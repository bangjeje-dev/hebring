# HEBRING

A modern, lightweight, and understandable CSS framework for building web interfaces.

## Project Status

**Stable — Phase 11**

HEBRING is functionally complete with a stable foundational architecture. The framework's core CSS layers (reset, base, layout, components, utilities) are established.

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
- npm (v9 or newer recommended)

### Getting Started

Install HEBRING via npm:

```bash
npm install hebring
```

Import the compiled CSS artifact in your frontend project (e.g., Vite, Next.js, or plain HTML):

```javascript
import 'hebring';
// or explicitly import the minified version:
import 'hebring/min';
```

Alternatively, you can link the stylesheet directly in HTML if serving from a static location or CDN.

### Local Development

Clone the repository and install dependencies:

```bash
git clone https://github.com/hebring/hebring.git
cd hebring
npm install
```

> **Note**: The core CSS will have no runtime JavaScript dependencies. Tooling and scripts in this repository are strictly for development, testing, and distribution workflows.

## License

This project is licensed under the [MIT License](LICENSE).
Copyright (c) 2026 HEBRING Contributors.
