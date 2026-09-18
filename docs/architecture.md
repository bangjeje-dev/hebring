# Architecture Notes — Cascade Layers

## Overview

HEBRING uses native CSS Cascade Layers (`@layer`) to make styling hierarchy explicit, predictable, and easy to understand.

By establishing an explicit cascade order, HEBRING avoids accidental selector specificity conflicts and maintains low selector complexity across the codebase.

## Official Layer Order

The canonical layer order declared in HEBRING is:

```css
@layer reset, base, layout, components, utilities;
```

The hierarchy flows in ascending priority:

```
reset → base → layout → components → utilities
```

1. **`reset`**: Normalizes default browser behaviors and removes inconsistencies across user agents.
2. **`base`**: Baseline typography, element styles, and core defaults.
3. **`layout`**: Structural scaffolding, grid systems, and page layout primitives.
4. **`components`**: Composable visual interface patterns (cards, buttons, navigation, etc.).
5. **`utilities`**: Single-purpose override classes. Utilities intentionally carry the highest priority among HEBRING's framework layers, allowing direct property overrides without specificity escalation.

## Specificity Principle

HEBRING's internal CSS architecture follows this clear priority preference:

```
Cascade Layers  >  Specificity escalation  >  !important
```

- Selectors are kept as simple and flat as possible.
- Avoid multi-class escalation or deep selector nesting.
- Avoid `!important` across framework layers.

## Design Tokens

Design tokens are **not** a cascade layer.

Tokens will be introduced in **Phase 03** as foundational CSS Custom Properties (`var(--hb-...)`). Rather than participating in the visual cascade hierarchy, tokens are shared values consumed by rules in `reset`, `base`, `layout`, `components`, and `utilities`.
