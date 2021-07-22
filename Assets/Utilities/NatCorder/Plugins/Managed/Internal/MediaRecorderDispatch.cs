/* 
*   NatCorder
*   Copyright (c) 2019 Yusuf Olokoba
*/

namespace NatCorder.Internal {

    using AOT;
    using UnityEngine;
    using System;
    using System.Collections;
    using System.Collections.Generic;
    using System.Runtime.InteropServices;

    public interface IDispatcher : IDisposable { // Implementations must be constructed on the Unity main thread
        void Dispatch (Action workload);
    }

    public sealed class MainDispatcher : IDispatcher {

        private readonly Queue<Action> queue;
        private readonly MainDispatcherAttachment attachment;

        public MainDispatcher () {
            this.queue = new Queue<Action>();
            this.attachment = new GameObject("NatCorderDispatcher").AddComponent<MainDispatcherAttachment>();
            MonoBehaviour.DontDestroyOnLoad(attachment.gameObject);
            MonoBehaviour.DontDestroyOnLoad(attachment);
            attachment.StartCoroutine(Dispatch());
        }

        public void Dispose () {
            Dispatch(() => {
                queue.Clear();
                MonoBehaviour.Destroy(attachment.gameObject);
            });
        }

        public void Dispatch (Action workload) {
            lock ((queue as ICollection).SyncRoot)
                queue.Enqueue(workload);
        }

        private IEnumerator Dispatch () {
            for (;;) {
                lock ((queue as ICollection).SyncRoot)
                    while (queue.Count > 0)
                        queue.Dequeue()();
                yield return new WaitForEndOfFrame();
            }
        }
        
        private class MainDispatcherAttachment : MonoBehaviour { }
    }

    public sealed class RenderDispatcher : IDispatcher {

        public void Dispose () { } // Nop

        public void Dispatch (Action workload) {
            switch (Application.platform) {
                case RuntimePlatform.Android:
                case RuntimePlatform.IPhonePlayer:
                    var renderDelegateHandle = Marshal.GetFunctionPointerForDelegate(new UnityRenderingEvent(DequeueRender));
                    var contextHandle = (IntPtr)GCHandle.Alloc(workload, GCHandleType.Normal);
                    GL.IssuePluginEvent(renderDelegateHandle, contextHandle.ToInt32());
                    break;
                default: // This dispatcher shouldn't be used on other platforms
                    Debug.LogError("NatCorder Error: RenderDispatcher is not supported on this platform");
                    break;
            }
        }

        [UnmanagedFunctionPointer(CallingConvention.Cdecl)]
        private delegate void UnityRenderingEvent (int context);

        [MonoPInvokeCallback(typeof(UnityRenderingEvent))]
        private static void DequeueRender (int context) {
            GCHandle handle = (GCHandle)(IntPtr)context;
            Action target = handle.Target as Action;
            handle.Free();
            target();
        }
    }
}