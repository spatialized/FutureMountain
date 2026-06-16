# Side-by-Side Mode

Last updated: 2026-06-12

## User Interface Behavior

Side-by-Side Mode lets the user zoom in on one cube and compare two warming scenarios for that same cube at the same simulation time.

The intended interaction is:

1. User enables the Side-by-Side toggle.
2. User clicks an aggregate or individual cube.
3. Camera zooms to a Side-by-Side framing.
4. Other cubes hide or shrink away.
5. Two versions of the selected cube are shown.
6. Two warming knobs appear, one for the left/original cube and one for the right/comparison cube.
7. The regular warming knob hides.
8. User can change each cube's warming scenario independently.
9. Timeline, pause, messages, lighting, and simulation time continue to apply.

The comparison cube defaults to a different warming index from the original: if the original is baseline, the comparison starts at `+1 C`; otherwise it starts at baseline.

## Technical Behavior

Side-by-Side Mode is controlled by `GameController.sideBySideMode` and `GameController.sbsIdx`.

Entry flow:

1. `CameraController.StartZoomIntoCube(cubeIdx)` checks whether Side-by-Side should be entered.
2. It triggers a Side-by-Side camera animation, such as `SBS_Cube0` for aggregate or `SBS_Cube1` through `SBS_Cube5` for individual cubes.
3. `GameController.EnterSideBySideMode(idx)` stores `sbsIdx`, sets `sideBySideMode = true`, hides other cubes, chooses the active main cube and matching side cube, shows two Side-by-Side warming knobs, hides the regular warming knob, and enables the Side-by-Side canvas.
4. `FinishEnteringSideBySideMode()` starts simulation on each selected cube at the current `timeIdx`, assigns the message manager, calls `CubeController.EnterSideBySide()`, and optionally initializes vegetation for the comparison cube.

Changing either Side-by-Side warming knob calls:

- `GameController.SetSBSWarmingLevel(newIdx, newDegrees, isComparedCube)`

That method resets the targeted cube, sets its warming index, and restarts its simulation at the current shared `timeIdx`.

Exit flow:

1. `ExitSideBySideMode(immediate)` sets `sideBySideMode = false`.
2. The active comparison cube is stopped.
3. Side cubes and Side-by-Side warming knobs are hidden.
4. The regular warming knob is restored.
5. Main cubes are reset to the global warming index.
6. Statistics panels are hidden/reset.
7. If exit is not immediate, cubes are shown again and camera reset animation runs.

## Key Objects And Scripts

- `GameController`: owns `sideBySideMode`, `sbsIdx`, entry/exit flow, and per-side warming changes.
- `CameraController`: decides whether a cube click means zoom-only or Side-by-Side entry.
- `CubeController.EnterSideBySide()`: prepares cube-specific UI/statistics and cube position/state.
- `WarmingKnobSlider`: has Side-by-Side flags and calls `SetSBSWarmingLevel()`.
- Side cube scene objects: one duplicate for each cube and one duplicate aggregate cube.

## Current Constraints

The feature assumes exactly five individual cubes plus one aggregate cube. The `WarmingKnobSlider` code comments note that Side-by-Side knob behavior still needs generalization. Future scenario work should make cube identity and comparison defaults data-driven.

