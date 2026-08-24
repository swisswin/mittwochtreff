# Improve image conversion script: stronger cwebp options and LQIP

## Summary

This PR updates `scripts/convert-images.sh` to produce better-optimized WebP background images and a low-quality image placeholder (LQIP). Changes include safety checks, stronger encoder options, metadata stripping, an optional output directory, and optional LQIP generation using ImageMagick.

## Changes

- Adds prerequisite checks for `cwebp` and optional `convert` (ImageMagick).
- Uses improved `cwebp` options: `-m 6`, `-preset photo`, `-mt`, `-af`, and `-metadata none` for better compression and smaller file sizes on photos.
- Supports an output directory argument for generated assets.
- Generates responsive WebP variants at widths: 2000, 1200, 800 with tuned quality settings.
- Optionally generates a tiny blurred placeholder `bg-lqip.webp` when ImageMagick is available.

## How to test

1. Ensure prerequisites are installed:
   - `cwebp` (from libwebp)
   - (optional) `convert` (ImageMagick) for LQIP

2. Make the script executable if needed:
```bash
chmod +x scripts/convert-images.sh
```

3. Run the script with a high-resolution image and an output directory:
```bash
./scripts/convert-images.sh path/to/highres.png dist/images
```

4. Verify output files are created and inspect them:
```bash
ls -lh dist/images/bg-*.webp
# open dist/images/bg-2000.webp in an image viewer or browser
```

5. (Optional) If ImageMagick is installed, ensure `bg-lqip.webp` is present and looks like a small blurred placeholder.

## Notes / Follow-ups

- Consider adding AVIF generation for even better compression (browser support permitting).
- Optionally generate content-hashed filenames for long-term caching and cache-busting.
- Could add a small README or docs snippet demonstrating how to use the generated images in CSS `background-image` or `srcset`.

---

*This file was added automatically to branch `mobile-friendly` as a ready-to-paste PR description.*
