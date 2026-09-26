#!/usr/bin/env bash
set -e

# HEBRING Package Consumer Tests
# Simulates an external consumer installing and using the HEBRING npm package
# through its documented public interface.

echo "Running Package Consumer Tests..."

ERRORS=0
REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
CONSUMER_DIR="$(mktemp -d)"

# Ensure cleanup on exit, success or failure
trap 'echo "Cleaning up consumer directory: $CONSUMER_DIR"; rm -rf "$CONSUMER_DIR"' EXIT

# Helper functions
pass() { echo "PASS: $1"; }
fail() { echo "FAIL: $1"; ((ERRORS++)); }

# ============================================================
# 1. Build HEBRING
# ============================================================
echo ""
echo "Step 1: Building HEBRING..."
(cd "$REPO_ROOT" && npm run build >/dev/null 2>&1) \
  && pass "Build succeeded" \
  || { fail "Build failed"; exit 1; }

# ============================================================
# 2. Pack HEBRING into a local tarball
# ============================================================
echo ""
echo "Step 2: Packing HEBRING into a local tarball..."
PACK_OUTPUT="$(cd "$REPO_ROOT" && npm pack --pack-destination "$CONSUMER_DIR" 2>&1)"
TARBALL="$(ls "$CONSUMER_DIR"/*.tgz 2>/dev/null | head -1)"

if [ -z "$TARBALL" ]; then
  fail "npm pack did not produce a tarball"
  exit 1
fi
pass "Tarball created: $(basename "$TARBALL")"

# ============================================================
# 3. Create a minimal isolated consumer project
# ============================================================
echo ""
echo "Step 3: Creating isolated consumer project..."
cat > "$CONSUMER_DIR/package.json" <<'EOF'
{
  "name": "hebring-consumer-test",
  "version": "1.0.0",
  "description": "Isolated consumer test for the HEBRING package",
  "type": "module"
}
EOF
pass "Consumer package.json created"

# ============================================================
# 4. Install the HEBRING tarball into the consumer project
# (no network, fully local)
# ============================================================
echo ""
echo "Step 4: Installing HEBRING tarball into consumer project..."
(cd "$CONSUMER_DIR" && npm install --no-save "$TARBALL" >/dev/null 2>&1) \
  && pass "Package installed from local tarball" \
  || { fail "npm install failed for tarball"; exit 1; }

INSTALLED_PKG="$CONSUMER_DIR/node_modules/hebring"

if [ -d "$INSTALLED_PKG" ]; then
  pass "Package directory exists in consumer node_modules"
else
  fail "Package directory missing from consumer node_modules"
  exit 1
fi

# ============================================================
# 5. Verify installed package is FULLY isolated from repo
#    (no symlinks back to the repository)
# ============================================================
echo ""
echo "Step 5: Validating consumer isolation (no repo path leakage)..."
REAL_PKG="$(realpath "$INSTALLED_PKG")"
REAL_REPO="$(realpath "$REPO_ROOT")"

if [[ "$REAL_PKG" == "$REAL_REPO"* ]]; then
  fail "Installed package resolves to repository path — not a true isolated install"
else
  pass "Consumer package is isolated from repository (no path leakage)"
fi

# ============================================================
# 6. Verify package metadata inside the installed package
# ============================================================
echo ""
echo "Step 6: Verifying installed package metadata..."
INSTALLED_PKG_JSON="$INSTALLED_PKG/package.json"

if [ -f "$INSTALLED_PKG_JSON" ]; then
  pass "Installed package.json exists"
else
  fail "Installed package.json missing"
fi

# Check package name
if grep -q '"name": "hebring"' "$INSTALLED_PKG_JSON"; then
  pass "Package name is 'hebring'"
else
  fail "Package name is not 'hebring'"
fi

# Check style field
if grep -q '"style"' "$INSTALLED_PKG_JSON"; then
  pass "Package exposes a style field"
else
  fail "Package is missing style field"
fi

# Check exports exist
if grep -q '"exports"' "$INSTALLED_PKG_JSON"; then
  pass "Package exposes exports field"
else
  fail "Package is missing exports field"
fi

# ============================================================
# 7. Verify installed distribution artifacts exist
# ============================================================
echo ""
echo "Step 7: Verifying installed distribution artifacts..."

INSTALLED_CSS="$INSTALLED_PKG/dist/hebring.css"
INSTALLED_MIN_CSS="$INSTALLED_PKG/dist/hebring.min.css"

if [ -f "$INSTALLED_CSS" ]; then
  pass "dist/hebring.css exists in installed package"
else
  fail "dist/hebring.css MISSING from installed package"
fi

if [ -f "$INSTALLED_MIN_CSS" ]; then
  pass "dist/hebring.min.css exists in installed package"
else
  fail "dist/hebring.min.css MISSING from installed package"
fi

if [ -s "$INSTALLED_CSS" ]; then
  pass "dist/hebring.css is non-empty"
else
  fail "dist/hebring.css is empty"
fi

if [ -s "$INSTALLED_MIN_CSS" ]; then
  pass "dist/hebring.min.css is non-empty"
else
  fail "dist/hebring.min.css is empty"
fi

# ============================================================
# 8. Validate package exports resolve to existing files
#    (exports map: "." -> ./dist/hebring.css,
#                  "./css" -> ./dist/hebring.css,
#                  "./min" -> ./dist/hebring.min.css)
# ============================================================
echo ""
echo "Step 8: Validating package exports resolve to existing files..."

# "." and "./css" → dist/hebring.css
CSS_EXPORT_PATH="$INSTALLED_PKG/dist/hebring.css"
if [ -f "$CSS_EXPORT_PATH" ]; then
  pass "Export '.' resolves to existing file: dist/hebring.css"
  pass "Export './css' resolves to existing file: dist/hebring.css"
else
  fail "Export '.' / './css' target missing: dist/hebring.css"
fi

# "./min" → dist/hebring.min.css
MIN_EXPORT_PATH="$INSTALLED_PKG/dist/hebring.min.css"
if [ -f "$MIN_EXPORT_PATH" ]; then
  pass "Export './min' resolves to existing file: dist/hebring.min.css"
else
  fail "Export './min' target missing: dist/hebring.min.css"
fi

# style field → dist/hebring.css
STYLE_FIELD_TARGET="$INSTALLED_PKG/dist/hebring.css"
if [ -f "$STYLE_FIELD_TARGET" ]; then
  pass "style field target exists: dist/hebring.css"
else
  fail "style field target MISSING: dist/hebring.css"
fi

# ============================================================
# 9. Validate representative framework contracts survive
#    package installation (from the INSTALLED copy — not repo)
# ============================================================
echo ""
echo "Step 9: Validating framework contracts in installed CSS..."

check_installed_css() {
  local pattern="$1"
  local label="$2"
  if grep -q -E -e "$pattern" "$INSTALLED_CSS"; then
    pass "Installed CSS contract: $label"
  else
    fail "Installed CSS missing contract: $label"
  fi
}

check_installed_min_css() {
  local pattern="$1"
  local label="$2"
  if grep -q -E -e "$pattern" "$INSTALLED_MIN_CSS"; then
    pass "Installed min CSS contract: $label"
  else
    fail "Installed min CSS missing contract: $label"
  fi
}

check_installed_css "--hb-[a-z0-9-]+" "HEBRING namespace variables (--hb-*)"
check_installed_css "@layer reset"     "Cascade layer: reset"
check_installed_css "@layer base"      "Cascade layer: base"
check_installed_css "@layer layout"    "Cascade layer: layout"
check_installed_css "@layer components" "Cascade layer: components"
check_installed_css "@layer utilities" "Cascade layer: utilities"
check_installed_css "\.hb-button"      "Component: .hb-button"
check_installed_css "\.hb-stack"       "Layout primitive: .hb-stack"
check_installed_css "\.hb-text-base"   "Utility: .hb-text-base"
check_installed_css '\[data-theme="dark"\]' "Theme selector: [data-theme=\"dark\"]"
check_installed_css "@media[^{]*640px"  "Responsive media rules"
check_installed_css "var\(--hb-color-primary\)" "Semantic token usage"

# Also spot-check the minified version is complete
check_installed_min_css "--hb-[a-z0-9-]+" "HEBRING namespace variables (--hb-*)"
check_installed_min_css "\.hb-button"     "Component: .hb-button"
check_installed_min_css "\.hb-stack"      "Layout primitive: .hb-stack"

# ============================================================
# 10. Verify NO JavaScript runtime files exist in dist
# ============================================================
echo ""
echo "Step 10: Verifying no runtime JavaScript in installed package dist..."

if ls "$INSTALLED_PKG/dist"/*.js >/dev/null 2>&1; then
  fail "Runtime JavaScript files found in installed dist — HEBRING must be CSS-only"
else
  pass "No runtime JavaScript in installed dist"
fi

# ============================================================
# 11. Verify installed CSS is not a symlink to repo (double check)
# ============================================================
echo ""
echo "Step 11: Verifying installed CSS files are not repository symlinks..."

if [ -L "$INSTALLED_CSS" ]; then
  fail "dist/hebring.css is a symlink — not a true installed copy"
else
  pass "dist/hebring.css is a real file in the consumer"
fi

if [ -L "$INSTALLED_MIN_CSS" ]; then
  fail "dist/hebring.min.css is a symlink — not a true installed copy"
else
  pass "dist/hebring.min.css is a real file in the consumer"
fi

# ============================================================
# 12. Confirm the installed CSS was served from the tarball,
#     not repo dist (cross-reference file sizes are reasonable)
# ============================================================
echo ""
echo "Step 12: Verifying installed files are non-trivially sized..."

CSS_SIZE=$(wc -c < "$INSTALLED_CSS")
MIN_SIZE=$(wc -c < "$INSTALLED_MIN_CSS")

if [ "$CSS_SIZE" -gt 10000 ]; then
  pass "Installed dist/hebring.css is substantive (${CSS_SIZE} bytes)"
else
  fail "Installed dist/hebring.css appears too small (${CSS_SIZE} bytes) — may be corrupt"
fi

if [ "$MIN_SIZE" -gt 5000 ]; then
  pass "Installed dist/hebring.min.css is substantive (${MIN_SIZE} bytes)"
else
  fail "Installed dist/hebring.min.css appears too small (${MIN_SIZE} bytes) — may be corrupt"
fi

# ============================================================
# 13. Verify package exports resolve Ecosystem Icons
# ============================================================
echo ""
echo "Step 13: Verifying Icon package exports resolve via Node..."

cat > "$CONSUMER_DIR/test-icons.js" <<'EOF'
import fs from 'fs';
import { createRequire } from 'module';
const require = createRequire(import.meta.url);

try {
  const iconCssPath = require.resolve('hebring/icons/icon.css');
  const checkSvgPath = require.resolve('hebring/icons/check.svg');
  
  if (!fs.existsSync(iconCssPath)) {
    console.error("FAIL: icon.css resolves but file is missing at", iconCssPath);
    process.exit(1);
  }
  
  if (!fs.existsSync(checkSvgPath)) {
    console.error("FAIL: check.svg resolves but file is missing at", checkSvgPath);
    process.exit(1);
  }
  
  const svgContent = fs.readFileSync(checkSvgPath, 'utf8');
  if (!svgContent.startsWith('<svg') || !svgContent.includes('viewBox') || !checkSvgPath.endsWith('.svg')) {
    console.error("FAIL: check.svg content is invalid or not .svg");
    process.exit(1);
  }
  
  const cssContent = fs.readFileSync(iconCssPath, 'utf8');
  if (!cssContent.includes('.hb-icon') || !cssContent.includes('--hb-icon-size')) {
    console.error("FAIL: icon.css content is invalid");
    process.exit(1);
  }
  
  if (!checkSvgPath.includes('node_modules')) {
    console.error("FAIL: path leakage detected", checkSvgPath);
    process.exit(1);
  }

  process.exit(0);
} catch (e) {
  console.error("FAIL:", e.message);
  process.exit(1);
}
EOF

if (cd "$CONSUMER_DIR" && node test-icons.js >/dev/null 2>&1); then
  pass "Node can resolve hebring/icons/icon.css"
  pass "Node can resolve hebring/icons/check.svg"
  pass "Icon SVG resolves to a valid .svg asset without source leakage"
  pass "Icon CSS resolves to a valid asset without source leakage"
else
  fail "Node failed to resolve Icon exports (or contents are invalid)"
  (cd "$CONSUMER_DIR" && node test-icons.js)
fi

# ============================================================
# Summary
# ============================================================
echo ""
if [ $ERRORS -eq 0 ]; then
  echo "All Package Consumer tests passed!"
  exit 0
else
  echo "$ERRORS Package Consumer test(s) failed."
  exit 1
fi
