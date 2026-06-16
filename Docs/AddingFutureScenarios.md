# Adding Future Scenarios

Last updated: 2026-06-16

## Purpose

This guide describes the Unity-side work for adding a new Future Mountain
scenario. It complements the RHESSys importer guide:

```text
Docs/RHESSysDataImporter/ScenarioUpgradeGuide.md
```

The importer guide explains how to bring new RHESSys data into the database.
This guide focuses on the Unity experience: scenes, terrain assets, runtime
settings, API profile selection, visual tuning, and asset isolation.

## Current Scenario Pattern

Current scenario scenes live under:

```text
Assets/Scenes/BigCreekV1/BigCreekV1.unity
Assets/Scenes/CentralCoastV2/CentralCoastV2.unity
```

Each scenario should have its own scene. A new scenario usually starts by
duplicating the closest existing scenario scene, then replacing or tuning the
scenario-specific objects and settings.

Do not turn the existing Big Creek scene into a new scenario in place. Big Creek
is still the compatibility baseline.

## High-Level Workflow

1. Create the importer/database/API path for the scenario, or confirm that one
   already exists.
2. Duplicate the closest Unity scene into a new scenario folder.
3. Duplicate scenario-owned terrain assets for the large landscape, cubes, and
   side cubes.
4. Duplicate or intentionally share prefabs, materials, terrain layers, and
   message assets.
5. Configure the scene's `Settings` GameObject and `SimulationSettings`.
6. Update scenario API routing and message resources.
7. Tune vegetation, carbon, snow, fire, water, terrain, and camera framing.
8. Run editor and web-build smoke tests.

## Scene Duplication

Create a new scene folder under:

```text
Assets/Scenes/<ScenarioName>/
```

Duplicate the closest existing scene into that folder and rename it clearly.
After duplication, open the new scene and verify:

- The `Settings` GameObject exists and has `SimulationSettings`.
- `GameController`, `LandscapeController`, camera, canvases, timeline, message
  managers, cube objects, side cube objects, and aggregate cube references are
  assigned.
- The scene appears in build settings when it is ready for build testing.

## Terrain Duplication

The scene contains more terrain-like assets than just the large landscape. When
adding a scenario, duplicate and reassign terrain assets for:

- The large landscape terrain.
- Each visible sample cube.
- The aggregate cube.
- Each side cube used by Side-by-Side Mode.
- The aggregate side cube.

This matters because Unity `TerrainData` assets are shared assets. If two scenes
reference the same terrain asset and one scene's terrain is edited, the other
scene can change too. That kind of cross-scenario asset bleed is hard to notice
until much later.

After duplication, inspect each terrain component and confirm it points to the
new scenario-specific `TerrainData` asset.

## Prefabs, Materials, And Shared Assets

Be deliberate about what is shared between scenarios.

Shared prefabs and materials are useful when the behavior and look should remain
identical. They are dangerous when a new scenario needs region-specific tuning.
If a shared prefab, material, terrain layer, or texture is edited for the new
scenario, the change can bleed into older scenarios that reference the same
asset.

Before editing any shared asset, decide whether to:

- Keep it shared because the change is global.
- Duplicate it into a scenario-specific folder because the change is local.

Assets that commonly need scenario-specific copies:

- Terrain materials and terrain layers.
- Large landscape terrain assets.
- Cube and side-cube terrain assets.
- Tree, shrub, roots, dead-tree, grass, and litter prefabs.
- Fire materials, fire terrain texture settings, and fire prefabs.
- Soil, groundwater, snow, and water materials.
- Message text assets.
- Camera animation controller or clips if framing changes.

Use names that make ownership obvious, such as `CentralCoastV2_...`.

## SimulationSettings

Each scenario scene should have its own configured `Settings` GameObject with
`SimulationSettings`. The component is scene-local, so values can differ by
scenario, but only if the scene has been duplicated and checked carefully.

Important fields to review:

| Area | Fields |
| --- | --- |
| API | `apiProfile` |
| Scenario features | `SnowEnabled`, `FireEnabled` |
| Fire | `AutoPauseOnFire`, `MinFireFrameLength`, `MaxFireLengthInSec`, `ImmediateFireTimeThreshold` |
| Population | `MinFrontTrees`, `MaxTrees`, `MaxShrubs`, `WebBuildMaxVegMultiplier` |
| Carbon | `TreeCarbonFactor`, `RootsCarbonFactor`, `ShrubCarbonFactor`, `CubeATreeCarbonFactor`, `CubeARootsCarbonFactor`, `CubeAShrubCarbonFactor`, `WebBuildCarbonMultiplier` |
| Distribution | tree spacing, cube padding, shrub zone settings |
| Geometry | tree/shrub height and width ranges |
| Roots | root size, spread, offset, and variability settings |
| Side-by-Side | `SideBySideModeXOffset`, `SideBySideModeXOffsetAggregate` |
| UI | message timing |

Questions to answer for every new scenario:

- Should snow visualization be enabled?
- Should fire simulation and fire data loading be enabled?
- Are the incoming carbon values on the same scale as Big Creek?
- Do tree, shrub, and root carbon factors need retuning?
- Is `WebBuildCarbonMultiplier` appropriate for WebGL density and performance?
- Is `WebBuildMaxVegMultiplier` aggressive enough for the scenario's vegetation?
- Do side-by-side cube offsets still frame correctly after terrain/cube changes?

`OptimizeForWeb()` runs in web builds when the `WEB_VERSION` scripting symbol is
defined. It reduces vegetation counts and multiplies carbon factors. Tune the
base carbon settings and web multipliers together, not independently.

## API Profile And Runtime Data

`SimulationSettings.apiProfile` controls the API prefix used by `WebManager`.

Current profiles:

| Profile | Route behavior |
| --- | --- |
| `BigCreek` | Uses legacy `/api/...` routes |
| `CentralCoast` | Uses `/api/centralcoast/...` routes |

If a new scenario has its own API routes, add a new `ScenarioApiProfile` value
and update `SimulationSettings.ScenarioApiPrefix`, message resource paths, and
any profile-specific runtime behavior.

The Unity scene should not load importer configuration directly. The importer,
database, API, and Unity DTOs still need to agree on fields, names, units, and
defaults.

## Messages And Narrative Content

Scenario-specific messages should live in separate Resources assets rather than
editing Big Creek messages in place.

`SimulationSettings` currently chooses message resource paths by API profile:

- Big Creek: `Messages/GeneralMessages`, `Messages/FireMessages`
- Central Coast: `Messages/CentralCoastGeneralMessages`,
  `Messages/CentralCoastFireMessages`

For a new scenario, add new message assets and route them through the profile
selection logic.

## Visual Tuning Checklist

After data loads, compare model values to the visual result:

- Tree and shrub density.
- Root depth and width.
- Soil and groundwater material response.
- Snow accumulation and snow-to-groundwater effects.
- Fire ignition, spread, burn texture, and regrowth.
- Landscape terrain splatmap behavior.
- Cube labels and message highlighting.
- Timeline range, precipitation scaling, fire icons, and message icons.
- Camera animation framing for normal zoom and Side-by-Side Mode.

Use the model data layer when available to compare source carbon values against
visible scene-derived vegetation values.

## Data Contract Checklist

For each new scenario data field:

- Identify the source file and source column name.
- Define database table and column type.
- Define API JSON field name.
- Define Unity DTO field or runtime mapping.
- Define units and expected range.
- Decide whether it drives a visual change, UI display, message condition, or
  only metadata.
- Define default behavior when the field is missing.

## Common Risks

- Shared materials or prefabs are edited for a new scenario and accidentally
  change Big Creek or another older scenario.
- A scene is duplicated but its large landscape or cube terrains still reference
  old `TerrainData` assets.
- Side cubes are forgotten because they are hidden until Side-by-Side Mode.
- `SimulationSettings.apiProfile` points at the wrong API route family.
- Carbon factors are tuned in the Editor but web multipliers make the WebGL
  build look sparse or overloaded.
- Snow or fire is enabled even though the scenario has no meaningful source data
  for it.
- Message resources still point at Big Creek text.
- Camera animation clips still frame the old cube/landscape positions.

## Smoke Tests

Before calling a new scenario ready:

- Open the scene directly in the Unity Editor.
- Confirm there are no missing scripts, missing materials, or missing terrain
  references.
- Start the simulation and verify data loads from the intended API profile.
- Toggle snow/fire-relevant controls if enabled.
- Enter and exit Side-by-Side Mode for the aggregate cube and every sample cube.
- Check the timeline, messages, model data layer, and camera reset.
- Build or run the web profile and verify vegetation density after
  `OptimizeForWeb()`.
