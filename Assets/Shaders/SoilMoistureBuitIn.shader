Shader "Custom/Soil Moisture Built-in"
  {
      Properties
      {
        _BaseTex ("Soil Base Color", 2D) = "white" {}
        _NormalMap ("Normal Map", 2D) = "bump" {}
        _DryColor ("Dry Tint", Color) = (0.55, 0.45, 0.35, 1)
        _WetColor ("Wet Patch Color (blue)", Color) = (0.10, 0.40, 0.90, 1)
        _WetVividness ("Wet Patch Vividness (0=textured,1=pure)", Range(0,1)) = 0.85
        _WetPatchOpacity ("Wet Patch Opacity (0=invisible,1=solid)", Range(0,1)) = 1.0

        _RootMoisture ("Moisture (particle count)", Range(0,1)) = 0.4
        _RootZoneDepth ("Root Zone Depth (0..1)", Range(0.01,1)) = 0.35
        _CapillaryHeight ("Capillary Fringe (0..1)", Range(0.01,1)) = 0.15

        _NoiseScale ("Particle Density", Float) = 22
        _DotSize ("Particle Size", Range(0.02,0.5)) = 0.16
        _NoiseAmount ("Particle Edge Softness", Range(0,1)) = 0.08
        _PatchJitter ("Particle Jitter", Range(0,1)) = 0.5
        _WetContrast ("Wet/Dry Contrast", Range(0.5,4)) = 2.0

        _WaterColor ("Groundwater Color", Color) = (0.15, 0.35, 0.80, 1)
        _WaterLevel ("Water Level (0=bottom..1=top)", Range(0,1)) = 0.25
        _WaterEdge ("Water Edge Softness (0..1)", Range(0.001,0.5)) = 0.05
        _WaterBottom ("Water Bottom (0..1)", Range(0,1)) = 0.0
        _WaterOpacity ("Water Opacity (0..1)", Range(0,1)) = 1.0

        _Smoothness ("Smoothness", Range(0,1)) = 0.2
      }
      SubShader
      {
        Tags { "RenderType"="Opaque" }
        LOD 200
        Cull Off

        CGPROGRAM
        #pragma surface surf Standard vertex:vert
        #pragma target 3.0

        sampler2D _BaseTex;
        sampler2D _NormalMap;
        fixed4 _DryColor, _WetColor, _WaterColor;
        half _RootMoisture, _RootZoneDepth, _CapillaryHeight, _NoiseAmount, _Smoothness, _WaterLevel, _WaterEdge, _WaterBottom, _WaterOpacity, _WetContrast, _WetVividness, _DotSize, _PatchJitter, _WetPatchOpacity;
        float _NoiseScale;

        // rawUV = the mesh's own 0..1 UV, UNAFFECTED by the _BaseTex Tiling/Offset. All vertical-position logic
        // (root zone, water table) must use this, or a per-face tiling/offset shifts the water band off the mesh.
        struct Input { float2 uv_BaseTex; float2 rawUV; };

        void vert(inout appdata_full v, out Input o)
        {
            UNITY_INITIALIZE_OUTPUT(Input, o);
            o.rawUV = v.texcoord.xy;
        }

        float hash(float2 p){ return frac(sin(dot(p, float2(127.1,311.7))) * 43758.5453); }
        float vnoise(float2 p)
        {
            float2 i = floor(p); float2 f = frac(p);
            f = f*f*(3.0-2.0*f);
            float a=hash(i), b=hash(i+float2(1,0)), c=hash(i+float2(0,1)), d=hash(i+float2(1,1));
            return lerp(lerp(a,b,f.x), lerp(c,d,f.x), f.y);
        }
        // Multi-octave noise -> natural, varied patchiness (not one regular frequency).
        float fbm(float2 p)
        {
            float v = 0.0, a = 0.5;
            for (int k = 0; k < 4; k++) { v += a * vnoise(p); p *= 2.0; a *= 0.5; }
            return v;   // ~0..1
        }

        float2 hash2(float2 p){ return frac(sin(float2(dot(p,float2(127.1,311.7)), dot(p,float2(269.5,183.3)))) * 43758.5453); }

        // Small, dense "moisture particle" dots. The UV is tiled into cells (one dot per cell -> dense).
        // A cell shows its dot only when its random value is below _RootMoisture, so more moisture = MORE dots.
        // Each dot wobbles over time (_PatchJitter) so the field shimmers like suspended particles.
        float moistureParticles(float2 uv)
        {
            float2 p = uv * _NoiseScale;          // higher density -> smaller, more numerous cells
            float2 baseCell = floor(p);
            float2 f = frac(p);
            float mask = 0.0;
            for (int y = -1; y <= 1; y++)
            {
                for (int x = -1; x <= 1; x++)
                {
                    float2 g = float2(x, y);
                    float2 cell = baseCell + g;
                    float present = step(hash(cell + 3.7), _RootMoisture);   // 1 if this cell carries a dot
                    float2 rnd = hash2(cell);                                // dot's resting offset within the cell
                    float2 wob = float2(sin(_Time.y * 2.5 + rnd.x * 6.2831),
                                        cos(_Time.y * 2.5 + rnd.y * 6.2831));
                    float2 center = g + 0.5 + (rnd - 0.5) * 0.5 + wob * (_PatchJitter * 0.18);
                    float d = length(f - center);
                    float dot = 1.0 - smoothstep(_DotSize, _DotSize + max(_NoiseAmount, 0.01), d);
                    mask = max(mask, dot * present);
                }
            }
            return saturate(mask);
        }

        void surf(Input IN, inout SurfaceOutputStandard o)
        {
            fixed4 baseCol = tex2D(_BaseTex, IN.uv_BaseTex);
            float yv = IN.rawUV.y;                       // raw mesh UV: 0 = bottom, 1 = top (tiling/offset-proof)

            // ---- UPPER SOIL: moisture PATCHES only (no smooth wet/dry gradient across the profile) ----
            // Root-zone mask: 1 at the surface, fades to 0 by _RootZoneDepth down. Patches live only here;
            // _RootZoneDepth is driven by root-depth data, so deeper roots => patches reach deeper.
            float rootZone = saturate(1.0 - (1.0 - yv) / _RootZoneDepth);

            // Small, dense, shimmering "moisture particle" dots (pure shader, no particle system).
            // _NoiseScale = density, _DotSize = size, _NoiseAmount = edge softness, _PatchJitter = wobble,
            // _RootMoisture = how many dots appear. Confined to the root zone.
            float wetPatch = moistureParticles(IN.uv_BaseTex) * rootZone;

            // Dry soil = textured brown. Wet patch = the blue _WetColor, kept vivid by NOT fully multiplying
            // it with the (brown) base texture: _WetVividness=1 -> pure blue, 0 -> blue tinted by the texture.
            float3 dryAlbedo = baseCol.rgb * _DryColor.rgb;
            float3 wetAlbedo = lerp(baseCol.rgb * _WetColor.rgb, _WetColor.rgb, _WetVividness);
            // _WetPatchOpacity fades the whole patch toward the dry soil: 1 = solid patch, 0 = patch invisible.
            o.Albedo = lerp(dryAlbedo, wetAlbedo, wetPatch * _WetPatchOpacity);

            // ---- GROUNDWATER (saturated zone) tint ----
            // Everything BELOW the water table is saturated, so fill from the profile bottom up to _WaterLevel
            // (data-driven). Soft edge of width _WaterEdge at the water table. No bottom cutoff (that hid the
            // band whenever the water table sat below the old _WaterBottom value).
            float belowWater = saturate((_WaterLevel - yv) / max(_WaterEdge, 0.001));
            float waterMask  = belowWater * _WaterOpacity;
            // Straight colour blend: fade the soil toward the water colour (no multiply).
            o.Albedo = lerp(o.Albedo, _WaterColor.rgb, waterMask);

            o.Normal = UnpackNormal(tex2D(_NormalMap, IN.uv_BaseTex));
            o.Smoothness = lerp(lerp(_Smoothness, _Smoothness + 0.3, wetPatch), 0.6, belowWater);
            o.Metallic = 0;
        }
        ENDCG
      }
      FallBack "Diffuse"
  }