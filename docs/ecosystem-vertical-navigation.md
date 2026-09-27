# Vertical Navigation (Ecosystem UI)

The Vertical Navigation component (`hb-vertical-nav`) provides a structured, accessible, and deep navigation pattern typically found in application sidebars, admin dashboards, and documentation layouts.

It supports hierarchical nested items, active states, expandable controls, icons, and badges.

*Note: For the underlying architecture and boundary definitions, see [Vertical Navigation Architecture](./vertical-navigation-architecture.md).*

## 1. DOM Contract

The component employs semantic HTML built around `<nav>` and unordered lists.

```html
<nav class="hb-vertical-nav" aria-label="Main Navigation">
  <div class="hb-vertical-nav__group">
    <div class="hb-vertical-nav__label" id="nav-workspace">Workspace</div>
    <ul class="hb-vertical-nav__list" aria-labelledby="nav-workspace">
      <!-- Items go here -->
    </ul>
  </div>
</nav>
```

## 2. Simple Navigation Item

A standard navigation item uses an anchor tag `<a>`.

```html
<li class="hb-vertical-nav__item">
  <a href="/orders" class="hb-vertical-nav__link">
    <span class="hb-vertical-nav__text">Orders</span>
  </a>
</li>
```

### Active State

To indicate the currently active page, use the native `aria-current="page"` attribute. Do not use custom classes.

```html
<a href="/orders" class="hb-vertical-nav__link" aria-current="page">
  <span class="hb-vertical-nav__text">Orders</span>
</a>
```

### Disabled State

To disable a navigation link functionally without breaking focus semantics, use `aria-disabled="true"`.

```html
<a href="/orders" class="hb-vertical-nav__link" aria-disabled="true">
  <span class="hb-vertical-nav__text">Orders</span>
</a>
```

## 3. Expandable Navigation Item (Nested)

To create a group that expands and collapses, use a `<button>` as the trigger, and a nested `<ul>` containing the sub-items.

```html
<li class="hb-vertical-nav__item hb-vertical-nav__item--expandable">
  <button type="button" class="hb-vertical-nav__link" aria-expanded="false" aria-controls="sub-products">
    <span class="hb-vertical-nav__text">Products</span>
    <svg class="hb-vertical-nav__chevron" viewBox="0 0 24 24"><polyline points="6 9 12 15 18 9"></polyline></svg>
  </button>
  
  <ul class="hb-vertical-nav__list hb-vertical-nav__list--nested" id="sub-products" hidden>
    <li class="hb-vertical-nav__item">
      <a href="/products/all" class="hb-vertical-nav__link">All Products</a>
    </li>
  </ul>
</li>
```

### Optional JS Enhancement

HEBRING is primarily a CSS framework. The expand/collapse visual styling relies on the `aria-expanded` and `hidden` attributes. 

You can include the optional vanilla JavaScript enhancement provided in `ecosystem/ui/vertical-nav.js` to automatically wire up the toggle logic.

```html
<script src="path/to/hebring/ecosystem/ui/vertical-nav.js"></script>
```

## 4. Icons and Badges

The component handles flexible layout for icons (start) and badges (end). Use `currentColor` for icons to ensure they inherit active/hover states seamlessly.

```html
<a href="/messages" class="hb-vertical-nav__link">
  <svg class="hb-vertical-nav__icon" viewBox="0 0 24 24">...</svg>
  <span class="hb-vertical-nav__text">Messages</span>
  <span class="hb-badge" style="margin-left: auto;">5</span>
</a>
```

## 5. Responsive Consumption

The `.hb-vertical-nav` component scales to `100%` of its parent container. 
It does **not** dictate sidebar width, fixed positioning, or mobile off-canvas behavior. Those layout concerns are the responsibility of the consumer application or template shell.

## 6. Theming

The component is fully compliant with HEBRING's semantic theme tokens (`--hb-color-text`, `--hb-color-primary`, `--hb-color-background-subtle`, etc.). It works seamlessly in both light and dark themes without additional overrides.
