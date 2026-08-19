# Design without screens

**When a project has no UI, the design layer holds the interface contract. It's a stronger baseline than Figma, and it needs less ceremony.**

Companion to *The Spec Ladder*. That post covers the layer and who owns it. This one covers the artifact.

An API has a UX. The producers and consumers who live in it every day form mental models, hit sharp edges, and pay for inconsistency the same way a user does. The design layer exists for them.

## The artifact, by project type

| Project type | What `DESIGN.md` points at |
|---|---|
| REST API | OpenAPI document, plus example request and response payloads |
| GraphQL | SDL schema file |
| Event-driven | AsyncAPI document, or `.proto` and Avro schemas per topic |
| Data product | A data contract such as ODCS, dbt model contracts, DDL for exposed views |
| CLI | Command grammar, flags, exit codes, and a transcript of a real session |

## This layer is not the ontology

The exposed shape diverges from the domain model on purpose. Field names differ from internal ones. You expose a subset. Pagination, cursors, rate-limit headers, error envelopes, and version prefixes live in the interface and nowhere in the domain.

Treating the ontology as the API is the common mistake, and it produces an interface that leaks your internals and can't version independently. That divergence is what earns this layer its own file.

## What DESIGN.md holds

The contract file carries the shape. `DESIGN.md` carries what no schema expresses.

- Idempotency guarantees, and which operations are safe to retry
- Retry and backoff expectations for consumers
- Ordering promises, and where they don't hold
- Deprecation windows and the notice path
- What a consumer should do when a field goes null
- Which errors are retryable and which are terminal

Keep it short. If the schema can say it, the schema says it.

## Pinning costs almost nothing here

| The artifact is | How it pins | What it costs |
|---|---|---|
| A schema or contract in the repo | The commit. Pinned by construction. | Nothing. Same-commit and contract tests do the work. |
| Figma, or anything outside the repo | A named version, plus a delta log in `DESIGN.md` | The delta log, and periodic re-pinning |

An OpenAPI file is versioned, diffable, and checkable against the running service. Figma is none of those, which is the only reason the baseline-and-delta ceremony exists. When the contract lives in the repo, that ceremony collapses into ground rule 5 and a contract test.

## Golden payloads are the mock

Commit two or three example payloads per endpoint next to the contract. A golden response is what a consumer actually reads, the way a user reads a screen. They work as documentation and as test fixtures at the same time.

Same rule as Figma text applies. Sample values are illustrative, and agents must never transcribe them into code.

## Stories and tickets don't belong here

A story describes work to be done. The interface contract describes what exists, and it survives the sprint that produced it. Different kind of truth.

Tickets also mutate. A live-edited ticket reintroduces the drift the ladder exists to remove. Stories belong with `docs/plans/`, disposable, citing the contract and never defining it.

## Copy still has an owner

With no screens, the user-facing strings are error messages, field descriptions, enum labels, and deprecation notices. They go in `CONTENT.md` with a key, a status, and an owner, exactly like button text.

Support and legal should own that copy. Developers should stop inventing error text at 6pm on a Friday, and consumers should stop parsing three different phrasings of the same failure.
