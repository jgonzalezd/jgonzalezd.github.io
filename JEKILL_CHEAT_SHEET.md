# Jekyll Cheat Sheet

A quick reference for Jekyll commands, conventions, and Liquid templating.

## Basic Commands

| Command | Description |
|---|---|
| `jekyll new SITENAME` | Creates a new Jekyll site in a directory called `SITENAME`. |
| `bundle exec jekyll serve` | Builds the site and serves it locally at `http://localhost:4000`. |
| `bundle exec jekyll serve --livereload` | Serves the site locally and reloads on changes. |
| `bundle exec jekyll serve --drafts` | Serves the site locally including posts in `_drafts` folder. |
| `bundle exec jekyll build` | Builds the site into the `_site` directory. |
| `bundle install` | Installs the gems specified in your `Gemfile`. |
| `bundle update` | Updates all gems in your `Gemfile`. |

## Directory Structure

| Directory / File | Purpose |
|---|---|
| `_config.yml` | Main configuration file. |
| `_posts` | Blog posts. Filename format: `YYYY-MM-DD-title.md`. |
| `_drafts` | Unpublished posts. |
| `_site` | The generated site. Don't edit this directly. |
| `_includes` | Reusable snippets of HTML. |
| `_layouts` | Template files for pages and posts. |
| `_data` | YAML, JSON, or CSV data files. |
| `assets` | CSS, JS, images, and other static files. |
| `pages` or root | Static pages like "About" or "Contact". |
| `Gemfile` | Ruby gem dependencies. |

## Creating Posts

1.  **Create a file** in the `_posts` directory.
2.  **Name the file** using the `YYYY-MM-DD-title.md` format.
3.  **Add Front Matter** and content to the file.

```markdown
---
layout: post
title: "My Awesome Post"
date: 2023-10-27 10:00:00 -0500
categories: jekyll update
author: "John Doe"
tags: [tag1, tag2]
---

Your post content starts here...
```

## Drafts

To work on a post without publishing it, you can create a draft.

1.  Create a file in the `_drafts` directory (no date in the filename needed).
2.  To preview your site with drafts, use `bundle exec jekyll serve --drafts`.
3.  When ready to publish, move the file to the `_posts` directory and add the date to the filename.

## Excerpts

Jekyll automatically takes the first paragraph of a post as its excerpt. You can customize this by setting `excerpt_separator` in `_config.yml` or in a post's Front Matter.

**_config.yml:**
```yaml
excerpt_separator: <!--more-->
```

**In your post:**
```markdown
This is the excerpt.
<!--more-->
This is the rest of the content.
```

## Front Matter

YAML block at the top of a file to set variables.

```yaml
---
layout: post
title: "My Awesome Post"
date: 2023-10-27 10:00:00 -0500
categories: jekyll update
author: "John Doe"
tags: [tag1, tag2]
custom_variable: "any value"
---
```

## Liquid Templating

### Objects

Access variables from Front Matter and `_config.yml`.

- `{{ site.title }}`: Site title from `_config.yml`.
- `{{ page.title }}`: Title of the current page/post.
- `{{ content }}`: The rendered content of a page/post.

### Tags (Logic)

- **Conditionals**:
  ```liquid
  {% if page.title == "Home" %}
    <h1>Welcome Home!</h1>
  {% else %}
    <h1>{{ page.title }}</h1>
  {% endif %}
  ```

- **Loops**:
  ```liquid
  <ul>
    {% for post in site.posts %}
      <li><a href="{{ post.url }}">{{ post.title }}</a></li>
    {% endfor %}
  </ul>
  ```

### Filters (Output manipulation)

- `{{ "hello" | capitalize }}` -> `Hello`
- `{{ page.date | date: "%B %d, %Y" }}` -> `October 27, 2023`
- `{{ site.posts | size }}` -> Number of posts.
- `{{ post.content | number_of_words }}` -> Word count.
- `{{ post.excerpt | strip_html }}` -> Remove HTML tags from post excerpt.

### Post-specific Variables

- `{{ post.url }}`: The URL of the post.
- `{{ post.date }}`: The date of the post.
- `{{ post.categories }}`: List of categories for the post.
- `{{ post.tags }}`: List of tags for the post.
- `{{ post.author }}`: The author of the post.
- `{{ post.excerpt }}`: The post excerpt.

## Includes

Include a file from the `_includes` directory.

```liquid
{% include header.html %}
{% include sidebar.html position="left" %}
```
Inside `_includes/sidebar.html`, you can access `include.position`.

## Data Files

Access data from `_data` directory.
`_data/members.yml`:
```yaml
- name: "John Doe"
  github: "johndoe"
- name: "Jane Smith"
  github: "janesmith"
```

Use it in your templates:
```liquid
<ul>
  {% for member in site.data.members %}
    <li>{{ member.name }} - {{ member.github }}</li>
  {% endfor %}
</ul>
```

## Permalinks

Customize URLs in `_config.yml`:

- `permalink: pretty` -> `/categories/post-title/`
- `permalink: /:categories/:year/:month/:day/:title.html`
- `permalink: /blog/:title/`

Or in a post's Front Matter:
`permalink: /my-custom-url/`

## Collections

Define custom document types in `_config.yml`.

```yaml
collections:
  my_collection:
    output: true
    permalink: /:collection/:name
```

Create a `_my_collection` directory and add documents. Access them via `site.my_collection`.

## Assets

Link to assets relative to the root.

- `[My Image]({{ "/assets/images/my-image.jpg" | relative_url }})`
- `<link rel="stylesheet" href="{{ "/assets/css/main.css" | relative_url }}">`
- `![My Image Text](/assets/images/my-image.jpg)`

The `relative_url` filter is useful for hosting on subpaths. For assets inside posts, you can use markdown syntax directly.

## Plugins & Themes

Add gems to your `Gemfile` and `_config.yml`.

**Gemfile**:
```ruby
gem "jekyll-feed"
gem "jekyll-seo-tag"
```

**_config.yml**:
```yaml
plugins:
  - jekyll-feed
  - jekyll-seo-tag
```

For themes:
**Gemfile**: `gem "minima"`
**_config.yml**: `theme: minima`
