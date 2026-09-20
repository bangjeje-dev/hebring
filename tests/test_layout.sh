#!/usr/bin/env bash
set -e

echo "Running Layout Tests..."

DIST_CSS="dist/hebring.css"
SRC_LAYOUT="src/layout"
LAYOUT_FILES=(
  "container"
  "stack"
  "cluster"
  "grid"
  "flex"
  "center"
  "flow"
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

# 1. Layout API Inventory
check_grep "$DIST_CSS" "\.hb-container" "Inventory: hb-container primitive exists"
check_grep "$DIST_CSS" "\.hb-stack" "Inventory: hb-stack primitive exists"
check_grep "$DIST_CSS" "\.hb-cluster" "Inventory: hb-cluster primitive exists"
check_grep "$DIST_CSS" "\.hb-grid" "Inventory: hb-grid primitive exists"
check_grep "$DIST_CSS" "\.hb-flex" "Inventory: hb-flex primitive exists"
check_grep "$DIST_CSS" "\.hb-center" "Inventory: hb-center primitive exists"
check_grep "$DIST_CSS" "\.hb-flow" "Inventory: hb-flow primitive exists"

# 2. Container Contract
check_grep "$SRC_LAYOUT/container.css" "width: 100%;" "Container: width is 100%"
check_grep "$SRC_LAYOUT/container.css" "margin-inline: auto;" "Container: margin-inline is auto"
check_grep "$SRC_LAYOUT/container.css" "padding-inline: var\(--hb-space-4\);" "Container: padding uses established token"
check_grep "$SRC_LAYOUT/container.css" "max-width: 80rem;" "Container: max-width is 80rem"
check_not_grep "$SRC_LAYOUT/container.css" "\.hb-container-sm|\.hb-container-md|\.hb-container-lg" "Container: no responsive container variants exist"

# 3. Stack Contract
check_grep "$SRC_LAYOUT/stack.css" "display: flex;" "Stack: display is flex"
check_grep "$SRC_LAYOUT/stack.css" "flex-direction: column;" "Stack: flex-direction is column"
check_grep "$SRC_LAYOUT/stack.css" "gap: var\(--hb-space-4\);" "Stack: gap uses established spacing token"
check_not_grep "$SRC_LAYOUT/stack.css" "\.hb-stack-sm|\.hb-stack-md|\.hb-stack-lg" "Stack: no responsive stack variants exist"

# 4. Cluster Contract
check_grep "$SRC_LAYOUT/cluster.css" "display: flex;" "Cluster: display is flex"
check_grep "$SRC_LAYOUT/cluster.css" "flex-wrap: wrap;" "Cluster: flex-wrap is wrap"
check_grep "$SRC_LAYOUT/cluster.css" "gap: var\(--hb-space-4\);" "Cluster: gap uses established spacing token"
check_not_grep "$SRC_LAYOUT/cluster.css" "justify-content|align-items" "Cluster: no alignment/justification variants"

# 5. Grid Contract
check_grep "$SRC_LAYOUT/grid.css" "display: grid;" "Grid: display is grid"
check_grep "$SRC_LAYOUT/grid.css" "gap: var\(--hb-space-4\);" "Grid: gap uses established spacing token"
check_not_grep "$SRC_LAYOUT/grid.css" "grid-template-columns|\.hb-grid-cols" "Grid: no column count or responsive grid APIs"

# 6. Flex Contract
check_grep "$SRC_LAYOUT/flex.css" "display: flex;" "Flex: display is flex"
check_not_grep "$SRC_LAYOUT/flex.css" "\.hb-items-center|\.hb-justify-center|\.hb-flex-row|\.hb-flex-column" "Flex: no utility aliases reinvented"

# 7. Center Contract
check_grep "$SRC_LAYOUT/center.css" "display: flex;" "Center: display is flex"
check_grep "$SRC_LAYOUT/center.css" "align-items: center;" "Center: align-items is center"
check_grep "$SRC_LAYOUT/center.css" "justify-content: center;" "Center: justify-content is center"

# 8. Flow Contract
check_grep "$SRC_LAYOUT/flow.css" "\.hb-flow > \* \+ \*" "Flow: uses direct sibling selector"
check_grep "$SRC_LAYOUT/flow.css" "margin-block-start: var\(--hb-space-4\);" "Flow: applies spacing via margin-block-start and token"
check_not_grep "$SRC_LAYOUT/flow.css" "margin-top" "Flow: uses logical properties, not margin-top"

# 9. Cascade Layer & Component Independence & Token Usage
for FILE in "${LAYOUT_FILES[@]}"; do
  check_grep "$SRC_LAYOUT/$FILE.css" "@layer layout {" "$FILE: wrapped in @layer layout"
  check_not_grep "$SRC_LAYOUT/$FILE.css" "@layer responsive|@layer foundation|@layer themes" "$FILE: no invalid cascade layers used"
  check_not_grep "$SRC_LAYOUT/$FILE.css" "\.hb-button" "$FILE: independent from components"
done

# 10. Responsive Boundary (Global Layout check)
check_not_grep "$DIST_CSS" "\.hb-stack-sm|\.hb-stack-md|\.hb-stack-lg|\.hb-grid-md|\.hb-flex-lg|\.hb-container-md" "Global Layout: no undocumented breakpoint-specific variants"

if [ $ERRORS -eq 0 ]; then
  echo "🎉 All Layout tests passed!"
  exit 0
else
  echo "❌ $ERRORS Layout test(s) failed."
  exit 1
fi
