# Breakpoint Architecture

Phase 08.2 establishes the official breakpoint vocabulary and architectural constraints for HEBRING.

## Official Breakpoint Vocabulary

HEBRING officially recognizes the following minimal breakpoint vocabulary:

- **`default`** (Base styles, no breakpoint required)
- **`sm`** → 640px
- **`md`** → 768px
- **`lg`** → 1024px

> **Note**: No `xl` or `2xl` breakpoints are defined initially. The breakpoint system must remain intentionally small, predictable, and understandable.

## Mobile-First Behavior

HEBRING uses a strict **mobile-first** responsive model powered by `min-width` media queries. 
- The **default** styles represent the smallest baseline and apply to all viewports universally.
- Breakpoints define where specific enhancements take effect as the viewport grows.
- Because `min-width` is cumulative, a 1200px viewport conceptually inherits rules from `default`, `sm`, `md`, and `lg`.

*Max-width APIs are explicitly rejected as the primary responsive system.*

## Breakpoint Naming Rationale

Breakpoint names (`sm`, `md`, `lg`) describe **viewport thresholds**, not specific physical device categories (e.g. tablet, phone, desktop). A 768px viewport (`md`) could represent a tablet in portrait mode or a small desktop window.

## Breakpoints vs. Design Tokens

Breakpoints are **responsive architecture**, not design tokens. 
Design tokens represent visual/design values (colors, spacing). Responsive breakpoints represent behavioral viewport thresholds.

Therefore, HEBRING explicitly prohibits exposing breakpoints as custom property tokens.
- **Do not** create `--hb-breakpoint-sm`.
- **Do not** place breakpoint values inside the `tokens/` domain (`primitives.css`, `semantic.css`, `themes.css`).

## Breakpoints vs. Responsive Utilities

The existence of the `sm`, `md`, and `lg` vocabulary **does not** automatically authorize the creation of a responsive variant for every utility (e.g. `hb-sm-p-4`, `hb-md-block`).

The responsive utility scope is an entirely separate concern and will be designed explicitly in subsequent phases.

## Layout Boundary

Layout primitives remain purely structural and semantic.
- **Do not** create breakpoint-specific modifiers for Layout components (e.g., no `hb-stack-sm`, `hb-grid-md`).
- Breakpoint vocabulary is an architectural capability, not an automatic modifier system.

## Component Boundary

Components do not automatically receive responsive modifiers.
- **Do not** create viewport-specific component variants (e.g., no `hb-button--mobile`, `hb-button--tablet`).

## Cascade Boundary

Responsive rules must remain inside their existing cascade domain (`reset`, `base`, `layout`, `components`, `utilities`).
- **Do not** create an `@layer responsive;`. 
- Responsive behavior does not introduce a new cascade layer.

## Future Breakpoint Addition Policy

Future additions to the breakpoint vocabulary (e.g. `xl`) are strictly prohibited without a documented use case and an explicit, approved architecture decision. 

## Implementation Abstraction Status

Phase 08.2 only establishes the official breakpoint vocabulary and threshold values. It **does not** finalize the implementation abstraction.

It remains intentionally deferred whether the final framework implementation will utilize:
- Repeated native `@media` queries
- Centralized generation
- Custom media (`@custom-media`)
- Another build-time abstraction

## Explicit Non-Goals (Phase 08.2)

- Defining custom properties (tokens) for breakpoints.
- Introducing `xl` or `2xl` breakpoints.
- Creating responsive utility classes.
- Adding `@media` rules to the framework source.
- Introducing `@container` or `@custom-media`.
- Modifying existing components, layouts, or utilities to support breakpoints.
