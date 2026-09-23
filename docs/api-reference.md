# HEBRING API Reference

This document is the authoritative reference for the currently implemented public HEBRING CSS API.

## 1. Naming Conventions

HEBRING adheres to a strict naming pattern to ensure predictability:

- **Custom property**: `--hb-{name}`
- **Utility**: `hb-{property}-{value}`
- **Responsive Utility**: `hb-{utility}-{breakpoint}`
- **Component**: `hb-{component}`
- **Modifier**: `hb-{component}--{modifier}`
- **Element**: `hb-{component}__{element}`
- **State**: `is-{state}` or `has-{state}`

---

## 2. Design Tokens

### Primitive Tokens
Primitive tokens are the absolute raw values of the design system, defined globally on `:root`.

#### Color
- **Neutral**: `--hb-color-neutral-50` through `--hb-color-neutral-950`
- **Blue**: `--hb-color-blue-50` through `--hb-color-blue-950`
- **Green**: `--hb-color-green-50` through `--hb-color-green-950`
- **Yellow**: `--hb-color-yellow-50` through `--hb-color-yellow-950`
- **Red**: `--hb-color-red-50` through `--hb-color-red-950`
- **Absolute**: `--hb-color-white`, `--hb-color-black`

#### Spacing (4px Base System)
`--hb-space-0`, `--hb-space-1`, `--hb-space-2`, `--hb-space-3`, `--hb-space-4`, `--hb-space-5`, `--hb-space-6`, `--hb-space-8`, `--hb-space-10`, `--hb-space-12`, `--hb-space-16`, `--hb-space-20`, `--hb-space-24`, `--hb-space-32`

#### Typography
- **Families**: `--hb-font-family-sans`, `--hb-font-family-mono`
- **Sizes**: `--hb-font-size-xs`, `--hb-font-size-sm`, `--hb-font-size-md`, `--hb-font-size-lg`, `--hb-font-size-xl`, `--hb-font-size-2xl`, `--hb-font-size-3xl`, `--hb-font-size-4xl`, `--hb-font-size-5xl`, `--hb-font-size-6xl`
- **Weights**: `--hb-font-weight-regular`, `--hb-font-weight-medium`, `--hb-font-weight-semibold`, `--hb-font-weight-bold`
- **Line Heights**: `--hb-line-height-tight`, `--hb-line-height-normal`, `--hb-line-height-relaxed`
- **Letter Spacings**: `--hb-letter-spacing-tight`, `--hb-letter-spacing-normal`, `--hb-letter-spacing-wide`

#### Radius
`--hb-radius-none`, `--hb-radius-sm`, `--hb-radius-md`, `--hb-radius-lg`, `--hb-radius-xl`, `--hb-radius-2xl`, `--hb-radius-full`

#### Shadow
`--hb-shadow-none`, `--hb-shadow-sm`, `--hb-shadow-md`, `--hb-shadow-lg`, `--hb-shadow-xl`

#### Motion
- **Durations**: `--hb-duration-instant`, `--hb-duration-fast`, `--hb-duration-normal`, `--hb-duration-slow`
- **Easings**: `--hb-ease-linear`, `--hb-ease-standard`, `--hb-ease-emphasized`

### Semantic Tokens
Contextual, intent-based design mappings referencing primitive tokens. These are the tokens components and application CSS should consume.

| Category | Token Variables |
|----------|-----------------|
| **Background** | `--hb-color-background`, `--hb-color-background-subtle` |
| **Surface** | `--hb-color-surface`, `--hb-color-surface-raised`, `--hb-color-surface-muted` |
| **Text** | `--hb-color-text`, `--hb-color-text-muted`, `--hb-color-text-subtle`, `--hb-color-text-disabled` |
| **Border** | `--hb-color-border`, `--hb-color-border-strong` |
| **Primary** | `--hb-color-primary`, `--hb-color-primary-hover`, `--hb-color-primary-active`, `--hb-color-primary-subtle`, `--hb-color-on-primary` |
| **Success** | `--hb-color-success`, `--hb-color-success-subtle`, `--hb-color-on-success` |
| **Warning** | `--hb-color-warning`, `--hb-color-warning-subtle`, `--hb-color-on-warning` |
| **Danger** | `--hb-color-danger`, `--hb-color-danger-subtle`, `--hb-color-on-danger` |
| **Info** | `--hb-color-info`, `--hb-color-info-subtle`, `--hb-color-on-info` |
| **Focus** | `--hb-color-focus` |
| **Typography** | `--hb-font-family-body`, `--hb-font-family-heading`, `--hb-font-family-code` |

---

## 3. Foundation API

HEBRING normalizes browser defaults via the `@layer reset` and `@layer base` CSS layers.

**Public Behaviors:**
- **Box Sizing**: Global `box-sizing: border-box` applied to `*`, `::before`, and `::after`.
- **Browser Text Size Adjustment**: Prevented on mobile devices (`text-size-adjust: 100%`).
- **Body Margin**: Normalized (`margin: 0`).
- **Media Containment**: Images and videos are responsive (`max-width: 100%; height: auto`).
- **SVG Behavior**: Default inline display, inheriting current color.
- **Typography Defaults**: Body inherits semantic typography variables (sans font family, medium size, regular weight, text color).
- **Form Inheritance**: Inputs and buttons inherit font family from their container.

*Note: Foundation provides baseline behaviors, not utility classes.*

---

## 4. Layout API

Structural relationships between elements.

| Class | Purpose | Key Behavior |
|-------|---------|--------------|
| `.hb-container` | Page/content boundary | `max-width: 80rem`, centered, horizontal padding (`--hb-space-4`) |
| `.hb-stack` | Vertical sequence | `display: flex; flex-direction: column`, gap (`--hb-space-4`) |
| `.hb-cluster` | Wrapping horizontal group | `display: flex; flex-wrap: wrap`, gap (`--hb-space-4`) |
| `.hb-grid` | 2D structure | `display: grid`, gap (`--hb-space-4`) |
| `.hb-flex` | Generic flex context | `display: flex` |
| `.hb-center` | Absolute centering | Flexbox centered on both axes |
| `.hb-flow` | Document vertical rhythm | `margin-block-start: var(--hb-space-4)` on sibling selector |

*Layout primitives are intentionally non-responsive. Use native CSS for responsive layout changes.*

---

## 5. Component API

HEBRING intentionally minimizes its component API.

### Button (`.hb-button`)
**Base**: `.hb-button` (Medium primary variant).
**Modifiers**:
- `.hb-button--secondary`
- `.hb-button--danger`
- `.hb-button--sm`
- `.hb-button--lg`

**JavaScript-Toggled States**:
- `.is-loading`

**Native States** (Handled automatically):
- `:hover`, `:focus-visible`, `:active`, `:disabled`

*Supported on `<button>` and `<a>` elements.*

### Card (`.hb-card`)
**Base**: `.hb-card`
**Elements**:
- `.hb-card__header`
- `.hb-card__body`
- `.hb-card__footer`

### Badge (`.hb-badge`)
**Base**: `.hb-badge`
**Modifiers**:
- `.hb-badge--primary`
- `.hb-badge--success`
- `.hb-badge--warning`
- `.hb-badge--danger`

### Alert (`.hb-alert`)
**Base**: `.hb-alert`
**Modifiers**:
- `.hb-alert--info`
- `.hb-alert--success`
- `.hb-alert--warning`
- `.hb-alert--danger`

---

## 6. Utility API

### Spacing
Maps to the 4px base primitive scale (`0`, `1`, `2`, `3`, `4`, `5`, `6`, `8`, `10`, `12`, `16`, `20`, `24`, `32`).

- **Padding**: `.hb-p-*`, `.hb-px-*`, `.hb-py-*`, `.hb-ps-*`, `.hb-pe-*`, `.hb-pt-*`, `.hb-pb-*`
- **Margin**: `.hb-m-*`, `.hb-mx-*`, `.hb-my-*`, `.hb-ms-*`, `.hb-me-*`, `.hb-mt-*`, `.hb-mb-*`
- **Gap**: `.hb-gap-*`, `.hb-gap-x-*`, `.hb-gap-y-*`

*Note: Spacing is non-responsive. Negative and arbitrary values are intentionally absent.*

### Display / Visibility
- **Display**: `.hb-block`, `.hb-inline`, `.hb-inline-block`, `.hb-inline-flex`, `.hb-inline-grid`, `.hb-none`
- **Visibility**: `.hb-visible`, `.hb-invisible`

### Sizing
- **Width**: `.hb-w-auto`, `.hb-w-full` (100%)
- **Height**: `.hb-h-auto`, `.hb-h-full` (100%)

### Typography
- **Font Size**: `.hb-text-xs`, `.hb-text-sm`, `.hb-text-base`, `.hb-text-lg`, `.hb-text-xl`, `.hb-text-2xl`, `.hb-text-3xl`, `.hb-text-4xl`, `.hb-text-5xl`, `.hb-text-6xl`
- **Text Alignment**: `.hb-text-start`, `.hb-text-center`, `.hb-text-end`
- **Font Weight**: `.hb-font-normal`, `.hb-font-medium`, `.hb-font-semibold`, `.hb-font-bold`

### Alignment (Flex/Grid Child)
- **Align Self**: `.hb-self-auto`, `.hb-self-start`, `.hb-self-center`, `.hb-self-end`, `.hb-self-stretch`
- **Justify Self**: `.hb-justify-self-auto`, `.hb-justify-self-start`, `.hb-justify-self-center`, `.hb-justify-self-end`, `.hb-justify-self-stretch`

---

## 7. Responsive Utility API

HEBRING provides a minimal responsive enhancement API.
**Breakpoints:**
- `sm`: 640px
- `md`: 768px
- `lg`: 1024px

| Utility Family | Supports Responsive? | Syntax |
|----------------|-----------------------|--------|
| **Display / Visibility** | ✅ Yes | `.hb-{utility}-{breakpoint}` (e.g., `.hb-block-sm`) |
| **Sizing** | ✅ Yes | `.hb-{utility}-{breakpoint}` (e.g., `.hb-w-full-lg`) |
| **Typography Size/Alignment**| ✅ Yes | `.hb-{utility}-{breakpoint}` (e.g., `.hb-text-center-md`) |
| **Item Alignment** | ✅ Yes | `.hb-{utility}-{breakpoint}` (e.g., `.hb-self-start-md`) |
| **Spacing** | ❌ No | - |
| **Typography Weight** | ❌ No | - |

---

## 8. Themes API

- **Default Theme**: Implemented globally on `:root`. Does **not** require a `data-theme="light"` attribute.
- **Dark Theme**: Implemented via `[data-theme="dark"]`. 

**Overridden Semantics in Dark Theme:**
Overrides the background, surface, text, border, primary, success, warning, danger, info, and focus variables to utilize darker primitive colors.

*Application-level themes (like `[data-theme="brand"]`) are extensions, not built-in HEBRING APIs.*

---

## 9. Package / Distribution API

**Package Name**: `hebring`
**Style Entry**: `"./dist/hebring.css"`

**Exports Map**:
- `"."`: Maps to `./dist/hebring.css`
- `"./css"`: Maps to `./dist/hebring.css`
- `"./min"`: Maps to `./dist/hebring.min.css`
- `"./package.json"`: Exposes `package.json`

**Distribution Artifacts**:
- `dist/hebring.css`: The bundled, unminified CSS framework.
- `dist/hebring.min.css`: The minified CSS framework.

---

## 10. Public vs Internal API Boundaries

**Public API**:
- All classes, custom properties, themes, and package exports explicitly documented above.

**Internal API (Not guaranteed by semver)**:
- The internal `src/` directory module file structure.
- Local component CSS custom properties (e.g., `--hb-button-bg`).
- Build and test scripts inside `package.json` and `./tests/`.
