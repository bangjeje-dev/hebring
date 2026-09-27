# HEBRING UI Architecture Specification

## 1. HEBRING UI Philosophy
HEBRING UI exists as a higher-level composition layer built on top of HEBRING Core. While Core provides the universal, framework-agnostic building blocks (buttons, inputs, layout primitives), HEBRING UI solves complex, domain-specific, or highly interactive UI challenges (modals, datepickers, complex navigation). By separating UI from Core, the Core remains exceptionally lightweight, predictable, and maintainable, while UI can iterate rapidly on complex patterns.

## 2. Core vs UI Boundary
- **HEBRING Core**: Pure CSS. Represents universal HTML patterns, including components like `.hb-button`, `.hb-card`, `.hb-badge`, and `.hb-alert`. Has no knowledge of complex state management beyond native pseudo-classes and simple `.is-*` toggles.
- **HEBRING UI**: Conceptual future ecosystem layer for complex interactive widgets (Modals, DatePickers, Accordions) that inherently require JavaScript logic, focus trapping, or dynamic rendering.
- *Example*: `.hb-card` belongs in Core. A complex interactive `Combobox` belongs in HEBRING UI.

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
HEBRING is distributed as a single npm package: `hebring`.
Conceptually, the ecosystem is split into distinct internal layers:
- Core: The pure CSS foundation (bundled in `dist/hebring.css`).
- Ecosystem UI: Optional framework-neutral CSS assets distributed unbundled via the `"./ui/*"` package export (e.g. `hebring/ui/modal.css`).
Interactive behavior is not provided by this CSS asset. Framework adapters / consumers own state and interaction logic. Core does not import Ecosystem UI.
*(Note: There is no `@hebring/core` or `@hebring/ui` package. These names refer purely to conceptual internal boundaries).*

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

## 10. Ecosystem UI State Convention
HEBRING Ecosystem UI follows a strict state fallback pattern to manage visibility and complex states:

**1. NATIVE STATE FIRST**
If the native HTML element provides an appropriate state, use that native state.
*Example: Native `<dialog>` visibility:*
```css
dialog.hb-modal[open] { ... }
dialog.hb-modal:not([open]) { ... }
```

**2. GENERIC DATA-STATE**
For generic Ecosystem UI components that do not have an equivalent native state, use the generic `data-state` attribute.
*Example: Dropdown or Popover visibility:*
```css
.hb-dropdown[data-state="open"] { ... }
.hb-dropdown[data-state="closed"] { ... }
```

**3. CONSUMER/FRAMEWORK BEHAVIOR**
- CSS *consumes* state. It does not create state.
- JavaScript/framework adapters *own* the state transitions (e.g., toggling the `open` attribute or `data-state`).
- Accessibility attributes (e.g., `aria-expanded="true"`, `aria-selected="true"`) remain the semantic accessibility state. They should not be replaced by `data-state` when the ARIA attribute itself is the authoritative source of truth for the state.

*Note: The `.is-*` classes (`.is-loading`, `.is-active`) remain valid as generic application hooks defined in Core, but `.is-open` is NOT the canonical HEBRING Ecosystem UI visibility state contract.*

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
If these criteria are met, a UI component may be refactored and moved to Core.

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

## 21. Modal DOM Contract & Accessibility
The Ecosystem UI Modal expects the native `<dialog>` element as its foundation.

### Canonical Markup
```html
<dialog class="hb-modal" aria-labelledby="modal-title" id="demo-modal">
  <div class="hb-modal__header">
    <h2 class="hb-modal__title" id="modal-title">Modal Title</h2>
    <button class="hb-button hb-button--sm" data-modal-close>Close</button>
  </div>
  <div class="hb-modal__body">
    <p>Modal content goes here.</p>
  </div>
  <div class="hb-modal__footer">
    <button class="hb-button hb-button--secondary" data-modal-close>Cancel</button>
    <button class="hb-button">Confirm</button>
  </div>
</dialog>
```

### Required Structure
- `<dialog class="hb-modal">`: The canonical modal primitive. Uses native `[open]` and `::backdrop`.

### Optional Structure
- `.hb-modal__header`, `.hb-modal__title`, `.hb-modal__body`, `.hb-modal__footer`: Optional semantic layout blocks.

### Accessibility Contract
- **Browser Responsibility**: Providing `[open]` state, top-layer rendering, `::backdrop`, and native Escape key handling when opened via `showModal()`.
- **Adapter Responsibility**: Triggering `.showModal()` and `.close()`, locking body scroll (if desired), and handling click-outside-to-close behavior.
- **Consumer Responsibility**: Providing correct `aria-labelledby` or `aria-describedby` connecting to internal content, and providing an accessible close button.

## 22. Drawer DOM Contract & Accessibility
The Ecosystem UI Drawer is built upon the same native `<dialog>` foundation as Modal, providing off-canvas sliding behavior.

### Canonical Markup
```html
<dialog class="hb-drawer" aria-labelledby="drawer-title">
  <div class="hb-drawer__header">
    <h2 class="hb-drawer__title" id="drawer-title">Drawer Title</h2>
    <button class="hb-button hb-button--sm" data-drawer-close>Close</button>
  </div>
  <div class="hb-drawer__content">
    <p>Drawer content</p>
  </div>
</dialog>
```

### Required Structure
- `<dialog class="hb-drawer">`: The canonical root. Uses native `[open]` and `::backdrop`.

### Optional Structure
- `.hb-drawer__header`, `.hb-drawer__title`, `.hb-drawer__content`, `.hb-drawer__footer`.

### Accessibility Contract
- Identical to Modal. The browser owns top-layer and `[open]` state. The adapter owns `showModal()` and click-outside logic.

## 23. Disclosure & Accordion DOM Contract & Accessibility
The Ecosystem UI Disclosure relies strictly on the native `<details>` and `<summary>` elements. An **Accordion** is a collection of these Disclosures.

### Canonical Disclosure Markup
```html
<details class="hb-accordion">
  <summary class="hb-accordion__trigger">
    Disclosure Title
  </summary>
  <div class="hb-accordion__content">
    Hidden content revealed upon open.
  </div>
</details>
```

### Canonical Accordion (Multiple-Open Baseline)
A basic Accordion is just multiple Disclosures in a row. It requires no JavaScript and allows multiple panels to be open simultaneously natively.
```html
<div class="hb-accordion-group">
  <details class="hb-accordion">...</details>
  <details class="hb-accordion">...</details>
</div>
```

### Required Structure
- `<details class="hb-accordion">`: The canonical root. Must be the `<details>` tag to inherit native `[open]` state.
- `<summary class="hb-accordion__trigger">`: The native disclosure trigger. Cannot be replaced with a generic button.

### Optional Structure
- `.hb-accordion__content`: A wrapper for the revealed content, mostly for padding control.

### Single-Open Enhancement
An optional single-open behavior (exclusive accordion) is supported natively in modern HTML via the `name` attribute on `<details>` elements.
```html
<details class="hb-accordion" name="my-accordion-group">...</details>
<details class="hb-accordion" name="my-accordion-group">...</details>
```

### Accessibility & Interaction Contract
- **Browser Responsibility**: Toggling the `[open]` attribute, handling click/Space/Enter on `<summary>`, focus management, and conveying expanded state to screen readers.
- **CSS Responsibility**: Styling relying entirely on native elements and native `[open]` state. No `.is-open`, `.is-active`, or custom state classes.
- **Adapter Responsibility**: None required for the multiple-open baseline or modern native single-open behavior. An optional reference adapter can provide a fallback for the single-open behavior in older browsers lacking `<details name>` support.
- **Consumer Responsibility**: Providing semantic content within the accordion.

Accordion does NOT require Popover, Menu, Tabs, or Tooltip semantics.

## 24. Breadcrumbs DOM Contract & Accessibility
Breadcrumbs provide semantic structural navigation without JavaScript behavior.

### Canonical Markup
```html
<nav class="hb-breadcrumbs" aria-label="Breadcrumb">
  <ol class="hb-breadcrumbs__list">
    <li class="hb-breadcrumbs__item">
      <a href="/">Home</a>
    </li>
    <li class="hb-breadcrumbs__item" aria-current="page">
      Current Page
    </li>
  </ol>
</nav>
```

### Required Structure
- `<nav class="hb-breadcrumbs">`: The canonical root. Should have `aria-label="Breadcrumb"`.
- `<ol class="hb-breadcrumbs__list">`: The ordered list container.
- `<li class="hb-breadcrumbs__item">`: The individual items. CSS handles the visual separator `/` via `::after`.

### Accessibility Contract
- **Browser Responsibility**: Standard link navigation and focus.
- **Adapter Responsibility**: None required.
- **Consumer Responsibility**: Constructing the proper list structure and correctly setting `aria-current="page"` on the final item.

## 25. Pagination DOM Contract & Accessibility
Pagination provides semantic structural navigation for multi-page datasets or content. It strictly owns presentation, not logic.

### Canonical Markup
```html
<nav class="hb-pagination" aria-label="Pagination">
  <ul class="hb-pagination__list">
    <li class="hb-pagination__item">
      <a class="hb-pagination__link" href="/page/1">1</a>
    </li>
    <li class="hb-pagination__item">
      <a class="hb-pagination__link" href="/page/2" aria-current="page">2</a>
    </li>
  </ul>
</nav>
```

### Required Structure
- `<nav class="hb-pagination">`: Canonical root. Should have `aria-label="Pagination"`.
- `<ul class="hb-pagination__list">`: List wrapper.
- `.hb-pagination__link`: The interactive page element (link or button).

### Accessibility Contract
- **Browser Responsibility**: Standard link/button navigation and focus.
- **Adapter/Consumer Responsibility**: Calculating pages, URLs, and setting `aria-current="page"` precisely on the active page. Applying `aria-disabled="true"` to unavailable links.

## 26. Stepper DOM Contract & Accessibility
The Stepper provides visual and semantic representation of progress through steps. It is a "Progress Stepper", not an interactive wizard controller.

### Canonical Markup
```html
<ol class="hb-stepper">
  <li class="hb-stepper__item hb-stepper__item--completed">
    Step 1: Account
  </li>
  <li class="hb-stepper__item" aria-current="step">
    Step 2: Profile
  </li>
  <li class="hb-stepper__item">
    Step 3: Confirm
  </li>
</ol>
```

### Required Structure
- `<ol class="hb-stepper">`: The ordered list root. Can optionally use `.hb-stepper--vertical`.
- `<li class="hb-stepper__item">`: The individual step wrapper.

### Accessibility Contract
- **Browser Responsibility**: Native list numbering and semantics.
- **Adapter/Consumer Responsibility**: Managing application state, setting `aria-current="step"` on the active step, and navigating between steps.

## 27. Popover DOM Contract & Accessibility
Popover is a fundamental interaction primitive using the native HTML Popover API. It serves as the foundation for future compositions like Dropdown Menu.

### Canonical Markup
```html
<button popovertarget="my-popover">Open Popover</button>

<div id="my-popover" class="hb-popover" popover>
  <p>Popover content</p>
</div>
```

### Required Structure
- `[popovertarget]`: The trigger button.
- `<div class="hb-popover" popover>`: The popover surface.

### State & Animation
- State is exclusively controlled by the browser using the `:popover-open` pseudo-class. No JavaScript classes are required or permitted.
- Entry/Exit animations use modern CSS features (`@starting-style`, `allow-discrete`) as progressive enhancements.

### Positioning
- CSS Anchor Positioning (`anchor-name`, `position-anchor`, `position-area`) is supported as a progressive enhancement.
- If unsupported, popovers fallback to centered or baseline margins depending on the flow. Complex fallback positioning belongs to the adapter.

### Accessibility Contract
- **Browser Responsibility**: Top-layer management, light-dismiss, Escape key handling, and `:popover-open` state.
- **Adapter Responsibility**: None for a generic popover. Compositions (like menus) will add keyboard focus management.
- **Consumer Responsibility**: Providing trigger relationships and appropriate fallback positioning logic for older browsers.

## 28. Menu Foundation DOM Contract & Accessibility
The Menu Foundation provides the semantic and visual presentation for a collection of actions or options. It is NOT an interactive Dropdown Menu on its own; it requires a Popover and an adapter for complete dropdown behavior.

### Canonical Markup
```html
<div class="hb-menu" role="menu">
  <div class="hb-menu__label" role="presentation">Actions</div>
  <button class="hb-menu__item" role="menuitem">Edit</button>
  <a class="hb-menu__item" role="menuitem" href="/view">View</a>
  <hr class="hb-menu__separator" role="separator" />
  <button class="hb-menu__item" role="menuitem" disabled>Delete</button>
</div>
```

### Required Structure
- `.hb-menu`: The menu surface root.
- `.hb-menu__item`: The interactive item (must be applied to a native interactive element like `<button>` or `<a>`).

### Optional Structure
- `.hb-menu__label`: A visual group label.
- `.hb-menu__separator`: A visual divider between groups.

### Accessibility Contract
- **Browser Responsibility**: Native button/link interaction, focus management, native disabled state handling.
- **HEBRING CSS**: Visual hierarchy, spacing, hover/focus-visible states, reduced motion.
- **DOM Contract**: Appropriate roles (`menu`, `menuitem`, `separator`) must be applied if the menu acts as a true ARIA menu.
- **Adapter Responsibility**: Keyboard navigation (Arrow Up/Down, Home, End), focus trapping, roving tabindex, and opening/closing when composed into a Dropdown Menu.
- **Consumer Responsibility**: Accessible labels and application action execution.

## 29. Tooltip Foundation DOM Contract & Accessibility
The Tooltip Foundation provides semantic and visual presentation for non-interactive descriptive text associated with another element. It is NOT an interactive Popover and must not contain interactive elements.

### Canonical Markup
```html
<button aria-describedby="tooltip-id">Action</button>

<div id="tooltip-id" class="hb-tooltip" role="tooltip">
  Concise descriptive text.
</div>
```

### Required Structure
- `.hb-tooltip`: The tooltip surface.
- `aria-describedby`: Explicitly links the trigger to the tooltip.
- `role="tooltip"`: Enforces the correct accessibility semantics on the surface.

### Placement Modifiers (Progressive Enhancement)
- `.hb-tooltip--top`, `.hb-tooltip--bottom`, `.hb-tooltip--start`, `.hb-tooltip--end`
- These rely exclusively on CSS Anchor Positioning (`position-area`) as a progressive enhancement. Browsers without support require an adapter (like Floating UI) to handle positioning coordinates. No DOM wrapper is required.

### Interactive Boundary
Tooltip content MUST remain non-interactive. Do not place buttons, links, or form fields inside a tooltip. If interaction is required, use a `Popover`, `Dialog`, or `Dropdown Menu` instead.

### Accessibility Contract
- **Browser Responsibility**: Exposing the `aria-describedby` relationship to screen readers.
- **HEBRING CSS**: Visual hierarchy, contrast, compact surface styling.
- **DOM Contract**: `aria-describedby` and `role="tooltip"` represent the core relationship.
- **Adapter Responsibility**: Hover intent delays, pointer enter/leave logic, focus handling, show/hide lifecycle, and dynamic coordinate positioning for fallback placement.
- **Consumer Responsibility**: Providing the accessible text, maintaining the ID reference, and ensuring the trigger itself is focusable.

## 30. Dropdown Menu Composition & Accessibility
The Dropdown Menu is NOT a separate CSS primitive. It is a composition of:
`Popover` + `Menu Foundation` + `Reference Adapter` = `Dropdown Menu`

### Canonical Markup
```html
<button
  type="button"
  popovertarget="dropdown-1"
  aria-haspopup="menu"
  aria-expanded="false"
>
  Actions
</button>

<div id="dropdown-1" class="hb-popover" popover>
  <div class="hb-menu" role="menu">
    <button class="hb-menu__item" role="menuitem" tabindex="0">Edit</button>
    <button class="hb-menu__item" role="menuitem" tabindex="-1">Duplicate</button>
    <hr class="hb-menu__separator" role="separator" />
    <button class="hb-menu__item" role="menuitem" tabindex="-1" disabled>Delete</button>
  </div>
</div>
```

### Required Structure
- Trigger: `<button popovertarget="id" aria-haspopup="menu" aria-expanded="false">`.
- Surface: `<div id="id" class="hb-popover" popover>`.
- Menu: `<div class="hb-menu" role="menu">` wrapping `.hb-menu__item` elements with `role="menuitem"`.

### Accessibility & Interaction Contract
- **Browser Responsibility**: Top-layer promotion, native `popover` light-dismiss, and `:popover-open` CSS synchronization.
- **HEBRING CSS**: Visual hierarchy, surface presentation, focus states, and native popover transitions (`@starting-style`).
- **Adapter Responsibility**:
  - Syncing `aria-expanded` on the trigger based on the popover state.
  - Managing a roving `tabindex` (`0` for the active item, `-1` for others).
  - Handling keyboard navigation within the menu (ArrowUp, ArrowDown, Home, End).
  - Trapping typeahead character searches to move focus.
  - Restoring focus to the trigger on Escape or menu activation.
- **Consumer Responsibility**: Application action logic and routing.

## 31. Context Menu Composition & Accessibility
The Context Menu is NOT a separate CSS primitive. It is a composition of:
`Popover` + `Menu Foundation` + `Context Menu Adapter` = `Context Menu`

### Canonical Markup
```html
<div id="context-menu-target" tabindex="0">
  Right-click here
</div>

<div id="context-menu" class="hb-popover" popover>
  <div class="hb-menu" role="menu">
    <button class="hb-menu__item" role="menuitem" tabindex="0">Edit</button>
    <button class="hb-menu__item" role="menuitem" tabindex="-1">Duplicate</button>
    <button class="hb-menu__item" role="menuitem" tabindex="-1" disabled>Delete</button>
  </div>
</div>
```

### Required Structure
- Target: An element that receives the `contextmenu` event. If it needs focus restoration, it should be focusable (e.g. `tabindex="0"` or inherently focusable).
- Surface: `<div id="id" class="hb-popover" popover>`.
- Menu: `<div class="hb-menu" role="menu">` wrapping `.hb-menu__item` elements with `role="menuitem"`.

### Accessibility & Interaction Contract
- **Browser Responsibility**: Top-layer promotion, native `popover` light-dismiss, and `:popover-open` CSS synchronization.
- **HEBRING CSS**: Visual hierarchy, surface presentation, focus states, and native popover transitions (`@starting-style`).
- **Adapter Responsibility**:
  - Intercepting the `contextmenu` event on the target and calling `preventDefault()`.
  - Capturing `event.clientX` and `event.clientY` coordinates.
  - Opening the native popover.
  - Positioning the popover via inline coordinates relative to the viewport.
  - Handling viewport boundary clamping to ensure the menu is visible.
  - Managing roving `tabindex`.
  - Focus management (first enabled item on open, restoring focus to original element on close).
  - Keyboard navigation (ArrowUp, ArrowDown, Home, End, Escape).
- **Consumer Responsibility**: Application logic and routing.

## 32. Tabs Architecture & Accessibility
Tabs are an independent interaction pattern. They are NOT a variation of Menu, Popover, Disclosure, or Dropdown.

### Canonical Markup
```html
<div class="hb-tabs">
  <div class="hb-tabs__list" role="tablist" aria-label="Tabs navigation">
    <button class="hb-tabs__tab" role="tab" aria-selected="true" aria-controls="panel-1" id="tab-1" tabindex="0">
      Tab One
    </button>
    <button class="hb-tabs__tab" role="tab" aria-selected="false" aria-controls="panel-2" id="tab-2" tabindex="-1">
      Tab Two
    </button>
  </div>

  <div class="hb-tabs__panel" role="tabpanel" id="panel-1" aria-labelledby="tab-1">
    Panel One Content
  </div>
  <div class="hb-tabs__panel" role="tabpanel" id="panel-2" aria-labelledby="tab-2" hidden>
    Panel Two Content
  </div>
</div>
```

### Required Structure
- **Container**: Optional `.hb-tabs` layout wrapper.
- **Tab List**: `.hb-tabs__list` with `role="tablist"` and `aria-label` (or `aria-labelledby`).
- **Tab**: `.hb-tabs__tab` with `role="tab"`, unique `id`, `aria-controls` pointing to the panel, `aria-selected`, and `tabindex`.
- **Panel**: `.hb-tabs__panel` with `role="tabpanel"`, unique `id`, `aria-labelledby` pointing to the tab. Inactive panels must use the native `hidden` attribute.

### Accessibility & Interaction Contract
- **CSS Responsibility**:
  - Styling based entirely on ARIA attributes (`[aria-selected="true"]`). No `.is-active`, `.is-selected`, or `.data-state` state classes.
  - Relying on native `[hidden]` attribute for panel visibility.
  - Distinct styling for `:disabled` native attribute.
- **Adapter Responsibility**:
  - Managing roving `tabindex` (`0` for active tab, `-1` for inactive tabs).
  - Synchronizing `aria-selected` on tabs.
  - Synchronizing native `hidden` state on corresponding panels.
  - Implementing keyboard navigation (ArrowRight, ArrowLeft, Home, End).
  - Implementing automatic activation (focusing a tab automatically activates its panel).
- **Consumer Responsibility**: Generating unique IDs mapping tabs to panels.

## 33. Combobox Foundation & Accessibility
Combobox is an independent input-driven selection primitive. It is distinct from Select (no search), Menu (no input filtering), and Command Menu (which may compose this).

### Canonical Markup
```html
<div class="hb-combobox">
  <input class="hb-combobox__input hb-input" role="combobox" aria-expanded="false" aria-controls="combo-listbox" aria-autocomplete="list" type="text" placeholder="Search...">
  <div id="combo-listbox" class="hb-popover hb-combobox__listbox" popover role="listbox">
    <div role="option" id="combo-opt-1" class="hb-combobox__option" aria-selected="false">Apple</div>
    <div role="option" id="combo-opt-2" class="hb-combobox__option" aria-disabled="true">Disabled Fruit</div>
    <div class="hb-combobox__empty">No results found</div>
  </div>
</div>
```

### Combobox Model & Contract
- Combobox uses a text input to filter and list options.
- Options use `[aria-selected="true"]` for visual highlight / active state, NOT `.is-highlighted`.
- The Popover API acts as the floating surface for the Listbox.
- Focus always remains in the `input`. The `input` manages `aria-activedescendant`.
- Do not place `role="combobox"` on the wrapper. Only on the `input`.
- Combobox options must use `role="option"`, not `role="menuitem"`.

### Responsibilities
- **Browser Responsibility**: Providing text input capabilities and Popover lifecycle.
- **CSS Responsibility**: Styling input, popup, and options purely relying on native elements, popover state, and semantic ARIA attributes.
- **Adapter Responsibility**: Managing popover visibility (via `.showPopover()`), handling keyboard navigation (Arrow Up/Down/Home/End), selecting items (Enter/Click), and syncing `aria-expanded` and `aria-activedescendant`.
- **Consumer Responsibility**: Providing matching option labels, IDs, and handling logic data binding (e.g. form submission).

## 34. Command Menu Foundation & Accessibility
Command Menu is an application command discovery interface. It is a higher-level ecosystem composition built on top of Dialog and Combobox interaction models.

### Canonical Markup
```html
<dialog class="hb-modal hb-command-menu__dialog" aria-label="Command Menu">
  <div class="hb-command-menu">
    <input type="text" class="hb-command-menu__input" role="combobox" aria-expanded="true" aria-controls="cmd-listbox" aria-autocomplete="list" placeholder="Search...">
    <div id="cmd-listbox" class="hb-command-menu__list" role="listbox">
      <div class="hb-command-menu__group" role="group" aria-label="Navigation">
        <div class="hb-command-menu__group-label" aria-hidden="true">Navigation</div>
        <div role="option" class="hb-command-menu__item" aria-selected="false">Dashboard</div>
      </div>
    </div>
  </div>
</dialog>
```

### Architectural Contract
- **Not a Menu**: It does not use Menu or Dropdown/Context Menu semantics. It uses Listbox semantics because it is driven by a search/filter input.
- **Composition**: It composes `dialog` (for the modal popup) and a Combobox-like input model (for filtering and arrow navigation).
- **Focus Model**: Focus remains strictly on the input field. `aria-activedescendant` is used to track the currently active item.
- **Execution**: The input handles Enter to execute the active command.
- **Disabled Commands**: Represented with `aria-disabled="true"`, preventing selection and execution.
- **Shortcut Presentation**: Command shortcuts (e.g., `⌘K`) are purely visual metadata. No global shortcut engine or history macros are included in this foundation.

### Responsibilities
- **Browser Responsibility**: Managing the modal lifecycle (via `<dialog>` and `showModal()`) and input typing.
- **CSS Responsibility**: Styling the surface, input, groups, and items without relying on custom `.is-*` state classes.
- **Adapter Responsibility**: Managing simple substring filtering, keyboard navigation (Arrow Up/Down, Home/End, Enter, Escape), syncing `aria-activedescendant` on the input, and executing commands safely within the playground environment.
- **Consumer Responsibility**: Supplying the actual command definitions and the execution logic (e.g., routing) within an application context.

## 35. Toast & Notification Foundation
Toast represents transient, non-blocking feedback. It is distinct from Dialog (which is blocking) and Tooltip (which provides contextual description).

### Canonical Markup
```html
<!-- Region wrapper (often application singleton) -->
<div class="hb-toast-region" aria-label="Notifications">

  <!-- Individual Toast -->
  <div class="hb-toast" role="status" aria-live="polite" data-variant="success">
    <div class="hb-toast__content">
      <strong class="hb-toast__title">Changes Saved</strong>
      <p class="hb-toast__message">Your settings have been updated successfully.</p>
    </div>

    <button type="button" class="hb-toast__close" aria-label="Dismiss notification">
      <!-- Icon SVG -->
    </button>
  </div>

</div>
```

### Architectural Contract
- **Not a Modal**: Toast does not block the page.
- **Not a Popover**: Toast does not use the Popover API and does not anchor to specific trigger elements; it is viewport-fixed.
- **Region Responsibility**: `.hb-toast-region` handles viewport positioning (respecting safe areas), stacking (flex layout + gap), and pointer-event passthrough (`pointer-events: none`).
- **Toast Responsibility**: `.hb-toast` handles the individual surface appearance, spacing, and reinstates `pointer-events: auto`.
- **Variants**: Semantic feedback relies on the `data-variant` attribute (`success`, `warning`, `error`).
- **Animation**: Reduced motion is respected natively within CSS. CSS transition completion does *not* govern the lifecycle.

### Semantic / ARIA Model
- Standard feedback uses `role="status"` and `aria-live="polite"`.
- Critical/Urgent feedback uses `role="alert"` and `aria-live="assertive"`.
- Do not automatically focus a Toast when it appears.
- Close buttons must be properly labeled (e.g. `aria-label="Dismiss notification"`).

### Responsibilities
- **Browser Responsibility**: Providing layout, fixed positioning, flex gap, and safe-area environment variables.
- **CSS Responsibility**: Styling the Toast Region (stacking/positioning) and Toast Content (surface, colors, typography, layout) without relying on global `is-visible` classes.
- **Adapter Responsibility**: Demonstrating dynamic creation, insertion, timeout (auto-dismiss), hover pause/resume logic, explicit dismissal (closing), and DOM removal.
- **Consumer Responsibility**: Integrating Toasts with their actual application event lifecycle, state management, and notification queuing if required. HEBRING provides the CSS surface, not a notification manager library.

## 36. Alert Dialog Foundation
Alert Dialog is a specialized confirmation-oriented modal interaction for actions requiring explicit user acknowledgment or decision (e.g., destructive actions).

### Canonical Markup
```html
<dialog class="hb-modal" aria-labelledby="alert-dialog-title" aria-describedby="alert-dialog-desc" role="alertdialog">
  <div class="hb-modal__header">
    <h2 class="hb-modal__title" id="alert-dialog-title">Delete Project?</h2>
  </div>
  <div class="hb-modal__body" id="alert-dialog-desc">
    <p>Are you sure you want to delete this project? This action cannot be undone.</p>
  </div>
  <div class="hb-modal__footer">
    <button class="hb-button hb-button--secondary">Cancel</button>
    <button class="hb-button hb-button--danger">Delete</button>
  </div>
</dialog>
```

### Architectural Contract
- **CSS Reuse**: Alert Dialog does not require a dedicated CSS implementation. It strictly reuses `.hb-modal` structural primitives (`hb-modal__header`, `hb-modal__body`, `hb-modal__footer`).
- **State Model**: State is tied to the native `<dialog>` element's `[open]` attribute, just like standard Modal.
- **Escape Behavior**: Native browser Esc dismissal is implicitly supported via `<dialog>`.
- **Backdrop Behavior**: Backdrop clicks should not automatically dismiss the alert dialog. This requires explicit user acknowledgment.
- **Async Actions**: Loading spinners, network requests, and async lifecycles are the responsibility of the consumer application layer, not HEBRING.

### Semantic / ARIA Model
- Uses `role="alertdialog"` to convey urgency and explicit confirmation semantics to assistive technology.
- Explicitly demands an accessible name via `aria-labelledby` directly referencing the title element.
- Employs `aria-describedby` referencing the body content to provide critical contextual feedback.
- For destructive actions, the "Cancel" action should receive initial focus to prevent accidental irreversible damage.

### Responsibilities
- **Browser Responsibility**: Providing `<dialog>` top layer, focus trapping, Escape handling, and `::backdrop` overlay.
- **CSS Responsibility**: Supplying standard `.hb-modal` surface styles, layout, and visual component semantics (like `.hb-button--danger` for destructive contexts).
- **Adapter Responsibility**: Managing `showModal()`, `close()`, initial focus shifting (e.g. defaulting to Cancel), and restoring focus to the original trigger upon dialog dismissal.
- **Consumer Responsibility**: Orchestrating actual backend deletions, network async behavior, button states while loading, and final contextual logic routing.

## 37. Navigation Menu Foundation
Navigation Menu represents persistent or semi-persistent site/application information architecture. It is destination-oriented, distinguishing it from action-oriented Menus.

### Canonical Markup
```html
<nav class="hb-navigation" aria-label="Main Navigation">
  <ul class="hb-navigation__list">
    <li class="hb-navigation__item">
      <a class="hb-navigation__link" href="#" aria-current="page">Home</a>
    </li>
    <li class="hb-navigation__item">
      <!-- Submenu Trigger -->
      <button class="hb-navigation__trigger" aria-expanded="false" popovertarget="nav-products">
        Products
      </button>
      <!-- Submenu Content -->
      <div id="nav-products" class="hb-popover" popover>
        <ul class="hb-navigation__content">
          <li class="hb-navigation__item">
            <a class="hb-navigation__link" href="#">Analytics</a>
          </li>
        </ul>
      </div>
    </li>
  </ul>
</nav>
```

### Architectural Contract
- **Semantics**: Uses `<nav>`, `<ul>`, `<li>`, and `<a>`. It explicitly does **not** use `role="menu"` or `role="menuitem"`. Navigation is not a desktop widget.
- **Current Page**: State is driven by `aria-current="page"`. Custom `.is-active` state classes are strictly forbidden.
- **Router Boundary**: HEBRING CSS styles the active state based on attributes but never parses URLs or tracks history. The consumer application router assigns `aria-current`.
- **Submenus**: Optional interactions are composed using native primitives (e.g. Popover API) rather than an exclusive Navigation CSS positioning engine.

### Responsibilities
- **Browser Responsibility**: Native link handling, Tab focus progression, Popover APIs (for submenus).
- **CSS Responsibility**: Supplying layout (horizontal vs. wrapped), readable spacing, hover states, visible focus states, and current page styles via `[aria-current="page"]`.
- **Adapter Responsibility**: Toggling `aria-expanded` and managing focus restoration if complex submenu interaction is added natively via Popover.
- **Consumer Responsibility**: Accessible labeling (`aria-label`), tracking browser history, assigning `aria-current`, and mapping routes.

## 38. Carousel Foundation
Carousel is a content navigation pattern for presenting a sequence of related items where only part of the collection may be visible. It relies purely on native scrolling mechanics without a custom physics engine or global JS framework.

### Canonical Markup
```html
<section class="hb-carousel" aria-label="Featured Projects">
  <div class="hb-carousel__viewport">
    <div class="hb-carousel__track">
      <article class="hb-carousel__slide">Slide 1</article>
      <article class="hb-carousel__slide">Slide 2</article>
    </div>
  </div>
  <div class="hb-carousel__controls">
    <button class="hb-button" aria-label="Previous slide">Previous</button>
    <button class="hb-button" aria-label="Next slide">Next</button>
  </div>
  <div class="hb-carousel__pagination">
    <button class="hb-carousel__indicator" aria-current="true" aria-label="Go to slide 1"></button>
    <button class="hb-carousel__indicator" aria-current="false" aria-label="Go to slide 2"></button>
  </div>
</section>
```

### Architectural Contract
- **Native Scrolling**: The `.hb-carousel__viewport` container manages overflow purely via CSS (`overflow-x: auto`), using native scroll physics and touch APIs.
- **Scroll Snap**: Implements `scroll-snap-type` and `scroll-snap-align` to ensure predictable navigation naturally.
- **No Global JS Carousel Engine**: Does not require autoplay, infinite looping, or custom swipe physics engines.
- **No Tabs/Selected State Constraints**: Slide visibility is based entirely on viewport scroll position. We do not inject custom `.is-active` or `aria-selected` tracking purely for visible slides unless creating explicit tab semantics. Indicators utilize `aria-current`.

### Responsibilities
- **Browser Responsibility**: Touch inertia, track bounding, native scrolling functionality, scroll snap calculations, rendering scrollbars.
- **CSS Responsibility**: Providing layout structure, enabling overflow behavior, specifying scroll snap configuration, sizing slides flexably, styling interactive controls and indicators, and managing `prefers-reduced-motion` fallbacks to native instant scroll.
- **Adapter Responsibility**: Interpreting the scroll position of the viewport, calculating button disabled boundaries, orchestrating smooth programmable scrolling on button clicks, and syncing the indicator states (`aria-current`).
- **Consumer Responsibility**: Orchestrating complex logic such as auto-rotation, rendering loops, or sophisticated dynamic lists if applicable on top of the HEBRING foundation.

## 39. Definition of Done
Phase 54 is complete when this UI Architecture Specification is updated and implemented correctly.
