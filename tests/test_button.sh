#!/usr/bin/env bash
set -e

echo "Running Button Component Tests..."

CSS_FILE="src/components/button.css"

if [ ! -f "$CSS_FILE" ]; then
  echo "❌ Error: $CSS_FILE does not exist."
  exit 1
fi

echo "✅ $CSS_FILE exists."

# Verify selectors
SELECTORS=(
  ".hb-button"
  ".hb-button--secondary"
  ".hb-button--danger"
  ".hb-button--sm"
  ".hb-button--lg"
  ".hb-button.is-loading"
  ".hb-button:hover"
  ".hb-button:focus-visible"
  ".hb-button:active"
  ".hb-button:disabled"
)

for SELECTOR in "${SELECTORS[@]}"; do
  if grep -qF "$SELECTOR" "$CSS_FILE"; then
    echo "✅ Found selector: $SELECTOR"
  else
    echo "❌ Error: Selector $SELECTOR not found in $CSS_FILE."
    exit 1
  fi
done

# Verify component layer wrapper
if grep -q "@layer components {" "$CSS_FILE"; then
  echo "✅ Button wrapped in @layer components."
else
  echo "❌ Error: Missing @layer components wrapper."
  exit 1
fi

# Verify no !important
if grep -q "!important" "$CSS_FILE"; then
  echo "❌ Error: Found !important in $CSS_FILE."
  exit 1
else
  echo "✅ No !important used."
fi

# Verify no utility imports (basic check)
if grep -qE "hb-p-|hb-m-|hb-text-" "$CSS_FILE"; then
  echo "❌ Error: Utility dependency found in $CSS_FILE."
  exit 1
else
  echo "✅ No utility dependency found."
fi

# Verify imports in index.css
if grep -q "@import \"./button.css\";" "src/components/index.css"; then
  echo "✅ button.css is imported in src/components/index.css."
else
  echo "❌ Error: button.css is not imported in src/components/index.css."
  exit 1
fi

echo "🎉 All Button tests passed!"
