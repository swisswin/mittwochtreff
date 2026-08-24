#!/usr/bin/env bash
# scripts/convert-images.sh
# Usage: ./scripts/convert-images.sh [source-image] [out-dir]
# Requires: cwebp (from libwebp). Optionally ImageMagick `convert` for LQIP.
set -euo pipefail

SRC=${1:-background.png}
OUT_DIR=${2:-.}

if [ ! -f "$SRC" ]; then
  echo "Source image '$SRC' not found in current directory."
  echo "Place your high-resolution background image as $SRC and re-run, or pass an explicit path."
  exit 1
fi

if ! command -v cwebp >/dev/null 2>&1; then
  echo "Error: cwebp not found. Install libwebp (cwebp) and retry."
  exit 1
fi

mkdir -p "$OUT_DIR"
echo "Generating WebP variants from $SRC into $OUT_DIR..."

# Define widths and corresponding quality settings
sizes=(2000 1200 800)
qualities=(85 82 78)

for i in "${!sizes[@]}"; do
  w=${sizes[$i]}
  q=${qualities[$i]}
  out="$OUT_DIR/bg-${w}.webp"
  echo "  - $out (width=${w}, quality=${q})"
  # -m 6: best (but slowest) compression method
  # -preset photo: tuned for photos
  # -mt: enable multi-threading
  # -af: auto-filter (better quality/compression)
  # -metadata none: strip EXIF/ICC/XMP to reduce size
  cwebp -q "$q" -m 6 -preset photo -mt -af -metadata none -resize "$w" 0 "$SRC" -o "$out"
done

# Optional: generate a tiny blurred placeholder (LQIP) for progressive loading
lqip_out="$OUT_DIR/bg-lqip.webp"
if command -v convert >/dev/null 2>&1; then
  echo "Generating low-quality placeholder $lqip_out"
  # resize to tiny width then blur to create a base64-friendly placeholder
  convert "$SRC" -resize 20 -filter Gaussian -blur 0x8 -quality 50 "$lqip_out"
else
  echo "ImageMagick 'convert' not found; skipping LQIP generation."
fi

echo "Done. Generated:"
ls -lh "$OUT_DIR"/bg-*.webp || true