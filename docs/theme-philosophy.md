# Theme Philosophy

Phase 09 establishes the Theme architecture for HEBRING. This document defines the philosophical principles, architectural boundaries, and mechanics of the theme system.

## 1. Core Theme Principle

**A Theme is a contextual mapping of HEBRING semantic design tokens to a coherent visual system.**

The architecture follows a strict one-way dependency chain:
1. **Primitive Tokens**: Context-agnostic raw values (e.g., `#2563EB`).
2. **Semantic Tokens**: Intent-driven roles (e.g., `--hb-color-primary`).
3. **Theme Mapping**: Contextual overrides of semantic tokens.
4. **Components / Layout / Utilities**: Consumers of semantic tokens.

Themes modify **semantic token values**. They do NOT replace or redefine primitive tokens.

## 2. Semantic Tokens Are the Theme Boundary

Themes operate exclusively at the semantic token layer. A theme may remap semantic roles such as `background`, `surface`, `text`, `border`, `primary`, `status`, `focus`, and `semantic typography`. 

Components continue consuming the same semantic token (e.g., `var(--hb-color-background)`). The component does not need to know which theme is active, allowing components to adapt automatically without requiring theme-specific CSS modifications.

## 3. Primitive Token Stability

Primitive tokens are foundational values and must remain completely stable. Themes must **never** redefine the primitive token architecture. 

For example, do NOT write rules like:
```css
[data-theme="dark"] {
  --hb-color-blue-600: ...;
}
```
Using themes as a mechanism to mutate the primitive palette is prohibited.

## 4. The Data Attribute Mechanism

The official HEBRING theme selector mechanism is the `data-theme` attribute:

```html
<html data-theme="dark">
<section data-theme="brand">
```

- The mechanism is strictly attribute-based.
- Do NOT use `.dark`, `.theme-dark`, or other classes as the official API.
- The attribute model scales elegantly to support arbitrary named themes.

## 5. Default Theme Behavior

The base/root semantic token mapping represents the **default theme**.
The default HEBRING theme must work perfectly out of the box without requiring `data-theme="light"`.

A simple HTML document:
```html
<html>
```
must produce a valid HEBRING visual system. This ensures the framework is usable without requiring explicit theme configuration.

## 6. Theme Nesting and Local Scope

Themes are selector-based and cascade naturally through the DOM. This allows them to be applied at different scopes:
- Page-level themes (`<html data-theme="dark">`)
- Section-level themes (`<section data-theme="brand">`)
- Component-area themes or embedded application themes

A descendant theme overrides the semantic tokens for its specific subtree.

## 7. Themes Are Not "Dark Mode" Only

HEBRING's theme architecture is broader than dark mode. "Dark" is only one possible theme. The system is designed to support:
- Light variations
- Dark variations
- Brand themes
- High-contrast themes
- Product or context-specific application themes

## 8. Theme Switching is an Application Concern

HEBRING CSS defines how themes are represented and consumed. HEBRING core **does NOT own theme switching behavior**. 

The framework does NOT introduce:
- JavaScript theme switchers
- `localStorage`, cookies, or system theme detection (`prefers-color-scheme` logic in JS)
- Event listeners or DOM manipulation

Applications have full freedom to decide how and when to change the `data-theme="..."` attribute.

## 9. Component Independence

Components must remain completely theme-agnostic. 
Do NOT introduce theme-specific component selectors like `[data-theme="dark"] .hb-button`. 

The official flow is:
1. Theme changes semantic token.
2. Component consumes semantic token.
3. Component automatically adapts.

## 10. Utility and Layout Independence

- **Utilities**: Utilities operate on their existing properties and remain independent of themes. Do NOT create theme-specific utility classes (e.g., `hb-dark-block`). 
- **Layouts**: Layout primitives (`hb-container`, `hb-stack`, etc.) manage structural intent. Theme changes should not alter their semantic purpose or structure.

## 11. CSS-Only Architecture

Theme support remains CSS-native, relying solely on CSS custom properties, attribute selectors, and normal cascade behavior. No JavaScript runtime is required.

## 12. Accessibility Boundaries

Themes must consider accessibility by preserving:
- Readable text/background contrast
- Visible focus indication
- Usable interactive states
- Semantic meaning independent of visual styling

## 13. Framework-Agnostic Principle

Theme architecture works with plain HTML/CSS and does not depend on JavaScript frameworks (React, Vue, Svelte, etc.) or utility engines (Tailwind).

## 14. Custom Application Themes (Escape Hatch)

HEBRING allows applications to define their own custom themes using the exact same semantic token model without modifying the framework core.

```css
[data-theme="my-brand"] {
  --hb-color-primary: var(--hb-color-emerald-500);
}
```
The framework provides the architecture, rather than an exhaustive theme marketplace.

## 15. Naming and Exclusions

- **Theme Naming**: The architecture supports arbitrary semantic names (e.g., `dark`, `brand`). It does not require theme names to represent color modes.
- **Cascade Boundary**: Theme mappings function as contextual token overrides. Do NOT create a separate `@layer themes` cascade layer.
- **Responsive Separation**: Themes and responsive breakpoints are separate concerns. Do not introduce responsive theme names (e.g., `dark-md`) or theme breakpoints.
- **Component Tokens**: Existing component tokens remain implementation-level wiring and are not the primary mechanism for theming.
- **Motion**: Themes do not control motion. Do not introduce transitions for theme switching in the CSS core.

## Explicit Non-Goals for Phase 09.1

- Implementing a dark, light, or brand theme.
- Modifying semantic or primitive token values.
- Modifying component or utility CSS.
- Adding JavaScript, theme switching logic, or system preference detection.
- Adding framework-specific APIs, `@layer themes`, responsive themes, or theme-specific component/utility classes.
