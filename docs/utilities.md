# Utilities Guide

This guide explains what HEBRING's utility system is, why it exists, and how to use it practically. 

## 1. What is a Utility?

A utility in HEBRING is a class that applies a single, specific CSS property adjustment.

**"Utilities are conveniences, not constraints."**

Utilities are:
- Small (handling a single CSS concern)
- Specific
- Composable
- Predictable

**"Utility handles one thing. Component defines a reusable UI pattern."**

A utility should never attempt to become a component. If you find yourself pasting 15 utility classes onto a `div` to make it look like a button, you should create a component instead.

## 2. Why HEBRING Has Utilities

HEBRING uses utilities to provide small, common adjustments without requiring developers to write custom CSS for every trivial case. 

Rather than writing bespoke CSS just to add `margin-top: 16px` to a paragraph, you use `.hb-mt-4`.

HEBRING intentionally **does not** expose every possible CSS property as a utility. This architectural choice prevents class explosion and keeps the framework understandable. If you need highly custom, bespoke styling, write custom CSS.

## 3. Utility Philosophy

HEBRING utilities adhere strictly to these principles:
- **One narrow concern**: A utility changes one specific thing.
- **Composable**: Utilities can be freely combined.
- **Token-aware**: Spacing, sizing, and typography utilities consume the design token system (e.g. `--hb-space-4`).
- **Framework agnostic**: They are plain HTML classes.
- **CSS-only**: No JavaScript runtime is required.
- **No `!important`**: Utilities rely on their position at the very end of the CSS cascade (`@layer utilities`) to override components successfully.
- **Independent**: Utilities are not coupled to any specific component.
- **Do not duplicate Layouts**: We don't provide complex Flexbox structure utilities because Layout primitives (like `.hb-cluster` and `.hb-stack`) handle structural meaning.
- **No arbitrary values API**: HEBRING does not have a JIT compiler (e.g., `w-[32px]`).

## 4. Current Utility Categories

HEBRING currently provides utilities in five categories:
- **Spacing**: Margin, padding, and flex/grid gap.
- **Display**: Block, inline, none, etc., and visibility.
- **Sizing**: Specific width and height constraints.
- **Typography**: Font sizes, weights, and text alignment.
- **Alignment**: Flex/grid child item alignment (self-alignment).

## 5. Spacing Utilities

Spacing utilities map directly to the 4px base primitive spacing tokens (from `0` to `32`).

**Naming Pattern:**
- `p` (padding), `m` (margin)
- `t` (top/block-start), `b` (bottom/block-end), `l`/`s` (start/inline-start), `r`/`e` (end/inline-end), `x` (horizontal/inline), `y` (vertical/block)

**Examples:**
- `.hb-p-4` (Padding all sides: 16px)
- `.hb-mt-2` (Margin block start: 8px)
- `.hb-px-6` (Padding inline: 24px)
- `.hb-gap-4` (Flex/grid gap: 16px)

**What is intentionally excluded:**
- No negative spacing utilities.
- No arbitrary values.
- No `auto` spacing API (e.g., `mx-auto` is handled internally by layouts like `hb-container`).
- **No responsive spacing API**: Spacing classes are not responsive to prevent excessive media-query payload bloat.
- No component-specific spacing utilities.

## 6. Display and Visibility

Controls CSS `display` and `visibility` behavior.

**Classes:**
- `.hb-block`
- `.hb-inline`
- `.hb-inline-block`
- `.hb-inline-flex`
- `.hb-inline-grid`
- `.hb-none` (Sets `display: none`)
- `.hb-visible`
- `.hb-invisible` (Sets `visibility: hidden`)

## 7. Sizing

Provides a deliberately small API for width and height constraints.

**Classes:**
- `.hb-w-auto`
- `.hb-w-full` (`100%`)
- `.hb-h-auto`
- `.hb-h-full` (`100%`)

**What is intentionally excluded:**
- HEBRING does not invent exhaustive min/max width or fractional height utilities (e.g. `w-1/2`). Use CSS for bespoke dimensions.

## 8. Typography Utilities

Handles text styling using the design token scale.

**Font Size:**
- `.hb-text-xs` through `.hb-text-6xl`

**Font Weight:**
- `.hb-font-normal`
- `.hb-font-medium`
- `.hb-font-semibold`
- `.hb-font-bold`

**Text Alignment:**
- `.hb-text-start`
- `.hb-text-center`
- `.hb-text-end`

## 9. Alignment Utilities

Handles self-alignment for flex and grid children. These exist independently from layout primitives because layout primitives dictate the container's structural behavior, whereas alignment utilities let an individual child deviate from that structure.

**Align Self:**
- `.hb-self-auto`, `.hb-self-start`, `.hb-self-center`, `.hb-self-end`, `.hb-self-stretch`

**Justify Self:**
- `.hb-justify-self-auto`, `.hb-justify-self-start`, `.hb-justify-self-center`, `.hb-justify-self-end`, `.hb-justify-self-stretch`

## 10. Responsive Utilities

HEBRING supports responsive behavior for *meaningful* utilities using a mobile-first, min-width architecture without JavaScript viewport detection.

**Current Breakpoints:**
- `sm`: 640px
- `md`: 768px
- `lg`: 1024px

**Syntax:**
`{utility}-{breakpoint}`

Responsive utilities are cumulative. Applying a style at `sm` automatically persists into `md` and `lg` unless explicitly overridden.

**Supported Responsive Categories:**
- Display / Visibility (e.g., `.hb-none`, `.hb-block-md`)
- Sizing (e.g., `.hb-w-full`, `.hb-w-auto-lg`)
- Typography font-size (e.g., `.hb-text-sm`, `.hb-text-lg-md`)
- Typography text alignment (e.g., `.hb-text-center`, `.hb-text-start-sm`)
- Alignment (e.g., `.hb-self-center`, `.hb-self-start-lg`)

**What is intentionally excluded:**
- **No responsive spacing**: Classes like `hb-p-4-md` do not exist.
- **No responsive font-weight**: Font-weight does not typically need to change across viewports.
- **No `@layer responsive`**: Responsive utilities are embedded natively at the bottom of the standard `utilities` cascade layer to prevent specificity conflicts.

## 11. Composition

Utilities can be combined powerfully when needed, though they often work best when tweaking existing Layouts.

```html
<!-- A neutral flex container, vertically centered, hidden on mobile but visible on sm screens -->
<div class="hb-flex hb-none hb-block-sm hb-self-center">
  <span class="hb-text-lg hb-font-bold hb-text-center-md">
    Responsive, combined utilities
  </span>
</div>
```
