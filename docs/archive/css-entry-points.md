# CSS Entry Points

Phase 10.4 establishes and validates the official CSS entry-point architecture for HEBRING.

> **"HEBRING has one canonical full-framework CSS entry point."**
> 
> **"Internal CSS modules are implementation architecture, not fragmented public packages."**

## 1. Primary Entry Point

**File:** `src/index.css`
**Status:** Canonical Source Entry

`src/index.css` is the sole entry point for the HEBRING framework. It exposes the complete framework by strictly following the domain composition boundaries:
1. Tokens
2. Foundation
3. Layout
4. Components
5. Utilities

This structure guarantees that all variables and layer configurations are loaded exactly as designed, ensuring predictability.

## 2. Cascade Layer Order

The primary entry point declares the exact cascade layer hierarchy for the entire framework at the very top:
```css
@layer reset, base, layout, components, utilities;
```

**Architectural Rules Enforced:**
- Tokens are **NOT** a cascade layer; they apply globally via `:root` or attribute selectors.
- Themes are **NOT** a cascade layer; they override tokens natively.
- No `@layer themes`, `@layer tokens`, or `@layer responsive` exists.

## 3. Import Graph

The framework resolves imports cleanly from the primary entry point without circular dependencies or duplicated includes.

```text
src/index.css
├── tokens/index.css
│   ├── primitives.css
│   ├── semantic.css
│   └── themes/index.css
├── foundation/index.css
│   ├── reset.css
│   └── base.css
├── layout/index.css
│   ├── container.css
│   ├── stack.css
│   ├── cluster.css
│   ├── grid.css
│   ├── flex.css
│   ├── center.css
│   └── flow.css
├── components/index.css
│   └── button.css
└── utilities/index.css
    ├── spacing.css
    ├── display.css
    ├── sizing.css
    ├── typography.css
    └── alignment.css
```

### 3.1 Token Entry
**File:** `src/tokens/index.css`
Imports primitives, semantics, and themes in sequence. Themes are naturally part of the token dependency graph. Consumers do not need to import themes separately for normal usage.

### 3.2 Foundation Entry
**File:** `src/foundation/index.css`
Imports CSS reset and baseline typographic/form norms, which map natively into `@layer reset` and `@layer base`.

### 3.3 Layout Entry
**File:** `src/layout/index.css`
Aggregates independent layout primitives (e.g., container, cluster, stack). 

### 3.4 Component Entry
**File:** `src/components/index.css`
Aggregates all robust component styles. (Currently includes `button.css`). There are no component-specific package entry points exposed.

### 3.5 Utility Entry
**File:** `src/utilities/index.css`
Aggregates all baseline and responsive utilities. Responsive utilities live within these specific files, utilizing the unified breakpoints, rather than being broken out into isolated imports.

## 4. Internal vs Public Entry Points

**PUBLIC:**
- `src/index.css`: The canonical source entry point.
- `dist/hebring.css` (future): The canonical distribution artifact.

**INTERNAL:**
- Individual module files (e.g., `src/components/button.css`).
- Modular entry points (e.g., `src/utilities/index.css`).

Internal modules should not be treated as stable public package APIs. If modular entry points (like `hebring/components`) become necessary in the future, they will be introduced as a separate architectural decision.

## 5. Consumer Experience

The intended conceptual consumer flow remains simple:
```bash
npm install hebring
```
Followed by standard CSS importation in the consumer's framework:
```javascript
import 'hebring/dist/hebring.css';
```
Consumers do not need to understand internal source imports, nor do they need to assemble the framework themselves.

## 6. Build Relationship

When the build pipeline executes, Lightning CSS strictly follows the canonical import graph from `src/index.css` downwards, resolving all paths into a flat stylesheet, preserving exact cascade layers, and preserving all custom properties:

```text
src/index.css
    ↓
Lightning CSS (bundler)
    ↓
dist/hebring.css
    ↓
dist/hebring.min.css
```
*(This exact build is deferred to Phase 10.5).*

## 7. Framework Integrity

The evaluated entry architecture perfectly preserves:
- **CSS-first philosophy:** The framework remains entirely CSS.
- **Framework agnosticism:** No JS runtime is needed.
- **Responsive Utilities & Built-in Themes:** Completely reachable via the main entry.
- **Cascade structure:** Strict `@layer` order is maintained perfectly.
- **No Duplication:** 100% linear import graph without duplication or circular references.
