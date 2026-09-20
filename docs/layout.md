# Layout Guide

This guide explains how HEBRING's layout system works, how to choose the right layout primitives, and how they compose together to build robust, semantic structures.

## 1. What Is a Layout Primitive?

A **layout primitive** defines a meaningful structural relationship between elements. 

While utilities adjust a single CSS property (like `padding` or `font-size`) and components provide full reusable UI patterns (like a `button`), layout primitives exist solely to arrange content. 

**"Utility handles one thing. Component defines a reusable UI pattern. Layout dictates structure."**

Rather than writing generic classes for every flexbox alignment, HEBRING distills common UI structural patterns into composable abstractions.

## 2. The Layout Philosophy

HEBRING's approach to layout is rooted in semantic intent and native CSS:

- **Semantic Intent**: You use a layout primitive based on the relationship it describes (e.g., a "stack" of items), not just the CSS properties it uses.
- **Native CSS**: Layouts utilize standard modern CSS (Flexbox and Grid).
- **No Class Explosion**: HEBRING does not provide an exhaustive alias for every possible Flexbox or Grid property.
- **CSS-Only**: Absolutely no JavaScript runtime required to calculate layouts.
- **Token-Aware**: Layout spacing seamlessly consumes the established token system.

## 3. Layout Primitive Reference

HEBRING intentionally ships with a curated set of core layout primitives.

### `hb-container`
**Purpose**: Establishes a page or content width boundary. It acts as a safety wrapper.
**CSS Concept**: Enforces a `max-width` (currently `80rem`), sets `width: 100%`, centers horizontally via `margin-inline: auto`, and provides baseline horizontal breathing room (`padding-inline`).
**When to use it**: To prevent content from stretching infinitely on large displays, typically at the root level of a page or major section.
**What NOT to do**: Do not use it for aligning small internal UI components.
```html
<main class="hb-container">
  Content constrained and centered horizontally.
</main>
```

### `hb-stack`
**Purpose**: Establishes a vertical relationship between direct children.
**CSS Concept**: Uses `display: flex` and `flex-direction: column` with a consistent `gap` (`--hb-space-4`).
**When to use it**: When building vertical forms, lists, or placing elements one above the other with consistent spacing.
```html
<div class="hb-stack">
  <label>Email</label>
  <input type="email">
</div>
```

### `hb-cluster`
**Purpose**: Establishes a horizontal grouping that wraps naturally.
**CSS Concept**: Uses `display: flex` with `flex-wrap: wrap` and a consistent `gap`.
**When to use it**: For tags, action button groups, or horizontal lists that need to wrap gracefully on smaller viewports.
```html
<div class="hb-cluster">
  <button class="hb-button">Save</button>
  <button class="hb-button">Cancel</button>
</div>
```

### `hb-grid`
**Purpose**: Establishes a two-dimensional layout context.
**CSS Concept**: Strictly applies `display: grid` with a consistent `gap`.
**When to use it**: When arranging items in a grid format. 
**What NOT to do**: HEBRING intentionally does not ship a generic column-count utility API (e.g. `cols-3`). Use standard CSS or utility extensions to define specific grid templates when needed.
```html
<div class="hb-grid">
  <div class="card">Item 1</div>
  <div class="card">Item 2</div>
</div>
```

### `hb-flex`
**Purpose**: A neutral, un-opinionated flex container.
**CSS Concept**: Applies `display: flex` and nothing else.
**When to use it**: When you need a generic flex context to be manipulated further by utilities.
**What NOT to do**: Do not assume it implies spacing or wrapping. HEBRING does not provide every possible Flexbox property as an alias.
```html
<div class="hb-flex hb-justify-between">
  <span>Left</span>
  <span>Right</span>
</div>
```

### `hb-center`
**Purpose**: An opinionated layout pattern for centering content on both axes.
**CSS Concept**: Uses Flexbox `align-items: center` and `justify-content: center`.
**When to use it**: When an element or icon must be absolutely centered within its container.
```html
<div class="hb-center">
  <p>Perfectly centered text</p>
</div>
```

### `hb-flow`
**Purpose**: Provides vertical content rhythm while preserving standard CSS document flow.
**CSS Concept**: Uses the lobotomized owl selector (`> * + *`) to apply `margin-block-start` (`--hb-space-4`) between sibling elements.
**When to use it**: When rendering dynamic rich text or markdown content where wrapping everything in a Flexbox stack isn't semantically appropriate.
```html
<article class="hb-flow">
  <h2>Heading</h2>
  <p>Paragraph 1</p>
  <p>Paragraph 2</p>
</article>
```

## 4. Composition

Layout primitives are explicitly designed to be composable. They are not mutually exclusive; you can nest them to build complex structures rapidly.

**Example Composition:**
A page wrapper (`hb-container`), holding a vertical rhythm (`hb-stack`), containing a header and a wrapped action group (`hb-cluster`) full of components (`hb-button`).

```html
<main class="hb-container">
  <section class="hb-stack">
    <h1>Page Title</h1>
    <p>Page description text.</p>
    
    <div class="hb-cluster">
      <button class="hb-button hb-button--primary">Primary Action</button>
      <button class="hb-button hb-button--secondary">Secondary Action</button>
    </div>
  </section>
</main>
```

## 5. Layout vs Utilities

While both are tools to construct UIs, their semantic intent differs strictly:

| Concern | Layout Primitive | Utility |
|---------|------------------|---------|
| **Scope** | Manages relationships *between* elements | Edits a single property on *one* element |
| **Examples**| `.hb-stack`, `.hb-cluster` | `.hb-p-4`, `.hb-text-center` |
| **Philosophy**| "Arrange these items together." | "Make this specific text bold." |

Utilities can and should be used to tweak layout behavior (e.g. using an alignment utility on a child element of an `.hb-stack`), but the core structural pattern belongs to the layout primitive.

## 6. Layout vs Components

Layouts and components answer fundamentally different architectural questions:

- **Layout** answers: *"How are these things structurally arranged?"*
- **Component** answers: *"What reusable UI pattern are these things?"*

You use an `.hb-button` (Component) to render an interactive action element. You wrap three of them in an `.hb-cluster` (Layout) to structure them together logically.

## 7. Responsive Layout

HEBRING explicitly separates responsive behavior into the utility layer.

There are **no responsive layout-specific APIs** inside HEBRING. You will not find classes like `hb-stack-md` or `hb-grid-lg` because that leads to an unmaintainable combinatorial class explosion.

If a layout must fundamentally change its structural relationship across viewports (e.g., swapping from a flex row to a grid at `768px`), developers should utilize standard CSS media queries or available responsive utilities rather than fighting with excessive framework abstractions.

## 8. Custom CSS

HEBRING does not attempt to abstract every possible CSS layout requirement.

If your design requires a layout relationship not represented by an existing HEBRING primitive (for example, a highly bespoke asymmetrical CSS Grid definition), **you should write normal CSS**.

This is highly intentional because it:
- Keeps the framework small and fast.
- Avoids an API class explosion.
- Preserves native CSS knowledge.
- Avoids forcing bespoke designs into rigid predefined classes.

## 9. Accessibility

Layout primitives should always preserve semantic HTML. 

HEBRING layout classes apply directly to standard HTML tags. You should never feel forced to replace a semantic `<header>`, `<main>`, `<ul>`, or `<article>` with a generic `<div>` just to use a layout class.

```html
<!-- Good: Preserving semantics while applying layout -->
<ul class="hb-stack">
  <li>Item 1</li>
  <li>Item 2</li>
</ul>
```

## 10. Quick Decision Guide

- **Need a page or content width boundary?** → `hb-container`
- **Need a consistent vertical sequence?** → `hb-stack`
- **Need a wrapping horizontal group?** → `hb-cluster`
- **Need CSS Grid structure?** → `hb-grid`
- **Need a generic flex container?** → `hb-flex`
- **Need to perfectly center something?** → `hb-center`
- **Need sibling vertical rhythm in a document flow?** → `hb-flow`
- **Need something outside these patterns?** → Write normal custom CSS.

## 11. Layout API Reference

| Primitive | Purpose | Underlying CSS Model |
|-----------|---------|----------------------|
| `.hb-container` | Width boundaries and centering | `max-width`, `margin: auto`, `padding` |
| `.hb-stack` | Vertical spacing | Flexbox (`column`), `gap` |
| `.hb-cluster` | Horizontal wrapping grouping | Flexbox (`wrap`), `gap` |
| `.hb-grid` | 2D structure | CSS Grid, `gap` |
| `.hb-flex` | Generic flex context | Flexbox |
| `.hb-center` | Absolute centering | Flexbox (`center`, `center`) |
| `.hb-flow` | Document vertical rhythm | `margin-block-start` (`> * + *`) |
