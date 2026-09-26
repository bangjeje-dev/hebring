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

echo "All Ecosystem UI tests passed!"
