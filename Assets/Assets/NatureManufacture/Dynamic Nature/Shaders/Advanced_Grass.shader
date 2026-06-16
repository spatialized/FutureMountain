Shader "NatureManufacture Shaders/Advanced Grass"
{
	Properties
	{
		_Cutoff( "Mask Clip Value", Float ) = 0.4
		_MainTex("MainTex", 2D) = "white" {}
		_BumpMap("BumpMap", 2D) = "bump" {}
		_BumpScale("BumpScale", Range( 0 , 2)) = 1
		_AmbientOcclusionG("Ambient Occlusion (G)", 2D) = "white" {}
		_AmbientOcclusionPower("Ambient Occlusion Power", Range( 0 , 1)) = 0
		_WindNoisetilling("Wind Noise tilling", Vector) = (0.007,0.007,0,0)
		_Color("Color", Vector) = (1,1,1,0)
		[Toggle]_Wind_VertexColorR("Wind_VertexColor(R)", Int) = 0
		_WindColorMultiply("Wind Color Multiply", Vector) = (1,1,1,0)
		_WindNoise("Wind Noise", 2D) = "black" {}
		_MaxWindbending("Max Wind bending", Range( 0 , 5)) = 1
		_NoiseWindSpeed("Noise Wind Speed", Range( 0 , 10)) = 0
		_WindPowerDirectionX("Wind Power Direction X", Range( -1 , 1)) = 1
		_WindPowerDirectionZ("Wind Power Direction Z", Range( -1 , 1)) = 1
		_WindNoisePower("Wind Noise Power", Range( 0 , 5)) = 3
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "TransparentCutout"  "Queue" = "AlphaTest+0" }
		Cull Off
		CGPROGRAM
		#include "UnityStandardUtils.cginc"
		#include "UnityShaderVariables.cginc"
		#pragma target 3.0
		#pragma multi_compile_instancing
		#pragma multi_compile __ _WIND_VERTEXCOLORR_ON
		#pragma surface surf Standard keepalpha addshadow fullforwardshadows dithercrossfade vertex:vertexDataFunc 
		struct Input
		{
			float2 uv_texcoord;
			float3 worldPos;
		};

		uniform fixed _BumpScale;
		uniform sampler2D _BumpMap;
		uniform sampler2D _MainTex;
		uniform float4 _MainTex_ST;
		uniform fixed3 _Color;
		uniform fixed3 _WindColorMultiply;
		uniform sampler2D _WindNoise;
		uniform fixed _NoiseWindSpeed;
		uniform fixed2 _WindNoisetilling;
		uniform fixed _WindNoisePower;
		uniform sampler2D _AmbientOcclusionG;
		uniform fixed _AmbientOcclusionPower;
		uniform fixed _MaxWindbending;
		uniform fixed _WindPowerDirectionX;
		uniform fixed _WindPowerDirectionZ;
		uniform float _Cutoff = 0.4;


		float4 CalculateContrast( float contrastValue, float4 colorTarget )
		{
			float t = 0.5 * ( 1.0 - contrastValue );
			return mul( float4x4( contrastValue,0,0,t, 0,contrastValue,0,t, 0,0,contrastValue,t, 0,0,0,1 ), colorTarget );
		}

		void vertexDataFunc( inout appdata_full v, out Input o )
		{
			UNITY_INITIALIZE_OUTPUT( Input, o );
			float3 ase_objectScale = float3( length( unity_ObjectToWorld[ 0 ].xyz ), length( unity_ObjectToWorld[ 1 ].xyz ), length( unity_ObjectToWorld[ 2 ].xyz ) );;
			float2 appendResult219 = (fixed2(_WindPowerDirectionX , _WindPowerDirectionZ));
			float mulTime363 = _Time.y * 0.7;
			float3 ase_worldPos = mul( unity_ObjectToWorld, v.vertex );
			float2 appendResult362 = (fixed2(ase_worldPos.x , ase_worldPos.z));
			float2 temp_output_366_0 = sin( ( mulTime363 + ( appendResult362 * float2( 0.1,0.1 ) ) ) );
			float2 clampResult269 = clamp( temp_output_366_0 , float2( 0.0,0 ) , float2( 1.0,0 ) );
			float2 lerpResult270 = lerp( temp_output_366_0 , ( 1.0 - temp_output_366_0 ) , clampResult269.x);
			fixed2 temp_cast_1 = (_SinTime.x).xx;
			float clampResult351 = clamp( _SinTime.y , 0.0 , 0.7 );
			float2 lerpResult349 = lerp( lerpResult270 , temp_cast_1 , clampResult351);
			float2 appendResult277 = (fixed2(( lerpResult349 + float2( 0.3,0 ) ).x , lerpResult349.x));
			float2 temp_output_367_0 = ( ( appendResult219 * float2( 0.8,0.8 ) ) + appendResult277 );
			float2 appendResult297 = (fixed2(ase_worldPos.x , ase_worldPos.z));
			float cos299 = cos( ( temp_output_366_0 * float2( 0.05,0 ) ).x );
			float sin299 = sin( ( temp_output_366_0 * float2( 0.05,0 ) ).x );
			float2 rotator299 = mul( appendResult297 - float2( 0.04,-0.04 ) , float2x2( cos299 , -sin299 , sin299 , cos299 )) + float2( 0.04,-0.04 );
			float2 panner337 = ( ( rotator299 * _WindNoisetilling ) + ( _NoiseWindSpeed * _Time.y ) * float2( 0.01,0.01 ));
			fixed4 temp_cast_5 = (_WindNoisePower).xxxx;
			float4 temp_output_343_0 = ( 1.0 - CalculateContrast(tex2Dlod( _WindNoise, fixed4( panner337, 0, 1.0) ).r,temp_cast_5) );
			float2 appendResult312 = (fixed2(temp_output_343_0.r , temp_output_343_0.r));
			float2 clampResult323 = clamp( appendResult312 , float2( 0.4,0.4 ) , float2( 1,1 ) );
			float3 appendResult172 = (fixed3(( ( v.color.r * _MaxWindbending ) * temp_output_367_0 * clampResult323 ).x , 0.0 , ( ( v.color.r * _MaxWindbending ) * temp_output_367_0 * clampResult323 ).y));
			float3 ase_vertex3Pos = v.vertex.xyz;
			float2 clampResult341 = clamp( ( clampResult323 * ( ase_vertex3Pos.y - float4( float4x4( 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0 )[3][0],float4x4( 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0 )[3][1],float4x4( 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0 )[3][2],float4x4( 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0 )[3][3]).y ) ) , float2( 0.1,0.1 ) , float2( 1,1 ) );
			float3 appendResult283 = (fixed3(( ( clampResult341 * _MaxWindbending ) * temp_output_367_0 ).x , 0.0 , ( ( clampResult341 * _MaxWindbending ) * temp_output_367_0 ).y));
			#ifdef _WIND_VERTEXCOLORR_ON
				float3 staticSwitch274 = appendResult172;
			#else
				float3 staticSwitch274 = appendResult283;
			#endif
			float4 transform360 = mul(unity_WorldToObject,fixed4( ( ase_objectScale * staticSwitch274 ) , 0.0 ));
			v.vertex.xyz += transform360.xyz;
		}

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float2 uv_MainTex = i.uv_texcoord * _MainTex_ST.xy + _MainTex_ST.zw;
			o.Normal = UnpackScaleNormal( tex2D( _BumpMap, uv_MainTex ) ,_BumpScale );
			fixed4 tex2DNode3 = tex2D( _MainTex, uv_MainTex );
			float3 ase_worldPos = i.worldPos;
			float2 appendResult297 = (fixed2(ase_worldPos.x , ase_worldPos.z));
			float mulTime363 = _Time.y * 0.7;
			float2 appendResult362 = (fixed2(ase_worldPos.x , ase_worldPos.z));
			float2 temp_output_366_0 = sin( ( mulTime363 + ( appendResult362 * float2( 0.1,0.1 ) ) ) );
			float cos299 = cos( ( temp_output_366_0 * float2( 0.05,0 ) ).x );
			float sin299 = sin( ( temp_output_366_0 * float2( 0.05,0 ) ).x );
			float2 rotator299 = mul( appendResult297 - float2( 0.04,-0.04 ) , float2x2( cos299 , -sin299 , sin299 , cos299 )) + float2( 0.04,-0.04 );
			float2 panner337 = ( ( rotator299 * _WindNoisetilling ) + ( _NoiseWindSpeed * _Time.y ) * float2( 0.01,0.01 ));
			fixed4 temp_cast_3 = (_WindNoisePower).xxxx;
			float4 temp_output_343_0 = ( 1.0 - CalculateContrast(tex2D( _WindNoise, panner337 ).r,temp_cast_3) );
			float2 appendResult312 = (fixed2(temp_output_343_0.r , temp_output_343_0.r));
			float2 clampResult323 = clamp( appendResult312 , float2( 0.4,0.4 ) , float2( 1,1 ) );
			float3 ase_vertex3Pos = mul( unity_WorldToObject, float4( i.worldPos , 1 ) );
			float2 clampResult341 = clamp( ( clampResult323 * ( ase_vertex3Pos.y - float4( float4x4( 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0 )[3][0],float4x4( 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0 )[3][1],float4x4( 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0 )[3][2],float4x4( 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0 )[3][3]).y ) ) , float2( 0.1,0.1 ) , float2( 1,1 ) );
			float2 clampResult372 = clamp( clampResult341 , float2( 0,0 ) , float2( 1,1 ) );
			float4 lerpResult354 = lerp( ( fixed4( _Color , 0.0 ) * tex2DNode3 ) , ( fixed4( _WindColorMultiply , 0.0 ) * tex2DNode3 ) , clampResult372.x);
			o.Albedo = lerpResult354.rgb;
			float clampResult150 = clamp( tex2D( _AmbientOcclusionG, uv_MainTex ).g , ( 1.0 - _AmbientOcclusionPower ) , 1.0 );
			o.Occlusion = clampResult150;
			o.Alpha = 1;
			clip( tex2DNode3.a - _Cutoff );
		}

		ENDCG
	}
	Fallback "Diffuse"
}