# HEBRING UI Architecture Specification

## 1. HEBRING UI Philosophy
HEBRING UI exists as a higher-level composition layer built on top of HEBRING Core. While Core provides the universal, framework-agnostic building blocks (buttons, inputs, layout primitives), HEBRING UI solves complex, domain-specific, or highly interactive UI challenges (modals, datepickers, complex navigation). By separating UI from Core, the Core remains exceptionally lightweight, predictable, and maintainable, while UI can iterate rapidly on complex patterns.

## 2. Core vs UI Boundary
- **HEBRING Core**: Pure CSS. Represents fundamental HTML elements (e.g., `.hb-button`, `.hb-input`). Has no knowledge of complex state management beyond native pseudo-classes and simple `.is-*` toggles.
- **HEBRING UI**: Compositions of multiple Core primitives and HTML structures. May represent complex widgets that inherently require JavaScript for logic, focus trapping, or dynamic rendering (e.g., a Combobox or Modal). 
- *Example*: `.hb-button` belongs in Core. A `Dialog` containing a form, backdrop, and action buttons belongs in HEBRING UI.

## 3. UI Component Definition
A HEBRING UI component is a cohesive, reusable pattern that composes HEBRING Core components, Layout primitives, and Utilities to solve a specific user interface requirement. It dictates the anatomy of how these lower-level pieces fit together.

## 4. Composition Model
HEBRING UI components embrace composition.
The model is strictly: **UI Component → Core Component / Layout Primitive → Tokens**.
A UI component (like an Alert Dialog) will compose a layout primitive (`.hb-stack`) to arrange a core component (`.hb-button`) and typography, all of which ultimately consume global semantic tokens. UI components should rarely define properties from scratch if a Core primitive already handles it.

## 5. Dependency Rules
- **UI → Core**: STRICTLY ALLOWED (UI heavily depends on Core).
- **Core → UI**: STRICTLY FORBIDDEN (Core must never know about UI).
- **UI → Native CSS**: ALLOWED (UI can define its own unique CSS for specific structural needs).
- **UI CSS → External Framework Runtime**: FORBIDDEN (The pure CSS output of HEBRING UI must not depend on React/Vue. Framework adapters are a separate ecosystem concern).

## 6. Package Architecture
Conceptually, the ecosystem will split into distinct boundaries:
- `@hebring/core`: The pure CSS foundation (current repository state).
- `@hebring/ui`: The higher-level UI component CSS and structural definitions.
*(Note: These packages do not exist yet. This serves as the blueprint for future package extraction).*

## 7. CSS Architecture
HEBRING UI CSS fits seamlessly into the existing cascade architecture:
`@layer reset, base, layout, components, utilities;`
UI Components reside within `@layer components`. Because UI Components are structured as parent containers composing Core Components as children, standard CSS specificity and the DOM tree naturally resolve styling without requiring a new, distinct `@layer ui` cascade layer.

## 8. Naming Convention
HEBRING UI components follow the exact same predictable naming model as Core:
- **Base Class**: `.hb-{component}` (e.g., `.hb-modal`, `.hb-accordion`).
- **Modifiers**: `.hb-{component}--{modifier}` (e.g., `.hb-modal--fullscreen`).
- **Internal Elements**: `.hb-{component}__{element}` (e.g., `.hb-modal__backdrop`, `.hb-accordion__panel`).
Tailwind-like utility salad or arbitrary one-off names are forbidden.

## 9. Variants
Variants alter the visual intent or physical dimensions of a UI component. They are exposed purely through CSS modifier classes (`--primary`, `--lg`, `--compact`). UI components should map these variants to local implementation tokens internally, keeping the CSS output DRY.

## 10. States
UI components strictly inherit the Phase 14 Interaction States.
- Native: `:hover`, `:focus-visible`, `:disabled`, `:checked`.
- JS Hooks: `.is-loading`, `.is-active`, `.is-invalid`, `.is-selected`, `.is-expanded`.
UI components do not invent arbitrary state classes; they use the established conventions.

## 11. Composition vs Configuration
HEBRING UI prefers HTML composition over massive CSS configuration objects.
Instead of passing 50 props/modifiers to a monolithic `.hb-card` class, the UI component exposes internal elements (`.hb-card__header`, `.hb-card__body`) that the consumer can arrange using standard Layout primitives (`.hb-stack`).

## 12. Accessibility Contract
Every UI component inherits the Phase 14 Accessibility Foundations.
UI components must document:
- Focus trapping rules (if applicable, like in a Modal).
- Keyboard navigation (e.g., Arrow keys for Tabs/Dropdowns).
- Required ARIA roles and attributes for the complex widget pattern.

## 13. Responsive Behavior
UI components should adapt fluidly. Hidden magic `@media` queries inside UI components should be strictly avoided. Instead, structural changes across breakpoints should be handled by the consumer applying HEBRING responsive Utilities, or by leveraging inherent CSS Grid/Flexbox fluidity.

## 14. Theme Integration
UI components must consume HEBRING Semantic Tokens.
A UI component must never hardcode a color (e.g., `background: #ffffff`). It must use `var(--hb-color-surface)`. This guarantees that UI components automatically respect light/dark themes out of the box.

## 15. JavaScript Boundary
HEBRING UI establishes a clear boundary between styling and behavior:
- **CSS-Only UI**: Can be implemented fully in HTML/CSS (e.g., basic Cards, Badges, simple Dropdown menus using hover/focus-within).
- **Behavior-Requiring UI**: Patterns that intrinsically require DOM manipulation, focus trapping, or dynamic rendering (e.g., Modal focus traps, Combobox filtering, Toast lifecycles). The CSS for these lives in HEBRING UI, but the execution logic belongs to specific framework adapters (React/Vue/Vanilla JS) in the wider Ecosystem.

## 16. Component Taxonomy
Future HEBRING UI components are categorized as follows:
- **Overlay**: Modal, Dialog, Popover, Tooltip, Drawer.
- **Navigation**: Dropdown Menu, Breadcrumbs, Tabs, Pagination.
- **Data Display**: Accordion, Carousel, Calendar.
- **Feedback**: Toast, Snackbar.
- **Complex Forms**: Combobox, DatePicker, FileUpload.

## 17. Core Component Promotion Rules
Promoting a UI component to Core requires strict justification:
1. It must be universally applicable to almost all web projects.
2. It must be achievable with 100% pure CSS and native HTML semantics.
3. It must not rely on complex internal DOM structures.
If these criteria are met, a UI component may be refactored and moved to `@hebring/core`.

## 18. Ecosystem Boundary
HEBRING UI is a sibling to other Ecosystem packages. It does not own them.
Icons, Themes, Framework Adapters (React/Vue bindings), and Playgrounds remain separate entities within the broader HEBRING Ecosystem. UI relies on them via standard contracts.

## 19. Testing Architecture
Future HEBRING UI testing will mirror Core but at a higher level:
- **Structural Tests**: Bash scripts verifying correct class naming, layer encapsulation, and lack of `!important`.
- **Integration Tests**: Verifying that UI components correctly consume Core tokens and Layouts without breaking encapsulation.
- **Accessibility Tests**: Verifying required ARIA attributes and focus styles.

## 20. Documentation Architecture
Future UI components will be documented with a standardized structure:
- **Purpose**: What problem it solves.
- **Anatomy**: The required HTML structure and element classes.
- **CSS API**: Modifiers and state hooks.
- **Accessibility**: Keyboard interactions and ARIA roles.
- **Composition**: Examples of composing with Layout primitives.

## 21. Definition of Done
Phase 15 is complete when this UI Architecture Specification is written, validated against the Core taxonomy and accessibility foundations, and committed to the repository, formally defining how HEBRING UI will operate in the future.
