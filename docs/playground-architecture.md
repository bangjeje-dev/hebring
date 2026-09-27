# Playground Architecture

## 1. Purpose
The HEBRING Playground (`examples/playground/index.html`) serves as the definitive reference implementation for the framework. It exists to validate the CSS architecture in a real browser environment, demonstrate correct semantic markup, and provide reference JavaScript adapters for complex interactive components. 

PLAYGROUND is reference infrastructure and NOT part of the HEBRING runtime package.

## 2. Reference Implementation Boundary
The Playground demonstrates how consumers should integrate HEBRING into their applications. It is deliberately constructed as a single static HTML file with vanilla JavaScript. It does not use a build system, framework (React, Vue), or global state manager. This guarantees that HEBRING's functionality relies entirely on CSS and native browser capabilities, rather than a hidden runtime dependency.

## 3. File Inventory
- `examples/playground/index.html`: The single canonical reference application. It contains all HTML markup, isolated demo styles, and reference JavaScript adapters.

## 4. Core CSS Consumption
The Playground accurately consumes the core framework via direct `<link>` tags pointing to the development source (`../../src/index.css`). This simulates consumer usage while allowing for immediate visual regression testing during framework development.

## 5. Ecosystem UI Consumption
Ecosystem UI components are loaded individually via direct links (e.g., `../../ecosystem/ui/modal.css`). This mirrors the public package export model where Ecosystem CSS is explicitly requested by the consumer rather than bundled by default into the Core framework.

## 6. DOM Contract Alignment
The HTML markup in the Playground strictly adheres to the specifications defined in `docs/ecosystem-dom-contracts.md`. It correctly leverages native elements like `<dialog>`, `<details>`, and `popover` attributes, proving the validity of the CSS architecture against standard HTML.

## 7. Accessibility Alignment
The markup correctly implements ARIA roles (`role="menu"`, `role="tablist"`), semantic boundaries, and accessible names. Keyboard interactions (e.g., Arrow key navigation in tabs and comboboxes) are manually orchestrated by reference adapters in alignment with W3C APG guidelines and `docs/ecosystem-accessibility-audit.md`.

## 8. Reference Adapter Boundary
The embedded JavaScript acts purely as a set of Reference Adapters. Each adapter bridges the gap between native browser events and the semantic state expected by the CSS.
- **Allowed**: Managing focus, syncing `aria-expanded` based on popover toggle events, handling keyboard arrow navigation.
- **Prohibited**: Global data models, routing, complex state machines, or framework-like reactivity.

## 9. Global Event Listeners
Global event listeners (`document.addEventListener`) are strictly limited to necessary interactions, such as binding a global keyboard shortcut (e.g., `Cmd+K` for the Command Menu). The majority of listeners are correctly scoped to their specific component DOM nodes.

## 10. State Ownership
State is correctly mapped to authoritative HTML attributes.
- Open/close states rely on native `[open]` or `:popover-open` semantics.
- Selection states rely on `aria-selected="true"`.
- The Playground correctly avoids introducing custom architectural state classes (like `.is-active`).

## 11. Component Coverage
The Playground successfully demonstrates the majority of the Ecosystem UI components (Modal, Alert Dialog, Drawer, Popover, Menu, Dropdown Menu, Context Menu, Tabs, Accordion, Combobox, Command Menu, Navigation Menu, Carousel). The coverage provides a comprehensive proof of concept for the architecture.

## 12. Demo Isolation
Each interactive demo is functionally isolated. Reference adapters query DOM elements via specific IDs (e.g., `demo-cmd`, `demo-tabs`). State mutations in one adapter do not leak into or affect sibling components.

## 13. ID Management
IDs (`id="..."`) are used responsibly to establish ARIA relationships (`aria-controls`, `aria-labelledby`) and configure native browser features (`popovertarget`). They are unique within the document.

## 14. Script Architecture
JavaScript is intentionally inlined at the bottom of the HTML file. This architectural decision prevents the Playground's reference JS from being accidentally perceived as an external dependency or runtime library that consumers must install. It reinforces that HEBRING is CSS-only.

## 15. Native Platform Demonstrations
The Playground relies heavily on native platform capabilities:
- Native `<dialog>` for Modals, Alert Dialogs, and Command Menus.
- Native `popover` API for Popovers, Dropdowns, Context Menus, and Comboboxes.
- Native `<details>` for Accordions.
The CSS correctly styles these native elements without reinventing their core behaviors.

## 16. Composition Demonstrations
The Playground includes demonstrations of component composition (e.g., placing interactive elements within a Modal). These compositions validate the `@layer` specificity rules and ensure that isolated component CSS does not conflict when nested.

## 17. Responsive Demonstrations
Responsive behaviors are correctly delegated to CSS media queries and native fluid layouts. The JavaScript adapters do not perform manual viewport size calculations, preserving the CSS-first philosophy.

## 18. Motion / Reduced Motion
Transitions are handled via CSS. The JavaScript adapters do not enforce manual animation frames (except for scroll positioning in the Carousel), respecting global browser motion preferences.

## 19. Edge Case Demonstrations
The Playground includes essential edge case validations, such as handling disabled menu items, typeahead navigation in menus, and empty states in filtering components (Combobox, Command Menu).

## 20. Documentation Alignment
The examples presented in the Playground are the canonical source of truth and align perfectly with the theoretical architectures documented in the `docs/` folder.

## 21. Package Boundary
The `examples/` directory is properly excluded from the distributed npm package. It serves exclusively as a development and reference tool.

## 22. Performance / Complexity
The Playground is lightweight. The JavaScript adapters are procedural and highly specific, avoiding complex abstractions that would degrade performance or obscure the underlying DOM mechanics.

## 23. Testing
While the Playground itself is not subjected to automated browser tests (Playwright/Cypress), its static presence ensures that developers can manually verify visual regressions during architectural refactoring.

## 24. Findings
The Playground architecture successfully achieves its purpose. It acts as an accurate, isolated, and framework-neutral reference implementation that proves the HEBRING CSS architecture without accidentally introducing a JavaScript runtime library.

## 25. Remediation
NO SOURCE CHANGES REQUIRED.

## 26. Final Playground Assessment
The `examples/playground/` infrastructure is architecturally sound and fulfills its role as a pure reference implementation.
