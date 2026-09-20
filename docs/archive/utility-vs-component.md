# HEBRING Utility vs Component Philosophy

This document defines HEBRING's architectural philosophy for delineating responsibilities across **Foundation**, **Layout**, **Components**, and **Utilities**.

HEBRING is neither purely utility-first nor purely component-first. It is a **layered and composable CSS framework**.

---

## 1. Core Philosophy

HEBRING is founded on a clear guiding principle:

> **"Utility handles one thing. Component defines a reusable UI pattern."**

Modern CSS development often falls into one of two extremes:
1. **Component-only frameworks**, which risk rigidity, bloated component variants, and difficult ad-hoc adjustments.
2. **Utility-only frameworks**, which risk noisy HTML markup, repeated utility chains, and the absence of clear UI identity.

HEBRING takes a balanced, layered approach. The architecture enables developers to combine framework primitives naturally without forcing every UI element into either a utility-only or component-only approach.

---

## 2. Layer Responsibilities

HEBRING delineates architectural responsibilities across four distinct domains:

```
┌────────────────────────────────────────────────────────┐
│ Utilities   (hb-p-4, hb-flex, hb-w-full)               │ Single-purpose adjustments
├────────────────────────────────────────────────────────┤
│ Components  (hb-button, hb-card, hb-alert)             │ Reusable UI patterns
├────────────────────────────────────────────────────────┤
│ Layout      (hb-container, hb-grid, hb-stack)          │ Structural layout primitives
├────────────────────────────────────────────────────────┤
│ Foundation  (reset, base, element defaults)            │ Browser normalization & baselines
└────────────────────────────────────────────────────────┘
```

### 1. Foundation

Foundation establishes the baseline environment in which the rest of HEBRING operates.

**Responsible for:**
- Browser normalization and cross-browser consistency.
- CSS resets (box-sizing, margin resets, list normalization).
- Fundamental HTML behavior and accessible element defaults.
- Baseline typography and default element styling (headings, paragraphs, links).

**NOT intended for:**
- Visual UI components.
- Structural layout abstractions.
- Utility classes.

**Examples:**
- `box-sizing: border-box` normalization.
- Baseline `body` margins, font smoothing, and text color.
- Default link hover and focus styles.
- Form control normalization (baseline `button`, `input`, `select`).

---

### 2. Layout

Layout contains meaningful structural layout primitives that govern how content is organized on a page or across sections.

**Responsible for:**
- Structural scaffolding and macro layout.
- Content width constraints and centering.
- Multi-dimensional layout systems (grids) and flow management (stacks).

**Key Principle: Meaningful Concepts, Not Every CSS Property**
> A layout primitive must represent a meaningful, reusable structural concept. Do not create a layout class for every individual CSS property or combination.

**Examples of Good Layout Primitives:**
- `hb-container`: Manages responsive max-widths and horizontal centering.
- `hb-grid`: Defines structured, track-based spatial relationships.
- `hb-stack`: Manages vertical rhythm and spacing between sibling elements.

**NOT the Goal:**
- Creating separate framework classes for every conceivable combination of `display`, `position`, `grid`, `flex`, `gap`, `align-items`, and `justify-content`.
- Layout primitives help developers express page and structural relationships, not micromanage individual CSS declarations.

---

### 3. Components

Components represent recognizable, reusable visual interface patterns.

**Responsible for:**
- Encapsulating cohesive visual design patterns.
- Multi-declaration styling that gives elements their distinct visual identity.
- Interactive states (hover, focus, active, disabled) intrinsic to the pattern.
- Variants and modifiers (`--primary`, `--large`) and structural sub-elements (`__header`, `__body`).

**Examples:**
- `hb-button`
- `hb-card`
- `hb-alert`
- `hb-badge`
- `hb-modal`
- `hb-input`

#### Components May Contain Multiple Declarations

A component is not simply one CSS property. A component exists because multiple declarations collectively define a recognizable and reusable UI pattern:

```css
/* hb-button defines an entire pattern */
.hb-button {
  display: inline-flex;
  align-items: center;
  justify-content: center;
  font-family: inherit;
  font-size: var(--hb-font-size-base);
  padding: var(--hb-space-2) var(--hb-space-4);
  border: 1px solid transparent;
  border-radius: var(--hb-radius-md);
  background-color: var(--hb-color-neutral);
  color: var(--hb-color-text);
  text-decoration: none;
  cursor: pointer;
  transition: background-color 150ms ease, border-color 150ms ease;
}
```

This multi-declaration definition does **not** violate the utility philosophy. The declarations collectively define the cohesive button pattern.

#### Baseline Completeness Requirement

A component **must** have its own baseline styling. A component must **never** require utility classes in order to become functional or visually valid.

```html
<!-- GOOD: The component is visually complete and self-contained -->
<button class="hb-button hb-button--primary">
  Save Changes
</button>

<!-- NOT REQUIRED: The component should never require utility scaffolding -->
<button class="hb-button hb-flex hb-items-center hb-px-4 hb-py-2 hb-rounded hb-bg-blue hb-text-white">
  Save Changes
</button>
```

Utilities may enhance or modify a component, but the component itself must remain fully valid and usable on its own.

---

### 4. Utilities

Utilities represent small, single-purpose CSS behaviors designed for targeted adjustments and compositional control.

**Responsible for:**
- Single-purpose property application (spacing, visibility, alignment).
- Narrow, atomic layout adjustments.
- Situational overrides without leaving the markup.

**Key Principle: Useful Primitives, Not Every Possible Declaration**
> A utility should perform one narrow responsibility. However, HEBRING must NOT attempt to reproduce the entire CSS specification as utility classes.

**Examples:**
- `hb-p-4` (padding)
- `hb-mt-6` (margin-top)
- `hb-flex` (display: flex)
- `hb-hidden` (display: none)
- `hb-text-center` (text-align: center)
- `hb-w-full` (width: 100%)

Utilities are deliberately selected based on common practical usage and framework consistency, rather than mechanical generation of every CSS property.

---

## 3. Composition

Components and utilities are designed to compose together seamlessly.

- The **component** establishes the reusable UI pattern and visual identity.
- The **utility** provides a targeted, narrow adjustment for a specific context.

### Composition Examples

**Modifying Component Spacing:**
```html
<div class="hb-card hb-p-6">
  <h3>Card Title</h3>
  <p>Card content with adjusted internal padding.</p>
</div>
```

**Modifying Component Sizing / Display:**
```html
<button class="hb-button hb-button--primary hb-w-full">
  Submit Order
</button>
```

Neither abstraction becomes coupled to or dependent on the other. The component functions identically without the utility, and the utility functions identically without the component.

---

## 4. Component Independence

**Components must NOT depend on utilities.**

A component must never be architected as a skeletal class that requires auxiliary utilities to look acceptable or complete:

```html
<!-- ANTI-PATTERN: Incomplete component requiring utilities -->
<div class="hb-card hb-p-6 hb-shadow hb-rounded">
  ...
</div>

<!-- HEBRING PATTERN: Complete, self-sufficient component -->
<div class="hb-card">
  ...
</div>
```

`hb-card` defines its own baseline padding, border, background, and radius. Utilities can subsequently adjust these values if a specific page context warrants it, but the baseline card remains robust without any extra classes.

---

## 5. Utility Independence

**Utilities must NOT depend on components.**

A utility class must operate at its own abstraction level and remain completely agnostic of where it is applied.

For example, `hb-p-6` must apply `padding: var(--hb-space-6)` identically whether it is placed on:
- A component: `<div class="hb-card hb-p-6">`
- A layout primitive: `<div class="hb-container hb-p-6">`
- A semantic HTML element: `<section class="hb-p-6">`
- An application-specific element: `<aside class="sidebar hb-p-6">`

A utility must never contain component-specific selectors, context queries, or specialized overrides.

---

## 6. Cascade Relationship

HEBRING enforces layer precedence through native CSS Cascade Layers:

```css
@layer reset, base, layout, components, utilities;
```

Because `@layer utilities` is declared **after** `@layer components`, utilities naturally take precedence in the cascade:

```
components layer  <  utilities layer
```

### Clean Cascade Overrides (No `!important`)

When a utility is applied to a component, the utility cleanly overrides the component's declaration through layer order—**without specificity escalation and without `!important`**:

```html
<button class="hb-button hb-button--primary hb-w-full">
  Submit
</button>
```

- In `@layer components`, `.hb-button` defines default button sizing (e.g. `width: auto;`).
- In `@layer utilities`, `.hb-w-full` defines `width: 100%;`.
- Because the `utilities` layer has higher cascade priority than `components`, `width: 100%` wins naturally.

```
Cascade Layers  >  Specificity Escalation  >  !important
```

`!important` must never be used as a solution to component-utility conflicts.

---

## 7. Component Identity vs Utility Adjustment

Clear boundary definition is vital to preventing framework degradation:

| Abstraction | Role | Question It Answers | Example |
| :--- | :--- | :--- | :--- |
| **Component** | **Identity** | *"What is this element?"* | `hb-button` → *"This is a HEBRING button."* |
| **Modifier** | **Variant** | *"Which variant of this pattern?"* | `hb-button--primary` → *"This is the primary variant."* |
| **Utility** | **Adjustment** | *"What single adjustment is needed?"* | `hb-w-full` → *"Make this element full width."* |

- **Do not** allow components to dissolve into collections of arbitrary utilities.
- **Do not** allow utilities to become disguised, compound component definitions (e.g., `hb-button-like`).

---

## 8. Coexistence with Application CSS

HEBRING is designed to coexist peacefully with application-specific and user-authored CSS:

```html
<button class="hb-button hb-button--primary checkout-submit">
  Continue to Payment
</button>
```

### Namespace Boundaries
- All HEBRING framework classes use the reserved `hb-` namespace.
- Application-specific classes (e.g., `checkout-submit`, `user-avatar`, `analytics-hook`) exist freely outside the `hb-` namespace.
- HEBRING never attempts to control, namespace, or dictate application-level class structures.
- User CSS authored outside `@layer` or in custom user layers naturally integrates according to CSS cascade rules.

---

## 9. Decision Tree: Where Does Code Belong?

When considering introducing a new rule or class to HEBRING, follow this decision tree:

```
                         [ New Requirement ]
                                  │
         Is this a foundational browser normalization or HTML reset?
                                ├───► YES: Foundation (reset / base)
                                │
         Is this a meaningful structural layout primitive?
                                ├───► YES: Layout (hb-container, hb-grid, hb-stack)
                                │
         Is this a cohesive, reusable UI pattern?
                                ├───► YES: Component (hb-button, hb-card, hb-alert)
                                │
         Is this a narrow, single-purpose adjustment?
                                ├───► YES: Utility (hb-p-4, hb-flex, hb-hidden)
                                │
                                └───► NO / UNCLEAR:
                                      Re-evaluate the abstraction.
                                      Do not create a framework class.
```

1. **Is this a foundational browser/HTML rule?**
   → **Foundation**: Belongs in `reset.css` or `base.css` without dedicated class names where possible.
2. **Is this a meaningful structural layout primitive?**
   → **Layout**: Belongs in `layout/` as an explicit structural primitive (`hb-container`, `hb-grid`, `hb-stack`).
3. **Is this a reusable UI pattern?**
   → **Component**: Belongs in `components/` as a self-contained component pattern (`hb-button`, `hb-card`).
4. **Is this a narrow, single-purpose adjustment?**
   → **Utility**: Belongs in `utilities/` as an atomic property class (`hb-p-4`, `hb-w-full`).
5. **If none of the above clearly applies:**
   → Re-evaluate the abstraction. Avoid creating ad-hoc or hybrid classes.

---

## 10. Conceptual Responsibility vs Module Dependency

This architecture defines **conceptual responsibility** and **cascade precedence**.

It does **NOT** represent an import dependency chain:

```
INCORRECT ASSUMPTION (Dependency Chain):
Foundation  ──►  imports Layout  ──►  imports Components  ──►  imports Utilities
```

Domains do not import or depend on one another:
- `foundation/` does not import `layout/`.
- `layout/` does not import `components/`.
- `components/` does not import `utilities/`.

Each domain is self-contained. The framework entry point (`src/index.css`) composes the domains into their respective `@layer` positions:

```css
@layer reset, base, layout, components, utilities;

@import "./foundation/index.css";
@import "./layout/index.css";
@import "./components/index.css";
@import "./utilities/index.css";
```

Composition occurs through the CSS cascade, not through coupled stylesheet imports.

---

## 11. Anti-Patterns HEBRING Intentionally Avoids

To maintain architecture health, HEBRING explicitly rejects the following patterns:

1. **Utility class for every CSS declaration**:
   Replicating the entire CSS specification leads to unmaintainable bloat and cognitive overload. HEBRING provides curated, high-value utilities.
2. **Components requiring utilities to function**:
   A component that looks unstyled without companion utility classes violates component completeness.
3. **Utilities that only work with specific components**:
   Coupling utilities to specific component selectors destroys utility portability.
4. **Components implemented as utility collections**:
   Wrapping 15 utility classes into a macro or pseudo-component defeats the clarity of a dedicated component stylesheet.
5. **Excessive abstraction**:
   Inventing layout or utility classes for single-property, rarely-used CSS properties.
6. **Specificity escalation**:
   Chaining classes (e.g. `.hb-button.hb-button--primary.is-large`) to force overrides instead of relying on cascade layers.
7. **Unnecessary `!important`**:
   Using `!important` to force overrides across framework boundaries.
8. **Recreating Tailwind's entire utility model**:
   HEBRING is not a utility-only compiler; it values semantic components with intrinsic styling.
9. **Recreating Bootstrap's component model**:
   HEBRING avoids heavy, highly-opinionated, rigid components that cannot easily be adjusted with light utilities.
10. **Mixing architectural responsibilities**:
    Placing layout abstractions inside component files or utility overrides inside foundation files.
