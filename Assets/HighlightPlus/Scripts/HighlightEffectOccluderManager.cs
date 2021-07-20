using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Rendering;

namespace HighlightPlus {


    public partial class HighlightEffect : MonoBehaviour {

        static List<HighlightSeeThroughOccluder> occluders = new List<HighlightSeeThroughOccluder>();
        static Dictionary<Camera, int> occludersFrameCount = new Dictionary<Camera, int>();
        static CommandBuffer cbOccluder;
        static Material fxMatOccluder;

        public static void RegisterOccluder(HighlightSeeThroughOccluder occluder) {
            if (!occluders.Contains(occluder)) {
                occluders.Add(occluder);
            }
        }

        public static void UnregisterOccluder(HighlightSeeThroughOccluder occluder) {
            if (occluders.Contains(occluder)) {
                occluders.Remove(occluder);
            }
        }

        public void RenderOccluders() {

            int occludersCount = occluders.Count;
            if (occludersCount == 0) return;

            int lastFrameCount;
            Camera cam = Camera.current;
            occludersFrameCount.TryGetValue(cam, out lastFrameCount);
            int currentFrameCount = Time.frameCount;
            if (currentFrameCount == lastFrameCount) return;
            occludersFrameCount[cam] = currentFrameCount;

            if (cbOccluder == null) {
                cbOccluder = new CommandBuffer();
                cbOccluder.name = "Occluder";
            }

            if (fxMatOccluder == null) {
                InitMaterial(ref fxMatOccluder, "HighlightPlus/Geometry/SeeThroughOccluder");
                if (fxMatOccluder == null) return;
            }

            cbOccluder.Clear();
            for (int k = 0; k < occludersCount; k++) {
                HighlightSeeThroughOccluder occluder = occluders[k];
                if (occluder == null || !occluder.isActiveAndEnabled || occluder.meshData == null || occluder.meshData.Length == 0) continue;
                // Per renderer
                for (int m=0;m<occluder.meshData.Length;m++) {
                    // Per submesh
                    Renderer renderer = occluder.meshData[m].renderer;
                    if (renderer.isVisible) {
                        for (int s = 0; s < occluder.meshData[m].subMeshCount; s++) {
                            cbOccluder.DrawRenderer(renderer, fxMatOccluder, s);
                        }
                    }
                }
            }
            Graphics.ExecuteCommandBuffer(cbOccluder);
        }

    }
}
