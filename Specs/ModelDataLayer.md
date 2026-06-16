# Show Model / Data Layer

Last updated: 2026-06-12

## Purpose

The Show Model feature is the cube-side visual data layer: the bar-style graphs that appear next to cubes. Its purpose is to let users compare the current RHESSys model values with the living 3D visualization, so the experience is not only scenic or illustrative but also connected back to the underlying data.

This feature is related to, but separate from, the Timeline. The Timeline is also graph-like: it renders annual precipitation as bars and overlays fire/message markers. Show Model is a cube-level data display for the current simulation moment.

## User Interface Behavior

The user enables the layer with the `ShowModelDataToggle` UI control.

In Normal Mode, the layer appears for:

- The aggregate cube.
- Each active detailed terrain cube.

In Side-by-Side Mode, the layer appears in the left and right side-by-side statistics areas so the selected cube and comparison cube can be evaluated against different warming scenarios.

The current UI is best understood as a set of bars or slider-like readouts, not as a full graphing system. It shows current-state values. It does not show a full time-series line chart, historical trace, uncertainty range, or selectable axis.

## Current Displayed Variables

The active current-version display focuses on:

- Net transpiration.
- Plant carbon, calculated as stem carbon plus leaf carbon.

`CubeController.UpdateStatistics()` maps current data values into UI sliders:

- `netTransSlider`: model net transpiration.
- `plantCarbonSlider`: model stem carbon plus leaf carbon.

The same method also computes visualized comparison values:

- `netTransSliderDebug`: transpiration currently represented by visible tree and shrub particle emission.
- `plantCarbonSliderDebug`: plant carbon currently represented by visible trees and shrubs.

Those debug/comparison sliders are initialized inactive in `SetupStatisticsPanel()`, so the current public UI may not expose them as a polished user-facing comparison. They are still important technically because they show the intended comparison model: data value vs. current 3D representation.

## Technical Flow

`GameController.UpdateModelDisplayFromToggle()` reads the Show Model toggle, sets `displayModel`, and calls either `ShowStatistics()` or `HideStatistics()`.

`GameController.ShowStatistics()` enables the proper statistics UI for the current mode:

- Normal Mode: aggregate cube plus active cubes.
- Side-by-Side Mode: `cubeSBSModeStatsLeft` and `cubeSBSModeStatsRight`.

`GameController.HideStatistics()` disables the same display objects.

During simulation playback, `GameController.RunGame()` updates the statistics when either of these is true:

- `displayModel` is enabled.
- `sideBySideMode` is active.

Each cube then runs `CubeController.UpdateStatistics()`, which:

1. Reads the current model values for the cube's current `timeIdx`.
2. Chooses the correct overstory, understory, or aggregate fields based on cube data type.
3. Maps values from scenario min/max data ranges into slider min/max UI ranges.
4. Optionally computes the current visualized equivalents from objects already in the scene.

## Data-to-Bar Mapping

Net transpiration uses:

- `transOver` for one-layer vegetation cubes.
- `transOver + transUnder` for two-layer vegetation cubes.
- `netTranspiration` for aggregate cubes.

Plant carbon uses:

- `leafCOver + stemCOver` for one-layer vegetation cubes.
- `leafCOver + stemCOver + leafCUnder + stemCUnder` for two-layer vegetation cubes.

The visualized comparison values are calculated from the scene:

- Visualized transpiration sums tree transpiration effects and shrub particle emission rates.
- Visualized plant carbon sums tree carbon and shrub carbon inferred from current object sizes.

This means the layer can reveal when the 3D representation is still catching up to the model data during animated playback.

## Timeline As Precipitation Graph

The Timeline is a separate graphing feature. `TimelineControl.CreateTimeline()` and `CreateTimelineWeb()` instantiate one bar per year and map precipitation to bar height.

For local/non-web data, the maximum precipitation is calculated from loaded `WaterDataYear` values. For web data, the current code uses a hard-coded maximum precipitation value of `2582f`, with a code comment noting that this should come from the API.

Timeline bars are not a general Show Model graph. They are specifically annual precipitation bars plus event markers for fires and messages.

## Currently Disabled Or Latent Data Layer Variables

The code contains commented or inactive references for additional statistics:

- Snow amount.
- Net photosynthesis.
- Water access.
- Groundwater depth.

These variables should be treated as candidates for future data-layer work rather than confirmed active user-facing graphs in the current version.

## Current Limitations

- The display is bar-based, not an actual line graph or multi-year chart.
- The visible UI does not clearly expose all computed data-vs-visual comparison values.
- Units, legends, and labels are limited.
- The graph ranges are scenario-dependent and rely on min/max values calculated from loaded data.
- The layer compares current values only; it does not preserve a visible history of how a cube changed over time.
- Some potentially useful data fields are loaded but not actively graphed.

## Future Improvement Ideas

Future versions could turn this into a more complete visual analytics layer:

- Replace or augment bars with actual graphs.
- Show model value and visualized value together as paired traces.
- Add variable selectors for water, snow, vegetation, fire, and soil metrics.
- Add units, legends, and short labels that match RHESSys/source data names.
- Support time-window graphs for the selected cube instead of current-frame values only.
- Share graph infrastructure with the Timeline so precipitation, fire markers, and cube variables can be compared more consistently.
- Allow scenario-specific graph definitions so Big Creek remains compatible while Central Coast can add new fields.

## Backward Compatibility Notes

For Big Creek, keep the current Show Model defaults working even if the graph system is refactored.

For Central Coast and later scenarios, each graphable variable should declare:

- Data field name.
- Display label.
- Units.
- Min/max or normalization rule.
- Whether it is compared against a visualized scene-derived value.
- Whether missing data should hide the graph, show a disabled state, or use a default.

This will let new data columns be added without breaking the existing Big Creek visualization.
