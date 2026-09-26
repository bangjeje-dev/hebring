#!/bin/bash
set -e

THEMES_DIR="ecosystem/themes"
PACKAGE_JSON="package.json"
DIST_CSS="dist/hebring.css"

echo "Running Ecosystem Theme tests..."

# A. ecosystem/themes directory exists
if [ ! -d "$THEMES_DIR" ]; then
    echo "FAIL: $THEMES_DIR does not exist"
    exit 1
fi
echo "PASS: $THEMES_DIR exists"

# B. At least one .css theme exists
if ! ls "$THEMES_DIR"/*.css >/dev/null 2>&1; then
    echo "FAIL: No CSS themes found in $THEMES_DIR"
    exit 1
fi
echo "PASS: CSS themes found"

# C. ocean.css exists
if [ ! -f "$THEMES_DIR/ocean.css" ]; then
    echo "FAIL: ocean.css does not exist"
    exit 1
fi
echo "PASS: ocean.css exists"

# Identify allowed semantic tokens dynamically from src/tokens/semantic.css
ALLOWED_SEMANTICS=$(grep -oE -- '--hb-[a-zA-Z0-9-]+[a-zA-Z0-9-]*:' src/tokens/semantic.css | sed 's/://g' | sort -u)

for THEME_FILE in "$THEMES_DIR"/*.css; do
    echo "Testing theme: $THEME_FILE"

    # D. Uses [data-theme="..."] scoping
    if ! grep -q '\[data-theme=' "$THEME_FILE"; then
        echo "FAIL: Theme $THEME_FILE must use [data-theme=\"...\"] scoping"
        exit 1
    fi

    # Class and element selectors
    if grep -qE '^\s*\.[a-zA-Z]' "$THEME_FILE"; then
        echo "FAIL: Theme $THEME_FILE contains class selectors"
        exit 1
    fi
    if grep -qE '^\s*(div|span|p|a|ul|li|html|body|h[1-6])\s*[{,]' "$THEME_FILE"; then
        echo "FAIL: Theme $THEME_FILE contains element selectors"
        exit 1
    fi

    # @import
    if grep -q '@import' "$THEME_FILE"; then
        echo "FAIL: Theme $THEME_FILE contains @import"
        exit 1
    fi

    # JS
    if grep -qE '<script>|import |require\(' "$THEME_FILE"; then
        echo "FAIL: Theme $THEME_FILE contains JS-like content"
        exit 1
    fi

    # E. Reject primitive tokens
    if grep -qE '--hb-color-(neutral|blue|green|yellow|red|teal|orange|purple|pink)-[0-9]+' "$THEME_FILE"; then
        echo "FAIL: Theme $THEME_FILE redefines color primitive tokens"
        exit 1
    fi
    if grep -qE '--hb-space-|--hb-font-size-|--hb-radius-|--hb-shadow-|--hb-font-weight-|--hb-line-height-' "$THEME_FILE"; then
        echo "FAIL: Theme $THEME_FILE redefines primitive tokens"
        exit 1
    fi

    # G. Verify it only uses allowed semantic tokens (for declarations, i.e., before the colon)
    # Extract all custom properties declared (left side of :)
    DECLARED_TOKENS=$(grep -oE -- '^\s*--hb-[a-zA-Z0-9-]+:' "$THEME_FILE" | sed -E 's/^\s*//;s/://')
    for TOKEN in $DECLARED_TOKENS; do
        if ! echo "$ALLOWED_SEMANTICS" | grep -qx "$TOKEN"; then
            echo "FAIL: Theme $THEME_FILE declares unallowed semantic token $TOKEN"
            exit 1
        fi
    done

    # F. Reject component selectors explicitly
    if grep -qE '\.hb-(button|card|badge|alert|input)' "$THEME_FILE"; then
        echo "FAIL: Theme $THEME_FILE contains component selectors"
        exit 1
    fi

    echo "PASS: $THEME_FILE contract met"
done

# H. Verify Core build does NOT contain ocean theme CSS
if [ -f "$DIST_CSS" ]; then
    if grep -q 'data-theme="ocean"' "$DIST_CSS"; then
        echo "FAIL: Core build contains ocean theme"
        exit 1
    fi
    echo "PASS: Core build is isolated from themes"
fi

# I. Verify package export for "./themes/*" exists
if ! grep -q '"./themes/\*": "./ecosystem/themes/\*"' "$PACKAGE_JSON"; then
    echo "FAIL: package.json missing ./themes/* export"
    exit 1
fi
echo "PASS: package.json contains ./themes/* export"

echo "All Ecosystem Theme tests passed!"
