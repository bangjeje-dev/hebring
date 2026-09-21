# Components Guide

This guide explains HEBRING's component philosophy and documents the exact components provided by the framework.

## 1. What is a Component?

In HEBRING, a component represents a **reusable UI pattern** rather than a single CSS property.

The architectural distinction is strictly enforced:
- **Layout**: Dictates structural relationships (e.g., arranging items in a grid).
- **Utility**: Applies a small, isolated adjustment (e.g., adding padding).
- **Component**: Defines a complete, reusable UI pattern (e.g., an interactive button).

You use a component when a UI element requires complex, coordinated visual styling, multiple interaction states, and specific semantic HTML structure that would be unmaintainable to rebuild from utilities every time.

## 2. Component Philosophy

HEBRING components adhere to the following principles:
- **Reusable UI Pattern**: Designed for repeating elements.
- **Semantic HTML**: Built assuming standard, accessible HTML elements.
- **Framework Agnostic**: Pure CSS/HTML; no React/Vue/Svelte wrappers required.
- **CSS-First**: No JavaScript runtime dependency.
- **Native CSS Interaction States**: Components handle their own `:hover`, `:active`, `:focus-visible`, and `:disabled` states naturally.
- **Accessibility-Aware**: Components handle focus rings and disabled styling.
- **Composable**: Components fit cleanly inside Layout primitives and can be tweaked by Utilities.
- **Token-Aware**: Components consume semantic tokens (e.g., `--hb-color-primary`), making them automatically theme-compatible.
- **Meaningful Component APIs**: Variants use a BEM-like modifier syntax (`--modifier`).
- **State Selectors**: JavaScript-toggled states use standard `is-*` or `has-*` prefixes.
- **No `!important`**: Components live in the `@layer components` cascade layer, allowing utilities to override them safely.
- **No Premature Component-Token Architecture**: Components use local CSS variables for their internal logic rather than polluting the global `:root` scope with hundreds of component-specific design tokens.

## 3. Current Component Inventory

HEBRING intentionally maintains a minimal component footprint, focusing on essential patterns that are difficult to construct correctly from utilities alone.

Currently, the following components exist:
- **Button** (`.hb-button`)
- **Card** (`.hb-card`)
- **Badge** (`.hb-badge`)
- **Alert** (`.hb-alert`)
*Note: HEBRING is a CSS foundation, not an exhaustive UI toolkit. It does not ship with complex interactive widgets like accordions or modals that inherently require JavaScript.*

---

## 4. Button

The `.hb-button` component provides a fully styled, interactive, and accessible button element. By default, applying `.hb-button` creates a medium-sized primary button.

### Modifiers

Modifiers alter the visual intent or geometry of the button.

**Visual Variants:**
- `.hb-button` (Default Primary)
- `.hb-button--secondary` (Surface/Neutral)
- `.hb-button--danger` (Destructive actions)

**Size Variants:**
- `.hb-button--sm` (Small)
- `.hb-button--lg` (Large)

### States

**Native CSS States:**
The button natively supports standard interaction states without additional classes:
- `:hover`
- `:focus-visible` (Accessible focus ring)
- `:active`
- `:disabled`

**JavaScript-Toggled States:**
- `.is-loading`: Modifies cursor, reduces opacity, and disables `pointer-events`.

### Local Implementation Tokens

The button utilizes local CSS custom properties (e.g., `--hb-button-bg`, `--hb-button-padding-y`) scoped strictly to the `.hb-button` class. These local tokens dynamically map to global semantic tokens (like `--hb-color-primary`). 

This architecture allows modifiers (like `--danger`) to simply remap the local `--hb-button-bg` variable to `--hb-color-danger` internally, keeping the CSS extremely DRY and avoiding global token pollution.

## 5. Button HTML Examples

Below are the smallest useful examples demonstrating how to construct buttons using semantic HTML.

**Basic Primary Button:**
```html
<button class="hb-button" type="button">
  Primary Action
</button>
```

**Secondary Link Button:**
```html
<a href="#" class="hb-button hb-button--secondary">
  Cancel
</a>
```

**Destructive Action:**
```html
<button class="hb-button hb-button--danger" type="button">
  Delete Account
</button>
```

**Small Size Variant:**
```html
<button class="hb-button hb-button--sm" type="button">
  Tiny Action
</button>
```

**Disabled State:**
```html
<button class="hb-button" type="button" disabled>
  Cannot Click
</button>
```

**Loading State:**
```html
<button class="hb-button is-loading" type="button">
  Submitting...
</button>
```

---

## 6. Card

The `.hb-card` component provides a foundational structural container. It is a compositional UI component designed to hold content, not a layout primitive.

### Anatomy
A Card uses optional child elements to structure content:
- `.hb-card` (Container)
- `.hb-card__header` (Optional top section)
- `.hb-card__body` (Main content area, fills available space)
- `.hb-card__footer` (Optional bottom section)

### CSS API
The Card consumes semantic tokens (`--hb-color-surface`, `--hb-color-border`) mapping them to local variables.

### HTML Example
```html
<article class="hb-card">
  <header class="hb-card__header">
    <h3 class="hb-text-lg">Card Title</h3>
  </header>
  <div class="hb-card__body">
    <p>This is the main content of the card.</p>
  </div>
  <footer class="hb-card__footer">
    <button class="hb-button hb-button--sm">Action</button>
  </footer>
</article>
```

### Accessibility & Responsive Behavior
- **Accessibility**: Cards typically do not require specific ARIA roles unless acting as an interactive widget or article. Use semantic HTML like `<article>`, `<header>`, and `<footer>` where appropriate.
- **Responsive**: Cards are fluid and adapt to their container (`display: flex`). Use layout primitives (e.g. `.hb-grid`) to arrange multiple cards responsively.
- **Theme**: Automatically inherits dark mode via semantic surface and border tokens.

---

## 7. Badge

The `.hb-badge` component is a compact, non-interactive semantic indicator often used for statuses, counts, or tags.

### Variants
Badges provide semantic color variants:
- `.hb-badge` (Default/Neutral)
- `.hb-badge--primary`
- `.hb-badge--success`
- `.hb-badge--warning`
- `.hb-badge--danger`

### CSS API
Badges use `inline-flex` and consume subtle semantic background tokens paired with strong semantic text tokens to ensure readability.

### HTML Example
```html
<span class="hb-badge hb-badge--success">Completed</span>
```

### Accessibility
- Non-interactive by default. Do not use `<button>` unless extending functionality with JavaScript.
- If used for counts, ensure context is available to screen readers (e.g. via visually hidden text).

---

## 8. Alert

The `.hb-alert` component provides semantic feedback or state presentation to the user.

### Variants
Alerts provide contextual color variants using subtle backgrounds and bordered edges:
- `.hb-alert` (Default)
- `.hb-alert--info`
- `.hb-alert--success`
- `.hb-alert--warning`
- `.hb-alert--danger`

### HTML Example
```html
<div class="hb-alert hb-alert--danger" role="alert">
  <strong>Error:</strong> Failed to save changes.
</div>
```

### Accessibility
- Use `role="alert"` for important and time-sensitive feedback.
- Do not rely on color alone; ensure the text explicitly states the meaning or include an explicit icon in the HTML.
- Colors mapped directly to semantic tokens to guarantee contrast ratios.
