# Architecture Notes — Cascade Layers, Source Structure & Naming Convention

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

---

## 3. Naming Convention

HEBRING follows a strict, predictable naming syntax across its public API (see [Naming Convention](naming-convention.md) for complete details):

1. **Framework Prefix**: All framework classes are prefixed with `hb-` (e.g., `hb-button`, `hb-card`).
2. **Components**: `hb-{component}` (lowercase kebab-case).
3. **Modifiers / Variants**: `hb-{component}--{modifier}` using double hyphens (e.g., `hb-button--primary`).
4. **Component Elements**: `hb-{component}__{element}` using double underscores (e.g., `hb-card__header`). Avoid deep chains like `hb-card__header__title`.
5. **States**: `is-{state}` or `has-{state}` without the `hb-` prefix (e.g., `<button class="hb-button is-active">`).
6. **Utilities**: `hb-{property}-{value}` representing single-purpose utility rules (e.g., `hb-p-4`, `hb-flex`, `hb-text-center`).
7. **Custom Properties**: All CSS variables use the `--hb-` prefix (e.g., `--hb-color-primary`, `--hb-space-4`).
8. **Semantic Elements**: Plain HTML elements (e.g. `<h1>`, `<p>`) are styled directly in base/foundation without forcing utility or heading classes on every tag.
9. **Naming Style**: Strict lowercase kebab-case across all tokens, classes, and properties.
10. **Namespace Isolation**: `hb-` is reserved for HEBRING; user/application classes exist freely outside this prefix.

---

## 4. Utility vs Component Philosophy

HEBRING is neither purely utility-first nor purely component-first. It is a layered and composable CSS framework built on the guiding principle (see [Utility vs Component Philosophy](utility-vs-component.md) for complete details):

> **"Utility handles one thing. Component defines a reusable UI pattern."**

### Architectural Domains & Responsibilities

1. **Foundation (`reset`, `base`)**:
   - Manages browser normalization, CSS resets, and baseline semantic element defaults.
   - Does not contain UI components, layout primitives, or utility classes.
2. **Layout (`layout`)**:
   - Meaningful structural layout primitives (`hb-container`, `hb-grid`, `hb-stack`).
   - Represents reusable spatial concepts rather than utilities for every CSS property.
3. **Components (`components`)**:
   - Reusable visual interface patterns (`hb-button`, `hb-card`, `hb-alert`).
   - May contain multiple CSS declarations defining a cohesive pattern.
   - **Baseline Completeness**: Components must be self-sufficient and never require utility classes to become functional or visually valid.
4. **Utilities (`utilities`)**:
   - Small, single-purpose CSS adjustments (`hb-p-4`, `hb-flex`, `hb-w-full`).
   - Follows the principle: *"Useful primitives, not every possible CSS declaration."*

### Independence and Composition

- **Component Independence**: Components must not depend on utilities to function or be complete.
- **Utility Independence**: Utilities operate at their own abstraction level and do not depend on or target specific components.
- **Natural Composition**: Components establish UI identity (`hb-button`); utilities provide narrow adjustments (`hb-w-full`).
- **Cascade Precedence**: Because `@layer utilities` is declared after `@layer components`, utilities override component properties cleanly via the native cascade without specificity escalation or `!important`.

### Decision Tree

When adding styling abstractions to HEBRING:

1. **Foundational browser/HTML rule?** → `foundation`
2. **Meaningful structural layout primitive?** → `layout`
3. **Reusable UI pattern?** → `components`
4. **Narrow, single-purpose adjustment?** → `utilities`
5. **None of the above?** → Re-evaluate the abstraction instead of creating a new class.

### Conceptual Responsibility vs Import Dependencies

This domain hierarchy reflects **conceptual responsibility** and **cascade layer order**. It does **not** define an import dependency chain:
- Domains do not import one another.
- All domains are independently composed at the framework entry point (`src/index.css`) into their respective native `@layer` slots.

---

## 5. Design Token Source Architecture

HEBRING establishes a dedicated `tokens/` domain to house design values as CSS Custom Properties (see [Design Token Architecture](design-token-architecture.md) for full details).

### Domain Structure & Responsibilities

```
src/tokens/
├── index.css        # Entry point composing primitive and semantic tokens
├── primitives.css   # Raw, context-agnostic values (scales, steps, base units)
└── semantic.css     # Intent-driven mappings (roles, surfaces, states)
```

1. **`tokens/index.css`**: Composes `primitives.css` and `semantic.css` into a unified token export.
2. **`primitives.css`**: Future home for literal design values (color palettes, spacing units, typography scales, radii) independent of UI context.
3. **`semantic.css`**: Future home for contextual, purpose-driven aliases (e.g. primary color, surface background) referencing primitives.

### Token Dependency Hierarchy

Values flow strictly in one direction:

```
Primitive Tokens  →  Semantic Tokens  →  Framework Styling (reset, base, layout, components, utilities)
```

### Tokens Are Not a Cascade Layer

Design tokens are a **value system**, not a visual cascade layer. They are intentionally **not** placed in `@layer tokens;`. The established layer order remains:

```css
@layer reset, base, layout, components, utilities;
```

Because CSS custom properties resolve via standard DOM inheritance rather than selector cascade priority, declaring tokens outside of `@layer` makes them globally accessible across all framework layers.

### Public Entry Point & Composition Boundaries

`src/index.css` remains the **single public entry point** for the framework:

```
src/index.css
  ├── @import "./tokens/index.css";
  ├── @import "./foundation/index.css";
  ├── @import "./layout/index.css";
  ├── @import "./components/index.css";
  └── @import "./utilities/index.css";
```

### No Circular Imports

Component, layout, and utility modules never import `tokens/` directly. The framework entry point composes tokens prior to the visual styling layers, eliminating circular dependencies and tangled stylesheet import graphs.


