#!/usr/bin/env bash

# HEBRING Theme Implementation Validation

echo "Validating Theme Implementation..."

SRC_DIR="src/tokens/themes"
THEME_CSS="$SRC_DIR/index.css"
MAIN_CSS="src/index.css"
TOKENS_INDEX="src/tokens/index.css"
SEMANTIC_CSS="src/tokens/semantic.css"
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

# 3. Check default theme contract (semantic tokens on :root)
check_grep "$SEMANTIC_CSS" ':root {'

# 4. Check theme selector
check_grep "$THEME_CSS" '\[data-theme="dark"\] {'

# 5. Check forbidden selectors and features
check_not_grep "$THEME_CSS" '\.dark'
check_not_grep "$THEME_CSS" '\[data-mode="dark"\]'
check_not_grep "$THEME_CSS" '\[data-theme="light"\]'
check_not_grep "$THEME_CSS" '@layer themes'
check_not_grep "$THEME_CSS" '!important'
check_not_grep "$THEME_CSS" '\.hb-button'

# 6. Check primitive token boundary (no primitive token overrides in theme)
# Primitive tokens like --hb-color-blue-500, --hb-color-neutral-950 etc should not be redefined
if grep -E '^\s*--hb-color-[a-z]+-[0-9]+:' "$THEME_CSS"; then
  echo "❌ ERROR: Found primitive token redefinition in theme."
  ((ERRORS++))
else
  echo "✅ No primitive token redefinitions in theme."
fi
check_not_grep "$THEME_CSS" '--hb-color-white:'
check_not_grep "$THEME_CSS" '--hb-color-black:'

# 7. Check token naming (no variables lacking --hb- prefix)
if grep -E '^\s*--[a-zA-Z0-9-]+:' "$THEME_CSS" | grep -vE '^\s*--hb-'; then
  echo "❌ ERROR: Found CSS custom properties without --hb- prefix."
  ((ERRORS++))
else
  echo "✅ All theme custom properties use --hb- prefix."
fi

# 8. Check semantic overrides
check_grep "$THEME_CSS" '--hb-color-background: var(--hb-color-neutral-950);'
check_grep "$THEME_CSS" '--hb-color-primary: var(--hb-color-blue-500);'
check_grep "$THEME_CSS" '--hb-color-danger: var(--hb-color-red-500);'

# 9. Check that typography is stable (no font-family overrides)
check_not_grep "$THEME_CSS" '--hb-font-family'

# 10. Verify components didn't add theme selectors
check_not_grep "$COMPONENTS_CSS" '\[data-theme="dark"\]'
check_not_grep "$UTILITIES_CSS" '\[data-theme="dark"\]'

# 11. No Javascript files in themes
if ls "$SRC_DIR"/*.js >/dev/null 2>&1; then
  echo "❌ ERROR: Found JavaScript files in theme directory."
  ((ERRORS++))
else
  echo "✅ No JavaScript files in theme directory."
fi

if [ $ERRORS -eq 0 ]; then
  echo "✅ All theme implementation tests passed."
  exit 0
else
  echo "❌ $ERRORS theme test(s) failed."
  exit 1
fi
