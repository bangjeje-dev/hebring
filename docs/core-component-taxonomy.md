# HEBRING Core Component Taxonomy & Boundary Specification

## 1. Core Component Philosophy
HEBRING Core Components provide the essential, foundational UI patterns required to build modern web interfaces. They are strictly pure CSS, lightweight, accessible, and framework-agnostic. They prioritize composability and predictability over exhaustive feature quantity, serving as the styling foundation upon which more complex Ecosystem UI components can be built.

## 2. Definition of a Core Component
A Core Component in HEBRING is a pure CSS implementation of a universal, foundational UI pattern. It encapsulates a coordinated set of styles (colors, typography, spacing, borders) and native interaction states to represent a specific semantic element, designed to be used repeatedly across a project.

## 3. Core Component vs Layout Primitive
- **Layout Primitive (`.hb-stack`, `.hb-grid`)**: Dictates the spatial arrangement, flow, and spacing between child elements. It has no visual styling (no backgrounds, no borders).
- **Core Component (`.hb-button`, `.hb-input`)**: Dictates the visual semantics, internal spacing, and interaction states of a specific UI element. It does not dictate how it is laid out relative to its siblings.

## 4. Core Component vs Utility
- **Utility (`.hb-p-4`, `.hb-text-center`)**: A single-purpose class that maps directly to one (or very few) CSS properties. Used for granular overrides or micro-adjustments.
- **Core Component**: A cohesive abstraction combining many properties, pseudo-classes, and token mappings to form a recognizable UI pattern. Utilities can override component styles safely due to cascade layer rules.

## 5. Core Component vs Ecosystem UI Component
- **HEBRING Core Component**: Pure CSS and HTML. Operates without a JavaScript runtime. Represents universal web primitives (e.g., buttons, inputs, tables, cards, badges, alerts).
- **HEBRING Ecosystem UI Component**: Future higher-level conceptual compositions or interactive widgets (Modals, DatePickers, Accordions) that inherently require JavaScript logic, complex DOM manipulation, or framework-specific wrappers (React, Vue, etc.). Ecosystem components consume Core Components and Layouts.

## 6. Core Component Categories
Core Components are organized into functional categories:
- **Actions**: Elements that trigger operations.
- **Forms**: Elements for capturing user input.
- **Feedback**: Elements communicating status or information to the user.
- **Data Display**: Elements for structuring and presenting content.

## 7. Proposed Core Component Taxonomy
Based on the boundaries established, the following taxonomy represents the target scope for HEBRING Core:
- **Actions**: `button`, `link`
- **Forms**: `input` (text-based), `textarea`, `select`, `checkbox`, `radio`, `label`
- **Feedback**: `alert`, `badge`, `progress`
- **Data Display**: `table`, `avatar`, `card`

## 8. Naming Convention
- **Base Class**: `.hb-{component}` (e.g., `.hb-button`, `.hb-input`).
- **Modifiers**: BEM-like double hyphens for variants, altering intent or size: `.hb-{component}--{modifier}` (e.g., `.hb-button--danger`, `.hb-input--sm`).
- **Internal Elements**: If a component has necessary sub-elements, use double underscores: `.hb-{component}__{element}` (e.g., `.hb-card__body`).

## 9. Composition Rules
Core Components must remain decoupled from their surroundings.
- They MUST NOT define external margins (`margin-top`, `margin-left`). External spacing is strictly the responsibility of Layout primitives.
- They MUST be fluid by default (e.g., standard block or inline-block behavior) and adapt to the constraints of their parent Layout.

## 10. State Rules
- **Native States**: Core Components must implement standard CSS pseudo-classes (`:hover`, `:focus-visible`, `:active`, `:disabled`, `:checked`) to handle native interactions without JavaScript.
- **JavaScript-Toggled States**: For states that require script intervention, use standardized state prefixes (`.is-loading`, `.is-invalid`, `.is-active`).

## 11. Accessibility Baseline
Every Core Component must:
- Assume semantic HTML usage in its design.
- Preserve explicit, highly visible focus rings (e.g., using `:focus-visible` with `--hb-color-focus`).
- Support clear `:disabled` styles (cursor changes, muted colors).
- Respect standard user preferences (e.g., reduced motion via token durations).

## 12. Dependency Rules
- **Allowed Dependencies**: Core Components may rely on the Foundation layer (normalizations) and Design Tokens.
- **Forbidden Dependencies**: Core Components MUST NOT rely on Layout primitives or Utility classes in their implementation.
- **Isolation**: They must be encapsulated within the `@layer components` cascade layer.

## 13. Token Usage Rules
Core Components must NOT consume generic semantic tokens directly for highly modifiable properties.
Instead, they use **Local Implementation Tokens**:
1. Map semantic tokens to local variables (e.g., `--hb-button-bg: var(--hb-color-primary)`).
2. Apply the local variable to the property (`background-color: var(--hb-button-bg)`).
3. Modifiers overwrite the local variables, keeping the CSS extremely DRY and avoiding global root pollution.

## 14. JavaScript Boundary
HEBRING Core CSS is strictly JavaScript-free. No component within the Core Taxonomy may require a JavaScript library or custom scripts to render its base appearance or handle its native interactive states. State classes (`.is-*`) exist merely as styling hooks for consumers to use with their own logic.

## 15. Responsive Behavior Rules
Core Components should naturally reflow based on standard CSS box model principles.
They MUST NOT contain internal, hardcoded `@media` queries to change their fundamental design at specific breakpoints. Responsive adjustments should be handled by Layout constraints or applied via responsive Utilities by the consumer.

## 16. Testing Requirements
Every Core Component must be covered by a bash-based test suite verifying:
- Existence of the base selector and modifiers.
- Presence of required state selectors.
- Strict placement within `@layer components`.
- Absence of `!important`.
- Absence of dependencies on Layout or Utility layers.
- Strict token consumption patterns.

## 17. Documentation Requirements
Every Core Component must be documented in `docs/components.md` containing:
- Semantic purpose.
- Minimum viable semantic HTML structure.
- List of available modifiers.
- Native and JavaScript-toggled states.
- Local implementation tokens.

## 18. Criteria for adding a new Core Component
A component belongs in HEBRING Core if it:
1. Is a universal web UI pattern.
2. Can be fully implemented using HTML and pure CSS.
3. Requires complex internal coordination of spacing, typography, and states that makes it tedious to build repeatedly using only utilities.

## 19. Criteria for rejecting a Core Component
A component MUST be rejected from HEBRING Core (and deferred to Ecosystem) if it:
1. Intrinsically requires JavaScript to function (e.g., Modals, Accordions, Tooltips, Custom Selects).
2. Represents a highly opinionated, domain-specific layout (e.g., `dashboard-sidebar`, `shopping-cart`).
3. Is merely a composition of other components better handled by the consumer (e.g., a `login-form` component).

## 20. Definition of Done for Phase 13
Phase 13 is complete when this taxonomy and boundary specification document is written, validated against the existing architecture, and committed to the repository, formally establishing the roadmap and rules for Phase 14 component implementation.
