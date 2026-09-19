# Theme Token Mapping

Phase 09.3 defines the mapping principles for HEBRING themes. This document outlines which existing semantic tokens are expected to change across themes, which remain stable, and how future built-in themes (e.g., dark mode) should approach these mappings.

## 1. Purpose

The core principle of HEBRING theming is:
`Primitive tokens → Semantic tokens → Theme mapping`

Themes override semantic token values. Themes **MUST NOT** override primitive tokens as their normal architecture. A theme changes the semantic interpretation of a visual role (e.g., "what is the background color?"), not the primitive design foundation (e.g., "what is blue-600?").

## 2. Semantic Token Inventory & Classification

Based on the official `src/tokens/semantic.css`, the following is the complete inventory of HEBRING semantic tokens and their expected behavior across themes.

### A. Themeable Tokens

These semantic roles are fundamentally tied to the visual lightness/darkness of the UI and are expected to change in almost every built-in theme (such as Dark Mode).

**Background Roles**
- `--hb-color-background`
- `--hb-color-background-subtle`

**Surface Roles**
- `--hb-color-surface`
- `--hb-color-surface-raised`
- `--hb-color-surface-muted`

**Text Roles**
- `--hb-color-text`
- `--hb-color-text-muted`
- `--hb-color-text-subtle`
- `--hb-color-text-disabled`

**Border Roles**
- `--hb-color-border`
- `--hb-color-border-strong`

**Status Roles**
- `--hb-color-success`, `--hb-color-success-subtle`, `--hb-color-on-success`
- `--hb-color-warning`, `--hb-color-warning-subtle`, `--hb-color-on-warning`
- `--hb-color-danger`, `--hb-color-danger-subtle`, `--hb-color-on-danger`
- `--hb-color-info`, `--hb-color-info-subtle`, `--hb-color-on-info`

**Focus Role**
- `--hb-color-focus`

*Reason*: In a dark theme, backgrounds become dark, text becomes light, borders become dark, and status/focus colors often need to shift to lighter primitive steps (e.g., 400 or 500) to maintain WCAG AA contrast against dark surfaces. Therefore, these are highly themeable.

### B. Context-Dependent Tokens

These roles may be themed depending on the specific goal of the theme (e.g., a "brand" theme), but they might remain stable between Light and Dark themes if the default primitive value has sufficient contrast on both.

**Primary Brand & Action Roles**
- `--hb-color-primary`
- `--hb-color-primary-hover`
- `--hb-color-primary-active`
- `--hb-color-primary-subtle`
- `--hb-color-on-primary`

*Reason*: A dark theme may optionally remap `--hb-color-primary` from `blue-600` to a lighter `blue-500` if `blue-600` fails contrast on dark surfaces. A brand theme will entirely replace these tokens with a custom brand palette. Thus, they are context-dependent.

### C. Stable Tokens

These tokens govern structural or brand-independent semantics and should remain unchanged across standard built-in themes.

**Semantic Typography**
- `--hb-font-family-body`
- `--hb-font-family-heading`
- `--hb-font-family-code`

*Reason*: Built-in themes (like Dark mode) adjust color and contrast, not layout or typography. For standard built-in themes, typography remains strictly stable.

---

## 3. Mapping Principles

### Color Semantics and Text/Background Relationships
A theme changes the value, not the meaning. For example, `--hb-color-background` continues to mean "the primary application background" regardless of the theme. 

When remapping colors, themes must preserve semantic usability. The relationship between `background`, `surface`, `text`, and `border` must remain coherent and accessible as a unified group.

### Primary Role
The primary tokens represent the main brand/action color. Themes may change their primitive mapping while preserving this exact meaning. The framework does NOT use theme-specific names like `--hb-color-dark-primary`. The token is always `--hb-color-primary`.

### Status Roles
Status semantics (Success, Warning, Danger, Info) must remain semantically recognizable across themes. A dark theme may map `--hb-color-danger` to a lighter red primitive to ensure it is readable on a dark background, but it remains a danger indicator. Do not invent theme-specific names like `--hb-color-dark-danger`.

### Focus Role
Themes may remap the focus token, but the resulting value must continue to provide an appropriate, highly visible focus indication that contrasts sufficiently with the themed background.

### Typography and Motion Roles
The current architecture includes Typography roles, which are classified as Stable. There are currently no Motion semantic tokens. If added in the future, motion semantics should also remain Stable across visual themes.

### Component-Token Relationship
Theme mapping operates strictly on semantic tokens. Components consume these semantic tokens directly (or via optional local component variables). Themes must NOT create a global theme-specific component-token layer (e.g., `--hb-dark-button-bg` is prohibited). 

## 4. Built-in Theme Expectations (Future Dark Theme)

While actual themes are not implemented in this phase, future built-in themes (such as a Dark Theme) must follow this architectural rule:

**A dark theme should remap semantic tokens according to their semantic roles rather than mechanically inverting primitive colors.**

Do not use an automatic inversion algorithm (e.g., `white → black`). Instead:
- `background` maps to an appropriate dark background primitive.
- `surface` maps to an appropriate dark surface primitive.
- `text` maps to an appropriate light text primitive.

## 5. Primitive Token Stability

Theme implementations are explicitly prohibited from redefining primitive tokens as part of their normal architecture.

**Forbidden:**
```css
[data-theme="dark"] {
    --hb-color-blue-600: #...; /* NEVER do this */
}
```
The primitive token system remains globally stable. Themes consume the existing primitive palette through semantic mappings.

## 6. Token Fallback and Inheritance

A theme does NOT need to map every single semantic token. Partial themes are officially supported.
The fallback model is purely CSS-based:
1. The Root semantic token provides the default.
2. A Theme overrides selected semantic tokens.
3. Unmapped semantic tokens continue to inherit from the default/root.
4. A nested theme may override selected tokens, while unmapped tokens continue inheriting from the parent theme.

## 7. Naming Rules

Do NOT create theme-prefixed token names. 
- **Forbidden**: `--hb-theme-dark-background`, `--hb-dark-background`, `--hb-light-text`
- **Correct**: Use the existing semantic token name (e.g., `--hb-color-background`) inside a theme selector context.

## 8. Accessibility Requirements

Every future theme implementation must evaluate and preserve:
- Foreground/background usability (WCAG contrast ratios)
- Focus visibility
- Status distinction
- Interactive state visibility

Accessibility is an intrinsic requirement of the theme mapping process, not a separate token system.

## 9. Application Extension

Applications can override semantic tokens using their own themes without modifying HEBRING core.

```css
[data-theme="my-product"] {
    --hb-color-primary: var(--hb-color-emerald-600);
}
```
This is the official extension model. It requires zero changes to components, utilities, layout, or primitive token definitions.

## 10. Explicit Non-Goals

Phase 09.3 explicitly does NOT:
- Implement any actual theme CSS (Dark, Light, Brand).
- Choose actual dark/light palette values.
- Change any primitive or semantic token values.
- Add new semantic tokens or rename existing ones.
- Modify components, utilities, layout, or package exports.
- Add JavaScript, theme switching, or `@layer themes`.
- Create theme-specific component tokens or a theme registry.
