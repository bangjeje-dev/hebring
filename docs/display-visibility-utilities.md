# Display & Visibility Utilities

Phase 06.4 establishes the core display and visibility utilities for HEBRING.

## Purpose

These utilities provide explicit control over element flow (`block`, `inline`) and visibility (`hidden`, `visible`) without requiring component-level abstractions.

## The API

All utilities map directly to CSS properties and are contained within `@layer utilities`.

### Display

- `.hb-block` → `display: block`
- `.hb-inline` → `display: inline`
- `.hb-inline-block` → `display: inline-block`
- `.hb-inline-flex` → `display: inline-flex`
- `.hb-inline-grid` → `display: inline-grid`
- `.hb-none` → `display: none`

### Visibility

- `.hb-visible` → `visibility: visible`
- `.hb-invisible` → `visibility: hidden`

## Distinctions

### `hb-none` vs `hb-invisible`

- `.hb-none` applies `display: none`, removing the element completely from the document flow and accessibility tree.
- `.hb-invisible` applies `visibility: hidden`, hiding the element visually while maintaining its layout space.

### The `hb-flex` and `hb-grid` Boundary

In HEBRING, `hb-flex` and `hb-grid` are **Layout primitives**, not utilities. They exist in the `@layer layout` cascade step and represent structural contexts, not atomic adjustments. Consequently, HEBRING explicitly omits `.hb-flex` and `.hb-grid` from the utilities domain to prevent architectural overlap.

## Exclusions

The following patterns are deliberately excluded:
- Table display variants (e.g., `table-cell`, `table-row`).
- Structural flow properties (e.g., `flow-root`, `contents`).
- Responsive display variants (deferred to Phase 08).
- Arbitrary display values.
- Component-bound visibility states.

## Composition Examples

```html
<!-- Overriding semantic default flow -->
<span class="hb-block hb-text-muted">...</span>

<!-- Hiding an element while retaining layout -->
<div class="hb-invisible">...</div>
```
