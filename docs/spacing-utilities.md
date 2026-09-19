# Spacing Utilities

Phase 06.3 establishes the canonical spacing utility API for HEBRING.

## Philosophy

Utilities in HEBRING are conveniences, not constraints. They are single-purpose, small, composable, framework-agnostic, and token-aware. Spacing utilities specifically provide granular overrides for margin, padding, and gap without requiring complex component abstractions.

## Implementation Details

All spacing values are derived directly from the primitive spacing tokens (`--hb-space-0` through `--hb-space-32`).

### Padding (`hb-p-*`)

- `hb-p-{value}`: `padding`
- `hb-px-{value}`: `padding-inline`
- `hb-py-{value}`: `padding-block`
- `hb-ps-{value}`: `padding-inline-start`
- `hb-pe-{value}`: `padding-inline-end`
- `hb-pt-{value}`: `padding-block-start`
- `hb-pb-{value}`: `padding-block-end`

### Margin (`hb-m-*`)

- `hb-m-{value}`: `margin`
- `hb-mx-{value}`: `margin-inline`
- `hb-my-{value}`: `margin-block`
- `hb-ms-{value}`: `margin-inline-start`
- `hb-me-{value}`: `margin-inline-end`
- `hb-mt-{value}`: `margin-block-start`
- `hb-mb-{value}`: `margin-block-end`

### Gap (`hb-gap-*`)

- `hb-gap-{value}`: `gap`
- `hb-gap-x-{value}`: `column-gap`
- `hb-gap-y-{value}`: `row-gap`

## Logical Properties

HEBRING strictly uses logical properties for directional spacing (`inline`, `block`, `start`, `end`). Physical directional classes (e.g., `ml`, `pr`) are excluded.

## Excluded APIs

- Negative margins
- Auto margins
- Arbitrary values
- Responsive spacing variants
- Component-specific spacing utilities
