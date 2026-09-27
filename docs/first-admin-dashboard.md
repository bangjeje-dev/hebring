# First Official Admin Dashboard: Specification & Architecture

## 1. Purpose
The Admin Dashboard template exists to demonstrate how HEBRING can compose into a realistic, responsive, and complex application-style interface. It serves as a serious reference for developers building admin panels, internal tools, or SaaS products, proving that HEBRING scales gracefully without requiring a JavaScript framework or backend logic.

## 2. Scope
The initial scope includes:
- **Application Shell**: Responsive sidebar navigation, mobile navigation toggle, top header, and a main content region.
- **Dashboard Overview**: A landing page featuring a page heading, metric cards, trend/summary information, recent activity feeds, and a data table for recent orders.
- **Header**: Search input, notification center (popover), and user profile menu.

## 3. Architecture
The template strictly adheres to the HEBRING ecosystem architecture:
`HEBRING Core` → `Ecosystem UI` → `Templates` → `Applications`
- The template is a consumer of HEBRING.
- It does not modify or extend the framework core.
- It remains framework-neutral (pure HTML/CSS).
- Template-specific CSS uses local unprefixed class names (e.g., `.admin-shell`, `.admin-sidebar`).

## 4. Template Boundary
- **HEBRING Owns**: Typography, generic layout primitives (stack, cluster, grid), core components (buttons, badges, cards), responsive behavior foundations, design tokens, and interactive ecosystems (menus, popovers).
- **Template Owns**: Macro-layout definitions (the exact CSS grid layout of the sidebar vs. main content area), fictional data, application-specific composition, and disposable vanilla JavaScript for mobile navigation toggles.

## 5. Page/Feature Map
- **Sidebar**: Persistent navigation links, active states, and a logo area.
- **Header**: Global search bar, notifications toggle, and profile avatar dropdown.
- **Main Area**: 
  - Welcome heading and date context.
  - KPI/Metric cards (4-column grid).
  - Main chart/graph placeholder (large card).
  - Recent Orders table.
  - Recent Activity timeline.

## 6. Component Mapping
The dashboard will aggressively reuse existing HEBRING APIs:
- **Layout**: `hb-container`, `hb-stack`, `hb-cluster`, `hb-grid`, `hb-flow` for micro-layouts.
- **Components**: `.hb-card` for metric widgets, `.hb-button` for actions, `.hb-badge` for status indicators, `.hb-avatar` for user profiles, `.hb-table` for data presentation.
- **Ecosystem**: `.hb-menu` for the user profile dropdown, `.hb-popover` for notifications.
- **Icons**: Inline SVG using `currentColor` from the HEBRING icon set.
- **Template CSS**: Only used for macro-layouts, e.g., `.admin-shell` (CSS Grid) and `.admin-sidebar` (positioning).

## 7. Responsive Strategy
- Relies on HEBRING's built-in responsive utilities where possible.
- The local template CSS will handle macro-layout reflows using CSS Media Queries (e.g., collapsing the sidebar into a mobile drawer or off-canvas menu on small screens).
- No JavaScript viewport detection will be used.

## 8. Accessibility Strategy
- **Semantic HTML**: `<nav>`, `<header>`, `<main>`, `<aside>`.
- **Keyboard Navigation**: Interactive elements will maintain visible focus states.
- **State Management**: Using `aria-current="page"` for active navigation, and `aria-expanded`/native `popover` for menus.
- **Tables**: Fully semantic `<thead>`, `<tbody>`, `<th>`, and `<td>` with appropriate scope.

## 9. Theme Strategy
- Consumes HEBRING semantic tokens (e.g., `var(--hb-color-background)`, `var(--hb-color-text)`).
- Naturally inherits Light/Dark modes natively provided by the core CSS without duplicating the theme system or hardcoding colors.

## 10. Data Strategy
- Uses static, hardcoded HTML fixture data.
- No database, no backend, no real API integration.

## 11. JavaScript Strategy
- A minimal, disposable vanilla JavaScript file will handle progressive enhancements such as toggling the mobile sidebar.
- No React, Vue, Svelte, state management libraries, or complex logic.

## 12. Directory Structure
```text
ecosystem/templates/admin-dashboard/
├── index.html        # Main entry point (Overview page)
├── assets/
│   ├── admin.css     # Local template-specific macro-layout CSS
│   └── admin.js      # Disposable vanilla JS (mobile toggles)
└── README.md         # Template documentation
```

## 13. Package Consumption Strategy
The template simulates an external consumer. It points to the public package distribution rather than internal `src/` files:
- `node_modules/hebring/dist/hebring.css`
- `node_modules/hebring/ecosystem/ui/menu.css`
- `node_modules/hebring/ecosystem/ui/popover.css`

## 14. Validation Plan
- Ensure semantic HTML compliance.
- Test responsive breakpoints natively via the browser.
- Run via a simple local HTTP server (`npx serve`) without build tools.
- Confirm zero internal dependencies leak into the template.

## 15. Explicit Non-Goals
- DO NOT invent new HEBRING `hb-*` components.
- DO NOT add charting libraries (use placeholder UI).
- DO NOT implement backend auth.
- DO NOT use an external CSS preprocessor (Sass/Less) for the template.

## 16. Implementation Sequence
1. Scaffold `index.html` and link to HEBRING dist.
2. Build the `.admin-shell` macro-layout in `admin.css`.
3. Construct the Sidebar and Header using `hb-cluster` and `hb-stack`.
4. Compose the Main Dashboard view (Cards, Tables).
5. Implement Ecosystem components (Menus, Popovers).
6. Apply responsive behavior for mobile breakpoints.
7. Document the template usage in its local README.
