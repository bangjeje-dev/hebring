# Build Toolchain Architecture

Phase 10.3 establishes the official build toolchain for HEBRING's CSS distribution.

> **"HEBRING only adopts build tooling when the tooling solves a real distribution problem."**
> 
> **"The smallest toolchain that reliably produces the required artifacts is preferred."**

## 1. Requirements

The toolchain must process the HEBRING `src/` directory to produce the distribution artifacts defined in Phase 10.2:
- `hebring.css`
- `hebring.min.css`

The toolchain must correctly handle and preserve:
- CSS `@import` resolution
- CSS custom properties
- Cascade layers (`@layer`)
- `@media` queries
- `data-theme` selectors
- Semantic tokens and responsive utilities
- Standard modern CSS syntax without aggressive transpilation

It must **NOT**:
- Require or output runtime JavaScript.
- Require complex configuration files.
- Introduce heavy plugin ecosystems.

## 2. Candidates Considered

1. **Native Node Script**: Writing a custom regex-based `@import` resolver.
2. **PostCSS** (`postcss`, `postcss-import`, `cssnano`): The traditional CSS build ecosystem.
3. **esbuild**: A fast Go-based bundler that supports CSS.
4. **Vite / Rollup**: Full frontend build tools.
5. **Lightning CSS** (`lightningcss-cli`): A fast, Rust-based CSS-specific bundler and minifier.

## 3. Evaluation

- **Native Node Script**: Eliminated. Writing and maintaining a custom parser that correctly handles nested `@import` rules, URL paths, and edge cases is unnecessary complexity when fast, zero-config tools exist.
- **PostCSS**: Eliminated. Requires installing multiple packages (`postcss`, `postcss-cli`, `postcss-import`, `cssnano`), maintaining a configuration file, and managing a plugin ecosystem.
- **Vite / Rollup**: Eliminated. These are application bundlers meant to handle JS, CSS, and assets. They introduce unnecessary complexity for a CSS-only framework.
- **esbuild**: Viable. Zero dependencies and very fast. However, it is primarily a JavaScript bundler that happens to support CSS.
- **Lightning CSS**: Selected. It is explicitly designed for modern CSS. It handles `@import` resolution and minification natively out of the box with zero configuration. It understands modern CSS features (like Cascade Layers) deeply and preserves them exactly as authored.

## 4. Selected Toolchain

**Tool:** `lightningcss-cli`

### Exact Role
- Resolve `@import` statements starting from `src/index.css`.
- Bundle all source CSS into a single `dist/hebring.css`.
- Minify the bundled CSS to produce `dist/hebring.min.css`.

### Why it fits HEBRING
- **Single Dependency**: Only one package is required to achieve both bundling and minification.
- **Zero Configuration**: Commands run directly from `package.json` scripts without requiring a config file.
- **CSS-First**: It is purpose-built for CSS, ensuring accurate parsing of layers and custom properties.
- **Speed**: Written in Rust, it adds negligible time to the development cycle.

### What it explicitly does NOT do
- It does not compile SCSS/Less.
- It does not generate JavaScript.
- It does not purge CSS classes based on HTML scanning (JIT).
- It does not modify the source architecture.

## 5. Architecture Relationships

### Relationship to `src/`
The toolchain strictly reads from `src/index.css`. It does not modify or reformat the `src/` directory.

### Relationship to `dist/`
The toolchain is solely responsible for creating and populating the `dist/` directory with the final artifacts. 

### Build Determinism
The output is purely deterministic, based exactly on the sequence of `@import` declarations in `src/index.css`.

### Dependency Philosophy
HEBRING relies on standard npm scripts. The dependency footprint is isolated strictly to `devDependencies`.

### Future Replacement Criteria
The toolchain can be trivially replaced in the future if a new native standard emerges for CSS module bundling or if Lightning CSS ceases to be maintained. Because there is no configuration file or plugin lock-in, swapping out `lightningcss-cli` for another bundler requires changing only a single npm script.
