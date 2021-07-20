Shader "NatureManufacture Shaders/Cross Model Shader"
{
	Properties
	{
		_Cutoff( "Mask Clip Value", Float ) = 0.65
		_MainTex("MainTex", 2D) = "white" {}
		_ColorAdjustment("Color Adjustment", Vector) = (1,1,1,0)
		_Smooothness("Smooothness", Float) = 0.3
		_AO("AO", Float) = 1
		_Color("Color", Color) = (1,1,1,0)
		_BumpMap("BumpMap", 2D) = "bump" {}
		_BumpScale("BumpScale", Range( 0 , 3)) = 1
		[Toggle] _WindVertexColorMainR("Wind Vertex Color Main (R)", Float) = 0.0
		_WindPower("Wind Power", Range( 0 , 1)) = 0.3
		_WindPowerDirectionX("Wind Power Direction X", Range( -1 , 1)) = 1
		_WindPowerDirectionZ("Wind Power Direction Z", Range( -1 , 1)) = 1
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "TransparentCutout"  "Queue" = "AlphaTest+0" }
		Cull Back
		CGPROGRAM
		#include "UnityStandardUtils.cginc"
		#include "UnityShaderVariables.cginc"
		#pragma target 2.0
		#pragma multi_compile_instancing
		#pragma multi_compile __ _WINDVERTEXCOLORMAINR_ON
		#pragma surface surf StandardSpecular keepalpha addshadow fullforwardshadows dithercrossfade vertex:vertexDataFunc 
		struct Input
		{
			float2 uv_texcoord;
		};

		uniform fixed _BumpScale;
		uniform sampler2D _BumpMap;
		uniform sampler2D _MainTex;
		uniform float4 _MainTex_ST;
		uniform fixed4 _Color;
		uniform float3 _ColorAdjustment;
		uniform float _Smooothness;
		uniform float _AO;
		uniform float _WindPower;
		uniform fixed _WindPowerDirectionX;
		uniform fixed _WindPowerDirectionZ;
		uniform float _Cutoff = 0.65;

		void vertexDataFunc( inout appdata_full v, out Input o )
		{
			UNITY_INITIALIZE_OUTPUT( Input, o );
			float2 appendResult84 = (float2(_WindPowerDirectionX , _WindPowerDirectionZ));
			float mulTime60 = _Time.y * 0.7;
			float3 ase_worldPos = mul( unity_ObjectToWorld, v.vertex );
			float2 appendResult58 = (float2(ase_worldPos.x , ase_worldPos.z));
			float2 temp_output_66_0 = sin( ( mulTime60 + ( appendResult58 * float2( 0.1,0.1 ) ) ) );
			float2 clampResult71 = clamp( ( temp_output_66_0 * float2( 0.1,0.1 ) ) , float2( 0,0 ) , float2( 1,1 ) );
			float2 lerpResult72 = lerp( temp_output_66_0 , ( 1.0 - temp_output_66_0 ) , clampResult71.x);
			float2 appendResult83 = (float2(( lerpResult72.x + 0.3 ) , lerpResult72.y));
			float2 appendResult62 = (float2(ase_worldPos.x , ase_worldPos.z));
			float mulTime63 = _Time.y * 0.0004;
			float2 temp_output_73_0 = sin( ( ( appendResult58 + ( appendResult62 * mulTime63 ) ) * float2( 0.6,0.8 ) ) );
			float cos75 = cos( _SinTime.w );
			float sin75 = sin( _SinTime.w );
			float2 rotator75 = mul( temp_output_73_0 - float2( 0.1,0.3 ) , float2x2( cos75 , -sin75 , sin75 , cos75 )) + float2( 0.1,0.3 );
			float cos78 = cos( temp_output_73_0.x );
			float sin78 = sin( temp_output_73_0.x );
			float2 rotator78 = mul( temp_output_73_0 - float2( 1,0.9 ) , float2x2( cos78 , -sin78 , sin78 , cos78 )) + float2( 1,0.9 );
			float2 clampResult77 = clamp( lerpResult72 , float2( 0.3,0 ) , float2( 1,0 ) );
			float2 lerpResult79 = lerp( rotator75 , rotator78 , clampResult77.x);
			float2 clampResult85 = clamp( lerpResult79 , float2( 0.3,0.3 ) , float2( 0.7,0.7 ) );
			float3 appendResult95 = (float3(( ( v.color.r * _WindPower ) * ( ( appendResult84 * float2( 0.8,0.8 ) ) + ( appendResult83 + clampResult85 ) ) ).x , 0.0 , ( ( v.color.r * _WindPower ) * ( ( appendResult84 * float2( 0.8,0.8 ) ) + ( appendResult83 + clampResult85 ) ) ).y));
			float3 temp_cast_3 = (0.0).xxx;
			#ifdef _WINDVERTEXCOLORMAINR_ON
				float3 staticSwitch96 = appendResult95;
			#else
				float3 staticSwitch96 = temp_cast_3;
			#endif
			float4 transform97 = mul(unity_WorldToObject,float4( staticSwitch96 , 0.0 ));
			v.vertex.xyz += transform97.xyz;
		}

		void surf( Input i , inout SurfaceOutputStandardSpecular o )
		{
			float2 uv_MainTex = i.uv_texcoord * _MainTex_ST.xy + _MainTex_ST.zw;
			o.Normal = UnpackScaleNormal( tex2D( _BumpMap, uv_MainTex ) ,_BumpScale );
			float4 tex2DNode2 = tex2D( _MainTex, uv_MainTex );
			float4 temp_output_47_0 = ( ( tex2DNode2 * _Color ) * float4( _ColorAdjustment , 0.0 ) );
			o.Albedo = temp_output_47_0.rgb;
			float temp_output_51_0 = 0.0;
			float3 temp_cast_2 = (temp_output_51_0).xxx;
			o.Specular = temp_cast_2;
			o.Smoothness = _Smooothness;
			o.Occlusion = _AO;
			o.Alpha = 1;
			clip( tex2DNode2.a - _Cutoff );
		}

		ENDCG
	}
	Fallback "Diffuse"
}