# Messages Spec

Last updated: 2026-06-12

## User Interface Behavior

Messages are short narrative or explanatory text boxes that appear during simulation when the current date and warming level match configured message records. They can also highlight cube labels when not in Side-by-Side Mode.

There are two message categories:

- General story/model messages.
- Fire messages.

Messages can be shown or hidden through story/message controls. The timeline can also show message icons at years where messages exist.

## Technical Behavior

`GameController` references two `TextAsset` fields:

- `messagesFile`
- `fireMessagesFile`

During `FinishStarting()`, it calls `LoadMessagesFile(file, fire)` for each file and passes the parsed message lists into `UI_MessageManager.Initialize()`.

Message file record format is currently parsed as:

1. Header line with date, warming values, and cube indices.
2. Message text line.
3. Blank/separator line.

Example shape:

```text
1969-07-15 0C,6C 2
Message text goes here.

```

The loader parses:

- Date as `year-month-day`.
- Warming list as values ending in `C`.
- Cube list as comma-separated integer indices.
- Message text as the next line.

It converts the date to `timeIdx` using `GetTimeIdxForDay()`.

## Runtime Display

`UI_MessageManager.UpdateSimulation(...)` checks both general messages and fire messages during each simulation update. A message appears if:

- Its date/time window applies.
- Its warming list includes the current warming degrees.
- It is not already displayed.
- There is an available message box.

The message panel has four message boxes: `MessageBox1` through `MessageBox4`. Text is displayed through TextMeshProUGUI child objects.

When not in Side-by-Side Mode, message cube indices can show associated cube labels. Labels are hidden again when the message hides.

## Timeline Integration

`GameController` builds `messageYears` from loaded messages whose warming degrees apply. `TimelineControl` displays message icons for those years. Clicking a message icon jumps to that year.

## Current Constraints

- Message format is custom plain text and positional.
- Warming matching uses degrees, while some method/field names still say index.
- Timeline click jumps to the message year, not exact message date.
- Cube labels are suppressed in Side-by-Side Mode.
- Future scenarios should move message content into scenario-specific files with documented format validation.

