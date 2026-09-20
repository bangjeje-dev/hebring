# Component Architecture

Phase 07.2 establishes the component architecture and boundaries for HEBRING.

## Component Domain

The Components layer (`src/components/`) sits precisely at the center of the cascade:

`reset → base → layout → components → utilities`

This guarantees components naturally inherit baseline semantic rules and layout contexts, while remaining safely overridable by utility classes.

## Composition Boundary

The entry point for all components is `src/components/index.css`. This file acts as the explicit architectural boundary. Individual components are defined in their own CSS modules (e.g., `button.css`, `card.css`) and aggregated into `index.css`. All rules within these component files must reside inside the `@layer components` cascade step.

## File Organization and Naming

- **One component per module**: A `button` component gets exactly one file (`button.css`). No premature nested folders.
- **Naming Conventions**: Filenames use lowercase `kebab-case`. Component class names follow the `hb-{component}` prefix format.

## Dependency Direction

Component architecture explicitly enforces a strict dependency direction:
- Components **may** depend on design tokens, Foundation semantics, and Layout primitives conceptually.
- Components **must not** import `src/utilities/` or rely on utility classes for their internal construction. Utilities are optional composition mechanisms applied externally in the DOM.

## Exclusions

To keep the framework robust and unbloated, HEBRING explicitly rejects:
- Component dependency on JavaScript or frontend frameworks (React/Vue/Svelte).
- Premature component-token architecture (no arbitrary abstraction layers).
- Utility-first component construction.
- Mixing Layout primitive responsibility inside components.

## Local Playground Architecture

The Local Playground (`examples/playground/`) is a pristine testing ground for visual development and demonstration.

- **Plain HTML + CSS**: The playground exclusively uses native web standards to render HEBRING.
- **Zero Build Frameworks**: It intentionally excludes bundlers (Vite/Webpack) and JavaScript frameworks (React/Next.js) to guarantee HEBRING remains a CSS-first, framework-agnostic system.
- **Package Exclusion**: The playground lives outside of `src/` and is strictly excluded from the `npm` core package distribution.
