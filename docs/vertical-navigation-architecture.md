# Vertical Navigation Architecture

## 1. Purpose

The Vertical Navigation component provides a structured, accessible, and deep navigation pattern typically found in application sidebars, admin dashboards, and documentation layouts. It is responsible for organizing hierarchical links and actions.

It supports:
- Sectioned navigation groups (e.g., "Commerce", "System").
- Top-level flat navigation items.
- Nested, expandable/collapsible navigation trees.
- Active states (`aria-current`).
- Optional structural integrations for icons and badges.
- Accessible keyboard interaction and focus states.
- Responsive integration by template consumers.

It remains entirely framework-agnostic, zero-runtime dependent, and avoids polluting HEBRING Core.

## 2. Boundary

**Vertical Navigation owns:**
- The structural CSS and semantic presentation of nested links.
- Expand/collapse styling patterns.
- Active item token inheritance.
- Group labeling styling.

**Vertical Navigation does NOT own:**
- Sidebar width, placement, or off-canvas responsive toggling (owned by Application Shell / `.admin-shell`).
- Application branding or logos (owned by Template).
- Dashboard macro-layout, content, or routing logic.
- Framework-specific JS or complex state management.

## 3. Proposed DOM Contract

The component employs semantic HTML built around `<nav>` and unordered lists, heavily aligned with native accessibility patterns.

```html
<nav class="hb-vertical-nav" aria-label="Main Navigation">
  
  <!-- Navigation Group -->
  <div class="hb-vertical-nav__group">
    <div class="hb-vertical-nav__label" id="nav-commerce">Commerce</div>
    
    <ul class="hb-vertical-nav__list" aria-labelledby="nav-commerce">
      <!-- Standard Item -->
      <li class="hb-vertical-nav__item">
        <a href="#" class="hb-vertical-nav__link">
          <svg class="hb-vertical-nav__icon">...</svg>
          <span class="hb-vertical-nav__text">Orders</span>
          <span class="hb-badge">New</span>
        </a>
      </li>

      <!-- Nested / Expandable Group -->
      <li class="hb-vertical-nav__item hb-vertical-nav__item--expandable">
        <button class="hb-vertical-nav__link" aria-expanded="false" aria-controls="sub-products">
          <svg class="hb-vertical-nav__icon">...</svg>
          <span class="hb-vertical-nav__text">Products</span>
          <svg class="hb-vertical-nav__chevron">...</svg>
        </button>
        
        <ul class="hb-vertical-nav__list hb-vertical-nav__list--nested" id="sub-products" hidden>
          <li class="hb-vertical-nav__item">
            <a href="#" class="hb-vertical-nav__link">All Products</a>
          </li>
          <li class="hb-vertical-nav__item">
            <a href="#" class="hb-vertical-nav__link" aria-current="page">Inventory</a>
          </li>
        </ul>
      </li>
    </ul>
  </div>

</nav>
```

## 4. Navigation Item Model

- **Simple Item**: An `<a>` styled with `.hb-vertical-nav__link`.
- **Expandable Parent**: A `<button>` styled with `.hb-vertical-nav__link`, carrying `aria-expanded` and `aria-controls`. Contains a trailing chevron indicator.
- **Child Item**: Placed within a `.hb-vertical-nav__list--nested`, indented visually to represent depth hierarchy.
- **Active Item**: Indicated natively via `[aria-current="page"]` on links.
- **Disabled Item**: Utilizes `disabled` on `<button>` or `[aria-disabled="true"]` on `<a>`, lowering opacity and removing pointer events.
- **Item with Badge/Icon**: Leverages standard flexbox composition inside the link to handle spacing.

## 5. Accessibility Contract

- **Nav Landmark**: Root element must be `<nav>` with a unique `aria-label`.
- **Lists**: Uses `<ul>` and `<li>` to communicate hierarchy to screen readers.
- **Active State**: Must use `aria-current="page"`, not a custom class.
- **Collapsible State**: Parent triggers must use `aria-expanded="true/false"` and `aria-controls="[id]"`.
- **Semantics**: Links are `<a>`. Items that only expand/collapse menus are `<button>`s. Do NOT use `href="#"` for toggle triggers.
- **Focus**: Standard `focus-visible` styling using `outline` and `outline-offset` aligned with HEBRING global standards.

## 6. Interaction Contract

HEBRING remains a CSS framework. The interaction is progressively enhanced.

- **No-JS Baseline**: All `.hb-vertical-nav__list--nested` elements are visible by default, acting as a flat list. Alternatively, CSS-only techniques (`:target` or `<details>/<summary>`) can be used if semantic constraints permit, though `<button aria-expanded>` with minimal JS is preferred for rich applications.
- **JS Enhancement**: A minimal vanilla JS script (provided in the template) targets `aria-expanded` to toggle the `hidden` attribute on nested lists.
- **Mobile Behavior**: The component naturally scales to 100% width of its parent container. Off-canvas sliding is handled outside the component by the template layout.

## 7. Visual State Contract

- **Default**: Transparent background, text colored by `var(--hb-color-text-subtle)`.
- **Hover**: Background shifts to `var(--hb-color-surface-muted)`, text color sharpens to `var(--hb-color-text)`.
- **Focus-Visible**: Inherits standard HEBRING focus ring (2px solid primary, offset).
- **Active (`aria-current="page"`)**: Background shifts to `var(--hb-color-primary-muted)` or `var(--hb-color-primary)`, text to matching contrast token.
- **Expanded**: Parent button maintains hover-like state, chevron rotates 180deg.
- **Disabled**: `opacity: 0.5`, `cursor: not-allowed`.

## 8. Responsive Contract

- **Desktop Sidebar**: Component takes up 100% width of the fixed sidebar.
- **Compact Sidebar (Icon-Only)**: Handled by a parent container class (e.g., `.admin-sidebar--compact`) that hides text and repositions popovers, or by native `container-queries` inside Ecosystem UI if universally adopted.
- **Mobile Off-Canvas**: Fills the mobile drawer width natively without structural changes.

## 9. Composition

The component composes seamlessly with existing HEBRING primitives:
- `hb-badge`: Placed inside `.hb-vertical-nav__link` directly. Flexbox (via `justify-content: space-between` logic) aligns the text and badge.
- Icons: Rendered directly inside `.hb-vertical-nav__link`, utilizing `currentColor`.
- The internal structure behaves similarly to a localized `hb-cluster` but optimized specifically for vertical navigation constraints.

## 10. Naming

- Block: `hb-vertical-nav`
- Elements: `__group`, `__label`, `__list`, `__item`, `__link`, `__icon`, `__text`, `__chevron`.
- Modifiers: `--nested`, `--expandable`.

Follows standard BEM-like convention used in `hb-navigation-menu`.

## 11. Ecosystem Boundary

This component explicitly belongs in **Ecosystem UI** (`ecosystem/ui/vertical-nav.css`), NOT HEBRING Core.
- Core focuses on agnostic primitives (`button`, `card`, `grid`).
- Vertical Navigation represents a complex, multi-part, domain-specific pattern (Admin UI, Documentation UI) combining state, accessibility, and structural requirements. It is a pre-composed solution, not a low-level primitive.

## 12. Admin Dashboard Consumer

The Admin Dashboard template will replace its local custom navigation classes (`.admin-nav-link`, etc.) with `hb-vertical-nav`.

```html
<!-- ecosystem/templates/admin-dashboard/index.html (Future state) -->
<aside class="admin-sidebar">
  <div class="admin-sidebar-logo">HEBRING</div>
  
  <!-- Reusable Ecosystem Component -->
  <nav class="hb-vertical-nav" aria-label="Main">
    <div class="hb-vertical-nav__group">
      <div class="hb-vertical-nav__label">Workspace</div>
      <ul class="hb-vertical-nav__list">
        ...
      </ul>
    </div>
  </nav>
</aside>
```
The template still owns the sidebar width, logo, and toggle logic.

## 13. Validation Criteria

Before implementation can begin, the architecture must pass:
1. **Semantic HTML**: Fully supports `<nav>`, `<ul>`, `<li>`, `<button>`, `<a>`.
2. **Accessibility**: `aria-current`, `aria-expanded`, and focus visibility are architecturally defined.
3. **No Core Pollution**: Component remains strictly in Ecosystem UI.
4. **No Framework Dependency**: Operates without React, Vue, or heavy JS dependencies.
5. **Theme Compatibility**: Fully maps to `var(--hb-color-*)` semantic tokens.
