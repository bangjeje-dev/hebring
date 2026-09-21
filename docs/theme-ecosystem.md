# HEBRING Theme Ecosystem Architecture

## 1. Theme Ecosystem Philosophy
The HEBRING Theme Ecosystem exists to allow developers to rapidly and safely apply distinct visual identities to HEBRING Core and UI components without forking the framework. Themes exist as an independent Ecosystem layer; they extend HEBRING's presentation but never modify the Core engine or require structural overrides.

## 2. Core Theme vs Ecosystem Theme
- **Core Theme Capability**: The intrinsic ability of HEBRING to support themes via its primitive and semantic token architecture (e.g., the built-in dark mode mapping via `[data-theme="dark"]`).
- **Ecosystem-Distributed Theme**: An external, self-contained CSS asset that selectively maps semantic tokens to new values to create a cohesive new aesthetic, distributed independently from Core.

## 3. Theme Contract
A valid HEBRING theme must operate exclusively by overriding semantic CSS custom properties defined in `:root` or `[data-theme]`. It must not introduce arbitrary classes (like `.bg-red`), override component-level CSS (like `.hb-button { ... }`), or modify HTML structure.

## 4. Primitive vs Semantic Tokens
**Rule:** Themes should exclusively override **Semantic Tokens** (e.g., `--hb-color-primary`, `--hb-color-surface`).
Themes should **NOT** redefine Primitive Tokens (e.g., `--hb-color-blue-500`). Redefining primitives breaks the predictable color palette that other utilities and components might rely on.

## 5. Theme Scope
Themes are permitted to customize:
- Brand colors (primary, semantic text)
- Status colors (success, warning, danger, info)
- Surfaces and backgrounds
- Borders
- Focus indicators
- Semantic typography (heading vs body font families)
- Shared geometry (radii, shadows)

Themes must NOT alter:
- Core Layout primitives (grid, stack)
- Z-index scales
- CSS Reset properties
- Responsive breakpoints

## 6. Component Compatibility
HEBRING Core and UI components consume semantic tokens via local component variables. Because they rely entirely on the semantic token layer, components automatically adopt any valid theme applied to their context without requiring component-specific CSS overrides (e.g., no need to write `.hb-button[data-theme="mint"]`).

## 7. Theme Naming
Themes use a predictable naming convention extending the existing data attribute mechanism:
`[data-theme="theme-name"]`
Arbitrary naming schemes or root-level class hooks (e.g., `.theme-mint`) are prohibited to ensure ecosystem consistency.

## 8. Theme Activation
Themes are activated via the `data-theme` attribute natively in HTML:
```html
<html data-theme="ocean">
<!-- or scoped -->
<div data-theme="ocean">
```
No JavaScript runtime, React context, or CSS-in-JS provider is required to activate a theme.

## 9. Theme Composition
HEBRING themes naturally inherit via the CSS cascade.
- Nested themes override parent themes seamlessly (e.g., `<html data-theme="dark">` containing a `<div data-theme="light">`).
- Multiple themes can coexist in the same DOM tree without conflicting, provided they correctly scope their `[data-theme]` selectors.

## 10. Theme Independence
A theme must be a pure CSS asset. It must NEVER require JavaScript, React, Vue, or any specific application framework to function. It relies entirely on native CSS Custom Properties.

## 11. UI Theme Integration
Future HEBRING UI components (and existing ones like Card, Badge, Alert) will consume ecosystem themes inherently. Because they map local variables to semantic tokens (e.g., `--hb-card-bg: var(--hb-color-surface)`), they require zero modifications or explicit theme integrations to support new themes.

## 12. Icon Theme Integration
HEBRING Icons automatically support the theme ecosystem via the `currentColor` SVG property. Icons inherit the surrounding text color (controlled by the theme's semantic tokens) and never contain theme-specific color definitions.

## 13. Theme Package Boundary
Ecosystem themes belong to a conceptual `@hebring/themes` package boundary.
For now, they may exist as source files (e.g., `src/themes/`), but structurally, they represent an optional consumer dependency rather than a Core requirement.
`@hebring/themes` → optional dependency of Consumer (never imported by `@hebring/core`).

## 14. Built-in vs Community Themes
- **Built-in Themes**: Officially maintained themes (like the default light/dark) guaranteeing exact contrast ratios and long-term support.
- **Community Themes**: Third-party themes conforming to the Theme Contract, distributed independently. HEBRING provides the contract, but will not operate a centralized marketplace.

## 15. Theme Authoring
To create a theme, a developer simply maps semantic tokens to desired primitive (or raw) values within a `data-theme` selector:
```css
/* Minimal Authoring Example */
[data-theme="mint"] {
  --hb-color-primary: var(--hb-color-teal-600);
  --hb-color-primary-hover: var(--hb-color-teal-700);
  --hb-color-primary-subtle: var(--hb-color-teal-50);
  --hb-color-on-primary: var(--hb-color-white);
  --hb-color-surface: var(--hb-color-white);
}
```
No component rewriting is necessary.

## 16. Theme Validation
A theme is considered valid if it:
1. Conforms to the token contract (overrides semantic tokens).
2. Uses the `[data-theme="..."]` naming convention.
3. Contains no hardcoded component overrides (e.g., `.hb-button { ... }`).
4. Requires no JavaScript dependency.
5. Maintains accessibility (sufficient contrast between background/surface and text/on-status tokens).

## 17. Theme Testing
Future automated theme tests must validate:
- **Semantic Coverage**: Does the theme override the expected subset of tokens?
- **Component Independence**: Are there any illegal component class selectors?
- **Inheritance**: Do variables cascade correctly within nested `data-theme` boundaries?

## 18. Documentation Requirements
Every published theme must document:
- Name and Purpose
- Visual Intent (e.g., "A high-contrast monochrome aesthetic")
- Supported Tokens
- Activation Method (`<html data-theme="...">`)
- Accessibility Considerations (e.g., contrast warnings if any)
- Minimal Usage Example

## 19. Theme Contribution Rules
Future HEBRING-maintained themes must adhere to the validation checklist and ensure strict contrast ratio compliance for WCAG AA standard on all surface/text pairings. They must not introduce new tokens into the global semantic registry; they must only consume existing ones.

## 20. Definition of Done
The Theme Ecosystem Architecture is complete when:
- This document is approved and merged.
- Core remains entirely independent of the Theme Ecosystem.
- UI and Icons are proven to seamlessly inherit contextual semantic overrides without modifications.
