---
layout: post
title: 'From Tuples to Type-Safe Contracts: A Masterclass in the Open/Closed Principle'
date: 2025-09-04 16:00:13 UTC
categories:
- Software Craft
- Design Patterns
- AI Engineering
- Software Engineering
tags:
- ai-pair-programming
- dataclasses
- open-closed-principle
- python
- refactoring
comments: true
toc: true
---

I've been pair-programming with an AI assistant a lot lately, and while it's great for raw productivity, the most valuable moments are the ones that send me down a rabbit hole of learning. The other day, while exploring the internals of Clerk's Python library, I stumbled upon a piece of code that was elegant but also felt... incomplete. My journey to understand it, guided by my AI partner, turned into a masterclass on a fundamental software design principle.

It all started with this custom exception class:

```python
class TokenVerificationError(Exception):
    """Exception raised when token verification fails"""

    def __init__(self, reason: TokenVerificationErrorReason):
        self.reason = reason
        super().__init__(self.reason.value[1])
```

Simple enough. But the magic was in the `TokenVerificationErrorReason` enum.

## The Anatomy of My Curiosity

The `reason` object wasn't just a simple string; it was an `Enum` where each member was a tuple containing a machine-readable code and a human-readable message.

```python
class TokenVerificationErrorReason(Enum):
    JWK_FAILED_TO_LOAD = (
        'jwk-failed-to-load',
        'Failed to load JWKS from Clerk Backend API...'
    )

    TOKEN_EXPIRED = (
        'token-expired',
        'Token has expired and is no longer valid.'
    )
    # ... and so on
```

This pattern is clever. It centralizes error definitions and provides both a stable code for programmatic checks and a clear message for logging. But I couldn't shake the feeling that using tuple indices like `self.reason.value[1]` was a code smell. It felt brittle. What if someone accidentally swapped the order in the tuple? What if we needed to add more metadata, like an HTTP status code or a flag indicating if the error is retryable? The tuple would become an unmanageable grab-bag of data.

## The Turning Point: An Insight from the Agent

I posed this to my AI assistant. "This is a great implementation of the Open/Closed Principle," it told me.

And it was right.

The **Open/Closed Principle** states that software entities should be **open for extension** but **closed for modification**.

-   **Open for extension:** I could easily add new error reasons to the `Enum` without ever touching the `TokenVerificationError` class. The system could grow.
-   **Closed for modification:** The core logic of the exception class itself was stable and didn't need to be changed to accommodate new error types.

The agent's explanation crystallized why the pattern was so effective. But it also validated my unease about the tuples. The agent confirmed that while the principle was correctly applied, the implementation could be made more robust, readable, and extensible. The key? **Dataclasses**.

## My Solution: Building a Better, Type-Safe Contract

Following the agent's lead, I decided to refactor this pattern. The goal was to keep the Open/Closed characteristic while eliminating the brittleness of tuples.

First, I defined a `dataclass` to act as a structured container for the error metadata. This would be our new "contract."

```python
from dataclasses import dataclass, field
from typing import Optional, List

@dataclass(frozen=True)  # frozen=True makes instances immutable
class ErrorMetadata:
    """A structured contract for our error reasons."""
    code: str
    message: str
    http_status_code: int = 400
    retryable: bool = False
    category: str = "validation"
    tags: List[str] = field(default_factory=list)
```

This is a massive improvement over a tuple.
1.  **Self-Documenting:** The fields are named (`code`, `message`, etc.). No more guessing what `value[1]` means.
2.  **Type-Safe:** Each field has a type hint, which mypy and my IDE can use to catch errors.
3.  **Defaults:** I can provide sensible defaults (`http_status_code=400`, `retryable=False`).
4.  **Immutability:** `frozen=True` prevents the metadata from being accidentally changed at runtime.

With this new data structure in place, I refactored the `Enum`. Instead of tuples, each member is now an instance of our `