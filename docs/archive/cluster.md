# Cluster (`hb-cluster`)

The `hb-cluster` is a foundational layout primitive designed to establish a horizontal grouping relationship between direct children, allowing them to wrap naturally when available space is insufficient.

---

## 1. What is `hb-cluster`?

`hb-cluster` is a layout primitive, not a UI component. Its only purpose is to take a group of sibling elements (such as tags, buttons, or metadata items) and group them horizontally, enabling them to safely wrap onto a new line if they run out of horizontal space.

**Why is it a layout primitive?**
Horizontal wrapping with consistent spacing is a structural pattern required continuously across user interfaces. Conceptualizing it as a "Cluster" allows developers to focus on the intent of the layout without re-writing `display: flex; flex-wrap: wrap; gap: ...` every time.

---

## 2. Flexbox Foundation & Natural Wrapping

The implementation is built on native CSS Flexbox, utilizing the default direction and explicit wrapping behavior:

```css
.hb-cluster {
  display: flex;
  flex-wrap: wrap;
  gap: var(--hb-space-4);
}
```

The intrinsic responsiveness of `hb-cluster` is entirely driven by `flex-wrap: wrap;`. As the container shrinks, children will automatically flow to the next line without requiring media queries.

---

## 3. Gap vs. Child Margins

By using the modern `gap` property, `hb-cluster` cleanly manages the space between its children without requiring structural hacks. 

**Why gap is preferred:**
Historically, wrapping layouts relied on complex margins (e.g., negative margins on the parent combined with margins on children). `gap` delegates this responsibility to the browser's layout engine. It accurately applies spacing between wrapped lines and adjacent items without leaking margins into the surrounding layout or requiring `> *` child targeting.

### Default Gap

The default spacing is bound to the primitive token `var(--hb-space-4)` (16px). This unifies the spacing rhythm without introducing a component-specific token like `--hb-cluster-gap`.

---

## 4. Child Responsibility Boundary

The `hb-cluster` manages the horizontal layout relationship, not the visual styling of its children. 

It explicitly **does not**:
- Create child selectors (e.g., `.hb-cluster > *` or `.hb-cluster span`).
- Modify child margins, borders, backgrounds, or typography.
- Impose explicit widths, heights, or flex sizing (`flex-grow`, `flex-basis`) on children.

Each child maintains total control over its own styling and dimensions.

---

## 5. Alignment and Distribution

Alignment and distribution are **intentionally not defined** on the base `hb-cluster` class. 

The primitive avoids properties like:
- `align-items`
- `justify-content`

By relying on Flexbox defaults, the cluster does not enforce a specific visual centering or space distribution, keeping the layout primitive universally applicable. When specific alignment is needed, developers should compose the cluster with single-purpose utility classes (e.g., `hb-justify-center`).

---

## 6. Composition with Other Layout Primitives

`hb-cluster` works seamlessly alongside other layout primitives like `hb-stack` and `hb-container`.

For example, a cluster of action buttons placed beneath a text stack:

```html
<div class="hb-stack">
  <h2>Settings</h2>
  <p>Manage your account preferences here.</p>
  
  <div class="hb-cluster">
    <button>Cancel</button>
    <button>Save Changes</button>
  </div>
</div>
```
*(Note: Do not style the buttons in this layer. The cluster merely handles the horizontal layout and potential wrapping.)*

### Nested Cluster Behavior

Like stacks, clusters can be nested. There is no special `.hb-cluster .hb-cluster` rule. Each cluster simply establishes its own independent wrapping layout context.

---

## 7. Semantic HTML Flexibility

The `.hb-cluster` class provides layout behavior, not semantic meaning. Any structural element can function as a cluster:

```html
<div class="hb-cluster">...</div>
<nav class="hb-cluster">...</nav>
<ul class="hb-cluster">...</ul>
```

---

## 8. Explicit Non-Goals & Distinctions

- **No Responsive Variants**: `hb-cluster` does not include `sm`, `md`, or `lg` modifier variants. Wrapping is its intrinsic responsive behavior. Media-query-based variations are explicitly deferred.
- **No Sizing Magic**: The cluster does not force `width: 100%`, `flex: 1`, or modify the natural size of the flex container itself.
- **Not a Flex API Alias**: `hb-cluster` is conceptually different from a future `hb-flex` utility. A cluster represents the *intent* of grouping wrapping elements with a default gap. A future `hb-flex` utility will serve lower-level control where developers need explicit, configurable access to Flexbox behavior.
