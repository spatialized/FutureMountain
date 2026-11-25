Shader "NatureManufacture/Lit/Lit Top Cover"
{
	Properties
	{
		_BaseColor("Base Color", Color) = (1,1,1,1)
		[Toggle(_PLANARUV1_ON)] _PlanarUV1("PlanarUV", Float) = 0
		[NoScaleOffset]_BaseColorMap("Base Map(RGB) Alpha(A)", 2D) = "white" {}
		[Toggle]_BaseUsePlanarUV("Base Use Planar UV", Float) = 0
		[Toggle]_UV0_UV2("UV0 (T) UV2 (F)", Float) = 1
		_BaseTilingOffset("Base Tiling and Offset", Vector) = (1,1,0,0)
		[NoScaleOffset]_BaseNormalMap("Base Normal Map", 2D) = "bump" {}
		_BaseNormalScale("Base Normal Scale", Range( 0 , 8)) = 1
		[NoScaleOffset]_BaseMaskMap("Base Mask Map MT(R) AO(G) H(B) SM(A)", 2D) = "white" {}
		_BaseMetallic("Base Metallic", Range( 0 , 1)) = 1
		_BaseAORemapMin("Base AO Remap Min", Range( 0 , 1)) = 0
		_BaseAORemapMax("Base AO Remap Max", Range( 0 , 1)) = 1
		_BaseSmoothnessRemapMin("Base Smoothness Remap Min", Range( 0 , 1)) = 0
		_BaseSmoothnessRemapMax("Base Smoothness Remap Max", Range( 0 , 1)) = 1
		[Toggle(_USEDYNAMICCOVERTSTATICMASKF_ON)] _USEDYNAMICCOVERTSTATICMASKF("Use Dynamic Cover (T) Static Mask (F)", Float) = 1
		_CoverMaskA("Cover Mask (A)", 2D) = "white" {}
		_CoverMaskPower("Cover Mask Power", Range( 0 , 10)) = 1
		_Cover_Amount("Cover Amount", Range( 0 , 2)) = 2
		_Cover_Amount_Grow_Speed("Cover Amount Grow Speed", Range( 0 , 3)) = 3
		_Cover_Max_Angle("Cover Max Angle", Range( 0.001 , 90)) = 35
		_Cover_Min_Height("Cover Min Height", Float) = -10000
		_Cover_Min_Height_Blending("Cover Min Height Blending", Range( 0 , 500)) = 1
		_CoverBaseColor("Cover Base Color", Color) = (1,1,1,1)
		[NoScaleOffset]_CoverBaseColorMap("Cover Base Map(RGB)", 2D) = "white" {}
		_CoverTilingOffset("Cover Tiling Offset", Vector) = (1,1,0,0)
		[NoScaleOffset]_CoverNormalMap("Cover Normal Map", 2D) = "bump" {}
		_CoverNormalScale("Cover Normal Scale", Range( 0 , 8)) = 1
		_CoverNormalBlendHardness("Cover Normal Blend Hardness", Range( 0 , 8)) = 1
		_CoverHardness("Cover Hardness", Range( 0 , 10)) = 5
		_CoverHeightMapMin("Cover Height Map Min", Float) = 0
		_CoverHeightMapMax("Cover Height Map Max", Float) = 1
		[Toggle]_CoverUsePlanarUV("Cover Use Planar UV", Float) = 0
		_CoverHeightMapOffset("Cover Height Map Offset", Float) = 0
		[Toggle]_Cover_UV0_UV2("Cover UV0 (T) UV2 (F)", Float) = 1
		[NoScaleOffset]_CoverMaskMap("Cover Mask Map  Mask Map MT(R) AO(G) H(B) SM(A)", 2D) = "white" {}
		_CoverMetallic("Cover Metallic", Range( 0 , 1)) = 1
		_CoverAORemapMin("Cover AO Remap Min", Range( 0 , 1)) = 0
		_CoverAORemapMax("Cover AO Remap Max", Range( 0 , 1)) = 0
		_CoverSmoothnessRemapMin("Cover Smoothness Remap Min", Range( 0 , 1)) = 0
		_CoverSmoothnessRemapMax("Cover Smoothness Remap Max", Range( 0 , 1)) = 1
		_WetColor("Wet Color Vertex(R)", Color) = (0,0,0,0)
		_WetSmoothness("Wet Smoothness Vertex(R)", Range( 0 , 1)) = 1
		[NoScaleOffset]_DetailMap("Detail Map Base (R) Ny(G) Sm(B) Nx(A)", 2D) = "white" {}
		_DetailTilingOffset("Detail Tiling Offset", Vector) = (1,1,0,0)
		_DetailAlbedoScale("Detail Albedo Scale", Range( 0 , 2)) = 0
		_DetailNormalScale("Detail Normal Scale", Range( 0 , 2)) = 0
		_DetailSmoothnessScale("Detail Smoothness Scale", Range( 0 , 2)) = 0
		[HideInInspector] _texcoord3( "", 2D ) = "white" {}
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
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
		#pragma shader_feature_local _USEDYNAMICCOVERTSTATICMASKF_ON
		#define ASE_USING_SAMPLING_MACROS 1
		#if defined(SHADER_API_D3D11) || defined(SHADER_API_XBOXONE) || defined(UNITY_COMPILER_HLSLCC) || defined(SHADER_API_PSSL) || (defined(SHADER_TARGET_SURFACE_ANALYSIS) && !defined(SHADER_TARGET_SURFACE_ANALYSIS_MOJOSHADER))//ASE Sampler Macros
		#define SAMPLE_TEXTURE2D(tex,samplerTex,coord) tex.Sample(samplerTex,coord)
		#else//ASE Sampling Macros
		#define SAMPLE_TEXTURE2D(tex,samplerTex,coord) tex2D(tex,coord)
		#endif//ASE Sampling Macros

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
			float3 worldPos;
			float2 uv3_texcoord3;
			float3 worldNormal;
			INTERNAL_DATA
			float4 vertexColor : COLOR;
		};

		UNITY_DECLARE_TEX2D_NOSAMPLER(_DetailMap);
		uniform float4 _DetailTilingOffset;
		SamplerState sampler_DetailMap;
		uniform float _DetailNormalScale;
		UNITY_DECLARE_TEX2D_NOSAMPLER(_BaseNormalMap);
		uniform float4 _BaseTilingOffset;
		SamplerState sampler_Linear_Repeat;
		uniform float _BaseNormalScale;
		UNITY_DECLARE_TEX2D_NOSAMPLER(_CoverNormalMap);
		uniform float4 _CoverTilingOffset;
		uniform float _CoverNormalScale;
		UNITY_DECLARE_TEX2D_NOSAMPLER(_CoverMaskA);
		SamplerState sampler_CoverMaskA;
		uniform float _CoverMaskPower;
		uniform float _CoverNormalBlendHardness;
		uniform float _Cover_Amount;
		uniform float _Cover_Amount_Grow_Speed;
		uniform float _Cover_Max_Angle;
		uniform float _CoverHardness;
		uniform float _Cover_Min_Height;
		uniform float _Cover_Min_Height_Blending;
		UNITY_DECLARE_TEX2D_NOSAMPLER(_CoverMaskMap);
		uniform float _CoverHeightMapMin;
		uniform float _CoverHeightMapOffset;
		uniform float _CoverHeightMapMax;
		uniform float4 _BaseColor;
		UNITY_DECLARE_TEX2D_NOSAMPLER(_BaseColorMap);
		uniform float _DetailAlbedoScale;
		UNITY_DECLARE_TEX2D_NOSAMPLER(_BaseMaskMap);
		uniform float _BaseSmoothnessRemapMin;
		uniform float _BaseSmoothnessRemapMax;
		uniform float _DetailSmoothnessScale;
		uniform float4 _CoverBaseColor;
		UNITY_DECLARE_TEX2D_NOSAMPLER(_CoverBaseColorMap);
		uniform float _CoverSmoothnessRemapMin;
		uniform float _CoverSmoothnessRemapMax;
		uniform float4 _WetColor;
		uniform float _WetSmoothness;
		uniform float _BaseMetallic;
		uniform float _BaseAORemapMin;
		uniform float _BaseAORemapMax;
		uniform float _CoverMetallic;
		uniform float _CoverAORemapMin;
		uniform float _CoverAORemapMax;

		UNITY_INSTANCING_BUFFER_START(TopCover)
			UNITY_DEFINE_INSTANCED_PROP(float4, _CoverMaskA_ST)
#define _CoverMaskA_ST_arr TopCover
			UNITY_DEFINE_INSTANCED_PROP(float, _BaseUsePlanarUV)
#define _BaseUsePlanarUV_arr TopCover
			UNITY_DEFINE_INSTANCED_PROP(float, _UV0_UV2)
#define _UV0_UV2_arr TopCover
			UNITY_DEFINE_INSTANCED_PROP(float, _CoverUsePlanarUV)
#define _CoverUsePlanarUV_arr TopCover
			UNITY_DEFINE_INSTANCED_PROP(float, _Cover_UV0_UV2)
#define _Cover_UV0_UV2_arr TopCover
		UNITY_INSTANCING_BUFFER_END(TopCover)

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float2 appendResult81 = (float2(_DetailTilingOffset.x , _DetailTilingOffset.y));
			float2 appendResult82 = (float2(_DetailTilingOffset.z , _DetailTilingOffset.w));
			float2 uv_TexCoord85 = i.uv_texcoord * appendResult81 + appendResult82;
			float4 tex2DNode84 = SAMPLE_TEXTURE2D( _DetailMap, sampler_DetailMap, uv_TexCoord85 );
			float2 appendResult93 = (float2(tex2DNode84.g , tex2DNode84.a));
			float2 temp_output_96_0 = ( ( ( appendResult93 * float2( 2,2 ) ) + float2( -1,-1 ) ) * _DetailNormalScale );
			float dotResult98 = dot( temp_output_96_0 , temp_output_96_0 );
			float3 appendResult100 = (float3(temp_output_96_0 , sqrt( ( 1.0 - saturate( dotResult98 ) ) )));
			float _BaseUsePlanarUV_Instance = UNITY_ACCESS_INSTANCED_PROP(_BaseUsePlanarUV_arr, _BaseUsePlanarUV);
			float3 ase_worldPos = i.worldPos;
			float3 break16_g36 = ase_worldPos;
			float2 appendResult17_g36 = (float2(break16_g36.x , break16_g36.z));
			float4 break29_g36 = _BaseTilingOffset;
			float _UV0_UV2_Instance = UNITY_ACCESS_INSTANCED_PROP(_UV0_UV2_arr, _UV0_UV2);
			float2 appendResult24_g36 = (float2(break29_g36.x , break29_g36.y));
			float2 appendResult25_g36 = (float2(break29_g36.z , break29_g36.w));
			float2 uv_TexCoord26_g36 = i.uv_texcoord * appendResult24_g36 + appendResult25_g36;
			float2 uv3_TexCoord49_g36 = i.uv3_texcoord3 * appendResult24_g36 + appendResult25_g36;
			float3 tex2DNode13_g36 = UnpackNormal( SAMPLE_TEXTURE2D( _BaseNormalMap, sampler_Linear_Repeat, ( _BaseUsePlanarUV_Instance == 1.0 ? ( appendResult17_g36 * ( 1.0 / break29_g36.x ) ) : ( _UV0_UV2_Instance == 1.0 ? uv_TexCoord26_g36 : uv3_TexCoord49_g36 ) ) ) );
			float2 appendResult32_g36 = (float2(tex2DNode13_g36.r , tex2DNode13_g36.g));
			float3 ase_worldNormal = WorldNormalVector( i, float3( 0, 0, 1 ) );
			float2 appendResult39_g36 = (float2(sign( ase_worldNormal ).y , 1.0));
			float3 break41_g36 = ase_worldNormal;
			float2 appendResult42_g36 = (float2(break41_g36.x , break41_g36.z));
			float2 break44_g36 = ( ( appendResult32_g36 * appendResult39_g36 ) + appendResult42_g36 );
			float3 appendResult45_g36 = (float3(break44_g36.x , ( tex2DNode13_g36.b * break41_g36.y ) , break44_g36.y));
			float3 ase_worldTangent = WorldNormalVector( i, float3( 1, 0, 0 ) );
			float3 ase_worldBitangent = WorldNormalVector( i, float3( 0, 1, 0 ) );
			float3x3 ase_worldToTangent = float3x3( ase_worldTangent, ase_worldBitangent, ase_worldNormal );
			float3 worldToTangentDir46_g36 = mul( ase_worldToTangent, appendResult45_g36);
			float3 normalizeResult48_g36 = normalize( worldToTangentDir46_g36 );
			#ifdef _PLANARUV1_ON
				float3 staticSwitch31_g36 = normalizeResult48_g36;
			#else
				float3 staticSwitch31_g36 = tex2DNode13_g36;
			#endif
			float3 break31_g38 = staticSwitch31_g36;
			float2 appendResult35_g38 = (float2(break31_g38.x , break31_g38.y));
			float temp_output_38_0_g38 = _BaseNormalScale;
			float lerpResult36_g38 = lerp( 1.0 , break31_g38.z , saturate( temp_output_38_0_g38 ));
			float3 appendResult34_g38 = (float3(( appendResult35_g38 * temp_output_38_0_g38 ) , lerpResult36_g38));
			float3 temp_output_113_0 = BlendNormals( appendResult100 , appendResult34_g38 );
			float _CoverUsePlanarUV_Instance = UNITY_ACCESS_INSTANCED_PROP(_CoverUsePlanarUV_arr, _CoverUsePlanarUV);
			float3 break16_g54 = ase_worldPos;
			float2 appendResult17_g54 = (float2(break16_g54.x , break16_g54.z));
			float4 break29_g54 = _CoverTilingOffset;
			float _Cover_UV0_UV2_Instance = UNITY_ACCESS_INSTANCED_PROP(_Cover_UV0_UV2_arr, _Cover_UV0_UV2);
			float2 appendResult24_g54 = (float2(break29_g54.x , break29_g54.y));
			float2 appendResult25_g54 = (float2(break29_g54.z , break29_g54.w));
			float2 uv_TexCoord26_g54 = i.uv_texcoord * appendResult24_g54 + appendResult25_g54;
			float2 uv3_TexCoord50_g54 = i.uv3_texcoord3 * appendResult24_g54 + appendResult25_g54;
			float3 tex2DNode13_g54 = UnpackNormal( SAMPLE_TEXTURE2D( _CoverNormalMap, sampler_Linear_Repeat, ( _CoverUsePlanarUV_Instance == 1.0 ? ( appendResult17_g54 * ( 1.0 / break29_g54.x ) ) : ( _Cover_UV0_UV2_Instance == 1.0 ? uv_TexCoord26_g54 : uv3_TexCoord50_g54 ) ) ) );
			float2 appendResult32_g54 = (float2(tex2DNode13_g54.r , tex2DNode13_g54.g));
			float2 appendResult39_g54 = (float2(sign( ase_worldNormal ).y , 1.0));
			float3 break41_g54 = ase_worldNormal;
			float2 appendResult42_g54 = (float2(break41_g54.x , break41_g54.z));
			float2 break44_g54 = ( ( appendResult32_g54 * appendResult39_g54 ) + appendResult42_g54 );
			float3 appendResult45_g54 = (float3(break44_g54.x , ( tex2DNode13_g54.b * break41_g54.y ) , break44_g54.y));
			float3 worldToTangentDir46_g54 = mul( ase_worldToTangent, appendResult45_g54);
			float3 normalizeResult48_g54 = normalize( worldToTangentDir46_g54 );
			#ifdef _PLANARUV1_ON
				float3 staticSwitch31_g54 = normalizeResult48_g54;
			#else
				float3 staticSwitch31_g54 = tex2DNode13_g54;
			#endif
			float3 temp_output_178_0 = staticSwitch31_g54;
			float3 break31_g50 = temp_output_178_0;
			float2 appendResult35_g50 = (float2(break31_g50.x , break31_g50.y));
			float temp_output_38_0_g50 = _CoverNormalScale;
			float lerpResult36_g50 = lerp( 1.0 , break31_g50.z , saturate( temp_output_38_0_g50 ));
			float3 appendResult34_g50 = (float3(( appendResult35_g50 * temp_output_38_0_g50 ) , lerpResult36_g50));
			float4 _CoverMaskA_ST_Instance = UNITY_ACCESS_INSTANCED_PROP(_CoverMaskA_ST_arr, _CoverMaskA_ST);
			float2 uv_CoverMaskA = i.uv_texcoord * _CoverMaskA_ST_Instance.xy + _CoverMaskA_ST_Instance.zw;
			float clampResult243 = clamp( ( SAMPLE_TEXTURE2D( _CoverMaskA, sampler_CoverMaskA, uv_CoverMaskA ).a * _CoverMaskPower ) , 0.0 , 1.0 );
			float3 break31_g51 = temp_output_178_0;
			float2 appendResult35_g51 = (float2(break31_g51.x , break31_g51.y));
			float temp_output_38_0_g51 = _CoverNormalBlendHardness;
			float lerpResult36_g51 = lerp( 1.0 , break31_g51.z , saturate( temp_output_38_0_g51 ));
			float3 appendResult34_g51 = (float3(( appendResult35_g51 * temp_output_38_0_g51 ) , lerpResult36_g51));
			float temp_output_187_0 = ( 4.0 - _Cover_Amount_Grow_Speed );
			float clampResult190 = clamp( pow( abs( ( _Cover_Amount / temp_output_187_0 ) ) , temp_output_187_0 ) , 0.0 , 2.0 );
			float clampResult192 = clamp( ase_worldNormal.y , 0.0 , 0.9999 );
			float temp_output_195_0 = ( _Cover_Max_Angle / 45.0 );
			float clampResult198 = clamp( ( clampResult192 - ( 1.0 - temp_output_195_0 ) ) , 0.0 , 2.0 );
			float temp_output_209_0 = ( ( 1.0 - _Cover_Min_Height ) + ase_worldPos.y );
			float clampResult217 = clamp( ( temp_output_209_0 + 1.0 ) , 0.0 , 1.0 );
			float clampResult219 = clamp( ( ( 1.0 - ( ( temp_output_209_0 + _Cover_Min_Height_Blending ) / temp_output_209_0 ) ) + -0.5 ) , 0.0 , 1.0 );
			float clampResult221 = clamp( ( clampResult217 + clampResult219 ) , 0.0 , 1.0 );
			float temp_output_206_0 = ( pow( abs( ( clampResult198 * ( 1.0 / temp_output_195_0 ) ) ) , _CoverHardness ) * clampResult221 );
			float3 lerpResult223 = lerp( temp_output_113_0 , appendResult34_g51 , ( saturate( ( clampResult190 * ase_worldNormal.y ) ) * temp_output_206_0 ));
			float3x3 ase_tangentToWorldFast = float3x3(ase_worldTangent.x,ase_worldBitangent.x,ase_worldNormal.x,ase_worldTangent.y,ase_worldBitangent.y,ase_worldNormal.y,ase_worldTangent.z,ase_worldBitangent.z,ase_worldNormal.z);
			float3 tangentToWorldDir224 = mul( ase_tangentToWorldFast, lerpResult223 );
			float3 break16_g49 = ase_worldPos;
			float2 appendResult17_g49 = (float2(break16_g49.x , break16_g49.z));
			float4 break29_g49 = _CoverTilingOffset;
			float2 appendResult24_g49 = (float2(break29_g49.x , break29_g49.y));
			float2 appendResult25_g49 = (float2(break29_g49.z , break29_g49.w));
			float2 uv_TexCoord26_g49 = i.uv_texcoord * appendResult24_g49 + appendResult25_g49;
			float2 uv3_TexCoord32_g49 = i.uv3_texcoord3 * appendResult24_g49 + appendResult25_g49;
			float4 break158 = SAMPLE_TEXTURE2D( _CoverMaskMap, sampler_Linear_Repeat, ( _CoverUsePlanarUV_Instance == 1.0 ? ( appendResult17_g49 * ( 1.0 / break29_g49.x ) ) : ( _Cover_UV0_UV2_Instance == 1.0 ? uv_TexCoord26_g49 : uv3_TexCoord32_g49 ) ) );
			float clampResult251 = clamp( i.vertexColor.g , 0.0 , 1.0 );
			float clampResult244 = clamp( ( saturate( ( ( ( ( tangentToWorldDir224.y * clampResult190 ) * ( ( _CoverHardness * clampResult190 ) * temp_output_206_0 ) ) * (( _CoverHeightMapMin + _CoverHeightMapOffset ) + (break158.b - 0.0) * (( _CoverHeightMapMax + _CoverHeightMapOffset ) - ( _CoverHeightMapMin + _CoverHeightMapOffset )) / (1.0 - 0.0)) ) * clampResult251 ) ) * clampResult243 ) , 0.0 , 1.0 );
			#ifdef _USEDYNAMICCOVERTSTATICMASKF_ON
				float staticSwitch245 = clampResult244;
			#else
				float staticSwitch245 = clampResult243;
			#endif
			float3 lerpResult247 = lerp( temp_output_113_0 , appendResult34_g50 , staticSwitch245);
			o.Normal = lerpResult247;
			float3 appendResult64 = (float3(_BaseColor.r , _BaseColor.g , _BaseColor.b));
			float3 break16_g35 = ase_worldPos;
			float2 appendResult17_g35 = (float2(break16_g35.x , break16_g35.z));
			float4 break29_g35 = _BaseTilingOffset;
			float2 appendResult24_g35 = (float2(break29_g35.x , break29_g35.y));
			float2 appendResult25_g35 = (float2(break29_g35.z , break29_g35.w));
			float2 uv_TexCoord26_g35 = i.uv_texcoord * appendResult24_g35 + appendResult25_g35;
			float2 uv3_TexCoord31_g35 = i.uv3_texcoord3 * appendResult24_g35 + appendResult25_g35;
			float4 break60 = SAMPLE_TEXTURE2D( _BaseColorMap, sampler_Linear_Repeat, ( _BaseUsePlanarUV_Instance == 1.0 ? ( appendResult17_g35 * ( 1.0 / break29_g35.x ) ) : ( _UV0_UV2_Instance == 1.0 ? uv_TexCoord26_g35 : uv3_TexCoord31_g35 ) ) );
			float3 appendResult61 = (float3(break60.r , break60.g , break60.b));
			float4 break46_g40 = float4( ( appendResult64 * appendResult61 ) , 0.0 );
			float3 appendResult47_g40 = (float3(break46_g40.r , break46_g40.g , break46_g40.b));
			float temp_output_88_0 = ( ( tex2DNode84.r * 2.0 ) + -1.0 );
			float3 temp_cast_1 = (ceil( ( ( sign( temp_output_88_0 ) + 1.0 ) * 0.5 ) )).xxx;
			float temp_output_33_0_g40 = abs( saturate( ( temp_output_88_0 * _DetailAlbedoScale ) ) );
			float clampResult44_g40 = clamp( ( temp_output_33_0_g40 * temp_output_33_0_g40 ) , 0.0 , 1.0 );
			float3 lerpResult38_g40 = lerp( sqrt( appendResult47_g40 ) , temp_cast_1 , clampResult44_g40);
			float3 break16_g37 = ase_worldPos;
			float2 appendResult17_g37 = (float2(break16_g37.x , break16_g37.z));
			float4 break29_g37 = _BaseTilingOffset;
			float2 appendResult24_g37 = (float2(break29_g37.x , break29_g37.y));
			float2 appendResult25_g37 = (float2(break29_g37.z , break29_g37.w));
			float2 uv_TexCoord26_g37 = i.uv_texcoord * appendResult24_g37 + appendResult25_g37;
			float2 uv3_TexCoord31_g37 = i.uv3_texcoord3 * appendResult24_g37 + appendResult25_g37;
			float4 break72 = SAMPLE_TEXTURE2D( _BaseMaskMap, sampler_Linear_Repeat, ( _BaseUsePlanarUV_Instance == 1.0 ? ( appendResult17_g37 * ( 1.0 / break29_g37.x ) ) : ( _UV0_UV2_Instance == 1.0 ? uv_TexCoord26_g37 : uv3_TexCoord31_g37 ) ) );
			float temp_output_107_0 = ( ( tex2DNode84.b * 2.0 ) + -1.0 );
			float lerpResult38_g39 = lerp( (_BaseSmoothnessRemapMin + (break72.a - 0.0) * (_BaseSmoothnessRemapMax - _BaseSmoothnessRemapMin) / (1.0 - 0.0)) , ceil( ( ( sign( temp_output_107_0 ) + 1.0 ) * 0.5 ) ) , abs( saturate( ( temp_output_107_0 * _DetailSmoothnessScale ) ) ));
			float4 appendResult114 = (float4(( lerpResult38_g40 * lerpResult38_g40 ) , lerpResult38_g39));
			float3 appendResult168 = (float3(_CoverBaseColor.r , _CoverBaseColor.g , _CoverBaseColor.b));
			float3 break16_g53 = ase_worldPos;
			float2 appendResult17_g53 = (float2(break16_g53.x , break16_g53.z));
			float4 break29_g53 = _CoverTilingOffset;
			float2 appendResult24_g53 = (float2(break29_g53.x , break29_g53.y));
			float2 appendResult25_g53 = (float2(break29_g53.z , break29_g53.w));
			float2 uv_TexCoord26_g53 = i.uv_texcoord * appendResult24_g53 + appendResult25_g53;
			float2 uv3_TexCoord32_g53 = i.uv3_texcoord3 * appendResult24_g53 + appendResult25_g53;
			float4 break157 = SAMPLE_TEXTURE2D( _CoverBaseColorMap, sampler_Linear_Repeat, ( _CoverUsePlanarUV_Instance == 1.0 ? ( appendResult17_g53 * ( 1.0 / break29_g53.x ) ) : ( _Cover_UV0_UV2_Instance == 1.0 ? uv_TexCoord26_g53 : uv3_TexCoord32_g53 ) ) );
			float3 appendResult153 = (float3(break157.r , break157.g , break157.b));
			float4 appendResult175 = (float4(( appendResult168 * appendResult153 ) , (_CoverSmoothnessRemapMin + (break158.a - 0.0) * (_CoverSmoothnessRemapMax - _CoverSmoothnessRemapMin) / (1.0 - 0.0))));
			float4 lerpResult246 = lerp( appendResult114 , appendResult175 , staticSwitch245);
			float3 appendResult294 = (float3(_WetColor.r , _WetColor.g , _WetColor.b));
			float3 appendResult296 = (float3(lerpResult246.xyz));
			float4 appendResult298 = (float4(( appendResult294 * appendResult296 ) , _WetSmoothness));
			float clampResult306 = clamp( i.vertexColor.r , 0.0 , 1.0 );
			float4 lerpResult300 = lerp( lerpResult246 , appendResult298 , ( 1.0 - clampResult306 ));
			o.Albedo = lerpResult300.xyz;
			float2 appendResult79 = (float2(( break72.r * _BaseMetallic ) , (_BaseAORemapMin + (break72.g - 0.0) * (_BaseAORemapMax - _BaseAORemapMin) / (1.0 - 0.0))));
			float2 appendResult172 = (float2(( break158.r * _CoverMetallic ) , (_CoverAORemapMin + (break158.g - 0.0) * (_CoverAORemapMax - _CoverAORemapMin) / (1.0 - 0.0))));
			float2 lerpResult248 = lerp( appendResult79 , appendResult172 , staticSwitch245);
			float2 break252 = lerpResult248;
			o.Metallic = break252;
			o.Smoothness = lerpResult300.w;
			o.Occlusion = break252.y;
			o.Alpha = 1;
		}

		ENDCG
		CGPROGRAM
		#pragma surface surf Standard keepalpha fullforwardshadows dithercrossfade 

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
				half4 color : COLOR0;
				UNITY_VERTEX_INPUT_INSTANCE_ID
				UNITY_VERTEX_OUTPUT_STEREO
			};
			v2f vert( appdata_full v )
			{
				v2f o;
				UNITY_SETUP_INSTANCE_ID( v );
				UNITY_INITIALIZE_OUTPUT( v2f, o );
				UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO( o );
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
				o.color = v.color;
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
				surfIN.worldPos = worldPos;
				surfIN.worldNormal = float3( IN.tSpace0.z, IN.tSpace1.z, IN.tSpace2.z );
				surfIN.internalSurfaceTtoW0 = IN.tSpace0.xyz;
				surfIN.internalSurfaceTtoW1 = IN.tSpace1.xyz;
				surfIN.internalSurfaceTtoW2 = IN.tSpace2.xyz;
				surfIN.vertexColor = IN.color;
				SurfaceOutputStandard o;
				UNITY_INITIALIZE_OUTPUT( SurfaceOutputStandard, o )
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