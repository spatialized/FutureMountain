Shader "NatureManufacture Shaders/Trees/Tree Bark Specular Snow"
{
	Properties
	{
		_Snow_Amount("Snow_Amount", Range( 0 , 2)) = 0.13
		_Color("Color", Color) = (1,1,1,0)
		_MainTex("MainTex", 2D) = "white" {}
		[NoScaleOffset]_BumpMap("BumpMap", 2D) = "bump" {}
		_BumpScale("BumpScale", Range( 0 , 5)) = 1
		[NoScaleOffset]_SpecularRGBSmothnessA("Specular (RGB) Smothness (A)", 2D) = "white" {}
		_SpecularPower("Specular Power", Range( 0 , 2)) = 0
		_SmoothnessPower("Smoothness Power", Range( 0 , 2)) = 0
		[NoScaleOffset]_AmbientOcclusionA("Ambient Occlusion (A)", 2D) = "gray" {}
		_AmbientOcclusionPower("Ambient Occlusion Power", Range( 0 , 1)) = 1
		_DetailMask("DetailMask", 2D) = "black" {}
		_DetailAlbedoMap("DetailAlbedoMap", 2D) = "white" {}
		[Toggle(_DETALUSEUV3_ON)] _DetalUseUV3("Detal Use UV3", Float) = 0
		[NoScaleOffset]_DetailNormalMap("DetailNormalMap", 2D) = "bump" {}
		_DetailNormalMapScale("DetailNormalMapScale", Range( 0 , 5)) = 1
		[NoScaleOffset]_DetailAmbientOcclusionG("Detail Ambient Occlusion (G)", 2D) = "gray" {}
		_DetailAmbientOcclusionPower("Detail Ambient Occlusion Power", Range( 0 , 1)) = 1
		[NoScaleOffset]_DetailSpecularRGBSmothnessA("Detail Specular (RGB) Smothness (A)", 2D) = "white" {}
		_SnowColor("Snow Color", Color) = (1,1,1,0)
		_SnowCover("Snow Cover", 2D) = "white" {}
		[Toggle(_SNOWUSEUV3_ON)] _SnowUseUV3("Snow Use UV3", Float) = 0
		[NoScaleOffset]_SnowCoverNormal("Snow Cover Normal", 2D) = "bump" {}
		[NoScaleOffset]_SnowCoverSpecularRGBSmothnessA("Snow Cover Specular (RGB) Smothness (A)", 2D) = "gray" {}
		_SnowSpecularPower("Snow Specular Power", Range( 0 , 2)) = 0
		_SnowSmoothnessPower("Snow Smoothness Power", Range( 0 , 2)) = 0
		[NoScaleOffset]_SnowCoverAmbientOcclusionG("Snow Cover Ambient Occlusion (G)", 2D) = "gray" {}
		_SnowAmbientOcclusionPower("Snow Ambient Occlusion Power", Range( 0 , 1)) = 1
		_InitialBend("Wind Initial Bend", Float) = 1
		_Stiffness("Wind Stiffness", Float) = 1
		_Drag("Wind Drag", Float) = 1
		[Toggle(_TOUCHREACTACTIVE_ON)] _TouchReactActive("TouchReactActive", Float) = 0
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] _texcoord3( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Opaque"  "Queue" = "Geometry+0" }
		Cull Back
		CGINCLUDE
		#include "UnityStandardUtils.cginc"
		#include "UnityPBSLighting.cginc"
		#include "Lighting.cginc"
		#pragma target 3.0
		#pragma multi_compile_instancing
		#pragma shader_feature _TOUCHREACTACTIVE_ON
		#pragma shader_feature _DETALUSEUV3_ON
		#pragma shader_feature _SNOWUSEUV3_ON
		#include "NMWindNoShiver.cginc"
		#include "NM_indirect.cginc"
		#pragma vertex vert
		#pragma instancing_options procedural:setup
		#pragma multi_compile GPU_FRUSTUM_ON __
		#ifdef UNITY_PASS_SHADOWCASTER
			#undef INTERNAL_DATA
			#undef WorldReflectionVector
			#undef WorldNormalVector
			#define INTERNAL_DATA half3 internalSurfaceTtoW0; half3 internalSurfaceTtoW1; half3 internalSurfaceTtoW2;
			#define WorldReflectionVector(data,normal) reflect (data.worldRefl, half3(dot(data.internalSurfaceTtoW0,normal), dot(data.internalSurfaceTtoW1,normal), dot(data.internalSurfaceTtoW2,normal)))
			#define WorldNormalVector(data,normal) half3(dot(data.internalSurfaceTtoW0,normal), dot(data.internalSurfaceTtoW1,normal), dot(data.internalSurfaceTtoW2,normal))
		#endif
		struct Input
		{
			float2 uv_texcoord;
			float2 uv3_texcoord3;
			float3 worldNormal;
			INTERNAL_DATA
		};

		uniform float _BumpScale;
		uniform sampler2D _BumpMap;
		uniform sampler2D _MainTex;
		uniform float4 _MainTex_ST;
		uniform float _DetailNormalMapScale;
		uniform sampler2D _DetailNormalMap;
		uniform sampler2D _DetailAlbedoMap;
		uniform float4 _DetailAlbedoMap_ST;
		uniform float4 _DetailNormalMap_ST;
		uniform sampler2D _DetailMask;
		uniform float4 _DetailMask_ST;
		uniform sampler2D _SnowCoverNormal;
		uniform sampler2D _SnowCover;
		uniform float4 _SnowCover_ST;
		uniform float4 _SnowCoverNormal_ST;
		uniform float _Snow_Amount;
		uniform float4 _Color;
		uniform float4 _SnowColor;
		uniform sampler2D _SpecularRGBSmothnessA;
		uniform sampler2D _DetailSpecularRGBSmothnessA;
		uniform float _SpecularPower;
		uniform sampler2D _SnowCoverSpecularRGBSmothnessA;
		uniform float _SnowSpecularPower;
		uniform float _SmoothnessPower;
		uniform float _SnowSmoothnessPower;
		uniform sampler2D _AmbientOcclusionA;
		uniform float _AmbientOcclusionPower;
		uniform sampler2D _DetailAmbientOcclusionG;
		uniform float _DetailAmbientOcclusionPower;
		uniform sampler2D _SnowCoverAmbientOcclusionG;
		uniform float _SnowAmbientOcclusionPower;

		void surf( Input i , inout SurfaceOutputStandardSpecular o )
		{
			float2 uv0_MainTex = i.uv_texcoord * _MainTex_ST.xy + _MainTex_ST.zw;
			float2 uv0_DetailAlbedoMap = i.uv_texcoord * _DetailAlbedoMap_ST.xy + _DetailAlbedoMap_ST.zw;
			float2 uv2_DetailNormalMap = i.uv3_texcoord3 * _DetailNormalMap_ST.xy + _DetailNormalMap_ST.zw;
			#ifdef _DETALUSEUV3_ON
				float2 staticSwitch157 = uv2_DetailNormalMap;
			#else
				float2 staticSwitch157 = uv0_DetailAlbedoMap;
			#endif
			float2 uv_DetailMask = i.uv_texcoord * _DetailMask_ST.xy + _DetailMask_ST.zw;
			float4 tex2DNode25 = tex2D( _DetailMask, uv_DetailMask );
			float3 lerpResult19 = lerp( UnpackScaleNormal( tex2D( _BumpMap, uv0_MainTex ), _BumpScale ) , UnpackScaleNormal( tex2D( _DetailNormalMap, staticSwitch157 ), _DetailNormalMapScale ) , tex2DNode25.a);
			float2 uv0_SnowCover = i.uv_texcoord * _SnowCover_ST.xy + _SnowCover_ST.zw;
			float2 uv2_SnowCoverNormal = i.uv3_texcoord3 * _SnowCoverNormal_ST.xy + _SnowCoverNormal_ST.zw;
			#ifdef _SNOWUSEUV3_ON
				float2 staticSwitch160 = uv2_SnowCoverNormal;
			#else
				float2 staticSwitch160 = uv0_SnowCover;
			#endif
			float3 ase_worldNormal = WorldNormalVector( i, float3( 0, 0, 1 ) );
			float3 lerpResult29 = lerp( lerpResult19 , UnpackNormal( tex2D( _SnowCoverNormal, staticSwitch160 ) ) , saturate( ( ase_worldNormal.y * _Snow_Amount ) ));
			o.Normal = lerpResult29;
			float4 lerpResult16 = lerp( tex2D( _MainTex, uv0_MainTex ) , tex2D( _DetailAlbedoMap, staticSwitch157 ) , tex2DNode25.a);
			float temp_output_33_0 = saturate( ( (WorldNormalVector( i , lerpResult29 )).y * _Snow_Amount ) );
			float4 lerpResult28 = lerp( ( lerpResult16 * _Color ) , ( tex2D( _SnowCover, staticSwitch160 ) * _SnowColor ) , temp_output_33_0);
			o.Albedo = lerpResult28.rgb;
			float4 lerpResult18 = lerp( tex2D( _SpecularRGBSmothnessA, uv0_MainTex ) , tex2D( _DetailSpecularRGBSmothnessA, staticSwitch157 ) , tex2DNode25.a);
			float4 break22 = lerpResult18;
			float3 appendResult48 = (float3(break22.r , break22.g , break22.b));
			float4 tex2DNode45 = tex2D( _SnowCoverSpecularRGBSmothnessA, staticSwitch160 );
			float3 appendResult49 = (float3(tex2DNode45.r , tex2DNode45.g , tex2DNode45.b));
			float3 lerpResult38 = lerp( ( appendResult48 * _SpecularPower ) , ( appendResult49 * _SnowSpecularPower ) , temp_output_33_0);
			o.Specular = lerpResult38;
			float lerpResult37 = lerp( ( break22.a * _SmoothnessPower ) , ( tex2DNode45.a * _SnowSmoothnessPower ) , temp_output_33_0);
			o.Smoothness = lerpResult37;
			float clampResult64 = clamp( tex2D( _AmbientOcclusionA, uv0_MainTex ).g , ( 1.0 - _AmbientOcclusionPower ) , 1.0 );
			float clampResult66 = clamp( tex2D( _DetailAmbientOcclusionG, staticSwitch157 ).g , ( 1.0 - _DetailAmbientOcclusionPower ) , 1.0 );
			float lerpResult53 = lerp( clampResult64 , clampResult66 , tex2DNode25.a);
			float clampResult62 = clamp( tex2D( _SnowCoverAmbientOcclusionG, staticSwitch160 ).g , ( 1.0 - _SnowAmbientOcclusionPower ) , 1.0 );
			float lerpResult39 = lerp( lerpResult53 , clampResult62 , temp_output_33_0);
			o.Occlusion = lerpResult39;
			o.Alpha = 1;
		}

		ENDCG
		CGPROGRAM
		#pragma surface surf StandardSpecular keepalpha fullforwardshadows dithercrossfade 

		ENDCG
		Pass
		{
			Name "ShadowCaster"
			Tags{ "LightMode" = "ShadowCaster" }
			ZWrite On
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#pragma target 3.0
			#pragma multi_compile_shadowcaster
			#pragma multi_compile UNITY_PASS_SHADOWCASTER
			#pragma skip_variants FOG_LINEAR FOG_EXP FOG_EXP2
			#include "HLSLSupport.cginc"
			#if ( SHADER_API_D3D11 || SHADER_API_GLCORE || SHADER_API_GLES || SHADER_API_GLES3 || SHADER_API_METAL || SHADER_API_VULKAN )
				#define CAN_SKIP_VPOS
			#endif
			#include "UnityCG.cginc"
			#include "Lighting.cginc"
			#include "UnityPBSLighting.cginc"
			struct v2f
			{
				V2F_SHADOW_CASTER;
				float4 customPack1 : TEXCOORD1;
				float4 tSpace0 : TEXCOORD2;
				float4 tSpace1 : TEXCOORD3;
				float4 tSpace2 : TEXCOORD4;
				UNITY_VERTEX_INPUT_INSTANCE_ID
			};
			v2f vert( appdata_full v )
			{
				v2f o;
				UNITY_SETUP_INSTANCE_ID( v );
				UNITY_INITIALIZE_OUTPUT( v2f, o );
				UNITY_TRANSFER_INSTANCE_ID( v, o );
				Input customInputData;
				float3 worldPos = mul( unity_ObjectToWorld, v.vertex ).xyz;
				half3 worldNormal = UnityObjectToWorldNormal( v.normal );
				half3 worldTangent = UnityObjectToWorldDir( v.tangent.xyz );
				half tangentSign = v.tangent.w * unity_WorldTransformParams.w;
				half3 worldBinormal = cross( worldNormal, worldTangent ) * tangentSign;
				o.tSpace0 = float4( worldTangent.x, worldBinormal.x, worldNormal.x, worldPos.x );
				o.tSpace1 = float4( worldTangent.y, worldBinormal.y, worldNormal.y, worldPos.y );
				o.tSpace2 = float4( worldTangent.z, worldBinormal.z, worldNormal.z, worldPos.z );
				o.customPack1.xy = customInputData.uv_texcoord;
				o.customPack1.xy = v.texcoord;
				o.customPack1.zw = customInputData.uv3_texcoord3;
				o.customPack1.zw = v.texcoord2;
				TRANSFER_SHADOW_CASTER_NORMALOFFSET( o )
				return o;
			}
			half4 frag( v2f IN
			#if !defined( CAN_SKIP_VPOS )
			, UNITY_VPOS_TYPE vpos : VPOS
			#endif
			) : SV_Target
			{
				UNITY_SETUP_INSTANCE_ID( IN );
				Input surfIN;
				UNITY_INITIALIZE_OUTPUT( Input, surfIN );
				surfIN.uv_texcoord = IN.customPack1.xy;
				surfIN.uv3_texcoord3 = IN.customPack1.zw;
				float3 worldPos = float3( IN.tSpace0.w, IN.tSpace1.w, IN.tSpace2.w );
				half3 worldViewDir = normalize( UnityWorldSpaceViewDir( worldPos ) );
				surfIN.worldNormal = float3( IN.tSpace0.z, IN.tSpace1.z, IN.tSpace2.z );
				surfIN.internalSurfaceTtoW0 = IN.tSpace0.xyz;
				surfIN.internalSurfaceTtoW1 = IN.tSpace1.xyz;
				surfIN.internalSurfaceTtoW2 = IN.tSpace2.xyz;
				SurfaceOutputStandardSpecular o;
				UNITY_INITIALIZE_OUTPUT( SurfaceOutputStandardSpecular, o )
				surf( surfIN, o );
				#if defined( CAN_SKIP_VPOS )
				float2 vpos = IN.pos;
				#endif
				SHADOW_CASTER_FRAGMENT( IN )
			}
			ENDCG
		}
	}
	Fallback "Diffuse"
}