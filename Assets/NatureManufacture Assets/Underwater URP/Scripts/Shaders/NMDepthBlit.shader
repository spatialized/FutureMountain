Shader "Hidden/NMDepthBlit"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "black" {}
    }

    SubShader
    {
        Tags { "RenderType" = "Opaque" }

        Pass
        {
            Name "LightweightDepthBlit"
            ZTest Always
            Cull Off
            ZWrite Off
            Blend Off

            CGPROGRAM
            #pragma vertex Vert
            #pragma fragment Frag
            #pragma target 3.0

            #include "UnityCG.cginc"


            UNITY_DECLARE_DEPTH_TEXTURE(_LightweightDepthTex);

            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
            };

            struct v2f
            {
                float4 pos : SV_POSITION;
                float2 uv : TEXCOORD0;
            };

            v2f Vert(appdata v)
            {
                v2f o;
                o.pos = UnityObjectToClipPos(v.vertex);
                o.uv = v.uv;
                return o;
            }

            float4 Frag(v2f i) : SV_Target
            {
                float rawDepth = SAMPLE_DEPTH_TEXTURE(_LightweightDepthTex, i.uv);

            
                float d;
                #if defined(UNITY_REVERSED_Z)
                    d = rawDepth;           // near=1, far=0 → poprawny kierunek
                #else
                    d = 1.0 - rawDepth;     // near=0, far=1 → flip
                #endif

                return float4(d, d, d, 1.0);
            }
            ENDCG
        }
    }
    Fallback Off
}
