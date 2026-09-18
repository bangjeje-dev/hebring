# Architecture Notes — Cascade Layers & Source Structure

## 1. Cascade Layer Architecture

### Overview

HEBRING uses native CSS Cascade Layers (`@layer`) to make styling hierarchy explicit, predictable, and easy to understand.

By establishing an explicit cascade order, HEBRING avoids accidental selector specificity conflicts and maintains low selector complexity across the codebase.

### Official Layer Order

The canonical layer order declared in HEBRING is:

```css
@layer reset, base, layout, components, utilities;
```

The hierarchy flows in ascending priority:

```
reset → base → layout → components → utilities
```

1. **`reset`**: Normalizes default browser behaviors and removes inconsistencies across user agents.
2. **`base`**: Baseline typography, element styles, and core defaults.
3. **`layout`**: Structural scaffolding, grid systems, and page layout primitives.
4. **`components`**: Composable visual interface patterns (cards, buttons, navigation, etc.).
5. **`utilities`**: Single-purpose override classes. Utilities intentionally carry the highest priority among HEBRING's framework layers, allowing direct property overrides without specificity escalation.

### Specificity Principle

HEBRING's internal CSS architecture follows this clear priority preference:

```
Cascade Layers  >  Specificity escalation  >  !important
```

- Selectors are kept as simple and flat as possible.
- Avoid multi-class escalation or deep selector nesting.
- Avoid `!important` across framework layers.

### Design Tokens

Design tokens are **not** a cascade layer.

Tokens will be introduced in **Phase 03** as foundational CSS Custom Properties (`var(--hb-...)`). Rather than participating in the visual cascade hierarchy, tokens are shared values consumed by rules in `reset`, `base`, `layout`, `components`, and `utilities`.

---

## 2. Source Architecture

### Structure Overview

HEBRING organizes source code into clearly delineated conceptual domains:

```
src/
├── index.css
│
├── foundation/
│   ├── index.css
│   ├── reset.css
│   └── base.css
│
├── layout/
│   └── index.css
│
├── components/
│   └── index.css
│
└── utilities/
    └── index.css
```

### Domain Responsibilities

- **`foundation/`**: Normalization and fundamental element defaults (`reset.css`, `base.css`).
- **`layout/`**: Structural layout primitives (containers, grids, flex helpers, and scaffolding).
- **`components/`**: Reusable UI components (buttons, cards, inputs, badges, alerts, etc.).
- **`utilities/`**: Single-purpose, atomic utility classes (spacing, sizing, typography, display).

### Public Entry Point (`src/index.css`)

`src/index.css` acts as the single public entry point for the framework. It explicitly declares the canonical `@layer` order and composes the top-level domain entry points in sequence:

```
src/index.css
  ├── @import "./foundation/index.css";
  ├── @import "./layout/index.css";
  ├── @import "./components/index.css";
  └── @import "./utilities/index.css";
```

### Composition Boundaries

Each domain directory contains its own `index.css`, which serves as a composition boundary. For example, `src/foundation/index.css` composes `./reset.css` and `./base.css`. This shallow, explicit composition prevents complex, tangled import graphs and avoids the need for bundler aliases or custom module resolvers.

### File Granularity Principle

HEBRING adheres to the principle of **One Responsibility → One CSS Module**.

Future components and utilities will reside in dedicated, granular files (e.g. `components/button.css`, `utilities/spacing.css`) rather than monolithic files.

> **Note**: Actual layout primitives, UI components, and utility classes will be introduced in subsequent phases. Current domain `index.css` files exist strictly as architectural entry points.
