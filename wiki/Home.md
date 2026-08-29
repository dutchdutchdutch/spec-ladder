# The Spec Ladder

**Problem: Source of truth confusion** kills team momentum which kills confidence, the remediations often cause more drift in debt beyond the codebase, in design, in specs, in PRDs, etc.

Coding agents are literal, and tireless, which means they amplify whatever we feed them. Feed them a crisp contract and they produce what we meant. Feed them multiple overlapping documents and they invent the gaps.

**Proposal: one `spec/` folder, layered by kind of truth** so coding agents build without guessing, and every team member can read, correct, and steer without touching code.

**Root cause: PRDs spawn** Designs, Stories, test Cases Slack threads. Each a partial copy of the same feature, each drifting from the others. After a while nobody can say which one is authoritative, so the agent picks one, implements it. And if incorrect, we often spent days till the drift is uncovered and hours debating which source is the right one.

**The change.** One document per kind of truth. Eight layers, each added only when its specific pain shows up. A new major use case, component or feature, starts with three of them. Conventions, Vocabulary, and Scenarios; roughly three pages.

**What's different for you.** Five of the eight layers are plain language and yours to edit — no design file, no dev ticket, no code. The by-role breakdown is at the [end of this page](#what-this-might-change-for-you).

---

## The problem is drift, not the PRD

PRDs are rarely read by anyone but the author — and neglect is the smaller issue. The PRD gets transcribed into designs and stories, every transcription drifts, and the corrections land in Slack, legible to humans and invisible to agents. Nothing routes back fast enough.

Volume compounds it. When five artifacts describe the same feature, none of them is the source of truth. And prose is ambiguous exactly where it hurts: one section says "session," the next says "workout." The spec calls for an explicit checkbox on the consent form; the design shows a slider. Every reader, human or agent, resolves those conflicts differently.

The fix: split truth by *kind*, give each kind a home that stays load-bearing after release, and add each home only when its specific pain shows up. That's the ladder.

## The ladder

Read bottom-up. Each layer arrives when its trigger fires, never on principle. Every layer costs maintenance, and a stale spec is worse than no spec.

![The spec ladder — eight layers, each with the trigger that adds it](fig1-spec-ladder.png)

*Teal = machine-checkable contract · Amber = human steering · Outline = always-on base*

> **Start a new area with base + vocabulary + scenarios** — roughly three pages. That alone kills the two biggest agent failure modes: naming drift and invented behavior.

## What each layer buys

| Layer | The agent gets | You get |
| :---- | :---- | :---- |
| `VOCABULARY` | Deterministic naming — no synonym guessing | Your own domain words back, at near-zero reading cost |
| `ONTOLOGY` | A generative source for schema, types, validators | A picture of what exists, correctable without reading code |
| `VALUE-STREAM` | Sequencing context — the state of the world before and after what it's building, and which handoffs are deliberately human | The end-to-end map of how value moves, on one page |
| `SCENARIOS` | Concrete acceptance targets to verify against | Plain-language stories anyone can veto |
| `decisions/` | Knowledge of where to hold firm and where to explore | Visibility into what's settled, without asking anyone |
| `PRD` | A tiebreaker for intent | The strategic conversation, minus the definitions |
| `DESIGN` + `CONTENT` | Pixel truth, plus copy it must never transcribe | Copy edits with no designer on the critical path |

**Scenarios are the steering sweet spot** — the one place where agent precision and human readability peak together. A domain expert reads a scenario and says "that's not how it should feel" without knowing what an invariant is. Read one spec file, read that one.

Insert note: on how certain projects will favor heavy reliance on story/issue detail but that is team dependent. Many people get lost in the web of stories. And stories start to overlap and duplicate quickly, the larger the team the bigger the maintenance becomes

## The value stream: the spine between ontology and scenarios

One step, one question no other layer holds: **in what order does value move through the domain, and who moves it?** For us: intake → consent → program authored → published → athlete training → outcomes.

**The thinnest form is an ordered list of stages, three facts per stage.** An actor. Entry and exit conditions written as ontology states, never prose. The scenario IDs that anchor the stage. Roughly fifteen lines per slice.

That thinness is possible because only three things are net new here — everything else already has a home:

1. **Cross-entity order.** The ontology gives each entity its own state machine; the stream composes them end to end. No entity owns the sequence.
2. **The actor at each handoff.** No entity owns "a human does this step by hand." The stream does — our concierge intake stage points at DR-041 and inherits its expiry. The stream shows *where* the deliberate waste sits; the decision record says *why and until when*.
3. **Scenario completeness.** Scenarios zoom in on stages and transitions. A stage or handoff with no anchoring scenario becomes a visible gap instead of a silent one — and the stream is what tells us which journeys count as primary in the first place.

What stays out keeps it thin. Observed metrics — cycle times, wait times, waste percentages — belong on dashboards, not in spec; a stream quoting last month's numbers is stale by next month, and a stale spec teaches everyone the folder lies. Targets go in the PRD. Per-entity states stay in the ontology. Journey detail stays in scenarios.

One binding rule makes it checkable instead of a wall poster: **entry and exit conditions must be ontology states.** An agent can then verify every stage boundary is reachable, no state is orphaned outside the stream, and stage order agrees with the legal transitions.

Trigger to add it: scenarios accumulate but nobody can say how they compose end to end; "what happens between X and Y" keeps recurring; or a human handoff is invisible to the people and agents building around it.

## Three concerns, one shared center

Every argument we have reduces to three questions: is it *valuable*, is it *feasible*, is it *usable*. The layers sort themselves onto that map. Three artifacts sit dead center, read and written by all three concerns.

![Valuable, Feasible, Usable — with Vocabulary, Value stream, and Scenarios at the shared center](fig2-venn.png)

Shared language and journey stories are the first layers we add and the last we'd cut. The value stream joins them at the center once its trigger fires — product reads it for what value flows, devs for the states that bound each stage, design for the journey users actually travel. The pairwise edges hold the decision records with multiple lenses: the contested ones.

## Decisions: firm ground vs. open ground

Teammates and agents share one hard question: what's safe to build on, and what's still in play? One `decisions/` folder answers it — one file per decision, a permanent ID (`DR-044`), and one field that carries the weight.

**`status`** runs `exploring` → `provisional` → `firm`, with `superseded` for anything replaced. Promotion is always a human act, and provisional records carry an expiry so they can't quietly harden into permanent ones.

Mechanics — expiry triggers, lenses, and how a record gets reopened — are in [[Decision Records: The Operating Model|Decision-Records-Operating-Model]].

## Design and copy, without bottlenecks

Figma or another prototype is a **pinned baseline**, not live truth. We reference a named version; current design truth = that baseline plus a short delta log in the spec. That single move unlocks three tiers of change:

| Change | Process | Who's involved |
| :---- | :---- | :---- |
| **Copy** | Edit the keyed string in `CONTENT.md`; git is the log | Product, marketing, support — directly. Legal-owned keys need legal. |
| **Small structural** | Decision record plus one delta line, composed from existing patterns | Anyone proposes; no designer blocking |
| **New pattern** | Recorded as `exploring`; designer review is the trigger | Designer — on purpose |

Every string in the product carries a key (`data.consent.body`), a status, and an owner. Figma text layers are samples, and agents are forbidden from transcribing them. When deltas pile up on a frame, the designer absorbs them into Figma on their own cadence and we re-pin. The loop closes without ever blocking on it.

Copy itself is collaborative — marketing sets tone, design sets register, a copywriter drafts, product owns the hard strings — and every shipped tweak rides the full pipeline, so churn is expensive. The key's `status` carries the distinction: `working` copy ships but is expected to change and batches into sweeps; `firm` copy changes only through its owner. The full model is in [[Content: Working Truth vs Firm Truth|Content-Operating-Model]].

## Ground rules, on one hand

When artifacts disagree, earlier wins:

```
contracts (VOCABULARY → ONTOLOGY → TAXONOMY → VALUE-STREAM → SCENARIOS)
  → firm decisions
  → surfaces (CONTENT → DESIGN)
  → PRD → plans → code
```

One qualifier inside `surfaces`: **CONTENT outranks DESIGN on wording; DESIGN's length and layout constraints bind CONTENT.** A string that busts a 40-character constraint isn't winning a precedence fight, it's non-compliant, the same way a scenario contradicting an invariant is.

Five rules:

1. **No noun outside the vocabulary.** A missing term is a question, not an invitation.
2. **IDs are permanent.** `SC-021` and `DR-044` mean the same thing forever.
3. **Derive what you can, hand-write what you must.** Rule-restatements are generated; journeys are authored.
4. **Provisional needs an expiry.** Otherwise it's a permanent decision nobody admitted making.
5. **Same-commit.** A behavior change without its spec change is drift, and it bounces.

Questions, objections, and "that scenario is wrong" are the point. Cheap steering is what we're after.

## What this might change for you

Five of the eight layers are plain language and yours to edit — no design file, no dev ticket, no code.

| You are | You edit directly | What it buys you |
| :---- | :---- | :---- |
| **Product** | `SCENARIOS.md` · `decisions/` · `VALUE-STREAM.md` | Scope debates end in a decision record, not a thread |
| **Business owner / domain expert** | `SCENARIOS.md` · `VOCABULARY.md` · `VALUE-STREAM.md` | "That's not how it works" — and "there's a whole stage missing" — are our highest-leverage corrections |
| **Marketing / support** | `CONTENT.md` | Propose any string freely; confirm the ones you own — `working` vs `firm` marks which is which |
| **Design** | `DESIGN.md` | You absorb small deltas on your cadence; new patterns still route to you first |
| **Dev / tech lead** | `ONTOLOGY.md` · `spec/CLAUDE.md` | Schema and tests generate from the spec; behavior changes without spec changes bounce |

By role, if we adopt it:

**Design** — You own layout, components, interaction, and length constraints. You don't own copy. Small changes accumulate as deltas you absorb on your schedule; genuinely new patterns still come to you first. → `spec/training/DESIGN.md`

**Marketing** — You set brand tone as a constraint and propose any string freely; the keys you own, you confirm. No design file, no dev ticket for wording. Legal-locked keys are marked. → `spec/training/CONTENT.md`

**Product** — You own the thin PRD, the scenarios, the value stream, and most decision records, including promotion from exploring to firm. Scope debates end in a DR, not a thread. → `SCENARIOS.md` · `decisions/` · `VALUE-STREAM.md`

**Devs** — You generate schema, types, and model tests from the ontology. Plans cite scenario IDs and get deleted afterward. When the spec is silent, ask — then write the answer back. → `ONTOLOGY.md` · `spec/CLAUDE.md`

**Tech lead** — You guard the precedence chain and the same-commit rule: behavior changes without spec changes bounce in review. You decide when a slice earns its next layer. → `spec/CLAUDE.md`

**Business owners / domain experts** — You read scenarios written in your vocabulary and say "that's not how it works." The value stream gives you the second lever: reading the end-to-end map and saying "there's a whole stage missing between authoring and publishing" — a structural correction no single scenario surfaces. → `SCENARIOS.md` · `VOCABULARY.md` · `VALUE-STREAM.md`

**Customer support** — You get precise bug language from scenario IDs: "SC-014 doesn't hold — I got a duplicate workout" routes itself. The value stream also tells you which stage a complaint lives in. You'll spot missing scenarios before anyone else. → `SCENARIOS.md`
