// Upgrade NOTE: upgraded instancing buffer 'M_BlendMaster' to new syntax.

// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "M_BlendMaster"
{
	Properties
	{
		_Offset("Offset", Vector) = (0,0,0,0)
		_Tiling("Tiling", Vector) = (1,1,0,0)
		[Header(Material_1)][Header(_________________)]_Mat1_UV("Mat1_UV", Range( 0 , 20)) = 1
		_Mat1_BaseColor("Mat1_BaseColor", Range( 0 , 5)) = 1
		_Mat1_Roughness("Mat1_Roughness", Range( 0 , 2)) = 0.5
		_Mat1_Metallic("Mat1_Metallic", Range( 0 , 1)) = 0
		[Toggle(_USECOLOR_ON)] _UseColor("UseColor", Float) = 0
		_Mat1_Color("Mat1_Color", Color) = (1,1,1,0)
		[Toggle(_MAT1_BAKEDNORMAL_ON)] _Mat1_BakedNormal("Mat1_BakedNormal", Float) = 0
		[Toggle(_MAT1_COLORTEXTURE_ON)] _Mat1_ColorTexture("Mat1_ColorTexture", Float) = 1
		[Toggle(_MAT1_ROUGHNESSTEXTURE_ON)] _Mat1_RoughnessTexture("Mat1_RoughnessTexture", Float) = 0
		_Mat1_BakedUV1("Mat1_BakedUV1", Range( 0 , 20)) = 1
		_Mat1_BaseTexture("Mat1_BaseTexture", 2D) = "white" {}
		_BakedNormal("BakedNormal", 2D) = "bump" {}
		_Mat1_Base_Normal("Mat1_Base_Normal", 2D) = "bump" {}
		[Header(Material_2)][Header(_________________)]_Mat2_UV("Mat2_UV", Range( 0 , 20)) = 2
		_Mat2_BaseColor("Mat2_BaseColor", Range( 0 , 5)) = 3.75
		_Mat2_Roughness("Mat2_Roughness", Range( 0 , 2)) = 0
		_Mat2_Metallic("Mat2_Metallic", Range( 0 , 1)) = 0
		[Toggle(_USECOLOR_2_ON)] _UseColor_2("UseColor_2", Float) = 0
		_Mat2_Color("Mat2_Color", Color) = (1,1,1,0)
		[Toggle(_MAT2_COLORTEXTURE_ON)] _Mat2_ColorTexture("Mat2_ColorTexture", Float) = 1
		[Toggle(_MAT2_ROUGHNESSTEXTURE_ON)] _Mat2_RoughnessTexture("Mat2_RoughnessTexture", Float) = 0
		_Mat2_BaseTexture("Mat2_BaseTexture", 2D) = "white" {}
		_Mat2_Base_Normal("Mat2_Base_Normal", 2D) = "bump" {}
		_T_VertexBlend_Mask("T_VertexBlend_Mask", 2D) = "white" {}
		[Header(Vertex Color)][Header(_____________________)]_VColor_G_Scale("VColor_G_Scale", Range( 0 , 10)) = 1.37
		_VColor_Details("VColor_Details", Range( 0 , 10)) = 1.1
		_VColor_Power("VColor_Power", Range( 0 , 10)) = 1.1
		_Worn_Level("Worn_Level", Range( 0 , 1)) = 1.1
		[Toggle(_USE_AO_ON)] _Use_AO("Use_AO", Float) = 0
		_AO("AO", 2D) = "white" {}
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Opaque"  "Queue" = "Geometry+0" }
		Cull Back
		CGPROGRAM
		#include "UnityStandardUtils.cginc"
		#pragma target 3.0
		#pragma multi_compile_instancing
		#pragma shader_feature_local _MAT1_BAKEDNORMAL_ON
		#pragma shader_feature_local _MAT2_COLORTEXTURE_ON
		#pragma shader_feature_local _USECOLOR_2_ON
		#pragma shader_feature_local _MAT1_COLORTEXTURE_ON
		#pragma shader_feature_local _USECOLOR_ON
		#pragma shader_feature_local _MAT2_ROUGHNESSTEXTURE_ON
		#pragma shader_feature_local _MAT1_ROUGHNESSTEXTURE_ON
		#pragma shader_feature_local _USE_AO_ON
		#pragma surface surf Standard keepalpha addshadow fullforwardshadows 
		struct Input
		{
			float2 uv_texcoord;
			float4 vertexColor : COLOR;
		};

		uniform sampler2D _Mat2_Base_Normal;
		uniform float2 _Tiling;
		uniform float2 _Offset;
		uniform float _Mat2_UV;
		uniform sampler2D _Mat1_Base_Normal;
		uniform float _Mat1_UV;
		uniform sampler2D _T_VertexBlend_Mask;
		uniform float _VColor_G_Scale;
		uniform float _VColor_Power;
		uniform float _VColor_Details;
		uniform float _Worn_Level;
		uniform sampler2D _BakedNormal;
		uniform float _Mat1_BakedUV1;
		uniform float _Mat2_BaseColor;
		uniform float4 _Mat2_Color;
		uniform sampler2D _Mat2_BaseTexture;
		uniform float4 _Mat1_Color;
		uniform sampler2D _Mat1_BaseTexture;
		uniform float _Mat2_Metallic;
		uniform float _Mat1_Metallic;
		uniform float _Mat2_Roughness;
		uniform float _Mat1_Roughness;
		uniform sampler2D _AO;

		UNITY_INSTANCING_BUFFER_START(M_BlendMaster)
			UNITY_DEFINE_INSTANCED_PROP(float, _Mat1_BaseColor)
#define _Mat1_BaseColor_arr M_BlendMaster
		UNITY_INSTANCING_BUFFER_END(M_BlendMaster)

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float2 uv_TexCoord49 = i.uv_texcoord * _Tiling + _Offset;
			float2 temp_output_50_0 = ( uv_TexCoord49 * _Mat2_UV );
			float2 uv_TexCoord45 = i.uv_texcoord * _Tiling + _Offset;
			float2 temp_output_46_0 = ( uv_TexCoord45 * _Mat1_UV );
			float2 uv_TexCoord23 = i.uv_texcoord * _Tiling + _Offset;
			float clampResult100 = clamp( pow( ( ( i.vertexColor.g + tex2D( _T_VertexBlend_Mask, ( uv_TexCoord23 * _VColor_G_Scale ) ).r ) * _VColor_Power ) , _VColor_Details ) , 0.0 , 1.0 );
			float lerpResult84 = lerp( 1.0 , clampResult100 , _Worn_Level);
			float3 lerpResult18 = lerp( UnpackNormal( tex2D( _Mat2_Base_Normal, temp_output_50_0 ) ) , UnpackNormal( tex2D( _Mat1_Base_Normal, temp_output_46_0 ) ) , lerpResult84);
			#ifdef _MAT1_BAKEDNORMAL_ON
				float3 staticSwitch80 = BlendNormals( lerpResult18 , UnpackNormal( tex2D( _BakedNormal, ( uv_TexCoord45 * _Mat1_BakedUV1 ) ) ) );
			#else
				float3 staticSwitch80 = lerpResult18;
			#endif
			o.Normal = staticSwitch80;
			float4 temp_cast_0 = (_Mat2_BaseColor).xxxx;
			float4 tex2DNode12 = tex2D( _Mat2_BaseTexture, temp_output_50_0 );
			#ifdef _USECOLOR_2_ON
				float4 staticSwitch77 = ( _Mat2_Color * tex2DNode12 );
			#else
				float4 staticSwitch77 = temp_cast_0;
			#endif
			#ifdef _MAT2_COLORTEXTURE_ON
				float4 staticSwitch11 = tex2DNode12;
			#else
				float4 staticSwitch11 = staticSwitch77;
			#endif
			float _Mat1_BaseColor_Instance = UNITY_ACCESS_INSTANCED_PROP(_Mat1_BaseColor_arr, _Mat1_BaseColor);
			float4 temp_cast_1 = (_Mat1_BaseColor_Instance).xxxx;
			float4 tex2DNode10 = tex2D( _Mat1_BaseTexture, temp_output_46_0 );
			#ifdef _USECOLOR_ON
				float4 staticSwitch53 = ( _Mat1_Color * tex2DNode10 );
			#else
				float4 staticSwitch53 = temp_cast_1;
			#endif
			#ifdef _MAT1_COLORTEXTURE_ON
				float4 staticSwitch9 = tex2DNode10;
			#else
				float4 staticSwitch9 = staticSwitch53;
			#endif
			float4 lerpResult17 = lerp( ( _Mat2_BaseColor * staticSwitch11 ) , ( _Mat1_BaseColor_Instance * staticSwitch9 ) , lerpResult84);
			o.Albedo = lerpResult17.rgb;
			float lerpResult20 = lerp( _Mat2_Metallic , _Mat1_Metallic , lerpResult84);
			o.Metallic = lerpResult20;
			#ifdef _MAT2_ROUGHNESSTEXTURE_ON
				float staticSwitch15 = tex2DNode12.a;
			#else
				float staticSwitch15 = _Mat2_Roughness;
			#endif
			#ifdef _MAT1_ROUGHNESSTEXTURE_ON
				float staticSwitch13 = tex2DNode10.a;
			#else
				float staticSwitch13 = _Mat1_Roughness;
			#endif
			float lerpResult19 = lerp( staticSwitch15 , staticSwitch13 , lerpResult84);
			o.Smoothness = lerpResult19;
			float2 temp_cast_3 = (_Mat1_BakedUV1).xx;
			#ifdef _USE_AO_ON
				float staticSwitch91 = tex2D( _AO, temp_cast_3 ).r;
			#else
				float staticSwitch91 = 1.0;
			#endif
			o.Occlusion = staticSwitch91;
			o.Alpha = 1;
		}

		ENDCG
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=18930
435;315;1916;945;2672.455;1077.637;1;True;True
Node;AmplifyShaderEditor.Vector2Node;89;-4976.288,1113.609;Inherit;False;Property;_Offset;Offset;0;0;Create;True;0;0;0;False;0;False;0,0;1,1;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.Vector2Node;88;-4768.708,-508.9574;Inherit;False;Property;_Tiling;Tiling;1;0;Create;True;0;0;0;False;0;False;1,1;1,1;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.TextureCoordinatesNode;23;-4462.465,434.303;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;22;-4498.17,647.3954;Inherit;False;Property;_VColor_G_Scale;VColor_G_Scale;26;1;[Header];Create;True;2;Vertex Color;_____________________;0;0;False;0;False;1.37;0.11;0;10;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;25;-4161.965,492.603;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.VertexColorNode;21;-3968.584,55.49733;Inherit;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;26;-3940.165,454.1935;Inherit;True;Property;_T_VertexBlend_Mask;T_VertexBlend_Mask;25;0;Create;True;0;0;0;False;0;False;-1;1035ac5893f531b40b3553688a0545c8;1035ac5893f531b40b3553688a0545c8;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;48;-2148.188,982.5687;Inherit;False;Property;_Mat2_UV;Mat2_UV;15;1;[Header];Create;True;2;Material_2;_________________;0;0;False;0;False;2;0.5;0;20;0;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;49;-2175.782,794.9487;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TextureCoordinatesNode;45;-3089.203,-1310.344;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;101;-3912.102,723.4922;Inherit;False;Property;_VColor_Power;VColor_Power;28;0;Create;True;0;0;0;False;0;False;1.1;1.19;0;10;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;34;-3471.844,266.5873;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;47;-2871.466,-831.1132;Inherit;False;Property;_Mat1_UV;Mat1_UV;2;1;[Header];Create;True;2;Material_1;_________________;0;0;False;0;False;1;0.5;0;20;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;102;-3323.157,290.9846;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;46;-2571.679,-1035.918;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;50;-1895.286,812.7576;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;38;-3447.309,612.8582;Inherit;False;Property;_VColor_Details;VColor_Details;27;0;Create;True;0;0;0;False;0;False;1.1;6.78;0;10;0;1;FLOAT;0
Node;AmplifyShaderEditor.PowerNode;95;-3158.465,274.3345;Inherit;False;False;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;12;-1621.021,724.7871;Inherit;True;Property;_Mat2_BaseTexture;Mat2_BaseTexture;23;0;Create;True;0;0;0;False;0;False;-1;c92b9a382c23f1046add6d7b821e10bb;9777c280394532e41a7df09b0fa52a1a;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;76;-2046.572,551.8091;Inherit;False;Property;_Mat2_Color;Mat2_Color;20;0;Create;True;0;0;0;False;0;False;1,1,1,0;1,1,1,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;10;-2297.417,-619.2255;Inherit;True;Property;_Mat1_BaseTexture;Mat1_BaseTexture;12;0;Create;True;0;0;0;False;0;False;-1;c92b9a382c23f1046add6d7b821e10bb;7ef69588f587108429bad0ae1500cb1d;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;52;-2350.779,-870.9109;Inherit;False;Property;_Mat1_Color;Mat1_Color;7;0;Create;True;0;0;0;False;0;False;1,1,1,0;1,1,1,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;6;-1740.719,421.8404;Inherit;False;Property;_Mat2_BaseColor;Mat2_BaseColor;16;0;Create;True;0;0;0;False;0;False;3.75;1.55;0;5;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;98;-3033.59,783.1057;Inherit;False;Property;_Worn_Level;Worn_Level;29;0;Create;True;0;0;0;False;0;False;1.1;1.1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;79;-1979.947,-785.2712;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.ClampOpNode;100;-2988.238,269.6634;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;85;-1729.428,526.2179;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;2;-2081.693,-964.5801;Inherit;False;InstancedProperty;_Mat1_BaseColor;Mat1_BaseColor;3;0;Create;True;1;Material_1;0;0;False;0;False;1;1;0;5;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;86;-3069.743,-1069.338;Inherit;False;Property;_Mat1_BakedUV1;Mat1_BakedUV1;11;0;Create;True;0;0;0;False;0;False;1;1;0;20;0;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;84;-2495.843,369.1819;Inherit;False;3;0;FLOAT;1;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;87;-2695.929,-1372.63;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SamplerNode;5;-1276.416,770.4982;Inherit;True;Property;_Mat2_Base_Normal;Mat2_Base_Normal;24;0;Create;True;0;0;0;False;0;False;-1;e12563ccf97f87a4683eed1673a7b8c7;dd13a41cea496044ea2daef5f0b00bf2;True;0;True;bump;Auto;True;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;1;-1440.477,-568.6525;Inherit;True;Property;_Mat1_Base_Normal;Mat1_Base_Normal;14;0;Create;True;0;0;0;False;0;False;-1;e12563ccf97f87a4683eed1673a7b8c7;dd13a41cea496044ea2daef5f0b00bf2;True;0;True;bump;Auto;True;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.StaticSwitch;77;-1475.833,526.3207;Inherit;False;Property;_UseColor_2;UseColor_2;19;0;Create;True;0;0;0;False;0;False;0;0;0;True;;Toggle;2;Key0;Key1;Create;True;True;All;9;1;COLOR;0,0,0,0;False;0;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;3;COLOR;0,0,0,0;False;4;COLOR;0,0,0,0;False;5;COLOR;0,0,0,0;False;6;COLOR;0,0,0,0;False;7;COLOR;0,0,0,0;False;8;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.StaticSwitch;53;-1821.177,-832.5112;Inherit;False;Property;_UseColor;UseColor;6;0;Create;True;0;0;0;False;0;False;0;0;0;True;;Toggle;2;Key0;Key1;Create;True;True;All;9;1;COLOR;0,0,0,0;False;0;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;3;COLOR;0,0,0,0;False;4;COLOR;0,0,0,0;False;5;COLOR;0,0,0,0;False;6;COLOR;0,0,0,0;False;7;COLOR;0,0,0,0;False;8;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;81;-160.74,227.2795;Inherit;True;Property;_BakedNormal;BakedNormal;13;0;Create;True;0;0;0;False;0;False;-1;9d43bd232e090b64f8aec41af6a64ae1;dd13a41cea496044ea2daef5f0b00bf2;True;0;True;bump;Auto;True;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;7;-1748.122,1030.765;Inherit;False;Property;_Mat2_Roughness;Mat2_Roughness;17;0;Create;True;0;0;0;False;0;False;0;0;0;2;0;1;FLOAT;0
Node;AmplifyShaderEditor.StaticSwitch;9;-1580.43,-762.0961;Inherit;False;Property;_Mat1_ColorTexture;Mat1_ColorTexture;9;0;Create;True;0;0;0;False;0;False;0;1;1;True;;Toggle;2;Key0;Key1;Create;True;True;All;9;1;COLOR;0,0,0,0;False;0;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;3;COLOR;0,0,0,0;False;4;COLOR;0,0,0,0;False;5;COLOR;0,0,0,0;False;6;COLOR;0,0,0,0;False;7;COLOR;0,0,0,0;False;8;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;3;-1916.791,-486.3765;Inherit;False;Property;_Mat1_Roughness;Mat1_Roughness;4;0;Create;True;0;0;0;False;0;False;0.5;0.5;0;2;0;1;FLOAT;0
Node;AmplifyShaderEditor.StaticSwitch;11;-1258.789,660.0801;Inherit;False;Property;_Mat2_ColorTexture;Mat2_ColorTexture;21;0;Create;True;0;0;0;False;0;False;0;1;1;True;;Toggle;2;Key0;Key1;Create;True;True;All;9;1;COLOR;0,0,0,0;False;0;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;3;COLOR;0,0,0,0;False;4;COLOR;0,0,0,0;False;5;COLOR;0,0,0,0;False;6;COLOR;0,0,0,0;False;7;COLOR;0,0,0,0;False;8;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;18;-514.5466,-46.95919;Inherit;False;3;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode;92;471.8482,58.03412;Inherit;False;Constant;_Float0;Float 0;30;0;Create;True;0;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.StaticSwitch;13;-1430.081,-261.2372;Inherit;False;Property;_Mat1_RoughnessTexture;Mat1_RoughnessTexture;10;0;Create;True;0;0;0;False;0;False;0;0;0;True;;Toggle;2;Key0;Key1;Create;True;True;All;9;1;FLOAT;0;False;0;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT;0;False;7;FLOAT;0;False;8;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;8;-1241.935,957.9409;Inherit;False;Property;_Mat2_Metallic;Mat2_Metallic;18;0;Create;True;0;0;0;False;0;False;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;4;-1283.155,-360.102;Inherit;False;Property;_Mat1_Metallic;Mat1_Metallic;5;0;Create;True;0;0;0;False;0;False;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.StaticSwitch;15;-1245.402,1047.107;Inherit;False;Property;_Mat2_RoughnessTexture;Mat2_RoughnessTexture;22;0;Create;True;0;0;0;False;0;False;0;0;0;True;;Toggle;2;Key0;Key1;Create;True;True;All;9;1;FLOAT;0;False;0;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT;0;False;7;FLOAT;0;False;8;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;36;-1003.413,517.7916;Inherit;False;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;42;-1219.9,-829.0978;Inherit;False;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.BlendNormalsNode;82;29.28052,-25.37628;Inherit;False;0;3;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SamplerNode;90;195.2255,122.7134;Inherit;True;Property;_AO;AO;31;0;Create;True;0;0;0;False;0;False;-1;44b950def6060664cab938e7e3ca7961;44b950def6060664cab938e7e3ca7961;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.StaticSwitch;80;236.0903,-147.3646;Inherit;False;Property;_Mat1_BakedNormal;Mat1_BakedNormal;8;0;Create;True;0;0;0;False;0;False;0;0;0;True;;Toggle;2;Key0;Key1;Create;True;True;All;9;1;FLOAT3;0,0,0;False;0;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT3;0,0,0;False;4;FLOAT3;0,0,0;False;5;FLOAT3;0,0,0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.StaticSwitch;91;588.977,140.9839;Inherit;False;Property;_Use_AO;Use_AO;30;0;Create;True;0;0;0;False;0;False;0;0;0;True;;Toggle;2;Key0;Key1;Create;True;True;All;9;1;FLOAT;0;False;0;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT;0;False;7;FLOAT;0;False;8;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;19;-520.3776,206.3138;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;17;-512.5402,-180.6163;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;20;-516.1099,79.82659;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;924.7648,-255.7612;Float;False;True;-1;2;ASEMaterialInspector;0;0;Standard;M_BlendMaster;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Opaque;0.5;True;True;0;False;Opaque;;Geometry;All;18;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;0;0;False;-1;0;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;True;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;False;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;23;0;88;0
WireConnection;23;1;89;0
WireConnection;25;0;23;0
WireConnection;25;1;22;0
WireConnection;26;1;25;0
WireConnection;49;0;88;0
WireConnection;49;1;89;0
WireConnection;45;0;88;0
WireConnection;45;1;89;0
WireConnection;34;0;21;2
WireConnection;34;1;26;1
WireConnection;102;0;34;0
WireConnection;102;1;101;0
WireConnection;46;0;45;0
WireConnection;46;1;47;0
WireConnection;50;0;49;0
WireConnection;50;1;48;0
WireConnection;95;0;102;0
WireConnection;95;1;38;0
WireConnection;12;1;50;0
WireConnection;10;1;46;0
WireConnection;79;0;52;0
WireConnection;79;1;10;0
WireConnection;100;0;95;0
WireConnection;85;0;76;0
WireConnection;85;1;12;0
WireConnection;84;1;100;0
WireConnection;84;2;98;0
WireConnection;87;0;45;0
WireConnection;87;1;86;0
WireConnection;5;1;50;0
WireConnection;1;1;46;0
WireConnection;77;1;6;0
WireConnection;77;0;85;0
WireConnection;53;1;2;0
WireConnection;53;0;79;0
WireConnection;81;1;87;0
WireConnection;9;1;53;0
WireConnection;9;0;10;0
WireConnection;11;1;77;0
WireConnection;11;0;12;0
WireConnection;18;0;5;0
WireConnection;18;1;1;0
WireConnection;18;2;84;0
WireConnection;13;1;3;0
WireConnection;13;0;10;4
WireConnection;15;1;7;0
WireConnection;15;0;12;4
WireConnection;36;0;6;0
WireConnection;36;1;11;0
WireConnection;42;0;2;0
WireConnection;42;1;9;0
WireConnection;82;0;18;0
WireConnection;82;1;81;0
WireConnection;90;1;86;0
WireConnection;80;1;18;0
WireConnection;80;0;82;0
WireConnection;91;1;92;0
WireConnection;91;0;90;1
WireConnection;19;0;15;0
WireConnection;19;1;13;0
WireConnection;19;2;84;0
WireConnection;17;0;36;0
WireConnection;17;1;42;0
WireConnection;17;2;84;0
WireConnection;20;0;8;0
WireConnection;20;1;4;0
WireConnection;20;2;84;0
WireConnection;0;0;17;0
WireConnection;0;1;80;0
WireConnection;0;3;20;0
WireConnection;0;4;19;0
WireConnection;0;5;91;0
ASEEND*/
//CHKSM=C3D40FB737B6242E11A1E2FBE43B2B55A7443368