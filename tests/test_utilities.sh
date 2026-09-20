#!/usr/bin/env bash
set -e

echo "Running Utility Tests..."

DIST_CSS="dist/hebring.css"
SRC_UTILS="src/utilities"
UTILITY_FILES=(
  "spacing"
  "display"
  "sizing"
  "typography"
  "alignment"
)

if [ ! -f "$DIST_CSS" ]; then
  echo "❌ FAIL: dist/hebring.css not found. Please run build first."
  exit 1
fi

ERRORS=0

function check_grep() {
  if grep -q -E -e "$2" "$1"; then
    echo "✅ PASS: $3"
  else
    echo "❌ FAIL: $3 (Expected to find '$2' in $1)"
    ((ERRORS++))
  fi
}

function check_not_grep() {
  if grep -q -E -e "$2" "$1"; then
    echo "❌ FAIL: $3 (Found forbidden '$2' in $1)"
    ((ERRORS++))
  else
    echo "✅ PASS: $3"
  fi
}

# 1. Spacing Utilities
check_grep "$SRC_UTILS/spacing.css" "\.hb-p-4" "Spacing: padding utility exists"
check_grep "$SRC_UTILS/spacing.css" "\.hb-m-4" "Spacing: margin utility exists"
check_grep "$SRC_UTILS/spacing.css" "\.hb-gap-4" "Spacing: gap utility exists"
check_grep "$SRC_UTILS/spacing.css" "var\(--hb-space-4\)" "Spacing: utilities map to space tokens"
check_not_grep "$SRC_UTILS/spacing.css" "\.hb-m-auto|\.hb-p-auto" "Spacing: auto spacing is not supported"
check_not_grep "$SRC_UTILS/spacing.css" "\.-hb-m" "Spacing: negative spacing is not supported"
check_not_grep "$SRC_UTILS/spacing.css" "\[" "Spacing: arbitrary values are not supported"
check_not_grep "$SRC_UTILS/spacing.css" "\.hb-m-[0-9]+-(sm|md|lg)" "Spacing: responsive spacing is not supported"

# 2. Display / Visibility Utilities
check_grep "$SRC_UTILS/display.css" "\.hb-block" "Display: hb-block exists"
check_grep "$SRC_UTILS/display.css" "\.hb-none" "Display: hb-none exists"
check_grep "$SRC_UTILS/display.css" "\.hb-visible" "Display: hb-visible exists"
check_grep "$SRC_UTILS/display.css" "\.hb-inline-flex" "Display: hb-inline-flex exists"

# 3. Sizing Utilities
check_grep "$SRC_UTILS/sizing.css" "\.hb-w-auto" "Sizing: hb-w-auto exists"
check_grep "$SRC_UTILS/sizing.css" "\.hb-w-full" "Sizing: hb-w-full exists"
check_grep "$SRC_UTILS/sizing.css" "\.hb-h-full" "Sizing: hb-h-full exists"
check_not_grep "$SRC_UTILS/sizing.css" "\.hb-w-[0-9]" "Sizing: no arbitrary width scales"
check_not_grep "$SRC_UTILS/sizing.css" "\.hb-(max|min)-[wh]" "Sizing: no max/min width/height utilities"

# 4. Typography Utilities
check_grep "$SRC_UTILS/typography.css" "\.hb-text-base" "Typography: hb-text-base exists"
check_grep "$SRC_UTILS/typography.css" "\.hb-text-center" "Typography: hb-text-center exists"
check_grep "$SRC_UTILS/typography.css" "\.hb-font-bold" "Typography: hb-font-bold exists"
check_grep "$SRC_UTILS/typography.css" "var\(--hb-font-" "Typography: maps to font tokens"
check_not_grep "$SRC_UTILS/typography.css" "\.hb-font-bold-(sm|md|lg)" "Typography: responsive font weight is not supported"

# 5. Alignment Utilities
check_grep "$SRC_UTILS/alignment.css" "\.hb-self-center" "Alignment: hb-self-center exists"
check_grep "$SRC_UTILS/alignment.css" "\.hb-justify-self-center" "Alignment: hb-justify-self-center exists"
check_not_grep "$SRC_UTILS/alignment.css" "\.hb-items-center|\.hb-justify-center" "Alignment: layout aliases like items-center are forbidden"

# 6. Responsive Boundary
check_grep "$DIST_CSS" "@media.*640px" "Responsive: sm breakpoint exists and uses min-width"
check_grep "$DIST_CSS" "@media.*768px" "Responsive: md breakpoint exists and uses min-width"
check_grep "$DIST_CSS" "@media.*1024px" "Responsive: lg breakpoint exists and uses min-width"
check_not_grep "$DIST_CSS" "@media.*(1280px|1536px)" "Responsive: xl/2xl breakpoints are not supported"

# 7. Architecture & Cascade Layer
check_not_grep "$SRC_UTILS" "\!important" "Architecture: !important is forbidden in utilities"

for FILE in "${UTILITY_FILES[@]}"; do
  check_grep "$SRC_UTILS/$FILE.css" "@layer utilities {" "$FILE: wrapped in @layer utilities"
  check_not_grep "$SRC_UTILS/$FILE.css" "@layer responsive|@layer themes|@layer layout|@layer components" "$FILE: no invalid cascade layers used"
  check_not_grep "$SRC_UTILS/$FILE.css" "\.hb-button" "$FILE: independent from components"
  check_not_grep "$SRC_UTILS/$FILE.css" "\.hb-stack|\.hb-container|\.hb-grid\s*\{" "$FILE: does not recreate layout primitives"
done

if [ $ERRORS -eq 0 ]; then
  echo "🎉 All Utility tests passed!"
  exit 0
else
  echo "❌ $ERRORS Utility test(s) failed."
  exit 1
fi
