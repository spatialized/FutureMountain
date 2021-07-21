Shader "NatureManufacture Shaders/Trees/Tree Leaves Specular Snow"
{
	Properties
	{
		_Cutoff( "Mask Clip Value", Float ) = 0.5
		_Snow_Amount("Snow_Amount", Range( 0 , 2)) = 0
		_SnowBrightnessReduction("Snow Brightness Reduction", Range( 0 , 0.5)) = 0.1239701
		_SnowMaskTreshold("Snow Mask Treshold", Range( 0.1 , 6)) = 4
		_SnowAngleOverlay("Snow Angle Overlay", Range( 0 , 1)) = 0.5
		_MainTex("MainTex", 2D) = "white" {}
		_HealthyColor("Healthy Color", Color) = (1,0.9735294,0.9338235,1)
		_DryColor("Dry Color", Color) = (0.8676471,0.818369,0.6124567,1)
		_ColorNoiseSpread("Color Noise Spread", Float) = 50
		[NoScaleOffset]_BumpMap("BumpMap", 2D) = "bump" {}
		_BumpScale("BumpScale", Range( 0 , 3)) = 1
		_SpecularPower("Specular Power", Range( 0 , 2)) = 0
		[NoScaleOffset]_AmbientOcclusionGSmothnessA("Ambient Occlusion (G)  Smothness (A)", 2D) = "white" {}
		_AmbientOcclusionPower("Ambient Occlusion Power", Range( 0 , 2)) = 0
		_SmoothnessPower("Smoothness Power", Range( 0 , 2)) = 0
		_SnowAlbedoRGB("Snow Albedo (RGB)", 2D) = "white" {}
		[NoScaleOffset]_SnowNormalRGB("Snow Normal (RGB)", 2D) = "bump" {}
		[NoScaleOffset]_SnowSpecularRGBSmothnessA("Snow Specular (RGB) Smothness (A)", 2D) = "white" {}
		_SnowSpecularPower("Snow Specular Power", Range( 0 , 2)) = 1
		[Toggle]_BackFaceMirrorNormal("BackFace Mirror Normal", Float) = 0
		_SnowSmoothnessPower("Snow Smoothness Power", Range( 0 , 3)) = 1
		[NoScaleOffset]_SnowAmbientOcclusionG("Snow Ambient Occlusion (G)", 2D) = "white" {}
		_SnowAmbientOcclusionPower("Snow Ambient Occlusion Power", Range( 0 , 1)) = 1
		_InitialBend("Wind Initial Bend", Float) = 1
		_Stiffness("Wind Stiffness", Float) = 1
		_Drag("Wind Drag", Float) = 1
		_ShiverDrag("Wind Shiver Drag", Float) = 0.05
		_ShiverDirectionality("Wind Shiver Directionality", Range( 0 , 1)) = 0.5
		[Toggle(_TOUCHREACTACTIVE_ON)] _TouchReactActive("TouchReactActive", Float) = 0
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "TransparentCutout"  "Queue" = "AlphaTest+0" }
		Cull Off
		CGINCLUDE
		#include "UnityStandardUtils.cginc"
		#include "UnityPBSLighting.cginc"
		#include "Lighting.cginc"
		#pragma target 3.0
		#pragma multi_compile_instancing
		#pragma shader_feature _TOUCHREACTACTIVE_ON
		#include "NMWind.cginc"
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
			half ASEVFace : VFACE;
			float3 worldPos;
			float3 worldNormal;
			INTERNAL_DATA
		};

		uniform float _BackFaceMirrorNormal;
		uniform float _BumpScale;
		uniform sampler2D _BumpMap;
		uniform sampler2D _MainTex;
		uniform float4 _MainTex_ST;
		uniform float4 _DryColor;
		uniform float4 _HealthyColor;
		uniform float _ColorNoiseSpread;
		uniform sampler2D _SnowAlbedoRGB;
		uniform float4 _SnowAlbedoRGB_ST;
		uniform float _SnowBrightnessReduction;
		uniform sampler2D _SnowNormalRGB;
		uniform float _Snow_Amount;
		uniform float _SnowAngleOverlay;
		uniform float _SnowMaskTreshold;
		uniform float _SpecularPower;
		uniform float _SnowSpecularPower;
		uniform sampler2D _SnowSpecularRGBSmothnessA;
		uniform sampler2D _AmbientOcclusionGSmothnessA;
		uniform float _SmoothnessPower;
		uniform float _SnowSmoothnessPower;
		uniform float _AmbientOcclusionPower;
		uniform sampler2D _SnowAmbientOcclusionG;
		uniform float _SnowAmbientOcclusionPower;
		uniform float _Cutoff = 0.5;


		float3 mod2D289( float3 x ) { return x - floor( x * ( 1.0 / 289.0 ) ) * 289.0; }

		float2 mod2D289( float2 x ) { return x - floor( x * ( 1.0 / 289.0 ) ) * 289.0; }

		float3 permute( float3 x ) { return mod2D289( ( ( x * 34.0 ) + 1.0 ) * x ); }

		float snoise( float2 v )
		{
			const float4 C = float4( 0.211324865405187, 0.366025403784439, -0.577350269189626, 0.024390243902439 );
			float2 i = floor( v + dot( v, C.yy ) );
			float2 x0 = v - i + dot( i, C.xx );
			float2 i1;
			i1 = ( x0.x > x0.y ) ? float2( 1.0, 0.0 ) : float2( 0.0, 1.0 );
			float4 x12 = x0.xyxy + C.xxzz;
			x12.xy -= i1;
			i = mod2D289( i );
			float3 p = permute( permute( i.y + float3( 0.0, i1.y, 1.0 ) ) + i.x + float3( 0.0, i1.x, 1.0 ) );
			float3 m = max( 0.5 - float3( dot( x0, x0 ), dot( x12.xy, x12.xy ), dot( x12.zw, x12.zw ) ), 0.0 );
			m = m * m;
			m = m * m;
			float3 x = 2.0 * frac( p * C.www ) - 1.0;
			float3 h = abs( x ) - 0.5;
			float3 ox = floor( x + 0.5 );
			float3 a0 = x - ox;
			m *= 1.79284291400159 - 0.85373472095314 * ( a0 * a0 + h * h );
			float3 g;
			g.x = a0.x * x0.x + h.x * x0.y;
			g.yz = a0.yz * x12.xz + h.yz * x12.yw;
			return 130.0 * dot( m, g );
		}


		void surf( Input i , inout SurfaceOutputStandardSpecular o )
		{
			float2 uv0_MainTex = i.uv_texcoord * _MainTex_ST.xy + _MainTex_ST.zw;
			float3 tex2DNode4 = UnpackScaleNormal( tex2D( _BumpMap, uv0_MainTex ), _BumpScale );
			float3 switchResult354 = (((i.ASEVFace>0)?(tex2DNode4):(( tex2DNode4 * float3( -1,-1,-1 ) ))));
			o.Normal = lerp(tex2DNode4,switchResult354,_BackFaceMirrorNormal);
			float3 ase_worldPos = i.worldPos;
			float2 appendResult347 = (float2(ase_worldPos.x , ase_worldPos.z));
			float simplePerlin2D351 = snoise( ( appendResult347 / _ColorNoiseSpread ) );
			float4 lerpResult352 = lerp( _DryColor , _HealthyColor , simplePerlin2D351);
			float4 tex2DNode3 = tex2D( _MainTex, uv0_MainTex );
			float4 temp_output_97_0 = ( lerpResult352 * tex2DNode3 );
			float2 uv0_SnowAlbedoRGB = i.uv_texcoord * _SnowAlbedoRGB_ST.xy + _SnowAlbedoRGB_ST.zw;
			float3 appendResult121 = (float3(_SnowBrightnessReduction , _SnowBrightnessReduction , _SnowBrightnessReduction));
			float3 ase_worldNormal = WorldNormalVector( i, float3( 0, 0, 1 ) );
			float3 lerpResult41 = lerp( tex2DNode4 , UnpackNormal( tex2D( _SnowNormalRGB, uv0_SnowAlbedoRGB ) ) , saturate( ( ase_worldNormal.y * _Snow_Amount ) ));
			float temp_output_45_0 = saturate( ( ( (WorldNormalVector( i , lerpResult41 )).y + _SnowAngleOverlay ) * _Snow_Amount ) );
			float lerpResult94 = lerp( 0.0 , ( 1.0 - temp_output_45_0 ) , _Snow_Amount);
			float clampResult93 = clamp( ( temp_output_45_0 + lerpResult94 ) , 0.0 , 1.0 );
			float clampResult339 = clamp( _Snow_Amount , 0.1 , 2.0 );
			float lerpResult334 = lerp( 0.0 , clampResult93 , pow( tex2DNode3.a , ( _SnowMaskTreshold / clampResult339 ) ));
			float4 lerpResult51 = lerp( temp_output_97_0 , ( tex2D( _SnowAlbedoRGB, uv0_SnowAlbedoRGB ) - float4( appendResult121 , 0.0 ) ) , lerpResult334);
			o.Albedo = lerpResult51.rgb;
			float4 tex2DNode64 = tex2D( _SnowSpecularRGBSmothnessA, uv0_SnowAlbedoRGB );
			float3 appendResult101 = (float3(tex2DNode64.r , tex2DNode64.g , tex2DNode64.b));
			float4 lerpResult53 = lerp( ( temp_output_97_0 * _SpecularPower ) , float4( ( _SnowSpecularPower * appendResult101 ) , 0.0 ) , temp_output_45_0);
			o.Specular = lerpResult53.rgb;
			float4 tex2DNode98 = tex2D( _AmbientOcclusionGSmothnessA, uv0_MainTex );
			float lerpResult66 = lerp( ( tex2DNode98.a * _SmoothnessPower ) , ( tex2DNode64.a * _SnowSmoothnessPower ) , temp_output_45_0);
			o.Smoothness = lerpResult66;
			float clampResult125 = clamp( tex2DNode98.g , ( 1.0 - _AmbientOcclusionPower ) , 1.0 );
			float clampResult123 = clamp( tex2D( _SnowAmbientOcclusionG, uv0_SnowAlbedoRGB ).g , ( 1.0 - _SnowAmbientOcclusionPower ) , 1.0 );
			float lerpResult65 = lerp( clampResult125 , clampResult123 , temp_output_45_0);
			o.Occlusion = lerpResult65;
			o.Alpha = 1;
			clip( tex2DNode3.a - _Cutoff );
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
				surfIN.worldPos = worldPos;
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