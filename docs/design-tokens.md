# Design Tokens Architecture

This guide explains how HEBRING's design token architecture works, how tokens are categorized, and how application developers should consume them.

## 1. What Are Design Tokens?

Design tokens are named values used to keep visual decisions consistent. Rather than hardcoding hex codes (`#3b82f6`) or pixel values (`16px`) throughout your CSS, HEBRING separates raw values from their semantic meaning.

HEBRING splits tokens into three strict categories:
- **Primitive Tokens**: Raw design values.
- **Semantic Tokens**: Meaningful UI roles.
- **Themes**: Contextual mappings of semantic roles.

## 2. Primitive Tokens

Primitive tokens are foundational values. They represent reusable raw measurements and colors, detached from any specific UI meaning.

HEBRING provides the following primitive token groups:
- **Color Palettes**: White, black, neutral, blue, green, yellow, red (e.g., `--hb-color-blue-600`)
- **Spacing Scale**: A 4px base system (e.g., `--hb-space-4` for 16px)
- **Typography**: Font families, sizes, weights, line heights, and letter spacings (e.g., `--hb-font-size-md`)
- **Radius**: Border-radius definitions (e.g., `--hb-radius-md`)
- **Shadow**: Box-shadow elevations (e.g., `--hb-shadow-sm`)
- **Motion**: Durations and easings (e.g., `--hb-duration-fast`)

**Role**: Primitive tokens serve as the absolute source of truth. You should reference them when constructing higher-level semantic meaning, but generally avoid using them directly in UI components if a semantic alternative exists.

## 3. Semantic Tokens

Semantic tokens define **meaningful roles** rather than raw values. They communicate *why* a value is used, rather than *what* raw value it is.

HEBRING provides the following semantic categories:
- **Background Roles**: `--hb-color-background`
- **Surface Roles**: `--hb-color-surface`, `--hb-color-surface-muted`
- **Text Roles**: `--hb-color-text`, `--hb-color-text-muted`
- **Border Roles**: `--hb-color-border`
- **Primary Brand & Action Roles**: `--hb-color-primary`, `--hb-color-primary-hover`
- **Status Roles**: Success, Warning, Danger, Info (e.g., `--hb-color-danger`)
- **Focus Indicator**: `--hb-color-focus`
- **Semantic Typography**: `--hb-font-family-body`, `--hb-font-family-code`

**The Concept**: `--hb-color-blue-600` is a primitive token. `--hb-color-primary` is a semantic token. If you ever change your brand color from blue to purple, you update `--hb-color-primary`—not every instance of `blue-600`.

## 4. Primitive → Semantic Relationship

HEBRING architecture enforces a strict dependency direction:

```text
Primitive Tokens → Semantic Tokens
```

Semantic tokens always reference primitive tokens. Application and UI code should generally consume semantic roles when the intent is semantic. (However, structural spacing like `--hb-space-4` often remains primitive because its intent is inherently structural).

## 5. Themes and Tokens

Themes act as a contextual override layer for semantic tokens. 

```text
Primitive Tokens → Semantic Tokens → Theme overrides
```

**Architectural Rules:**
- Themes modify semantic mappings.
- Themes **do not** redefine primitive tokens (blue should always be blue, even in a dark theme).
- The Default (Light) theme works implicitly without requiring a `data-theme` attribute.
- The Dark theme is activated via the `[data-theme="dark"]` selector.

Because themes rely on CSS custom property inheritance, they can be applied globally to the `<html>` element, or scoped locally to specific sections of a page.

## 6. How Components Use Tokens

HEBRING components (like `.hb-button`) consume tokens semantically. 

For example, a button does not use `--hb-color-blue-600`. It uses `--hb-color-primary`. This guarantees that if a dark theme remaps `--hb-color-primary` to `--hb-color-blue-500`, the button updates automatically.

**Note**: HEBRING does *not* possess a component-specific global design token layer (e.g., there is no global `--hb-button-bg-color`). Component implementation tokens (if used internally) remain strictly local implementation details, not global APIs.

## 7. Using Tokens in Application CSS

When writing custom CSS for your application, consume HEBRING's variables to guarantee consistency and theme compatibility.

**Example (Semantic consumption for theme-safe UI):**
```css
.my-card {
  background-color: var(--hb-color-surface);
  color: var(--hb-color-text);
  border: 1px solid var(--hb-color-border);
  padding: var(--hb-space-4);
}
```

By using `--hb-color-surface`, your `.my-card` component will automatically adapt when `data-theme="dark"` is applied.

## 8. Customization

When customizing HEBRING for your application:
- **Override semantic tokens**: If you want a different primary color, redefine `--hb-color-primary` at the `:root` level.
- **Do not rewrite the primitive scale**: Do not change the hex value of `--hb-color-blue-600` to be green.
- **Create custom themes**: You can create arbitrary themes (e.g., `[data-theme="high-contrast"]`) simply by remapping semantic variables inside that selector.

## 9. Token Design Principles

HEBRING adheres to these established principles:
- **Primitive values are foundational.**
- **Semantic tokens express meaning.**
- **Themes remap semantic values.**
- **Primitive tokens remain stable across themes.**
- Avoid unnecessary token proliferation.
- Do not create component-specific global tokens prematurely.
- Prefer semantic roles when expressing UI meaning.
- Keep token names predictable.
- Keep the system understandable.

## 10. Token Group Reference

| Token Group | Purpose | Examples |
|-------------|---------|----------|
| **Color** | Absolute color palettes | `--hb-color-blue-600`, `--hb-color-neutral-900` |
| **Spacing** | 4px-based structural sizing | `--hb-space-4`, `--hb-space-8` |
| **Typography** | Font properties and scaling | `--hb-font-size-md`, `--hb-font-weight-bold` |
| **Radius** | Border radius geometry | `--hb-radius-md`, `--hb-radius-full` |
| **Shadow** | Box-shadow elevations | `--hb-shadow-sm`, `--hb-shadow-lg` |
| **Motion** | Transitions and easing | `--hb-duration-fast`, `--hb-ease-standard` |

## 11. What NOT to Do

- **Do not** create a new token when an existing semantic role already expresses the intent.
- **Do not** make themes by rewriting primitive tokens (e.g., making `--hb-color-white` black in a dark theme).
- **Do not** treat themes as cascade layers (`@layer themes`).
- **Do not** invent component-global tokens for every component property.
- **Do not** hardcode semantic colors (e.g., `#3b82f6`) when an existing semantic token (`--hb-color-primary`) represents the role.
- **Do not** introduce arbitrary token naming conventions.

## 12. Quick Mental Model

- **Raw design value** → Primitive token
- **Meaningful UI role** → Semantic token
- **Visual context** → Theme
- **Reusable UI pattern** → Component implementation
