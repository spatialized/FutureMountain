# Future Mountain API Configuration

Last updated: 2026-06-16

## Connection Strings

The API uses ASP.NET Core configuration and named connection strings.

Required keys:

| Key | Used by |
| --- | --- |
| `BigCreekDbContext` | Legacy Big Creek controllers and startup server-version detection |
| `CentralCoastDbContext` | Central Coast prototype controllers |

`BigCreekDbContext` must be non-empty or startup throws. `CentralCoastDbContext`
is registered only when configured, but Central Coast routes require it.

## Hosting

`Program.cs` currently configures Kestrel with:

```text
http://*:13198
```

IIS fronts the public `https://data.futuremtn.org/api/` site/application.

## CORS

The current CORS policy allows:

- any origin
- any header
- any method

This supports WebGL/API access but should be revisited if the API becomes
publicly broader than the Future Mountain runtime.

## Swagger

Swagger services are registered, but Swagger UI is enabled only when the app
environment is development.

## Current Cleanup Notes

- Some old SQL Server package references and comments remain.
- `WeatherForecastController` remains from the ASP.NET template and is not part
  of the Unity runtime API.
- Production credentials must not be committed to source control.
