# FutureMountain
Interactive 3D data visualization of fire effects on climate, water and soil in watersheds

## Services

The Future Mountain API now lives in `Services/FutureMountainApi/`. It was
imported from the former standalone `FutureMountainAPI` repository with
`git subtree` so the API history is preserved in this repository.

Before the import, credential-bearing configuration and hardcoded connection
strings were removed from the imported history. Configure the API connection
string outside source control, for example with user secrets, environment
variables, or a local ignored `appsettings.Development.json`.
