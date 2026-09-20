# Testing Philosophy

HEBRING testing exists to verify that the framework remains predictable, correct, framework-agnostic, CSS-first, accessible by design, composable, stable across changes, and distributable as a real npm package. 

Testing should verify behavior and architectural contracts, not merely increase test count.

---

## Testing Mental Model

> **HEBRING tests the contracts developers rely on, not every implementation detail.**

A failed test should indicate a meaningful contract violation. Tests should avoid brittle snapshots, tying failures to irrelevant implementation formatting, or excessive exact string matching when behavior can be tested more robustly. We do not test every CSS declaration merely because it exists.

## Test the Public Contract

Tests should prioritize the things that developers depend on:
- Public CSS classes
- Public custom properties/tokens
- Documented APIs
- Responsive behavior
- Theme behavior
- Component states
- Package exports
- Generated distribution artifacts

Internal implementation details should only be tested when they represent an architectural contract.

## Test Architecture, Not Just Syntax

HEBRING tests should validate architectural boundaries:
- Cascade layer structure (`@layer reset, base, layout, components, utilities;`)
- Token dependency direction (Primitive → Semantic → Components)
- Responsive rules staying inside existing layers
- Themes remaining independent from components
- No JavaScript runtime dependency in the CSS core
- No accidental dependency on undocumented APIs

## Distinguishing Testing Boundaries

It is vital to distinguish between:
- **Source correctness**: Validating source files, conventions, architecture boundaries, and forbidden patterns.
- **CSS structure correctness**: Validating cascade layers, generated CSS output, media queries, and artifact integrity.
- **Browser behavior correctness**: Validating visual rendering, layout behavior, and interactive states in a browser environment.
- **Distribution correctness**: Validating the npm package, exports, and external consumption.

Static text matching does not prove visual or browser behavior. 

## The Testing Pyramid

HEBRING defines a practical testing model in four layers:

1. **Layer 1 — Static / Source Tests**: Verify files, selectors, tokens, naming, architecture, and forbidden patterns.
2. **Layer 2 — CSS Structure Tests**: Verify cascade layers, generated CSS structure, media queries, theme selectors, and artifact integrity.
3. **Layer 3 — Behavioral / Browser Tests**: Where practical, verify actual browser behavior rather than relying only on source inspection.
4. **Layer 4 — Build / Distribution Tests**: Verify production builds, npm package contents, exports, and external consumption.

## Accessibility

Accessibility is a framework quality requirement. Tests may validate:
- Focus-visible rules
- Native semantic behavior where applicable
- Disabled states
- Color contrast where measurable
- Preservation of browser accessibility affordances
- Absence of destructive resets

Passing automated tests does not guarantee complete WCAG compliance, but it prevents fundamental accessibility regressions.

## Regression Safety

Every completed subsystem should have regression coverage where practical. A change to tokens, foundation, layout, utilities, components, responsive behavior, themes, or the build system must not silently break previously validated public behavior.

## Test Independence

Tests should:
- Be deterministic
- Avoid network dependency
- Avoid external services
- Run locally
- Be reproducible
- Have clear failure messages
- Avoid depending on machine-specific absolute paths where possible

## CSS-First Constraint

The core framework must remain free from JavaScript runtime requirements. While testing infrastructure may use scripts and tools:
- HEBRING CSS itself must not require JavaScript
- Tests must not introduce runtime JavaScript requirements into the distributed framework
- Test tooling is not part of the framework runtime

## Build and Distribution

Testing must eventually cover the full path:  
`source → build → dist → npm package → external consumer`

The final package that users consume must be tested, not just the local source tree.

## Test Naming

Test names should clearly communicate:
- What contract is being tested
- What behavior is expected
- Why failure matters

Prefer descriptive and meaningful names over generic names (e.g., avoid `test1`, `basic-test`, `css-test`).

## Relationship to Existing Tests

HEBRING already has targeted validation scripts from previous phases, including responsive, theme, build, and package validation (e.g., `test_themes.sh` and `test_responsive_utilities.sh`). The testing system will consolidate and mature testing rather than blindly replacing existing validation.

## No Premature Complexity

HEBRING avoids adding large testing frameworks, browser automation, visual regression systems, CI services, or unnecessary dependencies unless a later testing sub-phase explicitly decides they are needed.

## Scope Boundary

This document defines testing principles and boundaries only. It does **NOT**:
- Implement the complete testing architecture
- Add new test suites for every subsystem
- Introduce browser automation
- Define CI
- Define coverage thresholds
- Modify public APIs

Those tasks belong to later sub-phases.
