Shader "HighlightPlus/Geometry/SeeThrough" {
Properties {
    _MainTex ("Texture", 2D) = "white" {}
    _SeeThrough ("See Through", Range(0,1)) = 0.8
    _SeeThroughTintColor ("See Through Tint Color", Color) = (1,0,0,0.8)
	_SeeThroughNoise("Noise", Float) = 1
    _Color ("Color", Color) = (1,1,1) // not used; dummy property to avoid inspector warning "material has no _Color property"
    _CutOff("CutOff", Float ) = 0.5
}
    SubShader
    {
        Tags { "Queue"="Transparent+201" "RenderType"="Transparent" }
   
        // See through effect
        Pass
        {
            Stencil {
                Ref 2
                Comp Greater
                Pass keep 
            }

            // In order to preserve rendering order when two objects overlaps we adjust the o.pos.z to near clip and 
            //ZTest Greater // Always
            ZWrite On
//            Cull Off
            Blend SrcAlpha OneMinusSrcAlpha

            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #pragma multi_compile _ HP_ALPHACLIP

            #include "UnityCG.cginc"

            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
				UNITY_VERTEX_INPUT_INSTANCE_ID
            };

            struct v2f
            {
				float4 pos: SV_POSITION;
                float2 uv : TEXCOORD0;
				UNITY_VERTEX_OUTPUT_STEREO
            };

            sampler2D _MainTex;
            float4 _MainTex_ST;
            fixed _SeeThrough;
            fixed4 _SeeThroughTintColor;
            fixed _CutOff;
			fixed _SeeThroughNoise;

            v2f vert (appdata v)
            {
                v2f o;
				UNITY_SETUP_INSTANCE_ID(v);
				UNITY_INITIALIZE_OUTPUT(v2f, o);
				UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);
                o.pos    = UnityObjectToClipPos(v.vertex);
                #if UNITY_REVERSED_Z
				    o.pos.z = o.pos.w - (o.pos.w - o.pos.z) * 0.001;
                #else
                    o.pos.z = -o.pos.w + ( o.pos.z + o.pos.w ) * 0.001;
                #endif
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                return o;
            }
            
            fixed4 frag (v2f i) : SV_Target
            {
                fixed4 col = tex2D(_MainTex, i.uv);
                #if HP_ALPHACLIP
                clip(col.a - _CutOff);
                #endif
                col.rgb = lerp(col.rgb, _SeeThroughTintColor.rgb, _SeeThroughTintColor.a);
				float scry = i.pos.y;
                col.rgb += _SeeThroughNoise *(frac( scry * _Time.w ) * 0.1);
                col.a = _SeeThrough;
            	col.a = lerp(col.a, col.a * ( (scry % 2) - 1.0 ), _SeeThroughNoise);
                return col;
            }
            ENDCG
        }

    }
}