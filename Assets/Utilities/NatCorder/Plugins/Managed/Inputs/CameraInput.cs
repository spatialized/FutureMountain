/* 
*   NatCorder
*   Copyright (c) 2019 Yusuf Olokoba
*/

namespace NatCorder.Inputs {

    using UnityEngine;
    using System;
    using System.Collections;
    using Clocks;
    using Internal;

    /// <summary>
    /// Recorder input for recording video frames from one or more game cameras
    /// </summary>
    [Doc(@"CameraInput")]
    public sealed class CameraInput : IDisposable {

        #region --Client API--
        /// <summary>
        /// Control number of successive camera frames to skip while recording.
        /// This is very useful for GIF recording, which typically has a lower framerate appearance
        /// </summary>
        [Doc(@"CameraInputFrameSkip", @"CameraInputFrameSkipDiscussion")]
        public int frameSkip;

        /// <summary>
        /// Create a video recording input from a game camera
        /// </summary>
        /// <param name="mediaRecorder">Media recorder to receive committed frames</param>
        /// <param name="clock">Clock for generating timestamps</param>
        /// <param name="cameras">Game cameras to record</param>
        [Doc(@"CameraInputCtor")]
        public CameraInput (IMediaRecorder mediaRecorder, IClock clock, params Camera[] cameras) {
            // Sort cameras by depth
            Array.Sort(cameras, (a, b) => (int)(10 * (a.depth - b.depth)));
            // Save state
            this.mediaRecorder = mediaRecorder;
            this.clock = clock;
            this.cameras = cameras;
            // Create framebuffer
            var frameDescriptor = new RenderTextureDescriptor(mediaRecorder.pixelWidth, mediaRecorder.pixelHeight, RenderTextureFormat.ARGB32, 24);
            frameDescriptor.sRGB = true;
            this.framebuffer = ReadableTexture.ToReadable(RenderTexture.GetTemporary(frameDescriptor));
            // Start recording
            this.frameHelper = cameras[0].gameObject.AddComponent<CameraInputAttachment>();
            frameHelper.StartCoroutine(OnFrame());            
        }

        /// <summary>
        /// Stop recorder input and teardown resources
        /// </summary>
        [Doc(@"AudioInputDispose")]
        public void Dispose () {
            CameraInputAttachment.Destroy(frameHelper);
            RenderTexture.ReleaseTemporary(framebuffer);
            framebuffer.Dispose();
        }
        #endregion


        #region --Operations--

        private readonly IMediaRecorder mediaRecorder;
        private readonly IClock clock;
        private readonly Camera[] cameras;
        private readonly ReadableTexture framebuffer;
        private readonly CameraInputAttachment frameHelper;
        private int frameCount;

        private IEnumerator OnFrame () {
            var yielder = new WaitForEndOfFrame();
            for (;;) {
                // Check frame index
                yield return yielder;
                var recordFrame = frameCount++ % (frameSkip + 1) == 0;
                if (recordFrame) {
                    // Render every camera
                    for (var i = 0; i < cameras.Length; i++) {
                        var prevActive = RenderTexture.active;
                        var prevTarget = cameras[i].targetTexture;
                        cameras[i].targetTexture = framebuffer;
                        cameras[i].Render();
                        cameras[i].targetTexture = prevTarget;
                        RenderTexture.active = prevActive;
                    }
                    // Commit frame
                    var timestamp = clock.Timestamp;
                    framebuffer.Readback(pixelBuffer => mediaRecorder.CommitFrame(pixelBuffer, timestamp));
                }
            }
        }

        private sealed class CameraInputAttachment : MonoBehaviour { }
        #endregion
    }
}