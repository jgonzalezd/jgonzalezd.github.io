---
layout: post
title: I built an X-to-Obsidian button (and it quietly fixed my AI notes)
date: 2026-03-31 16:00 +0000
categories:
  - Developer Tools
  - Personal Knowledge Management
tags:
  - obsidian
  - markdown
  - ai
  - browser-extension
  - x
---

I quite often find good stuff on X that I want to use for inspiration for content ideas or improving my internal processes; sometimes it's just a piece of the article, sometimes is the general idea, but when I was copying and pasting from X into my obsidian I had to do repetitive markdown fomatting I felt a really bad taste in my mouth about my precious time being wasted. 

So I built a tiny Chrome/Brave extension that does one blunt, practical thing: it converts an X.com article into an Obsidian-friendly Markdown file. One click, a clean `.md`, ready to drop into a vault.

If you want to use it yourself, everything is in the open: [github.com/jgonzalezd/x-article-2-obsidian-md](https://github.com/jgonzalezd/x-article-2-obsidian-md) (clone or download, then load unpacked in Chrome or Brave—the README walks through it).

![Extension popup on an X article](/assets/img/2026-03-31-x-to-obsidian/extension-popup.png){: width="750" }

When the file lands in the vault, it keeps the stuff that makes knowledge bases useful: metadata you can query later. Title. Author. Date. Source. Tags. The boring scaffolding that turns a pile of text into something you can work with.

![Obsidian note with properties and source link](/assets/img/2026-03-31-x-to-obsidian/obsidian-properties.png){: width="250" }

And yes, it preserves the body in readable Markdown, the images are linked automatically in the original places.

![Converted article content example](/assets/img/2026-03-31-x-to-obsidian/converted-article.png){: width="250" }

If you're a heavy Obsidian user, you'll appreciate this extension and use it almost daily. **Repo:** [jgonzalezd/x-article-2-obsidian-md](https://github.com/jgonzalezd/x-article-2-obsidian-md).

