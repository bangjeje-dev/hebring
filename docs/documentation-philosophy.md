# Documentation Philosophy

Phase 11.1 defines the official documentation philosophy and information architecture for HEBRING.

> **"HEBRING documentation should explain the framework's mental model, not merely list its classes."**
> 
> **"A developer should be able to read the documentation and understand why HEBRING works."**

## 1. Documentation Goals

HEBRING documentation must help developers understand:
1. What HEBRING is.
2. How HEBRING works.
3. Why HEBRING is structured the way it is.
4. How to use HEBRING correctly.
5. How to extend HEBRING without fighting its architecture.

The documentation aims to achieve:
- Understandability
- Discoverability
- Correct usage
- Architecture transparency
- Framework literacy
- Accessibility awareness
- Practical implementation guidance
- Maintainability
- Framework-agnostic usage

It should serve both developers discovering HEBRING for the first time and experienced developers needing precise reference.

## 2. Mental Model First

Documentation should establish the HEBRING mental model before presenting exhaustive APIs.

### Conceptual Architecture
```text
CSS
  ↓
HEBRING
  ├── Tokens
  ├── Foundation
  ├── Layout
  ├── Components
  └── Utilities
```

### Framework Relationship
```text
Tokens
→ Foundation
→ Layout
→ Components
→ Utilities
```

### Cascade Layers
The CSS cascade maps directly to domain boundaries:
```text
reset
→ base
→ layout
→ components
→ utilities
```

**Clarifications:**
- Tokens are **not** a cascade layer.
- Themes are **not** a cascade layer.
- Responsive behavior is **not** a separate cascade layer.

## 3. Teach "When to Use What"

Documentation must teach decision-making (e.g., when to use a layout primitive vs a utility vs a component vs custom application CSS vs semantic HTML).

- **"Utility handles one thing. Component defines a reusable UI pattern."**
- **"Utilities are conveniences, not constraints."**

## 4. Explain Why

Where architecture decisions are meaningful, documentation should explain WHY. 
Examples include:
- Why HEBRING uses CSS custom properties.
- Why tokens are separated from cascade layers.
- Why themes modify semantic tokens.
- Why themes use `data-theme`.
- Why HEBRING does not require JavaScript.
- Why responsive utilities are limited.
- Why there is no JIT class generation.
- Why internal CSS modules are not public package APIs.
- Why the framework uses a single canonical CSS entry point.

Explanations must remain concise and practical.

## 5. Progressive Disclosure

Documentation should reveal complexity progressively. Do not force beginners to understand the entire internal architecture before using HEBRING.

**Learning Flow:**
1. Getting Started
2. Mental Model
3. Core Concepts
4. Practical Usage
5. Reference
6. Architecture / Advanced Topics

## 6. Beginner → Advanced

Documentation supports multiple experience levels:

- **Beginner:** Installation, first stylesheet, semantic HTML, basic layout, basic components.
- **Intermediate:** Utilities, responsive utilities, tokens, themes, customization.
- **Advanced:** Architecture, cascade layers, token source architecture, build system, package architecture, extension strategy.

## 7. Examples Over Abstract Description

Where practical, documentation should use small, realistic examples that:
- Are minimal.
- Use actual HEBRING classes.
- Use semantic HTML.
- Avoid unnecessary complexity.
- Are copy/paste friendly.
- Reflect current implementation.

Do not invent APIs that do not exist.

## 8. Source of Truth

Documentation must follow actual implementation.
- For API/reference documentation, **source code is authoritative**.
- For architecture philosophy, **architecture documents are authoritative**.

Clearly distinguish between current, future, and conceptual APIs.

## 9. API Documentation

API documentation will eventually cover classes, modifiers, states, responsive variants, semantic tokens, themes, layout primitives, and components. Reference documentation must be maintained from actual implementation.

## 10. Accessibility

Accessibility is part of normal HEBRING usage, not an optional appendix.
Documentation should explain:
- Semantic HTML
- Focus behavior
- Keyboard accessibility
- Native controls
- State semantics
- Color/contrast considerations
- Accessible component usage

Do not claim compliance without evidence.

## 11. Framework-Agnostic

HEBRING is independent of JavaScript frameworks. Examples should primarily use **HTML** and **CSS**. Framework-specific integrations may be documented later.

## 12. Copy / Paste Quality

Code examples should be complete enough to work, minimal enough to understand, consistent with the current API, and free from fictional syntax.

## 13. Documentation Terminology

Preserve established HEBRING terminology:
- Primitive tokens
- Semantic tokens
- Themes
- Foundation
- Layout
- Components
- Utilities
- Responsive utilities
- Cascade layers
- CSS entry point
- Distribution artifacts

## 14. Information Architecture

Future documentation will adopt the following structure:

```text
Documentation
│
├── Getting Started
│
├── Concepts
│   ├── Mental Model
│   ├── Tokens
│   ├── Foundation
│   ├── Layout
│   ├── Components
│   ├── Utilities
│   ├── Responsive
│   └── Themes
│
├── Reference
│   ├── Tokens
│   ├── Layout
│   ├── Utilities
│   └── Components
│
├── Guides
│   ├── Customization
│   ├── Responsive Design
│   ├── Themes
│   └── Accessibility
│
└── Advanced
    ├── Architecture
    ├── Build & Distribution
    └── Extension Strategy
```

## 15. README vs Documentation

- **README:** Concise project introduction, installation, quick start, basic usage, project identity.
- **Documentation:** Complete learning path, conceptual explanations, guides, API reference, architecture, advanced usage.

Do not duplicate the entire documentation site inside the README.

## 16. Documentation vs Source Comments

- **Documentation:** User-facing concepts, architecture explanation, usage guidance.
- **Source Comments:** Implementation details requiring local explanation, context for future maintainers.

## 17. Documentation Versioning

Documentation must correspond to the actual released HEBRING API. Future breaking changes must update documentation alongside implementation.

## 18. Search / Discoverability

Future documentation will make it easy to discover classes, components, tokens, concepts, and guides.

## 19. Documentation Design Principle

> **"Documentation should make HEBRING easier to understand, not make HEBRING look more complicated."**
> 
> **"Show the smallest useful example first. Explain the architecture when the reader is ready for it."**

## 20. What Documentation Must Not Become

HEBRING documentation strictly avoids:
- Marketing-heavy language.
- Fictional APIs.
- Exhaustive complexity without context.
- Framework-specific assumptions.
- Unexplained jargon.
- Copy/paste examples that do not work.
- Documenting internal implementation as public API.
- Premature documentation for future features.

## 21. Relationship to Phases 01–10

Documentation is built on the existing architecture:
- 01 Foundation
- 02 CSS Architecture
- 03 Design Tokens
- 04 Core / Reset
- 05 Layout
- 06 Utilities
- 07 Components
- 08 Responsive System
- 09 Themes
- 10 Build & Distribution

Documentation must describe the system that actually exists.

## 22. Future Documentation Validation

A later validation phase will formally verify that examples match implementation, documented exports exist, installation instructions work, and code examples are syntactically valid.
