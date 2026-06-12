# Normal Mode Spec

Last updated: 2026-06-12

## User Interface Behavior

Normal Mode is the main simulation view. It shows the full Big Creek landscape, the aggregate cube, and five individual terrain cubes. The user can start the simulation, select a warming scenario, pause or resume time, control time speed, inspect cubes, show or hide model/statistics overlays, show or hide narrative messages, and use the timeline.

The primary warming control is a single knob with five discrete values:

- `0 C`
- `+1 C`
- `+2 C`
- `+4 C`
- `+6 C`

When the simulation starts, the intro panel hides, loading UI appears, runtime data is loaded, and the user is asked to continue into the main experience. Cubes animate into view after loading. In normal mode, clicking a cube zooms the camera toward that cube unless the Side-by-Side toggle is armed.

## Technical Behavior

`GameController` is the coordinator for Normal Mode. It owns current time, current warming index, cube arrays, side-cube arrays, UI canvases, messages, timeline, lighting, and fire scheduling.

Startup flow:

1. `StartSimulationRun()` hides setup UI and reads the selected warming index from `WarmingKnobSlider`.
2. Web builds call `LandscapeController.LoadLandscapeDataForWarmingIdx(warmingIdx)` and `WebManager.GetDataDates()`.
3. `FinishStarting()` initializes each cube, side cube, aggregate cube, messages, fire dates, timeline, and initial sun position.
4. `HandleContinueButtonPressed()` transitions from loading into the interactive simulation.

Runtime flow:

1. `RunGame()` advances `timeIdx` by `timeStep` while not paused.
2. `UpdateSimulation()` updates the current `DateModel`, checks fire ignition, updates the landscape, updates cubes, updates messages, updates aggregate cubes, and records the last update time.
3. `UpdateLighting()` updates seasonal sun angle and intensity between simulation frames.
4. `UpdateUIText()` writes the current date to the timeline label.

Normal Mode uses the main cube array (`cubes`) and aggregate cube. Side cube instances are normally hidden but are initialized so Side-by-Side Mode can activate them quickly.

## Key Objects And Scripts

- `GameController`: mode state, simulation clock, UI, fire scheduling, timeline integration.
- `LandscapeController`: full landscape terrain, river, fire, snow, and patch/water data.
- `CubeController`: per-cube data and visual simulation.
- `CameraController`: click/zoom behavior and fly camera mode.
- `WarmingKnobSlider`: discrete scenario selector.
- `TimeKnobSlider`: time-step/speed selector.
- `TimelineControl`: annual timeline and click targets.
- `UI_MessageManager`: story/fire messages and cube label highlights.

## Scenario Assumptions

Normal Mode currently assumes one aggregate cube plus five individual cubes. It also assumes the five Big Creek warming levels and a Big Creek data/API contract. Future scenarios should make these values scenario-configurable.

