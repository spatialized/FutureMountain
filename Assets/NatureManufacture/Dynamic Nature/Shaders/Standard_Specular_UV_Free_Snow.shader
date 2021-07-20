// Upgrade NOTE: upgraded instancing buffer 'NatureManufactureShadersStandardSpecularUVFreeSnow' to new syntax.

Shader "NatureManufacture Shaders/Standard Specular UV Free Snow"
{
	Properties
	{
		_DetailAlbedoMap("DetailAlbedoMap", 2D) = "bump" {}
		_TopTexture0("Top Texture 0", 2D) = "white" {}
		_SnowAmbientOcclusionG("Snow Ambient Occlusion(G)", 2D) = "white" {}
		_AmbientOcclusionG("Ambient Occlusion (G)", 2D) = "white" {}
		_AlbedoColor("Albedo Color", Color) = (1,1,1,1)
		_Tiling("Tiling", Range( 0.0001 , 100)) = 15
		_TriplanarFalloff("Triplanar Falloff", Range( 0 , 100)) = 100
		_DetailNormalMapScale("DetailNormalMapScale", Range( 0 , 5)) = 5
		_SpecularPower("Specular Power", Range( 0 , 2)) = 1
		_SmoothnessPower("Smoothness Power", Range( 0 , 2)) = 1
		_AmbientOcclusionPower("Ambient Occlusion Power", Range( 0 , 2)) = 1
		_BumpMap("BumpMap", 2D) = "bump" {}
		_BumpScale("BumpScale", Range( 0 , 2)) = 1
		_ShapeAmbientOcclusionG("Shape Ambient Occlusion (G)", 2D) = "white" {}
		_ShapeAmbientOcclusionPower("Shape Ambient Occlusion Power", Range( 0 , 1)) = 1
		_SnowAlbedoRGB("Snow Albedo (RGB)", 2D) = "white" {}
		_SnowTiling("Snow Tiling", Range( 0.0001 , 100)) = 15
		_SnowAlbedoColor("Snow Albedo Color", Color) = (1,1,1,1)
		_SnowTriplanarFalloff("Snow Triplanar Falloff", Range( 0 , 100)) = 100
		_SnowNormalRGB("Snow Normal (RGB)", 2D) = "bump" {}
		_SnowNormalScale("Snow Normal Scale", Range( 0 , 5)) = 1
		_SnowSpecularRGBSmoothnessA("Snow Specular (RGB) Smoothness (A)", 2D) = "white" {}
		_SnowSpecularPower("Snow Specular Power", Range( 0 , 2)) = 1
		_SnowSmoothnessPower("Snow Smoothness Power", Range( 0 , 2)) = 1
		_SnowAmbientOcclusionPower("Snow Ambient Occlusion Power", Range( 0 , 1)) = 1
		_Snow_Amount("Snow_Amount", Range( 0 , 2)) = 0
		_SnowMaxAngle("Snow Max Angle", Float) = 0
		_SnowHardness("Snow Hardness", Float) = 0
		_Snow_Min_Height("Snow_Min_Height", Float) = 0
		_Snow_Min_Height_Blending("Snow_Min_Height_Blending", Float) = 0
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
			float3 worldPos;
			float3 worldNormal;
			INTERNAL_DATA
			float2 uv_texcoord;
		};

		uniform sampler2D _TopTexture0;
		uniform fixed _Tiling;
		uniform fixed _TriplanarFalloff;
		uniform sampler2D _SnowAlbedoRGB;
		uniform fixed _SnowTiling;
		uniform fixed _SnowTriplanarFalloff;
		uniform sampler2D _BumpMap;
		uniform sampler2D _DetailAlbedoMap;
		uniform float4 _DetailAlbedoMap_ST;
		uniform fixed _DetailNormalMapScale;
		uniform sampler2D _SnowNormalRGB;
		uniform fixed _SnowNormalScale;
		uniform fixed _Snow_Amount;
		uniform fixed _SnowMaxAngle;
		uniform fixed _SnowHardness;
		uniform fixed _Snow_Min_Height;
		uniform fixed _Snow_Min_Height_Blending;
		uniform fixed _SpecularPower;
		uniform sampler2D _AmbientOcclusionG;
		uniform sampler2D _SnowSpecularRGBSmoothnessA;
		uniform sampler2D _ShapeAmbientOcclusionG;
		uniform fixed _ShapeAmbientOcclusionPower;
		uniform fixed _AmbientOcclusionPower;
		uniform sampler2D _SnowAmbientOcclusionG;

		UNITY_INSTANCING_BUFFER_START(NatureManufactureShadersStandardSpecularUVFreeSnow)
			UNITY_DEFINE_INSTANCED_PROP(fixed4, _AlbedoColor)
#define _AlbedoColor_arr NatureManufactureShadersStandardSpecularUVFreeSnow
			UNITY_DEFINE_INSTANCED_PROP(fixed4, _SnowAlbedoColor)
#define _SnowAlbedoColor_arr NatureManufactureShadersStandardSpecularUVFreeSnow
			UNITY_DEFINE_INSTANCED_PROP(fixed, _BumpScale)
#define _BumpScale_arr NatureManufactureShadersStandardSpecularUVFreeSnow
			UNITY_DEFINE_INSTANCED_PROP(fixed, _SnowSpecularPower)
#define _SnowSpecularPower_arr NatureManufactureShadersStandardSpecularUVFreeSnow
			UNITY_DEFINE_INSTANCED_PROP(fixed, _SmoothnessPower)
#define _SmoothnessPower_arr NatureManufactureShadersStandardSpecularUVFreeSnow
			UNITY_DEFINE_INSTANCED_PROP(fixed, _SnowSmoothnessPower)
#define _SnowSmoothnessPower_arr NatureManufactureShadersStandardSpecularUVFreeSnow
			UNITY_DEFINE_INSTANCED_PROP(fixed, _SnowAmbientOcclusionPower)
#define _SnowAmbientOcclusionPower_arr NatureManufactureShadersStandardSpecularUVFreeSnow
		UNITY_INSTANCING_BUFFER_END(NatureManufactureShadersStandardSpecularUVFreeSnow)


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


		void surf( Input i , inout SurfaceOutputStandardSpecular o )
		{
			o.Normal = float3(0,0,1);
			float temp_output_3715_0 = ( 1.0 / _Tiling );
			float3 ase_worldPos = i.worldPos;
			fixed3 ase_worldNormal = WorldNormalVector( i, fixed3( 0, 0, 1 ) );
			float4 triplanar3768 = TriplanarSampling( _TopTexture0, _TopTexture0, _TopTexture0, ase_worldPos, ase_worldNormal, _TriplanarFalloff, temp_output_3715_0, 0 );
			fixed4 _AlbedoColor_Instance = UNITY_ACCESS_INSTANCED_PROP(_AlbedoColor_arr, _AlbedoColor);
			float temp_output_3742_0 = ( 1.0 / _SnowTiling );
			float4 triplanar3776 = TriplanarSampling( _SnowAlbedoRGB, _SnowAlbedoRGB, _SnowAlbedoRGB, ase_worldPos, ase_worldNormal, _SnowTriplanarFalloff, temp_output_3742_0, 0 );
			fixed4 _SnowAlbedoColor_Instance = UNITY_ACCESS_INSTANCED_PROP(_SnowAlbedoColor_arr, _SnowAlbedoColor);
			fixed _BumpScale_Instance = UNITY_ACCESS_INSTANCED_PROP(_BumpScale_arr, _BumpScale);
			float2 uv_DetailAlbedoMap = i.uv_texcoord * _DetailAlbedoMap_ST.xy + _DetailAlbedoMap_ST.zw;
			fixed3 ase_worldTangent = WorldNormalVector( i, fixed3( 1, 0, 0 ) );
			fixed3 ase_worldBitangent = WorldNormalVector( i, fixed3( 0, 1, 0 ) );
			float3x3 ase_worldToTangent = float3x3( ase_worldTangent, ase_worldBitangent, ase_worldNormal );
			float3 worldTriplanarNormal3771 = TriplanarNormal( _DetailAlbedoMap, _DetailAlbedoMap, _DetailAlbedoMap, ase_worldPos, ase_worldNormal, _TriplanarFalloff, temp_output_3715_0, 0 );
			float3 tanTriplanarNormal3771 = mul( ase_worldToTangent, worldTriplanarNormal3771 );
			float3 appendResult3772 = (fixed3(_DetailNormalMapScale , _DetailNormalMapScale , 1.0));
			float3 worldTriplanarNormal3778 = TriplanarNormal( _SnowNormalRGB, _SnowNormalRGB, _SnowNormalRGB, ase_worldPos, ase_worldNormal, _SnowTriplanarFalloff, temp_output_3742_0, 0 );
			float3 tanTriplanarNormal3778 = mul( ase_worldToTangent, worldTriplanarNormal3778 );
			float3 appendResult3779 = (fixed3(_SnowNormalScale , _SnowNormalScale , 0.0));
			float clampResult3644 = clamp( ase_worldNormal.y , 0.0 , 0.999999 );
			float temp_output_3640_0 = ( _SnowMaxAngle / 45.0 );
			float clampResult3659 = clamp( ( clampResult3644 - ( 1.0 - temp_output_3640_0 ) ) , 0.0 , 2.0 );
			float temp_output_3637_0 = ( ( 1.0 - _Snow_Min_Height ) + ase_worldPos.y );
			float clampResult3657 = clamp( ( temp_output_3637_0 + 1.0 ) , 0.0 , 1.0 );
			float clampResult3656 = clamp( ( ( 1.0 - ( ( temp_output_3637_0 + _Snow_Min_Height_Blending ) / temp_output_3637_0 ) ) + -0.5 ) , 0.0 , 1.0 );
			float clampResult3670 = clamp( ( clampResult3657 + clampResult3656 ) , 0.0 , 1.0 );
			float temp_output_3673_0 = ( pow( ( clampResult3659 * ( 1.0 / temp_output_3640_0 ) ) , _SnowHardness ) * clampResult3670 );
			float3 lerpResult3676 = lerp( BlendNormals( UnpackScaleNormal( tex2D( _BumpMap, uv_DetailAlbedoMap ) ,_BumpScale_Instance ) , ( tanTriplanarNormal3771 * appendResult3772 ) ) , ( tanTriplanarNormal3778 * appendResult3779 ) , ( saturate( ( ase_worldNormal.y * _Snow_Amount ) ) * temp_output_3673_0 ));
			float3 newWorldNormal3678 = WorldNormalVector( i , lerpResult3676 );
			float temp_output_3682_0 = saturate( ( ( newWorldNormal3678.y * _Snow_Amount ) * ( ( _Snow_Amount * _SnowHardness ) * temp_output_3673_0 ) ) );
			float4 lerpResult3317 = lerp( ( triplanar3768 * _AlbedoColor_Instance ) , ( triplanar3776 * _SnowAlbedoColor_Instance ) , temp_output_3682_0);
			float4 clampResult3290 = clamp( lerpResult3317 , float4( 0,0,0,0 ) , float4( 1,1,1,0 ) );
			o.Albedo = clampResult3290.xyz;
			float4 triplanar3775 = TriplanarSampling( _AmbientOcclusionG, _AmbientOcclusionG, _AmbientOcclusionG, ase_worldPos, ase_worldNormal, _TriplanarFalloff, temp_output_3715_0, 0 );
			float3 appendResult3389 = (fixed3(triplanar3775.x , triplanar3775.y , triplanar3775.z));
			float4 triplanar3780 = TriplanarSampling( _SnowSpecularRGBSmoothnessA, _SnowSpecularRGBSmoothnessA, _SnowSpecularRGBSmoothnessA, ase_worldPos, ase_worldNormal, _SnowTriplanarFalloff, temp_output_3742_0, 0 );
			float3 appendResult3467 = (fixed3(triplanar3780.x , triplanar3780.y , triplanar3780.z));
			fixed _SnowSpecularPower_Instance = UNITY_ACCESS_INSTANCED_PROP(_SnowSpecularPower_arr, _SnowSpecularPower);
			float3 lerpResult3332 = lerp( ( _SpecularPower * appendResult3389 ) , ( appendResult3467 * _SnowSpecularPower_Instance ) , temp_output_3682_0);
			o.Specular = lerpResult3332;
			fixed _SmoothnessPower_Instance = UNITY_ACCESS_INSTANCED_PROP(_SmoothnessPower_arr, _SmoothnessPower);
			fixed _SnowSmoothnessPower_Instance = UNITY_ACCESS_INSTANCED_PROP(_SnowSmoothnessPower_arr, _SnowSmoothnessPower);
			float lerpResult3345 = lerp( ( triplanar3775.w * _SmoothnessPower_Instance ) , ( triplanar3780.w * _SnowSmoothnessPower_Instance ) , temp_output_3682_0);
			o.Smoothness = lerpResult3345;
			float clampResult3626 = clamp( tex2D( _ShapeAmbientOcclusionG, uv_DetailAlbedoMap ).g , ( 1.0 - _ShapeAmbientOcclusionPower ) , 1.0 );
			float4 triplanar3774 = TriplanarSampling( _TopTexture0, _TopTexture0, _TopTexture0, ase_worldPos, ase_worldNormal, _TriplanarFalloff, temp_output_3715_0, 0 );
			float clampResult3629 = clamp( triplanar3774.y , ( 1.0 - _AmbientOcclusionPower ) , 1 );
			float4 triplanar3783 = TriplanarSampling( _SnowAmbientOcclusionG, _SnowAmbientOcclusionG, _SnowAmbientOcclusionG, ase_worldPos, ase_worldNormal, _SnowTriplanarFalloff, temp_output_3742_0, 0 );
			fixed _SnowAmbientOcclusionPower_Instance = UNITY_ACCESS_INSTANCED_PROP(_SnowAmbientOcclusionPower_arr, _SnowAmbientOcclusionPower);
			float clampResult3632 = clamp( 0.0 , ( triplanar3783.y - _SnowAmbientOcclusionPower_Instance ) , 1.0 );
			float lerpResult3333 = lerp( ( clampResult3626 + clampResult3629 ) , clampResult3632 , temp_output_3682_0);
			o.Occlusion = lerpResult3333;
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