# Theme Architecture

Phase 09.2 establishes the concrete architecture through which HEBRING themes will override semantic tokens.

## 1. Architectural Goal

The theme architecture structurally defines how HEBRING themes override semantic tokens. It establishes the default source of truth, selector mechanisms, inheritance behaviors, specificity policies, and the application extension model, without defining the actual theme token palettes.

## 2. Source of Truth

The existing semantic token definitions (`src/tokens/semantic.css`) remain the default source of truth. The theme architecture does NOT duplicate the entire semantic token system.

The root/default mapping represents the baseline HEBRING visual system. A theme only overrides the semantic variables whose values differ from the default, allowing for partial themes and future extensibility.

## 3. Official Theme Selector

The official selector mechanism for HEBRING is the data attribute:
`[data-theme="<name>"]`

Examples:
- `[data-theme="dark"]`
- `[data-theme="brand"]`

Do NOT use `.dark`, `.theme-dark`, `[data-mode="dark"]`, or `[data-color-scheme="dark"]` as the official API.

## 4. Theme Name Semantics

Theme names are arbitrary identifiers. The architecture does not reserve a fixed theme registry, a hardcoded list of themes, or an enum. Applications may define any theme name.

## 5. Root Default Behavior

An HTML document without a `data-theme` attribute automatically receives the default theme represented by the base/root semantic token declarations.

`<html>` is perfectly valid. No explicit `data-theme="light"` is required for baseline behavior.

## 6. Root-Level Themes

A theme may be applied at the document scope (`<html data-theme="dark">`). The theme selector overrides semantic tokens for the document subtree, and all descendants inherit these values unless overridden by a more local theme.

## 7. Local Theme Scope

A theme may be applied to any suitable DOM subtree (e.g., `<section data-theme="brand">`). Elements outside the subtree continue using their inherited theme. This allows for page-level, section-level, or application-shell themes managed by normal DOM inheritance without JavaScript scope management.

## 8. Nested Themes

Nested themes are officially supported. A nested theme is a partial override:
- Explicitly overridden semantic tokens use the nested theme's value.
- Semantic tokens not overridden continue inheriting from the outer context.

## 9. Cascade Model

Theme behavior relies strictly on CSS custom property inheritance, attribute selectors, and normal CSS cascade. No special theme runtime or custom cascade management is required.

## 10. Selector Specificity

Theme selectors must remain simple (e.g., `[data-theme="dark"]`). Do not introduce unnecessarily specific selectors (e.g., `html[data-theme="dark"] body`) and avoid `!important`. Declarations target the semantic variables at the theme scope itself.

## 11. Token-Only Theme Declarations

Theme implementations should primarily contain semantic custom-property overrides. Do NOT place component styles (e.g., `[data-theme="dark"] .hb-button`) inside theme selectors.

## 12. Theme Architecture and Cascade Layers

Themes do NOT belong to a separate cascade layer. No `@layer themes` is introduced. Mappings are contextual token overrides and stay outside the existing framework cascade-layer sequence.

## 13. Intended Theme Source Architecture

The intended source architecture places themes under the tokens domain to associate mappings conceptually with the token system:
```text
src/tokens/
├── index.css
├── primitives.css
├── semantic.css
└── themes/
    └── index.css
```
*Note: This structure is architectural intent; no implementation files are created in this phase.*

## 14. Token Dependency Direction

Themes preserve the strict token dependency direction:
`primitives` → `semantic` → `themes`

Themes may override semantic properties, but they must NOT import components, utilities, layout, or JavaScript. No circular dependencies are allowed.

## 15. Component Consumption Model

Components consume semantic tokens. When a theme changes a semantic value, the component remains unchanged and automatically adapts. No theme-specific component variants (e.g., `hb-button--dark`) are created.

## 16. Utility Consumption Model

Utilities remain completely independent of theme selectors. No theme-specific utilities (e.g., `hb-bg-dark`) are introduced.

## 17. Layout Consumption Model

Layout primitives do not consume theme state, and their structural behavior remains completely unchanged (e.g., no `hb-grid--dark`).

## 18. Partial Theme Overrides

Themes may override only a subset of semantic tokens. Other semantic tokens continue to inherit from the parent or default context. Complete semantic token duplication is not required.

## 19. Fallback / Inheritance Model

The fallback behavior operates entirely through CSS inheritance:
1. Default semantic token exists at root.
2. Theme overrides token at a scope.
3. Descendants inherit the override.
4. Nested theme may override the same token.
5. If the nested theme does not define a token, the inherited outer value remains active.
6. When leaving the nested scope, the outer value becomes active again.

## 20. Theme Precedence

Theme precedence is conceptual: the nearest applicable theme scope wins for a given semantic token. There is no numerical priority system or theme ranking.

## 21. Responsive Separation

Theme architecture and responsive architecture are completely independent. No responsive theme classes or viewport-dependent theme mappings are introduced.

## 22. Accessibility Architecture

The architecture allows future themes to maintain accessible contrast, focus indicators, and semantics. The architecture does not encode accessibility assumptions into theme names (e.g., no `[data-theme="accessible"]`).

## 23. Application Extension

Applications can define custom themes (e.g., `[data-theme="my-product"]`) simply by declaring semantic overrides in their own CSS. The HEBRING core does not need modification.

## 24. No Theme Registry

HEBRING core does not maintain a runtime, CSS registry, enum, or JavaScript manager of themes. The CSS attribute itself is the identifier.

## 25. Source / Build Boundary

The theme architecture is part of the token system. The build system, package exports, and package metadata remain unmodified.

## 26. Explicit Non-Goals

Phase 09.2 MUST NOT:
- Implement dark/light/brand themes or define theme colors.
- Change semantic/primitive token values or create actual theme CSS mappings.
- Modify components, utilities, layout, package exports, or JavaScript.
- Add theme switching, `@layer themes`, responsive theme behavior, a theme registry, or configuration APIs.
