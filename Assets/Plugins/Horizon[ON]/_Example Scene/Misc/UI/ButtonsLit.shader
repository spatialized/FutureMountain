// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "Shader Forge/ButtonsLit" {
    Properties {
        _MainTex ("MainTex", 2D) = "white" {}
        _AmbientLightFactor ("AmbientLightFactor", Range(0, 1)) = 0
        _Shimmer ("Shimmer", 2D) = "white" {}
        [HideInInspector]_Cutoff ("Alpha cutoff", Range(0,1)) = 0.5
    }
    SubShader {
        Tags {
            "IgnoreProjector"="True"
            "Queue"="Transparent"
            "RenderType"="Transparent"
        }
        Pass {
            Name "ForwardBase"
            Tags {
                "LightMode"="ForwardBase"
            }
            Blend SrcAlpha OneMinusSrcAlpha
            ZWrite Off
            
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #define UNITY_PASS_FORWARDBASE
            #include "UnityCG.cginc"
            #pragma multi_compile_fwdbase
            #pragma exclude_renderers xbox360 ps3 flash d3d11_9x 
            #pragma target 3.0
            uniform float4 _TimeEditor;
            uniform sampler2D _MainTex; uniform float4 _MainTex_ST;
            uniform float _AmbientLightFactor;
            uniform sampler2D _Shimmer; uniform float4 _Shimmer_ST;
            struct VertexInput {
                float4 vertex : POSITION;
                float2 texcoord0 : TEXCOORD0;
            };
            struct VertexOutput {
                float4 pos : SV_POSITION;
                float2 uv0 : TEXCOORD0;
                float4 screenPos : TEXCOORD1;
            };
            VertexOutput vert (VertexInput v) {
                VertexOutput o = (VertexOutput)0;
                o.uv0 = v.texcoord0;
                o.pos = UnityObjectToClipPos(v.vertex);
                o.screenPos = o.pos;
                return o;
            }
            fixed4 frag(VertexOutput i) : COLOR {
                i.screenPos = float4( i.screenPos.xy / i.screenPos.w, 0, 0 );
                i.screenPos.y *= _ProjectionParams.x;

                float node_1368 = 1.0;
                float4 _MainTex_var = tex2D(_MainTex,TRANSFORM_TEX(i.uv0, _MainTex));
                float4 node_5236 = _Time + _TimeEditor;
                float2 node_1502 = float2(((frac((node_5236.r*(-0.75)))*60.0+-30.0)+float2(i.screenPos.x*(_ScreenParams.r/_ScreenParams.g), i.screenPos.y).r),float2(i.screenPos.x*(_ScreenParams.r/_ScreenParams.g), i.screenPos.y).g);
                float4 _Shimmer_var = tex2D(_Shimmer,TRANSFORM_TEX(node_1502, _Shimmer));
                float3 emissive = ((lerp(float3(node_1368,node_1368,node_1368),UNITY_LIGHTMODEL_AMBIENT.rgb,_AmbientLightFactor)*_MainTex_var.rgb)+(_MainTex_var.rgb*_Shimmer_var.rgb));
                float3 finalColor = emissive;
                return fixed4(finalColor,_MainTex_var.a);
            }
            ENDCG
        }
    }
    FallBack "Diffuse"
}
