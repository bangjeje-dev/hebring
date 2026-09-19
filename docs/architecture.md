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

1. **`reset`**: Normalizes default browser behaviors and removes inconsistencies across user agents (see [Reset Philosophy](reset-philosophy.md)).
2. **`base`**: Baseline typography, element styles, and core defaults (see [Typography](typography.md) and [Form Foundation](forms.md)).
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
│   ├── index.css
│   ├── container.css
│   ├── stack.css
│   ├── cluster.css
│   ├── grid.css
│   ├── flex.css
│   ├── center.css
│   └── flow.css
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

---

## 6. Primitive Design Tokens

HEBRING defines its foundational design values as primitive tokens in `src/tokens/primitives.css` (see [Primitive Design Tokens](primitive-tokens.md) for full reference tables):

### Primitive Scope & Characteristics

- **Context-Agnostic**: Values represent absolute design metrics without encoding component or semantic roles.
- **Global Declaration**: Declared globally on `:root` outside `@layer` to ensure universal availability across all layers.
- **Strict Namespacing**: Uses the `--hb-{category}-{name}` prefix.

### Implemented Token Categories

1. **Color Palettes**:
   - 5 cohesive palettes: Neutral, Blue, Green, Yellow, Red.
   - 11 numeric steps per palette (50–950).
   - `--hb-color-blue-600` is defined as `#2563EB` (the approved default primary source).
2. **Spacing Scale**:
   - Strict 4px base system: `--hb-space-0` (0px) through `--hb-space-32` (128px).
3. **Typography**:
   - Font families: `--hb-font-family-sans` (prioritizing "Outfit" with system fallbacks; zero bundled font files) and `--hb-font-family-mono`.
   - Font sizes: 10-step progression from `--hb-font-size-xs` (0.75rem) to `--hb-font-size-6xl` (3.75rem).
   - Font weights: 4 intentional weights (`regular`, `medium`, `semibold`, `bold`).
   - Line heights: `tight` (1.25), `normal` (1.5), `relaxed` (1.75).
   - Letter spacings: `tight` (-0.02em), `normal` (0em), `wide` (0.025em).
4. **Border Radius**:
   - 7-step scale from `--hb-radius-none` (0px) to `--hb-radius-full` (9999px).
5. **Box Shadows**:
   - Restrained elevation system: `none`, `sm`, `md`, `lg`, `xl`.
6. **Motion**:
   - Transition durations (`instant`, `fast`, `normal`, `slow`) and standard/emphasized easing curves.

### Architectural Exclusions

- Semantic tokens (`--hb-color-primary`, `--hb-color-surface`, `--hb-color-text`) are deferred to **Phase 03.3**.
- Component-specific tokens, utility classes, and layout classes remain strictly excluded from the `tokens/` domain.

---

## 7. Semantic Design Tokens

HEBRING defines its intent-driven design roles as semantic tokens in `src/tokens/semantic.css` (see [Semantic Design Tokens](semantic-tokens.md) for full reference tables):

### Role-Based Architecture & Mapping Rules

- **Intent Over Value**: Semantic tokens describe functional purpose (e.g. `--hb-color-text-muted`), never physical appearance or raw metrics.
- **Reference Primitives Only**: Semantic tokens strictly reference primitive tokens via `var(--hb-...)` and never duplicate literal hex or unit values.
- **Global Scope**: Declared on `:root` alongside primitives, providing framework-wide design coherence across all cascade layers without introducing `@layer tokens;`.

### Implemented Semantic Categories

1. **Background Roles**: `--hb-color-background` (`white`), `--hb-color-background-subtle` (`neutral-50`).
2. **Surface Roles**: `--hb-color-surface` (`white`), `--hb-color-surface-raised` (`white`), `--hb-color-surface-muted` (`neutral-100`).
3. **Text Roles**: `--hb-color-text` (`neutral-900`), `--hb-color-text-muted` (`neutral-600`), `--hb-color-text-subtle` (`neutral-500`), `--hb-color-text-disabled` (`neutral-400`).
4. **Border Roles**: `--hb-color-border` (`neutral-200`), `--hb-color-border-strong` (`neutral-300`).
5. **Primary Action Roles**:
   - `--hb-color-primary` (`blue-600`, `#2563EB`)
   - `--hb-color-primary-hover` (`blue-700`), `--hb-color-primary-active` (`blue-800`), `--hb-color-primary-subtle` (`blue-50`)
   - `--hb-color-on-primary` (`white`, contrast 5.17:1)
6. **Status Roles**:
   - **Success**: `--hb-color-success` (`green-600`), `--hb-color-success-subtle` (`green-50`), `--hb-color-on-success` (`black`, contrast 6.37:1 for WCAG AA)
   - **Warning**: `--hb-color-warning` (`yellow-600`), `--hb-color-warning-subtle` (`yellow-50`), `--hb-color-on-warning` (`black`, contrast 7.15:1 for WCAG AAA)
   - **Danger**: `--hb-color-danger` (`red-600`), `--hb-color-danger-subtle` (`red-50`), `--hb-color-on-danger` (`white`, contrast 4.83:1 for WCAG AA)
   - **Info**: `--hb-color-info` (`blue-600`), `--hb-color-info-subtle` (`blue-50`), `--hb-color-on-info` (`white`, contrast 5.17:1 for WCAG AA)
7. **Focus Indicator**: `--hb-color-focus` (`blue-600`).
8. **Semantic Typography**: `--hb-font-family-body` (`sans`), `--hb-font-family-heading` (`sans`), `--hb-font-family-code` (`mono`).

### Architectural Exclusions

- **Themes & Dark Mode**: Multi-theme switching (`[data-theme="dark"]`, `prefers-color-scheme`) belongs exclusively to **Phase 03.4**.
- **Component-Specific Tokens**: Tokens like `--hb-button-*` or `--hb-card-*` remain prohibited to maintain decoupled, composable architecture.

---

## 8. Theme Architecture

HEBRING implements theming exclusively through semantic token overrides declared in `src/tokens/themes.css` (see [Theme Architecture](theme-architecture.md) for complete guide):

### Core Theme Principles

1. **Tokens Over Components**: Themes override semantic design tokens. Components consume semantic tokens directly and remain completely theme-agnostic. No component-specific theme classes (e.g. `.hb-card--dark`, `.dark .hb-button`) exist in HEBRING.
2. **Official Activation (`data-theme`)**: Themes are activated via the `data-theme` HTML attribute selector (`<html data-theme="dark">`), avoiding class collisions and scaling cleanly to custom named themes.
3. **Default Light Behavior**: No attribute implies Light theme. In `semantic.css`, `:root, [data-theme="light"]` declares default Light semantics without redundant duplication.
4. **Pure CSS Inheritance**: Nested theming works predictably across subtrees (`<div data-theme="dark">` inside light, or `<div data-theme="light">` inside dark) via standard CSS custom property inheritance without JavaScript.
5. **No `@layer tokens`**: Themes are token definitions, not visual cascade layers.
6. **Explicit Over Mechanical Inversion**: Dark mode maps intentional semantic roles (e.g. primary shifts to blue-500 for WCAG AA readability on dark surfaces) rather than mechanically inverting lightness.

### Source Architecture Integration

```
src/tokens/
├── index.css        # Entry point composing primitives, semantic, and themes
├── primitives.css   # Context-agnostic raw scales
├── semantic.css     # Light theme defaults (:root, [data-theme="light"])
└── themes.css       # Dark theme overrides ([data-theme="dark"])
```

### Extensibility

Applications can define custom themes (e.g., `[data-theme="brand"]`) by declaring semantic token overrides in their own stylesheets without modifying HEBRING framework files.

---

## 9. Design Token Documentation Suite

For complete developer guides and technical specifications, refer to:

- [Design Token Architecture](design-token-architecture.md) — Source structure, composition boundaries, and import mechanics.
- [Primitive Tokens Reference](primitive-tokens.md) — Context-agnostic scales: colors, spacing, typography, radii, shadows, motion.
- [Semantic Tokens Reference](semantic-tokens.md) — Intent-driven role mappings and WCAG AA contrast validation.
- [Theme Architecture](theme-architecture.md) — Theme activation (`data-theme`), Light default behavior, Dark overrides, and nested inheritance.
- [Token Developer Usage Guide](token-usage.md) — Practical component implementation rules, custom themes, and architectural anti-patterns.

---

## 10. Foundation Architecture & Reset Philosophy

Phase 04 establishes the **Foundation Domain** (`src/foundation/`), composed of two sequential cascade layers:

```
src/foundation/
├── index.css   # Composes reset.css and base.css
├── reset.css   # Browser normalization (@layer reset)
└── base.css    # Foundational defaults & typography (@layer base)
```

### Reset Layer Principles (`reset.css`)
- **Minimal & Non-Aggressive**: Eliminates layout-breaking user-agent bugs while preserving native semantic HTML behavior and accessibility affordances.
- **Predictable Box Sizing**: Enforces `box-sizing: border-box` across all elements and pseudo-elements inside `@layer reset`.
- **Mobile Viewport Normalization**: Prevents automatic font inflation on mobile devices via `html { -webkit-text-size-adjust: 100%; text-size-adjust: 100%; }`.
- **Canvas Normalization**: Removes arbitrary 8px `body` margin.
- **Media Overflow Containment**: Constrains `img`, `video`, and `canvas` with `max-width: 100%; height: auto;` and `svg` with `max-width: 100%;` without forcing `display: block` or dictating `<picture>` wrapper behavior.
- **Accessibility Invariant**: Strictly forbids blanket focus removal (`outline: none`). Interaction accessibility is maintained in reset; color contrast is managed in tokens/components.

For comprehensive architectural rationale, candidate evaluation matrix, and boundaries with future typography/form phases, refer to:
- [Reset Philosophy](reset-philosophy.md) — Deep dive into minimal normalization, media philosophy, accessibility guarantees, candidate classifications, and layer boundaries.

### Base Layer Typography (`base.css`)
- **Semantic First**: Raw semantic HTML (`h1`–`h6`, `p`, `a`, `ul`, `ol`, `code`, `blockquote`) receives accessible, balanced styling without requiring framework classes.
- **Strict Token Mapping**: Uses semantic tokens for font families (`--hb-font-family-body`, `--hb-font-family-heading`, `--hb-font-family-code`) and text colors (`--hb-color-text`, `--hb-color-primary`), scaling with themes.
- **Layer & Specificity Strategy**: Authored with flat element selectors inside `@layer base` (`reset < base < layout < components < utilities`), allowing future utilities to override base styles effortlessly without `!important`.
- **Vertical Rhythm**: Bottom-margin flow (`margin-top: 0; margin-bottom: var(--hb-space-*)`) eliminates collapsing margin friction.

For comprehensive typography specifications, refer to:
- [Typography](typography.md) — Complete specification of heading scales, prose spacing, link interactions, and monospace blocks.

### Base Layer Form Foundation (`base.css`)
- **Minimal / Native-Preserving**: Enhances native form controls (`button, input, select, textarea`) through typography and color inheritance without stripping native platform appearance, borders, or backgrounds.
- **Inherited Metrics**: Uses `font: inherit; color: inherit; line-height: inherit;` to automatically harmonize form controls with active document typography and light/dark theme states without extra tokens.
- **Fieldset Containment**: Normalizes `<fieldset>` with `min-width: 0;` to prevent flex/grid layout blowout bugs without removing borders, paddings, or legends.
- **Preserved Invariants**: Zero `appearance: none`, zero `outline: none`, zero forced `width: 100%`, and zero cursor changes.

For comprehensive form foundation specifications, refer to:
- [Form Foundation](forms.md) — Technical specifications, inheritance mechanics, layout normalization, and scope boundaries.

---

## 11. Layout Philosophy

Phase 05 establishes the **Layout Domain** (`src/layout/`), focusing on structural relationships rather than individual element styling or single-purpose utility overrides.

### Core Layout Principles
- **Intent Over Implementation**: Layout primitives use semantic names (`hb-stack`, `hb-cluster`) rather than functioning as collections of CSS property aliases (`hb-flex-col`).
- **Clear Separation**: Layouts manage spatial relationships, alignment, and distribution. They **never** define component visual identity (borders, backgrounds, shadows).
- **Composability**: Layout primitives (`hb-container`, `hb-stack`, `hb-cluster`, `hb-grid`, `hb-center`, `hb-flow`) are designed to be freely nested to construct complex page structures.
- **Native Foundations**: Built on native CSS Flexbox and Grid without relying on JavaScript or arbitrary rigid columns.

### Architectural Distinctions

HEBRING carefully distinguishes its core layout primitives:
- **`hb-container`**: Defines a content width boundary.
- **`hb-stack`**: Defines a vertical relationship between children with a default gap.
- **`hb-cluster`**: Defines a horizontal grouping relationship with wrapping.
- **`hb-grid`**: Defines a two-dimensional CSS Grid context.
- **`hb-flex`**: Defines a neutral Flexbox context without additional layout opinions.
- **`hb-center`**: Defines an opinionated centering pattern using Flexbox.
- **`hb-flow`**: Defines vertical content rhythm using normal document flow.

For a comprehensive overview of the layout design patterns and composition model, refer to:
- [Layout Philosophy](layout-philosophy.md) — Conceptual foundations, primitive vocabulary, and compositional rules.

---

## 12. Utilities

Phase 06 establishes the **Utilities Domain** (`src/utilities/`), providing single-purpose, small, composable classes for granular overrides.

### Core Utility Principles
- **Conveniences, Not Constraints**: Utilities exist to augment components and layouts, not to build everything from scratch.
- **Token-Aware**: Utilities directly map to existing primitive and semantic tokens (e.g., `--hb-space-*`).
- **Logical First**: Utilities use logical properties for layout flow (e.g., `inline`, `block`).

### Implemented Utilities
- **Spacing**: Padding, margin, and gap mapped to the 14-step spacing scale.
- **Display & Visibility**: Flow control (`block`, `inline`, `none`) and visibility (`visible`, `hidden`). Note that `hb-flex` and `hb-grid` are explicitly preserved as layout primitives.
- **Sizing**: Minimal width and height boundaries (`auto`, `full`).
- **Typography**: Narrow overrides for font size, weight, and logical alignment.
- **Alignment**: Item-level logical alignments (`align-self`, `justify-self`).

For a comprehensive overview of the utility APIs, refer to:
- [Spacing Utilities](spacing-utilities.md) — Documentation of margin, padding, and gap utility families.
- [Display & Visibility Utilities](display-visibility-utilities.md) — Documentation of flow and visibility overrides.
- [Sizing Utilities](sizing-utilities.md) — Documentation of the minimal width and height API.
- [Typography Utilities](typography-utilities.md) — Documentation of font size, weight, and alignment overrides.
- [Alignment Utilities](alignment-utilities.md) — Documentation of item-level alignment boundaries.

---

## 13. Component Architecture

Phase 07 establishes the **Component Domain** (`src/components/`), focusing on reusable UI patterns and their boundaries within the framework.

For a comprehensive overview of the component architecture, composition boundaries, and the Local Playground, refer to:
- [Component Architecture](component-architecture.md) — Architectural rules, dependencies, file organization, and Local Playground usage.
- [Component Naming and States](component-naming-and-states.md) — Structural BEM-style grammar and the native HTML/ARIA state philosophy.
- [Component Tokens](component-tokens.md) — Architectural rules for optional, locally-scoped component tokens.

---

## 14. Responsive System Architecture

Phase 08 establishes the **Responsive System** as an architectural concern layered over the existing cascade.

### Core Principles
- **Mobile-First**: Default styles represent the baseline experience and must work natively without requiring breakpoints.
- **Cascade Preservation**: Responsive behavior does not create a new cascade layer. The existing canonical layer order (`reset → base → layout → components → utilities`) remains authoritative. Responsive enhancements modify behavior from *within* their respective domains using native CSS `@media` rules.
- **Independence from Design Tokens**: Breakpoints are viewport threshold boundaries rather than literal design tokens. They are not defined in the `tokens/` domain.
- **Constraint**: HEBRING avoids breakpoint explosion and auto-generation of responsive variants. The framework provides utility-level and component-level responsiveness strictly where semantically meaningful.

For a comprehensive overview of the responsive philosophy and architectural boundaries, refer to:
- [Responsive Philosophy](responsive-philosophy.md) — Documentation of the mobile-first approach, cascade interactions, application CSS principles, and explicit exclusions (e.g. `@container`).

