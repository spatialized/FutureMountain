# Camera Animation

Last updated: 2026-06-16

## User Interface Behavior

Camera animation is used when the user focuses on a cube, exits a cube focus,
or enters Side-by-Side Mode. In normal simulation view, clicking the aggregate
cube or one of the five sample cubes starts a predefined camera zoom toward that
cube. While zoomed in, the zoom-out button is shown unless the experience is in
Side-by-Side Mode.

The user can also enable fly-camera mode. Fly mode disables the Animator-driven
camera path and lets the user move the camera manually with mouse and keyboard
input. Turning fly mode off re-enables the Animator and starts the normal reset
zoom flow.

Keyboard shortcuts still exist for development/testing:

- `A`: zoom to aggregate cube.
- `F`, `E`, `D`, `C`, `B`: zoom to sample cubes 1 through 5.
- `Space`: reset zoom when already zoomed.
- Fly mode uses mouse look plus `W`, `A`, `S`, `D`, `Q`, `E`, Shift, and Control
  for movement speed and vertical movement.

## Technical Behavior

`CameraController` is attached to the scene camera and drives the camera
Animator. At startup it:

1. Gets the camera `Animator`.
2. Enables the Animator.
3. Reads `moveLength` from the first clip in the runtime animator controller.
4. Asserts that the zoom-out button and Side-by-Side toggle objects are
   assigned.

The controller uses three main runtime state flags:

- `moving`: prevents overlapping camera animations.
- `zoomed`: records whether the camera is currently in a focused position.
- `fly`: switches between Animator-driven camera motion and manual fly-camera
  input.

`pauseState` is a small handoff enum read by `GameController.RunGame()`. Camera
animations set it to `pause` before triggering movement and to `unpause` after
the animation coroutine waits for `moveLength`.

## Animation Triggers

Normal zoom triggers:

- `ZoomAggregateCube`
- `ZoomCube1`
- `ZoomCube2`
- `ZoomCube3`
- `ZoomCube4`
- `ZoomCube5`

Side-by-Side zoom triggers:

- `SBS_Cube0` for the aggregate cube.
- `SBS_Cube1` through `SBS_Cube5` for sample cubes.

Reset trigger:

- `ResetZoom`

Idle state:

- `ResetPosition()` directly plays `Idle`.

## Cube Click Flow

`GetMouseInput()` raycasts from the main camera on left click. If the hit object
has tag `AggregateCube`, it calls:

```text
StartZoomIntoCube(-1)
```

For other tagged cube objects, it reads the final character of the tag, converts
it into a zero-based cube index, and calls:

```text
StartZoomIntoCube(idx)
```

`StartZoomIntoCube(cubeIdx)` disables the Side-by-Side toggle, hides the model
data layer, chooses the appropriate trigger, pauses simulation time through
`pauseState`, starts the Animator trigger, and launches `ZoomingIn()`.

If the Side-by-Side toggle is armed and the app is not already in
Side-by-Side Mode, the same method calls `GameController.EnterSideBySideMode()`
before triggering the `SBS_Cube*` animation.

## Reset Flow

`StartResetZoom()` restores normal UI state, pauses simulation time, triggers
`ResetZoom`, and launches `ZoomingOut()`. After the wait, `ZoomingOut()` clears
`moving`, sets `zoomed = false`, and requests unpause.

`GameController.ResetCameraZoom()` also uses `CameraController.ResetPosition()`
to force the Animator back to `Idle` during broader app resets.

## Fly Camera

`SetCameraFlyMode(true)` saves the current transform, copies current Euler
rotation into the fly-camera rotation fields, disables the Animator, and leaves
the camera in place for manual control.

`SetCameraFlyMode(false)` re-enables the Animator, hides the zoom-out button,
restores the Side-by-Side toggle, and calls `StartResetZoom()`.

Manual fly-camera rotation is clamped to:

- X rotation: `0` to `180`.
- Y rotation: `100` to `240`.

## Key Objects And Scripts

- `CameraController`: input handling, Animator triggers, fly-camera mode, and
  pause/unpause handoff.
- `GameController`: reads `CameraController.pauseState`, controls UI visibility,
  enters/exits Side-by-Side Mode, and performs full camera resets.
- Camera Animator Controller: owns the named animation clips and transitions.
- Scene cube tags: `AggregateCube` and numbered cube tags used to infer cube
  identity.

## Current Constraints

- Camera animation assumes one aggregate cube plus five sample cubes.
- Trigger names are hard-coded in `CameraController` and must match the camera
  Animator Controller exactly.
- `moveLength` is taken from the first animation clip, based on the assumption
  that all camera animation clips have the same length.
- Cube identity is inferred from tag names rather than scenario data.
- Click-to-reset while zoomed is disabled; reset is currently through UI or
  keyboard path.
- Fly-camera rotation limits are hard-coded for the current scene framing.
