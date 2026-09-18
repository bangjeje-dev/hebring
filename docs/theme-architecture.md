# HEBRING Theme Architecture

This document defines the architectural model, activation mechanisms, and composition rules for **Themes** in the HEBRING CSS framework.

HEBRING is a modern, framework-agnostic CSS framework. The core is pure CSS without runtime JavaScript dependencies.

---

## 1. What a HEBRING Theme Is

In HEBRING, a theme is **strictly an override layer for semantic design tokens**. 

```
┌────────────────────────────────────────────────────────┐
│  Primitive Tokens (primitives.css)                     │  Context-agnostic raw scales
└──────────────────────────┬─────────────────────────────┘
                           │
                           ▼
┌────────────────────────────────────────────────────────┐
│  Semantic Tokens (semantic.css)                        │  Default Light theme mappings
└──────────────────────────┬─────────────────────────────┘
                           │
                           ▼
┌────────────────────────────────────────────────────────┐
│  Themes (themes.css)                                   │  [data-theme="dark"] overrides
│  (Semantic Overrides Only)                             │
└──────────────────────────┬─────────────────────────────┘
                           │
                           ▼
┌────────────────────────────────────────────────────────┐
│  Framework Styling                                     │  Components & layouts consume
│  (Components, Layouts, Utilities)                      │  semantic tokens agnostically
└────────────────────────────────────────────────────────┘
```

A theme does **not** change component rules, alter layout abstractions, or declare visual cascade layers. It simply recalibrates the CSS Custom Properties that components already consume.

---

## 2. Theme Activation: `data-theme`

The official activation mechanism for HEBRING themes is the `data-theme` HTML attribute:

```html
<!-- Light Theme (explicit) -->
<html data-theme="light">

<!-- Dark Theme -->
<html data-theme="dark">
```

### Why `data-theme` Instead of `.dark` Class
1. **Explicit API Surface**: `data-theme="dark"` clearly communicates state and theme intent rather than mixing with visual or behavioral utility classes.
2. **Multi-Theme Scalability**: An attribute allows arbitrary named themes (e.g. `data-theme="brand"`, `data-theme="high-contrast"`, `data-theme="ocean"`) without inventing divergent class conventions.
3. **Namespace Isolation**: Prevents collisions with application-level `.dark` utilities or third-party CSS classes.

---

## 3. Default Theme (Light)

**Light is the default theme.**

When no `data-theme` attribute is specified on `<html>`, the framework automatically renders in the Light theme:

```html
<!-- Automatically renders in Light Theme -->
<html>
  <body>...</body>
</html>
```

### Zero-Duplication Architecture
In `src/tokens/semantic.css`, the default semantic tokens are scoped to:

```css
:root,
[data-theme="light"] {
  --hb-color-background: var(--hb-color-white);
  --hb-color-surface: var(--hb-color-white);
  --hb-color-text: var(--hb-color-neutral-900);
  /* ... */
}
```

This ensures:
1. **Zero Redundancy**: The default `:root` definitions directly serve as the Light theme without duplicating token declarations across separate files.
2. **Explicit Targeting**: Elements with `data-theme="light"` match the same block, allowing explicit light styling even when nested inside dark containers.

---

## 4. Dark Theme Implementation

Dark theme is activated via `[data-theme="dark"]` in [`src/tokens/themes.css`](file:///Users/user/Documents/HEBRING/hebring/src/tokens/themes.css).

Dark theme overrides only the semantic tokens that require different values for dark contexts. Every dark override strictly references existing primitive tokens from `src/tokens/primitives.css`.

### Evaluated Semantic Overrides

| Category | Token | Light Default (`:root`) | Dark Override (`[data-theme="dark"]`) | Resolved Dark Value |
| :--- | :--- | :--- | :--- | :--- |
| **Background** | `--hb-color-background` | `var(--hb-color-white)` | `var(--hb-color-neutral-950)` | `#020617` |
| | `--hb-color-background-subtle` | `var(--hb-color-neutral-50)` | `var(--hb-color-neutral-900)` | `#0f172a` |
| **Surface** | `--hb-color-surface` | `var(--hb-color-white)` | `var(--hb-color-neutral-900)` | `#0f172a` |
| | `--hb-color-surface-raised` | `var(--hb-color-white)` | `var(--hb-color-neutral-800)` | `#1e293b` |
| | `--hb-color-surface-muted` | `var(--hb-color-neutral-100)` | `var(--hb-color-neutral-800)` | `#1e293b` |
| **Text** | `--hb-color-text` | `var(--hb-color-neutral-900)` | `var(--hb-color-neutral-50)` | `#f8fafc` |
| | `--hb-color-text-muted` | `var(--hb-color-neutral-600)` | `var(--hb-color-neutral-400)` | `#94a3b8` |
| | `--hb-color-text-subtle` | `var(--hb-color-neutral-500)` | `var(--hb-color-neutral-500)` | `#64748b` |
| | `--hb-color-text-disabled` | `var(--hb-color-neutral-400)` | `var(--hb-color-neutral-600)` | `#475569` |
| **Border** | `--hb-color-border` | `var(--hb-color-neutral-200)` | `var(--hb-color-neutral-800)` | `#1e293b` |
| | `--hb-color-border-strong` | `var(--hb-color-neutral-300)` | `var(--hb-color-neutral-700)` | `#334155` |
| **Primary** | `--hb-color-primary` | `var(--hb-color-blue-600)` | `var(--hb-color-blue-500)` | `#3b82f6` |
| | `--hb-color-primary-hover` | `var(--hb-color-blue-700)` | `var(--hb-color-blue-400)` | `#60a5fa` |
| | `--hb-color-primary-active` | `var(--hb-color-blue-800)` | `var(--hb-color-blue-600)` | `#2563EB` |
| | `--hb-color-primary-subtle` | `var(--hb-color-blue-50)` | `var(--hb-color-blue-950)` | `#172554` |
| | `--hb-color-on-primary` | `var(--hb-color-white)` | `var(--hb-color-black)` | `#000000` |
| **Status (Success)** | `--hb-color-success` | `var(--hb-color-green-600)` | `var(--hb-color-green-500)` | `#22c55e` |
| | `--hb-color-success-subtle` | `var(--hb-color-green-50)` | `var(--hb-color-green-950)` | `#052e16` |
| | `--hb-color-on-success` | `var(--hb-color-black)` | `var(--hb-color-black)` | `#000000` |
| **Status (Warning)** | `--hb-color-warning` | `var(--hb-color-yellow-600)` | `var(--hb-color-yellow-500)` | `#eab308` |
| | `--hb-color-warning-subtle` | `var(--hb-color-yellow-50)` | `var(--hb-color-yellow-950)` | `#422006` |
| | `--hb-color-on-warning` | `var(--hb-color-black)` | `var(--hb-color-black)` | `#000000` |
| **Status (Danger)** | `--hb-color-danger` | `var(--hb-color-red-600)` | `var(--hb-color-red-500)` | `#ef4444` |
| | `--hb-color-danger-subtle` | `var(--hb-color-red-50)` | `var(--hb-color-red-950)` | `#450a0a` |
| | `--hb-color-on-danger` | `var(--hb-color-white)` | `var(--hb-color-black)` | `#000000` |
| **Status (Info)** | `--hb-color-info` | `var(--hb-color-blue-600)` | `var(--hb-color-blue-500)` | `#3b82f6` |
| | `--hb-color-info-subtle` | `var(--hb-color-blue-50)` | `var(--hb-color-blue-950)` | `#172554` |
| | `--hb-color-on-info` | `var(--hb-color-white)` | `var(--hb-color-black)` | `#000000` |
| **Focus** | `--hb-color-focus` | `var(--hb-color-blue-600)` | `var(--hb-color-blue-500)` | `#3b82f6` |

### Color Semantics & Accessibility
- **Deliberate Progression**: Rather than inverting colors mechanically, Dark theme preserves role semantics. Surfaces use dark neutrals (`neutral-900`, `neutral-800`), canvas uses `neutral-950`, and text uses light neutrals (`neutral-50`, `neutral-400`).
- **Primary & Status Readability**: On dark surfaces, saturated 600-series colors often vibrate or lack contrast. Dark theme shifts interactive primaries and statuses to step 500 (`#3b82f6`, `#22c55e`, `#ef4444`), providing high contrast (≥ 4.5:1 WCAG AA) against dark backgrounds.
- **`on-*` Contrast**: On step 500 status backgrounds in dark mode, `var(--hb-color-black)` achieves superior contrast exceeding WCAG AA standards (e.g., 5.71:1 for blue-500, 9.22:1 for green-500, 5.58:1 for red-500).

---

## 5. Nested Themes

Because themes are implemented as CSS Custom Properties bound to attribute selectors, nested theming works naturally via standard CSS variable inheritance without JavaScript:

```html
<html data-theme="dark">
  <body>
    <!-- Inherits dark theme from html -->
    <div class="hb-card">
      <h2>Dark Card</h2>
      
      <!-- Nested light container inside dark document -->
      <div data-theme="light" class="preview-panel">
        <div class="hb-card">
          <h2>Light Card inside Dark Document</h2>
        </div>
      </div>
    </div>
  </body>
</html>
```

### Inheritance Mechanics
- The `[data-theme="light"]` selector matches the inner element directly, re-declaring light semantic tokens for that subtree.
- Descendants of the inner element inherit the light tokens.
- Similarly, a `<div data-theme="dark">` inside a default or light document matches `[data-theme="dark"]` directly, creating a dark subtree seamlessly.

---

## 6. Custom Theme Extensibility

HEBRING’s theme architecture allows application developers to introduce custom themes effortlessly by declaring semantic overrides on custom `data-theme` values:

```css
/* Application-defined theme */
[data-theme="brand-ocean"] {
  --hb-color-primary: var(--hb-color-blue-400);
  --hb-color-background: #0a192f;
  --hb-color-surface: #112240;
  --hb-color-text: #e6f1ff;
  --hb-color-border: #233554;
}
```

Component stylesheets do not need to be modified or recompiled when custom themes are added.

---

## 7. Architectural Decisions & Anti-Patterns Avoided

### Why Themes Do Not Modify Components
Components must remain completely theme-agnostic:

```css
/* CORRECT: Component consumes semantic tokens */
.hb-card {
  background-color: var(--hb-color-surface);
  color: var(--hb-color-text);
  border: 1px solid var(--hb-color-border);
}

/* ANTI-PATTERN: Component-specific theme variants */
.hb-card--dark { ... }
.dark .hb-card { ... }
[data-theme="dark"] .hb-card { ... }
```

Coupling themes to component selectors creates massive CSS bloat, breaks encapsulation, and requires updating every component whenever a new theme is introduced.

### Why `prefers-color-scheme` Is Not the Primary Mechanism
HEBRING relies on explicit `data-theme` activation rather than automatic media query overrides:
1. **Predictable SSR**: Prevents hydration flashes or layout shifts when server-rendered pages encounter client-side theme states.
2. **User Agency**: Many web applications allow users to choose Light, Dark, or System preference explicitly. Relying strictly on CSS media queries forces an all-or-nothing OS-level switch.
3. **Future Extension**: Developers who desire automatic OS-level adaptation can easily bridge `prefers-color-scheme` to `data-theme` or add a media query block in application CSS without framework rigidity.

---

## 8. Further Documentation

- **[Token Developer Usage Guide](token-usage.md)**: Best practices, practical component examples, and anti-patterns.
- **[Semantic Tokens Reference](semantic-tokens.md)**: Contextual role mappings and WCAG contrast validation.
- **[Primitive Tokens Reference](primitive-tokens.md)**: Raw color palettes, 4px spacing scale, typography, radii, shadows, and motion values.
- **[Design Token Architecture](design-token-architecture.md)**: Source structure, composition boundaries, and import mechanics.

