# RHESSys Data Importer Backlog And Known Gaps

Last updated: 2026-06-13

## Scope

This document records known current-state gaps in the embedded RHESSys Data Importer.

It is not a migration plan and does not specify future data formats.

## Repository Structure Gaps

- The embedded importer contains its own nested `.git` directory.
- The parent Future Mountain repository currently sees `RHESSYs_Data_Importer/` as untracked content.
- The embedded importer contains `.vs`, `bin`, and `obj` generated folders.
- The embedded importer includes a nested `.git/index.lock` file.
- The embedded data folder contains roughly 120 MB of files; Git vs Git LFS vs external data storage has not been decided.

## Documentation Gaps

- The importer README still says MSSQL even though current active DbContexts use MySQL.
- Current import behavior was not previously documented in the parent repo.
- The distinction between source data, sample data, and generated output is not clearly documented in the importer tree.

## Configuration Gaps

- `ScenarioConfig_BigCreek.json` contains mojibake in the description text.
- Configured input folders point to `../Data/...`, while embedded sample data lives under `data/`.
- The config includes categories and mappings that are not fully implemented by importer code.
- No formal JSON schema exists for scenario config validation.
- The config can contain database credentials.

## Import Behavior Gaps

- Wizard mode imports only cube data.
- Climate import is recognized but not implemented.
- `--force` is recognized but does not implement a clear overwrite or safety behavior.
- The create-database wizard option is simulated.
- Legacy import paths rely on hard-coded local folders in `Program.cs`.
- Legacy import paths rely heavily on positional parsing and filename conventions.
- File discovery searches every configured folder for every category.
- File discovery is top-level only and does not recurse.
- Missing files or failed category discovery often produce warnings rather than hard stops.

## Database Gaps

- Imports write one record per DbContext/`SaveChanges` call.
- There is no bulk insert path.
- There is no import-run transaction.
- There is no import manifest or provenance table.
- There is no duplicate detection or idempotency strategy.
- There is no preflight target-schema validation.
- EF migrations appear partial and do not clearly cover every target table.

## Code Quality Gaps

- The project builds with many nullable warnings.
- Some catch blocks swallow exceptions or ignore exception variables.
- SQL Server references remain in comments and packages despite MySQL being active.
- `TextFileInput.cs` is large and mixes parsing, conversion, and import orchestration.
- The DAL has unused fields and repeated context/write patterns.
- Several model namespaces and comments reflect historical code organization.

## Testing Gaps

- No automated tests were found for parsing, file discovery, config loading, or database writes.
- No fixture manifest defines expected file counts or row counts.
- No dry-run summary verifies expected import totals.
- No automated check compares imported database rows to source-file counts.

## Operational Gaps

- No clear staging-vs-production guardrail exists.
- No backup requirement is enforced by the tool.
- No structured import report is produced.
- No retry strategy exists for transient database failures.
- No guidance exists in code for whether imports append, replace, or require empty tables.

## Current Cleanup Candidates

Before fully absorbing the importer into the parent repository:

1. Remove or convert the nested `.git` directory according to the chosen repository strategy.
2. Remove generated `.vs`, `bin`, and `obj` folders from source control candidates.
3. Decide how to store source/sample data.
4. Fix the README database/provider statement.
5. Fix config description encoding.
6. Align configured sample paths with actual sample data or document the difference.
7. Add a minimal fixture set if large data is moved out of Git.
