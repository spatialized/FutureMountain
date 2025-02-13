Shader "NatureManufacture Shaders/Water River Tesseled"
{
	Properties
	{
		[HideInInspector] __dirty( "", Int ) = 1
		_Cutoff( "Mask Clip Value", Float ) = 0.5
		_UVVDirection1UDirection0("UV - V Direction (1) U Direction (0)", Int) = 0
		_WaterMainSpeed("Water Main Speed", Vector) = (0.01,0,0,0)
		_WaterMixSpeed("Water Mix Speed", Vector) = (0.01,0.05,0,0)
		_SmallCascadeMainSpeed("Small Cascade Main Speed", Vector) = (0,0.08,0,0)
		_SmallCascadeMixSpeed("Small Cascade Mix Speed", Vector) = (0.04,0.08,0,0)
		_BigCascadeMainSpeed("Big Cascade Main Speed", Vector) = (0,0.24,0,0)
		_BigCascadeMixSpeed("Big Cascade Mix Speed", Vector) = (0.02,0.28,0,0)
		_WaterDepth("Water Depth", Range( 0 , 1)) = 0
		_ShalowFalloff("Shalow Falloff", Float) = 0
		_ShalowDepth("Shalow Depth", Float) = 0
		_ShalowColor("Shalow Color", Color) = (1,1,1,0)
		_DeepColor("Deep Color", Color) = (0,0,0,0)
		_WaterDeepTranslucencyPower("Water Deep Translucency Power", Range( 0 , 10)) = 1
		_WaterShalowTranslucencyPower("Water Shalow Translucency Power", Range( 0 , 10)) = 1
		_WaterSpecular("Water Specular", Range( 0 , 1)) = 0
		_WaterSmoothness("Water Smoothness", Float) = 0
		_Distortion("Distortion", Float) = 0.5
		_WaterFalloffBorder("Water Falloff Border", Range( 0 , 10)) = 0
		_WaterNormal("Water Normal", 2D) = "bump" {}
		_NormalScale("Normal Scale", Float) = 0
		_WaterTesselation("Water Tesselation", 2D) = "black" {}
		_WaterTessScale("Water Tess Scale", Float) = 0
		_SmallCascadeAngle("Small Cascade Angle", Range( 0.001 , 90)) = 90
		_SmallCascadeAngleFalloff("Small Cascade Angle Falloff", Range( 0 , 80)) = 5
		_SmallCascadeNormal("Small Cascade Normal", 2D) = "bump" {}
		_SmallCascadeNormalScale("Small Cascade Normal Scale", Float) = 0
		_SmallCascadeWaterTess("Small Cascade Water Tess", 2D) = "white" {}
		_SmallCascadeWaterTessScale("Small Cascade Water Tess Scale", Float) = 0
		_SmallCascade("Small Cascade", 2D) = "white" {}
		_SmallCascadeColor("Small Cascade Color", Vector) = (1,1,1,0)
		_SmallCascadeFoamFalloff("Small Cascade Foam Falloff", Range( 0 , 10)) = 0
		_SmallCascadeSmoothness("Small Cascade Smoothness", Float) = 0
		_SmallCascadeSpecular("Small Cascade Specular", Range( 0 , 1)) = 0
		_BigCascadeAngle("Big Cascade Angle", Range( 0.001 , 90)) = 90
		_BigCascadeAngleFalloff("Big Cascade Angle Falloff", Range( 0 , 80)) = 15
		_BigCascadeNormal("Big Cascade Normal", 2D) = "bump" {}
		_BigCascadeNormalScale("Big Cascade Normal Scale", Float) = 0
		_BigCascadeWaterTess("Big Cascade Water Tess", 2D) = "black" {}
		_BigCascadeWaterTessScale("Big Cascade Water Tess Scale", Float) = 0
		_BigCascade("Big Cascade", 2D) = "white" {}
		_BigCascadeColor("Big Cascade Color", Vector) = (1,1,1,0)
		_BigCascadeFoamFalloff("Big Cascade Foam Falloff", Range( 0 , 10)) = 0
		_BigCascadeSmoothness("Big Cascade Smoothness", Float) = 0
		_BigCascadeSpecular("Big Cascade Specular", Range( 0 , 1)) = 0
		_Noise("Noise", 2D) = "white" {}
		_CascadesNoisePower("Cascades Noise Power", Range( 0 , 10)) = 2.71
		_NoiseSpeed("Noise Speed", Vector) = (-0.2,-0.5,0,0)
		_Foam("Foam", 2D) = "white" {}
		_FoamSpeed("Foam Speed", Vector) = (-0.001,0.018,0,0)
		_FoamColor("Foam Color", Vector) = (1,1,1,0)
		_FoamDepth("Foam Depth", Range( -100 , 100)) = 0
		_FoamFalloff("Foam Falloff", Range( -100 , 1)) = 0
		_FoamSpecular("Foam Specular", Range( 0 , 1)) = 0
		_FoamSmoothness("Foam Smoothness", Float) = 0
		_AOPower("AO Power", Range( 0 , 1)) = 1
		_TessValue( "Max Tessellation", Range( 1, 32 ) ) = 25
		_TessMin( "Tess Min Distance", Float ) = 0
		_TessMax( "Tess Max Distance", Float ) = 20
		_TessPhongStrength( "Phong Tess Strength", Range( 0, 1 ) ) = 0.57
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
	}

	SubShader
	{
		Tags{ "RenderType" = "Transparent"  "Queue" = "Geometry+1001" "IgnoreProjector" = "True" "IsEmissive" = "true"  }
		Cull Off
		ZTest LEqual
		Blend SrcAlpha OneMinusSrcAlpha , SrcAlpha OneMinusSrcAlpha
		BlendOp Add , Add
		GrabPass{ "_WaterGrab" }
		CGPROGRAM
		#include "UnityStandardUtils.cginc"
		#include "UnityShaderVariables.cginc"
		#include "UnityCG.cginc"
		#include "Tessellation.cginc"
		#pragma target 4.6
		#pragma multi_compile_instancing
		#pragma surface surf StandardSpecular keepalpha vertex:vertexDataFunc tessellate:tessFunction tessphong:_TessPhongStrength 
		struct Input
		{
			float2 uv_texcoord;
			float3 worldNormal;
			INTERNAL_DATA
			float4 screenPos;
		};

		struct appdata
		{
			float4 vertex : POSITION;
			float4 tangent : TANGENT;
			float3 normal : NORMAL;
			float4 texcoord : TEXCOORD0;
			float4 texcoord1 : TEXCOORD1;
			float4 texcoord2 : TEXCOORD2;
			float4 texcoord3 : TEXCOORD3;
			fixed4 color : COLOR;
			UNITY_VERTEX_INPUT_INSTANCE_ID
		};

		uniform half _NormalScale;
		uniform sampler2D _WaterNormal;
		uniform int _UVVDirection1UDirection0;
		uniform half2 _WaterMixSpeed;
		uniform float4 _WaterNormal_ST;
		uniform half2 _WaterMainSpeed;
		uniform half _SmallCascadeNormalScale;
		uniform sampler2D _SmallCascadeNormal;
		uniform half2 _SmallCascadeMixSpeed;
		uniform float4 _SmallCascadeNormal_ST;
		uniform half2 _SmallCascadeMainSpeed;
		uniform fixed _SmallCascadeAngle;
		uniform half _SmallCascadeAngleFalloff;
		uniform half _BigCascadeNormalScale;
		uniform sampler2D _BigCascadeNormal;
		uniform half2 _BigCascadeMixSpeed;
		uniform float4 _BigCascadeNormal_ST;
		uniform half2 _BigCascadeMainSpeed;
		uniform fixed _BigCascadeAngle;
		uniform half _BigCascadeAngleFalloff;
		uniform sampler2D _WaterGrab;
		uniform half _Distortion;
		uniform half4 _DeepColor;
		uniform half4 _ShalowColor;
		uniform sampler2D _CameraDepthTexture;
		uniform half _ShalowDepth;
		uniform half _ShalowFalloff;
		uniform half3 _FoamColor;
		uniform half _FoamDepth;
		uniform half _FoamFalloff;
		uniform sampler2D _Foam;
		uniform half2 _FoamSpeed;
		uniform float4 _Foam_ST;
		uniform sampler2D _SmallCascade;
		uniform sampler2D _Noise;
		uniform half2 _NoiseSpeed;
		uniform float4 _Noise_ST;
		uniform half _CascadesNoisePower;
		uniform half3 _SmallCascadeColor;
		uniform half _SmallCascadeFoamFalloff;
		uniform sampler2D _BigCascade;
		uniform half3 _BigCascadeColor;
		uniform half _BigCascadeFoamFalloff;
		uniform half _WaterDeepTranslucencyPower;
		uniform half _WaterShalowTranslucencyPower;
		uniform half _WaterSpecular;
		uniform half _FoamSpecular;
		uniform half _SmallCascadeSpecular;
		uniform half _BigCascadeSpecular;
		uniform half _WaterSmoothness;
		uniform half _FoamSmoothness;
		uniform half _SmallCascadeSmoothness;
		uniform half _BigCascadeSmoothness;
		uniform half _AOPower;
		uniform half _WaterDepth;
		uniform half _WaterFalloffBorder;
		uniform half _WaterTessScale;
		uniform sampler2D _WaterTesselation;
		uniform sampler2D _SmallCascadeWaterTess;
		uniform half _SmallCascadeWaterTessScale;
		uniform half _BigCascadeWaterTessScale;
		uniform sampler2D _BigCascadeWaterTess;
		uniform float _Cutoff = 0.5;
		uniform half _TessValue;
		uniform half _TessMin;
		uniform half _TessMax;
		uniform half _TessPhongStrength;

		float4 tessFunction( appdata v0, appdata v1, appdata v2 )
		{
			return UnityDistanceBasedTess( v0.vertex, v1.vertex, v2.vertex, _TessMin, _TessMax, _TessValue );
		}

		void vertexDataFunc( inout appdata v )
		{
			int Direction723 = _UVVDirection1UDirection0;
			float2 appendResult706 = (half2(_WaterMixSpeed.y , _WaterMixSpeed.x));
			float2 uv_WaterNormal20 = v.texcoord;
			uv_WaterNormal20.xy = v.texcoord.xy * _WaterNormal_ST.xy + _WaterNormal_ST.zw;
			float2 panner612 = ( uv_WaterNormal20 + _Time.y * (( (float)Direction723 == 1.0 ) ? _WaterMixSpeed :  appendResult706 ));
			float2 WaterSpeedValueMix516 = panner612;
			float2 appendResult705 = (half2(_WaterMainSpeed.y , _WaterMainSpeed.x));
			float2 panner611 = ( uv_WaterNormal20 + _Time.y * (( (float)Direction723 == 1.0 ) ? _WaterMainSpeed :  appendResult705 ));
			float2 WaterSpeedValueMain614 = panner611;
			float2 appendResult709 = (half2(_SmallCascadeMixSpeed.y , _SmallCascadeMixSpeed.x));
			float2 uv_SmallCascadeNormal20 = v.texcoord;
			uv_SmallCascadeNormal20.xy = v.texcoord.xy * _SmallCascadeNormal_ST.xy + _SmallCascadeNormal_ST.zw;
			float2 panner597 = ( uv_SmallCascadeNormal20 + _Time.y * (( (float)Direction723 == 1.0 ) ? _SmallCascadeMixSpeed :  appendResult709 ));
			float2 SmallCascadeSpeedValueMix433 = panner597;
			float2 appendResult710 = (half2(_SmallCascadeMainSpeed.y , _SmallCascadeMainSpeed.x));
			float2 panner598 = ( uv_SmallCascadeNormal20 + _Time.y * (( (float)Direction723 == 1.0 ) ? _SmallCascadeMainSpeed :  appendResult710 ));
			float2 SmallCascadeSpeedValueMain600 = panner598;
			half3 ase_worldNormal = UnityObjectToWorldNormal( v.normal );
			float clampResult259 = clamp( ase_worldNormal.y , 0.0 , 1.0 );
			float temp_output_258_0 = ( _SmallCascadeAngle / 45.0 );
			float clampResult263 = clamp( ( clampResult259 - ( 1.0 - temp_output_258_0 ) ) , 0.0 , 2.0 );
			float clampResult584 = clamp( ( clampResult263 * ( 1.0 / temp_output_258_0 ) ) , 0.0 , 1.0 );
			float clampResult285 = clamp( pow( ( 1.0 - clampResult584 ) , _SmallCascadeAngleFalloff ) , 0.0 , 1.0 );
			float lerpResult407 = lerp( ( ( _WaterTessScale * tex2Dlod( _WaterTesselation, half4( WaterSpeedValueMix516, 0.0 , 0.0 ) ).r ) + ( _WaterTessScale * tex2Dlod( _WaterTesselation, half4( WaterSpeedValueMain614, 0.0 , 0.0 ) ).r ) ) , ( ( ( tex2Dlod( _SmallCascadeWaterTess, half4( SmallCascadeSpeedValueMix433, 0.0 , 0.0 ) ).r * _SmallCascadeWaterTessScale ) + ( tex2Dlod( _SmallCascadeWaterTess, half4( SmallCascadeSpeedValueMain600, 0.0 , 0.0 ) ).r * _SmallCascadeWaterTessScale ) ) * clampResult285 ) , clampResult285);
			float2 appendResult712 = (half2(_BigCascadeMixSpeed.y , _BigCascadeMixSpeed.x));
			float2 uv_BigCascadeNormal20 = v.texcoord;
			uv_BigCascadeNormal20.xy = v.texcoord.xy * _BigCascadeNormal_ST.xy + _BigCascadeNormal_ST.zw;
			float2 panner606 = ( uv_BigCascadeNormal20 + _Time.y * (( (float)Direction723 == 1.0 ) ? _BigCascadeMixSpeed :  appendResult712 ));
			float2 BigCascadeSpeedValueMix608 = panner606;
			float2 appendResult714 = (half2(_BigCascadeMainSpeed.y , _BigCascadeMainSpeed.x));
			float2 panner607 = ( uv_BigCascadeNormal20 + _Time.y * (( (float)Direction723 == 1.0 ) ? _BigCascadeMainSpeed :  appendResult714 ));
			float2 BigCascadeSpeedValueMain432 = panner607;
			float clampResult507 = clamp( ase_worldNormal.y , 0.0 , 1.0 );
			float temp_output_504_0 = ( _BigCascadeAngle / 45.0 );
			float clampResult509 = clamp( ( clampResult507 - ( 1.0 - temp_output_504_0 ) ) , 0.0 , 2.0 );
			float clampResult583 = clamp( ( clampResult509 * ( 1.0 / temp_output_504_0 ) ) , 0.0 , 1.0 );
			float clampResult514 = clamp( pow( ( 1.0 - clampResult583 ) , _BigCascadeAngleFalloff ) , 0.0 , 1.0 );
			float lerpResult568 = lerp( lerpResult407 , ( ( ( _BigCascadeWaterTessScale * tex2Dlod( _BigCascadeWaterTess, half4( BigCascadeSpeedValueMix608, 0.0 , 0.0 ) ).r ) + ( _BigCascadeWaterTessScale * tex2Dlod( _BigCascadeWaterTess, half4( BigCascadeSpeedValueMain432, 0.0 , 0.0 ) ).r ) ) * clampResult514 ) , clampResult514);
			float3 ase_vertexNormal = v.normal.xyz;
			v.vertex.xyz += ( lerpResult568 * ase_vertexNormal );
		}

		void surf( Input i , inout SurfaceOutputStandardSpecular o )
		{
			int Direction723 = _UVVDirection1UDirection0;
			float2 appendResult706 = (half2(_WaterMixSpeed.y , _WaterMixSpeed.x));
			float2 uv_WaterNormal = i.uv_texcoord * _WaterNormal_ST.xy + _WaterNormal_ST.zw;
			float2 panner612 = ( uv_WaterNormal + _Time.y * (( (float)Direction723 == 1.0 ) ? _WaterMixSpeed :  appendResult706 ));
			float2 WaterSpeedValueMix516 = panner612;
			float2 appendResult705 = (half2(_WaterMainSpeed.y , _WaterMainSpeed.x));
			float2 panner611 = ( uv_WaterNormal + _Time.y * (( (float)Direction723 == 1.0 ) ? _WaterMainSpeed :  appendResult705 ));
			float2 WaterSpeedValueMain614 = panner611;
			float2 appendResult709 = (half2(_SmallCascadeMixSpeed.y , _SmallCascadeMixSpeed.x));
			float2 uv_SmallCascadeNormal = i.uv_texcoord * _SmallCascadeNormal_ST.xy + _SmallCascadeNormal_ST.zw;
			float2 panner597 = ( uv_SmallCascadeNormal + _Time.y * (( (float)Direction723 == 1.0 ) ? _SmallCascadeMixSpeed :  appendResult709 ));
			float2 SmallCascadeSpeedValueMix433 = panner597;
			float2 appendResult710 = (half2(_SmallCascadeMainSpeed.y , _SmallCascadeMainSpeed.x));
			float2 panner598 = ( uv_SmallCascadeNormal + _Time.y * (( (float)Direction723 == 1.0 ) ? _SmallCascadeMainSpeed :  appendResult710 ));
			float2 SmallCascadeSpeedValueMain600 = panner598;
			half3 ase_worldNormal = WorldNormalVector( i, half3( 0, 0, 1 ) );
			float clampResult259 = clamp( ase_worldNormal.y , 0.0 , 1.0 );
			float temp_output_258_0 = ( _SmallCascadeAngle / 45.0 );
			float clampResult263 = clamp( ( clampResult259 - ( 1.0 - temp_output_258_0 ) ) , 0.0 , 2.0 );
			float clampResult584 = clamp( ( clampResult263 * ( 1.0 / temp_output_258_0 ) ) , 0.0 , 1.0 );
			float clampResult285 = clamp( pow( ( 1.0 - clampResult584 ) , _SmallCascadeAngleFalloff ) , 0.0 , 1.0 );
			float3 lerpResult330 = lerp( BlendNormals( UnpackScaleNormal( tex2D( _WaterNormal, WaterSpeedValueMix516 ) ,( _NormalScale * 1.2 ) ) , UnpackScaleNormal( tex2D( _WaterNormal, WaterSpeedValueMain614 ) ,_NormalScale ) ) , BlendNormals( UnpackScaleNormal( tex2D( _SmallCascadeNormal, SmallCascadeSpeedValueMix433 ) ,_SmallCascadeNormalScale ) , UnpackScaleNormal( tex2D( _SmallCascadeNormal, SmallCascadeSpeedValueMain600 ) ,_SmallCascadeNormalScale ) ) , clampResult285);
			float2 appendResult712 = (half2(_BigCascadeMixSpeed.y , _BigCascadeMixSpeed.x));
			float2 uv_BigCascadeNormal = i.uv_texcoord * _BigCascadeNormal_ST.xy + _BigCascadeNormal_ST.zw;
			float2 panner606 = ( uv_BigCascadeNormal + _Time.y * (( (float)Direction723 == 1.0 ) ? _BigCascadeMixSpeed :  appendResult712 ));
			float2 BigCascadeSpeedValueMix608 = panner606;
			float2 appendResult714 = (half2(_BigCascadeMainSpeed.y , _BigCascadeMainSpeed.x));
			float2 panner607 = ( uv_BigCascadeNormal + _Time.y * (( (float)Direction723 == 1.0 ) ? _BigCascadeMainSpeed :  appendResult714 ));
			float2 BigCascadeSpeedValueMain432 = panner607;
			float clampResult507 = clamp( ase_worldNormal.y , 0.0 , 1.0 );
			float temp_output_504_0 = ( _BigCascadeAngle / 45.0 );
			float clampResult509 = clamp( ( clampResult507 - ( 1.0 - temp_output_504_0 ) ) , 0.0 , 2.0 );
			float clampResult583 = clamp( ( clampResult509 * ( 1.0 / temp_output_504_0 ) ) , 0.0 , 1.0 );
			float clampResult514 = clamp( pow( ( 1.0 - clampResult583 ) , _BigCascadeAngleFalloff ) , 0.0 , 1.0 );
			float3 lerpResult529 = lerp( lerpResult330 , BlendNormals( UnpackScaleNormal( tex2D( _BigCascadeNormal, BigCascadeSpeedValueMix608 ) ,_BigCascadeNormalScale ) , UnpackScaleNormal( tex2D( _BigCascadeNormal, BigCascadeSpeedValueMain432 ) ,_BigCascadeNormalScale ) ) , clampResult514);
			o.Normal = lerpResult529;
			float4 ase_screenPos = float4( i.screenPos.xyz , i.screenPos.w + 0.00000000001 );
			float4 ase_screenPos502 = ase_screenPos;
			#if UNITY_UV_STARTS_AT_TOP
			float scale502 = -1.0;
			#else
			float scale502 = 1.0;
			#endif
			float halfPosW502 = ase_screenPos502.w * 0.5;
			ase_screenPos502.y = ( ase_screenPos502.y - halfPosW502 ) * _ProjectionParams.x* scale502 + halfPosW502;
			ase_screenPos502.xyzw /= ase_screenPos502.w;
			float2 appendResult163 = (half2(ase_screenPos502.r , ase_screenPos502.g));
			float4 screenColor65 = tex2D( _WaterGrab, ( half3( ( appendResult163 / ase_screenPos502.a ) ,  0.0 ) + ( lerpResult529 * _Distortion ) ).xy );
			float eyeDepth1 = LinearEyeDepth(UNITY_SAMPLE_DEPTH(tex2Dproj(_CameraDepthTexture,UNITY_PROJ_COORD(ase_screenPos))));
			float temp_output_89_0 = abs( ( eyeDepth1 - ase_screenPos.w ) );
			float temp_output_94_0 = saturate( pow( ( temp_output_89_0 + _ShalowDepth ) , _ShalowFalloff ) );
			float4 lerpResult13 = lerp( _DeepColor , _ShalowColor , temp_output_94_0);
			float temp_output_113_0 = saturate( pow( ( temp_output_89_0 + _FoamDepth ) , _FoamFalloff ) );
			float2 appendResult716 = (half2(_FoamSpeed.y , _FoamSpeed.x));
			float2 uv_Foam = i.uv_texcoord * _Foam_ST.xy + _Foam_ST.zw;
			float2 panner116 = ( uv_Foam + _Time.y * (( (float)Direction723 == 1.0 ) ? _FoamSpeed :  appendResult716 ));
			float temp_output_114_0 = ( temp_output_113_0 * tex2D( _Foam, panner116 ).r );
			float4 lerpResult117 = lerp( lerpResult13 , half4( _FoamColor , 0.0 ) , temp_output_114_0);
			float4 lerpResult93 = lerp( screenColor65 , lerpResult117 , temp_output_113_0);
			float temp_output_458_0 = ( 1.0 - temp_output_94_0 );
			float4 lerpResult390 = lerp( lerpResult93 , lerpResult13 , temp_output_458_0);
			half4 tex2DNode319 = tex2D( _SmallCascade, SmallCascadeSpeedValueMain600 );
			float2 appendResult718 = (half2(_NoiseSpeed.y , _NoiseSpeed.x));
			float2 temp_output_743_0 = (( (float)Direction723 == 1.0 ) ? float2( 0,0 ) :  appendResult718 );
			float2 uv_Noise = i.uv_texcoord * _Noise_ST.xy + _Noise_ST.zw;
			float2 panner646 = ( uv_Noise + _SinTime.x * ( temp_output_743_0 * float2( -1.2,-0.9 ) ));
			float2 panner321 = ( uv_Noise + _SinTime.x * temp_output_743_0);
			float clampResult488 = clamp( ( pow( min( tex2D( _Noise, panner646 ).r , tex2D( _Noise, panner321 ).r ) , _CascadesNoisePower ) * 20.0 ) , 0.0 , 1.0 );
			float lerpResult480 = lerp( 0.0 , tex2DNode319.g , clampResult488);
			float clampResult322 = clamp( pow( tex2DNode319.g , _SmallCascadeFoamFalloff ) , 0.0 , 1.0 );
			float lerpResult580 = lerp( 0.0 , clampResult322 , clampResult285);
			float4 lerpResult324 = lerp( lerpResult390 , half4( ( lerpResult480 * _SmallCascadeColor ) , 0.0 ) , lerpResult580);
			half4 tex2DNode213 = tex2D( _BigCascade, BigCascadeSpeedValueMain432 );
			float lerpResult626 = lerp( ( tex2DNode213.r * 0.5 ) , tex2DNode213.r , clampResult488);
			float clampResult299 = clamp( pow( tex2DNode213.r , _BigCascadeFoamFalloff ) , 0.0 , 1.0 );
			float lerpResult579 = lerp( 0.0 , clampResult299 , clampResult514);
			float4 lerpResult239 = lerp( lerpResult324 , half4( ( lerpResult626 * _BigCascadeColor ) , 0.0 ) , lerpResult579);
			o.Albedo = lerpResult239.rgb;
			float clampResult552 = clamp( max( lerpResult529.x , lerpResult529.y ) , 0.0 , 1.0 );
			float4 lerpResult451 = lerp( float4( 0,0,0,0 ) , _ShalowColor , clampResult552);
			float lerpResult549 = lerp( _WaterDeepTranslucencyPower , _WaterShalowTranslucencyPower , temp_output_94_0);
			float4 lerpResult459 = lerp( float4( 0,0,0,0 ) , ( lerpResult451 * lerpResult549 ) , temp_output_458_0);
			o.Emission = lerpResult459.rgb;
			float lerpResult130 = lerp( _WaterSpecular , _FoamSpecular , temp_output_114_0);
			float lerpResult585 = lerp( lerpResult130 , _SmallCascadeSpecular , ( lerpResult580 * clampResult285 ));
			float lerpResult587 = lerp( lerpResult585 , _BigCascadeSpecular , ( lerpResult579 * clampResult514 ));
			half3 temp_cast_16 = (lerpResult587).xxx;
			o.Specular = temp_cast_16;
			float lerpResult591 = lerp( _WaterSmoothness , _FoamSmoothness , temp_output_114_0);
			float lerpResult593 = lerp( lerpResult591 , _SmallCascadeSmoothness , ( lerpResult580 * clampResult285 ));
			float lerpResult592 = lerp( lerpResult593 , _BigCascadeSmoothness , ( lerpResult579 * clampResult514 ));
			o.Smoothness = lerpResult592;
			o.Occlusion = _AOPower;
			float lerpResult208 = lerp( 0.0 , 1.0 , pow( saturate( pow( temp_output_89_0 , _WaterDepth ) ) , _WaterFalloffBorder ));
			o.Alpha = lerpResult208;
		}

		ENDCG
	}
	Fallback "Diffuse"
}