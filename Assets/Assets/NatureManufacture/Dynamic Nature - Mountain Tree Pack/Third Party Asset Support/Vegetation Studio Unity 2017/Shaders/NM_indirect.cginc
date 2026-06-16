#ifdef UNITY_PROCEDURAL_INSTANCING_ENABLED
struct IndirectShaderData
{
	float4x4 PositionMatrix;
	float4x4 InversePositionMatrix;
};

#if defined(SHADER_API_GLCORE) || defined(SHADER_API_D3D11) || defined(SHADER_API_GLES3) || defined(SHADER_API_METAL) || defined(SHADER_API_VULKAN) || defined(SHADER_API_PS4) || defined(SHADER_API_XBOXONE)
StructuredBuffer<IndirectShaderData> IndirectShaderDataBuffer;
#endif	

#endif


void setup()
{
#ifdef UNITY_PROCEDURAL_INSTANCING_ENABLED

	unity_ObjectToWorld = IndirectShaderDataBuffer[unity_InstanceID].PositionMatrix;
	unity_WorldToObject = IndirectShaderDataBuffer[unity_InstanceID].InversePositionMatrix;

#ifdef FAR_CULL_ON_PROCEDURAL_INSTANCING

#define transformPosition mul(unity_ObjectToWorld, float4(0,0,0,1)).xyz
#define distanceToCamera length(transformPosition - _WorldSpaceCameraPos.xyz)

	float cull = 1.0 - saturate((distanceToCamera - _CullFarStart) / _CullFarDistance);
	unity_ObjectToWorld = mul(unity_ObjectToWorld, float4x4(cull, 0, 0, 0, 0, cull, 0, 0, 0, 0, cull, 0, 0, 0, 0, 1));

#undef transformPosition
#undef distanceToCamera

#endif

#endif
}
