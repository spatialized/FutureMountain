Shader "VacuumShaders/Terrain To Mesh/Legacy Shaders/Bumped/3 Textures" 
{
	Properties 
	{
		_Color("Color", color) = (1, 1, 1, 1)
		[NoScaleOffset]_V_T2M_Control ("Control Map (RGBA)", 2D) = "black" {}

		//TTM				
		[V_T2M_Layer] _V_T2M_Splat1 ("Layer 1 (R)", 2D) = "white" {}
		[HideInInspector] _V_T2M_Splat1_uvScale("", float) = 1	
		[HideInInspector] _V_T2M_Splat1_bumpMap("", 2D) = ""{}	

		[V_T2M_Layer] _V_T2M_Splat2 ("Layer 2 (G)", 2D) = "white" {}
		[HideInInspector] _V_T2M_Splat2_uvScale("", float) = 1	
		[HideInInspector] _V_T2M_Splat2_bumpMap("", 2D) = ""{}	

		[V_T2M_Layer] _V_T2M_Splat3 ("Layer 3 (B)", 2D) = "white" {}
		[HideInInspector] _V_T2M_Splat3_uvScale("", float) = 1	
		[HideInInspector] _V_T2M_Splat3_bumpMap("", 2D) = ""{}	


		//Fallback use only
		[NoScaleOffset]_MainTex("BaseMap (Fallback use only!)", 2D) = "white" {}
	}

	SubShader  
	{
		Tags { "RenderType"="Opaque" }
		LOD 200
		
		CGPROGRAM
		#pragma surface surf Lambert vertex:vert
		#pragma target 2.0


		#define V_T2M_3_TEX
		#define V_T2M_BUMP

		#include "../cginc/T2M_Deferred.cginc"		

		ENDCG
	} 
	
	FallBack "Hidden/VacuumShaders/Fallback/VertexLit"
}
