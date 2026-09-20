# Built-in Themes

HEBRING intentionally provides a minimal set of built-in themes to serve as the foundation for the visual system. A theme in HEBRING is a contextual visual mapping of semantic tokens to primitive values, rather than a separate framework or a parallel token system.

## 1. Built-in Theme Overview

HEBRING supports exactly two official built-in themes:
1. **Default (Root)**: The baseline semantic token mapping.
2. **Dark**: A semantic dark mode mapping.

HEBRING does not provide built-in "Brand", "High Contrast", or "Solarized" themes. Applications are encouraged to define custom themes using the standard extension model.

### Design Principle
> "Built-in themes change semantic visual relationships, not the HEBRING design language."

The Dark theme continues to use the existing primitive palette, semantic roles, typography, component architecture, and utility architecture. It is a contextual visual mapping, not a second framework.

## 2. Default / Root Theme

The current root semantic token mapping (`:root` in `src/tokens/semantic.css`) is the official Default theme.
It serves as the fallback when no `data-theme` attribute is present.

- **Selector**: `:root`
- **Requirement**: Does NOT require `data-theme="light"` on the HTML element.

## 3. Dark Theme

HEBRING's first alternate built-in theme is the Dark theme.
The Dark theme is a **semantic remapping**. It does not mechanically invert colors (e.g., swapping black and white). Instead, it reasons by semantic role (e.g., mapping `background` to a dark primitive, and `text` to a light primitive) to establish a coherent, accessible dark UI hierarchy.

- **Selector**: `[data-theme="dark"]`
- **Requirement**: MUST use the exact attribute selector. No `.dark` or `[data-mode="dark"]` aliases are provided.

### Nested Theme Compatibility
The Dark theme is fully compatible with nested themes. It applies only to the scope of the `[data-theme="dark"]` attribute.
```html
<html data-theme="dark">
    <!-- Inherits dark theme -->
    <section data-theme="brand">
        <!-- Overrides specific tokens for the brand theme -->
    </section>
</html>
```

## 4. Semantic Mapping Table

The following table defines the design contract for the Dark theme. Unmapped tokens will automatically inherit from the Default/root theme.

| Semantic Token | Default Value | Dark Value | Classification | Notes |
|---|---|---|---|---|
| **Background Roles** | | | | |
| `--hb-color-background` | `var(--hb-color-white)` | `var(--hb-color-neutral-950)` | Themeable | Page background |
| `--hb-color-background-subtle` | `var(--hb-color-neutral-50)` | `var(--hb-color-neutral-900)` | Themeable | Subtle section background |
| **Surface Roles** | | | | |
| `--hb-color-surface` | `var(--hb-color-white)` | `var(--hb-color-neutral-900)` | Themeable | Standard card/container surface |
| `--hb-color-surface-raised` | `var(--hb-color-white)` | `var(--hb-color-neutral-800)` | Themeable | Elevated surfaces (dropdowns, modals) |
| `--hb-color-surface-muted` | `var(--hb-color-neutral-100)` | `var(--hb-color-neutral-950)` | Themeable | Recessed/muted surfaces |
| **Text Roles** | | | | |
| `--hb-color-text` | `var(--hb-color-neutral-900)` | `var(--hb-color-neutral-50)` | Themeable | Primary text |
| `--hb-color-text-muted` | `var(--hb-color-neutral-600)` | `var(--hb-color-neutral-400)` | Themeable | Secondary/muted text |
| `--hb-color-text-subtle` | `var(--hb-color-neutral-500)` | `var(--hb-color-neutral-500)` | Themeable | Tertiary/subtle text |
| `--hb-color-text-disabled` | `var(--hb-color-neutral-400)` | `var(--hb-color-neutral-600)` | Themeable | Disabled text |
| **Border Roles** | | | | |
| `--hb-color-border` | `var(--hb-color-neutral-200)` | `var(--hb-color-neutral-800)` | Themeable | Standard borders and dividers |
| `--hb-color-border-strong` | `var(--hb-color-neutral-300)` | `var(--hb-color-neutral-700)` | Themeable | High-contrast borders |
| **Primary Roles** | | | | |
| `--hb-color-primary` | `var(--hb-color-blue-600)` | `var(--hb-color-blue-500)` | Context-dependent | Lightened for contrast on dark backgrounds |
| `--hb-color-primary-hover` | `var(--hb-color-blue-700)` | `var(--hb-color-blue-400)` | Context-dependent | Hover state |
| `--hb-color-primary-active` | `var(--hb-color-blue-800)` | `var(--hb-color-blue-600)` | Context-dependent | Active state |
| `--hb-color-primary-subtle` | `var(--hb-color-blue-50)` | `var(--hb-color-blue-950)` | Context-dependent | Subtle primary background |
| `--hb-color-on-primary` | `var(--hb-color-white)` | `var(--hb-color-white)` | Context-dependent | Text on primary (unchanged) |
| **Status Roles** | | | | |
| `--hb-color-success` | `var(--hb-color-green-600)` | `var(--hb-color-green-500)` | Themeable | Lightened for contrast |
| `--hb-color-success-subtle` | `var(--hb-color-green-50)` | `var(--hb-color-green-950)` | Themeable | Dark subtle success background |
| `--hb-color-on-success` | `var(--hb-color-black)` | `var(--hb-color-black)` | Themeable | Text on success (unchanged) |
| `--hb-color-warning` | `var(--hb-color-yellow-600)` | `var(--hb-color-yellow-500)` | Themeable | Lightened for contrast |
| `--hb-color-warning-subtle` | `var(--hb-color-yellow-50)` | `var(--hb-color-yellow-950)` | Themeable | Dark subtle warning background |
| `--hb-color-on-warning` | `var(--hb-color-black)` | `var(--hb-color-black)` | Themeable | Text on warning (unchanged) |
| `--hb-color-danger` | `var(--hb-color-red-600)` | `var(--hb-color-red-500)` | Themeable | Lightened for contrast |
| `--hb-color-danger-subtle` | `var(--hb-color-red-50)` | `var(--hb-color-red-950)` | Themeable | Dark subtle danger background |
| `--hb-color-on-danger` | `var(--hb-color-white)` | `var(--hb-color-white)` | Themeable | Text on danger (unchanged) |
| `--hb-color-info` | `var(--hb-color-blue-600)` | `var(--hb-color-blue-500)` | Themeable | Lightened for contrast |
| `--hb-color-info-subtle` | `var(--hb-color-blue-50)` | `var(--hb-color-blue-950)` | Themeable | Dark subtle info background |
| `--hb-color-on-info` | `var(--hb-color-white)` | `var(--hb-color-white)` | Themeable | Text on info (unchanged) |
| **Focus Role** | | | | |
| `--hb-color-focus` | `var(--hb-color-blue-600)` | `var(--hb-color-blue-500)` | Themeable | Focus indicator |

## 5. Decision Log

### Primary/Brand and Status Mapping
The default `600` level primitives for primary and status colors (e.g., `blue-600`, `red-600`) can lack sufficient contrast or appear too aggressive against dark backgrounds (`neutral-950` / `neutral-900`). The Dark theme remaps these to the `500` level primitives to improve readability and visual comfort, while keeping the corresponding `-on-` colors (e.g., `white` or `black`) stable.

### Intentionally Stable Tokens
The Semantic Typography tokens (`--hb-font-family-body`, `--hb-font-family-heading`, `--hb-font-family-code`) are strictly stable and excluded from the Dark theme mapping. Dark theme changes visual color semantics, not typography architecture.

### Accessibility Assessment
The mapped primitives rely on standard contrast scales (e.g., `50` for text on `900` backgrounds, `500` for primary actions on dark surfaces). While specific WCAG ratios are contextual to the final rendered DOM, this mapping uses established lightness differentials to maintain foreground/background usability, surface elevation visibility, and status distinction.

## 6. Custom Theme Extension

Applications can define custom themes without modifying HEBRING core. This is the official extension model for application-specific theming:

```css
/* In application CSS */
[data-theme="my-product"] {
    --hb-color-primary: var(--hb-color-purple-600);
    --hb-color-primary-hover: var(--hb-color-purple-700);
}
```

## 7. Explicit Non-Goals

This document represents the Design Contract for Phase 09.4. It explicitly does NOT:
- Implement any actual theme CSS.
- Modify `semantic.css` or `primitives.css`.
- Modify any component or utility CSS.
- Add JavaScript theme switching or user-preference media queries.
- Propose new primitive tokens.
