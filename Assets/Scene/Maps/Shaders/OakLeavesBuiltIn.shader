Shader "Custom/Oak Leaves Built-in"
{
    Properties
    {
        _FrontTex ("Front Base Color", 2D) = "white" {}
        _BackTex ("Back Base Color", 2D) = "white" {}
        _MaskTex ("Leaf Mask", 2D) = "white" {}
        _NormalMap ("Normal Map", 2D) = "bump" {}

        _Tint ("Tint", Color) = (1,1,1,1)
        _Cutoff ("Alpha Cutoff", Range(0,1)) = 0.5
        _Smoothness ("Smoothness", Range(0,1)) = 0.2
    }

    SubShader
    {
        Tags
        {
            "Queue" = "AlphaTest"
            "RenderType" = "TransparentCutout"
        }

        Cull Off
        LOD 300

        CGPROGRAM
        #pragma surface surf Standard fullforwardshadows addshadow
        #pragma target 3.0

        sampler2D _FrontTex;
        sampler2D _BackTex;
        sampler2D _MaskTex;
        sampler2D _NormalMap;

        fixed4 _Tint;
        half _Cutoff;
        half _Smoothness;

        struct Input
        {
            float2 uv_FrontTex;
            float facing : VFACE;
        };

        void surf(Input IN, inout SurfaceOutputStandard o)
        {
            bool isFront = IN.facing > 0;

            fixed4 frontColor = tex2D(_FrontTex, IN.uv_FrontTex);
            fixed4 backColor = tex2D(_BackTex, IN.uv_FrontTex);
            fixed4 mask = tex2D(_MaskTex, IN.uv_FrontTex);

            clip(mask.r - _Cutoff);

            fixed4 color = isFront ? frontColor : backColor;
            o.Albedo = color.rgb * _Tint.rgb;

            fixed3 n = UnpackNormal(tex2D(_NormalMap, IN.uv_FrontTex));

            if (!isFront)
            {
                n.z *= -1;
            }

            o.Normal = n;
            o.Metallic = 0;
            o.Smoothness = _Smoothness;
            o.Alpha = 1;
        }
        ENDCG
    }

    FallBack "Transparent/Cutout/VertexLit"
}