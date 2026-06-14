# Future Mountain API

The API project is stored at `Services/FutureMountainApi/`. It was moved from
the former standalone `FutureMountainAPI` repository with `git subtree` to
preserve project history.

The imported history was sanitized before import:

- `appsettings.json` and `appsettings.Development.json` entries containing
  database credentials were removed from historical commits.
- Hardcoded connection-string credentials in historical source files were
  redacted.
- The current API startup code reads `ConnectionStrings:CubeDataDbContext`
  from configuration instead of using a checked-in connection string.

Use a local configuration source for the connection string, such as .NET user
secrets, environment variables, or an ignored `appsettings.Development.json`.
