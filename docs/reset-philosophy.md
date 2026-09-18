# HEBRING Reset Philosophy

This document outlines the architectural principles, boundaries, and rationale governing the **Reset Layer** (`src/foundation/reset.css`) in the HEBRING CSS framework.

---

## 1. Core Philosophy: Minimal / Non-Aggressive Reset

HEBRING rejects the aggressive "scorched-earth" resets popular in early CSS libraries, which attempted to wipe every default property from every HTML element (e.g., `* { margin: 0; padding: 0; }`). 

Instead, HEBRING employs a **minimal, non-aggressive reset**.

### Purpose of the Reset Layer
The sole responsibility of `reset.css` is to **normalize broken or problematic browser defaults** that cause layout failures or cross-browser inconsistencies, while **preserving useful native HTML semantics and accessibility affordances**.

### The Conceptual Progression

```
┌────────────────────────────────────────────────────────┐
│  1. Browser Defaults (User-Agent Stylesheet)           │  Native semantic defaults
└──────────────────────────┬─────────────────────────────┘
                           │
                           ▼
┌────────────────────────────────────────────────────────┐
│  2. Minimal Normalization (src/foundation/reset.css)   │  Eliminate layout bugs & blowouts
│     @layer reset                                       │  Preserve semantics & focus
└──────────────────────────┬─────────────────────────────┘
                           │
                           ▼
┌────────────────────────────────────────────────────────┐
│  3. Foundational Baselines (src/foundation/base.css)   │  HEBRING typography & defaults
│     @layer base                                        │  Base body styles, headings, links
└──────────────────────────┬─────────────────────────────┘
                           │
                           ▼
┌────────────────────────────────────────────────────────┐
│  4. Layout, Components & Utilities                     │  Modular UI patterns
│     @layer layout, components, utilities               │  Composable interface styling
└────────────────────────────────────────────────────────┘
```

HEBRING does **not** assume that the browser's native rendering engine is an adversary that must be flattened to zero. Native HTML elements possess rich, accessible default behaviors that should be celebrated and retained.

---

## 2. Guiding Principles

The HEBRING reset is governed by eight core principles:

1. **Predictable Box Sizing**: Enforce an intuitive box model across all elements and pseudo-elements.
2. **Sensible Media Containment**: Prevent intrinsic media dimensions from blowing out layout containers without dictating how media is displayed.
3. **Accessible Focus Preservation**: Never remove or weaken native keyboard focus indicators in the reset layer.
4. **Preservation of Semantic HTML**: Semantic elements (`<h1>`–`<h6>`, `<p>`, `<ul>`, `<ol>`, `<button>`, `<input>`) must remain fully functional and legible without requiring HEBRING classes.
5. **Strict Separation of Concerns**: Maintain a clear boundary between browser normalization (`reset.css`) and opinionated framework baselines (`base.css`).
6. **Minimal Footprint**: Keep the reset layer intentionally compact, adding only rules that are unambiguously justified.
7. **Framework-Agnostic & Zero Runtime**: Pure, modern CSS authored directly in native cascade layers with no preprocessors, build tools, or JavaScript dependencies.
8. **Cascade Composability**: Resets live in `@layer reset`, the lowest-priority framework layer, allowing downstream layers to override properties effortlessly without specificity escalation.

---

## 3. Preservation of Semantic HTML

A key failure mode of aggressive CSS resets is rendering raw HTML unusable. When a framework strips margins, line-heights, list styles, and button paddings globally, an unstyled document becomes an unreadable block of unformatted text.

In HEBRING:
- **Headings (`<h1>`–`<h6>`)**: Maintain native hierarchy and vertical separation out of the box.
- **Paragraphs (`<p>`)**: Retain default paragraph spacing until deliberately refined in `base.css` (Phase 04.3).
- **Lists (`<ul>`, `<ol>`)**: Retain their bullet markers and numbering semantics. List markers are not stripped globally in the reset layer.
- **Interactive Controls (`<button>`, `<input>`, `<select>`, `<textarea>`)**: Retain their native accessibility affordances, hit targets, and usability until normalized in Phase 04.4.
- **Links (`<a>`)**: Retain native cursor and interaction semantics.

**The Golden Standard**: Semantic HTML markup written without HEBRING classes must remain fully accessible, readable, and functional.

---

## 4. Accessibility as a Foundational Invariant

Accessibility is not a feature layered on top of visual design; it is a foundational invariant of the CSS cascade.

### Strict Prohibition of Blanket Focus Removal
The HEBRING reset strictly forbids blanket focus suppression:

```css
/* ❌ STRICTLY FORBIDDEN IN HEBRING */
*:focus {
  outline: none;
}

* {
  outline: 0;
}
```

Disabling native focus outlines without an immediate, accessible replacement leaves keyboard-only and assistive-technology users unable to navigate the interface. Native focus indicators (`:focus`, `:focus-visible`) remain fully functional across all interactive elements.

### Demarcation: Reset vs. Color Contrast
- **Reset Responsibility**: Interaction accessibility and structural affordances (preserving focus rings, maintaining tabability, retaining form controls).
- **Token & Component Responsibility**: Perceptual accessibility and color contrast.
  - `reset.css` does **not** declare text colors or background colors.
  - Color contrast (WCAG 2.1 AA/AAA compliance) is managed exclusively through calibrated [Semantic Tokens](semantic-tokens.md) (`--hb-color-text`, `--hb-color-surface`, `--hb-color-on-primary`) and future component implementations.

---

## 5. Box Model Normalization

Browser default stylesheets historically compute element sizing using `box-sizing: content-box`. Under `content-box`, borders and padding are added to an element's declared `width` and `height`, resulting in fragile calculations, container overflows, and unintuitive layout math.

### The Approved HEBRING Rule
```css
*,
*::before,
*::after {
  box-sizing: border-box;
}
```

### Rationale
1. **Predictability**: A `width: 300px` element with `padding: 16px` and `border: 1px solid` remains exactly 300px wide.
2. **Pseudo-Element Parity**: Applying `border-box` to `*::before` and `*::after` ensures decorative and structural pseudo-elements behave identically to DOM nodes.
3. **Cascade Layer Isolation**: Because this rule is placed inside `@layer reset`, its cascade priority is the lowest in the framework. Third-party widgets or legacy components requiring `content-box` can easily override it in unlayered or higher-layered styles without fighting specificity.

---

## 6. Media Normalization: Normalization vs. Layout Opinion

Media elements (`<img>`, `<video>`, `<canvas>`, `<svg>`) require careful normalization to prevent container blowouts, but the reset must never impose layout opinions.

### Normalization vs. Layout Opinion Demarcation

| Property / Strategy | Classification | Belongs in | Rationale |
| :--- | :--- | :--- | :--- |
| `max-width: 100%` | **Normalization** | `reset.css` | Fixes intrinsic element blowout where media exceeds container width. |
| `height: auto` | **Normalization** | `reset.css` | Preserves intrinsic aspect ratio when downscaling, preventing vertical distortion. |
| `display: block` | **Layout Opinion** | `base.css` / Components | Changes native `inline-block` document flow; breaks inline images, status icons, and badges. |
| Styling `<picture>` | **Layout Opinion** | Excluded | `<picture>` is an inline wrapper element; layout constraints belong to the child `<img>`. |
| Unconstrained `<svg>` | **Normalization** | `reset.css` | SVG viewBoxes can blow out containers; `max-width: 100%` keeps them contained without forcing block mode. |

### The Approved HEBRING Media Rules
```css
/* Media & Replaced Elements: Prevent container overflow while preserving aspect ratio */
img,
video,
canvas {
  max-width: 100%;
  height: auto;
}

svg {
  max-width: 100%;
}
```

- **`display` remains unforced**: Images and SVGs can be placed inline with text, within buttons, or alongside labels without unwanted line breaks.
- **`<picture>` receives no rules**: `<picture>` is a transparent HTML5 wrapper delegating rendering to child `<img>`. Leaving it unstyled prevents fragile wrapper constraints.

---

## 7. Document Canvas Normalization

```css
body {
  margin: 0;
}
```

User-agent stylesheets universally apply an arbitrary `margin: 8px` to `<body>`. This default creates unwanted whitespace around full-bleed layouts, hero sections, navigation bars, and footers. Removing this margin is a universal, non-aggressive normalization.

---

## 8. Reset vs. Base Responsibility

To prevent architectural drift, HEBRING strictly delineates between `reset.css` and subsequent layers:

```
src/foundation/
├── reset.css   # Browser normalization (Lowest layer: @layer reset)
└── base.css    # HEBRING foundational defaults (Layer: @layer base)
```

| Concern | `reset.css` (`@layer reset`) | `base.css` (`@layer base`) | Subsequent Phases |
| :--- | :--- | :--- | :--- |
| **Box Sizing** | `box-sizing: border-box` | Overrides if needed | Layout primitives |
| **Body Canvas** | `margin: 0` | `background-color`, default `font-family`, base `color` | Themes |
| **Typography Defaults** | **None** | Base font scale, line-height, text rendering | Phase 04.3 (Typography) |
| **Headings & Paragraphs** | **None** (native margins preserved) | Typographic hierarchy, intentional margins | Phase 04.3 (Typography) |
| **Lists** | **None** (bullets preserved) | Clean document lists | Utilities (`.hb-list-none`) |
| **Form Controls** | **None** (native affordances preserved) | Baseline font inheritance, normalization | Phase 04.4 (Forms) |
| **Focus Outlines** | **Preserved intact** (no `outline: none`) | `:focus-visible` styling with `--hb-color-focus` | Components & Utilities |
| **Media Display Mode** | **None** (`inline-block` preserved) | Editorial/article block images | Layout primitives |

---

## 9. Architectural Anti-Patterns Avoided

The following anti-patterns are strictly prohibited in the HEBRING reset:

1. **The Universal Margin/Padding Wipeout**:
   - ❌ `* { margin: 0; padding: 0; }`
   - Destroys semantic rhythm across headings, paragraphs, blockquotes, and lists.
2. **Global List Marker Removal**:
   - ❌ `ul, ol { list-style: none; }`
   - Strips list semantics from assistive technologies and breaks raw unstyled markdown/content rendering.
3. **Blanket Focus Outline Suppression**:
   - ❌ `*:focus { outline: none; }` or `* { outline: 0; }`
   - Causes severe keyboard navigation accessibility regressions.
4. **Forcing `display: block` on Media in Reset**:
   - ❌ `img, svg { display: block; }`
   - Disrupts inline icon, badge, and inline avatar usage in typography and navigation.
5. **Form Redesigns in the Reset Layer**:
   - ❌ Resetting input borders, backgrounds, and button styles in `reset.css`.
   - Conflates normalization with form design; belongs in Phase 04.4.
6. **Component or Utility Classes in Reset**:
   - ❌ Defining `.hb-reset` or `.hb-img-fluid` in `reset.css`.
   - The reset layer styles pure HTML elements via tag and universal selectors, never class names.

---

## 10. Summary of Implemented Reset Rules

The complete, active implementation of `src/foundation/reset.css`:

```css
@layer reset {
  /* 1. Box Model: Predictable sizing across all elements and pseudo-elements */
  *,
  *::before,
  *::after {
    box-sizing: border-box;
  }

  /* 2. Document Canvas: Eliminate arbitrary user-agent margin */
  body {
    margin: 0;
  }

  /* 3. Media & Replaced Elements: Prevent container overflow while preserving aspect ratio */
  img,
  video,
  canvas {
    max-width: 100%;
    height: auto;
  }

  svg {
    max-width: 100%;
  }
}
```

---

## 11. Further Documentation

- **[Architecture Notes](architecture.md)**: Master framework cascade layers, source architecture, and domain boundaries.
- **[Design Token Architecture](design-token-architecture.md)**: Value system structure and composition mechanics.
- **[Semantic Tokens Reference](semantic-tokens.md)**: Role mappings and WCAG AA contrast calibrations.
- **[Token Developer Usage Guide](token-usage.md)**: Developer best practices for styling components with tokens.
