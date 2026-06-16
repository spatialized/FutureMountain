// Upgrade NOTE: upgraded instancing buffer 'NatureManufactureShadersStandardMetalicUVFreeSnow' to new syntax.

 Shader "NatureManufacture Shaders/Standard Metalic UV Free Snow"
{
	Properties
	{
		_Color("Color", Color) = (1,1,1,1)
		_DetailAlbedoMap("DetailAlbedoMap", 2D) = "white" {}
		_Tiling("Tiling", Range( 0.0001 , 100)) = 15
		_SnowMetalicRAmbientOcclusionGSmoothnessA("Snow Metalic (R) Ambient Occlusion (G) Smoothness (A)", 2D) = "white" {}
		_TriplanarFalloff("Triplanar Falloff", Range( 1 , 100)) = 100
		_DetailNormalMap("DetailNormalMap", 2D) = "white" {}
		_DetailNormalMapScale("DetailNormalMapScale", Range( 0 , 5)) = 1
		_BumpMap("BumpMap", 2D) = "bump" {}
		_BumpScale("BumpScale", Range( 0 , 2)) = 1
		_ShapeAmbientOcclusionG("Shape Ambient Occlusion (G)", 2D) = "white" {}
		_ShapeAmbientOcclusionPower("Shape Ambient Occlusion Power", Range( 0 , 1)) = 1
		_MetalicRAmbientOcclusionGSmoothnessA("Metalic (R) Ambient Occlusion (G) Smoothness (A)", 2D) = "white" {}
		_MetalicPower("Metalic Power", Range( 0 , 2)) = 1
		_AmbientOcclusionPower("Ambient Occlusion Power", Range( 0 , 1)) = 0
		_SmoothnessPower("Smoothness Power", Range( 0 , 2)) = 1
		_SnowAlbedoRGB("Snow Albedo (RGB)", 2D) = "white" {}
		_SnowAlbedoColor("Snow Albedo Color", Color) = (1,1,1,1)
		_SnowTiling("Snow Tiling", Range( 0.0001 , 100)) = 15
		_SnowTriplanarFalloff("Snow Triplanar Falloff", Range( 1 , 100)) = 100
		_SnowNormalRGB("Snow Normal (RGB)", 2D) = "white" {}
		_SnowNormalScale("Snow Normal Scale", Range( 0 , 5)) = 1
		_SnowMetalicPower("Snow Metalic Power", Range( 0 , 2)) = 0
		_SnowAmbientOcclusionPower("Snow Ambient Occlusion Power", Range( 0 , 1)) = 0
		_SnowSmoothnessPower("Snow Smoothness Power", Range( 0 , 2)) = 0
		_Snow_Amount("Snow_Amount", Range( 0 , 2)) = 0.13
		_SnowHardness("Snow Hardness", Range( 1 , 10)) = 5
		_SnowMaxAngle("Snow Max Angle ", Range( 0.001 , 90)) = 90
		_Snow_Min_Height("Snow_Min_Height", Range( -1000 , 10000)) = -1000
		_Snow_Min_Height_Blending("Snow_Min_Height_Blending", Range( 0 , 500)) = 1
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

		uniform sampler2D _DetailNormalMap;
		uniform fixed _Tiling;
		uniform float _TriplanarFalloff;
		uniform fixed _DetailNormalMapScale;
		uniform fixed _BumpScale;
		uniform sampler2D _BumpMap;
		uniform float4 _DetailNormalMap_ST;
		uniform sampler2D _SnowNormalRGB;
		uniform fixed _SnowTiling;
		uniform float _SnowTriplanarFalloff;
		uniform fixed _SnowNormalScale;
		uniform fixed _Snow_Amount;
		uniform fixed _SnowMaxAngle;
		uniform fixed _SnowHardness;
		uniform fixed _Snow_Min_Height;
		uniform fixed _Snow_Min_Height_Blending;
		uniform sampler2D _DetailAlbedoMap;
		uniform sampler2D _SnowAlbedoRGB;
		uniform sampler2D _MetalicRAmbientOcclusionGSmoothnessA;
		uniform fixed _MetalicPower;
		uniform sampler2D _SnowMetalicRAmbientOcclusionGSmoothnessA;
		uniform fixed _SnowMetalicPower;
		uniform fixed _SmoothnessPower;
		uniform fixed _SnowSmoothnessPower;
		uniform sampler2D _ShapeAmbientOcclusionG;
		uniform fixed _ShapeAmbientOcclusionPower;
		uniform fixed _AmbientOcclusionPower;
		uniform fixed _SnowAmbientOcclusionPower;

		UNITY_INSTANCING_BUFFER_START(NatureManufactureShadersStandardMetalicUVFreeSnow)
			UNITY_DEFINE_INSTANCED_PROP(fixed4, _Color)
#define _Color_arr NatureManufactureShadersStandardMetalicUVFreeSnow
			UNITY_DEFINE_INSTANCED_PROP(fixed4, _SnowAlbedoColor)
#define _SnowAlbedoColor_arr NatureManufactureShadersStandardMetalicUVFreeSnow
		UNITY_INSTANCING_BUFFER_END(NatureManufactureShadersStandardMetalicUVFreeSnow)


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
			float temp_output_3656_0 = ( 1.0 / _Tiling );
			float3 ase_worldNormal = WorldNormalVector( i, float3( 0, 0, 1 ) );
			float3 ase_worldTangent = WorldNormalVector( i, float3( 1, 0, 0 ) );
			float3 ase_worldBitangent = WorldNormalVector( i, float3( 0, 1, 0 ) );
			float3x3 ase_worldToTangent = float3x3( ase_worldTangent, ase_worldBitangent, ase_worldNormal );
			float3 ase_worldPos = i.worldPos;
			float3 worldTriplanarNormal3729 = TriplanarNormal( _DetailNormalMap, _DetailNormalMap, _DetailNormalMap, ase_worldPos, ase_worldNormal, _TriplanarFalloff, temp_output_3656_0, 0 );
			float3 tanTriplanarNormal3729 = mul( ase_worldToTangent, worldTriplanarNormal3729 );
			float3 appendResult3730 = (float3(_DetailNormalMapScale , _DetailNormalMapScale , 1.0));
			float2 uv_DetailNormalMap = i.uv_texcoord * _DetailNormalMap_ST.xy + _DetailNormalMap_ST.zw;
			float temp_output_3685_0 = ( 1.0 / _SnowTiling );
			float3 worldTriplanarNormal3735 = TriplanarNormal( _SnowNormalRGB, _SnowNormalRGB, _SnowNormalRGB, ase_worldPos, ase_worldNormal, _SnowTriplanarFalloff, temp_output_3685_0, 0 );
			float3 tanTriplanarNormal3735 = mul( ase_worldToTangent, worldTriplanarNormal3735 );
			float3 appendResult3734 = (float3(_SnowNormalScale , _SnowNormalScale , 1.0));
			float clampResult3628 = clamp( ase_worldNormal.y , 0.0 , 0.999999 );
			float temp_output_3625_0 = ( _SnowMaxAngle / 45.0 );
			float clampResult3634 = clamp( ( clampResult3628 - ( 1.0 - temp_output_3625_0 ) ) , 0.0 , 2.0 );
			float temp_output_3620_0 = ( ( 1.0 - _Snow_Min_Height ) + ase_worldPos.y );
			float clampResult3636 = clamp( ( temp_output_3620_0 + 1.0 ) , 0.0 , 1.0 );
			float clampResult3633 = clamp( ( ( 1.0 - ( ( temp_output_3620_0 + _Snow_Min_Height_Blending ) / temp_output_3620_0 ) ) + -0.5 ) , 0.0 , 1.0 );
			float clampResult3643 = clamp( ( clampResult3636 + clampResult3633 ) , 0.0 , 1.0 );
			float temp_output_3645_0 = ( pow( ( clampResult3634 * ( 1.0 / temp_output_3625_0 ) ) , _SnowHardness ) * clampResult3643 );
			float3 lerpResult3647 = lerp( BlendNormals( ( tanTriplanarNormal3729 * appendResult3730 ) , UnpackScaleNormal( tex2D( _BumpMap, uv_DetailNormalMap ) ,_BumpScale ) ) , ( tanTriplanarNormal3735 * appendResult3734 ) , ( saturate( ( ase_worldNormal.y * _Snow_Amount ) ) * temp_output_3645_0 ));
			o.Normal = lerpResult3647;
			float4 triplanar3728 = TriplanarSampling( _DetailAlbedoMap, _DetailAlbedoMap, _DetailAlbedoMap, ase_worldPos, ase_worldNormal, _TriplanarFalloff, temp_output_3656_0, 0 );
			fixed4 _Color_Instance = UNITY_ACCESS_INSTANCED_PROP(_Color_arr, _Color);
			float4 triplanar3738 = TriplanarSampling( _SnowAlbedoRGB, _SnowAlbedoRGB, _SnowAlbedoRGB, ase_worldPos, ase_worldNormal, _SnowTriplanarFalloff, temp_output_3685_0, 0 );
			fixed4 _SnowAlbedoColor_Instance = UNITY_ACCESS_INSTANCED_PROP(_SnowAlbedoColor_arr, _SnowAlbedoColor);
			float3 newWorldNormal3648 = WorldNormalVector( i , lerpResult3647 );
			float temp_output_3653_0 = saturate( ( ( newWorldNormal3648.y * _Snow_Amount ) * ( ( _Snow_Amount * _SnowHardness ) * temp_output_3645_0 ) ) );
			float4 lerpResult3317 = lerp( ( triplanar3728 * _Color_Instance ) , ( triplanar3738 * _SnowAlbedoColor_Instance ) , temp_output_3653_0);
			float4 clampResult3290 = clamp( lerpResult3317 , float4( 0,0,0,0 ) , float4( 1,1,1,0 ) );
			o.Albedo = clampResult3290.xyz;
			float4 triplanar3731 = TriplanarSampling( _MetalicRAmbientOcclusionGSmoothnessA, _MetalicRAmbientOcclusionGSmoothnessA, _MetalicRAmbientOcclusionGSmoothnessA, ase_worldPos, ase_worldNormal, _TriplanarFalloff, temp_output_3656_0, 0 );
			float4 triplanar3737 = TriplanarSampling( _SnowMetalicRAmbientOcclusionGSmoothnessA, _SnowMetalicRAmbientOcclusionGSmoothnessA, _SnowMetalicRAmbientOcclusionGSmoothnessA, ase_worldPos, ase_worldNormal, _SnowTriplanarFalloff, temp_output_3685_0, 0 );
			float lerpResult3332 = lerp( ( triplanar3731.x * _MetalicPower ) , ( triplanar3737.x * _SnowMetalicPower ) , temp_output_3653_0);
			o.Metallic = lerpResult3332;
			float lerpResult3345 = lerp( ( triplanar3731.w * _SmoothnessPower ) , ( triplanar3737.w * _SnowSmoothnessPower ) , temp_output_3653_0);
			o.Smoothness = lerpResult3345;
			float clampResult3614 = clamp( tex2D( _ShapeAmbientOcclusionG, uv_DetailNormalMap ).g , ( 1.0 - _ShapeAmbientOcclusionPower ) , 1.0 );
			float clampResult3582 = clamp( triplanar3731.y , ( 1.0 - _AmbientOcclusionPower ) , 1.0 );
			float clampResult3589 = clamp( triplanar3737.y , ( 1.0 - _SnowAmbientOcclusionPower ) , 1.0 );
			float lerpResult3333 = lerp( clampResult3582 , clampResult3589 , temp_output_3653_0);
			o.Occlusion = ( clampResult3614 + lerpResult3333 );
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