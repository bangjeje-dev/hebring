#!/usr/bin/env bash
set -e

# HEBRING Build & Distribution Validation

echo "Validating Build & Distribution Contracts..."

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
  if grep -q -E -e "$2" "$1"; then
    echo "✅ Found pattern '$2' in $1"
  else
    echo "❌ ERROR: Missing pattern '$2' in $1"
    ((ERRORS++))
  fi
}

function check_not_grep() {
  if grep -q -E -e "$2" "$1"; then
    echo "❌ ERROR: Found forbidden '$2' in $1"
    ((ERRORS++))
  else
    echo "✅ No '$2' in $1"
  fi
}

# 1. Build succeeds
echo "Running build..."
if npm run build >/dev/null 2>&1; then
  echo "✅ Build succeeded"
else
  echo "❌ ERROR: Build failed"
  exit 1
fi

# 2. Distribution artifacts exist
DIST_DIR="dist"
CSS_FILE="$DIST_DIR/hebring.css"
MIN_CSS_FILE="$DIST_DIR/hebring.min.css"
check_file "$CSS_FILE"
check_file "$MIN_CSS_FILE"

# 3. Artifact content is structurally valid
if [ -s "$CSS_FILE" ] && [ -s "$MIN_CSS_FILE" ]; then
  echo "✅ Distribution files are non-empty"
else
  echo "❌ ERROR: Distribution files are empty"
  ((ERRORS++))
fi

# 4. Source -> dist contracts
# We check hebring.css as it is not minified and easier to grep reliably, but we should use flexible regex
check_grep "$CSS_FILE" "--hb-[a-z0-9-]+" # HEBRING namespace variables
check_grep "$CSS_FILE" "@layer reset" # Cascade layers definition (reset)
check_grep "$CSS_FILE" "@layer base" # Cascade layers definition (base)
check_grep "$CSS_FILE" "@layer layout" # Cascade layers definition (layout)
check_grep "$CSS_FILE" "@layer components" # Cascade layers definition (components)
check_grep "$CSS_FILE" "@layer utilities" # Cascade layers definition (utilities)
check_grep "$CSS_FILE" "box-sizing:\s*border-box" # Reset rules
check_grep "$CSS_FILE" "\.hb-stack" # Layout primitives
check_grep "$CSS_FILE" "\.hb-text-base" # Utility classes
check_grep "$CSS_FILE" "\.hb-button" # Component classes
check_grep "$CSS_FILE" "@media[^{]*640px" # Responsive rules
check_grep "$CSS_FILE" '\[data-theme="dark"\]' # Theme selectors
check_grep "$CSS_FILE" "var\(--hb-color-primary\)" # Semantic token usage

# 5. Entry point contracts
check_file "src/index.css"

# 6. Package metadata contracts
PACKAGE_JSON="package.json"
check_grep "$PACKAGE_JSON" '"style": "./dist/hebring.css"'
check_grep "$PACKAGE_JSON" '"\./css": "./dist/hebring.css"'
check_grep "$PACKAGE_JSON" '"\./min": "./dist/hebring.min.css"'

if grep -q '"files": \[' "$PACKAGE_JSON" && grep -q '"dist"' "$PACKAGE_JSON" && grep -q '"src"' "$PACKAGE_JSON"; then
  echo "✅ Package files array includes dist and src"
else
  echo "❌ ERROR: Package files array missing or invalid"
  ((ERRORS++))
fi

# 7. npm packaging sanity
echo "Checking npm pack --dry-run..."
PACK_OUTPUT=$(npm pack --dry-run 2>&1)
if echo "$PACK_OUTPUT" | grep -q "dist/hebring.css" && \
   echo "$PACK_OUTPUT" | grep -q "dist/hebring.min.css" && \
   echo "$PACK_OUTPUT" | grep -q "src/index.css" && \
   echo "$PACK_OUTPUT" | grep -q "package.json"; then
  echo "✅ npm pack correctly includes expected distribution files"
else
  echo "❌ ERROR: npm pack is missing expected files"
  echo "$PACK_OUTPUT"
  ((ERRORS++))
fi

# 8. No runtime JavaScript dependency
if ls "$DIST_DIR"/*.js >/dev/null 2>&1; then
  echo "❌ ERROR: Found JavaScript files in dist directory"
  ((ERRORS++))
else
  echo "✅ No JavaScript files in dist directory"
fi

# 9. Build Repeatability
echo "Checking build stability..."
ORIGINAL_HASH=$(shasum -a 256 "$MIN_CSS_FILE" | awk '{print $1}')
npm run build >/dev/null 2>&1
NEW_HASH=$(shasum -a 256 "$MIN_CSS_FILE" | awk '{print $1}')

if [ "$ORIGINAL_HASH" = "$NEW_HASH" ]; then
  echo "✅ Build is repeatable (hash matches)"
else
  echo "❌ ERROR: Build is non-deterministic (hash mismatch)"
  echo "Original: $ORIGINAL_HASH"
  echo "New:      $NEW_HASH"
  ((ERRORS++))
fi

if [ $ERRORS -eq 0 ]; then
  echo "🎉 All Build & Distribution tests passed!"
  exit 0
else
  echo "❌ $ERRORS Build & Distribution test(s) failed."
  exit 1
fi
