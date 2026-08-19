# PRD — training slice (thin)

This file carries intent: why, who, scope, and quality bars. It defines no
entities, no terms, no strings — those live in the contracts it references.

## Problem

Independent coaches manage athletes over spreadsheets and texts. Programs drift,
adherence is invisible, and nothing survives a coach's vacation.

## Users

- **Coach** — authors Programs, monitors adherence. Desktop-first.
- **Athlete** — follows Workouts, logs Sets. Mobile-first, often offline in
  gyms (hence SC-014 / INV-11).

## Scope — v1

In: concierge Intake (DR-041), Program authoring and publishing (SC-012),
Workout logging with offline sync (SC-014), explicit consent (SC-021, DR-044).

**Deliberately cut:** self-serve athlete signup (until DR-041 expires),
payments, messaging, EHR integration (rejected in DR-041), wearable import.

## Non-functional targets

- Offline logging: full Workout logging with zero connectivity; sync < 30s
  after reconnect.
- Consent step: meets legal's approved wording exactly (CONTENT.md keys with
  `owner: legal`).
- Athlete app usable one-handed mid-workout.

## Success metrics

- 80% of scheduled Workouts logged within 24h.
- Coach authors a Program in < 15 minutes.
- Zero duplicate-sync incidents (INV-11 is the contract; this is the outcome).

## Rationale worth keeping

Concierge-over-integration reasoning lives in DR-041 — read it before proposing
an importer. Consent-as-checkbox reasoning lives in DR-044 — compliance-driven,
firm.
