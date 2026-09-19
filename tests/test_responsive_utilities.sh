#!/usr/bin/env bash
set -e

echo "Running Responsive Utility Tests..."

# Verify Display utilities
DISPLAY_CSS="src/utilities/display.css"
DISPLAY_CLASSES=("hb-block" "hb-inline" "hb-inline-block" "hb-inline-flex" "hb-inline-grid" "hb-none" "hb-visible" "hb-invisible")
for class in "${DISPLAY_CLASSES[@]}"; do
  for bp in "sm" "md" "lg"; do
    if ! grep -qF ".$class-$bp" "$DISPLAY_CSS"; then
      echo "❌ Error: .$class-$bp not found in $DISPLAY_CSS"
      exit 1
    fi
  done
done
echo "✅ Responsive display utilities verified."

# Verify Sizing utilities
SIZING_CSS="src/utilities/sizing.css"
SIZING_CLASSES=("hb-w-auto" "hb-w-full" "hb-h-auto" "hb-h-full")
for class in "${SIZING_CLASSES[@]}"; do
  for bp in "sm" "md" "lg"; do
    if ! grep -qF ".$class-$bp" "$SIZING_CSS"; then
      echo "❌ Error: .$class-$bp not found in $SIZING_CSS"
      exit 1
    fi
  done
done
echo "✅ Responsive sizing utilities verified."

# Verify Typography utilities
TYPOGRAPHY_CSS="src/utilities/typography.css"
TYPOGRAPHY_CLASSES=("hb-text-xs" "hb-text-sm" "hb-text-md" "hb-text-lg" "hb-text-xl" "hb-text-2xl" "hb-text-3xl" "hb-text-4xl" "hb-text-5xl" "hb-text-6xl" "hb-text-start" "hb-text-center" "hb-text-end")
for class in "${TYPOGRAPHY_CLASSES[@]}"; do
  for bp in "sm" "md" "lg"; do
    if ! grep -qF ".$class-$bp" "$TYPOGRAPHY_CSS"; then
      echo "❌ Error: .$class-$bp not found in $TYPOGRAPHY_CSS"
      exit 1
    fi
  done
done
echo "✅ Responsive typography utilities verified."

# Verify NO responsive font-weight
FONT_WEIGHT_CLASSES=("hb-font-normal" "hb-font-medium" "hb-font-semibold" "hb-font-bold")
for class in "${FONT_WEIGHT_CLASSES[@]}"; do
  for bp in "sm" "md" "lg"; do
    if grep -qF ".$class-$bp" "$TYPOGRAPHY_CSS"; then
      echo "❌ Error: Found invalid responsive font-weight .$class-$bp"
      exit 1
    fi
  done
done
echo "✅ No responsive font-weight utilities found."

# Verify Alignment utilities
ALIGNMENT_CSS="src/utilities/alignment.css"
ALIGNMENT_CLASSES=("hb-self-auto" "hb-self-start" "hb-self-center" "hb-self-end" "hb-self-stretch" "hb-justify-self-auto" "hb-justify-self-start" "hb-justify-self-center" "hb-justify-self-end" "hb-justify-self-stretch")
for class in "${ALIGNMENT_CLASSES[@]}"; do
  for bp in "sm" "md" "lg"; do
    if ! grep -qF ".$class-$bp" "$ALIGNMENT_CSS"; then
      echo "❌ Error: .$class-$bp not found in $ALIGNMENT_CSS"
      exit 1
    fi
  done
done
echo "✅ Responsive alignment utilities verified."

# Verify NO responsive spacing
SPACING_CSS="src/utilities/spacing.css"
if grep -qE "(hb-p-|hb-m-|hb-gap-).+-(sm|md|lg)" "$SPACING_CSS"; then
  echo "❌ Error: Found responsive spacing utility."
  exit 1
fi
echo "✅ No responsive spacing utilities found."

# Verify NO xl/2xl breakpoints
if grep -rE "(sm|md|lg|xl|2xl)-(xl|2xl)" src/utilities/; then
  echo "❌ Error: Found xl/2xl responsive utilities."
  exit 1
fi
echo "✅ No xl/2xl utilities found."

# Verify NO @layer responsive
if grep -r "@layer responsive" src/utilities/; then
  echo "❌ Error: Found @layer responsive."
  exit 1
fi
echo "✅ No @layer responsive found."

# Verify NO !important
if grep -r "!important" src/utilities/; then
  echo "❌ Error: Found !important in utilities."
  exit 1
fi
echo "✅ No !important found."

echo "🎉 All Responsive Utility tests passed!"
