#!/bin/bash

# Exit on any error
set -e

ERRORS=0

echo "Running Ecosystem Boundary Tests..."

# Helper function
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

# 1. src/index.css does not import ecosystem
check_not_grep "src/index.css" 'ecosystem' "Core entry point does not import ecosystem"

# 2. Core build does not contain ecosystem artifacts
if [ -f "dist/hebring.css" ]; then
  # Just to be sure, check if the string "ecosystem" somehow ended up in the built CSS
  # This might be tricky if "ecosystem" is used in comments, but lightningcss minifies/removes comments.
  # Let's ensure no paths related to ecosystem are in the build.
  # The word "ecosystem" shouldn't exist in the CSS output.
  check_not_grep "dist/hebring.css" 'ecosystem' "Core CSS bundle does not contain ecosystem artifacts"
fi

if [ $ERRORS -eq 0 ]; then
  echo "All Ecosystem Boundary tests passed!"
  exit 0
else
  echo "$ERRORS Ecosystem Boundary test(s) failed."
  exit 1
fi
