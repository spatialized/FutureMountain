/* 
*   NatCorder
*   Copyright (c) 2019 Yusuf Olokoba
*/

namespace NatCorder {

    using UnityEngine;
    using System;
    using System.Collections;
    using System.Collections.Generic;
    using System.IO;
    using System.Runtime.InteropServices;
    using System.Threading;
    using Internal;

    /// <summary>
    /// JPG image sequence recorder.
    /// This recorder is currently supported on macOS and Windows.
    /// </summary>
    [Doc(@"JPGRecorder")]
    public sealed class JPGRecorder : IMediaRecorder {

        #region --Client API--
        /// <summary>
        /// Image width
        /// </summary>
        [Doc(@"PixelWidth")]
        public int pixelWidth {
            get { return framebuffer.width; }
        }

        /// <summary>
        /// Image height
        /// </summary>
        [Doc(@"PixelHeight")]
        public int pixelHeight {
            get { return framebuffer.height; }
        }

        /// <summary>
        /// Create a JPG recorder
        /// </summary>
        /// <param name="imageWidth">Image width</param>
        /// <param name="imageHeight">Image height</param>
        /// <param name="recordingCallback">Recording callback</param>
        [Doc(@"JPGRecorderCtor")]
        public JPGRecorder (int imageWidth, int imageHeight, Action<string> recordingCallback) {
            // Create buffers
            this.framebuffer = new Texture2D(imageWidth, imageHeight, TextureFormat.RGBA32, false, false);
            this.writeQueue = new Queue<byte[]>();
            // Setup output
            var isEditor = Application.platform == RuntimePlatform.OSXEditor || Application.platform == RuntimePlatform.WindowsEditor;
            var baseDirectory = isEditor ? Directory.GetCurrentDirectory() : Application.persistentDataPath;
            var recordingName = string.Format("recording_{0}", DateTime.Now.ToString("yyyy_MM_dd_HH_mm_ss_fff"));
            var recordingDirectory = Path.Combine(baseDirectory, recordingName);
            Directory.CreateDirectory(recordingDirectory);
            // Start writer thread
            var callbackDispatcher = new MainDispatcher();
            this.writerThread = new Thread(() => {
                // Loop
                var frameIndex = 0;
                for (;;) {
                    // Dequeue frame
                    byte[] frameData;
                    lock ((writeQueue as ICollection).SyncRoot)
                        if (writeQueue.Count > 0)
                            frameData = writeQueue.Dequeue();
                        else
                            continue;
                    // Write
                    if (frameData != null)
                        File.WriteAllBytes(Path.Combine(recordingDirectory, ++frameIndex + ".jpg"), frameData);
                    else
                        break;
                }
                // Invoke callback
                callbackDispatcher.Dispatch(() => recordingCallback(recordingDirectory));
                callbackDispatcher.Dispose();
            });
            writerThread.Start();
        }

        /// <summary>
        /// Stop recording and dispose the recorder.
        /// The recording callback is expected to be invoked soon after calling this method.
        /// </summary>
        [Doc(@"Dispose", @"DisposeDiscussion")]
        public void Dispose () {
            // Enqueue EOS
            lock ((writeQueue as ICollection).SyncRoot)
                writeQueue.Enqueue(null);
            // Destroy framebuffer
            Texture2D.Destroy(framebuffer);
        }

        /// <summary>
        /// Commit a video pixel buffer for encoding.
        /// The pixel buffer MUST have RGBA32 pixel layout.
        /// </summary>
        /// <param name="pixelBuffer">Pixel buffer containing video frame to commit</param>
        /// <param name="timestamp">Not used</param>
        [Doc(@"CommitFrame", @"CommitFrameDiscussion")]
        public void CommitFrame<T> (T[] pixelBuffer, long timestamp) where T : struct {
            var handle = GCHandle.Alloc(pixelBuffer, GCHandleType.Pinned);
            CommitFrame(handle.AddrOfPinnedObject(), timestamp);
            handle.Free();
        }

        /// <summary>
        /// Commit a video pixel buffer for encoding.
        /// The pixel buffer MUST have RGBA32 pixel layout.
        /// </summary>
        /// <param name="nativeBuffer">Pixel buffer in native memory to commit</param>
        /// <param name="timestamp">Not used</param>
        [Doc(@"CommitFrame", @"CommitFrameDiscussion")]
        public void CommitFrame (IntPtr nativeBuffer, long timestamp) {
            // Encode immediately
            framebuffer.LoadRawTextureData(nativeBuffer, framebuffer.width * framebuffer.height * 4);
            var frameData = framebuffer.EncodeToJPG();
            // Write out on a worker thread
            lock ((writeQueue as ICollection).SyncRoot)
                writeQueue.Enqueue(frameData);
        }

        /// <summary>
        /// This recorder does not support committing audio samples
        /// </summary>
        [Doc(@"CommitSamplesNotSupported")]
        public void CommitSamples (float[] sampleBuffer, long timestamp) { }
        #endregion


        #region --Operations--
        private readonly Texture2D framebuffer;
        private readonly Queue<byte[]> writeQueue;
        private readonly Thread writerThread;
        #endregion
    }
}