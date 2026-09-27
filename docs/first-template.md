# The First Official Template: Starter Dashboard

This document details the architectural decisions and constraints applied to the **Starter Dashboard** template, located in `ecosystem/templates/starter-dashboard/`.

## 1. Why the first template exists

HEBRING has successfully established a multi-layered CSS architecture (Core, Layout, Responsive, Components, Themes, and Interactive UI). However, up until now, these layers were only demonstrated in isolation (via documentation or the Playground).

The Starter Dashboard exists to prove that these disparate layers can be composed into a realistic, production-like application shell without requiring an external JS framework, a complex build system, or duplicate component code.

## 2. Template Purpose

The primary purpose of the Starter Dashboard is to serve as a **reference composition**. It demonstrates how an application consumer should orchestrate HEBRING primitives. 

It is intentionally NOT a production application, a UI kit, or a starter repository with Webpack/Vite. It is raw, understandable HTML/CSS.

## 3. Architecture

The template adheres to the established HEBRING boundary:
`CSS Core` → `Ecosystem UI` → `Themes` → **`Templates`** → `Applications`

Templates are consumers. They do not feed back into the core framework.

## 4. Core Dependencies

The template consumes standard HEBRING Core rules directly:
- **Typography:** `hb-text-3xl`, `hb-text-sm`
- **Buttons:** `hb-button`, `hb-button--secondary`
- **Tables:** `hb-table`
- **Avatars:** `hb-avatar`
- **Badges:** `hb-badge`

## 5. Ecosystem Dependencies

The template consumes Ecosystem UI for complex surfaces:
- **Card:** `.hb-card`
- **Popover:** `.hb-popover` (and native `popover` attributes)
- **Menu:** `.hb-menu`

## 6. Layout Composition

HEBRING Core provides micro-layout primitives (`hb-stack`, `hb-cluster`). However, macro-layouts (like a persistent sidebar next to a scrolling main content area) are highly application-specific. 

The template introduces a small local stylesheet (`assets/dashboard.css`) to handle these macro-layouts (e.g., `.dashboard-shell`, `.dashboard-sidebar`). This clearly demonstrates that developers should not force application-level layout into global utility classes, nor should they add `.hb-dashboard-shell` to the Core.

## 7. Responsive Strategy

The template uses CSS Grid and media queries in its local stylesheet to handle the Sidebar/Main split. It intentionally avoids JavaScript viewport detection, relying entirely on CSS for structural responsiveness.

## 8. Theme Strategy

The template uses standard HEBRING semantic color tokens (e.g., `var(--hb-color-background)`, `var(--hb-color-text-subtle)`). It will naturally inherit any HEBRING theme (like `ocean.css` or `dark.css`) dropped into the page without requiring modifications to the template markup.

## 9. Icon Strategy

The template demonstrates the standard HEBRING icon pattern: inline SVGs utilizing `currentColor` for seamless integration with the surrounding text color cascade. It avoids introducing heavy external icon libraries.

## 10. Accessibility Strategy

The template relies on semantic HTML and ARIA where appropriate:
- Native `<nav>`, `<aside>`, `<header>`, `<main>` landmarks.
- `aria-current="page"` for active navigation states.
- `aria-label` and `aria-hidden` for icons and structural boundaries.

## 11. JavaScript Boundary

JavaScript in the template is strictly isolated to a single `<script>` block and uses Vanilla DOM APIs. It is included purely to demonstrate necessary interactions (e.g., toggling the mobile sidebar). It is expected that consumers will strip this script and replace it with their framework's state management (e.g., React `useState`).

## 12. Customization

Consumers are encouraged to copy the template directory and modify the markup and `dashboard.css` heavily. The template is a starting point, not a rigid dependency.

## 13. What belongs to HEBRING

- `hb-*` classes.
- Design tokens (`var(--hb-color-*)`).
- Semantic components (`hb-button`, `hb-card`).
- Micro-layout primitives (`hb-stack`).

## 14. What belongs to the template

- Macro-layout classes (`dashboard-shell`, `dashboard-sidebar`).
- Specific DOM structure combining multiple components.
- Fictional content and imagery.

## 15. How future templates should differ

Future templates (e.g., E-commerce Storefront, Blog Theme) will follow the exact same constraint model: rely entirely on HEBRING Core/Ecosystem, use a local non-prefixed stylesheet for macro-layout, and keep JavaScript minimal and disposable.
