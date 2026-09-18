# HEBRING Primitive Design Tokens

This document details the approved **Primitive Design Tokens** for the HEBRING CSS framework.

Primitive tokens are context-agnostic, raw design values. They define literal scales (colors, spacing, typography, radii, elevation, motion) without expressing semantic purpose or component-specific logic.

All primitive tokens are defined globally on `:root` in [`src/tokens/primitives.css`](file:///Users/user/Documents/HEBRING/hebring/src/tokens/primitives.css).

---

## 1. Primitive vs. Semantic Distinction

HEBRING strictly separates **Primitive Tokens** from **Semantic Tokens**:

| Attribute | Primitive Tokens (`primitives.css`) | Semantic Tokens (`semantic.css`) |
| :--- | :--- | :--- |
| **Role** | Raw, literal scales | Contextual, intent-based aliases |
| **Context** | Completely context-agnostic | Purpose-specific (e.g. text, surface, action) |
| **Example** | `--hb-color-blue-600` | `--hb-color-primary` (mapped to blue-600) |
| **Changes** | Rarely change once calibrated | Can change across themes (light, dark) |
| **Status** | Implemented ([primitives.css](file:///Users/user/Documents/HEBRING/hebring/src/tokens/primitives.css)) | Implemented ([semantic.css](file:///Users/user/Documents/HEBRING/hebring/src/tokens/semantic.css)) |

---

## 2. Color Primitives

### Foundational Absolute Colors

HEBRING defines two universal absolute color primitives:

- `--hb-color-white`: `#FFFFFF`
- `--hb-color-black`: `#000000`

These represent universal absolute extremes and are intentionally separate from the contextual `Neutral` 50–950 scale. They serve as reliable base values for overlays, high-contrast text, borders, and theme baselines. They are raw primitives, not semantic tokens.

### Palettes

HEBRING provides 5 curated, coherent color palettes. Each palette spans 11 steps from `50` (lightest tint) to `950` (deepest shade).

- **Neutral**: Slate-tinted neutral calibrated for high-contrast UI text, borders, and surfaces.
- **Blue**: Vibrant brand & action scale. Step `600` (`#2563EB`) is the approved source for primary actions.
- **Green**: Natural positive scale for success indicators, badges, and validation.
- **Yellow**: Warm warning scale for caution alerts, stars, and attention badges.
- **Red**: Clear destructive scale for errors, danger alerts, and critical actions.

### Palette Values

| Step | Neutral | Blue | Green | Yellow | Red |
| :--- | :--- | :--- | :--- | :--- | :--- |
| **50** | `#f8fafc` | `#eff6ff` | `#f0fdf4` | `#fefce8` | `#fef2f2` |
| **100** | `#f1f5f9` | `#dbeafe` | `#dcfce7` | `#fef9c3` | `#fee2e2` |
| **200** | `#e2e8f0` | `#bfdbfe` | `#bbf7d0` | `#fef08a` | `#fecaca` |
| **300** | `#cbd5e1` | `#93c5fd` | `#86efac` | `#fde047` | `#fca5a5` |
| **400** | `#94a3b8` | `#60a5fa` | `#4ade80` | `#facc15` | `#f87171` |
| **500** | `#64748b` | `#3b82f6` | `#22c55e` | `#eab308` | `#ef4444` |
| **600** | `#475569` | **`#2563EB`** | `#16a34a` | `#ca8a04` | `#dc2626` |
| **700** | `#334155` | `#1d4ed8` | `#15803d` | `#a16207` | `#b91c1c` |
| **800** | `#1e293b` | `#1e40af` | `#166534` | `#854d0e` | `#991b1b` |
| **900** | `#0f172a` | `#1e3a8a` | `#14532d` | `#713f12` | `#7f1d1d` |
| **950** | `#020617` | `#172554` | `#052e16` | `#422006` | `#450a0a` |

> **Crucial Rule**: `--hb-color-blue-600` (`#2563EB`) is the raw primitive source. Semantic aliases such as `--hb-color-primary` are intentionally deferred to Phase 03.3.

---

## 3. Spacing Scale

HEBRING uses a strict **4px base spacing system**:

| Token | Multiplier | Value (px) |
| :--- | :--- | :--- |
| `--hb-space-0` | 0× | `0px` |
| `--hb-space-1` | 1× | `4px` |
| `--hb-space-2` | 2× | `8px` |
| `--hb-space-3` | 3× | `12px` |
| `--hb-space-4` | 4× | `16px` |
| `--hb-space-5` | 5× | `20px` |
| `--hb-space-6` | 6× | `24px` |
| `--hb-space-8` | 8× | `32px` |
| `--hb-space-10` | 10× | `40px` |
| `--hb-space-12` | 12× | `48px` |
| `--hb-space-16` | 16× | `64px` |
| `--hb-space-20` | 20× | `80px` |
| `--hb-space-24` | 24× | `96px` |
| `--hb-space-32` | 32× | `128px` |

---

## 4. Typography Primitives

### Font Families
- **`--hb-font-family-sans`**: `"Outfit", system-ui, -apple-system, BlinkMacSystemFont, "Segoe UI", sans-serif`
- **`--hb-font-family-mono`**: `ui-monospace, SFMono-Regular, Menlo, Monaco, Consolas, "Liberation Mono", "Courier New", monospace`

> **Note**: HEBRING does not bundle, download, or host font assets. `Outfit` is prioritized with native system fallbacks for zero network overhead.

### Font Sizes
| Token | Relative Value | Pixel Equivalent |
| :--- | :--- | :--- |
| `--hb-font-size-xs` | `0.75rem` | 12px |
| `--hb-font-size-sm` | `0.875rem` | 14px |
| `--hb-font-size-md` | `1rem` | 16px (base) |
| `--hb-font-size-lg` | `1.125rem` | 18px |
| `--hb-font-size-xl` | `1.25rem` | 20px |
| `--hb-font-size-2xl` | `1.5rem` | 24px |
| `--hb-font-size-3xl` | `1.875rem` | 30px |
| `--hb-font-size-4xl` | `2.25rem` | 36px |
| `--hb-font-size-5xl` | `3rem` | 48px |
| `--hb-font-size-6xl` | `3.75rem` | 60px |

### Font Weights
Only four deliberate weights are supported to maintain typographic discipline:
- `--hb-font-weight-regular`: `400`
- `--hb-font-weight-medium`: `500`
- `--hb-font-weight-semibold`: `600`
- `--hb-font-weight-bold`: `700`

### Line Heights
- `--hb-line-height-tight`: `1.25` (Headings, titles)
- `--hb-line-height-normal`: `1.5` (Body text, UI elements)
- `--hb-line-height-relaxed`: `1.75` (Long-form reading)

### Letter Spacing
- `--hb-letter-spacing-tight`: `-0.02em` (Large headlines)
- `--hb-letter-spacing-normal`: `0em` (Body copy)
- `--hb-letter-spacing-wide`: `0.025em` (All-caps, badges)

---

## 5. Border Radius

| Token | Value | Intended Scale |
| :--- | :--- | :--- |
| `--hb-radius-none` | `0px` | Sharp corners |
| `--hb-radius-sm` | `4px` | Badges, small tags, tooltips |
| `--hb-radius-md` | `8px` | Buttons, inputs, small cards |
| `--hb-radius-lg` | `12px` | Panels, standard cards, dropdowns |
| `--hb-radius-xl` | `16px` | Modals, large containers |
| `--hb-radius-2xl` | `24px` | Floating sheets, hero blocks |
| `--hb-radius-full` | `9999px` | Pills, circular avatars, status chips |

---

## 6. Box Shadows (Elevation)

A restrained elevation system using neutral shadows:

| Token | Value | Purpose |
| :--- | :--- | :--- |
| `--hb-shadow-none` | `none` | Flat surfaces |
| `--hb-shadow-sm` | `0 1px 2px 0 rgb(0 0 0 / 0.05)` | Subtle depth (cards at rest) |
| `--hb-shadow-md` | `0 4px 6px -1px rgb(0 0 0 / 0.1), 0 2px 4px -2px rgb(0 0 0 / 0.1)` | Hover states, dropdown menus |
| `--hb-shadow-lg` | `0 10px 15px -3px rgb(0 0 0 / 0.1), 0 4px 6px -4px rgb(0 0 0 / 0.1)` | Popovers, sticky headers |
| `--hb-shadow-xl` | `0 20px 25px -5px rgb(0 0 0 / 0.1), 0 8px 10px -6px rgb(0 0 0 / 0.1)` | Modals, dialogs, floating overlays |

---

## 7. Motion

### Transition Durations
- `--hb-duration-instant`: `50ms` (Micro-feedback)
- `--hb-duration-fast`: `150ms` (Hover states, toggles)
- `--hb-duration-normal`: `250ms` (Dropdowns, expansions)
- `--hb-duration-slow`: `350ms` (Modals, full-page transitions)

### Transition Easings
- `--hb-ease-linear`: `linear` (Spinners, continuous motion)
- `--hb-ease-standard`: `cubic-bezier(0.4, 0, 0.2, 1)` (General UI interactions)
- `--hb-ease-emphasized`: `cubic-bezier(0.2, 0, 0, 1)` (Attention-drawing entrances)

---

## 8. What Is Intentionally Excluded

To protect architectural boundaries, the following are strictly excluded from Phase 03.2:

- **Semantic Tokens**: `--hb-color-primary`, `--hb-color-surface`, `--hb-color-text` belong in `semantic.css` (Phase 03.3).
- **Component-Specific Tokens**: Tokens like `--hb-button-padding` or `--hb-card-radius` are prohibited.
- **Utility Classes**: Classes like `.hb-p-4` or `.hb-text-blue-600` belong in `utilities/` (Phase 06).
- **Layout Classes**: Primitives like `.hb-container` belong in `layout/` (Phase 04).
- **Theme Overrides & Dark Mode**: Multi-theme switching belongs in semantic token mappings and theme definitions.
- **Responsive Tokens**: Dynamic viewport clamp tokens are not introduced here.
- **CSS Preprocessors / JavaScript**: Tokens are pure, standard CSS Custom Properties.

---

## 9. Further Documentation

- **[Semantic Tokens Reference](semantic-tokens.md)**: Contextual role mappings and WCAG contrast validation.
- **[Theme Architecture](theme-architecture.md)**: `data-theme` activation, Light default behavior, and Dark overrides.
- **[Token Developer Usage Guide](token-usage.md)**: Best practices, practical component examples, and anti-patterns.
- **[Design Token Architecture](design-token-architecture.md)**: Source structure, composition boundaries, and import mechanics.

