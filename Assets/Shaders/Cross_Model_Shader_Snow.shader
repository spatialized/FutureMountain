Shader "NatureManufacture Shaders/Trees/Cross Model Shader Snow"
{
	Properties
	{
		_Cutoff( "Mask Clip Value", Float ) = 0.5
		_Snow_Amount("Snow_Amount", Range( 0 , 2)) = 0.13
		_ColorAdjustment("Color Adjustment", Vector) = (1,1,1,0)
		_MainTex("MainTex", 2D) = "white" {}
		_HealthyColor("Healthy Color", Color) = (1,0.9735294,0.9338235,1)
		_Smooothness("Smooothness", Float) = 0.3
		_AO("AO", Float) = 1
		[NoScaleOffset]_BumpMap("BumpMap", 2D) = "bump" {}
		_BumpScale("BumpScale", Range( 0 , 3)) = 1
		[NoScaleOffset]_SnowMaskA("Snow Mask (A)", 2D) = "black" {}
		[Toggle(_INVERTSNOWMASK_ON)] _InvertSnowMask("Invert Snow Mask", Float) = 0
		_SnowMaskTreshold("Snow Mask Treshold", Range( 0.1 , 3)) = 1
		_SnowAlbedoRGB("Snow Albedo (RGB)", 2D) = "white" {}
		_NewNormal("Vertex Normal Multiply", Vector) = (0,0,0,0)
		[NoScaleOffset]_SnowNormalRGB("Snow Normal (RGB)", 2D) = "bump" {}
		_SnowNormalPower("Snow Normal Power", Range( 0 , 2)) = 1
		_SnowBrightnessReduction("Snow Brightness Reduction", Range( -0.5 , 0.5)) = 0.2
		_InitialBend("Wind Initial Bend", Float) = 1
		_Stiffness("Wind Stiffness", Float) = 1
		_Drag("Wind Drag", Float) = 0.2
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "TransparentCutout"  "Queue" = "AlphaTest+0" }
		Cull Back
		CGINCLUDE
		#include "UnityStandardUtils.cginc"
		#include "UnityPBSLighting.cginc"
		#include "Lighting.cginc"
		#pragma target 3.0
		#pragma multi_compile_instancing
		#pragma multi_compile __ _INVERTSNOWMASK_ON
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
			float3 worldNormal;
			INTERNAL_DATA
		};

		uniform float _BumpScale;
		uniform sampler2D _BumpMap;
		uniform sampler2D _MainTex;
		uniform float4 _MainTex_ST;
		uniform float4 _HealthyColor;
		uniform sampler2D _SnowAlbedoRGB;
		uniform float4 _SnowAlbedoRGB_ST;
		uniform float _SnowBrightnessReduction;
		uniform float _SnowNormalPower;
		uniform sampler2D _SnowNormalRGB;
		uniform float _Snow_Amount;
		uniform sampler2D _SnowMaskA;
		uniform float _SnowMaskTreshold;
		uniform float3 _ColorAdjustment;
		uniform float _Smooothness;
		uniform float _AO;
		uniform float _Cutoff = 0.5;

		void surf( Input i , inout SurfaceOutputStandardSpecular o )
		{
			float2 uv0_MainTex = i.uv_texcoord * _MainTex_ST.xy + _MainTex_ST.zw;
			float3 tex2DNode3 = UnpackScaleNormal( tex2D( _BumpMap, uv0_MainTex ), _BumpScale );
			o.Normal = tex2DNode3;
			float4 tex2DNode2 = tex2D( _MainTex, uv0_MainTex );
			float2 uv0_SnowAlbedoRGB = i.uv_texcoord * _SnowAlbedoRGB_ST.xy + _SnowAlbedoRGB_ST.zw;
			float3 appendResult76 = (float3(_SnowBrightnessReduction , _SnowBrightnessReduction , _SnowBrightnessReduction));
			float3 ase_worldNormal = WorldNormalVector( i, float3( 0, 0, 1 ) );
			float3 lerpResult46 = lerp( tex2DNode3 , UnpackScaleNormal( tex2D( _SnowNormalRGB, uv0_SnowAlbedoRGB ), _SnowNormalPower ) , saturate( ( ase_worldNormal * _Snow_Amount ) ));
			float4 tex2DNode68 = tex2D( _SnowMaskA, uv0_MainTex );
			#ifdef _INVERTSNOWMASK_ON
				float staticSwitch125 = ( 1.0 - tex2DNode68.a );
			#else
				float staticSwitch125 = tex2DNode68.a;
			#endif
			float clampResult127 = clamp( ( staticSwitch125 * _SnowMaskTreshold ) , 0.0 , 1.0 );
			float lerpResult67 = lerp( saturate( ( (WorldNormalVector( i , lerpResult46 )).y * _Snow_Amount ) ) , 0.0 , clampResult127);
			float clampResult149 = clamp( _Snow_Amount , 0.1 , 2.0 );
			float lerpResult150 = lerp( 0.0 , lerpResult67 , pow( tex2DNode68.a , ( _SnowMaskTreshold / clampResult149 ) ));
			float4 lerpResult56 = lerp( ( tex2DNode2 * _HealthyColor ) , ( tex2D( _SnowAlbedoRGB, uv0_SnowAlbedoRGB ) - float4( appendResult76 , 0.0 ) ) , lerpResult150);
			o.Albedo = ( lerpResult56 * float4( _ColorAdjustment , 0.0 ) ).rgb;
			float3 temp_cast_3 = (0.0).xxx;
			o.Specular = temp_cast_3;
			o.Smoothness = _Smooothness;
			o.Occlusion = _AO;
			o.Alpha = 1;
			clip( tex2DNode2.a - _Cutoff );
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
				float2 customPack1 : TEXCOORD1;
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
				 AdditionalWind(v);
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