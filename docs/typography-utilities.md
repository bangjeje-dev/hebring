# Typography Utilities

Phase 06.6 establishes the typography utility API for HEBRING.

## Purpose

Typography utilities provide narrow, single-purpose adjustments to font size, font weight, and text alignment, allowing specific visual overrides without duplicating the foundational typography rules or creating component-specific text classes.

## The API

All utilities map directly to CSS properties within `@layer utilities`. Font sizes and weights exclusively reference the existing HEBRING typography primitive tokens.

### Font Size

- `.hb-text-xs` → `var(--hb-font-size-xs)`
- `.hb-text-sm` → `var(--hb-font-size-sm)`
- `.hb-text-md` → `var(--hb-font-size-md)`
- `.hb-text-lg` → `var(--hb-font-size-lg)`
- `.hb-text-xl` → `var(--hb-font-size-xl)`
- `.hb-text-2xl` → `var(--hb-font-size-2xl)`
- `.hb-text-3xl` → `var(--hb-font-size-3xl)`
- `.hb-text-4xl` → `var(--hb-font-size-4xl)`
- `.hb-text-5xl` → `var(--hb-font-size-5xl)`
- `.hb-text-6xl` → `var(--hb-font-size-6xl)`

### Font Weight

- `.hb-font-normal` → `var(--hb-font-weight-normal)`
- `.hb-font-medium` → `var(--hb-font-weight-medium)`
- `.hb-font-semibold` → `var(--hb-font-weight-semibold)`
- `.hb-font-bold` → `var(--hb-font-weight-bold)`

### Text Alignment

- `.hb-text-start` → `text-align: start;`
- `.hb-text-center` → `text-align: center;`
- `.hb-text-end` → `text-align: end;`

## Foundation vs. Utility Boundary

HEBRING's Foundation layer (`base.css`) continues to own the semantic default typography for HTML elements (like `<h1>`, `<p>`, `<a>`). These typography utilities do **not** replace the foundation; they augment it for isolated situations where the natural document flow isn't sufficient.

## Logical Alignment Rationale

Text alignment strictly uses logical properties (`start`, `end`) rather than physical directions (`left`, `right`). This guarantees that typography alignment automatically respects the writing mode (e.g., LTR vs RTL) without requiring additional overrides.

## Exclusions

To prevent utility bloat, the following are explicitly excluded from this phase:
- Line-height utilities
- Letter-spacing utilities
- Font-family utilities
- Text-transform and text-decoration utilities
- Truncation and line-clamp patterns
- Arbitrary value injection
- Component-bound typography helpers
- Responsive typography variants (Deferred to Phase 08)

## Composition Examples

```html
<!-- Overriding baseline typography for a specific emphasis -->
<p class="hb-text-sm hb-font-medium hb-text-center">...</p>
```
