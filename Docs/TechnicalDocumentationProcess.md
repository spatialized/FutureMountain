# Technical Documentation Process

Last updated: 2026-06-16

## Purpose

Future Mountain keeps technical documentation in both `Docs/` and `Specs/`.
This separation is intentionally lightweight:

- `Docs/` contains general, operational, onboarding, scenario, service, and
  higher-level process documentation.
- `Specs/` contains feature-specific or subsystem-specific technical notes that
  are useful when implementing, reviewing, or extending a defined part of the
  project.

This structure is meant to support both human readers and agentic workflows.
General documentation helps a new contributor understand the project and its
scenarios. Specs give implementation agents and reviewers smaller, focused
documents they can use as context without needing to load the whole project
history.

## Handbook Manifest

The generated handbook order is controlled by the repo-root file:

```text
handbook-manifest.txt
```

This file does not move or rename documentation. It only defines handbook
chapters and the order in which existing Markdown files should be assembled.
The handbook is simply an organized single source for the project's docs and
specs, built from the same canonical Markdown files already maintained in the
repo.

Manifest conventions:

- Lines starting with `# ` define handbook chapters.
- Lines starting with `## ` define handbook sub-chapters.
- Non-empty non-heading lines are relative paths to Markdown files.
- Blank lines are allowed for readability.
- Lines starting with `//` are comments for future build tooling.

Each Markdown file under `Docs/` and `Specs/` should appear in the manifest
exactly once unless the handbook process is intentionally changed later.

## Building The Draft Handbook

Run the handbook build script from the repo root:

```powershell
.\Build-Handbook.ps1
```

By default, the script reads:

```text
handbook-manifest.txt
```

and writes:

```text
FutureMountain_Handbook.md
```

The generated Markdown handbook is a draft assembly of the documentation in the
manifest order. The source documents remain the canonical files to edit.
Ideally, the handbook should be rebuilt, exported, and refreshed after each
major Future Mountain update so the shareable version stays aligned with the
current project state.

## Final Handbook Output

Pandoc is required to create final converted versions of the handbook, such as a
PDF or Word document. The current script creates the assembled Markdown file;
the final Pandoc command/process may be updated after the first full draft pass.

Until that process is finalized, install Pandoc before attempting final handbook
export, and treat `FutureMountain_Handbook.md` as the intermediate build output.
