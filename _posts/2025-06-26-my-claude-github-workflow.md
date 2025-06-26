---
layout: post
title: My Claude + Github Workflow
date: 2025-06-26 14:01 +0000
categories: [claude-code, ai-workflow]
---

## Leveling Up My Claude Code Workflow: It's All About the Cycle!

It's funny, right? We've got these incredibly powerful ROBOTS capable of spitting out code faster than I can type `git commit`, and yet, the wisdom from years of software development still holds true. Writing code is just one piece of the puzzle. The processes we built to manage software creation? Turns out they work darn well with our AI coding buddies.

My current setup is heavily inspired by GitHub Flow – a battle-tested approach perfect for small, agile teams. And let's be honest, a team of "me + AI" is pretty small and needs to be agile! So, what does this look like? It’s a cycle: **Plan, Create, Test, Deploy.**

### Phase 1: Plan Like You Mean It!

This is where I’ve found myself putting my "manager hat" back on, and surprisingly, I’m not mad about it. The more granular, specific, and atomic your planning, the better the ROBOTS perform.

1.  **GitHub Issues are King:** Everything starts as an issue. I mean *everything*. Initially, I might dump a bunch of ideas from a dictation session or a brainstorm with GPT-4o into a requirements doc, then have Claude Code break those down into initial issues. But then the real work begins: refining these issues. They need to be *tightly scoped*.
2.  **The Almighty Slash Command:** I’ve got a detailed `/process-issue` slash command in Claude Code. This isn't just a simple prompt; it's a multi-step instruction manual for the AI.

    ```markdown
    # Example /process-issue command (simplified)
    # Args: issue_number

    ## PLAN
    1. Use `gh issue view {{issue_number}}` to understand the task.
    2. Review project SCRATCHPAD directory for any related planning notes or previous attempts for this issue.
    3. Search previous PRs using `gh pr list --search "issue {{issue_number}}"` for context.
    4. **Think Harder**: Break down the issue into the smallest possible atomic tasks.
    5. Write a detailed plan in a new file: `SCRATCHPAD/{{issue_number}}-plan.md`. Include a link to the GitHub issue.

    ## CREATE CODE
    ... (instructions for coding)

    ## TEST
    ... (instructions for running tests, puppeteer)

    ## DEPLOY (Commit & PR)
    ... (instructions for committing with a clear message and opening a PR)
    ```
    The planning part is crucial. I have Claude use scratchpads – just a directory where it can dump its thoughts, plans, and breakdown of tasks. This helps it (and me) keep track of its "reasoning."

3.  **Novel Idea: The AI Pre-Mortem:** Before Claude Code even *starts* implementing an issue, I've started experimenting with a "pre-mortem" step using a strong reasoning model. I feed the finalized issue spec to something like Claude 3 Opus or GPT-4o and ask: *"Given this issue spec, what are 3-5 ways this could go disastrously wrong, lead to subtle bugs, or show a misunderstanding of the core requirement?"* The insights here are gold for refining the spec *one last time* before the ROBOT gets its digital hands dirty. It’s like an extra layer of defensive planning.

The more time I spend here, in the planning and spec-writing phase, the smoother everything else goes. It's less about me writing lines of code and more about me architecting the work. How much of your 'manager hat' are you willing to wear if it means shipping features faster and with fewer bugs? Is there a point where it stops feeling like *your* creation?

### Phase 2: Create (Let the ROBOT Cook!)

Once the plan is solid, it's time for Claude Code to do what it does best: write the code. My `/process-issue` command guides it through this, referencing the plan it just created.

Now, the big debate: who makes the commit? My friend Thomas Ptacek wrote a killer piece ("All of My AI Skeptic Friends Are Nuts") that really resonated with me. His point? You've *always* been responsible for what you merge to main. Whether an LLM wrote it or you did five years ago, read the damn code.

I’ve been letting Claude Code make the commits more often than not on my current project. It’s surprisingly good at writing commit messages. However, this only works if the next phase is locked down.

### Phase 3: Test, Test, and Test Again! (Seriously!)

This is non-negotiable. If you're going to let an AI write and commit code, you need a safety net woven from steel.

1.  **Robust Test Suite:** I'm a big Rails fan for projects needing user management, and its integrated testing framework is a lifesaver. Getting the test suite up and running *before* any significant feature development was priority zero. TDD, which I used to grumble about, is a godsend for AI. The ROBOTS *love* TDD. Have them write the test, then the code to make it pass. It’s a fantastic way to keep them on track and counter scope drift.
2.  **Puppeteer for UI:** For UI changes, having Claude Code use Puppeteer to click around in a browser and verify things is just *chef's kiss*. Watching it test its own visual work is both satisfying and incredibly useful for catching things simple unit tests might miss.
3.  **Continuous Integration (CI):** Every commit Claude makes triggers GitHub Actions. This runs the full test suite and a linter (Ruff is my current favorite). If the checks don't pass, the PR is blocked. No exceptions.
4.  **Pre-Commit Hooks are Your Best Friend:** This is a real game-changer. The ROBOTS *really* want to commit. By setting up pre-commit hooks (the `pre-commit` Python package is excellent for this), I can enforce linting, formatting, and even light test runs *before* the commit even happens locally.

    ```yaml
    # .pre-commit-config.yaml example
    repos:
    -   repo: https://github.com/pre-commit/pre-commit-hooks
        rev: v4.5.0
        hooks:
        -   id: check-yaml
        -   id: end-of-file-fixer
        -   id: trailing-whitespace
    -   repo: https://github.com/astral-sh/ruff-pre-commit
        rev: v0.4.1
        hooks:
        -   id: ruff
          args: [--fix, --exit-non-zero-on-fix]
        -   id: ruff-format
    ```
    This saves so much back-and-forth and keeps my GitHub Actions history cleaner because a lot of the silly mistakes get caught before they even hit the remote.

If the ROBOTS get *really* good at self-correction via robust testing and linting, how does that change your personal threshold for reviewing AI-generated commits? Would you ever trust it completely for certain types of changes?

### Phase 4: Deploy (aka PR and Merge)

Once the code is written and tests are passing (both locally and in CI after the push), Claude Code opens a Pull Request.

1.  **Human Review (Mostly Me):** This is my main checkpoint. I review the PR, look at the changes, and leave comments. Claude Code can then be instructed to read these comments and make revisions.
2.  **AI-Assisted PR Review:** Sometimes, I'll have *another* Claude Code instance (in a fresh shell, crucial for avoiding context pollution!) review the PR. I have a `/pr-review` command where I ask it to critique the code based on principles from software engineering best practice guides (think general concepts of clean, maintainable code, rather than adhering to a single specific person's style). It often catches things I'd miss, or that the original Claude Code instance missed in its "creative" phase.
3.  **Novel Idea: AI-Assisted Refactoring Sessions:** Taking the AI review a step further, I'm now blocking out time for dedicated "refactoring sessions." I'll feed larger, existing modules to Claude Code with a command like `/refactor-module --style=SOLID --target-complexity=low --language=ruby`. Then I review its suggestions. It’s a proactive way to combat technical debt and improve code quality across the board, not just on new changes.

Once I'm happy and CI is green, I hit that merge button. On services like Render (which I use a lot), merging to `main` automatically deploys. Sweet.

### Rinse and Repeat: The `/clear` Command

After a PR is merged, I go back to my Claude Code console and run `/clear`. This wipes the context window clean. Each issue should be self-contained enough for Claude Code to tackle it from a cold start, relying on the info in the issue, its scratchpad plans, and its ability to review past PRs. This keeps the AI focused and helps manage token usage.

### What About Claude in GitHub Actions & Work Trees?

Anthropic launched Claude integration directly in GitHub Actions. It's cool, but for now, I'm sticking to the console. The GitHub Actions usage hits my API bill even with a Max plan, and honestly, I feel I get better control and results in the `claude` CLI. For super small fixes, maybe GitHub Actions makes sense, but for beefy work, the console is my home.

Work trees? The idea of running multiple Claude instances in parallel on different branches is tempting – like multi-tabling poker. But for my current project, much of the work is iterative and sequential. I also found the permissions re-approval dance for each new work tree a bit clunky. For now, a single, focused Claude Code instance is working great.

### Final Thoughts

This iterative cycle of Plan, Create, Test, and Deploy, supercharged with AI, has dramatically changed how I build software. I spend more time on high-level design and specification, and the ROBOTS handle a lot of the meticulous implementation and initial testing.

We're setting up these elaborate workflows for the AI, but what parts of *our own* human workflow could we optimize or even automate away to better complement our AI partners? It’s an exciting time to be a developer, that’s for sure!

Let me know your own workflows and how you're wrangling these ROBOTS! It’s always fun to compare notes.

---
*This post was written 95% by a human, with AI assisting in remembering all the steps I actually take.*
