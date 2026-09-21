# HEBRING Core Accessibility & Interaction Foundations

## 1. Accessibility Philosophy
HEBRING treats accessibility as a foundational requirement, not an afterthought. The core philosophy is to provide an accessible baseline by default. Components and layouts must be accessible by design and rely on pure CSS and native HTML where possible, ensuring that developers build inclusive interfaces without manual intervention for basic interactions.

## 2. Semantic HTML
HEBRING Core relies strictly on native HTML semantics to provide structural meaning and default interactive behavior. Native elements (`<button>`, `<a>`, `<input>`, `<nav>`) must be used for their intended purposes rather than recreating native behaviors on generic `<div>` or `<span>` elements using CSS and JavaScript.

## 3. Focus Management
Consistent and highly visible focus management is critical for keyboard navigation.
- **focus-visible**: Components must use `:focus-visible` (not just `:focus`) to provide focus rings only when navigating via keyboard, preventing intrusive styling during mouse interactions.
- **Outline preservation**: Browsers' native `outline` behavior should not be removed (`outline: none` or `outline: transparent`) unless an explicitly defined and highly visible accessible replacement (such as a `box-shadow` focus ring) is provided.
- **Focus styling**: Focus indicators must use the dedicated `--hb-color-focus` token to ensure contrast and consistency across the framework.

## 4. Keyboard Interaction
Core Components must respect native keyboard accessibility:
- **Tab navigation**: Interactive components must be reachable via the `Tab` key, leveraging native focusable HTML elements.
- **Enter / Space**: Activation of buttons, links, and form controls relies on standard browser behavior for Enter and Space keys.
- **Arrow keys / Escape**: Complex key handling belongs outside of HEBRING Core. JavaScript-driven keyboard navigation (e.g., arrowing through a custom select) is strictly deferred to the Ecosystem layer.

## 5. Interaction States
HEBRING defines the following standardized states for Core Components:
- **Native pseudo-classes**: `:hover`, `:focus-visible`, `:active`, `:disabled`, `:checked`. These must be styled for every interactive component.
- **CSS hooks for JavaScript**: `.is-loading`, `.is-invalid`, `.is-selected`, `.is-disabled` (when native `:disabled` cannot be used).
- Do not invent unnecessary, non-standard state classes.

## 6. Disabled vs Inert Behavior
Understanding the boundaries of disabled states:
- **disabled**: Use the native HTML `disabled` attribute for form controls and buttons. HEBRING styles the `:disabled` pseudo-class (reducing opacity, setting `cursor: not-allowed`).
- **aria-disabled**: Use `aria-disabled="true"` to indicate a disabled state on elements that do not support the native attribute (styled similarly to `:disabled`).
- **inert**: Use the HTML `inert` attribute to completely remove entire DOM subtrees from focus and screen readers. HEBRING does not replicate this with CSS/JS.
- **visually disabled**: Handled via `.is-disabled` when styling hooks are needed without altering native DOM behavior.

## 7. ARIA Boundary
HEBRING prefers semantic HTML. ARIA attributes (Accessible Rich Internet Applications) must only be used to bridge semantic gaps where native HTML falls short.
- ARIA attributes MUST NOT be used merely as CSS styling hooks. Use standard classes or native state selectors.
- Do not add ARIA roles to elements that already possess native semantics (e.g., `role="button"` on a `<button>`).

## 8. Reduced Motion
HEBRING respects user preferences for reduced motion globally.
- Interaction effects (hover transitions, focus rings) must evaluate the `@media (prefers-reduced-motion: reduce)` media query.
- When reduced motion is preferred, transitions and animations must instantly complete or be entirely disabled. HEBRING defines this via global token durations rather than a heavy animation framework.

## 9. Color and Contrast
Semantic states (success, warning, danger) and UI indicators (links, active states) must not rely solely on color to convey information.
- Provide additional visual indicators (e.g., underlines for links, distinct borders, or icons for alerts).
- Utilize the existing token architecture (e.g., `--hb-color-on-primary`) to guarantee contrast ratios on surface backgrounds.

## 10. Forms Accessibility
Forms must provide clear context and feedback:
- **Labels**: Every input must have an explicitly associated `<label>`.
- **Inputs**: Must clearly indicate their boundaries.
- **Descriptions/Errors**: Helper text and error messages must be linked to inputs using `aria-describedby`.
- **Invalid states**: Inputs should visually indicate validation failures (e.g., red borders) using the `.is-invalid` class, supplementing the `aria-invalid="true"` attribute.

## 11. Screen Reader Considerations
Not all visual information is easily interpreted by assistive technologies.
- Visually hidden content meant strictly for screen readers should be handled by a dedicated visually-hidden pattern (or an `.hb-sr-only` utility if introduced).
- Do not use `display: none` or `visibility: hidden` to hide content visually if it still needs to be read by a screen reader.

## 12. Component Accessibility Contract
Every future HEBRING Core Component must explicitly document:
- The required semantic HTML element.
- How the accessible name is derived (e.g., text content or `aria-label`).
- Native keyboard behavior.
- Focus ring presentation.
- All supported states and how they degrade gracefully.
- Necessary ARIA requirements (if native elements are insufficient).
- Behavior under `prefers-reduced-motion`.

## 13. Interaction CSS Architecture
Interaction-related CSS (hover, focus, active states) belongs strictly within the existing cascade layers:
`@layer reset, base, layout, components, utilities;`
- Component states reside within `@layer components`.
- Focus normalization resides within `@layer reset` or `base`.
No new architectural layers will be introduced for interactions.

## 14. JavaScript Boundary
HEBRING Core CSS operates independently of JavaScript.
- HEBRING Core MUST NOT require JavaScript merely to achieve basic styling, layout, or state presentation.
- State classes like `.is-loading` are provided strictly as CSS hooks. Toggling them is the responsibility of the consumer or Ecosystem layer.
- Complex DOM state management (e.g., trapping focus in a modal) belongs exclusively to the Ecosystem layer.

## 15. Accessibility Testing Philosophy
Accessibility validation in HEBRING Core relies on:
- **Source-level validation**: Code review for semantic HTML and state management logic.
- **Semantic validation**: Linting and tests verifying that components don't enforce inaccessible patterns.
- **Keyboard-oriented validation**: Manual and test verification that `:focus-visible` exists on interactive selectors.
- **Automated checks**: Utilizing existing bash-based script tests to verify the existence of focus styles and state pseudo-classes. Browser automation is excluded from the CSS Core repository.

## 16. Documentation Requirements
Future components must include an explicit "Accessibility" section in their documentation (e.g., inside `docs/components.md`), detailing the terms defined in the Component Accessibility Contract.

## 17. Definition of Done
Phase 14 is complete when this accessibility and interaction foundation specification is written, validated against the existing HEBRING architecture, committed to the repository, and serves as the governing contract for all future Core Components.
