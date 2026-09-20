# HEBRING CSS Naming Convention

This document defines the official CSS naming convention for the HEBRING framework.

The system is designed to be:
- **Predictable**: Consistent patterns across all layers and element types.
- **Human-Readable**: Self-descriptive class names without cryptic abbreviations.
- **Framework-Scoped**: Strict namespacing to prevent collisions with application code or third-party styles.
- **Easy to Scan**: Clear visual distinctions between components, elements, modifiers, states, and utilities.

---

## 1. Framework Prefix

All framework-owned classes use the prefix:

```css
hb-
```

Examples:
- `hb-button`
- `hb-card`
- `hb-input`

The `hb-` prefix is strictly reserved for HEBRING's public CSS API. Do not use verbose alternatives such as `hebring-button`, `framework-button`, or `component-button`.

---

## 2. Component Naming

Components use the format:

```css
hb-{component}
```

- Component names use lowercase kebab-case.
- The name directly describes the UI component.

Examples:
- `hb-button`
- `hb-card`
- `hb-input`
- `hb-alert`
- `hb-badge`
- `hb-modal`

---

## 3. Component Modifiers / Variants

Modifiers and stylistic/sizing variants use a double hyphen (`--`):

```css
hb-{component}--{modifier}
```

Examples:
- `hb-button--primary`
- `hb-button--secondary`
- `hb-button--large`
- `hb-card--featured`

The double hyphen explicitly identifies a variant of a base component.

**Do NOT use**:
- `hb-button-primary` (indistinguishable from a compound component name)
- `hb-button_primary`
- `hb-button.mod-primary`

---

## 4. Component Elements

Internal elements that belong to a component use a double underscore (`__`):

```css
hb-{component}__{element}
```

Examples:
- `hb-card__header`
- `hb-card__body`
- `hb-card__footer`
- `hb-button__icon`

The double underscore indicates structural containment within a component. Elements are not standalone public components.

**Do NOT use deep element chains**:
- Avoid: `hb-card__header__title`
- If an element's internal structure grows complex enough to require multi-level nesting, that element should be extracted into a dedicated component.

---

## 5. States

State classes represent dynamic or interaction-driven conditions. They use:

```css
is-{state}
```
or, where semantically appropriate:
```css
has-{state}
```

Examples:
- `is-active`
- `is-open`
- `is-disabled`
- `is-invalid`
- `has-shadow`

### Important Rules for States:
- State classes are **intentionally NOT prefixed** with `hb-`.
- State naming is kept independent from component naming to allow standard semantic expression.

Usage examples:
```html
<button class="hb-button is-active">
<div class="hb-modal is-open">
<input class="hb-input is-invalid">
```

**Do NOT use**:
- `hb-is-active`
- `hb-button-is-active`

---

## 6. Utilities

Utility classes use the HEBRING prefix followed by the target property and value:

```css
hb-{property}-{value}
```

Examples:
- `hb-p-4` (padding)
- `hb-m-2` (margin)
- `hb-flex` (display: flex)
- `hb-grid` (display: grid)
- `hb-hidden` (display: none)
- `hb-text-center` (text-align: center)

Utilities represent single-purpose, atomic CSS behavior. The full utility vocabulary and scale will be designed in Phase 06.

---

## 7. Custom Properties (CSS Variables)

All HEBRING-owned CSS custom properties use the prefix:

```css
--hb-
```

Examples:
- `--hb-color-primary`
- `--hb-space-4`
- `--hb-radius-md`
- `--hb-font-family`

Design tokens will be formally introduced in Phase 03. All token definitions will adhere to this `--hb-` prefix.

---

## 8. HTML Semantic Elements

HEBRING does **NOT** require classes on every standard HTML element.

For example:
```html
<h1>Page Heading</h1>
<p>Introductory text...</p>
```
does **NOT** automatically require:
```html
<h1 class="hb-heading-1">
<p class="hb-paragraph">
```

Foundation and base layers style semantic HTML elements directly to provide sensible, accessible defaults. Component classes are applied when a distinct, reusable UI component is being represented.

---

## 9. Naming Style

All names in HEBRING use **lowercase kebab-case**:
- Components: `hb-button`
- Modifiers: `hb-button--primary`
- Elements: `hb-card__header`
- Utilities: `hb-text-center`
- Custom Properties: `--hb-color-primary`

**Do NOT use**:
- `HBButton` (PascalCase)
- `hb_Button` (Mixed snake/Pascal)
- `hbButton` (camelCase)
- `HB-BUTTON` (UPPERCASE)

---

## 10. Reserved / User Space

- The `hb-` namespace is strictly reserved for HEBRING.
- Application developers are free to use their own classes alongside HEBRING primitives without risk of collisions:

```html
<button class="hb-button hb-button--primary checkout-submit">
  Continue to Payment
</button>
```
