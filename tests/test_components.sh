#!/bin/bash

# Exit on any error
set -e

# Configuration
DIST_CSS="dist/hebring.css"
SRC_COMPONENTS="src/components"
ERRORS=0

echo "Running Component Tests..."

# Helper function to assert grep finds a match
check_grep() {
  local file=$1
  local pattern=$2
  local message=$3
  if grep -qE "$pattern" "$file"; then
    echo "PASS: $message"
  else
    echo "FAIL: $message (Pattern '$pattern' not found in $file)"
    ERRORS=$((ERRORS + 1))
  fi
}

# Helper function to assert grep does NOT find a match
check_not_grep() {
  local file=$1
  local pattern=$2
  local message=$3
  if grep -qE "$pattern" "$file"; then
    echo "FAIL: $message (Pattern '$pattern' unexpectedly found in $file)"
    ERRORS=$((ERRORS + 1))
  else
    echo "PASS: $message"
  fi
}

# 1. Component API Inventory
check_grep "$SRC_COMPONENTS/button.css" "^\s*\.hb-button\s*\{" "Button: base .hb-button selector exists"
check_grep "$SRC_COMPONENTS/button.css" "\.hb-button--secondary" "Button: --secondary modifier exists"
check_grep "$SRC_COMPONENTS/button.css" "\.hb-button--danger" "Button: --danger modifier exists"
check_grep "$SRC_COMPONENTS/button.css" "\.hb-button--sm" "Button: --sm modifier exists"
check_grep "$SRC_COMPONENTS/button.css" "\.hb-button--lg" "Button: --lg modifier exists"

check_not_grep "$SRC_COMPONENTS/button.css" "\.hb-button--(primary|success|warning|icon|block|outline|ghost)" "Button: does not invent undocumented modifiers"

# 2. State Contract
check_grep "$SRC_COMPONENTS/button.css" "\.hb-button:hover" "Button: :hover state exists"
check_grep "$SRC_COMPONENTS/button.css" "\.hb-button:focus-visible" "Button: :focus-visible state exists"
check_grep "$SRC_COMPONENTS/button.css" "\.hb-button:active" "Button: :active state exists"
check_grep "$SRC_COMPONENTS/button.css" "\.hb-button:disabled" "Button: :disabled state exists"
check_grep "$SRC_COMPONENTS/button.css" "\.hb-button\.is-loading" "Button: .is-loading state exists"

check_not_grep "$SRC_COMPONENTS/button.css" "\.is-loading.*::after.*spinner" "Button: does not invent a CSS spinner for loading"
check_not_grep "$SRC_COMPONENTS/button.css" "aria-busy" "Button: does not rely on javascript attributes like aria-busy in core CSS"

# 3. Base Button Contract (Visual/Structural)
check_grep "$SRC_COMPONENTS/button.css" "display:\s*inline-flex" "Button: inline-flex display"
check_grep "$SRC_COMPONENTS/button.css" "align-items:\s*center" "Button: center alignment"
check_grep "$SRC_COMPONENTS/button.css" "cursor:\s*pointer" "Button: pointer cursor"
check_grep "$SRC_COMPONENTS/button.css" "text-decoration:\s*none" "Button: removes underline"
check_grep "$SRC_COMPONENTS/button.css" "transition:" "Button: implements transition"

# 4. Component Token Boundary
check_grep "$SRC_COMPONENTS/button.css" "-e --hb-button-bg:" "Button: uses component-local token for background"
check_grep "$SRC_COMPONENTS/button.css" "-e --hb-button-padding-y:" "Button: uses component-local token for padding"
check_grep "$SRC_COMPONENTS/button.css" "background-color:\s*var\(--hb-button-bg\)" "Button: consumes component-local tokens"

check_not_grep "$SRC_COMPONENTS/button.css" "background-color:\s*var\(--hb-color-primary\)" "Button: does not consume global tokens directly for modifiable properties"

# 5. Accessibility-Sensitive Rules
check_grep "$SRC_COMPONENTS/button.css" "outline:\s*2px\s*solid\s*transparent" "Button: preserves focus-visible structure via transparent outline"
check_grep "$SRC_COMPONENTS/button.css" "box-shadow:.*var\(--hb-button-focus-ring\)" "Button: implements visible focus ring via box-shadow"
check_grep "$SRC_COMPONENTS/button.css" "cursor:\s*not-allowed" "Button: disabled state implies not-allowed cursor"

# 6. Cascade Layer
check_grep "$SRC_COMPONENTS/button.css" "@layer components \{" "Button: wrapped in @layer components"
check_not_grep "$SRC_COMPONENTS/button.css" "@layer buttons|@layer responsive|@layer themes|@layer utilities" "Button: no invalid cascade layers used"

# 7. Component Independence
check_not_grep "$SRC_COMPONENTS/button.css" "\.hb-stack|\.hb-container|\.hb-text-center" "Button: does not rely on or import Layout or Utility CSS"

# 8. Utility Override Contract
check_not_grep "$SRC_COMPONENTS/button.css" "\!important" "Button: no !important used"

# 9. Responsive Boundary
check_not_grep "$SRC_COMPONENTS/button.css" "\.hb-button-sm|\.hb-button-md|\.hb-button-lg|\.hb-button--.*-(sm|md|lg)" "Button: no responsive component modifiers"
check_not_grep "$SRC_COMPONENTS/button.css" "@media" "Button: no internal media queries"

# 10. Card Tests
check_grep "$SRC_COMPONENTS/card.css" "^\s*\.hb-card\s*\{" "Card: class exists"
check_grep "$SRC_COMPONENTS/card.css" "\.hb-card__header" "Card: header element exists"
check_grep "$SRC_COMPONENTS/card.css" "\.hb-card__body" "Card: body element exists"
check_grep "$SRC_COMPONENTS/card.css" "\.hb-card__footer" "Card: footer element exists"
check_grep "$SRC_COMPONENTS/card.css" "var\(--hb-color-surface\)" "Card: uses semantic tokens"
check_grep "$SRC_COMPONENTS/card.css" "@layer components" "Card: exists in correct CSS layer"
check_not_grep "$SRC_COMPONENTS/card.css" "\.is-|\.has-" "Card: no JavaScript dependency"

# 11. Badge Tests
check_grep "$SRC_COMPONENTS/badge.css" "^\s*\.hb-badge\s*\{" "Badge: class exists"
check_grep "$SRC_COMPONENTS/badge.css" "\.hb-badge--primary" "Badge: primary variant exists"
check_grep "$SRC_COMPONENTS/badge.css" "\.hb-badge--success" "Badge: success variant exists"
check_grep "$SRC_COMPONENTS/badge.css" "\.hb-badge--warning" "Badge: warning variant exists"
check_grep "$SRC_COMPONENTS/badge.css" "\.hb-badge--danger" "Badge: danger variant exists"
check_grep "$SRC_COMPONENTS/badge.css" "var\(--hb-color-surface-muted\)" "Badge: uses semantic tokens"
check_grep "$SRC_COMPONENTS/badge.css" "@layer components" "Badge: exists in correct CSS layer"
check_not_grep "$SRC_COMPONENTS/badge.css" "\.is-|\.has-" "Badge: no JavaScript dependency"

# 12. Alert Tests
check_grep "$SRC_COMPONENTS/alert.css" "^\s*\.hb-alert\s*\{" "Alert: class exists"
check_grep "$SRC_COMPONENTS/alert.css" "\.hb-alert--info" "Alert: info variant exists"
check_grep "$SRC_COMPONENTS/alert.css" "\.hb-alert--success" "Alert: success variant exists"
check_grep "$SRC_COMPONENTS/alert.css" "\.hb-alert--warning" "Alert: warning variant exists"
check_grep "$SRC_COMPONENTS/alert.css" "\.hb-alert--danger" "Alert: danger variant exists"
check_grep "$SRC_COMPONENTS/alert.css" "var\(--hb-color-surface-muted\)" "Alert: uses semantic tokens"
check_grep "$SRC_COMPONENTS/alert.css" "@layer components" "Alert: exists in correct CSS layer"
check_not_grep "$SRC_COMPONENTS/alert.css" "\.is-|\.has-" "Alert: no JavaScript dependency"

# 13. Form Tests
check_grep "$SRC_COMPONENTS/form.css" "\.hb-label" "Form: hb-label exists"
check_grep "$SRC_COMPONENTS/form.css" "\.hb-input" "Form: hb-input exists"
check_grep "$SRC_COMPONENTS/form.css" "\.hb-select" "Form: hb-select exists"
check_grep "$SRC_COMPONENTS/form.css" "\.hb-textarea" "Form: hb-textarea exists"
check_grep "$SRC_COMPONENTS/form.css" "\.hb-checkbox" "Form: hb-checkbox exists"
check_grep "$SRC_COMPONENTS/form.css" "\.hb-radio" "Form: hb-radio exists"
check_grep "$SRC_COMPONENTS/form.css" ":focus-visible" "Form: :focus-visible states handled"
check_grep "$SRC_COMPONENTS/form.css" ":invalid" "Form: :invalid state handled"
check_grep "$SRC_COMPONENTS/form.css" "\[aria-invalid=\"true\"\]" "Form: aria-invalid handled"
check_grep "$SRC_COMPONENTS/form.css" ":disabled" "Form: :disabled state handled"
check_grep "$SRC_COMPONENTS/form.css" "\.is-invalid" "Form: .is-invalid utility class handled"
check_not_grep "$SRC_COMPONENTS/form.css" "data:image/svg\+xml" "Form: does not use hardcoded SVG data URIs"
check_not_grep "$SRC_COMPONENTS/form.css" "stroke=|fill=|#[0-9a-fA-F]{3,6}\b|rgb\(|rgba\(" "Form: does not use hardcoded color literals"

if [ $ERRORS -eq 0 ]; then
  echo "All Component tests passed!"
  exit 0
else
  echo "$ERRORS Component test(s) failed."
  exit 1
fi
