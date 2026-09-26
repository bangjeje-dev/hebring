#!/usr/bin/env bash
set -e

echo "Running Token Tests..."

TOKENS_DIR="src/tokens"
PRIMITIVES="$TOKENS_DIR/primitives.css"
SEMANTIC="$TOKENS_DIR/semantic.css"
THEMES="$TOKENS_DIR/themes/index.css"

ERRORS=0

function check_file() {
  if [ ! -f "$1" ]; then
    echo "FAIL: $1 not found."
    ((ERRORS++))
  else
    echo "PASS: Found $1"
  fi
}

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

# Ensure files exist
check_file "$PRIMITIVES"
check_file "$SEMANTIC"
check_file "$THEMES"

# 1. Primitive Token Architecture
check_grep "$PRIMITIVES" "--hb-color-white: #FFFFFF;" "Primitive Token: white exists and is #FFFFFF"
check_grep "$PRIMITIVES" "--hb-color-black: #000000;" "Primitive Token: black exists and is #000000"
check_grep "$PRIMITIVES" "--hb-color-blue-600: #2563EB;" "Primitive Token: blue-600 exists and is #2563EB"
check_grep "$PRIMITIVES" "--hb-space-4: 16px;" "Primitive Token: space-4 exists and is 16px"
check_grep "$PRIMITIVES" "--hb-font-size-" "Primitive Token: font-size scale exists"
check_grep "$PRIMITIVES" "--hb-font-weight-" "Primitive Token: font-weight scale exists"
check_grep "$PRIMITIVES" "--hb-line-height-" "Primitive Token: line-height scale exists"
check_grep "$PRIMITIVES" "--hb-radius-" "Primitive Token: radius scale exists"
check_grep "$PRIMITIVES" "--hb-shadow-" "Primitive Token: shadow scale exists"
check_grep "$PRIMITIVES" "--hb-duration-" "Primitive Token: motion duration scale exists"

# 2. Semantic Token Architecture & Primitive -> Semantic mapping
check_grep "$SEMANTIC" "--hb-color-background: var\(--hb-color-white\);" "Semantic Token: background maps to white"
check_grep "$SEMANTIC" "--hb-color-surface: var\(--hb-color-white\);" "Semantic Token: surface maps to white"
check_grep "$SEMANTIC" "--hb-color-text: var\(--hb-color-neutral-900\);" "Semantic Token: text maps to neutral-900"
check_grep "$SEMANTIC" "--hb-color-border: var\(--hb-color-neutral-200\);" "Semantic Token: border maps to neutral-200"
check_grep "$SEMANTIC" "--hb-color-primary: var\(--hb-color-blue-600\);" "Semantic Token: primary maps to blue-600"
check_grep "$SEMANTIC" "--hb-color-success: var\(--hb-color-green-600\);" "Semantic Token: success maps to green-600"
check_grep "$SEMANTIC" "--hb-color-success-hover: var\(--hb-color-green-700\);" "Semantic Token: success-hover maps to green-700"
check_grep "$SEMANTIC" "--hb-color-success-active: var\(--hb-color-green-800\);" "Semantic Token: success-active maps to green-800"
check_grep "$SEMANTIC" "--hb-color-warning: var\(--hb-color-yellow-600\);" "Semantic Token: warning maps to yellow-600"
check_grep "$SEMANTIC" "--hb-color-warning-hover: var\(--hb-color-yellow-700\);" "Semantic Token: warning-hover maps to yellow-700"
check_grep "$SEMANTIC" "--hb-color-warning-active: var\(--hb-color-yellow-800\);" "Semantic Token: warning-active maps to yellow-800"
check_grep "$SEMANTIC" "--hb-color-danger: var\(--hb-color-red-600\);" "Semantic Token: danger maps to red-600"
check_grep "$SEMANTIC" "--hb-color-danger-hover: var\(--hb-color-red-700\);" "Semantic Token: danger-hover maps to red-700"
check_grep "$SEMANTIC" "--hb-color-danger-active: var\(--hb-color-red-800\);" "Semantic Token: danger-active maps to red-800"
check_grep "$SEMANTIC" "--hb-color-info: var\(--hb-color-blue-600\);" "Semantic Token: info maps to blue-600"
check_grep "$SEMANTIC" "--hb-color-info-hover: var\(--hb-color-blue-700\);" "Semantic Token: info-hover maps to blue-700"
check_grep "$SEMANTIC" "--hb-color-info-active: var\(--hb-color-blue-800\);" "Semantic Token: info-active maps to blue-800"
check_grep "$SEMANTIC" "--hb-font-family-body: var\(--hb-font-family-sans\);" "Semantic Token: body font maps to sans primitive"

# 3. Naming Contract
check_not_grep "$PRIMITIVES" "--color-" "Primitive naming: no generic --color- prefix"
check_not_grep "$SEMANTIC" "--color-" "Semantic naming: no generic --color- prefix"
check_not_grep "$SEMANTIC" "--primary:" "Semantic naming: no raw --primary (must be --hb-color-primary)"

# 4. Theme Boundary
check_grep "$THEMES" "\[data-theme=\"dark\"\]" "Theme boundary: Dark theme uses [data-theme=\"dark\"] selector"
check_grep "$THEMES" "--hb-color-background: var\(--hb-color-neutral-950\);" "Theme boundary: Dark theme overrides semantic background token"
check_grep "$THEMES" "--hb-color-secondary: var\(--hb-color-neutral-500\);" "Theme boundary: Dark theme overrides semantic secondary token"
check_grep "$THEMES" "--hb-color-success-hover: var\(--hb-color-green-400\);" "Theme boundary: Dark theme has success-hover"
check_grep "$THEMES" "--hb-color-warning-hover: var\(--hb-color-yellow-400\);" "Theme boundary: Dark theme has warning-hover"
check_grep "$THEMES" "--hb-color-info-hover: var\(--hb-color-blue-400\);" "Theme boundary: Dark theme has info-hover"
check_not_grep "$THEMES" "--hb-color-white:" "Theme boundary: Dark theme does NOT redefine primitive tokens"
check_not_grep "$THEMES" "@layer themes" "Theme boundary: No @layer themes used"
check_not_grep "$THEMES" "data-theme=\"light\"" "Theme boundary: No built-in light theme selector"

# 5. Duplicate Token Architecture
if [ -f "$TOKENS_DIR/themes.css" ]; then
  echo "FAIL: Obsolete themes.css found"
  ((ERRORS++))
else
  echo "PASS: No obsolete themes.css found"
fi

if grep -q -E -e "--hb-color-primary: " "$PRIMITIVES"; then
  echo "FAIL: Semantic token found in primitives"
  ((ERRORS++))
else
  echo "PASS: No duplicate semantic tokens in primitives"
fi

if grep -q -E -e "--hb-color-blue-600:" "$SEMANTIC"; then
  echo "FAIL: Primitive token redefined in semantic"
  ((ERRORS++))
else
  echo "PASS: No duplicate primitive tokens in semantic"
fi

# 6. Consumption Boundaries
check_grep "src/components/button.css" "var\(--hb-color-primary\)" "Token consumption: Components consume semantic tokens"
check_not_grep "src/components/button.css" "var\(--hb-color-blue-600\)" "Token consumption: Components do not consume primitive tokens directly"

if [ $ERRORS -eq 0 ]; then
  echo "All Token tests passed!"
  exit 0
else
  echo "$ERRORS Token test(s) failed."
  exit 1
fi
