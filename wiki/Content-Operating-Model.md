# Content: Working Truth vs Firm Truth

**Copy is collaborative by nature. The fix for drift isn't one owner — it's one landing spot and one status field. The landing spot is the bundle the product actually ships.**

Companion to *The Spec Ladder*. That post covers where truth lives. This one covers the layer where drift concentrates: the words in the product.

## Why copy drifts hardest

Copy changes are easy to suggest, easy to confuse, and expensive to ship — every tweak rides a PR → test → deploy pipeline, so the cost of confusion compounds. And no single role owns it. Marketing owns brand tone and the promotional surfaces. Design sets the register — conversational or factual — to match the design goals. A copywriter, not marketing per se, often drafts the bulk of it. Product owns the hard copy: consent, product specs, integrations. Legal locks some strings outright.

The final string emerges from feedback loops across all of them. The loops are good — they produce the best combined thinking. The drift comes from their residue: five almost-final versions living in Slack, Figma comments, and PR threads, none marked as the real one.

## Three things the single-owner framing conflated

**Voice constraints.** Rules copy must obey, owned the way `max: 40ch` is owned. Brand tone is marketing's constraint. Register per surface is design's, set in `DESIGN.md`. Constraints bind strings; they are not ownership of strings.

**Authorship.** Anyone drafts — copywriter, PM, support, an agent. Proposing is free and welcome. That's how the combined thinking gets in.

**Confirmation.** Each key has one owner whose act promotes it. Owner means accountable confirmer, not sole author.

## The two statuses

| Status | Licenses | Forbids |
|---|---|---|
| `working` | Shipping it — visibly expected to change. Editing it freely in the bundle. | Wordsmithing it in the deploy pipeline. Treating it as settled. |
| `firm` | Citing it, rendering it verbatim. | Changing it without its owner — legal-owned keys need legal review noted in the commit. |

There is no third status. A legal lock is `firm` plus `owner: legal`.

## Three rules that do the work

**One landing spot, and it is the shipped artifact.** Feedback loops may run anywhere — Slack, Figma comments, PR review. Nothing is true until the key changes in the source-language content bundle: the one file the running product reads. Loop output has exactly one place to land, so the almost-final versions stop competing.

The bundle is the layer. It is not a markdown file that generates the bundle, because generation still leaves the same fact in two places — and the copy that runs is the one that wins. Somebody hotfixes the bundle at midnight to close a legal problem, the description goes stale, and the folder has taught everyone it lies. The format is the team's to pick; the rule is that the spec artifact and the runtime artifact are the same file.

**Shipping never promotes.** A string is not firm because it's in production — that's how placeholder copy calcifies into brand voice nobody chose. Promotion from `working` to `firm` is the owner's act, recorded in the commit. Same rule as decisions: humans promote; usage doesn't.

**Batch the churn.** The pipeline cost per change is fixed, so don't spend it one string at a time. `working` copy accumulates edits in the bundle and lands as periodic copy sweeps — one PR, many strings. A `firm` string changing is a real, deliberate event; that cost is the point.

## What the bundle holds, and what it doesn't

One key, one source-language string, one status, one owner. That is the whole of it, because that is the whole of what drifts across disciplines.

Three things sit outside, and they stay outside:

**Translations.** Derived from the source bundle, in the tooling built for that job. They are downstream truth. Nobody argues across disciplines about whether the German is the German.

**The code that consumes the keys.** Whatever the platforms are and whatever languages they are written in, they hold no literals. That is an engineering concern and it moves at engineering speed.

**How each touchpoint renders the string.** Web, mobile, email, SMS. Layout, truncation, and length limits belong to `DESIGN.md` and to the build check that enforces them, not to the artifact that says what the words are.

The test is the one the value stream uses for metrics: if it moves at a different speed and answers to a different system, it does not belong in the spec folder. Content is what the product says. Delivery is how it arrives.

## Key anatomy

```markdown
- `data.consent.body` — "We store your training history and health notes…"
  status: firm · owner: legal
- `workout.logger.synced_toast` — "Workout synced"
  status: working · owner: product
```

The string, how settled it is, and who confirms it. Nothing else. Constraints are not repeated here: `DESIGN.md` owns length and register, per surface, and a build check enforces them. A limit copied onto the entry is the same drift we just designed out of the string itself.

## Failure modes to watch

- **Wordsmithing in the pipeline.** Copy review in a deploy PR is the most expensive editing surface in the company. Edit in the bundle; ship in sweeps.
- **Production as confirmation.** "It's been live for months" is not a promotion. A named owner is.
- **Constraint-owner acting as string-owner.** Design vetoing wording because it owns the register, marketing rewriting consent because it owns tone. Constraints bind; they don't confer the pen.
- **Feedback residue.** The "final final" version living in a Slack thread. If it didn't land in the bundle, it isn't true.
- **A second home for the string.** A description that generates the bundle, a spreadsheet the marketing team keeps, an English default inlined in a component. Any of them and the layer is decorative.
- **Every tweak its own PR.** Death by a thousand pipelines. Batch `working`; reserve single-string changes for `firm`.

## The working-truth pattern

Copy is the clearest instance of a pattern the whole ladder follows. Every kind of truth in the spec has:

1. **One landing spot** — loops run anywhere; truth lands in one file.
2. **One status axis** — working truth vs firm truth, whatever the layer calls it.
3. **One accountable confirmer** — promotion is a named human's act. Usage never promotes: shipping doesn't firm copy, dependent code doesn't firm decisions, accumulated deltas don't re-pin a baseline.
4. **Free proposal** — ownership gates confirmation, not contribution.

| Instance | Landing spot | Working truth | Firm truth | Confirmer |
|---|---|---|---|---|
| Copy | the content bundle | `working` | `firm` | Key owner |
| Decisions | `decisions/` | `exploring` / `provisional` | `firm` | A named person ([[Decision Records\|Decision-Records-Operating-Model]]) |
| Design | `DESIGN.md` | deltas | re-pinned baseline | Designer, on their cadence |
| Scenarios | `SCENARIOS.md` | proposed scenario | active `SC-###` | Product |

The pattern stays a callout here, not a page of its own — the same add-on-pain rule that governs layers governs abstractions. When a fifth instance shows up asking for it, it earns one.

## What to do with this

If you write copy: draft freely against the constraints, land every version in the bundle, and expect `working` strings to change under you.

If you own keys: confirming is your job, not authoring. Promote deliberately, note legal review where it applies, and refuse to let production tenure stand in for your sign-off.

If you're an agent: render keys verbatim, never transcribe from Figma, treat `working` as shippable-but-unsettled, and never edit a `firm` string without its owner in the loop.
