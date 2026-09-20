#!/usr/bin/env bash

# HEBRING Theme Implementation Validation

echo "Validating Theme Implementation..."

SRC_DIR="src/tokens/themes"
THEME_CSS="$SRC_DIR/index.css"
MAIN_CSS="src/index.css"
TOKENS_INDEX="src/tokens/index.css"
COMPONENTS_CSS="src/components/button.css"
UTILITIES_CSS="src/utilities/display.css"

ERRORS=0

function check_file() {
  if [ ! -f "$1" ]; then
    echo "❌ ERROR: $1 not found."
    ((ERRORS++))
  else
    echo "✅ Found $1"
  fi
}

function check_grep() {
  if grep -q -e "$2" "$1"; then
    echo "✅ Found '$2' in $1"
  else
    echo "❌ ERROR: Missing '$2' in $1"
    ((ERRORS++))
  fi
}

function check_not_grep() {
  if grep -q -e "$2" "$1"; then
    echo "❌ ERROR: Found forbidden '$2' in $1"
    ((ERRORS++))
  else
    echo "✅ No '$2' in $1"
  fi
}

# 1. Check file existence
check_file "$THEME_CSS"

# 2. Check architecture imports
check_grep "$TOKENS_INDEX" '@import "./themes/index.css";'

# 3. Check theme selector
check_grep "$THEME_CSS" '\[data-theme="dark"\] {'

# 4. Check forbidden selectors and features
check_not_grep "$THEME_CSS" '\.dark'
check_not_grep "$THEME_CSS" '\[data-mode="dark"\]'
check_not_grep "$THEME_CSS" '\[data-theme="light"\]'
check_not_grep "$THEME_CSS" '@layer themes'
check_not_grep "$THEME_CSS" '!important'
check_not_grep "$THEME_CSS" '\.hb-button'

# 5. Check semantic overrides
check_grep "$THEME_CSS" '--hb-color-background: var(--hb-color-neutral-950);'
check_grep "$THEME_CSS" '--hb-color-primary: var(--hb-color-blue-500);'
check_grep "$THEME_CSS" '--hb-color-danger: var(--hb-color-red-500);'

# 6. Check that typography is stable (no font-family overrides)
check_not_grep "$THEME_CSS" '--hb-font-family'

# 7. Verify components didn't add theme selectors
check_not_grep "$COMPONENTS_CSS" '\[data-theme="dark"\]'
check_not_grep "$UTILITIES_CSS" '\[data-theme="dark"\]'

if [ $ERRORS -eq 0 ]; then
  echo "✅ All theme implementation tests passed."
  exit 0
else
  echo "❌ $ERRORS theme test(s) failed."
  exit 1
fi
