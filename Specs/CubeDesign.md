# Cube Design

Last updated: 2026-06-16

## Design Purpose

Terrain cubes are the close-up, inspectable units of the Future Mountain
experience. The large landscape shows watershed-scale change, while cubes make
model processes visible at a human-readable scale: vegetation growth, snow,
streamflow, groundwater, roots, soil state, fire effects, and scenario
comparison.

The original concept design suggested a stronger object-like cube treatment,
including an almost glass enclosure around each cube. The current implementation
does not use visible glass walls or a strong transparent container. The visual
direction so far has favored open terrain blocks with visible ecological systems
over a literal display-case treatment. This keeps the cubes readable, reduces
material and transparency complexity, and avoids adding visual clutter around
vegetation, particles, snow, water, and fire.

## User Interface Behavior

In Normal Mode, the scene presents one aggregate cube and five individual sample
cubes alongside the large landscape. Users can click a cube to zoom in and
inspect it. In Side-by-Side Mode, a selected cube can be compared against its
matching side cube under another warming scenario.

Each cube is intended to feel like a small self-contained terrain system rather
than a simple chart. The cube surface, vegetation, roots, snow, water, particles,
and fire state all update over simulation time.

## Technical Structure

Each active cube is built around its own `CubeController`. The controller owns
or coordinates the cube's model data, terrain state, vegetation objects, water
and soil visuals, fire behavior, labels, and statistics/model-data display.

The cube hierarchy is scenario-authored in Unity rather than generated entirely
from code. A typical cube setup includes:

- A Unity `Terrain` or terrain-like object for the cube surface.
- A cube-specific `TerrainData` asset.
- A `CubeController`.
- A soil/groundwater visual subtree.
- Stream/water objects driven by cube flow data.
- Vegetation containers for trees, shrubs, grass, litter, and roots.
- Particle systems for precipitation, groundwater movement, and
  evapotranspiration.
- A cube-specific fire manager object.
- Labels or UI targets used by messages, camera focus, and model data display.

The scene also contains side-cube variants used by Side-by-Side Mode. These are
normally hidden or inactive in Normal Mode, but they still need their own
terrain assets and scenario-specific setup because they become active during
comparison.

## Per-Cube Ownership

Each cube should own the scene assets that can change during simulation or
scenario tuning. In practice, this means each cube should have its own terrain,
fire manager, and mutable visual setup. Side cubes should be treated the same
way, even when they are hidden by default.

This is especially important for scenario duplication. Unity `TerrainData`,
materials, prefabs, terrain layers, and fire settings can be shared accidentally
between scenes. If a new scenario edits a shared asset, that change can bleed
back into older scenarios. When a cube needs scenario-specific tuning, duplicate
the relevant asset and reassign the cube to the duplicate.

## Fire And Terrain

Cube fire is separate from landscape fire. The large landscape has its own fire
manager and terrain state, while each burnable cube uses its own fire manager
and cube-local terrain update path. This allows cube vegetation and cube terrain
to respond to fire without requiring the large landscape's fire grid to map
perfectly onto cube-local geometry.

The current cube fire behavior is less spatially data-driven than the landscape
fire behavior. Cube fire primarily uses cube model data to decide vegetation
loss and visual fire impact, while the cube fire grid itself burns locally.

## Relationship To Data

Cube design is tightly coupled to `CubeData`. The following fields are among the
main drivers of cube visuals:

- `snow`: cube snow surface and precipitation-to-groundwater effect.
- `qout`: stream height and flow presentation.
- `depthToGW`: groundwater/soil wetness cue.
- `vegAccessWater`: surface soil water availability.
- `leafC*`, `stemC*`, `rootC*`: tree, shrub, and root size/count behavior.
- `transOver` and `transUnder`: evapotranspiration particle behavior.
- fire and burn-related data: vegetation loss and burned terrain state.

The cube is therefore not just a miniature terrain mesh. It is an authored
container for many simultaneous data mappings.

## Current Constraints

- The current experience assumes one aggregate cube plus five individual sample
  cubes.
- Side-by-Side Mode assumes corresponding side-cube instances exist for the
  aggregate cube and each sample cube.
- Cube identity is still scene/tag driven in several places rather than fully
  scenario-data driven.
- The glass/display-case concept remains a design option, not an implemented
  visual feature.
- Transparent cube enclosures would need careful testing with vegetation,
  particles, snow, water, fire, selection rays, WebGL performance, and camera
  framing before adoption.
- Scenario duplication must include cube terrains, side-cube terrains, and
  cube-specific fire/visual assets where those assets will be edited.

## Related Specs

- `Specs/NormalMode.md`
- `Specs/SideBySideMode.md`
- `Specs/CameraAnimation.md`
- `Specs/DataMappings.md`
- `Specs/Fire.md`
- `Docs/AddingFutureScenarios.md`
