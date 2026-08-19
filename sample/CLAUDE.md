# Stride

Coaching app: Coaches build Programs of Workouts for Athletes.

**Before implementing anything, read `spec/CLAUDE.md`.** The `spec/` directory
is authoritative; code and plans are downstream of it. A behavior present in
code but absent from `spec/` is drift, not a requirement.

## Conventions

- TypeScript, strict mode. Tests in `tests/`, tagged with the `SC-###` they
  verify.
- Plans live in `docs/plans/` and are disposable — they cite spec IDs, they
  never define behavior.
- Never invent a noun: if a concept has no entry in `spec/VOCABULARY.md`, stop
  and ask.
