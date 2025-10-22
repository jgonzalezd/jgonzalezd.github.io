---
layout: post
title: Making markdown display the triple backticks
date: 2025-06-26 17:45 +0000
categories: [Software Craft, Technical Tips]
tags: [markdown]
---

This is a tricky one and I spend a lot of time fiddling with this. And, Grok failed miserably at helping, however Gemini 2.5 Pro nailed perfectly:

The issue:

You want to display markdown... from a Mardown file. So when you put a code block it breaks:

Example: On this screenshot everything should be under the triple backticks but it spils over.

![Markdown template example](/assets/img/2025-06-26-making-markdown-display-the-triple-backticks/markdown-triple-ticks-issue-ex.png){: width="750" }


Enter... Indentation


So In order to render the backticks without braking the markdown like this:

![Fixed markdown rendered](/assets/img/2025-06-26-making-markdown-display-the-triple-backticks/issue-fixed.png){: width="750" }

You need to use indentation:

![Souce Markdown](/assets/img/2025-06-26-making-markdown-display-the-triple-backticks/issue-fixed-source.png){: width="750" }

Happy building friends,

Julian