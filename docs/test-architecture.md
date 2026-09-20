# Test Architecture

HEBRING testing follows a structured architecture designed to validate the public developer contract predictably and reliably. This document outlines how tests are organized, named, and executed.

---

## 1. Test Directory Structure

The conceptual test architecture for HEBRING organizes tests by the type of contract they validate. The target structure under `tests/` is:

- **`source/`**: Validates source-level contracts. Includes tests for selectors, naming conventions, token usage, forbidden patterns, and architecture boundaries (e.g., ensuring no cascade layer violations in source).
- **`css/`**: Validates generated CSS structure. Verifies cascade layers in the final output, media query structure, correct selector rendering, and overall artifact integrity.
- **`browser/`**: (Deferred) Will validate actual browser behavior, including computed styles, visual layout rendering, and accessibility affordances. Currently reserved for future implementation.
- **`build/`**: Validates the production build. Ensures reproducibility, correct minification, and proper dist artifact generation.
- **`package/`**: Validates the npm package structure, `package.json` exports, and external consumer paths.
- **`fixtures/`**: Contains minimal, stable test inputs (HTML/CSS fixtures) needed by other tests. Fixtures avoid unnecessary duplication and never disguise production code.

*Note: Empty directories are not created prematurely. Directories are added only when test phases require them.*

## 2. Existing Test Scripts

Before implementing the full directory architecture, HEBRING already contains targeted validation scripts located in the root `tests/` directory:

- `test_themes.sh`: A mixed validation script verifying source CSS variables, theme selector boundaries (`:root`, `[data-theme="dark"]`), and generated CSS integrity.
- `test_responsive_utilities.sh`: Validates CSS structure for responsive utilities, checking media query logic and breakpoint consistency.
- `test_button.sh`: Validates component source architecture and output structure for the core button component.

These scripts currently serve as vital regression checks and will remain in place until the test architecture implementation phase naturally absorbs them.

## 3. Test Naming

HEBRING uses a predictable naming convention that communicates exactly what contract is being tested.

**Convention**: `test_<subject>.sh` (or appropriate extension)

- **Good**: `test_themes.sh`, `test_responsive_utilities.sh`, `test_cascade_layers.sh`
- **Avoid**: `test1.sh`, `basic.sh`, `temp.sh`, `debug.sh`

## 4. Test Execution Model

HEBRING avoids premature complexity and does not currently utilize a sophisticated test runner. Tests are executed via simple, targeted shell scripts. 

The conceptual execution path supports scaling from single tests to full suites:
`single test` → `category tests` → `full test suite`

## 5. Exit Codes

Shell-based tests adhere to standard POSIX exit codes:
- **`0`**: Success (Contract verified).
- **Non-zero**: Failure (Contract violated). Failures must output clear diagnostics identifying the violated contract.

## 6. Determinism & Isolation

To guarantee reliability, tests must be deterministic.
- Tests must run locally and reproducibly.
- Tests must avoid network dependencies, external APIs, and random behavior.
- Tests must not rely on machine-specific absolute filesystem paths.
- Tests must run in isolation, avoiding unintended mutations to source files, the production `dist/` directory, user configuration, or global system state. Temporary artifacts must use controlled temporary locations and be cleaned up.

## 7. Source vs. Artifact Testing

Testing differentiates strictly between source validation and artifact validation:

- **Source Tests**: Answer *"Is the source architecture and API correct?"*
- **Artifact Tests**: Answer *"Did the build produce the correct distributable CSS?"*

Both are required. A passing source test does not guarantee that the built CSS package functions correctly.

## 8. Build / Package Testing

Build and package tests validate the real-world consumer path:
`src/` → `build` → `dist/` → `npm pack` → `external consumer`

Testing the distributed package ensures the user receives a working product, maintaining the precedent set in early distribution validation.

## 9. Browser Tests (Deferred)

Browser behavior validation is an architectural category but is explicitly deferred. HEBRING does not currently implement Playwright, Puppeteer, Cypress, or Selenium. Fake browser tests must not be introduced to simulate coverage.

## 10. Fixtures

Fixtures must be minimal, intentional, reusable, human-readable, and version-controlled. They must not lead to fixture explosion or contain production code.

## 11. Relationship With Documentation

The relationship between documentation, testing, and implementation is strictly defined:

```text
Documentation  (Defines the Public Contract)
      ↓
Tests          (Verifies the Public Contract)
      ↓
Implementation (Satisfies the Public Contract)
```

Tests verify the contract; they do not replace documentation as the definition of the API.

## 12. Anti-Patterns

HEBRING explicitly avoids the following testing anti-patterns:
- Mechanical testing of every CSS declaration.
- Brittle snapshot tests tied to internal formatting.
- Duplicate tests validating the same contract.
- Fake browser tests simulating runtime validation.
- Network-dependent testing.
- Tests that unexpectedly mutate source code.
- Tests relying on undocumented classes.
- Tests that introduce runtime JavaScript dependencies into HEBRING CSS.
- Excessive or unnecessary testing infrastructure.
- Tests that report false positives while the distributed package is broken.

## 13. Future Test Categories

The architecture prepares for the sequential implementation of full regression coverage in subsequent Phase 12 sub-phases:

- 12.3 Foundation Tests
- 12.4 Token Tests
- 12.5 Layout Tests
- 12.6 Utility Tests
- 12.7 Component Tests
- 12.8 Responsive Tests
- 12.9 Theme Tests
- 12.10 Build & Distribution Tests
- 12.11 Package Consumer Tests
- 12.12 Full Regression Validation

*These categories outline the future roadmap and are not yet implemented.*
