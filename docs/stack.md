# Stack (`hb-stack`)

The `hb-stack` is a foundational layout primitive designed to establish a vertical relationship and consistent spacing between its direct children.

---

## 1. What is `hb-stack`?

`hb-stack` is a layout primitive, not a UI component. Its only purpose is to take a group of sibling elements and stack them vertically with a uniform gap.

**Why is it a layout primitive?**
Because stacking elements vertically with consistent spacing is one of the most common structural patterns in UI development. By conceptualizing this as a "Stack" instead of repeatedly writing `hb-flex hb-flex-col hb-gap-4`, we communicate structural intent directly in the HTML.

---

## 2. Flexbox Implementation Concept

The implementation relies purely on native CSS Flexbox defaults to achieve its layout, deliberately avoiding overly rigid constraints:

```css
.hb-stack {
  display: flex;
  flex-direction: column;
  gap: var(--hb-space-4);
}
```

By relying on Flexbox's native `column` direction and the modern `gap` property, `hb-stack` completely avoids the fragile spacing hacks of the past (like setting `margin-top` on adjacent sibling selectors: `* + *`). 

---

## 3. Child Responsibility Boundary

A core principle of `hb-stack` is that **it must not modify its children**. 

The stack manages the *relationship* between children, not the children themselves. It explicitly does **not**:
- Reset, remove, or dictate child margins.
- Modify child typography, colors, or backgrounds.
- Set child widths or heights.
- Target specific child elements (e.g., `.hb-stack > p` or `.hb-stack > *`).

Each child is responsible for its own content and internal styling.

---

## 4. Nested Stack Behavior

Stacks are frequently nested to create more complex vertical rhythm without writing custom CSS.

```html
<div class="hb-stack">
  <div class="hb-stack">
    <h2>Article Title</h2>
    <p>Article subtitle or meta information.</p>
  </div>
  <p>Main article content goes here.</p>
</div>
```

**Nested stacks work naturally.** There is no special `.hb-stack .hb-stack` selector. Each stack establishes its own independent layout context, and they compose flawlessly.

---

## 5. Semantic HTML Flexibility

The `.hb-stack` class provides layout behavior, not semantic meaning. It does not require a specific HTML element. It can be applied to any semantic tag that conceptually represents a vertical group:

```html
<div class="hb-stack">...</div>
<section class="hb-stack">...</section>
<form class="hb-stack">...</form>
<ul class="hb-stack">...</ul>
```

---

## 6. Composition with Future Layout Primitives

The stack primitive is designed to be composed with other layout primitives.

For example, a standard page structure might use a Container to constrain width, and a Stack to flow the vertical content:
```html
<div class="hb-container">
  <div class="hb-stack">
    <header>Site Header</header>
    <main>Main Content</main>
    <footer>Site Footer</footer>
  </div>
</div>
```

Future utilities (like `hb-gap-6`) will be able to compose with the stack to override its default gap conceptually:
```html
<div class="hb-stack hb-gap-6">
  <!-- Items with a larger gap -->
</div>
```

---

## 7. Explicit Non-Goals

To maintain its purity as a layout primitive, `hb-stack` explicitly avoids the following:

- **No Responsive Variants**: There are no media-query bound variants (like `hb-stack-md`). Responsive APIs belong to a future phase.
- **No Spacing Variants**: Spacing customization is deferred to future utility classes. Creating `hb-stack--large` or `--hb-stack-gap` tokens would violate the philosophy of using single-purpose utilities for overrides and avoiding component-specific tokens.
- **No Margin-Based Spacing**: Using `gap` is preferred over child margins (`* + * { margin-top: ... }`) because `gap` correctly handles empty elements, nested structures, and doesn't pollute the child's own box model.
- **No Explicit Alignment Defaults**: The primitive avoids setting `align-items`, `justify-content`, or flex sizing properties. It relies on the natural Flexbox defaults to prevent unexpected side-effects on child elements.
