---
layout: post
title: 'Debugging Misaligned Text: How Template Literal Whitespace Breaks CSS Alignment'
date: 2025-11-06 18:08 +0000
---

I encountered a text alignment issue where content appeared indented despite explicit `text-align: left` declarations. My investigation revealed that the CSS `white-space` property interacts with whitespace sequences in JavaScript template literals in ways that are not immediately obvious. This post examines the execution mechanics of whitespace preservation across the CSS rendering pipeline and template literal evaluation.

**tldr;** The `white-space: pre-wrap` property preserves all whitespace sequences from JavaScript template literals, including formatting indentation, which then renders as visual spacing. Changing to `white-space: pre-line` collapses whitespace sequences while preserving line breaks, and inlining content in templates eliminates template-level whitespace entirely.

## Background: CSS white-space Property Behavior

The CSS `white-space` property controls how the rendering engine processes whitespace sequences in text content. The specification defines several values that determine whether whitespace characters are collapsed, preserved, or transformed during layout computation.

When the browser parses HTML and computes layout, it processes text nodes according to the `white-space` value applied to their containing element. This processing occurs after template literal evaluation in JavaScript, meaning any whitespace present in the template string becomes part of the DOM text node content before CSS processing begins.

The distinction that needs to be made:
- **Whitespace sequences**: Multiple consecutive space, tab, or newline characters
- **Line breaks**: Single newline characters that separate lines

Different `white-space` values handle these differently during the layout computation phase.

## Analysis: Template Literal Whitespace Preservation

### Template Literal Evaluation (Whitespace Becomes DOM Content)

JavaScript template literals preserve all whitespace characters exactly as written in the source code. When a template literal contains indentation for formatting purposes, that indentation becomes part of the resulting string.

Consider this template literal:

```javascript
const html = `
    <div class="content">
        ${userContent}
    </div>
`;
```

The string includes:
- A newline character after the opening backtick
- Four space characters before `<div>`
- A newline after `<div class="content">`
- Eight space characters before `${userContent}`
- A newline after `${userContent}`
- Four space characters before `</div>`
- A newline before the closing backtick

When this string is assigned to `innerHTML` or inserted into the DOM, these whitespace characters become part of the DOM's text nodes. The browser's HTML parser creates text nodes containing these whitespace sequences.

### CSS white-space Processing (Rendering Decision)

After template literal evaluation and DOM construction, CSS `white-space` determines how these whitespace sequences are rendered visually.

The `pre-wrap` value instructs the rendering engine to:
1. Preserve all whitespace sequences (spaces, tabs, newlines)
2. Preserve line breaks
3. Allow text wrapping at container boundaries
4. Not collapse consecutive whitespace characters

This means every space character from the template literal becomes a rendered space in the layout. The indentation intended for code formatting becomes visual indentation in the rendered output.

### The Conflict: Formatting Whitespace vs. Content Whitespace

The problem arises when template literals contain formatting indentation that developers intend for code readability, but the CSS property preserves this formatting as visual spacing.

In my case, the template structure was:

```javascript
<div class="journal-entry-content">
    ${displayContent}
</div>
```

With `white-space: pre-wrap`, the four space characters before `${displayContent}` were preserved and rendered as leading spacing in the content, causing misalignment despite `text-align: left` being set.

![Text misalignment caused by template literal whitespace](/assets/img/2025-11-06-debugging-misaligned-text-how-template-literal-whitespace-breaks-css-alignment/screenshot-2025-11-05-bug.png){: width="750" }

*The visual result of the bug: content appears indented due to preserved whitespace from template literal formatting, despite `text-align: left` being applied.*

The `text-align` property controls horizontal alignment of text within its container, but it does not remove leading whitespace characters. Those characters are still rendered, creating visual indentation.

## Analysis: white-space Value Selection

### pre-wrap: Preserves All Whitespace Sequences

The `pre-wrap` value preserves every whitespace character from the source, including:
- Template literal formatting indentation
- User-entered content whitespace
- Line breaks

This behavior is appropriate for use cases requiring exact whitespace preservation, such as code blocks or pre-formatted text where spacing has semantic meaning.

However, when displaying user-generated content that may contain intentional line breaks but should not preserve template formatting whitespace, `pre-wrap` introduces unwanted spacing.

### pre-line: Collapses Sequences, Preserves Line Breaks

The `pre-line` value instructs the rendering engine to:
1. Collapse sequences of whitespace characters into single spaces
2. Preserve line breaks (newline characters)
3. Allow text wrapping

This means:
- Template indentation spaces are collapsed and effectively removed
- User-entered line breaks are preserved
- Multiple consecutive spaces in content become single spaces

For displaying user content that may contain intentional line breaks but should not preserve template formatting, `pre-line` provides the correct behavior.

### Comparison Table

| Value | Collapses Whitespace Sequences | Preserves Line Breaks | Preserves Individual Spaces | Use Case |
|-------|-------------------------------|----------------------|---------------------------|----------|
| `normal` | Yes | No | No | Standard text content |
| `pre-wrap` | No | Yes | Yes | Code blocks, exact formatting |
| `pre-line` | Yes | Yes | No | User content with line breaks |

## Analysis: Template Structure Impact

### Multi-line Template with Indentation

When template literals span multiple lines with indentation for code formatting:

```javascript
<div class="container">
    ${content}
</div>
```

The whitespace between the opening tag and `${content}` becomes part of the DOM text node. With `white-space: pre-wrap`, this renders as leading spacing.

### Inlined Template Content

When content is inlined on the same line as the opening tag:

```javascript
<div class="container">${content}</div>
```

No whitespace exists between the tag and content in the template string, so no leading spacing is introduced regardless of the `white-space` value.

### Content String Trimming

Trimming the content string itself:

```javascript
const trimmed = content.trim();
<div>${trimmed}</div>
```

This removes leading and trailing whitespace from the content value, but does not affect whitespace that exists in the template literal structure between tags and interpolation expressions.

## Resolution Strategy

The fix required two changes:

1. **CSS property change**: `white-space: pre-wrap` → `white-space: pre-line`
   - This collapses template formatting whitespace while preserving user-entered line breaks

2. **Template structure change**: Inline content to eliminate template whitespace
   - This removes the source of the whitespace entirely

Combined, these ensure that:
- User content line breaks are preserved (via `pre-line`)
- Template formatting whitespace is not rendered (collapsed by `pre-line` and eliminated by inlining)
- Text alignment works as expected (no leading whitespace to offset content)

![Text properly aligned after fixing whitespace handling](/assets/img/2025-11-06-debugging-misaligned-text-how-template-literal-whitespace-breaks-css-alignment/screenshot-2025-11-06-fixed.png){: width="750" }

*The fix applied: content now aligns correctly to the left edge after changing to `white-space: pre-line` and inlining template content, eliminating the unwanted indentation.*

## Conclusion

The interaction between JavaScript template literal whitespace and CSS `white-space` processing creates a subtle issue where code formatting indentation becomes visual spacing. The `pre-wrap` value preserves all whitespace sequences, including those intended only for source code readability.

The solution requires understanding that:
1. Template literal whitespace becomes DOM content before CSS processing
2. `white-space` values control how that content is rendered, not whether it exists
3. `pre-line` collapses whitespace sequences while preserving line breaks, making it appropriate for user content display
4. Inlining content in templates eliminates template-level whitespace entirely

When displaying user-generated content that may contain intentional line breaks, use `white-space: pre-line` and structure templates to minimize formatting whitespace, or inline content to eliminate it completely. This ensures proper alignment while preserving user-entered formatting.

