// Upgrade NOTE: upgraded instancing buffer 'NatureManufactureShadersStandardSpecularSnow' to new syntax.

Shader "NatureManufacture Shaders/Standard Specular Snow"
{
	Properties
	{
		_MainTex("MainTex", 2D) = "white" {}
		_Color("Color", Color) = (1,1,1,1)
		_BumpMap("BumpMap", 2D) = "bump" {}
		_BumpScale("BumpScale", Range( 0 , 2)) = 1
		_SpecularRGBSmoothnesA("Specular (RGB) Smoothnes (A)", 2D) = "white" {}
		_SpecularPower("Specular Power", Range( 0 , 2)) = 1
		_SmoothnessPower("Smoothness Power", Range( 0 , 2)) = 1
		_AmbientOcclusionG("Ambient Occlusion (G)", 2D) = "white" {}
		_AmbientOcclusionPower("Ambient Occlusion Power", Range( 0 , 1)) = 1
		_DetailAlbedoMap("DetailAlbedoMap", 2D) = "white" {}
		_DetailMapTiling("Detail Map Tiling", Range( 0.0001 , 100)) = 15
		_DetailNormalMapScale("DetailNormalMapScale", Range( 0 , 2)) = 0
		_DetailNormalMap("DetailNormalMap", 2D) = "white" {}
		_Snow_Amount("Snow_Amount", Range( 0 , 2)) = 0.13
		_TriplanarCoverFalloff("Triplanar Cover Falloff", Range( 1 , 100)) = 8
		_SnowAlbedoRGB("Snow Albedo (RGB)", 2D) = "white" {}
		_SnowTiling("Snow Tiling", Range( 0.0001 , 100)) = 15
		_SnowAlbedoColor("Snow Albedo Color", Color) = (1,1,1,1)
		_SnowNormalRGB("Snow Normal (RGB)", 2D) = "white" {}
		_SnowNormalScale("Snow Normal Scale", Range( 0 , 2)) = 1
		_SnowNormalCoverHardness("Snow Normal Cover Hardness", Range( 0 , 10)) = 1
		_Snow_SpecularRGBSmoothnessA("Snow_Specular (RGB) Smoothness (A)", 2D) = "white" {}
		_SnowSpecularPower("Snow Specular Power", Range( 0 , 2)) = 1
		_SnowSmoothnessPower("Snow Smoothness Power", Range( 0 , 2)) = 1
		_SnowAmbientOcclusionG("Snow Ambient Occlusion(G)", 2D) = "white" {}
		_SnowAmbientOcclusionPower("Snow Ambient Occlusion Power", Range( 0 , 1)) = 1
		_SnowMaxAngle("Snow Max Angle", Range( 0.001 , 90)) = 90
		_SnowHardness("Snow Hardness", Range( 1 , 10)) = 5
		_Snow_Min_Height("Snow_Min_Height", Range( -1000 , 10000)) = -1000
		_SnowHeightG("Snow Height (G)", 2D) = "white" {}
		_SnowHeightSharpness("Snow Height Sharpness", Range( 0 , 2)) = 0.3
		_Snow_Min_Height_Blending("Snow_Min_Height_Blending", Range( 0 , 500)) = 1
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
		uniform fixed _SnowNormalCoverHardness;
		uniform sampler2D _SnowNormalRGB;
		uniform fixed _SnowTiling;
		uniform fixed _TriplanarCoverFalloff;
		uniform fixed _SnowNormalScale;
		uniform fixed _Snow_Amount;
		uniform fixed _SnowMaxAngle;
		uniform fixed _SnowHardness;
		uniform fixed _Snow_Min_Height;
		uniform fixed _Snow_Min_Height_Blending;
		uniform sampler2D _SnowHeightG;
		uniform fixed _SnowHeightSharpness;
		uniform sampler2D _DetailAlbedoMap;
		uniform sampler2D _SnowAlbedoRGB;
		uniform sampler2D _SpecularRGBSmoothnesA;
		uniform sampler2D _Snow_SpecularRGBSmoothnessA;
		uniform sampler2D _AmbientOcclusionG;
		uniform sampler2D _SnowAmbientOcclusionG;

		UNITY_INSTANCING_BUFFER_START(NatureManufactureShadersStandardSpecularSnow)
			UNITY_DEFINE_INSTANCED_PROP(fixed4, _Color)
#define _Color_arr NatureManufactureShadersStandardSpecularSnow
			UNITY_DEFINE_INSTANCED_PROP(fixed4, _SnowAlbedoColor)
#define _SnowAlbedoColor_arr NatureManufactureShadersStandardSpecularSnow
			UNITY_DEFINE_INSTANCED_PROP(fixed, _SpecularPower)
#define _SpecularPower_arr NatureManufactureShadersStandardSpecularSnow
			UNITY_DEFINE_INSTANCED_PROP(fixed, _SnowSpecularPower)
#define _SnowSpecularPower_arr NatureManufactureShadersStandardSpecularSnow
			UNITY_DEFINE_INSTANCED_PROP(fixed, _SmoothnessPower)
#define _SmoothnessPower_arr NatureManufactureShadersStandardSpecularSnow
			UNITY_DEFINE_INSTANCED_PROP(fixed, _SnowSmoothnessPower)
#define _SnowSmoothnessPower_arr NatureManufactureShadersStandardSpecularSnow
			UNITY_DEFINE_INSTANCED_PROP(fixed, _AmbientOcclusionPower)
#define _AmbientOcclusionPower_arr NatureManufactureShadersStandardSpecularSnow
			UNITY_DEFINE_INSTANCED_PROP(fixed, _SnowAmbientOcclusionPower)
#define _SnowAmbientOcclusionPower_arr NatureManufactureShadersStandardSpecularSnow
		UNITY_INSTANCING_BUFFER_END(NatureManufactureShadersStandardSpecularSnow)


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


		void surf( Input i , inout SurfaceOutputStandardSpecular o )
		{
			float2 uv_MainTex = i.uv_texcoord * _MainTex_ST.xy + _MainTex_ST.zw;
			float temp_output_185_0 = ( 1.0 / _DetailMapTiling );
			fixed3 ase_worldNormal = WorldNormalVector( i, fixed3( 0, 0, 1 ) );
			fixed3 ase_worldTangent = WorldNormalVector( i, fixed3( 1, 0, 0 ) );
			fixed3 ase_worldBitangent = WorldNormalVector( i, fixed3( 0, 1, 0 ) );
			float3x3 ase_worldToTangent = float3x3( ase_worldTangent, ase_worldBitangent, ase_worldNormal );
			float3 ase_worldPos = i.worldPos;
			float3 worldTriplanarNormal179 = TriplanarNormal( _DetailNormalMap, _DetailNormalMap, _DetailNormalMap, ase_worldPos, ase_worldNormal, 8.0, temp_output_185_0, 0 );
			float3 tanTriplanarNormal179 = mul( ase_worldToTangent, worldTriplanarNormal179 );
			float3 appendResult182 = (fixed3(_DetailNormalMapScale , _DetailNormalMapScale , 1.0));
			float temp_output_122_0 = ( 1.0 / _SnowTiling );
			float3 worldTriplanarNormal166 = TriplanarNormal( _SnowNormalRGB, _SnowNormalRGB, _SnowNormalRGB, ase_worldPos, ase_worldNormal, _TriplanarCoverFalloff, temp_output_122_0, 0 );
			float3 tanTriplanarNormal166 = mul( ase_worldToTangent, worldTriplanarNormal166 );
			float3 appendResult169 = (fixed3(_SnowNormalScale , _SnowNormalScale , 1.0));
			float clampResult89 = clamp( ase_worldNormal.y , 0.0 , 0.999999 );
			float temp_output_88_0 = ( _SnowMaxAngle / 45.0 );
			float clampResult98 = clamp( ( clampResult89 - ( 1.0 - temp_output_88_0 ) ) , 0.0 , 2.0 );
			float temp_output_83_0 = ( ( 1.0 - _Snow_Min_Height ) + ase_worldPos.y );
			float clampResult95 = clamp( ( temp_output_83_0 + 1.0 ) , 0.0 , 1.0 );
			float clampResult97 = clamp( ( ( 1.0 - ( ( temp_output_83_0 + _Snow_Min_Height_Blending ) / temp_output_83_0 ) ) + -0.5 ) , 0.0 , 1.0 );
			float clampResult103 = clamp( ( clampResult95 + clampResult97 ) , 0.0 , 1.0 );
			float temp_output_106_0 = ( pow( ( clampResult98 * ( 1.0 / temp_output_88_0 ) ) , _SnowHardness ) * clampResult103 );
			float3 lerpResult115 = lerp( UnpackScaleNormal( tex2D( _BumpMap, uv_MainTex ) ,_SnowNormalCoverHardness ) , ( tanTriplanarNormal166 * appendResult169 ) , ( saturate( ( ase_worldNormal.y * _Snow_Amount ) ) * temp_output_106_0 ));
			float3 newWorldNormal108 = WorldNormalVector( i , lerpResult115 );
			float4 triplanar175 = TriplanarSampling( _SnowHeightG, _SnowHeightG, _SnowHeightG, ase_worldPos, ase_worldNormal, _TriplanarCoverFalloff, temp_output_122_0, 0 );
			float temp_output_113_0 = saturate( ( ( ( newWorldNormal108.y * _Snow_Amount ) * ( ( _Snow_Amount * _SnowHardness ) * temp_output_106_0 ) ) * pow( triplanar175.y , _SnowHeightSharpness ) ) );
			float3 lerpResult177 = lerp( BlendNormals( UnpackScaleNormal( tex2D( _BumpMap, uv_MainTex ) ,_BumpScale ) , ( tanTriplanarNormal179 * appendResult182 ) ) , lerpResult115 , temp_output_113_0);
			o.Normal = lerpResult177;
			fixed4 _Color_Instance = UNITY_ACCESS_INSTANCED_PROP(_Color_arr, _Color);
			float4 triplanar178 = TriplanarSampling( _DetailAlbedoMap, _DetailAlbedoMap, _DetailAlbedoMap, ase_worldPos, ase_worldNormal, 8.0, temp_output_185_0, 0 );
			fixed4 blendOpSrc189 = ( tex2D( _MainTex, uv_MainTex ) * _Color_Instance );
			fixed4 blendOpDest189 = triplanar178;
			float4 triplanar162 = TriplanarSampling( _SnowAlbedoRGB, _SnowAlbedoRGB, _SnowAlbedoRGB, ase_worldPos, ase_worldNormal, _TriplanarCoverFalloff, temp_output_122_0, 0 );
			fixed4 _SnowAlbedoColor_Instance = UNITY_ACCESS_INSTANCED_PROP(_SnowAlbedoColor_arr, _SnowAlbedoColor);
			float4 lerpResult10 = lerp( 	max( blendOpSrc189, blendOpDest189 ) , ( triplanar162 * _SnowAlbedoColor_Instance ) , temp_output_113_0);
			o.Albedo = lerpResult10.xyz;
			fixed4 tex2DNode29 = tex2D( _SpecularRGBSmoothnesA, uv_MainTex );
			fixed _SpecularPower_Instance = UNITY_ACCESS_INSTANCED_PROP(_SpecularPower_arr, _SpecularPower);
			float4 triplanar165 = TriplanarSampling( _Snow_SpecularRGBSmoothnessA, _Snow_SpecularRGBSmoothnessA, _Snow_SpecularRGBSmoothnessA, ase_worldPos, ase_worldNormal, _TriplanarCoverFalloff, temp_output_122_0, 0 );
			float3 appendResult151 = (fixed3(triplanar165.x , triplanar165.y , triplanar165.z));
			fixed _SnowSpecularPower_Instance = UNITY_ACCESS_INSTANCED_PROP(_SnowSpecularPower_arr, _SnowSpecularPower);
			float4 lerpResult17 = lerp( ( tex2DNode29 * _SpecularPower_Instance ) , fixed4( ( appendResult151 * _SnowSpecularPower_Instance ) , 0.0 ) , temp_output_113_0);
			o.Specular = lerpResult17.rgb;
			fixed _SmoothnessPower_Instance = UNITY_ACCESS_INSTANCED_PROP(_SmoothnessPower_arr, _SmoothnessPower);
			fixed _SnowSmoothnessPower_Instance = UNITY_ACCESS_INSTANCED_PROP(_SnowSmoothnessPower_arr, _SnowSmoothnessPower);
			float lerpResult28 = lerp( ( tex2DNode29.a * _SmoothnessPower_Instance ) , ( triplanar165.w * _SnowSmoothnessPower_Instance ) , temp_output_113_0);
			o.Smoothness = lerpResult28;
			fixed _AmbientOcclusionPower_Instance = UNITY_ACCESS_INSTANCED_PROP(_AmbientOcclusionPower_arr, _AmbientOcclusionPower);
			float clampResult67 = clamp( tex2D( _AmbientOcclusionG, uv_MainTex ).g , ( 1.0 - _AmbientOcclusionPower_Instance ) , 1.0 );
			float4 triplanar170 = TriplanarSampling( _SnowAmbientOcclusionG, _SnowAmbientOcclusionG, _SnowAmbientOcclusionG, ase_worldPos, ase_worldNormal, _TriplanarCoverFalloff, temp_output_122_0, 0 );
			fixed _SnowAmbientOcclusionPower_Instance = UNITY_ACCESS_INSTANCED_PROP(_SnowAmbientOcclusionPower_arr, _SnowAmbientOcclusionPower);
			float clampResult69 = clamp( triplanar170.y , ( 1.0 - _SnowAmbientOcclusionPower_Instance ) , 1.0 );
			float lerpResult27 = lerp( clampResult67 , clampResult69 , temp_output_113_0);
			o.Occlusion = lerpResult27;
			o.Alpha = 1;
		}

		ENDCG
		CGPROGRAM
		#pragma surface surf StandardSpecular keepalpha fullforwardshadows 

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