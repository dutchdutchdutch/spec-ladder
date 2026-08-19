# Content — training slice

Every user-facing string has a key. Code renders keys; Figma shows samples.
Editing a string = editing this file. `owner: legal` + `status: firm` means
locked — do not touch without legal review noted in the commit.

## data.consent

- `data.consent.header` — "Your data, your call"
  status: firm · owner: product · max: 30ch
- `data.consent.body` — "We store your training history and health notes to
  build your program. We never sell your data. Full policy: stride.app/privacy"
  status: firm · owner: legal · **do not edit without legal review**
- `data.consent.checkbox_label` — "I agree to the data policy"
  status: firm · owner: legal · max: 40ch · added by DR-044
- `data.consent.continue` — "Continue"
  status: firm · owner: product

## program.publish

- `program.publish.cta` — "Publish program"
  status: firm · owner: product
- `program.publish.blocked_empty` — "Add at least one workout before
  publishing." status: firm · owner: product · shown in SC-012

## workout.logger

- `workout.logger.offline_badge` — "Offline — saved on this device"
  status: firm · owner: product · max: 40ch
- `workout.logger.synced_toast` — "Workout synced"
  status: draft · owner: product

## Conventions

- Keys are `area.screen.element`, permanent once shipped.
- `status: draft` strings may be changed by anyone; `firm` needs the owner;
  `owner: legal` needs legal.
- `max` is a design constraint that travels with the string — respect it or
  raise a tier-2 change.
