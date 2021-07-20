// Upgrade NOTE: upgraded instancing buffer 'NatureManufactureShadersStandardMetalicSnow' to new syntax.

Shader "NatureManufacture Shaders/Standard Metalic Snow"
{
	Properties
	{
		_MainTex("MainTex ", 2D) = "white" {}
		_Color("Color", Color) = (1,1,1,1)
		_BumpMap("BumpMap", 2D) = "bump" {}
		_BumpScale("BumpScale", Range( 0 , 5)) = 0
		_MetalicRAmbientOcclusionGSmoothnessA("Metalic (R) Ambient Occlusion (G) Smoothness (A)", 2D) = "white" {}
		_MetalicPower("Metalic Power", Range( 0 , 2)) = 1
		_AmbientOcclusionPower("Ambient Occlusion Power", Range( 0 , 1)) = 1
		_SmothnessPower("Smothness Power", Range( 0 , 2)) = 1
		_DetailAlbedoMap("DetailAlbedoMap", 2D) = "black" {}
		_DetailMapTiling("Detail Map Tiling", Range( 0.0001 , 100)) = 15
		_DetailNormalMap("DetailNormalMap", 2D) = "bump" {}
		_DetailNormalMapScale("DetailNormalMapScale", Range( 0 , 2)) = 0
		_Snow_Amount("Snow_Amount", Range( 0 , 2)) = 0.13
		_TriplanarCoverFalloff("Triplanar Cover Falloff", Range( 1 , 100)) = 8
		_SnowAlbedoRGB("Snow Albedo (RGB)", 2D) = "white" {}
		_SnowTiling("Snow Tiling", Range( 0.0001 , 100)) = 15
		_SnowAlbedoColor("Snow Albedo Color", Color) = (1,1,1,1)
		_SnowNormalRGB("Snow Normal (RGB)", 2D) = "white" {}
		_SnowMetalicRAmbientOcclusionGSmothnessA("Snow Metalic (R) Ambient Occlusion(G) Smothness (A)", 2D) = "white" {}
		_SnowNormalScale("Snow Normal Scale", Range( 0 , 5)) = 0
		_SnowNormalCoverHardness("Snow Normal Cover Hardness", Range( 0 , 10)) = 0
		_SnowMetalicPower("Snow Metalic Power", Range( 0 , 2)) = 1
		_SnowAmbientOcclusionPower("Snow Ambient Occlusion Power", Range( 0 , 1)) = 1
		_SnowSmoothnessPower("Snow Smoothness Power", Range( 0 , 2)) = 1
		_SnowMaxAngle("Snow Max Angle ", Range( 0.001 , 90)) = 90
		_SnowHardness("Snow Hardness", Range( 1 , 10)) = 5
		_Snow_Min_Height("Snow_Min_Height", Range( -1000 , 10000)) = -1000
		_Snow_Min_Height_Blending("Snow_Min_Height_Blending", Range( 0 , 500)) = 1
		_SnowHeightG("Snow Height (G)", 2D) = "white" {}
		_SnowHeightSharpness("Snow Height Sharpness", Range( 0 , 2)) = 0.3
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Opaque"  "Queue" = "Geometry+0" }
		Cull Back
		ZTest LEqual
		CGINCLUDE
		#include "UnityStandardUtils.cginc"
		#include "UnityPBSLighting.cginc"
		#include "Lighting.cginc"
		#pragma target 3.0
		#pragma multi_compile_instancing
		#ifdef UNITY_PASS_SHADOWCASTER
			#undef INTERNAL_DATA
			#undef WorldReflectionVector
			#undef WorldNormalVector
			#define INTERNAL_DATA half3 internalSurfaceTtoW0; half3 internalSurfaceTtoW1; half3 internalSurfaceTtoW2;
			#define WorldReflectionVector(data,normal) reflect (data.worldRefl, half3(dot(data.internalSurfaceTtoW0,normal), dot(data.internalSurfaceTtoW1,normal), dot(data.internalSurfaceTtoW2,normal)))
			#define WorldNormalVector(data,normal) fixed3(dot(data.internalSurfaceTtoW0,normal), dot(data.internalSurfaceTtoW1,normal), dot(data.internalSurfaceTtoW2,normal))
		#endif
		struct Input
		{
			float2 uv_texcoord;
			float3 worldPos;
			float3 worldNormal;
			INTERNAL_DATA
		};

		uniform fixed _BumpScale;
		uniform sampler2D _BumpMap;
		uniform sampler2D _MainTex;
		uniform float4 _MainTex_ST;
		uniform sampler2D _DetailNormalMap;
		uniform fixed _DetailMapTiling;
		uniform fixed _DetailNormalMapScale;
		uniform sampler2D _SnowNormalRGB;
		uniform fixed _SnowTiling;
		uniform fixed _TriplanarCoverFalloff;
		uniform fixed _SnowNormalScale;
		uniform fixed _SnowNormalCoverHardness;
		uniform fixed _Snow_Amount;
		uniform fixed _SnowMaxAngle;
		uniform fixed _SnowHardness;
		uniform fixed _Snow_Min_Height;
		uniform fixed _Snow_Min_Height_Blending;
		uniform sampler2D _SnowHeightG;
		uniform fixed _SnowHeightSharpness;
		uniform sampler2D _DetailAlbedoMap;
		uniform sampler2D _SnowAlbedoRGB;
		uniform sampler2D _MetalicRAmbientOcclusionGSmoothnessA;
		uniform sampler2D _SnowMetalicRAmbientOcclusionGSmothnessA;
		uniform fixed _SnowSmoothnessPower;

		UNITY_INSTANCING_BUFFER_START(NatureManufactureShadersStandardMetalicSnow)
			UNITY_DEFINE_INSTANCED_PROP(fixed4, _Color)
#define _Color_arr NatureManufactureShadersStandardMetalicSnow
			UNITY_DEFINE_INSTANCED_PROP(fixed4, _SnowAlbedoColor)
#define _SnowAlbedoColor_arr NatureManufactureShadersStandardMetalicSnow
			UNITY_DEFINE_INSTANCED_PROP(fixed, _MetalicPower)
#define _MetalicPower_arr NatureManufactureShadersStandardMetalicSnow
			UNITY_DEFINE_INSTANCED_PROP(fixed, _SnowMetalicPower)
#define _SnowMetalicPower_arr NatureManufactureShadersStandardMetalicSnow
			UNITY_DEFINE_INSTANCED_PROP(fixed, _SmothnessPower)
#define _SmothnessPower_arr NatureManufactureShadersStandardMetalicSnow
			UNITY_DEFINE_INSTANCED_PROP(fixed, _AmbientOcclusionPower)
#define _AmbientOcclusionPower_arr NatureManufactureShadersStandardMetalicSnow
			UNITY_DEFINE_INSTANCED_PROP(fixed, _SnowAmbientOcclusionPower)
#define _SnowAmbientOcclusionPower_arr NatureManufactureShadersStandardMetalicSnow
		UNITY_INSTANCING_BUFFER_END(NatureManufactureShadersStandardMetalicSnow)


		inline float3 TriplanarNormal( sampler2D topBumpMap, sampler2D midBumpMap, sampler2D botBumpMap, float3 worldPos, float3 worldNormal, float falloff, float tilling, float vertex )
		{
			float3 projNormal = ( pow( abs( worldNormal ), falloff ) );
			projNormal /= projNormal.x + projNormal.y + projNormal.z;
			float3 nsign = sign(worldNormal);
			half3 xNorm; half3 yNorm; half3 zNorm;
			if( vertex == 1 ){
				xNorm = UnpackNormal( tex2Dlod( topBumpMap, float4( ( tilling * worldPos.zy * float2( nsign.x, 1.0 ) ).xy, 0, 0 ) ) );
				yNorm = UnpackNormal( tex2Dlod( topBumpMap, float4( ( tilling * worldPos.xz * float2( nsign.y, 1.0 ) ).xy, 0, 0 ) ) );
				zNorm = UnpackNormal( tex2Dlod( topBumpMap, float4( ( tilling * worldPos.xy * float2( -nsign.z, 1.0 ) ).xy, 0, 0 ) ) );
			} else {
				xNorm = UnpackNormal( tex2D( topBumpMap, tilling * worldPos.zy * float2( nsign.x, 1.0 ) ) );
				yNorm = UnpackNormal( tex2D( topBumpMap, tilling * worldPos.xz * float2( nsign.y, 1.0 ) ) );
				zNorm = UnpackNormal( tex2D( topBumpMap, tilling * worldPos.xy * float2( -nsign.z, 1.0 ) ) );
			}
			xNorm = half3( xNorm.xy * float2( nsign.x, 1.0 ) + worldNormal.zy, worldNormal.x );
			yNorm = half3( yNorm.xy * float2( nsign.y, 1.0 ) + worldNormal.xz, worldNormal.y );
			zNorm = half3( zNorm.xy * float2( -nsign.z, 1.0 ) + worldNormal.xy, worldNormal.z );
			xNorm = xNorm.zyx;
			yNorm = yNorm.xzy;
			zNorm = zNorm.xyz;
			return normalize( xNorm * projNormal.x + yNorm * projNormal.y + zNorm * projNormal.z );
		}


		inline float4 TriplanarSampling( sampler2D topTexMap, sampler2D midTexMap, sampler2D botTexMap, float3 worldPos, float3 worldNormal, float falloff, float tilling, float vertex )
		{
			float3 projNormal = ( pow( abs( worldNormal ), falloff ) );
			projNormal /= projNormal.x + projNormal.y + projNormal.z;
			float3 nsign = sign( worldNormal );
			half4 xNorm; half4 yNorm; half4 zNorm;
			if( vertex == 1 ){
				xNorm = ( tex2Dlod( topTexMap, float4( ( tilling * worldPos.zy * float2( nsign.x, 1.0 ) ).xy, 0, 0 ) ) );
				yNorm = ( tex2Dlod( topTexMap, float4( ( tilling * worldPos.xz * float2( nsign.y, 1.0 ) ).xy, 0, 0 ) ) );
				zNorm = ( tex2Dlod( topTexMap, float4( ( tilling * worldPos.xy * float2( -nsign.z, 1.0 ) ).xy, 0, 0 ) ) );
			} else {
				xNorm = ( tex2D( topTexMap, tilling * worldPos.zy * float2( nsign.x, 1.0 ) ) );
				yNorm = ( tex2D( topTexMap, tilling * worldPos.xz * float2( nsign.y, 1.0 ) ) );
				zNorm = ( tex2D( topTexMap, tilling * worldPos.xy * float2( -nsign.z, 1.0 ) ) );
			}
			return xNorm * projNormal.x + yNorm * projNormal.y + zNorm * projNormal.z;
		}


		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float2 uv_MainTex = i.uv_texcoord * _MainTex_ST.xy + _MainTex_ST.zw;
			float temp_output_473_0 = ( 1.0 / _DetailMapTiling );
			fixed3 ase_worldNormal = WorldNormalVector( i, fixed3( 0, 0, 1 ) );
			fixed3 ase_worldTangent = WorldNormalVector( i, fixed3( 1, 0, 0 ) );
			fixed3 ase_worldBitangent = WorldNormalVector( i, fixed3( 0, 1, 0 ) );
			float3x3 ase_worldToTangent = float3x3( ase_worldTangent, ase_worldBitangent, ase_worldNormal );
			float3 ase_worldPos = i.worldPos;
			float3 worldTriplanarNormal471 = TriplanarNormal( _DetailNormalMap, _DetailNormalMap, _DetailNormalMap, ase_worldPos, ase_worldNormal, 8.0, temp_output_473_0, 0 );
			float3 tanTriplanarNormal471 = mul( ase_worldToTangent, worldTriplanarNormal471 );
			float3 appendResult469 = (fixed3(_DetailNormalMapScale , _DetailNormalMapScale , 1.0));
			float temp_output_265_0 = ( 1.0 / _SnowTiling );
			float3 worldTriplanarNormal457 = TriplanarNormal( _SnowNormalRGB, _SnowNormalRGB, _SnowNormalRGB, ase_worldPos, ase_worldNormal, _TriplanarCoverFalloff, temp_output_265_0, 0 );
			float3 tanTriplanarNormal457 = mul( ase_worldToTangent, worldTriplanarNormal457 );
			float3 appendResult458 = (fixed3(_SnowNormalScale , _SnowNormalScale , 1.0));
			float clampResult87 = clamp( ase_worldNormal.y , 0.0 , 0.999999 );
			float temp_output_85_0 = ( _SnowMaxAngle / 45.0 );
			float clampResult83 = clamp( ( clampResult87 - ( 1.0 - temp_output_85_0 ) ) , 0.0 , 2.0 );
			float temp_output_329_0 = ( ( 1.0 - _Snow_Min_Height ) + ase_worldPos.y );
			float clampResult336 = clamp( ( temp_output_329_0 + 1.0 ) , 0.0 , 1.0 );
			float clampResult335 = clamp( ( ( 1.0 - ( ( temp_output_329_0 + _Snow_Min_Height_Blending ) / temp_output_329_0 ) ) + -0.5 ) , 0.0 , 1.0 );
			float clampResult338 = clamp( ( clampResult336 + clampResult335 ) , 0.0 , 1.0 );
			float temp_output_349_0 = ( pow( ( clampResult83 * ( 1.0 / temp_output_85_0 ) ) , _SnowHardness ) * clampResult338 );
			float3 lerpResult15 = lerp( UnpackScaleNormal( tex2D( _BumpMap, uv_MainTex ) ,_SnowNormalCoverHardness ) , tanTriplanarNormal457 , ( saturate( ( ase_worldNormal.y * _Snow_Amount ) ) * temp_output_349_0 ));
			float3 newWorldNormal19 = WorldNormalVector( i , lerpResult15 );
			float clampResult368 = clamp( ( ( newWorldNormal19.y * _Snow_Amount ) * ( ( _Snow_Amount * _SnowHardness ) * temp_output_349_0 ) ) , 0.0 , 1.0 );
			float4 triplanar460 = TriplanarSampling( _SnowHeightG, _SnowHeightG, _SnowHeightG, ase_worldPos, ase_worldNormal, _TriplanarCoverFalloff, temp_output_265_0, 0 );
			float temp_output_18_0 = saturate( ( clampResult368 * pow( triplanar460.y , _SnowHeightSharpness ) ) );
			float3 lerpResult369 = lerp( BlendNormals( UnpackScaleNormal( tex2D( _BumpMap, uv_MainTex ) ,_BumpScale ) , ( tanTriplanarNormal471 * appendResult469 ) ) , ( tanTriplanarNormal457 * appendResult458 ) , temp_output_18_0);
			o.Normal = lerpResult369;
			fixed4 _Color_Instance = UNITY_ACCESS_INSTANCED_PROP(_Color_arr, _Color);
			float4 triplanar472 = TriplanarSampling( _DetailAlbedoMap, _DetailAlbedoMap, _DetailAlbedoMap, ase_worldPos, ase_worldNormal, 8.0, temp_output_473_0, 0 );
			fixed4 blendOpSrc474 = ( tex2D( _MainTex, uv_MainTex ) * _Color_Instance );
			fixed4 blendOpDest474 = triplanar472;
			float4 triplanar455 = TriplanarSampling( _SnowAlbedoRGB, _SnowAlbedoRGB, _SnowAlbedoRGB, ase_worldPos, ase_worldNormal, _TriplanarCoverFalloff, temp_output_265_0, 0 );
			fixed4 _SnowAlbedoColor_Instance = UNITY_ACCESS_INSTANCED_PROP(_SnowAlbedoColor_arr, _SnowAlbedoColor);
			float4 lerpResult10 = lerp( 	max( blendOpSrc474, blendOpDest474 ) , ( triplanar455 * _SnowAlbedoColor_Instance ) , temp_output_18_0);
			o.Albedo = lerpResult10.xyz;
			fixed4 tex2DNode2 = tex2D( _MetalicRAmbientOcclusionGSmoothnessA, uv_MainTex );
			fixed _MetalicPower_Instance = UNITY_ACCESS_INSTANCED_PROP(_MetalicPower_arr, _MetalicPower);
			float4 triplanar459 = TriplanarSampling( _SnowMetalicRAmbientOcclusionGSmothnessA, _SnowMetalicRAmbientOcclusionGSmothnessA, _SnowMetalicRAmbientOcclusionGSmothnessA, ase_worldPos, ase_worldNormal, _TriplanarCoverFalloff, temp_output_265_0, 0 );
			fixed _SnowMetalicPower_Instance = UNITY_ACCESS_INSTANCED_PROP(_SnowMetalicPower_arr, _SnowMetalicPower);
			float lerpResult17 = lerp( ( tex2DNode2.r * _MetalicPower_Instance ) , ( triplanar459.x * _SnowMetalicPower_Instance ) , temp_output_18_0);
			o.Metallic = lerpResult17;
			fixed _SmothnessPower_Instance = UNITY_ACCESS_INSTANCED_PROP(_SmothnessPower_arr, _SmothnessPower);
			float lerpResult27 = lerp( ( tex2DNode2.a * _SmothnessPower_Instance ) , ( triplanar459.w * _SnowSmoothnessPower ) , temp_output_18_0);
			o.Smoothness = lerpResult27;
			fixed _AmbientOcclusionPower_Instance = UNITY_ACCESS_INSTANCED_PROP(_AmbientOcclusionPower_arr, _AmbientOcclusionPower);
			float clampResult96 = clamp( tex2DNode2.g , ( 1.0 - _AmbientOcclusionPower_Instance ) , 1.0 );
			fixed _SnowAmbientOcclusionPower_Instance = UNITY_ACCESS_INSTANCED_PROP(_SnowAmbientOcclusionPower_arr, _SnowAmbientOcclusionPower);
			float clampResult94 = clamp( triplanar459.y , ( 1.0 - _SnowAmbientOcclusionPower_Instance ) , 1.0 );
			float lerpResult28 = lerp( clampResult96 , clampResult94 , temp_output_18_0);
			o.Occlusion = lerpResult28;
			o.Alpha = 1;
		}

		ENDCG
		CGPROGRAM
		#pragma surface surf Standard keepalpha fullforwardshadows 

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
			# include "HLSLSupport.cginc"
			#if ( SHADER_API_D3D11 || SHADER_API_GLCORE || SHADER_API_GLES3 || SHADER_API_METAL || SHADER_API_VULKAN )
				#define CAN_SKIP_VPOS
			#endif
			#include "UnityCG.cginc"
			#include "Lighting.cginc"
			#include "UnityPBSLighting.cginc"
			sampler3D _DitherMaskLOD;
			struct v2f
			{
				V2F_SHADOW_CASTER;
				float4 tSpace0 : TEXCOORD1;
				float4 tSpace1 : TEXCOORD2;
				float4 tSpace2 : TEXCOORD3;
				float4 texcoords01 : TEXCOORD4;
				UNITY_VERTEX_INPUT_INSTANCE_ID
			};
			v2f vert( appdata_full v )
			{
				v2f o;
				UNITY_SETUP_INSTANCE_ID( v );
				UNITY_INITIALIZE_OUTPUT( v2f, o );
				UNITY_TRANSFER_INSTANCE_ID( v, o );
				float3 worldPos = mul( unity_ObjectToWorld, v.vertex ).xyz;
				fixed3 worldNormal = UnityObjectToWorldNormal( v.normal );
				fixed3 worldTangent = UnityObjectToWorldDir( v.tangent.xyz );
				fixed tangentSign = v.tangent.w * unity_WorldTransformParams.w;
				fixed3 worldBinormal = cross( worldNormal, worldTangent ) * tangentSign;
				o.tSpace0 = float4( worldTangent.x, worldBinormal.x, worldNormal.x, worldPos.x );
				o.tSpace1 = float4( worldTangent.y, worldBinormal.y, worldNormal.y, worldPos.y );
				o.tSpace2 = float4( worldTangent.z, worldBinormal.z, worldNormal.z, worldPos.z );
				o.texcoords01 = float4( v.texcoord.xy, v.texcoord1.xy );
				TRANSFER_SHADOW_CASTER_NORMALOFFSET( o )
				return o;
			}
			fixed4 frag( v2f IN
			#if !defined( CAN_SKIP_VPOS )
			, UNITY_VPOS_TYPE vpos : VPOS
			#endif
			) : SV_Target
			{
				UNITY_SETUP_INSTANCE_ID( IN );
				Input surfIN;
				UNITY_INITIALIZE_OUTPUT( Input, surfIN );
				surfIN.uv_texcoord.xy = IN.texcoords01.xy;
				float3 worldPos = float3( IN.tSpace0.w, IN.tSpace1.w, IN.tSpace2.w );
				fixed3 worldViewDir = normalize( UnityWorldSpaceViewDir( worldPos ) );
				surfIN.worldPos = worldPos;
				surfIN.worldNormal = float3( IN.tSpace0.z, IN.tSpace1.z, IN.tSpace2.z );
				surfIN.internalSurfaceTtoW0 = IN.tSpace0.xyz;
				surfIN.internalSurfaceTtoW1 = IN.tSpace1.xyz;
				surfIN.internalSurfaceTtoW2 = IN.tSpace2.xyz;
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