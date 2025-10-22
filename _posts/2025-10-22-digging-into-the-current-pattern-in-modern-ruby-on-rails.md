---
layout: post
title: Digging into the `Current` pattern in modern Ruby on Rails
date: 2025-10-22 15:18 +0000
---

I was digging into a modern Rails codebase recently and saw this `Current` object being used everywhere. It felt like a global variable, which usually sets off alarm bells for me. You’d see `Current.user` pop up in a model, a service object, or a mailer, with no clear indication of where it came from. I decided to properly investigate how it works, why it exists, and whether it’s a brilliant convenience or something to be cautios of.

**tldr;** `Current` is a glorified, thread-safe global hash for request-specific data. It's an intentional design choice by Rails to solve the pain of passing data like `user` or `ip_address` through every method call, trading explicit dependencies for major convenience.

## The Problem: Passing State Everywhere

Before we get to the solution, let's appreciate the problem. In any web application, you have a bunch of data that is unique to a single request but needed in many places. The classic example is the currently logged-in user.

You start by having `current_user` in your controller. But soon, a service object needs it. So you pass it in: `MyService.new(user: current_user).call`. Then that service calls a model method that needs to know who is making the change, so you pass it again: `some_record.update_with_auditing(attributes, user: current_user)`. Then a mailer needs it. This "prop-drilling" gets old, fast. It clutters method signatures with context that isn't core to the business logic.

## The Deep Dive: `ActiveSupport::CurrentAttributes`

This is where the `Current` object comes in. It's a pattern built on top of a specific Rails class, `ActiveSupport::CurrentAttributes`.

### The `Current` Pattern (A Pragmantic Tool for a Specific Job)

The implementation is usually deceptively simple, like the one in the prompt:

```ruby
# app/models/current.rb
class Current < ActiveSupport::CurrentAttributes
  attribute :session
  attribute :user_agent, :ip_address

  delegate :user, to: :session, allow_nil: true
end
```

Then, in a controller `before_action`, you set it up:

```ruby
# app/controllers/application_controller.rb
class ApplicationController < ActionController::Base
  before_action :set_current

  private
    def set_current
      Current.session = Session.find_by(id: session[:session_id])
      Current.user_agent = request.user_agent
      Current.ip_address = request.ip
    end
end
```

From this point on, for the entire lifecycle of that single request, you can call `Current.user`, `Current.ip_address`, etc., from literally anywhere in your synchronous code path—models, views, services, mailers—and it will just work.

### How It Actually Works (It's Just a Fancy, Thread-Local Singleton)

![](../assets/img/2025-10-22-digging-into-the-current-pattern-in-modern-ruby-on-rails/meme1.png){: width="250" }

So I dug a little deeper. This isn't a true global variable. If it were, you'd have a catastrophic race condition on any multi-threaded web server like Puma. Request A's user would overwrite Request B's user, and chaos would ensue.

The key is that `ActiveSupport::CurrentAttributes` uses **thread-local storage**. As far as I can tell, it essentially boils down to storing its instance in `Thread.current`. Since modern web servers like Puma handle each request in a separate thread, `Current` is effectively a singleton *per request*. Request A, running on Thread A, gets its own `Current` object. Request B on Thread B gets a completely separate one. Neither can see or overwrite the other's data.

Crucially, Rails also adds middleware (`ActionDispatch::Executor`) that ensures these attributes are automatically cleared after each request is finished. This is the safety net. Without it, a thread could be re-used for a new request and accidentally pick up the old request's data. The automatic reset is what makes this pattern viable and not just a ticking time bomb.

### The Big Trade-Off (Feels a little risky, but worth the adrenaline)

So, is this a good pattern? It depends on who you ask.

The massive advantage is convenience. It cleans up your code by removing the need to pass request-level context everywhere. It follows the Rails philosophy of prioritizing developer ergonomics.

The disadvantage is that it creates an **implicit dependency**. When you look at a method like `Invoice.generate_for_company(company)`, you have no idea it might be secretly depending on `Current.user` under the hood. This can make code harder to reason about and, more importantly, harder to test. To test that method, you can't just call it; you first have to remember to stub the global state: `Current.user = some_user`.

This feels "wrong" to developers coming from environments that prize pure functions and explicit dependency injection. And they're not wrong to feel that way. It *is* a trade-off. You are trading purity and explicitness for convenience and less boilerplate.

## Final Thoughts

After digging in, my take is that the `Current` pattern is a pragmatic, well-designed solution for a common problem *within the context of a Rails application*. The built-in, thread-safe, and auto-clearing nature of `ActiveSupport::CurrentAttributes` tames most of the historical dangers of global state.

It's an opinionated pattern that leans into the "magic" of the framework. If you're building a Rails app, embracing it for request-scoped data is idiomatic and will likely make your life easier. Just be mindful of what it is: a controlled, request-scoped global that makes your methods less pure. Use it for its intended purpose, but don't treat it as a dumping ground for all application state. It’s a sharp tool, not a blunt instrument.