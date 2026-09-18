# HEBRING Semantic Design Tokens

This document details the approved **Semantic Design Tokens** for the HEBRING CSS framework.

Semantic tokens assign intent, role, and meaning to raw primitive values. While primitive tokens define *what value* exists (e.g., `#2563EB`), semantic tokens declare *what role* that value plays in an interface (e.g., primary action, muted text, surface background).

All semantic tokens are defined globally on `:root` in [`src/tokens/semantic.css`](file:///Users/user/Documents/HEBRING/hebring/src/tokens/semantic.css).

---

## 1. Semantic Token Philosophy

HEBRING maintains a strict distinction between primitive and semantic tokens:

```
┌────────────────────────────────────────────────────────┐
│  Primitive Tokens (primitives.css)                     │  "What value is this?"
│  --hb-color-blue-600: #2563EB;                         │  Literal scales, context-agnostic
└──────────────────────────┬─────────────────────────────┘
                           │
                           ▼
┌────────────────────────────────────────────────────────┐
│  Semantic Tokens (semantic.css)                        │  "What role does this serve?"
│  --hb-color-primary: var(--hb-color-blue-600);         │  Intent-driven, role-based aliases
└──────────────────────────┬─────────────────────────────┘
                           │
                           ▼
┌────────────────────────────────────────────────────────┐
│  Framework Layers (Components, Layout, etc.)           │  "How is the UI constructed?"
│  color: var(--hb-color-primary);                       │  Consistent design language
└────────────────────────────────────────────────────────┘
```

### Core Rules:
1. **Never Duplicate Hex Codes**: Semantic tokens must **always** reference primitive tokens via `var(--hb-...)`. They never define literal hex, rgb, or rem values directly.
2. **Contextual Clarity**: Semantic tokens describe functional intent (e.g., `--hb-color-text-muted`), never physical appearance (e.g., `--hb-color-gray`).
3. **No Component Coupling**: Semantic tokens represent framework-wide roles, not individual component parts.

---

## 2. Token Categories & Default Mappings

### 1. Background Roles
Background tokens define page and foundation container canvas colors:

| Token | Primitive Reference | Resolved Default | Description |
| :--- | :--- | :--- | :--- |
| `--hb-color-background` | `var(--hb-color-white)` | `#FFFFFF` | Default canvas background for views and viewports |
| `--hb-color-background-subtle` | `var(--hb-color-neutral-50)` | `#f8fafc` | Subtle off-white canvas for sectioning and contrasting zones |

### 2. Surface Roles
Surface tokens represent elevated cards, panels, sheets, and modular containers:

| Token | Primitive Reference | Resolved Default | Description |
| :--- | :--- | :--- | :--- |
| `--hb-color-surface` | `var(--hb-color-white)` | `#FFFFFF` | Default surface for cards, dialogs, and lists |
| `--hb-color-surface-raised` | `var(--hb-color-white)` | `#FFFFFF` | Elevated surfaces (e.g., floating menus, dropdowns) |
| `--hb-color-surface-muted` | `var(--hb-color-neutral-100)` | `#f1f5f9` | Inset, secondary, or deactivated container background |

### 3. Text Roles
Text tokens establish accessible reading hierarchy across standard backgrounds:

| Token | Primitive Reference | Resolved Default | Description |
| :--- | :--- | :--- | :--- |
| `--hb-color-text` | `var(--hb-color-neutral-900)` | `#0f172a` | Primary body text, headings, and high-emphasis labels |
| `--hb-color-text-muted` | `var(--hb-color-neutral-600)` | `#475569` | Secondary captions, timestamps, and supporting text |
| `--hb-color-text-subtle` | `var(--hb-color-neutral-500)` | `#64748b` | Tertiary metadata, placeholder text, and subtle icons |
| `--hb-color-text-disabled` | `var(--hb-color-neutral-400)` | `#94a3b8` | Deactivated or disabled text states |

### 4. Border Roles
Border tokens provide structured visual demarcation:

| Token | Primitive Reference | Resolved Default | Description |
| :--- | :--- | :--- | :--- |
| `--hb-color-border` | `var(--hb-color-neutral-200)` | `#e2e8f0` | Standard dividing lines, table rows, and card borders |
| `--hb-color-border-strong` | `var(--hb-color-neutral-300)` | `#cbd5e1` | Emphasized dividers, input boundaries, and active outlines |

### 5. Primary Action & Brand Roles
Primary tokens govern brand identity, primary call-to-action buttons, and interactive highlights:

| Token | Primitive Reference | Resolved Default | Description |
| :--- | :--- | :--- | :--- |
| `--hb-color-primary` | `var(--hb-color-blue-600)` | `#2563EB` | Base brand and primary interactive action |
| `--hb-color-primary-hover` | `var(--hb-color-blue-700)` | `#1d4ed8` | Pointer hover state on primary interactive elements |
| `--hb-color-primary-active` | `var(--hb-color-blue-800)` | `#1e40af` | Pressed/active state on primary interactive elements |
| `--hb-color-primary-subtle` | `var(--hb-color-blue-50)` | `#eff6ff` | Light tint background for highlighted rows or pills |
| `--hb-color-on-primary` | `var(--hb-color-white)` | `#FFFFFF` | Text and icons rendered atop primary background |

### 6. Status Roles
Status tokens communicate system feedback, health states, and transactional alerts:

| Status | Role Token | Primitive Reference | Resolved Default | Purpose |
| :--- | :--- | :--- | :--- | :--- |
| **Success** | `--hb-color-success` | `var(--hb-color-green-600)` | `#16a34a` | Confirmations, success alerts, valid inputs |
| | `--hb-color-success-subtle` | `var(--hb-color-green-50)` | `#f0fdf4` | Soft tint background for success callouts |
| | `--hb-color-on-success` | `var(--hb-color-black)` | `#000000` | Text/icons rendered on success background |
| **Warning** | `--hb-color-warning` | `var(--hb-color-yellow-600)` | `#ca8a04` | Non-blocking alerts, attention tags, caution |
| | `--hb-color-warning-subtle` | `var(--hb-color-yellow-50)` | `#fefce8` | Soft tint background for warning callouts |
| | `--hb-color-on-warning` | `var(--hb-color-black)` | `#000000` | Text/icons rendered on warning background |
| **Danger** | `--hb-color-danger` | `var(--hb-color-red-600)` | `#dc2626` | Errors, destructive actions, critical failures |
| | `--hb-color-danger-subtle` | `var(--hb-color-red-50)` | `#fef2f2` | Soft tint background for error callouts |
| | `--hb-color-on-danger` | `var(--hb-color-white)` | `#FFFFFF` | Text/icons rendered on danger background |
| **Info** | `--hb-color-info` | `var(--hb-color-blue-600)` | `#2563EB` | Informational announcements and system notes |
| | `--hb-color-info-subtle` | `var(--hb-color-blue-50)` | `#eff6ff` | Soft tint background for informational callouts |
| | `--hb-color-on-info` | `var(--hb-color-white)` | `#FFFFFF` | Text/icons rendered on info background |

### 7. Focus Indicator
Generic semantic focus ring token for accessible keyboard navigation:

| Token | Primitive Reference | Resolved Default | Description |
| :--- | :--- | :--- | :--- |
| `--hb-color-focus` | `var(--hb-color-blue-600)` | `#2563EB` | Universal outline color for `:focus-visible` elements |

### 8. Semantic Typography
Semantic font families for layout and content roles:

| Token | Primitive Reference | Resolved Value | Description |
| :--- | :--- | :--- | :--- |
| `--hb-font-family-body` | `var(--hb-font-family-sans)` | `"Outfit", system-ui, ...` | Default body copy and general interface controls |
| `--hb-font-family-heading` | `var(--hb-font-family-sans)` | `"Outfit", system-ui, ...` | Titles, section headers, and hero display |
| `--hb-font-family-code` | `var(--hb-font-family-mono)` | `ui-monospace, SFMono, ...` | Code blocks, inline snippets, and terminal output |

---

## 3. Accessibility & Contrast Verification (`on-*` Tokens)

HEBRING rigorously enforces WCAG 2.1 AA requirements (minimum **4.5:1** contrast ratio for normal text). The foreground `on-*` tokens were mathematically evaluated against their respective status background colors:

| Background Role | Background Hex | Contrast with White (`#FFFFFF`) | Contrast with Black (`#000000`) | Selected `on-*` Token | WCAG 2.1 AA Result |
| :--- | :--- | :--- | :--- | :--- | :--- |
| `--hb-color-primary` | `#2563EB` | **5.17:1** | 4.06:1 | `var(--hb-color-white)` | **Pass** (≥ 4.5:1) |
| `--hb-color-info` | `#2563EB` | **5.17:1** | 4.06:1 | `var(--hb-color-white)` | **Pass** (≥ 4.5:1) |
| `--hb-color-success` | `#16a34a` | 3.30:1 *(Fails AA)* | **6.37:1** | `var(--hb-color-black)` | **Pass** (≥ 4.5:1) |
| `--hb-color-warning` | `#ca8a04` | 2.94:1 *(Fails AA)* | **7.15:1** | `var(--hb-color-black)` | **Pass** (≥ 7.0:1, AAA) |
| `--hb-color-danger` | `#dc2626` | **4.83:1** | 4.35:1 | `var(--hb-color-white)` | **Pass** (≥ 4.5:1) |

### Contrast Rationale:
- **`--hb-color-on-success`**: White on Green-600 achieves only `3.30:1`, failing the 4.5:1 threshold for normal text. Black achieves **`6.37:1`**, easily satisfying WCAG AA.
- **`--hb-color-on-warning`**: White on Yellow-600 achieves only `2.94:1`. Black achieves **`7.15:1`**, satisfying both WCAG AA and AAA.
- **`--hb-color-on-danger`**: White on Red-600 achieves **`4.83:1`**, safely passing WCAG AA.
- **`--hb-color-on-primary` & `--hb-color-on-info`**: White on Blue-600 achieves **`5.17:1`**, safely passing WCAG AA.

---

## 4. Why Component-Specific Tokens Are Excluded

HEBRING explicitly avoids component-scoped tokens such as `--hb-button-bg`, `--hb-card-border`, or `--hb-input-padding`:

1. **Prevents Token Bloat**: Component tokens create hundreds of redundant aliases that simply point back to semantic tokens.
2. **Promotes Composition**: Components styled using semantic tokens (`--hb-color-surface`, `--hb-color-border`, `--hb-color-primary`) automatically share visual coherence across the system.
3. **Streamlines Theming**: In Phase 03.4, swapping semantic tokens cleanly re-themes every component in the framework without touching individual component files.

---

## 5. Further Documentation

- **[Theme Architecture](theme-architecture.md)**: `data-theme` activation, Light default behavior, and Dark overrides.
- **[Token Developer Usage Guide](token-usage.md)**: Best practices, practical component examples, and anti-patterns.
- **[Primitive Tokens Reference](primitive-tokens.md)**: Raw color palettes, 4px spacing scale, typography, radii, shadows, and motion values.
- **[Design Token Architecture](design-token-architecture.md)**: Source structure, composition boundaries, and import mechanics.

