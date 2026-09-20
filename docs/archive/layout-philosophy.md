# HEBRING Layout Philosophy

This document outlines the conceptual foundations, composition model, and architectural rules governing the **Layout Domain** (`src/layout/`) in the HEBRING CSS framework.

---

## 1. Core Layout Principles

The following principles govern the design and implementation of layout primitives in HEBRING:

1. **Relationship-Driven**: Layout defines structural relationships between elements (e.g., vertical stacking, flexible clustering), rather than styling individual elements.
2. **Utilities vs. Layouts**: Utilities provide narrow, single-purpose adjustments (e.g., `margin-top: 16px;`, `display: flex;`). Layout primitives represent meaningful, recurring structural patterns.
3. **Intentional Vocabulary**: Layout primitives must have clear, semantic, intention-based names that communicate their purpose (e.g., `hb-stack` vs. `hb-flex-col`).
4. **Native Foundations**: Native CSS Flexbox and Grid remain the technical foundation. HEBRING abstracts their complexity into predictable primitives.
5. **Composability**: Layout primitives must be composable. A stack can exist within a grid, a cluster within a stack.
6. **No Component Identity**: Layout primitives must not define component visual styling (e.g., borders, backgrounds, shadows).
7. **Framework-Agnostic**: Layout rules must remain purely CSS-driven, avoiding JavaScript-dependent masonry or resize logic.
8. **No Layout Tokens**: Layout must not introduce component-specific design tokens (e.g., `--hb-container-width`), relying instead on standard metrics or contextual definitions.
9. **Curated Patterns, Not CSS Aliases**: HEBRING avoids becoming a Tailwind-style collection of property aliases. We provide useful primitives, not every possible CSS layout combination.
10. **Intrinsic Responsiveness**: Responsive behavior belongs primarily to the future Responsive System phase. However, a layout primitive may possess intrinsic responsive behavior (e.g., wrapping) that does not require a complex breakpoint API.

---

## 2. Layout vs. Utilities vs. Components

A clear architectural distinction is maintained to avoid scope leak:

### Layout
- **Purpose**: Defines structure and spatial relationships.
- **Examples**: `hb-container`, `hb-stack`, `hb-cluster`, `hb-grid`.
- **Characteristics**: Manages child distribution, alignment, and gaps. Does not provide visual aesthetics.

### Utilities
- **Purpose**: Provides narrow, single-property adjustments.
- **Examples**: `hb-text-center`, `hb-w-full`, `hb-p-4`.
- **Characteristics**: Overrides specific properties. While utilities might alter layout properties (e.g., `hb-flex`), they don't form a cohesive conceptual pattern on their own.

### Components
- **Purpose**: Defines reusable UI patterns with strong visual identity.
- **Examples**: `hb-button`, `hb-card`, `hb-modal`.
- **Characteristics**: Manages borders, backgrounds, typography, and states. **Components may compose Layout primitives conceptually, but Layout must never depend on Components.**

---

## 3. Prefer Intent Over Implementation

When a developer's intent is to create a vertical list of items with consistent spacing, HEBRING prefers a semantic abstraction over a collection of utility classes.

**Preferred Conceptual API (Intent-Driven):**
```html
<div class="hb-stack">
  <div>Item 1</div>
  <div>Item 2</div>
</div>
```

**Avoided Implementation (Alias-Driven):**
```html
<div class="hb-flex hb-flex-col hb-gap-4">
  <div>Item 1</div>
  <div>Item 2</div>
</div>
```

The class name should always communicate *what the layout is conceptually achieving*, not *how the CSS engine is rendering it*.

---

## 4. Initial Conceptual Primitive Vocabulary

The layout domain will implement the following core primitives:

### 1. `hb-container`
- **Responsibility**: Establishes a content width boundary and handles horizontal centering.
- **Constraints**: No component styling (no background, border, or padding defaults beyond basic gutters).

### 2. `hb-stack`
- **Responsibility**: Establishes a vertical relationship between children, providing consistent vertical spacing (gaps).
- **Constraints**: No typography or component styling.

### 3. `hb-cluster`
- **Responsibility**: Groups items horizontally with flexible wrapping behavior.
- **Use Cases**: Tags, action buttons, metadata blocks, form controls, navigation item groups.

### 4. `hb-grid`
- **Responsibility**: Establishes two-dimensional layout relationships.
- **Constraints**: Built on native CSS Grid. It must **not** regress into an old-style mandatory 12-column rigid framework.

### 5. `hb-center`
- **Responsibility**: Intentional vertical and/or horizontal centering of content.
- **Constraints**: Strictly layout-focused; no component styling.

### 6. `hb-flow`
- **Responsibility**: Manages document/content flow spacing where appropriate, acting on generic prose blocks.
- **Constraints**: Must not manipulate component identity.

---

## 5. The Composition Model

Layout primitives are designed to be freely nested and composed to construct complex page structures without writing custom CSS. 

**Composition Example:**
```html
<div class="hb-container">
  <div class="hb-stack">
    <h1>Build faster.</h1>
    <p>A predictable CSS framework.</p>

    <div class="hb-cluster">
      <button class="hb-button">Get Started</button>
      <a href="/docs">Read the docs</a>
    </div>
  </div>
</div>
```

**Breakdown of Responsibilities:**
- `hb-container` → Restricts maximum width and centers the entire block on the page.
- `hb-stack` → Stacks the heading, paragraph, and action cluster vertically with consistent spacing.
- `hb-cluster` → Groups the button and link horizontally, allowing them to wrap gracefully on very small screens.

By keeping these primitives decoupled from components, they remain universally useful across the entire application.

---

## 6. Explicit Non-Goals

To maintain focus and avoid framework bloat, the following are explicit non-goals for the Layout layer:

1. **Do not create an alias for every Flexbox property.** If a developer needs highly specific, ad-hoc flex alignment, they should use utility classes or write custom CSS, rather than forcing a layout primitive to support every edge case.
2. **Do not embed responsive breakpoint classes into layout primitives yet.** Complex responsive APIs (like `hb-stack-md`, `hb-grid-lg`) belong to the dedicated Responsive System phase.
3. **Do not add JavaScript.** Layouts must resolve purely through native CSS rendering.
