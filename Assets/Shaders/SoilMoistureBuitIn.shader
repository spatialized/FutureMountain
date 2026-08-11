Shader "Custom/Soil Moisture Built-in"
  {
      Properties
      {
          _BaseTex ("Soil Base Color", 2D) = "white" {}
          _NormalMap ("Normal Map", 2D) = "bump" {}
          _DryColor ("Dry Tint", Color) = (0.55, 0.45, 0.35, 1)
          _WetColor ("Wet Tint", Color) = (0.18, 0.13, 0.10, 1)

          _RootMoisture ("Root Moisture (vegAccessWater)", Range(0,1)) = 0.4
          _RootZoneDepth ("Root Zone Depth (0..1)", Range(0.01,1)) = 0.35
          _CapillaryHeight ("Capillary Fringe (0..1)", Range(0.01,1)) = 0.15

          _NoiseScale ("Clump Scale", Float) = 8
          _NoiseAmount ("Clump Strength", Range(0,1)) = 0.5

          _WaterColor ("Groundwater Color", Color) = (0.1, 0.18, 0.28, 1)
          _WaterLevel ("Water Level (0=bottom..1=top)", Range(0,1)) = 0.25
          _WaterEdge ("Water Edge Softness (0..1)", Range(0.001,0.5)) = 0.05

          _Smoothness ("Smoothness", Range(0,1)) = 0.2
      }
      SubShader
      {
          Tags { "RenderType"="Opaque" }
          LOD 200
          Cull Off

          CGPROGRAM
          #pragma surface surf Standard
          #pragma target 3.0

          sampler2D _BaseTex;
          sampler2D _NormalMap;
          fixed4 _DryColor, _WetColor, _WaterColor;
          half _RootMoisture, _RootZoneDepth, _CapillaryHeight, _NoiseAmount, _Smoothness, _WaterLevel, _WaterEdge;
          float _NoiseScale;

          struct Input { float2 uv_BaseTex; };

          float hash(float2 p){ return frac(sin(dot(p, float2(127.1,311.7))) * 43758.5453); }
          float vnoise(float2 p)
          {
              float2 i = floor(p); float2 f = frac(p);
              f = f*f*(3.0-2.0*f);
              float a=hash(i), b=hash(i+float2(1,0)), c=hash(i+float2(0,1)), d=hash(i+float2(1,1));
              return lerp(lerp(a,b,f.x), lerp(c,d,f.x), f.y);
          }

          void surf(Input IN, inout SurfaceOutputStandard o)
          {
              fixed4 baseCol = tex2D(_BaseTex, IN.uv_BaseTex);
              float yv = IN.uv_BaseTex.y;                 // 0 = bottom, 1 = top (flip to 1-yv if inverted)

              // top root-zone wetness: strong at surface (yv=1), fades down by _RootZoneDepth
              float rootWet = _RootMoisture * saturate(1.0 - (1.0 - yv) / _RootZoneDepth);

              // capillary fringe: wet just above the water level, fading up over _CapillaryHeight
              float capWet = saturate(1.0 - (yv - _WaterLevel) / _CapillaryHeight);

              float clump = vnoise(IN.uv_BaseTex * _NoiseScale) * _NoiseAmount;

              // wet - dry - wet: top (root) and bottom (capillary) wet, middle dry
              float soilWet = saturate(max(rootWet, capWet) + clump * max(rootWet, capWet));

              o.Albedo = baseCol.rgb * lerp(_DryColor.rgb, _WetColor.rgb, soilWet);

              // groundwater below the water level: blue with a soft edge
              float belowWater = saturate((_WaterLevel - yv) / _WaterEdge);
              o.Albedo = lerp(o.Albedo, _WaterColor.rgb, belowWater);

              o.Normal = UnpackNormal(tex2D(_NormalMap, IN.uv_BaseTex));
              o.Smoothness = lerp(lerp(_Smoothness, _Smoothness + 0.3, soilWet), 0.6, belowWater);
              o.Metallic = 0;
          }
          ENDCG
      }
      FallBack "Diffuse"
  }