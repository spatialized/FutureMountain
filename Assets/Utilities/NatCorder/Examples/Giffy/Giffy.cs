/* 
*   NatCorder
*   Copyright (c) 2019 Yusuf Olokoba
*/

namespace NatCorder.Examples {

    #if UNITY_EDITOR
	using UnityEditor;
	#endif
    using UnityEngine;
    using Clocks;
    using Inputs;

    public class Giffy : MonoBehaviour {
        
        [Header("GIF Settings")]
        public int imageWidth = 640;
        public int imageHeight = 480;
        public float frameDuration = 0.1f; // seconds

        private GIFRecorder gifRecorder;
        private CameraInput cameraInput;

        public void StartRecording () {
            // Start recording
            gifRecorder = new GIFRecorder(imageWidth, imageHeight, frameDuration, OnGIF);
            // Create a camera input
            cameraInput = new CameraInput(gifRecorder, new RealtimeClock(), Camera.main);
            // Get a real GIF look by skipping frames
            cameraInput.frameSkip = 4;
        }

        public void StopRecording () {
            // Stop the recording
            cameraInput.Dispose();
            gifRecorder.Dispose();
        }

        private void OnGIF (string path) {
            Debug.Log("Saved recording to: "+path);
            // Playback the video
            #if UNITY_EDITOR
            EditorUtility.OpenWithDefaultApp(path);
            #elif UNITY_IOS
            Application.OpenURL("file://" + path);
            #elif UNITY_ANDROID
            Application.OpenURL(path);
            #endif
        }
    }
}