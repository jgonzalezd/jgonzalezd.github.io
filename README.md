# jgonzalez.dev Blog

Welcome to [jgonzalez.dev](https://jgonzalez.dev) — a blog by Julian Gonzalez focused on Software Engineering best practices, DevOps, agentic development,and entrepreneurship. Here you'll find deep dives into building with and without AI, lessons learned from real-world software projects and geek deep dives into technical challenges I find along the way.

---

## 📚 Blog Post Index

### 2025

- **2025-06-29**  
  [I Taught My AI Agent How to Stop Leaving Zombie Processes Everywhere](_posts/2025-06-29-my-battle-with-background-terminalson-cursor-how-i-finally-tamed-background-command-chaos.md)  
  *How to build a robust debugging workflow for AI agents, eliminate zombie processes, and empower agents to test servers autonomously.*

- **2025-06-28**  
  [My trick for creating System Prompts Fast (Meta-Prompting)](_posts/2025-06-28-my-trick-for-creating-system-prompts-fast.md)  
  *A step-by-step guide to meta-prompting: using AI to engineer better system prompts for building production-grade AI agents.*

- **2025-06-26**  
  [Making markdown display the triple backticks](_posts/2025-02-11-making-markdown-display-the-triple-backticks.md)  
  *A practical tip for rendering triple backticks in Markdown files, with screenshots and solutions.*

- **2025-06-26**  
  [Making Cursor's Output format ready for commit message](_posts/2025-01-02-making-cursor-s-output-format-ready-for-commit-message.md)  
  *How to format AI-generated summaries for direct use in git commit messages, with templates and shell compatibility tips.*

- **2025-06-26**  
  [My Agentic testing Rules](_posts/2025-03-18-my-agentic-testing-rules.md)  
  *A comprehensive rule set for AI-driven TDD, E2E, and UI acceptance testing in modern web projects.*

- **2025-06-26**  
  [My Claude + Github Workflow](_posts/2025-05-24-my-claude-github-workflow.md)  
  *A detailed breakdown of an AI-augmented GitHub workflow: planning, coding, testing, and deploying with Claude Code.*

### 2023

- **2023-11-21**  
  [Your brain needs a Firewall](_posts/2023-11-21-your-brain-needs-a-firewall.md)  
  *A philosophy post on mental focus, discipline, and building cognitive firewalls against distraction.*

---

## 📝 About

This blog is a living notebook of experiments, workflows, and lessons learned at the intersection of AI, software engineering, and productivity.  
You'll find:

- Real-world AI agent workflows and debugging strategies
- Prompt engineering and meta-prompting techniques
- Automated testing strategies for agentic development
- Productivity systems and philosophical approaches to focus

For more about the author, see [`_tabs/about.md`](_tabs/about.md) or the [portfolio](_tabs/portfolio.md).

---

## 📂 How to Use

- Browse posts via the [index above](#blog-post-index) or the [archives](_tabs/archives.md).
- Each post contains practical examples, code snippets, and actionable workflows.
- Source code and configuration for the blog are in this repository.

### 🤖 Auto-Taxonomy Feature

This blog includes an automated system for suggesting and applying tags and categories to posts based on content analysis:

#### Usage

1. **Run auto-taxonomy suggestions:**
   ```bash
   bundle exec rake auto:taxonomies
   ```

2. **What it does:**
   - Analyzes post content using NLP (TF-IDF, keyword extraction)
   - Suggests relevant tags and categories from a controlled vocabulary
   - Updates post front matter with normalized tags (kebab-case)
   - Maintains consistency across the site's taxonomy

3. **Configuration:**
   - Controlled vocabulary: `_data/taxonomy.yml`
   - Tag normalization: kebab-case (e.g., "Ruby on Rails" → "ruby-on-rails")
   - Categories: title-case for display
   - Maximum 5 tags per post

4. **Integration:**
   - Run before committing new posts
   - CI/CD can enforce taxonomy consistency
   - Works with existing Jekyll archives plugin

#### Dependencies

The auto-taxonomy feature requires these gems (already in Gemfile):
- `pragmatic_tokenizer` - Text tokenization
- `engtagger` - Part-of-speech tagging and keyword extraction
- `tf-idf-similarity` - Content similarity analysis
- `front_matter_parser` - YAML front matter parsing

---

## 📄 License

Content is published under the [MIT License](LICENSE).

---
