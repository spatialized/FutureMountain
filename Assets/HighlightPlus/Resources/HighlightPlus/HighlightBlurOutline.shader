Shader "HighlightPlus/Geometry/BlurOutline" {
Properties {
    _MainTex ("Texture", Any) = "white" {}
    _Color ("Color", Color) = (1,1,0) // not used; dummy property to avoid inspector warning "material has no _Color property"
    _BlurScale("Blur Scale", Float) = 2.0
}
    SubShader
    {
        Tags { "Queue"="Transparent+100" "RenderType"="Transparent" }
        ZTest Always
        ZWrite Off
        CGINCLUDE

	#include "UnityCG.cginc"

	UNITY_DECLARE_SCREENSPACE_TEXTURE(_MainTex);
	float4     _MainTex_TexelSize;
	float4     _MainTex_ST;
	float     _BlurScale;

    struct appdata {
    	float4 vertex : POSITION;
		float2 texcoord : TEXCOORD0;
		UNITY_VERTEX_INPUT_INSTANCE_ID
    };


	struct v2fCross {
	    float4 pos : SV_POSITION;
	    float2 uv: TEXCOORD0;
	    float2 uv1: TEXCOORD1;
	    float2 uv2: TEXCOORD2;
	    float2 uv3: TEXCOORD3;
	    float2 uv4: TEXCOORD4;
		UNITY_VERTEX_INPUT_INSTANCE_ID
		UNITY_VERTEX_OUTPUT_STEREO
	};

	struct v2fSides {
	    float4 pos : SV_POSITION;
	    float2 uv1: TEXCOORD0;
	    float2 uv2: TEXCOORD1;
	    float2 uv3: TEXCOORD2;
	    float2 uv4: TEXCOORD3;
		UNITY_VERTEX_INPUT_INSTANCE_ID
		UNITY_VERTEX_OUTPUT_STEREO
	};

	v2fCross vertCross(appdata v) {
    	v2fCross o;
		UNITY_SETUP_INSTANCE_ID(v);
		UNITY_TRANSFER_INSTANCE_ID(v, o);
		UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);
    	o.pos = UnityObjectToClipPos(v.vertex);
		#if UNITY_UV_STARTS_AT_TOP
    	if (_MainTex_TexelSize.y < 0) {
	        // Texture is inverted WRT the main texture
    	    v.texcoord.y = 1.0 - v.texcoord.y;
    	}
    	#endif   
    	o.uv = UnityStereoScreenSpaceUVAdjust(v.texcoord, _MainTex_ST);
		float3 offsets = _MainTex_TexelSize.xyx * float3(1,1,-1) * _BlurScale;
		#if UNITY_SINGLE_PASS_STEREO
		offsets.xz *= 2.0;
		#endif
		o.uv1 = UnityStereoScreenSpaceUVAdjust(v.texcoord - offsets.xy, _MainTex_ST);
		o.uv2 = UnityStereoScreenSpaceUVAdjust(v.texcoord - offsets.zy, _MainTex_ST);
		o.uv3 = UnityStereoScreenSpaceUVAdjust(v.texcoord + offsets.zy, _MainTex_ST);
		o.uv4 = UnityStereoScreenSpaceUVAdjust(v.texcoord + offsets.xy, _MainTex_ST);
		return o;
	}

   	v2fSides vertSides(appdata v) {
    	v2fSides o;
		UNITY_SETUP_INSTANCE_ID(v);
		UNITY_TRANSFER_INSTANCE_ID(v, o);
		UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);
    	o.pos = UnityObjectToClipPos(v.vertex);
		#if UNITY_UV_STARTS_AT_TOP
    	if (_MainTex_TexelSize.y < 0) {
	        // Texture is inverted WRT the main texture
    	    v.texcoord.y = 1.0 - v.texcoord.y;
    	}
    	#endif   
		float3 offsets = _MainTex_TexelSize.xyx * float3(1,1,-1) * _BlurScale;
		#if UNITY_SINGLE_PASS_STEREO
		offsets.xz *= 2.0;
		#endif
		o.uv1 = UnityStereoScreenSpaceUVAdjust(v.texcoord - offsets.xy, _MainTex_ST);
		o.uv2 = UnityStereoScreenSpaceUVAdjust(v.texcoord - offsets.zy, _MainTex_ST);
		o.uv3 = UnityStereoScreenSpaceUVAdjust(v.texcoord + offsets.zy, _MainTex_ST);
		o.uv4 = UnityStereoScreenSpaceUVAdjust(v.texcoord + offsets.xy, _MainTex_ST);
		return o;
	}

	float4 fragBlur (v2fSides i): SV_Target {
		//UNITY_SETUP_INSTANCE_ID(i);
        //UNITY_SETUP_STEREO_EYE_INDEX_POST_VERTEX(i);
		float4 pixel = max(
						max(UNITY_SAMPLE_SCREENSPACE_TEXTURE(_MainTex, i.uv1), UNITY_SAMPLE_SCREENSPACE_TEXTURE(_MainTex, i.uv2)),
						max(UNITY_SAMPLE_SCREENSPACE_TEXTURE(_MainTex, i.uv3), UNITY_SAMPLE_SCREENSPACE_TEXTURE(_MainTex, i.uv4))
					);
   		return pixel;
	}	


	float4 fragResample(v2fCross i) : SV_Target {
		//UNITY_SETUP_INSTANCE_ID(i);
        //UNITY_SETUP_STEREO_EYE_INDEX_POST_VERTEX(i);
        float4 c0 = UNITY_SAMPLE_SCREENSPACE_TEXTURE(_MainTex, i.uv);
		float4 c1 = UNITY_SAMPLE_SCREENSPACE_TEXTURE(_MainTex, i.uv1);
		float4 c2 = UNITY_SAMPLE_SCREENSPACE_TEXTURE(_MainTex, i.uv2);
		float4 c3 = UNITY_SAMPLE_SCREENSPACE_TEXTURE(_MainTex, i.uv3);
		float4 c4 = UNITY_SAMPLE_SCREENSPACE_TEXTURE(_MainTex, i.uv4);
		return c0*0.6+(c1+c2+c3+c4)*0.4;
	}

	ENDCG

	Pass {
		CGPROGRAM
		#pragma vertex vertSides
		#pragma fragment fragBlur
      	#pragma fragmentoption ARB_precision_hint_fastest
	  	#pragma target 3.0
		ENDCG
	}

	Pass {
	  	CGPROGRAM
      	#pragma vertex vertCross
      	#pragma fragment fragResample
      	#pragma fragmentoption ARB_precision_hint_fastest
      	#pragma target 3.0
      	ENDCG
	}

	}
}