# HEBRING Starter Dashboard

The Starter Dashboard is the first official HEBRING reference template. It demonstrates how to compose a realistic, responsive application dashboard using only HEBRING primitives, ecosystem components, and semantic HTML.

## What it is
- A framework-neutral HTML/CSS reference implementation.
- A demonstration of how to combine Layout, Components, Themes, and Interactive UI into a cohesive application shell.
- A learning resource for developers new to HEBRING composition.

## What it is NOT
- A production-ready JavaScript application.
- A UI component library.
- A template framework or SSG (Static Site Generator).
- It does not contain Webpack, Vite, React, Vue, or any build system.

## How to use it
1. Copy the `index.html` and `assets/` folder to your project.
2. Ensure you have the HEBRING package installed (`npm install hebring` or via CDN).
3. Update the `<link>` tags in the HTML `<head>` to point to your `node_modules/hebring/` paths or your CDN links.
4. Replace the demo data and structural classes (`dashboard-*`) with your own framework-specific component architecture (e.g., React components) if desired.

## HEBRING Dependencies

This template consumes HEBRING as a public package. It relies on:
- **Core CSS:** Layout primitives (`hb-stack`, `hb-cluster`), utility classes, and base typography/buttons.
- **Ecosystem UI:** Cards, Menus, Popovers, and Dialogs.
- **Ecosystem Icons:** Direct SVG inclusion via `currentColor`.
- **Ecosystem Themes:** Inherits semantic variables, demonstrated natively.

## Customization

The template uses a very small local stylesheet (`assets/dashboard.css`) to define application-specific layout boundaries (e.g., the sidebar and main content area grid). These classes (`.dashboard-shell`, `.dashboard-sidebar`) intentionally do **not** use the `hb-*` prefix.

This is the recommended pattern: use `hb-*` for fundamental framework blocks, and use custom un-prefixed classes for your unique application macro-layouts.

## JavaScript Boundary

The JavaScript included in this template is intentionally minimal and vanilla. It serves **only** to demonstrate interactive behavior (such as toggling the mobile sidebar or opening a user menu) using native browser APIs. It is not a framework runtime and should be replaced by your application's actual state management layer (e.g., React `useState`, Alpine.js, etc.).
