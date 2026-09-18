# HEBRING Foundation Typography

This document outlines the architectural specifications, token mappings, and usage rules governing the **Typography System** in the HEBRING CSS framework, implemented in [`src/foundation/base.css`](file:///Users/user/Documents/HEBRING/hebring/src/foundation/base.css) inside `@layer base`.

---

## 1. Core Philosophy

HEBRING establishes an accessible, aesthetically harmonious typographic baseline for raw semantic HTML elements out of the box.

### The Semantic HTML First Principle
Semantic HTML markup should look visually balanced and highly readable without requiring framework utility classes:

```html
<!-- Automatically balanced typography without requiring class names -->
<h1>Welcome to HEBRING</h1>
<p>Build modern interfaces with predictable, understandable CSS.</p>
<a href="#">Learn more about the architecture</a>
```

### Layered Architecture & Override Predictability
All base typography rules reside inside `@layer base`. In accordance with HEBRING's canonical cascade layer order:

```
@layer reset < base < layout < components < utilities;
```

1. **Effortless Utility Overrides**: Because base typography resides in `@layer base`, any single-purpose utility class in `@layer utilities` (such as `.hb-text-5xl` or `.hb-font-bold`) automatically overrides base element styles without requiring specificity escalation or `!important`.
2. **Component Encapsulation**: Component styles in `@layer components` (`.hb-card h2`) supersede base typography naturally by layer priority.
3. **Pure CSS & Zero JavaScript**: No runtime dependencies, polyfills, or build steps required.

---

## 2. The Font Family System

HEBRING defines three semantic font family roles in `src/tokens/semantic.css`, referencing primitive font stacks in `src/tokens/primitives.css`:

| Role | Semantic Token | Primitive Source | Stack Definition |
| :--- | :--- | :--- | :--- |
| **Body / Content** | `--hb-font-family-body` | `--hb-font-family-sans` | `"Outfit", system-ui, -apple-system, BlinkMacSystemFont, "Segoe UI", sans-serif` |
| **Headings / Titles** | `--hb-font-family-heading` | `--hb-font-family-sans` | `"Outfit", system-ui, -apple-system, BlinkMacSystemFont, "Segoe UI", sans-serif` |
| **Code / Technical** | `--hb-font-family-code` | `--hb-font-family-mono` | `ui-monospace, SFMono-Regular, Menlo, Monaco, Consolas, "Liberation Mono", monospace` |

No hardcoded font families or arbitrary font names are permitted in component or base rules.

---

## 3. Body Typography

The baseline document typography is applied to `<body>`:

```css
body {
  font-family: var(--hb-font-family-body);
  font-size: var(--hb-font-size-md);
  font-weight: var(--hb-font-weight-regular);
  line-height: var(--hb-line-height-normal);
  color: var(--hb-color-text);
}
```

- **Font Family**: `--hb-font-family-body` ensures brand coherence while falling back cleanly to native system UI fonts.
- **Font Size**: Base font size is `--hb-font-size-md` (`1rem` / `16px`).
- **Font Weight**: `--hb-font-weight-regular` (`400`).
- **Line Height**: `--hb-line-height-normal` (`1.5`), providing comfortable reading line-box spacing.
- **Text Color**: `--hb-color-text` dynamically recalibrates between Light theme (`neutral-900`) and Dark theme (`neutral-50`).

---

## 4. Heading Scale Hierarchy (`h1`–`h6`)

Headings use `--hb-font-family-heading`, tight line-height (`--hb-line-height-tight`: `1.25`), and proportional bottom margins:

| Tag | Token Size | Computed Size | Token Weight | Line Height | Bottom Margin |
| :--- | :--- | :--- | :--- | :--- | :--- |
| `<h1>` | `--hb-font-size-4xl` | `2.25rem` (36px) | `bold` (`700`) | `tight` (`1.25`) | `--hb-space-4` (16px) |
| `<h2>` | `--hb-font-size-3xl` | `1.875rem` (30px) | `bold` (`700`) | `tight` (`1.25`) | `--hb-space-3` (12px) |
| `<h3>` | `--hb-font-size-2xl` | `1.5rem` (24px) | `semibold` (`600`) | `tight` (`1.25`) | `--hb-space-3` (12px) |
| `<h4>` | `--hb-font-size-xl` | `1.25rem` (20px) | `semibold` (`600`) | `tight` (`1.25`) | `--hb-space-2` (8px) |
| `<h5>` | `--hb-font-size-lg` | `1.125rem` (18px) | `semibold` (`600`) | `tight` (`1.25`) | `--hb-space-2` (8px) |
| `<h6>` | `--hb-font-size-md` | `1rem` (16px) | `semibold` (`600`) | `tight` (`1.25`) | `--hb-space-2` (8px) |

All headings set `margin-top: 0` to maintain a predictable, single-direction vertical rhythm.

---

## 5. Paragraphs & Prose Spacing

```css
p {
  margin-top: 0;
  margin-bottom: var(--hb-space-4);
}
```

Paragraphs inherit body typography metrics and establish a consistent `16px` (`--hb-space-4`) bottom margin. HEBRING avoids aggressive margin collapse wipeouts, ensuring running prose flows with natural spacing.

---

## 6. Hyperlinks (`<a>`)

Hyperlinks provide clear, accessible visual affordances that conform to WCAG 2.1 guidelines:

```css
a {
  color: var(--hb-color-primary);
  text-decoration: underline;
}

a:hover {
  color: var(--hb-color-primary-hover);
}

a:active {
  color: var(--hb-color-primary-active);
}
```

- **Underline Preserved**: Hyperlinks retain their underline by default, ensuring links remain distinguishable for low-vision and color-blind users without relying strictly on color contrast.
- **Interactive Feedback**: Transitions cleanly from `--hb-color-primary` (`#2563EB` in light, `#3B82F6` in dark) to hover and active states.

---

## 7. Inline Semantics & Formatting

### Emphasis: `<strong>`, `<b>`, `<em>`, `<i>`
- `strong, b`: Styled with `font-weight: var(--hb-font-weight-semibold)` (`600`), providing clear visual emphasis without excessive ink weight.
- `em, i`: Retain `font-style: italic`.

### Small Text: `<small>`
- `small`: Sets `font-size: var(--hb-font-size-sm)` (`0.875rem` / `14px`) and maintains readable `line-height: var(--hb-line-height-normal)`.

### Highlighting: `<mark>`
- `mark`: Uses `background-color: var(--hb-color-warning-subtle)` paired with `color: var(--hb-color-text)`.
- Achieves high visual legibility and WCAG AA contrast without transforming into an artificial badge or button component.

### Subscript & Superscript: `<sub>`, `<sup>`
```css
sub,
sup {
  font-size: 75%;
  line-height: 0;
  position: relative;
  vertical-align: baseline;
}

sub { bottom: -0.25em; }
sup { top: -0.5em; }
```
- Normalizes vertical positioning using relative offsets and `line-height: 0`, preventing sub/superscript elements from expanding line-boxes and disrupting paragraph line spacing.

---

## 8. Lists (`<ul>`, `<ol>`, `<li>`)

```css
ul,
ol {
  margin-top: 0;
  margin-bottom: var(--hb-space-4);
  padding-inline-start: var(--hb-space-6);
}

li {
  margin-bottom: var(--hb-space-1);
}

li > ul,
li > ol {
  margin-top: var(--hb-space-1);
  margin-bottom: 0;
}
```

- **Preserved Markers**: Native list markers (bullets for `<ul>`, numbers for `<ol>`) are strictly retained. Stripping list markers globally is prohibited.
- **Direction-Aware Indentation**: Uses `padding-inline-start: var(--hb-space-6)` (`24px`), providing optimal readability in both LTR and RTL reading contexts.
- **Nested Lists**: Sets tight `margin-top: var(--hb-space-1)` and `margin-bottom: 0` to eliminate double-spacing in multi-level outlines.

---

## 9. Code & Monospace (`code`, `kbd`, `samp`, `pre`)

### Inline Monospace
```css
code,
kbd,
samp {
  font-family: var(--hb-font-family-code);
  font-size: 0.875em;
}
```
- Sets font family to `--hb-font-family-code`.
- Uses a proportional `0.875em` font size so inline code scales harmoniously whether placed inside a body paragraph (`1rem`), a small caption (`0.875rem`), or a heading (`1.5rem`).

### Preformatted Code Blocks
```css
pre {
  font-family: var(--hb-font-family-code);
  font-size: var(--hb-font-size-sm);
  line-height: var(--hb-line-height-normal);
  overflow-x: auto;
  margin-top: 0;
  margin-bottom: var(--hb-space-4);
}

pre code {
  font-size: inherit;
}
```
- **Overflow Containment**: `overflow-x: auto` allows long code lines to scroll horizontally without breaking container bounds.
- **Typographic Baseline**: Remains a pure typographical element, avoiding opinionated component chrome, line numbers, or borders.

---

## 10. Blockquotes (`<blockquote>`)

```css
blockquote {
  margin-top: 0;
  margin-bottom: var(--hb-space-4);
  margin-inline: var(--hb-space-6);
  line-height: var(--hb-line-height-relaxed);
  color: var(--hb-color-text-muted);
}
```

- Sets relaxed line spacing (`--hb-line-height-relaxed`: `1.75`) and secondary text contrast (`--hb-color-text-muted`) to distinguish quoted passages from primary narrative text without component-level decoration.

---

## 11. Complete Token Mapping Summary

| Element | Property | Token Applied |
| :--- | :--- | :--- |
| `body` | `font-family` | `var(--hb-font-family-body)` |
| `body` | `font-size` | `var(--hb-font-size-md)` |
| `body` | `font-weight` | `var(--hb-font-weight-regular)` |
| `body` | `line-height` | `var(--hb-line-height-normal)` |
| `body` | `color` | `var(--hb-color-text)` |
| `h1`–`h6` | `font-family` | `var(--hb-font-family-heading)` |
| `h1`–`h6` | `line-height` | `var(--hb-line-height-tight)` |
| `h1`–`h6` | `color` | `var(--hb-color-text)` |
| `h1` | `font-size`, `font-weight` | `var(--hb-font-size-4xl)`, `var(--hb-font-weight-bold)` |
| `h2` | `font-size`, `font-weight` | `var(--hb-font-size-3xl)`, `var(--hb-font-weight-bold)` |
| `h3` | `font-size`, `font-weight` | `var(--hb-font-size-2xl)`, `var(--hb-font-weight-semibold)` |
| `h4` | `font-size`, `font-weight` | `var(--hb-font-size-xl)`, `var(--hb-font-weight-semibold)` |
| `h5` | `font-size`, `font-weight` | `var(--hb-font-size-lg)`, `var(--hb-font-weight-semibold)` |
| `h6` | `font-size`, `font-weight` | `var(--hb-font-size-md)`, `var(--hb-font-weight-semibold)` |
| `a` | `color` | `var(--hb-color-primary)` |
| `a:hover` | `color` | `var(--hb-color-primary-hover)` |
| `a:active` | `color` | `var(--hb-color-primary-active)` |
| `strong, b` | `font-weight` | `var(--hb-font-weight-semibold)` |
| `small` | `font-size` | `var(--hb-font-size-sm)` |
| `mark` | `background-color` | `var(--hb-color-warning-subtle)` |
| `code, kbd, samp, pre` | `font-family` | `var(--hb-font-family-code)` |
| `pre` | `font-size` | `var(--hb-font-size-sm)` |
| `blockquote` | `color`, `line-height` | `var(--hb-color-text-muted)`, `var(--hb-line-height-relaxed)` |
| Spacing margins | `margin-bottom` | `var(--hb-space-1)` to `var(--hb-space-4)` |

---

## 12. Further Documentation

- **[Architecture Notes](architecture.md)**: Cascade layers, domain boundaries, and layer specificity hierarchy.
- **[Reset Philosophy](reset-philosophy.md)**: Minimal browser normalization and semantic HTML preservation.
- **[Design Token Architecture](design-token-architecture.md)**: Design token source organization and composition mechanics.
- **[Token Developer Usage Guide](token-usage.md)**: Practical guidelines for styling components with tokens.
