# HEBRING Icon System Architecture

## 1. Icon Philosophy
HEBRING Icons form an original, SVG-first ecosystem asset library designed specifically for modern web interfaces. They embody the HEBRING principles: minimal, clean, accessible, framework-agnostic, and predictable. They prioritize legibility and visual consistency over decorative complexity.

## 2. Visual Language
The icon family uses a rigorous outline-based geometry.
- **Stroke Width**: 2px
- **Linecap**: Round (approachable, smooth endpoints)
- **Linejoin**: Round (smooth intersections)
- **Scale**: Designed to align with the visual weight of HEBRING base typography.

## 3. SVG Contract
All HEBRING icons must conform to a strict SVG structural contract:
- Coordinate space: `viewBox="0 0 24 24"`
- Default dimensions are intentionally omitted from the `<svg>` tag; sizing is controlled by CSS.
- Raster graphics (`<image>`) and embedded fonts (`<text>`) are strictly forbidden.

## 4. Naming
Icons follow a clear, semantic naming convention (kebab-case).
- Names reflect the visual form or universal intent: `arrow-left`, `search`, `chevron-down`.
- CSS classes follow the HEBRING component standard: `.hb-icon`, `.hb-icon--sm`.

## 5. Sizing
Icons expose a minimalistic sizing API via CSS custom properties.
Instead of baking fixed pixel sizes, icons adapt contextually.
- `width` and `height` are bound to `var(--hb-icon-size)`.
- Default `--hb-icon-size` is `1.5em` (scaling relative to surrounding text).
- Modifiers like `.hb-icon--sm` or `.hb-icon--lg` adjust the base custom property, completely avoiding a bloated list of predefined sizes.

## 6. Stroke & Fill
HEBRING Icons are exclusively outline-based.
- `fill="none"`
- `stroke="currentColor"`

## 7. Color
Icons must intrinsically inherit color from their context.
No icon SVG file will ever contain hardcoded colors (`#FF0000`, `blue`). By strictly relying on `currentColor`, icons seamlessly support the semantic theme system (Light/Dark mode) and specific UI contexts (e.g., inside an `.hb-alert--danger`) automatically.

## 8. Accessibility
The HEBRING icon system defines two distinct roles:
1. **Decorative**: Icons that add visual flair but convey no unique information. These MUST be hidden from screen readers by adding `aria-hidden="true"` on the parent SVG or wrapper.
2. **Semantic**: Icons that convey meaning (e.g., a standalone search button without text). These MUST possess an accessible name, typically provided by an `aria-label` on the parent interactive element (`<button aria-label="Search">`).
*Note: HEBRING raw SVGs do not hardcode `aria-hidden` or `<title>` tags to allow the consumer maximum semantic flexibility.*

## 9. CSS Integration
The ecosystem provides an optional foundational CSS wrapper in `icon.css`.
Applying `.hb-icon` to an `<svg>` normalizes alignment with text and establishes the contextual sizing root.

## 10. Usage Examples
**Raw SVG (Semantic):**
```html
<button class="hb-button hb-button--sm" aria-label="Close modal">
  <svg class="hb-icon" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
    <path d="M18 6L6 18M6 6l12 12" />
  </svg>
</button>
```

**Raw SVG (Decorative):**
```html
<a href="#" class="hb-button">
  <svg class="hb-icon" aria-hidden="true" ...>...</svg>
  Continue
</a>
```

## 11. UI Integration
HEBRING Icons remain entirely optional.
HEBRING Core and UI components (Cards, Badges, Alerts) NEVER import, bundle, or require icons internally. If a consumer wishes to place an icon inside an Alert, they compose the SVG inside the Alert markup themselves.

## 12. Package Boundary
Icons are an Ecosystem capability. They are distributed in the `ecosystem/icons` directory, completely decoupled from the HEBRING Core source (`src/`). They represent the Ecosystem layer and will never become a structural dependency of Core.

## 13. Contribution Rules
New icons must be authored originally. Copying path data or source code from Lucide, Heroicons, or Material Icons is strictly prohibited to maintain the original HEBRING identity and avoid licensing conflicts.

## 14. Testing Requirements
Automated tests verify that no hardcoded colors exist, correct `viewBox` is preserved, raster imagery is absent, and the CSS contract (`.hb-icon`) is preserved without leaking into Core.
