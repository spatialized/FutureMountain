# Future Scenario Notes

Last updated: 2026-06-12

## Purpose

This document captures early requirements and decisions for adding future scenarios, especially the planned Central Coast scenario. It is intentionally a draft spec for review.

## Central Coast Scenario Goals

- Reuse the Future Mountain interaction model and visual system.
- Replace or extend Big Creek-specific data with Central Coast model outputs.
- Support additional data columns that will require importer, MySQL schema, API, and Unity model updates.
- Make the scenario understandable to a new developer/designer without requiring project-history knowledge.

## Required Scenario Configuration

A future-ready scenario should define:

- Scenario id and display name.
- Region description and narrative framing.
- Available warming/climate scenarios.
- Data date range.
- Cube count and cube metadata.
- Aggregate cube behavior.
- API base URL or local data source.
- Database/schema version.
- Column mappings for all source files.
- Runtime variable mappings from data fields to visual systems.
- Feature flags, such as fire enabled, vegetation layers, background snow, and terrain data source.

## Schema/API Changes

For each new Central Coast data column:

- Identify source file and source column name.
- Define database table and column type.
- Define API JSON field name.
- Define Unity DTO field or runtime mapping.
- Define whether the field drives a visual change, UI display, message condition, or only metadata.
- Define default behavior when the field is missing.

## Runtime Refactor Targets

Before implementing the new scenario, consider:

- Centralize warming-level definitions.
- Move API base URL and scenario id into configuration.
- Replace hard-coded cube count assumptions where possible.
- Move Big Creek text/labels/messages into scenario content.
- Create shared data-contract definitions for importer/API/Unity.
- Add validation on startup so incompatible data fails clearly.

## Open Questions

- What are the exact Central Coast data columns and their units?
- Are warming levels still `0, 1, 2, 4, 6 C`, or will the scenario use different climate cases?
- Does the Central Coast scenario include fire, and if so, does fire data have the same grid/patch structure?
- Will the deployed web API serve multiple scenarios from one endpoint, or will each scenario have its own API/database?
- Which parts of the Big Creek visual design should remain, and which should become region-specific?

