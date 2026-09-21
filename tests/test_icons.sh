#!/bin/bash

# Exit on any error
set -e

# Configuration
SRC_ICONS="src/icons"
ERRORS=0

echo "Running Icon Tests..."

# Helper function
check_grep() {
  local file=$1
  local pattern=$2
  local message=$3
  if grep -qE -e "$pattern" "$file"; then
    echo "PASS: $message"
  else
    echo "FAIL: $message (Pattern '$pattern' not found in $file)"
    ERRORS=$((ERRORS + 1))
  fi
}

check_not_grep() {
  local file=$1
  local pattern=$2
  local message=$3
  if grep -qE -e "$pattern" "$file"; then
    echo "FAIL: $message (Pattern '$pattern' unexpectedly found in $file)"
    ERRORS=$((ERRORS + 1))
  else
    echo "PASS: $message"
  fi
}

# 1. Directory and Files Exist
if [ ! -d "$SRC_ICONS" ]; then
  echo "FAIL: Icons directory missing"
  exit 1
fi

for icon in arrow-left arrow-right chevron-down chevron-up menu plus minus close check search info warning error success settings external-link; do
  if [ ! -f "$SRC_ICONS/$icon.svg" ]; then
    echo "FAIL: Missing icon $icon.svg"
    ERRORS=$((ERRORS + 1))
  else
    echo "PASS: Found icon $icon.svg"
    # 2. SVG Contract Validation
    check_grep "$SRC_ICONS/$icon.svg" 'viewBox="0 0 24 24"' "$icon has correct viewBox"
    check_grep "$SRC_ICONS/$icon.svg" 'stroke="currentColor"' "$icon uses currentColor"
    check_grep "$SRC_ICONS/$icon.svg" 'fill="none"' "$icon uses no fill"
    check_not_grep "$SRC_ICONS/$icon.svg" '#[0-9a-fA-F]{3,6}' "$icon has no hardcoded hex colors"
    check_not_grep "$SRC_ICONS/$icon.svg" '<image|<font' "$icon contains no raster images or fonts"
    check_not_grep "$SRC_ICONS/$icon.svg" 'Lucide|Heroicons|FontAwesome' "$icon is original HEBRING artwork"
  fi
done

# 3. CSS Contract
if [ -f "$SRC_ICONS/icon.css" ]; then
  check_grep "$SRC_ICONS/icon.css" '\.hb-icon' "Icon CSS wrapper exists"
  check_grep "$SRC_ICONS/icon.css" '--hb-icon-size' "Icon CSS uses HEBRING token naming convention"
else
  echo "FAIL: icon.css missing"
  ERRORS=$((ERRORS + 1))
fi

# 4. Core Dependency Check (Ensure Core didn't secretly import icons)
check_not_grep "src/components/index.css" 'icon\.css' "Core does not import icons directly"

if [ $ERRORS -eq 0 ]; then
  echo "All Icon tests passed!"
  exit 0
else
  echo "$ERRORS Icon test(s) failed."
  exit 1
fi
