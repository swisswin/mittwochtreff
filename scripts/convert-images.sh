#!/usr/bin/env bash
# scripts/convert-images.sh
# Usage: ./scripts/convert-images.sh [source-image]
# Requires: cwebp (from libwebp) installed and available in PATH.
# This script generates responsive WebP background images from a large source PNG.

set -euo pipefail

SRC=${1:-background.png}
if [ ! -f "$SRC" ]; then
  echo "Source image '$SRC' not found in current directory."
  echo "Place your high-resolution background image as $SRC and re-run, or pass an explicit path."
  exit 1
fi

echo "Generating WebP variants from $SRC..."

# Desktop (approx 2000px wide)
cwebp -q 85 -resize 2000 0 "$SRC" -o bg-2000.webp
# Tablet (approx 1200px wide)
cwebp -q 82 -resize 1200 0 "$SRC" -o bg-1200.webp
# Mobile (approx 800px wide)
cwebp -q 78 -resize 800 0 "$SRC" -o bg-800.webp

echo "Done. Generated: bg-2000.webp, bg-1200.webp, bg-800.webp"

# Optional: show sizes
ls -lh bg-*.webp || true
