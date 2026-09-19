# Flow (`hb-flow`)

The `hb-flow` primitive provides vertical content rhythm while preserving normal CSS document flow. It is designed to give flowing content consistent spacing without converting the container into a Flexbox or Grid layout.

---

## 1. Purpose & Layout Intent

The primary purpose of `hb-flow` is to inject predictable vertical spacing between adjacent sibling elements. Its layout intent is summarized as:

> *"Give flowing content a consistent vertical rhythm without converting the content into Flexbox or Grid."*

`hb-flow` provides content rhythm; it does not become the layout system for the content.

---

## 2. The Normal Document Flow Model

Unlike other structural primitives in HEBRING, `hb-flow` intentionally **preserves normal document flow**. It does not set `display: flex;` or `display: grid;`. Elements inside an `hb-flow` container behave exactly as they would in a standard HTML document, retaining their native block or inline formatting contexts.

---

## 3. CSS Behavior & Direct Sibling Spacing

The implementation targets the direct-sibling relationship using the owl selector pattern:

```css
.hb-flow > * + * {
  margin-block-start: var(--hb-space-4);
}
```

This applies a top margin (using logical properties) to every direct child of `.hb-flow` *except* the first child. It prevents unwanted margins at the top or bottom of the container, cleanly managing the space *between* elements.

---

## 4. Why Margin Instead of Flexbox `gap`?

Using `gap` requires changing the display model of the container to `flex` or `grid`. Changing the display model to `flex` (like `hb-stack` does) alters how children are rendered (e.g., text nodes become flex items, block-level margin collapsing is disabled, max-width behaviors change). 

`hb-flow` uses `margin-block-start` specifically to avoid these side effects, ensuring the content behaves like natural HTML documents.

---

## 5. Architectural Distinctions

### Difference Between `hb-flow` and `hb-stack`
- **`hb-stack`**: Creates a Flexbox layout context (`display: flex; flex-direction: column;`). It uses `gap` for spacing. It is used for structural UI layouts (e.g., a card with a header, body, and footer).
- **`hb-flow`**: Preserves normal document flow and uses `margin-block-start` for spacing. It is used for long-form content rhythm (e.g., articles, markdown output, mixed prose).

### Difference Between `hb-flow` and Spacing Utilities
Spacing utilities (like a hypothetical `hb-mt-4`) apply spacing to specific, individual elements. `hb-flow` is a systemic primitive that automatically handles the spacing for *all* siblings within its context, managing the spaces between them dynamically without requiring utility classes on every child.

---

## 6. What `hb-flow` Intentionally Does NOT Do

To maintain its strict boundaries, `hb-flow` avoids:
- Altering the `display` property of the container or its children.
- Applying `margin` to anything other than the `* + *` direct sibling relationship.
- Applying `padding`.
- Defining sizes, min/max dimensions, or responsive behavior.
- Defining typography, colors, borders, or visual styling.
- Introducing configurable spacing variants (like `hb-flow--tight`) at this primitive layer.
- Creating special cases for specific tags (like headings or paragraphs).

---

## 7. Basic Usage and Nested Usage

Nested `hb-flow` containers work naturally through normal CSS inheritance and document structure. The selector `> * + *` ensures that only direct children receive the margin, preventing deep, unintended cascading margins.

### Example HTML

```html
<div class="hb-flow">
  <div>First structural block</div>
  <div>Second structural block</div>
  <div>Third structural block</div>
</div>
```

### Example with Semantic Content

`hb-flow` is ideal for raw, semantic content blocks:

```html
<article class="hb-flow">
  <h2>The Importance of Flow</h2>
  <p>In web design, normal document flow is often overlooked in favor of structural layout engines like Flexbox.</p>
  <ul>
    <li>It is robust.</li>
    <li>It handles text naturally.</li>
  </ul>
  <blockquote>"Flow is the default state of the web."</blockquote>
  <p>By using the flow primitive, we respect this natural state while enforcing a baseline rhythm.</p>
</article>
```
