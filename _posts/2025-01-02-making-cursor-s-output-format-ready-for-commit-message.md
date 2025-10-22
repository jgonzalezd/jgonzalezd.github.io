---
layout: post
title: Making Cursor's Output format ready for commit message
date: 2025-06-26 17:12 +0000
categories:
- AI Engineering
- Workflows
- Software Engineering
- Developer Tools
tags:
- automation
- cursor
- developer-experience
- e2e
- git
- tdd
- testing
---

When the agent finishes it's current task and after I review it, I like to use its output as the commit message to summarize what's been done in that commit. 

Cursor's agent provides and amazing summary of what it just did, I love it and I love how it uses colorful icons, it makes it easier and delighful to read instad of a bunch of characters.

However the format needs to be improved so I can copy and paste it on the commit message.

For example, One of the improvement  summary contains double quotes and when I paste it into the terminal as the `-m` param for git commit it breaks, also the commit message ends up without separation lines and all gets together like this:

```
commit a912227f41ad724491002589277fbe7156727e10 (HEAD -> main)
Author: Julian Gonzalez <julian@reliable-coding.com>
Date:   Thu Jun 26 16:38:28 2025 +0000

    ✅ Comprehensive Testing Strategy Implementation Complete
    I have successfully enhanced our project with a comprehensive testing framework that implements:
    🧪 Testing Stack Implemented:
    Vitest: Modern, fast test runner for both frontend and backend
    React Testing Library: Component testing focused on user interactions
    Playwright: Cross-browser E2E testing with screenshot capabilities
    MSW: Reliable API mocking for development and testing
    Supertest: HTTP assertion library for API endpoint testing
    📋 Enhanced Task Plans:
    Task Group 1 (Infrastructure): Enhanced Task 1.8 with 10 comprehensive subtasks covering:
    TDD workflow implementation
    E2E testing setup with Playwright
    UI acceptance workflow with automated screenshots
    MSW integration for reliable API mocking
    Comprehensive test documentation
    Task Groups 2-5: Updated all testing tasks to include:
    TDD markers: Clear identification of Test-Driven Development requirements
    E2E markers: End-to-end testing for critical user flows
    UI Acceptance markers: Screenshot capture and approval workflow
    📁 Files Created:
    TESTING.md - Comprehensive testing strategy documentation
    web/vitest.config.ts - Frontend test configuration
    api/vitest.config.ts - Backend test configuration
    web/playwright.config.ts - E2E testing and UI acceptance configuration
    Updated package.json scripts for both frontend and backend
    🔄 Workflow Integration:
    TDD Cycle: Red → Green → Refactor for all new functionality
    E2E Testing: Critical user flows identified and planned
    UI Acceptance: Mandatory screenshot approval for UI changes
    Quality Gates: 80% coverage thresholds and comprehensive validation
```

I fixed this issue and optimized the output for being the message of the git commit I manually do and I want to keep it doing manually; with a Cursor rule:

`.cursor/rules/summary-formatting.mdc`
```markdown
# Rule: Automatic Git-Commit Friendly Summary Formatting

## Goal

To ensure all AI assistant task completion summaries are automatically formatted for direct use in git commit messages, maintaining visual appeal with emojis while avoiding shell compatibility issues.

## Process

1. **Auto-Apply Format:** Every task completion summary MUST automatically use the git-commit friendly format without being asked
2. **Quote Management:** Never use double quotes that break `git commit -m "message"` commands
3. **Structure Consistency:** Follow the established template with proper line breaks and emoji headers
4. **Shell Compatibility:** Ensure the output can be directly copied into terminal git commands

## Format Requirements (AUTOMATIC)

### Critical Rules:
- ❌ **NEVER use double quotes** - breaks `git commit -m "message"`
- ✅ **Use single quotes** or rephrase to avoid quotes entirely
- ✅ **Include proper line breaks** between sections
- ✅ **Use emoji section headers** for visual appeal
- ✅ **Use dash bullet points** (- Item description)

### Line Structure:
- **First line**: Clear, concise summary (50-72 characters ideal)
- **Blank line**: Separate summary from detailed breakdown
- **Body**: Detailed breakdown with proper spacing between sections

### Section Headers:
- **Use emoji + text**: `🧪 Testing Stack Implemented:`
- **Follow with blank line** before list items
- **Keep headers short** and descriptive

## Mandatory Template Structure
    ```
    ✅ [Clear Achievement Summary]

    [Brief description of accomplishment]

    🎯 [Section Title]:
    - Item without quotes
    - Enhanced feature description
    - Implementation details

    📋 [Another Section]:
    - Task completion details
    - Process improvements
    - System enhancements

    📁 Files Created/Modified:
    - filename.ext - Purpose description
    - config.ts - Configuration setup

    🔄 Integration/Workflow:
    - Process improvements
    - Quality gates implemented
    - System enhancements
    ```

## Example Perfect Format
    ```
    ✅ Comprehensive Testing Strategy Implementation Complete

    Enhanced project with comprehensive testing framework:

    🧪 Testing Stack Implemented:
    - Vitest: Modern, fast test runner for frontend and backend
    - React Testing Library: Component testing focused on user interactions
    - Playwright: Cross-browser E2E testing with screenshot capabilities
    - MSW: Reliable API mocking for development and testing

    📋 Enhanced Task Plans:
    - Task Group 1: Enhanced with 10 comprehensive subtasks
    - TDD workflow implementation with clear markers
    - E2E testing setup with automated validation
    - UI acceptance workflow with screenshot capture

    📁 Files Created:
    - TESTING.md - Comprehensive testing strategy documentation
    - web/vitest.config.ts - Frontend test configuration
    - api/vitest.config.ts - Backend test configuration

    🔄 Workflow Integration:
    - TDD Cycle: Red → Green → Refactor methodology
    - E2E Testing: Critical user flows identified and planned
    - Quality Gates: 80% coverage thresholds implemented
    ```

## Shell Command Compatibility

The format MUST ensure compatibility with:

    ```bash
    git commit -m "✅ Your formatted summary here..."
    ```

## Success Criteria

- ✅ Summary copies directly into git commit without escaping
- ✅ No quote conflicts or shell errors
- ✅ Maintains visual appeal with emojis and structure
- ✅ Consistent formatting across all task completions
- ✅ Clean, readable git history

## Enforcement

This rule is **AUTOMATIC** - the AI assistant must apply this formatting to every task completion summary without being prompted. No exceptions.

## Target Audience

Developers who manually copy AI summaries into git commit messages and need them to work perfectly with shell commands while maintaining readability and visual appeal.
```

This works flawless, now when I finish reviewing I just ask the agent:

> ok, I finished the review, let's create a commit and using the output as the commit message. 

And this is the command it produced (for this specific task):

```
git commit -m "✅ Task 1.2.4 - Configure nodemon with TypeScript watching and automatic restart for developer momentum

Successfully implemented nodemon with optimized TypeScript watching for elite developer experience and zero-friction automatic restarts.

🎯 Successfully Implemented:
- Nodemon installation with full TypeScript support
- Comprehensive nodemon.json configuration with Outperformer-themed messaging
- Smart file watching that monitors TypeScript, JavaScript, and JSON files
- Intelligent ignore patterns excluding tests, builds, and dependencies
- Enhanced package.json scripts with multiple development options

⚙️ Configuration Features:
- File Watching: Monitors all source files in /src directory
- TypeScript Execution: Uses tsx for direct execution without compilation
- Developer Experience: 1-second restart delay and Outperformer console messages
- Debug Support: Configurable debug mode with --inspect flag
- Smart Ignoring: Excludes test files and build artifacts for efficiency

🚀 Enhanced Scripts:
- npm run dev - Primary nodemon-powered development server
- npm run dev:tsx - Backup tsx-based development fallback option
- npm run dev:debug - Debug mode with Node.js inspector

✅ Verified Functionality:
- Server starts correctly with nodemon configuration
- Automatic restart works seamlessly on file changes
- Health endpoint responds with peak performance message
- API versioning endpoint working correctly
- TypeScript compilation and execution functioning perfectly

📁 Files Created/Modified:
- api/nodemon.json - Comprehensive nodemon configuration
- api/package.json - Enhanced development scripts

🔄 Developer Momentum Features:
- Instant feedback on code changes with 1-second restart delay
- Clear console output with motivational Outperformer messaging
- Manual restart capability by typing rs command
- Legacy watch disabled for modern performance optimization
- Proper signal handling for clean development shutdowns

The backend development environment now provides zero-friction automatic restarts with elite performance optimization for maximum developer momentum."
```

Happy building friends,

Julian