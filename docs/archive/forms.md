# HEBRING Form Foundation

This document outlines the architectural specifications, inheritance mechanics, and boundaries governing the **Form Foundation** in the HEBRING CSS framework, implemented in [`src/foundation/base.css`](file:///Users/user/Documents/HEBRING/hebring/src/foundation/base.css) inside `@layer base`.

---

## 1. Core Philosophy: Minimal / Native-Preserving Form Foundation

HEBRING follows the principle:

> **"HEBRING enhances native form controls without taking ownership of their native behavior or appearance."**

The objective of the form foundation is to normalize typography and resolve obvious browser engine layout inconsistencies while **strictly preserving native HTML semantics, accessibility affordances, platform behavior, and appearance**.

### What This Means in Practice
1. **Typographic Integration**: Form controls (`<button>`, `<input>`, `<select>`, `<textarea>`) seamlessly inherit the document typography and text color.
2. **Native Platform Preservation**: Checkboxes, radio buttons, buttons, selects, file inputs, and range sliders retain their native operating system visual styling, state indicators, and interaction models.
3. **No Unsolicited Layout Opinions**: Controls do not force full-width layouts or block-level labels.
4. **Accessible Invariants**: Keyboard navigation, focus rings, and native control semantics remain 100% intact.

---

## 2. Implemented Baseline Rules

The entire form foundation in `src/foundation/base.css` consists of two focused, high-leverage normalization rules:

```css
@layer base {
  /* ==================================================
     10. FORM CONTROLS BASELINE
     ================================================== */
  button,
  input,
  select,
  textarea {
    font: inherit;
    color: inherit;
    line-height: inherit;
  }

  fieldset {
    min-width: 0;
  }
}
```

---

## 3. Typographic & Color Inheritance Mechanics

### Overcoming User-Agent Typography Disparities
Browser engines (Chromium, Gecko, WebKit) historically do not inherit typography onto form controls. By default, user-agent stylesheets assign internal platform widget fonts (`system-ui`, `small-caption`, or fixed 11–13px sizes) to form controls, causing them to look disconnected from document prose.

- **`font: inherit;`**:
  - Directs form controls to inherit `--hb-font-family-body`, `--hb-font-size-md` (1rem / 16px), and surrounding font weights from their parent container.
  - Controls placed inside smaller captions, table cells, or headings scale harmoniously with their enclosing context.
- **`color: inherit;`**:
  - Replaces user-agent system color keywords (`ButtonText`, `FieldText`) with the inherited `--hb-color-text`.
  - **Seamless Multi-Theme Adaptation**: When switching to Dark theme (`[data-theme="dark"]`) or embedding nested themed subtrees, form controls automatically inherit the active text color without writing theme-specific form CSS.
- **`line-height: inherit;`**:
  - Ensures predictable line-box alignment across browsers, preventing vertical text clipping within single-line inputs and buttons.

### Zero Form-Specific Tokens
HEBRING intentionally avoids creating redundant form tokens like `--hb-form-font-size` or `--hb-input-color`. Utilizing native CSS property inheritance guarantees maximum efficiency and architectural simplicity.

---

## 4. Fieldset Layout Normalization

```css
fieldset {
  min-width: 0;
}
```

### The Flex/Grid Container Blowout Bug
In Chromium and WebKit, `<fieldset>` elements default to `min-width: min-content;`. When a fieldset is placed inside modern flex or grid layouts (e.g., `<form class="hb-flex">` or responsive dashboard grids), it refuses to shrink below its intrinsic content width, causing the entire layout to overflow horizontally on mobile screens.

- Setting `min-width: 0;` allows `<fieldset>` to shrink below its content width inside flex and grid formatting contexts.
- **Non-Aggressive**: This rule leaves native fieldset borders, legends, and paddings completely untouched.

---

## 5. Preserved Native Behaviors & Appearance

HEBRING deliberately leaves the following areas unstyled at the foundation layer:

### 1. Buttons (`<button>`)
- Native platform button appearance, bevels, padding, borders, and backgrounds are preserved.
- **Excluded**: No custom background, border-radius, padding, box-shadows, or hover/active pseudo-class visual states.
- **No Component Classes**: `.hb-button` is not introduced here (reserved for Phase 05 Components).

### 2. Text Inputs, Selects & Textareas
- Retain native operating system borders, backgrounds, and platform chrome.
- **No Forced Width**: `width: 100%` is **not** applied globally. Inputs preserve their natural inline-block sizing, preventing compact fields (e.g., ZIP codes, dates, search inputs) from expanding uncontrollably.

### 3. Labels (`<label>`)
- Retain native `display: inline` behavior.
- **No Forced Block**: `label { display: block; }` is **not** applied, ensuring inline labels (such as checkboxes and radio labels) remain on the same line as their controls.

### 4. Checkboxes & Radio Buttons (`input[type="checkbox"]`, `input[type="radio"]`)
- **No `appearance: none;`**: Controls retain native platform checkmarks, radio dots, and OS accessibility affordances.
- Custom SVG or CSS-drawn checkbox components belong to opt-in component patterns, not foundational HTML.

### 5. File & Range Inputs (`input[type="file"]`, `input[type="range"]`)
- Retain native file selector button and platform slider track/thumb controls.
- Pseudo-elements like `::file-selector-button` and `::-webkit-slider-thumb` are untouched.

### 6. Focus Ring Preservation
- **Strict Prohibition**: Neither `outline: none;` nor `outline: 0;` is permitted on form controls.
- Native keyboard focus rings (`:focus`, `:focus-visible`) remain fully functional for keyboard navigation.
- The `--hb-color-focus` token is reserved for future component-level focus rings.

### 7. Disabled & ARIA Semantics
- **No Global Opacity**: `opacity: 0.5` is **not** applied globally to `:disabled`.
- The foundation simply does not interfere with native `disabled` behavior or `aria-disabled` semantics, ensuring assistive technologies receive raw, unmodified control states.

### 8. Cursor Behavior
- **No `button { cursor: pointer; }`**: The user-agent default `cursor: default` is preserved.

---

## 6. Cascade Layer & Specificity Strategy

All form foundation rules reside inside `@layer base`. Under the canonical layer order:

```
@layer reset < base < layout < components < utilities;
```

1. **Flat Selectors**: Sourced with specificity `(0, 0, 1)` on tag selectors.
2. **Effortless Component Overrides**: When future form components are implemented in `@layer components` (e.g., `.hb-input`, `.hb-button`), their styles naturally supersede `@layer base` by layer precedence.
3. **Effortless Utility Overrides**: Single-purpose utility classes in `@layer utilities` (e.g., `.hb-w-full`, `.hb-text-sm`) will override base form defaults effortlessly with a single class `(0, 1, 0)` without specificity escalation or `!important`.
4. **Zero `!important`**: No `!important` flags are permitted in the foundation domain.

---

## 7. Scope Boundaries (What Belongs to Future Phases)

The following items are strictly deferred to future phases:
- **Phase 05 (Components)**: Styled form controls (`.hb-input`, `.hb-button`, `.hb-select`, `.hb-form-field`, custom checkboxes).
- **Phase 06 (Utilities)**: Form sizing and layout utility classes (`.hb-w-full`, `.hb-resize-none`).
- **Validation UI**: Error, warning, and success visual feedback indicators.

---

## 8. Further Documentation

- **[Typography](typography.md)**: Document typography defaults and font family mappings.
- **[Reset Philosophy](reset-philosophy.md)**: Minimal browser normalization and semantic HTML preservation.
- **[Architecture Notes](architecture.md)**: Master framework cascade layers and domain boundaries.
- **[Token Developer Usage Guide](token-usage.md)**: Practical guidelines for consuming design tokens.
