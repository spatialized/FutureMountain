using System.Collections;
using System.Collections.Generic;
using UnityEngine;

// Put this on the CC root prefab. FirController drives SetGrowth() so the root reveals via the shader
// instead of scaling. BigCreek root prefabs have no such component -> normal scale growth (unaffected).
public class RootClipReveal : MonoBehaviour
{
    private Renderer[] rends;
    private MaterialPropertyBlock mpb;
    private static readonly int GrowthID = Shader.PropertyToID("_Growth");

    public void SetGrowth(float g01)
    {
        if (rends == null)                                  // lazy init (root may start inactive)
        {
            rends = GetComponentsInChildren<Renderer>(true);
            mpb = new MaterialPropertyBlock();
        }
        g01 = Mathf.Clamp01(g01);
        foreach (var r in rends)
        {
            if (r == null) continue;
            r.GetPropertyBlock(mpb);
            mpb.SetFloat(GrowthID, g01);
            r.SetPropertyBlock(mpb);
        }
    }
}