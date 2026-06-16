Shader "NatureManufacture Shaders/Tree Leaves Specular Snow"
{
	Properties
	{
		[Header(Translucency)]
		_Translucency("Strength", Range( 0 , 50)) = 1
		_TransNormalDistortion("Normal Distortion", Range( 0 , 1)) = 0.1
		_TransScattering("Scaterring Falloff", Range( 1 , 50)) = 2
		_TransDirect("Direct", Range( 0 , 1)) = 1
		_TransAmbient("Ambient", Range( 0 , 1)) = 0.2
		_TransShadow("Shadow", Range( 0 , 1)) = 0.9
		_TranslucencyColor("Translucency Color", Color) = (0.7585312,0.8676471,0.6124567,0)
		_Cutoff( "Mask Clip Value", Float ) = 0.2
		_Snow_Amount("Snow_Amount", Range( 0 , 2)) = 0
		_SnowBrightnessReduction("Snow Brightness Reduction", Range( 0 , 0.5)) = 0.1239701
		_SnowAngleOverlay("Snow Angle Overlay", Range( 0 , 1)) = 0.5
		_MainTex("MainTex", 2D) = "white" {}
		_Color("Color", Color) = (1,1,1,0)
		_BumpMap("BumpMap", 2D) = "bump" {}
		_BumpScale("BumpScale", Range( 0 , 3)) = 1
		_SpecularRGBSmothnessA("Specular (RGB) Smothness (A)", 2D) = "white" {}
		_SpecularPower("Specular Power", Range( 0 , 2)) = 0
		_SmothnessPower("Smothness Power", Range( 0 , 2)) = 0
		_AmbientOcclusionG("Ambient Occlusion (G)", 2D) = "white" {}
		_AmbientOcclusionPower("Ambient Occlusion Power", Range( 0 , 2)) = 0
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
		_WindPowerDirectionX("Wind Power Direction X", Range( -1 , 1)) = 1
		_WindPowerDirectionZ("Wind Power Direction Z", Range( -1 , 1)) = 1
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
		#include "UnityPBSLighting.cginc"
		#include "UnityShaderVariables.cginc"
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
			float3 worldNormal;
			INTERNAL_DATA
			float4 vertexColor : COLOR;
			float3 worldPos;
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
		uniform sampler2D _SnowAlbedoRGB;
		uniform float4 _SnowAlbedoRGB_ST;
		uniform fixed _SnowBrightnessReduction;
		uniform sampler2D _SnowNormalRGB;
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
		uniform fixed3 _WindColorMultiply;
		uniform fixed _WindPower;
		uniform fixed _WindPowerDirectionX;
		uniform fixed _WindPowerDirectionZ;
		uniform fixed _WindNoisePower;
		uniform fixed _WindNoiseSpeed;
		uniform float _Cutoff = 0.2;

		void vertexDataFunc( inout appdata_full v, out Input o )
		{
			UNITY_INITIALIZE_OUTPUT( Input, o );
			float2 appendResult222 = (fixed2(_WindPowerDirectionX , _WindPowerDirectionZ));
			float mulTime268 = _Time.y * 0.7;
			float3 ase_worldPos = mul( unity_ObjectToWorld, v.vertex );
			float2 appendResult266 = (fixed2(ase_worldPos.x , ase_worldPos.z));
			float2 temp_output_273_0 = sin( ( mulTime268 + ( appendResult266 * float2( 0.1,0.1 ) ) ) );
			float2 clampResult297 = clamp( ( temp_output_273_0 * float2( 0.1,0.1 ) ) , float2( 0,0 ) , float2( 1,1 ) );
			float2 lerpResult280 = lerp( temp_output_273_0 , ( 1.0 - temp_output_273_0 ) , clampResult297.x);
			float2 appendResult290 = (fixed2(( lerpResult280.x + 0.3 ) , lerpResult280.y));
			float2 appendResult271 = (fixed2(ase_worldPos.x , ase_worldPos.z));
			float mulTime272 = _Time.y * 0.0004;
			float2 temp_output_282_0 = sin( ( appendResult266 + ( ( appendResult271 * mulTime272 ) * float2( 0.6,0.8 ) ) ) );
			float cos284 = cos( _SinTime.w );
			float sin284 = sin( _SinTime.w );
			float2 rotator284 = mul( temp_output_282_0 - float2( 0.1,0.3 ) , float2x2( cos284 , -sin284 , sin284 , cos284 )) + float2( 0.1,0.3 );
			float cos283 = cos( temp_output_282_0.x );
			float sin283 = sin( temp_output_282_0.x );
			float2 rotator283 = mul( temp_output_282_0 - float2( 1,0.9 ) , float2x2( cos283 , -sin283 , sin283 , cos283 )) + float2( 1,0.9 );
			float2 clampResult286 = clamp( lerpResult280 , float2( 0.3,0 ) , float2( 1.0,0 ) );
			float2 lerpResult287 = lerp( rotator284 , rotator283 , clampResult286.x);
			float2 clampResult289 = clamp( lerpResult287 , float2( 0.3,0.3 ) , float2( 0.7,0.7 ) );
			float mulTime299 = _Time.y * _WindNoiseSpeed;
			float lerpResult302 = lerp( _WindNoisePower , ( _WindNoisePower * 0.5 ) , sin( mulTime299 ));
			fixed2 temp_cast_4 = (ase_worldPos.y).xx;
			float2 panner229 = ( temp_cast_4 + clampResult289.x * float2( 10000,4000 ));
			float2 lerpResult233 = lerp( float2( 0,0 ) , panner229 , v.color.b);
			float2 temp_output_241_0 = ( lerpResult302 * ( lerpResult233 * float2( 0.0001,0.0001 ) ) );
			float mulTime292 = _Time.y * 0.9;
			float cos238 = cos( lerpResult280.x );
			float sin238 = sin( lerpResult280.x );
			float2 rotator238 = mul( sin( ( mulTime292 + ( appendResult266 * float2( 0.5,0.5 ) ) ) ) - float2( 0.5,0.5 ) , float2x2( cos238 , -sin238 , sin238 , cos238 )) + float2( 0.5,0.5 );
			float2 clampResult239 = clamp( rotator238 , float2( 0.2,0.2 ) , float2( 0.8,0.8 ) );
			float2 lerpResult245 = lerp( temp_output_241_0 , ( temp_output_241_0 * float2( 0.45,0.45 ) ) , clampResult239.x);
			float3 appendResult246 = (fixed3(( ( v.color.r * _WindPower ) * ( ( appendResult222 * float2( 0.8,0.8 ) ) + ( appendResult290 + clampResult289 ) ) ).x , lerpResult245.x , ( ( v.color.r * _WindPower ) * ( ( appendResult222 * float2( 0.8,0.8 ) ) + ( appendResult290 + clampResult289 ) ) ).y));
			#ifdef _WINDVERTEXCOLORMAINRNOISEB_ON
				float3 staticSwitch248 = appendResult246;
			#else
				float3 staticSwitch248 = fixed3(0,0,0);
			#endif
			float4 transform249 = mul(unity_WorldToObject,fixed4( staticSwitch248 , 0.0 ));
			v.vertex.xyz += transform249.xyz;
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
			float4 temp_output_97_0 = ( _Color * tex2DNode3 );
			float2 uv_SnowAlbedoRGB = i.uv_texcoord * _SnowAlbedoRGB_ST.xy + _SnowAlbedoRGB_ST.zw;
			float3 appendResult121 = (fixed3(_SnowBrightnessReduction , _SnowBrightnessReduction , _SnowBrightnessReduction));
			fixed3 ase_worldNormal = WorldNormalVector( i, fixed3( 0, 0, 1 ) );
			float3 lerpResult41 = lerp( tex2DNode4 , UnpackNormal( tex2D( _SnowNormalRGB, uv_SnowAlbedoRGB ) ) , saturate( ( ase_worldNormal.y * _Snow_Amount ) ));
			float3 newWorldNormal46 = WorldNormalVector( i , lerpResult41 );
			float temp_output_45_0 = saturate( ( ( newWorldNormal46.y + _SnowAngleOverlay ) * _Snow_Amount ) );
			float lerpResult94 = lerp( 0.0 , ( 1.0 - temp_output_45_0 ) , _Snow_Amount);
			float clampResult93 = clamp( ( temp_output_45_0 + lerpResult94 ) , 0.0 , 1.0 );
			float4 lerpResult51 = lerp( temp_output_97_0 , ( tex2D( _SnowAlbedoRGB, uv_SnowAlbedoRGB ) - fixed4( appendResult121 , 0.0 ) ) , clampResult93);
			o.Albedo = lerpResult51.rgb;
			fixed4 tex2DNode28 = tex2D( _SpecularRGBSmothnessA, uv_MainTex );
			float3 appendResult100 = (fixed3(tex2DNode28.r , tex2DNode28.g , tex2DNode28.b));
			fixed4 tex2DNode64 = tex2D( _SnowSpecularRGBSmothnessA, uv_SnowAlbedoRGB );
			float3 appendResult101 = (fixed3(tex2DNode64.r , tex2DNode64.g , tex2DNode64.b));
			float3 lerpResult53 = lerp( ( appendResult100 * _SpecularPower ) , ( _SnowSpecularPower * appendResult101 ) , temp_output_45_0);
			o.Specular = lerpResult53;
			float lerpResult66 = lerp( ( tex2DNode28.a * _SmothnessPower ) , ( tex2DNode64.a * _SnowSmothnessPower ) , temp_output_45_0);
			o.Smoothness = lerpResult66;
			float clampResult125 = clamp( tex2D( _AmbientOcclusionG, uv_MainTex ).g , ( 1.0 - _AmbientOcclusionPower ) , 1.0 );
			float clampResult123 = clamp( tex2D( _SnowAmbientOcclusionG, uv_SnowAlbedoRGB ).g , ( 1.0 - _SnowAmbientOcclusionPower ) , 1.0 );
			float lerpResult65 = lerp( clampResult125 , clampResult123 , temp_output_45_0);
			o.Occlusion = lerpResult65;
			float2 appendResult222 = (fixed2(_WindPowerDirectionX , _WindPowerDirectionZ));
			float mulTime268 = _Time.y * 0.7;
			float3 ase_worldPos = i.worldPos;
			float2 appendResult266 = (fixed2(ase_worldPos.x , ase_worldPos.z));
			float2 temp_output_273_0 = sin( ( mulTime268 + ( appendResult266 * float2( 0.1,0.1 ) ) ) );
			float2 clampResult297 = clamp( ( temp_output_273_0 * float2( 0.1,0.1 ) ) , float2( 0,0 ) , float2( 1,1 ) );
			float2 lerpResult280 = lerp( temp_output_273_0 , ( 1.0 - temp_output_273_0 ) , clampResult297.x);
			float2 appendResult290 = (fixed2(( lerpResult280.x + 0.3 ) , lerpResult280.y));
			float2 appendResult271 = (fixed2(ase_worldPos.x , ase_worldPos.z));
			float mulTime272 = _Time.y * 0.0004;
			float2 temp_output_282_0 = sin( ( appendResult266 + ( ( appendResult271 * mulTime272 ) * float2( 0.6,0.8 ) ) ) );
			float cos284 = cos( _SinTime.w );
			float sin284 = sin( _SinTime.w );
			float2 rotator284 = mul( temp_output_282_0 - float2( 0.1,0.3 ) , float2x2( cos284 , -sin284 , sin284 , cos284 )) + float2( 0.1,0.3 );
			float cos283 = cos( temp_output_282_0.x );
			float sin283 = sin( temp_output_282_0.x );
			float2 rotator283 = mul( temp_output_282_0 - float2( 1,0.9 ) , float2x2( cos283 , -sin283 , sin283 , cos283 )) + float2( 1,0.9 );
			float2 clampResult286 = clamp( lerpResult280 , float2( 0.3,0 ) , float2( 1.0,0 ) );
			float2 lerpResult287 = lerp( rotator284 , rotator283 , clampResult286.x);
			float2 clampResult289 = clamp( lerpResult287 , float2( 0.3,0.3 ) , float2( 0.7,0.7 ) );
			float mulTime299 = _Time.y * _WindNoiseSpeed;
			float lerpResult302 = lerp( _WindNoisePower , ( _WindNoisePower * 0.5 ) , sin( mulTime299 ));
			fixed2 temp_cast_7 = (ase_worldPos.y).xx;
			float2 panner229 = ( temp_cast_7 + clampResult289.x * float2( 10000,4000 ));
			float2 lerpResult233 = lerp( float2( 0,0 ) , panner229 , i.vertexColor.b);
			float2 temp_output_241_0 = ( lerpResult302 * ( lerpResult233 * float2( 0.0001,0.0001 ) ) );
			float mulTime292 = _Time.y * 0.9;
			float cos238 = cos( lerpResult280.x );
			float sin238 = sin( lerpResult280.x );
			float2 rotator238 = mul( sin( ( mulTime292 + ( appendResult266 * float2( 0.5,0.5 ) ) ) ) - float2( 0.5,0.5 ) , float2x2( cos238 , -sin238 , sin238 , cos238 )) + float2( 0.5,0.5 );
			float2 clampResult239 = clamp( rotator238 , float2( 0.2,0.2 ) , float2( 0.8,0.8 ) );
			float2 lerpResult245 = lerp( temp_output_241_0 , ( temp_output_241_0 * float2( 0.45,0.45 ) ) , clampResult239.x);
			float3 appendResult246 = (fixed3(( ( i.vertexColor.r * _WindPower ) * ( ( appendResult222 * float2( 0.8,0.8 ) ) + ( appendResult290 + clampResult289 ) ) ).x , lerpResult245.x , ( ( i.vertexColor.r * _WindPower ) * ( ( appendResult222 * float2( 0.8,0.8 ) ) + ( appendResult290 + clampResult289 ) ) ).y));
			#ifdef _WINDVERTEXCOLORMAINRNOISEB_ON
				float3 staticSwitch248 = appendResult246;
			#else
				float3 staticSwitch248 = fixed3(0,0,0);
			#endif
			float4 transform249 = mul(unity_WorldToObject,fixed4( staticSwitch248 , 0.0 ));
			float clampResult264 = clamp( transform249.x , 0.0 , 1.0 );
			float4 lerpResult191 = lerp( temp_output_97_0 , ( tex2DNode3 * fixed4( _WindColorMultiply , 0.0 ) ) , clampResult264);
			float4 lerpResult54 = lerp( ( _TranslucencyColor * ( lerpResult191 - fixed4( ( appendResult121 * _Snow_Amount ) , 0.0 ) ) ) , float4( 0,0,0,0 ) , temp_output_45_0);
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