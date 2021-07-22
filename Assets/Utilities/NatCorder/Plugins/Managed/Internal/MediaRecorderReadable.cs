/* 
*   NatCorder
*   Copyright (c) 2019 Yusuf Olokoba
*/

namespace NatCorder.Internal {

    using UnityEngine;
    using UnityEngine.Rendering;
    using UnityEngine.Scripting;
    using System;
    using System.Runtime.InteropServices;
    using Readback;

    public abstract class ReadableTexture : IDisposable {

        protected ReadableTexture (RenderTexture reTex) {
            this.renderTexture = reTex;
        }

        public abstract void Dispose ();

        public abstract void Readback (Action<IntPtr> handler);

        public static implicit operator RenderTexture (ReadableTexture readable) {
            return readable.renderTexture;
        }

        public static ReadableTexture ToReadable (RenderTexture reTex) {
            // Check that we aren't on Vulkan
            if (Application.platform == RuntimePlatform.Android && SystemInfo.graphicsDeviceType == GraphicsDeviceType.Vulkan)
                Debug.LogError("NatCorder Error: NatCorder does not support Vulkan on Android");
            // Create readable
            if (Application.platform == RuntimePlatform.Android)
                return new GLESReadableTexture(reTex);
            else if (SystemInfo.supportsAsyncGPUReadback)
                return new AsyncReadableTexture(reTex);
            else
                return new SyncReadableTexture(reTex);
        }

        public readonly RenderTexture renderTexture;
    }

    namespace Readback {

        public sealed class SyncReadableTexture : ReadableTexture {

            public SyncReadableTexture (RenderTexture reTex) : base(reTex) {
                this.readbackBuffer = new Texture2D(reTex.width, reTex.height, TextureFormat.RGBA32, false, false);
                this.pixelBuffer = new byte[reTex.width * reTex.height * 4];
            }

            public override void Dispose () {
                Texture2D.Destroy(readbackBuffer);
            }

            public override void Readback (Action<IntPtr> handler) {
                // Readback
                RenderTexture.active = renderTexture;
                readbackBuffer.ReadPixels(new Rect(0, 0, renderTexture.width, renderTexture.height), 0, 0, false);
                readbackBuffer.GetRawTextureData<byte>().CopyTo(pixelBuffer);
                // Invoke handler
                var handle = GCHandle.Alloc(pixelBuffer, GCHandleType.Pinned);
                handler(handle.AddrOfPinnedObject());
                handle.Free();
            }

            private readonly Texture2D readbackBuffer;
            private readonly byte[] pixelBuffer;
        }

        public sealed class AsyncReadableTexture : ReadableTexture {

            public AsyncReadableTexture (RenderTexture reTex) : base(reTex) {
                this.pixelBuffer = new byte[reTex.width * reTex.height * 4];
            }

            public override void Dispose () {
                pixelBuffer = null;
            }

            public override void Readback (Action<IntPtr> handler) {
                AsyncGPUReadback.Request(renderTexture, 0, request => {
                    if (pixelBuffer == null)
                        return;
                    request.GetData<byte>().CopyTo(pixelBuffer);
                    var handle = GCHandle.Alloc(pixelBuffer, GCHandleType.Pinned);
                    handler(handle.AddrOfPinnedObject());
                    handle.Free();
                });
            }

            private byte[] pixelBuffer;
        }

        public sealed class GLESReadableTexture : ReadableTexture {

            public GLESReadableTexture (RenderTexture reTex) : base(reTex) {
                // Get texture ptr
                var _= reTex.colorBuffer;
                this.texturePtr = reTex.GetNativeTexturePtr();
                // Setup native resources
                this.Unmanaged = new AndroidJavaClass(@"com.olokobayusuf.natrender.Unmanaged");
                var callback = new Callback((context, nativeBuffer) => {
                    var handle = (GCHandle)(IntPtr)context;
                    var handler = handle.Target as Action<IntPtr>;
                    handle.Free();
                    var pixelBuffer = (IntPtr)Unmanaged.CallStatic<long>(@"baseAddress", nativeBuffer);
                    handler(pixelBuffer);
                });
                this.readback = new AndroidJavaObject(@"com.olokobayusuf.natcorder.readback.GLESReadback", reTex.width, reTex.height, callback);
                // Attach render thread to JNI
                using (var dispatcher = new RenderDispatcher())
                    dispatcher.Dispatch(() => AndroidJNI.AttachCurrentThread());
            }

            public override void Dispose () {
                Unmanaged.Dispose();
                readback.Call(@"release");
                readback.Dispose();
                readback = null;
            }

            public override void Readback (Action<IntPtr> handler) {
                GL.Flush();
                using (var dispatcher = new RenderDispatcher())
                    dispatcher.Dispatch(() => {
                        if (readback != null)
                            readback.Call(@"readback", texturePtr.ToInt32(), (long)(IntPtr)GCHandle.Alloc(handler, GCHandleType.Normal));
                    });
            }

            private readonly IntPtr texturePtr;
            private readonly AndroidJavaClass Unmanaged;
            private AndroidJavaObject readback;

            private class Callback : AndroidJavaProxy {
                private readonly Action<long, AndroidJavaObject> handler;
                public Callback (Action<long, AndroidJavaObject> handler) : base(@"com.olokobayusuf.natcorder.readback.GLESReadback$Callback") { this.handler = handler; }
                [Preserve] private void onReadback (long context, AndroidJavaObject nativeBuffer) { handler(context, nativeBuffer); nativeBuffer.Dispose(); }
            }
        }
    }
}