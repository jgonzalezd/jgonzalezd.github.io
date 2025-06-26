# Chirpy Starter

[![Gem Version](https://img.shields.io/gem/v/jekyll-theme-chirpy)][gem]&nbsp;
[![GitHub license](https://img.shields.io/github/license/cotes2020/chirpy-starter.svg?color=blue)][mit]

When installing the [**Chirpy**][chirpy] theme through [RubyGems.org][gem], Jekyll can only read files in the folders
`_data`, `_layouts`, `_includes`, `_sass` and `assets`, as well as a small part of options of the `_config.yml` file
from the theme's gem. If you have ever installed this theme gem, you can use the command
`bundle info --path jekyll-theme-chirpy` to locate these files.

The Jekyll team claims that this is to leave the ball in the user’s court, but this also results in users not being
able to enjoy the out-of-the-box experience when using feature-rich themes.

To fully use all the features of **Chirpy**, you need to copy the other critical files from the theme's gem to your
Jekyll site. The following is a list of targets:

```shell
.
├── _config.yml
├── _plugins
├── _tabs
└── index.html
```

To save you time, and also in case you lose some files while copying, we extract those files/configurations of the
latest version of the **Chirpy** theme and the [CD][CD] workflow to here, so that you can start writing in minutes.

## Usage

Check out the [theme's docs](https://github.com/cotes2020/jekyll-theme-chirpy/wiki).

## Contributing

This repository is automatically updated with new releases from the theme repository. If you encounter any issues or want to contribute to its improvement, please visit the [theme repository][chirpy] to provide feedback.

## License

This work is published under [MIT][mit] License.

[gem]: https://rubygems.org/gems/jekyll-theme-chirpy
[chirpy]: https://github.com/cotes2020/jekyll-theme-chirpy/
[CD]: https://en.wikipedia.org/wiki/Continuous_deployment
[mit]: https://github.com/cotes2020/chirpy-starter/blob/master/LICENSE


Okay, here's how you can insert an image into a post using the Chirpy Jekyll theme, along with some best practices.

**1. Place Your Image in the Correct Directory**

*   The standard place for images and other assets in a Jekyll site, including those using the Chirpy theme, is the `/assets` folder.
*   It's a good practice to create a subdirectory within `/assets/img/` for your post's images to keep things organized. For example, if your post is named `my-awesome-post.md`, you could store its images in `/assets/img/my-awesome-post/`.
*   So, if you have an image named `my-image.jpg`, you would place it in `/assets/img/my-awesome-post/my-image.jpg`.

**2. Insert the Image Using Markdown**

The most common way to insert an image in a Markdown file is using the standard Markdown syntax:

```markdown
![Alt text for your image](/assets/img/my-awesome-post/my-image.jpg)
```

*   **`![Alt text for your image]`**: The alt text is important for accessibility and SEO. It describes the image for users who cannot see it.
*   **`(/assets/img/my-awesome-post/my-image.jpg)`**: This is the path to your image.
    *   It starts with a `/` to indicate that it's an absolute path from the root of your website.
    *   Jekyll will correctly process this path when it builds your site.

**Example:**

Let's say you have a post file `_posts/2025-06-26-my-new-adventure.md`.
You've placed an image `mountain-view.jpg` inside `assets/img/my-new-adventure/`.

In your `_posts/2025-06-26-my-new-adventure.md` file, you would write:

```markdown
---
title: My New Adventure
date: 2025-06-26 10:00:00 -0000
categories: [travel, photography]
tags: [mountains, nature]
---

Here is a beautiful view from my recent trip:

![View of a sunlit mountain range](/assets/img/my-new-adventure/mountain-view.jpg)

The hike was challenging but rewarding...
```

**3. Chirpy Theme Specific Image Features**

The Chirpy theme has some specific features and considerations for images:

*   **Preview Image (for post listings and social media):**
    *   You can specify a "preview image" or "hero image" for your post in the front matter. This image is often used on the homepage where posts are listed and when sharing the post on social media.
    *   The recommended resolution for this preview image is 1200 x 630 pixels to maintain an aspect ratio of 1.91:1. Images not meeting this ratio might be scaled and cropped.
    *   To set a preview image, add the `image` variable to your post's front matter:
        ```yaml
        ---
        title: My New Adventure
        date: 2025-06-26 10:00:00 -0000
        categories: [travel, photography]
        tags: [mountains, nature]
        image:
          path: /assets/img/my-new-adventure/mountain-view-preview.jpg
          alt: "A stunning mountain landscape"
        ---
        ```
    *   You can also specify `lqip` (Low Quality Image Placeholder) for preview images to improve perceived loading performance.

*   **Image Sizing and Positioning (Advanced):**
    *   The Chirpy theme documentation mentions options for image caption, size, position, and even dark/light mode variations for images within the post content.
    *   For dark/light mode specific images:
        ```markdown
        ![Light mode image](/path/to/light-mode.png){: .light }
        ![Dark mode image](/path/to/dark-mode.png){: .dark }
        ```
        This allows you to display different images based on the user's system theme.

*   **Favicons:** Favicons are a special type of image and have their own customization guide within the Chirpy documentation, typically placed in `assets/img/favicons/`.

**Important Considerations:**

*   **Relative vs. Absolute Paths:** Using an absolute path starting with `/` (e.g., `/assets/img/your-image.jpg`) is generally more reliable in Jekyll as it ensures the path is correct regardless of where the page is being viewed from.
*   **Base URL:** If you are hosting your Jekyll site in a subdirectory (e.g., `username.github.io/my-blog/`), you might need to prepend `{{ site.baseurl }}` to your image paths if you're not using a leading `/`. However, with paths starting with `/assets/...`, Jekyll usually handles this correctly. If you encounter issues, check your `_config.yml` for the `baseurl` setting.
*   **File Naming:** Keep your image filenames descriptive and use hyphens instead of spaces.
*   **Image Optimization:** For faster loading times, consider optimizing your images (compressing them without losing too much quality and using formats like WebP where appropriate). The Chirpy theme also supports LQIP (Low Quality Image Placeholders) which can enhance user experience during image loading.

By following these steps, you should be able to successfully insert images into your posts using the Chirpy Jekyll theme. Always refer to the official Chirpy theme documentation for the most up-to-date and detailed information.
