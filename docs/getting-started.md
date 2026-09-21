# Getting Started

## What is HEBRING?

HEBRING is a modern, lightweight, and framework-agnostic CSS framework designed to provide a predictable foundation for building web interfaces. It is entirely CSS-based and requires no JavaScript runtime. 

Built on a robust architecture of design tokens, layout primitives, and composable utilities, HEBRING helps you create scalable and maintainable user interfaces with a clear mental model.

---

## Installation

Install HEBRING using npm (or your preferred package manager):

```bash
npm install hebring
```

---

## Using HEBRING

HEBRING is distributed as a pre-built CSS package. To include it in your project, simply import the framework stylesheet.

### Option 1: CSS Import
If you are using a bundler (like Vite, Webpack, or Lightning CSS), you can import the framework directly into your main stylesheet:

```css
@import "hebring";
```

For the explicitly minified version, use:

```css
@import "hebring/min";
```

### Option 2: JavaScript Import
In many modern frontend frameworks (e.g., React, Vue, Next.js), you can import the CSS artifact directly into your application's entry point:

```javascript
import 'hebring';
```

---

## Minimal Working Example

Once HEBRING is included in your project, you can begin using its classes immediately. HEBRING relies on semantic HTML and straightforward class names.

Here is a minimal HTML example using HEBRING's layout and component classes:

```html
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>HEBRING Quickstart</title>
  <!-- Assuming your bundler processes this or you point to node_modules/hebring/dist/hebring.css -->
  <link rel="stylesheet" href="/path/to/hebring.css">
</head>
<body>
  <!-- Container constraints the max-width and centers content -->
  <main class="hb-container hb-p-4">
    <!-- Stack layout handles vertical spacing -->
    <div class="hb-stack">
      <h1 class="hb-text-xl">Welcome to HEBRING</h1>
      <p class="hb-text-base">A predictable CSS framework for modern web interfaces.</p>
      
      <!-- Cluster layout groups items horizontally -->
      <div class="hb-cluster">
        <button class="hb-button">Get Started</button>
        <button class="hb-button hb-button--secondary">Documentation</button>
      </div>
    </div>
  </main>
</body>
</html>
```

### Dark Theme

HEBRING includes a built-in dark theme powered by semantic CSS variables. Simply apply the `data-theme="dark"` attribute to your `<html>` or `<body>` element (or any container) to activate it:

```html
<html data-theme="dark">
```

---

## Basic Structure

HEBRING organizes CSS into logical, composable boundaries:

- **Tokens**: The primitive values (colors, spacing, sizing) that power the framework.
- **Foundation**: A robust CSS reset and base element normalization.
- **Layout**: Primitive classes for structural arrangement (e.g., `.hb-stack`, `.hb-cluster`, `.hb-container`).
- **Components**: Reusable, pre-styled UI patterns (e.g., `.hb-button`).
- **Utilities**: Single-purpose classes for granular styling (e.g., `.hb-p-4`, `.hb-text-center`).

When you import HEBRING, these layers cascade in a strict, predictable order (`reset < base < layout < components < utilities`), meaning utilities will always safely override components when necessary.

---

## Next Steps

To get the most out of HEBRING, we recommend exploring the documentation in this sequence:

1. **[Documentation Philosophy](documentation-philosophy.md)**: Understand the HEBRING mental model.
2. **[Architecture](architecture-guide.md)**: Learn how the framework's CSS layers interact.
3. **[Themes](themes.md)**: Discover how semantic token mapping powers effortless theming.
4. **[Responsive Design](responsive.md)**: Learn how to build for multiple viewports.
