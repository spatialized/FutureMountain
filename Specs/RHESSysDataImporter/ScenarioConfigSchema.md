# RHESSys Data Importer Scenario Config Schema

Last updated: 2026-06-13

## Scope

This spec documents the current scenario config object model implemented in:

```text
Configuration/ScenarioConfig.cs
```

It is descriptive, not a future schema proposal.

## Object Model

Current C# classes:

- `ScenarioConfig`
- `DatabaseConfig`
- `ScenarioFlags`

## ScenarioConfig

| Property | Type | Required by current code | Notes |
| --- | --- | --- | --- |
| `ScenarioName` | `string` | Expected | Logged at startup and in wizard |
| `Description` | `string` | Not actively required | Descriptive metadata |
| `Version` | `string` | Not actively required | Descriptive metadata |
| `Database` | `DatabaseConfig` | Yes | Used to build connection string |
| `InputFolders` | `Dictionary<string, string>` | Yes for discovery | Empty/missing collection produces warning |
| `FilePatterns` | `Dictionary<string, string>` | Yes for discovery | Empty/missing collection produces warning |
| `ColumnMapping` | `Dictionary<string, Dictionary<string, string>>` | Optional | Cube mapping currently uses `cube` key |
| `Transforms` | `Dictionary<string, List<string>>` | Not actively used | Placeholder metadata |
| `Flags` | `ScenarioFlags` | Not actively required | Light metadata |
| `OutputTables` | `List<string>` | Not actively enforced | Documents expected target tables |

Because nullable warnings are currently present, these properties are not initialized in constructors even though many are expected by runtime paths.

## DatabaseConfig

| Property | Type | Current use |
| --- | --- | --- |
| `Name` | `string` | Database name in connection string |
| `Host` | `string` | Server host in connection string |
| `Port` | `int` | Server port in connection string |
| `User` | `string` | User in connection string |
| `Password` | `string` | Password in connection string |
| `Charset` | `string` | Charset in connection string |
| `Collation` | `string` | Present in config, not included in regular connection string |

Generated connection string:

```text
server={Host};port={Port};database={Name};user={User};password={Password};charset={Charset};
```

Generated admin connection string:

```text
server={Host};port={Port};user={User};password={Password};charset={Charset};
```

## ScenarioFlags

| Property | Type | Current use |
| --- | --- | --- |
| `HasFire` | `bool` | Metadata only in current code |
| `VegetationLayers` | `int` | Metadata only in current code |

## JSON Naming

The current JSON uses camelCase names such as `scenarioName`, while C# properties use PascalCase such as `ScenarioName`.

Newtonsoft.Json maps these successfully with default case-insensitive behavior.

## Discovery Categories

`FileDiscovery` has a fixed category list:

```text
cube
patch
terrain
fire
water
climate
```

These categories must be present in `filePatterns` to avoid missing-pattern warnings.

## Column Mapping Contract

Column mapping entries are source-to-target:

```text
source header name -> importer model field name
```

For cube data, target field names are expected to match names requested in `TextFileInput.AddDataPointMapped`, including:

- `snow`
- `evap`
- `netpsn`
- `depthToGW`
- `vegAccessWater`
- `Qout`
- `litter`
- `soil`
- `heightOver`
- `transOver`
- `heightUnder`
- `transUnder`
- `leafCOver`
- `stemCOver`
- `rootCOver`
- `leafCUnder`
- `stemCUnder`
- `rootCUnder`

The mapper is case-insensitive for source header matching. Target lookup uses the default dictionary comparer, so target field casing must match the target strings requested by importer code.

## Current Validation Behavior

The importer currently validates only lightly:

- Missing `inputFolders` emits a warning.
- Missing `filePatterns` emits a warning.
- Missing category pattern emits a warning.
- Missing input folder emits a warning.
- No matched files emits a warning.
- Missing mapped cube target fields emits warnings.

The importer does not currently:

- Validate JSON against a formal schema.
- Validate database existence before import.
- Validate target table schema before import.
- Validate source file row counts or date ranges before import.
- Validate that every output table exists.

## Current Schema Compatibility Notes

The config currently describes more than the importer fully implements. For example, climate mappings and transform lists are present, but climate import and transforms are not implemented.
