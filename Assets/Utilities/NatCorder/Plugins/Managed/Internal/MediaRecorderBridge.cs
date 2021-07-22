/* 
*   NatCorder
*   Copyright (c) 2019 Yusuf Olokoba
*/

namespace NatCorder.Internal {

    using System;
    using System.Runtime.InteropServices;

    public static class MediaRecorderBridge {

        private const string Assembly =
        #if (UNITY_IOS || UNITY_WEBGL) && !UNITY_EDITOR
        @"__Internal";
        #else
        @"NatCorder";
        #endif

        private const UnmanagedType StringType =
        #if UNITY_EDITOR_WIN || UNITY_STANDALONE_WIN
        UnmanagedType.LPWStr;
        #else
        UnmanagedType.LPStr;
        #endif

        #if UNITY_EDITOR || UNITY_IOS || UNITY_STANDALONE || UNITY_WEBGL
        [DllImport(Assembly, EntryPoint = @"NCCreateMP4Recorder")]
        public static extern IntPtr CreateMP4Recorder (int width, int height, float framerate, int bitrate, int keyframeInterval, int sampleRate, int channelCount);
        [DllImport(Assembly, EntryPoint = @"NCCreateHEVCRecorder")]
        public static extern IntPtr CreateHEVCRecorder (int width, int height, float framerate, int bitrate, int keyframeInterval, int sampleRate, int channelCount);
        [DllImport(Assembly, EntryPoint = @"NCCreateGIFRecorder")]
        public static extern IntPtr CreateGIFRecorder (int width, int height, float frameDuration);
        [DllImport(Assembly, EntryPoint = @"NCStartRecording")]
        public static extern void StartRecording (this IntPtr recorder, [MarshalAs(StringType)] string recordingDirectory, Action<IntPtr, IntPtr> callback, IntPtr context);
        [DllImport(Assembly, EntryPoint = @"NCStopRecording")]
        public static extern void StopRecording (this IntPtr recorder);
        [DllImport(Assembly, EntryPoint = @"NCEncodeFrame")]
        public static extern void EncodeFrame (this IntPtr recorder, IntPtr pixelBuffer, long timestamp);
        [DllImport(Assembly, EntryPoint = @"NCEncodeSamples")]
        public static extern void EncodeSamples (this IntPtr recorder, float[] sampleBuffer, int sampleCount, long timestamp);
        #else
        public static IntPtr CreateMP4Recorder (int width, int height, float framerate, int bitrate, int keyframeInterval, int sampleRate, int channelCount) { return IntPtr.Zero; }
        public static IntPtr CreateHEVCRecorder (int width, int height, float framerate, int bitrate, int keyframeInterval, int sampleRate, int channelCount) { return IntPtr.Zero; }
        public static IntPtr CreateGIFRecorder (int width, int height, float frameDuration) { return IntPtr.Zero; }
        public static void StartRecording (this IntPtr recorder, string recordingDirectory, Action<IntPtr, IntPtr> callback, IntPtr context) {}
        public static void StopRecording (this IntPtr recorder) {}
        public static void EncodeFrame (this IntPtr recorder, IntPtr pixelBuffer, long timestamp) {}
        public static void EncodeSamples (this IntPtr recorder, float[] sampleBuffer, int sampleCount, long timestamp) {}
        #endif
    }
}