# Build & Distribution Philosophy

Phase 10 establishes the official architecture and philosophy for HEBRING's build and distribution pipeline. 

HEBRING is a CSS framework, not a JavaScript framework. The build system exists to serve the CSS framework rather than shaping the framework around any particular build tool.

---

## 1. Core Principles

> **"Build tooling is infrastructure. It must never become the identity of HEBRING."**
> 
> **"HEBRING should remain understandable even when the build tool is not."**

### CSS-First
HEBRING's core remains native CSS. The build process must not turn HEBRING into a JavaScript runtime framework.

### Minimal Build Dependencies
Build dependencies must be introduced only when they solve a concrete distribution or authoring problem. We avoid toolchain complexity for its own sake.

### Source of Truth
The `src/` directory remains the canonical authoring and source architecture. Build output must be derived from `src/` and must never become the source of truth.

### Distributable Output
The build process must eventually produce artifacts suitable for actual developer consumption. The future architecture should support a distribution model such as:
```text
src/  →  build  →  dist/
```

---

## 2. Framework & Environment Agnostic

The distributed CSS must be consumable by any frontend environment, including:
- Plain HTML/CSS
- Vite projects
- React projects
- Vue projects
- Any other frontend ecosystem

HEBRING core must not depend on a specific frontend framework.

### No Runtime JavaScript
HEBRING CSS must not require JavaScript at runtime. While build tooling may exist during development and distribution, the resulting framework must remain CSS-first.

### No JIT / Class Generation Engine
HEBRING is not Tailwind. Classes are authored and distributed as part of the framework itself. The build system must not scan user application files and dynamically generate HEBRING utility classes.

### Native CSS Features
HEBRING prefers native CSS capabilities:
- CSS custom properties (`var(--hb-...)`)
- Cascade layers (`@layer`)
- Media queries (`@media`)
- Semantic tokens
- Data-attribute selectors (`[data-theme="..."]`)

Do not introduce preprocessing (like Sass or Less) simply because other CSS frameworks commonly use it.

---

## 3. Distribution Model

### NPM Distribution
The architecture should support HEBRING being installed through npm. The package will expose clear CSS entry points.

### CDN Distribution
The architecture should support a browser-consumable CSS artifact suitable for CDN distribution (e.g., unpkg, jsdelivr).

### Source Accessibility
The npm package should preserve useful source CSS for transparency, debugging, and framework inspection.

### Predictable Output
Developers should be able to understand exactly what they are importing. We avoid opaque build output or unnecessary generated artifacts.

### Development vs Distribution
We clearly distinguish between source files used to develop HEBRING and generated files intended for package consumers. The distribution architecture will allow readable source-oriented CSS and optimized production CSS where appropriate.

---

## 4. Build Architecture Boundaries

### No Premature Optimization
We do not introduce the following tools unless a later phase establishes a concrete requirement for them:
- PostCSS
- Sass / Less
- CSS-in-JS
- CSS Modules
- Autoprefixer
- Plugin chains
- Complex bundler configurations

*Note: This is a philosophical stance, not a blanket statement that these tools can never be used. They must earn their place.*

### Build Tool Independence
The architecture must remain conceptually independent from any specific tool such as Vite, Rollup, esbuild, PostCSS, or Lightning CSS. Tool selection belongs to a later architecture phase after strict distribution requirements are defined.

### Zero Runtime Theme/Utility Engine
Themes, utilities, responsive behavior, and components must continue to work through the CSS already present in the distributed framework. No runtime engine should be required.

### Minification
Production-oriented minified CSS may be generated as a distribution artifact, but readable CSS should remain available alongside it.

---

## 5. Relationship to Existing Architecture

Build & Distribution must package the existing HEBRING architecture without changing its conceptual layering or token flow:

**CSS Source Architecture:**
`Foundation → Layout → Components → Utilities`

**Token Source Architecture:**
`Primitives → Semantic → Themes`

**Cascade Layers:**
`@layer reset, base, layout, components, utilities;`

---

## 6. Future Distribution Target

The intended conceptual flow for distribution is:

```text
HEBRING source
    ↓
Build process
    ↓
Distribution artifacts
    ├── readable CSS
    ├── minified CSS
    └── npm package consumption
```
*(This is a future target and is not implemented in Phase 10.1).*
