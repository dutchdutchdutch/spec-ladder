---
name: slopmonster
description: Score and de-slop prose in this repo with SlopMonster. Lint wiki articles and blog posts for AI tells, rewrite, cleanse on a second Claude model, lint again. Trigger on /slopmonster, "de-slop this", "does this sound like AI", "score this article", "fix this copy".
---

# SlopMonster (this repo's wiring)

Upstream lives at `tools/slopmonster/` (git submodule). This skill is the repo-specific
loop. Claude only: no Gemini (dropped 2026-09-06 after quota and 503 failures), never
OpenAI. A model is poor at hearing its own accent, so the two roles go to **two different
Claude models**: the running session writes the draft, and `tools/cleanse.sh` sends it to
a different Claude model (Sonnet by default, Opus when the session itself is Sonnet).
The running session never cleanses its own text. The regex rescore has the final word.

The loop, always in this order. The scorer gets the first word and the last word.

```
1. SCORE     tools/slop.sh <files>        each file out of 5, exit 1 below 5
2. REWRITE   by hand, three passes         see "Rewrite" below
3. CLEANSE   tools/cleanse.sh draft.md     a second Claude model strips the tells
4. RESCORE   tools/slop.sh cleansed.md     ship only at 5/5
```

## Step 1: score

```bash
tools/slop.sh                                # every wiki article
tools/slop.sh wiki/Home.md                   # one file
tools/slop.sh ../ag-periodicals/*.md         # blog posts in another repo
tools/slop.sh wiki/Home.md --allow-proof     # the numbers are real and evidenced
```

Read the hit list before touching anything. Some hits are this project's fixed
vocabulary (for example "Conventions, Vocabulary, and Scenarios" names three real
layers). Leave those and tell the user which hits you kept and why.

## Step 2: rewrite

Full catalogue: `tools/slopmonster/references/signs-of-ai-writing.md`. Principles for
what goes in the tells' place: `tools/slopmonster/references/principles.md`.

1. **Vocabulary.** Replace `leverage`, `unlock`, `journey`, `seamless`, `robust`,
   `level up` and friends with a plainer word, not a posher synonym.
2. **Shapes.** Break two-em-dash sentences into two sentences or use commas. Turn
   rule-of-three lists into two or four items when that is truer. Cut "not just X, but Y".
   Cut semicolon chains in web copy.
3. **A person.** Vary sentence length. Keep one rough edge. One concrete number per
   claim, taken only from the source text.

Keep the author's meaning and claims exactly. Preserve markdown structure, links,
code spans and image references untouched. Never invent a fact, count or quote. If a
sentence needs a number that is not there, write `[needs number]`.

## Step 3: cleanse on a second Claude model

```bash
tools/cleanse.sh --strip draft.md > /tmp/home-cleansed.md              # Sonnet cleanses
DRAFT_MODEL=sonnet tools/cleanse.sh --strip draft.md > /tmp/x.md       # session is Sonnet: Opus cleanses
CLEANSE_MODEL=opus tools/cleanse.sh --strip draft.md > /tmp/x.md       # Opus on request
TIMEOUT=600 tools/cleanse.sh --strip draft.md > /tmp/x.md              # long page
```

Set `DRAFT_MODEL` to the model this session runs on (Fable and Opus count as `opus`,
Sonnet as `sonnet`). The script refuses to cleanse on the drafting model and moves to
the other one. It runs `claude -p` as a plain copy editor: no tools, one turn, from a
temp directory so this tree's `CLAUDE.md` does not colour the register. If the CLI is
missing, it prints the full prompt so the user can paste it into a chat by hand. Never
do the rewrite yourself inside this session and call it the cleanse. Run the script.

Without `--strip` the output ends with a `---` line and up to five bullets naming what
changed. `--strip` drops that trailer from stdout and prints it on stderr instead, so the
result can be written straight back over the article.

## Step 4: rescore

```bash
tools/slop.sh /tmp/home-cleansed.md
```

Below 5/5, go back to step 2 on the remaining hits. Show the user a diff of the
article before replacing it. The user reviews every prose change before it is committed.

## Hard rules

- Never invent proof: no user counts, testimonials or ratings the project has not earned.
- Read the cleanse's "what changed" bullets before using its output. If the model says it
  "added" an opinion, a failure, or a first-person line, that line is invented: cut it.
  The wrapper's system prompt forbids this, but the rescore cannot see it, so you must.
- Never run the cleanse in the same session, or on the same model, that wrote the draft.
  Two Claude models, one per role. No Gemini, no OpenAI.
- Cleanse pages in parallel with care: four `claude -p` runs at once is fine, but give
  a long page its own `TIMEOUT`.
- `python3 tools/slopmonster/tools/test_deslop.py` must pass after any regex change
  (regex changes belong upstream, not in this repo).
