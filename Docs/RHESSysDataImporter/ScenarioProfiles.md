# RHESSys Data Importer Scenario Profiles

Last updated: 2026-06-13

## Purpose

This document defines the scenario-profile concept added to the importer as task
`CCV2-02` in `Tasks/CentralCoastV2_Importer_TaskGraph.md`.

A scenario profile is an explicit, curated identifier for a scenario's data
model. It lets the importer support more than one data model side by side
without breaking Big Creek v1, and without guessing the data model from table
names or from which files happen to be present.

## Known Profiles

| Profile | Meaning |
| --- | --- |
| `BigCreekV1` | Existing Big Creek data model (legacy default). |
| `CentralCoastV2` | Central Coast v2 RHESSys-derived data model. |

These are represented in code by the `ScenarioProfileKind` enum in
`Configuration/ScenarioProfile.cs`.

## Selection

The active profile is selected explicitly through the scenario config field:

```json
{
  "scenarioName": "BigCreek",
  "scenarioProfile": "BigCreekV1"
}
```

Resolution rules (`ScenarioProfiles.ResolveOrDefault`):

- A recognized value selects that profile.
- A missing/empty value defaults to `BigCreekV1`.
- An unknown value defaults to `BigCreekV1` and logs a warning.

Recognized aliases are case-insensitive and tolerate a few spellings, e.g.
`BigCreekV1` / `bigcreek`, and `CentralCoastV2` / `centralcoast`.

The default of `BigCreekV1` is deliberate: existing Big Creek configs that omit
`scenarioProfile` keep their current behavior unchanged.

## Why Not Infer The Profile

The importer must not infer the data model from:

- table names in the database,
- which CSV/text files are present,
- folder layout alone.

Inference is fragile and would let an accidental file or table silently change
parsing/import behavior. Instead, the profile is declared in config and logged at
startup so every run states which data model it is using.

## Current Behavior

- `Program.cs` resolves and prints the active profile at startup and warns on an
  unknown value.
- `WizardRunner` displays the active profile during scenario confirmation.
- `ScenarioConfig_BigCreek.json` now declares `"scenarioProfile": "BigCreekV1"`.

At this stage the profile is established and surfaced, but it does not yet branch
import logic. Profile-specific config, schema, model classes, and import paths for
Central Coast v2 are implemented in later tasks (`CCV2-03` onward). Big Creek v1
remains the only profile with an implemented import path until then.

## Compatibility

- Big Creek v1 is the default; omitting `scenarioProfile` preserves existing
  behavior.
- Adding `CentralCoastV2` does not change any Big Creek path.
- New profiles should be added as enum values plus explicit handling, never as
  implicit behavior triggered by data shape.
