// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "MK4/Rock_cover"
{
	Properties
	{
		_RockAlbedo("Rock Albedo", 2D) = "gray" {}
		_RockNormal("Rock Normal", 2D) = "bump" {}
		_Normalbase("Normal base", Range( 0 , 2)) = 0.13
		_RockSpecular("Rock Specular", 2D) = "white" {}
		_AO("AO", 2D) = "white" {}
		_CoverAlbedo("Cover Albedo", 2D) = "white" {}
		_CoverNormal("Cover Normal", 2D) = "bump" {}
		_NormalCoverPower("Normal Cover Power", Range( 0 , 2)) = 0.13
		_CoverSpecular("Cover Specular", 2D) = "white" {}
		_CoverAmount("Cover Amount", Range( 0 , 1)) = 0.13
		_CoverbyAO("Cover by AO", Range( 0 , 1)) = 0
		_DetailNormal("Detail Normal", 2D) = "bump" {}
		_NormalDetail("Normal Detail", Range( 0 , 2)) = 0.13
		_Detail("Detail", 2D) = "gray" {}
		_AODetail("AO Detail", 2D) = "white" {}
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
			float3 worldNormal;
			INTERNAL_DATA
		};

		uniform float _NormalDetail;
		uniform sampler2D _DetailNormal;
		uniform float4 _DetailNormal_ST;
		uniform float _Normalbase;
		uniform sampler2D _RockNormal;
		uniform float4 _RockNormal_ST;
		uniform float _NormalCoverPower;
		uniform sampler2D _CoverNormal;
		uniform float4 _CoverNormal_ST;
		uniform sampler2D _AO;
		uniform float4 _AO_ST;
		uniform float _CoverbyAO;
		uniform float _CoverAmount;
		uniform sampler2D _Detail;
		uniform float4 _Detail_ST;
		uniform sampler2D _RockAlbedo;
		uniform float4 _RockAlbedo_ST;
		uniform sampler2D _CoverAlbedo;
		uniform float4 _CoverAlbedo_ST;
		uniform sampler2D _RockSpecular;
		uniform float4 _RockSpecular_ST;
		uniform sampler2D _CoverSpecular;
		uniform float4 _CoverSpecular_ST;
		uniform sampler2D _AODetail;
		uniform float4 _AODetail_ST;

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float2 uv_DetailNormal = i.uv_texcoord * _DetailNormal_ST.xy + _DetailNormal_ST.zw;
			float2 uv_RockNormal = i.uv_texcoord * _RockNormal_ST.xy + _RockNormal_ST.zw;
			float3 temp_output_55_0 = BlendNormals( UnpackScaleNormal( tex2D( _DetailNormal, uv_DetailNormal ) ,_NormalDetail ) , UnpackScaleNormal( tex2D( _RockNormal, uv_RockNormal ) ,_Normalbase ) );
			float2 uv_CoverNormal = i.uv_texcoord * _CoverNormal_ST.xy + _CoverNormal_ST.zw;
			float2 uv_AO = i.uv_texcoord * _AO_ST.xy + _AO_ST.zw;
			float4 tex2DNode29 = tex2D( _AO, uv_AO );
			float3 newWorldNormal20 = WorldNormalVector( i , temp_output_55_0 );
			float clampResult62 = clamp( ( (0.0 + (tex2DNode29.r - 1.0) * ((0.0 + (_CoverbyAO - 0.0) * (2.0 - 0.0) / (1.0 - 0.0)) - 0.0) / (0.0 - 1.0)) + saturate( newWorldNormal20.y ) ) , 0.0 , 1.0 );
			float clampResult41 = clamp( ((-7.0 + (_CoverAmount - 0.3) * (1.4 - -7.0) / (1.2 - 0.3)) + (clampResult62 - 0.0) * ((0.8 + (_CoverAmount - 0.0) * (2.0 - 0.8) / (1.0 - 0.0)) - (-7.0 + (_CoverAmount - 0.3) * (1.4 - -7.0) / (1.2 - 0.3))) / (1.0 - 0.0)) , 0.0 , 1.0 );
			float3 lerpResult15 = lerp( temp_output_55_0 , BlendNormals( UnpackScaleNormal( tex2D( _CoverNormal, uv_CoverNormal ) ,_NormalCoverPower ) , temp_output_55_0 ) , clampResult41);
			float3 normalizeResult58 = normalize( lerpResult15 );
			o.Normal = normalizeResult58;
			float2 uv_Detail = i.uv_texcoord * _Detail_ST.xy + _Detail_ST.zw;
			float2 uv_RockAlbedo = i.uv_texcoord * _RockAlbedo_ST.xy + _RockAlbedo_ST.zw;
			float4 blendOpSrc51 = tex2D( _Detail, uv_Detail );
			float4 blendOpDest51 = tex2D( _RockAlbedo, uv_RockAlbedo );
			float2 uv_CoverAlbedo = i.uv_texcoord * _CoverAlbedo_ST.xy + _CoverAlbedo_ST.zw;
			float4 tex2DNode9 = tex2D( _CoverAlbedo, uv_CoverAlbedo );
			float clampResult26 = clamp( clampResult41 , 0.0 , 1.0 );
			float4 lerpResult10 = lerp( ( saturate( (( blendOpDest51 > 0.5 ) ? ( 1.0 - ( 1.0 - 2.0 * ( blendOpDest51 - 0.5 ) ) * ( 1.0 - blendOpSrc51 ) ) : ( 2.0 * blendOpDest51 * blendOpSrc51 ) ) )) , tex2DNode9 , clampResult26);
			o.Albedo = lerpResult10.rgb;
			float2 uv_RockSpecular = i.uv_texcoord * _RockSpecular_ST.xy + _RockSpecular_ST.zw;
			float4 temp_cast_1 = (tex2D( _RockSpecular, uv_RockSpecular ).a).xxxx;
			float2 uv_CoverSpecular = i.uv_texcoord * _CoverSpecular_ST.xy + _CoverSpecular_ST.zw;
			float4 lerpResult17 = lerp( temp_cast_1 , tex2D( _CoverSpecular, uv_CoverSpecular ) , clampResult26);
			o.Smoothness = lerpResult17.r;
			float2 uv_AODetail = i.uv_texcoord * _AODetail_ST.xy + _AODetail_ST.zw;
			o.Occlusion = ( tex2DNode29.r * tex2D( _AODetail, uv_AODetail ).r );
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
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=14201
82;351;1472;701;4397.897;693.2451;3.312426;True;True
Node;AmplifyShaderEditor.RangedFloatNode;56;-3053.078,-173.8841;Float;False;Property;_NormalDetail;Normal Detail;12;0;Create;0.13;0.4;0;2;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;57;-3052.641,64.47824;Float;False;Property;_Normalbase;Normal base;2;0;Create;0.13;1;0;2;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;4;-2728.438,-5.670311;Float;True;Property;_RockNormal;Rock Normal;1;0;Create;096782e0373354d4c874fb467a4ba6bd;096782e0373354d4c874fb467a4ba6bd;True;0;True;bump;Auto;True;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;0,0;False;1;FLOAT2;0,0;False;2;FLOAT;1.0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1.0;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;54;-2727.961,-256.0311;Float;True;Property;_DetailNormal;Detail Normal;11;0;Create;None;702a6a3ec5172994699249e18a899bf1;True;0;True;bump;Auto;True;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0.0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1.0;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.BlendNormalsNode;55;-2414.335,-72.79214;Float;False;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode;45;-2248.33,-406.8345;Float;False;Property;_CoverbyAO;Cover by AO;10;0;Create;0;0.25;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.WorldNormalVector;20;-2100.311,-242.6568;Float;False;1;0;FLOAT3;0,0,0;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SamplerNode;29;-1783.641,695.9526;Float;True;Property;_AO;AO;4;0;Create;None;ec3ecf7c00c74af40a1728f96025aa0d;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0.0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1.0;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TFHCRemapNode;50;-1988.431,-463.4362;Float;False;5;0;FLOAT;0.0;False;1;FLOAT;0.0;False;2;FLOAT;1.0;False;3;FLOAT;0.0;False;4;FLOAT;2.0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;22;-1895.679,-212.6008;Float;False;1;0;FLOAT;0.0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCRemapNode;48;-1775.67,-467.659;Float;False;5;0;FLOAT;0.0;False;1;FLOAT;1.0;False;2;FLOAT;0.0;False;3;FLOAT;0.0;False;4;FLOAT;0.0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;49;-1627.526,-352.046;Float;False;2;2;0;FLOAT;0.0;False;1;FLOAT;0.0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;12;-1694.75,-114.5753;Float;False;Property;_CoverAmount;Cover Amount;9;0;Create;0.13;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCRemapNode;40;-1342.479,-249.2735;Float;False;5;0;FLOAT;0.0;False;1;FLOAT;0.3;False;2;FLOAT;1.2;False;3;FLOAT;-7.0;False;4;FLOAT;1.4;False;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCRemapNode;39;-1343.22,-66.72542;Float;False;5;0;FLOAT;0.0;False;1;FLOAT;0.0;False;2;FLOAT;1.0;False;3;FLOAT;0.8;False;4;FLOAT;2.0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;61;-2395.247,560.0236;Float;False;Property;_NormalCoverPower;Normal Cover Power;7;0;Create;0.13;0;0;2;0;1;FLOAT;0
Node;AmplifyShaderEditor.ClampOpNode;62;-1506.857,-395.0685;Float;False;3;0;FLOAT;0.0;False;1;FLOAT;0.0;False;2;FLOAT;1.0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;14;-2065.081,466.4261;Float;True;Property;_CoverNormal;Cover Normal;6;0;Create;82681e35c9155e94a8c5d88e2e801a89;af2134b0a8ccc584db0264ff9166ddc6;True;0;True;bump;Auto;True;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;0,0;False;1;FLOAT2;0,0;False;2;FLOAT;1.0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1.0;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TFHCRemapNode;38;-1137.241,-344.8055;Float;False;5;0;FLOAT;0.0;False;1;FLOAT;0.0;False;2;FLOAT;1.0;False;3;FLOAT;-6.0;False;4;FLOAT;0.9;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;53;-2028.784,-1262.28;Float;True;Property;_Detail;Detail;13;0;Create;None;779e8e2c6fa6f3e4cb29f88a59abf5c8;True;0;False;gray;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0.0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1.0;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ClampOpNode;41;-940.7082,-287.1443;Float;False;3;0;FLOAT;0.0;False;1;FLOAT;0.0;False;2;FLOAT;1.0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;1;-2037.44,-1052.243;Float;True;Property;_RockAlbedo;Rock Albedo;0;0;Create;9b487e25ce9473948b8cbce4d2aeb25c;9b487e25ce9473948b8cbce4d2aeb25c;True;0;False;gray;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;0,0;False;1;FLOAT2;0,0;False;2;FLOAT;1.0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1.0;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.BlendNormalsNode;31;-1399.708,421.8192;Float;False;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SamplerNode;9;-2000.554,-695.4543;Float;True;Property;_CoverAlbedo;Cover Albedo;5;0;Create;a2c25eda4b27b5c4fa31b4817799c234;e2773268d97db794ba32570132cf2602;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;0,0;False;1;FLOAT2;0,0;False;2;FLOAT;1.0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1.0;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;2;-693.0005,253.9001;Float;True;Property;_RockSpecular;Rock Specular;3;0;Create;b6757776081c3c64192c325db797d664;b6757776081c3c64192c325db797d664;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;0,0;False;1;FLOAT2;0,0;False;2;FLOAT;1.0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1.0;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.BlendOpsNode;51;-1487.359,-958.7681;Float;False;Overlay;True;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;15;-838.5424,106.4919;Float;False;3;0;FLOAT3;0.0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT;0.0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SamplerNode;16;-704.8019,470.7009;Float;True;Property;_CoverSpecular;Cover Specular;8;0;Create;210da0a4919dc9744bd2559bf23d2fb7;210da0a4919dc9744bd2559bf23d2fb7;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;0,0;False;1;FLOAT2;0,0;False;2;FLOAT;1.0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1.0;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ClampOpNode;26;-575.5357,-307.1779;Float;False;3;0;FLOAT;0.0;False;1;FLOAT;0.0;False;2;FLOAT;1.0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;59;-1748.182,935.4699;Float;True;Property;_AODetail;AO Detail;14;0;Create;None;a27cc6ae19fd16d44bf8040b7910e091;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0.0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1.0;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.LerpOp;35;-1875.248,295.4169;Float;False;3;0;FLOAT3;0,0,0;False;1;FLOAT3;0.0,0,0;False;2;FLOAT;0.5;False;1;FLOAT3;0
Node;AmplifyShaderEditor.LerpOp;17;-223.4019,317.8009;Float;False;3;0;COLOR;0.0,0,0,0;False;1;COLOR;0;False;2;FLOAT;0.0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;42;-1320.113,-405.3875;Float;False;2;2;0;FLOAT;0.0;False;1;FLOAT;0.0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;10;-312.2803,-427.0809;Float;False;3;0;COLOR;0.0,0,0,0;False;1;COLOR;0.0,0,0,0;False;2;FLOAT;0.0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.Vector3Node;36;-2128.721,296.4045;Float;False;Constant;_Vector0;Vector 0;8;0;Create;0,0,1;0,0,0;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.LerpOp;37;-1652.29,258.6799;Float;False;3;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;60;-1339.649,754.67;Float;False;2;2;0;FLOAT;0.0;False;1;FLOAT;0.0;False;1;FLOAT;0
Node;AmplifyShaderEditor.NormalizeNode;58;-639.6517,87.59093;Float;False;1;0;FLOAT3;0,0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;173.1982,39.34741;Float;False;True;2;Float;ASEMaterialInspector;0;0;Standard;MK4/Rock_cover;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;3;False;0;0;Opaque;0.5;True;True;0;False;Opaque;Geometry;All;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;False;0;255;255;0;0;0;0;0;0;0;0;False;0;4;10;25;False;0.5;True;0;Zero;Zero;0;Zero;Zero;Add;Add;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;0;0;False;0;0;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0.0;False;4;FLOAT;0.0;False;5;FLOAT;0.0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0.0;False;9;FLOAT;0.0;False;10;FLOAT;0.0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;4;5;57;0
WireConnection;54;5;56;0
WireConnection;55;0;54;0
WireConnection;55;1;4;0
WireConnection;20;0;55;0
WireConnection;50;0;45;0
WireConnection;22;0;20;2
WireConnection;48;0;29;1
WireConnection;48;4;50;0
WireConnection;49;0;48;0
WireConnection;49;1;22;0
WireConnection;40;0;12;0
WireConnection;39;0;12;0
WireConnection;62;0;49;0
WireConnection;14;5;61;0
WireConnection;38;0;62;0
WireConnection;38;3;40;0
WireConnection;38;4;39;0
WireConnection;41;0;38;0
WireConnection;31;0;14;0
WireConnection;31;1;55;0
WireConnection;51;0;53;0
WireConnection;51;1;1;0
WireConnection;15;0;55;0
WireConnection;15;1;31;0
WireConnection;15;2;41;0
WireConnection;26;0;41;0
WireConnection;35;0;55;0
WireConnection;35;1;36;0
WireConnection;17;0;2;4
WireConnection;17;1;16;0
WireConnection;17;2;26;0
WireConnection;42;0;62;0
WireConnection;42;1;9;4
WireConnection;10;0;51;0
WireConnection;10;1;9;0
WireConnection;10;2;26;0
WireConnection;37;0;55;0
WireConnection;37;1;35;0
WireConnection;37;2;9;4
WireConnection;60;0;29;1
WireConnection;60;1;59;1
WireConnection;58;0;15;0
WireConnection;0;0;10;0
WireConnection;0;1;58;0
WireConnection;0;4;17;0
WireConnection;0;5;60;0
ASEEND*/
//CHKSM=B4CE613D1A6357B8EF6419AEDF543CD9CBA24A81