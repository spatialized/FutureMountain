/* 
*   NatCorder
*   Copyright (c) 2019 Yusuf Olokoba
*/

namespace NatCorder {

    using UnityEngine;
    using System;
    using System.IO;
    using Internal;

    /// <summary>
    /// HEVC video recorder.
    /// </summary>
    [Doc(@"HEVCRecorder")]
    public sealed class HEVCRecorder : IMediaRecorder {

        #region --Client API--
        /// <summary>
        /// Video width
        /// </summary>
        [Doc(@"PixelWidth")]
        public int pixelWidth {
            get { return recorder.pixelWidth; }
        }
        
        /// <summary>
        /// Video height
        /// </summary>
        [Doc(@"PixelHeight")]
        public int pixelHeight {
            get { return recorder.pixelHeight; }
        }

        /// <summary>
        /// Create a HEVC recorder
        /// </summary>
        /// <param name="width">Video width</param>
        /// <param name="height">Video height</param>
        /// <param name="framerate">Video framerate</param>
        /// <param name="sampleRate">Audio sample rate. Pass 0 for no audio.</param>
        /// <param name="channelCount">Audio channel count. Pass 0 for no audio.</param>
        /// <param name="recordingCallback">Recording callback</param>
        /// <param name="bitrate">Video bitrate in bits per second</param>
        /// <param name="keyframeInterval">Keyframe interval in seconds</param>
        [Doc(@"HEVCRecorderCtor")]
        public HEVCRecorder (int width, int height, float framerate, int sampleRate, int channelCount, Action<string> recordingCallback, int bitrate = (int)(960 * 540 * 11.4f), int keyframeInterval = 3) {
            var recordingDirectory = Application.persistentDataPath;
            var recordingName = string.Format("recording_{0}.mp4", DateTime.Now.ToString("yyyy_MM_dd_HH_mm_ss_fff"));
            switch (Application.platform) {
                case RuntimePlatform.OSXEditor:
                    recordingDirectory = Directory.GetCurrentDirectory();
                    goto case RuntimePlatform.OSXPlayer;
                case RuntimePlatform.WindowsEditor:
                    recordingDirectory = Directory.GetCurrentDirectory();
                    goto case RuntimePlatform.WindowsPlayer;
                case RuntimePlatform.OSXPlayer:
                case RuntimePlatform.WindowsPlayer:
                case RuntimePlatform.IPhonePlayer: {
                    var recordingPath = Path.Combine(recordingDirectory, recordingName);
                    var nativeRecorder = MediaRecorderBridge.CreateHEVCRecorder(width, height, framerate, bitrate, keyframeInterval, sampleRate, channelCount);
                    this.recorder = new MediaRecorderiOS(nativeRecorder, width, height, recordingPath, recordingCallback);
                    break;
                }
                case RuntimePlatform.Android: {
                    var recordingPath = Path.Combine(recordingDirectory, recordingName);
                    var nativeRecorder = new AndroidJavaObject(@"com.olokobayusuf.natcorder.HEVCRecorder", width, height, framerate, bitrate, keyframeInterval, sampleRate, channelCount);
                    this.recorder = new MediaRecorderAndroid(nativeRecorder, width, height, recordingPath, recordingCallback);
                    break;
                }
                default:
                    Debug.LogError("NatCorder Error: HEVCRecorder is not supported on this platform");
                    break;
            }
        }

        /// <summary>
        /// Stop recording and dispose the recorder.
        /// The recording callback is expected to be invoked soon after calling this method.
        /// </summary>
        [Doc(@"Dispose", @"DisposeDiscussion")]
        public void Dispose () {
            recorder.Dispose();
        }

        /// <summary>
        /// Commit a video pixel buffer for encoding.
        /// The pixel buffer MUST have RGBA32 pixel layout.
        /// </summary>
        /// <param name="pixelBuffer">Pixel buffer containing video frame to commit</param>
        /// <param name="timestamp">Frame timestamp in nanoseconds</param>
        [Doc(@"CommitFrame", @"CommitFrameDiscussion"), Code(@"RecordWebCam")]
        public void CommitFrame<T> (T[] pixelBuffer, long timestamp) where T : struct {
            recorder.CommitFrame(pixelBuffer, timestamp);
        }

        /// <summary>
        /// Commit a video pixel buffer for encoding.
        /// The pixel buffer MUST have RGBA32 pixel layout.
        /// </summary>
        /// <param name="nativeBuffer">Pixel buffer in native memory to commit</param>
        /// <param name="timestamp">Frame timestamp in nanoseconds</param>
        [Doc(@"CommitFrame", @"CommitFrameDiscussion")]
        public void CommitFrame (IntPtr nativeBuffer, long timestamp) {
            recorder.CommitFrame(nativeBuffer, timestamp);
        }

        /// <summary>
        /// Commit an audio sample buffer for encoding
        /// </summary>
        /// <param name="sampleBuffer">Raw PCM audio sample buffer, interleaved by channel</param>
        /// <param name="timestamp">Sample buffer timestamp in nanoseconds</param>
        [Doc(@"CommitSamples", @"CommitSamplesDiscussion"), Code(@"RecordPCM")]
        public void CommitSamples (float[] sampleBuffer, long timestamp) {
            recorder.CommitSamples(sampleBuffer, timestamp);
        }
        #endregion

        private readonly IMediaRecorder recorder;
    }
}