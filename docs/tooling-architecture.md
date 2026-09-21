# HEBRING Developer Tooling Architecture

## 1. Developer Tooling Philosophy
HEBRING Developer Tooling exists solely to automate repetitive, error-prone tasks related to consuming the framework and its ecosystem. Tooling must reduce friction without introducing magic. It serves developers by scaffolding, validating, and acquiring assets while ensuring the resulting codebase remains transparent, portable, and standard HTML/CSS.

## 2. Tooling Boundary
Tooling is an isolated Ecosystem layer. 
`Tooling` → `Ecosystem` → `Core` → `Native CSS`
HEBRING Core must remain completely independent of any tooling. Developers must always be able to install and use `@hebring/core` without requiring a CLI or build tool. Tooling exists to enhance the experience, not to act as a mandatory gateway.

## 3. Candidate Workflows
Useful workflows that benefit from automation include:
- Scaffolding a new project with HEBRING pre-configured.
- Adding specific UI components or templates into a project.
- Extracting specific SVGs from the icon library.
- Linting/validating HTML to ensure correct HEBRING class usage and accessibility contracts.
- Managing themes.

## 4. CLI Decision
A dedicated CLI (`@hebring/cli`) is conceptually justified for the ecosystem because copying raw SVG icons, configuring themes, and manually validating utility classes can become tedious at scale. However, the CLI must not be implemented until the UI, Icon, Theme, and Template ecosystems are mature enough to require orchestration.

## 5. Command Architecture
Future CLI commands must be:
- **Predictable**: using standard verb-noun syntax (e.g., `hebring add`).
- **Composable**: supporting standard input/output streams where applicable.
- **Transparent**: never hiding generated code in `.hebring` ghost folders; code is copied directly into the user's workspace.
- **Stateless**: requiring no complex background daemons.

## 6. Package Architecture
The conceptual boundary is `@hebring/cli`.
This package would be executed via `npx` (e.g., `npx @hebring/cli add card`) or installed globally/locally as a devDependency. It will never be bundled into `@hebring/core` or required at runtime.

## 7. Initialization
- **Candidate Command**: `hebring init`
- **Behavior**: Generates a basic configuration file (if required) and scaffolds a minimal `index.html` referencing `@hebring/core`.

## 8. Component Acquisition
- **Candidate Command**: `hebring add [component]`
- **Behavior**: Copies the structural HTML pattern of a UI component into the project or provides instructions. Because HEBRING is CSS-first, UI components don't require JavaScript runtime installation; they simply require the correct markup structure.

## 9. Icon Acquisition
- **Candidate Command**: `hebring add icon [name]`
- **Behavior**: Copies the raw SVG string of a requested icon directly into the developer's clipboard or specified output directory. This prevents forcing developers to install the entire `@hebring/icons` package if they only need three SVGs.

## 10. Theme Acquisition
- **Candidate Command**: `hebring add theme [name]`
- **Behavior**: Downloads or outputs the CSS variables for a specific ecosystem theme, saving it as a local `.css` file for the developer to include in their build.

## 11. Template Acquisition
- **Candidate Command**: `hebring create [template-name] [directory]`
- **Behavior**: Scaffolds a complete starting directory structure using a predefined template. It downloads the static HTML/CSS assets and initializes a standard project.

## 12. Validation Tooling
- **Candidate Command**: `hebring check`
- **Behavior**: Scans local HTML files to validate HEBRING usage. It would flag deprecated classes, alert on missing accessibility attributes (e.g., missing `aria-label` on semantic icons), and warn about incorrect modifier combinations. This is a high-value workflow.

## 13. Configuration
HEBRING tooling prefers **zero configuration**.
If absolutely necessary (e.g., to define a default icon output directory or custom prefix), configuration should exist in a standard format (e.g., `hebring.config.json` or `package.json` under `"hebring"`). Defaults must be sensible enough that the configuration file is strictly optional.

## 14. Versioning
The CLI must be version-aware but loosely coupled. It should interrogate the locally installed version of `@hebring/core` to ensure it generates components or validates classes that are compatible with the developer's current framework version.

## 15. Error Handling
CLI errors must be actionable and human-readable. If an icon doesn't exist, the CLI should suggest close matches. If a template fails to download, it should provide the manual download URL. Stack traces should be hidden by default unless a `--verbose` flag is passed.

## 16. Offline Behavior
The CLI should cache downloaded templates and themes in a local system directory (e.g., `~/.hebring`) to allow scaffolding and asset acquisition when disconnected from the network.

## 17. Security
The CLI must not execute remote, untrusted code. Template extraction and component additions must strictly copy standard text/HTML/CSS files. The CLI will never run arbitrary npm scripts as part of a `create` or `add` command unless explicitly and interactively confirmed by the user.

## 18. CI Usage
All commands must support a `--yes` or `--non-interactive` flag. The `hebring check` validation command is specifically intended to be run in CI pipelines to enforce framework correctness before merging pull requests.

## 19. Future Expansion
The architecture leaves room for integrating the CLI with the HEBRING Playground (e.g., `hebring preview`, which spins up a local instance of the Playground for the current project), provided it doesn't violate the dependency constraints.

## 20. Definition of Done
The Tooling Architecture is complete when all boundaries, workflows, and command philosophies are documented and committed without unnecessarily scaffolding an empty CLI package.
