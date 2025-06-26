---
layout: post
title: My Agentic testing Rules
date: 2025-06-26 15:55 +0000
---

As I work on my current project, I wanted to setup e2e testing as possible and make sure that the Agent don't introduce functionality or UI bugs while working on new features.

So I started intially prompting something like:

```
First, review the current tasks plan and make sure we will have a solid foundation to work with TDD, making sure every important featured developed is build using TDD and that the project also implements e2e testing for regression tests.
Use your criteria for choosing the tooling but make sure that we have as part of our fundational development workflow, a feedback loop that runs the app in a browser, so that we can take screenshots of what it's displayed on different formats to use for acceptance criteria.
```

You get the idea, I want to make sure that the AI don't introduce bugs so they're caught with  unit & regression testing, and also that the produced UI is accepted by the human in the loop before passing to the next tasks.

But I found that this approach wasn't doing it as I wanted, so I produced a Rules file for this, that I use as an auxiliary to my `generate-tasks.mdc` file for when I'm generating the taks I'm going to be working on:

```
---
description: Defines the comprehensive testing strategy the AI must implement and follow during web software development, ensuring quality, TDD, E2E coverage, and UI acceptance.
globs: # This rule set is foundational and applies conceptually to the start of projects or new major features.
alwaysApply: false # This set of rules should be explicitly invoked when initiating testing setup or reviewing/planning feature implementation.
---
# Rule: Implementing a Comprehensive Testing Strategy

## Goal

To ensure the AI establishes and adheres to a robust testing methodology throughout the development lifecycle. This strategy aims to:
1.  Embed Test-Driven Development (TDD) for all new functional code.
2.  Implement End-to-End (E2E) tests for critical user flows to prevent regressions.
3.  Establish a clear UI acceptance workflow using browser rendering and screenshots, involving human review.
4.  Promote the selection of appropriate testing tools and their integration into the development feedback loop.

## Key Testing Strategy Components

1.  **Foundational Setup (To be performed at project/feature inception):**
    *   **Tooling Selection:**
        *   The AI will propose a testing stack (e.g., Jest/Vitest for unit/integration, Playwright/Cypress for E2E).
        *   The choice should prioritize tools that integrate well, support the required types of testing, and can facilitate browser automation for screenshots.
        *   The AI must present its proposed tooling stack to the user for approval before proceeding with setup.
    *   **Environment Configuration:**
        *   Set up testing frameworks, assertion libraries, and mock/stubbing utilities.
        *   Configure test runners and scripts (e.g., in `package.json`).
        *   Ensure a dedicated test environment or configuration is available.
    *   **Browser Automation for UI Feedback:**
        *   Integrate a mechanism to run the application in a headless or controlled browser environment.
        *   Ensure capabilities for capturing screenshots of specific components or full pages across different viewport sizes (e.g., mobile, tablet, desktop).

2.  **Test-Driven Development (TDD) for Features:**
    *   For every new piece of functional logic (e.g., utility functions, component logic, API handlers):
        1.  **Write a Failing Test:** Before writing implementation code, create a unit or integration test that clearly defines the expected behavior and currently fails.
        2.  **Write Code to Pass:** Implement the minimal code necessary to make the test pass.
        3.  **Refactor:** Improve the code's structure and readability while ensuring all tests still pass.
    *   Unit tests should be co-located with the source code (e.g., `feature.ts` and `feature.test.ts`).

3.  **End-to-End (E2E) Testing for Regression:**
    *   Identify critical user flows (e.g., user login, core feature interaction, checkout process).
    *   Develop E2E tests that simulate these user journeys through the browser.
    *   These tests should verify that the application behaves correctly from the user's perspective.
    *   E2E tests should be run regularly, especially before releases or merging major features, to catch regressions.

4.  **UI Acceptance Workflow (Visual Regression & Feedback):**
    *   For any task involving UI changes or new UI components:
        1.  After initial development, the AI must render the relevant UI in a browser.
        2.  Capture screenshots of the UI in specified viewports (e.g., 375px, 768px, 1280px widths).
        3.  Present these screenshots to the user with the message: "UI for [Task/Component Name] is ready for review. Please see attached screenshots. Respond with 'Approved' or provide feedback."
        4.  The AI must wait for a user response.
        5.  If feedback is provided, the AI must address it and repeat steps 1-4.
        6.  Only after receiving "Approved" from the user can the UI-related task be considered complete for the visual acceptance part. Functional tests (TDD) should still pass.

## AI Workflow & Instructions

1.  **Initial Project/Feature Setup:**
    *   When starting a new project or a significant new feature set, the AI must first address the "Foundational Setup" component.
    *   **AI Action:** "I will now propose a testing stack for this project, focusing on TDD, E2E, and UI screenshot capabilities. My proposal is [AI's proposed stack and brief rationale]. Do you approve this stack? Respond 'Yes' to approve or provide alternatives."
    *   Await user approval before configuring tools.

2.  **During Task Implementation (referencing `process-task-list.md`):**
    *   **For functional sub-tasks:** Apply the TDD cycle. Tests must be written and pass before a sub-task related to new logic is marked `[x]`.
    *   **For UI sub-tasks:** After implementing the UI and ensuring related functional tests pass, initiate the "UI Acceptance Workflow". The sub-task can only be fully marked `[x]` after user approval of screenshots.
    *   **Test Execution:** All relevant unit and integration tests should be run and pass before a parent task (as per `process-task-list.md`) is committed. E2E tests should be run for significant feature completions.

3.  **Documentation:**
    *   The AI should ensure that a `TESTING.md` file is created or updated in the repository, outlining:
        *   The chosen testing tools and versions.
        *   Instructions on how to run unit, integration, and E2E tests.
        *   Brief explanation of the testing strategy in place.

4.  **Maintenance:**
    *   As new critical paths are developed, the AI should proactively suggest or create new E2E tests.
    *   Ensure test suites are kept up-to-date with code changes.

## Expected Deliverables / Artifacts from this Strategy

-   Configured testing frameworks and environments.
-   Unit and integration test files (e.g., `*.test.ts`, `*.spec.ts`).
-   E2E test suites/files.
-   Scripts to run different types of tests.
-   Screenshots for UI acceptance stages.
-   A `TESTING.md` file in the project repository.

```

And this worked really well.

Happy value creation my friends!

Julian