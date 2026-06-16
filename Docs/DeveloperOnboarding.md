# Developer Onboarding

Last updated: 2026-06-16

## Purpose

This is the practical checklist for a new Future Mountain developer who needs
repository access, server access, and working database/API configuration.

## Access To Request

Ask the project lead and UCSB GRIT for:

- GitHub access to the Future Mountain repository.
- UCSB Ivanti VPN access.
- Remote Desktop access to `fm01.grit.ucsb.edu`.
- A Windows/server login account with the admin privileges needed to manage IIS
  for `data.futuremtn.org`.
- MySQL credentials for the Future Mountain databases needed for your role.

GRIT helpdesk:

```text
https://zammad.grit.ucsb.edu/
```

## Clone The Repository

Recommended local path on the Windows workstation:

```powershell
cd D:\Git
git clone <repo-url> FutureMountain
cd D:\Git\FutureMountain
```

Open the project with Unity `2022.3.62f3`.

## Local API Configuration

The API project is:

```text
Services/FutureMountainApi/FutureMountainAPI/FutureMountainAPI/
```

The checked-in `appsettings.json` should not contain real passwords. For local
development, keep connection strings in a local-only config source such as
`appsettings.Development.json`, environment variables, or user secrets.

Expected connection-string keys:

```json
{
  "ConnectionStrings": {
    "BigCreekDbContext": "<Big Creek database connection string>",
    "CentralCoastDbContext": "<Central Coast database connection string>"
  }
}
```

Do not commit local password files. The repository ignores API
`appsettings.Development.json` and `appsettings.Local.json` files.

## Server API Configuration

The deployed API for Unity is served through:

```text
https://data.futuremtn.org/api/
```

On the server, the deployed API folder for `data.futuremtn.org` must have an
`appsettings.json` or approved server-side configuration containing production
connection strings for:

- `BigCreekDbContext`
- `CentralCoastDbContext`

When publishing a new API build:

1. Publish locally to a folder.
2. Confirm the publish output has the correct deployment configuration.
3. Remote Desktop to `fm01.grit.ucsb.edu`.
4. Stop the IIS site/application for `data.futuremtn.org`.
5. Back up the current deployed folder.
6. Copy the publish output into the deployed folder.
7. Confirm server connection strings are still present.
8. Restart the IIS site/application.
9. Smoke test the API.

Deployment details live in:

```text
Docs/Services/FutureMountainApi.md
Specs/FutureMountainAPI/Deployment.md
```

## Importer Local Password File

The RHESSys importer can read an ignored local password file:

```text
RHESSYs_Data_Importer/RHESSYs_Data_Importer/appsettings.Local.json
```

This is used when scenario config files intentionally omit the database
password. Keep this file local only.

## Smoke Tests

After configuration, verify:

```text
https://data.futuremtn.org/api/dates
https://data.futuremtn.org/api/waterdata/total
https://data.futuremtn.org/api/centralcoast/dates
https://data.futuremtn.org/api/centralcoast/waterdata/total
```

Then open the intended Unity scene and confirm the simulation loads data from
the expected API profile.
