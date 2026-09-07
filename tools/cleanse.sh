#!/usr/bin/env bash
# Model cleanse for SlopMonster, on two different Claude models.
#
# The rule from upstream (tools/slopmonster): the model that cleanses must not be the
# model that wrote the draft, because a model is poor at hearing its own accent. This
# repo uses Claude only (Gemini was dropped on 2026-09-06: daily quota, 503s, retired
# model names). So the two roles go to two different Claude models:
#
#   DRAFT_MODEL    the model that wrote the draft (the running Claude Code session)
#   CLEANSE_MODEL  the model that strips the tells (default: sonnet)
#
# When both would be the same model the script moves the cleanse to the other one
# (sonnet <-> opus) and says so on stderr. Any other clash is refused.
#
#   tools/cleanse.sh draft.md > cleansed.md                # Sonnet cleanses
#   DRAFT_MODEL=sonnet tools/cleanse.sh draft.md           # session is Sonnet, so Opus cleanses
#   CLEANSE_MODEL=opus tools/cleanse.sh draft.md           # ask for Opus explicitly
#   tools/cleanse.sh --strip draft.md > cleansed.md        # drop the "---" change-log trailer
#   cat draft.md | tools/cleanse.sh -                      # cleanse stdin
#   TIMEOUT=600 tools/cleanse.sh long-page.md              # longer bound for a long document
#
# The cleanse runs `claude -p` as a plain copy editor: no tools, one turn, no session
# saved, and from a temp directory so no CLAUDE.md in this tree colours the register.
#
# Always re-score the output afterwards. A frontier model removes tells and adds
# new ones in the same breath:
#   tools/slop.sh cleansed.md
#
# Exit codes: 2 bad model choice, 66 unreadable/empty draft, 124 timeout,
# 127 claude CLI not found.
set -uo pipefail

HERE="$(cd "$(dirname "$0")" && pwd)"
PROMPT_FILE="$HERE/slopmonster/prompts/cleanse.txt"
TIMEOUT="${TIMEOUT:-300}"

[ -f "$PROMPT_FILE" ] || { echo "cleanse: prompt missing. Run: git submodule update --init" >&2; exit 66; }

STRIP=0
if [ "${1:-}" = "--strip" ]; then STRIP=1; shift; fi

if [ "${1:-}" = "-" ] || [ $# -eq 0 ]; then
  DRAFT="$(cat)"
else
  [ -f "$1" ] && [ -r "$1" ] || { echo "cleanse: cannot read $1" >&2; exit 66; }
  DRAFT="$(cat "$1")"
fi
[ -n "$(printf '%s' "$DRAFT" | tr -d '[:space:]')" ] || {
  echo "cleanse: draft is empty, nothing to cleanse" >&2; exit 66; }

# ---- pick the two models -------------------------------------------------------
DRAFT_MODEL="${DRAFT_MODEL:-}"
CLEANSE_MODEL="${CLEANSE_MODEL:-sonnet}"

other_of() {
  case "$1" in
    sonnet|*sonnet*) echo opus ;;
    opus|*opus*)     echo sonnet ;;
    *)               echo "" ;;
  esac
}

if [ -n "$DRAFT_MODEL" ] && [ "$DRAFT_MODEL" = "$CLEANSE_MODEL" ]; then
  ALT="$(other_of "$CLEANSE_MODEL")"
  if [ -z "$ALT" ]; then
    echo "cleanse: DRAFT_MODEL and CLEANSE_MODEL are both '$CLEANSE_MODEL'. Pick a different CLEANSE_MODEL." >&2
    exit 2
  fi
  echo "cleanse: draft and cleanse would both run on $CLEANSE_MODEL; moving the cleanse to $ALT." >&2
  CLEANSE_MODEL="$ALT"
fi

BIN="$(command -v claude 2>/dev/null || true)"
if [ -z "$BIN" ]; then
  echo "cleanse: claude CLI not found. Paste the block below into a Claude chat on a different model than the one that wrote the draft:" >&2
  echo >&2
  printf '%s\n\n%s\n' "$(cat "$PROMPT_FILE")" "$DRAFT"
  exit 127
fi

echo "cleanse: draft=${DRAFT_MODEL:-session model} cleanse=$CLEANSE_MODEL" >&2

FULL="$(cat "$PROMPT_FILE")

$DRAFT"

# The upstream prompt is written for marketing copy and its third pass asks for "an
# opinion, a preference, a failure". On documentation that invites a made-up
# confession in the author's voice, which is invented proof by another name. The
# system prompt closes that door and keeps the page's own structure.
SYSTEM='You are a copy editor working on one document. Follow the instructions in the message exactly and output only what they ask for. Do not read or write files, do not run tools, do not add commentary.

Two repo-specific rules override the instructions where they clash:
1. This is documentation, not marketing copy. Never add a first-person statement, anecdote, admission, opinion, or any claim about the author or the team that is not already in the source. If a pass asks for one, skip that pass.
2. Keep the document structure exactly: headings, tables, code blocks, links, and every list item as it is, including bold lead-ins on list items. Edit the words inside the structure, never the structure.'

# ---- run it, bounded -------------------------------------------------------------
# macOS has no `timeout`, so roll a bounded run. stdout is the answer; stderr
# carries the CLI's startup chatter. `env -u CLAUDECODE` lets `claude -p` run from
# inside a Claude Code session. The temp cwd keeps this repo's CLAUDE.md out of it.
OUT="$(mktemp)"; ERR="$(mktemp)"; WORK="$(mktemp -d)"
trap 'rm -rf "$OUT" "$ERR" "$WORK"' EXIT

(
  cd "$WORK" && env -u CLAUDECODE "$BIN" -p \
    --model "$CLEANSE_MODEL" \
    --system-prompt "$SYSTEM" \
    --tools "" \
    --max-turns 1 \
    --no-session-persistence \
    "$FULL"
) >"$OUT" 2>"$ERR" </dev/null &
PID=$!; WAITED=0
while kill -0 "$PID" 2>/dev/null; do
  if [ "$WAITED" -ge "$TIMEOUT" ]; then
    kill -9 "$PID" 2>/dev/null; wait "$PID" 2>/dev/null
    echo "cleanse: timed out after ${TIMEOUT}s" >&2; exit 124
  fi
  sleep 2; WAITED=$((WAITED + 2))
done
wait "$PID"; RC=$?

if [ "$RC" -ne 0 ] || [ -z "$(tr -d '[:space:]' <"$OUT")" ]; then
  echo "cleanse: claude ($CLEANSE_MODEL) returned nothing (exit $RC). Its stderr:" >&2
  grep -v -e DeprecationWarning -e 'trace-deprecation' -e 'supports tool updates' "$ERR" >&2
  exit "${RC:-1}"
fi

# ---- optional: strip the change-log trailer -------------------------------------
# The prompt asks for the copy, then a "---" line, then up to five bullets naming
# what changed. With --strip only the copy is printed; the bullets go to stderr so
# the change list is still visible.
if [ "$STRIP" = 1 ]; then
  python3 - "$OUT" <<'PY'
import sys, re
text = open(sys.argv[1], encoding='utf-8').read().rstrip('\n')
lines = text.split('\n')
cut = None
for i in range(len(lines) - 1, -1, -1):
    if lines[i].strip() == '---':
        tail = [l for l in lines[i + 1:] if l.strip()]
        if tail and len(tail) <= 6 and all(re.match(r'\s*([-*+•]|\d+[.)])\s', l) for l in tail):
            cut = i
        break
if cut is None:
    sys.stdout.write(text + '\n')
else:
    sys.stdout.write('\n'.join(lines[:cut]).rstrip('\n') + '\n')
    sys.stderr.write('cleanse: what changed\n' + '\n'.join(lines[cut + 1:]) + '\n')
PY
else
  cat "$OUT"
fi
