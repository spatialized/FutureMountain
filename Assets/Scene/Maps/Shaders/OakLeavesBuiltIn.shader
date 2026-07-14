Shader "Custom/Oak Leaves Built-in"
{
    Properties
    {
        _MainTex ("Base Color", 2D) = "white" {}
        _MaskTex ("Leaf Mask", 2D) = "white" {}
        _NormalMap ("Normal Map", 2D) = "bump" {}

        _Color ("Tint", Color) = (1,1,1,1)
        _Cutoff ("Alpha Cutoff", Range(0,1)) = 0.5
        _Smoothness ("Smoothness", Range(0,1)) = 0.25
        _NormalStrength ("Normal Strength", Range(0,2)) = 1
    }

    SubShader
    {
        Tags
        {
            "Queue" = "AlphaTest"
            "RenderType" = "TransparentCutout"
        }

        LOD 300
        Cull Off

        CGPROGRAM

        #pragma surface surf Standard fullforwardshadows addshadow
        #pragma target 3.0

        sampler2D _MainTex;
        sampler2D _MaskTex;
        sampler2D _NormalMap;

        fixed4 _Color;
        half _Cutoff;
        half _Smoothness;
        half _NormalStrength;

        struct Input
        {
            float2 uv_MainTex;
        };

        void surf(Input IN, inout SurfaceOutputStandard o)
        {
            fixed4 color = tex2D(_MainTex, IN.uv_MainTex) * _Color;
            fixed4 mask = tex2D(_MaskTex, IN.uv_MainTex);

            clip(mask.r - _Cutoff);

            o.Albedo = color.rgb;

            fixed3 normal = UnpackNormal(tex2D(_NormalMap, IN.uv_MainTex));
            normal.xy *= _NormalStrength;
            o.Normal = normalize(normal);

            o.Metallic = 0;
            o.Smoothness = _Smoothness;
            o.Alpha = 1;
        }

        ENDCG
    }

    FallBack "Transparent/Cutout/VertexLit"
}