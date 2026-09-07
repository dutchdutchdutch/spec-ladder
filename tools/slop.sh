#!/usr/bin/env bash
# Score markdown files for AI-writing tells with SlopMonster (tools/slopmonster).
#
#   tools/slop.sh                       # score every wiki article
#   tools/slop.sh wiki/Home.md          # score one file
#   tools/slop.sh path/to/*.md          # score any set of files
#
# Each file gets a score out of 5. Exit status is non-zero if any file scores below 5.
# Extra flags such as --allow-proof are passed through to deslop.py.
set -uo pipefail

HERE="$(cd "$(dirname "$0")" && pwd)"
DESLOP="$HERE/slopmonster/tools/deslop.py"

if [ ! -f "$DESLOP" ]; then
  echo "slop: submodule missing. Run: git submodule update --init" >&2
  exit 66
fi

flags=()
files=()
for arg in "$@"; do
  case "$arg" in
    --*) flags+=("$arg") ;;
    *)   files+=("$arg") ;;
  esac
done
[ "${#files[@]}" -eq 0 ] && files=("$(cd "$HERE/.." && pwd)"/wiki/*.md)

status=0
for f in "${files[@]}"; do
  echo "=== $f"
  python3 "$DESLOP" "$f" ${flags[@]+"${flags[@]}"} || status=1
  echo
done
exit $status
