# Responsive Guide

This guide explains HEBRING's responsive architecture, how breakpoints work, and how to use responsive utilities effectively.

## 1. Responsive Philosophy

HEBRING's approach to responsive design is rooted in the following principles:
- **Mobile-First**: Base styles apply everywhere. Responsive variants enhance designs at larger viewport widths.
- **CSS-Native**: Relies purely on CSS `@media` queries.
- **Minimal API**: Does not bloat the framework by making every single class responsive.
- **Base Styles First**: Responsive behavior is an enhancement of the base CSS, not a separate runtime system.
- **Framework Agnostic**: No JavaScript viewport detection is required.
- **Meaningful Scope**: Responsive classes only exist where responsive behavior is genuinely meaningful.

## 2. Mobile-First Model

HEBRING uses a **mobile-first** mental model. 

```text
Base class
  ↓
Responsive enhancement
```

When you write `.hb-none .hb-block-md`, the `.hb-none` class hides the element globally (starting from the smallest screens). Once the viewport reaches the `md` threshold, the responsive `.hb-block-md` class overrides it, making the element visible.

## 3. Breakpoints

HEBRING ships with three carefully chosen viewport thresholds:

- `sm`: **640px**
- `md`: **768px**
- `lg`: **1024px**

**Important Architectural Rules:**
- These are **minimum-width** (`min-width`) thresholds.
- The names (`sm`, `md`, `lg`) represent pixel thresholds, not specific devices (like "tablet" or "desktop").
- They are hardcoded in the media queries. They are not CSS custom properties because CSS does not currently allow custom properties in `@media` query conditions natively.
- There are currently no `xl` or `2xl` breakpoints.

## 4. Responsive Naming

Responsive utilities follow a strict syntax:

`{utility}-{breakpoint}`

**Verified Examples:**
- `.hb-none-sm`
- `.hb-block-md`
- `.hb-w-full-lg`
- `.hb-text-xl-md`
- `.hb-text-center-lg`

The responsive suffix modifies an *existing* supported utility class.

## 5. Responsive Coverage

HEBRING intentionally limits responsive variants to prevent catastrophic CSS bloat. Currently, the following utility categories support responsive variants:

- **Display / Visibility** (e.g., `.hb-block-md`, `.hb-invisible-lg`)
- **Sizing** (e.g., `.hb-w-auto-sm`, `.hb-w-full-lg`)
- **Typography Font-Size** (e.g., `.hb-text-lg-sm`, `.hb-text-2xl-md`)
- **Typography Text Alignment** (e.g., `.hb-text-center-md`, `.hb-text-start-lg`)
- **Alignment** (e.g., `.hb-self-start-sm`, `.hb-justify-self-center-md`)

**Intentionally EXCLUDED:**
- **Spacing**: `.hb-p-4-md` does not exist. Responsive spacing utilities cause massive CSS bloat. Use custom CSS for complex responsive padding logic.
- **Font-Weight**: `.hb-font-bold-md` does not exist, as font-weight rarely changes across breakpoints structurally.

## 6. Cumulative Breakpoint Behavior

Because HEBRING uses `min-width` media queries, responsive classes are cumulative. 

```text
base
  ↓
sm
  ↓
md
  ↓
lg
```

If you apply `.hb-text-sm .hb-text-lg-md`, the text will be `sm` size on mobile devices, remain `sm` on `640px` screens, and switch to `lg` size at `768px`. It will continue to be `lg` size at `1024px` and above, unless explicitly overridden by an `-lg` class.

## 7. Responsive Composition

You can combine responsive utilities with base utilities to create dynamic behaviors safely.

```html
<div class="hb-flex hb-text-center hb-text-start-md">
  <!-- 
    Content is centered on mobile and small screens, 
    but aligns to the start on medium and large screens. 
  -->
  <p class="hb-text-sm hb-text-lg-lg">Responsive Text</p>
</div>
```

## 8. Responsive Utilities and Layout

HEBRING establishes an intentional boundary between utilities and layouts.

**There are NO responsive layout-specific APIs.**
Classes like `hb-stack-md` or `hb-grid-lg` do not exist. Generating responsive variants for every structural layout pattern would cause an unmanageable API explosion.

If a complex layout fundamentally changes structure across viewports (e.g., changing from a stacked column to a multi-column grid), developers should use native CSS media queries. 

## 9. Responsive Utilities and Components

HEBRING does not provide automatic responsive component variants.
Classes like `hb-button--mobile` or `hb-button--sm-md` do not exist.

Components in HEBRING are designed to be fluid by default (e.g., a button fits its content or expands to its container). If a component requires distinct responsive behavior, application-level CSS or supported responsive sizing utilities can be composed around it.

## 10. Custom Media Queries

When HEBRING's responsive utility API does not cover a specific requirement, you should write normal CSS media queries in your application code.

```css
/* Example custom application behavior */
.my-custom-card {
  padding: var(--hb-space-4);
}

@media (min-width: 768px) {
  .my-custom-card {
    padding: var(--hb-space-8);
  }
}
```

This keeps the framework small and preserves native CSS knowledge.

## 11. Responsive vs JavaScript

Responsive behavior in HEBRING is 100% CSS-native. 
You should **not** use JavaScript viewport detection (`window.innerWidth` or `matchMedia`) for ordinary responsive styling. 

CSS media queries are:
- Simpler
- Framework agnostic
- Free of runtime dependencies
- Capable of working with plain HTML
- Inherently predictable

## 12. Accessibility

When designing responsive layouts, ensure that viewport changes do not destroy:
- Semantic HTML structure.
- Keyboard access.
- Visible focus outlines.
- Meaningful content reading order.

Do not use `.hb-none` to hide critical interactive elements strictly on mobile if they are required for task completion, unless an accessible alternative exists on that viewport.

## 13. Quick Decision Guide

- **Need a responsive change in a supported utility?** → Use the responsive utility (e.g., `.hb-none-md`).
- **Need structural responsive behavior not represented by HEBRING?** → Use normal CSS media queries.
- **Need JavaScript behavior based on the viewport?** → That is application behavior, not HEBRING's CSS responsive system.
- **Need a new HEBRING responsive API?** → Establish a concrete use case and architecture decision before adding to the framework.

## 14. Responsive API Reference

| Category | Responsive Support | Breakpoints |
|----------|--------------------|-------------|
| **Display / Visibility** | ✅ Yes | `sm`, `md`, `lg` |
| **Sizing** | ✅ Yes | `sm`, `md`, `lg` |
| **Typography Size** | ✅ Yes | `sm`, `md`, `lg` |
| **Text Alignment** | ✅ Yes | `sm`, `md`, `lg` |
| **Item Alignment** | ✅ Yes | `sm`, `md`, `lg` |
| **Spacing** | ❌ No | - |
| **Font Weight** | ❌ No | - |
| **Layout Primitives** | ❌ No | - |
| **Components** | ❌ No | - |
