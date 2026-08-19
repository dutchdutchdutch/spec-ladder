// SC-014 — Athlete completes a workout offline and syncs later
// Anchor: spec/training/SCENARIOS.md · Invariant: INV-11
// Hand-written: journey-level (crosses entities, involves failure + timing).

import { describe, it, expect } from "vitest";
import { makeAthleteWithActiveProgram, goOffline, reconnect } from "./helpers";

describe("SC-014: offline workout completion syncs exactly once", () => {
  it("stores locally as completed_pending_sync while offline", async () => {
    const { athlete, workout } = await makeAthleteWithActiveProgram();
    await goOffline();
    await workout.logSet({ reps: 8, load_kg: 60 });
    await workout.complete();
    expect(workout.status).toBe("completed_pending_sync");
  });

  it("syncs without duplicating the Workout or its Sets (INV-11)", async () => {
    const { athlete, workout } = await makeAthleteWithActiveProgram();
    await goOffline();
    await workout.logSet({ reps: 8, load_kg: 60 });
    await workout.complete();
    await reconnect();
    const synced = await athlete.workouts();
    expect(synced.filter((w) => w.id === workout.id)).toHaveLength(1);
    expect(synced[0].status).toBe("completed");
    expect(synced[0].sets).toHaveLength(1);
  });
});
