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
└── semantic.css     # Intent-driven, contextual mappings
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
```

### `src/tokens/primitives.css`
Contains raw, context-agnostic design decisions. Primitives represent absolute design values with no implied role or usage context.

**Responsibilities:**
- Raw color scales (e.g., neutrals, blues, reds across numeric steps).
- Spacing scales (e.g., base unit multiples).
- Typography scales (font sizes, line heights, font weights).
- Border radii, transition durations, and z-index scales.

*Note: In Phase 03.1, this file serves as structural scaffolding. Specific token values will be introduced in subsequent phases.*

### `src/tokens/semantic.css`
Contains contextual, intent-based design mappings that reference primitive tokens.

**Responsibilities:**
- Role-based colors (e.g., primary action, secondary, danger, success, warning).
- Surface and background tokens (e.g., page background, surface elevated, surface overlay).
- Text roles (e.g., text primary, text muted, text inverse).
- Interactive state tokens (hover, active, focus outlines).

*Note: In Phase 03.1, this file serves as structural scaffolding. Specific semantic mappings will be introduced in subsequent phases.*

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
└────────────────────────────────────────────────────────┘
```

1. **Primitives** define literal design scales.
2. **Semantics** reference primitives to assign purpose (e.g. assigning a specific blue step to primary actions).
3. **Framework Layers** consume semantic tokens (and primitives where appropriate) via `var(--hb-...)`.

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

- **Primitive Example (Future)**: `--hb-color-blue-600`, `--hb-space-4`, `--hb-radius-md`
- **Semantic Example (Future)**: `--hb-color-primary`, `--hb-color-surface`, `--hb-color-text`

---

## 7. Architectural Constraints

1. **No Component or Layout Styles**: `src/tokens/` contains only custom property definitions; no CSS class selectors, element selectors, or layout rules belong in this domain.
2. **No Utility Classes**: Utility classes belong exclusively to `src/utilities/`.
3. **No Build-Step Requirement**: Token files are authored in pure, standard CSS. No CSS preprocessors (Sass, Less), JavaScript compilers, or generator scripts are required.
4. **No Layer Assignment**: Token source files are not wrapped in `@layer`.
