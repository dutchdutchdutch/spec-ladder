// DERIVED from INV-07 (spec/training/ONTOLOGY.md) — do not hand-edit.
// Regenerate when the invariant changes. Model-level: no journey context.

import { describe, it, expect } from "vitest";
import { makeDraftProgram } from "../helpers";

describe("INV-07: draft → published requires at least one Workout", () => {
  it("blocks publishing an empty Program", async () => {
    const program = await makeDraftProgram({ workouts: 0 });
    await expect(program.publish()).rejects.toThrow(/INV-07/);
    expect(program.status).toBe("draft");
  });

  it("allows publishing with one Workout", async () => {
    const program = await makeDraftProgram({ workouts: 1 });
    await program.publish();
    expect(program.status).toBe("published");
  });
});
