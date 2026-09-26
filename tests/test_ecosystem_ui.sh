#!/bin/bash
set -e

# ============================================================
# Ecosystem UI Validation Script
# ============================================================
echo "Validating Ecosystem UI Boundary Contract..."

UI_DIR="ecosystem/ui"
INDEX_CSS="src/index.css"
DIST_CSS="dist/hebring.css"
PRIMITIVES="src/tokens/primitives.css"

fail() {
  echo "FAIL: $1"
  exit 1
}

pass() {
  echo "PASS: $1"
}

# 1. Existence
if [ ! -d "$UI_DIR" ]; then
  fail "Ecosystem UI directory missing: $UI_DIR"
fi

if [ -z "$(ls -A "$UI_DIR"/*.css 2>/dev/null)" ]; then
  fail "No CSS files found in $UI_DIR"
fi

if [ ! -f "$UI_DIR/modal.css" ]; then
  fail "Reference modal.css missing"
fi
pass "Ecosystem UI CSS exists"

# 2. Check for JS, script, !important, external resources
for file in "$UI_DIR"/*.css; do
  if grep -q "@import" "$file"; then
    fail "$file contains @import"
  fi
  if grep -q "<script" "$file"; then
    fail "$file contains <script>"
  fi
  if grep -qi "data:" "$file"; then
    fail "$file contains data: URIs"
  fi
  if grep -q "!important" "$file"; then
    fail "$file contains !important"
  fi
done
pass "No invalid imports, scripts, or !important"

# 3. Verify no primitive tokens redefined
# Extract primitive token names from primitives.css
if [ ! -f "$PRIMITIVES" ]; then
  fail "Primitives file missing"
fi

while IFS= read -r line; do
  if [[ "$line" =~ ^\s*(--hb-[a-zA-Z0-9-]+): ]]; then
    token="${BASH_REMATCH[1]}"
    for file in "$UI_DIR"/*.css; do
      if grep -Eq "^\s*$token:" "$file"; then
         fail "$file redefines primitive token $token"
      fi
    done
  fi
done < "$PRIMITIVES"
pass "UI CSS does NOT redefine primitive tokens"

# 4. Verify semantic tokens are used when using --hb-*
for file in "$UI_DIR"/*.css; do
  if grep -Eq "var\(--hb-[^\)]+\)" "$file"; then
    pass "UI CSS uses existing tokens"
  fi
  # Verify no primitive tokens are directly used via var()
  while IFS= read -r line; do
    if [[ "$line" =~ ^\s*(--hb-[a-zA-Z0-9-]+): ]]; then
      token="${BASH_REMATCH[1]}"
      if grep -Eq "var\($token\)" "$file"; then
         fail "$file consumes primitive token directly: $token"
      fi
    fi
  done < "$PRIMITIVES"
done
pass "UI CSS only consumes semantic tokens"

# 5. Verify no new --hb-* tokens are defined
for file in "$UI_DIR"/*.css; do
  while IFS= read -r line; do
    if [[ "$line" =~ ^\s*(--hb-[a-zA-Z0-9-]+): ]]; then
       token="${BASH_REMATCH[1]}"
       fail "$file defines new token $token"
    fi
  done < "$file"
done
pass "UI CSS does not introduce new --hb-* tokens"

# 6. Reject obvious component contamination
for file in "$UI_DIR"/*.css; do
  if grep -Eq "\.hb-(button|card|badge|alert|input)\b" "$file"; then
    fail "$file contains Core component selectors (.hb-button, .hb-card, etc)"
  fi
done
pass "No Core component contamination"

# 7. Core isolation
if [ -f "$DIST_CSS" ]; then
  if grep -q "\.hb-modal" "$DIST_CSS"; then
    fail "modal.css leaked into dist/hebring.css"
  fi
fi

if grep -q "ecosystem/ui" "$INDEX_CSS"; then
  fail "src/index.css imports from ecosystem/ui"
fi
pass "Core build is isolated from Ecosystem UI"

# 8. Package export
if ! grep -q "\"./ui/\*\": \"./ecosystem/ui/\*\"" package.json; then
  fail "package.json missing ./ui/* export"
fi
pass "package.json contains ./ui/* export"

# 9. Modal Reference Specifics
if [ -f "$UI_DIR/modal.css" ]; then
  if ! grep -q "dialog.hb-modal" "$UI_DIR/modal.css"; then
    fail "modal.css is missing native dialog reference (dialog.hb-modal)"
  fi
  if ! grep -q "dialog.hb-modal\[open\]" "$UI_DIR/modal.css"; then
    fail "modal.css is missing [open] state"
  fi
  if ! grep -q "dialog.hb-modal::backdrop" "$UI_DIR/modal.css"; then
    fail "modal.css is missing ::backdrop"
  fi
  if grep -q "\.is-open" "$UI_DIR/modal.css"; then
    fail "modal.css should not use .is-open"
  fi
  if grep -q "data-state=\"open\"" "$UI_DIR/modal.css"; then
    fail "modal.css should not use data-state=\"open\" for native dialog"
  fi
  if grep -q "100vw" "$UI_DIR/modal.css"; then
    fail "modal.css should not assume 100vw overlay"
  fi
  if grep -q "100vh" "$UI_DIR/modal.css"; then
    fail "modal.css should not assume 100vh overlay"
  fi
  if grep -q "z-index: 50" "$UI_DIR/modal.css"; then
    fail "modal.css should not hardcode z-index: 50"
  fi
  if grep -q "position: fixed" "$UI_DIR/modal.css"; then
    fail "modal.css should not hardcode position: fixed on the dialog itself"
  fi
  pass "Modal CSS respects native state and dialog layout"
fi

# 10. Drawer Reference Specifics
if [ -f "$UI_DIR/drawer.css" ]; then
  if ! grep -q "dialog.hb-drawer" "$UI_DIR/drawer.css"; then
    fail "drawer.css is missing native dialog reference (dialog.hb-drawer)"
  fi
  if ! grep -q "dialog.hb-drawer\[open\]" "$UI_DIR/drawer.css"; then
    fail "drawer.css is missing [open] state"
  fi
  if ! grep -q "dialog.hb-drawer::backdrop" "$UI_DIR/drawer.css"; then
    fail "drawer.css is missing ::backdrop"
  fi
  pass "Drawer CSS respects native state and dialog layout"
else
  fail "drawer.css is missing"
fi

# 11. Accordion Reference Specifics
if [ -f "$UI_DIR/accordion.css" ]; then
  if ! grep -q "details.hb-accordion" "$UI_DIR/accordion.css"; then
    fail "accordion.css is missing native details reference (details.hb-accordion)"
  fi
  if ! grep -q "\.hb-accordion__trigger" "$UI_DIR/accordion.css"; then
    fail "accordion.css is missing trigger reference (.hb-accordion__trigger)"
  fi
  pass "Accordion CSS respects native state and details layout"
else
  fail "accordion.css is missing"
fi

# 12. Breadcrumbs Reference Specifics
if [ -f "$UI_DIR/breadcrumbs.css" ]; then
  if ! grep -q "nav.hb-breadcrumbs" "$UI_DIR/breadcrumbs.css"; then
    fail "breadcrumbs.css is missing nav reference (nav.hb-breadcrumbs)"
  fi
  if ! grep -q "\.hb-breadcrumbs__list" "$UI_DIR/breadcrumbs.css"; then
    fail "breadcrumbs.css is missing list reference (.hb-breadcrumbs__list)"
  fi
  pass "Breadcrumbs CSS respects semantic structure"
else
  fail "breadcrumbs.css is missing"
fi

# 13. Pagination Reference Specifics
if [ -f "$UI_DIR/pagination.css" ]; then
  if ! grep -q "nav.hb-pagination" "$UI_DIR/pagination.css"; then
    fail "pagination.css is missing nav reference (nav.hb-pagination)"
  fi
  if ! grep -q "\.hb-pagination__link\[aria-current=\"page\"\]" "$UI_DIR/pagination.css"; then
    fail "pagination.css is missing aria-current=\"page\" reference"
  fi
  pass "Pagination CSS respects semantic structure"
else
  fail "pagination.css is missing"
fi

# 14. Stepper Reference Specifics
if [ -f "$UI_DIR/stepper.css" ]; then
  if ! grep -q "ol.hb-stepper" "$UI_DIR/stepper.css"; then
    fail "stepper.css is missing ol reference (ol.hb-stepper)"
  fi
  if ! grep -q "\.hb-stepper__item\[aria-current=\"step\"\]" "$UI_DIR/stepper.css"; then
    fail "stepper.css is missing aria-current=\"step\" reference"
  fi
  pass "Stepper CSS respects semantic structure"
else
  fail "stepper.css is missing"
fi

# 15. Popover Reference Specifics
if [ -f "$UI_DIR/popover.css" ]; then
  if ! grep -q "\.hb-popover" "$UI_DIR/popover.css"; then
    fail "popover.css is missing .hb-popover"
  fi
  if ! grep -q ":popover-open" "$UI_DIR/popover.css"; then
    fail "popover.css is missing :popover-open state"
  fi
  if grep -q "\.is-open" "$UI_DIR/popover.css" || grep -q "\.is-visible" "$UI_DIR/popover.css"; then
    fail "popover.css uses fake state system instead of native popover state"
  fi
  pass "Popover CSS respects native Popover API"
else
  fail "popover.css is missing"
fi

# 16. Menu Reference Specifics
if [ -f "$UI_DIR/menu.css" ]; then
  if ! grep -q "\.hb-menu" "$UI_DIR/menu.css"; then
    fail "menu.css is missing .hb-menu"
  fi
  if ! grep -q "\.hb-menu__item" "$UI_DIR/menu.css"; then
    fail "menu.css is missing .hb-menu__item"
  fi
  if ! grep -q "\.hb-menu__item:disabled" "$UI_DIR/menu.css"; then
    fail "menu.css is missing native disabled state for items"
  fi
  if ! grep -q "\.hb-menu__separator" "$UI_DIR/menu.css"; then
    fail "menu.css is missing .hb-menu__separator"
  fi
  if ! grep -q "\.hb-menu__label" "$UI_DIR/menu.css"; then
    fail "menu.css is missing .hb-menu__label"
  fi
  if grep -q "\.is-open" "$UI_DIR/menu.css" || grep -q "popover" "$UI_DIR/menu.css"; then
    fail "menu.css contains unauthorized state/popover logic"
  fi
  pass "Menu CSS respects pure styling foundation"
else
  fail "menu.css is missing"
fi

# 17. Tooltip Reference Specifics
if [ -f "$UI_DIR/tooltip.css" ]; then
  if ! grep -q "\.hb-tooltip" "$UI_DIR/tooltip.css"; then
    fail "tooltip.css is missing .hb-tooltip"
  fi
  if grep -q "\.is-open" "$UI_DIR/tooltip.css" || grep -q "\.is-visible" "$UI_DIR/tooltip.css"; then
    fail "tooltip.css contains unauthorized state logic"
  fi
  if grep -q "popover" "$UI_DIR/tooltip.css"; then
    fail "tooltip.css must not depend on popover logic"
  fi
  pass "Tooltip CSS respects pure non-interactive foundation"
else
  fail "tooltip.css is missing"
fi

# 18. Dropdown Menu Composition
if [ -f "$UI_DIR/dropdown.css" ] || [ -f "$UI_DIR/dropdown-menu.css" ]; then
  fail "Dropdown Menu must be a composition, not a new CSS primitive file"
fi

if ! grep -q 'id="dropdown-trigger"' "$ROOT_DIR/examples/playground/index.html"; then
  fail "Playground is missing dropdown trigger"
fi

if ! grep -q 'popovertarget="demo-dropdown"' "$ROOT_DIR/examples/playground/index.html"; then
  fail "Playground dropdown trigger missing popovertarget"
fi

if ! grep -q 'aria-haspopup="menu"' "$ROOT_DIR/examples/playground/index.html"; then
  fail "Playground dropdown trigger missing aria-haspopup=\"menu\""
fi

if ! grep -q 'DROPDOWN MENU ADAPTER' "$ROOT_DIR/examples/playground/index.html"; then
  fail "Playground is missing DROPDOWN MENU ADAPTER"
fi

pass "Dropdown Menu composition respects pure architecture"

# 19. Context Menu Composition
if [ -f "$UI_DIR/context-menu.css" ] || [ -f "$UI_DIR/contextmenu.css" ]; then
  fail "Context Menu must be a composition, not a new CSS primitive file"
fi

if ! grep -q 'id="context-menu-target"' "$ROOT_DIR/examples/playground/index.html"; then
  fail "Playground is missing context-menu-target"
fi

if ! grep -q 'CONTEXT MENU ADAPTER' "$ROOT_DIR/examples/playground/index.html"; then
  fail "Playground is missing CONTEXT MENU ADAPTER"
fi

if ! grep -q 'contextmenu' "$ROOT_DIR/examples/playground/index.html"; then
  fail "Playground is missing contextmenu event listener"
fi

if ! grep -q 'clientX' "$ROOT_DIR/examples/playground/index.html"; then
  fail "Playground is missing clientX coordinate logic"
fi

pass "Context Menu composition respects pure architecture"

# 20. Tabs Validation
if [ ! -f "$UI_DIR/tabs.css" ]; then
  fail "tabs.css is missing"
fi

if grep -q '\.is-active' "$UI_DIR/tabs.css" || grep -q '\.is-selected' "$UI_DIR/tabs.css" || grep -q '\.is-open' "$UI_DIR/tabs.css"; then
  fail "Tabs CSS must not use custom .is-* state classes"
fi

if ! grep -q '\[aria-selected="true"\]' "$UI_DIR/tabs.css"; then
  fail "Tabs CSS must style based on aria-selected"
fi

if ! grep -q 'role="tablist"' "$ROOT_DIR/examples/playground/index.html"; then
  fail "Playground is missing tablist role"
fi

if ! grep -q 'role="tabpanel"' "$ROOT_DIR/examples/playground/index.html"; then
  fail "Playground is missing tabpanel role"
fi

if ! grep -q 'TABS ADAPTER' "$ROOT_DIR/examples/playground/index.html"; then
  fail "Playground is missing TABS ADAPTER"
fi

pass "Tabs architecture respects pure constraints"

# 21. Accordion Validation
if [ ! -f "$UI_DIR/accordion.css" ]; then
  fail "accordion.css is missing"
fi

if grep -q '\.is-open' "$UI_DIR/accordion.css" || grep -q '\.is-active' "$UI_DIR/accordion.css" || grep -q 'data-state' "$UI_DIR/accordion.css"; then
  fail "Accordion CSS must not use custom state classes"
fi

if ! grep -q 'details' "$UI_DIR/accordion.css" || ! grep -q 'summary' "$UI_DIR/accordion.css"; then
  fail "Accordion CSS must target native details/summary elements"
fi

if ! grep -q 'name="demo-exclusive"' "$ROOT_DIR/examples/playground/index.html"; then
  fail "Playground is missing details name grouping for single-open accordion"
fi

if ! grep -q 'ACCORDION SINGLE-OPEN ADAPTER' "$ROOT_DIR/examples/playground/index.html"; then
  fail "Playground is missing ACCORDION SINGLE-OPEN ADAPTER"
fi

pass "Accordion architecture respects pure native constraints"

# 22. Combobox Validation
if [ ! -f "$UI_DIR/combobox.css" ]; then
  fail "combobox.css is missing"
fi

if grep -q '\.is-open' "$UI_DIR/combobox.css" || grep -q '\.is-active' "$UI_DIR/combobox.css" || grep -q '\.is-selected' "$UI_DIR/combobox.css" || grep -q '\.is-highlighted' "$UI_DIR/combobox.css"; then
  fail "Combobox CSS must not use custom state classes"
fi

if grep -q 'role="menu"' "$UI_DIR/combobox.css" || grep -q 'role="menuitem"' "$UI_DIR/combobox.css"; then
  fail "Combobox CSS must not use menu semantics"
fi

if ! grep -q 'role="combobox"' "$ROOT_DIR/examples/playground/index.html" || ! grep -q 'role="listbox"' "$ROOT_DIR/examples/playground/index.html" || ! grep -q 'role="option"' "$ROOT_DIR/examples/playground/index.html"; then
  fail "Playground is missing combobox semantic roles"
fi

if ! grep -q 'COMBOBOX ADAPTER' "$ROOT_DIR/examples/playground/index.html"; then
  fail "Playground is missing COMBOBOX ADAPTER"
fi

pass "Combobox architecture respects pure native constraints"

echo "All Ecosystem UI tests passed!"
