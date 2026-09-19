# Component Naming and States

Phase 07.3 formalizes the naming grammar, structure, and state management for HEBRING components. This architecture strictly adheres to a robust, framework-agnostic convention inspired by BEM, while preserving native HTML and ARIA as the ultimate sources of semantic truth.

## Naming Grammar

HEBRING uses a strict prefix and delimiter syntax to ensure class names are predictable and visually distinct.

### 1. Component Root Class
Every component must have a root class acting as its styling anchor.
**Format**: `hb-{component}`
**Example**: `hb-button`, `hb-card`, `hb-alert`

### 2. Modifiers
Modifiers represent semantic visual or structural variations of a component.
**Format**: `hb-{component}--{modifier}` (double hyphen)
**Example**: `hb-button--primary`, `hb-alert--danger`

**Rules**:
- Modifiers represent static variations, **not** dynamic runtime states.
- A modifier class must be used alongside the root component class (e.g. `class="hb-button hb-button--primary"`).
- Styling properties must not become component modifiers (e.g. use `hb-button--large`, not `hb-button--padding-lg`).

### 3. Elements
Elements represent internal, structural parts of a component.
**Format**: `hb-{component}__{element}` (double underscore)
**Example**: `hb-button__icon`, `hb-card__header`

**Rules**:
- Elements are strictly scoped to their parent component.
- Deep element nesting chains (e.g., `hb-card__header__title`) are strictly prohibited. If a structure is that complex, it should be extracted into a separate component.

## Component States

State classes manage dynamic, runtime conditions or characteristics of a component.

### Formats
- `is-{state}` for a boolean condition (e.g., `is-loading`, `is-active`).
- `has-{state}` for a boolean characteristic (e.g., `has-icon`).

### Rules
- State classes are **intentionally NOT prefixed** with `hb-`. (e.g., `is-active`, NOT `hb-is-active`).
- States must **not** represent visual/component variants (use Modifiers for that).
- State classes are only used when genuinely useful. HEBRING does not predefine an exhaustive global state vocabulary to avoid premature bloat.

## Native HTML & ARIA Principle

Native HTML and ARIA attributes remain the authoritative semantic source of truth in HEBRING. Accessibility semantics must **never** be replaced by CSS class naming.

### Prefer Native HTML
If a native HTML attribute exists to represent a state, use it instead of inventing a CSS state class.

**Prefer**:
```html
<button class="hb-button" disabled>Submit</button>
```
**Avoid**:
```html
<button class="hb-button is-disabled">Submit</button>
```

### Prefer ARIA Attributes
If an ARIA attribute exists to represent a state, use it as the styling hook.

**Prefer**:
```html
<button class="hb-button" aria-expanded="true">Menu</button>
```
**Avoid**:
```html
<button class="hb-button is-expanded">Menu</button>
```

CSS should respond to these native pseudo-classes (`:disabled`, `:checked`) and ARIA attributes (`[aria-expanded="true"]`) where appropriate. State classes like `is-loading` should only be introduced when there is no direct, semantic HTML/ARIA equivalent.

## Summary: Correct vs Incorrect Examples

### Correct
- `hb-button` (Component)
- `hb-button--secondary` (Modifier)
- `hb-button__label` (Element)
- `is-loading` (State)
- `<button disabled>` (Native HTML State)
- `aria-selected="true"` (ARIA State)

### Incorrect
- `hb-is-active` (State classes do not use the `hb-` namespace)
- `hb-button--is-loading` (Modifiers are not for runtime states)
- `hb-button-primary` (Missing double hyphen for modifier)
- `hb-card__header__title` (Deep element chaining)
- `is-primary` (States are for conditions, not visual variants)
