# Ecosystem UI DOM Contracts

## 1. Contract Philosophy
HEBRING relies on native HTML structure, semantic attributes, and precise component boundaries to define DOM contracts. It aims for a zero-JavaScript foundational structure where interaction, state, and accessibility roles are owned by their respective native elements (e.g. `<dialog>`, `[popover]`, `[aria-current]`) whenever possible. CSS controls presentation; Framework Adapters coordinate missing behaviors (like focus management); and Consumers control application logic.

## 2. Contract Vocabulary
- **REQUIRED**: Must exist for the component contract.
- **OPTIONAL**: Supported but not structurally necessary.
- **RECOMMENDED**: Strongly advised for accessibility or good UX but not structurally mandatory.
- **ADAPTER-OWNED**: Created, synchronized, or manipulated by the framework/reference adapter.
- **CONSUMER-OWNED**: Data, content, and application-specific logic provided by the application.

## 3. Modal
- **Purpose**: A blocking surface that commands the user's attention.
- **Required DOM**: `<dialog class="hb-modal">`
- **Optional DOM**: `<div class="hb-modal__header">`, `<div class="hb-modal__body">`, `<div class="hb-modal__footer">`
- **Required Attributes**: `[open]` (when active)
- **State Owner**: The `<dialog>` element (`[open]`).
- **Focus Owner**: Initially, the `<dialog>` or the first focusable element. Focus is trapped.
- **ARIA Contract**: RECOMMENDED `aria-labelledby` and `aria-describedby` pointing to header/body content.
- **ID/Reference Contract**: CONSUMER-OWNED IDs for `aria-labelledby`.
- **Adapter Responsibility**: Triggering `showModal()`/`close()`.
- **Consumer Responsibility**: Handling submission, state synchronization.
- **Keyboard Contract**: NATIVE `Escape` key to close.

## 4. Alert Dialog
- **Purpose**: A blocking confirmation surface for destructive or critical actions.
- **Required DOM**: `<dialog class="hb-modal">` (Reuses Modal CSS)
- **Optional DOM**: Same as Modal.
- **Required Attributes**: `role="alertdialog"`, `aria-labelledby`, `aria-describedby`
- **State Owner**: The `<dialog>` element (`[open]`).
- **Focus Owner**: RECOMMENDED to focus the least-destructive action (e.g., "Cancel" button).
- **ARIA Contract**: REQUIRED `role="alertdialog"`, `aria-labelledby`, `aria-describedby`.
- **ID/Reference Contract**: CONSUMER-OWNED IDs for ARIA references.
- **Adapter Responsibility**: Managing `showModal()` and explicit focus routing.
- **Consumer Responsibility**: Application logic for destructive actions.
- **Keyboard Contract**: NATIVE `Escape` key to close.

## 5. Drawer
- **Purpose**: An edge-anchored overlay.
- **Required DOM**: `<dialog class="hb-drawer">`
- **Optional DOM**: Same inner structure as Modal.
- **Required Attributes**: `[open]`
- **State Owner**: The `<dialog>` element (`[open]`).
- **Focus Owner**: The `<dialog>` or first focusable element.
- **ARIA Contract**: RECOMMENDED `aria-labelledby`.
- **ID/Reference Contract**: CONSUMER-OWNED IDs.
- **Adapter Responsibility**: `showModal()`/`close()`.
- **Consumer Responsibility**: Mounting/unmounting.
- **Keyboard Contract**: NATIVE `Escape` key.

## 6. Popover
- **Purpose**: A non-modal overlay bound to a trigger.
- **Required DOM**: `<div class="hb-popover">`
- **Optional DOM**: N/A
- **Required Attributes**: `popover` or `popover="auto"`
- **State Owner**: The Popover element (`:popover-open`).
- **Focus Owner**: NATIVE browser handles light-dismiss, focus typically remains on trigger or moves manually via adapter.
- **ARIA Contract**: `aria-expanded` (on trigger) and `aria-controls` (on trigger) RECOMMENDED.
- **ID/Reference Contract**: REQUIRED `id` on the popover, referenced by the trigger.
- **Adapter Responsibility**: Explicit coordinate positioning (if not using CSS anchor).
- **Consumer Responsibility**: Content population.
- **Keyboard Contract**: NATIVE `Escape` to close.

## 7. Menu
- **Purpose**: A list of actionable commands.
- **Required DOM**: `<div class="hb-menu">` (or `<menu>`), `<div class="hb-menu__item">`
- **Optional DOM**: Menu separators.
- **Required Attributes**: `role="menu"` on root, `role="menuitem"` on items.
- **State Owner**: The currently focused item (via roving tabindex).
- **Focus Owner**: The active `menuitem`.
- **ARIA Contract**: `role="menu"`, `role="menuitem"`, `aria-disabled` (if disabled).
- **ID/Reference Contract**: None strictly required.
- **Adapter Responsibility**: Roving tabindex (`ArrowUp`/`ArrowDown`).
- **Consumer Responsibility**: Action handling.
- **Keyboard Contract**: ADAPTER handles arrow keys.

## 8. Dropdown Menu
- **Purpose**: A Menu presented within a Popover.
- **Required DOM**: Popover structure containing Menu structure.
- **Optional DOM**: N/A
- **Required Attributes**: Same as Popover + Menu.
- **State Owner**: Popover for visibility, Menu for selection.
- **Focus Owner**: Menu items (upon opening).
- **ARIA Contract**: `aria-expanded`, `aria-controls` on trigger; `role="menu"` on content.
- **ID/Reference Contract**: Same as Popover.
- **Adapter Responsibility**: Popover positioning + Menu keyboard coordination.
- **Consumer Responsibility**: Action handling.
- **Keyboard Contract**: ADAPTER handles arrow keys; NATIVE handles `Escape`.

## 9. Context Menu
- **Purpose**: A Menu triggered by right-click/context-action at specific coordinates.
- **Required DOM**: Popover containing Menu.
- **Optional DOM**: N/A
- **Required Attributes**: `popover="manual"`.
- **State Owner**: Popover.
- **Focus Owner**: Menu items.
- **ARIA Contract**: `role="menu"`.
- **ID/Reference Contract**: N/A.
- **Adapter Responsibility**: Manual absolute coordinate positioning based on mouse event.
- **Consumer Responsibility**: Binding the contextmenu event.
- **Keyboard Contract**: ADAPTER handles arrow keys.

## 10. Tooltip
- **Purpose**: Transient, informative text bound to an element.
- **Required DOM**: `<div class="hb-tooltip" popover>`
- **Optional DOM**: N/A
- **Required Attributes**: `popover`, `role="tooltip"`.
- **State Owner**: Popover (`:popover-open`).
- **Focus Owner**: Focus MUST remain on the trigger.
- **ARIA Contract**: `role="tooltip"`, trigger MUST have `aria-describedby`.
- **ID/Reference Contract**: REQUIRED `id` on tooltip referenced by trigger's `aria-describedby`.
- **Adapter Responsibility**: Hover/Focus intent timing, positioning.
- **Consumer Responsibility**: Providing concise text.
- **Keyboard Contract**: ADAPTER opens on focus, NATIVE `Escape` to close.

## 11. Accordion
- **Purpose**: Vertically stacked progressive disclosure.
- **Required DOM**: `<details class="hb-accordion">`, `<summary class="hb-accordion__trigger">`, `<div class="hb-accordion__content">`
- **Optional DOM**: N/A
- **Required Attributes**: None (native).
- **State Owner**: `<details>` (`[open]`).
- **Focus Owner**: `<summary>`.
- **ARIA Contract**: Handled natively by `<details>`/`<summary>`.
- **ID/Reference Contract**: N/A.
- **Adapter Responsibility**: Optional exclusive (accordion group) logic.
- **Consumer Responsibility**: Content.
- **Keyboard Contract**: NATIVE `Enter`/`Space` to toggle.

## 12. Breadcrumbs
- **Purpose**: Hierarchical location context.
- **Required DOM**: `<nav class="hb-breadcrumbs">`, `<ol class="hb-breadcrumbs__list">`, `<li class="hb-breadcrumbs__item">`, `<a>`
- **Optional DOM**: Separators.
- **Required Attributes**: `aria-current="page"` on the current active item.
- **State Owner**: Consumer (via `aria-current="page"`).
- **Focus Owner**: `<a>`.
- **ARIA Contract**: `aria-current="page"`.
- **ID/Reference Contract**: N/A.
- **Adapter Responsibility**: None.
- **Consumer Responsibility**: Providing correct hierarchy and applying `aria-current="page"`.
- **Keyboard Contract**: NATIVE `Tab`.

## 13. Pagination
- **Purpose**: Navigation through sequential pages.
- **Required DOM**: `<nav class="hb-pagination">`, `<ul>`, `<li>`, `<a>` or `<button>`
- **Optional DOM**: N/A
- **Required Attributes**: `aria-current="page"` on current page.
- **State Owner**: Consumer (via `aria-current="page"`).
- **Focus Owner**: Links/Buttons.
- **ARIA Contract**: `aria-current="page"`, `aria-disabled="true"`.
- **ID/Reference Contract**: N/A.
- **Adapter Responsibility**: None.
- **Consumer Responsibility**: Routing/fetching.
- **Keyboard Contract**: NATIVE `Tab`.

## 14. Stepper
- **Purpose**: Multi-step progressive workflow.
- **Required DOM**: `<ol class="hb-stepper">`, `<li class="hb-stepper__item">`
- **Optional DOM**: N/A
- **Required Attributes**: `aria-current="step"` on active step.
- **State Owner**: Consumer (via `aria-current="step"`).
- **Focus Owner**: N/A (unless interactive).
- **ARIA Contract**: `aria-current="step"`.
- **ID/Reference Contract**: N/A.
- **Adapter Responsibility**: None.
- **Consumer Responsibility**: Step logic.
- **Keyboard Contract**: N/A.

## 15. Tabs
- **Purpose**: Mutually exclusive local panel switching.
- **Required DOM**: `<div class="hb-tabs">`, `<div class="hb-tabs__list">`, `<button class="hb-tabs__tab">`, `<div class="hb-tabs__panel">`
- **Optional DOM**: N/A
- **Required Attributes**: `role="tablist"`, `role="tab"`, `role="tabpanel"`, `aria-selected`, `aria-controls`, `aria-labelledby`.
- **State Owner**: The Tab List (`aria-selected`).
- **Focus Owner**: The active Tab.
- **ARIA Contract**: REQUIRED full ARIA tabs pattern.
- **ID/Reference Contract**: REQUIRED IDs matching `aria-controls` to panels and `aria-labelledby` to tabs.
- **Adapter Responsibility**: Roving tabindex, `ArrowLeft`/`ArrowRight` navigation, showing/hiding panels.
- **Consumer Responsibility**: None beyond markup if adapter handles logic.
- **Keyboard Contract**: ADAPTER owns arrow keys.

## 16. Combobox
- **Purpose**: Text input with filtered popup listbox.
- **Required DOM**: `<div class="hb-combobox">`, `<input class="hb-combobox__input">`, `<div class="hb-combobox__popover" popover>`, `<div class="hb-combobox__option">`
- **Optional DOM**: N/A
- **Required Attributes**: `role="combobox"`, `aria-expanded`, `aria-controls`, `role="listbox"`, `role="option"`.
- **State Owner**: Input (`aria-expanded`), Active Option (`aria-selected`).
- **Focus Owner**: Input (Focus remains on input).
- **ARIA Contract**: `aria-activedescendant` coordinates the "active" visual option without moving DOM focus.
- **ID/Reference Contract**: REQUIRED `aria-controls` to listbox, `aria-activedescendant` to option ID.
- **Adapter Responsibility**: Filtering, popover management, `ArrowUp`/`ArrowDown` manipulation of `aria-activedescendant`.
- **Consumer Responsibility**: Data fetching.
- **Keyboard Contract**: ADAPTER owns arrow keys and selection.

## 17. Command Menu
- **Purpose**: Global system action palette.
- **Required DOM**: Dialog containing Combobox primitives.
- **Optional DOM**: N/A
- **Required Attributes**: Same as Dialog + Combobox.
- **State Owner**: Dialog (`[open]`).
- **Focus Owner**: Input.
- **ARIA Contract**: Dialog + Combobox ARIA.
- **ID/Reference Contract**: Same as Combobox.
- **Adapter Responsibility**: Shortcut invocation (e.g. Cmd+K), Combobox interaction.
- **Consumer Responsibility**: Command execution.
- **Keyboard Contract**: ADAPTER owns Combobox keyboard semantics + Global invocation shortcut.

## 18. Toast
- **Purpose**: Ephemeral system feedback.
- **Required DOM**: `<div class="hb-toast-region">`, `<output class="hb-toast">`
- **Optional DOM**: Close button.
- **Required Attributes**: `role="status"` or `role="alert"`.
- **State Owner**: Consumer/Adapter lifecycle manager.
- **Focus Owner**: N/A (Does not steal focus).
- **ARIA Contract**: `role="status"`/`"alert"`.
- **ID/Reference Contract**: N/A.
- **Adapter Responsibility**: Rendering, timing out, removing from DOM.
- **Consumer Responsibility**: Triggering toasts.
- **Keyboard Contract**: N/A.

## 19. Navigation Menu
- **Purpose**: Primary site destinations.
- **Required DOM**: `<nav class="hb-navigation">`, `<ul class="hb-navigation__list">`, `<li class="hb-navigation__item">`, `<a class="hb-navigation__link">`
- **Optional DOM**: Popover submenus.
- **Required Attributes**: `aria-current="page"` on current link.
- **State Owner**: Consumer (via `aria-current="page"`).
- **Focus Owner**: Links.
- **ARIA Contract**: `aria-current="page"`.
- **ID/Reference Contract**: N/A.
- **Adapter Responsibility**: Orchestrating Popover for submenus if applicable.
- **Consumer Responsibility**: Routing.
- **Keyboard Contract**: NATIVE `Tab` progression.

## 20. Carousel
- **Purpose**: Sequential content presentation.
- **Required DOM**: `<div class="hb-carousel">`, `<div class="hb-carousel__track">`, `<div class="hb-carousel__slide">`
- **Optional DOM**: Indicators, Controls.
- **Required Attributes**: None (CSS Scroll Snap handles layout natively).
- **State Owner**: Native scroll position.
- **Focus Owner**: Interactive elements inside slides.
- **ARIA Contract**: `aria-current="true"` on active indicator.
- **ID/Reference Contract**: N/A.
- **Adapter Responsibility**: Syncing scroll position to indicators, click-to-scroll.
- **Consumer Responsibility**: Content.
- **Keyboard Contract**: NATIVE scroll/arrow keys when track is focused.

## 21. Cross-Component Rules
- Do not duplicate ARIA semantics.
- Do not use global state classes (e.g. `.is-active`).
- Respect native browser element capabilities before writing adapter logic.

## 22. Adapter Boundary
- Adapters orchestrate focus, coordinate manual positioning, handle complex keyboard navigation, and manage ARIA synchronization. They reside entirely outside the core CSS library.

## 23. Consumer Boundary
- Consumers are responsible for fetching data, maintaining application state (e.g. knowing which page is `aria-current="page"`), and handling routing/actions.

## 24. Accessibility Rules
- The UI Ecosystem explicitly rejects excessive or redundant ARIA attributes. ARIA is strictly applied only where semantic HTML is insufficient or custom interaction patterns (like roving tabindex or `aria-activedescendant`) require explicit accessibility tree overrides.
