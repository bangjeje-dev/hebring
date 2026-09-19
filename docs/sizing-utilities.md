# Sizing Utilities

Phase 06.5 establishes the sizing utility API for HEBRING.

## Purpose

Sizing utilities provide useful, predictable width and height adjustments without attempting to become an exhaustive, arbitrary CSS sizing API.

## The API

All utilities map directly to basic sizing CSS properties and reside within `@layer utilities`.

### Width

- `.hb-w-auto` → `width: auto;`
- `.hb-w-full` → `width: 100%;`

### Height

- `.hb-h-auto` → `height: auto;`
- `.hb-h-full` → `height: 100%;`

## Exclusions

HEBRING intentionally limits its sizing utilities to this 4-class API. The following are explicitly excluded to prevent the framework from deteriorating into a utility-only mess:

- Numeric sizing utilities (e.g., `w-1`, `w-2`).
- Percentage and fraction matrices (e.g., `w-1/2`, `w-33`).
- Viewport sizing utilities (e.g., `w-screen`, `h-screen`).
- Min/max sizing utilities (`min-w-*`, `max-h-*`).
- Arbitrary sizing values (e.g., `w-[32px]`).
- Responsive variants (deferred to Phase 08).
- Component-specific sizing classes.

## Relationship to Layout Primitives

Sizing utilities are strictly orthogonal to layout primitives. While layout primitives like `hb-container` manage horizontal bounding and `hb-stack` manages vertical relationships, sizing utilities can be selectively applied to shape individual child elements explicitly.

## Composition Examples

```html
<!-- Filling the available width inside a container -->
<button class="hb-button hb-w-full">Submit</button>

<!-- Resetting sizing dynamically -->
<img src="..." class="hb-w-auto hb-h-auto" alt="...">
```

## Application CSS

Application-specific CSS remains valid and encouraged. If your application requires highly specific widths, max-widths, or viewport calculations, declaring those directly in your application CSS is preferred over abusing utility classes or forcing the framework to carry unused utilities.
