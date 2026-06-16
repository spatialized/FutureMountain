
Shader "NatureManufacture Shaders/Tree Leaves Specular Snow Season"
{
	Properties
	{
		[Header(Translucency)]
		_Translucency("Strength", Range( 0 , 50)) = 1
		_TransNormalDistortion("Normal Distortion", Range( 0 , 1)) = 0.1
		_TransScattering("Scaterring Falloff", Range( 1 , 50)) = 2
		_TransDirect("Direct", Range( 0 , 1)) = 1
		_TransAmbient("Ambient", Range( 0 , 1)) = 0.2
		_TranslucencyColor("Translucency Color", Color) = (0.7585312,0.8676471,0.6124567,0)
		_TransShadow("Shadow", Range( 0 , 1)) = 0.9
		_Cutoff( "Mask Clip Value", Float ) = 0.2
		_Season("Season", Range( 0 , 4)) = 0
		_Snow_Amount("Snow_Amount", Range( 0 , 2)) = 0.13
		_SnowAngleOverlay("Snow Angle Overlay", Range( 0 , 1)) = 0.5
		_SnowBrightnessReduction("Snow Brightness Reduction", Range( 0 , 0.5)) = 0.2
		_MainTex("MainTex", 2D) = "white" {}
		_Color("Color", Color) = (0,0,0,0)
		_BumpMap("BumpMap", 2D) = "bump" {}
		_BumpScale("BumpScale", Range( 0 , 3)) = 3
		_SpecularRGBSmothnessA("Specular (RGB) Smothness (A)", 2D) = "white" {}
		_SmothnessPower("Smothness Power", Range( 0 , 2)) = 0
		_AmbientOcclusionG("Ambient Occlusion (G)", 2D) = "white" {}
		_AmbientOcclusionPower("Ambient Occlusion Power", Range( 0 , 1)) = 1
		_AlbedoAutumnRGB("Albedo Autumn (RGB)", 2D) = "white" {}
		_SpecularPower("Specular Power", Range( 0 , 2)) = 0
		_SnowAlbedoRGB("Snow Albedo (RGB)", 2D) = "white" {}
		_SnowNormalRGB("Snow Normal (RGB)", 2D) = "bump" {}
		_SnowSpecularRGBSmothnessA("Snow Specular (RGB) Smothness (A)", 2D) = "white" {}
		_SnowSpecularPower("Snow Specular Power", Range( 0 , 2)) = 1
		_SnowSmothnessPower("Snow Smothness Power", Range( 0 , 3)) = 1
		_SnowAmbientOcclusionG("Snow Ambient Occlusion (G)", 2D) = "white" {}
		_SnowAmbientOcclusionPower("Snow Ambient Occlusion Power", Range( 0 , 1)) = 1
		[Toggle]_WindVertexColorMainRNoiseB("Wind Vertex Color Main (R) Noise (B)", Int) = 1
		_WindColorMultiply("Wind Color Multiply", Vector) = (1,1,1,0)
		_WindPower("Wind Power", Range( 0 , 3)) = 0.3
		_WindPowerDirectionZ("Wind Power Direction Z", Range( -1 , 1)) = 1
		_WindPowerDirectionX("Wind Power Direction X", Range( -1 , 1)) = 1
		_WindNoiseSpeed("Wind Noise Speed", Float) = 2
		_WindNoisePower("Wind Noise Power", Range( 0 , 2)) = 1
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "TransparentCutout"  "Queue" = "AlphaTest+0" }
		Cull Off
		CGINCLUDE
		#include "UnityStandardUtils.cginc"
		#include "UnityShaderVariables.cginc"
		#include "UnityPBSLighting.cginc"
		#include "Lighting.cginc"
		#pragma target 3.0
		#pragma multi_compile_instancing
		#pragma multi_compile __ _WINDVERTEXCOLORMAINRNOISEB_ON
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
			fixed2 uv_texcoord;
			float4 vertexColor : COLOR;
			float3 worldPos;
			float3 worldNormal;
			INTERNAL_DATA
		};

		struct SurfaceOutputStandardSpecularCustom
		{
			fixed3 Albedo;
			fixed3 Normal;
			half3 Emission;
			fixed3 Specular;
			half Smoothness;
			half Occlusion;
			fixed Alpha;
			fixed3 Translucency;
		};

		uniform fixed _BumpScale;
		uniform sampler2D _BumpMap;
		uniform sampler2D _MainTex;
		uniform float4 _MainTex_ST;
		uniform fixed4 _Color;
		uniform sampler2D _AlbedoAutumnRGB;
		uniform fixed _Season;
		uniform fixed3 _WindColorMultiply;
		uniform fixed _WindPower;
		uniform fixed _WindPowerDirectionX;
		uniform fixed _WindPowerDirectionZ;
		uniform fixed _WindNoisePower;
		uniform fixed _WindNoiseSpeed;
		uniform sampler2D _SnowAlbedoRGB;
		uniform sampler2D _SnowNormalRGB;
		uniform float4 _SnowNormalRGB_ST;
		uniform fixed _SnowBrightnessReduction;
		uniform fixed _Snow_Amount;
		uniform fixed _SnowAngleOverlay;
		uniform sampler2D _SpecularRGBSmothnessA;
		uniform fixed _SpecularPower;
		uniform fixed _SnowSpecularPower;
		uniform sampler2D _SnowSpecularRGBSmothnessA;
		uniform fixed _SmothnessPower;
		uniform fixed _SnowSmothnessPower;
		uniform sampler2D _AmbientOcclusionG;
		uniform fixed _AmbientOcclusionPower;
		uniform sampler2D _SnowAmbientOcclusionG;
		uniform fixed _SnowAmbientOcclusionPower;
		uniform half _Translucency;
		uniform half _TransNormalDistortion;
		uniform half _TransScattering;
		uniform half _TransDirect;
		uniform half _TransAmbient;
		uniform half _TransShadow;
		uniform fixed4 _TranslucencyColor;
		uniform float _Cutoff = 0.2;

		void vertexDataFunc( inout appdata_full v, out Input o )
		{
			UNITY_INITIALIZE_OUTPUT( Input, o );
			float2 appendResult213 = (fixed2(_WindPowerDirectionX , _WindPowerDirectionZ));
			float mulTime262 = _Time.y * 0.7;
			float3 ase_worldPos = mul( unity_ObjectToWorld, v.vertex );
			float2 appendResult260 = (fixed2(ase_worldPos.x , ase_worldPos.z));
			float2 temp_output_267_0 = sin( ( mulTime262 + ( appendResult260 * float2( 0.1,0.1 ) ) ) );
			float2 clampResult291 = clamp( ( temp_output_267_0 * float2( 0.1,0.1 ) ) , float2( 0,0 ) , float2( 1,1 ) );
			float2 lerpResult274 = lerp( temp_output_267_0 , ( 1.0 - temp_output_267_0 ) , clampResult291.x);
			float2 appendResult284 = (fixed2(( lerpResult274.x + 0.3 ) , lerpResult274.y));
			float2 appendResult265 = (fixed2(ase_worldPos.x , ase_worldPos.z));
			float mulTime266 = _Time.y * 0.0004;
			float2 temp_output_276_0 = sin( ( ( appendResult260 + ( appendResult265 * mulTime266 ) ) * float2( 0.6,0.8 ) ) );
			float cos278 = cos( _SinTime.w );
			float sin278 = sin( _SinTime.w );
			float2 rotator278 = mul( temp_output_276_0 - float2( 0.1,0.3 ) , float2x2( cos278 , -sin278 , sin278 , cos278 )) + float2( 0.1,0.3 );
			float cos277 = cos( temp_output_276_0.x );
			float sin277 = sin( temp_output_276_0.x );
			float2 rotator277 = mul( temp_output_276_0 - float2( 1,0.9 ) , float2x2( cos277 , -sin277 , sin277 , cos277 )) + float2( 1,0.9 );
			float2 clampResult280 = clamp( lerpResult274 , float2( 0.3,0 ) , float2( 1.0,0 ) );
			float2 lerpResult281 = lerp( rotator278 , rotator277 , clampResult280.x);
			float2 clampResult283 = clamp( lerpResult281 , float2( 0.3,0.3 ) , float2( 0.7,0.7 ) );
			float mulTime293 = _Time.y * _WindNoiseSpeed;
			float lerpResult296 = lerp( _WindNoisePower , ( _WindNoisePower * 0.5 ) , sin( mulTime293 ));
			fixed2 temp_cast_4 = (ase_worldPos.y).xx;
			float2 panner220 = ( temp_cast_4 + clampResult283.x * float2( 10000,4000 ));
			float2 lerpResult226 = lerp( float2( 0,0 ) , panner220 , v.color.b);
			float2 temp_output_231_0 = ( lerpResult296 * ( lerpResult226 * float2( 0.0001,0.0001 ) ) );
			float mulTime286 = _Time.y * 0.9;
			float cos229 = cos( lerpResult274.x );
			float sin229 = sin( lerpResult274.x );
			float2 rotator229 = mul( sin( ( mulTime286 + ( appendResult260 * float2( 0.5,0.5 ) ) ) ) - float2( 0.5,0.5 ) , float2x2( cos229 , -sin229 , sin229 , cos229 )) + float2( 0.5,0.5 );
			float2 clampResult230 = clamp( rotator229 , float2( 0.2,0.2 ) , float2( 0.8,0.8 ) );
			float2 lerpResult235 = lerp( temp_output_231_0 , ( temp_output_231_0 * float2( 0.45,0.45 ) ) , clampResult230.x);
			float3 appendResult237 = (fixed3(( ( v.color.r * _WindPower ) * ( ( appendResult213 * float2( 0.8,0.8 ) ) + ( appendResult284 + clampResult283 ) ) ).x , lerpResult235.x , ( ( v.color.r * _WindPower ) * ( ( appendResult213 * float2( 0.8,0.8 ) ) + ( appendResult284 + clampResult283 ) ) ).y));
			#ifdef _WINDVERTEXCOLORMAINRNOISEB_ON
				float3 staticSwitch239 = appendResult237;
			#else
				float3 staticSwitch239 = fixed3(0,0,0);
			#endif
			float4 transform240 = mul(unity_WorldToObject,fixed4( staticSwitch239 , 0.0 ));
			v.vertex.xyz += transform240.xyz;
		}

		inline half4 LightingStandardSpecularCustom(SurfaceOutputStandardSpecularCustom s, half3 viewDir, UnityGI gi )
		{
			#if !DIRECTIONAL
			float3 lightAtten = gi.light.color;
			#else
			float3 lightAtten = lerp( _LightColor0.rgb, gi.light.color, _TransShadow );
			#endif
			half3 lightDir = gi.light.dir + s.Normal * _TransNormalDistortion;
			half transVdotL = pow( saturate( dot( viewDir, -lightDir ) ), _TransScattering );
			half3 translucency = lightAtten * (transVdotL * _TransDirect + gi.indirect.diffuse * _TransAmbient) * s.Translucency;
			half4 c = half4( s.Albedo * translucency * _Translucency, 0 );

			SurfaceOutputStandardSpecular r;
			r.Albedo = s.Albedo;
			r.Normal = s.Normal;
			r.Emission = s.Emission;
			r.Specular = s.Specular;
			r.Smoothness = s.Smoothness;
			r.Occlusion = s.Occlusion;
			r.Alpha = s.Alpha;
			return LightingStandardSpecular (r, viewDir, gi) + c;
		}

		inline void LightingStandardSpecularCustom_GI(SurfaceOutputStandardSpecularCustom s, UnityGIInput data, inout UnityGI gi )
		{
			UNITY_GI(gi, s, data);
		}

		void surf( Input i , inout SurfaceOutputStandardSpecularCustom o )
		{
			float2 uv_MainTex = i.uv_texcoord * _MainTex_ST.xy + _MainTex_ST.zw;
			fixed3 tex2DNode4 = UnpackScaleNormal( tex2D( _BumpMap, uv_MainTex ) ,_BumpScale );
			o.Normal = tex2DNode4;
			fixed4 tex2DNode3 = tex2D( _MainTex, uv_MainTex );
			float clampResult255 = clamp( ( _Season - 2.0 ) , 0.0 , 1.0 );
			float4 lerpResult108 = lerp( tex2DNode3 , tex2D( _AlbedoAutumnRGB, uv_MainTex ) , clampResult255);
			float2 appendResult213 = (fixed2(_WindPowerDirectionX , _WindPowerDirectionZ));
			float mulTime262 = _Time.y * 0.7;
			float3 ase_worldPos = i.worldPos;
			float2 appendResult260 = (fixed2(ase_worldPos.x , ase_worldPos.z));
			float2 temp_output_267_0 = sin( ( mulTime262 + ( appendResult260 * float2( 0.1,0.1 ) ) ) );
			float2 clampResult291 = clamp( ( temp_output_267_0 * float2( 0.1,0.1 ) ) , float2( 0,0 ) , float2( 1,1 ) );
			float2 lerpResult274 = lerp( temp_output_267_0 , ( 1.0 - temp_output_267_0 ) , clampResult291.x);
			float2 appendResult284 = (fixed2(( lerpResult274.x + 0.3 ) , lerpResult274.y));
			float2 appendResult265 = (fixed2(ase_worldPos.x , ase_worldPos.z));
			float mulTime266 = _Time.y * 0.0004;
			float2 temp_output_276_0 = sin( ( ( appendResult260 + ( appendResult265 * mulTime266 ) ) * float2( 0.6,0.8 ) ) );
			float cos278 = cos( _SinTime.w );
			float sin278 = sin( _SinTime.w );
			float2 rotator278 = mul( temp_output_276_0 - float2( 0.1,0.3 ) , float2x2( cos278 , -sin278 , sin278 , cos278 )) + float2( 0.1,0.3 );
			float cos277 = cos( temp_output_276_0.x );
			float sin277 = sin( temp_output_276_0.x );
			float2 rotator277 = mul( temp_output_276_0 - float2( 1,0.9 ) , float2x2( cos277 , -sin277 , sin277 , cos277 )) + float2( 1,0.9 );
			float2 clampResult280 = clamp( lerpResult274 , float2( 0.3,0 ) , float2( 1.0,0 ) );
			float2 lerpResult281 = lerp( rotator278 , rotator277 , clampResult280.x);
			float2 clampResult283 = clamp( lerpResult281 , float2( 0.3,0.3 ) , float2( 0.7,0.7 ) );
			float mulTime293 = _Time.y * _WindNoiseSpeed;
			float lerpResult296 = lerp( _WindNoisePower , ( _WindNoisePower * 0.5 ) , sin( mulTime293 ));
			fixed2 temp_cast_5 = (ase_worldPos.y).xx;
			float2 panner220 = ( temp_cast_5 + clampResult283.x * float2( 10000,4000 ));
			float2 lerpResult226 = lerp( float2( 0,0 ) , panner220 , i.vertexColor.b);
			float2 temp_output_231_0 = ( lerpResult296 * ( lerpResult226 * float2( 0.0001,0.0001 ) ) );
			float mulTime286 = _Time.y * 0.9;
			float cos229 = cos( lerpResult274.x );
			float sin229 = sin( lerpResult274.x );
			float2 rotator229 = mul( sin( ( mulTime286 + ( appendResult260 * float2( 0.5,0.5 ) ) ) ) - float2( 0.5,0.5 ) , float2x2( cos229 , -sin229 , sin229 , cos229 )) + float2( 0.5,0.5 );
			float2 clampResult230 = clamp( rotator229 , float2( 0.2,0.2 ) , float2( 0.8,0.8 ) );
			float2 lerpResult235 = lerp( temp_output_231_0 , ( temp_output_231_0 * float2( 0.45,0.45 ) ) , clampResult230.x);
			float3 appendResult237 = (fixed3(( ( i.vertexColor.r * _WindPower ) * ( ( appendResult213 * float2( 0.8,0.8 ) ) + ( appendResult284 + clampResult283 ) ) ).x , lerpResult235.x , ( ( i.vertexColor.r * _WindPower ) * ( ( appendResult213 * float2( 0.8,0.8 ) ) + ( appendResult284 + clampResult283 ) ) ).y));
			#ifdef _WINDVERTEXCOLORMAINRNOISEB_ON
				float3 staticSwitch239 = appendResult237;
			#else
				float3 staticSwitch239 = fixed3(0,0,0);
			#endif
			float4 transform240 = mul(unity_WorldToObject,fixed4( staticSwitch239 , 0.0 ));
			float clampResult258 = clamp( transform240.x , 0.0 , 1.0 );
			float4 lerpResult182 = lerp( lerpResult108 , ( lerpResult108 * fixed4( _WindColorMultiply , 0.0 ) ) , clampResult258);
			float4 temp_output_97_0 = ( _Color * lerpResult182 );
			float2 uv_SnowNormalRGB = i.uv_texcoord * _SnowNormalRGB_ST.xy + _SnowNormalRGB_ST.zw;
			float3 appendResult112 = (fixed3(_SnowBrightnessReduction , _SnowBrightnessReduction , _SnowBrightnessReduction));
			fixed3 ase_worldNormal = WorldNormalVector( i, fixed3( 0, 0, 1 ) );
			float3 lerpResult41 = lerp( tex2DNode4 , UnpackNormal( tex2D( _SnowNormalRGB, uv_SnowNormalRGB ) ) , saturate( ( ase_worldNormal.y * _Snow_Amount ) ));
			float3 newWorldNormal46 = WorldNormalVector( i , lerpResult41 );
			float temp_output_45_0 = saturate( ( ( newWorldNormal46.y + _SnowAngleOverlay ) * _Snow_Amount ) );
			float lerpResult94 = lerp( 0.0 , ( 1.0 - temp_output_45_0 ) , _Snow_Amount);
			float clampResult93 = clamp( ( temp_output_45_0 + lerpResult94 ) , 0.0 , 1.0 );
			float4 lerpResult51 = lerp( temp_output_97_0 , ( tex2D( _SnowAlbedoRGB, uv_SnowNormalRGB ) - fixed4( appendResult112 , 0.0 ) ) , clampResult93);
			o.Albedo = lerpResult51.rgb;
			fixed4 tex2DNode28 = tex2D( _SpecularRGBSmothnessA, uv_MainTex );
			float3 appendResult100 = (fixed3(tex2DNode28.r , tex2DNode28.g , tex2DNode28.b));
			fixed4 tex2DNode64 = tex2D( _SnowSpecularRGBSmothnessA, uv_SnowNormalRGB );
			float3 appendResult101 = (fixed3(tex2DNode64.r , tex2DNode64.g , tex2DNode64.b));
			float3 lerpResult53 = lerp( ( appendResult100 * _SpecularPower ) , ( _SnowSpecularPower * appendResult101 ) , temp_output_45_0);
			o.Specular = lerpResult53;
			float lerpResult66 = lerp( ( tex2DNode28.a * _SmothnessPower ) , ( tex2DNode64.a * _SnowSmothnessPower ) , temp_output_45_0);
			o.Smoothness = lerpResult66;
			float clampResult114 = clamp( tex2D( _AmbientOcclusionG, uv_MainTex ).g , ( 1.0 - _AmbientOcclusionPower ) , 1.0 );
			float clampResult116 = clamp( tex2D( _SnowAmbientOcclusionG, uv_SnowNormalRGB ).g , ( 1.0 - _SnowAmbientOcclusionPower ) , 1.0 );
			float lerpResult65 = lerp( clampResult114 , clampResult116 , temp_output_45_0);
			o.Occlusion = lerpResult65;
			float4 lerpResult54 = lerp( ( _TranslucencyColor * ( temp_output_97_0 - fixed4( ( appendResult112 * _Snow_Amount ) , 0.0 ) ) ) , float4( 0,0,0,0 ) , temp_output_45_0);
			o.Translucency = lerpResult54.rgb;
			o.Alpha = 1;
			clip( tex2DNode3.a - _Cutoff );
		}

		ENDCG
		CGPROGRAM
		#pragma surface surf StandardSpecularCustom keepalpha fullforwardshadows exclude_path:deferred dithercrossfade vertex:vertexDataFunc 

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
			#if ( SHADER_API_D3D11 || SHADER_API_GLCORE || SHADER_API_GLES3 || SHADER_API_METAL || SHADER_API_VULKAN )
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
				Input customInputData;
				vertexDataFunc( v, customInputData );
				float3 worldPos = mul( unity_ObjectToWorld, v.vertex ).xyz;
				fixed3 worldNormal = UnityObjectToWorldNormal( v.normal );
				fixed3 worldTangent = UnityObjectToWorldDir( v.tangent.xyz );
				fixed tangentSign = v.tangent.w * unity_WorldTransformParams.w;
				fixed3 worldBinormal = cross( worldNormal, worldTangent ) * tangentSign;
				o.tSpace0 = float4( worldTangent.x, worldBinormal.x, worldNormal.x, worldPos.x );
				o.tSpace1 = float4( worldTangent.y, worldBinormal.y, worldNormal.y, worldPos.y );
				o.tSpace2 = float4( worldTangent.z, worldBinormal.z, worldNormal.z, worldPos.z );
				o.customPack1.xy = customInputData.uv_texcoord;
				o.customPack1.xy = v.texcoord;
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
				surfIN.uv_texcoord = IN.customPack1.xy;
				float3 worldPos = float3( IN.tSpace0.w, IN.tSpace1.w, IN.tSpace2.w );
				fixed3 worldViewDir = normalize( UnityWorldSpaceViewDir( worldPos ) );
				surfIN.worldPos = worldPos;
				surfIN.worldNormal = float3( IN.tSpace0.z, IN.tSpace1.z, IN.tSpace2.z );
				surfIN.internalSurfaceTtoW0 = IN.tSpace0.xyz;
				surfIN.internalSurfaceTtoW1 = IN.tSpace1.xyz;
				surfIN.internalSurfaceTtoW2 = IN.tSpace2.xyz;
				SurfaceOutputStandardSpecularCustom o;
				UNITY_INITIALIZE_OUTPUT( SurfaceOutputStandardSpecularCustom, o )
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