# Developer Tooling Architecture

## 1. Purpose
Developer tooling in HEBRING exists solely to facilitate the building, validating, and packaging of the CSS framework. The tooling architecture is intentionally kept to an absolute minimum to prevent the accidental introduction of a JavaScript framework runtime, complex build requirements, or a second public API.

## 2. Tooling Layer Boundary
The conceptual hierarchy is:
`Core CSS` → `Ecosystem UI / Themes / Icons` → `Templates / Examples` → `Developer Tooling`
Tooling sits outside the runtime environment. No tooling component, script, or development dependency is permitted to leak into the Core CSS or Ecosystem UI layers. A consumer of HEBRING must never be required to run HEBRING's internal tooling to use the CSS.

## 3. Repository Tooling Inventory
An audit of the repository reveals the following tooling footprint:
- `package.json`: Defines minimal build scripts and one dependency.
- `tests/*.sh`: A suite of bash scripts used for validating CSS outputs and architectural contracts.
- **Missing by design**: `.github/workflows/`, `scripts/`, `stylelint`, `prettier`, `typescript`, `webpack`, `vite`, `storybook`.

## 4. Runtime vs Development Boundary
HEBRING is a CSS framework. Therefore:
- **Runtime**: Zero dependencies.
- **Development**: One dependency (`lightningcss-cli`).
This boundary is strictly enforced.

## 5. package.json Architecture
- **Dependencies**: None.
- **DevDependencies**: `lightningcss-cli`.
- **Scripts**: 
  - `build:css`: Bundles the raw CSS.
  - `build:min`: Bundles and minifies the CSS.
  - `build`: Runs both sequentially.
- **Exports/Files**: Explicitly maps `/dist`, `/src`, and `/ecosystem` to ensure tooling files (like `/tests`) are not distributed in the final npm package.

## 6. Build Tooling
The build pipeline relies entirely on `lightningcss-cli`.
- **Source Entry**: `src/index.css`.
- **Output**: `dist/hebring.css` and `dist/hebring.min.css`.
- **Responsibilities**: Resolving `@import` statements and minification.
It intentionally avoids PostCSS plugins, Autoprefixer (LightningCSS handles vendor prefixes natively if configured), and JavaScript bundlers, ensuring a pure CSS build path.

## 7. Test Tooling
Testing is performed via standard Unix shell scripts (`tests/*.sh`) and `grep`.
- **Scope**: Validates cascade layers, class names, token consumption, package distribution correctness, and ecosystem boundaries.
- **Architecture**: No Node.js test runners (Jest, Vitest) are used, eliminating massive dependency trees. The tests validate the compiled CSS output and raw source text.

## 8. Documentation Tooling
Documentation is written as plain Markdown files in the `docs/` directory. No static site generator (e.g., VitePress, Docusaurus) or component explorer (e.g., Storybook) is currently implemented. The architecture permits future SSG usage as long as the documentation generator does not become a core runtime dependency.

## 9. Playground Tooling
The Playground (`examples/playground/index.html`) operates without tooling. It is a static HTML file that consumes uncompiled `src/index.css` natively in the browser. It requires no bundler or development server to function, acting as a pure reference implementation.

## 10. Example / Template Tooling
Examples and templates (currently empty) require no build systems. They are plain HTML/CSS compositions by definition. Imposing a bundler or package manager on templates would violate their portability.

## 11. Icon Tooling
Icons are currently distributed as raw, optimized SVGs in `ecosystem/icons/`. There is no internal SVG generation or transformation pipeline (like SVGO or build-time sprite generation) present in the repository, maintaining extreme simplicity.

## 12. Theme Tooling
Themes are written as declarative CSS variables in `ecosystem/themes/`. No token transformation tools (e.g., Style Dictionary) are used. The themes are consumed natively without a build step.

## 13. Validation Tooling
Validation consists of:
- `npm run build` (Ensuring the CSS compiles).
- `for test_script in tests/*.sh; do bash "$test_script"; done` (Running the bash test suite).
- `npm pack --dry-run` (Validating the package boundary).
- `git diff --check` (Checking for whitespace errors).

## 14. Linting / Formatting
There are currently no formal linting (Stylelint) or formatting (Prettier) tools configured. This absence is documented. While useful, they have been omitted to keep the contributor barrier to entry incredibly low and the dependency tree small.

## 15. Type Checking
TypeScript is not present in the repository. As a pure CSS framework, type checking is unnecessary and would impose an inappropriate tooling burden.

## 16. CI / Automation
There are currently no GitHub Actions or automated CI pipelines configured. Validation is performed locally via the test shell scripts.

## 17. Release Tooling
Release tooling relies on native npm commands (`npm pack`, `npm publish`). No automated release managers (e.g., semantic-release, changesets) are implemented.

## 18. Developer Experience
The developer experience is optimized for simplicity. A contributor only needs to understand standard HTML, CSS, and basic Bash. There is no requirement to learn a complex build toolchain or navigate a labyrinth of configuration files.

## 19. Tooling Dependency Classification
- `lightningcss-cli`: **Build-time / Development-only**.

## 20. Generated Files
The only generated files are `dist/hebring.css` and `dist/hebring.min.css`. These are the source of truth for package consumers and are reproducibly generated from `src/index.css`.

## 21. Workspace / Monorepo Boundary
This is a single-package repository. There is no monorepo tooling (Lerna, Turborepo, npm workspaces) configured, which aligns with the framework's lightweight philosophy.

## 22. Tooling API Boundary
The tooling does not expose a public API. Scripts in `package.json` are internal build mechanisms, not public CLI tools for consumers to use in their own projects.

## 23. Documentation Alignment
Existing documentation correctly references native npm commands (`npm run build`). No contradictory or outdated tooling commands were found in the `README.md` or `docs/`.

## 24. Performance / Complexity
- **Install Complexity**: Near zero (one dependency).
- **Build Time**: Milliseconds (due to LightningCSS).
- **Dependency Count**: 1.
The tooling architecture achieves maximum performance through radical minimalism.

## 25. Future Tooling Boundary
Future additions (e.g., documentation sites, CLI scaffolders) must remain conceptually isolated from the CSS framework. They must be placed in separate repositories or explicitly defined as optional development utilities that do not affect the `hebring` npm package payload.

## 26. Findings
The developer tooling architecture is flawlessly minimal. It avoids the common trap of over-engineering the CSS authoring experience with JavaScript toolchains. The boundary between development tooling and runtime code is completely airtight.

## 27. Remediation
No concrete architectural problems were found. This document was created to formally record and defend the minimalistic tooling boundary against future scope creep.

## 28. Final Developer Tooling Assessment
The developer tooling architecture is perfectly aligned with HEBRING's identity as a pure, lightweight CSS framework. The single-dependency build pipeline and bash-based testing suite are highly effective and impose zero runtime overhead.
