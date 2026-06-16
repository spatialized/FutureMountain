# SimulationSettings

Last updated: 2026-06-16

## Purpose

`SimulationSettings` (`Assets/Scripts/Settings/SimulationSettings.cs`) is a Unity `MonoBehaviour` attached to the **Settings** GameObject in the scene. It is the single Inspector-accessible location for tuning simulation behaviour without recompiling. All controllers obtain a reference to it at startup and read from it at runtime.

## How It Is Accessed

`GameController` finds it in `Awake()` with:
```csharp
settings = GameObject.Find("Settings").GetComponent<SimulationSettings>();
```

`LandscapeController` finds it using:
```csharp
settings = FindObjectOfType<SimulationSettings>();
```

Other controllers (`CubeController`, etc.) receive a reference through method arguments or by finding it the same way. `GameController` asserts that the reference is not null on startup, so the Settings GameObject and component must always be present in the scene.

## Inspector Groups

### Data
| Field | Default | Meaning |
|---|---|---|
| `CubeDataOnly` | `false` | Skip the full landscape simulation and use test precipitation data. Useful for rapid iteration on cube visuals. |
| `apiProfile` | `BigCreek` | Scene-level API route profile. `BigCreek` uses legacy `/api/...` routes; `CentralCoast` prepends `/api/centralcoast/...` for web requests. |

The Big Creek scene should use `apiProfile = BigCreek`. The Central Coast v2
scene should use `apiProfile = CentralCoast`. This setting affects cube data,
dates, water data, fire data, patch data, terrain data, and timeline water-data
requests because they all flow through `WebManager`.

### BuildForWeb (Compile-Time, Not Inspector)
`BuildForWeb` is **not** an inspector toggle. It is a read-only C# property whose value is determined at compile time:
- `WEB_VERSION` or `LOCAL_VERSION` build symbol → `true`
- No symbol (Editor) → `false`

This controls whether data is loaded from the web API (`true`) or from local `TextAsset`/`Resources` files (`false`). It is used extensively in `GameController` to switch between `UpdateDataFromWeb()` and `FindParameterRanges()` paths.

### Fire
| Field | Default | Meaning |
|---|---|---|
| `AutoPauseOnFire` | `false` | Pause the simulation automatically when a fire starts. |
| `MinFireFrameLength` | `6` | Minimum number of simulation frames a fire occupies when auto-pause is off. |
| `MaxFireLengthInSec` | `3` | Fire display duration in seconds when auto-pause is on. |
| `ImmediateFireTimeThreshold` | `10` | Time steps above which fire ignition skips spread animation and burns immediately. |

### Population
| Field | Default | Meaning |
|---|---|---|
| `MinFrontTrees` | `2` | Minimum trees placed at the front of each cube. |
| `MaxTrees` | `40` | Maximum grown trees per cube. Scaled down by `WebBuildMaxVegMultiplier` in web builds. |
| `MaxShrubs` | `100` | Maximum grown shrubs per cube. Scaled similarly. |
| `WebBuildMaxVegMultiplier` | `0.55` | Multiplier applied to `MaxTrees` and `MaxShrubs` to reduce vegetation density in web builds. |

### Distribution
Controls spatial placement of trees and shrubs within each cube (padding, zone depth, preference percentages).

### Carbon
Carbon-per-metre factors for trees, shrubs, roots, and the aggregate cube. Higher values → fewer visible plants for the same carbon value. Scaled by `WebBuildCarbonMultiplier` for web builds.

| Field | Default |
|---|---|
| `TreeCarbonFactor` | `0.027` |
| `RootsCarbonFactor` | `0.009` |
| `ShrubCarbonFactor` | `0.004` |
| `CubeATreeCarbonFactor` | `0.018` |
| `CubeARootsCarbonFactor` | `0.0033` |
| `CubeAShrubCarbonFactor` | `0.005` |
| `WebBuildCarbonMultiplier` | `3.0` |

### Emission
Particle emission rate factors for tree and shrub evapotranspiration particles.

### Geometry
Tree and shrub height/width scale ranges and variability.

### Roots
Root height/width scale ranges, spread speed, size ratio, Y-offset factor, and width variability.

### Time
| Field | Default | Meaning |
|---|---|---|
| `TreeGrowthSpeedFactor` | `0.00033` | Per-frame growth increment for trees. |
| `TreeDeathSpeed` | `0.1` | Speed at which trees die. |
| `DeadTreeShrinkFactor` | `0.066` | Per-frame shrink rate for dead tree litter. |

### Side-by-Side Mode
| Field | Default | Meaning |
|---|---|---|
| `SideBySideModeXOffsetAggregate` | `100` | Lateral offset for side-by-side aggregate cube (metres). |
| `SideBySideModeXOffset` | `80` | Lateral offset for side-by-side sample cubes (metres). |

### UI
| Field | Default | Meaning |
|---|---|---|
| `MessageFramesLength` | `90` | How many frames a message display lasts. |
| `MessageMinLength` | `8` | Minimum message display time in seconds. |

### Debugging
These flags gate `Debug.Log` output throughout the controllers. All default to `false`.

| Field | Controls |
|---|---|
| `DebugGame` | General flow logging in `GameController` and `LandscapeController`. |
| `DebugModel` | Graph/data-layer display logging in `CubeController`. |
| `DebugFire` | Fire ignition, regrowth, and patch burn logging in `LandscapeController`. |
| `DebugDetailed` | High-frequency per-frame or per-data-row logging in `LandscapeController`. Very verbose — only enable briefly. |

`GameController` reads these through its `DebugLevel(int level)` helper. `LandscapeController` reads them directly via its `settings` reference obtained in `Awake()`.

## Web Build Optimization

`OptimizeForWeb()` is called automatically from `Start()` whenever the `WEB_VERSION` scripting symbol is defined. It applies `WebBuildMaxVegMultiplier` and `WebBuildCarbonMultiplier` to the population and carbon fields so that vegetation counts are appropriate for WebGL performance budgets. **Do not call this manually** except in automated tests.

## Remaining Scattered Flags

The following debug booleans still exist as local hardcoded fields in their respective files and are not yet driven by `SimulationSettings`. They are all `false` by default and function as dead code unless manually changed in source:

| Flag | Location |
|---|---|
| `debugCubes`, `debugAggregate`, `debugDetailed` | `CubeController.cs` |
| `debugFire`, `debugFrame`, `debugMessages` | `GameController.cs` |
| `debug`, `debugDetailed` | `WebManager.cs` |

Additionally, `debugOutputPath = "/Users/davidgordon/Desktop/debug.txt"` is duplicated verbatim in both `GameController.cs` and `CubeController.cs`. It points to a hardcoded developer-specific path and is effectively dead code in any other environment.
