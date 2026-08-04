using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class LeafDensity : MonoBehaviour
{
    public Renderer[] leafRenderers;              // Leaf renderer(s) driven by leaf carbon (can span growth-stage models)
      public string cutoffProperty = "_Cutoff";     // Your custom shader's alpha-clip property
      public float cutoffAtFull  = 0.1f;            // Cutoff at FULL leaf carbon (dense)
      public float cutoffAtEmpty = 0.7f;            // Cutoff at ZERO leaf carbon (sparse)

      private int propId;
      private MaterialPropertyBlock mpb;

      /// f in [0,1]: 1 = full leaf carbon (dense), 0 = empty (sparse).
      public void SetDensity(float f)
      {
          if (leafRenderers == null || leafRenderers.Length == 0) return;
          if (mpb == null) { mpb = new MaterialPropertyBlock(); propId = Shader.PropertyToID(cutoffProperty); }
          float cutoff = Mathf.Lerp(cutoffAtEmpty, cutoffAtFull, Mathf.Clamp01(f));
          foreach (Renderer r in leafRenderers)
          {
              if (r == null) continue;
              r.GetPropertyBlock(mpb);
              mpb.SetFloat(propId, cutoff);
              r.SetPropertyBlock(mpb);
          }
      }
}
