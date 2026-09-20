# Component Tokens

Phase 07.4 defines the architecture and philosophy for **Component Tokens** within HEBRING.

Component tokens represent the deepest, most specific layer of the token architecture. However, unlike primitive and semantic tokens, they are **strictly optional** and exist solely as local implementation wiring.

## Architectural Model

The intended relationship and cascade of token values flows strictly downwards:

```text
Design Tokens
    |
    +-- Primitive Tokens (Raw values: spacing, color scales)
    |
    +-- Semantic Tokens (Intent: primary color, surface background)
            |
            v
       Component CSS (Consumes semantic tokens directly)
            |
            +-- Optional Local Component Tokens (Wiring/abstraction)
                    |
                    v
              Component Styling
```

## Core Principles

1. **Semantic Tokens First**: By default, components should consume semantic tokens directly. E.g., `background-color: var(--hb-color-surface);`.
2. **Strictly Optional**: Component tokens are not mandatory. They are introduced only when they provide a meaningful abstraction or simplify internal component state/variant wiring.
3. **Locally Scoped**: Component tokens are implementation details. They live within the component CSS file (e.g., `button.css`) and are scoped to the component class (e.g., `.hb-button`).
4. **No Global Namespace**: HEBRING explicitly rejects a global, predefined component-token namespace. There is no `src/tokens/components.css`.
5. **Not Automatically Public API**: Component tokens are internal wiring. While a consumer *could* override them, they are not guaranteed as stable public design-system APIs in the same way semantic tokens are.

## Naming Convention

When component tokens are utilized, they follow the naming convention:
`--hb-{component}-{property}` or `--hb-{component}-{element}-{property}`

Example: `--hb-button-background`, `--hb-card-padding`

## When to Use Component Tokens

Component tokens are justified when:
- **Modifier/Variant Simplification**: A component has many variants (primary, secondary, danger) that only change a few specific values. Overriding a local token (`--hb-button-bg`) inside a modifier class is cleaner than redeclaring every CSS property.
- **State Simplification**: A component's hover, active, or disabled state is best managed by swapping a local token rather than repeating complex CSS rules.

## When NOT to Use Component Tokens

Component tokens are **not** justified when:
- **Token Explosion**: Defining a component token for every single CSS property (e.g., `--hb-button-display`, `--hb-button-margin`) creates unnecessary abstraction and bloat.
- **Premature Abstraction**: Creating component tokens before the component exists or before the variant complexity demands them.

## Example (Architectural Only)

*Note: This is a conceptual example. Actual components do not exist yet.*

```css
/* Direct Semantic Consumption (Preferred for simple components) */
.hb-badge {
  background-color: var(--hb-color-surface-muted);
  color: var(--hb-color-text);
}

/* Component Token Wiring (Preferred for complex variants) */
.hb-button {
  --hb-button-bg: var(--hb-color-primary);
  --hb-button-text: var(--hb-color-on-primary);

  background-color: var(--hb-button-bg);
  color: var(--hb-button-text);
}

.hb-button--secondary {
  --hb-button-bg: var(--hb-color-surface);
  --hb-button-text: var(--hb-color-text);
}
```

## Validation Point

The true validation of this architecture will occur during the implementation of the first real component in HEBRING, ensuring that the token strategy works practically without introducing unnecessary bloat.
