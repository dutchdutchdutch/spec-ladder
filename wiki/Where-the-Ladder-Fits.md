# Where the Ladder Fits

**One question sorts it: can a person who cannot read code confirm that a statement is correct — and change it themselves?**

Companion to *The Spec Ladder*. That post covers where truth lives. This one covers whether to build the folder at all — and how the ladder relates to the per-change pipeline in Anthropic's [AI-native SDLC playbook](https://claude.com/blog/the-ai-native-sdlc-playbook). SDLC is the software development life cycle: the path from idea to shipped, running code.

## They are not two versions of the same thing

The playbook is a **process**. It defines stages and the gate between each one.

The ladder is an **information architecture**. It defines kinds of truth and where each one lives.

Those are different axes, so "which one" is the wrong question. You can run the playbook's stages over the ladder's layers, and on a domain-heavy project you probably should. The real variable is narrower: **how much standing truth does this slice need?** The playbook is the right answer when the honest answer is "almost none."

## What the playbook proposes

Six stages. Each one commits an artifact the next stage reads.

| Stage | Artifact |
|---|---|
| Plan | `intent.md` — problem, outcome, constraints, open questions, in the originator's words |
| Design | `spec.md` — requirements and design, drafted by Claude, approved by the product owner |
| Build | `plan.md`, `CLAUDE.md`, the code diff |
| Test | test output, verification logs |
| Deploy | pull request with review findings, merged code |
| Maintain | incident records, and a new `intent.md` when a control breaks |

The documents are **per change**. Once the work ships they become audit trail, and the code carries the truth from there.

## Where the two agree

More than the framing suggests.

- **Plain markdown in git, and the commit chain is the audit trail.** Same substrate, no translation cost between them.
- **A human gates every promotion.** The playbook gates by stage: accept the intent, approve the spec. The ladder gates by status: `exploring` → `provisional` → `firm`. Same instinct, one expressed in time, one in state.
- **Plans are throwaway.** The playbook writes `plan.md` per change; the ladder writes `docs/plans/` and deletes them after. Near-identical.
- **Same-commit for plans.** "When implementation departs from the plan, update `plan.md` in the same commit" is the ladder's same-commit rule, applied to one artifact.
- **An agent drafts, a human approves.** Neither expects people to hand-write the whole document.
- **Production feeds back to the front.** A breached control opens a new intent; a support ticket cites a broken `SC-###`. Both close the loop.
- **Non-engineers start work.** The playbook's intent is written by whoever had the idea — a product manager, an operations person, an alert. The ladder's layers are edited by the people who own them. Neither approach expects requirements to arrive only through engineering.

## Where they overlap, saying it differently

| Playbook artifact | Ladder equivalent | Lifespan |
|---|---|---|
| `intent.md`, per change | `intents/`, per release | No authority; kept as record |
| `spec.md` | a *diff* across `VOCABULARY`, `ONTOLOGY`, `SCENARIOS`, `decisions/` | Standing |
| `plan.md` | `docs/plans/` | Ephemeral — deleted after |
| `CLAUDE.md` | `spec/CLAUDE.md` | Standing |
| test output | tests generated from `SCENARIOS` and `ONTOLOGY` | Ephemeral output, standing source |
| new `intent.md` from a breach | a ticket citing `SC-014` | — |

The interesting row is `spec.md`. Both approaches want one reviewable, approved statement of what to build. The playbook makes it a document. The ladder makes it a **change to the standing documents** — and the pull request description is the readable version. Same gate, no new copy of the domain.

## Where they conflict

Five places, and the first is a genuine fork. You cannot hold both positions.

**1. What is true after the code ships.** The playbook says the code. The ladder says the layers, and a behaviour change without a spec change bounces in review. The playbook escapes drift by letting specs die; the ladder escapes it by forcing them to stay alive.

That works for the playbook when domain truth is **cheap to re-derive by reading the code**. In a deploy tool the domain nouns are the code nouns. It breaks when domain truth is **imposed from outside** — "athletes under 16 need guardian consent" comes from a statute, not from any function. Read the implementation and you learn what the code does, never whether it is right. So only a domain expert can confirm it, and code-as-truth locks that person out. The cost is not drift. It is **exclusion**, and on a multidisciplinary team exclusion is the whole problem.

**2. Per-change specs accumulate partial copies.** After twenty features you hold twenty spec files, each re-describing consent, sessions, and the athlete journey, each frozen on a different date. That is the ladder's root cause, restated. The playbook only survives it by demoting the documents to history.

**3. There is no story for mid-flight clarification.** The playbook assumes the design stage produces a spec clear enough to plan against, and that a big change restarts the cycle. On iterative work with four disciplines, clarifications arrive constantly — and they land in Slack. The ladder's answer is a rule: when the spec is silent, ask, then write the answer back in the same change.

**4. One document serves every reader.** So every reader skims. The ladder's bet is role-scoped reading: support reads scenarios, marketing reads content keys, nobody reads three pages they do not own.

**5. Every change is the same size.** The playbook has one path: intent, spec, plan, code. That is right for a feature and heavy for a word of copy. And once the work ships there is no standing artifact a product manager could edit anyway, because the code holds the truth. So a small cross-discipline change has two options — a ticket in the engineering queue, or nothing. The ladder gives small changes a small artifact, so a copy fix is one key and an ordinary pull request. Both approaches open the front door to non-engineers; only one gives them something durable to change afterwards.

## The seven questions

Each one points one way. Count them for the slice in front of you, not the company.

| Question | Points to the playbook | Points to the ladder |
|---|---|---|
| Who can confirm a statement — and change it? | An engineer, in the repo | A domain expert who cannot read code |
| Where does the truth come from? | The code — it is derivable | A statute, protocol, contract, or expert's head |
| How many disciplines with different concerns write requirements? | One or two | Three or more |
| Does the same noun appear in most features? | No — features are independent | Yes — "consent" and "session" are everywhere |
| What does a late wrong behaviour cost? | Cheap, reversible | Regulated, financial, or safety-critical |
| System lifespan against staff tenure? | Similar | The system outlives the people by years |
| What do agent-written tests check against? | The code, and the agent's reading of it | A standing statement a domain expert confirmed |

**Question four is the sharpest single test.** If every feature touches the same handful of nouns, per-feature specs guarantee twenty partial definitions of each. One `VOCABULARY.md` is the only structure that prevents it.

**Question seven is not about who writes the tests.** Agents write them in both approaches — unit, component, contract, integration, end to end. Nobody hand-writes that volume and still gets the speed either approach claims. The question is what the agent checks the behaviour *against*.

If the spec dies at ship, the agent derives its assertions from the code and its own reading of it. The suite becomes self-referential: it encodes what the system does, not what it should do. The knowledge still accretes — fixtures encode valid states, helpers encode invariants, test names encode journeys — so you end up with an **implicit ontology scattered across the test harness**: unnamed, unowned, with no precedence rule when two tests disagree, and written in the one language your domain expert cannot read.

Agents make this worse, not better. A person writing a test at least holds some domain intent in their head. An agent generating from code alone re-encodes whatever the code does — bugs included — as an assertion. That is how a defect quietly becomes a requirement: the suite goes green, the behaviour is wrong, and nobody outside engineering was ever in a position to catch it. And agents produce far more test code than people, so the implicit ontology accretes faster and reviews worse.

**Scenarios set the floor, not the ceiling.** They name the behaviours that must hold, in language every discipline can veto, and they anchor the integration and end-to-end coverage. They are not the test plan — an agent covers far more than the anchors. How thoroughly you verify, and at which level, is a separate call: the mix of unit, component, and contract tests and the coverage you hold to is informed by the architecture and recorded with the engineering decisions. Those decisions matter, and they solve a different problem. They are read almost entirely by engineers and they were never meant to keep scope aligned across disciplines.

## Project profiles

### Favour the playbook

**Internal developer tooling.** A build pipeline, a deploy tool, an internal library. Engineers write the requirements and engineers check them. The domain nouns *are* the code nouns, so `VOCABULARY.md` would only restate the type system. The standing truth is genuinely readable from the repo.

**A product still hunting for fit.** Three to eight engineers, pivoting each quarter. Standing layers go stale weekly, and a stale spec is worse than no spec. Each experiment gets its intent and its spec, ships, and becomes history — because the product becomes history too. The ladder here bets on a stability you do not have.

**High-volume, low-coupling work on a settled system.** Bug fixes, small screen changes, one more integration endpoint, on a domain model nobody is touching. The changes really are independent, so per-change documents cost less than maintaining layers. Note this is a **mode**, not a whole project — large systems run this mode and the one below at the same time.

**Compliance that audits change management.** Some regimes want to see who approved what, and when. The commit chain answers exactly that. The ladder answers a different question — what is true — and does not replace it.

### Favour the ladder

**A regulated domain with non-code truth.** Health, finance, insurance, employment, education. The rule comes from outside the building and only a non-engineer can confirm it. Manual review does not scale, and burying the rule in the test harness makes it unreadable to the one person who must sign off.

**Three or more disciplines with different concerns.** Product, design, and engineering is enough. Two disciplines resolve things in a conversation; at three, any pair can agree and the third finds out afterwards — that is where "the spec says checkbox, the design shows a slider" starts. Three is also the minimum for the valuable–feasible–usable Venn to have a center at all. Count concerns, not headcount: three engineers on three services is one discipline. Role-scoped layers exist so each person reads and edits the three pages that are theirs; a single `spec.md` gets skimmed by everyone and steered by no one.

**A ten-year system with two-year staff tenure.** The *why* has to outlive its author. Decision records with a status and an expiry do that. An archived intent file from 2021 does not — it records what someone wanted once, not what still binds.

**Heavy shared vocabulary.** If most features touch the same nouns, one home per noun is the only thing that stops twenty definitions.

**Agents generating the test suite from something a person confirmed.** Agents write the tests either way. The choice is whether they derive from a standing contract in domain language, or from the code. Only the first leaves a suite a domain expert can audit.

## Most systems are mixed

The unit is the slice, not the project. A fintech has a regulated ledger core that wants the full ladder, and a marketing site that wants the base and nothing else. This is the same add-on-pain rule that governs every layer, applied one level up: **a slice earns its layers, and some slices earn none.**

So the two approaches usually coexist in one repository. That is fine, as long as the boundary is deliberate and someone owns it.

## Failure modes to watch

- **The ladder on a pre-fit product.** Eight layers, stale in a month, and now the folder lies. Start with base, vocabulary, and scenarios, or start with nothing.
- **The playbook on a regulated domain.** The implicit ontology grows in the test harness, and the domain expert is locked out of the review that needs them most.
- **Adopting `spec.md` as a ninth layer.** It is a diff across the layers, not a document beside them. Add it and every feature mints another partial copy.
- **Treating an intent as truth.** It records what a release chose. The moment someone cites it in a conflict, it is competing with the layer that actually holds the answer.
- **"We're multidisciplinary" as a blanket justification.** That earns scenarios and vocabulary. It does not automatically earn a taxonomy, a value stream, and a design layer.
- **Choosing once, for the whole company.** The questions are cheap. Re-ask them per slice.

## What to do with this

If you are picking an approach: run the seven questions against one slice, not the org chart. Four or more answers on the right means build the folder. Fewer means run the pipeline and keep the base.

If you already run the playbook: the cheapest useful change is to stop writing `spec.md` as a document and start writing it as a change to standing layers, with the pull request description as the readable version. You keep every gate and stop minting copies.

If you already run the ladder: the playbook's front door is the piece you are missing, and `intents/` is it — provided it never earns authority.
