# Backlog

Open editorial and design questions for the spec-ladder project itself. Not part
of the published wiki — `wiki/` is the source of truth for what ships, and the
publish workflow only syncs that folder.

This file is working truth: items get removed when they land, not archived.

## Write the story/issue note

Was an inline placeholder in `wiki/Home.md`, in the scenarios section. The
original text:

> Insert note: on how certain projects will favor heavy reliance on story/issue
> detail but that is team dependent. Many people get lost in the web of stories.
> And stories start to overlap and duplicate quickly, the larger the team the
> bigger the maintenance becomes

The argument is worth making: stories overlap and duplicate faster as the team
grows, so a story-heavy process carries maintenance cost that scenarios avoid by
being capability-scoped and few.

Consider putting it in `wiki/Where-the-Ladder-Fits.md` rather than Home. It is a
fit question — story-heavy is a defensible choice for some teams — and that page
already carries the profiles and the seven questions. Home is about the ladder
itself; a "when is this not for you" argument reads better on the fit page.

## Make the sample's content layer a real bundle

`wiki/Content-Operating-Model.md` now says the spec artifact and the runtime
artifact are the same file: the shipped source-language bundle, not a document
that generates it. `sample/spec/training/CONTENT.md` still models content as a
markdown spec file, so the sample contradicts the wiki.

Needs a real decision about the sample's bundle format and where metadata
(`status`, `owner`) sits, not just a rename. `README.md` and
`sample/spec/CLAUDE.md` both reference `CONTENT.md` and would follow.

## Value stream as ontology edges

Exploring whether the value stream can merge into the ontology as an additional
type of graph connection, rather than living as its own level.

Two objections stand today: the stream is edited directly by business owners,
while the ontology is the least approachable level for non-engineers; and the two carry different staleness
regimes (quarterly attestation vs. the same-commit rule) that would collide in
one file.

The experiment is still worth running, because the residue is the answer. If the
stages express cleanly as typed edges, the layer is derivable and the separation
is only about audience. If actor, investment, and return will not sit as edge
attributes without distortion, that leftover is the definition of what the layer
holds — and it replaces the current three-reasons argument in Concepts with something
tested.

Condition that would settle it: if a quarter passes and nobody outside
engineering has edited `VALUE-STREAM.md`, the audience objection has evaporated
and the merge becomes right.

## Second pass: spec/CLAUDE.md and the sample

The wiki now says three groups (Conventions, Concepts, Scope), each a short
ladder, with group-order precedence: Concepts win on meaning, Scope wins on
behaviour, the thinner level wins inside a group, Conventions sit outside the
chain. `spec/CLAUDE.md`, `sample/spec/CLAUDE.md` and `sample/README.md` still
state the old nine-item precedence chain and the eight-layer read order. Bring
them in line, and fold the taxonomy-before-ontology order into the read order.

## fig3-decision-flow.png at the repo root

Unreferenced by any page or workflow, and older than the three-group rewrite.
Decide whether it becomes a figure source under `figures/` or gets deleted.

## The three-concerns framing is gone from the wiki

The valuable / feasible / usable Venn and its section were dropped from Home in
the three-group rewrite. What survives is one sentence on the Scope page: records
carrying more than one lens are where the three concerns pull against each other.
If the framing earns a page again, the figure would be rebuilt from a source
under `figures/`, not restored from the old PNG.
