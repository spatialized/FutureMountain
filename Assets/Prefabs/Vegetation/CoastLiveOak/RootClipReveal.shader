 Shader "FMCC/RootClipReveal"
  {
      Properties
      {
          _Color ("Color", Color) = (0.45,0.3,0.2,1)
          _MainTex ("Albedo", 2D) = "white" {}
          _Glossiness ("Smoothness", Range(0,1)) = 0.2
          _Metallic ("Metallic", Range(0,1)) = 0.0
          _Growth ("Growth (0..1)", Range(0,1)) = 1
          _TopY ("Top Y (object space)", Float) = 0
          _Depth ("Depth (object units)", Float) = 1
          _NoiseTex ("Jitter Noise (grayscale)", 2D) = "gray" {}   // default gray = no jitter; assign a noise tex for a ragged edge
          _NoiseScale ("Jitter Scale (freq)", Float) = 0.5
          _JitterAmp ("Jitter Amount", Float) = 0.3
      }
      SubShader
      {
          Tags { "RenderType"="Opaque" }
          Cull Off

          CGPROGRAM
          #pragma surface surf Standard vertex:vert addshadow
          #pragma target 3.0

          sampler2D _MainTex;
          sampler2D _NoiseTex;
          fixed4 _Color;
          half _Glossiness; half _Metallic;
          float _Growth; float _TopY; float _Depth;
          float _NoiseScale; float _JitterAmp;

          struct Input
          {
              float2 uv_MainTex;
              float objY;
              float2 objXZ;
          };

          void vert(inout appdata_full v, out Input o)
          {
              UNITY_INITIALIZE_OUTPUT(Input, o);
              o.objY  = v.vertex.y;
              o.objXZ = v.vertex.xz;      // for spatially-stable jitter
          }

          void surf(Input IN, inout SurfaceOutputStandard o)
          {
              // Sample noise by horizontal position to give the reveal line a ragged edge (default _NoiseTex=gray -> no jitter)
              float n = tex2D(_NoiseTex, IN.objXZ * _NoiseScale).r;
              float revealLine = _TopY - _Growth * _Depth + (n - 0.5) * _JitterAmp;
              clip(IN.objY - revealLine);

              fixed4 c = tex2D(_MainTex, IN.uv_MainTex) * _Color;
              o.Albedo = c.rgb;
              o.Metallic = _Metallic;
              o.Smoothness = _Glossiness;
              o.Alpha = c.a;
          }
          ENDCG
      }
      FallBack "Diffuse"
  }