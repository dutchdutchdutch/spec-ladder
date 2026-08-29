# Value stream — training slice

How value moves through the domain, end to end. Ordered stages, three facts
each: an actor, entry/exit as ontology states (never prose), and the scenario
IDs that anchor the stage. Stage IDs (`VS-#`) are permanent, same as SC and DR.

**The stream is a loop, not a line.** VS-7 exits back into VS-3: results
(logged `Set`s) and `Feedback` from one Program inform the draft of the next
(INV-13). Programming adapts; it is never static.

What this file does NOT hold: cycle times, wait times, or any observed metric
(dashboards); targets (PRD); per-entity states (ONTOLOGY); journey detail
(SCENARIOS).

## Stages

| # | Stage | Actor | Entry | Exit | Anchors |
|---|---|---|---|---|---|
| VS-1 | Intake | Coach — **manual**, per DR-041 (expires 2026-11-01) | no `Athlete` record | `Athlete.status = active` ∧ `consent_given = false` | SC-003 |
| VS-2 | Consent gate | Athlete | `Athlete.status = active` ∧ `consent_given = false` | `consent_given = true` (INV-09) | SC-021 · DR-044 |
| VS-3 | Program authoring | Coach | `consent_given = true` ∧ no `active` Program (INV-02); on re-entry from VS-7, `prior_program_id` set (INV-13) | `Program.status = published` (INV-07) | SC-012 |
| VS-4 | Acceptance | Athlete | `Program.status = published` | `Program.status = active` | ⚠ none |
| VS-5 | Training | Athlete (system syncs) | `Program.status = active` | `Program.status = completed` — results accumulate as logged `Set`s (INV-05, INV-11) | SC-014 |
| VS-6 | Feedback — *rolling: runs per Workout inside VS-5* | Athlete | `Workout.status ∈ {completed, completed_pending_sync}` | `Feedback` attached to the Workout (INV-12) | ⚠ none |
| VS-7 | Adaptation | Coach | `Program.status = completed` ∧ its Workouts carry `Set`s and `Feedback` | next `Program.status = draft` with `prior_program_id` set (INV-13) → **re-enters VS-3** | ⚠ none |

## Known gaps (visible on purpose)

Three stages have no anchoring scenario — the only stage transitions nothing
verifies end to end. In priority order:

1. **VS-7 Adaptation** — the loop-closing stage is the product's core claim
   ("programming is not static") and nothing verifies it. Write this one first.
2. **VS-6 Feedback** — new entity, no journey coverage yet.
3. **VS-4 Acceptance** — the `published → active` handoff.

## Checks this enables

Derivable from this file + ONTOLOGY.md, no hand-written tests needed:

1. Every stage's exit state is a legal entry state of the next stage —
   including the loop edge: VS-7's exit satisfies VS-3's re-entry.
2. Every entry/exit condition uses only states that exist in the ontology.
3. Stage order agrees with each entity's legal transitions (e.g. VS-3's exit
   requires `draft → published`, which INV-07 gates).
4. No ontology state is orphaned outside every stage.
5. VS-6 is rolling: its entry does not require VS-5's exit — the check is
   per-`Workout`, not per-`Program`.
