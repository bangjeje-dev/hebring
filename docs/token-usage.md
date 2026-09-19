# HEBRING Design Token Developer Usage Guide

This document provides a practical developer reference for consuming and extending **Design Tokens** in the HEBRING CSS framework.

---

## 1. The Token Hierarchy

HEBRING structures design values in a clean, one-directional hierarchy:

```
┌────────────────────────────────────────────────────────┐
│  1. Primitive Tokens (primitives.css)                  │  "What value is this?"
│  Raw scales: colors, spacing, typography, radii, etc.   │  Context-agnostic building blocks
└──────────────────────────┬─────────────────────────────┘
                           │
                           ▼
┌────────────────────────────────────────────────────────┐
│  2. Semantic Tokens (semantic.css)                     │  "What role does this serve?"
│  Role mappings: background, surface, text, border, etc.│  Intent-driven UI roles (Light default)
└──────────────────────────┬─────────────────────────────┘
                           │
                           ▼
┌────────────────────────────────────────────────────────┐
│  3. Theme Overrides (themes.css)                       │  "How does the role shift?"
│  Dark theme overrides via [data-theme="dark"]          │  Recalibrates semantic roles
└──────────────────────────┬─────────────────────────────┘
                           │
                           ▼
┌────────────────────────────────────────────────────────┐
│  4. Framework Styling & Components                     │  "How is the UI constructed?"
│  Components & layouts consume semantic tokens          │  Theme-agnostic CSS rules
└──────────────────────────┬─────────────────────────────┘
                           │
                           ▼
┌────────────────────────────────────────────────────────┐
│  5. Application UI & Local Component Tokens            │  Markup with clean semantics
│  Consistent user interface across all themes           │  Zero component-level theme logic
└────────────────────────────────────────────────────────┘
```

### Golden Rule for Developers
> **Framework and component styling should consume semantic tokens whenever an appropriate semantic token exists.**

---

## 2. Primitive Tokens: The Foundational Scale

Primitive tokens represent literal, context-agnostic design metrics. All primitive tokens are declared globally on `:root` in [`src/tokens/primitives.css`](file:///Users/user/Documents/HEBRING/hebring/src/tokens/primitives.css).

See the [Primitive Tokens Reference](primitive-tokens.md) for full numeric tables.

### 1. Colors
- **Palettes**: 5 cohesive palettes with 11 steps each (`50` to `950`):
  - `--hb-color-neutral-{step}`: Slate-tinted neutral scale for text, borders, and surfaces.
  - `--hb-color-blue-{step}`: Brand and interactive primary scale. **`--hb-color-blue-600` is `#2563EB`**.
  - `--hb-color-green-{step}`: Success and positive feedback indicators.
  - `--hb-color-yellow-{step}`: Warning, caution, and attention indicators.
  - `--hb-color-red-{step}`: Destructive, error, and danger indicators.
- **Foundational Absolutes**:
  - `--hb-color-white`: `#FFFFFF`
  - `--hb-color-black`: `#000000`

### 2. Spacing Scale (4px Base System)
Used for padding, margins, flex/grid gaps, and component dimensions:
- Tokens: `--hb-space-0` (0px), `--hb-space-1` (4px), `--hb-space-2` (8px), `--hb-space-3` (12px), `--hb-space-4` (16px), `--hb-space-5` (20px), `--hb-space-6` (24px), `--hb-space-8` (32px), `--hb-space-10` (40px), `--hb-space-12` (48px), `--hb-space-16` (64px), `--hb-space-20` (80px), `--hb-space-24` (96px), `--hb-space-32` (128px).

### 3. Typography
- **Families**:
  - `--hb-font-family-sans`: `"Outfit", system-ui, -apple-system, BlinkMacSystemFont, "Segoe UI", sans-serif`
  - `--hb-font-family-mono`: `ui-monospace, SFMono-Regular, Menlo, Monaco, Consolas, "Liberation Mono", "Courier New", monospace`
- **Sizes**: 10-step progression from `--hb-font-size-xs` (0.75rem / 12px) to `--hb-font-size-6xl` (3.75rem / 60px). Base size is `--hb-font-size-md` (1rem / 16px).
- **Weights**: `--hb-font-weight-regular` (400), `--hb-font-weight-medium` (500), `--hb-font-weight-semibold` (600), `--hb-font-weight-bold` (700).
- **Line Heights**: `--hb-line-height-tight` (1.25), `--hb-line-height-normal` (1.5), `--hb-line-height-relaxed` (1.75).
- **Letter Spacings**: `--hb-letter-spacing-tight` (-0.02em), `--hb-letter-spacing-normal` (0em), `--hb-letter-spacing-wide` (0.025em).

### 4. Border Radius
- Tokens: `--hb-radius-none` (0px), `--hb-radius-sm` (4px), `--hb-radius-md` (8px), `--hb-radius-lg` (12px), `--hb-radius-xl` (16px), `--hb-radius-2xl` (24px), `--hb-radius-full` (9999px).

### 5. Box Shadows (Elevation)
- Tokens: `--hb-shadow-none` (none), `--hb-shadow-sm`, `--hb-shadow-md`, `--hb-shadow-lg`, `--hb-shadow-xl` (restrained neutral elevation).

### 6. Motion
- **Durations**: `--hb-duration-instant` (50ms), `--hb-duration-fast` (150ms), `--hb-duration-normal` (250ms), `--hb-duration-slow` (350ms).
- **Easings**: `--hb-ease-linear`, `--hb-ease-standard` (cubic-bezier(0.4, 0, 0.2, 1)), `--hb-ease-emphasized` (cubic-bezier(0.2, 0, 0, 1)).

---

## 3. Semantic Tokens: The Role-Based API

Semantic tokens assign purposeful roles to raw primitive values. Declared on `:root, [data-theme="light"]` in [`src/tokens/semantic.css`](file:///Users/user/Documents/HEBRING/hebring/src/tokens/semantic.css).

See the [Semantic Tokens Reference](semantic-tokens.md) for full mapping details.

### Core Semantic Roles
1. **Background Canvas**:
   - `--hb-color-background`: Main page/canvas background.
   - `--hb-color-background-subtle`: Subtle secondary canvas background for sectioning.
2. **Surfaces**:
   - `--hb-color-surface`: Standard surface for cards, panels, and modal containers.
   - `--hb-color-surface-raised`: Elevated floating surfaces (dropdowns, popovers).
   - `--hb-color-surface-muted`: Inset or deactivated surface containers.
3. **Text & Content**:
   - `--hb-color-text`: Primary high-emphasis body text and headings.
   - `--hb-color-text-muted`: Secondary captions, metadata, and sub-labels.
   - `--hb-color-text-subtle`: Tertiary labels, placeholders, and disabled icons.
   - `--hb-color-text-disabled`: Deactivated text.
4. **Borders & Dividers**:
   - `--hb-color-border`: Standard card boundaries, table rules, and dividers.
   - `--hb-color-border-strong`: Active borders, input boundaries, and emphasized separators.
5. **Primary Brand & Action**:
   - `--hb-color-primary`: Base brand accent and primary button background.
   - `--hb-color-primary-hover`: Pointer hover state for primary elements.
   - `--hb-color-primary-active`: Pressed/active state for primary elements.
   - `--hb-color-primary-subtle`: Soft tint for selected rows, badges, or pills.
   - `--hb-color-on-primary`: Text and icon color rendered on primary backgrounds.
6. **System Statuses**:
   - **Success**: `--hb-color-success`, `--hb-color-success-subtle`, `--hb-color-on-success`
   - **Warning**: `--hb-color-warning`, `--hb-color-warning-subtle`, `--hb-color-on-warning`
   - **Danger**: `--hb-color-danger`, `--hb-color-danger-subtle`, `--hb-color-on-danger`
   - **Info**: `--hb-color-info`, `--hb-color-info-subtle`, `--hb-color-on-info`
7. **Focus**:
   - `--hb-color-focus`: Universal outline color for accessible `:focus-visible` rings.
8. **Semantic Typography**:
   - `--hb-font-family-body`: Standard body typography.
   - `--hb-font-family-heading`: Headings and titles.
   - `--hb-font-family-code`: Monospace code, logs, and technical output.

---

## 4. Primitive vs. Semantic: When to Use Which

| Scenario | Recommended Token Type | Example | Rationale |
| :--- | :--- | :--- | :--- |
| Component surface or canvas color | **Semantic** | `var(--hb-color-surface)` | Adapts seamlessly when switching themes |
| Body or label text color | **Semantic** | `var(--hb-color-text)` | Ensures accessible contrast across themes |
| Card or input border color | **Semantic** | `var(--hb-color-border)` | Preserves structural hierarchy across themes |
| Action button or interactive state | **Semantic** | `var(--hb-color-primary)` | Consistent brand language across themes |
| Padding, margin, or layout gap | **Primitive** | `var(--hb-space-4)` | Spacing metrics do not change between themes |
| Corner rounding (radius) | **Primitive** | `var(--hb-radius-md)` | Geometry remains consistent across themes |
| Elevation shadow depth | **Primitive** | `var(--hb-shadow-sm)` | Shadows represent consistent physical depth |
| Transition timing or easing | **Primitive** | `var(--hb-duration-fast)` | Motion kinetics remain consistent across themes |

### Code Comparison

```css
/* ✅ CORRECT: Component consumes semantic roles */
.hb-card {
  background-color: var(--hb-color-surface);
  color: var(--hb-color-text);
  border: 1px solid var(--hb-color-border);
  border-radius: var(--hb-radius-lg);
  padding: var(--hb-space-6);
  box-shadow: var(--hb-shadow-sm);
}

/* ❌ AVOID: Direct coupling to palette primitives for theme-sensitive roles */
.hb-card {
  background-color: var(--hb-color-white);       /* Breaks in dark mode! */
  color: var(--hb-color-neutral-900);            /* Breaks in dark mode! */
  border: 1px solid var(--hb-color-neutral-200); /* Breaks in dark mode! */
  border-radius: var(--hb-radius-lg);
  padding: var(--hb-space-6);
}
```

> **Note**: Primitive tokens are **not** forbidden. They are the foundational building blocks of the entire framework and are intended for spatial, geometric, elevation, and motion values, as well as low-level custom overrides. However, color roles should always use semantic tokens to maintain theme compatibility.

---

## 5. Theme Usage: Light, Dark & Nested

See the [Theme Architecture Document](theme-architecture.md) for full mechanics.

### 1. Activating Themes with `data-theme`
Themes are controlled exclusively via the `data-theme` HTML attribute:

```html
<!-- Default: Renders Light Theme automatically -->
<html>

<!-- Explicit Light Theme -->
<html data-theme="light">

<!-- Dark Theme -->
<html data-theme="dark">
```

### 2. How Themes Work Under the Hood
Components are completely theme-agnostic. They never declare `.hb-card--dark` or `.dark .hb-card`. When `data-theme="dark"` is set:
1. `src/tokens/themes.css` overrides the CSS Custom Properties:
   - `--hb-color-background` becomes `var(--hb-color-neutral-950)`.
   - `--hb-color-surface` becomes `var(--hb-color-neutral-900)`.
   - `--hb-color-text` becomes `var(--hb-color-neutral-50)`.
   - `--hb-color-border` becomes `var(--hb-color-neutral-800)`.
2. The exact same `.hb-card` styles automatically render dark backgrounds, light text, and dark borders without modifying any component CSS.

### 3. Nested Themes
Because HEBRING uses native CSS Custom Property inheritance, nesting themes works out of the box without JavaScript:

```html
<!-- Dark Document with an embedded Light Card -->
<html data-theme="dark">
  <body class="hb-p-6">
    <div class="hb-card">
      <h2>Dark Card</h2>
      <p>Inherits dark theme from &lt;html&gt;.</p>

      <!-- Subtree explicitly switched to Light Theme -->
      <div data-theme="light" class="preview-panel hb-p-4">
        <div class="hb-card">
          <h2>Light Card</h2>
          <p>Reset to light semantic tokens via data-theme="light".</p>
        </div>
      </div>
    </div>
  </body>
</html>
```

---

## 6. Authoring Custom Themes

Application developers can create custom themes in their own stylesheets by declaring semantic token overrides on a custom `data-theme` attribute:

```css
/* In user application CSS */
[data-theme="brand-midnight"] {
  --hb-color-primary: var(--hb-color-blue-400);
  --hb-color-primary-hover: var(--hb-color-blue-300);
  --hb-color-primary-active: var(--hb-color-blue-500);
  --hb-color-primary-subtle: #0f172a;
  --hb-color-on-primary: var(--hb-color-black);

  --hb-color-background: #0b0f19;
  --hb-color-background-subtle: #111827;
  --hb-color-surface: #1e293b;
  --hb-color-surface-raised: #334155;
  --hb-color-surface-muted: #0f172a;

  --hb-color-text: #f8fafc;
  --hb-color-text-muted: #cbd5e1;
  --hb-color-border: #334155;
}
```

```html
<!-- Apply custom theme to the page or a section -->
<html data-theme="brand-midnight">
```

All HEBRING components immediately adapt to the custom theme without touching any framework source code.

---

## 7. Architectural Anti-Patterns to Avoid

To maintain design system integrity, avoid the following anti-patterns:

1. **Component-Specific Global Tokens**:
   - ❌ `--hb-button-height`, `--hb-card-padding`, `--hb-modal-width` defined globally in `src/tokens/`.
   - ✅ Components should consume generic semantic tokens directly (`--hb-space-4`, `--hb-radius-md`, `--hb-color-surface`).
   - ✅ **Exception**: Local component tokens are perfectly fine if defined *inside* the component's CSS module for internal wiring (Phase 07.4).
2. **Hardcoding Component Colors**:
   - ❌ Directly referencing `#ffffff` or `var(--hb-color-neutral-900)` in component rules.
   - ✅ Reference role tokens: `var(--hb-color-surface)`, `var(--hb-color-text)`.
3. **Theme-Specific Component Modifiers**:
   - ❌ `.hb-card--dark`, `.hb-button--dark`, `.dark .hb-card`
   - ✅ Let the CSS cascade recalibrate tokens via `[data-theme="dark"]`.
4. **Using `.dark` as the Framework Theme Mechanism**:
   - ❌ `<html class="dark">`
   - ✅ `<html data-theme="dark">` (avoids utility class collisions and scales to custom themes).
5. **Introducing `@layer tokens`**:
   - ❌ Wrapping custom property definitions in a cascade layer.
   - ✅ Tokens are values, not visual cascade layers.
6. **Circular Token References**:
   - ❌ `--hb-color-surface: var(--hb-color-background); --hb-color-background: var(--hb-color-surface);`
   - ✅ Maintain strict one-directional flow: Primitives → Semantics → Framework Styling.
7. **Inventing Ad-hoc Tokens for One-off Component Needs**:
   - ❌ Creating `--hb-sidebar-item-active-left-border` globally.
   - ✅ Use existing semantic roles and compose layout/states cleanly in the component stylesheet.

---

## 8. Complete Realistic Component Example

Here is how a complete, production-ready component is authored using HEBRING tokens:

```css
/* src/components/card.css (Conceptual future component) */
.hb-card {
  /* Surfaces & Borders (Semantic) */
  background-color: var(--hb-color-surface);
  color: var(--hb-color-text);
  border: 1px solid var(--hb-color-border);

  /* Geometry & Elevation (Primitive) */
  border-radius: var(--hb-radius-lg);
  box-shadow: var(--hb-shadow-sm);
  padding: var(--hb-space-6);

  /* Motion (Primitive) */
  transition: box-shadow var(--hb-duration-fast) var(--hb-ease-standard),
              border-color var(--hb-duration-fast) var(--hb-ease-standard);
}

.hb-card:hover {
  box-shadow: var(--hb-shadow-md);
  border-color: var(--hb-color-border-strong);
}

.hb-card__title {
  font-family: var(--hb-font-family-heading);
  font-size: var(--hb-font-size-xl);
  font-weight: var(--hb-font-weight-semibold);
  line-height: var(--hb-line-height-tight);
  color: var(--hb-color-text);
  margin-bottom: var(--hb-space-2);
}

.hb-card__description {
  font-family: var(--hb-font-family-body);
  font-size: var(--hb-font-size-sm);
  color: var(--hb-color-text-muted);
  line-height: var(--hb-line-height-normal);
}
```

```html
<!-- Works seamlessly in Light, Dark, or Custom Theme -->
<div class="hb-card">
  <h3 class="hb-card__title">Deploy to Staging</h3>
  <p class="hb-card__description">Automatically builds and runs integration test suites.</p>
</div>
```

---

## 9. Documentation Map & Further Reading

For detailed specifications, refer to the individual documents across the HEBRING design token suite:

- [Design Token Architecture](design-token-architecture.md) — Source structure, composition boundaries, and import mechanics.
- [Primitive Tokens Reference](primitive-tokens.md) — Raw color palettes, 4px spacing scale, typography, radii, shadows, and motion values.
- [Semantic Tokens Reference](semantic-tokens.md) — Role definitions, primitive mappings, and WCAG 2.1 AA mathematical contrast ratios.
- [Theme Architecture](theme-architecture.md) — `data-theme` activation, Light/Dark override strategy, and nested inheritance.
- [Component Tokens](component-tokens.md) — Optional local component tokens for implementation wiring.
- [Typography](typography.md) — Baseline document typography, heading scale hierarchy, prose spacing, and inline semantics.
- [Form Foundation](forms.md) — Minimal, native-preserving form control foundation, typography inheritance, and fieldset normalization.
- [Architecture Notes](architecture.md) — Master framework architecture document covering Cascade Layers, Source Structure, Naming Conventions, Component Philosophy, and Tokens.
