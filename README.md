# HEBRING

A modern, lightweight, and understandable CSS framework for building web interfaces.

## Project Status

**Early Development — Phase 01: Project Foundation**

HEBRING is currently in its initial setup phase. The project foundation is established, and architecture design for core CSS layers is underway. It is not yet ready for production use.

## Core Philosophy

HEBRING is built around eight foundational principles:

1. **Simple**: The framework should be easy to understand and learn.
2. **Predictable**: Class names, architecture, and behavior follow consistent, transparent rules.
3. **Composable**: Developers can combine framework primitives naturally without friction.
4. **Lightweight**: Avoid unnecessary dependencies, excessive generated code, runtime JavaScript, superfluous animations, and heavy abstractions.
5. **Accessible**: Semantic structure and accessibility considerations are baked in from the ground up.
6. **Framework-Agnostic**: The core CSS works completely independently of any JavaScript framework (React, Vue, Svelte, Angular, vanilla HTML, etc.).
7. **Modern**: Employs contemporary CSS features and standards where appropriate without sacrificing maintainability.
8. **Human-Readable**: Developers can inspect the source code and immediately understand how HEBRING works.

## Project Structure

```
hebring/
├── src/          # Framework source files
├── docs/         # Documentation and architectural guides
├── examples/     # Reference implementations and examples
├── tests/        # Test suites and regression fixtures
├── package.json  # Project manifest
├── README.md     # Project overview and documentation
├── LICENSE       # MIT License
├── .gitignore    # Version control exclusions
├── .editorconfig # Consistent formatting rules across editors
└── .npmrc        # Package manager configuration
```

## Development

### Prerequisites

- [Node.js](https://nodejs.org/) (v18 or newer recommended)
- [pnpm](https://pnpm.io/) (v9 or newer recommended)

### Getting Started

Clone the repository and install dependencies:

```bash
git clone https://github.com/hebring/hebring.git
cd hebring
pnpm install
```

> **Note**: The core CSS will have no runtime JavaScript dependencies. Tooling and scripts in this repository are strictly for development, testing, and distribution workflows.

## License

This project is licensed under the [MIT License](LICENSE).
Copyright (c) 2026 HEBRING Contributors.
