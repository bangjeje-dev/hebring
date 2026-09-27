# Ecosystem UI Composition

## 1. Composition Philosophy
HEBRING components compose through native HTML structure, semantic attributes, established CSS contracts, existing layout/surface primitives, and native browser APIs (such as `<dialog>`, `[popover]`, `scroll-snap`).
They strictly DO NOT compose through hidden internal JavaScript dependencies, global state managers, global event buses, implicit DOM assumptions, component-specific runtime managers, or duplicated interaction engines.

## 2. Component Composition Matrix
- **Modal + Alert Dialog**: SUPPORTED (Alert Dialog leverages Modal's DOM and CSS entirely, with explicit `role="alertdialog"`).
- **Modal + Drawer**: SUPPORTED (Drawer extends Modal `<dialog>` surface via distinct CSS positioning).
- **Modal + Command Menu**: SUPPORTED (Command Menu leverages Modal `<dialog>` context natively).
- **Modal + Combobox**: SUPPORTED (Adapter orchestrates combobox popover natively inside dialog top-layer).
- **Popover + Menu**: SUPPORTED (Canonical Dropdown Menu composite).
- **Popover + Dropdown Menu**: COMPOSITION-ONLY (Dropdown Menu is essentially this).
- **Popover + Context Menu**: ADAPTER-REQUIRED (Adapter orchestrates manual top-left positioning).
- **Popover + Tooltip**: COMPOSITION-ONLY (Tooltip relies exclusively on Popover API native).
- **Popover + Combobox**: SUPPORTED (Canonical Combobox composite).
- **Popover + Navigation Menu**: SUPPORTED (Adapter orchestrates native `[popover]` behavior for submenus).
- **Menu + Dropdown Menu**: COMPOSITION-ONLY (Dropdown Menu uses Menu primitives).
- **Menu + Context Menu**: COMPOSITION-ONLY (Context Menu uses Menu primitives).
- **Menu + Command Menu**: NOT RECOMMENDED (Command menu typically demands Combobox listbox semantics, not rigid Menu actions).
- **Navigation Menu + Popover**: SUPPORTED (Native popover behavior is recommended for submenus).
- **Navigation Menu + Drawer**: SUPPORTED (Drawer provides the container, Navigation Menu retains semantics).
- **Navigation Menu + Accordion**: SUPPORTED (Native `<details>` allows expanding sub-hierarchies gracefully).
- **Tabs + Carousel**: NOT RECOMMENDED (Semantic conflict: `aria-selected` vs `scroll`).
- **Tabs + Pagination**: NOT RECOMMENDED (Conflicting information architecture models).
- **Tabs + Stepper**: NOT RECOMMENDED (Progressive steps vs arbitrary panel swaps).
- **Combobox + Command Menu**: COMPOSITION-ONLY (Command Menu uses Combobox interaction engine).
- **Toast + Alert Dialog**: NOT RECOMMENDED (Toast is ephemeral, Alert Dialog demands explicit interaction. Conflicting usage).
- **Toast + Modal**: SUPPORTED (Toast is global/fixed, Modal is top-layer. Browser handles stacking natively).
- **Carousel + Pagination**: ADAPTER-REQUIRED (Carousel slides navigate via scrolling; pagination dots trigger smooth scroll to index).
- **Accordion + Navigation**: SUPPORTED (Excellent fallback structure for mobile drawer navigation lists).
- **Breadcrumbs + Navigation Menu**: NOT RECOMMENDED (Breadcrumbs outline hierarchy path; Navigation Menu handles generic destinations).

## 3. Surface Reuse
- **Modal Surface**: Directly reused by Drawer, Alert Dialog, and Command Menu.
- **Popover Surface**: Directly reused by Tooltip, Dropdown Menu, Context Menu, and Combobox popups.
- **Menu Surface**: Action-oriented list structure reused by Dropdown and Context menus.
- **Toast Surface**: Explicitly single-purpose.
- **Important Distinction**: Tooltip visually resembles a minimal Popover, but semantic reuse is prohibited. Navigation Menu visually resembles Menu, but specifically uses `<nav>`/`<a>` elements rather than `role="menu"`.

## 4. Native API Composition
- `<dialog>` + Combobox/Popover: Supported natively because both use modern top-layer APIs correctly.
- `<details>` inside `<nav>`: Correctly leverages native progressive disclosure.
- `[popover]` within `<nav>`: Supported. Provides predictable top-layer escaping for submenus.
- Native scrolling (`overflow`) within `<dialog>`: Native browser feature, supported safely.

## 5. Interaction Ownership
- **Native Browser**: Owns `<dialog>` opening/escaping, `[popover]` opening/light-dismiss, and Carousel touch/scrolling inertia.
- **CSS**: Owns presentation, anchor positioning offsets, scroll-snap alignment, surface layouts.
- **Adapter**: Owns orchestrated behavior like Focus trapping/restoring (where native falls short), roving tabindex (Menu, Combobox), scroll synchronization (Carousel indicators), manual `[popover]` positioning (Context Menu).
- **Consumer**: Owns application state, data fetching, routing, component mounting/unmounting, and Toast queue management.

## 6. Focus Composition
- **Dialog + Content**: `<dialog>` natively manages focus trapping.
- **Popover + Content**: `[popover]` manages focus on invocation.
- **Combobox**: Adapter explicitly manages `aria-activedescendant` or focus manipulation to options.
- **Navigation + Popover**: Submenu toggle button receives focus; adapter logic or native tab-order progresses into submenu.
- No global HEBRING focus manager exists. Adapters implement specific scoped focus orchestration.

## 7. Keyboard Composition
- **Modal/Drawer**: Native `<dialog>` `Escape` key handling.
- **Popover/Tooltip**: Native `[popover]` `Escape` key light-dismiss.
- **Menu**: Adapter owns `ArrowUp`/`ArrowDown`/`Enter`.
- **Tabs**: Adapter owns `ArrowLeft`/`ArrowRight`/`Enter`.
- **Combobox/Command Menu**: Adapter owns `ArrowUp`/`ArrowDown`/`Enter`/`Escape`.
- **Carousel**: Native horizontal scrolling logic.
- **Navigation**: Native `Tab` progression through links.

## 8. State Composition
- `[open]` is authoritative for `<dialog>` and `<details>`.
- `:popover-open` is authoritative for Popover.
- `aria-current` is authoritative for Navigation, Breadcrumbs, Pagination, Stepper, and Carousel indicators.
- `aria-selected` is authoritative for Tabs and Combobox/Command Menu options.
- `aria-expanded` is authoritative for Combobox triggers and custom Popover toggles.
- CSS NEVER infers generic `.is-active` state.

## 9. Accessibility Composition
- **Dialog/Drawer**: Must have `aria-labelledby` + `aria-describedby` when Alert Dialog.
- **Combobox**: Requires `aria-controls` linked to listbox ID and `aria-activedescendant`.
- **Tabs**: Requires `aria-controls` on tabs and `aria-labelledby` on tab panels.
- **Menu**: Requires strict `menu`/`menuitem` hierarchy.
- **Tooltip**: Trigger requires `aria-describedby`.
- Semantic boundaries are explicitly protected. An Accordion inside a Navigation Menu remains semantically transparent as a progressive disclosure element.

## 10. Positioning Composition
- Native top layer manages primary z-index for Modal, Popover, Drawer, etc.
- Anchor positioning (or manual absolute offsets via adapters) specifically manages relative placements (Tooltip, Dropdown).
- Fixed positioning specifically scopes Toast without conflicting with top-layer APIs.

## 11. Responsive Composition
- Responsive behavior is explicitly CSS-only (e.g. Carousel flex constraints, Drawer full-screen media queries).
- No JavaScript viewport frameworks are used.
- Transitioning Navigation Menu to a mobile Drawer involves the consumer mounting the Navigation Menu DOM inside the Drawer DOM.

## 12. Feedback Composition
- **Toast**: Ephemeral, non-blocking notification (global).
- **Alert Dialog**: Blocking, explicit decision confirmation.
- **Command Menu Feedback**: Command completion triggers consumer application logic, which may spawn a Toast. HEBRING does not enforce this composition natively.

## 13. Navigation Composition
- **Navigation Menu**: Persistent primary site architecture destinations.
- **Breadcrumbs**: Hierarchical location context.
- **Pagination**: Sequential collection indexing.
- **Stepper**: Sequential multi-stage workflow.
- **Carousel**: Sequential content consumption.
- **Tabs**: Mutually exclusive local panel switching.

## 14. Input Composition
- **Combobox**: Combines input text entry with a popover listbox filter mechanic.
- **Command Menu**: Inherits Combobox mechanics inside a prominent `<dialog>` surface for global system actions.

## 15. Supported Patterns
- Dropdown Menu (Popover + Menu).
- Context Menu (Popover + Menu + manual coordinate positioning).
- Command Menu (Modal + Combobox).
- Mobile Navigation (Drawer + Navigation Menu).
- Hierarchical Navigation (Navigation Menu + Accordion/Popover).
- Carousel with indicator pagination.

## 16. Adapter-Required Patterns
- Roving tabindex (Menu, Tabs, Combobox).
- Scroll-synced pagination (Carousel).
- Manual coordinate positioning (Context Menu).

## 17. Consumer-Owned Patterns
- Application routing, auto-rotation (Carousel autoplay), network lifecycle loading states, Toast queue orchestration, infinite looping.

## 18. Not Recommended Patterns
- Tabs used as Carousel controls.
- Toast used as Alert Dialog replacement.
- Menu used for site Navigation.
- Navigation Menu used for distinct application Actions.
- Tooltip containing interactive Comboboxes or Menus.
- Global HEBRING JS engines.

## 19. Composition Rules
- RULE 1: Reuse visual primitives without inheriting unrelated semantics.
- RULE 2: Native platform behavior should be reused before custom behavior.
- RULE 3: A composite component may combine existing primitives but must retain its own semantic contract.
- RULE 4: Adapters own interaction orchestration.
- RULE 5: Consumers own application state and routing.
- RULE 6: One interaction concern should have one authoritative owner.
- RULE 7: Do not compose components merely because their visuals are similar.
