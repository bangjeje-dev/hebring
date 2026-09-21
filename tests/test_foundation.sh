#!/usr/bin/env bash
set -e

echo "Running Foundation Tests..."

DIST_CSS="dist/hebring.css"
SRC_RESET="src/foundation/reset.css"
SRC_BASE="src/foundation/base.css"

if [ ! -f "$DIST_CSS" ]; then
  echo "FAIL: dist/hebring.css not found. Please run build first."
  exit 1
fi

ERRORS=0

function check_grep() {
  if grep -q -E -e "$2" "$1"; then
    echo "PASS: $3"
  else
    echo "FAIL: $3 (Expected to find '$2' in $1)"
    ((ERRORS++))
  fi
}

function check_not_grep() {
  if grep -q -E -e "$2" "$1"; then
    echo "FAIL: $3 (Found forbidden '$2' in $1)"
    ((ERRORS++))
  else
    echo "PASS: $3"
  fi
}

# 1. Reset Tests
check_grep "$SRC_RESET" "box-sizing: border-box" "Reset applies border-box universally"
check_grep "$SRC_RESET" "margin: 0" "Reset eliminates body margin"
check_grep "$SRC_RESET" "max-width: 100%" "Reset contains media elements while preserving aspect ratio"
check_grep "$SRC_RESET" "height: auto" "Reset applies height: auto to media elements"

check_not_grep "$SRC_RESET" "outline:" "Reset preserves focus outlines (accessibility contract)"
check_not_grep "$SRC_RESET" "list-style: none" "Reset preserves native list semantics (accessibility contract)"

# 2. Browser Normalization Tests
check_grep "$SRC_RESET" "-webkit-text-size-adjust: 100%" "Normalization handles webkit text-size-adjust"
check_grep "$SRC_RESET" "text-size-adjust: 100%" "Normalization handles standard text-size-adjust"

# 3. Typography Tests
check_grep "$SRC_BASE" "font-family: var\(--hb-font-family-body\)" "Body uses semantic font-family token"
check_grep "$SRC_BASE" "font-size: var\(--hb-font-size-md\)" "Body uses semantic font-size token"
check_grep "$SRC_BASE" "line-height: var\(--hb-line-height-normal\)" "Body uses semantic line-height token"
check_grep "$SRC_BASE" "font-family: var\(--hb-font-family-heading\)" "Headings use semantic font-family token"
check_grep "$SRC_BASE" "^ *h1 *\{" "Heading hierarchy h1 is defined"
check_grep "$SRC_BASE" "^ *h6 *\{" "Heading hierarchy h6 is defined"
check_grep "$SRC_BASE" "^ *a *\{" "Hyperlinks are styled"
check_grep "$SRC_BASE" "^ *a:hover *\{" "Hyperlink hover states are defined"
check_grep "$SRC_BASE" "font-family: var\(--hb-font-family-code\)" "Code blocks use monospace semantic token"
check_grep "$SRC_BASE" "background-color: var\(--hb-color-warning-subtle\)" "Mark uses semantic warning background token"

# 4. Forms Tests
check_grep "$SRC_BASE" "font: inherit" "Form controls inherit font"
check_grep "$SRC_BASE" "line-height: inherit" "Form controls inherit line-height"
check_grep "$SRC_BASE" "min-width: 0" "Fieldset min-width is normalized"

# 5. Cascade Layer Contract
check_grep "$SRC_RESET" "@layer reset" "Reset CSS wrapped in @layer reset"
check_grep "$SRC_BASE" "@layer base" "Base CSS wrapped in @layer base"
check_not_grep "$DIST_CSS" "@layer foundation" "No @layer foundation exists"
check_not_grep "$SRC_RESET" "@layer responsive" "No @layer responsive inside Reset"
check_not_grep "$SRC_BASE" "@layer responsive" "No @layer responsive inside Base"

# 6. Token Usage Restrictions
check_not_grep "$SRC_BASE" "#[0-9a-fA-F]" "Base layer contains no hardcoded hex colors"

if [ $ERRORS -eq 0 ]; then
  echo "All Foundation tests passed!"
  exit 0
else
  echo "$ERRORS Foundation test(s) failed."
  exit 1
fi
