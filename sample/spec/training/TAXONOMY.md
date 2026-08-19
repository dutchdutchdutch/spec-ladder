# Taxonomy — training slice

Closed, versioned classification lists. These ARE the enums — code must not
extend them, and UI must not offer values absent from them. Additions bump the
version and are a reviewed change, not a code edit.

## workout_type — v2 (2026-08-02)

| Value | Label (see CONTENT.md for display strings) |
|---|---|
| `strength` | Strength |
| `endurance` | Endurance |
| `mobility` | Mobility |
| `recovery` | Recovery |
| `assessment` | Assessment |

v1 → v2: added `assessment`. No values removed; removals require a migration
note.

## goal_type — v1 (2026-07-20)

| Value |
|---|
| `general_fitness` |
| `strength_gain` |
| `endurance_event` |
| `rehabilitation` |
| `weight_management` |

## equipment — v1 (2026-07-20)

`none`, `dumbbells`, `barbell`, `kettlebell`, `bands`, `machine`, `other`

Note: `other` is a deliberate escape hatch pending real usage data — see the
expiry on this choice in decisions/ before treating it as permanent.
