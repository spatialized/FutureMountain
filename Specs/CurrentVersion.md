# Current Version Spec

Last updated: 2026-06-12

## Scope

This spec describes the current Big Creek version of Future Mountain as implemented in this Unity repository. It is intended as a baseline for review before refactoring and before adding a Central Coast scenario.

## Current Scenario

- Scenario: Big Creek watershed, Sierra Nevada.
- Scientific source: RHESSys-derived model output.
- Warming levels: baseline, +1 C, +2 C, +4 C, +6 C.
- Runtime data source: Future Mountain API for web builds, with legacy TextAsset/Resources loading paths still present.

## Primary User Features

### Intro and Loading Flow

The experience begins with an intro/setup state, then loads simulation data and transitions into the main scene. Loading text and short explanatory instructions are stored in the Unity scene.

### Warming Scenario Control

The warming knob allows the user to select one of five discrete warming levels before or during supported comparison flows.

Expected levels:

- `0 C`
- `+1 C`
- `+2 C`
- `+4 C`
- `+6 C`

### Time Control

The simulation advances through model dates. The user can pause/resume and adjust time progression with a time knob. The timeline displays annual precipitation and markers for fires/messages.

### Watershed Terrain View

The large landscape visualizes watershed-level state, including:

- Snow/background snow where enabled.
- River/streamflow level.
- Terrain texture changes related to fire and snow.
- Fire events loaded from data.

### Terrain Cubes

The current scene contains:

- One aggregate cube representing watershed-average conditions.
- Five detailed terrain cubes representing individual sampled locations.
- Side-by-side counterparts for comparison mode.

Cube visualization includes:

- Vegetation growth and death.
- Overstory and understory vegetation values where data supports two vegetation layers.
- Roots.
- Evapotranspiration particle effects.
- Snow.
- Groundwater depth and water access.
- Stream height/outflow.
- Litter and soil-related visual changes.
- Fire ignition and burn state.

### Side-by-Side Comparison

The user can enter side-by-side mode for a selected cube and compare the original cube with another warming level at the same simulation time.

### Timeline and Messages

The timeline shows annual precipitation and markers for fire/message events. UI messages can appear at configured dates and warming levels.

### Model/Statistics Display

The scene includes labels and statistics UI for cube variables such as water access, groundwater depth, evapotranspiration, stem carbon, and related model values.

## Technical Behavior

- Web builds use `https://data.futuremtn.org/api/`.
- Local standalone builds use `http://localhost:5550/api/`.
- Web optimization reduces vegetation density and increases carbon factors in `SimulationSettings.OptimizeForWeb`.
- Landscape fire and terrain data are loaded by warming index.
- Cube data is loaded by patch/cube id and warming index.

## Known Constraints

- Big Creek assumptions are embedded in code, data, scene setup, and UI.
- Warming levels are hard-coded in multiple places.
- Several data formats are positional rather than schema-driven.
- Some non-web data loading paths remain but may not be current.
- Some code paths and comments indicate historical installation/prototype behavior.
- API/database schema is external to this Unity repo.

## Acceptance Criteria For Current Baseline

- Project opens in Unity 2022.3.62f3.
- `Assets/Scenes/FutureMountain/FutureMountain.unity` is the active build scene.
- WebGL build can load Big Creek data from the API.
- User can start the simulation, select warming level, pause/resume, use the timeline, inspect cubes, and enter side-by-side comparison.
- Fire, snow, river, vegetation, roots, groundwater, and cube statistics appear consistently with the current deployed Big Creek behavior.

