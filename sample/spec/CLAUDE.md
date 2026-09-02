# spec/ — Authoritative Specification

This directory is the source of truth for what this system is and how it behaves.
Code, plans, and tests are downstream of it. When they disagree with `spec/`, they
are wrong.

## Read order

Before writing or changing any code:

1. **`VOCABULARY.md`** — canonical terms. Never use a noun that isn't here.
2. **`ONTOLOGY.md`** — entities, attributes, relationships, states, invariants.
3. **`TAXONOMY.md`** — closed classification lists (these *are* the enums).
4. **`VALUE-STREAM.md`** — ordered stages with stable `VS-#` IDs; entry/exit
   are ontology states. The stream is a loop: adaptation re-enters authoring.
   Slow-moving truth: kept true by owner attestation (quarterly, or within 14
   days of a declared transition), not by the same-commit rule. If its header
   says "under review", treat it as non-binding until re-attested. A missed
   attestation is staleness — surface it; mere non-editing is not.
5. **`SCENARIOS.md`** — journey anchors with stable `SC-###` IDs.
6. **`decisions/`** — all records with `status: firm`. These are constraints.

Read **`PRD.md`** only when you need intent, scope rationale, or non-functional
targets. It explains *why*; it does not define *what*.

Do not treat anything in `docs/plans/` as authoritative. Plans are execution
artifacts — they cite this directory, they never define it.

## Precedence

When two artifacts conflict, resolve in this order:

```
VOCABULARY → ONTOLOGY → TAXONOMY → VALUE-STREAM → SCENARIOS → firm decisions → PRD → plans → existing code
```

Decisions that are not `firm` do not participate in precedence at all — see below.

Existing code is last. A behavior present in code but absent from the spec is
undocumented drift, not a requirement. Surface it; do not preserve it by default.

## Hard rules

**Vocabulary is closed.** If you need a concept that has no canonical term, stop
and ask. Do not introduce a synonym. Do not use `session` for `Workout`,
`user` for `Athlete`, or `plan` for `Program`.

**Scenario IDs are permanent.** `SC-014` refers to the same behavior forever.
Retire a scenario by marking it `status: retired`; never renumber, never reuse.

**Model-level scenarios are derived, not written.** If a test case is a restatement
of an invariant or a state transition already in `ONTOLOGY.md`, generate it from
the model. Only hand-write scenarios that cross entities, involve time, failure,
concurrency, or encode a product decision the model cannot express.

**Invariant changes are same-commit.** Changing a constraint in code requires
updating `ONTOLOGY.md` in the same commit. A commit that alters behavior without
touching the spec will be rejected in review.

**Traceability is bidirectional.** Every plan cites the `SC-` IDs it implements.
Every hand-written test names its `SC-` ID in a comment or tag. Every scenario
names the entities it touches.

## Decisions

`decisions/` holds one record per decision, with a permanent ID (`DR-041`). There
is a single stream — decisions are **not** filed by type. Two fields govern how
you treat each one.

### `status` — how settled it is

This is the field that tells you what you may change.

| Status | What to do |
|---|---|
| `exploring` | Open question. Propose options; do **not** build on it. |
| `provisional` | Build on it, but isolate it behind a seam. Say so if you see a cheaper path. Expect churn. |
| `firm` | Build on it. Do **not** relitigate without escalating to the user. |
| `superseded` | Historical only. Read for context; never as a constraint. |

A record past its `expires` date is **stale**. Surface it; do not silently honor
it, and do not silently discard it.

### `lens` — who cares about it

Multi-valued, drawn from: `technical`, `scope`, `design`, `operational`,
`experimental`. Lenses are for filtering and for knowing whom to ask. They carry
no authority — only `status` does. A decision may hold several; the interesting
ones usually do.

Roughly: `scope` = is it valuable, `technical` = is it feasible, `design` = is it
usable. Decisions sitting at the intersection are the contested ones.

### Rules

**Every decision needs a status.** A record without one is treated as
`exploring` — i.e. not a constraint.

**Provisional and experimental records need an `expires` or a trigger.** A
provisional decision with no expiry is a permanent decision nobody admitted to
making. Refuse to write one without it.

**Every record carries `what would change my mind`.** One line. This is what
tells you where to poke and where to leave alone.

**Superseding does not edit history.** Set the old record to `superseded`, point
it at the new ID, and write a new record. Never rewrite a decision in place to
say something different.

**Promotion is explicit.** `exploring → provisional → firm` is a deliberate act
by the user, recorded in the file. Do not promote a decision because the code now
depends on it.

Use `decisions/TEMPLATE.md` for the exact shape.

## When the spec is silent

Ask. Do not invent.

If the answer is obvious and low-stakes, state the assumption explicitly in your
response, proceed, and write the answer back into the appropriate spec file in the
same change. Silence that gets resolved in code and never recorded is how this
directory rots.

If the answer is not obvious — it changes data shape, permissions, money, or user
trust — stop and ask before writing code.

## File responsibilities

| File | Owns | Does not own |
|---|---|---|
| `VOCABULARY.md` | Canonical term for each concept, aliases to reject | Definitions of behavior |
| `ONTOLOGY.md` | Entities, attributes + types, relationships + cardinality, states + legal transitions, invariants | UI, copy, sequencing |
| `TAXONOMY.md` | Closed, versioned classification lists | Anything open-ended |
| `SCENARIOS.md` | ~20 journey anchors per slice, stable IDs, GWT form | Exhaustive validation cases |
| `PRD.md` | Problem, users, scope + cuts, flows, NFRs, metrics, tradeoff rationale | Entity or term definitions |
| `decisions/` | One decision each, with `status`, `lens`, expiry, and the alternative rejected | Entity definitions; anything only `firm` records may constrain |

## Slice structure

Cross-slice terms live at the root. Slice-specific models live in their own
directory:

```
spec/
  CLAUDE.md
  VOCABULARY.md
  decisions/
  training/
    ONTOLOGY.md
    TAXONOMY.md
    SCENARIOS.md
    PRD.md
  nutrition/
    ...
```

A term used by more than one slice is promoted to root `VOCABULARY.md`. A slice
must not redefine a root term with different meaning.

## Worked example of the shape expected

**Vocabulary entry:**

> `Workout` — a single scheduled or completed training unit belonging to a
> `Program`. Rejected aliases: session, activity, entry.

**Invariant (ontology):**

> `INV-07` — A `Program` may not transition `draft → published` unless it
> contains at least one `Workout`.

**Journey anchor (scenarios):**

```gherkin
# SC-014  entities: Athlete, Workout, Program  invariants: INV-11
Scenario: Athlete completes a workout offline and syncs later
  Given an Athlete has an active Program with a scheduled Workout
    And the device has no network connection
  When they log all sets and mark the Workout complete
  Then the Workout is stored locally with status = completed_pending_sync
    And on reconnect it syncs exactly once, creating no duplicate Workout
```

`INV-07` needs no scenario — it derives. `SC-014` cannot derive, so it is written
by hand and given a permanent ID.
