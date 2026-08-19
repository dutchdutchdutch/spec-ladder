# Design — training slice

## Baseline

Source: Figma **"Stride Training v3 — 2026-08-14"** (named version, not the
live file). Live-file changes are not truth until re-pinned here.

Covered frames: Intake (all steps incl. consent), Program builder (empty,
populated, publish-blocked), Workout logger (online, offline).
Not covered — derive from patterns: Program archive, settings, error toasts.

## Authority by layer

| Layer | Owner | Binding here? |
|---|---|---|
| Layout, spacing, hierarchy | Figma baseline | yes |
| Component + interaction | Figma baseline + deltas below | yes |
| States drawn in frames | ONTOLOGY + Figma | yes |
| **Copy** | **CONTENT.md** | **never** — text layers are samples |
| Uncovered screens | pattern derivation | propose, don't invent new patterns |

Figma text layers prefixed `~` are placeholders; unprefixed text is a sample of
the firm string, but CONTENT.md always wins. **Never transcribe text from a
frame — look up the key.**

## Deltas

Current truth = baseline + these, in order. When a frame carries more than 5
active deltas, it is due for re-pinning (designer absorbs them, new version
pinned, deltas clear).

### Intake — consent step
- 2026-08-19 · **DR-044** · Continue-only replaced by required checkbox
  (`data.consent.checkbox_label`) + Continue; Continue disabled until checked.

### Change tiers (for anyone making updates)

1. **Copy** → edit CONTENT.md; git is the log. Legal-owned keys need legal
   sign-off in the commit.
2. **Small structural change composed from existing patterns** → DR with
   `lens: [design]` + delta line here + downstream spec edits, same commit.
3. **New pattern** → `exploring`/`provisional` DR, designer review is the
   trigger. Propose, don't ship.
