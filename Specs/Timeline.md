# Timeline Spec

Last updated: 2026-06-12

## User Interface Behavior

The timeline is visible during the simulation and works in both Normal Mode and Side-by-Side Mode. It shows annual precipitation as a bar graph, displays the current simulation date, and includes icon rows for fire years and message years.

User interactions:

- Hovering over timeline bars changes bar highlighting.
- Clicking a timeline bar jumps the simulation to that year.
- Clicking a fire icon jumps to the fire year.
- Clicking a message icon jumps to the message year.

The timeline does not currently jump to the exact day of a message or fire icon. It sets the simulation to January 1 of the selected year through `GameController.SetTimePosition()`.

## Technical Behavior

`TimelineControl` creates and updates the timeline. It stores a `clickedID` year offset that `GameController.RunGame()` reads and consumes.

Timeline creation paths:

- `CreateTimeline(...)`: non-web/local path, using formatted `WaterDataYear` objects.
- `CreateTimelineWeb(...)`: web path, using `PrecipByYear[]` from `waterdata/total`.
- `CreateTestTimeline(...)`: fallback/test path when landscape simulation is off.

For web builds:

1. `GameController.GetTimelineWaterDataFromWeb()` calls `WebManager.GetTimelineWaterData()`.
2. `SetTimelineWaterData()` deserializes the response into `TimelineWaterData`.
3. `TimelineControl.CreateTimelineWeb()` instantiates bars and icons.

Each year is represented by a `graphBarPrefab` named `Point_{index}`. Fire icons are named `Fire_{year}`. Message icons are named `Message_{year}_{warmingDegrees}`.

## Data Display

Annual precipitation determines bar height. In the web path, `CreateTimelineWeb()` currently uses a hard-coded max precipitation of `2582f`, with a comment noting that this should come from the API.

Fire and message years are passed in from `GameController`:

- `fireYears` comes from scheduled fire dates.
- `messageYears` comes from loaded message files filtered by active warming degrees.

## Mode Interaction

Timeline time is global. In Normal Mode, a timeline jump updates the main landscape, aggregate cube, and visible cubes. In Side-by-Side Mode, the same global `timeIdx` is used for both comparison cubes, preserving same-time comparison while warming levels can differ.

## Key Objects And Scripts

- `TimelineControl`: graph creation, icon creation, hover/click handling, current-year highlighting.
- `GameController`: reads `clickedID`, converts selected year to `timeIdx`, updates landscape and cubes.
- `WebManager`: fetches web precipitation totals.
- `TimelineWaterData` and `PrecipByYear`: web timeline DTOs.

## Current Constraints

- Web max precipitation is hard-coded.
- Timeline click resolution is year-level.
- Icon naming encodes year and warming degrees.
- Message icon lookup uses the message manager and active warming degree conventions.

