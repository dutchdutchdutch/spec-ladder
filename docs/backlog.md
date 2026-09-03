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

## Reconcile fig1 with the bundle model

`wiki/fig1-spec-ladder.png` labels the layer `CONTENT`, which is still correct as
a layer name but implies a markdown file alongside the other rungs. Worth a look
once the sample settles. Same figure would need redrawing if `intents/` ever
stopped being explicitly not-a-rung — it currently shows eight layers, which
stays accurate.

## Value stream as ontology edges

Exploring whether the value stream can merge into the ontology as an additional
type of graph connection, rather than living as its own layer.

Two objections stand today: the stream is one of three artifacts at the centre of
the Venn and is edited directly by business owners, while the ontology is the
least approachable layer for non-engineers; and the two carry different staleness
regimes (quarterly attestation vs. the same-commit rule) that would collide in
one file.

The experiment is still worth running, because the residue is the answer. If the
stages express cleanly as typed edges, the layer is derivable and the separation
is only about audience. If actor, investment, and return will not sit as edge
attributes without distortion, that leftover is the definition of what the layer
holds — and it replaces the current three-reasons argument in Home with something
tested.

Condition that would settle it: if a quarter passes and nobody outside
engineering has edited `VALUE-STREAM.md`, the audience objection has evaporated
and the merge becomes right.
