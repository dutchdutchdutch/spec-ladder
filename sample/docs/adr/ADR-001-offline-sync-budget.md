---
id: ADR-001                  # permanent, never renumbered or reused
title: Offline sync completes within 30 seconds of reconnect
status: firm                 # exploring | provisional | firm | superseded
decided: 2026-08-19
expires:                     # required unless status is firm
measured_by: sync_latency_p95 (dashboard, not this file)
relates_to: [SC-014, INV-11]
---

**Budget.** After a device regains connectivity, queued Workouts finish syncing
within 30 seconds at p95.

**Why.** SC-014 already fixes the *functional* contract: logging works with no
network, and reconnect syncs exactly once with no duplicate Workout. That is
binary and observable in a single run, so it belongs in `spec/SCENARIOS.md`.
How *fast* that sync completes is not observable in one run — it needs a
measurement regime — so it is a budget and it lives here.

**What would change my mind.** Median queue depth on reconnect exceeds 50
Workouts, or the p95 exceeds 30s for two consecutive weeks with no regression
in the sync path. Either means the budget was set against the wrong workload.

**Rejected.** Writing the 30s into SC-014. It would put a statistical target
into a file a domain expert is meant to veto by reading, and it would make the
scenario un-passable in a single test run.

**Consequences.** The sync path needs batching and a retry ceiling. The number
is checked on a dashboard, never asserted in the scenario suite — an
end-to-end test that fails on timing is a flaky test, not a done criterion.
