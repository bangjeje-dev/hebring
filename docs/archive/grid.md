# Grid (`hb-grid`)

The `hb-grid` is a foundational layout primitive designed to establish a two-dimensional layout context using native CSS Grid. 

---

## 1. What is `hb-grid`?

`hb-grid` is a layout primitive whose sole purpose is to establish a CSS Grid formatting context for its children, along with a consistent default spacing.

## 2. Why is it a layout primitive?

It is a layout primitive because it manages the two-dimensional spatial relationship between sibling elements. It does not provide any component-level visual identity (like backgrounds, borders, or colors), but instead serves as structural scaffolding.

## 3. The "Grid Context, Not Grid System" Philosophy

HEBRING explicitly separates the idea of a "Grid Context" from a "Grid System":
- **Grid Context**: Activating native CSS Grid behavior (`display: grid; gap: ...`). This is what `hb-grid` does.
- **Grid System**: Imposing a mandatory framework of rows, columns, and spanning mathematics (e.g., Bootstrap's 12-column grid).

`hb-grid` establishes the *context*, allowing native CSS Grid properties to flow naturally, rather than forcing developers into a rigid, framework-dictated *system*.

---

## 4. Native CSS Grid Foundation

The implementation is minimal and directly leverages the native specification:

```css
.hb-grid {
  display: grid;
  gap: var(--hb-space-4);
}
```

## 5. Default Gap

The primitive provides a default gap bound to `var(--hb-space-4)` (16px). This ensures consistent breathing room between grid items without introducing component-specific tokens like `--hb-grid-gap`, and without using brittle margin hacks.

---

## 6. Sizing and Columns

### Why No Default Column Count Exists

`hb-grid` intentionally does not define `grid-template-columns`. Imposing a default (e.g., 1 column or 12 columns) would immediately restrict the primitive's usefulness. By leaving the column definition empty, developers maintain the freedom to compose the exact grid structure their layout requires without fighting framework defaults.

### Why a 12-Column System is Intentionally Excluded

A mandatory 12-column system is a legacy abstraction from the pre-CSS Grid era. It forces developers to map their content to arbitrary fractions (e.g., `col-4` for a third) rather than expressing the intrinsic layout of the content itself. HEBRING rejects this rigid mathematical overlay in favor of native CSS Grid's immense flexibility. There are no `hb-col-1` through `hb-col-12` classes in HEBRING.

### Why Column-Count API is Deferred

The decision on how developers will ultimately specify column counts (e.g., utility classes like `hb-grid-cols-3`, or custom properties like `--hb-grid-columns: 3`) is intentionally deferred. This ensures the foundational primitive is solid before evaluating the broader utility and responsive architecture in later phases.

### Sizing Behavior

`hb-grid` does not define `width: 100%`, `height: 100%`, `grid-auto-columns`, or `grid-auto-rows`. It merely establishes the context, leaving sizing behavior to natural CSS Grid defaults and the content within.

---

## 7. Child Responsibility Boundary

`hb-grid` must not style its children. It explicitly **does not**:
- Create child selectors (e.g., `.hb-grid > *`).
- Target specific HTML tags (e.g., `.hb-grid > article`).
- Modify child margins, typography, colors, borders, or widths.

Each grid item is 100% responsible for its own visual identity and internal layout.

---

## 8. Alignment Behavior

The primitive explicitly preserves native CSS Grid alignment defaults. It does not impose properties like `align-items`, `justify-items`, `place-content`, or `place-items`. This guarantees that the layout primitive does not enforce opinionated visual centering or stretching that developers would then have to override.

---

## 9. Nested Grid Behavior

Nested grids work naturally. There are no special `.hb-grid .hb-grid` selectors. If you nest an `hb-grid` inside another `hb-grid`, the child establishes a brand new, independent two-dimensional layout context exactly as CSS Grid intends.

---

## 10. Semantic HTML Flexibility

The `.hb-grid` class provides layout behavior, not semantic meaning. It can be applied to any structural HTML element:

```html
<div class="hb-grid">...</div>
<main class="hb-grid">...</main>
<section class="hb-grid">...</section>
```

---

## 11. Responsive Behavior (Intentionally Deferred)

There are no media queries, breakpoints, or responsive variant classes (like `hb-grid-md`) in `hb-grid`. 

Complex responsive grid behavior belongs to the future Responsive System phase. HEBRING refuses to turn intrinsic CSS Grid capabilities into a hidden, rigid responsive API prematurely.

---

## 12. Distinctions

### `hb-grid` vs. `hb-cluster`

- **`hb-cluster`**: A *one-dimensional* horizontal grouping with intrinsic wrapping behavior. Used when you want items to flow horizontally like text.
- **`hb-grid`**: A *two-dimensional* relationship of rows and columns. Used when items need to align across both horizontal and vertical axes simultaneously. `hb-grid` is not a hidden replacement for `hb-cluster`.

### `hb-grid` vs. Future `hb-flex`

- **`hb-grid`**: Establishes a two-dimensional grid context.
- **Future `hb-flex`**: Will provide explicit, lower-level control over one-dimensional Flexbox behavior for highly specific layouts. 
*(Note: `hb-flex` is not yet implemented.)*

---

## 13. Explicit Non-Goals

To maintain its architectural purity, `hb-grid` explicitly avoids:
- Inventing a new grid API or 12-column framework.
- Supplying a column-count API in this phase.
- Enforcing sizing or alignment magic.
- Using margin hacks (`* + *`) instead of `gap`.
- Introducing component-specific design tokens.

---

## 14. Basic Example

The following example establishes a layout context for a group of articles. Note that the number of columns is not dictated by the `hb-grid` class itself.

```html
<div class="hb-grid">
  <article>Card Content A</article>
  <article>Card Content B</article>
  <article>Card Content C</article>
</div>
```
