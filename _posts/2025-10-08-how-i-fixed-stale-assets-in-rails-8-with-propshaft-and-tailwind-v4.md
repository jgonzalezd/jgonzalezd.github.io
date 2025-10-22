---
layout: post
description: "A deep dive into solving Propshaft asset cache invalidation issues when using Tailwind CSS v4 with external build tools. Learn why assets weren't updating and how to implement the proper architectural solution."
date: "2025-10-08"
tags: ["ruby-on-rails", "propshaft", "tailwind-css", "asset-pipeline", "cache-invalidation"]
---

As a developer working with Rails 8 and the modern Propshaft asset pipeline, I recently encountered a frustrating issue that had me scratching my head for hours. I was using Tailwind CSS v4 with its external CLI build process, but my CSS changes weren't being reflected in the browser, even after restarting the development server. The asset fingerprints were staying the same, and I was getting stale CSS served to my browser.

Let me walk you through the problem I faced, the root cause I discovered, and the solution I implemented.

## The Problem: Stale Assets Despite File Changes

I had set up a Rails 8 application with the Propshaft asset pipeline and Tailwind CSS v4. My development workflow was straightforward:

1. I made changes to my component files (like `app/components/user_details_component.html.erb`)
2. Tailwind's watch mode detected these changes and rebuilt the CSS file
3. I refreshed my browser expecting to see the new styles

But here's what was actually happening:

`app/components/user_details_component.html.erb`
```erb
<div data-controller="user-details-component" class="animate-flash-increase text-red-500">
    <%= @user.name %> (<%= @user.email %>)
</div>
```

I had defined a custom animation in my Tailwind source:

`app/assets/tailwind/application.css`
```css
@import "tailwindcss";

@source "../../components/**/*.{rb,erb,html,js}";

@theme {
  --animate-flash-increase: flash-increase 0.5s ease-out;
}

@keyframes flash-increase {
  0% {
    opacity: 0;
    transform: scale(0.95);
  }
  50% {
    opacity: 1;
    transform: scale(1.02);
  }
  100% {
    opacity: 1;
    transform: scale(1);
  }
}
```

The browser was serving `tailwind-71c00b9f.css` with the old fingerprint, but when I checked the actual file at `app/assets/builds/tailwind.css`, it contained the correct classes:

```css
/* Generated CSS contained */
.text-red-500 {
  color: var(--color-red-500);
}

.animate-flash-increase {
  animation: var(--animate-flash-increase);
}

@keyframes flash-increase {
  0% { opacity: 0; transform: scale(0.95); }
  50% { opacity: 1; transform: scale(1.02); }
  100% { opacity: 1; transform: scale(1); }
}
```

No matter how many times I restarted the development server or cleared my browser cache, the stale fingerprint persisted.

## The Architectural View: Propshaft's Caching Mechanism

To understand why this was happening, I needed to dig into how Propshaft works internally. Propshaft is Rails 8's modern asset pipeline that replaced Sprockets. It calculates SHA1 fingerprints of asset files and serves them with these fingerprints for cache busting.

The issue was in the interaction between two systems:

1. **Tailwind CLI**: An external process that watches for file changes and rebuilds CSS
2. **Propshaft**: Rails' asset pipeline that serves files with fingerprints

Here's what was happening at the architectural level:

```
Tailwind CLI → Builds app/assets/builds/tailwind.css → File system
                                                      ↓
Rails/Propshaft → Reads at boot → Calculates fingerprint → Caches it
                                                      ↓
                                             Next request → Uses cached fingerprint
```

When I made changes to my component files, Tailwind correctly detected the changes and rebuilt the CSS file. However, Propshaft had already cached the fingerprint during Rails boot and never checked if the underlying file had changed.

This is actually the intended behavior for performance reasons - Propshaft assumes that if a file's content changes, Rails itself will be restarted. But when using external build tools like Tailwind CLI, this assumption breaks down.

## The Debugging: Finding the Missing Piece

I initially tried several workarounds:

1. **Manual cache clearing**: Adding `rm -rf tmp/cache/*` to my `bin/dev` script
2. **Browser cache clearing**: Hard refreshes with Ctrl+Shift+R
3. **Server restarts**: Killing and restarting the development server

While the manual cache clearing worked, it felt like a hack. I wanted to understand why Propshaft wasn't automatically detecting these changes when it was designed to do exactly that.

Digging into Propshaft's source code, I discovered that it has a built-in cache sweeping mechanism that's enabled by default in development:

```ruby
# In config/environments/development.rb
config.assets.sweep_cache = true
```

And it runs a cache sweeper before each controller action:

```ruby
# In Propshaft's Railtie
ActiveSupport.on_load(:action_controller_base) do
  before_action { Rails.application.assets.load_path.cache_sweeper.execute_if_updated }
end
```

This should have been detecting my file changes, but it wasn't working. Let me show you why.

## The Root Cause: Missing `listen` Gem

The issue was that Propshaft's cache sweeper requires the `listen` gem to actually watch for file changes. Without it, Propshaft falls back to a `NullFileWatcher` that never detects changes.

However, there's another prerequisite: the `listen` gem itself requires the `watchman` utility to be installed on your operating system for optimal file watching performance.

Looking at the Propshaft source code, I found this in `lib/propshaft/load_path.rb`:

```ruby
def cache_sweeper
  @cache_sweeper ||= begin
    # ... file watching setup ...
    @file_watcher.new([], files_to_watch) do
      # ... clear cache when files change ...
    end
  end
end
```

The `file_watcher` defaults to `NullFileWatcher` if the `listen` gem isn't available:

```ruby
class NullFileWatcher
  def initialize(paths, files_to_watch, &block)
    @block = block
  end

  def execute_if_updated
    @block.call  # Never actually checks for changes!
  end
end
```

This explained everything! Propshaft was calling the cache sweeper before each request, but the `NullFileWatcher` was just executing the callback without actually checking for file changes.

## The Solution: Installing the Listen Gem

The fix involved two steps:

**Step 1: Install the `watchman` utility** (required for the `listen` gem to work optimally):

```bash
# On Ubuntu/Debian
sudo apt-get install watchman

# On macOS
brew install watchman

# On other systems, follow: https://facebook.github.io/watchman/docs/install
```

**Step 2: Add the `listen` gem** to enable proper file watching:

`Gemfile`
```ruby
group :development do
  # Use console on exceptions pages
  gem "web-console"

  # Listen to file modifications
  # Required for Propshaft to detect asset changes from external build tools
  gem "listen", "~> 3.9"
end
```

After installing both the system utility and the gem with `bundle install`, I removed my manual cache clearing workaround from `bin/dev`:

`bin/dev`
```ruby
#!/usr/bin/env sh

if ! gem list foreman -i --silent; then
  echo "Installing foreman..."
  gem install foreman
fi

# Default to port 3000 if not specified
export PORT="${PORT:-3000}"

# Let the debug gem allow remote connections
export RUBY_DEBUG_OPEN="true"
export RUBY_DEBUG_LAZY="true"

# Clear Rails tmp cache to ensure fresh asset fingerprints
# echo "Clearing Rails cache..."
# rm -rf tmp/cache/*

exec foreman start -f Procfile.dev "$@"
```

## How It Works: The Complete Flow

Now the complete flow works as intended:

1. **Tailwind watches** component files and rebuilds CSS when they change
2. **Propshaft's cache sweeper** (powered by Listen) detects the CSS file change
3. **Before each request**, Propshaft clears its cache and recalculates fingerprints
4. **Fresh fingerprints** are served to the browser

```erb
<!-- Browser now gets the correct fingerprint -->
<link rel="stylesheet" href="/assets/tailwind-2f1a241d.css" data-turbo-track="reload" />
```

## Verification: Testing the Solution

To verify the solution worked, I made a change to my component:

`app/components/user_details_component.html.erb`
```erb
<div data-controller="user-details-component" class="animate-flash-increase text-red-500">
    <%= @user.name %> (<%= @user.email %>)
</div>
```

After saving, I could see:
- Tailwind rebuilt the CSS file (file modification time changed)
- The browser request triggered Propshaft's cache sweep
- A new fingerprint was generated (`tailwind-2f1a241d.css`)
- The browser received the updated CSS with the correct styles

## Key Takeaways

- **Propshaft's cache sweeping requires both the `listen` gem AND the `watchman` utility** in development to actually detect file changes from external build tools
- **The `NullFileWatcher` fallback never checks for changes** - it's just a no-op that Propshaft uses when `listen` isn't available
- **Install `watchman` first** (`sudo apt-get install watchman` on Ubuntu/Debian, `brew install watchman` on macOS) as it's a prerequisite for the `listen` gem
- **This is the intended architectural pattern** for integrating external build tools with Rails' asset pipeline
- **No workarounds needed** - this leverages Rails' built-in mechanism properly

This solution ensures that any external build tool (Tailwind, Vite, esbuild, etc.) that modifies files in Rails' asset directories will trigger proper cache invalidation without requiring server restarts.

The key insight was understanding that Propshaft already had the right architecture - it just needed the right dependencies (`watchman` + `listen` gem) to function as designed.
