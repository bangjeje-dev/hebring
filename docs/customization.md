# Customization Guide

This guide explains how to adapt and extend HEBRING for your specific application without fighting the framework, polluting the global namespace, or relying on heavy configuration abstractions.

## 1. Customization Philosophy

HEBRING is customized exclusively through **native CSS** and its **semantic design tokens**.

- **CSS-First**: Customizations are written as standard CSS.
- **Framework Agnostic**: No JavaScript theme managers or context providers are needed.
- **No Build-Time Configuration**: There is no JIT compiler, no `hebring.config.js`, and no build-time class generation.
- **Native Extension**: You extend HEBRING by writing your own CSS components and utilities alongside it.

Customization in HEBRING should always start at the smallest available abstraction layer:
1. Override semantic tokens
2. Build custom component variants
3. Write custom CSS

## 2. Customize Existing Semantic Tokens

The easiest way to customize HEBRING is to redefine the default semantic tokens at the `:root` level in your application's CSS. This globally affects all HEBRING utilities and components that consume those semantics.

If you want HEBRING's primary color to be purple instead of blue, you don't need to rebuild HEBRING. You simply point the semantic `--hb-color-primary` token to a different primitive value.

```css
/* In your application's global CSS (loaded after HEBRING) */
:root {
  /* Override the default primary color to use purple primitives */
  --hb-color-primary: var(--hb-color-purple-500);
  --hb-color-primary-hover: var(--hb-color-purple-400);
  --hb-color-primary-active: var(--hb-color-purple-600);
  --hb-color-primary-subtle: var(--hb-color-purple-950);
  --hb-color-focus: var(--hb-color-purple-500);
}
```

Because HEBRING's components (like `.hb-button`) map to semantic variables instead of hardcoded values, overriding the semantics instantly restyles the components without touching component CSS.

## 3. Create a Brand Theme

If you need a complete thematic shift (e.g., an entirely different high-contrast theme, or a specific brand theme), you follow the HEBRING theme architecture by mapping semantic tokens under a custom data attribute.

```css
/* In your application CSS */
[data-theme="brand-marketing"] {
  /* Redefine surfaces and text */
  --hb-color-background: var(--hb-color-neutral-000);
  --hb-color-surface: var(--hb-color-neutral-100);
  --hb-color-text: var(--hb-color-neutral-900);

  /* Redefine primary actions */
  --hb-color-primary: var(--hb-color-orange-500);
  --hb-color-on-primary: var(--hb-color-white);
  --hb-color-border: var(--hb-color-neutral-300);
}
```

You can then apply `data-theme="brand-marketing"` to the `<body>` or to a specific `<section>` to activate your custom visual context safely.

## 4. Add Application-Specific CSS

HEBRING intentionally does not provide every possible component, utility, or layout pattern. When a UI requirement falls outside HEBRING's scope, **you should write normal application CSS**.

When writing application CSS, you should consume HEBRING's semantic and primitive tokens to maintain visual consistency.

```css
/* A highly bespoke card component specific to your application */
.my-app-dashboard-card {
  /* Consume HEBRING primitive tokens for spacing */
  padding: var(--hb-space-6);
  border-radius: var(--hb-radius-lg);
  
  /* Consume HEBRING semantic tokens for colors */
  background-color: var(--hb-color-surface);
  border: 1px solid var(--hb-color-border);
  color: var(--hb-color-text);
  
  /* Use native CSS for highly specific bespoke layouts */
  display: grid;
  grid-template-columns: 1fr 200px;
}
```

By consuming HEBRING's tokens, `.my-app-dashboard-card` automatically supports the built-in dark theme without any extra work.

## 5. When Should I Use Existing Tokens?

**Always.** 
Whenever you are writing custom application CSS, you should draw from HEBRING's token scales (especially spacing, radius, and color primitives) rather than inventing arbitrary pixel values. This ensures that your custom UI harmonizes with the framework.

## 6. When Should I Create New Application-Level Styles?

- **Complex Interactivity**: If you need a fully accessible Accordion, Tabs, or Modal component that requires JavaScript, build it in your application layer. HEBRING provides the CSS foundation; you provide the JS behavior.
- **Bespoke Layouts**: If you need an asymmetrical grid or a complex responsive layout that changes drastically across breakpoints, write custom media queries instead of relying entirely on utility classes.
- **Custom Modifiers**: If HEBRING provides `.hb-button` but your application requires a `.hb-button--outline` variant, you can safely write that modifier in your application CSS alongside HEBRING.

## 7. Extending HEBRING vs. Application CSS

**Application CSS:** 
Code that only matters to the specific product you are building (e.g., `.checkout-cart-grid`).

**Extending HEBRING:**
If you notice that every application in your organization needs an `.hb-badge` component, that is a candidate to become a core HEBRING feature. 

When adding a feature to HEBRING, ensure it follows the strict architectural guidelines: CSS-first, framework agnostic, relies on semantic tokens, and isolates local component variables cleanly.
