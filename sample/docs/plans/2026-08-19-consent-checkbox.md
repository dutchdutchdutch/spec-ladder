# Plan: implement consent checkbox (DISPOSABLE)

Implements: **SC-021** · Governed by: **DR-044**, **INV-09** · Design:
DESIGN.md delta 2026-08-19 · Copy: `data.consent.checkbox_label`,
`data.consent.body`

This plan defines nothing. Every behavior below is a citation; if a step seems
to conflict with spec/, spec/ wins and this plan is wrong.

## Steps

1. Add `consent_given`, `consent_recorded_at` per ONTOLOGY.md Athlete table.
2. Consent step UI: checkbox (key `data.consent.checkbox_label`) + disabled
   Continue until checked. Compose from the existing checkbox pattern
   (Program builder frame) — tier 2, no new pattern.
3. On continue: set both fields; `consent_recorded_at` write-once (INV-09).
4. Tests: hand-written `tests/sc-021-consent.test.ts` tagged SC-021; derived
   test for INV-09 write-once in `tests/derived/`.

## Done when

SC-021 passes end-to-end; INV-09 derived test passes; legal-owned keys rendered
verbatim from CONTENT.md (no transcribed Figma text).

*(After execution this file can be deleted — SC-021, DR-044, and INV-09 carry
the truth.)*
