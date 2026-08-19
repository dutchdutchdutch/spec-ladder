# Ontology — training slice

Entities, attributes, relationships, states, and invariants. This file is
generative: schema, types, validators, and model-level tests derive from it.
Changing behavior in code without changing this file in the same commit is
drift.

## Entities

### Athlete
| Attribute | Type | Notes |
|---|---|---|
| id | uuid | |
| name | string | |
| consent_given | boolean | see INV-09 |
| consent_recorded_at | datetime? | set once, immutable |
| status | enum: `active` \| `paused` \| `archived` | |

Relationships: has many `Program` (0..n). At most one Program `active` at a time
(INV-02).

### Program
| Attribute | Type | Notes |
|---|---|---|
| id | uuid | |
| coach_id | uuid → Coach | required |
| athlete_id | uuid → Athlete | required |
| goal_type | taxonomy: goal_type | closed list, see TAXONOMY.md |
| status | enum: `draft` \| `published` \| `active` \| `completed` \| `archived` | |

Relationships: has many `Workout` (0..n), ordered. Deleting a draft Program
cascades to its Workouts; published+ Programs are never deleted, only archived.

**States and legal transitions:**

```
draft → published        (Coach only; INV-07)
published → active       (on Athlete acceptance)
active → completed       (all Workouts completed or skipped)
draft|published|completed → archived
```

No other transitions exist. In particular: no un-publish, no un-archive.

### Workout
| Attribute | Type | Notes |
|---|---|---|
| id | uuid | |
| program_id | uuid → Program | required |
| type | taxonomy: workout_type | closed list |
| scheduled_for | date | |
| status | enum: `scheduled` \| `completed` \| `completed_pending_sync` \| `skipped` | |

Relationships: has many `Exercise` entries, each with many `Set` (1..n when
completed).

### Set
| Attribute | Type | Notes |
|---|---|---|
| reps | int? | one of reps or duration required |
| load_kg | decimal? | |
| duration_s | int? | |
| logged_at | datetime | |

## Invariants

| ID | Invariant |
|---|---|
| INV-01 | Every `Program` has exactly one `Coach` and one `Athlete`. |
| INV-02 | An `Athlete` has at most one `active` Program at a time. |
| INV-03 | A `Workout` belongs to exactly one `Program`; it cannot move between Programs. |
| INV-05 | A logged `Set` is immutable 24 hours after `logged_at`. |
| INV-07 | A `Program` may not transition `draft → published` unless it contains at least one `Workout`. |
| INV-09 | An `Athlete` cannot proceed past `Intake` unless `consent_given = true`, captured by an explicit affirmative action (see DR-044). `consent_recorded_at` is set once and never modified. |
| INV-11 | A `Workout` completed offline syncs exactly once; sync must not create a duplicate Workout or duplicate Sets. |

Invariants are model-level truth. Tests for them are **derived**, not
hand-written — see `SCENARIOS.md` for what does get hand-written.
