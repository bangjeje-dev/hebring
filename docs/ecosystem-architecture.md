# HEBRING Ecosystem Architecture

## 1. Ecosystem Purpose
The HEBRING Ecosystem is the architectural layer built ON TOP OF HEBRING Core. It provides advanced, domain-specific, or interactive capabilities (e.g., interactive UI components, alternative themes, icons, templates, and tooling) that cannot be implemented cleanly with pure CSS within the strict framework-neutral constraints of Core.

## 2. Dependency Direction
The strict dependency hierarchy is:
`Core CSS` → `HEBRING Core` → `HEBRING Ecosystem`

- Ecosystem modules (UI, Themes, Icons, Templates, Tooling) may consume Core.
- Core MUST NEVER depend on Ecosystem.
- Core source code (`src/`) must not import anything from the `ecosystem/` directory.

## 3. Physical Directory Structure
To enforce isolation without breaking the existing package, the ecosystem lives in a top-level directory separate from `src/`:
```text
HEBRING/
├── src/           # (Core)
└── ecosystem/     # (Ecosystem)
    ├── icons/
    ├── templates/
    ├── themes/
    ├── tooling/
    └── ui/
```

## 4. Current Empty Boundaries
As of Phase 30, the `ecosystem/` directories act purely as architectural boundaries and contain no implementation. They are tracked via `.gitkeep` files. They await future phases for actual implementations.

## 5. Existing Icon Location
The icons are distributed in `ecosystem/icons/`. They are architecturally treated as an ecosystem artifact because they do not compile into the main `dist/hebring.css` bundle.

## 6. Existing Playground Location
The existing Playground application remains at `examples/playground/`. It is a separate consumer application that exists outside the HEBRING Core dependencies.

## 7. Core Build Isolation
The HEBRING Core build compiles exclusively from `src/index.css`. This entry point explicitly imports only files within the `src/` directory. This guarantees that no Ecosystem code can accidentally leak into the Core CSS bundle (`dist/hebring.css`).

## 8. Current Package Export Policy
The HEBRING npm package remains a single distribution. It exposes Core entry points as well as Ecosystem distribution boundaries:
- `./css`
- `./min`
- `./icons/*`
- `./themes/*`
- `./ui/*`

## 9. Future Expansion Rules
- Any new component requiring JavaScript must be implemented in `ecosystem/ui/`.
- New alternative themes must be implemented in `ecosystem/themes/`.
- No ecosystem additions can modify `src/`.
- Ecosystem testing should validate consumption of `dist/hebring.css` acting as an external consumer.
