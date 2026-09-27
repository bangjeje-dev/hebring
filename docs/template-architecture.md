# Template Architecture

## 1. Purpose
The HEBRING Template layer is an ecosystem capability intended to provide high-quality, real-world starting points that demonstrate how to compose HEBRING Core, UI components, Themes, and Icons into cohesive layouts. Templates exist to reduce boilerplate and teach best practices. They are intended as starting points for developers, not proprietary lock-in mechanisms or JavaScript frameworks.

## 2. Template Layer Boundary
Templates are strictly consumers of HEBRING. The layering is defined as:
`Core CSS` → `Ecosystem UI / Themes / Icons` → `Templates / Examples` → `Applications`.
Templates must never leak back into Core CSS, duplicate established primitives, invent new token systems, or introduce framework-specific runtime assumptions into the framework architecture.

## 3. Repository Inventory
As of the current audit phase, the repository structure for templates is established but empty:
- `ecosystem/templates/`: Contains `.gitkeep`.
- `examples/`: Contains the `playground/` directory and `.gitkeep`.
No concrete templates or standalone examples currently exist. The following sections define the architectural rules for their future implementation.

## 4. Playground vs Example vs Template vs Application
- **Playground**: A single, comprehensive reference implementation (`examples/playground/`) used to validate the CSS architecture natively during development.
- **Example**: An isolated snippet demonstrating a specific feature or composition.
- **Template**: A contextual, page-level or section-level composition of UI components (e.g., a "Dashboard" or "Landing Page").
- **Application**: The final product built by a consumer, which owns the routing, data models, and business logic.

## 5. Core CSS Consumption
Future templates must consume HEBRING Core CSS explicitly (e.g., pointing to `dist/hebring.css` or importing from the package root). Templates must not include custom compiled CSS that modifies or overwrites Core behavior.

## 6. Ecosystem UI Consumption
Templates should consume Ecosystem UI components (e.g., Modal, Navigation Menu) by explicitly importing their respective CSS files and adhering to the documented DOM contracts. Templates must not reinvent existing Ecosystem components.

## 7. Theme Consumption
Templates must support HEBRING themes natively by relying exclusively on semantic tokens (e.g., `var(--hb-color-surface)`). Templates must not hardcode hex colors or implement alternative, undocumented theming systems.

## 8. Icon Consumption
Templates may demonstrate HEBRING Icons using the unstyled `currentColor` SVG model. Templates should not mandate external icon libraries as a core framework requirement.

## 9. Layout Composition
Templates must construct layouts exclusively using HEBRING's Core layout primitives (Container, Stack, Cluster, Grid, Flow, Center). They must not invent undocumented custom layout systems.

## 10. Component Composition
Templates should compose existing HEBRING Core and Ecosystem components (Buttons, Cards, Forms, Modals) naturally. Templates must not create unnecessary duplicated component styles (e.g., avoiding custom `.template-btn` classes if `.hb-button` suffices).

## 11. Responsive Architecture
Responsive behaviors in templates must rely on HEBRING's documented breakpoints and fluid layout primitives. Viewport-detecting JavaScript or contradictory custom breakpoints are prohibited.

## 12. Accessibility Alignment
Templates must adhere to the accessibility architecture defined in `docs/ecosystem-accessibility-audit.md`. This includes semantic HTML, proper ARIA relationships, and focus management.

## 13. JavaScript Boundary
Templates may include JavaScript to demonstrate interaction (e.g., Reference Adapters for Modals), but they must not introduce hidden framework runtimes (like Vue or React) or global state managers as a requirement for utilizing HEBRING.

## 14. State Ownership
State in templates must belong to native browser attributes (`[open]`, `:popover-open`) or standard ARIA attributes (`[aria-expanded]`). Templates must not introduce conflicting state conventions (like `.is-active`).

## 15. Naming Consistency
Any template-specific CSS classes must be clearly distinguishable and should not masquerade as HEBRING Core API. The `hb-*` prefix is reserved strictly for Core and Ecosystem components.

## 16. Token Usage
Templates must consume semantic and primitive tokens correctly. Hardcoded styling values (arbitrary padding, hex colors) should be avoided in favor of utility classes or token mappings.

## 17. CSS Architecture
Template-specific CSS, if necessary, should cleanly compose on top of HEBRING without redefining the cascade layers. It should avoid `!important` overrides of core framework features.

## 18. Template Variants
If multiple templates share foundations, they must remain individually portable. Templates should not become an interdependent mini-framework themselves.

## 19. Demo / Production Boundary
Templates are provided as demonstration starting points. They bridge the gap between Playground (testing) and Application (production) by providing structural boilerplate that the consumer takes ownership of.

## 20. Package Boundary
Templates and examples must remain excluded from the core npm package distribution (`dist/`). The `hebring` package distributes the CSS and Icons, not the HTML boilerplate.

## 21. Documentation Alignment
Documentation referencing templates will direct users to the `ecosystem/templates` directory. The terminology must strictly refer to them as starting points, not mandatory framework dependencies.

## 22. Developer Experience
A developer must easily understand that a template is a portable HTML/CSS composition they can copy and modify, entirely independent of any JavaScript build step or framework lock-in.

## 23. Performance / Complexity
Templates should remain lightweight, avoiding massive asset dependencies, excessive third-party libraries, or complex build requirements.

## 24. Testing / Validation
Templates must pass semantic HTML validation, utilize valid HEBRING CSS classes, and demonstrate unbroken responsive and accessibility patterns without requiring automated browser test suites in the core repository.

## 25. Findings
The template architecture is correctly defined as a consumer layer on top of HEBRING. Currently, no templates exist, ensuring zero leakage or contradictory implementations. The conceptual boundary is solid.

## 26. Remediation
Replaced the previous `template-architecture.md` with this formal architectural audit boundary to proactively govern future template implementation.

## 27. Final Template Architecture Assessment
The template layer architecture is sound, empty, and prepared for future implementation without risking the integrity of the HEBRING Core or Ecosystem UI boundaries.
