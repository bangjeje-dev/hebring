# HEBRING Design Token Source Architecture

This document defines the architectural structure, responsibilities, and composition rules for **Design Tokens** in the HEBRING CSS framework.

---

## 1. Overview & Purpose

Design Tokens represent HEBRING's foundational value system. They centralize raw and semantic design decisions—such as color scales, spacing, typography, radii, elevation, and transitions—into reusable CSS Custom Properties (`--hb-*`).

The token system is structured in the dedicated `src/tokens/` domain:

```
src/tokens/
├── index.css        # Token composition entry point
├── primitives.css   # Raw, context-agnostic values
├── semantic.css     # Intent-driven, contextual mappings (Light default)
└── themes.css       # Theme overrides ([data-theme="dark"])
```

---

## 2. Tokens Are a Value System, Not a Cascade Layer

HEBRING uses native CSS Cascade Layers (`@layer`) to order selector precedence:

```css
@layer reset, base, layout, components, utilities;
```

**Design Tokens are intentionally NOT a cascade layer.** There is no `@layer tokens;`.

### Why Tokens Are Not a Layer:
1. **Values vs. Selectors**: Cascade layers govern which selector rules take precedence when resolving visual conflicts. Design tokens are values (CSS custom properties) declared globally (typically on `:root`), not visual selector overrides.
2. **Universal Accessibility**: Because custom properties are resolved via variable inheritance rather than visual layer specificity, placing tokens in an unlayered or dedicated value boundary ensures they are available universally across all cascade layers:

```
Design Tokens (Value System)
       │
       ▼
CSS Custom Properties (--hb-*)
       │
       ▼
@layer reset, base, layout, components, utilities
```

---

## 3. Directory Structure & File Responsibilities

### `src/tokens/index.css`
The internal composition boundary for the tokens domain. It imports token files in their logical dependency order:

```css
@import "./primitives.css";
@import "./semantic.css";
@import "./themes.css";
```

### `src/tokens/primitives.css`
Contains raw, context-agnostic design decisions. Primitives represent absolute design values with no implied role or usage context.

**Responsibilities:**
- Raw color scales (Neutral, Blue, Green, Yellow, Red across steps 50–950, plus foundational white/black).
- Spacing scales (strict 4px base system from `--hb-space-0` to `--hb-space-32`).
- Typography scales (sans with Outfit/system fallbacks, monospace, font sizes xs–6xl, weights regular–bold, line heights, letter spacings).
- Border radii (none–full), box shadows (none–xl), and motion (durations, easings).

*Implemented in Phase 03.2. See [Primitive Design Tokens](primitive-tokens.md) for full reference.*

### `src/tokens/semantic.css`
Contains contextual, intent-based design mappings that reference primitive tokens. Represents the default Light theme on `:root, [data-theme="light"]`.

**Responsibilities:**
- Role-based colors (background, surface, text, border, primary, status roles).
- Interactive state tokens (hover, active, focus indicator).
- Semantic typography families (body, heading, code).

*Implemented in Phase 03.3. See [Semantic Design Tokens](semantic-tokens.md) for full reference.*

### `src/tokens/themes.css`
Contains theme-specific semantic token overrides (such as `[data-theme="dark"]`). Components consume semantic tokens and remain completely theme-agnostic.

*Implemented in Phase 03.4. See [Theme Architecture](theme-architecture.md) for full reference.*


---

## 4. Token Dependency Hierarchy

The HEBRING design token architecture follows a strict, one-directional flow of values:

```
┌────────────────────────────────────────────────────────┐
│  Primitive Tokens (primitives.css)                     │  Raw values: scales, sizes, palettes
└──────────────────────────┬─────────────────────────────┘
                           │
                           ▼
┌────────────────────────────────────────────────────────┐
│  Semantic Tokens (semantic.css)                        │  Role & intent mappings
└──────────────────────────┬─────────────────────────────┘
                           │
                           ▼
┌────────────────────────────────────────────────────────┐
│  Framework Styling                                     │  Consumed across:
│  (foundation, layout, components, utilities)          │  reset, base, layout, components, utilities
└──────────────────────────┬─────────────────────────────┘
                           │
                           ▼
┌────────────────────────────────────────────────────────┐
│  Optional Local Component Tokens                       │  Internal wiring (e.g. --hb-button-bg)
│  (Scoped locally inside component CSS)                 │  Not global, not a new token category
└────────────────────────────────────────────────────────┘
```

1. **Primitives** define literal design scales.
2. **Semantics** reference primitives to assign purpose (e.g. assigning a specific blue step to primary actions).
3. **Framework Layers** consume semantic tokens (and primitives where appropriate) via `var(--hb-...)`.
4. **Local Component Tokens** (optional) are defined within component stylesheets to abstract complex internal wiring or state changes.

---

## 5. Public Entry Point & Composition Boundaries

`src/index.css` remains the **single public entry point** for the entire HEBRING framework:

```
src/index.css
  ├── @import "./tokens/index.css";
  ├── @import "./foundation/index.css";
  ├── @import "./layout/index.css";
  ├── @import "./components/index.css";
  └── @import "./utilities/index.css";
```

### No Circular Imports or Direct Cross-Domain Dependencies

- Component files do **NOT** import `tokens/index.css` directly.
- Layout files do **NOT** import `tokens/index.css` directly.
- Utility files do **NOT** import `tokens/index.css` directly.

The single public entry point (`src/index.css`) composes tokens prior to the styled domain entry points. Because CSS custom properties inherit globally through the DOM tree, framework rules in any layer consume `--hb-*` variables without creating tight, circular, or fragmented stylesheet import graphs.

---

## 6. Naming Convention

All design tokens adhere to the established HEBRING naming syntax (Phase 02.3):

```css
--hb-{category}-{name}
```

- **Primitive Example**: `--hb-color-blue-600`, `--hb-space-4`, `--hb-radius-md`
- **Semantic Example**: `--hb-color-primary`, `--hb-color-surface`, `--hb-color-text`

---

## 7. Implemented Primitive Token Categories

Phase 03.2 established the following six categories of primitive tokens defined in `src/tokens/primitives.css` (see [Primitive Design Tokens](primitive-tokens.md) for values and details):

1. **Colors (`--hb-color-{palette}-{step}`)**:
   - 5 palettes: Neutral, Blue, Green, Yellow, Red (steps 50–950), plus foundational `--hb-color-white` (#FFFFFF) and `--hb-color-black` (#000000).
   - `--hb-color-blue-600` is defined as `#2563EB` (approved default primary source).
2. **Spacing (`--hb-space-{step}`)**:
   - Strict 4px base scale: `0` (0px), `1` (4px), `2` (8px), `3` (12px), `4` (16px), `5` (20px), `6` (24px), `8` (32px), `10` (40px), `12` (48px), `16` (64px), `20` (80px), `24` (96px), `32` (128px).
3. **Typography**:
   - Families: `--hb-font-family-sans` ("Outfit" + system-ui fallbacks), `--hb-font-family-mono` (system monospace stack).
   - Sizes: `--hb-font-size-xs` through `--hb-font-size-6xl` (0.75rem to 3.75rem).
   - Weights: `--hb-font-weight-regular` (400), `medium` (500), `semibold` (600), `bold` (700).
   - Line Heights: `--hb-line-height-tight` (1.25), `normal` (1.5), `relaxed` (1.75).
   - Letter Spacings: `--hb-letter-spacing-tight` (-0.02em), `normal` (0em), `wide` (0.025em).
4. **Border Radius (`--hb-radius-{step}`)**:
   - Coherent progression: `none` (0px), `sm` (4px), `md` (8px), `lg` (12px), `xl` (16px), `2xl` (24px), `full` (9999px).
5. **Box Shadows (`--hb-shadow-{step}`)**:
   - Restrained elevation: `none`, `sm`, `md`, `lg`, `xl`.
6. **Motion**:
   - Durations: `--hb-duration-instant` (50ms), `fast` (150ms), `normal` (250ms), `slow` (350ms).
   - Easings: `--hb-ease-linear`, `--hb-ease-standard`, `--hb-ease-emphasized`.

---

## 8. Implemented Semantic Token Roles

Phase 03.3 established the following semantic token roles defined in `src/tokens/semantic.css` (see [Semantic Design Tokens](semantic-tokens.md) for full reference tables):

1. **Background Roles**:
   - `--hb-color-background`: `var(--hb-color-white)`
   - `--hb-color-background-subtle`: `var(--hb-color-neutral-50)`
2. **Surface Roles**:
   - `--hb-color-surface`: `var(--hb-color-white)`
   - `--hb-color-surface-raised`: `var(--hb-color-white)`
   - `--hb-color-surface-muted`: `var(--hb-color-neutral-100)`
3. **Text Roles**:
   - `--hb-color-text`: `var(--hb-color-neutral-900)`
   - `--hb-color-text-muted`: `var(--hb-color-neutral-600)`
   - `--hb-color-text-subtle`: `var(--hb-color-neutral-500)`
   - `--hb-color-text-disabled`: `var(--hb-color-neutral-400)`
4. **Border Roles**:
   - `--hb-color-border`: `var(--hb-color-neutral-200)`
   - `--hb-color-border-strong`: `var(--hb-color-neutral-300)`
5. **Primary Action Roles**:
   - `--hb-color-primary`: `var(--hb-color-blue-600)` (#2563EB)
   - `--hb-color-primary-hover`: `var(--hb-color-blue-700)`
   - `--hb-color-primary-active`: `var(--hb-color-blue-800)`
   - `--hb-color-primary-subtle`: `var(--hb-color-blue-50)`
   - `--hb-color-on-primary`: `var(--hb-color-white)`
6. **Status Roles**:
   - Success: `--hb-color-success` (`var(--hb-color-green-600)`), `--hb-color-success-subtle` (`var(--hb-color-green-50)`), `--hb-color-on-success` (`var(--hb-color-black)`)
   - Warning: `--hb-color-warning` (`var(--hb-color-yellow-600)`), `--hb-color-warning-subtle` (`var(--hb-color-yellow-50)`), `--hb-color-on-warning` (`var(--hb-color-black)`)
   - Danger: `--hb-color-danger` (`var(--hb-color-red-600)`), `--hb-color-danger-subtle` (`var(--hb-color-red-50)`), `--hb-color-on-danger` (`var(--hb-color-white)`)
   - Info: `--hb-color-info` (`var(--hb-color-blue-600)`), `--hb-color-info-subtle` (`var(--hb-color-blue-50)`), `--hb-color-on-info` (`var(--hb-color-white)`)
7. **Focus Indicator**:
   - `--hb-color-focus`: `var(--hb-color-blue-600)`
8. **Semantic Typography**:
   - `--hb-font-family-body`: `var(--hb-font-family-sans)`
   - `--hb-font-family-heading`: `var(--hb-font-family-sans)`
   - `--hb-font-family-code`: `var(--hb-font-family-mono)`

---

## 9. Architectural Constraints

1. **No Component or Layout Styles**: `src/tokens/` contains only custom property definitions; no CSS class selectors, element selectors, or layout rules belong in this domain.
2. **No Utility Classes**: Utility classes belong exclusively to `src/utilities/`.
3. **No Build-Step Requirement**: Token files are authored in pure, standard CSS. No CSS preprocessors (Sass, Less), JavaScript compilers, or generator scripts are required.
4. **No Layer Assignment**: Token source files are not wrapped in `@layer`.

---

## 10. Design Token Documentation Map

- **[Primitive Tokens Reference](primitive-tokens.md)**: Exhaustive reference tables for literal scales (colors, spacing, typography, radii, shadows, motion).
- **[Semantic Tokens Reference](semantic-tokens.md)**: Role definitions, primitive mappings, and WCAG contrast validations.
- [Theme Architecture](theme-architecture.md) — `data-theme` activation, Light default behavior, Dark overrides, and nested inheritance.
- [Component Tokens](component-tokens.md) — Architectural rules for optional, locally-scoped component tokens.
- [Token Developer Usage Guide](token-usage.md) — Practical guidelines, best practices, component examples, and anti-patterns.
