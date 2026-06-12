# Lighting Spec

Last updated: 2026-06-12

## User Interface Behavior

Lighting changes as simulation time advances. The sun angle and intensity shift seasonally, giving a visual cue for time of year. This is especially important because users can accelerate time or jump through the timeline.

There is no direct user-facing sun control in the current version. Lighting is tied to simulation date.

## Technical Behavior

Lighting is controlled by `GameController`.

Key fields:

- `sunLight`: directional light.
- `summerLightIntensity = 1.525f`
- `winterLightIntensity = 1.3f`
- `summerAltitudeAngle = 71.35f`
- `summerAzimuthAngle = 132.65f`
- `winterAltitudeAngle = 29.48f`
- `winterAzimuthAngle = 181.19f`

The code comments note that these angles came from SunCalc. They are treated as representative seasonal solar positions.

## Seasonal Transition

`InitSunTransition()` sets the starting transition direction based on the simulation start month/day and the solstices:

- June 21: summer reference.
- December 21: winter reference.

`UpdateSunTransition()` computes the current day of year, decides whether the simulation is moving from summer to winter or winter to summer, then linearly interpolates:

- Altitude angle.
- Azimuth angle.
- Light intensity.

The final light transform is:

```text
sunLight.transform.localEulerAngles = (altitude, azimuth, existingZ)
```

The code adds `180f` to azimuth when applying the orientation, then wraps if it exceeds 360 degrees.

## Runtime Update

`RunGame()` calls `UpdateLighting()` during simulation updates and also between simulation frames when seasons are displayed. This keeps lighting visually moving even when the simulation timestep is not advancing every rendered frame.

## Current Constraints

- Angles are hard-coded for the Big Creek experience.
- Seasonal interpolation is based on solstice endpoints, not full astronomical recalculation per date/location.
- Future scenarios should decide whether to keep this stylized seasonal lighting or compute location-specific sun paths from scenario latitude/longitude.

