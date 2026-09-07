# The Spec Ladder

For product teams whose PRDs, designs, tickets and Slack threads no longer agree, the Spec Ladder is one folder of shared truths that people and coding agents build from together.

**Problem: source of truth confusion** kills team momentum and erodes confidence. The remediations are costly and frustrating.

Coding agents are literal and tireless, they amplify whatever we feed them. Feed them a crisp contract and they produce what we meant. Feed them multiple conflicting documents and they invent the gaps.

Even small misunderstandings compound over time: one document says "session," the next says "event." The spec calls for a consent checkbox; the design shows a slider. Every reader, human or agent, resolves those differently.

**Common cause: PRDs spawn with small misunderstandings that compound.** Designs, stories, test cases, Slack threads. Each is a partial copy of the same feature, each drifting from the others. After a while we loose track of which one is authoritative in what aspect. And the agents are fed inaccurate or conflicting guidance. Days may pass before the drift surfaces, then hours or days go to determining which source is right, and then the fix has to be applied to multiple documents.

**Proposal: one `spec/` folder, sorted into three groups**, so coding agents build without guessing and every team member can read and correct it without touching code. The goal is simple to state: the latest version of the product stays aligned with the latest truths, because team members, their agents, shared agents, and everything they produce start from one shared understanding.

Most of the folder is plain language and yours to edit. The by-role breakdown is at the [end of this page](#what-this-might-change-for-you).

## Three groups, each a short ladder

![The Spec Ladder: three groups, each a short ladder](fig1-three-ladders.png)

*Grey = conventions · Teal = concepts · Amber = scope*

Every group starts thin and adds a level only when its trigger fires. Each level costs maintenance, and a stale spec is worse than no spec, so a level has to earn its place.

**[[Conventions]] are how we work.** Repo and code conventions come first: folder layout, test tags, the rulebook agents read before anything else. Ways-of-working conventions follow as the team grows: the ground rules, what wins when documents disagree, how slow truth stays true. Conventions evolve with team complexity and as we learn.

**[[Concepts]] are what things are.** A shared vocabulary is the whole of it at first. A taxonomy sorts the vocabulary into closed lists. An ontology adds entities, states and rules for the concepts that agents and people across disciplines get wrong. A value stream composes those states into the order value moves through the domain. Fidelity goes up only as far as the domain demands.

**[[Scope]] is what the product does.** It starts with a list of scenarios, plainer than stories or epics. Decisions log the choices that follow from the conventions, the concepts and the scenarios. A PRD adds context when the scenarios alone leave "why" debates open. Intents record what each release took in and left out. Design and content give the most specific guidance of all: the pixels and the words on them.

> **Start a new area with conventions + vocabulary + scenarios**, roughly three pages. That alone kills the two biggest agent failure modes: naming drift and invented behaviour.

## What earns a place, and what doesn't

**The folder holds what more than one discipline has to agree on.** That is the test. A bigger, longer-lived solution needs more levels because more people across disciplines have to stay aligned on it. Anything only one discipline ever has a view on belongs in that discipline's own area, not in `spec/`.

For example latency budgets, throughput, uptime, threat models, coverage targets, and the architecture are engineering's to set and engineering's to meet. They live in architecture decision records under `docs/`, next to plans, referenced from `spec/CLAUDE.md`, never folded into the shared folder. The folder boundary is the discipline boundary: `spec/` is what we have to agree on together, `docs/` is where a discipline keeps its own working truth.

## Ground rules

When artifacts disagree:

1. **Concepts win on meaning.** If the ontology says an athlete has one active program, no scenario, PRD or screen can imply two.
2. **Scope wins on behaviour.** What the product does comes from scenarios and the levels above them, never from a plan or the code.
3. **Inside a group, the thinner level wins.** Vocabulary beats ontology. Scenarios beat the PRD. The level everyone reads is the one everyone agreed to.
4. **Conventions sit outside the chain.** They are not truth about the product. They say how the other two groups change: who may edit, what bounces in review, when a level counts as stale.
5. **Plans and code never win.** A behaviour change without its spec change is drift, and it bounces.

The working rules that make this hold (permanent IDs, same-commit, provisional needs an expiry, and the rest) live in [[Conventions]].

Questions, objections, and "that scenario is wrong" are the point. Cheap steering is what we're after.

## Where this fits, and where it doesn't

The spec folder costs maintenance, and it is not the right shape everywhere. The main razor: **do people who cannot read code review and confirm the solution?

If yes, the spec folder may be a good fit.

If not, a lighter per-change pipeline fits better. 

Most systems are mixed, and the seven questions help you decide how much spec and how much pipeline you need, and are in [[Where-the-Ladder-Fits|Where the Ladder Fits]].

## What this might change for you

Most levels are plain language and yours to edit: no design file, no dev ticket, no code. A change by a product manager, a marketer, or a designer is an ordinary pull request. You don't need git: describe the change to an agent and it opens the pull request. Review still belongs to engineers. Authorship doesn't.

| You are | You edit directly | What it buys you |
| :---- | :---- | :---- |
| **Product** | Scope: `SCENARIOS.md` · `decisions/` · `PRD.md` · `intents/` | Scope debates end in a decision record, not a thread, and cuts stop getting re-argued |
| **Business owner / domain expert** | Concepts: `VOCABULARY.md` · `VALUE-STREAM.md` · Scope: `SCENARIOS.md` | "That's not how it works" and "there's a whole stage missing" are the corrections that pay off most |
| **Marketing / support** | Scope: the content bundle | Propose any string freely; confirm the ones you own |
| **Design** | Scope: `DESIGN.md` | You absorb small deltas on your cadence; new patterns still route to you first |
| **Dev / tech lead** | Concepts: `ONTOLOGY.md` · `TAXONOMY.md` · Conventions: `spec/CLAUDE.md` | Schema and tests generate from the spec; behaviour changes without spec changes bounce |
| **Customer support** | Scope: `SCENARIOS.md` | Precise bug language: "SC-014 doesn't hold" routes itself |

Roles overlap. One person may wear several hats, and people share or backfill roles as needed. The tech lead guards the ground rules and decides when a slice earns its next level. An unowned trigger admits the level by default.
