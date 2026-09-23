# HEBRING Playground Architecture

## 1. Purpose
The HEBRING Playground is a dedicated development and demonstration tool designed to make the framework effortlessly discoverable and learnable. It allows developers to interactively write HTML, apply HEBRING classes, and immediately visualize the CSS rendering without requiring a local project setup or build step.

## 2. Developer Experience Goals
The target developer flow is: **Discover → Experiment → Understand → Copy → Install → Build**.
To achieve this, the Playground must minimize friction. It should load instantly, provide immediate visual feedback, and ensure that the code written in the Playground is exactly the code needed in a production environment.

## 3. Architecture
The Playground acts as an independent consumer application. It sits completely outside the HEBRING Core architecture.
It functions as a static or lightweight client-side application that imports the compiled `hebring.css` distribution file and renders user-provided markup.

## 4. Dependency Direction
The strict architectural dependency flow is:
`Playground` → `Ecosystem (Themes/Icons)` → `Core` → `Native CSS`

**CRITICAL INVARIANT:** HEBRING Core, UI Components, Icons, and Themes must NEVER depend on the Playground. The Playground is purely a consumer.

## 5. Technology Boundary
The Playground is permitted to use JavaScript (unlike Core), as it is a web-based developer tool requiring state management (e.g., syncing an editor with a preview pane). However:
- Playground JavaScript must remain isolated and never leak into the HEBRING Core bundle.
- The Playground should prefer simple, vanilla web standards or minimal, buildless tools (e.g., standard Web Components or lightweight DOM manipulation) to avoid introducing massive framework dependencies (React/Vue/Svelte) into the repository.
- A static bundler (like Vite) may eventually be used for the Playground itself, provided its configuration remains strictly separated from the Core library build process.

## 6. Editor Model
The Playground requires a minimal HTML text editor. It should ideally support basic syntax highlighting and indentation. The editor captures raw HTML strings which are then passed to the preview model.

## 7. Preview Model
The Preview model takes the raw HTML from the Editor and injects it into a rendering context. This context must be accurately styled by the exact `dist/hebring.css` artifact that a user would download from npm.

## 8. CSS Loading
The Playground must load the exact distribution artifacts (`dist/hebring.css`). It should not attempt to hot-reload or dynamically compile the raw `src/` CSS files on the client. It acts exactly like a consumer application referencing the built stylesheet.

## 9. Theme Handling
Themes are natively driven by CSS custom properties bound to data attributes. The Playground will implement a UI toggle (e.g., a "Light / Dark" button) that simply toggles `data-theme="dark"` on the preview container or iframe. No JavaScript-based CSS styling engines are permitted.

## 10. Icon Handling
The Playground will demonstrate icons by providing raw SVG snippets (referencing `src/icons`) that developers can paste into the editor. The icons will correctly inherit `currentColor` from the surrounding HEBRING utility or component classes. The Playground will not force icons to be a Core dependency.

## 11. Responsive Preview
To validate HEBRING's fluid and responsive design, the Playground will offer a responsive preview mechanism. The preferred approach is providing predefined viewport size toggles (Mobile, Tablet, Desktop) that resize the preview container/iframe using CSS width transitions, avoiding the need for a complex JavaScript browser emulator.

## 12. Copy Experience
Developers must be able to copy the exact HTML from the Playground editor and paste it directly into their own projects. The Playground must not introduce proprietary template syntax, pseudo-markup, or Playground-specific wrapper classes that would break when copied to a standard HTML environment.

## 13. Documentation Integration
Future documentation pages will link directly to Playground states (e.g., via URL parameters containing base64 encoded HTML) or embed minimal instances of the Playground to provide interactive examples of components and utilities directly within the reading experience.

## 14. Security Considerations
Because the Playground renders arbitrary user-provided HTML, security boundaries are paramount:
- **Isolation**: The preview should ideally be rendered inside a sandboxed `<iframe>` to prevent CSS bleed and script execution from affecting the parent Playground application.
- **Sanitization**: If rendering directly in the DOM, strict HTML sanitization (e.g., DOMPurify) must strip `<script>` tags, `onload` attributes, and other XSS vectors before injection.

## 15. Performance Considerations
The Playground must remain lightweight. By relying on the pre-compiled `dist/hebring.css` and minimal vanilla JavaScript for syncing the editor and preview, the Playground ensures fast initialization and seamless typing responsiveness.

## 16. Testing
Playground testing will validate:
- The Playground successfully loads the latest `dist/hebring.css`.
- Core CSS builds do not accidentally include Playground JavaScript or CSS.
- The `<iframe>` or preview container accurately reflects DOM updates.
- Security constraints (e.g., `<script>` execution blocked) are upheld.

## 17. Future Expansion
Once the minimal prototype is proven, the Playground may expand to include a utility class auto-completer, interactive token explorers, and deeper integration with alternative ecosystem themes, provided all expansion adheres to the dependency invariants.
