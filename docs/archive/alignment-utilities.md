# Alignment Utilities

Phase 06.7 establishes the alignment utility API for HEBRING.

## Purpose

Alignment utilities provide ITEM-LEVEL alignment overrides for Flexbox and Grid contexts. They exclusively control `align-self` and `justify-self`.

## The API

All utilities map directly to CSS properties and are contained within `@layer utilities`.

### Self Alignment (`align-self`)

- `.hb-self-auto` → `align-self: auto;`
- `.hb-self-start` → `align-self: start;`
- `.hb-self-center` → `align-self: center;`
- `.hb-self-end` → `align-self: end;`
- `.hb-self-stretch` → `align-self: stretch;`

### Justify Self (`justify-self`)

- `.hb-justify-self-auto` → `justify-self: auto;`
- `.hb-justify-self-start` → `justify-self: start;`
- `.hb-justify-self-center` → `justify-self: center;`
- `.hb-justify-self-end` → `justify-self: end;`
- `.hb-justify-self-stretch` → `justify-self: stretch;`

## Item-Level Alignment Concept

These utilities are strictly applied to **items** inside a layout context, not the context itself. Container-level Flexbox/Grid alignment utilities (like `justify-content` or `align-items`) are intentionally excluded from this phase.

## Relationship to Layout Primitives

HEBRING relies on Layout primitives (`hb-flex`, `hb-grid`, `hb-center`) for establishing the context and the default container-level alignment. These utilities serve as orthogonal overrides when a specific child item needs to deviate from the container's default rules.

## Difference from Typography Text-Align

While text-align utilities (`hb-text-center`, etc.) control how text is aligned inside an element, `align-self` and `justify-self` utilities control how the entire element block aligns itself within its parent layout track.

## Logical Alignment Rationale

Alignment uses logical values (`start`, `end`) instead of physical flow values (`flex-start`, `left`, `right`). This aligns with HEBRING's logical-first philosophy, ensuring proper flow regardless of writing mode.

## Exclusions and Deferred APIs

The following are explicitly excluded to maintain boundary integrity:
- Container-level alignment utilities (e.g., `hb-justify-*`, `hb-items-*`).
- Combined placement utilities (e.g., `hb-place-self-*`).
- Physical Flexbox alignments (`flex-start`, `flex-end`).
- Inline flow vertical alignments (`vertical-align`).
- Responsive variants (deferred to Phase 08).
- Arbitrary values or component-specific alignment.

## Composition Examples

```html
<!-- An item deviating from the stack's cross-axis alignment -->
<div class="hb-stack">
  <div>Default Item</div>
  <div class="hb-self-end">Aligned Item</div>
</div>
```
