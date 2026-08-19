# Stride — sample spec-driven repo

A worked example of the **spec ladder**: a layered source of truth that coding
agents can build from deterministically and that domain-familiar humans can read
and steer without learning to code.

Stride is a fictional coaching app: Coaches build Programs of Workouts for
Athletes. The domain is small on purpose — the point is the structure, not the
product.

## Tour by role

**Everyone, first:** read [spec/CLAUDE.md](spec/CLAUDE.md). It's one page and it
is the rulebook everything else obeys.

**Product / domain experts:** start with
[spec/training/SCENARIOS.md](spec/training/SCENARIOS.md) — plain-language
stories of how the product behaves, each with a permanent ID. If a story is
wrong, that's steering: say so. Then
[spec/training/PRD.md](spec/training/PRD.md) for the why and the cuts.

**Designers:** [spec/training/DESIGN.md](spec/training/DESIGN.md) shows how the
Figma baseline is pinned and how small changes accumulate as deltas without you
on the critical path. [spec/training/CONTENT.md](spec/training/CONTENT.md) is
where copy lives — not in your file.

**Marketing / support:** [spec/training/CONTENT.md](spec/training/CONTENT.md).
Every string in the product has a key, a status, and an owner. Copy changes are
edits to this file — no designer, no dev required for the words themselves.

**Devs / tech lead:** [spec/training/ONTOLOGY.md](spec/training/ONTOLOGY.md) and
[spec/VOCABULARY.md](spec/VOCABULARY.md) are the contracts you generate from.
[spec/decisions/](spec/decisions/) tells you what's firm and what's open.
[docs/plans/](docs/plans/) shows a disposable plan citing scenario IDs, and
[tests/](tests/) shows the SC-tag traceability convention.

## The chain in one line

```
VOCABULARY → ONTOLOGY → TAXONOMY → SCENARIOS → firm decisions → PRD → plans → code
```

Earlier beats later. Non-firm decisions don't participate at all.

## What to notice

- `SC-021` (consent checkbox) traces from a decision ([DR-044](spec/decisions/DR-044-consent-checkbox.md))
  through an invariant (`INV-09`), a design delta, two content keys, a plan, and
  a test — grep the ID and you find every artifact it touches.
- [DR-041](spec/decisions/DR-041-concierge-onboarding.md) is `provisional` with
  an expiry. When the date passes, it goes stale loudly, not silently.
- The plan in `docs/plans/` defines nothing. It only cites. Delete it after
  execution and no truth is lost.
