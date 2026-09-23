# HEBRING Template Architecture

## 1. Template Philosophy
HEBRING Templates are intended to be high-quality, real-world starting points that demonstrate how to compose HEBRING Core, UI components, Themes, and Icons into cohesive layouts. They exist to reduce boilerplate and teach best practices. A template is a starting point, not a lock-in mechanism—developers are expected to take, modify, dissect, and independently deploy templates without proprietary restrictions.

## 2. Template Definition
- **What a Template is**: A pre-constructed composition of HTML and HEBRING CSS classes representing a common page, section, or layout pattern.
- **What a Template is NOT**: A template is not the HEBRING framework itself, nor is it a proprietary component system, a WordPress theme, or a JavaScript runtime dependency.

## 3. Template Categories
Templates will be organized by purposeful taxonomy. Initial sensible categories include:
- **Authentication**: Login, Registration, Password Reset
- **Marketing**: Landing Pages, Features, Pricing, Hero Sections
- **Dashboard**: Admin Panels, Data Tables, Settings, Sidebars
- **Content**: Blogs, Documentation, Portfolios, Articles
- **E-commerce**: Product Pages, Shopping Carts, Checkouts

## 4. Composition Model
Templates are the highest practical composition layer in the HEBRING ecosystem. The hierarchy is:
`Template` → `Sections / Patterns` → `UI Components` → `Core Primitives` → `Tokens` → `Native CSS`
A template may use any layer below it, but lower layers never depend on templates.

## 5. Template vs UI Boundary
- **UI Component**: A reusable, single-responsibility element (e.g., a `.hb-card` or `.hb-alert`).
- **Template**: A contextual composition of UI components and primitives fulfilling a specific user journey (e.g., a complete "Pricing Section" containing a header grid, multiple pricing cards, feature lists, and call-to-action buttons). Templates compose UI; UI remains independent.

## 6. Portability
Templates are distributed as plain, framework-neutral HTML and CSS. They avoid framework coupling (React, Vue, Angular) to guarantee maximum portability. A developer can copy the template HTML and paste it into any environment where HEBRING CSS is loaded.

## 7. Structure
A conceptual template directory structure follows a simple static site model:
```
template-[name]/
├── index.html
├── preview.png
└── README.md
```
No complex bundlers or transpilers are enforced per-template.

## 8. Naming
Template names must be stable, predictable, and describe their purpose rather than an iteration or internal version.
- **Valid**: `dashboard-admin`, `marketing-landing`, `auth-login`
- **Invalid**: `landing-v2-final`, `test-dashboard-new`

## 9. Accessibility
Templates are bound by the same strict accessibility contracts as Phase 14 Core Components. They must utilize semantic HTML, proper ARIA roles where necessary, focus-visible states, and maintain strict contrast ratios.

## 10. Responsive Behavior
Templates must be fully fluid and responsive, utilizing HEBRING's Core layout primitives (grids, stacks) and utility classes. They must not rely on undocumented breakpoints or hardcoded pixel values.

## 11. Theme Integration
Templates automatically support HEBRING Themes because they consume semantic tokens and core classes. Templates must never hardcode theme-specific hex colors into their markup or custom CSS (e.g., no `style="background: #000"`).

## 12. Icon Integration
Templates may optionally consume HEBRING Icons (using the `<svg>` format established in Phase 17). Doing so demonstrates practical usage but does not introduce Icons as a Core dependency.

## 13. Playground Integration
Templates serve as ideal candidates for the HEBRING Playground (Phase 19). Future workflows will allow a developer to select a Template, open it in the Playground, edit the markup interactively, and copy the customized result.

## 14. Distribution
Templates will be distributed via standard, open channels:
- Included in the repository (`/templates`)
- Downloadable ZIP archives
- Optionally via CLI scaffolding or GitHub Template repositories.
There is no proprietary marketplace or payment system.

## 15. Versioning
Templates declare their compatibility with HEBRING Core versions in their `README.md`. Because HEBRING relies on stable CSS classes, templates remain largely backwards compatible, but major breaking changes to Core layout primitives will require template version bumps.

## 16. Dependencies
Templates have exactly one mandatory dependency: the `hebring` single npm package (specifically `dist/hebring.css`).
Dependencies on alternative ecosystem themes or icons are strictly optional.

## 17. Customization
Developers customize templates by editing the raw HTML, swapping HEBRING utility classes, or overriding semantic tokens. No proprietary template language (like Liquid or Twig) is required to parse or modify a template.

## 18. Quality Contract
Every template must meet minimum quality standards:
- 100% Valid Semantic HTML5.
- fully responsive (mobile-first).
- 100% valid HEBRING CSS classes (no invented aliases).
- No hard-coded theme hacks.
- No JavaScript dependencies required for layout.
- No broken asset links.

## 19. Testing
Future testing infrastructure for templates will validate:
- HTML validity.
- CSS class validity (ensuring no deprecated or nonexistent classes are used).
- Broken link detection.
- A11y auditing (e.g., via axe-core or Chrome DevTools integration) where feasible.

## 20. Future Expansion
As the ecosystem matures, templates may be branched into framework-specific adapters (e.g., React or Vue versions of the HTML) only if the framework-neutral HTML version remains the authoritative source of truth.
