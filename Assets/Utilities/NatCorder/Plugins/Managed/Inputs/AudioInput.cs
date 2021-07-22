/* 
*   NatCorder
*   Copyright (c) 2019 Yusuf Olokoba
*/

namespace NatCorder.Inputs {

    using UnityEngine;
    using System;
    using Clocks;
    using Internal;

    /// <summary>
    /// Recorder input for recording audio frames from an `AudioListener` or `AudioSource`
    /// </summary>
    [Doc(@"AudioInput")]
    public sealed class AudioInput : IDisposable {

        #region --Client API--
        /// <summary>
        /// Create an audio recording input from a scene's AudioListener
        /// </summary>
        /// <param name="mediaRecorder">Media recorder to receive committed frames</param>
        /// <param name="clock">Clock for generating timestamps</param>
        /// <param name="audioListener">Audio listener for the current scene</param>
        [Doc(@"AudioInputCtorListener")]
        public AudioInput (IMediaRecorder mediaRecorder, IClock clock, AudioListener audioListener) {
            this.mediaRecorder = mediaRecorder;
            this.clock = clock;
            this.attachment = audioListener.gameObject.AddComponent<AudioInputAttachment>();
            this.attachment.sampleBufferDelegate = OnSampleBuffer;
        }

        /// <summary>
        /// Create an audio recording input from an AudioSource
        /// </summary>
        /// <param name="mediaRecorder">Media recorder to receive committed frames</param>
        /// <param name="clock">Clock for generating timestamps</param>
        /// <param name="audioSource">Audio source to record</param>
        /// <param name="mute">Optional. Mute audio source after recording so that it is not heard in scene</param>
        [Doc(@"AudioInputCtorSource")]
        public AudioInput (IMediaRecorder mediaRecorder, IClock clock, AudioSource audioSource, bool mute = false) {
            this.mediaRecorder = mediaRecorder;
            this.clock = clock;
            this.attachment = audioSource.gameObject.AddComponent<AudioInputAttachment>();
            this.attachment.sampleBufferDelegate = OnSampleBuffer;
            this.mute = mute;
        }

        /// <summary>
        /// Stop recorder input and teardown resources
        /// </summary>
        [Doc(@"AudioInputDispose")]
        public void Dispose () {
            attachment.sampleBufferDelegate = null;
            AudioInputAttachment.Destroy(attachment);
        }
        #endregion


        #region --Operations--

        private readonly IMediaRecorder mediaRecorder;
        private readonly IClock clock;
        private readonly AudioInputAttachment attachment;
        private readonly bool mute;

        private void OnSampleBuffer (float[] data) {
            AndroidJNI.AttachCurrentThread();
            mediaRecorder.CommitSamples(data, clock.Timestamp);
            if (mute)
                Array.Clear(data, 0, data.Length);
        }

        private class AudioInputAttachment : MonoBehaviour {
            public Action<float[]> sampleBufferDelegate;
            private void OnAudioFilterRead (float[] data, int channels) { if (sampleBufferDelegate != null) sampleBufferDelegate(data); }
        }
        #endregion
    }
}