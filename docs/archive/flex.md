# Flex (`hb-flex`)

The `hb-flex` is a foundational layout primitive designed to establish an explicit, native CSS Flexbox context while remaining entirely neutral regarding specific Flexbox configuration.

---

## 1. What is `hb-flex`?

`hb-flex` is a structural layout primitive. Its sole responsibility is to apply `display: flex;` to an element, thereby activating a flex formatting context for its direct children.

## 2. Why is it a Layout Primitive?

It resides in the layout layer because it governs the spatial formatting context of its descendants. It is not a component because it has zero visual styling (no backgrounds, borders, or aesthetic identity). 

## 3. The "Neutral Flexbox Context" Philosophy

HEBRING emphasizes intention-driven layouts. The `hb-flex` class exists so developers can clearly communicate in their HTML: *"This element establishes a Flexbox context."* It does not imply a specific direction, alignment, gap, or wrapping behavior. It is intentionally unopinionated.

---

## 4. Minimal Core Implementation

The implementation is strictly limited to enabling Flexbox:

```css
.hb-flex {
  display: flex;
}
```

---

## 5. Intentional Omissions

### Why There is No Default Gap
Unlike `hb-stack`, `hb-cluster`, or `hb-grid`, `hb-flex` intentionally defines **no default spacing**. Adding a default gap would impose an opinionated behavior on a neutral primitive, which might not be desired for all generic flex containers. Future spacing utilities will be composed with `hb-flex` when spacing is required.

### Why Direction is Not Specified
Even though the browser defaults to `flex-direction: row`, `hb-flex` does not explicitly declare it. It preserves the native CSS Flexbox defaults to prevent unnecessary specificity or overrides.

### Why Wrapping is Not Specified
Wrapping is a higher-level layout intention (handled natively by the `hb-cluster` pattern). `hb-flex` remains neutral, leaving `flex-wrap` entirely to the browser default (`nowrap`) or future explicit utility classes.

### Why Alignment/Distribution are Not Specified
The primitive explicitly avoids defining `align-items`, `align-content`, or `justify-content`. Imposing default centering or space distribution would force developers to fight the framework when they need native flex behavior.

---

## 6. Child Responsibility Boundary

`hb-flex` manages the flex context of the parent container only. It explicitly **does not**:
- Create child selectors (e.g., `.hb-flex > *`).
- Modify child margins, typography, widths, heights, or visual styles.
- Define explicit child flex properties like `flex-grow`, `flex-shrink`, or `flex-basis`.

Children are responsible for their own internal dimensions and styling. There are no margin-based spacing hacks.

---

## 7. Nested Flex Behavior

Nested `hb-flex` elements work natively and fluidly. There are no special `.hb-flex .hb-flex` selectors. Each `hb-flex` container establishes its own independent Flexbox context without interference.

---

## 8. Semantic HTML Flexibility

The `.hb-flex` class provides layout behavior, not semantic meaning. It can be applied to any block-level semantic element:

```html
<div class="hb-flex">...</div>
<nav class="hb-flex">...</nav>
<section class="hb-flex">...</section>
```

---

## 9. Relationship to Other Layout Primitives

`hb-flex` is the most neutral base layer among HEBRING's flex-based primitives:

- **`hb-stack`**: An opinionated vertical layout pattern (`flex-direction: column` + `gap`).
- **`hb-cluster`**: An opinionated horizontal grouping pattern (`flex-wrap: wrap` + `gap`).
- **`hb-grid`**: An opinionated two-dimensional Grid context (`display: grid` + `gap`).
- **`hb-flex`**: A neutral, unopinionated explicit Flexbox context (`display: flex`).

---

## 10. Future Utility/API Considerations

To avoid premature abstractions, HEBRING does not currently implement a comprehensive Flexbox utility API (e.g., `hb-flex-col`, `hb-items-center`, `hb-justify-between`, `hb-flex-1`).

These granular Flexbox controls are explicitly deferred. They must be carefully evaluated and designed as part of the broader Utilities and Responsive System architecture in future phases, rather than being rushed into the structural layout primitive layer.

---

## 11. Explicit Non-Goals

To maintain its neutrality, `hb-flex` strictly avoids:
- Inventing a gap where one is not strictly requested.
- Imposing alignment or direction behavior.
- Styling its children.
- Using margin hacks (`* + *`) instead of explicit modern gap handling in future utilities.
- Providing responsive variants (e.g., `hb-flex-md`) or introducing media queries in this phase.
- Introducing layout or component-specific tokens.

---

## 12. Basic Example

The following example establishes a simple flex context. Notice that no additional styling is assumed. Any further Flexbox behavior (like spacing or alignment) is intentionally deferred to future API/utility design.

```html
<div class="hb-flex">
  <div>Item A</div>
  <div>Item B</div>
</div>
```
