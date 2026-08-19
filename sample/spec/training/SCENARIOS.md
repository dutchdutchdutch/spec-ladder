# Scenarios — training slice

Hand-written journey anchors. Each has a permanent `SC-###` ID — never
renumbered, never reused; retire with `status: retired`. Written in vocabulary
terms only.

**What belongs here:** journeys that cross entities, involve time, failure,
concurrency, or encode a product decision the ontology cannot express.
**What does not:** restatements of invariants — those derive (see
`tests/derived/`).

---

```gherkin
# SC-003  status: active  entities: Athlete, Intake  decisions: DR-041
Scenario: New athlete is onboarded via concierge intake
  Given a Coach has collected an athlete's intake by hand
  When the Coach enters the Intake on the athlete's behalf
  Then an Athlete record is created with status = active
    And no Program exists yet
    And the Athlete receives an invitation to review and consent
```

```gherkin
# SC-012  status: active  entities: Coach, Program  invariants: INV-07
Scenario: Coach attempts to publish an empty program
  Given a Coach has a Program in draft with zero Workouts
  When they attempt to publish it
  Then the transition is blocked
    And the Coach sees why (key: program.publish.blocked_empty)
    And the Program remains in draft
```

```gherkin
# SC-014  status: active  entities: Athlete, Workout, Program  invariants: INV-11
Scenario: Athlete completes a workout offline and syncs later
  Given an Athlete has an active Program with a scheduled Workout
    And the device has no network connection
  When they log all Sets and mark the Workout complete
  Then the Workout is stored locally with status = completed_pending_sync
    And on reconnect it syncs exactly once, creating no duplicate Workout or Sets
```

```gherkin
# SC-021  status: active  entities: Athlete, Consent, Intake
# invariants: INV-09  decisions: DR-044
Scenario: Athlete gives explicit consent before entering the app
  Given an Athlete has been invited after concierge Intake (SC-003)
    And they have reached the consent step
  When they view the step
  Then Continue is disabled and an unchecked required checkbox is shown
    (keys: data.consent.body, data.consent.checkbox_label)
  When they check the checkbox and press Continue
  Then consent_given = true and consent_recorded_at is set exactly once
    And they proceed into the app
```

---

## Selection heuristic (when adding anchors)

One per primary journey, one per money/trust-critical path, one per known-painful
failure mode, one per decision we'd regret losing. Target ~20 per slice. If a
scenario is only interesting because it exercises a validation rule, it is
model-level — delete it and let it derive.
