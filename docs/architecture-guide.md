# Architecture Guide

This guide explains **how HEBRING works** as a CSS framework and **why** it is structured the way it is.

## Architectural Mental Model

HEBRING is a true CSS framework. It is CSS-first, framework-agnostic, and relies entirely on native CSS capabilities—requiring no JavaScript runtime or preprocessor JIT generation. 

Instead of wrapping all styling concerns into a single abstraction, HEBRING explicitly separates responsibilities. The conceptual structure is:

```text
Tokens
  ↓
Foundation
  ↓
Layout
  ↓
Components
  ↓
Utilities
```

*Note: **Responsive Utilities** and **Themes** extend this system, but they are **not** additional cascade layers. Responsive utilities selectively extend specific utilities via media queries, and themes manipulate semantic token values dynamically.*

---

## 1. Design Tokens

Tokens form the baseline values of the framework, separated into three distinct categories:

1. **Primitive Tokens**: The raw, absolute design values (e.g., `#3b82f6` for blue-500, `1rem` for spacing).
2. **Semantic Tokens**: Meaningful roles that consume primitive tokens (e.g., `--hb-color-primary` maps to `--hb-color-blue-500`).
3. **Themes**: Contextual overrides that remap semantic tokens based on application state.

**The Dependency Direction:**
```text
Primitive tokens → Semantic tokens → Theme overrides
```

**Architectural Rules:**
- Themes **never** redefine primitive tokens; they only remap semantic tokens.
- Components consume semantic tokens (often through component-level variables) rather than relying directly on primitives.
- There are no component-specific tokens living in the global token root.

---

## 2. Foundation

The Foundation layer establishes the browser baseline before any structural layout or components are applied.

It contains:
- **Reset**: An extremely minimal, non-aggressive browser normalization.
- **Base**: Global typographic and form normalizations built directly on HTML elements.

**Why it exists:** Foundation normalizes inconsistent browser defaults, establishing a predictable environment and ensuring baseline accessibility. HEBRING respects native browser behavior and semantic HTML, resetting only what is absolutely necessary.

---

## 3. Layout

Layout primitives define structural relationships.

Current layout primitives include:
- `.hb-container`
- `.hb-stack`
- `.hb-cluster`
- `.hb-grid`
- `.hb-flex`
- `.hb-center`
- `.hb-flow`

**Why it exists:** Rather than manually combining utilities to achieve standard spacing and flex/grid behaviors on every container, Layout classes handle structural composition semantically. They use modern native CSS (Flexbox, Grid) to dictate how children elements relate to one another. Layouts are strictly structural—they do not control typography, colors, or intricate styling details.

---

## 4. Components

**A component is a reusable UI pattern.**

Currently implemented components include:
- `.hb-button`

Components define meaningful visual relationships, rely on semantic HTML, and provide out-of-the-box interactive states (e.g., `:hover`, `:focus-visible`, `:active`, `:disabled`). 

**Component Modifiers:**
The button component ships with contextual modifiers rather than requiring manual utility reconstruction:
- `.hb-button--secondary`
- `.hb-button--danger`
- `.hb-button--sm`
- `.hb-button--lg`
- `.is-loading`

**Why it exists:** While utilities are excellent for precise adjustments, forcing developers to reconstruct a complex, interactive, accessible button purely from utilities leads to duplication and fragile UIs. "Utility handles one thing. Component defines a reusable UI pattern."

---

## 5. Utilities

Utilities are small, specific, composable adjustments.

**Why it exists:** "Utilities are conveniences, not constraints." They solve narrow, single-property concerns independent of component logic. 

**Architectural Rules:**
- Utilities can be combined freely.
- Utilities consume design tokens.
- Utilities **do not** require JavaScript.
- Utilities **do not** use `!important` as a brute-force override strategy (this is handled gracefully by Cascade Layers).
- Utilities should not unnecessarily duplicate meaningful structural arrangements that belong in Layout primitives.

**The Distinction:**
- **Component**: A complete, reusable UI pattern (e.g., a button).
- **Layout primitive**: A structural relationship (e.g., a stack of elements).
- **Utility**: A small, precise adjustment (e.g., adding padding).

---

## 6. Responsive System

HEBRING features a mobile-first, min-width responsive architecture.

Current breakpoints:
- `sm`: 640px
- `md`: 768px
- `lg`: 1024px

Responsive utilities follow a `{utility}-{breakpoint}` syntax (e.g., `.hb-block-md`). Breakpoints are cumulative, meaning styles applied at `sm` persist into `md` and `lg` unless overridden.

**Architectural Rules:**
- The responsive system generates variants *only* for utilities where responsiveness is genuinely meaningful (e.g., display, sizing, typography, alignment).
- It relies on native CSS `@media` queries; there is no JavaScript viewport detection.
- There are no responsive component variants (components handle their own fluid behavior natively where necessary).
- Responsive utilities exist inside the standard `utilities` cascade layer. **There is no `@layer responsive`**, preventing unnecessary cascade explosion.

---

## 7. Themes

HEBRING supports a dynamic theme architecture via HTML data attributes.

Current built-in themes:
- **Default/Root** (Base semantic tokens)
- **Dark** (`[data-theme="dark"]`)

**Why it exists:** Themes safely override semantic CSS custom properties without requiring alternative CSS class compilation.

**Architectural Rules:**
- The Default theme is the implicit baseline. It **does not** require `data-theme="light"`.
- Themes can be scoped globally (on the `<html>` element) or locally (on any container).
- Nested themes work automatically via native CSS custom property inheritance.
- Components and utilities remain strictly theme-agnostic—they simply consume the active semantic variable.
- Themes operate strictly via token manipulation. **Themes are not a cascade layer** and do not utilize `@layer themes`.

---

## 8. Cascade Layers

HEBRING resolves styling collisions elegantly using native CSS Cascade Layers (`@layer`).

The canonical CSS entry point (`src/index.css`) enforces this exact cascade order:

```css
@layer reset, base, layout, components, utilities;
```

**Why it exists:** Cascade layers eliminate specificity wars. Because `utilities` is defined last, a utility class like `.hb-text-center` will *always* successfully override a component's default text alignment, regardless of the component's internal selector weight. This completely removes the need for `!important` declarations across the framework.

---

## 9. Distribution

HEBRING is distributed as pre-compiled CSS artifacts via npm.

The framework provides a single canonical entry point yielding deterministic CSS artifacts:
- `dist/hebring.css`
- `dist/hebring.min.css`

The conceptual distribution flow is:
```text
CSS (HEBRING Source)
  ↓
Build Pipeline (Lightning CSS)
  ↓
Application / UI (Consumer imports hebring/dist/hebring.css)
```

By decoupling the CSS architecture from the build system, HEBRING guarantees that application developers can consume the framework seamlessly across Vite, Webpack, Next.js, or plain HTML without fighting framework-specific plugins or JIT compilers.
