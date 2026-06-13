# RHESSys Data Importer Repository Strategy

Last updated: 2026-06-13

## Purpose

This document records the repository/importer cleanup decision tracked as task
`CCV2-01` in `Tasks/CentralCoastV2_Importer_TaskGraph.md`.

It defines how the embedded RHESSys Data Importer lives inside the Future
Mountain repository so the importer can be committed, cloned, and built without
nested Git confusion.

## Decision

The importer is **fully absorbed into the Future Mountain repository as source**.

It is not a Git submodule and does not keep its own nested `.git` directory.

Rationale:

- The importer is small, project-specific tooling, not an independently
  versioned library.
- A submodule would add clone/checkout complexity for a tool that is only used
  alongside this repo's data and docs.
- Absorbing as source keeps importer code, docs, specs, and sample data history
  together.

Current state confirms this decision is already in effect:

- `RHESSYs_Data_Importer/` has no nested `.git` directory.
- Its source files are tracked by the parent repository.

## Project And Build Files

The importer is a real .NET 8 solution, so its solution/project files are source
and must be tracked:

```text
RHESSYs_Data_Importer/RHESSYs_Data_Importer.sln
RHESSYs_Data_Importer/RHESSYs_Data_Importer/RHESSYs_Data_Importer.csproj
```

### Problem

The repository root `.gitignore` uses the standard Unity ignore pattern:

```gitignore
*.csproj
*.unityproj
*.sln
```

That is correct for Unity-generated files such as `Assembly-CSharp.csproj` and
`FutureMountain.sln`, which are machine-generated and vary per workstation. But
it is too broad for the embedded importer, whose `.sln`/`.csproj` are real,
hand-maintained source files. Before this fix they were silently untracked, so a
fresh clone could not build the importer.

### Fix

Keep ignoring Unity-generated project files, then explicitly un-ignore the
importer's project files using narrow negation patterns in the root
`.gitignore`:

```gitignore
# Embedded RHESSys Data Importer is a real .NET tool absorbed as source.
# Keep its solution/project files tracked despite the broad Unity rules above.
!RHESSYs_Data_Importer/RHESSYs_Data_Importer.sln
!RHESSYs_Data_Importer/RHESSYs_Data_Importer/RHESSYs_Data_Importer.csproj
```

The narrow form is used (rather than `RHESSYs_Data_Importer/**/*.csproj`) because
only this single importer solution is expected. If more importer projects are
added later, add matching narrow negations or switch to the broad form.

## Generated Files

The importer's build output must never be committed. The root `.gitignore` now
explicitly ignores it:

```gitignore
RHESSYs_Data_Importer/**/[Bb]in/
RHESSYs_Data_Importer/**/[Oo]bj/
RHESSYs_Data_Importer/**/.vs/
```

This keeps generated local files (compiler output, NuGet/EF intermediate output,
Visual Studio cache) out of source control while preserving the project files.

## Large Source Data

The Central Coast v2 sample bundle is large (the embedded data totals hundreds of
MB, including a ~370 MB stratum CSV). It is handled explicitly with Git LFS:

- `RHESSYs_Data_Importer/.gitattributes` routes the `Data` tree through LFS.
- `RHESSYs_Data_Importer/Data/.gitattributes` routes `*.csv` through LFS.

The raster `.tiff` sources and CSVs in
`RHESSYs_Data_Importer/Data/RHESSysOutput-SingleWarmIdx-6-4-2026/` are tracked via
LFS so the working repository stays usable.

Source vs. sample vs. generated data distinction:

- `RHESSYs_Data_Importer/Data/` holds Central Coast v2 source/sample bundles.
- `RHESSYs_Data_Importer/RHESSYs_Data_Importer/data/` holds the older embedded
  Big Creek sample text files.
- `bin/`, `obj/`, and `.vs/` are generated and are not source.

## Acceptance Check

- Future Mountain can commit the importer without nested Git confusion: the
  importer has no nested `.git`, and its `.sln`/`.csproj` are now tracked.
- Large source data handling is explicit: data is tracked via Git LFS.
- Generated local files are not committed: `bin/`, `obj/`, and `.vs/` under the
  importer are ignored.
