#!/bin/zsh
# Render the wiki figures from their text sources.
#
#   figures/<name>.infographic   one AntV Infographic DSL file  -> wiki/<name>.png
#   figures/<name>.composite     several parts side by side     -> wiki/<name>.png
#
# A .composite file has optional "title:" and "desc:" lines, then one part path per
# line (relative to figures/). Lines starting with # are comments.
#
# Each DSL source is wrapped in an HTML shell, rendered by headless Chrome at 2x and
# trimmed to its content with Pillow. A composite then lays the trimmed parts out
# bottom-aligned under one heading and is screenshotted the same way. Sources are
# the source of truth; the PNGs in wiki/ are build output kept in git because the
# wiki publish only mirrors wiki/.
#
#   tools/figures.sh                 # build every figure
#   tools/figures.sh fig-scope       # build one (name without extension)
set -e
HERE="$(cd "$(dirname "$0")" && pwd)"
ROOT="$(cd "$HERE/.." && pwd)"
SRC="$ROOT/figures"
OUT="$ROOT/wiki"
BUILD="$ROOT/.figures-build"
CHROME="${CHROME:-/Applications/Google Chrome.app/Contents/MacOS/Google Chrome}"
LIB="https://unpkg.com/@antv/infographic@latest/dist/infographic.min.js"
FONT='-apple-system, "Helvetica Neue", Arial, sans-serif'
mkdir -p "$BUILD"

[ -x "$CHROME" ] || { echo "figures: Chrome not found at $CHROME" >&2; exit 127; }

# Screenshot an HTML file at 2x and trim the result to its content.
shoot() {
  local html="$1" png="$2" w="$3" h="$4"
  "$CHROME" --headless=new --disable-gpu --hide-scrollbars \
    --force-device-scale-factor=2 --window-size=${w},${h} \
    --virtual-time-budget=20000 --screenshot="$png.raw.png" "file://$html" 2>/dev/null
  python3 - "$png.raw.png" "$png" <<'PY'
import sys
from PIL import Image, ImageChops
src, dst = sys.argv[1], sys.argv[2]
im = Image.open(src).convert("RGB")
bg = Image.new("RGB", im.size, im.getpixel((0, 0)))
# ignore faint anti-aliasing and near-background artefacts when finding the content box
box = ImageChops.difference(im, bg).convert("L").point(lambda v: 255 if v > 24 else 0).getbbox()
pad = 40
if box:
    l, t, r, b = box
    im = im.crop((max(0, l - pad), max(0, t - pad), min(im.width, r + pad), min(im.height, b + pad)))
im.save(dst, optimize=True)
print(f"{dst}: {im.width}x{im.height}")
PY
  rm -f "$png.raw.png"
}

# Render one DSL file to a trimmed PNG in the build dir.
render_dsl() {
  # Canvas follows the step count: the library scales a ladder to fill its canvas,
  # so equal per-step sizing is what keeps three ladders on one page comparable.
  local file="$1" name="$2" html="$BUILD/$name.html"
  local n=$(grep -c '^    - label' "$file") w="${3:-1500}" h="${4:-$((300 + n * 100))}"
  {
    cat <<HTML
<!DOCTYPE html><html><head><meta charset="utf-8">
<style>html,body{margin:0;padding:0;background:#FAF9F5} #fig{width:${w}px;height:${h}px}</style>
</head><body><div id="fig"></div>
<script type="text/plain" id="src">
HTML
    cat "$file"
    cat <<HTML
</script>
<script src="$LIB"></script>
<script>
  const syntax = document.getElementById('src').textContent.replace(/^\n/, '');
  const ig = new AntVInfographic.Infographic({ container: '#fig', width: '100%', height: '100%' });
  ig.render(syntax);
  document.fonts?.ready.then(() => ig.render(syntax));
</script></body></html>
HTML
  } > "$html"
  shoot "$html" "$BUILD/$name.png" 1600 900
}

build_single() {
  local name="${1:t:r}"
  render_dsl "$1" "$name"
  cp "$BUILD/$name.png" "$OUT/$name.png"
  echo "built wiki/$name.png"
}

build_composite() {
  local file="$1" name="${1:t:r}" title="" desc="" i=0
  local -a imgs caps subs
  while IFS= read -r line; do
    case "$line" in
      ''|'#'*) ;;
      title:*) title="${line#title:}"; title="${title## }" ;;
      desc:*)  desc="${line#desc:}";  desc="${desc## }" ;;
      *) local pname="${name}-part$i"
         local -a f=("${(@s:|:)line}")
         local src="$SRC/${f[1]// /}" steps=$(grep -c '^    - label' "$SRC/${f[1]// /}")
         render_dsl "$src" "$pname" $((steps * 300)) $((steps * 120 + 80))
         imgs+=("$BUILD/$pname.png"); caps+=("${${f[2]:-}## }"); subs+=("${${f[3]:-}## }")
         i=$((i + 1)) ;;
    esac
  done < "$file"
  local html="$BUILD/$name.html"
  {
    cat <<HTML
<!DOCTYPE html><html><head><meta charset="utf-8">
<style>
  html,body{margin:0;padding:0;background:#FAF9F5}
  body{padding:24px;display:inline-block}
  h1{font:600 34px/1.2 $FONT;color:#2B2B2B;margin:0 0 8px}
  p{font:20px/1.4 $FONT;color:#444;margin:0 0 24px}
  .stack{display:flex;flex-direction:column;gap:8px}
  .col{display:flex;align-items:center;gap:16px}
  .cap{width:230px;text-align:right}
  h2{font:600 28px/1.2 $FONT;color:#2B2B2B;margin:0}
  .cap p{font:18px/1.3 $FONT;color:#555;margin:2px 0 0}
  img{display:block}
</style></head><body>
HTML
    [ -n "$title" ] && echo "<h1>$title</h1>"
    [ -n "$desc" ] && echo "<p>$desc</p>"
    echo '<div class="stack">'
    for ((j = 1; j <= ${#imgs[@]}; j++)); do
      # parts were shot at 2x, so half their pixel height is their natural size
      local h=$(python3 -c "from PIL import Image; print(Image.open('${imgs[$j]}').height // 2)")
      echo "<div class=\"col\"><div class=\"cap\"><h2>${caps[$j]}</h2><p>${subs[$j]}</p></div><img src=\"file://${imgs[$j]}\" style=\"height:${h}px\"></div>"
    done
    echo '</div></body></html>'
  } > "$html"
  shoot "$html" "$OUT/$name.png" 2000 1400
  echo "built wiki/$name.png"
}

if [ $# -gt 0 ]; then
  for n in "$@"; do
    if [ -f "$SRC/$n.infographic" ]; then build_single "$SRC/$n.infographic"
    elif [ -f "$SRC/$n.composite" ]; then build_composite "$SRC/$n.composite"
    else echo "figures: no source for $n" >&2; exit 1; fi
  done
else
  for f in "$SRC"/*.infographic; do build_single "$f"; done
  for f in "$SRC"/*.composite; do build_composite "$f"; done
fi
