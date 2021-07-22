/* 
*   NatCorder
*   Copyright (c) 2019 Yusuf Olokoba
*/

namespace NatCorder.Examples {

    using UnityEngine;
    using UnityEngine.UI;
    using System.Collections;
    using Clocks;

    public class WebCam : MonoBehaviour {

        public RawImage rawImage;
        public AspectRatioFitter aspectFitter;

        private WebCamTexture webcamTexture;
        private MP4Recorder videoRecorder;
        private IClock clock;
        private Color32[] pixelBuffer;

        public void StartRecording () {
            // Start recording
            clock = new RealtimeClock();
            videoRecorder = new MP4Recorder(webcamTexture.width, webcamTexture.height, 30, 0, 0, OnRecording);
            pixelBuffer = webcamTexture.GetPixels32();
        }

        public void StopRecording () {
            // Stop recording
            videoRecorder.Dispose();
            videoRecorder = null;
            pixelBuffer = null;
        }

        IEnumerator Start () {
            // Request microphone and camera
            yield return Application.RequestUserAuthorization(UserAuthorization.WebCam | UserAuthorization.Microphone);
            if (!Application.HasUserAuthorization(UserAuthorization.WebCam | UserAuthorization.Microphone)) yield break;
            // Start the WebCamTexture
            webcamTexture = new WebCamTexture(1280, 720, 30);
            webcamTexture.Play();
            // Display webcam
            yield return new WaitUntil(() => webcamTexture.width != 16 && webcamTexture.height != 16); // Workaround for weird bug on macOS
            rawImage.texture = webcamTexture;
            aspectFitter.aspectRatio = (float)webcamTexture.width / webcamTexture.height;
        }

        void Update () {
            // Record frames
            if (videoRecorder != null && webcamTexture.didUpdateThisFrame) {
                webcamTexture.GetPixels32(pixelBuffer);
                videoRecorder.CommitFrame(pixelBuffer, clock.Timestamp);
            }
        }

        void OnRecording (string path) {
            Debug.Log("Saved recording to: "+path);
            // Playback the video
            #if UNITY_IOS
            Handheld.PlayFullScreenMovie("file://" + path);
            #elif UNITY_ANDROID
            Handheld.PlayFullScreenMovie(path);
            #endif
        }
    }
}