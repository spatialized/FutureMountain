# Future Mountain API Deployment

Last updated: 2026-06-16

## Purpose

This spec records the current manual deployment workflow for the Future Mountain
API on the `data.futuremtn.org` IIS site/application.

The operational runbook is also summarized in:

```text
Docs/Services/FutureMountainApi.md
```

## Build Output

Publish from:

```text
Services/FutureMountainApi/FutureMountainAPI/FutureMountainAPI/
```

Command:

```powershell
dotnet publish -c Release -o C:\tmp\FutureMountainApiPublish
```

The publish folder should contain the compiled API, dependencies, `web.config`,
and deployment configuration.

## Required Configuration

The deployed app must have:

```json
{
  "ConnectionStrings": {
    "BigCreekDbContext": "<production Big Creek database>",
    "CentralCoastDbContext": "<production Central Coast database>"
  }
}
```

`BigCreekDbContext` is required during startup. `CentralCoastDbContext` is
required for Central Coast routes.

Do not commit production credentials. Put production connection strings into the
publish folder or server-side configuration using the approved deployment
practice for the host.

## IIS Copy Workflow

Manual deployment steps:

1. Publish locally.
2. Confirm production connection strings are present in the publish output or
   server-side configuration.
3. Remote Desktop to `fm01.grit.ucsb.edu`.
4. Open IIS Manager.
5. Stop the `data.futuremtn.org` website/application.
6. Back up the current deployed folder.
7. Copy all files from the publish folder into the deployed
   `data.futuremtn.org` folder.
8. Confirm deployed `appsettings.json` or server config still has production
   connection strings.
9. Start the website/application.
10. Smoke test Big Creek and Central Coast endpoints.

## Smoke Tests

Minimum endpoint checks:

```text
https://data.futuremtn.org/api/dates
https://data.futuremtn.org/api/waterdata/total
https://data.futuremtn.org/api/cubedata/-1/0
https://data.futuremtn.org/api/centralcoast/dates
https://data.futuremtn.org/api/centralcoast/waterdata/total
```

After endpoint checks pass, run a Unity/WebGL smoke test.

## Rollback

If the new deployment fails:

1. Stop the IIS website/application.
2. Restore the backed-up deployed folder.
3. Confirm configuration is still present.
4. Start the website/application.
5. Re-run the smoke-test endpoints.
