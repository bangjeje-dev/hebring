# Responsive Utility Scope

Phase 08.3 defines the scope, syntax, and boundaries of the HEBRING responsive utility API. Responsive utilities are a deliberate, carefully curated subset of the utility API, not an automatic multiplier for every existing CSS class.

## Official Responsive Utility Syntax

The official syntax for responsive utilities is:
**`{utility}-{breakpoint}`**

The breakpoint suffix must be one of the officially supported viewports (`sm`, `md`, `lg`).

Examples:
- `hb-block-sm`
- `hb-none-md`
- `hb-w-full-lg`
- `hb-text-4xl-md`
- `hb-self-center-md`

The default (baseline) utility remains unchanged (`hb-block`, `hb-w-full`). Responsive utilities act as additive overrides.

Explicitly prohibited syntax patterns include: `hb-sm-block`, `hb-block@md`, `hb-block--md`, or component-specific responsive aliases.

## Mobile-First / Cumulative Model

HEBRING follows a strict **mobile-first** responsive model powered by `min-width` queries.

- **Default utility**: Applies at all viewport sizes unless overridden.
- **`sm`**: Applies at `min-width: 640px` and above.
- **`md`**: Applies at `min-width: 768px` and above.
- **`lg`**: Applies at `min-width: 1024px` and above.

Because the system is cumulative, a utility suffixed with `-md` will override the baseline and `-sm` variant from `768px` upwards.

**Example**: `class="hb-none hb-block-md"`
- Below 768px: The element is `display: none;`
- 768px and above: The element is `display: block;`

Max-width responsive APIs are not supported.

## Included Utility Categories

Responsive support is provided strictly for utility categories where shifting layouts across viewports is a common structural requirement.

1. **Display & Visibility (Full Support)**
   All flow control and visibility utilities are eligible for `sm`, `md`, and `lg`.
   - Examples: `hb-block-sm`, `hb-inline-md`, `hb-none-lg`, `hb-invisible-md`.

2. **Sizing (Full Support)**
   All width and height boundaries are eligible.
   - Examples: `hb-w-auto-sm`, `hb-w-full-lg`, `hb-h-full-md`.

3. **Typography (Partial Support)**
   Responsive support is limited to:
   - **Font-size**: `hb-text-base-sm`, `hb-text-xl-md`, `hb-text-4xl-lg`.
   - **Text alignment**: `hb-text-center-sm`, `hb-text-start-md`.
   - *(Note: Font-weight is explicitly excluded to avoid unnecessary API growth).*

4. **Alignment (Full Support)**
   Item-level logical alignments (`self` and `justify-self`) are eligible.
   - Examples: `hb-self-center-md`, `hb-justify-self-end-lg`.

## Excluded Utility Categories

HEBRING intentionally prevents responsive API explosion. The following categories **do not** receive responsive core APIs.

1. **Spacing**
   No responsive variants for padding, margin, or gap utilities (`hb-p-*`, `hb-m-*`, `hb-gap-*`). Adding breakpoints to the 238 spacing utilities would drastically expand the API footprint and encourage bloated HTML. Responsive spacing is best managed in application CSS or custom components.

2. **Deferred Utility Categories**
   Categories such as flexbox, grid, positioning, effects, and interaction are currently deferred. Their responsive scope will be evaluated when the categories themselves are built.

## Architectural Boundaries

### Cascade Boundary
Responsive utility rules remain inside the existing `@layer utilities;`. There is no `@layer responsive;`. The breakpoint simply dictates when the utility declaration becomes active. Responsive media queries will be ordered `sm` → `md` → `lg` to ensure deterministic mobile-first overrides.

### Layout and Component Boundaries
- **Layout primitives** remain purely semantic and structural. There are no breakpoint aliases (no `hb-stack-md` or `hb-grid-lg`).
- **Components** do not automatically receive responsive modifiers (no `hb-button-md`). Intrinsic component responsiveness belongs in the component's own CSS, while contextual responsiveness belongs in application CSS or layout utilities.

### Application CSS Escape Hatch
HEBRING provides useful responsive primitives, not a complete responsive styling language. If a responsive requirement falls outside the approved utility scope (e.g. responsive padding, font-weight changes), users are encouraged to use native `@media` queries in application CSS:

```css
@media (min-width: 768px) {
  .dashboard-card {
    padding: var(--hb-space-6);
  }
}
```

## Future Responsive Utility Additions

Any future addition to the responsive utility API requires:
1. A concrete, repeated real-world use case.
2. Evidence that the property is commonly responsive.
3. A clear utility-level semantic definition.
4. No excessive API expansion or duplication.
5. Compatibility with the mobile-first `min-width` behavior and the existing cascade architecture.
6. Documentation approval before implementation.

## Explicit Non-Goals (Phase 08.3)
- Adding `@media` rules to source CSS.
- Modifying existing utility CSS or components.
- Adding breakpoint custom properties.
- Introducing `xl` or `2xl` breakpoints.
- Creating an `@layer responsive`.
- Adding container queries or custom media syntax.
