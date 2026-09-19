# Responsive Philosophy

Phase 08.1 defines the overarching responsive philosophy for the HEBRING framework. The responsive system is an architectural concern layered intentionally over the existing cascade, maintaining predictability and simplicity.

## Mobile-First Approach

HEBRING strictly adheres to a **mobile-first** responsive philosophy:
- Default styles represent the baseline experience and must work natively without requiring breakpoints.
- Responsive enhancement is applied sequentially upward for larger viewports.

## Breakpoint Philosophy

- **Breakpoints are architectural, not design tokens**: Breakpoints define viewport threshold behavior, not literal visual values. Therefore, they are not treated strictly as design tokens.
- **Small and understandable API**: The number of breakpoints must remain deliberately minimal. HEBRING avoids breakpoint explosion.
- *Note: Exact breakpoint values and names are NOT defined in this phase. They will be evaluated in subsequent implementation phases.*

## Responsive Mechanism

- **Native CSS `@media`**: Native CSS media queries are the primary responsive mechanism. No custom-media abstraction or JavaScript viewport detection exists within the CSS core.
- **Container Queries**: `@container` rules and container queries are acknowledged as a powerful future capability but are **not** implemented in this phase.

## Cascade Interaction

Responsive behavior **does not** create a new cascade layer. The existing cascade architecture remains the authoritative order:
`reset → base → layout → components → utilities`

Responsive rules modify behavior from *within* their appropriate existing domain.

## Responsive Utility Philosophy

- Responsive utilities are only introduced for highly meaningful utility categories where shifting layouts is genuinely useful.
- **No automatic generation**: HEBRING explicitly rejects automatically generating a responsive variant for every single existing utility class (e.g., no `hb-md-p-4` or `hb-lg-hidden` unless deliberately designed).
- Responsive utilities belong strictly to the `utilities` layer.

## Layout Interaction

Existing Layout primitives (e.g., `hb-stack`, `hb-cluster`, `hb-container`) remain strictly semantic.
- **No Breakpoint Aliases**: HEBRING does not create breakpoint-specific layout components (e.g., no `hb-stack-md`).
- Responsive behavior must not inadvertently turn the Layout domain into a second utility system.

## Component Interaction

- Components do not automatically receive responsive variants (e.g., no `hb-button--mobile`).
- Responsive behavior is only integrated into a component's API when a real semantic requirement demands it.

## Application CSS Principle

When HEBRING does not provide an appropriate responsive API for a specific feature, **application CSS remains completely valid and encouraged**.

```css
/* Example of valid application-level responsive CSS */
@media (min-width: 1024px) {
  .dashboard-sidebar {
    display: block;
  }
}
```

This is not a failure of the framework. HEBRING aims to provide useful responsive primitives without forcing every single responsive requirement into framework classes.

## Accessibility Considerations

Responsive behavior must preserve accessibility:
- **Display properties**: Be mindful that `display: none` removes content entirely from the accessibility tree. Hiding content responsively must be done deliberately.
- **Interaction patterns**: Responsive behavior must not inadvertently create inaccessible interaction flows.
- **No JavaScript requirement**: Viewport detection must rely entirely on native CSS, ensuring it works universally without a JS dependency.

## Explicit Non-Goals (Phase 08.1)

This philosophy explicitly dictates that the following are **NOT** goals for the current architecture:
- Defining actual breakpoint tokens (`--hb-breakpoint-*`).
- Implementing responsive utility classes.
- Adding `@media` or `@container` rules to the framework source.
- Altering existing components, layouts, or utilities to support responsive APIs prematurely.
