# Container (`hb-container`)

The `hb-container` is the canonical layout primitive in HEBRING for establishing a maximum content width and horizontal centering.

---

## 1. Purpose & Responsibility

The sole responsibility of `hb-container` is to constrain the maximum width of content on large screens while ensuring the content remains centered, readable, and does not touch the edges of the viewport on small screens.

**It is strictly a layout boundary.** It does not provide typography, backgrounds, borders, or any component-level visual identity.

---

## 2. Basic Usage

```html
<div class="hb-container">
  <h1>Page Title</h1>
  <p>Main content area constrained and centered.</p>
</div>
```

---

## 3. Core Behavior

The container primitive provides:
- **`width: 100%`**: Ensures the container fills available space up to its maximum width constraint.
- **`margin-inline: auto`**: Automatically centers the container within its parent/viewport when the viewport is wider than the container's max-width.
- **Sensible Max-Width**: Prevents text lines from becoming unreadably long on wide displays.
- **Horizontal Padding**: Provides "breathing room" so content does not touch the physical edge of the screen on small devices.

---

## 4. Architectural Decisions

### Max-Width Decision

Currently, HEBRING's primitive token architecture (`src/tokens/primitives.css`) provides values for colors, spacing, typography, radii, shadows, and motion. It does **not** yet include a `size` or `max-width` token category.

Following the principle of avoiding arbitrary token expansion, the `hb-container` uses an **architecturally conservative implementation**: a hardcoded `max-width: 80rem;` (equivalent to `1280px`). This prevents polluting the token namespace with a single-use variable like `--hb-container-width`, adhering to the rule that layout primitives must not invent component-specific tokens.

### Horizontal Padding Decision

To provide viewport breathing room, `hb-container` leverages the existing primitive spacing token:
```css
padding-inline: var(--hb-space-4);
```
Using `var(--hb-space-4)` ensures the container padding is harmonious with the rest of the spacing scale, without inventing an unneeded `--hb-container-padding` token.

### Small Viewport Behavior

The container remains naturally usable on narrow screens. Because it relies on `max-width` rather than a fixed `width`, it behaves fluidly as the viewport shrinks. The `width: 100%` paired with `padding-inline` guarantees content naturally fits and wraps without horizontal scrolling. No media queries are required for this baseline behavior.

---

## 5. Composition Expectations

`hb-container` is designed to compose cleanly with other layout primitives. 

For example, a layout requiring vertical spacing inside the container boundary would look like:

```html
<div class="hb-container">
  <div class="hb-stack">
    <header>...</header>
    <main>...</main>
    <footer>...</footer>
  </div>
</div>
```

### Nested Container Behavior

Nested containers are technically allowed but do not receive special styling. There is no `hb-container .hb-container` rule. If a container is nested inside another container, it will simply take up 100% of the available width of the parent (minus the padding) up to its maximum width.

---

## 6. Explicit Non-Goals

The `hb-container` is **not**:
- A generic component (it does not apply colors, shadows, or typography).
- A grid system (it does not create rows or columns).
- A flex wrapper (it does not alter the layout of its direct children beyond containing their width).

### Why Responsive Variants are Not Included Yet

HEBRING intentionally omits responsive container APIs (such as `hb-container-sm`, `hb-container-lg`, or breakpoint-specific variants) during this phase. 

Adding media-query-dependent classes expands framework footprint significantly and requires a formalized Responsive System strategy (which belongs to a future phase). The baseline `hb-container` provides intrinsic fluidity and serves the majority of primary structural needs without the overhead of variant classes.
