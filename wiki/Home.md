# The Spec Ladder

**Problem: Source of truth confusion** kills team momentum which kills confidence, the remediations often more drift in debt beyond the codebase, in design, in specs, in PRDs, etc.

Coding agents are literal, and tireless, which means they amplify whatever we feed them. Feed them a crisp contract and they produce what we meant. Feed them multiple overlapping documents and they invent the gaps.

**Proposal: one `spec/` folder, layered by kind of truth** so coding agents build without guessing, and every team member can read, correct, and steer without touching code.

**Our PRDs spawn** Designs, stories, Slack threads. Each a partial copy of the same feature, each drifting from the others. After a while nobody can say which one is authoritative, so the agent picks one, implements it. And if incorrect, we often spent days till the drift is uncovered and hours debating which source is the right one.

**The change.** One document per kind of truth. Seven layers, each added only when its specific pain shows up. A new major use case, component or feature, starts with three of them. Conventions, Vocabulary, and Scenarios; roughly three pages.

**What's different for you.** Four of the seven layers are plain language and yours to edit. No design file, no dev ticket, no code.

| You are | You edit directly | What it buys you |
| :---- | :---- | :---- |
| **Product** | `SCENARIOS.md` · `decisions/` | Scope debates end in a decision record, not a thread |
| **Marketing / support** | `CONTENT.md` | Every user-facing string is a keyed line you change yourself |
| **Design** | `DESIGN.md` | You absorb small deltas on your cadence; new patterns still route to you first |
| **Domain expert** | `SCENARIOS.md` · `VOCABULARY.md` | Reading a journey and saying "that's not how it works" is our highest-leverage correction |
| **Dev / tech lead** | `ONTOLOGY.md` · `spec/CLAUDE.md` | Schema and tests generate from the spec; behavior changes without spec changes bounce |

---

## The problem is drift, not the PRD

PRDs are rarely read by anyone but the author — and neglect is the smaller issue. The PRD gets transcribed into designs and stories, every transcription drifts, and the corrections land in Slack, legible to humans and invisible to agents. Nothing routes back fast enough.

Volume compounds it. When five artifacts describe the same feature, none of them is the source of truth. And prose is ambiguous exactly where it hurts: one section says "session," the next says "workout." The spec calls for an explicit checkbox on the consent form; the design shows a slider. Every reader, human or agent, resolves those conflicts differently.

The fix: split truth by *kind*, give each kind a home that stays load-bearing after release, and add each home only when its specific pain shows up. That's the ladder.

## The ladder

Read bottom-up. Each layer arrives when its trigger fires, never on principle. Every layer costs maintenance, and a stale spec is worse than no spec.

![The spec ladder — seven layers, each with the trigger that adds it](fig1-spec-ladder.png)

*Teal = machine-checkable contract · Amber = human steering · Outline = always-on base*

> **Start a new area with base + vocabulary + scenarios** — roughly three pages. That alone kills the two biggest agent failure modes: naming drift and invented behavior.

## What each layer buys

| Layer | The agent gets | You get |
| :---- | :---- | :---- |
| `VOCABULARY` | Deterministic naming — no synonym guessing | Your own domain words back, at near-zero reading cost |
| `ONTOLOGY` | A generative source for schema, types, validators | A picture of what exists, correctable without reading code |
| `SCENARIOS` | Concrete acceptance targets to verify against | Plain-language stories anyone can veto |
| `decisions/` | Knowledge of where to hold firm and where to explore | Visibility into what's settled, without asking anyone |
| `PRD` | A tiebreaker for intent | The strategic conversation, minus the definitions |
| `DESIGN` + `CONTENT` | Pixel truth, plus copy it must never transcribe | Copy edits with no designer on the critical path |

**Scenarios are the steering sweet spot** — the one place where agent precision and human readability peak together. A domain expert reads a scenario and says "that's not how it should feel" without knowing what an invariant is. Read one spec file, read that one.

Insert note: on how certain projects will favor heavy reliance on story/issue detail but that is team dependent. Many people get lost in the web of stories. And stories start to overlap and duplicate quickly, the larger the team the bigger the maintenance becomes

## Three concerns, one shared center

Every argument we have reduces to three questions: is it *valuable*, is it *feasible*, is it *usable*. The layers sort themselves onto that map. Two artifacts sit dead center, read and written by all three concerns.

![Valuable, Feasible, Usable — with Vocabulary and Scenarios at the shared center](fig2-venn.png)

Shared language and journey stories are the only artifacts all three concerns touch — the first layers we add, the last we'd cut. The pairwise edges hold the decision records with multiple lenses: the contested ones.

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

## What this might change for you

By role, if we adopt it:

**Design** — You own layout, components, interaction, and length constraints. You don't own copy. Small changes accumulate as deltas you absorb on your schedule; genuinely new patterns still come to you first. → `spec/training/DESIGN.md`

**Marketing** — You own every user-facing string as a keyed line you edit directly. No design file, no dev ticket for wording. Legal-locked keys are marked. → `spec/training/CONTENT.md`

**Product** — You own the thin PRD, the scenarios, and most decision records, including promotion from exploring to firm. Scope debates end in a DR, not a thread. → `SCENARIOS.md` · `decisions/`

**Devs** — You generate schema, types, and model tests from the ontology. Plans cite scenario IDs and get deleted afterward. When the spec is silent, ask — then write the answer back. → `ONTOLOGY.md` · `spec/CLAUDE.md`

**Tech lead** — You guard the precedence chain and the same-commit rule: behavior changes without spec changes bounce in review. You decide when a slice earns its next layer. → `spec/CLAUDE.md`

**Domain experts** — You read scenarios written in your vocabulary and say "that's not how it works." That's the highest-leverage steering available to anyone here. → `SCENARIOS.md` · `VOCABULARY.md`

**Customer support** — You get precise bug language from scenario IDs: "SC-014 doesn't hold — I got a duplicate workout" routes itself. You'll also spot missing scenarios before anyone else. → `SCENARIOS.md`

## Ground rules, on one hand

When artifacts disagree, earlier wins:

```
contracts (VOCABULARY → ONTOLOGY → TAXONOMY → SCENARIOS)
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
