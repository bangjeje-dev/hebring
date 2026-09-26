# Themes Guide

This guide explains how HEBRING's theme architecture works, how to use the built-in dark theme, and how to create custom themes for your application.

## 1. What is a Theme?

In HEBRING, a **theme** is a contextual mapping of *semantic design tokens* to a coherent visual system. 

Themes **do not** redefine the primitive design system (the absolute colors, spacing, and typography scales). Instead, they change meaning-level visual values.

**The Mental Model:**
```text
Primitive Tokens (e.g., --hb-color-blue-500)
       ↓
Semantic Tokens  (e.g., --hb-color-primary)
       ↓
Theme Mapping    (e.g., in dark mode, --hb-color-primary becomes --hb-color-blue-400)
       ↓
Components / UI
```

This ensures your interface stays accessible and cohesive because the relationship between components relies on semantics, and themes merely adjust those semantics.

## 2. Built-in Themes

HEBRING intentionally ships with exactly two core themes:

1. **Default Theme** (Root/Light)
2. **Dark Theme**

### Default Theme
The default theme is established at the `:root` level. It works automatically without requiring any special HTML attributes.

**Important:** Do **not** use `data-theme="light"`. The default theme does not require an attribute and relying on one breaks the cascading fallback.

### Dark Theme
The built-in dark theme provides an accessible, high-contrast dark mode out of the box. It strictly uses the `[data-theme="dark"]` attribute selector.

## 3. Using the Dark Theme

To activate the dark theme, apply the `data-theme="dark"` attribute to a container. Usually, this is done at the document root level.

```html
<!DOCTYPE html>
<html lang="en" data-theme="dark">
<head>
  <meta charset="UTF-8">
  <title>Dark Mode Application</title>
</head>
<body>
  <!-- All HEBRING components and semantic utilities here will render in dark mode -->
</body>
</html>
```

*Note: HEBRING provides the CSS architecture. Implementing a JavaScript toggle to switch this attribute based on user preference or `prefers-color-scheme` is the responsibility of your application layer.*

## 4. How Theme Mapping Works

Themes operate exclusively on **semantic tokens**. 

When building a component, you should always use a semantic token like `--hb-color-surface`, never a primitive token like `--hb-color-neutral-000`.

**Why?**
If you use a primitive token, the theme cannot change it. Primitive tokens are absolute truth. Semantic tokens are contextual.

HEBRING's dark theme achieves its look simply by redefining the semantic variables inside the `[data-theme="dark"]` scope:

```css
/* Example of how the dark theme works internally */
[data-theme="dark"] {
  --hb-color-surface: var(--hb-color-neutral-900);
  --hb-color-text: var(--hb-color-neutral-50);
}
```

Because CSS custom properties inherit naturally down the DOM tree, any component inside an element with `data-theme="dark"` will automatically inherit the dark variants of the semantic variables.

## 5. Local and Nested Themes

Because HEBRING themes use CSS custom properties and standard data attributes, you can nest themes seamlessly.

```html
<!-- The page is using the default (light) theme -->
<body>
  <div class="hb-container">
    <p class="hb-text-color">I am dark text on a light background.</p>
    
    <!-- This specific section forces dark mode -->
    <section data-theme="dark" class="hb-p-4 hb-bg-surface">
      <p class="hb-text-color">I am light text on a dark background.</p>
      
      <!-- You can even nest back to the default if you build custom overrides! -->
    </section>
  </div>
</body>
```

## 6. Creating a Custom Theme

HEBRING is designed to be fully extensible. To create your own custom theme (e.g., a "high-contrast" or "brand" theme), you follow the exact same architectural pattern.

1. Pick an attribute selector (e.g., `[data-theme="brand-ocean"]`).
2. Redefine the HEBRING semantic tokens, pointing them to existing primitive tokens (or your own custom primitive tokens).

```css
/* Custom Theme Example */
[data-theme="brand-ocean"] {
  /* Redefining surface and text semantics */
  --hb-color-background: var(--hb-color-blue-950);
  --hb-color-surface: var(--hb-color-blue-900);
  --hb-color-text: var(--hb-color-blue-50);
  
  /* Redefining primary brand colors */
  --hb-color-primary: var(--hb-color-teal-500);
  --hb-color-primary-hover: var(--hb-color-teal-400);
  --hb-color-on-primary: var(--hb-color-black);
}
```

By hooking into HEBRING's semantic token layer, your custom theme automatically flows into all existing HEBRING components and utilities without needing to write custom CSS for every component.

## 7. Boundaries of the Theme System

- **No CSS Layer**: Themes do not require a specific `@layer` (like `@layer themes`). They are data attributes with the same specificity as standard classes, allowing them to naturally override the `:root` defaults.
- **No JavaScript**: HEBRING does not ship with a JavaScript runtime to manage theme switching.
- **No Component Tokens in Themes**: Themes should only override global *semantic* tokens (like `--hb-color-primary`). Themes should **never** override local *component* tokens (like `--hb-button-bg`). If a theme overrides semantic tokens correctly, the components will adapt automatically.
- **No Cascade Breakage**: Avoid using `!important` inside custom themes. Custom property inheritance handles the specificity perfectly.

## 8. Using Ecosystem Themes

HEBRING ships with optional alternative themes as part of its Ecosystem. These themes are distributed within the same `hebring` npm package but are not included in the Core build (`dist/hebring.css`).

To use an Ecosystem Theme (for example, `ocean`), import the CSS asset into your project:

**Bundler/Vite Example:**
```javascript
import "hebring/themes/ocean.css";
```

**HTML Example:**
```html
<link rel="stylesheet" href="node_modules/hebring/ecosystem/themes/ocean.css">
```

Once imported, you activate the theme exactly like the built-in dark theme:

```html
<html data-theme="ocean">
```

**Important Details:**
- Ecosystem themes are optional and do not change the Core default theme.
- Core does not automatically import ecosystem themes.
- Ecosystem themes only override semantic tokens and do not require JavaScript.
