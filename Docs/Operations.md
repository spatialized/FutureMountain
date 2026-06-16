# Future Mountain Operations Guide

## Purpose

This document describes the operational infrastructure required to maintain and support the Future Mountain project.

It is intended for developers, graduate students, researchers, and technical staff who may need to administer servers, websites, databases, or related services.

This document focuses on project operations rather than software architecture or scientific modeling.

---

# Infrastructure Overview

Future Mountain consists of several web applications, databases, simulation datasets, and Unity applications hosted through UCSB infrastructure.

Primary responsibilities include:

* Website administration
* Database maintenance
* User account management
* Server access and troubleshooting
* Deployment of web applications
* Data management and backups
* Coordination with UCSB GRIT support staff

---

# Server Hosting

## Primary Server

**Hostname**

```text
fm01.grit.ucsb.edu
```

**IP Address**

```text
128.111.100.115
```

This server is managed through UCSB GRIT (Geographic Information and Remote Sensing Technology).

The server hosts the Future Mountain web applications and associated services.

---

# GRIT Support

## GRIT Helpdesk

https://zammad.grit.ucsb.edu/

GRIT should be contacted for:

* Server outages
* Authentication problems
* Authorization and permissions issues
* VPN access problems
* Remote Desktop access issues
* Operating system or infrastructure failures
* Server maintenance requests

When reporting issues, include:

* Date and time of occurrence
* Error messages
* Screenshots if available
* Steps required to reproduce the issue

---

# VPN Requirements

Administrative access to project infrastructure requires connection through the UCSB Ivanti VPN.

Without VPN access, administrative services may be inaccessible.

Examples include:

* Remote Desktop access
* Internal server management
* IIS administration
* Database administration
* Internal web applications

---

# Administrative Access

## Remote Desktop

Administrative tasks are typically performed through Remote Desktop access to:

```text
fm01.grit.ucsb.edu
```

Requirements:

* UCSB Ivanti VPN connection
* Authorized user account
* Administrative privileges on the server

Common administrative tasks include:

* Website deployment
* IIS configuration
* Log inspection
* Application troubleshooting
* Database maintenance

---

# Hosted Websites

## Production Website

https://futuremtn.org

Primary public-facing Future Mountain website.

---

## Staging Website

https://staging.futuremtn.org

Used for testing and validation before production deployment.

---

## Data Portal

https://data.futuremtn.org

Provides access to simulation data and related resources.

---

# Website Administration

Website administration may include:

* Creating new websites
* Updating IIS configuration
* Managing SSL certificates
* Deploying application updates
* Reviewing server logs
* Managing application pools

Administrative access to the server is required.

---

# Databases

Future Mountain utilizes MySQL databases to store simulation outputs and related application data.

Database documentation is maintained separately in:

```text
Docs/DataDictionary.md
Specs/DataModel.md
```

Database administration tasks may include:

* Backups
* Schema updates
* User account management
* Data imports
* Performance troubleshooting

---

# Source Code

Source code repositories are maintained through GitHub.

Developers should use Git for:

* Version control
* Code reviews
* Documentation updates
* Issue tracking

Project documentation should be committed alongside source code whenever possible.

## Repository

* Repository root: `D:\Git\FutureMountain` on this workstation.
* Unity solution: `FutureMountain.sln`.
* Big Creek scene: `Assets/Scenes/BigCreekV1/BigCreekV1.unity`.
* Central Coast scene: `Assets/Scenes/CentralCoastV2/CentralCoastV2.unity`.
* Unity version: `2022.3.62f3`.
* Scenario config reference: `ScenarioConfig_BigCreek.json`.

The repository contains Unity source/assets plus documentation in `Docs/` and feature specs in `Specs/`.

## Required Local Software

* Unity Editor `2022.3.62f3`.
* Unity WebGL build support if building the online version.
* Git.
* A browser for WebGL smoke testing.
* Optional: MySQL Workbench 8 for schema inspection/export.
* Optional: local Future Mountain API/database stack if testing `LOCAL_VERSION`.

## Build Targets And Symbols

The project currently uses scripting define symbols in `ProjectSettings/ProjectSettings.asset`.

Known symbols:

* `WEB_VERSION` for WebGL.
* `LOCAL_VERSION` for Standalone/editor-local API testing.

Current API base URLs in `Assets/Scripts/Controllers/WebManager.cs`:

* `LOCAL_VERSION`: `http://localhost:5550/api/`
* `WEB_VERSION` or default: `https://data.futuremtn.org/api/`

`SimulationSettings.BuildForWeb` is currently true by default. In web builds, `SimulationSettings.OptimizeForWeb()` reduces vegetation density and increases carbon factors to improve performance.

## Opening The Project

1. Open the repository folder in Unity Hub.
2. Use Unity `2022.3.62f3`.
3. Open the scenario scene you are testing, such as
   `Assets/Scenes/BigCreekV1/BigCreekV1.unity`.
4. Wait for Unity to finish importing assets and compiling scripts.
5. Confirm that the scene loads without missing-script errors in the Console.

## Running In The Editor

The project can run in the Unity Editor, but current runtime settings are oriented toward API-backed data loading.

Before pressing Play, confirm:

* The active scene is the scenario scene you intend to test.
* The intended scripting symbol is active for the target being tested.
* The API target is reachable if using web/API data.
* The Console is visible for data-loading errors.

Basic run check:

1. Press Play.
2. Confirm the intro/loading flow appears.
3. Start the simulation.
4. Confirm terrain, aggregate cube, and individual cubes load.
5. Confirm the Timeline appears and the simulation advances through dates.

## Web/API Data Check

For the deployed Big Creek API, these endpoints are expected by Unity:

* `https://data.futuremtn.org/api/cubedata/{patchIdx}/{warmingIdx}`
* `https://data.futuremtn.org/api/waterdata/{index}`
* `https://data.futuremtn.org/api/waterdata/total`
* `https://data.futuremtn.org/api/firedata/{warmingIdx}`
* `https://data.futuremtn.org/api/patchdata`
* `https://data.futuremtn.org/api/patchdata/{patchId}`
* `https://data.futuremtn.org/api/dates`
* `https://data.futuremtn.org/api/dates/{year}/{month}/{day}`
* `https://data.futuremtn.org/api/terraindata/{warmingIdx}`

If the app stalls during loading, first check browser/Unity Console logs for failed API requests, JSON parse failures, or missing fields.

API route and deployment documentation:

* [Future Mountain API](Services/FutureMountainApi.md)
* [API Route Spec](../Specs/FutureMountainAPI/Routes.md)
* [API Deployment Spec](../Specs/FutureMountainAPI/Deployment.md)

## Local API Testing

`LOCAL_VERSION` points Unity to:

```text
http://localhost:5550/api/
```

Use this path when testing a local API/database copy. The local API should match the same endpoint and JSON field contract as the deployed API unless Unity code is being intentionally updated.

Before testing locally:

* Start the local API.
* Confirm the local database is loaded with the expected scenario data.
* Visit one or two API endpoints directly in a browser to confirm JSON responses.
* Confirm CORS/browser access if testing a WebGL build against the local API.

## WebGL Build Checklist

Before building:

* Confirm active build target is WebGL.
* Confirm `WEB_VERSION` is present for WebGL scripting define symbols.
* Confirm the intended scenario scene is included in Build Settings.
* Confirm `SimulationSettings.BuildForWeb` is true.
* Confirm the deployed API is reachable.
* Confirm no local-only API URL is selected.

Build smoke test:

1. Launch the built WebGL output through a local web server or deployment staging URL.
2. Confirm loading completes.
3. Confirm the landscape river, cubes, vegetation, snow behavior, timeline, and messages are visible.
4. Change warming level.
5. Pause/resume time.
6. Click the Timeline to jump to another year.
7. Enter Side-by-Side Mode on a cube and compare two warming levels.
8. Toggle Show Model/Data Layer.
9. Verify fire behavior around Big Creek fire years.

## Standalone/Local Build Checklist

Before building:

* Confirm active build target is Standalone.
* Confirm `LOCAL_VERSION` is present for Standalone scripting define symbols if testing a local API.
* Confirm a local API is running at `http://localhost:5550/api/`, or adjust the code/config intentionally.
* Confirm the intended scenario scene is included in Build Settings.

Smoke test the same primary features as WebGL, with extra attention to any local/non-web paths such as background snow and legacy data-loading behavior.

## Data Update Procedure

Current Big Creek runtime data is API/database-backed. The raw Big Creek source data files are not currently present in this Unity repository.

For any scenario data update:

1. Confirm source files and units with the data/modeling contact.
2. Update importer configuration and importer code as needed.
3. Import into a staging database.
4. Export or document the resulting schema changes.
5. Verify API responses for every endpoint Unity consumes.
6. Update Unity DTOs only if the API contract changes.
7. Update [DataDictionary.md](DataDictionary.md), [Data Model Spec](../Specs/DataModel.md), and [Data Mappings Spec](../Specs/DataMappings.md).
8. Run the WebGL/editor smoke tests before replacing production data.

For Central Coast, new fields should be added with an explicit compatibility plan so Big Creek can continue to run unchanged or through a clear adapter.

## Documentation Update Procedure

When behavior changes, update the nearest feature spec in `Specs/`.

When data contracts change, update:

* [DataDictionary.md](DataDictionary.md)
* [DataFormats.md](DataFormats.md)
* [Data Model Spec](../Specs/DataModel.md)
* [Data Mappings Spec](../Specs/DataMappings.md)

When build, deployment, access, or runbook details change, update this operations document.

---

# Documentation

Project documentation is maintained within the repository under:

```text
Docs/
```

Examples include:

* Architecture documentation
* Data model documentation
* RHESSys integration documentation
* Vegetation visualization specifications
* Fire system documentation
* Operations documentation

Documentation stored in Git is considered the authoritative source.

---

# Disaster Recovery

If project services become unavailable:

1. Verify VPN connectivity.
2. Verify server availability.
3. Review application and IIS logs.
4. Confirm database connectivity.
5. Contact GRIT if server-level issues are suspected.
6. Document findings and corrective actions.

---

# Key Contacts

## UCSB GRIT

Primary support organization responsible for server infrastructure and related services.

Helpdesk:

https://zammad.grit.ucsb.edu/

---

## Future Mountain Team

Project-specific contacts should be maintained here.

Future updates should include:

* Principal Investigators
* Graduate Researchers
* Developers
* System Administrators

---

# Revision History

| Date | Author | Notes |
| --- | --- | --- |
| YYYY-MM-DD | Initial Author | Initial operations guide created |
