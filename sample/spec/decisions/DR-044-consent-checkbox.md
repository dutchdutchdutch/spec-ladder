---
id: DR-044
title: Consent requires an explicit checkbox, not Continue alone
status: firm
lens: [design, scope, operational]
confidence: high
decided: 2026-08-19
expires:
supersedes: []
superseded_by:
touches: [Athlete, Intake, Consent]
scenarios: [SC-021]
---

**Decision.** The consent step shows a required, unchecked checkbox
(`data.consent.checkbox_label`); Continue is disabled until it is checked.
Checking + continuing sets `consent_given = true` and stamps
`consent_recorded_at` exactly once (INV-09).

**Why.** Compliance review found implied consent (Continue alone) insufficient
for the jurisdictions we launch in. An explicit affirmative action is required
and must be provable after the fact — hence the immutable timestamp.

**What would change my mind.** Compliance requirement withdrawn, or superseded
by a jurisdiction-specific flow that requires more than a checkbox.

**Rejected.** Continue-only (the Figma baseline — insufficient under review).
Signature capture (disproportionate friction for the risk level).

**Consequences.** Adds one interaction to Intake. Baseline Figma frame is now
modified by delta — see DESIGN.md. Any future Intake redesign must preserve an
explicit affirmative consent action.
