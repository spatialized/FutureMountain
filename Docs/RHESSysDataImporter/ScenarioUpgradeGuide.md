# RHESSys Data Importer Scenario Upgrade Guide

Last updated: 2026-06-14

## Purpose

This guide explains the recommended path for adding a future RHESSys data format after Big Creek v1 and Central Coast v2.

The goal is to add a new scenario path beside existing ones, not to mutate older imports in place. Big Creek v1 and Central Coast v2 should continue to run with their existing configs, tables, parser assumptions, API behavior, and Unity assets unless a separate compatibility task explicitly changes them.

## Short Version

Yes: start with a new `ScenarioConfig`.

Then decide whether the new data format can reuse an existing `scenarioProfile` or needs a new one. If the files, columns, grains, identifiers, or derived Unity data are meaningfully different, add a new profile rather than forcing the new data through an older importer path.

Recommended sequence:

1. Create a new scenario config JSON.
2. Inventory the source files and document their grains.
3. Decide whether a new scenario profile is needed.
4. Design raw import tables before API or Unity work.
5. Add model classes and database context mappings.
6. Create/export the target database schema.
7. Add validators and dry-run row-count checks.
8. Implement importers incrementally by data category.
9. Smoke test against a separate database.
10. Design derived API/Unity data only after raw import is proven.

## Step 1: Create A New ScenarioConfig

Copy the nearest existing config:

- `ScenarioConfig_BigCreek.json` for Big Creek-style data.
- `ScenarioConfig_CentralCoastV2.json` for Central Coast-style data.

For a new format, give the config its own scenario identity:

```json
{
  "scenarioProfile": "NewScenarioV3",
  "scenarioRunId": "new_scenario_v3_baseline_001",
  "warmingIdx": 0,
  "sourceRoot": "../Data/NewScenarioV3",
  "delimiter": ",",
  "files": {
    "dailyAggregate": "example_daily.csv"
  }
}
```

Use `scenarioRunId` for the specific run/member being imported. Use `warmingIdx` for Future Mountain comparison cases. If the first sample is a baseline or unknown case, use `warmingIdx = 0` and document that assumption.

## Step 2: Inventory The Source Data

Before writing importer code, create a data-format doc that answers:

- What files exist?
- What is each file's grain: daily, monthly, yearly, static, raster, or derived?
- What are the columns?
- Which columns identify space: cube, basin, hill, zone, patch, stratum, pixel, raster value?
- Which columns identify time?
- What date range is present?
- How many rows are expected?
- Are there multiple warming/climate/scenario members?
- Which files are raw RHESSys output, and which are derived assets?

For Central Coast v2, this lives in:

```text
Docs/CentralCoastV2/DataFormats.md
```

For a future format, create the equivalent under a new folder, for example:

```text
Docs/NewScenarioV3/DataFormats.md
```

## Step 3: Choose Or Add A Scenario Profile

Use an existing profile only if the new data matches that profile's assumptions.

Add a new profile when any of these change meaningfully:

- file naming
- column names
- temporal grain
- spatial identifiers
- raster/patch-map strategy
- table shape
- required derived data for Unity
- normalization or aggregation rules

Profiles currently include:

- `BigCreekV1`
- `CentralCoastV2`

A future profile should be explicit, such as:

```text
NewScenarioV3
```

Do not infer a scenario from file names alone. The config should say which profile is active.

## Step 4: Design Raw Import Tables First

Start with raw/staging tables that preserve the source data. Avoid jumping directly to Unity-facing tables.

For each raw table, define:

- source file
- table name
- primary key strategy
- scenario columns: `scenarioRunId`, `warmingIdx`, `importRunId`
- source provenance: `sourceFile` when useful
- indexes needed for validation and later transformations

Keep existing scenario databases separate when the table meaning changes. For example, Central Coast v2 uses its own database/settings instead of forcing new rows into Big Creek's schema.

## Step 5: Add Models And DbContext Entries

Add model classes under the scenario namespace when the table shape is scenario-specific:

```text
Models/CentralCoast/
Models/NewScenarioV3/
```

Then expose them through the appropriate scenario DbContext.

Do not modify older model classes unless the task is explicitly a backward-compatible cleanup and has been reviewed as such.

## Step 6: Create And Export The Database Schema

Each scenario profile should have an explicit target schema/database. Do not
reuse `defaultdb` or an older scenario schema when the table meanings or shapes
have changed.

For example:

```text
futuremtn_central_coast
futuremtn_ventana_wilderness_v3
```

The most user-friendly setup path is:

1. Create the empty schema in MySQL Workbench with **Create Schema**.
2. Open the scenario SQL export from `Database/Schema/`.
3. Select the new schema as the active/default schema, or add `USE <schema>;`
   near the top of the SQL editor.
4. Run the script.
5. Verify with `SHOW TABLES;`.

For Central Coast v2, the checked-in schema export is:

```text
Database/Schema/CentralCoastV2_schema.sql
```

Future scenarios should add the equivalent file, for example:

```text
Database/Schema/VentanaWildernessV3_schema.sql
```

Schema export files may include table-level character set/collation details, but
they do not necessarily create the database or select it. Keep the create-schema
step explicit in the runbook.

EF Core migrations can still be used to generate or evolve schema, but applying
migrations directly to a production/staging server requires checking the
design-time DbContext factory connection first. Prefer a reviewed SQL export for
manual server setup unless deployment automation has been wired.

## Step 7: Add Validation Before Import

Each new format should support dry-run validation before database writes.

Minimum validation:

- all configured files exist
- headers match expected columns
- row counts match expected counts
- date/month ranges match expected ranges
- expected spatial IDs are present
- missing/extra IDs are reported clearly

The dry run should print enough detail to catch source-data surprises before a long import starts.

## Step 8: Implement Importers Incrementally

Import one category at a time. Prefer this order:

1. date/time dimension
2. daily aggregate/basin data
3. daily cube or point data
4. monthly patch/zone data
5. monthly stratum/vegetation data
6. static spatial assets such as patch maps
7. derived API/Unity data

After each category:

- run a dry run
- run a small or staging import
- compare database row counts to source row counts
- spot-check a few source rows against database rows

## Step 9: Keep Derived Terrain/API Data Separate

Raw RHESSys tables are not necessarily what Unity should consume.

Use this shape:

```text
raw RHESSys source tables
-> validated database import
-> precomputed API/Unity-facing data
-> Unity visualization
```

For Central Coast v2, `StratumData`, `FireData`, and `PatchData` are raw or source-derived inputs. They later produce precomputed `TerrainData` frames. A future scenario should make the same distinction clear.

## Step 10: Preserve Existing Behavior

Every upgrade should explicitly state what remains untouched:

- Big Creek v1 config and database assumptions
- Central Coast v2 config and database assumptions
- existing Unity assets
- existing API endpoints
- existing importer commands

If a shared class must change, document why and test the older scenario path.

## Suggested Documentation Checklist

For a future scenario, add:

- `Docs/NewScenarioV3/DataFormats.md`
- `Docs/NewScenarioV3/BigCreekV1Differences.md` or equivalent comparison doc
- `Docs/NewScenarioV3/ScenarioConfig.md`
- `Docs/NewScenarioV3/Schema.md`
- `Docs/NewScenarioV3/DerivedTerrainDataPlan.md` if Unity landscape output is needed
- task graph entries under `Tasks/`

Update existing importer docs only for shared behavior, such as new command-line flags or new profile names.

## Suggested Implementation Checklist

- Add scenario profile enum/name.
- Add `ScenarioConfig_NewScenarioV3.json`.
- Add model classes for new raw tables.
- Add or extend a scenario DbContext.
- Add or update `Database/Schema/<ScenarioName>_schema.sql`.
- Add DAL write methods.
- Add validator checks.
- Add importer methods per category.
- Wire auto mode flags.
- Wire wizard categories if interactive import is needed.
- Add dry-run examples to `BuildingAndRunning.md`.
- Run build.
- Run dry-run validation.
- Run staging database smoke test.

## Rule Of Thumb

If the new data format changes only file paths or scenario metadata, use a new config.

If it changes columns, identifiers, table shape, temporal grain, spatial mapping, or Unity-facing derived data, use a new config plus a new scenario profile.
