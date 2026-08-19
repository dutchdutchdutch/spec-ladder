---
id: DR-041
title: Concierge onboarding instead of EHR integration
status: provisional
lens: [operational, scope]
confidence: medium
decided: 2026-08-19
expires: 2026-11-01
supersedes: []
superseded_by:
touches: [Athlete, Program]
scenarios: [SC-003]
---

**Decision.** Onboard the first 100 athletes by hand — a human transcribes intake
data into the system — rather than building EHR integration.

**Why.** Integration is 6+ weeks of work and we do not yet know which fields
actually drive program generation. Manual onboarding buys that knowledge cheaply
and keeps the data model free to change.

**What would change my mind.** Onboarding exceeds 20 minutes per athlete, or we
cross 100 active athletes — whichever comes first.

**Rejected.** Full EHR integration (too early; we'd be integrating fields we
can't yet justify). Self-serve CSV import (data quality unknown, and it hides the
field-selection question we're trying to answer).

**Consequences.** Makes the intake schema cheap to change — nothing external
depends on it yet. Makes growth past ~100 athletes operationally painful by
design; that pain is the trigger. Reversing this means building the integration
and backfilling manually-entered records.
