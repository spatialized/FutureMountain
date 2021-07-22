# NatCorder API
NatCorder is a lightweight, easy-to-use, native video recording API for iOS, Android, macOS, and Windows. NatCorder comes with a rich featureset including:
+ Record any texture, anything that can be rendered into a texture, or any pixel data.
+ Record to MP4 videos and animated GIF images.
+ Control recording quality and file size with bitrate and keyframe interval.
+ Record at any resolution. You get to specify what resolution recording you want.
+ Get path to recorded video in device storage.
+ Record game audio with video.
+ Experimental support for recording on WebGL.
+ Experimental support for recording HEVC videos.

## Fundamentals of Recording
NatCorder provides a simple recording API with instances of the `IMediaRecorder` interface. **NatCorder works by encoding video and audio frames on demand**. To start recording, simply create a recorder corresponding to the media type you want to record:
```csharp
var gifRecorder = new GIFRecorder(...);
var videoRecorder = new MP4Recorder(...);
var hevcRecorder = new HEVCRecorder(...);
```

Once you create a recorder, you then commit frames to it. You can commit video and audio frames to these recorders. These committed frames are then encoded into a media file. When committing frames, you must provide the frame data with a corresponding timestamp. The spacing between timestamps determine the final frame rate of the recording.

### Committing Video Frames
NatCorder records video using pixel buffers. The pixel buffers must be 32-bit per pixel, RGBA encoding (`TextureFormat.RGBA32`). The managed type of the pixel buffer is entirely flexible. As a result, you can commit a `Color32[]`, a `byte[]`, an `int[]`, or any struct array that can be interpreted as an RGBA32 pixel buffer.

When committing a pixel buffer for encoding, you will need to provide a corresponding timestamp. For this purpose, you can use implementations of the `IClock` interface. Here is an example illustrating recording a `WebCamTexture`:
```csharp
WebCamTexture webcamTexture;
IMediaRecorder mediaRecorder;
IClock clock;

void StartRecording () {
    // Start the webcam texture
    webcamTexture = new WebCamTexture(...);
    webcamTexture.Play();
    // Start recording
    clock = new RealtimeClock();
    mediaRecorder = new MP4Recorder(...) or GIFRecorder(...) or HEVCRecorder(...);
}

void Update () {
    // Check that we are recording
    if (webcamTexture.didUpdateThisFrame)
        if (mediaRecorder != null)
            mediaRecorder.CommitFrame(webcamTexture.GetPixels32(), clock.Timestamp);  // Commit the frame to the recorder
}

void StopRecording () {
    // Stop recording
    mediaRecorder.Dispose();
    mediaRecorder = null;
}
```

### Committing Audio Frames
NatCorder records audio provided as interleaved PCM sample buffers (`float[]`). Similar to recording video frames, you will call the `IMediaRecorder.CommitSamples` method, passing in a sample buffer and a corresponding timestamp. It is important that the timestamps synchronize with those of video, so it is recommended to use the same `IClock` for generating video and audio timestamps. Below is an example illustrating recording game audio using Unity's `OnAudioFilterRead` callback:
```csharp
void OnAudioFilterRead (float[] data, int channels) {
    // Check that we are recording
    if (mediaRecorder != null)
        // Commit the audio frame
        mediaRecorder.CommitSamples(data, clock.Timestamp);
}
```

## Easier Recording with Recorder Inputs
In most cases, you will likely just want to record a game camera optionally with game audio. To do so, you can use NatCorder's recorder `Inputs`. A recorder `Input` is a lightweight utility class that eases out the process of recording some aspect of a Unity application. NatCorder comes with two recorder inputs: `CameraInput` and `AudioInput`. You can create your own recorder inputs to do more interesting things like add a watermark to the video, or retime the video. Here is a simple example showing recording a game camera:
```csharp
IClock recordingClock;
IMediaRecorder mediaRecorder;
CameraInput cameraInput;
AudioInput audioInput;

void StartRecording () {
    // Create a recording clock
    recordingClock = new RealtimeClock();
    // Start recording
    mediaRecorder = new ...;
    // Create a camera input to record the main camera
    cameraInput = new CameraInput(mediaRecorder, recordingClock, Camera.main);
    // Create an audio input to record the scene's AudioListener
    audioInput = new AudioInput(mediaRecorder, recordingClock, audioListener);
}

void StopRecording () {
    // Destroy the recording inputs
    cameraInput.Dispose();
    audioInput.Dispose();
    // Stop recording
    mediaRecorder.Dispose();
    mediaRecorder = null;
}
```

___

## Limitations of the WebGL Backend
The WebGL backend is currently experimental. As a result, it has a few limitations in its operations. Firstly, it is an 'immediate-encode' backend. This means that video frames are encoded immediately they are committed. As a result, there is no support for custom frame timing (the `timestamp` provided to `CommitFrame` is always ignored).

Secondly, because Unity does not support the `OnAudioFilterRead` callback on WebGL, we cannot record game audio on WebGL (using an `AudioSource` or `AudioListener`). This is a limitation of Unity's WebGL implementation. However, you can still record raw audio data using the `IMediaRecorder.CommitSamples` API.

The `MP4Recorder` may record videos with the VP8/9 codec or H.264 codec, depending on the browser and device. These videos are always recorded in the `webm` container format. The `GIFRecorder` is not supported on WebGL.

## Using NatCorder with NatCam
If you use NatCorder with our NatCam camera API, then you will have to remove a duplicate copy of the `NatRender.aar` library **from NatCam**. The library can be found at `NatCam > Plugins > Android > NatRender.aar`.

## Tutorials
- [Unity Recording Made Easy](https://medium.com/@olokobayusuf/natcorder-unity-recording-made-easy-f0fdee0b5055)
- [Audio Workflows](https://medium.com/@olokobayusuf/natcorder-tutorial-audio-workflows-1cfce15fb86a)

## Requirements
- Unity 2018.3+
- Android API Level 21+
- iOS 11+
- macOS 10.13+
- Windows 10+, 64-bit only
- WebGL:
    - Firefox 25+
    - Chrome 47+
    - Safari 27+

## Notes
- NatCorder doesn't support recording UI canvases that are in Screen Space - Overlay mode. See [here](https://forum.unity3d.com/threads/render-a-canvas-to-rendertexture.272754/#post-1804847).
- NatCorder requires the Metal graphics API on macOS and iOS, in the Editor and Standalone builds.
- When building for WebGL, make sure that 'Use Prebuild Engine' is disabled in Build Settings.
- When recording audio, make sure that the 'Bypass Listener Effects' and 'Bypass Effects' flags on your `AudioSource`s are turned off.
- If you face `DllNotFound` errors on standalone Windows builds, install the latest Visual C++ redistributable on the computer.
- Recording may fail when a dimension (width or height) is an odd number. Always make sure to record at even resolutions.

## Quick Tips
- Please peruse the included scripting reference [here](https://olokobayusuf.github.io/NatCorder-Docs/)
- To discuss or report an issue, visit Unity forums [here](https://forum.unity.com/threads/natcorder-video-recording-api.505146/)
- Contact me at [olokobayusuf@gmail.com](mailto:olokobayusuf@gmail.com)

Thank you very much!