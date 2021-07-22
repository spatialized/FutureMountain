/* 
*   NatCorder
*   Copyright (c) 2019 Yusuf Olokoba
*/

namespace NatCorder.Internal {

    using UnityEngine;
    using UnityEngine.Scripting;
    using System;
    using System.Runtime.InteropServices;

    public sealed class MediaRecorderAndroid : AndroidJavaProxy, IMediaRecorder {
        
        #region --IMediaRecorder--

        public int pixelWidth { get; private set; }

        public int pixelHeight { get; private set; }

        public MediaRecorderAndroid (AndroidJavaObject recorder, int width, int height, string recordingPath, Action<string> callback) : base(@"com.olokobayusuf.natcorder.MediaRecorder$Callback") {
            this.recorder = recorder;
            this.pixelWidth = width;
            this.pixelHeight = height;
            this.callback = callback;
            // Start recording
            recorder.Call(@"startRecording", recordingPath, this);
            // Create commit pixel buffer
            using (var ByteBuffer = new AndroidJavaClass(@"java.nio.ByteBuffer"))
                using (var ByteOrder = new AndroidJavaClass(@"java.nio.ByteOrder"))
                    using (var nativeOrder = ByteOrder.CallStatic<AndroidJavaObject>(@"nativeOrder"))
                        using (var pixelBuffer = ByteBuffer.CallStatic<AndroidJavaObject>(@"allocateDirect", width * height * 4))
                            this.nativeBuffer = pixelBuffer.Call<AndroidJavaObject>(@"order", nativeOrder);
            Unmanaged = new AndroidJavaClass(@"com.olokobayusuf.natrender.Unmanaged");
        }

        public void Dispose () {
            recorder.Call(@"stopRecording");
            recorder.Dispose();
            nativeBuffer.Dispose();
            Unmanaged.Dispose();
        }
        
        public void CommitFrame<T> (T[] pixelBuffer, long timestamp) where T : struct {
            var bufferHandle = GCHandle.Alloc(pixelBuffer, GCHandleType.Pinned);
            CommitFrame(bufferHandle.AddrOfPinnedObject(), timestamp);
            bufferHandle.Free();            
        }

        public void CommitFrame (IntPtr pixelBuffer, long timestamp) {
            Unmanaged.CallStatic(
                @"copyFrame",
                pixelBuffer.ToInt64(),
                pixelWidth,
                pixelHeight,
                pixelWidth * 4,
                Unmanaged.CallStatic<long>(@"baseAddress", nativeBuffer)
            );
            using (var clearedBuffer = nativeBuffer.Call<AndroidJavaObject>("clear"))
                recorder.Call(@"encodeFrame", clearedBuffer, timestamp);
        }

        public void CommitSamples (float[] sampleBuffer, long timestamp) {
            recorder.Call(@"encodeSamples", sampleBuffer, timestamp);
        }
        #endregion


        #region --Operations--

        public readonly AndroidJavaObject recorder; // Used by RenderTextureInput to sidestep readback
        private readonly Action<string> callback;
        private readonly AndroidJavaObject nativeBuffer;
        private readonly AndroidJavaClass Unmanaged;

        [Preserve]
        private void onRecording (string path) {
            callback(path);
        }
        #endregion
    }
}