Shader "NatureManufacture/Lit/Lit Full Triplanar Cover"
{
	Properties
	{
		_BaseColor("Base Color", Color) = (1,1,1,1)
		_BaseColorMap("Base Map(RGB)", 2D) = "white" {}
		_BaseTilingOffset("Base Tiling and Offset", Vector) = (1,1,0,0)
		_BaseTriplanarThreshold("Base Triplanar Threshold", Range( 1 , 8)) = 5
		_BaseNormalMap("Base Normal Map", 2D) = "bump" {}
		_BaseNormalScale("Base Normal Scale", Range( 0 , 8)) = 1
		_BaseMaskMap("Base Mask Map MT(R) AO(G) H(B) SM(A)", 2D) = "white" {}
		_BaseMetallic("Base Metallic", Range( 0 , 1)) = 1
		_BaseAORemapMin("Base AO Remap Min", Range( 0 , 1)) = 0
		_BaseAORemapMax("Base AO Remap Max", Range( 0 , 1)) = 1
		_BaseSmoothnessRemapMin("Base Smoothness Remap Min", Range( 0 , 1)) = 0
		_BaseSmoothnessRemapMax("Base Smoothness Remap Max", Range( 0 , 1)) = 1
		[Toggle(_USEDYNAMICCOVERTSTATICMASKF_ON)] _USEDYNAMICCOVERTSTATICMASKF("Use Dynamic Cover (T) Static Mask (F)", Float) = 1
		[Toggle(_USECOVERHEIGHTT_ON)] _USECoverHeightT("Use Cover Height (T)", Float) = 1
		_CoverMaskA("Cover Mask (A)", 2D) = "white" {}
		_CoverMaskPower("Cover Mask Power", Range( 0 , 10)) = 1
		_Cover_Amount("Cover Amount", Range( 0 , 2)) = 2
		_Cover_Amount_Grow_Speed("Cover Amount Grow Speed", Range( 0 , 3)) = 3
		_Cover_Max_Angle("Cover Max Angle", Range( 0.001 , 90)) = 35
		_Cover_Min_Height("Cover Min Height", Float) = -10000
		_Cover_Min_Height_Blending("Cover Min Height Blending", Range( 0 , 500)) = 1
		_CoverBaseColor("Cover Base Color", Color) = (1,1,1,1)
		_CoverBaseColorMap("Cover Base Map(RGB)", 2D) = "white" {}
		_CoverTilingOffset("Cover Tiling Offset", Vector) = (1,1,0,0)
		_CoverTriplanarThreshold("Cover Triplanar Threshold", Range( 1 , 8)) = 5
		_CoverNormalMap("Cover Normal Map", 2D) = "bump" {}
		_CoverNormalScale("Cover Normal Scale", Range( 0 , 8)) = 1
		_CoverNormalBlendHardness("Cover Normal Blend Hardness", Range( 0 , 8)) = 1
		_CoverHardness("Cover Hardness", Range( 0 , 10)) = 5
		_CoverHeightMapMin("Cover Height Map Min", Float) = 0
		_CoverHeightMapMax("Cover Height Map Max", Float) = 1
		_CoverHeightMapOffset("Cover Height Map Offset", Float) = 0
		_VertexColorBBlendStrenght("Vertex Color (B) Blend Strenght", Range( 0 , 100)) = 10
		_VertexColorGBlendStrenght("Vertex Color (G) Blend Strenght", Range( 0 , 100)) = 10
		_CoverMaskMap("Cover Mask Map MT(R) AO(G) H(B) SM(A)", 2D) = "white" {}
		_CoverMetallic("Cover Metallic", Range( 0 , 1)) = 1
		_CoverAORemapMin("Cover AO Remap Min", Range( 0 , 1)) = 0
		_CoverAORemapMax("Cover AO Remap Max", Range( 0 , 1)) = 0
		_CoverSmoothnessRemapMin("Cover Smoothness Remap Min", Range( 0 , 1)) = 0
		_CoverSmoothnessRemapMax("Cover Smoothness Remap Max", Range( 0 , 1)) = 1
		[Toggle(_USE_SHAPEHEIGHTBT_STATIC_MASKF_ON)] _Use_ShapeHeightBT_Static_MaskF("Use Shape Height (B) (T) Cover Mask (F)", Float) = 0
		_ShapeNormalMap("Shape Normal", 2D) = "bump" {}
		_shapeNormalScale("Shape Normal Base Scale", Range( 0 , 2)) = 0
		_Shape_Normal_Cover_Scale("Shape Normal Cover Scale", Range( 0 , 2)) = 0
		_ShapeCurvAOHLeaksMask("Shape Curv (R) AO (G) H (B) Leaks Mask (A)", 2D) = "white" {}
		_CurvatureBlend("Curvature Power", Range( 0 , 1)) = 0
		_Shape_AO_Curvature_Reduction("Shape AO Curvature Reduction", Range( 0 , 1)) = 1
		_ShapeAORemapMin("Base Shape AO Remap Min", Range( 0 , 1)) = 0
		_ShapeAORemapMax("Base Shape AO Remap Max", Range( 0 , 1)) = 1
		_ShapeAORemapMin_1("Cover Shape AO Remap Min", Range( 0 , 1)) = 0
		_ShapeAORemapMax_1("Cover Shape AO Remap Max", Range( 0 , 1)) = 1
		_ShapeHeightMapMin("Shape Height Map Min", Float) = 0
		_ShapeHeightMapMax("Shape Height Map Max", Float) = 1
		_ShapeHeightMapOffset("Shape Height Map Offset", Float) = 0
		_LeaksR("Leaks (R)", 2D) = "white" {}
		_BaseLeaksColorMultiply("Base Leaks Color (RGB) Multiply (A)", Color) = (0,0,0,0)
		_CoverLeaksColorMultiply("Cover Leaks Color (RGB) Multiply (A)", Color) = (0,0,0,0)
		[Toggle(LEAKS_UV0_UV2_1_ON)] Leaks_UV0_UV2_1("Leaks UV0 (T) UV2 (F)", Float) = 1
		_LeaksTilingOffset("Leaks Tiling and Offset", Vector) = (1,1,0,0)
		_LeaksSmoothnessMultiply("Base Leaks Smoothness Multiply", Range( 0 , 2)) = 1
		_LeaksSmoothnessMultiply_1("Cover Leaks Smoothness Multiply", Range( 0 , 2)) = 1
		_WetColor("Wet Color Vertex(R)", Color) = (0,0,0,0)
		_WetSmoothness("Wet Smoothness Vertex(R)", Range( 0 , 1)) = 1
		_ShapeTilingOffset("Shape Tiling and Offset", Vector) = (1,1,0,0)
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
		#pragma shader_feature_local _USEDYNAMICCOVERTSTATICMASKF_ON
		#pragma shader_feature_local _USE_SHAPEHEIGHTBT_STATIC_MASKF_ON
		#pragma shader_feature_local _USECOVERHEIGHTT_ON
		#pragma shader_feature_local LEAKS_UV0_UV2_1_ON
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
			float3 worldNormal;
			INTERNAL_DATA
			float4 vertexColor : COLOR;
			float2 uv3_texcoord3;
		};

		UNITY_DECLARE_TEX2D_NOSAMPLER(_ShapeNormalMap);
		uniform float4 _ShapeTilingOffset;
		SamplerState sampler_Linear_Repeat;
		uniform float _shapeNormalScale;
		UNITY_DECLARE_TEX2D_NOSAMPLER(_BaseNormalMap);
		uniform float4 _BaseTilingOffset;
		uniform float _BaseTriplanarThreshold;
		uniform float _BaseNormalScale;
		UNITY_DECLARE_TEX2D_NOSAMPLER(_CoverNormalMap);
		uniform float4 _CoverTilingOffset;
		uniform float _CoverTriplanarThreshold;
		uniform float _CoverNormalScale;
		uniform float _Shape_Normal_Cover_Scale;
		UNITY_DECLARE_TEX2D_NOSAMPLER(_CoverMaskA);
		uniform float4 _CoverMaskA_ST;
		SamplerState sampler_CoverMaskA;
		uniform float _CoverMaskPower;
		UNITY_DECLARE_TEX2D_NOSAMPLER(_ShapeCurvAOHLeaksMask);
		uniform float _ShapeHeightMapMin;
		uniform float _ShapeHeightMapOffset;
		uniform float _ShapeHeightMapMax;
		uniform float _CoverHeightMapMax;
		uniform float _CoverHeightMapOffset;
		UNITY_DECLARE_TEX2D_NOSAMPLER(_CoverMaskMap);
		uniform float _CoverHeightMapMin;
		uniform float _VertexColorBBlendStrenght;
		uniform float _CoverNormalBlendHardness;
		uniform float _Cover_Amount;
		uniform float _Cover_Amount_Grow_Speed;
		uniform float _Cover_Max_Angle;
		uniform float _CoverHardness;
		uniform float _Cover_Min_Height;
		uniform float _Cover_Min_Height_Blending;
		uniform float _VertexColorGBlendStrenght;
		uniform float4 _BaseColor;
		UNITY_DECLARE_TEX2D_NOSAMPLER(_BaseColorMap);
		UNITY_DECLARE_TEX2D_NOSAMPLER(_LeaksR);
		uniform float4 _LeaksTilingOffset;
		SamplerState sampler_LeaksR;
		uniform float4 _BaseLeaksColorMultiply;
		uniform float _ShapeAORemapMin;
		uniform float _ShapeAORemapMax;
		uniform float _Shape_AO_Curvature_Reduction;
		uniform float _CurvatureBlend;
		UNITY_DECLARE_TEX2D_NOSAMPLER(_BaseMaskMap);
		uniform float _BaseSmoothnessRemapMin;
		uniform float _BaseSmoothnessRemapMax;
		uniform float _LeaksSmoothnessMultiply;
		uniform float4 _CoverBaseColor;
		UNITY_DECLARE_TEX2D_NOSAMPLER(_CoverBaseColorMap);
		uniform float4 _CoverLeaksColorMultiply;
		uniform float _CoverSmoothnessRemapMin;
		uniform float _CoverSmoothnessRemapMax;
		uniform float _LeaksSmoothnessMultiply_1;
		uniform float4 _WetColor;
		uniform float _WetSmoothness;
		uniform float _BaseMetallic;
		uniform float _BaseAORemapMin;
		uniform float _BaseAORemapMax;
		uniform float _CoverMetallic;
		uniform float _CoverAORemapMin;
		uniform float _CoverAORemapMax;
		uniform float _ShapeAORemapMin_1;
		uniform float _ShapeAORemapMax_1;

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float2 appendResult81 = (float2(_ShapeTilingOffset.x , _ShapeTilingOffset.y));
			float2 appendResult82 = (float2(_ShapeTilingOffset.z , _ShapeTilingOffset.w));
			float2 uv_TexCoord85 = i.uv_texcoord * appendResult81 + appendResult82;
			float3 tex2DNode84 = UnpackNormal( SAMPLE_TEXTURE2D( _ShapeNormalMap, sampler_Linear_Repeat, uv_TexCoord85 ) );
			float3 break31_g60 = tex2DNode84;
			float2 appendResult35_g60 = (float2(break31_g60.x , break31_g60.y));
			float temp_output_38_0_g60 = _shapeNormalScale;
			float lerpResult36_g60 = lerp( 1.0 , break31_g60.z , saturate( temp_output_38_0_g60 ));
			float3 appendResult34_g60 = (float3(( appendResult35_g60 * temp_output_38_0_g60 ) , lerpResult36_g60));
			float3 ase_worldPos = i.worldPos;
			float3 break16_g67 = ase_worldPos;
			float2 appendResult32_g67 = (float2(break16_g67.x , break16_g67.z));
			float4 temp_output_498_0 = ( float4( 1,1,1,1 ) / _BaseTilingOffset );
			float2 appendResult41_g67 = (float2(temp_output_498_0.xy));
			float3 ase_worldNormal = WorldNormalVector( i, float3( 0, 0, 1 ) );
			float3 break37_g67 = sign( ase_worldNormal );
			float2 appendResult46_g67 = (float2(break37_g67.y , 1.0));
			float3 tex2DNode49_g67 = UnpackNormal( SAMPLE_TEXTURE2D( _BaseNormalMap, sampler_Linear_Repeat, ( ( appendResult32_g67 * appendResult41_g67 ) * appendResult46_g67 ) ) );
			float2 appendResult70_g67 = (float2(tex2DNode49_g67.xy));
			float3 break78_g67 = ase_worldNormal;
			float2 appendResult80_g67 = (float2(break78_g67.x , break78_g67.z));
			float2 break83_g67 = ( ( appendResult70_g67 * appendResult46_g67 ) + appendResult80_g67 );
			float3 appendResult86_g67 = (float3(break83_g67.x , ( tex2DNode49_g67.b * break78_g67.y ) , break83_g67.y));
			float3 temp_cast_2 = (_BaseTriplanarThreshold).xxx;
			float3 temp_output_56_0_g67 = pow( abs( ase_worldNormal ) , temp_cast_2 );
			float3 break59_g67 = ( temp_output_56_0_g67 * temp_output_56_0_g67 );
			float2 appendResult33_g67 = (float2(break16_g67.x , break16_g67.y));
			float2 appendResult47_g67 = (float2(( break37_g67.z * -1.0 ) , 1.0));
			float3 tex2DNode50_g67 = UnpackNormal( SAMPLE_TEXTURE2D( _BaseNormalMap, sampler_Linear_Repeat, ( ( appendResult33_g67 * appendResult41_g67 ) * appendResult47_g67 ) ) );
			float2 appendResult72_g67 = (float2(tex2DNode50_g67.xy));
			float2 appendResult81_g67 = (float2(break78_g67.x , break78_g67.y));
			float2 break84_g67 = ( ( appendResult72_g67 * appendResult47_g67 ) + appendResult81_g67 );
			float3 appendResult87_g67 = (float3(break84_g67.x , break84_g67.y , ( tex2DNode50_g67.b * break78_g67.z )));
			float2 appendResult31_g67 = (float2(break16_g67.z , break16_g67.y));
			float2 appendResult45_g67 = (float2(break37_g67.x , 1.0));
			float3 tex2DNode13_g67 = UnpackNormal( SAMPLE_TEXTURE2D( _BaseNormalMap, sampler_Linear_Repeat, ( ( appendResult31_g67 * appendResult41_g67 ) * appendResult45_g67 ) ) );
			float2 appendResult68_g67 = (float2(tex2DNode13_g67.xy));
			float2 appendResult79_g67 = (float2(break78_g67.z , break78_g67.y));
			float2 break82_g67 = ( ( appendResult68_g67 * appendResult45_g67 ) + appendResult79_g67 );
			float3 appendResult85_g67 = (float3(( tex2DNode13_g67.b * break78_g67.x ) , break82_g67.y , break82_g67.x));
			float3 ase_worldTangent = WorldNormalVector( i, float3( 1, 0, 0 ) );
			float3 ase_worldBitangent = WorldNormalVector( i, float3( 0, 1, 0 ) );
			float3x3 ase_worldToTangent = float3x3( ase_worldTangent, ase_worldBitangent, ase_worldNormal );
			float3 worldToTangentDir92_g67 = mul( ase_worldToTangent, ( ( ( appendResult86_g67 * break59_g67.y ) + ( ( appendResult87_g67 * break59_g67.z ) + ( appendResult85_g67 * break59_g67.x ) ) ) / ( ( break59_g67.x + break59_g67.y ) + break59_g67.z ) ));
			float3 normalizeResult93_g67 = normalize( worldToTangentDir92_g67 );
			float3 break31_g62 = normalizeResult93_g67;
			float2 appendResult35_g62 = (float2(break31_g62.x , break31_g62.y));
			float temp_output_38_0_g62 = _BaseNormalScale;
			float lerpResult36_g62 = lerp( 1.0 , break31_g62.z , saturate( temp_output_38_0_g62 ));
			float3 appendResult34_g62 = (float3(( appendResult35_g62 * temp_output_38_0_g62 ) , lerpResult36_g62));
			float3 temp_output_113_0 = BlendNormals( appendResult34_g60 , appendResult34_g62 );
			float3 break16_g68 = ase_worldPos;
			float2 appendResult32_g68 = (float2(break16_g68.x , break16_g68.z));
			float4 temp_output_497_0 = ( float4( 1,1,1,1 ) / _CoverTilingOffset );
			float2 appendResult41_g68 = (float2(temp_output_497_0.xy));
			float3 break37_g68 = sign( ase_worldNormal );
			float2 appendResult46_g68 = (float2(break37_g68.y , 1.0));
			float3 tex2DNode49_g68 = UnpackNormal( SAMPLE_TEXTURE2D( _CoverNormalMap, sampler_Linear_Repeat, ( ( appendResult32_g68 * appendResult41_g68 ) * appendResult46_g68 ) ) );
			float2 appendResult70_g68 = (float2(tex2DNode49_g68.xy));
			float3 break78_g68 = ase_worldNormal;
			float2 appendResult80_g68 = (float2(break78_g68.x , break78_g68.z));
			float2 break83_g68 = ( ( appendResult70_g68 * appendResult46_g68 ) + appendResult80_g68 );
			float3 appendResult86_g68 = (float3(break83_g68.x , ( tex2DNode49_g68.b * break78_g68.y ) , break83_g68.y));
			float3 temp_cast_7 = (_CoverTriplanarThreshold).xxx;
			float3 temp_output_56_0_g68 = pow( abs( ase_worldNormal ) , temp_cast_7 );
			float3 break59_g68 = ( temp_output_56_0_g68 * temp_output_56_0_g68 );
			float2 appendResult33_g68 = (float2(break16_g68.x , break16_g68.y));
			float2 appendResult47_g68 = (float2(( break37_g68.z * -1.0 ) , 1.0));
			float3 tex2DNode50_g68 = UnpackNormal( SAMPLE_TEXTURE2D( _CoverNormalMap, sampler_Linear_Repeat, ( ( appendResult33_g68 * appendResult41_g68 ) * appendResult47_g68 ) ) );
			float2 appendResult72_g68 = (float2(tex2DNode50_g68.xy));
			float2 appendResult81_g68 = (float2(break78_g68.x , break78_g68.y));
			float2 break84_g68 = ( ( appendResult72_g68 * appendResult47_g68 ) + appendResult81_g68 );
			float3 appendResult87_g68 = (float3(break84_g68.x , break84_g68.y , ( tex2DNode50_g68.b * break78_g68.z )));
			float2 appendResult31_g68 = (float2(break16_g68.z , break16_g68.y));
			float2 appendResult45_g68 = (float2(break37_g68.x , 1.0));
			float3 tex2DNode13_g68 = UnpackNormal( SAMPLE_TEXTURE2D( _CoverNormalMap, sampler_Linear_Repeat, ( ( appendResult31_g68 * appendResult41_g68 ) * appendResult45_g68 ) ) );
			float2 appendResult68_g68 = (float2(tex2DNode13_g68.xy));
			float2 appendResult79_g68 = (float2(break78_g68.z , break78_g68.y));
			float2 break82_g68 = ( ( appendResult68_g68 * appendResult45_g68 ) + appendResult79_g68 );
			float3 appendResult85_g68 = (float3(( tex2DNode13_g68.b * break78_g68.x ) , break82_g68.y , break82_g68.x));
			float3 worldToTangentDir92_g68 = mul( ase_worldToTangent, ( ( ( appendResult86_g68 * break59_g68.y ) + ( ( appendResult87_g68 * break59_g68.z ) + ( appendResult85_g68 * break59_g68.x ) ) ) / ( ( break59_g68.x + break59_g68.y ) + break59_g68.z ) ));
			float3 normalizeResult93_g68 = normalize( worldToTangentDir92_g68 );
			float3 temp_output_307_0 = normalizeResult93_g68;
			float3 break31_g65 = temp_output_307_0;
			float2 appendResult35_g65 = (float2(break31_g65.x , break31_g65.y));
			float temp_output_38_0_g65 = _CoverNormalScale;
			float lerpResult36_g65 = lerp( 1.0 , break31_g65.z , saturate( temp_output_38_0_g65 ));
			float3 appendResult34_g65 = (float3(( appendResult35_g65 * temp_output_38_0_g65 ) , lerpResult36_g65));
			float3 break31_g61 = tex2DNode84;
			float2 appendResult35_g61 = (float2(break31_g61.x , break31_g61.y));
			float temp_output_38_0_g61 = _Shape_Normal_Cover_Scale;
			float lerpResult36_g61 = lerp( 1.0 , break31_g61.z , saturate( temp_output_38_0_g61 ));
			float3 appendResult34_g61 = (float3(( appendResult35_g61 * temp_output_38_0_g61 ) , lerpResult36_g61));
			float3 temp_output_314_0 = appendResult34_g61;
			float3 temp_output_317_0 = BlendNormals( appendResult34_g65 , temp_output_314_0 );
			float2 uv_CoverMaskA = i.uv_texcoord * _CoverMaskA_ST.xy + _CoverMaskA_ST.zw;
			float temp_output_241_0 = ( SAMPLE_TEXTURE2D( _CoverMaskA, sampler_CoverMaskA, uv_CoverMaskA ).a * _CoverMaskPower );
			float4 tex2DNode309 = SAMPLE_TEXTURE2D( _ShapeCurvAOHLeaksMask, sampler_Linear_Repeat, uv_TexCoord85 );
			float temp_output_343_0 = ( _ShapeHeightMapMin + _ShapeHeightMapOffset );
			float temp_output_344_0 = ( _ShapeHeightMapMax + _ShapeHeightMapOffset );
			float temp_output_342_0 = (temp_output_343_0 + (tex2DNode309.b - 0.0) * (temp_output_344_0 - temp_output_343_0) / (1.0 - 0.0));
			#ifdef _USE_SHAPEHEIGHTBT_STATIC_MASKF_ON
				float staticSwitch401 = temp_output_342_0;
			#else
				float staticSwitch401 = temp_output_241_0;
			#endif
			float clampResult243 = clamp( staticSwitch401 , 0.0 , 1.0 );
			float temp_output_233_0 = ( _CoverHeightMapMax + _CoverHeightMapOffset );
			float3 break16_g73 = ase_worldPos;
			float2 appendResult32_g73 = (float2(break16_g73.x , break16_g73.z));
			float2 appendResult41_g73 = (float2(temp_output_497_0.xy));
			float3 break37_g73 = sign( ase_worldNormal );
			float2 appendResult46_g73 = (float2(break37_g73.y , 1.0));
			float4 tex2DNode49_g73 = SAMPLE_TEXTURE2D( _CoverMaskMap, sampler_Linear_Repeat, ( ( appendResult32_g73 * appendResult41_g73 ) * appendResult46_g73 ) );
			float3 temp_cast_11 = (_CoverTriplanarThreshold).xxx;
			float3 temp_output_56_0_g73 = pow( abs( ase_worldNormal ) , temp_cast_11 );
			float3 break59_g73 = ( temp_output_56_0_g73 * temp_output_56_0_g73 );
			float2 appendResult33_g73 = (float2(break16_g73.x , break16_g73.y));
			float2 appendResult47_g73 = (float2(( break37_g73.z * -1.0 ) , 1.0));
			float4 tex2DNode50_g73 = SAMPLE_TEXTURE2D( _CoverMaskMap, sampler_Linear_Repeat, ( ( appendResult33_g73 * appendResult41_g73 ) * appendResult47_g73 ) );
			float2 appendResult31_g73 = (float2(break16_g73.z , break16_g73.y));
			float2 appendResult45_g73 = (float2(break37_g73.x , 1.0));
			float4 tex2DNode13_g73 = SAMPLE_TEXTURE2D( _CoverMaskMap, sampler_Linear_Repeat, ( ( appendResult31_g73 * appendResult41_g73 ) * appendResult45_g73 ) );
			float4 break158 = ( ( ( tex2DNode49_g73 * break59_g73.y ) + ( ( tex2DNode50_g73 * break59_g73.z ) + ( tex2DNode13_g73 * break59_g73.x ) ) ) / ( ( break59_g73.x + break59_g73.y ) + break59_g73.z ) );
			float temp_output_232_0 = ( _CoverHeightMapMin + _CoverHeightMapOffset );
			#ifdef _USECOVERHEIGHTT_ON
				float staticSwitch407 = (temp_output_232_0 + (break158.b - 0.0) * (temp_output_233_0 - temp_output_232_0) / (1.0 - 0.0));
			#else
				float staticSwitch407 = temp_output_233_0;
			#endif
			float clampResult501 = clamp( i.vertexColor.b , 0.0 , 1.0 );
			float2 appendResult422 = (float2(temp_output_343_0 , temp_output_344_0));
			float2 break420 = appendResult422;
			float2 break426 = ( appendResult422 + abs( ( ( break420.y - break420.x ) * clampResult501 ) ) );
			float clampResult427 = clamp( (break426.x + (tex2DNode309.b - 0.0) * (break426.y - break426.x) / (1.0 - 0.0)) , 0.0 , 1.0 );
			float2 appendResult431 = (float2(temp_output_232_0 , temp_output_233_0));
			float2 break430 = appendResult431;
			float2 break437 = ( appendResult431 + abs( ( clampResult501 * ( break430.y - break430.x ) ) ) );
			#ifdef _USECOVERHEIGHTT_ON
				float staticSwitch447 = (break437.x + (break158.b - 0.0) * (break437.y - break437.x) / (1.0 - 0.0));
			#else
				float staticSwitch447 = clampResult501;
			#endif
			float clampResult439 = clamp( staticSwitch447 , 0.0 , 1.0 );
			#ifdef _USE_SHAPEHEIGHTBT_STATIC_MASKF_ON
				float staticSwitch440 = clampResult439;
			#else
				float staticSwitch440 = ( clampResult427 * clampResult439 );
			#endif
			float clampResult446 = clamp( ( ( 1.0 - clampResult501 ) > 0.99 ? 0.0 : pow( abs( saturate( staticSwitch440 ) ) , _VertexColorBBlendStrenght ) ) , 0.0 , 1.0 );
			float3 break31_g66 = temp_output_307_0;
			float2 appendResult35_g66 = (float2(break31_g66.x , break31_g66.y));
			float temp_output_38_0_g66 = _CoverNormalBlendHardness;
			float lerpResult36_g66 = lerp( 1.0 , break31_g66.z , saturate( temp_output_38_0_g66 ));
			float3 appendResult34_g66 = (float3(( appendResult35_g66 * temp_output_38_0_g66 ) , lerpResult36_g66));
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
			float3 lerpResult223 = lerp( temp_output_113_0 , BlendNormals( appendResult34_g66 , temp_output_314_0 ) , ( saturate( ( clampResult190 * ase_worldNormal.y ) ) * temp_output_206_0 ));
			float3x3 ase_tangentToWorldFast = float3x3(ase_worldTangent.x,ase_worldBitangent.x,ase_worldNormal.x,ase_worldTangent.y,ase_worldBitangent.y,ase_worldNormal.y,ase_worldTangent.z,ase_worldBitangent.z,ase_worldNormal.z);
			float3 tangentToWorldDir224 = mul( ase_tangentToWorldFast, lerpResult223 );
			float temp_output_226_0 = ( ( tangentToWorldDir224.y * clampResult190 ) * ( ( _CoverHardness * clampResult190 ) * temp_output_206_0 ) );
			float clampResult405 = clamp( ( saturate( temp_output_226_0 ) * temp_output_342_0 ) , 0.0 , 1.0 );
			#ifdef _USE_SHAPEHEIGHTBT_STATIC_MASKF_ON
				float staticSwitch402 = clampResult405;
			#else
				float staticSwitch402 = temp_output_241_0;
			#endif
			float clampResult412 = clamp( staticSwitch402 , 0.0 , 1.0 );
			float clampResult244 = clamp( ( clampResult412 * saturate( ( ( temp_output_226_0 * staticSwitch407 ) * clampResult446 ) ) ) , 0.0 , 1.0 );
			#ifdef _USEDYNAMICCOVERTSTATICMASKF_ON
				float staticSwitch245 = clampResult244;
			#else
				float staticSwitch245 = ( clampResult243 * saturate( ( staticSwitch407 * clampResult446 ) ) );
			#endif
			float3 lerpResult247 = lerp( temp_output_113_0 , temp_output_317_0 , staticSwitch245);
			float clampResult502 = clamp( i.vertexColor.g , 0.0 , 1.0 );
			float2 appendResult455 = (float2(temp_output_343_0 , temp_output_344_0));
			float2 break454 = appendResult455;
			float clampResult503 = clamp( i.vertexColor.g , 0.0 , 1.0 );
			float clampResult477 = clamp( ( 1.0 - clampResult503 ) , 0.0 , 1.0 );
			float2 break465 = ( appendResult455 + abs( ( ( break454.y - break454.x ) * clampResult477 ) ) );
			float clampResult468 = clamp( (break465.x + (tex2DNode309.b - 0.0) * (break465.y - break465.x) / (1.0 - 0.0)) , 0.0 , 1.0 );
			float2 appendResult462 = (float2(temp_output_232_0 , temp_output_233_0));
			float2 break460 = appendResult462;
			float2 break476 = ( appendResult462 + abs( ( clampResult477 * ( break460.y - break460.x ) ) ) );
			#ifdef _USECOVERHEIGHTT_ON
				float staticSwitch474 = (break476.x + (break158.b - 0.0) * (break476.y - break476.x) / (1.0 - 0.0));
			#else
				float staticSwitch474 = clampResult502;
			#endif
			float clampResult473 = clamp( staticSwitch474 , 0.0 , 1.0 );
			#ifdef _USE_SHAPEHEIGHTBT_STATIC_MASKF_ON
				float staticSwitch483 = clampResult473;
			#else
				float staticSwitch483 = ( clampResult468 * clampResult473 );
			#endif
			float clampResult472 = clamp( ( clampResult502 > 0.99 ? 0.0 : pow( abs( saturate( staticSwitch483 ) ) , _VertexColorGBlendStrenght ) ) , 0.0 , 1.0 );
			float HeightLerp491 = clampResult472;
			float3 lerpResult489 = lerp( lerpResult247 , temp_output_317_0 , HeightLerp491);
			o.Normal = lerpResult489;
			float3 appendResult64 = (float3(_BaseColor.r , _BaseColor.g , _BaseColor.b));
			float3 break16_g70 = ase_worldPos;
			float2 appendResult32_g70 = (float2(break16_g70.x , break16_g70.z));
			float2 appendResult41_g70 = (float2(temp_output_498_0.xy));
			float3 break37_g70 = sign( ase_worldNormal );
			float2 appendResult46_g70 = (float2(break37_g70.y , 1.0));
			float4 tex2DNode49_g70 = SAMPLE_TEXTURE2D( _BaseColorMap, sampler_Linear_Repeat, ( ( appendResult32_g70 * appendResult41_g70 ) * appendResult46_g70 ) );
			float3 temp_cast_13 = (_BaseTriplanarThreshold).xxx;
			float3 temp_output_56_0_g70 = pow( abs( ase_worldNormal ) , temp_cast_13 );
			float3 break59_g70 = ( temp_output_56_0_g70 * temp_output_56_0_g70 );
			float2 appendResult33_g70 = (float2(break16_g70.x , break16_g70.y));
			float2 appendResult47_g70 = (float2(( break37_g70.z * -1.0 ) , 1.0));
			float4 tex2DNode50_g70 = SAMPLE_TEXTURE2D( _BaseColorMap, sampler_Linear_Repeat, ( ( appendResult33_g70 * appendResult41_g70 ) * appendResult47_g70 ) );
			float2 appendResult31_g70 = (float2(break16_g70.z , break16_g70.y));
			float2 appendResult45_g70 = (float2(break37_g70.x , 1.0));
			float4 tex2DNode13_g70 = SAMPLE_TEXTURE2D( _BaseColorMap, sampler_Linear_Repeat, ( ( appendResult31_g70 * appendResult41_g70 ) * appendResult45_g70 ) );
			float4 break60 = ( ( ( tex2DNode49_g70 * break59_g70.y ) + ( ( tex2DNode50_g70 * break59_g70.z ) + ( tex2DNode13_g70 * break59_g70.x ) ) ) / ( ( break59_g70.x + break59_g70.y ) + break59_g70.z ) );
			float3 appendResult61 = (float3(break60.r , break60.g , break60.b));
			float3 temp_output_63_0 = ( appendResult64 * appendResult61 );
			float2 appendResult354 = (float2(_LeaksTilingOffset.x , _LeaksTilingOffset.y));
			float2 appendResult355 = (float2(_LeaksTilingOffset.z , _LeaksTilingOffset.w));
			float2 uv3_TexCoord358 = i.uv3_texcoord3 * appendResult354 + appendResult355;
			float2 uv_TexCoord357 = i.uv_texcoord * appendResult354 + appendResult355;
			#ifdef LEAKS_UV0_UV2_1_ON
				float2 staticSwitch359 = uv_TexCoord357;
			#else
				float2 staticSwitch359 = uv3_TexCoord358;
			#endif
			float LeaksRvalue362 = SAMPLE_TEXTURE2D( _LeaksR, sampler_LeaksR, staticSwitch359 ).r;
			float4 lerpResult364 = lerp( ( ( 1.0 - LeaksRvalue362 ) * _BaseLeaksColorMultiply ) , float4( 1,1,1,1 ) , LeaksRvalue362);
			float clampResult373 = clamp( ( saturate( _BaseLeaksColorMultiply.a ) * ( 1.0 - tex2DNode309.a ) ) , 0.0 , 1.0 );
			float4 lerpResult374 = lerp( float4( temp_output_63_0 , 0.0 ) , ( lerpResult364 * float4( temp_output_63_0 , 0.0 ) ) , clampResult373);
			float4 temp_cast_16 = (( ( 1.0 - tex2DNode309.r ) - 0.5 )).xxxx;
			float temp_output_326_0 = (_ShapeAORemapMin + (tex2DNode309.g - 0.0) * (_ShapeAORemapMax - _ShapeAORemapMin) / (1.0 - 0.0));
			float4 temp_cast_17 = (temp_output_326_0).xxxx;
			float4 blendOpSrc325 = saturate( ( ( lerpResult374 - temp_cast_16 ) + ( tex2DNode309.r - 0.5 ) ) );
			float4 blendOpDest325 = temp_cast_17;
			float4 lerpBlendMode325 = lerp(blendOpDest325,( blendOpSrc325 * blendOpDest325 ),_Shape_AO_Curvature_Reduction);
			float4 lerpResult340 = lerp( lerpResult374 , ( saturate( lerpBlendMode325 )) , _CurvatureBlend);
			float3 appendResult375 = (float3(lerpResult340.rgb));
			float3 break16_g69 = ase_worldPos;
			float2 appendResult32_g69 = (float2(break16_g69.x , break16_g69.z));
			float2 appendResult41_g69 = (float2(temp_output_498_0.xy));
			float3 break37_g69 = sign( ase_worldNormal );
			float2 appendResult46_g69 = (float2(break37_g69.y , 1.0));
			float4 tex2DNode49_g69 = SAMPLE_TEXTURE2D( _BaseMaskMap, sampler_Linear_Repeat, ( ( appendResult32_g69 * appendResult41_g69 ) * appendResult46_g69 ) );
			float3 temp_cast_20 = (_BaseTriplanarThreshold).xxx;
			float3 temp_output_56_0_g69 = pow( abs( ase_worldNormal ) , temp_cast_20 );
			float3 break59_g69 = ( temp_output_56_0_g69 * temp_output_56_0_g69 );
			float2 appendResult33_g69 = (float2(break16_g69.x , break16_g69.y));
			float2 appendResult47_g69 = (float2(( break37_g69.z * -1.0 ) , 1.0));
			float4 tex2DNode50_g69 = SAMPLE_TEXTURE2D( _BaseMaskMap, sampler_Linear_Repeat, ( ( appendResult33_g69 * appendResult41_g69 ) * appendResult47_g69 ) );
			float2 appendResult31_g69 = (float2(break16_g69.z , break16_g69.y));
			float2 appendResult45_g69 = (float2(break37_g69.x , 1.0));
			float4 tex2DNode13_g69 = SAMPLE_TEXTURE2D( _BaseMaskMap, sampler_Linear_Repeat, ( ( appendResult31_g69 * appendResult41_g69 ) * appendResult45_g69 ) );
			float4 break72 = ( ( ( tex2DNode49_g69 * break59_g69.y ) + ( ( tex2DNode50_g69 * break59_g69.z ) + ( tex2DNode13_g69 * break59_g69.x ) ) ) / ( ( break59_g69.x + break59_g69.y ) + break59_g69.z ) );
			float temp_output_65_0 = (_BaseSmoothnessRemapMin + (break72.a - 0.0) * (_BaseSmoothnessRemapMax - _BaseSmoothnessRemapMin) / (1.0 - 0.0));
			float lerpResult377 = lerp( ( temp_output_65_0 * _LeaksSmoothnessMultiply ) , temp_output_65_0 , LeaksRvalue362);
			float lerpResult380 = lerp( temp_output_65_0 , lerpResult377 , clampResult373);
			float clampResult381 = clamp( lerpResult380 , 0.0 , 1.0 );
			float4 appendResult114 = (float4(appendResult375 , clampResult381));
			float3 appendResult168 = (float3(_CoverBaseColor.r , _CoverBaseColor.g , _CoverBaseColor.b));
			float3 break16_g72 = ase_worldPos;
			float2 appendResult32_g72 = (float2(break16_g72.x , break16_g72.z));
			float2 appendResult41_g72 = (float2(temp_output_497_0.xy));
			float3 break37_g72 = sign( ase_worldNormal );
			float2 appendResult46_g72 = (float2(break37_g72.y , 1.0));
			float4 tex2DNode49_g72 = SAMPLE_TEXTURE2D( _CoverBaseColorMap, sampler_Linear_Repeat, ( ( appendResult32_g72 * appendResult41_g72 ) * appendResult46_g72 ) );
			float3 temp_cast_22 = (_CoverTriplanarThreshold).xxx;
			float3 temp_output_56_0_g72 = pow( abs( ase_worldNormal ) , temp_cast_22 );
			float3 break59_g72 = ( temp_output_56_0_g72 * temp_output_56_0_g72 );
			float2 appendResult33_g72 = (float2(break16_g72.x , break16_g72.y));
			float2 appendResult47_g72 = (float2(( break37_g72.z * -1.0 ) , 1.0));
			float4 tex2DNode50_g72 = SAMPLE_TEXTURE2D( _CoverBaseColorMap, sampler_Linear_Repeat, ( ( appendResult33_g72 * appendResult41_g72 ) * appendResult47_g72 ) );
			float2 appendResult31_g72 = (float2(break16_g72.z , break16_g72.y));
			float2 appendResult45_g72 = (float2(break37_g72.x , 1.0));
			float4 tex2DNode13_g72 = SAMPLE_TEXTURE2D( _CoverBaseColorMap, sampler_Linear_Repeat, ( ( appendResult31_g72 * appendResult41_g72 ) * appendResult45_g72 ) );
			float4 break157 = ( ( ( tex2DNode49_g72 * break59_g72.y ) + ( ( tex2DNode50_g72 * break59_g72.z ) + ( tex2DNode13_g72 * break59_g72.x ) ) ) / ( ( break59_g72.x + break59_g72.y ) + break59_g72.z ) );
			float3 appendResult153 = (float3(break157.r , break157.g , break157.b));
			float3 temp_output_159_0 = ( appendResult168 * appendResult153 );
			float4 lerpResult387 = lerp( ( ( 1.0 - LeaksRvalue362 ) * _CoverLeaksColorMultiply ) , float4( 1,1,1,1 ) , LeaksRvalue362);
			float clampResult390 = clamp( ( saturate( _CoverLeaksColorMultiply.a ) * 0.0 ) , 0.0 , 1.0 );
			float4 lerpResult391 = lerp( float4( temp_output_159_0 , 0.0 ) , ( lerpResult387 * float4( temp_output_159_0 , 0.0 ) ) , clampResult390);
			float temp_output_154_0 = (_CoverSmoothnessRemapMin + (break158.a - 0.0) * (_CoverSmoothnessRemapMax - _CoverSmoothnessRemapMin) / (1.0 - 0.0));
			float lerpResult398 = lerp( ( temp_output_154_0 * _LeaksSmoothnessMultiply_1 ) , temp_output_154_0 , LeaksRvalue362);
			float lerpResult399 = lerp( temp_output_154_0 , lerpResult398 , clampResult390);
			float clampResult394 = clamp( lerpResult399 , 0.0 , 1.0 );
			float4 appendResult175 = (float4(lerpResult391.rgb , clampResult394));
			float4 lerpResult246 = lerp( appendResult114 , appendResult175 , staticSwitch245);
			float4 lerpResult488 = lerp( lerpResult246 , appendResult175 , HeightLerp491);
			float3 appendResult294 = (float3(_WetColor.r , _WetColor.g , _WetColor.b));
			float3 appendResult296 = (float3(lerpResult488.xyz));
			float4 appendResult298 = (float4(( appendResult294 * appendResult296 ) , _WetSmoothness));
			float clampResult132 = clamp( i.vertexColor.r , 0.0 , 1.0 );
			float4 lerpResult300 = lerp( lerpResult488 , appendResult298 , ( 1.0 - clampResult132 ));
			o.Albedo = lerpResult300.xyz;
			float2 appendResult79 = (float2(( break72.r * _BaseMetallic ) , ( (_BaseAORemapMin + (break72.g - 0.0) * (_BaseAORemapMax - _BaseAORemapMin) / (1.0 - 0.0)) * temp_output_326_0 )));
			float2 appendResult172 = (float2(( break158.r * _CoverMetallic ) , ( (_CoverAORemapMin + (break158.g - 0.0) * (_CoverAORemapMax - _CoverAORemapMin) / (1.0 - 0.0)) * (_ShapeAORemapMin_1 + (tex2DNode309.g - 0.0) * (_ShapeAORemapMax_1 - _ShapeAORemapMin_1) / (1.0 - 0.0)) )));
			float2 lerpResult248 = lerp( appendResult79 , appendResult172 , staticSwitch245);
			float2 lerpResult490 = lerp( lerpResult248 , appendResult172 , HeightLerp491);
			float2 break252 = lerpResult490;
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