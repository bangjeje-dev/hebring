# Template Ecosystem Strategy

## 1. Purpose
The HEBRING Template Ecosystem Strategy defines the architectural role of official templates within the repository. It dictates what constitutes a template, how templates consume the framework, and how the ecosystem should grow without compromising HEBRING's core mission as a CSS framework.

## 2. Template Definition
An official HEBRING Template is a realistic, composed HTML/CSS starting point (e.g., a Dashboard, Landing Page, or Documentation Site). It demonstrates the correct composition of HEBRING primitives, components, layout utilities, and ecosystem interactions. Templates reduce boilerplate for developers and establish best practices for framework consumption.

## 3. Layer Boundary
HEBRING strictly maintains the following dependency direction:
`HEBRING Core` → `Ecosystem UI / Themes / Icons` → `Templates` → `Applications`

Templates **must not**:
- Export logic or styles back to Core.
- Introduce new generic design tokens.
- Add components to the framework.
- Replace core framework responsibilities.

## 4. Template vs Example
- **Examples (`examples/`)**: Isolated API demonstrations or testing sandboxes (like the Playground). They validate that the framework functions internally and are not intended to be copied as a whole application foundation.
- **Templates (`ecosystem/templates/`)**: Holistic, composed pages intended to be copied by an external developer to serve as the foundation of their new project.

## 5. Template vs Application
A Template stops before it becomes a full Application.
Templates **do not contain**:
- Client-side routing.
- Backend API integration.
- Authentication systems.
- Build tools (Webpack, Vite, Rollup).
- Business logic or domain-specific persistent state.

The application consumer is responsible for taking the template and injecting their framework (React, Vue) and business logic.

## 6. Consumption Contract
Templates are strictly consumers of HEBRING. 
The expected contract is:
- Consumes Core CSS via the public package endpoint (`dist/hebring.css`).
- Consumes Ecosystem UI components unbundled (e.g., `ecosystem/ui/menu.css`).
- Consumes Icons as raw inline SVG using `currentColor`.
- Inherits Core and Ecosystem Themes via native CSS custom properties.

## 7. Framework Neutrality
Official HEBRING templates must remain completely framework-neutral. They will be authored in pure HTML and CSS, with minimal vanilla JavaScript for interaction demonstration. Introducing React, Vue, Tailwind runtimes, or any specific JS framework isolates users of other frameworks and violates the primary HEBRING philosophy.

## 8. CSS Policy
Templates may contain their own local CSS (e.g., `assets/dashboard.css`) strictly for **macro-layout composition** and **template-specific placement**.
- **HEBRING Responsibility:** Provides generic utility spacing, atomic primitives (flex, grid, cluster), component aesthetics, responsive breakpoints, and tokens.
- **Template Responsibility:** Places the sidebar on the left, defines the main content max-width for that specific page, or arranges unique grid templates for a dashboard layout.
Template CSS must not use the `hb-*` prefix. It must use template-specific prefixes (e.g., `dashboard-*`).

## 9. JavaScript Policy
JavaScript in templates is acceptable only to demonstrate progressive enhancement or necessary native interactions (e.g., toggling a mobile menu). 
Template JavaScript **must not**:
- Implement a state management library.
- Require a build step (TypeScript, JSX).
- Re-invent native browser capabilities (e.g., reinventing `<dialog>` or `popover`).
The JavaScript provided is disposable; consumers are expected to replace it with their framework's data-binding mechanisms.

## 10. Naming & Structure
Template directories must clearly indicate their semantic purpose. 
Structure: `ecosystem/templates/<kebab-case-name>/`
Examples of valid concepts: `starter-dashboard`, `marketing-landing`, `admin-console`.
Each template must be self-contained within its directory, containing an `index.html`, a `README.md`, and any local `assets/`.

## 11. Official Template Criteria
To be accepted as an official HEBRING template, it must:
- PASS semantic HTML validation.
- Consume HEBRING Core layout primitives and tokens correctly.
- Support responsive viewports exclusively via CSS.
- Maintain full framework neutrality (no JS frameworks).
- Achieve high accessibility (focus states, ARIA roles, landmarks).
- Contain a clean separation between Core `hb-*` classes and template-local classes.
- Introduce zero Node or build dependencies.

## 12. Validation Contract
Before a template is merged, it must survive external validation:
- The template must function properly when `hebring` is installed as an npm package in a fresh directory.
- It must run perfectly via a local HTTP server without a build step.
- Automated tests must confirm that the template does not leak code into Core.
- The Git tree must remain clean, and the build/pack steps must succeed.

## 13. Ecosystem Growth Rules
As the ecosystem scales, templates will naturally develop recurring patterns.
- If multiple templates use similar macro-layouts, they should remain duplicated across templates to keep each template portable.
- If a UI component becomes universally necessary across all templates, it must be evaluated for promotion to `ecosystem/ui/` first.
- **Never move template-specific domain logic into Core.** HEBRING remains a CSS framework; the templates remain consumer reference architectures.

## 14. Package Boundary
Templates are deliberately **excluded** from the core NPM package distribution. Consumers install `hebring` for the CSS, Icons, and UI components. They clone or copy template HTML files manually from the GitHub repository to avoid bloating their `node_modules` with boilerplate HTML they need to edit.

## 15. Current Starter Dashboard Compliance
An audit of `ecosystem/templates/starter-dashboard/` demonstrates 100% compliance with this strategy. It uses a single non-prefixed local stylesheet, consumes Core via `node_modules`, requires no JS framework, and implements responsive accessibility correctly.

## 16. Future Template Guidance
When designing new templates:
- Start with the Core primitives.
- Identify the macro-layout required and create a local `.css` file.
- Keep the design opinionated but the technical implementation agnostic.
- Always assume the user will rip out your placeholder data and JavaScript to replace it with their own application logic.
