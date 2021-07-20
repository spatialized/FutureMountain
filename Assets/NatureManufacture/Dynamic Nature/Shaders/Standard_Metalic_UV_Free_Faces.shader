// Upgrade NOTE: upgraded instancing buffer 'NatureManufactureShadersStandardMetalicUVFreeFaces' to new syntax.

Shader "NatureManufacture Shaders/Standard Metalic UV Free Faces"
{
	Properties
	{
		_TopAlbedo("Top Albedo", 2D) = "white" {}
		_TopNormal("Top Normal", 2D) = "bump" {}
		_TopMetalicRAmbientOcclusionGSmoothnessA("Top Metalic (R) Ambient Occlusion (G) Smoothness (A)", 2D) = "white" {}
		_BottomAlbedo("Bottom Albedo", 2D) = "white" {}
		_BottomNormal("Bottom Normal", 2D) = "bump" {}
		_BottomMetalicRAmbientOcclusionGSmoothnessA("Bottom Metalic (R) Ambient Occlusion (G) Smoothness (A)", 2D) = "white" {}
		_MetalicPower("Metalic Power", Range( 0 , 2)) = 0
		_AmbientOcclusionPower("Ambient Occlusion Power", Range( 0 , 1)) = 0
		_SmothnessPower("Smothness Power", Range( 0 , 2)) = 1
		_Tiling("Tiling", Range( 0.1 , 100)) = 6
		_Falloff("Falloff", Range( 0.0001 , 100)) = 15
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Opaque"  "Queue" = "Geometry+0" }
		Cull Back
		ZTest LEqual
		CGINCLUDE
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
			float3 worldPos;
			float3 worldNormal;
			INTERNAL_DATA
		};

		uniform sampler2D _TopNormal;
		uniform sampler2D _BottomNormal;
		uniform fixed _Tiling;
		uniform fixed _Falloff;
		uniform sampler2D _TopAlbedo;
		uniform sampler2D _BottomAlbedo;
		uniform sampler2D _TopMetalicRAmbientOcclusionGSmoothnessA;
		uniform sampler2D _BottomMetalicRAmbientOcclusionGSmoothnessA;

		UNITY_INSTANCING_BUFFER_START(NatureManufactureShadersStandardMetalicUVFreeFaces)
			UNITY_DEFINE_INSTANCED_PROP(fixed, _MetalicPower)
#define _MetalicPower_arr NatureManufactureShadersStandardMetalicUVFreeFaces
			UNITY_DEFINE_INSTANCED_PROP(fixed, _SmothnessPower)
#define _SmothnessPower_arr NatureManufactureShadersStandardMetalicUVFreeFaces
			UNITY_DEFINE_INSTANCED_PROP(fixed, _AmbientOcclusionPower)
#define _AmbientOcclusionPower_arr NatureManufactureShadersStandardMetalicUVFreeFaces
		UNITY_INSTANCING_BUFFER_END(NatureManufactureShadersStandardMetalicUVFreeFaces)


		inline float3 TriplanarNormal( sampler2D topBumpMap, sampler2D midBumpMap, sampler2D botBumpMap, float3 worldPos, float3 worldNormal, float falloff, float tilling, float vertex )
		{
			float3 projNormal = ( pow( abs( worldNormal ), falloff ) );
			projNormal /= projNormal.x + projNormal.y + projNormal.z;
			float3 nsign = sign(worldNormal);
			float negProjNormalY = max( 0, projNormal.y * -nsign.y );
			projNormal.y = max( 0, projNormal.y * nsign.y );
			half3 xNorm; half3 yNorm; half3 yNormN; half3 zNorm;
			if(vertex == 1){
				xNorm = UnpackNormal( tex2Dlod( midBumpMap, float4( ( tilling * worldPos.zy * float2( nsign.x, 1.0 ) ).xy, 0, 0 ) ) );
				yNorm = UnpackNormal( tex2Dlod( topBumpMap, float4( ( tilling * worldPos.xz * float2( nsign.y, 1.0 ) ).xy, 0, 0 ) ) );
				yNormN = UnpackNormal( tex2Dlod( botBumpMap, float4( ( tilling * worldPos.xz * float2( nsign.y, 1.0 ) ).xy, 0, 0 ) ) );
				zNorm = UnpackNormal( tex2Dlod( midBumpMap, float4( ( tilling * worldPos.xy * float2( -nsign.z, 1.0 ) ).xy, 0, 0 ) ) );
			} else {
				xNorm = UnpackNormal( tex2D( midBumpMap, tilling * worldPos.zy * float2( nsign.x, 1.0 ) ) );
				yNorm = UnpackNormal( tex2D( topBumpMap, tilling * worldPos.xz * float2( nsign.y, 1.0 ) ) );
				yNormN = UnpackNormal( tex2D( botBumpMap, tilling * worldPos.xz * float2( nsign.y, 1.0 ) ) );
				zNorm = UnpackNormal( tex2D( midBumpMap, tilling * worldPos.xy * float2( -nsign.z, 1.0 ) ) );
			}
			xNorm = half3( xNorm.xy * float2( nsign.x, 1.0 ) + worldNormal.zy, worldNormal.x );
			yNorm = half3( yNorm.xy * float2( nsign.y, 1.0 ) + worldNormal.xz, worldNormal.y );
			yNormN = half3( yNormN.xy * float2( nsign.y, 1.0 ) + worldNormal.xz, worldNormal.y );
			zNorm = half3( zNorm.xy * float2( -nsign.z, 1.0 ) + worldNormal.xy, worldNormal.z );
			xNorm = xNorm.zyx;
			yNorm = yNorm.xzy;
			yNormN = yNormN.xzy;
			zNorm = zNorm.xyz;
			return normalize( xNorm * projNormal.x + yNorm * projNormal.y + yNormN * negProjNormalY + zNorm * projNormal.z );
		}


		inline float4 TriplanarSampling( sampler2D topTexMap, sampler2D midTexMap, sampler2D botTexMap, float3 worldPos, float3 worldNormal, float falloff, float tilling, float vertex )
		{
			float3 projNormal = ( pow( abs( worldNormal ), falloff ) );
			projNormal /= projNormal.x + projNormal.y + projNormal.z;
			float3 nsign = sign( worldNormal );
			float negProjNormalY = max( 0, projNormal.y * -nsign.y );
			projNormal.y = max( 0, projNormal.y * nsign.y );
			half4 xNorm; half4 yNorm; half4 yNormN; half4 zNorm;
			if(vertex == 1){
				xNorm = ( tex2Dlod( midTexMap, float4( ( tilling * worldPos.zy * float2( nsign.x, 1.0 ) ).xy, 0, 0 ) ) );
				yNorm = ( tex2Dlod( topTexMap, float4( ( tilling * worldPos.xz * float2( nsign.y, 1.0 ) ).xy, 0, 0 ) ) );
				yNormN = ( tex2Dlod( botTexMap, float4( ( tilling * worldPos.xz * float2( nsign.y, 1.0 ) ).xy, 0, 0 ) ) );
				zNorm = ( tex2Dlod( midTexMap, float4( ( tilling * worldPos.xy * float2( -nsign.z, 1.0 ) ).xy, 0, 0 ) ) );
			} else {
				xNorm = ( tex2D( midTexMap, tilling * worldPos.zy * float2( nsign.x, 1.0 ) ) );
				yNorm = ( tex2D( topTexMap, tilling * worldPos.xz * float2( nsign.y, 1.0 ) ) );
				yNormN = ( tex2D( botTexMap, tilling * worldPos.xz * float2( nsign.y, 1.0 ) ) );
				zNorm = ( tex2D( midTexMap, tilling * worldPos.xy * float2( -nsign.z, 1.0 ) ) );
			}
			return xNorm * projNormal.x + yNorm * projNormal.y + yNormN * negProjNormalY + zNorm * projNormal.z;
		}


		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float temp_output_422_0 = ( 1.0 / _Tiling );
			fixed3 ase_worldNormal = WorldNormalVector( i, fixed3( 0, 0, 1 ) );
			fixed3 ase_worldTangent = WorldNormalVector( i, fixed3( 1, 0, 0 ) );
			fixed3 ase_worldBitangent = WorldNormalVector( i, fixed3( 0, 1, 0 ) );
			float3x3 ase_worldToTangent = float3x3( ase_worldTangent, ase_worldBitangent, ase_worldNormal );
			float3 ase_worldPos = i.worldPos;
			float3 worldTriplanarNormal409 = TriplanarNormal( _TopNormal, _BottomNormal, _BottomNormal, ase_worldPos, ase_worldNormal, _Falloff, temp_output_422_0, 0 );
			float3 tanTriplanarNormal409 = mul( ase_worldToTangent, worldTriplanarNormal409 );
			float3 temp_output_409_0 = tanTriplanarNormal409;
			o.Normal = temp_output_409_0;
			float4 triplanar406 = TriplanarSampling( _TopAlbedo, _BottomAlbedo, _BottomAlbedo, ase_worldPos, ase_worldNormal, _Falloff, temp_output_422_0, 0 );
			float4 temp_output_406_0 = triplanar406;
			o.Albedo = temp_output_406_0.xyz;
			float4 triplanar414 = TriplanarSampling( _TopMetalicRAmbientOcclusionGSmoothnessA, _BottomMetalicRAmbientOcclusionGSmoothnessA, _BottomMetalicRAmbientOcclusionGSmoothnessA, ase_worldPos, ase_worldNormal, _Falloff, temp_output_422_0, 0 );
			fixed _MetalicPower_Instance = UNITY_ACCESS_INSTANCED_PROP(_MetalicPower_arr, _MetalicPower);
			o.Metallic = ( triplanar414.x * _MetalicPower_Instance );
			fixed _SmothnessPower_Instance = UNITY_ACCESS_INSTANCED_PROP(_SmothnessPower_arr, _SmothnessPower);
			o.Smoothness = ( triplanar414.w * _SmothnessPower_Instance );
			fixed _AmbientOcclusionPower_Instance = UNITY_ACCESS_INSTANCED_PROP(_AmbientOcclusionPower_arr, _AmbientOcclusionPower);
			float clampResult96 = clamp( triplanar414.y , ( 1.0 - _AmbientOcclusionPower_Instance ) , 1.0 );
			o.Occlusion = clampResult96;
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