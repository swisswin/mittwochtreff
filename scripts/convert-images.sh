#!/usr/bin/env bash
# scripts/convert-images.sh
# Usage: ./scripts/convert-images.sh [source-image] [out-dir] [hash]
#   source-image: path to high-res image (default: background.png)
#   out-dir: output directory (default: .)
#   hash: set to "hash" to enable content-hashed filenames (short sha1)
# Requires: cwebp (from libwebp). Optionally ImageMagick `convert` for resizing/LQIP
#           and `cavif` or `avifenc` for AVIF generation.
set -euo pipefail

SRC=${1:-background.png}
OUT_DIR=${2:-.}
HASH_FLAG=${3:-}

if [ ! -f "$SRC" ]; then
  echo "Source image '$SRC' not found in current directory."
  echo "Place your high-resolution background image as $SRC and re-run, or pass an explicit path."
  exit 1
fi

if ! command -v cwebp >/dev/null 2>&1; then
  echo "Error: cwebp not found. Install libwebp (cwebp) and retry."
  exit 1
fi

# detect AVIF encoder
AVIF_TOOL=""
if command -v cavif >/dev/null 2>&1; then
  AVIF_TOOL="cavif"
elif command -v avifenc >/dev/null 2>&1; then
  AVIF_TOOL="avifenc"
fi

# detect ImageMagick convert (needed for AVIF resizing and LQIP)
HAS_CONVERT=0
if command -v convert >/dev/null 2>&1; then
  HAS_CONVERT=1
fi

# detect a hash tool
HASH_CMD=""
if command -v sha1sum >/dev/null 2>&1; then
  HASH_CMD="sha1sum"
elif command -v shasum >/dev/null 2>&1; then
  HASH_CMD="shasum"
fi

mkdir -p "$OUT_DIR"
echo "Generating variants from $SRC into $OUT_DIR..."

# Define widths and corresponding quality settings
sizes=(2000 1200 800)
webp_qualities=(85 82 78)
avif_qualities=(48 48 52) # approx quality for AVIF encoders

# helper to compute short hash
short_hash() {
  local file=$1
  if [ -z "$HASH_CMD" ]; then
    echo "";
    return
  fi
  if [ "$HASH_CMD" = "sha1sum" ]; then
    sha1sum "$file" | awk '{print substr($1,1,8)}'
  else
    shasum -a 1 "$file" | awk '{print substr($1,1,8)}'
  fi
}

# temp files to clean
tmp_files=()

for i in "${!sizes[@]}"; do
  w=${sizes[$i]}
  wq=${webp_qualities[$i]}
  aq=${avif_qualities[$i]}

  webp_out="$OUT_DIR/bg-${w}.webp"
  echo "  - creating $webp_out (width=${w}, webp-q=${wq})"
  cwebp -q "$wq" -m 6 -preset photo -mt -af -metadata none -resize "$w" 0 "$SRC" -o "$webp_out"

  # generate AVIF if tool and convert available
  if [ -n "$AVIF_TOOL" ] && [ "$HAS_CONVERT" -eq 1 ]; then
    tmp_png="$OUT_DIR/.tmp-${w}.png"
    echo "    - preparing resized PNG $tmp_png for AVIF encoding"
    convert "$SRC" -resize "${w}x" -strip -quality 90 "$tmp_png"
    tmp_files+=("$tmp_png")

    avif_out="$OUT_DIR/bg-${w}.avif"
    echo "    - encoding AVIF $avif_out (avif-tool=$AVIF_TOOL, q=${aq})"
    if [ "$AVIF_TOOL" = "cavif" ]; then
      cavif -q "$aq" -o "$avif_out" "$tmp_png"
    else
      # avifenc: quality param range depends on encoder; use --min/--max as a safe default when available
      avifenc -q "$aq" "$tmp_png" "$avif_out" || avifenc "$tmp_png" "$avif_out"
    fi
  else
    if [ -z "$AVIF_TOOL" ]; then
      echo "    - AVIF tool not found (cavif/avifenc); skipping AVIF for width $w"
    elif [ "$HAS_CONVERT" -ne 1 ]; then
      echo "    - ImageMagick 'convert' not found; skipping AVIF for width $w"
    fi
  fi

  # optional content-hash rename
  if [ "$HASH_FLAG" = "hash" ]; then
    # hash webp
    if [ -n "$HASH_CMD" ]; then
      h=$(short_hash "$webp_out")
      if [ -n "$h" ]; then
        new_webp="$OUT_DIR/bg-${w}-$h.webp"
        mv "$webp_out" "$new_webp"
        webp_out="$new_webp"
      fi
    else
      echo "Warning: no hashing tool available (sha1sum/shasum); skipping hashed filenames."
    fi
    # hash avif if present
    if [ -n "$AVIF_TOOL" ] && [ -f "$avif_out" ]; then
      if [ -n "$HASH_CMD" ]; then
        h2=$(short_hash "$avif_out")
        if [ -n "$h2" ]; then
          new_avif="$OUT_DIR/bg-${w}-$h2.avif"
          mv "$avif_out" "$new_avif"
          avif_out="$new_avif"
        fi
      fi
    fi
  fi

done

# Optional: generate a tiny blurred placeholder (LQIP) for progressive loading
lqip_out="$OUT_DIR/bg-lqip.webp"
if [ "$HAS_CONVERT" -eq 1 ]; then
  echo "Generating low-quality placeholder $lqip_out"
  convert "$SRC" -resize 20 -filter Gaussian -blur 0x8 -strip -quality 50 "$lqip_out"
  if [ "$HASH_FLAG" = "hash" ] && [ -n "$HASH_CMD" ]; then
    h3=$(short_hash "$lqip_out")
    if [ -n "$h3" ]; then
      mv "$lqip_out" "$OUT_DIR/bg-lqip-$h3.webp"
      lqip_out="$OUT_DIR/bg-lqip-$h3.webp"
    fi
  fi
else
  echo "ImageMagick 'convert' not found; skipping LQIP generation."
fi

# cleanup temp files
for tf in "${tmp_files[@]:-}"; do
  [ -f "$tf" ] && rm -f "$tf"
done

echo "Done. Generated:"
ls -lh "$OUT_DIR"/bg-* || true
