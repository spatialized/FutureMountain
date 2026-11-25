Shader "NatureManufacture/URP/Lit/Lit Top Cover 2"
{
    Properties
    {
        _AlphaCutoff("Alpha Cutoff", Range(0, 1)) = 0.5
        _BaseColor("Base Color (RGB) Alpha (A)", Color) = (1, 1, 1, 0)
        [NoScaleOffset]_BaseColorMap("Base Map (RGB) Alpha (A)", 2D) = "white" {}
        [ToggleUI]_BaseUsePlanarUV("Base Use Planar UV", Float) = 0
        _BaseTilingOffset("Base Tiling and Offset", Vector, 4) = (1, 1, 0, 0)
        [Normal][NoScaleOffset]_BaseNormalMap("Base Normal Map", 2D) = "bump" {}
        _BaseNormalScale("Base Normal Scale", Range(0, 8)) = 1
        [NoScaleOffset]_BaseMaskMap("Base Mask Map MT(R) AO(G) H(B) SM(A)", 2D) = "white" {}
        _BaseMetallic("Base Metallic", Range(0, 1)) = 1
        _BaseAORemapMin("Base AO Remap Min", Range(0, 1)) = 0
        _BaseAORemapMax("Base AO Remap Max", Range(0, 1)) = 1
        [ToggleUI]_USEBaseHeightT("Use Base Height (T)", Float) = 1
        _HeightMin("Base Height Min", Float) = 0
        _HeightMax("Base Height Max", Float) = 1
        _HeightOffset("Base Height Offset", Float) = 0
        _BaseSmoothnessRemapMin("Base Smoothness Remap Min", Range(0, 1)) = 0
        _BaseSmoothnessRemapMax("Base Smoothness Remap Max", Range(0, 1)) = 1
        [NoScaleOffset]_Masks("Cover Mask (A)", 2D) = "white" {}
        _Cover_Mask_A_Remap_Min("Cover Mask (A) Remap Min", Float) = 0
        _Cover_Mask_A_Remap_Max("Cover Mask (A) Remap Max", Float) = 1
        [Toggle(_USEDYNAMICCOVERTSTATICMASKF)]_USEDYNAMICCOVERTSTATICMASKF("Use Dynamic Cover", Float) = 0
        _Cover_Amount("Dynamic Cover Amount", Range(0, 2)) = 2
        _Cover_Amount_Grow_Speed("Dynamic Cover Amount Grow Speed", Range(0, 3)) = 3
        _Cover_Max_Angle("Dynamic Cover Max Angle", Range(0.001, 90)) = 35
        _CoverHardness("Dynamic Cover Max Angle Hardness", Range(0, 10)) = 5
        _CoverNormalBlendHardness("Dynamic Cover Normal Blend Hardness", Range(0, 8)) = 1
        _Cover_Min_Height("Dynamic Cover Min Height", Float) = -10000
        _Cover_Min_Height_Blending("Dynamic Cover Min Height Blending", Range(0, 500)) = 1
        _VertexColorGBlendStrenght("Height and VC (G) Top Cover Blend Power", Range(0, 100)) = 1
        _VertexColorBBlendStrenght("Height and VC (B) Cover Overlay Blend Power", Range(0, 100)) = 1
        _CoverBaseColor("Cover Base Color (RGB) Alpha (A)", Color) = (1, 1, 1, 0)
        [NoScaleOffset]_CoverBaseColorMap("Cover Base Map (RGB) Alpha (A)", 2D) = "white" {}
        [ToggleUI]_CoverUsePlanarUV("Cover Use Planar UV", Float) = 1
        _CoverTilingOffset("Cover Tiling Offset", Vector, 4) = (1, 1, 0, 0)
        [Normal][NoScaleOffset]_CoverNormalMap("Cover Normal Map", 2D) = "bump" {}
        _CoverNormalScale("Cover Normal Scale", Range(0, 8)) = 1
        [NoScaleOffset]_CoverMaskMap("Cover Mask Map MT(R) AO(G) H(B) SM(A)", 2D) = "white" {}
        _CoverMetallic("Cover Metallic", Range(0, 1)) = 1
        _CoverAORemapMin("Cover AO Remap Min", Range(0, 1)) = 0
        _CoverAORemapMax("Cover AO Remap Max", Range(0, 1)) = 1
        [ToggleUI]_USECoverHeightT("Use Cover Height (T)", Float) = 1
        _CoverHeightMapMin("Cover Height Map Min", Float) = 0
        _CoverHeightMapMax("Cover Height Map Max", Float) = 1
        _CoverHeightMapOffset("Cover Height Map Offset", Float) = 0
        _CoverSmoothnessRemapMin("Cover Smoothness Remap Min", Range(0, 1)) = 0
        _CoverSmoothnessRemapMax("Cover Smoothness Remap Max", Range(0, 1)) = 1
        [NoScaleOffset]_DetailMap("Detail Map Base (R) Ny(G) Sm(B) Nx(A)", 2D) = "white" {}
        _DetailTilingOffset("Detail Tiling Offset", Vector, 4) = (1, 1, 0, 0)
        _DetailAlbedoScale("Detail Albedo Scale", Range(0, 2)) = 0
        _DetailNormalScale("Detail Normal Scale", Range(0, 2)) = 0
        _DetailSmoothnessScale("Detail Smoothness Scale", Range(0, 2)) = 0
        [Toggle(_WETNESS_T_HEAT_F)]_WETNESS_T_HEAT_F("Wetness (T) Heat (F)", Float) = 1
        _WetColor("Wet Color Vertex (R)", Color) = (0.7735849, 0.7735849, 0.7735849, 0)
        _WetSmoothness("Wet Smoothness Vertex (R)", Range(0, 1)) = 1
        [HDR]_LavaEmissionColor("Emission Color (RGB)", Color) = (1, 0, 0, 0)
        _BaseEmissionMaskIntensivity("Base Emission Mask Intensivity", Range(0, 100)) = 0
        _BaseEmissionMaskTreshold("Base Emission Mask Treshold", Range(0.01, 100)) = 1
        _CoverEmissionMaskIntensivity("Cover Emission Mask Intensivity", Range(0, 100)) = 0
        _CoverEmissionMaskTreshold("Cover Emission Mask Treshold", Range(0.01, 100)) = 1
        [HDR]_RimColor("Rim Color", Color) = (766.9961, 12.04706, 0, 0)
        _RimLightPower("Rim Light Power", Float) = 4
        [NoScaleOffset]_Noise("Emission Noise (A)", 2D) = "white" {}
        [ToggleUI]Emission_Noise_UV0_UV3("Emission Noise UV0 (T) UV3 (F)", Float) = 1
        [ToggleUI]_EmissionNoiseUsePlanarUV("Emission Noise Use Planar UV", Float) = 0
        _Emission_Noise_Tiling_and_Offset("Emission Noise Tiling and Offset", Vector, 4) = (1, 1, 0, 0)
        _EmissionNoiseMultiply("Emission Noise Multiply", Range(0, 10)) = 1
        _EmissionNoisePower("Emission Noise Power", Range(0, 10)) = 2.71
        _NoiseSpeed("Emission Noise Speed", Vector, 2) = (0.001, 0.005, 0, 0)
        [HideInInspector]_WorkflowMode("_WorkflowMode", Float) = 1
        [HideInInspector]_CastShadows("_CastShadows", Float) = 1
        [HideInInspector]_ReceiveShadows("_ReceiveShadows", Float) = 1
        [HideInInspector]_Surface("_Surface", Float) = 0
        [HideInInspector]_Blend("_Blend", Float) = 0
        [HideInInspector]_AlphaClip("_AlphaClip", Float) = 0
        [HideInInspector]_BlendModePreserveSpecular("_BlendModePreserveSpecular", Float) = 1
        [HideInInspector]_SrcBlend("_SrcBlend", Float) = 1
        [HideInInspector]_DstBlend("_DstBlend", Float) = 0
        [HideInInspector]_SrcBlendAlpha("_SrcBlendAlpha", Float) = 1
        [HideInInspector]_DstBlendAlpha("_DstBlendAlpha", Float) = 0
        [HideInInspector][ToggleUI]_ZWrite("_ZWrite", Float) = 1
        [HideInInspector]_ZWriteControl("_ZWriteControl", Float) = 0
        [HideInInspector]_ZTest("_ZTest", Float) = 4
        [HideInInspector]_Cull("_Cull", Float) = 2
        [HideInInspector]_AlphaToMask("_AlphaToMask", Float) = 0
        [HideInInspector]_QueueOffset("_QueueOffset", Float) = 0
        [HideInInspector]_QueueControl("_QueueControl", Float) = -1
        [HideInInspector][NoScaleOffset]unity_Lightmaps("unity_Lightmaps", 2DArray) = "" {}
        [HideInInspector][NoScaleOffset]unity_LightmapsInd("unity_LightmapsInd", 2DArray) = "" {}
        [HideInInspector][NoScaleOffset]unity_ShadowMasks("unity_ShadowMasks", 2DArray) = "" {}
    }
    SubShader
    {
        Tags
        {
            "RenderPipeline"="UniversalPipeline"
            "RenderType"="Opaque"
            "UniversalMaterialType" = "Lit"
            "Queue"="Geometry"
            "DisableBatching"="LODFading"
            "ShaderGraphShader"="true"
            "ShaderGraphTargetId"="UniversalLitSubTarget"
        }
        Pass
        {
            Name "Universal Forward"
            Tags
            {
                "LightMode" = "UniversalForward"
            }
        
        // Render State
        Cull [_Cull]
        Blend [_SrcBlend] [_DstBlend], [_SrcBlendAlpha] [_DstBlendAlpha]
        ZTest [_ZTest]
        ZWrite [_ZWrite]
        AlphaToMask [_AlphaToMask]
        
        // Debug
        // <None>
        
        // --------------------------------------------------
        // Pass
        
        HLSLPROGRAM
        
        // Pragmas
        #pragma target 2.0
        #pragma multi_compile_instancing
        #pragma instancing_options renderinglayer
        #pragma vertex vert
        #pragma fragment frag
        
        // Keywords
        #pragma multi_compile_fragment _ _SCREEN_SPACE_OCCLUSION
        #pragma multi_compile_fragment _ _SCREEN_SPACE_IRRADIANCE
        #pragma multi_compile _ LIGHTMAP_ON
        #pragma multi_compile _ DYNAMICLIGHTMAP_ON
        #pragma multi_compile _ DIRLIGHTMAP_COMBINED
        #pragma multi_compile _ USE_LEGACY_LIGHTMAPS
        #pragma multi_compile _ LIGHTMAP_BICUBIC_SAMPLING
        #pragma multi_compile _ REFLECTION_PROBE_ROTATION
        #pragma multi_compile _ _MAIN_LIGHT_SHADOWS _MAIN_LIGHT_SHADOWS_CASCADE _MAIN_LIGHT_SHADOWS_SCREEN
        #pragma multi_compile _ _ADDITIONAL_LIGHTS_VERTEX _ADDITIONAL_LIGHTS
        #pragma multi_compile_fragment _ _ADDITIONAL_LIGHT_SHADOWS
        #pragma multi_compile_fragment _ _REFLECTION_PROBE_BLENDING
        #pragma multi_compile_fragment _ _REFLECTION_PROBE_BOX_PROJECTION
        #pragma multi_compile_fragment _ _REFLECTION_PROBE_ATLAS
        #pragma multi_compile_fragment _ _SHADOWS_SOFT _SHADOWS_SOFT_LOW _SHADOWS_SOFT_MEDIUM _SHADOWS_SOFT_HIGH
        #pragma multi_compile _ LIGHTMAP_SHADOW_MIXING
        #pragma multi_compile _ SHADOWS_SHADOWMASK
        #pragma multi_compile_fragment _ _DBUFFER_MRT1 _DBUFFER_MRT2 _DBUFFER_MRT3
        #pragma multi_compile_fragment _ _LIGHT_LAYERS
        #pragma multi_compile_fragment _ DEBUG_DISPLAY
        #pragma multi_compile_fragment _ _LIGHT_COOKIES
        #pragma multi_compile _ _CLUSTER_LIGHT_LOOP
        #pragma multi_compile _ EVALUATE_SH_MIXED EVALUATE_SH_VERTEX
        #pragma shader_feature_fragment _ _SURFACE_TYPE_TRANSPARENT
        #pragma shader_feature_local_fragment _ _ALPHAPREMULTIPLY_ON
        #pragma shader_feature_local_fragment _ _ALPHAMODULATE_ON
        #pragma shader_feature_local_fragment _ _ALPHATEST_ON
        #pragma shader_feature_local_fragment _ _SPECULAR_SETUP
        #pragma shader_feature_local _ _RECEIVE_SHADOWS_OFF
        #pragma multi_compile _ LOD_FADE_CROSSFADE
        #pragma shader_feature_local _ _USEDYNAMICCOVERTSTATICMASKF
        #pragma shader_feature_local _ _WETNESS_T_HEAT_F
        
        #if defined(_USEDYNAMICCOVERTSTATICMASKF) && defined(_WETNESS_T_HEAT_F)
            #define KEYWORD_PERMUTATION_0
        #elif defined(_USEDYNAMICCOVERTSTATICMASKF)
            #define KEYWORD_PERMUTATION_1
        #elif defined(_WETNESS_T_HEAT_F)
            #define KEYWORD_PERMUTATION_2
        #else
            #define KEYWORD_PERMUTATION_3
        #endif
        
        
        // Defines
        
        #define _NORMALMAP 1
        #define _NORMAL_DROPOFF_TS 1
        #define ATTRIBUTES_NEED_NORMAL
        #define ATTRIBUTES_NEED_TANGENT
        #define ATTRIBUTES_NEED_TEXCOORD0
        #define ATTRIBUTES_NEED_TEXCOORD1
        #define ATTRIBUTES_NEED_TEXCOORD2
        #define ATTRIBUTES_NEED_TEXCOORD3
        #define ATTRIBUTES_NEED_COLOR
        #define FEATURES_GRAPH_VERTEX_NORMAL_OUTPUT
        #define FEATURES_GRAPH_VERTEX_TANGENT_OUTPUT
        #define VARYINGS_NEED_POSITION_WS
        #define VARYINGS_NEED_NORMAL_WS
        #define VARYINGS_NEED_TANGENT_WS
        #define VARYINGS_NEED_TEXCOORD0
        #define VARYINGS_NEED_TEXCOORD3
        #define VARYINGS_NEED_COLOR
        #define VARYINGS_NEED_FOG_AND_VERTEX_LIGHT
        #define VARYINGS_NEED_SHADOW_COORD
        #define FEATURES_GRAPH_VERTEX
        /* WARNING: $splice Could not find named fragment 'PassInstancing' */
        #define SHADERPASS SHADERPASS_FORWARD
        #define USE_UNITY_CROSSFADE 1
        
        
        // custom interpolator pre-include
        /* WARNING: $splice Could not find named fragment 'sgci_CustomInterpolatorPreInclude' */
        
        // Includes
        #include_with_pragmas "Packages/com.unity.render-pipelines.universal/ShaderLibrary/DOTS.hlsl"
        #include_with_pragmas "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Fog.hlsl"
        #include_with_pragmas "Packages/com.unity.render-pipelines.universal/ShaderLibrary/RenderingLayers.hlsl"
        #include_with_pragmas "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ProbeVolumeVariants.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Texture.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
        #include_with_pragmas "Packages/com.unity.render-pipelines.core/ShaderLibrary/FoveatedRenderingKeywords.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/FoveatedRendering.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Input.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/TextureStack.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/DebugMipmapStreamingMacros.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Shadows.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/DBuffer.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShaderPass.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/LODCrossFade.hlsl"
        
        // --------------------------------------------------
        // Structs and Packing
        
        // custom interpolators pre packing
        /* WARNING: $splice Could not find named fragment 'CustomInterpolatorPrePacking' */
        
        struct Attributes
        {
             float3 positionOS : POSITION;
             float3 normalOS : NORMAL;
             float4 tangentOS : TANGENT;
             float4 uv0 : TEXCOORD0;
             float4 uv1 : TEXCOORD1;
             float4 uv2 : TEXCOORD2;
             float4 uv3 : TEXCOORD3;
             float4 color : COLOR;
            #if UNITY_ANY_INSTANCING_ENABLED || defined(ATTRIBUTES_NEED_INSTANCEID)
             uint instanceID : INSTANCEID_SEMANTIC;
            #endif
        };
        struct Varyings
        {
             float4 positionCS : SV_POSITION;
             float3 positionWS;
             float3 normalWS;
             float4 tangentWS;
             float4 texCoord0;
             float4 texCoord3;
             float4 color;
            #if defined(LIGHTMAP_ON)
             float2 staticLightmapUV;
            #endif
            #if defined(DYNAMICLIGHTMAP_ON)
             float2 dynamicLightmapUV;
            #endif
            #if !defined(LIGHTMAP_ON)
             float3 sh;
            #endif
            #if defined(USE_APV_PROBE_OCCLUSION)
             float4 probeOcclusion;
            #endif
             float4 fogFactorAndVertexLight;
            #if defined(REQUIRES_VERTEX_SHADOW_COORD_INTERPOLATOR)
             float4 shadowCoord;
            #endif
            #if UNITY_ANY_INSTANCING_ENABLED || defined(VARYINGS_NEED_INSTANCEID)
             uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
             uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
             uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
             FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
        };
        struct SurfaceDescriptionInputs
        {
             float3 WorldSpaceNormal;
             float3 TangentSpaceNormal;
             float3 WorldSpaceTangent;
             float3 WorldSpaceBiTangent;
             float3 WorldSpaceViewDirection;
             float3 TangentSpaceViewDirection;
             float3 AbsoluteWorldSpacePosition;
             float4 uv0;
             float4 uv3;
             float4 VertexColor;
        };
        struct VertexDescriptionInputs
        {
             float3 ObjectSpaceNormal;
             float3 ObjectSpaceTangent;
             float3 ObjectSpacePosition;
        };
        struct PackedVaryings
        {
             float4 positionCS : SV_POSITION;
            #if defined(LIGHTMAP_ON)
             float2 staticLightmapUV : INTERP0;
            #endif
            #if defined(DYNAMICLIGHTMAP_ON)
             float2 dynamicLightmapUV : INTERP1;
            #endif
            #if !defined(LIGHTMAP_ON)
             float3 sh : INTERP2;
            #endif
            #if defined(USE_APV_PROBE_OCCLUSION)
             float4 probeOcclusion : INTERP3;
            #endif
            #if defined(REQUIRES_VERTEX_SHADOW_COORD_INTERPOLATOR)
             float4 shadowCoord : INTERP4;
            #endif
             float4 tangentWS : INTERP5;
             float4 texCoord0 : INTERP6;
             float4 texCoord3 : INTERP7;
             float4 color : INTERP8;
             float4 fogFactorAndVertexLight : INTERP9;
             float3 positionWS : INTERP10;
             float3 normalWS : INTERP11;
            #if UNITY_ANY_INSTANCING_ENABLED || defined(VARYINGS_NEED_INSTANCEID)
             uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
             uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
             uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
             FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
        };
        
        PackedVaryings PackVaryings (Varyings input)
        {
            PackedVaryings output;
            ZERO_INITIALIZE(PackedVaryings, output);
            output.positionCS = input.positionCS;
            #if defined(LIGHTMAP_ON)
            output.staticLightmapUV = input.staticLightmapUV;
            #endif
            #if defined(DYNAMICLIGHTMAP_ON)
            output.dynamicLightmapUV = input.dynamicLightmapUV;
            #endif
            #if !defined(LIGHTMAP_ON)
            output.sh = input.sh;
            #endif
            #if defined(USE_APV_PROBE_OCCLUSION)
            output.probeOcclusion = input.probeOcclusion;
            #endif
            #if defined(REQUIRES_VERTEX_SHADOW_COORD_INTERPOLATOR)
            output.shadowCoord = input.shadowCoord;
            #endif
            output.tangentWS.xyzw = input.tangentWS;
            output.texCoord0.xyzw = input.texCoord0;
            output.texCoord3.xyzw = input.texCoord3;
            output.color.xyzw = input.color;
            output.fogFactorAndVertexLight.xyzw = input.fogFactorAndVertexLight;
            output.positionWS.xyz = input.positionWS;
            output.normalWS.xyz = input.normalWS;
            #if UNITY_ANY_INSTANCING_ENABLED || defined(VARYINGS_NEED_INSTANCEID)
            output.instanceID = input.instanceID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            output.cullFace = input.cullFace;
            #endif
            return output;
        }
        
        Varyings UnpackVaryings (PackedVaryings input)
        {
            Varyings output;
            output.positionCS = input.positionCS;
            #if defined(LIGHTMAP_ON)
            output.staticLightmapUV = input.staticLightmapUV;
            #endif
            #if defined(DYNAMICLIGHTMAP_ON)
            output.dynamicLightmapUV = input.dynamicLightmapUV;
            #endif
            #if !defined(LIGHTMAP_ON)
            output.sh = input.sh;
            #endif
            #if defined(USE_APV_PROBE_OCCLUSION)
            output.probeOcclusion = input.probeOcclusion;
            #endif
            #if defined(REQUIRES_VERTEX_SHADOW_COORD_INTERPOLATOR)
            output.shadowCoord = input.shadowCoord;
            #endif
            output.tangentWS = input.tangentWS.xyzw;
            output.texCoord0 = input.texCoord0.xyzw;
            output.texCoord3 = input.texCoord3.xyzw;
            output.color = input.color.xyzw;
            output.fogFactorAndVertexLight = input.fogFactorAndVertexLight.xyzw;
            output.positionWS = input.positionWS.xyz;
            output.normalWS = input.normalWS.xyz;
            #if UNITY_ANY_INSTANCING_ENABLED || defined(VARYINGS_NEED_INSTANCEID)
            output.instanceID = input.instanceID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            output.cullFace = input.cullFace;
            #endif
            return output;
        }
        
        
        // --------------------------------------------------
        // Graph
        
        // Graph Properties
        CBUFFER_START(UnityPerMaterial)
        float _EmissionNoiseMultiply;
        float _EmissionNoisePower;
        float Emission_Noise_UV0_UV3;
        float _EmissionNoiseUsePlanarUV;
        float _BaseEmissionMaskTreshold;
        float _CoverEmissionMaskIntensivity;
        float _CoverEmissionMaskTreshold;
        float4 _RimColor;
        float _RimLightPower;
        float4 _Noise_TexelSize;
        float2 _NoiseSpeed;
        float _BaseEmissionMaskIntensivity;
        float4 _LavaEmissionColor;
        float4 _Emission_Noise_Tiling_and_Offset;
        float _Cover_Mask_A_Remap_Min;
        float _Cover_Mask_A_Remap_Max;
        float _HeightMin;
        float _HeightMax;
        float _HeightOffset;
        float _VertexColorBBlendStrenght;
        float _USECoverHeightT;
        float _AlphaCutoff;
        float4 _WetColor;
        float4 _BaseColor;
        float _USEBaseHeightT;
        float4 _BaseColorMap_TexelSize;
        float _BaseUsePlanarUV;
        float4 _BaseTilingOffset;
        float4 _BaseNormalMap_TexelSize;
        float _BaseNormalScale;
        float4 _BaseMaskMap_TexelSize;
        float _BaseMetallic;
        float _VertexColorGBlendStrenght;
        float _BaseAORemapMin;
        float _BaseAORemapMax;
        float _BaseSmoothnessRemapMin;
        float _BaseSmoothnessRemapMax;
        float4 _Masks_TexelSize;
        float _Cover_Amount;
        float _Cover_Amount_Grow_Speed;
        float _Cover_Max_Angle;
        float _Cover_Min_Height;
        float _Cover_Min_Height_Blending;
        float4 _CoverBaseColor;
        float4 _CoverBaseColorMap_TexelSize;
        float _CoverUsePlanarUV;
        float4 _CoverTilingOffset;
        float4 _CoverNormalMap_TexelSize;
        float _CoverNormalScale;
        float _CoverNormalBlendHardness;
        float _CoverHardness;
        float _CoverHeightMapMin;
        float _CoverHeightMapMax;
        float _CoverHeightMapOffset;
        float4 _CoverMaskMap_TexelSize;
        float _CoverMetallic;
        float _CoverAORemapMin;
        float _CoverAORemapMax;
        float _CoverSmoothnessRemapMin;
        float _CoverSmoothnessRemapMax;
        float4 _DetailMap_TexelSize;
        float4 _DetailTilingOffset;
        float _DetailAlbedoScale;
        float _DetailNormalScale;
        float _DetailSmoothnessScale;
        float _WetSmoothness;
        UNITY_TEXTURE_STREAMING_DEBUG_VARS;
        CBUFFER_END
        
        
        // Object and Global properties
        SAMPLER(SamplerState_Linear_Repeat);
        SAMPLER(SamplerState_Linear_Repeat_Aniso8);
        TEXTURE2D(_Noise);
        SAMPLER(sampler_Noise);
        TEXTURE2D(_BaseColorMap);
        SAMPLER(sampler_BaseColorMap);
        TEXTURE2D(_BaseNormalMap);
        SAMPLER(sampler_BaseNormalMap);
        TEXTURE2D(_BaseMaskMap);
        SAMPLER(sampler_BaseMaskMap);
        TEXTURE2D(_Masks);
        SAMPLER(sampler_Masks);
        TEXTURE2D(_CoverBaseColorMap);
        SAMPLER(sampler_CoverBaseColorMap);
        TEXTURE2D(_CoverNormalMap);
        SAMPLER(sampler_CoverNormalMap);
        TEXTURE2D(_CoverMaskMap);
        SAMPLER(sampler_CoverMaskMap);
        TEXTURE2D(_DetailMap);
        SAMPLER(sampler_DetailMap);
        
        // Graph Includes
        // GraphIncludes: <None>
        
        // -- Property used by ScenePickingPass
        #ifdef SCENEPICKINGPASS
        float4 _SelectionID;
        #endif
        
        // -- Properties used by SceneSelectionPass
        #ifdef SCENESELECTIONPASS
        int _ObjectId;
        int _PassValue;
        #endif
        
        // Graph Functions
        
        void Unity_Combine_float(float R, float G, float B, float A, out float4 RGBA, out float3 RGB, out float2 RG)
        {
            RGBA = float4(R, G, B, A);
            RGB = float3(R, G, B);
            RG = float2(R, G);
        }
        
        void Unity_Divide_float(float A, float B, out float Out)
        {
            Out = A / B;
        }
        
        void Unity_Multiply_float4_float4(float4 A, float4 B, out float4 Out)
        {
        Out = A * B;
        }
        
        void Unity_Branch_float4(float Predicate, float4 True, float4 False, out float4 Out)
        {
            Out = Predicate ? True : False;
        }
        
        void Unity_TilingAndOffset_float(float2 UV, float2 Tiling, float2 Offset, out float2 Out)
        {
            Out = UV * Tiling + Offset;
        }
        
        void Unity_Branch_float2(float Predicate, float2 True, float2 False, out float2 Out)
        {
            Out = Predicate ? True : False;
        }
        
        struct Bindings_PlanarNM_c0f081da9c567704ea36e7dd38cedcf6_float
        {
        float3 AbsoluteWorldSpacePosition;
        half4 uv0;
        half4 uv3;
        };
        
        void SG_PlanarNM_c0f081da9c567704ea36e7dd38cedcf6_float(UnityTexture2D Texture2D_80A3D28F, float4 Vector4_2EBA7A3B, float Boolean_7ABB9909, UnitySamplerState _SamplerState, float Boolean_5ddfe6daabcc4715a44b5f34fc19becb, Bindings_PlanarNM_c0f081da9c567704ea36e7dd38cedcf6_float IN, out float4 XZ_2)
        {
        UnityTexture2D _Property_3e01b4d2fc68d48ba3acbba9d5881e59_Out_0_Texture2D = Texture2D_80A3D28F;
        float _Property_30834f691775a0898a45b1c868520436_Out_0_Boolean = Boolean_7ABB9909;
        float _Split_89ed63cb625cb3878c183d0b71c03400_R_1_Float = IN.AbsoluteWorldSpacePosition[0];
        float _Split_89ed63cb625cb3878c183d0b71c03400_G_2_Float = IN.AbsoluteWorldSpacePosition[1];
        float _Split_89ed63cb625cb3878c183d0b71c03400_B_3_Float = IN.AbsoluteWorldSpacePosition[2];
        float _Split_89ed63cb625cb3878c183d0b71c03400_A_4_Float = 0;
        float4 _Combine_cf2d04ff119ad88493f6460431765cbb_RGBA_4_Vector4;
        float3 _Combine_cf2d04ff119ad88493f6460431765cbb_RGB_5_Vector3;
        float2 _Combine_cf2d04ff119ad88493f6460431765cbb_RG_6_Vector2;
        Unity_Combine_float(_Split_89ed63cb625cb3878c183d0b71c03400_R_1_Float, _Split_89ed63cb625cb3878c183d0b71c03400_B_3_Float, float(0), float(0), _Combine_cf2d04ff119ad88493f6460431765cbb_RGBA_4_Vector4, _Combine_cf2d04ff119ad88493f6460431765cbb_RGB_5_Vector3, _Combine_cf2d04ff119ad88493f6460431765cbb_RG_6_Vector2);
        float4 _Property_8a66888ec47d0687ab1cb2f8abdc9da8_Out_0_Vector4 = Vector4_2EBA7A3B;
        float _Split_2f0f52f6ef8c0e81af0da6476402bc1f_R_1_Float = _Property_8a66888ec47d0687ab1cb2f8abdc9da8_Out_0_Vector4[0];
        float _Split_2f0f52f6ef8c0e81af0da6476402bc1f_G_2_Float = _Property_8a66888ec47d0687ab1cb2f8abdc9da8_Out_0_Vector4[1];
        float _Split_2f0f52f6ef8c0e81af0da6476402bc1f_B_3_Float = _Property_8a66888ec47d0687ab1cb2f8abdc9da8_Out_0_Vector4[2];
        float _Split_2f0f52f6ef8c0e81af0da6476402bc1f_A_4_Float = _Property_8a66888ec47d0687ab1cb2f8abdc9da8_Out_0_Vector4[3];
        float _Divide_e64179199923c58289b6aa94ea6c9178_Out_2_Float;
        Unity_Divide_float(float(1), _Split_2f0f52f6ef8c0e81af0da6476402bc1f_R_1_Float, _Divide_e64179199923c58289b6aa94ea6c9178_Out_2_Float);
        float4 _Multiply_14cec4902d0a00829e4555071a1b8ad1_Out_2_Vector4;
        Unity_Multiply_float4_float4(_Combine_cf2d04ff119ad88493f6460431765cbb_RGBA_4_Vector4, (_Divide_e64179199923c58289b6aa94ea6c9178_Out_2_Float.xxxx), _Multiply_14cec4902d0a00829e4555071a1b8ad1_Out_2_Vector4);
        float _Property_f17c7bf877e64b6abdd66b1fe9f5accc_Out_0_Boolean = Boolean_5ddfe6daabcc4715a44b5f34fc19becb;
        float4 _UV_029e8e8198564838b9389b902a09fb22_Out_0_Vector4 = IN.uv0;
        float4 _UV_7a6209af1506424fb75c81e87e42035a_Out_0_Vector4 = IN.uv3;
        float4 _Branch_fc37bb4bf641457cbbc6e290603056ff_Out_3_Vector4;
        Unity_Branch_float4(_Property_f17c7bf877e64b6abdd66b1fe9f5accc_Out_0_Boolean, _UV_029e8e8198564838b9389b902a09fb22_Out_0_Vector4, _UV_7a6209af1506424fb75c81e87e42035a_Out_0_Vector4, _Branch_fc37bb4bf641457cbbc6e290603056ff_Out_3_Vector4);
        float2 _Vector2_16c15d3bbdd14b85bd48e3a6cb318af7_Out_0_Vector2 = float2(_Split_2f0f52f6ef8c0e81af0da6476402bc1f_R_1_Float, _Split_2f0f52f6ef8c0e81af0da6476402bc1f_G_2_Float);
        float2 _Vector2_f8d75f54e7705083bbec539a60185577_Out_0_Vector2 = float2(_Split_2f0f52f6ef8c0e81af0da6476402bc1f_B_3_Float, _Split_2f0f52f6ef8c0e81af0da6476402bc1f_A_4_Float);
        float2 _TilingAndOffset_d91e2d25acd34686b562b7fe7e9d1d27_Out_3_Vector2;
        Unity_TilingAndOffset_float((_Branch_fc37bb4bf641457cbbc6e290603056ff_Out_3_Vector4.xy), _Vector2_16c15d3bbdd14b85bd48e3a6cb318af7_Out_0_Vector2, _Vector2_f8d75f54e7705083bbec539a60185577_Out_0_Vector2, _TilingAndOffset_d91e2d25acd34686b562b7fe7e9d1d27_Out_3_Vector2);
        float2 _Branch_8e5a4e8f4d52fc8aadd1f46485afc933_Out_3_Vector2;
        Unity_Branch_float2(_Property_30834f691775a0898a45b1c868520436_Out_0_Boolean, (_Multiply_14cec4902d0a00829e4555071a1b8ad1_Out_2_Vector4.xy), _TilingAndOffset_d91e2d25acd34686b562b7fe7e9d1d27_Out_3_Vector2, _Branch_8e5a4e8f4d52fc8aadd1f46485afc933_Out_3_Vector2);
        UnitySamplerState _Property_e8746b9475c94530ba35ba8019ad2ae0_Out_0_SamplerState = _SamplerState;
        float4 _SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_RGBA_0_Vector4 = SAMPLE_TEXTURE2D(_Property_3e01b4d2fc68d48ba3acbba9d5881e59_Out_0_Texture2D.tex, _Property_e8746b9475c94530ba35ba8019ad2ae0_Out_0_SamplerState.samplerstate, _Property_3e01b4d2fc68d48ba3acbba9d5881e59_Out_0_Texture2D.GetTransformedUV(_Branch_8e5a4e8f4d52fc8aadd1f46485afc933_Out_3_Vector2) );
        float _SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_R_4_Float = _SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_RGBA_0_Vector4.r;
        float _SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_G_5_Float = _SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_RGBA_0_Vector4.g;
        float _SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_B_6_Float = _SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_RGBA_0_Vector4.b;
        float _SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_A_7_Float = _SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_RGBA_0_Vector4.a;
        XZ_2 = _SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_RGBA_0_Vector4;
        }
        
        void Unity_ColorspaceConversion_Linear_RGB_float(float3 In, out float3 Out)
        {
            float3 sRGBLo = In * 12.92;
            float3 sRGBHi = (pow(max(abs(In), 1.192092896e-07), float3(1.0 / 2.4, 1.0 / 2.4, 1.0 / 2.4)) * 1.055) - 0.055;
            Out = float3(In <= 0.0031308) ? sRGBLo : sRGBHi;
        }
        
        void Unity_Blend_Overlay_float3(float3 Base, float3 Blend, out float3 Out, float Opacity)
        {
            float3 result1 = 1.0 - 2.0 * (1.0 - Base) * (1.0 - Blend);
            float3 result2 = 2.0 * Base * Blend;
            float3 zeroOrOne = step(Base, 0.5);
            Out = result2 * zeroOrOne + (1 - zeroOrOne) * result1;
            Out = lerp(Base, Out, Opacity);
        }
        
        void Unity_ColorspaceConversion_RGB_Linear_float(float3 In, out float3 Out)
        {
            float3 linearRGBLo = In / 12.92;
            float3 linearRGBHi = pow(max(abs((In + 0.055) / 1.055), 1.192092896e-07), float3(2.4, 2.4, 2.4));
            Out = float3(In <= 0.04045) ? linearRGBLo : linearRGBHi;
        }
        
        void Unity_Clamp_float3(float3 In, float3 Min, float3 Max, out float3 Out)
        {
            Out = clamp(In, Min, Max);
        }
        
        void Unity_Add_float2(float2 A, float2 B, out float2 Out)
        {
            Out = A + B;
        }
        
        void Unity_Remap_float(float In, float2 InMinMax, float2 OutMinMax, out float Out)
        {
            Out = OutMinMax.x + (In - InMinMax.x) * (OutMinMax.y - OutMinMax.x) / (InMinMax.y - InMinMax.x);
        }
        
        void Unity_Clamp_float(float In, float Min, float Max, out float Out)
        {
            Out = clamp(In, Min, Max);
        }
        
        void Unity_Multiply_float2_float2(float2 A, float2 B, out float2 Out)
        {
            Out = A * B;
        }
        
        void Unity_DotProduct_float2(float2 A, float2 B, out float Out)
        {
            Out = dot(A, B);
        }
        
        void Unity_Saturate_float(float In, out float Out)
        {
            Out = saturate(In);
        }
        
        void Unity_OneMinus_float(float In, out float Out)
        {
            Out = 1 - In;
        }
        
        void Unity_SquareRoot_float(float In, out float Out)
        {
            Out = sqrt(In);
        }
        
        void Unity_Sign_float3(float3 In, out float3 Out)
        {
            Out = sign(In);
        }
        
        void Unity_Multiply_float_float(float A, float B, out float Out)
        {
        Out = A * B;
        }
        
        void Unity_Normalize_float3(float3 In, out float3 Out)
        {
            Out = normalize(In);
        }
        
        void Unity_Branch_float3(float Predicate, float3 True, float3 False, out float3 Out)
        {
            Out = Predicate ? True : False;
        }
        
        struct Bindings_PlanarNMn_1b93a87456f9d4c419321d0cd92bd6c8_float
        {
        float3 WorldSpaceNormal;
        float3 WorldSpaceTangent;
        float3 WorldSpaceBiTangent;
        float3 AbsoluteWorldSpacePosition;
        half4 uv0;
        half4 uv3;
        };
        
        void SG_PlanarNMn_1b93a87456f9d4c419321d0cd92bd6c8_float(UnityTexture2D Texture2D_80A3D28F, float4 Vector4_82674548, float Boolean_9FF42DF6, UnitySamplerState _SamplerState, float Boolean_5ddfe6daabcc4715a44b5f34fc19becb, Bindings_PlanarNMn_1b93a87456f9d4c419321d0cd92bd6c8_float IN, out float4 XZ_2)
        {
        float _Property_1ef12cf3201a938993fe6a7951b0e754_Out_0_Boolean = Boolean_9FF42DF6;
        UnityTexture2D _Property_3e01b4d2fc68d48ba3acbba9d5881e59_Out_0_Texture2D = Texture2D_80A3D28F;
        float _Split_89ed63cb625cb3878c183d0b71c03400_R_1_Float = IN.AbsoluteWorldSpacePosition[0];
        float _Split_89ed63cb625cb3878c183d0b71c03400_G_2_Float = IN.AbsoluteWorldSpacePosition[1];
        float _Split_89ed63cb625cb3878c183d0b71c03400_B_3_Float = IN.AbsoluteWorldSpacePosition[2];
        float _Split_89ed63cb625cb3878c183d0b71c03400_A_4_Float = 0;
        float4 _Combine_cf2d04ff119ad88493f6460431765cbb_RGBA_4_Vector4;
        float3 _Combine_cf2d04ff119ad88493f6460431765cbb_RGB_5_Vector3;
        float2 _Combine_cf2d04ff119ad88493f6460431765cbb_RG_6_Vector2;
        Unity_Combine_float(_Split_89ed63cb625cb3878c183d0b71c03400_R_1_Float, _Split_89ed63cb625cb3878c183d0b71c03400_B_3_Float, float(0), float(0), _Combine_cf2d04ff119ad88493f6460431765cbb_RGBA_4_Vector4, _Combine_cf2d04ff119ad88493f6460431765cbb_RGB_5_Vector3, _Combine_cf2d04ff119ad88493f6460431765cbb_RG_6_Vector2);
        float4 _Property_3fa1d6f912feb481ba60f2e55e62e746_Out_0_Vector4 = Vector4_82674548;
        float _Split_a2e12fa5931da084b2949343a539dfd8_R_1_Float = _Property_3fa1d6f912feb481ba60f2e55e62e746_Out_0_Vector4[0];
        float _Split_a2e12fa5931da084b2949343a539dfd8_G_2_Float = _Property_3fa1d6f912feb481ba60f2e55e62e746_Out_0_Vector4[1];
        float _Split_a2e12fa5931da084b2949343a539dfd8_B_3_Float = _Property_3fa1d6f912feb481ba60f2e55e62e746_Out_0_Vector4[2];
        float _Split_a2e12fa5931da084b2949343a539dfd8_A_4_Float = _Property_3fa1d6f912feb481ba60f2e55e62e746_Out_0_Vector4[3];
        float _Divide_c36b770dfaa0bb8f85ab27da5fd794f0_Out_2_Float;
        Unity_Divide_float(float(1), _Split_a2e12fa5931da084b2949343a539dfd8_R_1_Float, _Divide_c36b770dfaa0bb8f85ab27da5fd794f0_Out_2_Float);
        float4 _Multiply_14cec4902d0a00829e4555071a1b8ad1_Out_2_Vector4;
        Unity_Multiply_float4_float4(_Combine_cf2d04ff119ad88493f6460431765cbb_RGBA_4_Vector4, (_Divide_c36b770dfaa0bb8f85ab27da5fd794f0_Out_2_Float.xxxx), _Multiply_14cec4902d0a00829e4555071a1b8ad1_Out_2_Vector4);
        float _Property_058f4fba88c3437288219f1929444bf2_Out_0_Boolean = Boolean_5ddfe6daabcc4715a44b5f34fc19becb;
        float4 _UV_43d85b3291324c848dfbeec6adac2a71_Out_0_Vector4 = IN.uv0;
        float4 _UV_36881dcaab9040168fc5215dcd00f352_Out_0_Vector4 = IN.uv3;
        float4 _Branch_8054d58a73be4ce1b22d48a84389ae07_Out_3_Vector4;
        Unity_Branch_float4(_Property_058f4fba88c3437288219f1929444bf2_Out_0_Boolean, _UV_43d85b3291324c848dfbeec6adac2a71_Out_0_Vector4, _UV_36881dcaab9040168fc5215dcd00f352_Out_0_Vector4, _Branch_8054d58a73be4ce1b22d48a84389ae07_Out_3_Vector4);
        float2 _Vector2_6845d21872714d889783b0cb707df3e9_Out_0_Vector2 = float2(_Split_a2e12fa5931da084b2949343a539dfd8_R_1_Float, _Split_a2e12fa5931da084b2949343a539dfd8_G_2_Float);
        float2 _Vector2_e2e2263627c6098e96a5b5d29350ad03_Out_0_Vector2 = float2(_Split_a2e12fa5931da084b2949343a539dfd8_B_3_Float, _Split_a2e12fa5931da084b2949343a539dfd8_A_4_Float);
        float2 _TilingAndOffset_17582d056c0b8a8dab1017d37497fe59_Out_3_Vector2;
        Unity_TilingAndOffset_float((_Branch_8054d58a73be4ce1b22d48a84389ae07_Out_3_Vector4.xy), _Vector2_6845d21872714d889783b0cb707df3e9_Out_0_Vector2, _Vector2_e2e2263627c6098e96a5b5d29350ad03_Out_0_Vector2, _TilingAndOffset_17582d056c0b8a8dab1017d37497fe59_Out_3_Vector2);
        float2 _Branch_1e152f3aac57448f8518bf2852c000c3_Out_3_Vector2;
        Unity_Branch_float2(_Property_1ef12cf3201a938993fe6a7951b0e754_Out_0_Boolean, (_Multiply_14cec4902d0a00829e4555071a1b8ad1_Out_2_Vector4.xy), _TilingAndOffset_17582d056c0b8a8dab1017d37497fe59_Out_3_Vector2, _Branch_1e152f3aac57448f8518bf2852c000c3_Out_3_Vector2);
        UnitySamplerState _Property_69f1ed7efd1b494e91f626b88ab2363c_Out_0_SamplerState = _SamplerState;
        float4 _SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_RGBA_0_Vector4 = SAMPLE_TEXTURE2D(_Property_3e01b4d2fc68d48ba3acbba9d5881e59_Out_0_Texture2D.tex, _Property_69f1ed7efd1b494e91f626b88ab2363c_Out_0_SamplerState.samplerstate, _Property_3e01b4d2fc68d48ba3acbba9d5881e59_Out_0_Texture2D.GetTransformedUV(_Branch_1e152f3aac57448f8518bf2852c000c3_Out_3_Vector2) );
        _SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_RGBA_0_Vector4.rgb = UnpackNormal(_SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_RGBA_0_Vector4);
        float _SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_R_4_Float = _SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_RGBA_0_Vector4.r;
        float _SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_G_5_Float = _SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_RGBA_0_Vector4.g;
        float _SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_B_6_Float = _SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_RGBA_0_Vector4.b;
        float _SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_A_7_Float = _SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_RGBA_0_Vector4.a;
        float2 _Vector2_ad6bd100e273d78fa409a30a77bfa2cc_Out_0_Vector2 = float2(_SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_R_4_Float, _SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_G_5_Float);
        float3 _Sign_3a6ebf59931cf08cb0482e0144ddac24_Out_1_Vector3;
        Unity_Sign_float3(IN.WorldSpaceNormal, _Sign_3a6ebf59931cf08cb0482e0144ddac24_Out_1_Vector3);
        float _Split_6299d4ddcc4c74828aea40a46fdb896e_R_1_Float = _Sign_3a6ebf59931cf08cb0482e0144ddac24_Out_1_Vector3[0];
        float _Split_6299d4ddcc4c74828aea40a46fdb896e_G_2_Float = _Sign_3a6ebf59931cf08cb0482e0144ddac24_Out_1_Vector3[1];
        float _Split_6299d4ddcc4c74828aea40a46fdb896e_B_3_Float = _Sign_3a6ebf59931cf08cb0482e0144ddac24_Out_1_Vector3[2];
        float _Split_6299d4ddcc4c74828aea40a46fdb896e_A_4_Float = 0;
        float2 _Vector2_b76cb1842101e58b9e636d49b075c612_Out_0_Vector2 = float2(_Split_6299d4ddcc4c74828aea40a46fdb896e_G_2_Float, float(1));
        float2 _Multiply_31e8db88ee20c985a9850d1a58f3282b_Out_2_Vector2;
        Unity_Multiply_float2_float2(_Vector2_ad6bd100e273d78fa409a30a77bfa2cc_Out_0_Vector2, _Vector2_b76cb1842101e58b9e636d49b075c612_Out_0_Vector2, _Multiply_31e8db88ee20c985a9850d1a58f3282b_Out_2_Vector2);
        float _Split_5ed44bf2eca0868f81eb18100f49d1fa_R_1_Float = IN.WorldSpaceNormal[0];
        float _Split_5ed44bf2eca0868f81eb18100f49d1fa_G_2_Float = IN.WorldSpaceNormal[1];
        float _Split_5ed44bf2eca0868f81eb18100f49d1fa_B_3_Float = IN.WorldSpaceNormal[2];
        float _Split_5ed44bf2eca0868f81eb18100f49d1fa_A_4_Float = 0;
        float2 _Vector2_70e5837843f28b8b9d64cada3697bd5a_Out_0_Vector2 = float2(_Split_5ed44bf2eca0868f81eb18100f49d1fa_R_1_Float, _Split_5ed44bf2eca0868f81eb18100f49d1fa_B_3_Float);
        float2 _Add_1145b2f896593d80aa864a34e6702562_Out_2_Vector2;
        Unity_Add_float2(_Multiply_31e8db88ee20c985a9850d1a58f3282b_Out_2_Vector2, _Vector2_70e5837843f28b8b9d64cada3697bd5a_Out_0_Vector2, _Add_1145b2f896593d80aa864a34e6702562_Out_2_Vector2);
        float _Split_2bc77ca2d17bd78cb2383770ce50b179_R_1_Float = _Add_1145b2f896593d80aa864a34e6702562_Out_2_Vector2[0];
        float _Split_2bc77ca2d17bd78cb2383770ce50b179_G_2_Float = _Add_1145b2f896593d80aa864a34e6702562_Out_2_Vector2[1];
        float _Split_2bc77ca2d17bd78cb2383770ce50b179_B_3_Float = 0;
        float _Split_2bc77ca2d17bd78cb2383770ce50b179_A_4_Float = 0;
        float _Multiply_ab12aea87465a78eaf7fc66c2598d266_Out_2_Float;
        Unity_Multiply_float_float(_SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_B_6_Float, _Split_5ed44bf2eca0868f81eb18100f49d1fa_G_2_Float, _Multiply_ab12aea87465a78eaf7fc66c2598d266_Out_2_Float);
        float3 _Vector3_433840b555db308b97e9b14b6a957195_Out_0_Vector3 = float3(_Split_2bc77ca2d17bd78cb2383770ce50b179_R_1_Float, _Multiply_ab12aea87465a78eaf7fc66c2598d266_Out_2_Float, _Split_2bc77ca2d17bd78cb2383770ce50b179_G_2_Float);
        float3 _Transform_c7914cc45a011c89b3f53c55afb51673_Out_1_Vector3;
        {
        float3x3 tangentTransform = float3x3(IN.WorldSpaceTangent, IN.WorldSpaceBiTangent, IN.WorldSpaceNormal);
        _Transform_c7914cc45a011c89b3f53c55afb51673_Out_1_Vector3 = TransformWorldToTangentDir(_Vector3_433840b555db308b97e9b14b6a957195_Out_0_Vector3.xyz, tangentTransform, true);
        }
        float3 _Clamp_3837949a36b5428a82af01e7bcd29952_Out_3_Vector3;
        Unity_Clamp_float3(_Transform_c7914cc45a011c89b3f53c55afb51673_Out_1_Vector3, float3(-1, -1, -1), float3(1, 1, 1), _Clamp_3837949a36b5428a82af01e7bcd29952_Out_3_Vector3);
        float3 _Normalize_09bf8a2bd0a4d38e8b97d5c674f79b44_Out_1_Vector3;
        Unity_Normalize_float3(_Clamp_3837949a36b5428a82af01e7bcd29952_Out_3_Vector3, _Normalize_09bf8a2bd0a4d38e8b97d5c674f79b44_Out_1_Vector3);
        float3 _Branch_9eadf909a90f2f80880f8c56ecc2a91f_Out_3_Vector3;
        Unity_Branch_float3(_Property_1ef12cf3201a938993fe6a7951b0e754_Out_0_Boolean, _Normalize_09bf8a2bd0a4d38e8b97d5c674f79b44_Out_1_Vector3, (_SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_RGBA_0_Vector4.xyz), _Branch_9eadf909a90f2f80880f8c56ecc2a91f_Out_3_Vector3);
        XZ_2 = (float4(_Branch_9eadf909a90f2f80880f8c56ecc2a91f_Out_3_Vector3, 1.0));
        }
        
        void Unity_NormalStrength_float(float3 In, float Strength, out float3 Out)
        {
            Out = float3(In.rg * Strength, lerp(1, In.b, saturate(Strength)));
        }
        
        void Unity_NormalBlend_Reoriented_float(float3 A, float3 B, out float3 Out)
        {
            float3 t = A.xyz + float3(0.0, 0.0, 1.0);
            float3 u = B.xyz * float3(-1.0, -1.0, 1.0);
            Out = (t / t.z) * dot(t, u) - u;
        }
        
        void Unity_Subtract_float(float A, float B, out float Out)
        {
            Out = A - B;
        }
        
        void Unity_Absolute_float(float In, out float Out)
        {
            Out = abs(In);
        }
        
        void Unity_Power_float(float A, float B, out float Out)
        {
            Out = pow(A, B);
        }
        
        void Unity_Add_float(float A, float B, out float Out)
        {
            Out = A + B;
        }
        
        void Unity_Lerp_float3(float3 A, float3 B, float3 T, out float3 Out)
        {
            Out = lerp(A, B, T);
        }
        
        void Unity_Comparison_Greater_float(float A, float B, out float Out)
        {
            Out = A > B ? 1 : 0;
        }
        
        void Unity_Branch_float(float Predicate, float True, float False, out float Out)
        {
            Out = Predicate ? True : False;
        }
        
        struct Bindings_UniversalHeighblend_3b5c31b864970d04197cd420b6c4b0fa_float
        {
        };
        
        void SG_UniversalHeighblend_3b5c31b864970d04197cd420b6c4b0fa_float(float _Vertex_Color, float _Blend_Hardness, float _Use_Layer_1_Height_T, float _Layer_1_Height, float2 _Layer_1_Before_Remap, float _Use_Layer_2_Height_T, float _Layer_2_Height, float2 _Layer_2_Before_Remap, float _Angle_Blend, Bindings_UniversalHeighblend_3b5c31b864970d04197cd420b6c4b0fa_float IN, out float Heightmap_1)
        {
        float _Property_b3ca7054ef0043de85912fc45d997ea2_Out_0_Float = _Vertex_Color;
        float _Clamp_852774a2be524975babf4eeb54af6d64_Out_3_Float;
        Unity_Clamp_float(_Property_b3ca7054ef0043de85912fc45d997ea2_Out_0_Float, float(0), float(1), _Clamp_852774a2be524975babf4eeb54af6d64_Out_3_Float);
        float _OneMinus_85e3550f37814cd3ab5ea5dde7f63a73_Out_1_Float;
        Unity_OneMinus_float(_Clamp_852774a2be524975babf4eeb54af6d64_Out_3_Float, _OneMinus_85e3550f37814cd3ab5ea5dde7f63a73_Out_1_Float);
        float _Comparison_5be6aeaa514b4921b5eb68269b58b028_Out_2_Boolean;
        Unity_Comparison_Greater_float(_OneMinus_85e3550f37814cd3ab5ea5dde7f63a73_Out_1_Float, float(0.99), _Comparison_5be6aeaa514b4921b5eb68269b58b028_Out_2_Boolean);
        float _Property_cfe724908035497c918d6d3f8dafe439_Out_0_Boolean = _Use_Layer_1_Height_T;
        float _Property_9634fd87d3374fdaa60181281a01f9b5_Out_0_Float = _Layer_1_Height;
        float2 _Property_e748f6c127e0479a9a01040378a4129b_Out_0_Vector2 = _Layer_1_Before_Remap;
        float _Split_cde172ab161d44cb81ea7874aec65560_R_1_Float = _Property_e748f6c127e0479a9a01040378a4129b_Out_0_Vector2[0];
        float _Split_cde172ab161d44cb81ea7874aec65560_G_2_Float = _Property_e748f6c127e0479a9a01040378a4129b_Out_0_Vector2[1];
        float _Split_cde172ab161d44cb81ea7874aec65560_B_3_Float = 0;
        float _Split_cde172ab161d44cb81ea7874aec65560_A_4_Float = 0;
        float _Subtract_e1e98a956721410caddfb467ae0eca8b_Out_2_Float;
        Unity_Subtract_float(_Split_cde172ab161d44cb81ea7874aec65560_R_1_Float, _Split_cde172ab161d44cb81ea7874aec65560_G_2_Float, _Subtract_e1e98a956721410caddfb467ae0eca8b_Out_2_Float);
        float _Clamp_ac4097026e6248dbb7a95fe910cc776e_Out_3_Float;
        Unity_Clamp_float(_OneMinus_85e3550f37814cd3ab5ea5dde7f63a73_Out_1_Float, float(0), float(1), _Clamp_ac4097026e6248dbb7a95fe910cc776e_Out_3_Float);
        float _Multiply_41691d316de74fef8a4ab5f63ed5474e_Out_2_Float;
        Unity_Multiply_float_float(_Subtract_e1e98a956721410caddfb467ae0eca8b_Out_2_Float, _Clamp_ac4097026e6248dbb7a95fe910cc776e_Out_3_Float, _Multiply_41691d316de74fef8a4ab5f63ed5474e_Out_2_Float);
        float2 _Add_48d37f8b8a464788860db14f0da8a66e_Out_2_Vector2;
        Unity_Add_float2(_Property_e748f6c127e0479a9a01040378a4129b_Out_0_Vector2, (_Multiply_41691d316de74fef8a4ab5f63ed5474e_Out_2_Float.xx), _Add_48d37f8b8a464788860db14f0da8a66e_Out_2_Vector2);
        float _Remap_21f3372608424df090026adc73778a39_Out_3_Float;
        Unity_Remap_float(_Property_9634fd87d3374fdaa60181281a01f9b5_Out_0_Float, float2 (0, 1), _Add_48d37f8b8a464788860db14f0da8a66e_Out_2_Vector2, _Remap_21f3372608424df090026adc73778a39_Out_3_Float);
        float _Clamp_8ea719b357b44537b42b2d05c22046f6_Out_3_Float;
        Unity_Clamp_float(_Remap_21f3372608424df090026adc73778a39_Out_3_Float, float(0), float(1), _Clamp_8ea719b357b44537b42b2d05c22046f6_Out_3_Float);
        float _Property_457e05a76c034ada998b3ff30a7781c3_Out_0_Boolean = _Use_Layer_2_Height_T;
        float _Property_9dfafa1ca8c94866a52535f412aff89a_Out_0_Float = _Angle_Blend;
        float _Property_b0e4a5720c374e2eb6f203a1bd075243_Out_0_Float = _Layer_2_Height;
        float _Multiply_00b31c7f720343caa4ded6df80a61899_Out_2_Float;
        Unity_Multiply_float_float(_Property_9dfafa1ca8c94866a52535f412aff89a_Out_0_Float, _Property_b0e4a5720c374e2eb6f203a1bd075243_Out_0_Float, _Multiply_00b31c7f720343caa4ded6df80a61899_Out_2_Float);
        float2 _Property_555a7734da754b989d8f80ef0bc86bea_Out_0_Vector2 = _Layer_2_Before_Remap;
        float _Split_bad56a0d03154ccc8cbfb53ea0e381d4_R_1_Float = _Property_555a7734da754b989d8f80ef0bc86bea_Out_0_Vector2[0];
        float _Split_bad56a0d03154ccc8cbfb53ea0e381d4_G_2_Float = _Property_555a7734da754b989d8f80ef0bc86bea_Out_0_Vector2[1];
        float _Split_bad56a0d03154ccc8cbfb53ea0e381d4_B_3_Float = 0;
        float _Split_bad56a0d03154ccc8cbfb53ea0e381d4_A_4_Float = 0;
        float _Subtract_2a7908018c384526a00494520503a83d_Out_2_Float;
        Unity_Subtract_float(_Split_bad56a0d03154ccc8cbfb53ea0e381d4_R_1_Float, _Split_bad56a0d03154ccc8cbfb53ea0e381d4_G_2_Float, _Subtract_2a7908018c384526a00494520503a83d_Out_2_Float);
        float _Multiply_417d72157b5f4930aed43775db746964_Out_2_Float;
        Unity_Multiply_float_float(_Subtract_2a7908018c384526a00494520503a83d_Out_2_Float, _Clamp_ac4097026e6248dbb7a95fe910cc776e_Out_3_Float, _Multiply_417d72157b5f4930aed43775db746964_Out_2_Float);
        float2 _Add_3d7e111e917c44e8a6800ce926fac67d_Out_2_Vector2;
        Unity_Add_float2((_Multiply_417d72157b5f4930aed43775db746964_Out_2_Float.xx), _Property_555a7734da754b989d8f80ef0bc86bea_Out_0_Vector2, _Add_3d7e111e917c44e8a6800ce926fac67d_Out_2_Vector2);
        float _Remap_931f83440e6c4c1588456788f84cbd9a_Out_3_Float;
        Unity_Remap_float(_Multiply_00b31c7f720343caa4ded6df80a61899_Out_2_Float, float2 (0, 1), _Add_3d7e111e917c44e8a6800ce926fac67d_Out_2_Vector2, _Remap_931f83440e6c4c1588456788f84cbd9a_Out_3_Float);
        float _Branch_a840aba5bca34588a2665f9794c96c38_Out_3_Float;
        Unity_Branch_float(_Property_457e05a76c034ada998b3ff30a7781c3_Out_0_Boolean, _Remap_931f83440e6c4c1588456788f84cbd9a_Out_3_Float, _Property_9dfafa1ca8c94866a52535f412aff89a_Out_0_Float, _Branch_a840aba5bca34588a2665f9794c96c38_Out_3_Float);
        float _Clamp_b1fe959daf444bf99c57756b8be77768_Out_3_Float;
        Unity_Clamp_float(_Branch_a840aba5bca34588a2665f9794c96c38_Out_3_Float, float(0), float(1), _Clamp_b1fe959daf444bf99c57756b8be77768_Out_3_Float);
        float _Multiply_c045ae9912ac409b9734c687968d47f6_Out_2_Float;
        Unity_Multiply_float_float(_Clamp_8ea719b357b44537b42b2d05c22046f6_Out_3_Float, _Clamp_b1fe959daf444bf99c57756b8be77768_Out_3_Float, _Multiply_c045ae9912ac409b9734c687968d47f6_Out_2_Float);
        float _Branch_5198cfc0a080466e93cf89aea61886e6_Out_3_Float;
        Unity_Branch_float(_Property_cfe724908035497c918d6d3f8dafe439_Out_0_Boolean, _Multiply_c045ae9912ac409b9734c687968d47f6_Out_2_Float, _Clamp_b1fe959daf444bf99c57756b8be77768_Out_3_Float, _Branch_5198cfc0a080466e93cf89aea61886e6_Out_3_Float);
        float _Saturate_ceafe30b0bae4f45a2f2ec500925b553_Out_1_Float;
        Unity_Saturate_float(_Branch_5198cfc0a080466e93cf89aea61886e6_Out_3_Float, _Saturate_ceafe30b0bae4f45a2f2ec500925b553_Out_1_Float);
        float _Absolute_274083e3f9f645bfb86074d91f3b7c62_Out_1_Float;
        Unity_Absolute_float(_Saturate_ceafe30b0bae4f45a2f2ec500925b553_Out_1_Float, _Absolute_274083e3f9f645bfb86074d91f3b7c62_Out_1_Float);
        float _Property_c68e0b8a84a549a582d4723036344b0e_Out_0_Float = _Blend_Hardness;
        float _Power_c9d62a3092174d9cb5674d87bcb7b5c5_Out_2_Float;
        Unity_Power_float(_Absolute_274083e3f9f645bfb86074d91f3b7c62_Out_1_Float, _Property_c68e0b8a84a549a582d4723036344b0e_Out_0_Float, _Power_c9d62a3092174d9cb5674d87bcb7b5c5_Out_2_Float);
        float _Branch_2425ee869bde4930bb8f36a5273bdc33_Out_3_Float;
        Unity_Branch_float(_Comparison_5be6aeaa514b4921b5eb68269b58b028_Out_2_Boolean, float(0), _Power_c9d62a3092174d9cb5674d87bcb7b5c5_Out_2_Float, _Branch_2425ee869bde4930bb8f36a5273bdc33_Out_3_Float);
        float _Clamp_9a5c5cfe52824e248ea0a8e38c593d84_Out_3_Float;
        Unity_Clamp_float(_Branch_2425ee869bde4930bb8f36a5273bdc33_Out_3_Float, float(0), float(1), _Clamp_9a5c5cfe52824e248ea0a8e38c593d84_Out_3_Float);
        Heightmap_1 = _Clamp_9a5c5cfe52824e248ea0a8e38c593d84_Out_3_Float;
        }
        
        void Unity_Lerp_float4(float4 A, float4 B, float4 T, out float4 Out)
        {
            Out = lerp(A, B, T);
        }
        
        void Unity_Clamp_float4(float4 In, float4 Min, float4 Max, out float4 Out)
        {
            Out = clamp(In, Min, Max);
        }
        
        void Unity_Lerp_float(float A, float B, float T, out float Out)
        {
            Out = lerp(A, B, T);
        }
        
        // unity-custom-func-begin
        void Time_float(out float Out){
            Out = _Time.y;
        }
        // unity-custom-func-end
        
        void Unity_Minimum_float(float A, float B, out float Out)
        {
            Out = min(A, B);
        };
        
        void Unity_DotProduct_float3(float3 A, float3 B, out float Out)
        {
            Out = dot(A, B);
        }
        
        void Unity_Add_float4(float4 A, float4 B, out float4 Out)
        {
            Out = A + B;
        }
        
        void Unity_Sign_float(float In, out float Out)
        {
            Out = sign(In);
        }
        
        void Unity_Ceiling_float(float In, out float Out)
        {
            Out = ceil(In);
        }
        
        struct Bindings_BlendOverlayDetailSmoothness_06e12138dc89c0040b45a57abe520a1a_float
        {
        };
        
        void SG_BlendOverlayDetailSmoothness_06e12138dc89c0040b45a57abe520a1a_float(float Vector1_32317166, float Vector1_FBE622A2, float Vector1_8C15C351, Bindings_BlendOverlayDetailSmoothness_06e12138dc89c0040b45a57abe520a1a_float IN, out float SmoothnessOverlay_1)
        {
        float _Property_728cc50521e9e988ac9cbff4872d5139_Out_0_Float = Vector1_32317166;
        float _Property_a00e29241d12f983b30177515b367ec9_Out_0_Float = Vector1_FBE622A2;
        float _Sign_343a45ede7349283a681c6bd9998fd8e_Out_1_Float;
        Unity_Sign_float(_Property_a00e29241d12f983b30177515b367ec9_Out_0_Float, _Sign_343a45ede7349283a681c6bd9998fd8e_Out_1_Float);
        float _Add_681019b8f5d3d68bb482d419c9fc61a9_Out_2_Float;
        Unity_Add_float(_Sign_343a45ede7349283a681c6bd9998fd8e_Out_1_Float, float(1), _Add_681019b8f5d3d68bb482d419c9fc61a9_Out_2_Float);
        float _Multiply_e8f4cb722712a880ac0db6c7461427f7_Out_2_Float;
        Unity_Multiply_float_float(_Add_681019b8f5d3d68bb482d419c9fc61a9_Out_2_Float, 0.5, _Multiply_e8f4cb722712a880ac0db6c7461427f7_Out_2_Float);
        float _Ceiling_95ad15988aa9b98184875fa754feae01_Out_1_Float;
        Unity_Ceiling_float(_Multiply_e8f4cb722712a880ac0db6c7461427f7_Out_2_Float, _Ceiling_95ad15988aa9b98184875fa754feae01_Out_1_Float);
        float _Property_2db1c747a05ee284a8b00076062f91a4_Out_0_Float = Vector1_8C15C351;
        float _Lerp_b3cdb01fc3c5b988ac9b184943bf7c01_Out_3_Float;
        Unity_Lerp_float(_Property_728cc50521e9e988ac9cbff4872d5139_Out_0_Float, _Ceiling_95ad15988aa9b98184875fa754feae01_Out_1_Float, _Property_2db1c747a05ee284a8b00076062f91a4_Out_0_Float, _Lerp_b3cdb01fc3c5b988ac9b184943bf7c01_Out_3_Float);
        SmoothnessOverlay_1 = _Lerp_b3cdb01fc3c5b988ac9b184943bf7c01_Out_3_Float;
        }
        
        // Custom interpolators pre vertex
        /* WARNING: $splice Could not find named fragment 'CustomInterpolatorPreVertex' */
        
        // Graph Vertex
        struct VertexDescription
        {
            float3 Position;
            float3 Normal;
            float3 Tangent;
        };
        
        VertexDescription VertexDescriptionFunction(VertexDescriptionInputs IN)
        {
            VertexDescription description = (VertexDescription)0;
            description.Position = IN.ObjectSpacePosition;
            description.Normal = IN.ObjectSpaceNormal;
            description.Tangent = IN.ObjectSpaceTangent;
            return description;
        }
        
        // Custom interpolators, pre surface
        #ifdef FEATURES_GRAPH_VERTEX
        Varyings CustomInterpolatorPassThroughFunc(inout Varyings output, VertexDescription input)
        {
        return output;
        }
        #define CUSTOMINTERPOLATOR_VARYPASSTHROUGH_FUNC
        #endif
        
        // Graph Pixel
        struct SurfaceDescription
        {
            float3 BaseColor;
            float3 NormalTS;
            float3 Emission;
            float Metallic;
            float3 Specular;
            float Smoothness;
            float Occlusion;
            float Alpha;
            float AlphaClipThreshold;
        };
        
        SurfaceDescription SurfaceDescriptionFunction(SurfaceDescriptionInputs IN)
        {
            SurfaceDescription surface = (SurfaceDescription)0;
            UnityTexture2D _Property_821e07b38fd0a08d85c4dd6e5b6bbac9_Out_0_Texture2D = UnityBuildTexture2DStructNoScale(_BaseColorMap);
            float4 _Property_8ec0d512145619859d288abab740e3bf_Out_0_Vector4 = _BaseTilingOffset;
            float _Property_122c0f9ef0a1c4818a140c75e512abe4_Out_0_Boolean = _BaseUsePlanarUV;
            Bindings_PlanarNM_c0f081da9c567704ea36e7dd38cedcf6_float _PlanarNM_cb7ded32e6af3382bbe06b62977afab6;
            _PlanarNM_cb7ded32e6af3382bbe06b62977afab6.AbsoluteWorldSpacePosition = IN.AbsoluteWorldSpacePosition;
            _PlanarNM_cb7ded32e6af3382bbe06b62977afab6.uv0 = IN.uv0;
            _PlanarNM_cb7ded32e6af3382bbe06b62977afab6.uv3 = IN.uv3;
            float4 _PlanarNM_cb7ded32e6af3382bbe06b62977afab6_XZ_2_Vector4;
            SG_PlanarNM_c0f081da9c567704ea36e7dd38cedcf6_float(_Property_821e07b38fd0a08d85c4dd6e5b6bbac9_Out_0_Texture2D, _Property_8ec0d512145619859d288abab740e3bf_Out_0_Vector4, _Property_122c0f9ef0a1c4818a140c75e512abe4_Out_0_Boolean, UnityBuildSamplerStateStruct(SamplerState_Linear_Repeat_Aniso8), 1, _PlanarNM_cb7ded32e6af3382bbe06b62977afab6, _PlanarNM_cb7ded32e6af3382bbe06b62977afab6_XZ_2_Vector4);
            float4 _Property_41859d117584758eb8002ecc938f9bce_Out_0_Vector4 = _BaseColor;
            float4 _Multiply_4d0f82599060228a9092027fd43912c8_Out_2_Vector4;
            Unity_Multiply_float4_float4(_PlanarNM_cb7ded32e6af3382bbe06b62977afab6_XZ_2_Vector4, _Property_41859d117584758eb8002ecc938f9bce_Out_0_Vector4, _Multiply_4d0f82599060228a9092027fd43912c8_Out_2_Vector4);
            float3 _ColorspaceConversion_30c5042ef70343cd92056cde73cd3ecb_Out_1_Vector3;
            Unity_ColorspaceConversion_Linear_RGB_float((_Multiply_4d0f82599060228a9092027fd43912c8_Out_2_Vector4.xyz), _ColorspaceConversion_30c5042ef70343cd92056cde73cd3ecb_Out_1_Vector3);
            UnityTexture2D _Property_50403cc6b1e3998a82afc21c6a6332ae_Out_0_Texture2D = UnityBuildTexture2DStructNoScale(_DetailMap);
            float4 _Property_256e5676e1089881ae3214634430b140_Out_0_Vector4 = _DetailTilingOffset;
            float _Split_257d0b6ea953418d97fd7daa8128bf35_R_1_Float = _Property_256e5676e1089881ae3214634430b140_Out_0_Vector4[0];
            float _Split_257d0b6ea953418d97fd7daa8128bf35_G_2_Float = _Property_256e5676e1089881ae3214634430b140_Out_0_Vector4[1];
            float _Split_257d0b6ea953418d97fd7daa8128bf35_B_3_Float = _Property_256e5676e1089881ae3214634430b140_Out_0_Vector4[2];
            float _Split_257d0b6ea953418d97fd7daa8128bf35_A_4_Float = _Property_256e5676e1089881ae3214634430b140_Out_0_Vector4[3];
            float2 _Vector2_98295494172421878c7a16cb2baddf9a_Out_0_Vector2 = float2(_Split_257d0b6ea953418d97fd7daa8128bf35_R_1_Float, _Split_257d0b6ea953418d97fd7daa8128bf35_G_2_Float);
            float2 _Vector2_130e8faa59837a81a7506636fcb30b8a_Out_0_Vector2 = float2(_Split_257d0b6ea953418d97fd7daa8128bf35_B_3_Float, _Split_257d0b6ea953418d97fd7daa8128bf35_A_4_Float);
            float2 _TilingAndOffset_1dfb2b4859ec3680ad3a74cf8f1bc17b_Out_3_Vector2;
            Unity_TilingAndOffset_float(IN.uv0.xy, _Vector2_98295494172421878c7a16cb2baddf9a_Out_0_Vector2, _Vector2_130e8faa59837a81a7506636fcb30b8a_Out_0_Vector2, _TilingAndOffset_1dfb2b4859ec3680ad3a74cf8f1bc17b_Out_3_Vector2);
            float4 _SampleTexture2D_d8eb0186b9a0cd819cde65431b4ea5ea_RGBA_0_Vector4 = SAMPLE_TEXTURE2D(_Property_50403cc6b1e3998a82afc21c6a6332ae_Out_0_Texture2D.tex, UnityBuildSamplerStateStruct(SamplerState_Linear_Repeat_Aniso8).samplerstate, _Property_50403cc6b1e3998a82afc21c6a6332ae_Out_0_Texture2D.GetTransformedUV(_TilingAndOffset_1dfb2b4859ec3680ad3a74cf8f1bc17b_Out_3_Vector2) );
            float _SampleTexture2D_d8eb0186b9a0cd819cde65431b4ea5ea_R_4_Float = _SampleTexture2D_d8eb0186b9a0cd819cde65431b4ea5ea_RGBA_0_Vector4.r;
            float _SampleTexture2D_d8eb0186b9a0cd819cde65431b4ea5ea_G_5_Float = _SampleTexture2D_d8eb0186b9a0cd819cde65431b4ea5ea_RGBA_0_Vector4.g;
            float _SampleTexture2D_d8eb0186b9a0cd819cde65431b4ea5ea_B_6_Float = _SampleTexture2D_d8eb0186b9a0cd819cde65431b4ea5ea_RGBA_0_Vector4.b;
            float _SampleTexture2D_d8eb0186b9a0cd819cde65431b4ea5ea_A_7_Float = _SampleTexture2D_d8eb0186b9a0cd819cde65431b4ea5ea_RGBA_0_Vector4.a;
            float _Property_605f29777330a58ba88ac032e905433b_Out_0_Float = _DetailAlbedoScale;
            float3 _Blend_de85bf99257f4eb7bb321fd973539f10_Out_2_Vector3;
            Unity_Blend_Overlay_float3(_ColorspaceConversion_30c5042ef70343cd92056cde73cd3ecb_Out_1_Vector3, (_SampleTexture2D_d8eb0186b9a0cd819cde65431b4ea5ea_R_4_Float.xxx), _Blend_de85bf99257f4eb7bb321fd973539f10_Out_2_Vector3, _Property_605f29777330a58ba88ac032e905433b_Out_0_Float);
            float3 _ColorspaceConversion_635670d250654503b34efa53a99ba43e_Out_1_Vector3;
            Unity_ColorspaceConversion_RGB_Linear_float(_Blend_de85bf99257f4eb7bb321fd973539f10_Out_2_Vector3, _ColorspaceConversion_635670d250654503b34efa53a99ba43e_Out_1_Vector3);
            float3 _Clamp_8913f48f801c43c2879f2e1ce926507e_Out_3_Vector3;
            Unity_Clamp_float3(_ColorspaceConversion_635670d250654503b34efa53a99ba43e_Out_1_Vector3, float3(0, 0, 0), float3(1, 1, 1), _Clamp_8913f48f801c43c2879f2e1ce926507e_Out_3_Vector3);
            float _Split_ddfe447fbb7845e88cc5cfb8158b2248_R_1_Float = _Clamp_8913f48f801c43c2879f2e1ce926507e_Out_3_Vector3[0];
            float _Split_ddfe447fbb7845e88cc5cfb8158b2248_G_2_Float = _Clamp_8913f48f801c43c2879f2e1ce926507e_Out_3_Vector3[1];
            float _Split_ddfe447fbb7845e88cc5cfb8158b2248_B_3_Float = _Clamp_8913f48f801c43c2879f2e1ce926507e_Out_3_Vector3[2];
            float _Split_ddfe447fbb7845e88cc5cfb8158b2248_A_4_Float = 0;
            float _Split_6d7debfd2b20440e932d58108f8e7f75_R_1_Float = _Multiply_4d0f82599060228a9092027fd43912c8_Out_2_Vector4[0];
            float _Split_6d7debfd2b20440e932d58108f8e7f75_G_2_Float = _Multiply_4d0f82599060228a9092027fd43912c8_Out_2_Vector4[1];
            float _Split_6d7debfd2b20440e932d58108f8e7f75_B_3_Float = _Multiply_4d0f82599060228a9092027fd43912c8_Out_2_Vector4[2];
            float _Split_6d7debfd2b20440e932d58108f8e7f75_A_4_Float = _Multiply_4d0f82599060228a9092027fd43912c8_Out_2_Vector4[3];
            float4 _Combine_b0f28916143e4b94af6bec53f5328b52_RGBA_4_Vector4;
            float3 _Combine_b0f28916143e4b94af6bec53f5328b52_RGB_5_Vector3;
            float2 _Combine_b0f28916143e4b94af6bec53f5328b52_RG_6_Vector2;
            Unity_Combine_float(_Split_ddfe447fbb7845e88cc5cfb8158b2248_R_1_Float, _Split_ddfe447fbb7845e88cc5cfb8158b2248_G_2_Float, _Split_ddfe447fbb7845e88cc5cfb8158b2248_B_3_Float, _Split_6d7debfd2b20440e932d58108f8e7f75_A_4_Float, _Combine_b0f28916143e4b94af6bec53f5328b52_RGBA_4_Vector4, _Combine_b0f28916143e4b94af6bec53f5328b52_RGB_5_Vector3, _Combine_b0f28916143e4b94af6bec53f5328b52_RG_6_Vector2);
            UnityTexture2D _Property_a155ddc33ed90685a5ab0edcf158a343_Out_0_Texture2D = UnityBuildTexture2DStructNoScale(_CoverBaseColorMap);
            float4 _Property_256beda96caf2d8aa05d3de41fc08d3d_Out_0_Vector4 = _CoverTilingOffset;
            float _Property_bd9dfe8dd615798f9f2d72d139e56d61_Out_0_Boolean = _CoverUsePlanarUV;
            Bindings_PlanarNM_c0f081da9c567704ea36e7dd38cedcf6_float _PlanarNM_e00e057d3d7c4181b1c7775c6ebbab5b;
            _PlanarNM_e00e057d3d7c4181b1c7775c6ebbab5b.AbsoluteWorldSpacePosition = IN.AbsoluteWorldSpacePosition;
            _PlanarNM_e00e057d3d7c4181b1c7775c6ebbab5b.uv0 = IN.uv0;
            _PlanarNM_e00e057d3d7c4181b1c7775c6ebbab5b.uv3 = IN.uv3;
            float4 _PlanarNM_e00e057d3d7c4181b1c7775c6ebbab5b_XZ_2_Vector4;
            SG_PlanarNM_c0f081da9c567704ea36e7dd38cedcf6_float(_Property_a155ddc33ed90685a5ab0edcf158a343_Out_0_Texture2D, _Property_256beda96caf2d8aa05d3de41fc08d3d_Out_0_Vector4, _Property_bd9dfe8dd615798f9f2d72d139e56d61_Out_0_Boolean, UnityBuildSamplerStateStruct(SamplerState_Linear_Repeat_Aniso8), 1, _PlanarNM_e00e057d3d7c4181b1c7775c6ebbab5b, _PlanarNM_e00e057d3d7c4181b1c7775c6ebbab5b_XZ_2_Vector4);
            float4 _Property_c3be5593fd661b8dafbd04f26b8ec9ac_Out_0_Vector4 = _CoverBaseColor;
            float4 _Multiply_b08794693505bd8e8c04b9ba1610d394_Out_2_Vector4;
            Unity_Multiply_float4_float4(_PlanarNM_e00e057d3d7c4181b1c7775c6ebbab5b_XZ_2_Vector4, _Property_c3be5593fd661b8dafbd04f26b8ec9ac_Out_0_Vector4, _Multiply_b08794693505bd8e8c04b9ba1610d394_Out_2_Vector4);
            float _Split_a80936a3c75945efb8cf9f2b95c76642_R_1_Float = IN.VertexColor[0];
            float _Split_a80936a3c75945efb8cf9f2b95c76642_G_2_Float = IN.VertexColor[1];
            float _Split_a80936a3c75945efb8cf9f2b95c76642_B_3_Float = IN.VertexColor[2];
            float _Split_a80936a3c75945efb8cf9f2b95c76642_A_4_Float = IN.VertexColor[3];
            float _Property_14a6757619d64822a44a69b34f85276d_Out_0_Float = _VertexColorGBlendStrenght;
            float _Property_c0d9ffba7dee497c885a54170977d874_Out_0_Boolean = _USEBaseHeightT;
            UnityTexture2D _Property_bb9b47702e64ec8c8d8ad011fd521576_Out_0_Texture2D = UnityBuildTexture2DStructNoScale(_BaseMaskMap);
            Bindings_PlanarNM_c0f081da9c567704ea36e7dd38cedcf6_float _PlanarNM_e51306c84cde8e84a1fb06a45d8d037f;
            _PlanarNM_e51306c84cde8e84a1fb06a45d8d037f.AbsoluteWorldSpacePosition = IN.AbsoluteWorldSpacePosition;
            _PlanarNM_e51306c84cde8e84a1fb06a45d8d037f.uv0 = IN.uv0;
            _PlanarNM_e51306c84cde8e84a1fb06a45d8d037f.uv3 = IN.uv3;
            float4 _PlanarNM_e51306c84cde8e84a1fb06a45d8d037f_XZ_2_Vector4;
            SG_PlanarNM_c0f081da9c567704ea36e7dd38cedcf6_float(_Property_bb9b47702e64ec8c8d8ad011fd521576_Out_0_Texture2D, _Property_8ec0d512145619859d288abab740e3bf_Out_0_Vector4, _Property_122c0f9ef0a1c4818a140c75e512abe4_Out_0_Boolean, UnityBuildSamplerStateStruct(SamplerState_Linear_Repeat_Aniso8), 1, _PlanarNM_e51306c84cde8e84a1fb06a45d8d037f, _PlanarNM_e51306c84cde8e84a1fb06a45d8d037f_XZ_2_Vector4);
            float _Split_218e1cfd00b30984921b5fc0ec63de60_R_1_Float = _PlanarNM_e51306c84cde8e84a1fb06a45d8d037f_XZ_2_Vector4[0];
            float _Split_218e1cfd00b30984921b5fc0ec63de60_G_2_Float = _PlanarNM_e51306c84cde8e84a1fb06a45d8d037f_XZ_2_Vector4[1];
            float _Split_218e1cfd00b30984921b5fc0ec63de60_B_3_Float = _PlanarNM_e51306c84cde8e84a1fb06a45d8d037f_XZ_2_Vector4[2];
            float _Split_218e1cfd00b30984921b5fc0ec63de60_A_4_Float = _PlanarNM_e51306c84cde8e84a1fb06a45d8d037f_XZ_2_Vector4[3];
            float _Property_1d4a1a93707b42c3abf0baa799c514e5_Out_0_Float = _HeightMin;
            float _Property_8f4f3606868d4028a34c2a9a5a59f99d_Out_0_Float = _HeightMax;
            float2 _Vector2_721b6f4d7077463490b4504fe6c940bf_Out_0_Vector2 = float2(_Property_1d4a1a93707b42c3abf0baa799c514e5_Out_0_Float, _Property_8f4f3606868d4028a34c2a9a5a59f99d_Out_0_Float);
            float _Property_a1ae2f61da87421b9f3839691e9dd8af_Out_0_Float = _HeightOffset;
            float2 _Add_1f9ea9bdf36544b59f763806e7eea80d_Out_2_Vector2;
            Unity_Add_float2(_Vector2_721b6f4d7077463490b4504fe6c940bf_Out_0_Vector2, (_Property_a1ae2f61da87421b9f3839691e9dd8af_Out_0_Float.xx), _Add_1f9ea9bdf36544b59f763806e7eea80d_Out_2_Vector2);
            float _Property_0fbef18600294e199eeda9905e3304e4_Out_0_Boolean = _USECoverHeightT;
            UnityTexture2D _Property_3702de305e11e085a40d7731b582d541_Out_0_Texture2D = UnityBuildTexture2DStructNoScale(_CoverMaskMap);
            Bindings_PlanarNM_c0f081da9c567704ea36e7dd38cedcf6_float _PlanarNM_2217ca3c12141a8cb1e0c7235b369601;
            _PlanarNM_2217ca3c12141a8cb1e0c7235b369601.AbsoluteWorldSpacePosition = IN.AbsoluteWorldSpacePosition;
            _PlanarNM_2217ca3c12141a8cb1e0c7235b369601.uv0 = IN.uv0;
            _PlanarNM_2217ca3c12141a8cb1e0c7235b369601.uv3 = IN.uv3;
            float4 _PlanarNM_2217ca3c12141a8cb1e0c7235b369601_XZ_2_Vector4;
            SG_PlanarNM_c0f081da9c567704ea36e7dd38cedcf6_float(_Property_3702de305e11e085a40d7731b582d541_Out_0_Texture2D, _Property_256beda96caf2d8aa05d3de41fc08d3d_Out_0_Vector4, _Property_bd9dfe8dd615798f9f2d72d139e56d61_Out_0_Boolean, UnityBuildSamplerStateStruct(SamplerState_Linear_Repeat_Aniso8), 1, _PlanarNM_2217ca3c12141a8cb1e0c7235b369601, _PlanarNM_2217ca3c12141a8cb1e0c7235b369601_XZ_2_Vector4);
            float _Split_2f45bca363698c859e51492899bc58f8_R_1_Float = _PlanarNM_2217ca3c12141a8cb1e0c7235b369601_XZ_2_Vector4[0];
            float _Split_2f45bca363698c859e51492899bc58f8_G_2_Float = _PlanarNM_2217ca3c12141a8cb1e0c7235b369601_XZ_2_Vector4[1];
            float _Split_2f45bca363698c859e51492899bc58f8_B_3_Float = _PlanarNM_2217ca3c12141a8cb1e0c7235b369601_XZ_2_Vector4[2];
            float _Split_2f45bca363698c859e51492899bc58f8_A_4_Float = _PlanarNM_2217ca3c12141a8cb1e0c7235b369601_XZ_2_Vector4[3];
            float _Property_32b48052fdbb4641bf4eeb294bc65050_Out_0_Float = _CoverHeightMapMin;
            float _Property_0e120eb0a0a14b12a31a3c1f5b961121_Out_0_Float = _CoverHeightMapMax;
            float2 _Vector2_6955747f7f0a4ff98fae60dbada25e89_Out_0_Vector2 = float2(_Property_32b48052fdbb4641bf4eeb294bc65050_Out_0_Float, _Property_0e120eb0a0a14b12a31a3c1f5b961121_Out_0_Float);
            float _Property_6b467710b0ba48058e003aebe9119249_Out_0_Float = _CoverHeightMapOffset;
            float2 _Add_28628d641d58481084e9c00e4ad5fc8d_Out_2_Vector2;
            Unity_Add_float2(_Vector2_6955747f7f0a4ff98fae60dbada25e89_Out_0_Vector2, (_Property_6b467710b0ba48058e003aebe9119249_Out_0_Float.xx), _Add_28628d641d58481084e9c00e4ad5fc8d_Out_2_Vector2);
            UnityTexture2D _Property_7bea2d9dd5651a8bbbd61ecde71faa54_Out_0_Texture2D = UnityBuildTexture2DStructNoScale(_Masks);
            float4 _UV_429c95affe88aa8694076115c99a0769_Out_0_Vector4 = IN.uv0;
            float4 _SampleTexture2D_2723da80b8a2528381ef199c0415beae_RGBA_0_Vector4 = SAMPLE_TEXTURE2D(_Property_7bea2d9dd5651a8bbbd61ecde71faa54_Out_0_Texture2D.tex, UnityBuildSamplerStateStruct(SamplerState_Linear_Repeat_Aniso8).samplerstate, _Property_7bea2d9dd5651a8bbbd61ecde71faa54_Out_0_Texture2D.GetTransformedUV((_UV_429c95affe88aa8694076115c99a0769_Out_0_Vector4.xy)) );
            float _SampleTexture2D_2723da80b8a2528381ef199c0415beae_R_4_Float = _SampleTexture2D_2723da80b8a2528381ef199c0415beae_RGBA_0_Vector4.r;
            float _SampleTexture2D_2723da80b8a2528381ef199c0415beae_G_5_Float = _SampleTexture2D_2723da80b8a2528381ef199c0415beae_RGBA_0_Vector4.g;
            float _SampleTexture2D_2723da80b8a2528381ef199c0415beae_B_6_Float = _SampleTexture2D_2723da80b8a2528381ef199c0415beae_RGBA_0_Vector4.b;
            float _SampleTexture2D_2723da80b8a2528381ef199c0415beae_A_7_Float = _SampleTexture2D_2723da80b8a2528381ef199c0415beae_RGBA_0_Vector4.a;
            float _Property_7bea2851849541b28a2bc695d39a7606_Out_0_Float = _Cover_Mask_A_Remap_Min;
            float _Property_3be0ae138e414a5cb43d60264b1bcfeb_Out_0_Float = _Cover_Mask_A_Remap_Max;
            float2 _Vector2_44ac029de1e440a799fbdfadc778af0c_Out_0_Vector2 = float2(_Property_7bea2851849541b28a2bc695d39a7606_Out_0_Float, _Property_3be0ae138e414a5cb43d60264b1bcfeb_Out_0_Float);
            float _Remap_0c551a3055a54f16b85b519194883552_Out_3_Float;
            Unity_Remap_float(_SampleTexture2D_2723da80b8a2528381ef199c0415beae_A_7_Float, float2 (0, 1), _Vector2_44ac029de1e440a799fbdfadc778af0c_Out_0_Vector2, _Remap_0c551a3055a54f16b85b519194883552_Out_3_Float);
            float _Clamp_bb1427696ce14fe987f799fecc5f9fac_Out_3_Float;
            Unity_Clamp_float(_Remap_0c551a3055a54f16b85b519194883552_Out_3_Float, float(0), float(1), _Clamp_bb1427696ce14fe987f799fecc5f9fac_Out_3_Float);
            float2 _Vector2_0d28074858599a88940dfc8b57b9a60f_Out_0_Vector2 = float2(_SampleTexture2D_d8eb0186b9a0cd819cde65431b4ea5ea_A_7_Float, _SampleTexture2D_d8eb0186b9a0cd819cde65431b4ea5ea_G_5_Float);
            float2 _Multiply_fac8d94f82a53486bc0142a1e64b3d32_Out_2_Vector2;
            Unity_Multiply_float2_float2(_Vector2_0d28074858599a88940dfc8b57b9a60f_Out_0_Vector2, float2(2, 2), _Multiply_fac8d94f82a53486bc0142a1e64b3d32_Out_2_Vector2);
            float2 _Add_f0e6e847d8d8798ab3ca8c4d878bafc0_Out_2_Vector2;
            Unity_Add_float2(_Multiply_fac8d94f82a53486bc0142a1e64b3d32_Out_2_Vector2, float2(-1, -1), _Add_f0e6e847d8d8798ab3ca8c4d878bafc0_Out_2_Vector2);
            float _Property_d0e8d8f7fd10f0829e8fd86c278c8226_Out_0_Float = _DetailNormalScale;
            float2 _Multiply_11f3dfc5283ea188ad9c83e552cf7e0f_Out_2_Vector2;
            Unity_Multiply_float2_float2(_Add_f0e6e847d8d8798ab3ca8c4d878bafc0_Out_2_Vector2, (_Property_d0e8d8f7fd10f0829e8fd86c278c8226_Out_0_Float.xx), _Multiply_11f3dfc5283ea188ad9c83e552cf7e0f_Out_2_Vector2);
            float _Split_c4822b8eaff9b185be7c059792345712_R_1_Float = _Multiply_11f3dfc5283ea188ad9c83e552cf7e0f_Out_2_Vector2[0];
            float _Split_c4822b8eaff9b185be7c059792345712_G_2_Float = _Multiply_11f3dfc5283ea188ad9c83e552cf7e0f_Out_2_Vector2[1];
            float _Split_c4822b8eaff9b185be7c059792345712_B_3_Float = 0;
            float _Split_c4822b8eaff9b185be7c059792345712_A_4_Float = 0;
            float _DotProduct_1a01939a143c548c8ccd7e8a04fe680d_Out_2_Float;
            Unity_DotProduct_float2(_Multiply_11f3dfc5283ea188ad9c83e552cf7e0f_Out_2_Vector2, _Multiply_11f3dfc5283ea188ad9c83e552cf7e0f_Out_2_Vector2, _DotProduct_1a01939a143c548c8ccd7e8a04fe680d_Out_2_Float);
            float _Saturate_bf3d57899db77f86a1689105ce6a373a_Out_1_Float;
            Unity_Saturate_float(_DotProduct_1a01939a143c548c8ccd7e8a04fe680d_Out_2_Float, _Saturate_bf3d57899db77f86a1689105ce6a373a_Out_1_Float);
            float _OneMinus_052960238cc4a18cb83109d2bcae6d09_Out_1_Float;
            Unity_OneMinus_float(_Saturate_bf3d57899db77f86a1689105ce6a373a_Out_1_Float, _OneMinus_052960238cc4a18cb83109d2bcae6d09_Out_1_Float);
            float _SquareRoot_d4f67288e4dbf5898bea492a70b89ab9_Out_1_Float;
            Unity_SquareRoot_float(_OneMinus_052960238cc4a18cb83109d2bcae6d09_Out_1_Float, _SquareRoot_d4f67288e4dbf5898bea492a70b89ab9_Out_1_Float);
            float3 _Vector3_1e56146bdd567884bb8d5ae769df4d29_Out_0_Vector3 = float3(_Split_c4822b8eaff9b185be7c059792345712_R_1_Float, _Split_c4822b8eaff9b185be7c059792345712_G_2_Float, _SquareRoot_d4f67288e4dbf5898bea492a70b89ab9_Out_1_Float);
            UnityTexture2D _Property_147b07430832c98eb0a470557ee61c5e_Out_0_Texture2D = UnityBuildTexture2DStructNoScale(_BaseNormalMap);
            Bindings_PlanarNMn_1b93a87456f9d4c419321d0cd92bd6c8_float _PlanarNMn_ecad9f1f260c6c8bbd0960b2a8976daf;
            _PlanarNMn_ecad9f1f260c6c8bbd0960b2a8976daf.WorldSpaceNormal = IN.WorldSpaceNormal;
            _PlanarNMn_ecad9f1f260c6c8bbd0960b2a8976daf.WorldSpaceTangent = IN.WorldSpaceTangent;
            _PlanarNMn_ecad9f1f260c6c8bbd0960b2a8976daf.WorldSpaceBiTangent = IN.WorldSpaceBiTangent;
            _PlanarNMn_ecad9f1f260c6c8bbd0960b2a8976daf.AbsoluteWorldSpacePosition = IN.AbsoluteWorldSpacePosition;
            _PlanarNMn_ecad9f1f260c6c8bbd0960b2a8976daf.uv0 = IN.uv0;
            _PlanarNMn_ecad9f1f260c6c8bbd0960b2a8976daf.uv3 = IN.uv3;
            float4 _PlanarNMn_ecad9f1f260c6c8bbd0960b2a8976daf_XZ_2_Vector4;
            SG_PlanarNMn_1b93a87456f9d4c419321d0cd92bd6c8_float(_Property_147b07430832c98eb0a470557ee61c5e_Out_0_Texture2D, _Property_8ec0d512145619859d288abab740e3bf_Out_0_Vector4, _Property_122c0f9ef0a1c4818a140c75e512abe4_Out_0_Boolean, UnityBuildSamplerStateStruct(SamplerState_Linear_Repeat_Aniso8), 1, _PlanarNMn_ecad9f1f260c6c8bbd0960b2a8976daf, _PlanarNMn_ecad9f1f260c6c8bbd0960b2a8976daf_XZ_2_Vector4);
            float _Property_72e436a108ad64868e46d548c585c5f3_Out_0_Float = _BaseNormalScale;
            float3 _NormalStrength_366affc5c8b42482a633d201ef52b9d6_Out_2_Vector3;
            Unity_NormalStrength_float((_PlanarNMn_ecad9f1f260c6c8bbd0960b2a8976daf_XZ_2_Vector4.xyz), _Property_72e436a108ad64868e46d548c585c5f3_Out_0_Float, _NormalStrength_366affc5c8b42482a633d201ef52b9d6_Out_2_Vector3);
            float3 _NormalBlend_9f531c87e2e45580b1d0f65f06c23526_Out_2_Vector3;
            Unity_NormalBlend_Reoriented_float(_Vector3_1e56146bdd567884bb8d5ae769df4d29_Out_0_Vector3, _NormalStrength_366affc5c8b42482a633d201ef52b9d6_Out_2_Vector3, _NormalBlend_9f531c87e2e45580b1d0f65f06c23526_Out_2_Vector3);
            UnityTexture2D _Property_d7e9139e0ac6718b89c610009c28a25a_Out_0_Texture2D = UnityBuildTexture2DStructNoScale(_CoverNormalMap);
            Bindings_PlanarNMn_1b93a87456f9d4c419321d0cd92bd6c8_float _PlanarNMn_690e893d26999680a5cea3604ed0ce16;
            _PlanarNMn_690e893d26999680a5cea3604ed0ce16.WorldSpaceNormal = IN.WorldSpaceNormal;
            _PlanarNMn_690e893d26999680a5cea3604ed0ce16.WorldSpaceTangent = IN.WorldSpaceTangent;
            _PlanarNMn_690e893d26999680a5cea3604ed0ce16.WorldSpaceBiTangent = IN.WorldSpaceBiTangent;
            _PlanarNMn_690e893d26999680a5cea3604ed0ce16.AbsoluteWorldSpacePosition = IN.AbsoluteWorldSpacePosition;
            _PlanarNMn_690e893d26999680a5cea3604ed0ce16.uv0 = IN.uv0;
            _PlanarNMn_690e893d26999680a5cea3604ed0ce16.uv3 = IN.uv3;
            float4 _PlanarNMn_690e893d26999680a5cea3604ed0ce16_XZ_2_Vector4;
            SG_PlanarNMn_1b93a87456f9d4c419321d0cd92bd6c8_float(_Property_d7e9139e0ac6718b89c610009c28a25a_Out_0_Texture2D, _Property_256beda96caf2d8aa05d3de41fc08d3d_Out_0_Vector4, _Property_bd9dfe8dd615798f9f2d72d139e56d61_Out_0_Boolean, UnityBuildSamplerStateStruct(SamplerState_Linear_Repeat_Aniso8), 1, _PlanarNMn_690e893d26999680a5cea3604ed0ce16, _PlanarNMn_690e893d26999680a5cea3604ed0ce16_XZ_2_Vector4);
            float _Property_0fd4d87ded104c829a6110c044eaa5f2_Out_0_Float = _CoverNormalBlendHardness;
            float3 _NormalStrength_c4639a6dd3dfde85b591971db2700eaf_Out_2_Vector3;
            Unity_NormalStrength_float((_PlanarNMn_690e893d26999680a5cea3604ed0ce16_XZ_2_Vector4.xyz), _Property_0fd4d87ded104c829a6110c044eaa5f2_Out_0_Float, _NormalStrength_c4639a6dd3dfde85b591971db2700eaf_Out_2_Vector3);
            float _Split_8ff22a6bdd437780ac7ea5963e1c5bb4_R_1_Float = IN.WorldSpaceNormal[0];
            float _Split_8ff22a6bdd437780ac7ea5963e1c5bb4_G_2_Float = IN.WorldSpaceNormal[1];
            float _Split_8ff22a6bdd437780ac7ea5963e1c5bb4_B_3_Float = IN.WorldSpaceNormal[2];
            float _Split_8ff22a6bdd437780ac7ea5963e1c5bb4_A_4_Float = 0;
            float _Property_28052b023ac35c8e9a95b30327681cc5_Out_0_Float = _Cover_Amount;
            float _Property_7749c0d5b28c14869ab3ba35d226788b_Out_0_Float = _Cover_Amount_Grow_Speed;
            float _Subtract_e5dc2afce7ff588fa1d4c91f78de7575_Out_2_Float;
            Unity_Subtract_float(float(4), _Property_7749c0d5b28c14869ab3ba35d226788b_Out_0_Float, _Subtract_e5dc2afce7ff588fa1d4c91f78de7575_Out_2_Float);
            float _Divide_c77b003bf1ce13828c94a705676e2b30_Out_2_Float;
            Unity_Divide_float(_Property_28052b023ac35c8e9a95b30327681cc5_Out_0_Float, _Subtract_e5dc2afce7ff588fa1d4c91f78de7575_Out_2_Float, _Divide_c77b003bf1ce13828c94a705676e2b30_Out_2_Float);
            float _Absolute_c7499cf07bdd0582abd82adbf367b0fc_Out_1_Float;
            Unity_Absolute_float(_Divide_c77b003bf1ce13828c94a705676e2b30_Out_2_Float, _Absolute_c7499cf07bdd0582abd82adbf367b0fc_Out_1_Float);
            float _Power_a9431dbce44a528f9ee7095adfa10556_Out_2_Float;
            Unity_Power_float(_Absolute_c7499cf07bdd0582abd82adbf367b0fc_Out_1_Float, _Subtract_e5dc2afce7ff588fa1d4c91f78de7575_Out_2_Float, _Power_a9431dbce44a528f9ee7095adfa10556_Out_2_Float);
            float _Clamp_815ffdd53cc1c889aa00f73784cb71e7_Out_3_Float;
            Unity_Clamp_float(_Power_a9431dbce44a528f9ee7095adfa10556_Out_2_Float, float(0), float(2), _Clamp_815ffdd53cc1c889aa00f73784cb71e7_Out_3_Float);
            float _Multiply_143da4886728ff868f10e9cfa6940ea0_Out_2_Float;
            Unity_Multiply_float_float(_Split_8ff22a6bdd437780ac7ea5963e1c5bb4_G_2_Float, _Clamp_815ffdd53cc1c889aa00f73784cb71e7_Out_3_Float, _Multiply_143da4886728ff868f10e9cfa6940ea0_Out_2_Float);
            float _Saturate_04686ab19029f68c8fb9e7a115b207b1_Out_1_Float;
            Unity_Saturate_float(_Multiply_143da4886728ff868f10e9cfa6940ea0_Out_2_Float, _Saturate_04686ab19029f68c8fb9e7a115b207b1_Out_1_Float);
            float _Clamp_9c0a88ffc7be288cbe97d3e13a014fe8_Out_3_Float;
            Unity_Clamp_float(_Split_8ff22a6bdd437780ac7ea5963e1c5bb4_G_2_Float, float(0), float(0.9999), _Clamp_9c0a88ffc7be288cbe97d3e13a014fe8_Out_3_Float);
            float _Property_58f42b34c7f0728f8c98e00a3e3a5726_Out_0_Float = _Cover_Max_Angle;
            float _Divide_b785767ecc1928889893fa60eac4e5fb_Out_2_Float;
            Unity_Divide_float(_Property_58f42b34c7f0728f8c98e00a3e3a5726_Out_0_Float, float(45), _Divide_b785767ecc1928889893fa60eac4e5fb_Out_2_Float);
            float _OneMinus_8e6f5b1570dc8c8b8afb036328281675_Out_1_Float;
            Unity_OneMinus_float(_Divide_b785767ecc1928889893fa60eac4e5fb_Out_2_Float, _OneMinus_8e6f5b1570dc8c8b8afb036328281675_Out_1_Float);
            float _Subtract_5348fb3702fea78d9ee10dbf81ede29c_Out_2_Float;
            Unity_Subtract_float(_Clamp_9c0a88ffc7be288cbe97d3e13a014fe8_Out_3_Float, _OneMinus_8e6f5b1570dc8c8b8afb036328281675_Out_1_Float, _Subtract_5348fb3702fea78d9ee10dbf81ede29c_Out_2_Float);
            float _Clamp_2b888688983edd82ac250226d9378893_Out_3_Float;
            Unity_Clamp_float(_Subtract_5348fb3702fea78d9ee10dbf81ede29c_Out_2_Float, float(0), float(2), _Clamp_2b888688983edd82ac250226d9378893_Out_3_Float);
            float _Divide_5615f16c20214d888a2e727ff7c5f5ff_Out_2_Float;
            Unity_Divide_float(float(1), _Divide_b785767ecc1928889893fa60eac4e5fb_Out_2_Float, _Divide_5615f16c20214d888a2e727ff7c5f5ff_Out_2_Float);
            float _Multiply_89aeffc0ad067981a18e6a77948b2b49_Out_2_Float;
            Unity_Multiply_float_float(_Clamp_2b888688983edd82ac250226d9378893_Out_3_Float, _Divide_5615f16c20214d888a2e727ff7c5f5ff_Out_2_Float, _Multiply_89aeffc0ad067981a18e6a77948b2b49_Out_2_Float);
            float _Absolute_b91ed8e326de8f88bf52e49cc5f641d4_Out_1_Float;
            Unity_Absolute_float(_Multiply_89aeffc0ad067981a18e6a77948b2b49_Out_2_Float, _Absolute_b91ed8e326de8f88bf52e49cc5f641d4_Out_1_Float);
            float _Property_4879e96694aee98c9d4ecd329a571123_Out_0_Float = _CoverHardness;
            float _Power_ca1f1906c90fb785bfe520b7faefc3cd_Out_2_Float;
            Unity_Power_float(_Absolute_b91ed8e326de8f88bf52e49cc5f641d4_Out_1_Float, _Property_4879e96694aee98c9d4ecd329a571123_Out_0_Float, _Power_ca1f1906c90fb785bfe520b7faefc3cd_Out_2_Float);
            float _Property_b66201e787ab7b83a55abc6ddd3fe1fd_Out_0_Float = _Cover_Min_Height;
            float _OneMinus_87c740d245de388db4fe5f4958de0668_Out_1_Float;
            Unity_OneMinus_float(_Property_b66201e787ab7b83a55abc6ddd3fe1fd_Out_0_Float, _OneMinus_87c740d245de388db4fe5f4958de0668_Out_1_Float);
            float _Split_ae16de7cacf9d0878aba1467f193d681_R_1_Float = IN.AbsoluteWorldSpacePosition[0];
            float _Split_ae16de7cacf9d0878aba1467f193d681_G_2_Float = IN.AbsoluteWorldSpacePosition[1];
            float _Split_ae16de7cacf9d0878aba1467f193d681_B_3_Float = IN.AbsoluteWorldSpacePosition[2];
            float _Split_ae16de7cacf9d0878aba1467f193d681_A_4_Float = 0;
            float _Add_9d6e1dd03919c88bb01e77a9a2b6b59c_Out_2_Float;
            Unity_Add_float(_OneMinus_87c740d245de388db4fe5f4958de0668_Out_1_Float, _Split_ae16de7cacf9d0878aba1467f193d681_G_2_Float, _Add_9d6e1dd03919c88bb01e77a9a2b6b59c_Out_2_Float);
            float _Add_448f30a2cd792b868416a253a1c502bb_Out_2_Float;
            Unity_Add_float(_Add_9d6e1dd03919c88bb01e77a9a2b6b59c_Out_2_Float, float(1), _Add_448f30a2cd792b868416a253a1c502bb_Out_2_Float);
            float _Clamp_53d91568d0627d8a9cac8deecdd003a8_Out_3_Float;
            Unity_Clamp_float(_Add_448f30a2cd792b868416a253a1c502bb_Out_2_Float, float(0), float(1), _Clamp_53d91568d0627d8a9cac8deecdd003a8_Out_3_Float);
            float _Property_98b8c0fc7e8f9b88b8d7d9dd28ed8aca_Out_0_Float = _Cover_Min_Height_Blending;
            float _Add_0edbe9f424de6d8089b453804bc6ec74_Out_2_Float;
            Unity_Add_float(_Add_9d6e1dd03919c88bb01e77a9a2b6b59c_Out_2_Float, _Property_98b8c0fc7e8f9b88b8d7d9dd28ed8aca_Out_0_Float, _Add_0edbe9f424de6d8089b453804bc6ec74_Out_2_Float);
            float _Divide_bacd243000beaa86b28174bd47716791_Out_2_Float;
            Unity_Divide_float(_Add_0edbe9f424de6d8089b453804bc6ec74_Out_2_Float, _Add_9d6e1dd03919c88bb01e77a9a2b6b59c_Out_2_Float, _Divide_bacd243000beaa86b28174bd47716791_Out_2_Float);
            float _OneMinus_dd51a0c56dbb9b8b8882c6d36bfadd50_Out_1_Float;
            Unity_OneMinus_float(_Divide_bacd243000beaa86b28174bd47716791_Out_2_Float, _OneMinus_dd51a0c56dbb9b8b8882c6d36bfadd50_Out_1_Float);
            float _Add_58dd4a9dfd5655818255c74dd17921da_Out_2_Float;
            Unity_Add_float(_OneMinus_dd51a0c56dbb9b8b8882c6d36bfadd50_Out_1_Float, float(-0.5), _Add_58dd4a9dfd5655818255c74dd17921da_Out_2_Float);
            float _Clamp_5b36f07b81ef6f87a93aefa8fcb815b4_Out_3_Float;
            Unity_Clamp_float(_Add_58dd4a9dfd5655818255c74dd17921da_Out_2_Float, float(0), float(1), _Clamp_5b36f07b81ef6f87a93aefa8fcb815b4_Out_3_Float);
            float _Add_5ef49a57de2cdf85b0e894bfa07f6f14_Out_2_Float;
            Unity_Add_float(_Clamp_53d91568d0627d8a9cac8deecdd003a8_Out_3_Float, _Clamp_5b36f07b81ef6f87a93aefa8fcb815b4_Out_3_Float, _Add_5ef49a57de2cdf85b0e894bfa07f6f14_Out_2_Float);
            float _Clamp_130844801cc2148bb64804d2328686eb_Out_3_Float;
            Unity_Clamp_float(_Add_5ef49a57de2cdf85b0e894bfa07f6f14_Out_2_Float, float(0), float(1), _Clamp_130844801cc2148bb64804d2328686eb_Out_3_Float);
            float _Multiply_4a38c41b77a2458085ff4ae52ba3c21c_Out_2_Float;
            Unity_Multiply_float_float(_Power_ca1f1906c90fb785bfe520b7faefc3cd_Out_2_Float, _Clamp_130844801cc2148bb64804d2328686eb_Out_3_Float, _Multiply_4a38c41b77a2458085ff4ae52ba3c21c_Out_2_Float);
            float _Multiply_edc44afd10069b8e80460ceee1cba8f0_Out_2_Float;
            Unity_Multiply_float_float(_Saturate_04686ab19029f68c8fb9e7a115b207b1_Out_1_Float, _Multiply_4a38c41b77a2458085ff4ae52ba3c21c_Out_2_Float, _Multiply_edc44afd10069b8e80460ceee1cba8f0_Out_2_Float);
            float3 _Lerp_05179f1a9a06b084b2d83e8bce908cce_Out_3_Vector3;
            Unity_Lerp_float3(_NormalBlend_9f531c87e2e45580b1d0f65f06c23526_Out_2_Vector3, _NormalStrength_c4639a6dd3dfde85b591971db2700eaf_Out_2_Vector3, (_Multiply_edc44afd10069b8e80460ceee1cba8f0_Out_2_Float.xxx), _Lerp_05179f1a9a06b084b2d83e8bce908cce_Out_3_Vector3);
            float3 _Transform_d583fb35b7a2838399ae5ff4e71be918_Out_1_Vector3;
            {
                float3x3 tangentTransform = float3x3(IN.WorldSpaceTangent, IN.WorldSpaceBiTangent, IN.WorldSpaceNormal);
                _Transform_d583fb35b7a2838399ae5ff4e71be918_Out_1_Vector3 = TransformTangentToWorldDir(_Lerp_05179f1a9a06b084b2d83e8bce908cce_Out_3_Vector3.xyz, tangentTransform, false).xyz;
            }
            float _Split_44ee9f8d0d54618cabce22ec49a8e7d3_R_1_Float = _Transform_d583fb35b7a2838399ae5ff4e71be918_Out_1_Vector3[0];
            float _Split_44ee9f8d0d54618cabce22ec49a8e7d3_G_2_Float = _Transform_d583fb35b7a2838399ae5ff4e71be918_Out_1_Vector3[1];
            float _Split_44ee9f8d0d54618cabce22ec49a8e7d3_B_3_Float = _Transform_d583fb35b7a2838399ae5ff4e71be918_Out_1_Vector3[2];
            float _Split_44ee9f8d0d54618cabce22ec49a8e7d3_A_4_Float = 0;
            float _Multiply_61fc6a92f0e952858b5d99f2caeb09a3_Out_2_Float;
            Unity_Multiply_float_float(_Split_44ee9f8d0d54618cabce22ec49a8e7d3_G_2_Float, _Clamp_815ffdd53cc1c889aa00f73784cb71e7_Out_3_Float, _Multiply_61fc6a92f0e952858b5d99f2caeb09a3_Out_2_Float);
            float _Multiply_1e7ca8eeb2afb68a96897072c537d835_Out_2_Float;
            Unity_Multiply_float_float(_Clamp_815ffdd53cc1c889aa00f73784cb71e7_Out_3_Float, _Property_4879e96694aee98c9d4ecd329a571123_Out_0_Float, _Multiply_1e7ca8eeb2afb68a96897072c537d835_Out_2_Float);
            float _Multiply_a16d49a3ef8d76899c86b7d84d20ef1f_Out_2_Float;
            Unity_Multiply_float_float(_Multiply_1e7ca8eeb2afb68a96897072c537d835_Out_2_Float, _Multiply_4a38c41b77a2458085ff4ae52ba3c21c_Out_2_Float, _Multiply_a16d49a3ef8d76899c86b7d84d20ef1f_Out_2_Float);
            float _Multiply_dd6ce40548593687a3441a83047275eb_Out_2_Float;
            Unity_Multiply_float_float(_Multiply_61fc6a92f0e952858b5d99f2caeb09a3_Out_2_Float, _Multiply_a16d49a3ef8d76899c86b7d84d20ef1f_Out_2_Float, _Multiply_dd6ce40548593687a3441a83047275eb_Out_2_Float);
            float _Clamp_a3bc14da42d1452f9459b4703c528466_Out_3_Float;
            Unity_Clamp_float(_Multiply_dd6ce40548593687a3441a83047275eb_Out_2_Float, float(0), float(1), _Clamp_a3bc14da42d1452f9459b4703c528466_Out_3_Float);
            float _Multiply_ce9d0ae57259445ba0ff1b83b3eac7be_Out_2_Float;
            Unity_Multiply_float_float(_Clamp_bb1427696ce14fe987f799fecc5f9fac_Out_3_Float, _Clamp_a3bc14da42d1452f9459b4703c528466_Out_3_Float, _Multiply_ce9d0ae57259445ba0ff1b83b3eac7be_Out_2_Float);
            #if defined(_USEDYNAMICCOVERTSTATICMASKF)
            float _UseDynamicCover_5ab22e0469924273a6c7c42f82abda85_Out_0_Float = _Multiply_ce9d0ae57259445ba0ff1b83b3eac7be_Out_2_Float;
            #else
            float _UseDynamicCover_5ab22e0469924273a6c7c42f82abda85_Out_0_Float = _Clamp_bb1427696ce14fe987f799fecc5f9fac_Out_3_Float;
            #endif
            Bindings_UniversalHeighblend_3b5c31b864970d04197cd420b6c4b0fa_float _UniversalHeighblend_21bd55d8d402489499f7ea440e52eb45;
            float _UniversalHeighblend_21bd55d8d402489499f7ea440e52eb45_Heightmap_1_Float;
            SG_UniversalHeighblend_3b5c31b864970d04197cd420b6c4b0fa_float(_Split_a80936a3c75945efb8cf9f2b95c76642_G_2_Float, _Property_14a6757619d64822a44a69b34f85276d_Out_0_Float, _Property_c0d9ffba7dee497c885a54170977d874_Out_0_Boolean, _Split_218e1cfd00b30984921b5fc0ec63de60_B_3_Float, _Add_1f9ea9bdf36544b59f763806e7eea80d_Out_2_Vector2, _Property_0fbef18600294e199eeda9905e3304e4_Out_0_Boolean, _Split_2f45bca363698c859e51492899bc58f8_B_3_Float, _Add_28628d641d58481084e9c00e4ad5fc8d_Out_2_Vector2, _UseDynamicCover_5ab22e0469924273a6c7c42f82abda85_Out_0_Float, _UniversalHeighblend_21bd55d8d402489499f7ea440e52eb45, _UniversalHeighblend_21bd55d8d402489499f7ea440e52eb45_Heightmap_1_Float);
            float _Split_05a25ef5bb1c4867950074f8c86410e8_R_1_Float = IN.VertexColor[0];
            float _Split_05a25ef5bb1c4867950074f8c86410e8_G_2_Float = IN.VertexColor[1];
            float _Split_05a25ef5bb1c4867950074f8c86410e8_B_3_Float = IN.VertexColor[2];
            float _Split_05a25ef5bb1c4867950074f8c86410e8_A_4_Float = IN.VertexColor[3];
            float _OneMinus_0527b7625ff14e8c8ca27817ac4fe9f9_Out_1_Float;
            Unity_OneMinus_float(_Split_05a25ef5bb1c4867950074f8c86410e8_B_3_Float, _OneMinus_0527b7625ff14e8c8ca27817ac4fe9f9_Out_1_Float);
            float _Property_defdd10d24ee4948b18af67062372fb7_Out_0_Float = _VertexColorBBlendStrenght;
            float _Property_f600c3fa0837403fa7000ace8a7aa949_Out_0_Boolean = _USEBaseHeightT;
            float _Property_cc1df5222a194b39870a1906a95881c7_Out_0_Boolean = _USECoverHeightT;
            float _Subtract_df32895ca10a49a6adc84378c30ceb7c_Out_2_Float;
            Unity_Subtract_float(_Property_0e120eb0a0a14b12a31a3c1f5b961121_Out_0_Float, _Property_32b48052fdbb4641bf4eeb294bc65050_Out_0_Float, _Subtract_df32895ca10a49a6adc84378c30ceb7c_Out_2_Float);
            float _Split_a090b28818f34dd8945b893c7fd769f1_R_1_Float = IN.VertexColor[0];
            float _Split_a090b28818f34dd8945b893c7fd769f1_G_2_Float = IN.VertexColor[1];
            float _Split_a090b28818f34dd8945b893c7fd769f1_B_3_Float = IN.VertexColor[2];
            float _Split_a090b28818f34dd8945b893c7fd769f1_A_4_Float = IN.VertexColor[3];
            float _OneMinus_d11f0c4a04b345419edf8e146b9c0221_Out_1_Float;
            Unity_OneMinus_float(_Split_a090b28818f34dd8945b893c7fd769f1_B_3_Float, _OneMinus_d11f0c4a04b345419edf8e146b9c0221_Out_1_Float);
            float _Multiply_b7ff184632b347e9b3d331daaed81a77_Out_2_Float;
            Unity_Multiply_float_float(_Subtract_df32895ca10a49a6adc84378c30ceb7c_Out_2_Float, _OneMinus_d11f0c4a04b345419edf8e146b9c0221_Out_1_Float, _Multiply_b7ff184632b347e9b3d331daaed81a77_Out_2_Float);
            float _Add_ff8ced5a04044788a5de3632a403c505_Out_2_Float;
            Unity_Add_float(_Property_6b467710b0ba48058e003aebe9119249_Out_0_Float, _Multiply_b7ff184632b347e9b3d331daaed81a77_Out_2_Float, _Add_ff8ced5a04044788a5de3632a403c505_Out_2_Float);
            float2 _Add_8ec067f807d04641bea7fd38ab0c8165_Out_2_Vector2;
            Unity_Add_float2(_Vector2_6955747f7f0a4ff98fae60dbada25e89_Out_0_Vector2, (_Add_ff8ced5a04044788a5de3632a403c505_Out_2_Float.xx), _Add_8ec067f807d04641bea7fd38ab0c8165_Out_2_Vector2);
            Bindings_UniversalHeighblend_3b5c31b864970d04197cd420b6c4b0fa_float _UniversalHeighblend_69e2f839a11b4aa7b8e84d65b0ac8307;
            float _UniversalHeighblend_69e2f839a11b4aa7b8e84d65b0ac8307_Heightmap_1_Float;
            SG_UniversalHeighblend_3b5c31b864970d04197cd420b6c4b0fa_float(_OneMinus_0527b7625ff14e8c8ca27817ac4fe9f9_Out_1_Float, _Property_defdd10d24ee4948b18af67062372fb7_Out_0_Float, _Property_f600c3fa0837403fa7000ace8a7aa949_Out_0_Boolean, _Split_218e1cfd00b30984921b5fc0ec63de60_B_3_Float, _Add_1f9ea9bdf36544b59f763806e7eea80d_Out_2_Vector2, _Property_cc1df5222a194b39870a1906a95881c7_Out_0_Boolean, _Split_2f45bca363698c859e51492899bc58f8_B_3_Float, _Add_8ec067f807d04641bea7fd38ab0c8165_Out_2_Vector2, float(1), _UniversalHeighblend_69e2f839a11b4aa7b8e84d65b0ac8307, _UniversalHeighblend_69e2f839a11b4aa7b8e84d65b0ac8307_Heightmap_1_Float);
            float _Add_facc0ab0661749d4bda41177c639b438_Out_2_Float;
            Unity_Add_float(_UniversalHeighblend_21bd55d8d402489499f7ea440e52eb45_Heightmap_1_Float, _UniversalHeighblend_69e2f839a11b4aa7b8e84d65b0ac8307_Heightmap_1_Float, _Add_facc0ab0661749d4bda41177c639b438_Out_2_Float);
            float _Saturate_269cfab86e2abe83819a3afa7b3eeda2_Out_1_Float;
            Unity_Saturate_float(_Add_facc0ab0661749d4bda41177c639b438_Out_2_Float, _Saturate_269cfab86e2abe83819a3afa7b3eeda2_Out_1_Float);
            float4 _Lerp_562b79f1df34b88e9a8a7431d434b435_Out_3_Vector4;
            Unity_Lerp_float4(_Combine_b0f28916143e4b94af6bec53f5328b52_RGBA_4_Vector4, _Multiply_b08794693505bd8e8c04b9ba1610d394_Out_2_Vector4, (_Saturate_269cfab86e2abe83819a3afa7b3eeda2_Out_1_Float.xxxx), _Lerp_562b79f1df34b88e9a8a7431d434b435_Out_3_Vector4);
            float4 _Property_44d9b71d47bc4d02b6d549b527e9d094_Out_0_Vector4 = _WetColor;
            float4 _Multiply_388c575a3467b88ab4d3719bf2b02ad5_Out_2_Vector4;
            Unity_Multiply_float4_float4(_Property_44d9b71d47bc4d02b6d549b527e9d094_Out_0_Vector4, _Lerp_562b79f1df34b88e9a8a7431d434b435_Out_3_Vector4, _Multiply_388c575a3467b88ab4d3719bf2b02ad5_Out_2_Vector4);
            float4 _Clamp_33ec4dd182654e108c0f4ee43f91e820_Out_3_Vector4;
            Unity_Clamp_float4(IN.VertexColor, float4(0, 0, 0, 0), float4(1, 1, 1, 1), _Clamp_33ec4dd182654e108c0f4ee43f91e820_Out_3_Vector4);
            float _Split_5b2299b48b10138ea40c141b79bfe90e_R_1_Float = _Clamp_33ec4dd182654e108c0f4ee43f91e820_Out_3_Vector4[0];
            float _Split_5b2299b48b10138ea40c141b79bfe90e_G_2_Float = _Clamp_33ec4dd182654e108c0f4ee43f91e820_Out_3_Vector4[1];
            float _Split_5b2299b48b10138ea40c141b79bfe90e_B_3_Float = _Clamp_33ec4dd182654e108c0f4ee43f91e820_Out_3_Vector4[2];
            float _Split_5b2299b48b10138ea40c141b79bfe90e_A_4_Float = _Clamp_33ec4dd182654e108c0f4ee43f91e820_Out_3_Vector4[3];
            float _OneMinus_489965dacb44928393bb0c19acfc1dad_Out_1_Float;
            Unity_OneMinus_float(_Split_5b2299b48b10138ea40c141b79bfe90e_R_1_Float, _OneMinus_489965dacb44928393bb0c19acfc1dad_Out_1_Float);
            float4 _Lerp_9f334e8d59abc78798691219f06b2fdb_Out_3_Vector4;
            Unity_Lerp_float4(_Lerp_562b79f1df34b88e9a8a7431d434b435_Out_3_Vector4, _Multiply_388c575a3467b88ab4d3719bf2b02ad5_Out_2_Vector4, (_OneMinus_489965dacb44928393bb0c19acfc1dad_Out_1_Float.xxxx), _Lerp_9f334e8d59abc78798691219f06b2fdb_Out_3_Vector4);
            #if defined(_WETNESS_T_HEAT_F)
            float4 _WetnessTHeatF_7390507dc4254612ae0a227e5143183d_Out_0_Vector4 = _Lerp_9f334e8d59abc78798691219f06b2fdb_Out_3_Vector4;
            #else
            float4 _WetnessTHeatF_7390507dc4254612ae0a227e5143183d_Out_0_Vector4 = _Lerp_562b79f1df34b88e9a8a7431d434b435_Out_3_Vector4;
            #endif
            float _Property_16c4ac023c82618b9a5117de14716c25_Out_0_Float = _CoverNormalScale;
            float3 _NormalStrength_76b1f6b709c2558a897aa152a50733b3_Out_2_Vector3;
            Unity_NormalStrength_float((_PlanarNMn_690e893d26999680a5cea3604ed0ce16_XZ_2_Vector4.xyz), _Property_16c4ac023c82618b9a5117de14716c25_Out_0_Float, _NormalStrength_76b1f6b709c2558a897aa152a50733b3_Out_2_Vector3);
            float3 _Lerp_337d63ad6393ae88af4c89b066722a45_Out_3_Vector3;
            Unity_Lerp_float3(_NormalBlend_9f531c87e2e45580b1d0f65f06c23526_Out_2_Vector3, _NormalStrength_76b1f6b709c2558a897aa152a50733b3_Out_2_Vector3, (_Saturate_269cfab86e2abe83819a3afa7b3eeda2_Out_1_Float.xxx), _Lerp_337d63ad6393ae88af4c89b066722a45_Out_3_Vector3);
            float4 Color_e553016c85254743b6051ed07aa64a6b = IsGammaSpace() ? LinearToSRGB(float4(0, 0, 0, 0)) : float4(0, 0, 0, 0);
            float _OneMinus_4d3b7f38bc644deaa5f1d244c0b9d1ee_Out_1_Float;
            Unity_OneMinus_float(_Split_218e1cfd00b30984921b5fc0ec63de60_G_2_Float, _OneMinus_4d3b7f38bc644deaa5f1d244c0b9d1ee_Out_1_Float);
            float _Split_c179bdbdbe5d44bdb614c4a9dd684f08_R_1_Float = IN.VertexColor[0];
            float _Split_c179bdbdbe5d44bdb614c4a9dd684f08_G_2_Float = IN.VertexColor[1];
            float _Split_c179bdbdbe5d44bdb614c4a9dd684f08_B_3_Float = IN.VertexColor[2];
            float _Split_c179bdbdbe5d44bdb614c4a9dd684f08_A_4_Float = IN.VertexColor[3];
            float _Clamp_0a7dd8a8d15f4e2a9eadb3d1f311e68c_Out_3_Float;
            Unity_Clamp_float(_Split_c179bdbdbe5d44bdb614c4a9dd684f08_R_1_Float, float(0), float(1), _Clamp_0a7dd8a8d15f4e2a9eadb3d1f311e68c_Out_3_Float);
            float _OneMinus_c85200bd0b22447a928d6f06eb113bb4_Out_1_Float;
            Unity_OneMinus_float(_Clamp_0a7dd8a8d15f4e2a9eadb3d1f311e68c_Out_3_Float, _OneMinus_c85200bd0b22447a928d6f06eb113bb4_Out_1_Float);
            float _Lerp_42887225ab924c5897118a743ddf24af_Out_3_Float;
            Unity_Lerp_float(float(0), _OneMinus_4d3b7f38bc644deaa5f1d244c0b9d1ee_Out_1_Float, _OneMinus_c85200bd0b22447a928d6f06eb113bb4_Out_1_Float, _Lerp_42887225ab924c5897118a743ddf24af_Out_3_Float);
            float _Property_606dc338aeef47969895771d12f2d38b_Out_0_Float = _BaseEmissionMaskIntensivity;
            float _Multiply_ce3fb5c46004495291e3a5c1c4124a48_Out_2_Float;
            Unity_Multiply_float_float(_Lerp_42887225ab924c5897118a743ddf24af_Out_3_Float, _Property_606dc338aeef47969895771d12f2d38b_Out_0_Float, _Multiply_ce3fb5c46004495291e3a5c1c4124a48_Out_2_Float);
            float _Absolute_db426b4c7ff34d91af15c6055c7523d1_Out_1_Float;
            Unity_Absolute_float(_Multiply_ce3fb5c46004495291e3a5c1c4124a48_Out_2_Float, _Absolute_db426b4c7ff34d91af15c6055c7523d1_Out_1_Float);
            float _Property_f0a12955c88c45d4839682aabc178f68_Out_0_Float = _BaseEmissionMaskTreshold;
            float _Power_948bdcff83b44a68b06dab91a4acb8aa_Out_2_Float;
            Unity_Power_float(_Absolute_db426b4c7ff34d91af15c6055c7523d1_Out_1_Float, _Property_f0a12955c88c45d4839682aabc178f68_Out_0_Float, _Power_948bdcff83b44a68b06dab91a4acb8aa_Out_2_Float);
            float _Split_f79493bbeb184f9fa903dd435dddf63e_R_1_Float = _Power_948bdcff83b44a68b06dab91a4acb8aa_Out_2_Float;
            float _Split_f79493bbeb184f9fa903dd435dddf63e_G_2_Float = 0;
            float _Split_f79493bbeb184f9fa903dd435dddf63e_B_3_Float = 0;
            float _Split_f79493bbeb184f9fa903dd435dddf63e_A_4_Float = 0;
            float _OneMinus_859309a0dff444b080fd5111ebbfdeb1_Out_1_Float;
            Unity_OneMinus_float(_Split_2f45bca363698c859e51492899bc58f8_G_2_Float, _OneMinus_859309a0dff444b080fd5111ebbfdeb1_Out_1_Float);
            float _Lerp_45c734cedcc74e2f868233751038d219_Out_3_Float;
            Unity_Lerp_float(float(0), _OneMinus_859309a0dff444b080fd5111ebbfdeb1_Out_1_Float, _OneMinus_c85200bd0b22447a928d6f06eb113bb4_Out_1_Float, _Lerp_45c734cedcc74e2f868233751038d219_Out_3_Float);
            float _Property_16d7b20087974f05a44a14a7d1d4e79b_Out_0_Float = _CoverEmissionMaskIntensivity;
            float _Multiply_624708dce85442e5bfe57d872f174df9_Out_2_Float;
            Unity_Multiply_float_float(_Lerp_45c734cedcc74e2f868233751038d219_Out_3_Float, _Property_16d7b20087974f05a44a14a7d1d4e79b_Out_0_Float, _Multiply_624708dce85442e5bfe57d872f174df9_Out_2_Float);
            float _Absolute_4b837863fc2044808429eeb18aafedae_Out_1_Float;
            Unity_Absolute_float(_Multiply_624708dce85442e5bfe57d872f174df9_Out_2_Float, _Absolute_4b837863fc2044808429eeb18aafedae_Out_1_Float);
            float _Property_2e664738eae4446c97ad4ec20f7e2028_Out_0_Float = _CoverEmissionMaskTreshold;
            float _Power_ab72ec0c8d604ed4a93dde47371091a6_Out_2_Float;
            Unity_Power_float(_Absolute_4b837863fc2044808429eeb18aafedae_Out_1_Float, _Property_2e664738eae4446c97ad4ec20f7e2028_Out_0_Float, _Power_ab72ec0c8d604ed4a93dde47371091a6_Out_2_Float);
            float _Lerp_023dc09265f14e56ae5473ca7b26294d_Out_3_Float;
            Unity_Lerp_float(_Split_f79493bbeb184f9fa903dd435dddf63e_R_1_Float, _Power_ab72ec0c8d604ed4a93dde47371091a6_Out_2_Float, _Saturate_269cfab86e2abe83819a3afa7b3eeda2_Out_1_Float, _Lerp_023dc09265f14e56ae5473ca7b26294d_Out_3_Float);
            float4 _Property_f4a77722436441c9a77e3c23dad8b88e_Out_0_Vector4 = IsGammaSpace() ? LinearToSRGB(_LavaEmissionColor) : _LavaEmissionColor;
            float4 _Multiply_4ffe85e4185949c6ac7d540068494138_Out_2_Vector4;
            Unity_Multiply_float4_float4((_Lerp_023dc09265f14e56ae5473ca7b26294d_Out_3_Float.xxxx), _Property_f4a77722436441c9a77e3c23dad8b88e_Out_0_Vector4, _Multiply_4ffe85e4185949c6ac7d540068494138_Out_2_Vector4);
            UnityTexture2D _Property_00795552653740bb881853e3daf2cf3f_Out_0_Texture2D = UnityBuildTexture2DStructNoScale(_Noise);
            float4 _Property_006d4241a7524b2583b5cc3097ff74ca_Out_0_Vector4 = _Emission_Noise_Tiling_and_Offset;
            float _Split_73d52870da5a455bb786b2c0fc9492c2_R_1_Float = _Property_006d4241a7524b2583b5cc3097ff74ca_Out_0_Vector4[0];
            float _Split_73d52870da5a455bb786b2c0fc9492c2_G_2_Float = _Property_006d4241a7524b2583b5cc3097ff74ca_Out_0_Vector4[1];
            float _Split_73d52870da5a455bb786b2c0fc9492c2_B_3_Float = _Property_006d4241a7524b2583b5cc3097ff74ca_Out_0_Vector4[2];
            float _Split_73d52870da5a455bb786b2c0fc9492c2_A_4_Float = _Property_006d4241a7524b2583b5cc3097ff74ca_Out_0_Vector4[3];
            float2 _Vector2_158f933d3fcd425392974c5cbc3cd56d_Out_0_Vector2 = float2(_Split_73d52870da5a455bb786b2c0fc9492c2_B_3_Float, _Split_73d52870da5a455bb786b2c0fc9492c2_A_4_Float);
            float2 _Property_40c7afe0030e415f8a1d31eeeb6b7393_Out_0_Vector2 = _NoiseSpeed;
            float _TimeCustomFunction_e6f001ad051b4ab78d1e2e9ddff8a244_Out_0_Float;
            Time_float(_TimeCustomFunction_e6f001ad051b4ab78d1e2e9ddff8a244_Out_0_Float);
            float2 _Multiply_8c6b65dd9b814c2da6a4483fda26ec51_Out_2_Vector2;
            Unity_Multiply_float2_float2(_Property_40c7afe0030e415f8a1d31eeeb6b7393_Out_0_Vector2, (_TimeCustomFunction_e6f001ad051b4ab78d1e2e9ddff8a244_Out_0_Float.xx), _Multiply_8c6b65dd9b814c2da6a4483fda26ec51_Out_2_Vector2);
            float2 _Add_4e8254b7e8c447d1af503ec6b1d99df6_Out_2_Vector2;
            Unity_Add_float2(_Vector2_158f933d3fcd425392974c5cbc3cd56d_Out_0_Vector2, _Multiply_8c6b65dd9b814c2da6a4483fda26ec51_Out_2_Vector2, _Add_4e8254b7e8c447d1af503ec6b1d99df6_Out_2_Vector2);
            float _Split_952b7b5a519048aeb5301164f67dd18a_R_1_Float = _Add_4e8254b7e8c447d1af503ec6b1d99df6_Out_2_Vector2[0];
            float _Split_952b7b5a519048aeb5301164f67dd18a_G_2_Float = _Add_4e8254b7e8c447d1af503ec6b1d99df6_Out_2_Vector2[1];
            float _Split_952b7b5a519048aeb5301164f67dd18a_B_3_Float = 0;
            float _Split_952b7b5a519048aeb5301164f67dd18a_A_4_Float = 0;
            float4 _Vector4_92e5675ce4234ea8a8198220bb39b015_Out_0_Vector4 = float4(_Split_73d52870da5a455bb786b2c0fc9492c2_R_1_Float, _Split_73d52870da5a455bb786b2c0fc9492c2_G_2_Float, _Split_952b7b5a519048aeb5301164f67dd18a_R_1_Float, _Split_952b7b5a519048aeb5301164f67dd18a_G_2_Float);
            float _Property_278fd9fc173e4625a1df64a92ba39390_Out_0_Boolean = _EmissionNoiseUsePlanarUV;
            float _Property_4b43a2e8035f4d20a5aa3c0d056dc9b8_Out_0_Boolean = Emission_Noise_UV0_UV3;
            Bindings_PlanarNM_c0f081da9c567704ea36e7dd38cedcf6_float _PlanarNM_9f397ccc775f4957b919b19d5b986acf;
            _PlanarNM_9f397ccc775f4957b919b19d5b986acf.AbsoluteWorldSpacePosition = IN.AbsoluteWorldSpacePosition;
            _PlanarNM_9f397ccc775f4957b919b19d5b986acf.uv0 = IN.uv0;
            _PlanarNM_9f397ccc775f4957b919b19d5b986acf.uv3 = IN.uv3;
            float4 _PlanarNM_9f397ccc775f4957b919b19d5b986acf_XZ_2_Vector4;
            SG_PlanarNM_c0f081da9c567704ea36e7dd38cedcf6_float(_Property_00795552653740bb881853e3daf2cf3f_Out_0_Texture2D, _Vector4_92e5675ce4234ea8a8198220bb39b015_Out_0_Vector4, _Property_278fd9fc173e4625a1df64a92ba39390_Out_0_Boolean, UnityBuildSamplerStateStruct(SamplerState_Linear_Repeat), _Property_4b43a2e8035f4d20a5aa3c0d056dc9b8_Out_0_Boolean, _PlanarNM_9f397ccc775f4957b919b19d5b986acf, _PlanarNM_9f397ccc775f4957b919b19d5b986acf_XZ_2_Vector4);
            float _Split_ad5f3d981abc4297be097b02598cbf16_R_1_Float = _PlanarNM_9f397ccc775f4957b919b19d5b986acf_XZ_2_Vector4[0];
            float _Split_ad5f3d981abc4297be097b02598cbf16_G_2_Float = _PlanarNM_9f397ccc775f4957b919b19d5b986acf_XZ_2_Vector4[1];
            float _Split_ad5f3d981abc4297be097b02598cbf16_B_3_Float = _PlanarNM_9f397ccc775f4957b919b19d5b986acf_XZ_2_Vector4[2];
            float _Split_ad5f3d981abc4297be097b02598cbf16_A_4_Float = _PlanarNM_9f397ccc775f4957b919b19d5b986acf_XZ_2_Vector4[3];
            float2 _Multiply_10da8cfb1b844c91b029f95ae9ec5b8f_Out_2_Vector2;
            Unity_Multiply_float2_float2(_Add_4e8254b7e8c447d1af503ec6b1d99df6_Out_2_Vector2, float2(-1.2, -0.9), _Multiply_10da8cfb1b844c91b029f95ae9ec5b8f_Out_2_Vector2);
            float2 _Add_307dce75a10243509597c2a661e556e7_Out_2_Vector2;
            Unity_Add_float2(_Multiply_10da8cfb1b844c91b029f95ae9ec5b8f_Out_2_Vector2, float2(0.5, 0.5), _Add_307dce75a10243509597c2a661e556e7_Out_2_Vector2);
            float _Split_d80e19706e9c48a69346db34ed2e1279_R_1_Float = _Add_307dce75a10243509597c2a661e556e7_Out_2_Vector2[0];
            float _Split_d80e19706e9c48a69346db34ed2e1279_G_2_Float = _Add_307dce75a10243509597c2a661e556e7_Out_2_Vector2[1];
            float _Split_d80e19706e9c48a69346db34ed2e1279_B_3_Float = 0;
            float _Split_d80e19706e9c48a69346db34ed2e1279_A_4_Float = 0;
            float4 _Vector4_96981646541d4722b5ef09551f6c683c_Out_0_Vector4 = float4(_Split_73d52870da5a455bb786b2c0fc9492c2_R_1_Float, _Split_73d52870da5a455bb786b2c0fc9492c2_G_2_Float, _Split_d80e19706e9c48a69346db34ed2e1279_R_1_Float, _Split_d80e19706e9c48a69346db34ed2e1279_G_2_Float);
            Bindings_PlanarNM_c0f081da9c567704ea36e7dd38cedcf6_float _PlanarNM_f19fcf05a02e4741a756f5cc341b4f5e;
            _PlanarNM_f19fcf05a02e4741a756f5cc341b4f5e.AbsoluteWorldSpacePosition = IN.AbsoluteWorldSpacePosition;
            _PlanarNM_f19fcf05a02e4741a756f5cc341b4f5e.uv0 = IN.uv0;
            _PlanarNM_f19fcf05a02e4741a756f5cc341b4f5e.uv3 = IN.uv3;
            float4 _PlanarNM_f19fcf05a02e4741a756f5cc341b4f5e_XZ_2_Vector4;
            SG_PlanarNM_c0f081da9c567704ea36e7dd38cedcf6_float(_Property_00795552653740bb881853e3daf2cf3f_Out_0_Texture2D, _Vector4_96981646541d4722b5ef09551f6c683c_Out_0_Vector4, _Property_278fd9fc173e4625a1df64a92ba39390_Out_0_Boolean, UnityBuildSamplerStateStruct(SamplerState_Linear_Repeat), _Property_4b43a2e8035f4d20a5aa3c0d056dc9b8_Out_0_Boolean, _PlanarNM_f19fcf05a02e4741a756f5cc341b4f5e, _PlanarNM_f19fcf05a02e4741a756f5cc341b4f5e_XZ_2_Vector4);
            float _Split_d5ec4f4d1e024709846d0576eb89bbca_R_1_Float = _PlanarNM_f19fcf05a02e4741a756f5cc341b4f5e_XZ_2_Vector4[0];
            float _Split_d5ec4f4d1e024709846d0576eb89bbca_G_2_Float = _PlanarNM_f19fcf05a02e4741a756f5cc341b4f5e_XZ_2_Vector4[1];
            float _Split_d5ec4f4d1e024709846d0576eb89bbca_B_3_Float = _PlanarNM_f19fcf05a02e4741a756f5cc341b4f5e_XZ_2_Vector4[2];
            float _Split_d5ec4f4d1e024709846d0576eb89bbca_A_4_Float = _PlanarNM_f19fcf05a02e4741a756f5cc341b4f5e_XZ_2_Vector4[3];
            float _Minimum_cd1daa7571e84585a203f83a48d8831a_Out_2_Float;
            Unity_Minimum_float(_Split_ad5f3d981abc4297be097b02598cbf16_A_4_Float, _Split_d5ec4f4d1e024709846d0576eb89bbca_A_4_Float, _Minimum_cd1daa7571e84585a203f83a48d8831a_Out_2_Float);
            float _Property_e7aef1fd7db945f2b6cf08be86efb1da_Out_0_Float = _EmissionNoiseMultiply;
            float _Multiply_36ffbb52845a491aa68eb4198a1a38e1_Out_2_Float;
            Unity_Multiply_float_float(_Minimum_cd1daa7571e84585a203f83a48d8831a_Out_2_Float, _Property_e7aef1fd7db945f2b6cf08be86efb1da_Out_0_Float, _Multiply_36ffbb52845a491aa68eb4198a1a38e1_Out_2_Float);
            float _Clamp_1406bf6d718c47639db90df3e930ec88_Out_3_Float;
            Unity_Clamp_float(_Multiply_36ffbb52845a491aa68eb4198a1a38e1_Out_2_Float, float(0), float(1), _Clamp_1406bf6d718c47639db90df3e930ec88_Out_3_Float);
            float _Absolute_25371384e8aa40f7a1a8143c24daafa7_Out_1_Float;
            Unity_Absolute_float(_Clamp_1406bf6d718c47639db90df3e930ec88_Out_3_Float, _Absolute_25371384e8aa40f7a1a8143c24daafa7_Out_1_Float);
            float _Property_b14cce2aa2354622a768385b02f85470_Out_0_Float = _EmissionNoisePower;
            float _Power_f1ee1566c8384717963cc242dd98650a_Out_2_Float;
            Unity_Power_float(_Absolute_25371384e8aa40f7a1a8143c24daafa7_Out_1_Float, _Property_b14cce2aa2354622a768385b02f85470_Out_0_Float, _Power_f1ee1566c8384717963cc242dd98650a_Out_2_Float);
            float _Multiply_34e318c6bc414a92baf58b6c0c43c29f_Out_2_Float;
            Unity_Multiply_float_float(_Power_f1ee1566c8384717963cc242dd98650a_Out_2_Float, 20, _Multiply_34e318c6bc414a92baf58b6c0c43c29f_Out_2_Float);
            float _Clamp_bec0a9e722c641748d5e70491cb9a2b2_Out_3_Float;
            Unity_Clamp_float(_Multiply_34e318c6bc414a92baf58b6c0c43c29f_Out_2_Float, float(0.05), float(1.2), _Clamp_bec0a9e722c641748d5e70491cb9a2b2_Out_3_Float);
            float4 _Multiply_7645a5b5112a49bca08420cfface3451_Out_2_Vector4;
            Unity_Multiply_float4_float4(_Multiply_4ffe85e4185949c6ac7d540068494138_Out_2_Vector4, (_Clamp_bec0a9e722c641748d5e70491cb9a2b2_Out_3_Float.xxxx), _Multiply_7645a5b5112a49bca08420cfface3451_Out_2_Vector4);
            float4 _Property_ca86ca33c2ae4885ba38452d9e56a7e5_Out_0_Vector4 = IsGammaSpace() ? LinearToSRGB(_RimColor) : _RimColor;
            float3 _Normalize_c4982c8cad634f628b5c428f3d903c7d_Out_1_Vector3;
            Unity_Normalize_float3(IN.TangentSpaceViewDirection, _Normalize_c4982c8cad634f628b5c428f3d903c7d_Out_1_Vector3);
            float _DotProduct_159813334d0546d1b48a9b61ad70a171_Out_2_Float;
            Unity_DotProduct_float3(_Lerp_337d63ad6393ae88af4c89b066722a45_Out_3_Vector3, _Normalize_c4982c8cad634f628b5c428f3d903c7d_Out_1_Vector3, _DotProduct_159813334d0546d1b48a9b61ad70a171_Out_2_Float);
            float _Saturate_5a5aac19081c4d4b8903fc7860f9a0c2_Out_1_Float;
            Unity_Saturate_float(_DotProduct_159813334d0546d1b48a9b61ad70a171_Out_2_Float, _Saturate_5a5aac19081c4d4b8903fc7860f9a0c2_Out_1_Float);
            float _OneMinus_ef8f9d7083b54e2885c1382b817e2652_Out_1_Float;
            Unity_OneMinus_float(_Saturate_5a5aac19081c4d4b8903fc7860f9a0c2_Out_1_Float, _OneMinus_ef8f9d7083b54e2885c1382b817e2652_Out_1_Float);
            float _Absolute_f6a29424054e4847b2545876315446e9_Out_1_Float;
            Unity_Absolute_float(_OneMinus_ef8f9d7083b54e2885c1382b817e2652_Out_1_Float, _Absolute_f6a29424054e4847b2545876315446e9_Out_1_Float);
            float _Power_57bee61abc694e7d8946acd86e5c7471_Out_2_Float;
            Unity_Power_float(_Absolute_f6a29424054e4847b2545876315446e9_Out_1_Float, float(10), _Power_57bee61abc694e7d8946acd86e5c7471_Out_2_Float);
            float4 _Multiply_8bcb4ce8918a4b2a9e321cfb7b2212ed_Out_2_Vector4;
            Unity_Multiply_float4_float4(_Property_ca86ca33c2ae4885ba38452d9e56a7e5_Out_0_Vector4, (_Power_57bee61abc694e7d8946acd86e5c7471_Out_2_Float.xxxx), _Multiply_8bcb4ce8918a4b2a9e321cfb7b2212ed_Out_2_Vector4);
            float _Property_aee69b4a68284a749ad0eeb6f13105cd_Out_0_Float = _RimLightPower;
            float4 _Multiply_5626d1059bb54a5e9499b3f53d1b5904_Out_2_Vector4;
            Unity_Multiply_float4_float4(_Multiply_8bcb4ce8918a4b2a9e321cfb7b2212ed_Out_2_Vector4, (_Property_aee69b4a68284a749ad0eeb6f13105cd_Out_0_Float.xxxx), _Multiply_5626d1059bb54a5e9499b3f53d1b5904_Out_2_Vector4);
            float4 _Multiply_c4b66106a8a0468aab2f1323013186d7_Out_2_Vector4;
            Unity_Multiply_float4_float4((_Lerp_023dc09265f14e56ae5473ca7b26294d_Out_3_Float.xxxx), _Multiply_5626d1059bb54a5e9499b3f53d1b5904_Out_2_Vector4, _Multiply_c4b66106a8a0468aab2f1323013186d7_Out_2_Vector4);
            float4 _Add_74f0b45c2e704e74a319f41d62506eed_Out_2_Vector4;
            Unity_Add_float4(_Multiply_7645a5b5112a49bca08420cfface3451_Out_2_Vector4, _Multiply_c4b66106a8a0468aab2f1323013186d7_Out_2_Vector4, _Add_74f0b45c2e704e74a319f41d62506eed_Out_2_Vector4);
            float4 _Clamp_cacf98ce9e9044c4986500fac50caa89_Out_3_Vector4;
            Unity_Clamp_float4(_Add_74f0b45c2e704e74a319f41d62506eed_Out_2_Vector4, float4(0, 0, 0, 0), _Add_74f0b45c2e704e74a319f41d62506eed_Out_2_Vector4, _Clamp_cacf98ce9e9044c4986500fac50caa89_Out_3_Vector4);
            #if defined(_WETNESS_T_HEAT_F)
            float4 _WetnessTHeatF_e4281f82d9f54deca38dcc29b0789b9b_Out_0_Vector4 = Color_e553016c85254743b6051ed07aa64a6b;
            #else
            float4 _WetnessTHeatF_e4281f82d9f54deca38dcc29b0789b9b_Out_0_Vector4 = _Clamp_cacf98ce9e9044c4986500fac50caa89_Out_3_Vector4;
            #endif
            float _Property_bbb7f63dc018f9828732f80495a95444_Out_0_Float = _BaseMetallic;
            float _Multiply_ee089bb3595c0c8da7ca2ff054def6d5_Out_2_Float;
            Unity_Multiply_float_float(_Split_218e1cfd00b30984921b5fc0ec63de60_R_1_Float, _Property_bbb7f63dc018f9828732f80495a95444_Out_0_Float, _Multiply_ee089bb3595c0c8da7ca2ff054def6d5_Out_2_Float);
            float _Property_8142f12b781ad08680220297dab56f14_Out_0_Float = _BaseAORemapMin;
            float _Property_48e1c5285b48c78e8af19e38f4bd77f9_Out_0_Float = _BaseAORemapMax;
            float2 _Vector2_344526038e228b85ad9c2d33f000c5ea_Out_0_Vector2 = float2(_Property_8142f12b781ad08680220297dab56f14_Out_0_Float, _Property_48e1c5285b48c78e8af19e38f4bd77f9_Out_0_Float);
            float _Remap_f4684fae31257d82aa14c39233760e21_Out_3_Float;
            Unity_Remap_float(_Split_218e1cfd00b30984921b5fc0ec63de60_G_2_Float, float2 (0, 1), _Vector2_344526038e228b85ad9c2d33f000c5ea_Out_0_Vector2, _Remap_f4684fae31257d82aa14c39233760e21_Out_3_Float);
            float _Property_0682b9e13137ec8f8de23962e6db211c_Out_0_Float = _BaseSmoothnessRemapMin;
            float _Property_0edea7916ed7a189a62b0faf2c274601_Out_0_Float = _BaseSmoothnessRemapMax;
            float2 _Vector2_8d45bee64b64f087b44fb9b02317dfdd_Out_0_Vector2 = float2(_Property_0682b9e13137ec8f8de23962e6db211c_Out_0_Float, _Property_0edea7916ed7a189a62b0faf2c274601_Out_0_Float);
            float _Remap_857d26677c8e8a809704b89dbca71045_Out_3_Float;
            Unity_Remap_float(_Split_218e1cfd00b30984921b5fc0ec63de60_A_4_Float, float2 (0, 1), _Vector2_8d45bee64b64f087b44fb9b02317dfdd_Out_0_Vector2, _Remap_857d26677c8e8a809704b89dbca71045_Out_3_Float);
            float _Multiply_0248fa77a8136c81b6e9a6bbf4b8ae44_Out_2_Float;
            Unity_Multiply_float_float(_SampleTexture2D_d8eb0186b9a0cd819cde65431b4ea5ea_B_6_Float, 2, _Multiply_0248fa77a8136c81b6e9a6bbf4b8ae44_Out_2_Float);
            float _Add_c58fd9db8613298bb7c10a8054cbe39a_Out_2_Float;
            Unity_Add_float(_Multiply_0248fa77a8136c81b6e9a6bbf4b8ae44_Out_2_Float, float(-1), _Add_c58fd9db8613298bb7c10a8054cbe39a_Out_2_Float);
            float _Property_cea4e47b293a988a83643b43f76c92ba_Out_0_Float = _DetailSmoothnessScale;
            float _Multiply_2008466558f0e4819e60b3c41d94487c_Out_2_Float;
            Unity_Multiply_float_float(_Add_c58fd9db8613298bb7c10a8054cbe39a_Out_2_Float, _Property_cea4e47b293a988a83643b43f76c92ba_Out_0_Float, _Multiply_2008466558f0e4819e60b3c41d94487c_Out_2_Float);
            float _Saturate_3d70f31d57bf638291bde1017f7f7782_Out_1_Float;
            Unity_Saturate_float(_Multiply_2008466558f0e4819e60b3c41d94487c_Out_2_Float, _Saturate_3d70f31d57bf638291bde1017f7f7782_Out_1_Float);
            float _Absolute_9df346239512598fa5a33dfdc91746c0_Out_1_Float;
            Unity_Absolute_float(_Saturate_3d70f31d57bf638291bde1017f7f7782_Out_1_Float, _Absolute_9df346239512598fa5a33dfdc91746c0_Out_1_Float);
            Bindings_BlendOverlayDetailSmoothness_06e12138dc89c0040b45a57abe520a1a_float _BlendOverlayDetailSmoothness_bf930d30c7c40486b65597615e35de43;
            float _BlendOverlayDetailSmoothness_bf930d30c7c40486b65597615e35de43_SmoothnessOverlay_1_Float;
            SG_BlendOverlayDetailSmoothness_06e12138dc89c0040b45a57abe520a1a_float(_Remap_857d26677c8e8a809704b89dbca71045_Out_3_Float, _Add_c58fd9db8613298bb7c10a8054cbe39a_Out_2_Float, _Absolute_9df346239512598fa5a33dfdc91746c0_Out_1_Float, _BlendOverlayDetailSmoothness_bf930d30c7c40486b65597615e35de43, _BlendOverlayDetailSmoothness_bf930d30c7c40486b65597615e35de43_SmoothnessOverlay_1_Float);
            float _Saturate_52f6692b8656668b837aebcf2f45f921_Out_1_Float;
            Unity_Saturate_float(_BlendOverlayDetailSmoothness_bf930d30c7c40486b65597615e35de43_SmoothnessOverlay_1_Float, _Saturate_52f6692b8656668b837aebcf2f45f921_Out_1_Float);
            float3 _Vector3_1f83d62db7392b81beeecb62c44f56c5_Out_0_Vector3 = float3(_Multiply_ee089bb3595c0c8da7ca2ff054def6d5_Out_2_Float, _Remap_f4684fae31257d82aa14c39233760e21_Out_3_Float, _Saturate_52f6692b8656668b837aebcf2f45f921_Out_1_Float);
            float _Property_0187ddd5583a3d86a3c4c2444b45e777_Out_0_Float = _CoverMetallic;
            float _Multiply_0248a4a17e4abe868ff7c5ec2a5c8d2f_Out_2_Float;
            Unity_Multiply_float_float(_Split_2f45bca363698c859e51492899bc58f8_R_1_Float, _Property_0187ddd5583a3d86a3c4c2444b45e777_Out_0_Float, _Multiply_0248a4a17e4abe868ff7c5ec2a5c8d2f_Out_2_Float);
            float _Property_5cc07bc49e1bf582b5c1b52606eec56f_Out_0_Float = _CoverAORemapMin;
            float _Property_506cf024c6db098fbc150277952a7bee_Out_0_Float = _CoverAORemapMax;
            float2 _Vector2_ffa116a725445282a83acc70377ff4e1_Out_0_Vector2 = float2(_Property_5cc07bc49e1bf582b5c1b52606eec56f_Out_0_Float, _Property_506cf024c6db098fbc150277952a7bee_Out_0_Float);
            float _Remap_02e4c7480ddeca88aa886be18ce15353_Out_3_Float;
            Unity_Remap_float(_Split_2f45bca363698c859e51492899bc58f8_G_2_Float, float2 (0, 1), _Vector2_ffa116a725445282a83acc70377ff4e1_Out_0_Vector2, _Remap_02e4c7480ddeca88aa886be18ce15353_Out_3_Float);
            float _Property_36782180ac25b489baf611efb6d0d9ed_Out_0_Float = _CoverSmoothnessRemapMin;
            float _Property_6c0666df4add418b8e32b0e4275b1c27_Out_0_Float = _CoverSmoothnessRemapMax;
            float2 _Vector2_b0c047c56338e78abcd740717a8d6900_Out_0_Vector2 = float2(_Property_36782180ac25b489baf611efb6d0d9ed_Out_0_Float, _Property_6c0666df4add418b8e32b0e4275b1c27_Out_0_Float);
            float _Remap_1f96cc6fc648098f8cb49680f75d5a1e_Out_3_Float;
            Unity_Remap_float(_Split_2f45bca363698c859e51492899bc58f8_A_4_Float, float2 (0, 1), _Vector2_b0c047c56338e78abcd740717a8d6900_Out_0_Vector2, _Remap_1f96cc6fc648098f8cb49680f75d5a1e_Out_3_Float);
            float3 _Vector3_48cf085b9f7fd28e89fe4361decf0fec_Out_0_Vector3 = float3(_Multiply_0248a4a17e4abe868ff7c5ec2a5c8d2f_Out_2_Float, _Remap_02e4c7480ddeca88aa886be18ce15353_Out_3_Float, _Remap_1f96cc6fc648098f8cb49680f75d5a1e_Out_3_Float);
            float3 _Lerp_48cc6a544b837c85a967cc83aab4e3fb_Out_3_Vector3;
            Unity_Lerp_float3(_Vector3_1f83d62db7392b81beeecb62c44f56c5_Out_0_Vector3, _Vector3_48cf085b9f7fd28e89fe4361decf0fec_Out_0_Vector3, (_Saturate_269cfab86e2abe83819a3afa7b3eeda2_Out_1_Float.xxx), _Lerp_48cc6a544b837c85a967cc83aab4e3fb_Out_3_Vector3);
            float _Split_645358fc1f0e278fbfc2ccb5594c95e3_R_1_Float = _Lerp_48cc6a544b837c85a967cc83aab4e3fb_Out_3_Vector3[0];
            float _Split_645358fc1f0e278fbfc2ccb5594c95e3_G_2_Float = _Lerp_48cc6a544b837c85a967cc83aab4e3fb_Out_3_Vector3[1];
            float _Split_645358fc1f0e278fbfc2ccb5594c95e3_B_3_Float = _Lerp_48cc6a544b837c85a967cc83aab4e3fb_Out_3_Vector3[2];
            float _Split_645358fc1f0e278fbfc2ccb5594c95e3_A_4_Float = 0;
            float _Property_006bb9304a39f5808cf13865f8c36ad4_Out_0_Float = _WetSmoothness;
            float _Lerp_02403a8fb24f4c8fb8bd6dbe84811d9a_Out_3_Float;
            Unity_Lerp_float(_Split_645358fc1f0e278fbfc2ccb5594c95e3_B_3_Float, _Property_006bb9304a39f5808cf13865f8c36ad4_Out_0_Float, _OneMinus_489965dacb44928393bb0c19acfc1dad_Out_1_Float, _Lerp_02403a8fb24f4c8fb8bd6dbe84811d9a_Out_3_Float);
            #if defined(_WETNESS_T_HEAT_F)
            float _WetnessTHeatF_a6ec97cf99bb4b93a57ba2146f13f8ef_Out_0_Float = _Lerp_02403a8fb24f4c8fb8bd6dbe84811d9a_Out_3_Float;
            #else
            float _WetnessTHeatF_a6ec97cf99bb4b93a57ba2146f13f8ef_Out_0_Float = _Split_645358fc1f0e278fbfc2ccb5594c95e3_B_3_Float;
            #endif
            float _Split_546cdec490fe4753bb0983eea82b45b5_R_1_Float = _Lerp_562b79f1df34b88e9a8a7431d434b435_Out_3_Vector4[0];
            float _Split_546cdec490fe4753bb0983eea82b45b5_G_2_Float = _Lerp_562b79f1df34b88e9a8a7431d434b435_Out_3_Vector4[1];
            float _Split_546cdec490fe4753bb0983eea82b45b5_B_3_Float = _Lerp_562b79f1df34b88e9a8a7431d434b435_Out_3_Vector4[2];
            float _Split_546cdec490fe4753bb0983eea82b45b5_A_4_Float = _Lerp_562b79f1df34b88e9a8a7431d434b435_Out_3_Vector4[3];
            float _Multiply_a7796e97d268424b880f9cb87fc6e42c_Out_2_Float;
            Unity_Multiply_float_float(_Split_546cdec490fe4753bb0983eea82b45b5_A_4_Float, _Split_5b2299b48b10138ea40c141b79bfe90e_A_4_Float, _Multiply_a7796e97d268424b880f9cb87fc6e42c_Out_2_Float);
            float _Property_7ae68b65d6ed4f37aec08ecb89701e8e_Out_0_Float = _AlphaCutoff;
            surface.BaseColor = (_WetnessTHeatF_7390507dc4254612ae0a227e5143183d_Out_0_Vector4.xyz);
            surface.NormalTS = _Lerp_337d63ad6393ae88af4c89b066722a45_Out_3_Vector3;
            surface.Emission = (_WetnessTHeatF_e4281f82d9f54deca38dcc29b0789b9b_Out_0_Vector4.xyz);
            surface.Metallic = _Split_645358fc1f0e278fbfc2ccb5594c95e3_R_1_Float;
            surface.Specular = IsGammaSpace() ? float3(0.5, 0.5, 0.5) : SRGBToLinear(float3(0.5, 0.5, 0.5));
            surface.Smoothness = _WetnessTHeatF_a6ec97cf99bb4b93a57ba2146f13f8ef_Out_0_Float;
            surface.Occlusion = _Split_645358fc1f0e278fbfc2ccb5594c95e3_G_2_Float;
            surface.Alpha = _Multiply_a7796e97d268424b880f9cb87fc6e42c_Out_2_Float;
            surface.AlphaClipThreshold = _Property_7ae68b65d6ed4f37aec08ecb89701e8e_Out_0_Float;
            return surface;
        }
        
        // --------------------------------------------------
        // Build Graph Inputs
        #ifdef HAVE_VFX_MODIFICATION
        #define VFX_SRP_ATTRIBUTES Attributes
        #define VFX_SRP_VARYINGS Varyings
        #define VFX_SRP_SURFACE_INPUTS SurfaceDescriptionInputs
        #endif
        VertexDescriptionInputs BuildVertexDescriptionInputs(Attributes input)
        {
            VertexDescriptionInputs output;
            ZERO_INITIALIZE(VertexDescriptionInputs, output);
        
            output.ObjectSpaceNormal =                          input.normalOS;
            output.ObjectSpaceTangent =                         input.tangentOS.xyz;
            output.ObjectSpacePosition =                        input.positionOS;
        #if UNITY_ANY_INSTANCING_ENABLED
        #else // TODO: XR support for procedural instancing because in this case UNITY_ANY_INSTANCING_ENABLED is not defined and instanceID is incorrect.
        #endif
        
            return output;
        }
        SurfaceDescriptionInputs BuildSurfaceDescriptionInputs(Varyings input)
        {
            SurfaceDescriptionInputs output;
            ZERO_INITIALIZE(SurfaceDescriptionInputs, output);
        
        #ifdef HAVE_VFX_MODIFICATION
        #if VFX_USE_GRAPH_VALUES
            uint instanceActiveIndex = asuint(UNITY_ACCESS_INSTANCED_PROP(PerInstance, _InstanceActiveIndex));
            /* WARNING: $splice Could not find named fragment 'VFXLoadGraphValues' */
        #endif
            /* WARNING: $splice Could not find named fragment 'VFXSetFragInputs' */
        
        #endif
        
            
        
            // must use interpolated tangent, bitangent and normal before they are normalized in the pixel shader.
            float3 unnormalizedNormalWS = input.normalWS;
            const float renormFactor = 1.0 / length(unnormalizedNormalWS);
        
            // use bitangent on the fly like in hdrp
            // IMPORTANT! If we ever support Flip on double sided materials ensure bitangent and tangent are NOT flipped.
            float crossSign = (input.tangentWS.w > 0.0 ? 1.0 : -1.0)* GetOddNegativeScale();
            float3 bitang = crossSign * cross(input.normalWS.xyz, input.tangentWS.xyz);
        
            output.WorldSpaceNormal = renormFactor * input.normalWS.xyz;      // we want a unit length Normal Vector node in shader graph
            output.TangentSpaceNormal = float3(0.0f, 0.0f, 1.0f);
        
            // to pr               eserve mikktspace compliance we use same scale renormFactor as was used on the normal.
            // This                is explained in section 2.2 in "surface gradient based bump mapping framework"
            output.WorldSpaceTangent = renormFactor * input.tangentWS.xyz;
            output.WorldSpaceBiTangent = renormFactor * bitang;
        
            output.WorldSpaceViewDirection = GetWorldSpaceNormalizeViewDir(input.positionWS);
            float3x3 tangentSpaceTransform = float3x3(output.WorldSpaceTangent, output.WorldSpaceBiTangent, output.WorldSpaceNormal);
            output.TangentSpaceViewDirection = mul(tangentSpaceTransform, output.WorldSpaceViewDirection);
            output.AbsoluteWorldSpacePosition = GetAbsolutePositionWS(input.positionWS);
        
            #if UNITY_UV_STARTS_AT_TOP
            #else
            #endif
        
        
            output.uv0 = input.texCoord0;
            output.uv3 = input.texCoord3;
            output.VertexColor = input.color;
        #if UNITY_ANY_INSTANCING_ENABLED
        #else // TODO: XR support for procedural instancing because in this case UNITY_ANY_INSTANCING_ENABLED is not defined and instanceID is incorrect.
        #endif
        #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
        #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN output.FaceSign =                    IS_FRONT_VFACE(input.cullFace, true, false);
        #else
        #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
        #endif
        #undef BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
        
                return output;
        }
        
        // --------------------------------------------------
        // Main
        
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/Varyings.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/PBRForwardPass.hlsl"
        
        // --------------------------------------------------
        // Visual Effect Vertex Invocations
        #ifdef HAVE_VFX_MODIFICATION
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/VisualEffectVertex.hlsl"
        #endif
        
        ENDHLSL
        }
        Pass
        {
            Name "GBuffer"
            Tags
            {
                "LightMode" = "UniversalGBuffer"
            }
        
        // Render State
        Cull [_Cull]
        Blend [_SrcBlend] [_DstBlend], [_SrcBlendAlpha] [_DstBlendAlpha]
        ZTest [_ZTest]
        ZWrite [_ZWrite]
        
        // Debug
        // <None>
        
        // --------------------------------------------------
        // Pass
        
        HLSLPROGRAM
        
        // Pragmas
        #pragma target 4.5
        #pragma exclude_renderers gles3 glcore
        #pragma multi_compile_instancing
        #pragma instancing_options renderinglayer
        #pragma vertex vert
        #pragma fragment frag
        
        // Keywords
        #pragma multi_compile_fragment _ _SCREEN_SPACE_IRRADIANCE
        #pragma multi_compile _ LIGHTMAP_ON
        #pragma multi_compile _ DYNAMICLIGHTMAP_ON
        #pragma multi_compile _ DIRLIGHTMAP_COMBINED
        #pragma multi_compile _ USE_LEGACY_LIGHTMAPS
        #pragma multi_compile _ LIGHTMAP_BICUBIC_SAMPLING
        #pragma multi_compile _ REFLECTION_PROBE_ROTATION
        #pragma multi_compile _ _MAIN_LIGHT_SHADOWS _MAIN_LIGHT_SHADOWS_CASCADE _MAIN_LIGHT_SHADOWS_SCREEN
        #pragma multi_compile_fragment _ _REFLECTION_PROBE_BLENDING
        #pragma multi_compile_fragment _ _REFLECTION_PROBE_BOX_PROJECTION
        #pragma multi_compile_fragment _ _SHADOWS_SOFT _SHADOWS_SOFT_LOW _SHADOWS_SOFT_MEDIUM _SHADOWS_SOFT_HIGH
        #pragma multi_compile _ LIGHTMAP_SHADOW_MIXING
        #pragma multi_compile _ SHADOWS_SHADOWMASK
        #pragma multi_compile _ _MIXED_LIGHTING_SUBTRACTIVE
        #pragma multi_compile_fragment _ _DBUFFER_MRT1 _DBUFFER_MRT2 _DBUFFER_MRT3
        #pragma multi_compile_fragment _ _GBUFFER_NORMALS_OCT
        #pragma multi_compile_fragment _ _RENDER_PASS_ENABLED
        #pragma multi_compile_fragment _ DEBUG_DISPLAY
        #pragma multi_compile _ _CLUSTER_LIGHT_LOOP
        #pragma shader_feature_fragment _ _SURFACE_TYPE_TRANSPARENT
        #pragma shader_feature_local_fragment _ _ALPHAPREMULTIPLY_ON
        #pragma shader_feature_local_fragment _ _ALPHAMODULATE_ON
        #pragma shader_feature_local_fragment _ _ALPHATEST_ON
        #pragma shader_feature_local_fragment _ _SPECULAR_SETUP
        #pragma shader_feature_local _ _RECEIVE_SHADOWS_OFF
        #pragma multi_compile _ LOD_FADE_CROSSFADE
        #pragma shader_feature_local _ _USEDYNAMICCOVERTSTATICMASKF
        #pragma shader_feature_local _ _WETNESS_T_HEAT_F
        
        #if defined(_USEDYNAMICCOVERTSTATICMASKF) && defined(_WETNESS_T_HEAT_F)
            #define KEYWORD_PERMUTATION_0
        #elif defined(_USEDYNAMICCOVERTSTATICMASKF)
            #define KEYWORD_PERMUTATION_1
        #elif defined(_WETNESS_T_HEAT_F)
            #define KEYWORD_PERMUTATION_2
        #else
            #define KEYWORD_PERMUTATION_3
        #endif
        
        
        // Defines
        
        #define _NORMALMAP 1
        #define _NORMAL_DROPOFF_TS 1
        #define ATTRIBUTES_NEED_NORMAL
        #define ATTRIBUTES_NEED_TANGENT
        #define ATTRIBUTES_NEED_TEXCOORD0
        #define ATTRIBUTES_NEED_TEXCOORD1
        #define ATTRIBUTES_NEED_TEXCOORD2
        #define ATTRIBUTES_NEED_TEXCOORD3
        #define ATTRIBUTES_NEED_COLOR
        #define FEATURES_GRAPH_VERTEX_NORMAL_OUTPUT
        #define FEATURES_GRAPH_VERTEX_TANGENT_OUTPUT
        #define VARYINGS_NEED_POSITION_WS
        #define VARYINGS_NEED_NORMAL_WS
        #define VARYINGS_NEED_TANGENT_WS
        #define VARYINGS_NEED_TEXCOORD0
        #define VARYINGS_NEED_TEXCOORD3
        #define VARYINGS_NEED_COLOR
        #define VARYINGS_NEED_FOG_AND_VERTEX_LIGHT
        #define VARYINGS_NEED_SHADOW_COORD
        #define FEATURES_GRAPH_VERTEX
        /* WARNING: $splice Could not find named fragment 'PassInstancing' */
        #define SHADERPASS SHADERPASS_GBUFFER
        #define _FOG_FRAGMENT 1
        #define USE_UNITY_CROSSFADE 1
        
        
        // custom interpolator pre-include
        /* WARNING: $splice Could not find named fragment 'sgci_CustomInterpolatorPreInclude' */
        
        // Includes
        #include_with_pragmas "Packages/com.unity.render-pipelines.universal/ShaderLibrary/DOTS.hlsl"
        #include_with_pragmas "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Fog.hlsl"
        #include_with_pragmas "Packages/com.unity.render-pipelines.universal/ShaderLibrary/RenderingLayers.hlsl"
        #include_with_pragmas "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ProbeVolumeVariants.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Texture.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
        #include_with_pragmas "Packages/com.unity.render-pipelines.core/ShaderLibrary/FoveatedRenderingKeywords.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/FoveatedRendering.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Input.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/TextureStack.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/DebugMipmapStreamingMacros.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Shadows.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/DBuffer.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShaderPass.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/LODCrossFade.hlsl"
        
        // --------------------------------------------------
        // Structs and Packing
        
        // custom interpolators pre packing
        /* WARNING: $splice Could not find named fragment 'CustomInterpolatorPrePacking' */
        
        struct Attributes
        {
             float3 positionOS : POSITION;
             float3 normalOS : NORMAL;
             float4 tangentOS : TANGENT;
             float4 uv0 : TEXCOORD0;
             float4 uv1 : TEXCOORD1;
             float4 uv2 : TEXCOORD2;
             float4 uv3 : TEXCOORD3;
             float4 color : COLOR;
            #if UNITY_ANY_INSTANCING_ENABLED || defined(ATTRIBUTES_NEED_INSTANCEID)
             uint instanceID : INSTANCEID_SEMANTIC;
            #endif
        };
        struct Varyings
        {
             float4 positionCS : SV_POSITION;
             float3 positionWS;
             float3 normalWS;
             float4 tangentWS;
             float4 texCoord0;
             float4 texCoord3;
             float4 color;
            #if defined(LIGHTMAP_ON)
             float2 staticLightmapUV;
            #endif
            #if defined(DYNAMICLIGHTMAP_ON)
             float2 dynamicLightmapUV;
            #endif
            #if !defined(LIGHTMAP_ON)
             float3 sh;
            #endif
            #if defined(USE_APV_PROBE_OCCLUSION)
             float4 probeOcclusion;
            #endif
             float4 fogFactorAndVertexLight;
            #if defined(REQUIRES_VERTEX_SHADOW_COORD_INTERPOLATOR)
             float4 shadowCoord;
            #endif
            #if UNITY_ANY_INSTANCING_ENABLED || defined(VARYINGS_NEED_INSTANCEID)
             uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
             uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
             uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
             FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
        };
        struct SurfaceDescriptionInputs
        {
             float3 WorldSpaceNormal;
             float3 TangentSpaceNormal;
             float3 WorldSpaceTangent;
             float3 WorldSpaceBiTangent;
             float3 WorldSpaceViewDirection;
             float3 TangentSpaceViewDirection;
             float3 AbsoluteWorldSpacePosition;
             float4 uv0;
             float4 uv3;
             float4 VertexColor;
        };
        struct VertexDescriptionInputs
        {
             float3 ObjectSpaceNormal;
             float3 ObjectSpaceTangent;
             float3 ObjectSpacePosition;
        };
        struct PackedVaryings
        {
             float4 positionCS : SV_POSITION;
            #if defined(LIGHTMAP_ON)
             float2 staticLightmapUV : INTERP0;
            #endif
            #if defined(DYNAMICLIGHTMAP_ON)
             float2 dynamicLightmapUV : INTERP1;
            #endif
            #if !defined(LIGHTMAP_ON)
             float3 sh : INTERP2;
            #endif
            #if defined(USE_APV_PROBE_OCCLUSION)
             float4 probeOcclusion : INTERP3;
            #endif
            #if defined(REQUIRES_VERTEX_SHADOW_COORD_INTERPOLATOR)
             float4 shadowCoord : INTERP4;
            #endif
             float4 tangentWS : INTERP5;
             float4 texCoord0 : INTERP6;
             float4 texCoord3 : INTERP7;
             float4 color : INTERP8;
             float4 fogFactorAndVertexLight : INTERP9;
             float3 positionWS : INTERP10;
             float3 normalWS : INTERP11;
            #if UNITY_ANY_INSTANCING_ENABLED || defined(VARYINGS_NEED_INSTANCEID)
             uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
             uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
             uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
             FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
        };
        
        PackedVaryings PackVaryings (Varyings input)
        {
            PackedVaryings output;
            ZERO_INITIALIZE(PackedVaryings, output);
            output.positionCS = input.positionCS;
            #if defined(LIGHTMAP_ON)
            output.staticLightmapUV = input.staticLightmapUV;
            #endif
            #if defined(DYNAMICLIGHTMAP_ON)
            output.dynamicLightmapUV = input.dynamicLightmapUV;
            #endif
            #if !defined(LIGHTMAP_ON)
            output.sh = input.sh;
            #endif
            #if defined(USE_APV_PROBE_OCCLUSION)
            output.probeOcclusion = input.probeOcclusion;
            #endif
            #if defined(REQUIRES_VERTEX_SHADOW_COORD_INTERPOLATOR)
            output.shadowCoord = input.shadowCoord;
            #endif
            output.tangentWS.xyzw = input.tangentWS;
            output.texCoord0.xyzw = input.texCoord0;
            output.texCoord3.xyzw = input.texCoord3;
            output.color.xyzw = input.color;
            output.fogFactorAndVertexLight.xyzw = input.fogFactorAndVertexLight;
            output.positionWS.xyz = input.positionWS;
            output.normalWS.xyz = input.normalWS;
            #if UNITY_ANY_INSTANCING_ENABLED || defined(VARYINGS_NEED_INSTANCEID)
            output.instanceID = input.instanceID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            output.cullFace = input.cullFace;
            #endif
            return output;
        }
        
        Varyings UnpackVaryings (PackedVaryings input)
        {
            Varyings output;
            output.positionCS = input.positionCS;
            #if defined(LIGHTMAP_ON)
            output.staticLightmapUV = input.staticLightmapUV;
            #endif
            #if defined(DYNAMICLIGHTMAP_ON)
            output.dynamicLightmapUV = input.dynamicLightmapUV;
            #endif
            #if !defined(LIGHTMAP_ON)
            output.sh = input.sh;
            #endif
            #if defined(USE_APV_PROBE_OCCLUSION)
            output.probeOcclusion = input.probeOcclusion;
            #endif
            #if defined(REQUIRES_VERTEX_SHADOW_COORD_INTERPOLATOR)
            output.shadowCoord = input.shadowCoord;
            #endif
            output.tangentWS = input.tangentWS.xyzw;
            output.texCoord0 = input.texCoord0.xyzw;
            output.texCoord3 = input.texCoord3.xyzw;
            output.color = input.color.xyzw;
            output.fogFactorAndVertexLight = input.fogFactorAndVertexLight.xyzw;
            output.positionWS = input.positionWS.xyz;
            output.normalWS = input.normalWS.xyz;
            #if UNITY_ANY_INSTANCING_ENABLED || defined(VARYINGS_NEED_INSTANCEID)
            output.instanceID = input.instanceID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            output.cullFace = input.cullFace;
            #endif
            return output;
        }
        
        
        // --------------------------------------------------
        // Graph
        
        // Graph Properties
        CBUFFER_START(UnityPerMaterial)
        float _EmissionNoiseMultiply;
        float _EmissionNoisePower;
        float Emission_Noise_UV0_UV3;
        float _EmissionNoiseUsePlanarUV;
        float _BaseEmissionMaskTreshold;
        float _CoverEmissionMaskIntensivity;
        float _CoverEmissionMaskTreshold;
        float4 _RimColor;
        float _RimLightPower;
        float4 _Noise_TexelSize;
        float2 _NoiseSpeed;
        float _BaseEmissionMaskIntensivity;
        float4 _LavaEmissionColor;
        float4 _Emission_Noise_Tiling_and_Offset;
        float _Cover_Mask_A_Remap_Min;
        float _Cover_Mask_A_Remap_Max;
        float _HeightMin;
        float _HeightMax;
        float _HeightOffset;
        float _VertexColorBBlendStrenght;
        float _USECoverHeightT;
        float _AlphaCutoff;
        float4 _WetColor;
        float4 _BaseColor;
        float _USEBaseHeightT;
        float4 _BaseColorMap_TexelSize;
        float _BaseUsePlanarUV;
        float4 _BaseTilingOffset;
        float4 _BaseNormalMap_TexelSize;
        float _BaseNormalScale;
        float4 _BaseMaskMap_TexelSize;
        float _BaseMetallic;
        float _VertexColorGBlendStrenght;
        float _BaseAORemapMin;
        float _BaseAORemapMax;
        float _BaseSmoothnessRemapMin;
        float _BaseSmoothnessRemapMax;
        float4 _Masks_TexelSize;
        float _Cover_Amount;
        float _Cover_Amount_Grow_Speed;
        float _Cover_Max_Angle;
        float _Cover_Min_Height;
        float _Cover_Min_Height_Blending;
        float4 _CoverBaseColor;
        float4 _CoverBaseColorMap_TexelSize;
        float _CoverUsePlanarUV;
        float4 _CoverTilingOffset;
        float4 _CoverNormalMap_TexelSize;
        float _CoverNormalScale;
        float _CoverNormalBlendHardness;
        float _CoverHardness;
        float _CoverHeightMapMin;
        float _CoverHeightMapMax;
        float _CoverHeightMapOffset;
        float4 _CoverMaskMap_TexelSize;
        float _CoverMetallic;
        float _CoverAORemapMin;
        float _CoverAORemapMax;
        float _CoverSmoothnessRemapMin;
        float _CoverSmoothnessRemapMax;
        float4 _DetailMap_TexelSize;
        float4 _DetailTilingOffset;
        float _DetailAlbedoScale;
        float _DetailNormalScale;
        float _DetailSmoothnessScale;
        float _WetSmoothness;
        UNITY_TEXTURE_STREAMING_DEBUG_VARS;
        CBUFFER_END
        
        
        // Object and Global properties
        SAMPLER(SamplerState_Linear_Repeat);
        SAMPLER(SamplerState_Linear_Repeat_Aniso8);
        TEXTURE2D(_Noise);
        SAMPLER(sampler_Noise);
        TEXTURE2D(_BaseColorMap);
        SAMPLER(sampler_BaseColorMap);
        TEXTURE2D(_BaseNormalMap);
        SAMPLER(sampler_BaseNormalMap);
        TEXTURE2D(_BaseMaskMap);
        SAMPLER(sampler_BaseMaskMap);
        TEXTURE2D(_Masks);
        SAMPLER(sampler_Masks);
        TEXTURE2D(_CoverBaseColorMap);
        SAMPLER(sampler_CoverBaseColorMap);
        TEXTURE2D(_CoverNormalMap);
        SAMPLER(sampler_CoverNormalMap);
        TEXTURE2D(_CoverMaskMap);
        SAMPLER(sampler_CoverMaskMap);
        TEXTURE2D(_DetailMap);
        SAMPLER(sampler_DetailMap);
        
        // Graph Includes
        // GraphIncludes: <None>
        
        // -- Property used by ScenePickingPass
        #ifdef SCENEPICKINGPASS
        float4 _SelectionID;
        #endif
        
        // -- Properties used by SceneSelectionPass
        #ifdef SCENESELECTIONPASS
        int _ObjectId;
        int _PassValue;
        #endif
        
        // Graph Functions
        
        void Unity_Combine_float(float R, float G, float B, float A, out float4 RGBA, out float3 RGB, out float2 RG)
        {
            RGBA = float4(R, G, B, A);
            RGB = float3(R, G, B);
            RG = float2(R, G);
        }
        
        void Unity_Divide_float(float A, float B, out float Out)
        {
            Out = A / B;
        }
        
        void Unity_Multiply_float4_float4(float4 A, float4 B, out float4 Out)
        {
        Out = A * B;
        }
        
        void Unity_Branch_float4(float Predicate, float4 True, float4 False, out float4 Out)
        {
            Out = Predicate ? True : False;
        }
        
        void Unity_TilingAndOffset_float(float2 UV, float2 Tiling, float2 Offset, out float2 Out)
        {
            Out = UV * Tiling + Offset;
        }
        
        void Unity_Branch_float2(float Predicate, float2 True, float2 False, out float2 Out)
        {
            Out = Predicate ? True : False;
        }
        
        struct Bindings_PlanarNM_c0f081da9c567704ea36e7dd38cedcf6_float
        {
        float3 AbsoluteWorldSpacePosition;
        half4 uv0;
        half4 uv3;
        };
        
        void SG_PlanarNM_c0f081da9c567704ea36e7dd38cedcf6_float(UnityTexture2D Texture2D_80A3D28F, float4 Vector4_2EBA7A3B, float Boolean_7ABB9909, UnitySamplerState _SamplerState, float Boolean_5ddfe6daabcc4715a44b5f34fc19becb, Bindings_PlanarNM_c0f081da9c567704ea36e7dd38cedcf6_float IN, out float4 XZ_2)
        {
        UnityTexture2D _Property_3e01b4d2fc68d48ba3acbba9d5881e59_Out_0_Texture2D = Texture2D_80A3D28F;
        float _Property_30834f691775a0898a45b1c868520436_Out_0_Boolean = Boolean_7ABB9909;
        float _Split_89ed63cb625cb3878c183d0b71c03400_R_1_Float = IN.AbsoluteWorldSpacePosition[0];
        float _Split_89ed63cb625cb3878c183d0b71c03400_G_2_Float = IN.AbsoluteWorldSpacePosition[1];
        float _Split_89ed63cb625cb3878c183d0b71c03400_B_3_Float = IN.AbsoluteWorldSpacePosition[2];
        float _Split_89ed63cb625cb3878c183d0b71c03400_A_4_Float = 0;
        float4 _Combine_cf2d04ff119ad88493f6460431765cbb_RGBA_4_Vector4;
        float3 _Combine_cf2d04ff119ad88493f6460431765cbb_RGB_5_Vector3;
        float2 _Combine_cf2d04ff119ad88493f6460431765cbb_RG_6_Vector2;
        Unity_Combine_float(_Split_89ed63cb625cb3878c183d0b71c03400_R_1_Float, _Split_89ed63cb625cb3878c183d0b71c03400_B_3_Float, float(0), float(0), _Combine_cf2d04ff119ad88493f6460431765cbb_RGBA_4_Vector4, _Combine_cf2d04ff119ad88493f6460431765cbb_RGB_5_Vector3, _Combine_cf2d04ff119ad88493f6460431765cbb_RG_6_Vector2);
        float4 _Property_8a66888ec47d0687ab1cb2f8abdc9da8_Out_0_Vector4 = Vector4_2EBA7A3B;
        float _Split_2f0f52f6ef8c0e81af0da6476402bc1f_R_1_Float = _Property_8a66888ec47d0687ab1cb2f8abdc9da8_Out_0_Vector4[0];
        float _Split_2f0f52f6ef8c0e81af0da6476402bc1f_G_2_Float = _Property_8a66888ec47d0687ab1cb2f8abdc9da8_Out_0_Vector4[1];
        float _Split_2f0f52f6ef8c0e81af0da6476402bc1f_B_3_Float = _Property_8a66888ec47d0687ab1cb2f8abdc9da8_Out_0_Vector4[2];
        float _Split_2f0f52f6ef8c0e81af0da6476402bc1f_A_4_Float = _Property_8a66888ec47d0687ab1cb2f8abdc9da8_Out_0_Vector4[3];
        float _Divide_e64179199923c58289b6aa94ea6c9178_Out_2_Float;
        Unity_Divide_float(float(1), _Split_2f0f52f6ef8c0e81af0da6476402bc1f_R_1_Float, _Divide_e64179199923c58289b6aa94ea6c9178_Out_2_Float);
        float4 _Multiply_14cec4902d0a00829e4555071a1b8ad1_Out_2_Vector4;
        Unity_Multiply_float4_float4(_Combine_cf2d04ff119ad88493f6460431765cbb_RGBA_4_Vector4, (_Divide_e64179199923c58289b6aa94ea6c9178_Out_2_Float.xxxx), _Multiply_14cec4902d0a00829e4555071a1b8ad1_Out_2_Vector4);
        float _Property_f17c7bf877e64b6abdd66b1fe9f5accc_Out_0_Boolean = Boolean_5ddfe6daabcc4715a44b5f34fc19becb;
        float4 _UV_029e8e8198564838b9389b902a09fb22_Out_0_Vector4 = IN.uv0;
        float4 _UV_7a6209af1506424fb75c81e87e42035a_Out_0_Vector4 = IN.uv3;
        float4 _Branch_fc37bb4bf641457cbbc6e290603056ff_Out_3_Vector4;
        Unity_Branch_float4(_Property_f17c7bf877e64b6abdd66b1fe9f5accc_Out_0_Boolean, _UV_029e8e8198564838b9389b902a09fb22_Out_0_Vector4, _UV_7a6209af1506424fb75c81e87e42035a_Out_0_Vector4, _Branch_fc37bb4bf641457cbbc6e290603056ff_Out_3_Vector4);
        float2 _Vector2_16c15d3bbdd14b85bd48e3a6cb318af7_Out_0_Vector2 = float2(_Split_2f0f52f6ef8c0e81af0da6476402bc1f_R_1_Float, _Split_2f0f52f6ef8c0e81af0da6476402bc1f_G_2_Float);
        float2 _Vector2_f8d75f54e7705083bbec539a60185577_Out_0_Vector2 = float2(_Split_2f0f52f6ef8c0e81af0da6476402bc1f_B_3_Float, _Split_2f0f52f6ef8c0e81af0da6476402bc1f_A_4_Float);
        float2 _TilingAndOffset_d91e2d25acd34686b562b7fe7e9d1d27_Out_3_Vector2;
        Unity_TilingAndOffset_float((_Branch_fc37bb4bf641457cbbc6e290603056ff_Out_3_Vector4.xy), _Vector2_16c15d3bbdd14b85bd48e3a6cb318af7_Out_0_Vector2, _Vector2_f8d75f54e7705083bbec539a60185577_Out_0_Vector2, _TilingAndOffset_d91e2d25acd34686b562b7fe7e9d1d27_Out_3_Vector2);
        float2 _Branch_8e5a4e8f4d52fc8aadd1f46485afc933_Out_3_Vector2;
        Unity_Branch_float2(_Property_30834f691775a0898a45b1c868520436_Out_0_Boolean, (_Multiply_14cec4902d0a00829e4555071a1b8ad1_Out_2_Vector4.xy), _TilingAndOffset_d91e2d25acd34686b562b7fe7e9d1d27_Out_3_Vector2, _Branch_8e5a4e8f4d52fc8aadd1f46485afc933_Out_3_Vector2);
        UnitySamplerState _Property_e8746b9475c94530ba35ba8019ad2ae0_Out_0_SamplerState = _SamplerState;
        float4 _SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_RGBA_0_Vector4 = SAMPLE_TEXTURE2D(_Property_3e01b4d2fc68d48ba3acbba9d5881e59_Out_0_Texture2D.tex, _Property_e8746b9475c94530ba35ba8019ad2ae0_Out_0_SamplerState.samplerstate, _Property_3e01b4d2fc68d48ba3acbba9d5881e59_Out_0_Texture2D.GetTransformedUV(_Branch_8e5a4e8f4d52fc8aadd1f46485afc933_Out_3_Vector2) );
        float _SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_R_4_Float = _SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_RGBA_0_Vector4.r;
        float _SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_G_5_Float = _SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_RGBA_0_Vector4.g;
        float _SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_B_6_Float = _SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_RGBA_0_Vector4.b;
        float _SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_A_7_Float = _SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_RGBA_0_Vector4.a;
        XZ_2 = _SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_RGBA_0_Vector4;
        }
        
        void Unity_ColorspaceConversion_Linear_RGB_float(float3 In, out float3 Out)
        {
            float3 sRGBLo = In * 12.92;
            float3 sRGBHi = (pow(max(abs(In), 1.192092896e-07), float3(1.0 / 2.4, 1.0 / 2.4, 1.0 / 2.4)) * 1.055) - 0.055;
            Out = float3(In <= 0.0031308) ? sRGBLo : sRGBHi;
        }
        
        void Unity_Blend_Overlay_float3(float3 Base, float3 Blend, out float3 Out, float Opacity)
        {
            float3 result1 = 1.0 - 2.0 * (1.0 - Base) * (1.0 - Blend);
            float3 result2 = 2.0 * Base * Blend;
            float3 zeroOrOne = step(Base, 0.5);
            Out = result2 * zeroOrOne + (1 - zeroOrOne) * result1;
            Out = lerp(Base, Out, Opacity);
        }
        
        void Unity_ColorspaceConversion_RGB_Linear_float(float3 In, out float3 Out)
        {
            float3 linearRGBLo = In / 12.92;
            float3 linearRGBHi = pow(max(abs((In + 0.055) / 1.055), 1.192092896e-07), float3(2.4, 2.4, 2.4));
            Out = float3(In <= 0.04045) ? linearRGBLo : linearRGBHi;
        }
        
        void Unity_Clamp_float3(float3 In, float3 Min, float3 Max, out float3 Out)
        {
            Out = clamp(In, Min, Max);
        }
        
        void Unity_Add_float2(float2 A, float2 B, out float2 Out)
        {
            Out = A + B;
        }
        
        void Unity_Remap_float(float In, float2 InMinMax, float2 OutMinMax, out float Out)
        {
            Out = OutMinMax.x + (In - InMinMax.x) * (OutMinMax.y - OutMinMax.x) / (InMinMax.y - InMinMax.x);
        }
        
        void Unity_Clamp_float(float In, float Min, float Max, out float Out)
        {
            Out = clamp(In, Min, Max);
        }
        
        void Unity_Multiply_float2_float2(float2 A, float2 B, out float2 Out)
        {
            Out = A * B;
        }
        
        void Unity_DotProduct_float2(float2 A, float2 B, out float Out)
        {
            Out = dot(A, B);
        }
        
        void Unity_Saturate_float(float In, out float Out)
        {
            Out = saturate(In);
        }
        
        void Unity_OneMinus_float(float In, out float Out)
        {
            Out = 1 - In;
        }
        
        void Unity_SquareRoot_float(float In, out float Out)
        {
            Out = sqrt(In);
        }
        
        void Unity_Sign_float3(float3 In, out float3 Out)
        {
            Out = sign(In);
        }
        
        void Unity_Multiply_float_float(float A, float B, out float Out)
        {
        Out = A * B;
        }
        
        void Unity_Normalize_float3(float3 In, out float3 Out)
        {
            Out = normalize(In);
        }
        
        void Unity_Branch_float3(float Predicate, float3 True, float3 False, out float3 Out)
        {
            Out = Predicate ? True : False;
        }
        
        struct Bindings_PlanarNMn_1b93a87456f9d4c419321d0cd92bd6c8_float
        {
        float3 WorldSpaceNormal;
        float3 WorldSpaceTangent;
        float3 WorldSpaceBiTangent;
        float3 AbsoluteWorldSpacePosition;
        half4 uv0;
        half4 uv3;
        };
        
        void SG_PlanarNMn_1b93a87456f9d4c419321d0cd92bd6c8_float(UnityTexture2D Texture2D_80A3D28F, float4 Vector4_82674548, float Boolean_9FF42DF6, UnitySamplerState _SamplerState, float Boolean_5ddfe6daabcc4715a44b5f34fc19becb, Bindings_PlanarNMn_1b93a87456f9d4c419321d0cd92bd6c8_float IN, out float4 XZ_2)
        {
        float _Property_1ef12cf3201a938993fe6a7951b0e754_Out_0_Boolean = Boolean_9FF42DF6;
        UnityTexture2D _Property_3e01b4d2fc68d48ba3acbba9d5881e59_Out_0_Texture2D = Texture2D_80A3D28F;
        float _Split_89ed63cb625cb3878c183d0b71c03400_R_1_Float = IN.AbsoluteWorldSpacePosition[0];
        float _Split_89ed63cb625cb3878c183d0b71c03400_G_2_Float = IN.AbsoluteWorldSpacePosition[1];
        float _Split_89ed63cb625cb3878c183d0b71c03400_B_3_Float = IN.AbsoluteWorldSpacePosition[2];
        float _Split_89ed63cb625cb3878c183d0b71c03400_A_4_Float = 0;
        float4 _Combine_cf2d04ff119ad88493f6460431765cbb_RGBA_4_Vector4;
        float3 _Combine_cf2d04ff119ad88493f6460431765cbb_RGB_5_Vector3;
        float2 _Combine_cf2d04ff119ad88493f6460431765cbb_RG_6_Vector2;
        Unity_Combine_float(_Split_89ed63cb625cb3878c183d0b71c03400_R_1_Float, _Split_89ed63cb625cb3878c183d0b71c03400_B_3_Float, float(0), float(0), _Combine_cf2d04ff119ad88493f6460431765cbb_RGBA_4_Vector4, _Combine_cf2d04ff119ad88493f6460431765cbb_RGB_5_Vector3, _Combine_cf2d04ff119ad88493f6460431765cbb_RG_6_Vector2);
        float4 _Property_3fa1d6f912feb481ba60f2e55e62e746_Out_0_Vector4 = Vector4_82674548;
        float _Split_a2e12fa5931da084b2949343a539dfd8_R_1_Float = _Property_3fa1d6f912feb481ba60f2e55e62e746_Out_0_Vector4[0];
        float _Split_a2e12fa5931da084b2949343a539dfd8_G_2_Float = _Property_3fa1d6f912feb481ba60f2e55e62e746_Out_0_Vector4[1];
        float _Split_a2e12fa5931da084b2949343a539dfd8_B_3_Float = _Property_3fa1d6f912feb481ba60f2e55e62e746_Out_0_Vector4[2];
        float _Split_a2e12fa5931da084b2949343a539dfd8_A_4_Float = _Property_3fa1d6f912feb481ba60f2e55e62e746_Out_0_Vector4[3];
        float _Divide_c36b770dfaa0bb8f85ab27da5fd794f0_Out_2_Float;
        Unity_Divide_float(float(1), _Split_a2e12fa5931da084b2949343a539dfd8_R_1_Float, _Divide_c36b770dfaa0bb8f85ab27da5fd794f0_Out_2_Float);
        float4 _Multiply_14cec4902d0a00829e4555071a1b8ad1_Out_2_Vector4;
        Unity_Multiply_float4_float4(_Combine_cf2d04ff119ad88493f6460431765cbb_RGBA_4_Vector4, (_Divide_c36b770dfaa0bb8f85ab27da5fd794f0_Out_2_Float.xxxx), _Multiply_14cec4902d0a00829e4555071a1b8ad1_Out_2_Vector4);
        float _Property_058f4fba88c3437288219f1929444bf2_Out_0_Boolean = Boolean_5ddfe6daabcc4715a44b5f34fc19becb;
        float4 _UV_43d85b3291324c848dfbeec6adac2a71_Out_0_Vector4 = IN.uv0;
        float4 _UV_36881dcaab9040168fc5215dcd00f352_Out_0_Vector4 = IN.uv3;
        float4 _Branch_8054d58a73be4ce1b22d48a84389ae07_Out_3_Vector4;
        Unity_Branch_float4(_Property_058f4fba88c3437288219f1929444bf2_Out_0_Boolean, _UV_43d85b3291324c848dfbeec6adac2a71_Out_0_Vector4, _UV_36881dcaab9040168fc5215dcd00f352_Out_0_Vector4, _Branch_8054d58a73be4ce1b22d48a84389ae07_Out_3_Vector4);
        float2 _Vector2_6845d21872714d889783b0cb707df3e9_Out_0_Vector2 = float2(_Split_a2e12fa5931da084b2949343a539dfd8_R_1_Float, _Split_a2e12fa5931da084b2949343a539dfd8_G_2_Float);
        float2 _Vector2_e2e2263627c6098e96a5b5d29350ad03_Out_0_Vector2 = float2(_Split_a2e12fa5931da084b2949343a539dfd8_B_3_Float, _Split_a2e12fa5931da084b2949343a539dfd8_A_4_Float);
        float2 _TilingAndOffset_17582d056c0b8a8dab1017d37497fe59_Out_3_Vector2;
        Unity_TilingAndOffset_float((_Branch_8054d58a73be4ce1b22d48a84389ae07_Out_3_Vector4.xy), _Vector2_6845d21872714d889783b0cb707df3e9_Out_0_Vector2, _Vector2_e2e2263627c6098e96a5b5d29350ad03_Out_0_Vector2, _TilingAndOffset_17582d056c0b8a8dab1017d37497fe59_Out_3_Vector2);
        float2 _Branch_1e152f3aac57448f8518bf2852c000c3_Out_3_Vector2;
        Unity_Branch_float2(_Property_1ef12cf3201a938993fe6a7951b0e754_Out_0_Boolean, (_Multiply_14cec4902d0a00829e4555071a1b8ad1_Out_2_Vector4.xy), _TilingAndOffset_17582d056c0b8a8dab1017d37497fe59_Out_3_Vector2, _Branch_1e152f3aac57448f8518bf2852c000c3_Out_3_Vector2);
        UnitySamplerState _Property_69f1ed7efd1b494e91f626b88ab2363c_Out_0_SamplerState = _SamplerState;
        float4 _SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_RGBA_0_Vector4 = SAMPLE_TEXTURE2D(_Property_3e01b4d2fc68d48ba3acbba9d5881e59_Out_0_Texture2D.tex, _Property_69f1ed7efd1b494e91f626b88ab2363c_Out_0_SamplerState.samplerstate, _Property_3e01b4d2fc68d48ba3acbba9d5881e59_Out_0_Texture2D.GetTransformedUV(_Branch_1e152f3aac57448f8518bf2852c000c3_Out_3_Vector2) );
        _SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_RGBA_0_Vector4.rgb = UnpackNormal(_SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_RGBA_0_Vector4);
        float _SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_R_4_Float = _SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_RGBA_0_Vector4.r;
        float _SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_G_5_Float = _SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_RGBA_0_Vector4.g;
        float _SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_B_6_Float = _SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_RGBA_0_Vector4.b;
        float _SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_A_7_Float = _SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_RGBA_0_Vector4.a;
        float2 _Vector2_ad6bd100e273d78fa409a30a77bfa2cc_Out_0_Vector2 = float2(_SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_R_4_Float, _SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_G_5_Float);
        float3 _Sign_3a6ebf59931cf08cb0482e0144ddac24_Out_1_Vector3;
        Unity_Sign_float3(IN.WorldSpaceNormal, _Sign_3a6ebf59931cf08cb0482e0144ddac24_Out_1_Vector3);
        float _Split_6299d4ddcc4c74828aea40a46fdb896e_R_1_Float = _Sign_3a6ebf59931cf08cb0482e0144ddac24_Out_1_Vector3[0];
        float _Split_6299d4ddcc4c74828aea40a46fdb896e_G_2_Float = _Sign_3a6ebf59931cf08cb0482e0144ddac24_Out_1_Vector3[1];
        float _Split_6299d4ddcc4c74828aea40a46fdb896e_B_3_Float = _Sign_3a6ebf59931cf08cb0482e0144ddac24_Out_1_Vector3[2];
        float _Split_6299d4ddcc4c74828aea40a46fdb896e_A_4_Float = 0;
        float2 _Vector2_b76cb1842101e58b9e636d49b075c612_Out_0_Vector2 = float2(_Split_6299d4ddcc4c74828aea40a46fdb896e_G_2_Float, float(1));
        float2 _Multiply_31e8db88ee20c985a9850d1a58f3282b_Out_2_Vector2;
        Unity_Multiply_float2_float2(_Vector2_ad6bd100e273d78fa409a30a77bfa2cc_Out_0_Vector2, _Vector2_b76cb1842101e58b9e636d49b075c612_Out_0_Vector2, _Multiply_31e8db88ee20c985a9850d1a58f3282b_Out_2_Vector2);
        float _Split_5ed44bf2eca0868f81eb18100f49d1fa_R_1_Float = IN.WorldSpaceNormal[0];
        float _Split_5ed44bf2eca0868f81eb18100f49d1fa_G_2_Float = IN.WorldSpaceNormal[1];
        float _Split_5ed44bf2eca0868f81eb18100f49d1fa_B_3_Float = IN.WorldSpaceNormal[2];
        float _Split_5ed44bf2eca0868f81eb18100f49d1fa_A_4_Float = 0;
        float2 _Vector2_70e5837843f28b8b9d64cada3697bd5a_Out_0_Vector2 = float2(_Split_5ed44bf2eca0868f81eb18100f49d1fa_R_1_Float, _Split_5ed44bf2eca0868f81eb18100f49d1fa_B_3_Float);
        float2 _Add_1145b2f896593d80aa864a34e6702562_Out_2_Vector2;
        Unity_Add_float2(_Multiply_31e8db88ee20c985a9850d1a58f3282b_Out_2_Vector2, _Vector2_70e5837843f28b8b9d64cada3697bd5a_Out_0_Vector2, _Add_1145b2f896593d80aa864a34e6702562_Out_2_Vector2);
        float _Split_2bc77ca2d17bd78cb2383770ce50b179_R_1_Float = _Add_1145b2f896593d80aa864a34e6702562_Out_2_Vector2[0];
        float _Split_2bc77ca2d17bd78cb2383770ce50b179_G_2_Float = _Add_1145b2f896593d80aa864a34e6702562_Out_2_Vector2[1];
        float _Split_2bc77ca2d17bd78cb2383770ce50b179_B_3_Float = 0;
        float _Split_2bc77ca2d17bd78cb2383770ce50b179_A_4_Float = 0;
        float _Multiply_ab12aea87465a78eaf7fc66c2598d266_Out_2_Float;
        Unity_Multiply_float_float(_SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_B_6_Float, _Split_5ed44bf2eca0868f81eb18100f49d1fa_G_2_Float, _Multiply_ab12aea87465a78eaf7fc66c2598d266_Out_2_Float);
        float3 _Vector3_433840b555db308b97e9b14b6a957195_Out_0_Vector3 = float3(_Split_2bc77ca2d17bd78cb2383770ce50b179_R_1_Float, _Multiply_ab12aea87465a78eaf7fc66c2598d266_Out_2_Float, _Split_2bc77ca2d17bd78cb2383770ce50b179_G_2_Float);
        float3 _Transform_c7914cc45a011c89b3f53c55afb51673_Out_1_Vector3;
        {
        float3x3 tangentTransform = float3x3(IN.WorldSpaceTangent, IN.WorldSpaceBiTangent, IN.WorldSpaceNormal);
        _Transform_c7914cc45a011c89b3f53c55afb51673_Out_1_Vector3 = TransformWorldToTangentDir(_Vector3_433840b555db308b97e9b14b6a957195_Out_0_Vector3.xyz, tangentTransform, true);
        }
        float3 _Clamp_3837949a36b5428a82af01e7bcd29952_Out_3_Vector3;
        Unity_Clamp_float3(_Transform_c7914cc45a011c89b3f53c55afb51673_Out_1_Vector3, float3(-1, -1, -1), float3(1, 1, 1), _Clamp_3837949a36b5428a82af01e7bcd29952_Out_3_Vector3);
        float3 _Normalize_09bf8a2bd0a4d38e8b97d5c674f79b44_Out_1_Vector3;
        Unity_Normalize_float3(_Clamp_3837949a36b5428a82af01e7bcd29952_Out_3_Vector3, _Normalize_09bf8a2bd0a4d38e8b97d5c674f79b44_Out_1_Vector3);
        float3 _Branch_9eadf909a90f2f80880f8c56ecc2a91f_Out_3_Vector3;
        Unity_Branch_float3(_Property_1ef12cf3201a938993fe6a7951b0e754_Out_0_Boolean, _Normalize_09bf8a2bd0a4d38e8b97d5c674f79b44_Out_1_Vector3, (_SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_RGBA_0_Vector4.xyz), _Branch_9eadf909a90f2f80880f8c56ecc2a91f_Out_3_Vector3);
        XZ_2 = (float4(_Branch_9eadf909a90f2f80880f8c56ecc2a91f_Out_3_Vector3, 1.0));
        }
        
        void Unity_NormalStrength_float(float3 In, float Strength, out float3 Out)
        {
            Out = float3(In.rg * Strength, lerp(1, In.b, saturate(Strength)));
        }
        
        void Unity_NormalBlend_Reoriented_float(float3 A, float3 B, out float3 Out)
        {
            float3 t = A.xyz + float3(0.0, 0.0, 1.0);
            float3 u = B.xyz * float3(-1.0, -1.0, 1.0);
            Out = (t / t.z) * dot(t, u) - u;
        }
        
        void Unity_Subtract_float(float A, float B, out float Out)
        {
            Out = A - B;
        }
        
        void Unity_Absolute_float(float In, out float Out)
        {
            Out = abs(In);
        }
        
        void Unity_Power_float(float A, float B, out float Out)
        {
            Out = pow(A, B);
        }
        
        void Unity_Add_float(float A, float B, out float Out)
        {
            Out = A + B;
        }
        
        void Unity_Lerp_float3(float3 A, float3 B, float3 T, out float3 Out)
        {
            Out = lerp(A, B, T);
        }
        
        void Unity_Comparison_Greater_float(float A, float B, out float Out)
        {
            Out = A > B ? 1 : 0;
        }
        
        void Unity_Branch_float(float Predicate, float True, float False, out float Out)
        {
            Out = Predicate ? True : False;
        }
        
        struct Bindings_UniversalHeighblend_3b5c31b864970d04197cd420b6c4b0fa_float
        {
        };
        
        void SG_UniversalHeighblend_3b5c31b864970d04197cd420b6c4b0fa_float(float _Vertex_Color, float _Blend_Hardness, float _Use_Layer_1_Height_T, float _Layer_1_Height, float2 _Layer_1_Before_Remap, float _Use_Layer_2_Height_T, float _Layer_2_Height, float2 _Layer_2_Before_Remap, float _Angle_Blend, Bindings_UniversalHeighblend_3b5c31b864970d04197cd420b6c4b0fa_float IN, out float Heightmap_1)
        {
        float _Property_b3ca7054ef0043de85912fc45d997ea2_Out_0_Float = _Vertex_Color;
        float _Clamp_852774a2be524975babf4eeb54af6d64_Out_3_Float;
        Unity_Clamp_float(_Property_b3ca7054ef0043de85912fc45d997ea2_Out_0_Float, float(0), float(1), _Clamp_852774a2be524975babf4eeb54af6d64_Out_3_Float);
        float _OneMinus_85e3550f37814cd3ab5ea5dde7f63a73_Out_1_Float;
        Unity_OneMinus_float(_Clamp_852774a2be524975babf4eeb54af6d64_Out_3_Float, _OneMinus_85e3550f37814cd3ab5ea5dde7f63a73_Out_1_Float);
        float _Comparison_5be6aeaa514b4921b5eb68269b58b028_Out_2_Boolean;
        Unity_Comparison_Greater_float(_OneMinus_85e3550f37814cd3ab5ea5dde7f63a73_Out_1_Float, float(0.99), _Comparison_5be6aeaa514b4921b5eb68269b58b028_Out_2_Boolean);
        float _Property_cfe724908035497c918d6d3f8dafe439_Out_0_Boolean = _Use_Layer_1_Height_T;
        float _Property_9634fd87d3374fdaa60181281a01f9b5_Out_0_Float = _Layer_1_Height;
        float2 _Property_e748f6c127e0479a9a01040378a4129b_Out_0_Vector2 = _Layer_1_Before_Remap;
        float _Split_cde172ab161d44cb81ea7874aec65560_R_1_Float = _Property_e748f6c127e0479a9a01040378a4129b_Out_0_Vector2[0];
        float _Split_cde172ab161d44cb81ea7874aec65560_G_2_Float = _Property_e748f6c127e0479a9a01040378a4129b_Out_0_Vector2[1];
        float _Split_cde172ab161d44cb81ea7874aec65560_B_3_Float = 0;
        float _Split_cde172ab161d44cb81ea7874aec65560_A_4_Float = 0;
        float _Subtract_e1e98a956721410caddfb467ae0eca8b_Out_2_Float;
        Unity_Subtract_float(_Split_cde172ab161d44cb81ea7874aec65560_R_1_Float, _Split_cde172ab161d44cb81ea7874aec65560_G_2_Float, _Subtract_e1e98a956721410caddfb467ae0eca8b_Out_2_Float);
        float _Clamp_ac4097026e6248dbb7a95fe910cc776e_Out_3_Float;
        Unity_Clamp_float(_OneMinus_85e3550f37814cd3ab5ea5dde7f63a73_Out_1_Float, float(0), float(1), _Clamp_ac4097026e6248dbb7a95fe910cc776e_Out_3_Float);
        float _Multiply_41691d316de74fef8a4ab5f63ed5474e_Out_2_Float;
        Unity_Multiply_float_float(_Subtract_e1e98a956721410caddfb467ae0eca8b_Out_2_Float, _Clamp_ac4097026e6248dbb7a95fe910cc776e_Out_3_Float, _Multiply_41691d316de74fef8a4ab5f63ed5474e_Out_2_Float);
        float2 _Add_48d37f8b8a464788860db14f0da8a66e_Out_2_Vector2;
        Unity_Add_float2(_Property_e748f6c127e0479a9a01040378a4129b_Out_0_Vector2, (_Multiply_41691d316de74fef8a4ab5f63ed5474e_Out_2_Float.xx), _Add_48d37f8b8a464788860db14f0da8a66e_Out_2_Vector2);
        float _Remap_21f3372608424df090026adc73778a39_Out_3_Float;
        Unity_Remap_float(_Property_9634fd87d3374fdaa60181281a01f9b5_Out_0_Float, float2 (0, 1), _Add_48d37f8b8a464788860db14f0da8a66e_Out_2_Vector2, _Remap_21f3372608424df090026adc73778a39_Out_3_Float);
        float _Clamp_8ea719b357b44537b42b2d05c22046f6_Out_3_Float;
        Unity_Clamp_float(_Remap_21f3372608424df090026adc73778a39_Out_3_Float, float(0), float(1), _Clamp_8ea719b357b44537b42b2d05c22046f6_Out_3_Float);
        float _Property_457e05a76c034ada998b3ff30a7781c3_Out_0_Boolean = _Use_Layer_2_Height_T;
        float _Property_9dfafa1ca8c94866a52535f412aff89a_Out_0_Float = _Angle_Blend;
        float _Property_b0e4a5720c374e2eb6f203a1bd075243_Out_0_Float = _Layer_2_Height;
        float _Multiply_00b31c7f720343caa4ded6df80a61899_Out_2_Float;
        Unity_Multiply_float_float(_Property_9dfafa1ca8c94866a52535f412aff89a_Out_0_Float, _Property_b0e4a5720c374e2eb6f203a1bd075243_Out_0_Float, _Multiply_00b31c7f720343caa4ded6df80a61899_Out_2_Float);
        float2 _Property_555a7734da754b989d8f80ef0bc86bea_Out_0_Vector2 = _Layer_2_Before_Remap;
        float _Split_bad56a0d03154ccc8cbfb53ea0e381d4_R_1_Float = _Property_555a7734da754b989d8f80ef0bc86bea_Out_0_Vector2[0];
        float _Split_bad56a0d03154ccc8cbfb53ea0e381d4_G_2_Float = _Property_555a7734da754b989d8f80ef0bc86bea_Out_0_Vector2[1];
        float _Split_bad56a0d03154ccc8cbfb53ea0e381d4_B_3_Float = 0;
        float _Split_bad56a0d03154ccc8cbfb53ea0e381d4_A_4_Float = 0;
        float _Subtract_2a7908018c384526a00494520503a83d_Out_2_Float;
        Unity_Subtract_float(_Split_bad56a0d03154ccc8cbfb53ea0e381d4_R_1_Float, _Split_bad56a0d03154ccc8cbfb53ea0e381d4_G_2_Float, _Subtract_2a7908018c384526a00494520503a83d_Out_2_Float);
        float _Multiply_417d72157b5f4930aed43775db746964_Out_2_Float;
        Unity_Multiply_float_float(_Subtract_2a7908018c384526a00494520503a83d_Out_2_Float, _Clamp_ac4097026e6248dbb7a95fe910cc776e_Out_3_Float, _Multiply_417d72157b5f4930aed43775db746964_Out_2_Float);
        float2 _Add_3d7e111e917c44e8a6800ce926fac67d_Out_2_Vector2;
        Unity_Add_float2((_Multiply_417d72157b5f4930aed43775db746964_Out_2_Float.xx), _Property_555a7734da754b989d8f80ef0bc86bea_Out_0_Vector2, _Add_3d7e111e917c44e8a6800ce926fac67d_Out_2_Vector2);
        float _Remap_931f83440e6c4c1588456788f84cbd9a_Out_3_Float;
        Unity_Remap_float(_Multiply_00b31c7f720343caa4ded6df80a61899_Out_2_Float, float2 (0, 1), _Add_3d7e111e917c44e8a6800ce926fac67d_Out_2_Vector2, _Remap_931f83440e6c4c1588456788f84cbd9a_Out_3_Float);
        float _Branch_a840aba5bca34588a2665f9794c96c38_Out_3_Float;
        Unity_Branch_float(_Property_457e05a76c034ada998b3ff30a7781c3_Out_0_Boolean, _Remap_931f83440e6c4c1588456788f84cbd9a_Out_3_Float, _Property_9dfafa1ca8c94866a52535f412aff89a_Out_0_Float, _Branch_a840aba5bca34588a2665f9794c96c38_Out_3_Float);
        float _Clamp_b1fe959daf444bf99c57756b8be77768_Out_3_Float;
        Unity_Clamp_float(_Branch_a840aba5bca34588a2665f9794c96c38_Out_3_Float, float(0), float(1), _Clamp_b1fe959daf444bf99c57756b8be77768_Out_3_Float);
        float _Multiply_c045ae9912ac409b9734c687968d47f6_Out_2_Float;
        Unity_Multiply_float_float(_Clamp_8ea719b357b44537b42b2d05c22046f6_Out_3_Float, _Clamp_b1fe959daf444bf99c57756b8be77768_Out_3_Float, _Multiply_c045ae9912ac409b9734c687968d47f6_Out_2_Float);
        float _Branch_5198cfc0a080466e93cf89aea61886e6_Out_3_Float;
        Unity_Branch_float(_Property_cfe724908035497c918d6d3f8dafe439_Out_0_Boolean, _Multiply_c045ae9912ac409b9734c687968d47f6_Out_2_Float, _Clamp_b1fe959daf444bf99c57756b8be77768_Out_3_Float, _Branch_5198cfc0a080466e93cf89aea61886e6_Out_3_Float);
        float _Saturate_ceafe30b0bae4f45a2f2ec500925b553_Out_1_Float;
        Unity_Saturate_float(_Branch_5198cfc0a080466e93cf89aea61886e6_Out_3_Float, _Saturate_ceafe30b0bae4f45a2f2ec500925b553_Out_1_Float);
        float _Absolute_274083e3f9f645bfb86074d91f3b7c62_Out_1_Float;
        Unity_Absolute_float(_Saturate_ceafe30b0bae4f45a2f2ec500925b553_Out_1_Float, _Absolute_274083e3f9f645bfb86074d91f3b7c62_Out_1_Float);
        float _Property_c68e0b8a84a549a582d4723036344b0e_Out_0_Float = _Blend_Hardness;
        float _Power_c9d62a3092174d9cb5674d87bcb7b5c5_Out_2_Float;
        Unity_Power_float(_Absolute_274083e3f9f645bfb86074d91f3b7c62_Out_1_Float, _Property_c68e0b8a84a549a582d4723036344b0e_Out_0_Float, _Power_c9d62a3092174d9cb5674d87bcb7b5c5_Out_2_Float);
        float _Branch_2425ee869bde4930bb8f36a5273bdc33_Out_3_Float;
        Unity_Branch_float(_Comparison_5be6aeaa514b4921b5eb68269b58b028_Out_2_Boolean, float(0), _Power_c9d62a3092174d9cb5674d87bcb7b5c5_Out_2_Float, _Branch_2425ee869bde4930bb8f36a5273bdc33_Out_3_Float);
        float _Clamp_9a5c5cfe52824e248ea0a8e38c593d84_Out_3_Float;
        Unity_Clamp_float(_Branch_2425ee869bde4930bb8f36a5273bdc33_Out_3_Float, float(0), float(1), _Clamp_9a5c5cfe52824e248ea0a8e38c593d84_Out_3_Float);
        Heightmap_1 = _Clamp_9a5c5cfe52824e248ea0a8e38c593d84_Out_3_Float;
        }
        
        void Unity_Lerp_float4(float4 A, float4 B, float4 T, out float4 Out)
        {
            Out = lerp(A, B, T);
        }
        
        void Unity_Clamp_float4(float4 In, float4 Min, float4 Max, out float4 Out)
        {
            Out = clamp(In, Min, Max);
        }
        
        void Unity_Lerp_float(float A, float B, float T, out float Out)
        {
            Out = lerp(A, B, T);
        }
        
        // unity-custom-func-begin
        void Time_float(out float Out){
            Out = _Time.y;
        }
        // unity-custom-func-end
        
        void Unity_Minimum_float(float A, float B, out float Out)
        {
            Out = min(A, B);
        };
        
        void Unity_DotProduct_float3(float3 A, float3 B, out float Out)
        {
            Out = dot(A, B);
        }
        
        void Unity_Add_float4(float4 A, float4 B, out float4 Out)
        {
            Out = A + B;
        }
        
        void Unity_Sign_float(float In, out float Out)
        {
            Out = sign(In);
        }
        
        void Unity_Ceiling_float(float In, out float Out)
        {
            Out = ceil(In);
        }
        
        struct Bindings_BlendOverlayDetailSmoothness_06e12138dc89c0040b45a57abe520a1a_float
        {
        };
        
        void SG_BlendOverlayDetailSmoothness_06e12138dc89c0040b45a57abe520a1a_float(float Vector1_32317166, float Vector1_FBE622A2, float Vector1_8C15C351, Bindings_BlendOverlayDetailSmoothness_06e12138dc89c0040b45a57abe520a1a_float IN, out float SmoothnessOverlay_1)
        {
        float _Property_728cc50521e9e988ac9cbff4872d5139_Out_0_Float = Vector1_32317166;
        float _Property_a00e29241d12f983b30177515b367ec9_Out_0_Float = Vector1_FBE622A2;
        float _Sign_343a45ede7349283a681c6bd9998fd8e_Out_1_Float;
        Unity_Sign_float(_Property_a00e29241d12f983b30177515b367ec9_Out_0_Float, _Sign_343a45ede7349283a681c6bd9998fd8e_Out_1_Float);
        float _Add_681019b8f5d3d68bb482d419c9fc61a9_Out_2_Float;
        Unity_Add_float(_Sign_343a45ede7349283a681c6bd9998fd8e_Out_1_Float, float(1), _Add_681019b8f5d3d68bb482d419c9fc61a9_Out_2_Float);
        float _Multiply_e8f4cb722712a880ac0db6c7461427f7_Out_2_Float;
        Unity_Multiply_float_float(_Add_681019b8f5d3d68bb482d419c9fc61a9_Out_2_Float, 0.5, _Multiply_e8f4cb722712a880ac0db6c7461427f7_Out_2_Float);
        float _Ceiling_95ad15988aa9b98184875fa754feae01_Out_1_Float;
        Unity_Ceiling_float(_Multiply_e8f4cb722712a880ac0db6c7461427f7_Out_2_Float, _Ceiling_95ad15988aa9b98184875fa754feae01_Out_1_Float);
        float _Property_2db1c747a05ee284a8b00076062f91a4_Out_0_Float = Vector1_8C15C351;
        float _Lerp_b3cdb01fc3c5b988ac9b184943bf7c01_Out_3_Float;
        Unity_Lerp_float(_Property_728cc50521e9e988ac9cbff4872d5139_Out_0_Float, _Ceiling_95ad15988aa9b98184875fa754feae01_Out_1_Float, _Property_2db1c747a05ee284a8b00076062f91a4_Out_0_Float, _Lerp_b3cdb01fc3c5b988ac9b184943bf7c01_Out_3_Float);
        SmoothnessOverlay_1 = _Lerp_b3cdb01fc3c5b988ac9b184943bf7c01_Out_3_Float;
        }
        
        // Custom interpolators pre vertex
        /* WARNING: $splice Could not find named fragment 'CustomInterpolatorPreVertex' */
        
        // Graph Vertex
        struct VertexDescription
        {
            float3 Position;
            float3 Normal;
            float3 Tangent;
        };
        
        VertexDescription VertexDescriptionFunction(VertexDescriptionInputs IN)
        {
            VertexDescription description = (VertexDescription)0;
            description.Position = IN.ObjectSpacePosition;
            description.Normal = IN.ObjectSpaceNormal;
            description.Tangent = IN.ObjectSpaceTangent;
            return description;
        }
        
        // Custom interpolators, pre surface
        #ifdef FEATURES_GRAPH_VERTEX
        Varyings CustomInterpolatorPassThroughFunc(inout Varyings output, VertexDescription input)
        {
        return output;
        }
        #define CUSTOMINTERPOLATOR_VARYPASSTHROUGH_FUNC
        #endif
        
        // Graph Pixel
        struct SurfaceDescription
        {
            float3 BaseColor;
            float3 NormalTS;
            float3 Emission;
            float Metallic;
            float3 Specular;
            float Smoothness;
            float Occlusion;
            float Alpha;
            float AlphaClipThreshold;
        };
        
        SurfaceDescription SurfaceDescriptionFunction(SurfaceDescriptionInputs IN)
        {
            SurfaceDescription surface = (SurfaceDescription)0;
            UnityTexture2D _Property_821e07b38fd0a08d85c4dd6e5b6bbac9_Out_0_Texture2D = UnityBuildTexture2DStructNoScale(_BaseColorMap);
            float4 _Property_8ec0d512145619859d288abab740e3bf_Out_0_Vector4 = _BaseTilingOffset;
            float _Property_122c0f9ef0a1c4818a140c75e512abe4_Out_0_Boolean = _BaseUsePlanarUV;
            Bindings_PlanarNM_c0f081da9c567704ea36e7dd38cedcf6_float _PlanarNM_cb7ded32e6af3382bbe06b62977afab6;
            _PlanarNM_cb7ded32e6af3382bbe06b62977afab6.AbsoluteWorldSpacePosition = IN.AbsoluteWorldSpacePosition;
            _PlanarNM_cb7ded32e6af3382bbe06b62977afab6.uv0 = IN.uv0;
            _PlanarNM_cb7ded32e6af3382bbe06b62977afab6.uv3 = IN.uv3;
            float4 _PlanarNM_cb7ded32e6af3382bbe06b62977afab6_XZ_2_Vector4;
            SG_PlanarNM_c0f081da9c567704ea36e7dd38cedcf6_float(_Property_821e07b38fd0a08d85c4dd6e5b6bbac9_Out_0_Texture2D, _Property_8ec0d512145619859d288abab740e3bf_Out_0_Vector4, _Property_122c0f9ef0a1c4818a140c75e512abe4_Out_0_Boolean, UnityBuildSamplerStateStruct(SamplerState_Linear_Repeat_Aniso8), 1, _PlanarNM_cb7ded32e6af3382bbe06b62977afab6, _PlanarNM_cb7ded32e6af3382bbe06b62977afab6_XZ_2_Vector4);
            float4 _Property_41859d117584758eb8002ecc938f9bce_Out_0_Vector4 = _BaseColor;
            float4 _Multiply_4d0f82599060228a9092027fd43912c8_Out_2_Vector4;
            Unity_Multiply_float4_float4(_PlanarNM_cb7ded32e6af3382bbe06b62977afab6_XZ_2_Vector4, _Property_41859d117584758eb8002ecc938f9bce_Out_0_Vector4, _Multiply_4d0f82599060228a9092027fd43912c8_Out_2_Vector4);
            float3 _ColorspaceConversion_30c5042ef70343cd92056cde73cd3ecb_Out_1_Vector3;
            Unity_ColorspaceConversion_Linear_RGB_float((_Multiply_4d0f82599060228a9092027fd43912c8_Out_2_Vector4.xyz), _ColorspaceConversion_30c5042ef70343cd92056cde73cd3ecb_Out_1_Vector3);
            UnityTexture2D _Property_50403cc6b1e3998a82afc21c6a6332ae_Out_0_Texture2D = UnityBuildTexture2DStructNoScale(_DetailMap);
            float4 _Property_256e5676e1089881ae3214634430b140_Out_0_Vector4 = _DetailTilingOffset;
            float _Split_257d0b6ea953418d97fd7daa8128bf35_R_1_Float = _Property_256e5676e1089881ae3214634430b140_Out_0_Vector4[0];
            float _Split_257d0b6ea953418d97fd7daa8128bf35_G_2_Float = _Property_256e5676e1089881ae3214634430b140_Out_0_Vector4[1];
            float _Split_257d0b6ea953418d97fd7daa8128bf35_B_3_Float = _Property_256e5676e1089881ae3214634430b140_Out_0_Vector4[2];
            float _Split_257d0b6ea953418d97fd7daa8128bf35_A_4_Float = _Property_256e5676e1089881ae3214634430b140_Out_0_Vector4[3];
            float2 _Vector2_98295494172421878c7a16cb2baddf9a_Out_0_Vector2 = float2(_Split_257d0b6ea953418d97fd7daa8128bf35_R_1_Float, _Split_257d0b6ea953418d97fd7daa8128bf35_G_2_Float);
            float2 _Vector2_130e8faa59837a81a7506636fcb30b8a_Out_0_Vector2 = float2(_Split_257d0b6ea953418d97fd7daa8128bf35_B_3_Float, _Split_257d0b6ea953418d97fd7daa8128bf35_A_4_Float);
            float2 _TilingAndOffset_1dfb2b4859ec3680ad3a74cf8f1bc17b_Out_3_Vector2;
            Unity_TilingAndOffset_float(IN.uv0.xy, _Vector2_98295494172421878c7a16cb2baddf9a_Out_0_Vector2, _Vector2_130e8faa59837a81a7506636fcb30b8a_Out_0_Vector2, _TilingAndOffset_1dfb2b4859ec3680ad3a74cf8f1bc17b_Out_3_Vector2);
            float4 _SampleTexture2D_d8eb0186b9a0cd819cde65431b4ea5ea_RGBA_0_Vector4 = SAMPLE_TEXTURE2D(_Property_50403cc6b1e3998a82afc21c6a6332ae_Out_0_Texture2D.tex, UnityBuildSamplerStateStruct(SamplerState_Linear_Repeat_Aniso8).samplerstate, _Property_50403cc6b1e3998a82afc21c6a6332ae_Out_0_Texture2D.GetTransformedUV(_TilingAndOffset_1dfb2b4859ec3680ad3a74cf8f1bc17b_Out_3_Vector2) );
            float _SampleTexture2D_d8eb0186b9a0cd819cde65431b4ea5ea_R_4_Float = _SampleTexture2D_d8eb0186b9a0cd819cde65431b4ea5ea_RGBA_0_Vector4.r;
            float _SampleTexture2D_d8eb0186b9a0cd819cde65431b4ea5ea_G_5_Float = _SampleTexture2D_d8eb0186b9a0cd819cde65431b4ea5ea_RGBA_0_Vector4.g;
            float _SampleTexture2D_d8eb0186b9a0cd819cde65431b4ea5ea_B_6_Float = _SampleTexture2D_d8eb0186b9a0cd819cde65431b4ea5ea_RGBA_0_Vector4.b;
            float _SampleTexture2D_d8eb0186b9a0cd819cde65431b4ea5ea_A_7_Float = _SampleTexture2D_d8eb0186b9a0cd819cde65431b4ea5ea_RGBA_0_Vector4.a;
            float _Property_605f29777330a58ba88ac032e905433b_Out_0_Float = _DetailAlbedoScale;
            float3 _Blend_de85bf99257f4eb7bb321fd973539f10_Out_2_Vector3;
            Unity_Blend_Overlay_float3(_ColorspaceConversion_30c5042ef70343cd92056cde73cd3ecb_Out_1_Vector3, (_SampleTexture2D_d8eb0186b9a0cd819cde65431b4ea5ea_R_4_Float.xxx), _Blend_de85bf99257f4eb7bb321fd973539f10_Out_2_Vector3, _Property_605f29777330a58ba88ac032e905433b_Out_0_Float);
            float3 _ColorspaceConversion_635670d250654503b34efa53a99ba43e_Out_1_Vector3;
            Unity_ColorspaceConversion_RGB_Linear_float(_Blend_de85bf99257f4eb7bb321fd973539f10_Out_2_Vector3, _ColorspaceConversion_635670d250654503b34efa53a99ba43e_Out_1_Vector3);
            float3 _Clamp_8913f48f801c43c2879f2e1ce926507e_Out_3_Vector3;
            Unity_Clamp_float3(_ColorspaceConversion_635670d250654503b34efa53a99ba43e_Out_1_Vector3, float3(0, 0, 0), float3(1, 1, 1), _Clamp_8913f48f801c43c2879f2e1ce926507e_Out_3_Vector3);
            float _Split_ddfe447fbb7845e88cc5cfb8158b2248_R_1_Float = _Clamp_8913f48f801c43c2879f2e1ce926507e_Out_3_Vector3[0];
            float _Split_ddfe447fbb7845e88cc5cfb8158b2248_G_2_Float = _Clamp_8913f48f801c43c2879f2e1ce926507e_Out_3_Vector3[1];
            float _Split_ddfe447fbb7845e88cc5cfb8158b2248_B_3_Float = _Clamp_8913f48f801c43c2879f2e1ce926507e_Out_3_Vector3[2];
            float _Split_ddfe447fbb7845e88cc5cfb8158b2248_A_4_Float = 0;
            float _Split_6d7debfd2b20440e932d58108f8e7f75_R_1_Float = _Multiply_4d0f82599060228a9092027fd43912c8_Out_2_Vector4[0];
            float _Split_6d7debfd2b20440e932d58108f8e7f75_G_2_Float = _Multiply_4d0f82599060228a9092027fd43912c8_Out_2_Vector4[1];
            float _Split_6d7debfd2b20440e932d58108f8e7f75_B_3_Float = _Multiply_4d0f82599060228a9092027fd43912c8_Out_2_Vector4[2];
            float _Split_6d7debfd2b20440e932d58108f8e7f75_A_4_Float = _Multiply_4d0f82599060228a9092027fd43912c8_Out_2_Vector4[3];
            float4 _Combine_b0f28916143e4b94af6bec53f5328b52_RGBA_4_Vector4;
            float3 _Combine_b0f28916143e4b94af6bec53f5328b52_RGB_5_Vector3;
            float2 _Combine_b0f28916143e4b94af6bec53f5328b52_RG_6_Vector2;
            Unity_Combine_float(_Split_ddfe447fbb7845e88cc5cfb8158b2248_R_1_Float, _Split_ddfe447fbb7845e88cc5cfb8158b2248_G_2_Float, _Split_ddfe447fbb7845e88cc5cfb8158b2248_B_3_Float, _Split_6d7debfd2b20440e932d58108f8e7f75_A_4_Float, _Combine_b0f28916143e4b94af6bec53f5328b52_RGBA_4_Vector4, _Combine_b0f28916143e4b94af6bec53f5328b52_RGB_5_Vector3, _Combine_b0f28916143e4b94af6bec53f5328b52_RG_6_Vector2);
            UnityTexture2D _Property_a155ddc33ed90685a5ab0edcf158a343_Out_0_Texture2D = UnityBuildTexture2DStructNoScale(_CoverBaseColorMap);
            float4 _Property_256beda96caf2d8aa05d3de41fc08d3d_Out_0_Vector4 = _CoverTilingOffset;
            float _Property_bd9dfe8dd615798f9f2d72d139e56d61_Out_0_Boolean = _CoverUsePlanarUV;
            Bindings_PlanarNM_c0f081da9c567704ea36e7dd38cedcf6_float _PlanarNM_e00e057d3d7c4181b1c7775c6ebbab5b;
            _PlanarNM_e00e057d3d7c4181b1c7775c6ebbab5b.AbsoluteWorldSpacePosition = IN.AbsoluteWorldSpacePosition;
            _PlanarNM_e00e057d3d7c4181b1c7775c6ebbab5b.uv0 = IN.uv0;
            _PlanarNM_e00e057d3d7c4181b1c7775c6ebbab5b.uv3 = IN.uv3;
            float4 _PlanarNM_e00e057d3d7c4181b1c7775c6ebbab5b_XZ_2_Vector4;
            SG_PlanarNM_c0f081da9c567704ea36e7dd38cedcf6_float(_Property_a155ddc33ed90685a5ab0edcf158a343_Out_0_Texture2D, _Property_256beda96caf2d8aa05d3de41fc08d3d_Out_0_Vector4, _Property_bd9dfe8dd615798f9f2d72d139e56d61_Out_0_Boolean, UnityBuildSamplerStateStruct(SamplerState_Linear_Repeat_Aniso8), 1, _PlanarNM_e00e057d3d7c4181b1c7775c6ebbab5b, _PlanarNM_e00e057d3d7c4181b1c7775c6ebbab5b_XZ_2_Vector4);
            float4 _Property_c3be5593fd661b8dafbd04f26b8ec9ac_Out_0_Vector4 = _CoverBaseColor;
            float4 _Multiply_b08794693505bd8e8c04b9ba1610d394_Out_2_Vector4;
            Unity_Multiply_float4_float4(_PlanarNM_e00e057d3d7c4181b1c7775c6ebbab5b_XZ_2_Vector4, _Property_c3be5593fd661b8dafbd04f26b8ec9ac_Out_0_Vector4, _Multiply_b08794693505bd8e8c04b9ba1610d394_Out_2_Vector4);
            float _Split_a80936a3c75945efb8cf9f2b95c76642_R_1_Float = IN.VertexColor[0];
            float _Split_a80936a3c75945efb8cf9f2b95c76642_G_2_Float = IN.VertexColor[1];
            float _Split_a80936a3c75945efb8cf9f2b95c76642_B_3_Float = IN.VertexColor[2];
            float _Split_a80936a3c75945efb8cf9f2b95c76642_A_4_Float = IN.VertexColor[3];
            float _Property_14a6757619d64822a44a69b34f85276d_Out_0_Float = _VertexColorGBlendStrenght;
            float _Property_c0d9ffba7dee497c885a54170977d874_Out_0_Boolean = _USEBaseHeightT;
            UnityTexture2D _Property_bb9b47702e64ec8c8d8ad011fd521576_Out_0_Texture2D = UnityBuildTexture2DStructNoScale(_BaseMaskMap);
            Bindings_PlanarNM_c0f081da9c567704ea36e7dd38cedcf6_float _PlanarNM_e51306c84cde8e84a1fb06a45d8d037f;
            _PlanarNM_e51306c84cde8e84a1fb06a45d8d037f.AbsoluteWorldSpacePosition = IN.AbsoluteWorldSpacePosition;
            _PlanarNM_e51306c84cde8e84a1fb06a45d8d037f.uv0 = IN.uv0;
            _PlanarNM_e51306c84cde8e84a1fb06a45d8d037f.uv3 = IN.uv3;
            float4 _PlanarNM_e51306c84cde8e84a1fb06a45d8d037f_XZ_2_Vector4;
            SG_PlanarNM_c0f081da9c567704ea36e7dd38cedcf6_float(_Property_bb9b47702e64ec8c8d8ad011fd521576_Out_0_Texture2D, _Property_8ec0d512145619859d288abab740e3bf_Out_0_Vector4, _Property_122c0f9ef0a1c4818a140c75e512abe4_Out_0_Boolean, UnityBuildSamplerStateStruct(SamplerState_Linear_Repeat_Aniso8), 1, _PlanarNM_e51306c84cde8e84a1fb06a45d8d037f, _PlanarNM_e51306c84cde8e84a1fb06a45d8d037f_XZ_2_Vector4);
            float _Split_218e1cfd00b30984921b5fc0ec63de60_R_1_Float = _PlanarNM_e51306c84cde8e84a1fb06a45d8d037f_XZ_2_Vector4[0];
            float _Split_218e1cfd00b30984921b5fc0ec63de60_G_2_Float = _PlanarNM_e51306c84cde8e84a1fb06a45d8d037f_XZ_2_Vector4[1];
            float _Split_218e1cfd00b30984921b5fc0ec63de60_B_3_Float = _PlanarNM_e51306c84cde8e84a1fb06a45d8d037f_XZ_2_Vector4[2];
            float _Split_218e1cfd00b30984921b5fc0ec63de60_A_4_Float = _PlanarNM_e51306c84cde8e84a1fb06a45d8d037f_XZ_2_Vector4[3];
            float _Property_1d4a1a93707b42c3abf0baa799c514e5_Out_0_Float = _HeightMin;
            float _Property_8f4f3606868d4028a34c2a9a5a59f99d_Out_0_Float = _HeightMax;
            float2 _Vector2_721b6f4d7077463490b4504fe6c940bf_Out_0_Vector2 = float2(_Property_1d4a1a93707b42c3abf0baa799c514e5_Out_0_Float, _Property_8f4f3606868d4028a34c2a9a5a59f99d_Out_0_Float);
            float _Property_a1ae2f61da87421b9f3839691e9dd8af_Out_0_Float = _HeightOffset;
            float2 _Add_1f9ea9bdf36544b59f763806e7eea80d_Out_2_Vector2;
            Unity_Add_float2(_Vector2_721b6f4d7077463490b4504fe6c940bf_Out_0_Vector2, (_Property_a1ae2f61da87421b9f3839691e9dd8af_Out_0_Float.xx), _Add_1f9ea9bdf36544b59f763806e7eea80d_Out_2_Vector2);
            float _Property_0fbef18600294e199eeda9905e3304e4_Out_0_Boolean = _USECoverHeightT;
            UnityTexture2D _Property_3702de305e11e085a40d7731b582d541_Out_0_Texture2D = UnityBuildTexture2DStructNoScale(_CoverMaskMap);
            Bindings_PlanarNM_c0f081da9c567704ea36e7dd38cedcf6_float _PlanarNM_2217ca3c12141a8cb1e0c7235b369601;
            _PlanarNM_2217ca3c12141a8cb1e0c7235b369601.AbsoluteWorldSpacePosition = IN.AbsoluteWorldSpacePosition;
            _PlanarNM_2217ca3c12141a8cb1e0c7235b369601.uv0 = IN.uv0;
            _PlanarNM_2217ca3c12141a8cb1e0c7235b369601.uv3 = IN.uv3;
            float4 _PlanarNM_2217ca3c12141a8cb1e0c7235b369601_XZ_2_Vector4;
            SG_PlanarNM_c0f081da9c567704ea36e7dd38cedcf6_float(_Property_3702de305e11e085a40d7731b582d541_Out_0_Texture2D, _Property_256beda96caf2d8aa05d3de41fc08d3d_Out_0_Vector4, _Property_bd9dfe8dd615798f9f2d72d139e56d61_Out_0_Boolean, UnityBuildSamplerStateStruct(SamplerState_Linear_Repeat_Aniso8), 1, _PlanarNM_2217ca3c12141a8cb1e0c7235b369601, _PlanarNM_2217ca3c12141a8cb1e0c7235b369601_XZ_2_Vector4);
            float _Split_2f45bca363698c859e51492899bc58f8_R_1_Float = _PlanarNM_2217ca3c12141a8cb1e0c7235b369601_XZ_2_Vector4[0];
            float _Split_2f45bca363698c859e51492899bc58f8_G_2_Float = _PlanarNM_2217ca3c12141a8cb1e0c7235b369601_XZ_2_Vector4[1];
            float _Split_2f45bca363698c859e51492899bc58f8_B_3_Float = _PlanarNM_2217ca3c12141a8cb1e0c7235b369601_XZ_2_Vector4[2];
            float _Split_2f45bca363698c859e51492899bc58f8_A_4_Float = _PlanarNM_2217ca3c12141a8cb1e0c7235b369601_XZ_2_Vector4[3];
            float _Property_32b48052fdbb4641bf4eeb294bc65050_Out_0_Float = _CoverHeightMapMin;
            float _Property_0e120eb0a0a14b12a31a3c1f5b961121_Out_0_Float = _CoverHeightMapMax;
            float2 _Vector2_6955747f7f0a4ff98fae60dbada25e89_Out_0_Vector2 = float2(_Property_32b48052fdbb4641bf4eeb294bc65050_Out_0_Float, _Property_0e120eb0a0a14b12a31a3c1f5b961121_Out_0_Float);
            float _Property_6b467710b0ba48058e003aebe9119249_Out_0_Float = _CoverHeightMapOffset;
            float2 _Add_28628d641d58481084e9c00e4ad5fc8d_Out_2_Vector2;
            Unity_Add_float2(_Vector2_6955747f7f0a4ff98fae60dbada25e89_Out_0_Vector2, (_Property_6b467710b0ba48058e003aebe9119249_Out_0_Float.xx), _Add_28628d641d58481084e9c00e4ad5fc8d_Out_2_Vector2);
            UnityTexture2D _Property_7bea2d9dd5651a8bbbd61ecde71faa54_Out_0_Texture2D = UnityBuildTexture2DStructNoScale(_Masks);
            float4 _UV_429c95affe88aa8694076115c99a0769_Out_0_Vector4 = IN.uv0;
            float4 _SampleTexture2D_2723da80b8a2528381ef199c0415beae_RGBA_0_Vector4 = SAMPLE_TEXTURE2D(_Property_7bea2d9dd5651a8bbbd61ecde71faa54_Out_0_Texture2D.tex, UnityBuildSamplerStateStruct(SamplerState_Linear_Repeat_Aniso8).samplerstate, _Property_7bea2d9dd5651a8bbbd61ecde71faa54_Out_0_Texture2D.GetTransformedUV((_UV_429c95affe88aa8694076115c99a0769_Out_0_Vector4.xy)) );
            float _SampleTexture2D_2723da80b8a2528381ef199c0415beae_R_4_Float = _SampleTexture2D_2723da80b8a2528381ef199c0415beae_RGBA_0_Vector4.r;
            float _SampleTexture2D_2723da80b8a2528381ef199c0415beae_G_5_Float = _SampleTexture2D_2723da80b8a2528381ef199c0415beae_RGBA_0_Vector4.g;
            float _SampleTexture2D_2723da80b8a2528381ef199c0415beae_B_6_Float = _SampleTexture2D_2723da80b8a2528381ef199c0415beae_RGBA_0_Vector4.b;
            float _SampleTexture2D_2723da80b8a2528381ef199c0415beae_A_7_Float = _SampleTexture2D_2723da80b8a2528381ef199c0415beae_RGBA_0_Vector4.a;
            float _Property_7bea2851849541b28a2bc695d39a7606_Out_0_Float = _Cover_Mask_A_Remap_Min;
            float _Property_3be0ae138e414a5cb43d60264b1bcfeb_Out_0_Float = _Cover_Mask_A_Remap_Max;
            float2 _Vector2_44ac029de1e440a799fbdfadc778af0c_Out_0_Vector2 = float2(_Property_7bea2851849541b28a2bc695d39a7606_Out_0_Float, _Property_3be0ae138e414a5cb43d60264b1bcfeb_Out_0_Float);
            float _Remap_0c551a3055a54f16b85b519194883552_Out_3_Float;
            Unity_Remap_float(_SampleTexture2D_2723da80b8a2528381ef199c0415beae_A_7_Float, float2 (0, 1), _Vector2_44ac029de1e440a799fbdfadc778af0c_Out_0_Vector2, _Remap_0c551a3055a54f16b85b519194883552_Out_3_Float);
            float _Clamp_bb1427696ce14fe987f799fecc5f9fac_Out_3_Float;
            Unity_Clamp_float(_Remap_0c551a3055a54f16b85b519194883552_Out_3_Float, float(0), float(1), _Clamp_bb1427696ce14fe987f799fecc5f9fac_Out_3_Float);
            float2 _Vector2_0d28074858599a88940dfc8b57b9a60f_Out_0_Vector2 = float2(_SampleTexture2D_d8eb0186b9a0cd819cde65431b4ea5ea_A_7_Float, _SampleTexture2D_d8eb0186b9a0cd819cde65431b4ea5ea_G_5_Float);
            float2 _Multiply_fac8d94f82a53486bc0142a1e64b3d32_Out_2_Vector2;
            Unity_Multiply_float2_float2(_Vector2_0d28074858599a88940dfc8b57b9a60f_Out_0_Vector2, float2(2, 2), _Multiply_fac8d94f82a53486bc0142a1e64b3d32_Out_2_Vector2);
            float2 _Add_f0e6e847d8d8798ab3ca8c4d878bafc0_Out_2_Vector2;
            Unity_Add_float2(_Multiply_fac8d94f82a53486bc0142a1e64b3d32_Out_2_Vector2, float2(-1, -1), _Add_f0e6e847d8d8798ab3ca8c4d878bafc0_Out_2_Vector2);
            float _Property_d0e8d8f7fd10f0829e8fd86c278c8226_Out_0_Float = _DetailNormalScale;
            float2 _Multiply_11f3dfc5283ea188ad9c83e552cf7e0f_Out_2_Vector2;
            Unity_Multiply_float2_float2(_Add_f0e6e847d8d8798ab3ca8c4d878bafc0_Out_2_Vector2, (_Property_d0e8d8f7fd10f0829e8fd86c278c8226_Out_0_Float.xx), _Multiply_11f3dfc5283ea188ad9c83e552cf7e0f_Out_2_Vector2);
            float _Split_c4822b8eaff9b185be7c059792345712_R_1_Float = _Multiply_11f3dfc5283ea188ad9c83e552cf7e0f_Out_2_Vector2[0];
            float _Split_c4822b8eaff9b185be7c059792345712_G_2_Float = _Multiply_11f3dfc5283ea188ad9c83e552cf7e0f_Out_2_Vector2[1];
            float _Split_c4822b8eaff9b185be7c059792345712_B_3_Float = 0;
            float _Split_c4822b8eaff9b185be7c059792345712_A_4_Float = 0;
            float _DotProduct_1a01939a143c548c8ccd7e8a04fe680d_Out_2_Float;
            Unity_DotProduct_float2(_Multiply_11f3dfc5283ea188ad9c83e552cf7e0f_Out_2_Vector2, _Multiply_11f3dfc5283ea188ad9c83e552cf7e0f_Out_2_Vector2, _DotProduct_1a01939a143c548c8ccd7e8a04fe680d_Out_2_Float);
            float _Saturate_bf3d57899db77f86a1689105ce6a373a_Out_1_Float;
            Unity_Saturate_float(_DotProduct_1a01939a143c548c8ccd7e8a04fe680d_Out_2_Float, _Saturate_bf3d57899db77f86a1689105ce6a373a_Out_1_Float);
            float _OneMinus_052960238cc4a18cb83109d2bcae6d09_Out_1_Float;
            Unity_OneMinus_float(_Saturate_bf3d57899db77f86a1689105ce6a373a_Out_1_Float, _OneMinus_052960238cc4a18cb83109d2bcae6d09_Out_1_Float);
            float _SquareRoot_d4f67288e4dbf5898bea492a70b89ab9_Out_1_Float;
            Unity_SquareRoot_float(_OneMinus_052960238cc4a18cb83109d2bcae6d09_Out_1_Float, _SquareRoot_d4f67288e4dbf5898bea492a70b89ab9_Out_1_Float);
            float3 _Vector3_1e56146bdd567884bb8d5ae769df4d29_Out_0_Vector3 = float3(_Split_c4822b8eaff9b185be7c059792345712_R_1_Float, _Split_c4822b8eaff9b185be7c059792345712_G_2_Float, _SquareRoot_d4f67288e4dbf5898bea492a70b89ab9_Out_1_Float);
            UnityTexture2D _Property_147b07430832c98eb0a470557ee61c5e_Out_0_Texture2D = UnityBuildTexture2DStructNoScale(_BaseNormalMap);
            Bindings_PlanarNMn_1b93a87456f9d4c419321d0cd92bd6c8_float _PlanarNMn_ecad9f1f260c6c8bbd0960b2a8976daf;
            _PlanarNMn_ecad9f1f260c6c8bbd0960b2a8976daf.WorldSpaceNormal = IN.WorldSpaceNormal;
            _PlanarNMn_ecad9f1f260c6c8bbd0960b2a8976daf.WorldSpaceTangent = IN.WorldSpaceTangent;
            _PlanarNMn_ecad9f1f260c6c8bbd0960b2a8976daf.WorldSpaceBiTangent = IN.WorldSpaceBiTangent;
            _PlanarNMn_ecad9f1f260c6c8bbd0960b2a8976daf.AbsoluteWorldSpacePosition = IN.AbsoluteWorldSpacePosition;
            _PlanarNMn_ecad9f1f260c6c8bbd0960b2a8976daf.uv0 = IN.uv0;
            _PlanarNMn_ecad9f1f260c6c8bbd0960b2a8976daf.uv3 = IN.uv3;
            float4 _PlanarNMn_ecad9f1f260c6c8bbd0960b2a8976daf_XZ_2_Vector4;
            SG_PlanarNMn_1b93a87456f9d4c419321d0cd92bd6c8_float(_Property_147b07430832c98eb0a470557ee61c5e_Out_0_Texture2D, _Property_8ec0d512145619859d288abab740e3bf_Out_0_Vector4, _Property_122c0f9ef0a1c4818a140c75e512abe4_Out_0_Boolean, UnityBuildSamplerStateStruct(SamplerState_Linear_Repeat_Aniso8), 1, _PlanarNMn_ecad9f1f260c6c8bbd0960b2a8976daf, _PlanarNMn_ecad9f1f260c6c8bbd0960b2a8976daf_XZ_2_Vector4);
            float _Property_72e436a108ad64868e46d548c585c5f3_Out_0_Float = _BaseNormalScale;
            float3 _NormalStrength_366affc5c8b42482a633d201ef52b9d6_Out_2_Vector3;
            Unity_NormalStrength_float((_PlanarNMn_ecad9f1f260c6c8bbd0960b2a8976daf_XZ_2_Vector4.xyz), _Property_72e436a108ad64868e46d548c585c5f3_Out_0_Float, _NormalStrength_366affc5c8b42482a633d201ef52b9d6_Out_2_Vector3);
            float3 _NormalBlend_9f531c87e2e45580b1d0f65f06c23526_Out_2_Vector3;
            Unity_NormalBlend_Reoriented_float(_Vector3_1e56146bdd567884bb8d5ae769df4d29_Out_0_Vector3, _NormalStrength_366affc5c8b42482a633d201ef52b9d6_Out_2_Vector3, _NormalBlend_9f531c87e2e45580b1d0f65f06c23526_Out_2_Vector3);
            UnityTexture2D _Property_d7e9139e0ac6718b89c610009c28a25a_Out_0_Texture2D = UnityBuildTexture2DStructNoScale(_CoverNormalMap);
            Bindings_PlanarNMn_1b93a87456f9d4c419321d0cd92bd6c8_float _PlanarNMn_690e893d26999680a5cea3604ed0ce16;
            _PlanarNMn_690e893d26999680a5cea3604ed0ce16.WorldSpaceNormal = IN.WorldSpaceNormal;
            _PlanarNMn_690e893d26999680a5cea3604ed0ce16.WorldSpaceTangent = IN.WorldSpaceTangent;
            _PlanarNMn_690e893d26999680a5cea3604ed0ce16.WorldSpaceBiTangent = IN.WorldSpaceBiTangent;
            _PlanarNMn_690e893d26999680a5cea3604ed0ce16.AbsoluteWorldSpacePosition = IN.AbsoluteWorldSpacePosition;
            _PlanarNMn_690e893d26999680a5cea3604ed0ce16.uv0 = IN.uv0;
            _PlanarNMn_690e893d26999680a5cea3604ed0ce16.uv3 = IN.uv3;
            float4 _PlanarNMn_690e893d26999680a5cea3604ed0ce16_XZ_2_Vector4;
            SG_PlanarNMn_1b93a87456f9d4c419321d0cd92bd6c8_float(_Property_d7e9139e0ac6718b89c610009c28a25a_Out_0_Texture2D, _Property_256beda96caf2d8aa05d3de41fc08d3d_Out_0_Vector4, _Property_bd9dfe8dd615798f9f2d72d139e56d61_Out_0_Boolean, UnityBuildSamplerStateStruct(SamplerState_Linear_Repeat_Aniso8), 1, _PlanarNMn_690e893d26999680a5cea3604ed0ce16, _PlanarNMn_690e893d26999680a5cea3604ed0ce16_XZ_2_Vector4);
            float _Property_0fd4d87ded104c829a6110c044eaa5f2_Out_0_Float = _CoverNormalBlendHardness;
            float3 _NormalStrength_c4639a6dd3dfde85b591971db2700eaf_Out_2_Vector3;
            Unity_NormalStrength_float((_PlanarNMn_690e893d26999680a5cea3604ed0ce16_XZ_2_Vector4.xyz), _Property_0fd4d87ded104c829a6110c044eaa5f2_Out_0_Float, _NormalStrength_c4639a6dd3dfde85b591971db2700eaf_Out_2_Vector3);
            float _Split_8ff22a6bdd437780ac7ea5963e1c5bb4_R_1_Float = IN.WorldSpaceNormal[0];
            float _Split_8ff22a6bdd437780ac7ea5963e1c5bb4_G_2_Float = IN.WorldSpaceNormal[1];
            float _Split_8ff22a6bdd437780ac7ea5963e1c5bb4_B_3_Float = IN.WorldSpaceNormal[2];
            float _Split_8ff22a6bdd437780ac7ea5963e1c5bb4_A_4_Float = 0;
            float _Property_28052b023ac35c8e9a95b30327681cc5_Out_0_Float = _Cover_Amount;
            float _Property_7749c0d5b28c14869ab3ba35d226788b_Out_0_Float = _Cover_Amount_Grow_Speed;
            float _Subtract_e5dc2afce7ff588fa1d4c91f78de7575_Out_2_Float;
            Unity_Subtract_float(float(4), _Property_7749c0d5b28c14869ab3ba35d226788b_Out_0_Float, _Subtract_e5dc2afce7ff588fa1d4c91f78de7575_Out_2_Float);
            float _Divide_c77b003bf1ce13828c94a705676e2b30_Out_2_Float;
            Unity_Divide_float(_Property_28052b023ac35c8e9a95b30327681cc5_Out_0_Float, _Subtract_e5dc2afce7ff588fa1d4c91f78de7575_Out_2_Float, _Divide_c77b003bf1ce13828c94a705676e2b30_Out_2_Float);
            float _Absolute_c7499cf07bdd0582abd82adbf367b0fc_Out_1_Float;
            Unity_Absolute_float(_Divide_c77b003bf1ce13828c94a705676e2b30_Out_2_Float, _Absolute_c7499cf07bdd0582abd82adbf367b0fc_Out_1_Float);
            float _Power_a9431dbce44a528f9ee7095adfa10556_Out_2_Float;
            Unity_Power_float(_Absolute_c7499cf07bdd0582abd82adbf367b0fc_Out_1_Float, _Subtract_e5dc2afce7ff588fa1d4c91f78de7575_Out_2_Float, _Power_a9431dbce44a528f9ee7095adfa10556_Out_2_Float);
            float _Clamp_815ffdd53cc1c889aa00f73784cb71e7_Out_3_Float;
            Unity_Clamp_float(_Power_a9431dbce44a528f9ee7095adfa10556_Out_2_Float, float(0), float(2), _Clamp_815ffdd53cc1c889aa00f73784cb71e7_Out_3_Float);
            float _Multiply_143da4886728ff868f10e9cfa6940ea0_Out_2_Float;
            Unity_Multiply_float_float(_Split_8ff22a6bdd437780ac7ea5963e1c5bb4_G_2_Float, _Clamp_815ffdd53cc1c889aa00f73784cb71e7_Out_3_Float, _Multiply_143da4886728ff868f10e9cfa6940ea0_Out_2_Float);
            float _Saturate_04686ab19029f68c8fb9e7a115b207b1_Out_1_Float;
            Unity_Saturate_float(_Multiply_143da4886728ff868f10e9cfa6940ea0_Out_2_Float, _Saturate_04686ab19029f68c8fb9e7a115b207b1_Out_1_Float);
            float _Clamp_9c0a88ffc7be288cbe97d3e13a014fe8_Out_3_Float;
            Unity_Clamp_float(_Split_8ff22a6bdd437780ac7ea5963e1c5bb4_G_2_Float, float(0), float(0.9999), _Clamp_9c0a88ffc7be288cbe97d3e13a014fe8_Out_3_Float);
            float _Property_58f42b34c7f0728f8c98e00a3e3a5726_Out_0_Float = _Cover_Max_Angle;
            float _Divide_b785767ecc1928889893fa60eac4e5fb_Out_2_Float;
            Unity_Divide_float(_Property_58f42b34c7f0728f8c98e00a3e3a5726_Out_0_Float, float(45), _Divide_b785767ecc1928889893fa60eac4e5fb_Out_2_Float);
            float _OneMinus_8e6f5b1570dc8c8b8afb036328281675_Out_1_Float;
            Unity_OneMinus_float(_Divide_b785767ecc1928889893fa60eac4e5fb_Out_2_Float, _OneMinus_8e6f5b1570dc8c8b8afb036328281675_Out_1_Float);
            float _Subtract_5348fb3702fea78d9ee10dbf81ede29c_Out_2_Float;
            Unity_Subtract_float(_Clamp_9c0a88ffc7be288cbe97d3e13a014fe8_Out_3_Float, _OneMinus_8e6f5b1570dc8c8b8afb036328281675_Out_1_Float, _Subtract_5348fb3702fea78d9ee10dbf81ede29c_Out_2_Float);
            float _Clamp_2b888688983edd82ac250226d9378893_Out_3_Float;
            Unity_Clamp_float(_Subtract_5348fb3702fea78d9ee10dbf81ede29c_Out_2_Float, float(0), float(2), _Clamp_2b888688983edd82ac250226d9378893_Out_3_Float);
            float _Divide_5615f16c20214d888a2e727ff7c5f5ff_Out_2_Float;
            Unity_Divide_float(float(1), _Divide_b785767ecc1928889893fa60eac4e5fb_Out_2_Float, _Divide_5615f16c20214d888a2e727ff7c5f5ff_Out_2_Float);
            float _Multiply_89aeffc0ad067981a18e6a77948b2b49_Out_2_Float;
            Unity_Multiply_float_float(_Clamp_2b888688983edd82ac250226d9378893_Out_3_Float, _Divide_5615f16c20214d888a2e727ff7c5f5ff_Out_2_Float, _Multiply_89aeffc0ad067981a18e6a77948b2b49_Out_2_Float);
            float _Absolute_b91ed8e326de8f88bf52e49cc5f641d4_Out_1_Float;
            Unity_Absolute_float(_Multiply_89aeffc0ad067981a18e6a77948b2b49_Out_2_Float, _Absolute_b91ed8e326de8f88bf52e49cc5f641d4_Out_1_Float);
            float _Property_4879e96694aee98c9d4ecd329a571123_Out_0_Float = _CoverHardness;
            float _Power_ca1f1906c90fb785bfe520b7faefc3cd_Out_2_Float;
            Unity_Power_float(_Absolute_b91ed8e326de8f88bf52e49cc5f641d4_Out_1_Float, _Property_4879e96694aee98c9d4ecd329a571123_Out_0_Float, _Power_ca1f1906c90fb785bfe520b7faefc3cd_Out_2_Float);
            float _Property_b66201e787ab7b83a55abc6ddd3fe1fd_Out_0_Float = _Cover_Min_Height;
            float _OneMinus_87c740d245de388db4fe5f4958de0668_Out_1_Float;
            Unity_OneMinus_float(_Property_b66201e787ab7b83a55abc6ddd3fe1fd_Out_0_Float, _OneMinus_87c740d245de388db4fe5f4958de0668_Out_1_Float);
            float _Split_ae16de7cacf9d0878aba1467f193d681_R_1_Float = IN.AbsoluteWorldSpacePosition[0];
            float _Split_ae16de7cacf9d0878aba1467f193d681_G_2_Float = IN.AbsoluteWorldSpacePosition[1];
            float _Split_ae16de7cacf9d0878aba1467f193d681_B_3_Float = IN.AbsoluteWorldSpacePosition[2];
            float _Split_ae16de7cacf9d0878aba1467f193d681_A_4_Float = 0;
            float _Add_9d6e1dd03919c88bb01e77a9a2b6b59c_Out_2_Float;
            Unity_Add_float(_OneMinus_87c740d245de388db4fe5f4958de0668_Out_1_Float, _Split_ae16de7cacf9d0878aba1467f193d681_G_2_Float, _Add_9d6e1dd03919c88bb01e77a9a2b6b59c_Out_2_Float);
            float _Add_448f30a2cd792b868416a253a1c502bb_Out_2_Float;
            Unity_Add_float(_Add_9d6e1dd03919c88bb01e77a9a2b6b59c_Out_2_Float, float(1), _Add_448f30a2cd792b868416a253a1c502bb_Out_2_Float);
            float _Clamp_53d91568d0627d8a9cac8deecdd003a8_Out_3_Float;
            Unity_Clamp_float(_Add_448f30a2cd792b868416a253a1c502bb_Out_2_Float, float(0), float(1), _Clamp_53d91568d0627d8a9cac8deecdd003a8_Out_3_Float);
            float _Property_98b8c0fc7e8f9b88b8d7d9dd28ed8aca_Out_0_Float = _Cover_Min_Height_Blending;
            float _Add_0edbe9f424de6d8089b453804bc6ec74_Out_2_Float;
            Unity_Add_float(_Add_9d6e1dd03919c88bb01e77a9a2b6b59c_Out_2_Float, _Property_98b8c0fc7e8f9b88b8d7d9dd28ed8aca_Out_0_Float, _Add_0edbe9f424de6d8089b453804bc6ec74_Out_2_Float);
            float _Divide_bacd243000beaa86b28174bd47716791_Out_2_Float;
            Unity_Divide_float(_Add_0edbe9f424de6d8089b453804bc6ec74_Out_2_Float, _Add_9d6e1dd03919c88bb01e77a9a2b6b59c_Out_2_Float, _Divide_bacd243000beaa86b28174bd47716791_Out_2_Float);
            float _OneMinus_dd51a0c56dbb9b8b8882c6d36bfadd50_Out_1_Float;
            Unity_OneMinus_float(_Divide_bacd243000beaa86b28174bd47716791_Out_2_Float, _OneMinus_dd51a0c56dbb9b8b8882c6d36bfadd50_Out_1_Float);
            float _Add_58dd4a9dfd5655818255c74dd17921da_Out_2_Float;
            Unity_Add_float(_OneMinus_dd51a0c56dbb9b8b8882c6d36bfadd50_Out_1_Float, float(-0.5), _Add_58dd4a9dfd5655818255c74dd17921da_Out_2_Float);
            float _Clamp_5b36f07b81ef6f87a93aefa8fcb815b4_Out_3_Float;
            Unity_Clamp_float(_Add_58dd4a9dfd5655818255c74dd17921da_Out_2_Float, float(0), float(1), _Clamp_5b36f07b81ef6f87a93aefa8fcb815b4_Out_3_Float);
            float _Add_5ef49a57de2cdf85b0e894bfa07f6f14_Out_2_Float;
            Unity_Add_float(_Clamp_53d91568d0627d8a9cac8deecdd003a8_Out_3_Float, _Clamp_5b36f07b81ef6f87a93aefa8fcb815b4_Out_3_Float, _Add_5ef49a57de2cdf85b0e894bfa07f6f14_Out_2_Float);
            float _Clamp_130844801cc2148bb64804d2328686eb_Out_3_Float;
            Unity_Clamp_float(_Add_5ef49a57de2cdf85b0e894bfa07f6f14_Out_2_Float, float(0), float(1), _Clamp_130844801cc2148bb64804d2328686eb_Out_3_Float);
            float _Multiply_4a38c41b77a2458085ff4ae52ba3c21c_Out_2_Float;
            Unity_Multiply_float_float(_Power_ca1f1906c90fb785bfe520b7faefc3cd_Out_2_Float, _Clamp_130844801cc2148bb64804d2328686eb_Out_3_Float, _Multiply_4a38c41b77a2458085ff4ae52ba3c21c_Out_2_Float);
            float _Multiply_edc44afd10069b8e80460ceee1cba8f0_Out_2_Float;
            Unity_Multiply_float_float(_Saturate_04686ab19029f68c8fb9e7a115b207b1_Out_1_Float, _Multiply_4a38c41b77a2458085ff4ae52ba3c21c_Out_2_Float, _Multiply_edc44afd10069b8e80460ceee1cba8f0_Out_2_Float);
            float3 _Lerp_05179f1a9a06b084b2d83e8bce908cce_Out_3_Vector3;
            Unity_Lerp_float3(_NormalBlend_9f531c87e2e45580b1d0f65f06c23526_Out_2_Vector3, _NormalStrength_c4639a6dd3dfde85b591971db2700eaf_Out_2_Vector3, (_Multiply_edc44afd10069b8e80460ceee1cba8f0_Out_2_Float.xxx), _Lerp_05179f1a9a06b084b2d83e8bce908cce_Out_3_Vector3);
            float3 _Transform_d583fb35b7a2838399ae5ff4e71be918_Out_1_Vector3;
            {
                float3x3 tangentTransform = float3x3(IN.WorldSpaceTangent, IN.WorldSpaceBiTangent, IN.WorldSpaceNormal);
                _Transform_d583fb35b7a2838399ae5ff4e71be918_Out_1_Vector3 = TransformTangentToWorldDir(_Lerp_05179f1a9a06b084b2d83e8bce908cce_Out_3_Vector3.xyz, tangentTransform, false).xyz;
            }
            float _Split_44ee9f8d0d54618cabce22ec49a8e7d3_R_1_Float = _Transform_d583fb35b7a2838399ae5ff4e71be918_Out_1_Vector3[0];
            float _Split_44ee9f8d0d54618cabce22ec49a8e7d3_G_2_Float = _Transform_d583fb35b7a2838399ae5ff4e71be918_Out_1_Vector3[1];
            float _Split_44ee9f8d0d54618cabce22ec49a8e7d3_B_3_Float = _Transform_d583fb35b7a2838399ae5ff4e71be918_Out_1_Vector3[2];
            float _Split_44ee9f8d0d54618cabce22ec49a8e7d3_A_4_Float = 0;
            float _Multiply_61fc6a92f0e952858b5d99f2caeb09a3_Out_2_Float;
            Unity_Multiply_float_float(_Split_44ee9f8d0d54618cabce22ec49a8e7d3_G_2_Float, _Clamp_815ffdd53cc1c889aa00f73784cb71e7_Out_3_Float, _Multiply_61fc6a92f0e952858b5d99f2caeb09a3_Out_2_Float);
            float _Multiply_1e7ca8eeb2afb68a96897072c537d835_Out_2_Float;
            Unity_Multiply_float_float(_Clamp_815ffdd53cc1c889aa00f73784cb71e7_Out_3_Float, _Property_4879e96694aee98c9d4ecd329a571123_Out_0_Float, _Multiply_1e7ca8eeb2afb68a96897072c537d835_Out_2_Float);
            float _Multiply_a16d49a3ef8d76899c86b7d84d20ef1f_Out_2_Float;
            Unity_Multiply_float_float(_Multiply_1e7ca8eeb2afb68a96897072c537d835_Out_2_Float, _Multiply_4a38c41b77a2458085ff4ae52ba3c21c_Out_2_Float, _Multiply_a16d49a3ef8d76899c86b7d84d20ef1f_Out_2_Float);
            float _Multiply_dd6ce40548593687a3441a83047275eb_Out_2_Float;
            Unity_Multiply_float_float(_Multiply_61fc6a92f0e952858b5d99f2caeb09a3_Out_2_Float, _Multiply_a16d49a3ef8d76899c86b7d84d20ef1f_Out_2_Float, _Multiply_dd6ce40548593687a3441a83047275eb_Out_2_Float);
            float _Clamp_a3bc14da42d1452f9459b4703c528466_Out_3_Float;
            Unity_Clamp_float(_Multiply_dd6ce40548593687a3441a83047275eb_Out_2_Float, float(0), float(1), _Clamp_a3bc14da42d1452f9459b4703c528466_Out_3_Float);
            float _Multiply_ce9d0ae57259445ba0ff1b83b3eac7be_Out_2_Float;
            Unity_Multiply_float_float(_Clamp_bb1427696ce14fe987f799fecc5f9fac_Out_3_Float, _Clamp_a3bc14da42d1452f9459b4703c528466_Out_3_Float, _Multiply_ce9d0ae57259445ba0ff1b83b3eac7be_Out_2_Float);
            #if defined(_USEDYNAMICCOVERTSTATICMASKF)
            float _UseDynamicCover_5ab22e0469924273a6c7c42f82abda85_Out_0_Float = _Multiply_ce9d0ae57259445ba0ff1b83b3eac7be_Out_2_Float;
            #else
            float _UseDynamicCover_5ab22e0469924273a6c7c42f82abda85_Out_0_Float = _Clamp_bb1427696ce14fe987f799fecc5f9fac_Out_3_Float;
            #endif
            Bindings_UniversalHeighblend_3b5c31b864970d04197cd420b6c4b0fa_float _UniversalHeighblend_21bd55d8d402489499f7ea440e52eb45;
            float _UniversalHeighblend_21bd55d8d402489499f7ea440e52eb45_Heightmap_1_Float;
            SG_UniversalHeighblend_3b5c31b864970d04197cd420b6c4b0fa_float(_Split_a80936a3c75945efb8cf9f2b95c76642_G_2_Float, _Property_14a6757619d64822a44a69b34f85276d_Out_0_Float, _Property_c0d9ffba7dee497c885a54170977d874_Out_0_Boolean, _Split_218e1cfd00b30984921b5fc0ec63de60_B_3_Float, _Add_1f9ea9bdf36544b59f763806e7eea80d_Out_2_Vector2, _Property_0fbef18600294e199eeda9905e3304e4_Out_0_Boolean, _Split_2f45bca363698c859e51492899bc58f8_B_3_Float, _Add_28628d641d58481084e9c00e4ad5fc8d_Out_2_Vector2, _UseDynamicCover_5ab22e0469924273a6c7c42f82abda85_Out_0_Float, _UniversalHeighblend_21bd55d8d402489499f7ea440e52eb45, _UniversalHeighblend_21bd55d8d402489499f7ea440e52eb45_Heightmap_1_Float);
            float _Split_05a25ef5bb1c4867950074f8c86410e8_R_1_Float = IN.VertexColor[0];
            float _Split_05a25ef5bb1c4867950074f8c86410e8_G_2_Float = IN.VertexColor[1];
            float _Split_05a25ef5bb1c4867950074f8c86410e8_B_3_Float = IN.VertexColor[2];
            float _Split_05a25ef5bb1c4867950074f8c86410e8_A_4_Float = IN.VertexColor[3];
            float _OneMinus_0527b7625ff14e8c8ca27817ac4fe9f9_Out_1_Float;
            Unity_OneMinus_float(_Split_05a25ef5bb1c4867950074f8c86410e8_B_3_Float, _OneMinus_0527b7625ff14e8c8ca27817ac4fe9f9_Out_1_Float);
            float _Property_defdd10d24ee4948b18af67062372fb7_Out_0_Float = _VertexColorBBlendStrenght;
            float _Property_f600c3fa0837403fa7000ace8a7aa949_Out_0_Boolean = _USEBaseHeightT;
            float _Property_cc1df5222a194b39870a1906a95881c7_Out_0_Boolean = _USECoverHeightT;
            float _Subtract_df32895ca10a49a6adc84378c30ceb7c_Out_2_Float;
            Unity_Subtract_float(_Property_0e120eb0a0a14b12a31a3c1f5b961121_Out_0_Float, _Property_32b48052fdbb4641bf4eeb294bc65050_Out_0_Float, _Subtract_df32895ca10a49a6adc84378c30ceb7c_Out_2_Float);
            float _Split_a090b28818f34dd8945b893c7fd769f1_R_1_Float = IN.VertexColor[0];
            float _Split_a090b28818f34dd8945b893c7fd769f1_G_2_Float = IN.VertexColor[1];
            float _Split_a090b28818f34dd8945b893c7fd769f1_B_3_Float = IN.VertexColor[2];
            float _Split_a090b28818f34dd8945b893c7fd769f1_A_4_Float = IN.VertexColor[3];
            float _OneMinus_d11f0c4a04b345419edf8e146b9c0221_Out_1_Float;
            Unity_OneMinus_float(_Split_a090b28818f34dd8945b893c7fd769f1_B_3_Float, _OneMinus_d11f0c4a04b345419edf8e146b9c0221_Out_1_Float);
            float _Multiply_b7ff184632b347e9b3d331daaed81a77_Out_2_Float;
            Unity_Multiply_float_float(_Subtract_df32895ca10a49a6adc84378c30ceb7c_Out_2_Float, _OneMinus_d11f0c4a04b345419edf8e146b9c0221_Out_1_Float, _Multiply_b7ff184632b347e9b3d331daaed81a77_Out_2_Float);
            float _Add_ff8ced5a04044788a5de3632a403c505_Out_2_Float;
            Unity_Add_float(_Property_6b467710b0ba48058e003aebe9119249_Out_0_Float, _Multiply_b7ff184632b347e9b3d331daaed81a77_Out_2_Float, _Add_ff8ced5a04044788a5de3632a403c505_Out_2_Float);
            float2 _Add_8ec067f807d04641bea7fd38ab0c8165_Out_2_Vector2;
            Unity_Add_float2(_Vector2_6955747f7f0a4ff98fae60dbada25e89_Out_0_Vector2, (_Add_ff8ced5a04044788a5de3632a403c505_Out_2_Float.xx), _Add_8ec067f807d04641bea7fd38ab0c8165_Out_2_Vector2);
            Bindings_UniversalHeighblend_3b5c31b864970d04197cd420b6c4b0fa_float _UniversalHeighblend_69e2f839a11b4aa7b8e84d65b0ac8307;
            float _UniversalHeighblend_69e2f839a11b4aa7b8e84d65b0ac8307_Heightmap_1_Float;
            SG_UniversalHeighblend_3b5c31b864970d04197cd420b6c4b0fa_float(_OneMinus_0527b7625ff14e8c8ca27817ac4fe9f9_Out_1_Float, _Property_defdd10d24ee4948b18af67062372fb7_Out_0_Float, _Property_f600c3fa0837403fa7000ace8a7aa949_Out_0_Boolean, _Split_218e1cfd00b30984921b5fc0ec63de60_B_3_Float, _Add_1f9ea9bdf36544b59f763806e7eea80d_Out_2_Vector2, _Property_cc1df5222a194b39870a1906a95881c7_Out_0_Boolean, _Split_2f45bca363698c859e51492899bc58f8_B_3_Float, _Add_8ec067f807d04641bea7fd38ab0c8165_Out_2_Vector2, float(1), _UniversalHeighblend_69e2f839a11b4aa7b8e84d65b0ac8307, _UniversalHeighblend_69e2f839a11b4aa7b8e84d65b0ac8307_Heightmap_1_Float);
            float _Add_facc0ab0661749d4bda41177c639b438_Out_2_Float;
            Unity_Add_float(_UniversalHeighblend_21bd55d8d402489499f7ea440e52eb45_Heightmap_1_Float, _UniversalHeighblend_69e2f839a11b4aa7b8e84d65b0ac8307_Heightmap_1_Float, _Add_facc0ab0661749d4bda41177c639b438_Out_2_Float);
            float _Saturate_269cfab86e2abe83819a3afa7b3eeda2_Out_1_Float;
            Unity_Saturate_float(_Add_facc0ab0661749d4bda41177c639b438_Out_2_Float, _Saturate_269cfab86e2abe83819a3afa7b3eeda2_Out_1_Float);
            float4 _Lerp_562b79f1df34b88e9a8a7431d434b435_Out_3_Vector4;
            Unity_Lerp_float4(_Combine_b0f28916143e4b94af6bec53f5328b52_RGBA_4_Vector4, _Multiply_b08794693505bd8e8c04b9ba1610d394_Out_2_Vector4, (_Saturate_269cfab86e2abe83819a3afa7b3eeda2_Out_1_Float.xxxx), _Lerp_562b79f1df34b88e9a8a7431d434b435_Out_3_Vector4);
            float4 _Property_44d9b71d47bc4d02b6d549b527e9d094_Out_0_Vector4 = _WetColor;
            float4 _Multiply_388c575a3467b88ab4d3719bf2b02ad5_Out_2_Vector4;
            Unity_Multiply_float4_float4(_Property_44d9b71d47bc4d02b6d549b527e9d094_Out_0_Vector4, _Lerp_562b79f1df34b88e9a8a7431d434b435_Out_3_Vector4, _Multiply_388c575a3467b88ab4d3719bf2b02ad5_Out_2_Vector4);
            float4 _Clamp_33ec4dd182654e108c0f4ee43f91e820_Out_3_Vector4;
            Unity_Clamp_float4(IN.VertexColor, float4(0, 0, 0, 0), float4(1, 1, 1, 1), _Clamp_33ec4dd182654e108c0f4ee43f91e820_Out_3_Vector4);
            float _Split_5b2299b48b10138ea40c141b79bfe90e_R_1_Float = _Clamp_33ec4dd182654e108c0f4ee43f91e820_Out_3_Vector4[0];
            float _Split_5b2299b48b10138ea40c141b79bfe90e_G_2_Float = _Clamp_33ec4dd182654e108c0f4ee43f91e820_Out_3_Vector4[1];
            float _Split_5b2299b48b10138ea40c141b79bfe90e_B_3_Float = _Clamp_33ec4dd182654e108c0f4ee43f91e820_Out_3_Vector4[2];
            float _Split_5b2299b48b10138ea40c141b79bfe90e_A_4_Float = _Clamp_33ec4dd182654e108c0f4ee43f91e820_Out_3_Vector4[3];
            float _OneMinus_489965dacb44928393bb0c19acfc1dad_Out_1_Float;
            Unity_OneMinus_float(_Split_5b2299b48b10138ea40c141b79bfe90e_R_1_Float, _OneMinus_489965dacb44928393bb0c19acfc1dad_Out_1_Float);
            float4 _Lerp_9f334e8d59abc78798691219f06b2fdb_Out_3_Vector4;
            Unity_Lerp_float4(_Lerp_562b79f1df34b88e9a8a7431d434b435_Out_3_Vector4, _Multiply_388c575a3467b88ab4d3719bf2b02ad5_Out_2_Vector4, (_OneMinus_489965dacb44928393bb0c19acfc1dad_Out_1_Float.xxxx), _Lerp_9f334e8d59abc78798691219f06b2fdb_Out_3_Vector4);
            #if defined(_WETNESS_T_HEAT_F)
            float4 _WetnessTHeatF_7390507dc4254612ae0a227e5143183d_Out_0_Vector4 = _Lerp_9f334e8d59abc78798691219f06b2fdb_Out_3_Vector4;
            #else
            float4 _WetnessTHeatF_7390507dc4254612ae0a227e5143183d_Out_0_Vector4 = _Lerp_562b79f1df34b88e9a8a7431d434b435_Out_3_Vector4;
            #endif
            float _Property_16c4ac023c82618b9a5117de14716c25_Out_0_Float = _CoverNormalScale;
            float3 _NormalStrength_76b1f6b709c2558a897aa152a50733b3_Out_2_Vector3;
            Unity_NormalStrength_float((_PlanarNMn_690e893d26999680a5cea3604ed0ce16_XZ_2_Vector4.xyz), _Property_16c4ac023c82618b9a5117de14716c25_Out_0_Float, _NormalStrength_76b1f6b709c2558a897aa152a50733b3_Out_2_Vector3);
            float3 _Lerp_337d63ad6393ae88af4c89b066722a45_Out_3_Vector3;
            Unity_Lerp_float3(_NormalBlend_9f531c87e2e45580b1d0f65f06c23526_Out_2_Vector3, _NormalStrength_76b1f6b709c2558a897aa152a50733b3_Out_2_Vector3, (_Saturate_269cfab86e2abe83819a3afa7b3eeda2_Out_1_Float.xxx), _Lerp_337d63ad6393ae88af4c89b066722a45_Out_3_Vector3);
            float4 Color_e553016c85254743b6051ed07aa64a6b = IsGammaSpace() ? LinearToSRGB(float4(0, 0, 0, 0)) : float4(0, 0, 0, 0);
            float _OneMinus_4d3b7f38bc644deaa5f1d244c0b9d1ee_Out_1_Float;
            Unity_OneMinus_float(_Split_218e1cfd00b30984921b5fc0ec63de60_G_2_Float, _OneMinus_4d3b7f38bc644deaa5f1d244c0b9d1ee_Out_1_Float);
            float _Split_c179bdbdbe5d44bdb614c4a9dd684f08_R_1_Float = IN.VertexColor[0];
            float _Split_c179bdbdbe5d44bdb614c4a9dd684f08_G_2_Float = IN.VertexColor[1];
            float _Split_c179bdbdbe5d44bdb614c4a9dd684f08_B_3_Float = IN.VertexColor[2];
            float _Split_c179bdbdbe5d44bdb614c4a9dd684f08_A_4_Float = IN.VertexColor[3];
            float _Clamp_0a7dd8a8d15f4e2a9eadb3d1f311e68c_Out_3_Float;
            Unity_Clamp_float(_Split_c179bdbdbe5d44bdb614c4a9dd684f08_R_1_Float, float(0), float(1), _Clamp_0a7dd8a8d15f4e2a9eadb3d1f311e68c_Out_3_Float);
            float _OneMinus_c85200bd0b22447a928d6f06eb113bb4_Out_1_Float;
            Unity_OneMinus_float(_Clamp_0a7dd8a8d15f4e2a9eadb3d1f311e68c_Out_3_Float, _OneMinus_c85200bd0b22447a928d6f06eb113bb4_Out_1_Float);
            float _Lerp_42887225ab924c5897118a743ddf24af_Out_3_Float;
            Unity_Lerp_float(float(0), _OneMinus_4d3b7f38bc644deaa5f1d244c0b9d1ee_Out_1_Float, _OneMinus_c85200bd0b22447a928d6f06eb113bb4_Out_1_Float, _Lerp_42887225ab924c5897118a743ddf24af_Out_3_Float);
            float _Property_606dc338aeef47969895771d12f2d38b_Out_0_Float = _BaseEmissionMaskIntensivity;
            float _Multiply_ce3fb5c46004495291e3a5c1c4124a48_Out_2_Float;
            Unity_Multiply_float_float(_Lerp_42887225ab924c5897118a743ddf24af_Out_3_Float, _Property_606dc338aeef47969895771d12f2d38b_Out_0_Float, _Multiply_ce3fb5c46004495291e3a5c1c4124a48_Out_2_Float);
            float _Absolute_db426b4c7ff34d91af15c6055c7523d1_Out_1_Float;
            Unity_Absolute_float(_Multiply_ce3fb5c46004495291e3a5c1c4124a48_Out_2_Float, _Absolute_db426b4c7ff34d91af15c6055c7523d1_Out_1_Float);
            float _Property_f0a12955c88c45d4839682aabc178f68_Out_0_Float = _BaseEmissionMaskTreshold;
            float _Power_948bdcff83b44a68b06dab91a4acb8aa_Out_2_Float;
            Unity_Power_float(_Absolute_db426b4c7ff34d91af15c6055c7523d1_Out_1_Float, _Property_f0a12955c88c45d4839682aabc178f68_Out_0_Float, _Power_948bdcff83b44a68b06dab91a4acb8aa_Out_2_Float);
            float _Split_f79493bbeb184f9fa903dd435dddf63e_R_1_Float = _Power_948bdcff83b44a68b06dab91a4acb8aa_Out_2_Float;
            float _Split_f79493bbeb184f9fa903dd435dddf63e_G_2_Float = 0;
            float _Split_f79493bbeb184f9fa903dd435dddf63e_B_3_Float = 0;
            float _Split_f79493bbeb184f9fa903dd435dddf63e_A_4_Float = 0;
            float _OneMinus_859309a0dff444b080fd5111ebbfdeb1_Out_1_Float;
            Unity_OneMinus_float(_Split_2f45bca363698c859e51492899bc58f8_G_2_Float, _OneMinus_859309a0dff444b080fd5111ebbfdeb1_Out_1_Float);
            float _Lerp_45c734cedcc74e2f868233751038d219_Out_3_Float;
            Unity_Lerp_float(float(0), _OneMinus_859309a0dff444b080fd5111ebbfdeb1_Out_1_Float, _OneMinus_c85200bd0b22447a928d6f06eb113bb4_Out_1_Float, _Lerp_45c734cedcc74e2f868233751038d219_Out_3_Float);
            float _Property_16d7b20087974f05a44a14a7d1d4e79b_Out_0_Float = _CoverEmissionMaskIntensivity;
            float _Multiply_624708dce85442e5bfe57d872f174df9_Out_2_Float;
            Unity_Multiply_float_float(_Lerp_45c734cedcc74e2f868233751038d219_Out_3_Float, _Property_16d7b20087974f05a44a14a7d1d4e79b_Out_0_Float, _Multiply_624708dce85442e5bfe57d872f174df9_Out_2_Float);
            float _Absolute_4b837863fc2044808429eeb18aafedae_Out_1_Float;
            Unity_Absolute_float(_Multiply_624708dce85442e5bfe57d872f174df9_Out_2_Float, _Absolute_4b837863fc2044808429eeb18aafedae_Out_1_Float);
            float _Property_2e664738eae4446c97ad4ec20f7e2028_Out_0_Float = _CoverEmissionMaskTreshold;
            float _Power_ab72ec0c8d604ed4a93dde47371091a6_Out_2_Float;
            Unity_Power_float(_Absolute_4b837863fc2044808429eeb18aafedae_Out_1_Float, _Property_2e664738eae4446c97ad4ec20f7e2028_Out_0_Float, _Power_ab72ec0c8d604ed4a93dde47371091a6_Out_2_Float);
            float _Lerp_023dc09265f14e56ae5473ca7b26294d_Out_3_Float;
            Unity_Lerp_float(_Split_f79493bbeb184f9fa903dd435dddf63e_R_1_Float, _Power_ab72ec0c8d604ed4a93dde47371091a6_Out_2_Float, _Saturate_269cfab86e2abe83819a3afa7b3eeda2_Out_1_Float, _Lerp_023dc09265f14e56ae5473ca7b26294d_Out_3_Float);
            float4 _Property_f4a77722436441c9a77e3c23dad8b88e_Out_0_Vector4 = IsGammaSpace() ? LinearToSRGB(_LavaEmissionColor) : _LavaEmissionColor;
            float4 _Multiply_4ffe85e4185949c6ac7d540068494138_Out_2_Vector4;
            Unity_Multiply_float4_float4((_Lerp_023dc09265f14e56ae5473ca7b26294d_Out_3_Float.xxxx), _Property_f4a77722436441c9a77e3c23dad8b88e_Out_0_Vector4, _Multiply_4ffe85e4185949c6ac7d540068494138_Out_2_Vector4);
            UnityTexture2D _Property_00795552653740bb881853e3daf2cf3f_Out_0_Texture2D = UnityBuildTexture2DStructNoScale(_Noise);
            float4 _Property_006d4241a7524b2583b5cc3097ff74ca_Out_0_Vector4 = _Emission_Noise_Tiling_and_Offset;
            float _Split_73d52870da5a455bb786b2c0fc9492c2_R_1_Float = _Property_006d4241a7524b2583b5cc3097ff74ca_Out_0_Vector4[0];
            float _Split_73d52870da5a455bb786b2c0fc9492c2_G_2_Float = _Property_006d4241a7524b2583b5cc3097ff74ca_Out_0_Vector4[1];
            float _Split_73d52870da5a455bb786b2c0fc9492c2_B_3_Float = _Property_006d4241a7524b2583b5cc3097ff74ca_Out_0_Vector4[2];
            float _Split_73d52870da5a455bb786b2c0fc9492c2_A_4_Float = _Property_006d4241a7524b2583b5cc3097ff74ca_Out_0_Vector4[3];
            float2 _Vector2_158f933d3fcd425392974c5cbc3cd56d_Out_0_Vector2 = float2(_Split_73d52870da5a455bb786b2c0fc9492c2_B_3_Float, _Split_73d52870da5a455bb786b2c0fc9492c2_A_4_Float);
            float2 _Property_40c7afe0030e415f8a1d31eeeb6b7393_Out_0_Vector2 = _NoiseSpeed;
            float _TimeCustomFunction_e6f001ad051b4ab78d1e2e9ddff8a244_Out_0_Float;
            Time_float(_TimeCustomFunction_e6f001ad051b4ab78d1e2e9ddff8a244_Out_0_Float);
            float2 _Multiply_8c6b65dd9b814c2da6a4483fda26ec51_Out_2_Vector2;
            Unity_Multiply_float2_float2(_Property_40c7afe0030e415f8a1d31eeeb6b7393_Out_0_Vector2, (_TimeCustomFunction_e6f001ad051b4ab78d1e2e9ddff8a244_Out_0_Float.xx), _Multiply_8c6b65dd9b814c2da6a4483fda26ec51_Out_2_Vector2);
            float2 _Add_4e8254b7e8c447d1af503ec6b1d99df6_Out_2_Vector2;
            Unity_Add_float2(_Vector2_158f933d3fcd425392974c5cbc3cd56d_Out_0_Vector2, _Multiply_8c6b65dd9b814c2da6a4483fda26ec51_Out_2_Vector2, _Add_4e8254b7e8c447d1af503ec6b1d99df6_Out_2_Vector2);
            float _Split_952b7b5a519048aeb5301164f67dd18a_R_1_Float = _Add_4e8254b7e8c447d1af503ec6b1d99df6_Out_2_Vector2[0];
            float _Split_952b7b5a519048aeb5301164f67dd18a_G_2_Float = _Add_4e8254b7e8c447d1af503ec6b1d99df6_Out_2_Vector2[1];
            float _Split_952b7b5a519048aeb5301164f67dd18a_B_3_Float = 0;
            float _Split_952b7b5a519048aeb5301164f67dd18a_A_4_Float = 0;
            float4 _Vector4_92e5675ce4234ea8a8198220bb39b015_Out_0_Vector4 = float4(_Split_73d52870da5a455bb786b2c0fc9492c2_R_1_Float, _Split_73d52870da5a455bb786b2c0fc9492c2_G_2_Float, _Split_952b7b5a519048aeb5301164f67dd18a_R_1_Float, _Split_952b7b5a519048aeb5301164f67dd18a_G_2_Float);
            float _Property_278fd9fc173e4625a1df64a92ba39390_Out_0_Boolean = _EmissionNoiseUsePlanarUV;
            float _Property_4b43a2e8035f4d20a5aa3c0d056dc9b8_Out_0_Boolean = Emission_Noise_UV0_UV3;
            Bindings_PlanarNM_c0f081da9c567704ea36e7dd38cedcf6_float _PlanarNM_9f397ccc775f4957b919b19d5b986acf;
            _PlanarNM_9f397ccc775f4957b919b19d5b986acf.AbsoluteWorldSpacePosition = IN.AbsoluteWorldSpacePosition;
            _PlanarNM_9f397ccc775f4957b919b19d5b986acf.uv0 = IN.uv0;
            _PlanarNM_9f397ccc775f4957b919b19d5b986acf.uv3 = IN.uv3;
            float4 _PlanarNM_9f397ccc775f4957b919b19d5b986acf_XZ_2_Vector4;
            SG_PlanarNM_c0f081da9c567704ea36e7dd38cedcf6_float(_Property_00795552653740bb881853e3daf2cf3f_Out_0_Texture2D, _Vector4_92e5675ce4234ea8a8198220bb39b015_Out_0_Vector4, _Property_278fd9fc173e4625a1df64a92ba39390_Out_0_Boolean, UnityBuildSamplerStateStruct(SamplerState_Linear_Repeat), _Property_4b43a2e8035f4d20a5aa3c0d056dc9b8_Out_0_Boolean, _PlanarNM_9f397ccc775f4957b919b19d5b986acf, _PlanarNM_9f397ccc775f4957b919b19d5b986acf_XZ_2_Vector4);
            float _Split_ad5f3d981abc4297be097b02598cbf16_R_1_Float = _PlanarNM_9f397ccc775f4957b919b19d5b986acf_XZ_2_Vector4[0];
            float _Split_ad5f3d981abc4297be097b02598cbf16_G_2_Float = _PlanarNM_9f397ccc775f4957b919b19d5b986acf_XZ_2_Vector4[1];
            float _Split_ad5f3d981abc4297be097b02598cbf16_B_3_Float = _PlanarNM_9f397ccc775f4957b919b19d5b986acf_XZ_2_Vector4[2];
            float _Split_ad5f3d981abc4297be097b02598cbf16_A_4_Float = _PlanarNM_9f397ccc775f4957b919b19d5b986acf_XZ_2_Vector4[3];
            float2 _Multiply_10da8cfb1b844c91b029f95ae9ec5b8f_Out_2_Vector2;
            Unity_Multiply_float2_float2(_Add_4e8254b7e8c447d1af503ec6b1d99df6_Out_2_Vector2, float2(-1.2, -0.9), _Multiply_10da8cfb1b844c91b029f95ae9ec5b8f_Out_2_Vector2);
            float2 _Add_307dce75a10243509597c2a661e556e7_Out_2_Vector2;
            Unity_Add_float2(_Multiply_10da8cfb1b844c91b029f95ae9ec5b8f_Out_2_Vector2, float2(0.5, 0.5), _Add_307dce75a10243509597c2a661e556e7_Out_2_Vector2);
            float _Split_d80e19706e9c48a69346db34ed2e1279_R_1_Float = _Add_307dce75a10243509597c2a661e556e7_Out_2_Vector2[0];
            float _Split_d80e19706e9c48a69346db34ed2e1279_G_2_Float = _Add_307dce75a10243509597c2a661e556e7_Out_2_Vector2[1];
            float _Split_d80e19706e9c48a69346db34ed2e1279_B_3_Float = 0;
            float _Split_d80e19706e9c48a69346db34ed2e1279_A_4_Float = 0;
            float4 _Vector4_96981646541d4722b5ef09551f6c683c_Out_0_Vector4 = float4(_Split_73d52870da5a455bb786b2c0fc9492c2_R_1_Float, _Split_73d52870da5a455bb786b2c0fc9492c2_G_2_Float, _Split_d80e19706e9c48a69346db34ed2e1279_R_1_Float, _Split_d80e19706e9c48a69346db34ed2e1279_G_2_Float);
            Bindings_PlanarNM_c0f081da9c567704ea36e7dd38cedcf6_float _PlanarNM_f19fcf05a02e4741a756f5cc341b4f5e;
            _PlanarNM_f19fcf05a02e4741a756f5cc341b4f5e.AbsoluteWorldSpacePosition = IN.AbsoluteWorldSpacePosition;
            _PlanarNM_f19fcf05a02e4741a756f5cc341b4f5e.uv0 = IN.uv0;
            _PlanarNM_f19fcf05a02e4741a756f5cc341b4f5e.uv3 = IN.uv3;
            float4 _PlanarNM_f19fcf05a02e4741a756f5cc341b4f5e_XZ_2_Vector4;
            SG_PlanarNM_c0f081da9c567704ea36e7dd38cedcf6_float(_Property_00795552653740bb881853e3daf2cf3f_Out_0_Texture2D, _Vector4_96981646541d4722b5ef09551f6c683c_Out_0_Vector4, _Property_278fd9fc173e4625a1df64a92ba39390_Out_0_Boolean, UnityBuildSamplerStateStruct(SamplerState_Linear_Repeat), _Property_4b43a2e8035f4d20a5aa3c0d056dc9b8_Out_0_Boolean, _PlanarNM_f19fcf05a02e4741a756f5cc341b4f5e, _PlanarNM_f19fcf05a02e4741a756f5cc341b4f5e_XZ_2_Vector4);
            float _Split_d5ec4f4d1e024709846d0576eb89bbca_R_1_Float = _PlanarNM_f19fcf05a02e4741a756f5cc341b4f5e_XZ_2_Vector4[0];
            float _Split_d5ec4f4d1e024709846d0576eb89bbca_G_2_Float = _PlanarNM_f19fcf05a02e4741a756f5cc341b4f5e_XZ_2_Vector4[1];
            float _Split_d5ec4f4d1e024709846d0576eb89bbca_B_3_Float = _PlanarNM_f19fcf05a02e4741a756f5cc341b4f5e_XZ_2_Vector4[2];
            float _Split_d5ec4f4d1e024709846d0576eb89bbca_A_4_Float = _PlanarNM_f19fcf05a02e4741a756f5cc341b4f5e_XZ_2_Vector4[3];
            float _Minimum_cd1daa7571e84585a203f83a48d8831a_Out_2_Float;
            Unity_Minimum_float(_Split_ad5f3d981abc4297be097b02598cbf16_A_4_Float, _Split_d5ec4f4d1e024709846d0576eb89bbca_A_4_Float, _Minimum_cd1daa7571e84585a203f83a48d8831a_Out_2_Float);
            float _Property_e7aef1fd7db945f2b6cf08be86efb1da_Out_0_Float = _EmissionNoiseMultiply;
            float _Multiply_36ffbb52845a491aa68eb4198a1a38e1_Out_2_Float;
            Unity_Multiply_float_float(_Minimum_cd1daa7571e84585a203f83a48d8831a_Out_2_Float, _Property_e7aef1fd7db945f2b6cf08be86efb1da_Out_0_Float, _Multiply_36ffbb52845a491aa68eb4198a1a38e1_Out_2_Float);
            float _Clamp_1406bf6d718c47639db90df3e930ec88_Out_3_Float;
            Unity_Clamp_float(_Multiply_36ffbb52845a491aa68eb4198a1a38e1_Out_2_Float, float(0), float(1), _Clamp_1406bf6d718c47639db90df3e930ec88_Out_3_Float);
            float _Absolute_25371384e8aa40f7a1a8143c24daafa7_Out_1_Float;
            Unity_Absolute_float(_Clamp_1406bf6d718c47639db90df3e930ec88_Out_3_Float, _Absolute_25371384e8aa40f7a1a8143c24daafa7_Out_1_Float);
            float _Property_b14cce2aa2354622a768385b02f85470_Out_0_Float = _EmissionNoisePower;
            float _Power_f1ee1566c8384717963cc242dd98650a_Out_2_Float;
            Unity_Power_float(_Absolute_25371384e8aa40f7a1a8143c24daafa7_Out_1_Float, _Property_b14cce2aa2354622a768385b02f85470_Out_0_Float, _Power_f1ee1566c8384717963cc242dd98650a_Out_2_Float);
            float _Multiply_34e318c6bc414a92baf58b6c0c43c29f_Out_2_Float;
            Unity_Multiply_float_float(_Power_f1ee1566c8384717963cc242dd98650a_Out_2_Float, 20, _Multiply_34e318c6bc414a92baf58b6c0c43c29f_Out_2_Float);
            float _Clamp_bec0a9e722c641748d5e70491cb9a2b2_Out_3_Float;
            Unity_Clamp_float(_Multiply_34e318c6bc414a92baf58b6c0c43c29f_Out_2_Float, float(0.05), float(1.2), _Clamp_bec0a9e722c641748d5e70491cb9a2b2_Out_3_Float);
            float4 _Multiply_7645a5b5112a49bca08420cfface3451_Out_2_Vector4;
            Unity_Multiply_float4_float4(_Multiply_4ffe85e4185949c6ac7d540068494138_Out_2_Vector4, (_Clamp_bec0a9e722c641748d5e70491cb9a2b2_Out_3_Float.xxxx), _Multiply_7645a5b5112a49bca08420cfface3451_Out_2_Vector4);
            float4 _Property_ca86ca33c2ae4885ba38452d9e56a7e5_Out_0_Vector4 = IsGammaSpace() ? LinearToSRGB(_RimColor) : _RimColor;
            float3 _Normalize_c4982c8cad634f628b5c428f3d903c7d_Out_1_Vector3;
            Unity_Normalize_float3(IN.TangentSpaceViewDirection, _Normalize_c4982c8cad634f628b5c428f3d903c7d_Out_1_Vector3);
            float _DotProduct_159813334d0546d1b48a9b61ad70a171_Out_2_Float;
            Unity_DotProduct_float3(_Lerp_337d63ad6393ae88af4c89b066722a45_Out_3_Vector3, _Normalize_c4982c8cad634f628b5c428f3d903c7d_Out_1_Vector3, _DotProduct_159813334d0546d1b48a9b61ad70a171_Out_2_Float);
            float _Saturate_5a5aac19081c4d4b8903fc7860f9a0c2_Out_1_Float;
            Unity_Saturate_float(_DotProduct_159813334d0546d1b48a9b61ad70a171_Out_2_Float, _Saturate_5a5aac19081c4d4b8903fc7860f9a0c2_Out_1_Float);
            float _OneMinus_ef8f9d7083b54e2885c1382b817e2652_Out_1_Float;
            Unity_OneMinus_float(_Saturate_5a5aac19081c4d4b8903fc7860f9a0c2_Out_1_Float, _OneMinus_ef8f9d7083b54e2885c1382b817e2652_Out_1_Float);
            float _Absolute_f6a29424054e4847b2545876315446e9_Out_1_Float;
            Unity_Absolute_float(_OneMinus_ef8f9d7083b54e2885c1382b817e2652_Out_1_Float, _Absolute_f6a29424054e4847b2545876315446e9_Out_1_Float);
            float _Power_57bee61abc694e7d8946acd86e5c7471_Out_2_Float;
            Unity_Power_float(_Absolute_f6a29424054e4847b2545876315446e9_Out_1_Float, float(10), _Power_57bee61abc694e7d8946acd86e5c7471_Out_2_Float);
            float4 _Multiply_8bcb4ce8918a4b2a9e321cfb7b2212ed_Out_2_Vector4;
            Unity_Multiply_float4_float4(_Property_ca86ca33c2ae4885ba38452d9e56a7e5_Out_0_Vector4, (_Power_57bee61abc694e7d8946acd86e5c7471_Out_2_Float.xxxx), _Multiply_8bcb4ce8918a4b2a9e321cfb7b2212ed_Out_2_Vector4);
            float _Property_aee69b4a68284a749ad0eeb6f13105cd_Out_0_Float = _RimLightPower;
            float4 _Multiply_5626d1059bb54a5e9499b3f53d1b5904_Out_2_Vector4;
            Unity_Multiply_float4_float4(_Multiply_8bcb4ce8918a4b2a9e321cfb7b2212ed_Out_2_Vector4, (_Property_aee69b4a68284a749ad0eeb6f13105cd_Out_0_Float.xxxx), _Multiply_5626d1059bb54a5e9499b3f53d1b5904_Out_2_Vector4);
            float4 _Multiply_c4b66106a8a0468aab2f1323013186d7_Out_2_Vector4;
            Unity_Multiply_float4_float4((_Lerp_023dc09265f14e56ae5473ca7b26294d_Out_3_Float.xxxx), _Multiply_5626d1059bb54a5e9499b3f53d1b5904_Out_2_Vector4, _Multiply_c4b66106a8a0468aab2f1323013186d7_Out_2_Vector4);
            float4 _Add_74f0b45c2e704e74a319f41d62506eed_Out_2_Vector4;
            Unity_Add_float4(_Multiply_7645a5b5112a49bca08420cfface3451_Out_2_Vector4, _Multiply_c4b66106a8a0468aab2f1323013186d7_Out_2_Vector4, _Add_74f0b45c2e704e74a319f41d62506eed_Out_2_Vector4);
            float4 _Clamp_cacf98ce9e9044c4986500fac50caa89_Out_3_Vector4;
            Unity_Clamp_float4(_Add_74f0b45c2e704e74a319f41d62506eed_Out_2_Vector4, float4(0, 0, 0, 0), _Add_74f0b45c2e704e74a319f41d62506eed_Out_2_Vector4, _Clamp_cacf98ce9e9044c4986500fac50caa89_Out_3_Vector4);
            #if defined(_WETNESS_T_HEAT_F)
            float4 _WetnessTHeatF_e4281f82d9f54deca38dcc29b0789b9b_Out_0_Vector4 = Color_e553016c85254743b6051ed07aa64a6b;
            #else
            float4 _WetnessTHeatF_e4281f82d9f54deca38dcc29b0789b9b_Out_0_Vector4 = _Clamp_cacf98ce9e9044c4986500fac50caa89_Out_3_Vector4;
            #endif
            float _Property_bbb7f63dc018f9828732f80495a95444_Out_0_Float = _BaseMetallic;
            float _Multiply_ee089bb3595c0c8da7ca2ff054def6d5_Out_2_Float;
            Unity_Multiply_float_float(_Split_218e1cfd00b30984921b5fc0ec63de60_R_1_Float, _Property_bbb7f63dc018f9828732f80495a95444_Out_0_Float, _Multiply_ee089bb3595c0c8da7ca2ff054def6d5_Out_2_Float);
            float _Property_8142f12b781ad08680220297dab56f14_Out_0_Float = _BaseAORemapMin;
            float _Property_48e1c5285b48c78e8af19e38f4bd77f9_Out_0_Float = _BaseAORemapMax;
            float2 _Vector2_344526038e228b85ad9c2d33f000c5ea_Out_0_Vector2 = float2(_Property_8142f12b781ad08680220297dab56f14_Out_0_Float, _Property_48e1c5285b48c78e8af19e38f4bd77f9_Out_0_Float);
            float _Remap_f4684fae31257d82aa14c39233760e21_Out_3_Float;
            Unity_Remap_float(_Split_218e1cfd00b30984921b5fc0ec63de60_G_2_Float, float2 (0, 1), _Vector2_344526038e228b85ad9c2d33f000c5ea_Out_0_Vector2, _Remap_f4684fae31257d82aa14c39233760e21_Out_3_Float);
            float _Property_0682b9e13137ec8f8de23962e6db211c_Out_0_Float = _BaseSmoothnessRemapMin;
            float _Property_0edea7916ed7a189a62b0faf2c274601_Out_0_Float = _BaseSmoothnessRemapMax;
            float2 _Vector2_8d45bee64b64f087b44fb9b02317dfdd_Out_0_Vector2 = float2(_Property_0682b9e13137ec8f8de23962e6db211c_Out_0_Float, _Property_0edea7916ed7a189a62b0faf2c274601_Out_0_Float);
            float _Remap_857d26677c8e8a809704b89dbca71045_Out_3_Float;
            Unity_Remap_float(_Split_218e1cfd00b30984921b5fc0ec63de60_A_4_Float, float2 (0, 1), _Vector2_8d45bee64b64f087b44fb9b02317dfdd_Out_0_Vector2, _Remap_857d26677c8e8a809704b89dbca71045_Out_3_Float);
            float _Multiply_0248fa77a8136c81b6e9a6bbf4b8ae44_Out_2_Float;
            Unity_Multiply_float_float(_SampleTexture2D_d8eb0186b9a0cd819cde65431b4ea5ea_B_6_Float, 2, _Multiply_0248fa77a8136c81b6e9a6bbf4b8ae44_Out_2_Float);
            float _Add_c58fd9db8613298bb7c10a8054cbe39a_Out_2_Float;
            Unity_Add_float(_Multiply_0248fa77a8136c81b6e9a6bbf4b8ae44_Out_2_Float, float(-1), _Add_c58fd9db8613298bb7c10a8054cbe39a_Out_2_Float);
            float _Property_cea4e47b293a988a83643b43f76c92ba_Out_0_Float = _DetailSmoothnessScale;
            float _Multiply_2008466558f0e4819e60b3c41d94487c_Out_2_Float;
            Unity_Multiply_float_float(_Add_c58fd9db8613298bb7c10a8054cbe39a_Out_2_Float, _Property_cea4e47b293a988a83643b43f76c92ba_Out_0_Float, _Multiply_2008466558f0e4819e60b3c41d94487c_Out_2_Float);
            float _Saturate_3d70f31d57bf638291bde1017f7f7782_Out_1_Float;
            Unity_Saturate_float(_Multiply_2008466558f0e4819e60b3c41d94487c_Out_2_Float, _Saturate_3d70f31d57bf638291bde1017f7f7782_Out_1_Float);
            float _Absolute_9df346239512598fa5a33dfdc91746c0_Out_1_Float;
            Unity_Absolute_float(_Saturate_3d70f31d57bf638291bde1017f7f7782_Out_1_Float, _Absolute_9df346239512598fa5a33dfdc91746c0_Out_1_Float);
            Bindings_BlendOverlayDetailSmoothness_06e12138dc89c0040b45a57abe520a1a_float _BlendOverlayDetailSmoothness_bf930d30c7c40486b65597615e35de43;
            float _BlendOverlayDetailSmoothness_bf930d30c7c40486b65597615e35de43_SmoothnessOverlay_1_Float;
            SG_BlendOverlayDetailSmoothness_06e12138dc89c0040b45a57abe520a1a_float(_Remap_857d26677c8e8a809704b89dbca71045_Out_3_Float, _Add_c58fd9db8613298bb7c10a8054cbe39a_Out_2_Float, _Absolute_9df346239512598fa5a33dfdc91746c0_Out_1_Float, _BlendOverlayDetailSmoothness_bf930d30c7c40486b65597615e35de43, _BlendOverlayDetailSmoothness_bf930d30c7c40486b65597615e35de43_SmoothnessOverlay_1_Float);
            float _Saturate_52f6692b8656668b837aebcf2f45f921_Out_1_Float;
            Unity_Saturate_float(_BlendOverlayDetailSmoothness_bf930d30c7c40486b65597615e35de43_SmoothnessOverlay_1_Float, _Saturate_52f6692b8656668b837aebcf2f45f921_Out_1_Float);
            float3 _Vector3_1f83d62db7392b81beeecb62c44f56c5_Out_0_Vector3 = float3(_Multiply_ee089bb3595c0c8da7ca2ff054def6d5_Out_2_Float, _Remap_f4684fae31257d82aa14c39233760e21_Out_3_Float, _Saturate_52f6692b8656668b837aebcf2f45f921_Out_1_Float);
            float _Property_0187ddd5583a3d86a3c4c2444b45e777_Out_0_Float = _CoverMetallic;
            float _Multiply_0248a4a17e4abe868ff7c5ec2a5c8d2f_Out_2_Float;
            Unity_Multiply_float_float(_Split_2f45bca363698c859e51492899bc58f8_R_1_Float, _Property_0187ddd5583a3d86a3c4c2444b45e777_Out_0_Float, _Multiply_0248a4a17e4abe868ff7c5ec2a5c8d2f_Out_2_Float);
            float _Property_5cc07bc49e1bf582b5c1b52606eec56f_Out_0_Float = _CoverAORemapMin;
            float _Property_506cf024c6db098fbc150277952a7bee_Out_0_Float = _CoverAORemapMax;
            float2 _Vector2_ffa116a725445282a83acc70377ff4e1_Out_0_Vector2 = float2(_Property_5cc07bc49e1bf582b5c1b52606eec56f_Out_0_Float, _Property_506cf024c6db098fbc150277952a7bee_Out_0_Float);
            float _Remap_02e4c7480ddeca88aa886be18ce15353_Out_3_Float;
            Unity_Remap_float(_Split_2f45bca363698c859e51492899bc58f8_G_2_Float, float2 (0, 1), _Vector2_ffa116a725445282a83acc70377ff4e1_Out_0_Vector2, _Remap_02e4c7480ddeca88aa886be18ce15353_Out_3_Float);
            float _Property_36782180ac25b489baf611efb6d0d9ed_Out_0_Float = _CoverSmoothnessRemapMin;
            float _Property_6c0666df4add418b8e32b0e4275b1c27_Out_0_Float = _CoverSmoothnessRemapMax;
            float2 _Vector2_b0c047c56338e78abcd740717a8d6900_Out_0_Vector2 = float2(_Property_36782180ac25b489baf611efb6d0d9ed_Out_0_Float, _Property_6c0666df4add418b8e32b0e4275b1c27_Out_0_Float);
            float _Remap_1f96cc6fc648098f8cb49680f75d5a1e_Out_3_Float;
            Unity_Remap_float(_Split_2f45bca363698c859e51492899bc58f8_A_4_Float, float2 (0, 1), _Vector2_b0c047c56338e78abcd740717a8d6900_Out_0_Vector2, _Remap_1f96cc6fc648098f8cb49680f75d5a1e_Out_3_Float);
            float3 _Vector3_48cf085b9f7fd28e89fe4361decf0fec_Out_0_Vector3 = float3(_Multiply_0248a4a17e4abe868ff7c5ec2a5c8d2f_Out_2_Float, _Remap_02e4c7480ddeca88aa886be18ce15353_Out_3_Float, _Remap_1f96cc6fc648098f8cb49680f75d5a1e_Out_3_Float);
            float3 _Lerp_48cc6a544b837c85a967cc83aab4e3fb_Out_3_Vector3;
            Unity_Lerp_float3(_Vector3_1f83d62db7392b81beeecb62c44f56c5_Out_0_Vector3, _Vector3_48cf085b9f7fd28e89fe4361decf0fec_Out_0_Vector3, (_Saturate_269cfab86e2abe83819a3afa7b3eeda2_Out_1_Float.xxx), _Lerp_48cc6a544b837c85a967cc83aab4e3fb_Out_3_Vector3);
            float _Split_645358fc1f0e278fbfc2ccb5594c95e3_R_1_Float = _Lerp_48cc6a544b837c85a967cc83aab4e3fb_Out_3_Vector3[0];
            float _Split_645358fc1f0e278fbfc2ccb5594c95e3_G_2_Float = _Lerp_48cc6a544b837c85a967cc83aab4e3fb_Out_3_Vector3[1];
            float _Split_645358fc1f0e278fbfc2ccb5594c95e3_B_3_Float = _Lerp_48cc6a544b837c85a967cc83aab4e3fb_Out_3_Vector3[2];
            float _Split_645358fc1f0e278fbfc2ccb5594c95e3_A_4_Float = 0;
            float _Property_006bb9304a39f5808cf13865f8c36ad4_Out_0_Float = _WetSmoothness;
            float _Lerp_02403a8fb24f4c8fb8bd6dbe84811d9a_Out_3_Float;
            Unity_Lerp_float(_Split_645358fc1f0e278fbfc2ccb5594c95e3_B_3_Float, _Property_006bb9304a39f5808cf13865f8c36ad4_Out_0_Float, _OneMinus_489965dacb44928393bb0c19acfc1dad_Out_1_Float, _Lerp_02403a8fb24f4c8fb8bd6dbe84811d9a_Out_3_Float);
            #if defined(_WETNESS_T_HEAT_F)
            float _WetnessTHeatF_a6ec97cf99bb4b93a57ba2146f13f8ef_Out_0_Float = _Lerp_02403a8fb24f4c8fb8bd6dbe84811d9a_Out_3_Float;
            #else
            float _WetnessTHeatF_a6ec97cf99bb4b93a57ba2146f13f8ef_Out_0_Float = _Split_645358fc1f0e278fbfc2ccb5594c95e3_B_3_Float;
            #endif
            float _Split_546cdec490fe4753bb0983eea82b45b5_R_1_Float = _Lerp_562b79f1df34b88e9a8a7431d434b435_Out_3_Vector4[0];
            float _Split_546cdec490fe4753bb0983eea82b45b5_G_2_Float = _Lerp_562b79f1df34b88e9a8a7431d434b435_Out_3_Vector4[1];
            float _Split_546cdec490fe4753bb0983eea82b45b5_B_3_Float = _Lerp_562b79f1df34b88e9a8a7431d434b435_Out_3_Vector4[2];
            float _Split_546cdec490fe4753bb0983eea82b45b5_A_4_Float = _Lerp_562b79f1df34b88e9a8a7431d434b435_Out_3_Vector4[3];
            float _Multiply_a7796e97d268424b880f9cb87fc6e42c_Out_2_Float;
            Unity_Multiply_float_float(_Split_546cdec490fe4753bb0983eea82b45b5_A_4_Float, _Split_5b2299b48b10138ea40c141b79bfe90e_A_4_Float, _Multiply_a7796e97d268424b880f9cb87fc6e42c_Out_2_Float);
            float _Property_7ae68b65d6ed4f37aec08ecb89701e8e_Out_0_Float = _AlphaCutoff;
            surface.BaseColor = (_WetnessTHeatF_7390507dc4254612ae0a227e5143183d_Out_0_Vector4.xyz);
            surface.NormalTS = _Lerp_337d63ad6393ae88af4c89b066722a45_Out_3_Vector3;
            surface.Emission = (_WetnessTHeatF_e4281f82d9f54deca38dcc29b0789b9b_Out_0_Vector4.xyz);
            surface.Metallic = _Split_645358fc1f0e278fbfc2ccb5594c95e3_R_1_Float;
            surface.Specular = IsGammaSpace() ? float3(0.5, 0.5, 0.5) : SRGBToLinear(float3(0.5, 0.5, 0.5));
            surface.Smoothness = _WetnessTHeatF_a6ec97cf99bb4b93a57ba2146f13f8ef_Out_0_Float;
            surface.Occlusion = _Split_645358fc1f0e278fbfc2ccb5594c95e3_G_2_Float;
            surface.Alpha = _Multiply_a7796e97d268424b880f9cb87fc6e42c_Out_2_Float;
            surface.AlphaClipThreshold = _Property_7ae68b65d6ed4f37aec08ecb89701e8e_Out_0_Float;
            return surface;
        }
        
        // --------------------------------------------------
        // Build Graph Inputs
        #ifdef HAVE_VFX_MODIFICATION
        #define VFX_SRP_ATTRIBUTES Attributes
        #define VFX_SRP_VARYINGS Varyings
        #define VFX_SRP_SURFACE_INPUTS SurfaceDescriptionInputs
        #endif
        VertexDescriptionInputs BuildVertexDescriptionInputs(Attributes input)
        {
            VertexDescriptionInputs output;
            ZERO_INITIALIZE(VertexDescriptionInputs, output);
        
            output.ObjectSpaceNormal =                          input.normalOS;
            output.ObjectSpaceTangent =                         input.tangentOS.xyz;
            output.ObjectSpacePosition =                        input.positionOS;
        #if UNITY_ANY_INSTANCING_ENABLED
        #else // TODO: XR support for procedural instancing because in this case UNITY_ANY_INSTANCING_ENABLED is not defined and instanceID is incorrect.
        #endif
        
            return output;
        }
        SurfaceDescriptionInputs BuildSurfaceDescriptionInputs(Varyings input)
        {
            SurfaceDescriptionInputs output;
            ZERO_INITIALIZE(SurfaceDescriptionInputs, output);
        
        #ifdef HAVE_VFX_MODIFICATION
        #if VFX_USE_GRAPH_VALUES
            uint instanceActiveIndex = asuint(UNITY_ACCESS_INSTANCED_PROP(PerInstance, _InstanceActiveIndex));
            /* WARNING: $splice Could not find named fragment 'VFXLoadGraphValues' */
        #endif
            /* WARNING: $splice Could not find named fragment 'VFXSetFragInputs' */
        
        #endif
        
            
        
            // must use interpolated tangent, bitangent and normal before they are normalized in the pixel shader.
            float3 unnormalizedNormalWS = input.normalWS;
            const float renormFactor = 1.0 / length(unnormalizedNormalWS);
        
            // use bitangent on the fly like in hdrp
            // IMPORTANT! If we ever support Flip on double sided materials ensure bitangent and tangent are NOT flipped.
            float crossSign = (input.tangentWS.w > 0.0 ? 1.0 : -1.0)* GetOddNegativeScale();
            float3 bitang = crossSign * cross(input.normalWS.xyz, input.tangentWS.xyz);
        
            output.WorldSpaceNormal = renormFactor * input.normalWS.xyz;      // we want a unit length Normal Vector node in shader graph
            output.TangentSpaceNormal = float3(0.0f, 0.0f, 1.0f);
        
            // to pr               eserve mikktspace compliance we use same scale renormFactor as was used on the normal.
            // This                is explained in section 2.2 in "surface gradient based bump mapping framework"
            output.WorldSpaceTangent = renormFactor * input.tangentWS.xyz;
            output.WorldSpaceBiTangent = renormFactor * bitang;
        
            output.WorldSpaceViewDirection = GetWorldSpaceNormalizeViewDir(input.positionWS);
            float3x3 tangentSpaceTransform = float3x3(output.WorldSpaceTangent, output.WorldSpaceBiTangent, output.WorldSpaceNormal);
            output.TangentSpaceViewDirection = mul(tangentSpaceTransform, output.WorldSpaceViewDirection);
            output.AbsoluteWorldSpacePosition = GetAbsolutePositionWS(input.positionWS);
        
            #if UNITY_UV_STARTS_AT_TOP
            #else
            #endif
        
        
            output.uv0 = input.texCoord0;
            output.uv3 = input.texCoord3;
            output.VertexColor = input.color;
        #if UNITY_ANY_INSTANCING_ENABLED
        #else // TODO: XR support for procedural instancing because in this case UNITY_ANY_INSTANCING_ENABLED is not defined and instanceID is incorrect.
        #endif
        #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
        #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN output.FaceSign =                    IS_FRONT_VFACE(input.cullFace, true, false);
        #else
        #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
        #endif
        #undef BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
        
                return output;
        }
        
        // --------------------------------------------------
        // Main
        
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/Varyings.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/GBufferOutput.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/PBRGBufferPass.hlsl"
        
        // --------------------------------------------------
        // Visual Effect Vertex Invocations
        #ifdef HAVE_VFX_MODIFICATION
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/VisualEffectVertex.hlsl"
        #endif
        
        ENDHLSL
        }
        Pass
        {
            Name "ShadowCaster"
            Tags
            {
                "LightMode" = "ShadowCaster"
            }
        
        // Render State
        Cull [_Cull]
        ZTest LEqual
        ZWrite On
        ColorMask 0
        
        // Debug
        // <None>
        
        // --------------------------------------------------
        // Pass
        
        HLSLPROGRAM
        
        // Pragmas
        #pragma target 2.0
        #pragma multi_compile_instancing
        #pragma vertex vert
        #pragma fragment frag
        
        // Keywords
        #pragma multi_compile_vertex _ _CASTING_PUNCTUAL_LIGHT_SHADOW
        #pragma shader_feature_local_fragment _ _ALPHATEST_ON
        #pragma multi_compile _ LOD_FADE_CROSSFADE
        #pragma shader_feature_local _ _USEDYNAMICCOVERTSTATICMASKF
        #pragma shader_feature_local _ _WETNESS_T_HEAT_F
        
        #if defined(_USEDYNAMICCOVERTSTATICMASKF) && defined(_WETNESS_T_HEAT_F)
            #define KEYWORD_PERMUTATION_0
        #elif defined(_USEDYNAMICCOVERTSTATICMASKF)
            #define KEYWORD_PERMUTATION_1
        #elif defined(_WETNESS_T_HEAT_F)
            #define KEYWORD_PERMUTATION_2
        #else
            #define KEYWORD_PERMUTATION_3
        #endif
        
        
        // Defines
        
        #define _NORMALMAP 1
        #define _NORMAL_DROPOFF_TS 1
        #define ATTRIBUTES_NEED_NORMAL
        #define ATTRIBUTES_NEED_TANGENT
        #define ATTRIBUTES_NEED_TEXCOORD0
        #define ATTRIBUTES_NEED_TEXCOORD3
        #define ATTRIBUTES_NEED_COLOR
        #define FEATURES_GRAPH_VERTEX_NORMAL_OUTPUT
        #define FEATURES_GRAPH_VERTEX_TANGENT_OUTPUT
        #define VARYINGS_NEED_POSITION_WS
        #define VARYINGS_NEED_NORMAL_WS
        #define VARYINGS_NEED_TANGENT_WS
        #define VARYINGS_NEED_TEXCOORD0
        #define VARYINGS_NEED_TEXCOORD3
        #define VARYINGS_NEED_COLOR
        #define FEATURES_GRAPH_VERTEX
        /* WARNING: $splice Could not find named fragment 'PassInstancing' */
        #define SHADERPASS SHADERPASS_SHADOWCASTER
        #define USE_UNITY_CROSSFADE 1
        
        
        // custom interpolator pre-include
        /* WARNING: $splice Could not find named fragment 'sgci_CustomInterpolatorPreInclude' */
        
        // Includes
        #include_with_pragmas "Packages/com.unity.render-pipelines.universal/ShaderLibrary/DOTS.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Texture.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
        #include_with_pragmas "Packages/com.unity.render-pipelines.core/ShaderLibrary/FoveatedRenderingKeywords.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/FoveatedRendering.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Input.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/TextureStack.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/DebugMipmapStreamingMacros.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShaderPass.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/LODCrossFade.hlsl"
        
        // --------------------------------------------------
        // Structs and Packing
        
        // custom interpolators pre packing
        /* WARNING: $splice Could not find named fragment 'CustomInterpolatorPrePacking' */
        
        struct Attributes
        {
             float3 positionOS : POSITION;
             float3 normalOS : NORMAL;
             float4 tangentOS : TANGENT;
             float4 uv0 : TEXCOORD0;
             float4 uv3 : TEXCOORD3;
             float4 color : COLOR;
            #if UNITY_ANY_INSTANCING_ENABLED || defined(ATTRIBUTES_NEED_INSTANCEID)
             uint instanceID : INSTANCEID_SEMANTIC;
            #endif
        };
        struct Varyings
        {
             float4 positionCS : SV_POSITION;
             float3 positionWS;
             float3 normalWS;
             float4 tangentWS;
             float4 texCoord0;
             float4 texCoord3;
             float4 color;
            #if UNITY_ANY_INSTANCING_ENABLED || defined(VARYINGS_NEED_INSTANCEID)
             uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
             uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
             uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
             FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
        };
        struct SurfaceDescriptionInputs
        {
             float3 WorldSpaceNormal;
             float3 WorldSpaceTangent;
             float3 WorldSpaceBiTangent;
             float3 AbsoluteWorldSpacePosition;
             float4 uv0;
             float4 uv3;
             float4 VertexColor;
        };
        struct VertexDescriptionInputs
        {
             float3 ObjectSpaceNormal;
             float3 ObjectSpaceTangent;
             float3 ObjectSpacePosition;
        };
        struct PackedVaryings
        {
             float4 positionCS : SV_POSITION;
             float4 tangentWS : INTERP0;
             float4 texCoord0 : INTERP1;
             float4 texCoord3 : INTERP2;
             float4 color : INTERP3;
             float3 positionWS : INTERP4;
             float3 normalWS : INTERP5;
            #if UNITY_ANY_INSTANCING_ENABLED || defined(VARYINGS_NEED_INSTANCEID)
             uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
             uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
             uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
             FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
        };
        
        PackedVaryings PackVaryings (Varyings input)
        {
            PackedVaryings output;
            ZERO_INITIALIZE(PackedVaryings, output);
            output.positionCS = input.positionCS;
            output.tangentWS.xyzw = input.tangentWS;
            output.texCoord0.xyzw = input.texCoord0;
            output.texCoord3.xyzw = input.texCoord3;
            output.color.xyzw = input.color;
            output.positionWS.xyz = input.positionWS;
            output.normalWS.xyz = input.normalWS;
            #if UNITY_ANY_INSTANCING_ENABLED || defined(VARYINGS_NEED_INSTANCEID)
            output.instanceID = input.instanceID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            output.cullFace = input.cullFace;
            #endif
            return output;
        }
        
        Varyings UnpackVaryings (PackedVaryings input)
        {
            Varyings output;
            output.positionCS = input.positionCS;
            output.tangentWS = input.tangentWS.xyzw;
            output.texCoord0 = input.texCoord0.xyzw;
            output.texCoord3 = input.texCoord3.xyzw;
            output.color = input.color.xyzw;
            output.positionWS = input.positionWS.xyz;
            output.normalWS = input.normalWS.xyz;
            #if UNITY_ANY_INSTANCING_ENABLED || defined(VARYINGS_NEED_INSTANCEID)
            output.instanceID = input.instanceID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            output.cullFace = input.cullFace;
            #endif
            return output;
        }
        
        
        // --------------------------------------------------
        // Graph
        
        // Graph Properties
        CBUFFER_START(UnityPerMaterial)
        float _EmissionNoiseMultiply;
        float _EmissionNoisePower;
        float Emission_Noise_UV0_UV3;
        float _EmissionNoiseUsePlanarUV;
        float _BaseEmissionMaskTreshold;
        float _CoverEmissionMaskIntensivity;
        float _CoverEmissionMaskTreshold;
        float4 _RimColor;
        float _RimLightPower;
        float4 _Noise_TexelSize;
        float2 _NoiseSpeed;
        float _BaseEmissionMaskIntensivity;
        float4 _LavaEmissionColor;
        float4 _Emission_Noise_Tiling_and_Offset;
        float _Cover_Mask_A_Remap_Min;
        float _Cover_Mask_A_Remap_Max;
        float _HeightMin;
        float _HeightMax;
        float _HeightOffset;
        float _VertexColorBBlendStrenght;
        float _USECoverHeightT;
        float _AlphaCutoff;
        float4 _WetColor;
        float4 _BaseColor;
        float _USEBaseHeightT;
        float4 _BaseColorMap_TexelSize;
        float _BaseUsePlanarUV;
        float4 _BaseTilingOffset;
        float4 _BaseNormalMap_TexelSize;
        float _BaseNormalScale;
        float4 _BaseMaskMap_TexelSize;
        float _BaseMetallic;
        float _VertexColorGBlendStrenght;
        float _BaseAORemapMin;
        float _BaseAORemapMax;
        float _BaseSmoothnessRemapMin;
        float _BaseSmoothnessRemapMax;
        float4 _Masks_TexelSize;
        float _Cover_Amount;
        float _Cover_Amount_Grow_Speed;
        float _Cover_Max_Angle;
        float _Cover_Min_Height;
        float _Cover_Min_Height_Blending;
        float4 _CoverBaseColor;
        float4 _CoverBaseColorMap_TexelSize;
        float _CoverUsePlanarUV;
        float4 _CoverTilingOffset;
        float4 _CoverNormalMap_TexelSize;
        float _CoverNormalScale;
        float _CoverNormalBlendHardness;
        float _CoverHardness;
        float _CoverHeightMapMin;
        float _CoverHeightMapMax;
        float _CoverHeightMapOffset;
        float4 _CoverMaskMap_TexelSize;
        float _CoverMetallic;
        float _CoverAORemapMin;
        float _CoverAORemapMax;
        float _CoverSmoothnessRemapMin;
        float _CoverSmoothnessRemapMax;
        float4 _DetailMap_TexelSize;
        float4 _DetailTilingOffset;
        float _DetailAlbedoScale;
        float _DetailNormalScale;
        float _DetailSmoothnessScale;
        float _WetSmoothness;
        UNITY_TEXTURE_STREAMING_DEBUG_VARS;
        CBUFFER_END
        
        
        // Object and Global properties
        SAMPLER(SamplerState_Linear_Repeat);
        SAMPLER(SamplerState_Linear_Repeat_Aniso8);
        TEXTURE2D(_Noise);
        SAMPLER(sampler_Noise);
        TEXTURE2D(_BaseColorMap);
        SAMPLER(sampler_BaseColorMap);
        TEXTURE2D(_BaseNormalMap);
        SAMPLER(sampler_BaseNormalMap);
        TEXTURE2D(_BaseMaskMap);
        SAMPLER(sampler_BaseMaskMap);
        TEXTURE2D(_Masks);
        SAMPLER(sampler_Masks);
        TEXTURE2D(_CoverBaseColorMap);
        SAMPLER(sampler_CoverBaseColorMap);
        TEXTURE2D(_CoverNormalMap);
        SAMPLER(sampler_CoverNormalMap);
        TEXTURE2D(_CoverMaskMap);
        SAMPLER(sampler_CoverMaskMap);
        TEXTURE2D(_DetailMap);
        SAMPLER(sampler_DetailMap);
        
        // Graph Includes
        // GraphIncludes: <None>
        
        // -- Property used by ScenePickingPass
        #ifdef SCENEPICKINGPASS
        float4 _SelectionID;
        #endif
        
        // -- Properties used by SceneSelectionPass
        #ifdef SCENESELECTIONPASS
        int _ObjectId;
        int _PassValue;
        #endif
        
        // Graph Functions
        
        void Unity_Combine_float(float R, float G, float B, float A, out float4 RGBA, out float3 RGB, out float2 RG)
        {
            RGBA = float4(R, G, B, A);
            RGB = float3(R, G, B);
            RG = float2(R, G);
        }
        
        void Unity_Divide_float(float A, float B, out float Out)
        {
            Out = A / B;
        }
        
        void Unity_Multiply_float4_float4(float4 A, float4 B, out float4 Out)
        {
        Out = A * B;
        }
        
        void Unity_Branch_float4(float Predicate, float4 True, float4 False, out float4 Out)
        {
            Out = Predicate ? True : False;
        }
        
        void Unity_TilingAndOffset_float(float2 UV, float2 Tiling, float2 Offset, out float2 Out)
        {
            Out = UV * Tiling + Offset;
        }
        
        void Unity_Branch_float2(float Predicate, float2 True, float2 False, out float2 Out)
        {
            Out = Predicate ? True : False;
        }
        
        struct Bindings_PlanarNM_c0f081da9c567704ea36e7dd38cedcf6_float
        {
        float3 AbsoluteWorldSpacePosition;
        half4 uv0;
        half4 uv3;
        };
        
        void SG_PlanarNM_c0f081da9c567704ea36e7dd38cedcf6_float(UnityTexture2D Texture2D_80A3D28F, float4 Vector4_2EBA7A3B, float Boolean_7ABB9909, UnitySamplerState _SamplerState, float Boolean_5ddfe6daabcc4715a44b5f34fc19becb, Bindings_PlanarNM_c0f081da9c567704ea36e7dd38cedcf6_float IN, out float4 XZ_2)
        {
        UnityTexture2D _Property_3e01b4d2fc68d48ba3acbba9d5881e59_Out_0_Texture2D = Texture2D_80A3D28F;
        float _Property_30834f691775a0898a45b1c868520436_Out_0_Boolean = Boolean_7ABB9909;
        float _Split_89ed63cb625cb3878c183d0b71c03400_R_1_Float = IN.AbsoluteWorldSpacePosition[0];
        float _Split_89ed63cb625cb3878c183d0b71c03400_G_2_Float = IN.AbsoluteWorldSpacePosition[1];
        float _Split_89ed63cb625cb3878c183d0b71c03400_B_3_Float = IN.AbsoluteWorldSpacePosition[2];
        float _Split_89ed63cb625cb3878c183d0b71c03400_A_4_Float = 0;
        float4 _Combine_cf2d04ff119ad88493f6460431765cbb_RGBA_4_Vector4;
        float3 _Combine_cf2d04ff119ad88493f6460431765cbb_RGB_5_Vector3;
        float2 _Combine_cf2d04ff119ad88493f6460431765cbb_RG_6_Vector2;
        Unity_Combine_float(_Split_89ed63cb625cb3878c183d0b71c03400_R_1_Float, _Split_89ed63cb625cb3878c183d0b71c03400_B_3_Float, float(0), float(0), _Combine_cf2d04ff119ad88493f6460431765cbb_RGBA_4_Vector4, _Combine_cf2d04ff119ad88493f6460431765cbb_RGB_5_Vector3, _Combine_cf2d04ff119ad88493f6460431765cbb_RG_6_Vector2);
        float4 _Property_8a66888ec47d0687ab1cb2f8abdc9da8_Out_0_Vector4 = Vector4_2EBA7A3B;
        float _Split_2f0f52f6ef8c0e81af0da6476402bc1f_R_1_Float = _Property_8a66888ec47d0687ab1cb2f8abdc9da8_Out_0_Vector4[0];
        float _Split_2f0f52f6ef8c0e81af0da6476402bc1f_G_2_Float = _Property_8a66888ec47d0687ab1cb2f8abdc9da8_Out_0_Vector4[1];
        float _Split_2f0f52f6ef8c0e81af0da6476402bc1f_B_3_Float = _Property_8a66888ec47d0687ab1cb2f8abdc9da8_Out_0_Vector4[2];
        float _Split_2f0f52f6ef8c0e81af0da6476402bc1f_A_4_Float = _Property_8a66888ec47d0687ab1cb2f8abdc9da8_Out_0_Vector4[3];
        float _Divide_e64179199923c58289b6aa94ea6c9178_Out_2_Float;
        Unity_Divide_float(float(1), _Split_2f0f52f6ef8c0e81af0da6476402bc1f_R_1_Float, _Divide_e64179199923c58289b6aa94ea6c9178_Out_2_Float);
        float4 _Multiply_14cec4902d0a00829e4555071a1b8ad1_Out_2_Vector4;
        Unity_Multiply_float4_float4(_Combine_cf2d04ff119ad88493f6460431765cbb_RGBA_4_Vector4, (_Divide_e64179199923c58289b6aa94ea6c9178_Out_2_Float.xxxx), _Multiply_14cec4902d0a00829e4555071a1b8ad1_Out_2_Vector4);
        float _Property_f17c7bf877e64b6abdd66b1fe9f5accc_Out_0_Boolean = Boolean_5ddfe6daabcc4715a44b5f34fc19becb;
        float4 _UV_029e8e8198564838b9389b902a09fb22_Out_0_Vector4 = IN.uv0;
        float4 _UV_7a6209af1506424fb75c81e87e42035a_Out_0_Vector4 = IN.uv3;
        float4 _Branch_fc37bb4bf641457cbbc6e290603056ff_Out_3_Vector4;
        Unity_Branch_float4(_Property_f17c7bf877e64b6abdd66b1fe9f5accc_Out_0_Boolean, _UV_029e8e8198564838b9389b902a09fb22_Out_0_Vector4, _UV_7a6209af1506424fb75c81e87e42035a_Out_0_Vector4, _Branch_fc37bb4bf641457cbbc6e290603056ff_Out_3_Vector4);
        float2 _Vector2_16c15d3bbdd14b85bd48e3a6cb318af7_Out_0_Vector2 = float2(_Split_2f0f52f6ef8c0e81af0da6476402bc1f_R_1_Float, _Split_2f0f52f6ef8c0e81af0da6476402bc1f_G_2_Float);
        float2 _Vector2_f8d75f54e7705083bbec539a60185577_Out_0_Vector2 = float2(_Split_2f0f52f6ef8c0e81af0da6476402bc1f_B_3_Float, _Split_2f0f52f6ef8c0e81af0da6476402bc1f_A_4_Float);
        float2 _TilingAndOffset_d91e2d25acd34686b562b7fe7e9d1d27_Out_3_Vector2;
        Unity_TilingAndOffset_float((_Branch_fc37bb4bf641457cbbc6e290603056ff_Out_3_Vector4.xy), _Vector2_16c15d3bbdd14b85bd48e3a6cb318af7_Out_0_Vector2, _Vector2_f8d75f54e7705083bbec539a60185577_Out_0_Vector2, _TilingAndOffset_d91e2d25acd34686b562b7fe7e9d1d27_Out_3_Vector2);
        float2 _Branch_8e5a4e8f4d52fc8aadd1f46485afc933_Out_3_Vector2;
        Unity_Branch_float2(_Property_30834f691775a0898a45b1c868520436_Out_0_Boolean, (_Multiply_14cec4902d0a00829e4555071a1b8ad1_Out_2_Vector4.xy), _TilingAndOffset_d91e2d25acd34686b562b7fe7e9d1d27_Out_3_Vector2, _Branch_8e5a4e8f4d52fc8aadd1f46485afc933_Out_3_Vector2);
        UnitySamplerState _Property_e8746b9475c94530ba35ba8019ad2ae0_Out_0_SamplerState = _SamplerState;
        float4 _SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_RGBA_0_Vector4 = SAMPLE_TEXTURE2D(_Property_3e01b4d2fc68d48ba3acbba9d5881e59_Out_0_Texture2D.tex, _Property_e8746b9475c94530ba35ba8019ad2ae0_Out_0_SamplerState.samplerstate, _Property_3e01b4d2fc68d48ba3acbba9d5881e59_Out_0_Texture2D.GetTransformedUV(_Branch_8e5a4e8f4d52fc8aadd1f46485afc933_Out_3_Vector2) );
        float _SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_R_4_Float = _SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_RGBA_0_Vector4.r;
        float _SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_G_5_Float = _SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_RGBA_0_Vector4.g;
        float _SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_B_6_Float = _SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_RGBA_0_Vector4.b;
        float _SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_A_7_Float = _SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_RGBA_0_Vector4.a;
        XZ_2 = _SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_RGBA_0_Vector4;
        }
        
        void Unity_ColorspaceConversion_Linear_RGB_float(float3 In, out float3 Out)
        {
            float3 sRGBLo = In * 12.92;
            float3 sRGBHi = (pow(max(abs(In), 1.192092896e-07), float3(1.0 / 2.4, 1.0 / 2.4, 1.0 / 2.4)) * 1.055) - 0.055;
            Out = float3(In <= 0.0031308) ? sRGBLo : sRGBHi;
        }
        
        void Unity_Blend_Overlay_float3(float3 Base, float3 Blend, out float3 Out, float Opacity)
        {
            float3 result1 = 1.0 - 2.0 * (1.0 - Base) * (1.0 - Blend);
            float3 result2 = 2.0 * Base * Blend;
            float3 zeroOrOne = step(Base, 0.5);
            Out = result2 * zeroOrOne + (1 - zeroOrOne) * result1;
            Out = lerp(Base, Out, Opacity);
        }
        
        void Unity_ColorspaceConversion_RGB_Linear_float(float3 In, out float3 Out)
        {
            float3 linearRGBLo = In / 12.92;
            float3 linearRGBHi = pow(max(abs((In + 0.055) / 1.055), 1.192092896e-07), float3(2.4, 2.4, 2.4));
            Out = float3(In <= 0.04045) ? linearRGBLo : linearRGBHi;
        }
        
        void Unity_Clamp_float3(float3 In, float3 Min, float3 Max, out float3 Out)
        {
            Out = clamp(In, Min, Max);
        }
        
        void Unity_Add_float2(float2 A, float2 B, out float2 Out)
        {
            Out = A + B;
        }
        
        void Unity_Remap_float(float In, float2 InMinMax, float2 OutMinMax, out float Out)
        {
            Out = OutMinMax.x + (In - InMinMax.x) * (OutMinMax.y - OutMinMax.x) / (InMinMax.y - InMinMax.x);
        }
        
        void Unity_Clamp_float(float In, float Min, float Max, out float Out)
        {
            Out = clamp(In, Min, Max);
        }
        
        void Unity_Multiply_float2_float2(float2 A, float2 B, out float2 Out)
        {
            Out = A * B;
        }
        
        void Unity_DotProduct_float2(float2 A, float2 B, out float Out)
        {
            Out = dot(A, B);
        }
        
        void Unity_Saturate_float(float In, out float Out)
        {
            Out = saturate(In);
        }
        
        void Unity_OneMinus_float(float In, out float Out)
        {
            Out = 1 - In;
        }
        
        void Unity_SquareRoot_float(float In, out float Out)
        {
            Out = sqrt(In);
        }
        
        void Unity_Sign_float3(float3 In, out float3 Out)
        {
            Out = sign(In);
        }
        
        void Unity_Multiply_float_float(float A, float B, out float Out)
        {
        Out = A * B;
        }
        
        void Unity_Normalize_float3(float3 In, out float3 Out)
        {
            Out = normalize(In);
        }
        
        void Unity_Branch_float3(float Predicate, float3 True, float3 False, out float3 Out)
        {
            Out = Predicate ? True : False;
        }
        
        struct Bindings_PlanarNMn_1b93a87456f9d4c419321d0cd92bd6c8_float
        {
        float3 WorldSpaceNormal;
        float3 WorldSpaceTangent;
        float3 WorldSpaceBiTangent;
        float3 AbsoluteWorldSpacePosition;
        half4 uv0;
        half4 uv3;
        };
        
        void SG_PlanarNMn_1b93a87456f9d4c419321d0cd92bd6c8_float(UnityTexture2D Texture2D_80A3D28F, float4 Vector4_82674548, float Boolean_9FF42DF6, UnitySamplerState _SamplerState, float Boolean_5ddfe6daabcc4715a44b5f34fc19becb, Bindings_PlanarNMn_1b93a87456f9d4c419321d0cd92bd6c8_float IN, out float4 XZ_2)
        {
        float _Property_1ef12cf3201a938993fe6a7951b0e754_Out_0_Boolean = Boolean_9FF42DF6;
        UnityTexture2D _Property_3e01b4d2fc68d48ba3acbba9d5881e59_Out_0_Texture2D = Texture2D_80A3D28F;
        float _Split_89ed63cb625cb3878c183d0b71c03400_R_1_Float = IN.AbsoluteWorldSpacePosition[0];
        float _Split_89ed63cb625cb3878c183d0b71c03400_G_2_Float = IN.AbsoluteWorldSpacePosition[1];
        float _Split_89ed63cb625cb3878c183d0b71c03400_B_3_Float = IN.AbsoluteWorldSpacePosition[2];
        float _Split_89ed63cb625cb3878c183d0b71c03400_A_4_Float = 0;
        float4 _Combine_cf2d04ff119ad88493f6460431765cbb_RGBA_4_Vector4;
        float3 _Combine_cf2d04ff119ad88493f6460431765cbb_RGB_5_Vector3;
        float2 _Combine_cf2d04ff119ad88493f6460431765cbb_RG_6_Vector2;
        Unity_Combine_float(_Split_89ed63cb625cb3878c183d0b71c03400_R_1_Float, _Split_89ed63cb625cb3878c183d0b71c03400_B_3_Float, float(0), float(0), _Combine_cf2d04ff119ad88493f6460431765cbb_RGBA_4_Vector4, _Combine_cf2d04ff119ad88493f6460431765cbb_RGB_5_Vector3, _Combine_cf2d04ff119ad88493f6460431765cbb_RG_6_Vector2);
        float4 _Property_3fa1d6f912feb481ba60f2e55e62e746_Out_0_Vector4 = Vector4_82674548;
        float _Split_a2e12fa5931da084b2949343a539dfd8_R_1_Float = _Property_3fa1d6f912feb481ba60f2e55e62e746_Out_0_Vector4[0];
        float _Split_a2e12fa5931da084b2949343a539dfd8_G_2_Float = _Property_3fa1d6f912feb481ba60f2e55e62e746_Out_0_Vector4[1];
        float _Split_a2e12fa5931da084b2949343a539dfd8_B_3_Float = _Property_3fa1d6f912feb481ba60f2e55e62e746_Out_0_Vector4[2];
        float _Split_a2e12fa5931da084b2949343a539dfd8_A_4_Float = _Property_3fa1d6f912feb481ba60f2e55e62e746_Out_0_Vector4[3];
        float _Divide_c36b770dfaa0bb8f85ab27da5fd794f0_Out_2_Float;
        Unity_Divide_float(float(1), _Split_a2e12fa5931da084b2949343a539dfd8_R_1_Float, _Divide_c36b770dfaa0bb8f85ab27da5fd794f0_Out_2_Float);
        float4 _Multiply_14cec4902d0a00829e4555071a1b8ad1_Out_2_Vector4;
        Unity_Multiply_float4_float4(_Combine_cf2d04ff119ad88493f6460431765cbb_RGBA_4_Vector4, (_Divide_c36b770dfaa0bb8f85ab27da5fd794f0_Out_2_Float.xxxx), _Multiply_14cec4902d0a00829e4555071a1b8ad1_Out_2_Vector4);
        float _Property_058f4fba88c3437288219f1929444bf2_Out_0_Boolean = Boolean_5ddfe6daabcc4715a44b5f34fc19becb;
        float4 _UV_43d85b3291324c848dfbeec6adac2a71_Out_0_Vector4 = IN.uv0;
        float4 _UV_36881dcaab9040168fc5215dcd00f352_Out_0_Vector4 = IN.uv3;
        float4 _Branch_8054d58a73be4ce1b22d48a84389ae07_Out_3_Vector4;
        Unity_Branch_float4(_Property_058f4fba88c3437288219f1929444bf2_Out_0_Boolean, _UV_43d85b3291324c848dfbeec6adac2a71_Out_0_Vector4, _UV_36881dcaab9040168fc5215dcd00f352_Out_0_Vector4, _Branch_8054d58a73be4ce1b22d48a84389ae07_Out_3_Vector4);
        float2 _Vector2_6845d21872714d889783b0cb707df3e9_Out_0_Vector2 = float2(_Split_a2e12fa5931da084b2949343a539dfd8_R_1_Float, _Split_a2e12fa5931da084b2949343a539dfd8_G_2_Float);
        float2 _Vector2_e2e2263627c6098e96a5b5d29350ad03_Out_0_Vector2 = float2(_Split_a2e12fa5931da084b2949343a539dfd8_B_3_Float, _Split_a2e12fa5931da084b2949343a539dfd8_A_4_Float);
        float2 _TilingAndOffset_17582d056c0b8a8dab1017d37497fe59_Out_3_Vector2;
        Unity_TilingAndOffset_float((_Branch_8054d58a73be4ce1b22d48a84389ae07_Out_3_Vector4.xy), _Vector2_6845d21872714d889783b0cb707df3e9_Out_0_Vector2, _Vector2_e2e2263627c6098e96a5b5d29350ad03_Out_0_Vector2, _TilingAndOffset_17582d056c0b8a8dab1017d37497fe59_Out_3_Vector2);
        float2 _Branch_1e152f3aac57448f8518bf2852c000c3_Out_3_Vector2;
        Unity_Branch_float2(_Property_1ef12cf3201a938993fe6a7951b0e754_Out_0_Boolean, (_Multiply_14cec4902d0a00829e4555071a1b8ad1_Out_2_Vector4.xy), _TilingAndOffset_17582d056c0b8a8dab1017d37497fe59_Out_3_Vector2, _Branch_1e152f3aac57448f8518bf2852c000c3_Out_3_Vector2);
        UnitySamplerState _Property_69f1ed7efd1b494e91f626b88ab2363c_Out_0_SamplerState = _SamplerState;
        float4 _SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_RGBA_0_Vector4 = SAMPLE_TEXTURE2D(_Property_3e01b4d2fc68d48ba3acbba9d5881e59_Out_0_Texture2D.tex, _Property_69f1ed7efd1b494e91f626b88ab2363c_Out_0_SamplerState.samplerstate, _Property_3e01b4d2fc68d48ba3acbba9d5881e59_Out_0_Texture2D.GetTransformedUV(_Branch_1e152f3aac57448f8518bf2852c000c3_Out_3_Vector2) );
        _SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_RGBA_0_Vector4.rgb = UnpackNormal(_SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_RGBA_0_Vector4);
        float _SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_R_4_Float = _SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_RGBA_0_Vector4.r;
        float _SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_G_5_Float = _SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_RGBA_0_Vector4.g;
        float _SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_B_6_Float = _SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_RGBA_0_Vector4.b;
        float _SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_A_7_Float = _SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_RGBA_0_Vector4.a;
        float2 _Vector2_ad6bd100e273d78fa409a30a77bfa2cc_Out_0_Vector2 = float2(_SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_R_4_Float, _SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_G_5_Float);
        float3 _Sign_3a6ebf59931cf08cb0482e0144ddac24_Out_1_Vector3;
        Unity_Sign_float3(IN.WorldSpaceNormal, _Sign_3a6ebf59931cf08cb0482e0144ddac24_Out_1_Vector3);
        float _Split_6299d4ddcc4c74828aea40a46fdb896e_R_1_Float = _Sign_3a6ebf59931cf08cb0482e0144ddac24_Out_1_Vector3[0];
        float _Split_6299d4ddcc4c74828aea40a46fdb896e_G_2_Float = _Sign_3a6ebf59931cf08cb0482e0144ddac24_Out_1_Vector3[1];
        float _Split_6299d4ddcc4c74828aea40a46fdb896e_B_3_Float = _Sign_3a6ebf59931cf08cb0482e0144ddac24_Out_1_Vector3[2];
        float _Split_6299d4ddcc4c74828aea40a46fdb896e_A_4_Float = 0;
        float2 _Vector2_b76cb1842101e58b9e636d49b075c612_Out_0_Vector2 = float2(_Split_6299d4ddcc4c74828aea40a46fdb896e_G_2_Float, float(1));
        float2 _Multiply_31e8db88ee20c985a9850d1a58f3282b_Out_2_Vector2;
        Unity_Multiply_float2_float2(_Vector2_ad6bd100e273d78fa409a30a77bfa2cc_Out_0_Vector2, _Vector2_b76cb1842101e58b9e636d49b075c612_Out_0_Vector2, _Multiply_31e8db88ee20c985a9850d1a58f3282b_Out_2_Vector2);
        float _Split_5ed44bf2eca0868f81eb18100f49d1fa_R_1_Float = IN.WorldSpaceNormal[0];
        float _Split_5ed44bf2eca0868f81eb18100f49d1fa_G_2_Float = IN.WorldSpaceNormal[1];
        float _Split_5ed44bf2eca0868f81eb18100f49d1fa_B_3_Float = IN.WorldSpaceNormal[2];
        float _Split_5ed44bf2eca0868f81eb18100f49d1fa_A_4_Float = 0;
        float2 _Vector2_70e5837843f28b8b9d64cada3697bd5a_Out_0_Vector2 = float2(_Split_5ed44bf2eca0868f81eb18100f49d1fa_R_1_Float, _Split_5ed44bf2eca0868f81eb18100f49d1fa_B_3_Float);
        float2 _Add_1145b2f896593d80aa864a34e6702562_Out_2_Vector2;
        Unity_Add_float2(_Multiply_31e8db88ee20c985a9850d1a58f3282b_Out_2_Vector2, _Vector2_70e5837843f28b8b9d64cada3697bd5a_Out_0_Vector2, _Add_1145b2f896593d80aa864a34e6702562_Out_2_Vector2);
        float _Split_2bc77ca2d17bd78cb2383770ce50b179_R_1_Float = _Add_1145b2f896593d80aa864a34e6702562_Out_2_Vector2[0];
        float _Split_2bc77ca2d17bd78cb2383770ce50b179_G_2_Float = _Add_1145b2f896593d80aa864a34e6702562_Out_2_Vector2[1];
        float _Split_2bc77ca2d17bd78cb2383770ce50b179_B_3_Float = 0;
        float _Split_2bc77ca2d17bd78cb2383770ce50b179_A_4_Float = 0;
        float _Multiply_ab12aea87465a78eaf7fc66c2598d266_Out_2_Float;
        Unity_Multiply_float_float(_SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_B_6_Float, _Split_5ed44bf2eca0868f81eb18100f49d1fa_G_2_Float, _Multiply_ab12aea87465a78eaf7fc66c2598d266_Out_2_Float);
        float3 _Vector3_433840b555db308b97e9b14b6a957195_Out_0_Vector3 = float3(_Split_2bc77ca2d17bd78cb2383770ce50b179_R_1_Float, _Multiply_ab12aea87465a78eaf7fc66c2598d266_Out_2_Float, _Split_2bc77ca2d17bd78cb2383770ce50b179_G_2_Float);
        float3 _Transform_c7914cc45a011c89b3f53c55afb51673_Out_1_Vector3;
        {
        float3x3 tangentTransform = float3x3(IN.WorldSpaceTangent, IN.WorldSpaceBiTangent, IN.WorldSpaceNormal);
        _Transform_c7914cc45a011c89b3f53c55afb51673_Out_1_Vector3 = TransformWorldToTangentDir(_Vector3_433840b555db308b97e9b14b6a957195_Out_0_Vector3.xyz, tangentTransform, true);
        }
        float3 _Clamp_3837949a36b5428a82af01e7bcd29952_Out_3_Vector3;
        Unity_Clamp_float3(_Transform_c7914cc45a011c89b3f53c55afb51673_Out_1_Vector3, float3(-1, -1, -1), float3(1, 1, 1), _Clamp_3837949a36b5428a82af01e7bcd29952_Out_3_Vector3);
        float3 _Normalize_09bf8a2bd0a4d38e8b97d5c674f79b44_Out_1_Vector3;
        Unity_Normalize_float3(_Clamp_3837949a36b5428a82af01e7bcd29952_Out_3_Vector3, _Normalize_09bf8a2bd0a4d38e8b97d5c674f79b44_Out_1_Vector3);
        float3 _Branch_9eadf909a90f2f80880f8c56ecc2a91f_Out_3_Vector3;
        Unity_Branch_float3(_Property_1ef12cf3201a938993fe6a7951b0e754_Out_0_Boolean, _Normalize_09bf8a2bd0a4d38e8b97d5c674f79b44_Out_1_Vector3, (_SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_RGBA_0_Vector4.xyz), _Branch_9eadf909a90f2f80880f8c56ecc2a91f_Out_3_Vector3);
        XZ_2 = (float4(_Branch_9eadf909a90f2f80880f8c56ecc2a91f_Out_3_Vector3, 1.0));
        }
        
        void Unity_NormalStrength_float(float3 In, float Strength, out float3 Out)
        {
            Out = float3(In.rg * Strength, lerp(1, In.b, saturate(Strength)));
        }
        
        void Unity_NormalBlend_Reoriented_float(float3 A, float3 B, out float3 Out)
        {
            float3 t = A.xyz + float3(0.0, 0.0, 1.0);
            float3 u = B.xyz * float3(-1.0, -1.0, 1.0);
            Out = (t / t.z) * dot(t, u) - u;
        }
        
        void Unity_Subtract_float(float A, float B, out float Out)
        {
            Out = A - B;
        }
        
        void Unity_Absolute_float(float In, out float Out)
        {
            Out = abs(In);
        }
        
        void Unity_Power_float(float A, float B, out float Out)
        {
            Out = pow(A, B);
        }
        
        void Unity_Add_float(float A, float B, out float Out)
        {
            Out = A + B;
        }
        
        void Unity_Lerp_float3(float3 A, float3 B, float3 T, out float3 Out)
        {
            Out = lerp(A, B, T);
        }
        
        void Unity_Comparison_Greater_float(float A, float B, out float Out)
        {
            Out = A > B ? 1 : 0;
        }
        
        void Unity_Branch_float(float Predicate, float True, float False, out float Out)
        {
            Out = Predicate ? True : False;
        }
        
        struct Bindings_UniversalHeighblend_3b5c31b864970d04197cd420b6c4b0fa_float
        {
        };
        
        void SG_UniversalHeighblend_3b5c31b864970d04197cd420b6c4b0fa_float(float _Vertex_Color, float _Blend_Hardness, float _Use_Layer_1_Height_T, float _Layer_1_Height, float2 _Layer_1_Before_Remap, float _Use_Layer_2_Height_T, float _Layer_2_Height, float2 _Layer_2_Before_Remap, float _Angle_Blend, Bindings_UniversalHeighblend_3b5c31b864970d04197cd420b6c4b0fa_float IN, out float Heightmap_1)
        {
        float _Property_b3ca7054ef0043de85912fc45d997ea2_Out_0_Float = _Vertex_Color;
        float _Clamp_852774a2be524975babf4eeb54af6d64_Out_3_Float;
        Unity_Clamp_float(_Property_b3ca7054ef0043de85912fc45d997ea2_Out_0_Float, float(0), float(1), _Clamp_852774a2be524975babf4eeb54af6d64_Out_3_Float);
        float _OneMinus_85e3550f37814cd3ab5ea5dde7f63a73_Out_1_Float;
        Unity_OneMinus_float(_Clamp_852774a2be524975babf4eeb54af6d64_Out_3_Float, _OneMinus_85e3550f37814cd3ab5ea5dde7f63a73_Out_1_Float);
        float _Comparison_5be6aeaa514b4921b5eb68269b58b028_Out_2_Boolean;
        Unity_Comparison_Greater_float(_OneMinus_85e3550f37814cd3ab5ea5dde7f63a73_Out_1_Float, float(0.99), _Comparison_5be6aeaa514b4921b5eb68269b58b028_Out_2_Boolean);
        float _Property_cfe724908035497c918d6d3f8dafe439_Out_0_Boolean = _Use_Layer_1_Height_T;
        float _Property_9634fd87d3374fdaa60181281a01f9b5_Out_0_Float = _Layer_1_Height;
        float2 _Property_e748f6c127e0479a9a01040378a4129b_Out_0_Vector2 = _Layer_1_Before_Remap;
        float _Split_cde172ab161d44cb81ea7874aec65560_R_1_Float = _Property_e748f6c127e0479a9a01040378a4129b_Out_0_Vector2[0];
        float _Split_cde172ab161d44cb81ea7874aec65560_G_2_Float = _Property_e748f6c127e0479a9a01040378a4129b_Out_0_Vector2[1];
        float _Split_cde172ab161d44cb81ea7874aec65560_B_3_Float = 0;
        float _Split_cde172ab161d44cb81ea7874aec65560_A_4_Float = 0;
        float _Subtract_e1e98a956721410caddfb467ae0eca8b_Out_2_Float;
        Unity_Subtract_float(_Split_cde172ab161d44cb81ea7874aec65560_R_1_Float, _Split_cde172ab161d44cb81ea7874aec65560_G_2_Float, _Subtract_e1e98a956721410caddfb467ae0eca8b_Out_2_Float);
        float _Clamp_ac4097026e6248dbb7a95fe910cc776e_Out_3_Float;
        Unity_Clamp_float(_OneMinus_85e3550f37814cd3ab5ea5dde7f63a73_Out_1_Float, float(0), float(1), _Clamp_ac4097026e6248dbb7a95fe910cc776e_Out_3_Float);
        float _Multiply_41691d316de74fef8a4ab5f63ed5474e_Out_2_Float;
        Unity_Multiply_float_float(_Subtract_e1e98a956721410caddfb467ae0eca8b_Out_2_Float, _Clamp_ac4097026e6248dbb7a95fe910cc776e_Out_3_Float, _Multiply_41691d316de74fef8a4ab5f63ed5474e_Out_2_Float);
        float2 _Add_48d37f8b8a464788860db14f0da8a66e_Out_2_Vector2;
        Unity_Add_float2(_Property_e748f6c127e0479a9a01040378a4129b_Out_0_Vector2, (_Multiply_41691d316de74fef8a4ab5f63ed5474e_Out_2_Float.xx), _Add_48d37f8b8a464788860db14f0da8a66e_Out_2_Vector2);
        float _Remap_21f3372608424df090026adc73778a39_Out_3_Float;
        Unity_Remap_float(_Property_9634fd87d3374fdaa60181281a01f9b5_Out_0_Float, float2 (0, 1), _Add_48d37f8b8a464788860db14f0da8a66e_Out_2_Vector2, _Remap_21f3372608424df090026adc73778a39_Out_3_Float);
        float _Clamp_8ea719b357b44537b42b2d05c22046f6_Out_3_Float;
        Unity_Clamp_float(_Remap_21f3372608424df090026adc73778a39_Out_3_Float, float(0), float(1), _Clamp_8ea719b357b44537b42b2d05c22046f6_Out_3_Float);
        float _Property_457e05a76c034ada998b3ff30a7781c3_Out_0_Boolean = _Use_Layer_2_Height_T;
        float _Property_9dfafa1ca8c94866a52535f412aff89a_Out_0_Float = _Angle_Blend;
        float _Property_b0e4a5720c374e2eb6f203a1bd075243_Out_0_Float = _Layer_2_Height;
        float _Multiply_00b31c7f720343caa4ded6df80a61899_Out_2_Float;
        Unity_Multiply_float_float(_Property_9dfafa1ca8c94866a52535f412aff89a_Out_0_Float, _Property_b0e4a5720c374e2eb6f203a1bd075243_Out_0_Float, _Multiply_00b31c7f720343caa4ded6df80a61899_Out_2_Float);
        float2 _Property_555a7734da754b989d8f80ef0bc86bea_Out_0_Vector2 = _Layer_2_Before_Remap;
        float _Split_bad56a0d03154ccc8cbfb53ea0e381d4_R_1_Float = _Property_555a7734da754b989d8f80ef0bc86bea_Out_0_Vector2[0];
        float _Split_bad56a0d03154ccc8cbfb53ea0e381d4_G_2_Float = _Property_555a7734da754b989d8f80ef0bc86bea_Out_0_Vector2[1];
        float _Split_bad56a0d03154ccc8cbfb53ea0e381d4_B_3_Float = 0;
        float _Split_bad56a0d03154ccc8cbfb53ea0e381d4_A_4_Float = 0;
        float _Subtract_2a7908018c384526a00494520503a83d_Out_2_Float;
        Unity_Subtract_float(_Split_bad56a0d03154ccc8cbfb53ea0e381d4_R_1_Float, _Split_bad56a0d03154ccc8cbfb53ea0e381d4_G_2_Float, _Subtract_2a7908018c384526a00494520503a83d_Out_2_Float);
        float _Multiply_417d72157b5f4930aed43775db746964_Out_2_Float;
        Unity_Multiply_float_float(_Subtract_2a7908018c384526a00494520503a83d_Out_2_Float, _Clamp_ac4097026e6248dbb7a95fe910cc776e_Out_3_Float, _Multiply_417d72157b5f4930aed43775db746964_Out_2_Float);
        float2 _Add_3d7e111e917c44e8a6800ce926fac67d_Out_2_Vector2;
        Unity_Add_float2((_Multiply_417d72157b5f4930aed43775db746964_Out_2_Float.xx), _Property_555a7734da754b989d8f80ef0bc86bea_Out_0_Vector2, _Add_3d7e111e917c44e8a6800ce926fac67d_Out_2_Vector2);
        float _Remap_931f83440e6c4c1588456788f84cbd9a_Out_3_Float;
        Unity_Remap_float(_Multiply_00b31c7f720343caa4ded6df80a61899_Out_2_Float, float2 (0, 1), _Add_3d7e111e917c44e8a6800ce926fac67d_Out_2_Vector2, _Remap_931f83440e6c4c1588456788f84cbd9a_Out_3_Float);
        float _Branch_a840aba5bca34588a2665f9794c96c38_Out_3_Float;
        Unity_Branch_float(_Property_457e05a76c034ada998b3ff30a7781c3_Out_0_Boolean, _Remap_931f83440e6c4c1588456788f84cbd9a_Out_3_Float, _Property_9dfafa1ca8c94866a52535f412aff89a_Out_0_Float, _Branch_a840aba5bca34588a2665f9794c96c38_Out_3_Float);
        float _Clamp_b1fe959daf444bf99c57756b8be77768_Out_3_Float;
        Unity_Clamp_float(_Branch_a840aba5bca34588a2665f9794c96c38_Out_3_Float, float(0), float(1), _Clamp_b1fe959daf444bf99c57756b8be77768_Out_3_Float);
        float _Multiply_c045ae9912ac409b9734c687968d47f6_Out_2_Float;
        Unity_Multiply_float_float(_Clamp_8ea719b357b44537b42b2d05c22046f6_Out_3_Float, _Clamp_b1fe959daf444bf99c57756b8be77768_Out_3_Float, _Multiply_c045ae9912ac409b9734c687968d47f6_Out_2_Float);
        float _Branch_5198cfc0a080466e93cf89aea61886e6_Out_3_Float;
        Unity_Branch_float(_Property_cfe724908035497c918d6d3f8dafe439_Out_0_Boolean, _Multiply_c045ae9912ac409b9734c687968d47f6_Out_2_Float, _Clamp_b1fe959daf444bf99c57756b8be77768_Out_3_Float, _Branch_5198cfc0a080466e93cf89aea61886e6_Out_3_Float);
        float _Saturate_ceafe30b0bae4f45a2f2ec500925b553_Out_1_Float;
        Unity_Saturate_float(_Branch_5198cfc0a080466e93cf89aea61886e6_Out_3_Float, _Saturate_ceafe30b0bae4f45a2f2ec500925b553_Out_1_Float);
        float _Absolute_274083e3f9f645bfb86074d91f3b7c62_Out_1_Float;
        Unity_Absolute_float(_Saturate_ceafe30b0bae4f45a2f2ec500925b553_Out_1_Float, _Absolute_274083e3f9f645bfb86074d91f3b7c62_Out_1_Float);
        float _Property_c68e0b8a84a549a582d4723036344b0e_Out_0_Float = _Blend_Hardness;
        float _Power_c9d62a3092174d9cb5674d87bcb7b5c5_Out_2_Float;
        Unity_Power_float(_Absolute_274083e3f9f645bfb86074d91f3b7c62_Out_1_Float, _Property_c68e0b8a84a549a582d4723036344b0e_Out_0_Float, _Power_c9d62a3092174d9cb5674d87bcb7b5c5_Out_2_Float);
        float _Branch_2425ee869bde4930bb8f36a5273bdc33_Out_3_Float;
        Unity_Branch_float(_Comparison_5be6aeaa514b4921b5eb68269b58b028_Out_2_Boolean, float(0), _Power_c9d62a3092174d9cb5674d87bcb7b5c5_Out_2_Float, _Branch_2425ee869bde4930bb8f36a5273bdc33_Out_3_Float);
        float _Clamp_9a5c5cfe52824e248ea0a8e38c593d84_Out_3_Float;
        Unity_Clamp_float(_Branch_2425ee869bde4930bb8f36a5273bdc33_Out_3_Float, float(0), float(1), _Clamp_9a5c5cfe52824e248ea0a8e38c593d84_Out_3_Float);
        Heightmap_1 = _Clamp_9a5c5cfe52824e248ea0a8e38c593d84_Out_3_Float;
        }
        
        void Unity_Lerp_float4(float4 A, float4 B, float4 T, out float4 Out)
        {
            Out = lerp(A, B, T);
        }
        
        void Unity_Clamp_float4(float4 In, float4 Min, float4 Max, out float4 Out)
        {
            Out = clamp(In, Min, Max);
        }
        
        // Custom interpolators pre vertex
        /* WARNING: $splice Could not find named fragment 'CustomInterpolatorPreVertex' */
        
        // Graph Vertex
        struct VertexDescription
        {
            float3 Position;
            float3 Normal;
            float3 Tangent;
        };
        
        VertexDescription VertexDescriptionFunction(VertexDescriptionInputs IN)
        {
            VertexDescription description = (VertexDescription)0;
            description.Position = IN.ObjectSpacePosition;
            description.Normal = IN.ObjectSpaceNormal;
            description.Tangent = IN.ObjectSpaceTangent;
            return description;
        }
        
        // Custom interpolators, pre surface
        #ifdef FEATURES_GRAPH_VERTEX
        Varyings CustomInterpolatorPassThroughFunc(inout Varyings output, VertexDescription input)
        {
        return output;
        }
        #define CUSTOMINTERPOLATOR_VARYPASSTHROUGH_FUNC
        #endif
        
        // Graph Pixel
        struct SurfaceDescription
        {
            float Alpha;
            float AlphaClipThreshold;
        };
        
        SurfaceDescription SurfaceDescriptionFunction(SurfaceDescriptionInputs IN)
        {
            SurfaceDescription surface = (SurfaceDescription)0;
            UnityTexture2D _Property_821e07b38fd0a08d85c4dd6e5b6bbac9_Out_0_Texture2D = UnityBuildTexture2DStructNoScale(_BaseColorMap);
            float4 _Property_8ec0d512145619859d288abab740e3bf_Out_0_Vector4 = _BaseTilingOffset;
            float _Property_122c0f9ef0a1c4818a140c75e512abe4_Out_0_Boolean = _BaseUsePlanarUV;
            Bindings_PlanarNM_c0f081da9c567704ea36e7dd38cedcf6_float _PlanarNM_cb7ded32e6af3382bbe06b62977afab6;
            _PlanarNM_cb7ded32e6af3382bbe06b62977afab6.AbsoluteWorldSpacePosition = IN.AbsoluteWorldSpacePosition;
            _PlanarNM_cb7ded32e6af3382bbe06b62977afab6.uv0 = IN.uv0;
            _PlanarNM_cb7ded32e6af3382bbe06b62977afab6.uv3 = IN.uv3;
            float4 _PlanarNM_cb7ded32e6af3382bbe06b62977afab6_XZ_2_Vector4;
            SG_PlanarNM_c0f081da9c567704ea36e7dd38cedcf6_float(_Property_821e07b38fd0a08d85c4dd6e5b6bbac9_Out_0_Texture2D, _Property_8ec0d512145619859d288abab740e3bf_Out_0_Vector4, _Property_122c0f9ef0a1c4818a140c75e512abe4_Out_0_Boolean, UnityBuildSamplerStateStruct(SamplerState_Linear_Repeat_Aniso8), 1, _PlanarNM_cb7ded32e6af3382bbe06b62977afab6, _PlanarNM_cb7ded32e6af3382bbe06b62977afab6_XZ_2_Vector4);
            float4 _Property_41859d117584758eb8002ecc938f9bce_Out_0_Vector4 = _BaseColor;
            float4 _Multiply_4d0f82599060228a9092027fd43912c8_Out_2_Vector4;
            Unity_Multiply_float4_float4(_PlanarNM_cb7ded32e6af3382bbe06b62977afab6_XZ_2_Vector4, _Property_41859d117584758eb8002ecc938f9bce_Out_0_Vector4, _Multiply_4d0f82599060228a9092027fd43912c8_Out_2_Vector4);
            float3 _ColorspaceConversion_30c5042ef70343cd92056cde73cd3ecb_Out_1_Vector3;
            Unity_ColorspaceConversion_Linear_RGB_float((_Multiply_4d0f82599060228a9092027fd43912c8_Out_2_Vector4.xyz), _ColorspaceConversion_30c5042ef70343cd92056cde73cd3ecb_Out_1_Vector3);
            UnityTexture2D _Property_50403cc6b1e3998a82afc21c6a6332ae_Out_0_Texture2D = UnityBuildTexture2DStructNoScale(_DetailMap);
            float4 _Property_256e5676e1089881ae3214634430b140_Out_0_Vector4 = _DetailTilingOffset;
            float _Split_257d0b6ea953418d97fd7daa8128bf35_R_1_Float = _Property_256e5676e1089881ae3214634430b140_Out_0_Vector4[0];
            float _Split_257d0b6ea953418d97fd7daa8128bf35_G_2_Float = _Property_256e5676e1089881ae3214634430b140_Out_0_Vector4[1];
            float _Split_257d0b6ea953418d97fd7daa8128bf35_B_3_Float = _Property_256e5676e1089881ae3214634430b140_Out_0_Vector4[2];
            float _Split_257d0b6ea953418d97fd7daa8128bf35_A_4_Float = _Property_256e5676e1089881ae3214634430b140_Out_0_Vector4[3];
            float2 _Vector2_98295494172421878c7a16cb2baddf9a_Out_0_Vector2 = float2(_Split_257d0b6ea953418d97fd7daa8128bf35_R_1_Float, _Split_257d0b6ea953418d97fd7daa8128bf35_G_2_Float);
            float2 _Vector2_130e8faa59837a81a7506636fcb30b8a_Out_0_Vector2 = float2(_Split_257d0b6ea953418d97fd7daa8128bf35_B_3_Float, _Split_257d0b6ea953418d97fd7daa8128bf35_A_4_Float);
            float2 _TilingAndOffset_1dfb2b4859ec3680ad3a74cf8f1bc17b_Out_3_Vector2;
            Unity_TilingAndOffset_float(IN.uv0.xy, _Vector2_98295494172421878c7a16cb2baddf9a_Out_0_Vector2, _Vector2_130e8faa59837a81a7506636fcb30b8a_Out_0_Vector2, _TilingAndOffset_1dfb2b4859ec3680ad3a74cf8f1bc17b_Out_3_Vector2);
            float4 _SampleTexture2D_d8eb0186b9a0cd819cde65431b4ea5ea_RGBA_0_Vector4 = SAMPLE_TEXTURE2D(_Property_50403cc6b1e3998a82afc21c6a6332ae_Out_0_Texture2D.tex, UnityBuildSamplerStateStruct(SamplerState_Linear_Repeat_Aniso8).samplerstate, _Property_50403cc6b1e3998a82afc21c6a6332ae_Out_0_Texture2D.GetTransformedUV(_TilingAndOffset_1dfb2b4859ec3680ad3a74cf8f1bc17b_Out_3_Vector2) );
            float _SampleTexture2D_d8eb0186b9a0cd819cde65431b4ea5ea_R_4_Float = _SampleTexture2D_d8eb0186b9a0cd819cde65431b4ea5ea_RGBA_0_Vector4.r;
            float _SampleTexture2D_d8eb0186b9a0cd819cde65431b4ea5ea_G_5_Float = _SampleTexture2D_d8eb0186b9a0cd819cde65431b4ea5ea_RGBA_0_Vector4.g;
            float _SampleTexture2D_d8eb0186b9a0cd819cde65431b4ea5ea_B_6_Float = _SampleTexture2D_d8eb0186b9a0cd819cde65431b4ea5ea_RGBA_0_Vector4.b;
            float _SampleTexture2D_d8eb0186b9a0cd819cde65431b4ea5ea_A_7_Float = _SampleTexture2D_d8eb0186b9a0cd819cde65431b4ea5ea_RGBA_0_Vector4.a;
            float _Property_605f29777330a58ba88ac032e905433b_Out_0_Float = _DetailAlbedoScale;
            float3 _Blend_de85bf99257f4eb7bb321fd973539f10_Out_2_Vector3;
            Unity_Blend_Overlay_float3(_ColorspaceConversion_30c5042ef70343cd92056cde73cd3ecb_Out_1_Vector3, (_SampleTexture2D_d8eb0186b9a0cd819cde65431b4ea5ea_R_4_Float.xxx), _Blend_de85bf99257f4eb7bb321fd973539f10_Out_2_Vector3, _Property_605f29777330a58ba88ac032e905433b_Out_0_Float);
            float3 _ColorspaceConversion_635670d250654503b34efa53a99ba43e_Out_1_Vector3;
            Unity_ColorspaceConversion_RGB_Linear_float(_Blend_de85bf99257f4eb7bb321fd973539f10_Out_2_Vector3, _ColorspaceConversion_635670d250654503b34efa53a99ba43e_Out_1_Vector3);
            float3 _Clamp_8913f48f801c43c2879f2e1ce926507e_Out_3_Vector3;
            Unity_Clamp_float3(_ColorspaceConversion_635670d250654503b34efa53a99ba43e_Out_1_Vector3, float3(0, 0, 0), float3(1, 1, 1), _Clamp_8913f48f801c43c2879f2e1ce926507e_Out_3_Vector3);
            float _Split_ddfe447fbb7845e88cc5cfb8158b2248_R_1_Float = _Clamp_8913f48f801c43c2879f2e1ce926507e_Out_3_Vector3[0];
            float _Split_ddfe447fbb7845e88cc5cfb8158b2248_G_2_Float = _Clamp_8913f48f801c43c2879f2e1ce926507e_Out_3_Vector3[1];
            float _Split_ddfe447fbb7845e88cc5cfb8158b2248_B_3_Float = _Clamp_8913f48f801c43c2879f2e1ce926507e_Out_3_Vector3[2];
            float _Split_ddfe447fbb7845e88cc5cfb8158b2248_A_4_Float = 0;
            float _Split_6d7debfd2b20440e932d58108f8e7f75_R_1_Float = _Multiply_4d0f82599060228a9092027fd43912c8_Out_2_Vector4[0];
            float _Split_6d7debfd2b20440e932d58108f8e7f75_G_2_Float = _Multiply_4d0f82599060228a9092027fd43912c8_Out_2_Vector4[1];
            float _Split_6d7debfd2b20440e932d58108f8e7f75_B_3_Float = _Multiply_4d0f82599060228a9092027fd43912c8_Out_2_Vector4[2];
            float _Split_6d7debfd2b20440e932d58108f8e7f75_A_4_Float = _Multiply_4d0f82599060228a9092027fd43912c8_Out_2_Vector4[3];
            float4 _Combine_b0f28916143e4b94af6bec53f5328b52_RGBA_4_Vector4;
            float3 _Combine_b0f28916143e4b94af6bec53f5328b52_RGB_5_Vector3;
            float2 _Combine_b0f28916143e4b94af6bec53f5328b52_RG_6_Vector2;
            Unity_Combine_float(_Split_ddfe447fbb7845e88cc5cfb8158b2248_R_1_Float, _Split_ddfe447fbb7845e88cc5cfb8158b2248_G_2_Float, _Split_ddfe447fbb7845e88cc5cfb8158b2248_B_3_Float, _Split_6d7debfd2b20440e932d58108f8e7f75_A_4_Float, _Combine_b0f28916143e4b94af6bec53f5328b52_RGBA_4_Vector4, _Combine_b0f28916143e4b94af6bec53f5328b52_RGB_5_Vector3, _Combine_b0f28916143e4b94af6bec53f5328b52_RG_6_Vector2);
            UnityTexture2D _Property_a155ddc33ed90685a5ab0edcf158a343_Out_0_Texture2D = UnityBuildTexture2DStructNoScale(_CoverBaseColorMap);
            float4 _Property_256beda96caf2d8aa05d3de41fc08d3d_Out_0_Vector4 = _CoverTilingOffset;
            float _Property_bd9dfe8dd615798f9f2d72d139e56d61_Out_0_Boolean = _CoverUsePlanarUV;
            Bindings_PlanarNM_c0f081da9c567704ea36e7dd38cedcf6_float _PlanarNM_e00e057d3d7c4181b1c7775c6ebbab5b;
            _PlanarNM_e00e057d3d7c4181b1c7775c6ebbab5b.AbsoluteWorldSpacePosition = IN.AbsoluteWorldSpacePosition;
            _PlanarNM_e00e057d3d7c4181b1c7775c6ebbab5b.uv0 = IN.uv0;
            _PlanarNM_e00e057d3d7c4181b1c7775c6ebbab5b.uv3 = IN.uv3;
            float4 _PlanarNM_e00e057d3d7c4181b1c7775c6ebbab5b_XZ_2_Vector4;
            SG_PlanarNM_c0f081da9c567704ea36e7dd38cedcf6_float(_Property_a155ddc33ed90685a5ab0edcf158a343_Out_0_Texture2D, _Property_256beda96caf2d8aa05d3de41fc08d3d_Out_0_Vector4, _Property_bd9dfe8dd615798f9f2d72d139e56d61_Out_0_Boolean, UnityBuildSamplerStateStruct(SamplerState_Linear_Repeat_Aniso8), 1, _PlanarNM_e00e057d3d7c4181b1c7775c6ebbab5b, _PlanarNM_e00e057d3d7c4181b1c7775c6ebbab5b_XZ_2_Vector4);
            float4 _Property_c3be5593fd661b8dafbd04f26b8ec9ac_Out_0_Vector4 = _CoverBaseColor;
            float4 _Multiply_b08794693505bd8e8c04b9ba1610d394_Out_2_Vector4;
            Unity_Multiply_float4_float4(_PlanarNM_e00e057d3d7c4181b1c7775c6ebbab5b_XZ_2_Vector4, _Property_c3be5593fd661b8dafbd04f26b8ec9ac_Out_0_Vector4, _Multiply_b08794693505bd8e8c04b9ba1610d394_Out_2_Vector4);
            float _Split_a80936a3c75945efb8cf9f2b95c76642_R_1_Float = IN.VertexColor[0];
            float _Split_a80936a3c75945efb8cf9f2b95c76642_G_2_Float = IN.VertexColor[1];
            float _Split_a80936a3c75945efb8cf9f2b95c76642_B_3_Float = IN.VertexColor[2];
            float _Split_a80936a3c75945efb8cf9f2b95c76642_A_4_Float = IN.VertexColor[3];
            float _Property_14a6757619d64822a44a69b34f85276d_Out_0_Float = _VertexColorGBlendStrenght;
            float _Property_c0d9ffba7dee497c885a54170977d874_Out_0_Boolean = _USEBaseHeightT;
            UnityTexture2D _Property_bb9b47702e64ec8c8d8ad011fd521576_Out_0_Texture2D = UnityBuildTexture2DStructNoScale(_BaseMaskMap);
            Bindings_PlanarNM_c0f081da9c567704ea36e7dd38cedcf6_float _PlanarNM_e51306c84cde8e84a1fb06a45d8d037f;
            _PlanarNM_e51306c84cde8e84a1fb06a45d8d037f.AbsoluteWorldSpacePosition = IN.AbsoluteWorldSpacePosition;
            _PlanarNM_e51306c84cde8e84a1fb06a45d8d037f.uv0 = IN.uv0;
            _PlanarNM_e51306c84cde8e84a1fb06a45d8d037f.uv3 = IN.uv3;
            float4 _PlanarNM_e51306c84cde8e84a1fb06a45d8d037f_XZ_2_Vector4;
            SG_PlanarNM_c0f081da9c567704ea36e7dd38cedcf6_float(_Property_bb9b47702e64ec8c8d8ad011fd521576_Out_0_Texture2D, _Property_8ec0d512145619859d288abab740e3bf_Out_0_Vector4, _Property_122c0f9ef0a1c4818a140c75e512abe4_Out_0_Boolean, UnityBuildSamplerStateStruct(SamplerState_Linear_Repeat_Aniso8), 1, _PlanarNM_e51306c84cde8e84a1fb06a45d8d037f, _PlanarNM_e51306c84cde8e84a1fb06a45d8d037f_XZ_2_Vector4);
            float _Split_218e1cfd00b30984921b5fc0ec63de60_R_1_Float = _PlanarNM_e51306c84cde8e84a1fb06a45d8d037f_XZ_2_Vector4[0];
            float _Split_218e1cfd00b30984921b5fc0ec63de60_G_2_Float = _PlanarNM_e51306c84cde8e84a1fb06a45d8d037f_XZ_2_Vector4[1];
            float _Split_218e1cfd00b30984921b5fc0ec63de60_B_3_Float = _PlanarNM_e51306c84cde8e84a1fb06a45d8d037f_XZ_2_Vector4[2];
            float _Split_218e1cfd00b30984921b5fc0ec63de60_A_4_Float = _PlanarNM_e51306c84cde8e84a1fb06a45d8d037f_XZ_2_Vector4[3];
            float _Property_1d4a1a93707b42c3abf0baa799c514e5_Out_0_Float = _HeightMin;
            float _Property_8f4f3606868d4028a34c2a9a5a59f99d_Out_0_Float = _HeightMax;
            float2 _Vector2_721b6f4d7077463490b4504fe6c940bf_Out_0_Vector2 = float2(_Property_1d4a1a93707b42c3abf0baa799c514e5_Out_0_Float, _Property_8f4f3606868d4028a34c2a9a5a59f99d_Out_0_Float);
            float _Property_a1ae2f61da87421b9f3839691e9dd8af_Out_0_Float = _HeightOffset;
            float2 _Add_1f9ea9bdf36544b59f763806e7eea80d_Out_2_Vector2;
            Unity_Add_float2(_Vector2_721b6f4d7077463490b4504fe6c940bf_Out_0_Vector2, (_Property_a1ae2f61da87421b9f3839691e9dd8af_Out_0_Float.xx), _Add_1f9ea9bdf36544b59f763806e7eea80d_Out_2_Vector2);
            float _Property_0fbef18600294e199eeda9905e3304e4_Out_0_Boolean = _USECoverHeightT;
            UnityTexture2D _Property_3702de305e11e085a40d7731b582d541_Out_0_Texture2D = UnityBuildTexture2DStructNoScale(_CoverMaskMap);
            Bindings_PlanarNM_c0f081da9c567704ea36e7dd38cedcf6_float _PlanarNM_2217ca3c12141a8cb1e0c7235b369601;
            _PlanarNM_2217ca3c12141a8cb1e0c7235b369601.AbsoluteWorldSpacePosition = IN.AbsoluteWorldSpacePosition;
            _PlanarNM_2217ca3c12141a8cb1e0c7235b369601.uv0 = IN.uv0;
            _PlanarNM_2217ca3c12141a8cb1e0c7235b369601.uv3 = IN.uv3;
            float4 _PlanarNM_2217ca3c12141a8cb1e0c7235b369601_XZ_2_Vector4;
            SG_PlanarNM_c0f081da9c567704ea36e7dd38cedcf6_float(_Property_3702de305e11e085a40d7731b582d541_Out_0_Texture2D, _Property_256beda96caf2d8aa05d3de41fc08d3d_Out_0_Vector4, _Property_bd9dfe8dd615798f9f2d72d139e56d61_Out_0_Boolean, UnityBuildSamplerStateStruct(SamplerState_Linear_Repeat_Aniso8), 1, _PlanarNM_2217ca3c12141a8cb1e0c7235b369601, _PlanarNM_2217ca3c12141a8cb1e0c7235b369601_XZ_2_Vector4);
            float _Split_2f45bca363698c859e51492899bc58f8_R_1_Float = _PlanarNM_2217ca3c12141a8cb1e0c7235b369601_XZ_2_Vector4[0];
            float _Split_2f45bca363698c859e51492899bc58f8_G_2_Float = _PlanarNM_2217ca3c12141a8cb1e0c7235b369601_XZ_2_Vector4[1];
            float _Split_2f45bca363698c859e51492899bc58f8_B_3_Float = _PlanarNM_2217ca3c12141a8cb1e0c7235b369601_XZ_2_Vector4[2];
            float _Split_2f45bca363698c859e51492899bc58f8_A_4_Float = _PlanarNM_2217ca3c12141a8cb1e0c7235b369601_XZ_2_Vector4[3];
            float _Property_32b48052fdbb4641bf4eeb294bc65050_Out_0_Float = _CoverHeightMapMin;
            float _Property_0e120eb0a0a14b12a31a3c1f5b961121_Out_0_Float = _CoverHeightMapMax;
            float2 _Vector2_6955747f7f0a4ff98fae60dbada25e89_Out_0_Vector2 = float2(_Property_32b48052fdbb4641bf4eeb294bc65050_Out_0_Float, _Property_0e120eb0a0a14b12a31a3c1f5b961121_Out_0_Float);
            float _Property_6b467710b0ba48058e003aebe9119249_Out_0_Float = _CoverHeightMapOffset;
            float2 _Add_28628d641d58481084e9c00e4ad5fc8d_Out_2_Vector2;
            Unity_Add_float2(_Vector2_6955747f7f0a4ff98fae60dbada25e89_Out_0_Vector2, (_Property_6b467710b0ba48058e003aebe9119249_Out_0_Float.xx), _Add_28628d641d58481084e9c00e4ad5fc8d_Out_2_Vector2);
            UnityTexture2D _Property_7bea2d9dd5651a8bbbd61ecde71faa54_Out_0_Texture2D = UnityBuildTexture2DStructNoScale(_Masks);
            float4 _UV_429c95affe88aa8694076115c99a0769_Out_0_Vector4 = IN.uv0;
            float4 _SampleTexture2D_2723da80b8a2528381ef199c0415beae_RGBA_0_Vector4 = SAMPLE_TEXTURE2D(_Property_7bea2d9dd5651a8bbbd61ecde71faa54_Out_0_Texture2D.tex, UnityBuildSamplerStateStruct(SamplerState_Linear_Repeat_Aniso8).samplerstate, _Property_7bea2d9dd5651a8bbbd61ecde71faa54_Out_0_Texture2D.GetTransformedUV((_UV_429c95affe88aa8694076115c99a0769_Out_0_Vector4.xy)) );
            float _SampleTexture2D_2723da80b8a2528381ef199c0415beae_R_4_Float = _SampleTexture2D_2723da80b8a2528381ef199c0415beae_RGBA_0_Vector4.r;
            float _SampleTexture2D_2723da80b8a2528381ef199c0415beae_G_5_Float = _SampleTexture2D_2723da80b8a2528381ef199c0415beae_RGBA_0_Vector4.g;
            float _SampleTexture2D_2723da80b8a2528381ef199c0415beae_B_6_Float = _SampleTexture2D_2723da80b8a2528381ef199c0415beae_RGBA_0_Vector4.b;
            float _SampleTexture2D_2723da80b8a2528381ef199c0415beae_A_7_Float = _SampleTexture2D_2723da80b8a2528381ef199c0415beae_RGBA_0_Vector4.a;
            float _Property_7bea2851849541b28a2bc695d39a7606_Out_0_Float = _Cover_Mask_A_Remap_Min;
            float _Property_3be0ae138e414a5cb43d60264b1bcfeb_Out_0_Float = _Cover_Mask_A_Remap_Max;
            float2 _Vector2_44ac029de1e440a799fbdfadc778af0c_Out_0_Vector2 = float2(_Property_7bea2851849541b28a2bc695d39a7606_Out_0_Float, _Property_3be0ae138e414a5cb43d60264b1bcfeb_Out_0_Float);
            float _Remap_0c551a3055a54f16b85b519194883552_Out_3_Float;
            Unity_Remap_float(_SampleTexture2D_2723da80b8a2528381ef199c0415beae_A_7_Float, float2 (0, 1), _Vector2_44ac029de1e440a799fbdfadc778af0c_Out_0_Vector2, _Remap_0c551a3055a54f16b85b519194883552_Out_3_Float);
            float _Clamp_bb1427696ce14fe987f799fecc5f9fac_Out_3_Float;
            Unity_Clamp_float(_Remap_0c551a3055a54f16b85b519194883552_Out_3_Float, float(0), float(1), _Clamp_bb1427696ce14fe987f799fecc5f9fac_Out_3_Float);
            float2 _Vector2_0d28074858599a88940dfc8b57b9a60f_Out_0_Vector2 = float2(_SampleTexture2D_d8eb0186b9a0cd819cde65431b4ea5ea_A_7_Float, _SampleTexture2D_d8eb0186b9a0cd819cde65431b4ea5ea_G_5_Float);
            float2 _Multiply_fac8d94f82a53486bc0142a1e64b3d32_Out_2_Vector2;
            Unity_Multiply_float2_float2(_Vector2_0d28074858599a88940dfc8b57b9a60f_Out_0_Vector2, float2(2, 2), _Multiply_fac8d94f82a53486bc0142a1e64b3d32_Out_2_Vector2);
            float2 _Add_f0e6e847d8d8798ab3ca8c4d878bafc0_Out_2_Vector2;
            Unity_Add_float2(_Multiply_fac8d94f82a53486bc0142a1e64b3d32_Out_2_Vector2, float2(-1, -1), _Add_f0e6e847d8d8798ab3ca8c4d878bafc0_Out_2_Vector2);
            float _Property_d0e8d8f7fd10f0829e8fd86c278c8226_Out_0_Float = _DetailNormalScale;
            float2 _Multiply_11f3dfc5283ea188ad9c83e552cf7e0f_Out_2_Vector2;
            Unity_Multiply_float2_float2(_Add_f0e6e847d8d8798ab3ca8c4d878bafc0_Out_2_Vector2, (_Property_d0e8d8f7fd10f0829e8fd86c278c8226_Out_0_Float.xx), _Multiply_11f3dfc5283ea188ad9c83e552cf7e0f_Out_2_Vector2);
            float _Split_c4822b8eaff9b185be7c059792345712_R_1_Float = _Multiply_11f3dfc5283ea188ad9c83e552cf7e0f_Out_2_Vector2[0];
            float _Split_c4822b8eaff9b185be7c059792345712_G_2_Float = _Multiply_11f3dfc5283ea188ad9c83e552cf7e0f_Out_2_Vector2[1];
            float _Split_c4822b8eaff9b185be7c059792345712_B_3_Float = 0;
            float _Split_c4822b8eaff9b185be7c059792345712_A_4_Float = 0;
            float _DotProduct_1a01939a143c548c8ccd7e8a04fe680d_Out_2_Float;
            Unity_DotProduct_float2(_Multiply_11f3dfc5283ea188ad9c83e552cf7e0f_Out_2_Vector2, _Multiply_11f3dfc5283ea188ad9c83e552cf7e0f_Out_2_Vector2, _DotProduct_1a01939a143c548c8ccd7e8a04fe680d_Out_2_Float);
            float _Saturate_bf3d57899db77f86a1689105ce6a373a_Out_1_Float;
            Unity_Saturate_float(_DotProduct_1a01939a143c548c8ccd7e8a04fe680d_Out_2_Float, _Saturate_bf3d57899db77f86a1689105ce6a373a_Out_1_Float);
            float _OneMinus_052960238cc4a18cb83109d2bcae6d09_Out_1_Float;
            Unity_OneMinus_float(_Saturate_bf3d57899db77f86a1689105ce6a373a_Out_1_Float, _OneMinus_052960238cc4a18cb83109d2bcae6d09_Out_1_Float);
            float _SquareRoot_d4f67288e4dbf5898bea492a70b89ab9_Out_1_Float;
            Unity_SquareRoot_float(_OneMinus_052960238cc4a18cb83109d2bcae6d09_Out_1_Float, _SquareRoot_d4f67288e4dbf5898bea492a70b89ab9_Out_1_Float);
            float3 _Vector3_1e56146bdd567884bb8d5ae769df4d29_Out_0_Vector3 = float3(_Split_c4822b8eaff9b185be7c059792345712_R_1_Float, _Split_c4822b8eaff9b185be7c059792345712_G_2_Float, _SquareRoot_d4f67288e4dbf5898bea492a70b89ab9_Out_1_Float);
            UnityTexture2D _Property_147b07430832c98eb0a470557ee61c5e_Out_0_Texture2D = UnityBuildTexture2DStructNoScale(_BaseNormalMap);
            Bindings_PlanarNMn_1b93a87456f9d4c419321d0cd92bd6c8_float _PlanarNMn_ecad9f1f260c6c8bbd0960b2a8976daf;
            _PlanarNMn_ecad9f1f260c6c8bbd0960b2a8976daf.WorldSpaceNormal = IN.WorldSpaceNormal;
            _PlanarNMn_ecad9f1f260c6c8bbd0960b2a8976daf.WorldSpaceTangent = IN.WorldSpaceTangent;
            _PlanarNMn_ecad9f1f260c6c8bbd0960b2a8976daf.WorldSpaceBiTangent = IN.WorldSpaceBiTangent;
            _PlanarNMn_ecad9f1f260c6c8bbd0960b2a8976daf.AbsoluteWorldSpacePosition = IN.AbsoluteWorldSpacePosition;
            _PlanarNMn_ecad9f1f260c6c8bbd0960b2a8976daf.uv0 = IN.uv0;
            _PlanarNMn_ecad9f1f260c6c8bbd0960b2a8976daf.uv3 = IN.uv3;
            float4 _PlanarNMn_ecad9f1f260c6c8bbd0960b2a8976daf_XZ_2_Vector4;
            SG_PlanarNMn_1b93a87456f9d4c419321d0cd92bd6c8_float(_Property_147b07430832c98eb0a470557ee61c5e_Out_0_Texture2D, _Property_8ec0d512145619859d288abab740e3bf_Out_0_Vector4, _Property_122c0f9ef0a1c4818a140c75e512abe4_Out_0_Boolean, UnityBuildSamplerStateStruct(SamplerState_Linear_Repeat_Aniso8), 1, _PlanarNMn_ecad9f1f260c6c8bbd0960b2a8976daf, _PlanarNMn_ecad9f1f260c6c8bbd0960b2a8976daf_XZ_2_Vector4);
            float _Property_72e436a108ad64868e46d548c585c5f3_Out_0_Float = _BaseNormalScale;
            float3 _NormalStrength_366affc5c8b42482a633d201ef52b9d6_Out_2_Vector3;
            Unity_NormalStrength_float((_PlanarNMn_ecad9f1f260c6c8bbd0960b2a8976daf_XZ_2_Vector4.xyz), _Property_72e436a108ad64868e46d548c585c5f3_Out_0_Float, _NormalStrength_366affc5c8b42482a633d201ef52b9d6_Out_2_Vector3);
            float3 _NormalBlend_9f531c87e2e45580b1d0f65f06c23526_Out_2_Vector3;
            Unity_NormalBlend_Reoriented_float(_Vector3_1e56146bdd567884bb8d5ae769df4d29_Out_0_Vector3, _NormalStrength_366affc5c8b42482a633d201ef52b9d6_Out_2_Vector3, _NormalBlend_9f531c87e2e45580b1d0f65f06c23526_Out_2_Vector3);
            UnityTexture2D _Property_d7e9139e0ac6718b89c610009c28a25a_Out_0_Texture2D = UnityBuildTexture2DStructNoScale(_CoverNormalMap);
            Bindings_PlanarNMn_1b93a87456f9d4c419321d0cd92bd6c8_float _PlanarNMn_690e893d26999680a5cea3604ed0ce16;
            _PlanarNMn_690e893d26999680a5cea3604ed0ce16.WorldSpaceNormal = IN.WorldSpaceNormal;
            _PlanarNMn_690e893d26999680a5cea3604ed0ce16.WorldSpaceTangent = IN.WorldSpaceTangent;
            _PlanarNMn_690e893d26999680a5cea3604ed0ce16.WorldSpaceBiTangent = IN.WorldSpaceBiTangent;
            _PlanarNMn_690e893d26999680a5cea3604ed0ce16.AbsoluteWorldSpacePosition = IN.AbsoluteWorldSpacePosition;
            _PlanarNMn_690e893d26999680a5cea3604ed0ce16.uv0 = IN.uv0;
            _PlanarNMn_690e893d26999680a5cea3604ed0ce16.uv3 = IN.uv3;
            float4 _PlanarNMn_690e893d26999680a5cea3604ed0ce16_XZ_2_Vector4;
            SG_PlanarNMn_1b93a87456f9d4c419321d0cd92bd6c8_float(_Property_d7e9139e0ac6718b89c610009c28a25a_Out_0_Texture2D, _Property_256beda96caf2d8aa05d3de41fc08d3d_Out_0_Vector4, _Property_bd9dfe8dd615798f9f2d72d139e56d61_Out_0_Boolean, UnityBuildSamplerStateStruct(SamplerState_Linear_Repeat_Aniso8), 1, _PlanarNMn_690e893d26999680a5cea3604ed0ce16, _PlanarNMn_690e893d26999680a5cea3604ed0ce16_XZ_2_Vector4);
            float _Property_0fd4d87ded104c829a6110c044eaa5f2_Out_0_Float = _CoverNormalBlendHardness;
            float3 _NormalStrength_c4639a6dd3dfde85b591971db2700eaf_Out_2_Vector3;
            Unity_NormalStrength_float((_PlanarNMn_690e893d26999680a5cea3604ed0ce16_XZ_2_Vector4.xyz), _Property_0fd4d87ded104c829a6110c044eaa5f2_Out_0_Float, _NormalStrength_c4639a6dd3dfde85b591971db2700eaf_Out_2_Vector3);
            float _Split_8ff22a6bdd437780ac7ea5963e1c5bb4_R_1_Float = IN.WorldSpaceNormal[0];
            float _Split_8ff22a6bdd437780ac7ea5963e1c5bb4_G_2_Float = IN.WorldSpaceNormal[1];
            float _Split_8ff22a6bdd437780ac7ea5963e1c5bb4_B_3_Float = IN.WorldSpaceNormal[2];
            float _Split_8ff22a6bdd437780ac7ea5963e1c5bb4_A_4_Float = 0;
            float _Property_28052b023ac35c8e9a95b30327681cc5_Out_0_Float = _Cover_Amount;
            float _Property_7749c0d5b28c14869ab3ba35d226788b_Out_0_Float = _Cover_Amount_Grow_Speed;
            float _Subtract_e5dc2afce7ff588fa1d4c91f78de7575_Out_2_Float;
            Unity_Subtract_float(float(4), _Property_7749c0d5b28c14869ab3ba35d226788b_Out_0_Float, _Subtract_e5dc2afce7ff588fa1d4c91f78de7575_Out_2_Float);
            float _Divide_c77b003bf1ce13828c94a705676e2b30_Out_2_Float;
            Unity_Divide_float(_Property_28052b023ac35c8e9a95b30327681cc5_Out_0_Float, _Subtract_e5dc2afce7ff588fa1d4c91f78de7575_Out_2_Float, _Divide_c77b003bf1ce13828c94a705676e2b30_Out_2_Float);
            float _Absolute_c7499cf07bdd0582abd82adbf367b0fc_Out_1_Float;
            Unity_Absolute_float(_Divide_c77b003bf1ce13828c94a705676e2b30_Out_2_Float, _Absolute_c7499cf07bdd0582abd82adbf367b0fc_Out_1_Float);
            float _Power_a9431dbce44a528f9ee7095adfa10556_Out_2_Float;
            Unity_Power_float(_Absolute_c7499cf07bdd0582abd82adbf367b0fc_Out_1_Float, _Subtract_e5dc2afce7ff588fa1d4c91f78de7575_Out_2_Float, _Power_a9431dbce44a528f9ee7095adfa10556_Out_2_Float);
            float _Clamp_815ffdd53cc1c889aa00f73784cb71e7_Out_3_Float;
            Unity_Clamp_float(_Power_a9431dbce44a528f9ee7095adfa10556_Out_2_Float, float(0), float(2), _Clamp_815ffdd53cc1c889aa00f73784cb71e7_Out_3_Float);
            float _Multiply_143da4886728ff868f10e9cfa6940ea0_Out_2_Float;
            Unity_Multiply_float_float(_Split_8ff22a6bdd437780ac7ea5963e1c5bb4_G_2_Float, _Clamp_815ffdd53cc1c889aa00f73784cb71e7_Out_3_Float, _Multiply_143da4886728ff868f10e9cfa6940ea0_Out_2_Float);
            float _Saturate_04686ab19029f68c8fb9e7a115b207b1_Out_1_Float;
            Unity_Saturate_float(_Multiply_143da4886728ff868f10e9cfa6940ea0_Out_2_Float, _Saturate_04686ab19029f68c8fb9e7a115b207b1_Out_1_Float);
            float _Clamp_9c0a88ffc7be288cbe97d3e13a014fe8_Out_3_Float;
            Unity_Clamp_float(_Split_8ff22a6bdd437780ac7ea5963e1c5bb4_G_2_Float, float(0), float(0.9999), _Clamp_9c0a88ffc7be288cbe97d3e13a014fe8_Out_3_Float);
            float _Property_58f42b34c7f0728f8c98e00a3e3a5726_Out_0_Float = _Cover_Max_Angle;
            float _Divide_b785767ecc1928889893fa60eac4e5fb_Out_2_Float;
            Unity_Divide_float(_Property_58f42b34c7f0728f8c98e00a3e3a5726_Out_0_Float, float(45), _Divide_b785767ecc1928889893fa60eac4e5fb_Out_2_Float);
            float _OneMinus_8e6f5b1570dc8c8b8afb036328281675_Out_1_Float;
            Unity_OneMinus_float(_Divide_b785767ecc1928889893fa60eac4e5fb_Out_2_Float, _OneMinus_8e6f5b1570dc8c8b8afb036328281675_Out_1_Float);
            float _Subtract_5348fb3702fea78d9ee10dbf81ede29c_Out_2_Float;
            Unity_Subtract_float(_Clamp_9c0a88ffc7be288cbe97d3e13a014fe8_Out_3_Float, _OneMinus_8e6f5b1570dc8c8b8afb036328281675_Out_1_Float, _Subtract_5348fb3702fea78d9ee10dbf81ede29c_Out_2_Float);
            float _Clamp_2b888688983edd82ac250226d9378893_Out_3_Float;
            Unity_Clamp_float(_Subtract_5348fb3702fea78d9ee10dbf81ede29c_Out_2_Float, float(0), float(2), _Clamp_2b888688983edd82ac250226d9378893_Out_3_Float);
            float _Divide_5615f16c20214d888a2e727ff7c5f5ff_Out_2_Float;
            Unity_Divide_float(float(1), _Divide_b785767ecc1928889893fa60eac4e5fb_Out_2_Float, _Divide_5615f16c20214d888a2e727ff7c5f5ff_Out_2_Float);
            float _Multiply_89aeffc0ad067981a18e6a77948b2b49_Out_2_Float;
            Unity_Multiply_float_float(_Clamp_2b888688983edd82ac250226d9378893_Out_3_Float, _Divide_5615f16c20214d888a2e727ff7c5f5ff_Out_2_Float, _Multiply_89aeffc0ad067981a18e6a77948b2b49_Out_2_Float);
            float _Absolute_b91ed8e326de8f88bf52e49cc5f641d4_Out_1_Float;
            Unity_Absolute_float(_Multiply_89aeffc0ad067981a18e6a77948b2b49_Out_2_Float, _Absolute_b91ed8e326de8f88bf52e49cc5f641d4_Out_1_Float);
            float _Property_4879e96694aee98c9d4ecd329a571123_Out_0_Float = _CoverHardness;
            float _Power_ca1f1906c90fb785bfe520b7faefc3cd_Out_2_Float;
            Unity_Power_float(_Absolute_b91ed8e326de8f88bf52e49cc5f641d4_Out_1_Float, _Property_4879e96694aee98c9d4ecd329a571123_Out_0_Float, _Power_ca1f1906c90fb785bfe520b7faefc3cd_Out_2_Float);
            float _Property_b66201e787ab7b83a55abc6ddd3fe1fd_Out_0_Float = _Cover_Min_Height;
            float _OneMinus_87c740d245de388db4fe5f4958de0668_Out_1_Float;
            Unity_OneMinus_float(_Property_b66201e787ab7b83a55abc6ddd3fe1fd_Out_0_Float, _OneMinus_87c740d245de388db4fe5f4958de0668_Out_1_Float);
            float _Split_ae16de7cacf9d0878aba1467f193d681_R_1_Float = IN.AbsoluteWorldSpacePosition[0];
            float _Split_ae16de7cacf9d0878aba1467f193d681_G_2_Float = IN.AbsoluteWorldSpacePosition[1];
            float _Split_ae16de7cacf9d0878aba1467f193d681_B_3_Float = IN.AbsoluteWorldSpacePosition[2];
            float _Split_ae16de7cacf9d0878aba1467f193d681_A_4_Float = 0;
            float _Add_9d6e1dd03919c88bb01e77a9a2b6b59c_Out_2_Float;
            Unity_Add_float(_OneMinus_87c740d245de388db4fe5f4958de0668_Out_1_Float, _Split_ae16de7cacf9d0878aba1467f193d681_G_2_Float, _Add_9d6e1dd03919c88bb01e77a9a2b6b59c_Out_2_Float);
            float _Add_448f30a2cd792b868416a253a1c502bb_Out_2_Float;
            Unity_Add_float(_Add_9d6e1dd03919c88bb01e77a9a2b6b59c_Out_2_Float, float(1), _Add_448f30a2cd792b868416a253a1c502bb_Out_2_Float);
            float _Clamp_53d91568d0627d8a9cac8deecdd003a8_Out_3_Float;
            Unity_Clamp_float(_Add_448f30a2cd792b868416a253a1c502bb_Out_2_Float, float(0), float(1), _Clamp_53d91568d0627d8a9cac8deecdd003a8_Out_3_Float);
            float _Property_98b8c0fc7e8f9b88b8d7d9dd28ed8aca_Out_0_Float = _Cover_Min_Height_Blending;
            float _Add_0edbe9f424de6d8089b453804bc6ec74_Out_2_Float;
            Unity_Add_float(_Add_9d6e1dd03919c88bb01e77a9a2b6b59c_Out_2_Float, _Property_98b8c0fc7e8f9b88b8d7d9dd28ed8aca_Out_0_Float, _Add_0edbe9f424de6d8089b453804bc6ec74_Out_2_Float);
            float _Divide_bacd243000beaa86b28174bd47716791_Out_2_Float;
            Unity_Divide_float(_Add_0edbe9f424de6d8089b453804bc6ec74_Out_2_Float, _Add_9d6e1dd03919c88bb01e77a9a2b6b59c_Out_2_Float, _Divide_bacd243000beaa86b28174bd47716791_Out_2_Float);
            float _OneMinus_dd51a0c56dbb9b8b8882c6d36bfadd50_Out_1_Float;
            Unity_OneMinus_float(_Divide_bacd243000beaa86b28174bd47716791_Out_2_Float, _OneMinus_dd51a0c56dbb9b8b8882c6d36bfadd50_Out_1_Float);
            float _Add_58dd4a9dfd5655818255c74dd17921da_Out_2_Float;
            Unity_Add_float(_OneMinus_dd51a0c56dbb9b8b8882c6d36bfadd50_Out_1_Float, float(-0.5), _Add_58dd4a9dfd5655818255c74dd17921da_Out_2_Float);
            float _Clamp_5b36f07b81ef6f87a93aefa8fcb815b4_Out_3_Float;
            Unity_Clamp_float(_Add_58dd4a9dfd5655818255c74dd17921da_Out_2_Float, float(0), float(1), _Clamp_5b36f07b81ef6f87a93aefa8fcb815b4_Out_3_Float);
            float _Add_5ef49a57de2cdf85b0e894bfa07f6f14_Out_2_Float;
            Unity_Add_float(_Clamp_53d91568d0627d8a9cac8deecdd003a8_Out_3_Float, _Clamp_5b36f07b81ef6f87a93aefa8fcb815b4_Out_3_Float, _Add_5ef49a57de2cdf85b0e894bfa07f6f14_Out_2_Float);
            float _Clamp_130844801cc2148bb64804d2328686eb_Out_3_Float;
            Unity_Clamp_float(_Add_5ef49a57de2cdf85b0e894bfa07f6f14_Out_2_Float, float(0), float(1), _Clamp_130844801cc2148bb64804d2328686eb_Out_3_Float);
            float _Multiply_4a38c41b77a2458085ff4ae52ba3c21c_Out_2_Float;
            Unity_Multiply_float_float(_Power_ca1f1906c90fb785bfe520b7faefc3cd_Out_2_Float, _Clamp_130844801cc2148bb64804d2328686eb_Out_3_Float, _Multiply_4a38c41b77a2458085ff4ae52ba3c21c_Out_2_Float);
            float _Multiply_edc44afd10069b8e80460ceee1cba8f0_Out_2_Float;
            Unity_Multiply_float_float(_Saturate_04686ab19029f68c8fb9e7a115b207b1_Out_1_Float, _Multiply_4a38c41b77a2458085ff4ae52ba3c21c_Out_2_Float, _Multiply_edc44afd10069b8e80460ceee1cba8f0_Out_2_Float);
            float3 _Lerp_05179f1a9a06b084b2d83e8bce908cce_Out_3_Vector3;
            Unity_Lerp_float3(_NormalBlend_9f531c87e2e45580b1d0f65f06c23526_Out_2_Vector3, _NormalStrength_c4639a6dd3dfde85b591971db2700eaf_Out_2_Vector3, (_Multiply_edc44afd10069b8e80460ceee1cba8f0_Out_2_Float.xxx), _Lerp_05179f1a9a06b084b2d83e8bce908cce_Out_3_Vector3);
            float3 _Transform_d583fb35b7a2838399ae5ff4e71be918_Out_1_Vector3;
            {
                float3x3 tangentTransform = float3x3(IN.WorldSpaceTangent, IN.WorldSpaceBiTangent, IN.WorldSpaceNormal);
                _Transform_d583fb35b7a2838399ae5ff4e71be918_Out_1_Vector3 = TransformTangentToWorldDir(_Lerp_05179f1a9a06b084b2d83e8bce908cce_Out_3_Vector3.xyz, tangentTransform, false).xyz;
            }
            float _Split_44ee9f8d0d54618cabce22ec49a8e7d3_R_1_Float = _Transform_d583fb35b7a2838399ae5ff4e71be918_Out_1_Vector3[0];
            float _Split_44ee9f8d0d54618cabce22ec49a8e7d3_G_2_Float = _Transform_d583fb35b7a2838399ae5ff4e71be918_Out_1_Vector3[1];
            float _Split_44ee9f8d0d54618cabce22ec49a8e7d3_B_3_Float = _Transform_d583fb35b7a2838399ae5ff4e71be918_Out_1_Vector3[2];
            float _Split_44ee9f8d0d54618cabce22ec49a8e7d3_A_4_Float = 0;
            float _Multiply_61fc6a92f0e952858b5d99f2caeb09a3_Out_2_Float;
            Unity_Multiply_float_float(_Split_44ee9f8d0d54618cabce22ec49a8e7d3_G_2_Float, _Clamp_815ffdd53cc1c889aa00f73784cb71e7_Out_3_Float, _Multiply_61fc6a92f0e952858b5d99f2caeb09a3_Out_2_Float);
            float _Multiply_1e7ca8eeb2afb68a96897072c537d835_Out_2_Float;
            Unity_Multiply_float_float(_Clamp_815ffdd53cc1c889aa00f73784cb71e7_Out_3_Float, _Property_4879e96694aee98c9d4ecd329a571123_Out_0_Float, _Multiply_1e7ca8eeb2afb68a96897072c537d835_Out_2_Float);
            float _Multiply_a16d49a3ef8d76899c86b7d84d20ef1f_Out_2_Float;
            Unity_Multiply_float_float(_Multiply_1e7ca8eeb2afb68a96897072c537d835_Out_2_Float, _Multiply_4a38c41b77a2458085ff4ae52ba3c21c_Out_2_Float, _Multiply_a16d49a3ef8d76899c86b7d84d20ef1f_Out_2_Float);
            float _Multiply_dd6ce40548593687a3441a83047275eb_Out_2_Float;
            Unity_Multiply_float_float(_Multiply_61fc6a92f0e952858b5d99f2caeb09a3_Out_2_Float, _Multiply_a16d49a3ef8d76899c86b7d84d20ef1f_Out_2_Float, _Multiply_dd6ce40548593687a3441a83047275eb_Out_2_Float);
            float _Clamp_a3bc14da42d1452f9459b4703c528466_Out_3_Float;
            Unity_Clamp_float(_Multiply_dd6ce40548593687a3441a83047275eb_Out_2_Float, float(0), float(1), _Clamp_a3bc14da42d1452f9459b4703c528466_Out_3_Float);
            float _Multiply_ce9d0ae57259445ba0ff1b83b3eac7be_Out_2_Float;
            Unity_Multiply_float_float(_Clamp_bb1427696ce14fe987f799fecc5f9fac_Out_3_Float, _Clamp_a3bc14da42d1452f9459b4703c528466_Out_3_Float, _Multiply_ce9d0ae57259445ba0ff1b83b3eac7be_Out_2_Float);
            #if defined(_USEDYNAMICCOVERTSTATICMASKF)
            float _UseDynamicCover_5ab22e0469924273a6c7c42f82abda85_Out_0_Float = _Multiply_ce9d0ae57259445ba0ff1b83b3eac7be_Out_2_Float;
            #else
            float _UseDynamicCover_5ab22e0469924273a6c7c42f82abda85_Out_0_Float = _Clamp_bb1427696ce14fe987f799fecc5f9fac_Out_3_Float;
            #endif
            Bindings_UniversalHeighblend_3b5c31b864970d04197cd420b6c4b0fa_float _UniversalHeighblend_21bd55d8d402489499f7ea440e52eb45;
            float _UniversalHeighblend_21bd55d8d402489499f7ea440e52eb45_Heightmap_1_Float;
            SG_UniversalHeighblend_3b5c31b864970d04197cd420b6c4b0fa_float(_Split_a80936a3c75945efb8cf9f2b95c76642_G_2_Float, _Property_14a6757619d64822a44a69b34f85276d_Out_0_Float, _Property_c0d9ffba7dee497c885a54170977d874_Out_0_Boolean, _Split_218e1cfd00b30984921b5fc0ec63de60_B_3_Float, _Add_1f9ea9bdf36544b59f763806e7eea80d_Out_2_Vector2, _Property_0fbef18600294e199eeda9905e3304e4_Out_0_Boolean, _Split_2f45bca363698c859e51492899bc58f8_B_3_Float, _Add_28628d641d58481084e9c00e4ad5fc8d_Out_2_Vector2, _UseDynamicCover_5ab22e0469924273a6c7c42f82abda85_Out_0_Float, _UniversalHeighblend_21bd55d8d402489499f7ea440e52eb45, _UniversalHeighblend_21bd55d8d402489499f7ea440e52eb45_Heightmap_1_Float);
            float _Split_05a25ef5bb1c4867950074f8c86410e8_R_1_Float = IN.VertexColor[0];
            float _Split_05a25ef5bb1c4867950074f8c86410e8_G_2_Float = IN.VertexColor[1];
            float _Split_05a25ef5bb1c4867950074f8c86410e8_B_3_Float = IN.VertexColor[2];
            float _Split_05a25ef5bb1c4867950074f8c86410e8_A_4_Float = IN.VertexColor[3];
            float _OneMinus_0527b7625ff14e8c8ca27817ac4fe9f9_Out_1_Float;
            Unity_OneMinus_float(_Split_05a25ef5bb1c4867950074f8c86410e8_B_3_Float, _OneMinus_0527b7625ff14e8c8ca27817ac4fe9f9_Out_1_Float);
            float _Property_defdd10d24ee4948b18af67062372fb7_Out_0_Float = _VertexColorBBlendStrenght;
            float _Property_f600c3fa0837403fa7000ace8a7aa949_Out_0_Boolean = _USEBaseHeightT;
            float _Property_cc1df5222a194b39870a1906a95881c7_Out_0_Boolean = _USECoverHeightT;
            float _Subtract_df32895ca10a49a6adc84378c30ceb7c_Out_2_Float;
            Unity_Subtract_float(_Property_0e120eb0a0a14b12a31a3c1f5b961121_Out_0_Float, _Property_32b48052fdbb4641bf4eeb294bc65050_Out_0_Float, _Subtract_df32895ca10a49a6adc84378c30ceb7c_Out_2_Float);
            float _Split_a090b28818f34dd8945b893c7fd769f1_R_1_Float = IN.VertexColor[0];
            float _Split_a090b28818f34dd8945b893c7fd769f1_G_2_Float = IN.VertexColor[1];
            float _Split_a090b28818f34dd8945b893c7fd769f1_B_3_Float = IN.VertexColor[2];
            float _Split_a090b28818f34dd8945b893c7fd769f1_A_4_Float = IN.VertexColor[3];
            float _OneMinus_d11f0c4a04b345419edf8e146b9c0221_Out_1_Float;
            Unity_OneMinus_float(_Split_a090b28818f34dd8945b893c7fd769f1_B_3_Float, _OneMinus_d11f0c4a04b345419edf8e146b9c0221_Out_1_Float);
            float _Multiply_b7ff184632b347e9b3d331daaed81a77_Out_2_Float;
            Unity_Multiply_float_float(_Subtract_df32895ca10a49a6adc84378c30ceb7c_Out_2_Float, _OneMinus_d11f0c4a04b345419edf8e146b9c0221_Out_1_Float, _Multiply_b7ff184632b347e9b3d331daaed81a77_Out_2_Float);
            float _Add_ff8ced5a04044788a5de3632a403c505_Out_2_Float;
            Unity_Add_float(_Property_6b467710b0ba48058e003aebe9119249_Out_0_Float, _Multiply_b7ff184632b347e9b3d331daaed81a77_Out_2_Float, _Add_ff8ced5a04044788a5de3632a403c505_Out_2_Float);
            float2 _Add_8ec067f807d04641bea7fd38ab0c8165_Out_2_Vector2;
            Unity_Add_float2(_Vector2_6955747f7f0a4ff98fae60dbada25e89_Out_0_Vector2, (_Add_ff8ced5a04044788a5de3632a403c505_Out_2_Float.xx), _Add_8ec067f807d04641bea7fd38ab0c8165_Out_2_Vector2);
            Bindings_UniversalHeighblend_3b5c31b864970d04197cd420b6c4b0fa_float _UniversalHeighblend_69e2f839a11b4aa7b8e84d65b0ac8307;
            float _UniversalHeighblend_69e2f839a11b4aa7b8e84d65b0ac8307_Heightmap_1_Float;
            SG_UniversalHeighblend_3b5c31b864970d04197cd420b6c4b0fa_float(_OneMinus_0527b7625ff14e8c8ca27817ac4fe9f9_Out_1_Float, _Property_defdd10d24ee4948b18af67062372fb7_Out_0_Float, _Property_f600c3fa0837403fa7000ace8a7aa949_Out_0_Boolean, _Split_218e1cfd00b30984921b5fc0ec63de60_B_3_Float, _Add_1f9ea9bdf36544b59f763806e7eea80d_Out_2_Vector2, _Property_cc1df5222a194b39870a1906a95881c7_Out_0_Boolean, _Split_2f45bca363698c859e51492899bc58f8_B_3_Float, _Add_8ec067f807d04641bea7fd38ab0c8165_Out_2_Vector2, float(1), _UniversalHeighblend_69e2f839a11b4aa7b8e84d65b0ac8307, _UniversalHeighblend_69e2f839a11b4aa7b8e84d65b0ac8307_Heightmap_1_Float);
            float _Add_facc0ab0661749d4bda41177c639b438_Out_2_Float;
            Unity_Add_float(_UniversalHeighblend_21bd55d8d402489499f7ea440e52eb45_Heightmap_1_Float, _UniversalHeighblend_69e2f839a11b4aa7b8e84d65b0ac8307_Heightmap_1_Float, _Add_facc0ab0661749d4bda41177c639b438_Out_2_Float);
            float _Saturate_269cfab86e2abe83819a3afa7b3eeda2_Out_1_Float;
            Unity_Saturate_float(_Add_facc0ab0661749d4bda41177c639b438_Out_2_Float, _Saturate_269cfab86e2abe83819a3afa7b3eeda2_Out_1_Float);
            float4 _Lerp_562b79f1df34b88e9a8a7431d434b435_Out_3_Vector4;
            Unity_Lerp_float4(_Combine_b0f28916143e4b94af6bec53f5328b52_RGBA_4_Vector4, _Multiply_b08794693505bd8e8c04b9ba1610d394_Out_2_Vector4, (_Saturate_269cfab86e2abe83819a3afa7b3eeda2_Out_1_Float.xxxx), _Lerp_562b79f1df34b88e9a8a7431d434b435_Out_3_Vector4);
            float _Split_546cdec490fe4753bb0983eea82b45b5_R_1_Float = _Lerp_562b79f1df34b88e9a8a7431d434b435_Out_3_Vector4[0];
            float _Split_546cdec490fe4753bb0983eea82b45b5_G_2_Float = _Lerp_562b79f1df34b88e9a8a7431d434b435_Out_3_Vector4[1];
            float _Split_546cdec490fe4753bb0983eea82b45b5_B_3_Float = _Lerp_562b79f1df34b88e9a8a7431d434b435_Out_3_Vector4[2];
            float _Split_546cdec490fe4753bb0983eea82b45b5_A_4_Float = _Lerp_562b79f1df34b88e9a8a7431d434b435_Out_3_Vector4[3];
            float4 _Clamp_33ec4dd182654e108c0f4ee43f91e820_Out_3_Vector4;
            Unity_Clamp_float4(IN.VertexColor, float4(0, 0, 0, 0), float4(1, 1, 1, 1), _Clamp_33ec4dd182654e108c0f4ee43f91e820_Out_3_Vector4);
            float _Split_5b2299b48b10138ea40c141b79bfe90e_R_1_Float = _Clamp_33ec4dd182654e108c0f4ee43f91e820_Out_3_Vector4[0];
            float _Split_5b2299b48b10138ea40c141b79bfe90e_G_2_Float = _Clamp_33ec4dd182654e108c0f4ee43f91e820_Out_3_Vector4[1];
            float _Split_5b2299b48b10138ea40c141b79bfe90e_B_3_Float = _Clamp_33ec4dd182654e108c0f4ee43f91e820_Out_3_Vector4[2];
            float _Split_5b2299b48b10138ea40c141b79bfe90e_A_4_Float = _Clamp_33ec4dd182654e108c0f4ee43f91e820_Out_3_Vector4[3];
            float _Multiply_a7796e97d268424b880f9cb87fc6e42c_Out_2_Float;
            Unity_Multiply_float_float(_Split_546cdec490fe4753bb0983eea82b45b5_A_4_Float, _Split_5b2299b48b10138ea40c141b79bfe90e_A_4_Float, _Multiply_a7796e97d268424b880f9cb87fc6e42c_Out_2_Float);
            float _Property_7ae68b65d6ed4f37aec08ecb89701e8e_Out_0_Float = _AlphaCutoff;
            surface.Alpha = _Multiply_a7796e97d268424b880f9cb87fc6e42c_Out_2_Float;
            surface.AlphaClipThreshold = _Property_7ae68b65d6ed4f37aec08ecb89701e8e_Out_0_Float;
            return surface;
        }
        
        // --------------------------------------------------
        // Build Graph Inputs
        #ifdef HAVE_VFX_MODIFICATION
        #define VFX_SRP_ATTRIBUTES Attributes
        #define VFX_SRP_VARYINGS Varyings
        #define VFX_SRP_SURFACE_INPUTS SurfaceDescriptionInputs
        #endif
        VertexDescriptionInputs BuildVertexDescriptionInputs(Attributes input)
        {
            VertexDescriptionInputs output;
            ZERO_INITIALIZE(VertexDescriptionInputs, output);
        
            output.ObjectSpaceNormal =                          input.normalOS;
            output.ObjectSpaceTangent =                         input.tangentOS.xyz;
            output.ObjectSpacePosition =                        input.positionOS;
        #if UNITY_ANY_INSTANCING_ENABLED
        #else // TODO: XR support for procedural instancing because in this case UNITY_ANY_INSTANCING_ENABLED is not defined and instanceID is incorrect.
        #endif
        
            return output;
        }
        SurfaceDescriptionInputs BuildSurfaceDescriptionInputs(Varyings input)
        {
            SurfaceDescriptionInputs output;
            ZERO_INITIALIZE(SurfaceDescriptionInputs, output);
        
        #ifdef HAVE_VFX_MODIFICATION
        #if VFX_USE_GRAPH_VALUES
            uint instanceActiveIndex = asuint(UNITY_ACCESS_INSTANCED_PROP(PerInstance, _InstanceActiveIndex));
            /* WARNING: $splice Could not find named fragment 'VFXLoadGraphValues' */
        #endif
            /* WARNING: $splice Could not find named fragment 'VFXSetFragInputs' */
        
        #endif
        
            
        
            // must use interpolated tangent, bitangent and normal before they are normalized in the pixel shader.
            float3 unnormalizedNormalWS = input.normalWS;
            const float renormFactor = 1.0 / length(unnormalizedNormalWS);
        
            // use bitangent on the fly like in hdrp
            // IMPORTANT! If we ever support Flip on double sided materials ensure bitangent and tangent are NOT flipped.
            float crossSign = (input.tangentWS.w > 0.0 ? 1.0 : -1.0)* GetOddNegativeScale();
            float3 bitang = crossSign * cross(input.normalWS.xyz, input.tangentWS.xyz);
        
            output.WorldSpaceNormal = renormFactor * input.normalWS.xyz;      // we want a unit length Normal Vector node in shader graph
        
            // to pr               eserve mikktspace compliance we use same scale renormFactor as was used on the normal.
            // This                is explained in section 2.2 in "surface gradient based bump mapping framework"
            output.WorldSpaceTangent = renormFactor * input.tangentWS.xyz;
            output.WorldSpaceBiTangent = renormFactor * bitang;
        
            output.AbsoluteWorldSpacePosition = GetAbsolutePositionWS(input.positionWS);
        
            #if UNITY_UV_STARTS_AT_TOP
            #else
            #endif
        
        
            output.uv0 = input.texCoord0;
            output.uv3 = input.texCoord3;
            output.VertexColor = input.color;
        #if UNITY_ANY_INSTANCING_ENABLED
        #else // TODO: XR support for procedural instancing because in this case UNITY_ANY_INSTANCING_ENABLED is not defined and instanceID is incorrect.
        #endif
        #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
        #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN output.FaceSign =                    IS_FRONT_VFACE(input.cullFace, true, false);
        #else
        #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
        #endif
        #undef BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
        
                return output;
        }
        
        // --------------------------------------------------
        // Main
        
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/Varyings.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShadowCasterPass.hlsl"
        
        // --------------------------------------------------
        // Visual Effect Vertex Invocations
        #ifdef HAVE_VFX_MODIFICATION
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/VisualEffectVertex.hlsl"
        #endif
        
        ENDHLSL
        }
        Pass
        {
            Name "MotionVectors"
            Tags
            {
                "LightMode" = "MotionVectors"
            }
        
        // Render State
        Cull [_Cull]
        ZTest LEqual
        ZWrite On
        ColorMask RG
        
        // Debug
        // <None>
        
        // --------------------------------------------------
        // Pass
        
        HLSLPROGRAM
        
        // Pragmas
        #pragma target 3.5
        #pragma multi_compile_instancing
        #pragma vertex vert
        #pragma fragment frag
        
        // Keywords
        #pragma shader_feature_local_fragment _ _ALPHATEST_ON
        #pragma multi_compile _ LOD_FADE_CROSSFADE
        #pragma shader_feature_local _ _USEDYNAMICCOVERTSTATICMASKF
        #pragma shader_feature_local _ _WETNESS_T_HEAT_F
        
        #if defined(_USEDYNAMICCOVERTSTATICMASKF) && defined(_WETNESS_T_HEAT_F)
            #define KEYWORD_PERMUTATION_0
        #elif defined(_USEDYNAMICCOVERTSTATICMASKF)
            #define KEYWORD_PERMUTATION_1
        #elif defined(_WETNESS_T_HEAT_F)
            #define KEYWORD_PERMUTATION_2
        #else
            #define KEYWORD_PERMUTATION_3
        #endif
        
        
        // Defines
        
        #define _NORMALMAP 1
        #define _NORMAL_DROPOFF_TS 1
        #define ATTRIBUTES_NEED_NORMAL
        #define ATTRIBUTES_NEED_TANGENT
        #define ATTRIBUTES_NEED_TEXCOORD0
        #define ATTRIBUTES_NEED_TEXCOORD3
        #define ATTRIBUTES_NEED_COLOR
        #define VARYINGS_NEED_POSITION_WS
        #define VARYINGS_NEED_NORMAL_WS
        #define VARYINGS_NEED_TANGENT_WS
        #define VARYINGS_NEED_TEXCOORD0
        #define VARYINGS_NEED_TEXCOORD3
        #define VARYINGS_NEED_COLOR
        #define FEATURES_GRAPH_VERTEX
        /* WARNING: $splice Could not find named fragment 'PassInstancing' */
        #define SHADERPASS SHADERPASS_MOTION_VECTORS
        #define USE_UNITY_CROSSFADE 1
        
        
        // custom interpolator pre-include
        /* WARNING: $splice Could not find named fragment 'sgci_CustomInterpolatorPreInclude' */
        
        // Includes
        #include_with_pragmas "Packages/com.unity.render-pipelines.universal/ShaderLibrary/DOTS.hlsl"
        #include_with_pragmas "Packages/com.unity.render-pipelines.universal/ShaderLibrary/RenderingLayers.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Texture.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
        #include_with_pragmas "Packages/com.unity.render-pipelines.core/ShaderLibrary/FoveatedRenderingKeywords.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/FoveatedRendering.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Input.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/TextureStack.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/DebugMipmapStreamingMacros.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShaderPass.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/LODCrossFade.hlsl"
        
        // --------------------------------------------------
        // Structs and Packing
        
        // custom interpolators pre packing
        /* WARNING: $splice Could not find named fragment 'CustomInterpolatorPrePacking' */
        
        struct Attributes
        {
             float3 positionOS : POSITION;
             float3 normalOS : NORMAL;
             float4 tangentOS : TANGENT;
             float4 uv0 : TEXCOORD0;
             float4 uv3 : TEXCOORD3;
             float4 color : COLOR;
            #if UNITY_ANY_INSTANCING_ENABLED || defined(ATTRIBUTES_NEED_INSTANCEID)
             uint instanceID : INSTANCEID_SEMANTIC;
            #endif
        };
        struct Varyings
        {
             float4 positionCS : SV_POSITION;
             float3 positionWS;
             float3 normalWS;
             float4 tangentWS;
             float4 texCoord0;
             float4 texCoord3;
             float4 color;
            #if UNITY_ANY_INSTANCING_ENABLED || defined(VARYINGS_NEED_INSTANCEID)
             uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
             uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
             uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
             FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
        };
        struct SurfaceDescriptionInputs
        {
             float3 WorldSpaceNormal;
             float3 WorldSpaceTangent;
             float3 WorldSpaceBiTangent;
             float3 AbsoluteWorldSpacePosition;
             float4 uv0;
             float4 uv3;
             float4 VertexColor;
        };
        struct VertexDescriptionInputs
        {
             float3 ObjectSpacePosition;
        };
        struct PackedVaryings
        {
             float4 positionCS : SV_POSITION;
             float4 tangentWS : INTERP0;
             float4 texCoord0 : INTERP1;
             float4 texCoord3 : INTERP2;
             float4 color : INTERP3;
             float3 positionWS : INTERP4;
             float3 normalWS : INTERP5;
            #if UNITY_ANY_INSTANCING_ENABLED || defined(VARYINGS_NEED_INSTANCEID)
             uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
             uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
             uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
             FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
        };
        
        PackedVaryings PackVaryings (Varyings input)
        {
            PackedVaryings output;
            ZERO_INITIALIZE(PackedVaryings, output);
            output.positionCS = input.positionCS;
            output.tangentWS.xyzw = input.tangentWS;
            output.texCoord0.xyzw = input.texCoord0;
            output.texCoord3.xyzw = input.texCoord3;
            output.color.xyzw = input.color;
            output.positionWS.xyz = input.positionWS;
            output.normalWS.xyz = input.normalWS;
            #if UNITY_ANY_INSTANCING_ENABLED || defined(VARYINGS_NEED_INSTANCEID)
            output.instanceID = input.instanceID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            output.cullFace = input.cullFace;
            #endif
            return output;
        }
        
        Varyings UnpackVaryings (PackedVaryings input)
        {
            Varyings output;
            output.positionCS = input.positionCS;
            output.tangentWS = input.tangentWS.xyzw;
            output.texCoord0 = input.texCoord0.xyzw;
            output.texCoord3 = input.texCoord3.xyzw;
            output.color = input.color.xyzw;
            output.positionWS = input.positionWS.xyz;
            output.normalWS = input.normalWS.xyz;
            #if UNITY_ANY_INSTANCING_ENABLED || defined(VARYINGS_NEED_INSTANCEID)
            output.instanceID = input.instanceID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            output.cullFace = input.cullFace;
            #endif
            return output;
        }
        
        
        // --------------------------------------------------
        // Graph
        
        // Graph Properties
        CBUFFER_START(UnityPerMaterial)
        float _EmissionNoiseMultiply;
        float _EmissionNoisePower;
        float Emission_Noise_UV0_UV3;
        float _EmissionNoiseUsePlanarUV;
        float _BaseEmissionMaskTreshold;
        float _CoverEmissionMaskIntensivity;
        float _CoverEmissionMaskTreshold;
        float4 _RimColor;
        float _RimLightPower;
        float4 _Noise_TexelSize;
        float2 _NoiseSpeed;
        float _BaseEmissionMaskIntensivity;
        float4 _LavaEmissionColor;
        float4 _Emission_Noise_Tiling_and_Offset;
        float _Cover_Mask_A_Remap_Min;
        float _Cover_Mask_A_Remap_Max;
        float _HeightMin;
        float _HeightMax;
        float _HeightOffset;
        float _VertexColorBBlendStrenght;
        float _USECoverHeightT;
        float _AlphaCutoff;
        float4 _WetColor;
        float4 _BaseColor;
        float _USEBaseHeightT;
        float4 _BaseColorMap_TexelSize;
        float _BaseUsePlanarUV;
        float4 _BaseTilingOffset;
        float4 _BaseNormalMap_TexelSize;
        float _BaseNormalScale;
        float4 _BaseMaskMap_TexelSize;
        float _BaseMetallic;
        float _VertexColorGBlendStrenght;
        float _BaseAORemapMin;
        float _BaseAORemapMax;
        float _BaseSmoothnessRemapMin;
        float _BaseSmoothnessRemapMax;
        float4 _Masks_TexelSize;
        float _Cover_Amount;
        float _Cover_Amount_Grow_Speed;
        float _Cover_Max_Angle;
        float _Cover_Min_Height;
        float _Cover_Min_Height_Blending;
        float4 _CoverBaseColor;
        float4 _CoverBaseColorMap_TexelSize;
        float _CoverUsePlanarUV;
        float4 _CoverTilingOffset;
        float4 _CoverNormalMap_TexelSize;
        float _CoverNormalScale;
        float _CoverNormalBlendHardness;
        float _CoverHardness;
        float _CoverHeightMapMin;
        float _CoverHeightMapMax;
        float _CoverHeightMapOffset;
        float4 _CoverMaskMap_TexelSize;
        float _CoverMetallic;
        float _CoverAORemapMin;
        float _CoverAORemapMax;
        float _CoverSmoothnessRemapMin;
        float _CoverSmoothnessRemapMax;
        float4 _DetailMap_TexelSize;
        float4 _DetailTilingOffset;
        float _DetailAlbedoScale;
        float _DetailNormalScale;
        float _DetailSmoothnessScale;
        float _WetSmoothness;
        UNITY_TEXTURE_STREAMING_DEBUG_VARS;
        CBUFFER_END
        
        
        // Object and Global properties
        SAMPLER(SamplerState_Linear_Repeat);
        SAMPLER(SamplerState_Linear_Repeat_Aniso8);
        TEXTURE2D(_Noise);
        SAMPLER(sampler_Noise);
        TEXTURE2D(_BaseColorMap);
        SAMPLER(sampler_BaseColorMap);
        TEXTURE2D(_BaseNormalMap);
        SAMPLER(sampler_BaseNormalMap);
        TEXTURE2D(_BaseMaskMap);
        SAMPLER(sampler_BaseMaskMap);
        TEXTURE2D(_Masks);
        SAMPLER(sampler_Masks);
        TEXTURE2D(_CoverBaseColorMap);
        SAMPLER(sampler_CoverBaseColorMap);
        TEXTURE2D(_CoverNormalMap);
        SAMPLER(sampler_CoverNormalMap);
        TEXTURE2D(_CoverMaskMap);
        SAMPLER(sampler_CoverMaskMap);
        TEXTURE2D(_DetailMap);
        SAMPLER(sampler_DetailMap);
        
        // Graph Includes
        // GraphIncludes: <None>
        
        // -- Property used by ScenePickingPass
        #ifdef SCENEPICKINGPASS
        float4 _SelectionID;
        #endif
        
        // -- Properties used by SceneSelectionPass
        #ifdef SCENESELECTIONPASS
        int _ObjectId;
        int _PassValue;
        #endif
        
        // Graph Functions
        
        void Unity_Combine_float(float R, float G, float B, float A, out float4 RGBA, out float3 RGB, out float2 RG)
        {
            RGBA = float4(R, G, B, A);
            RGB = float3(R, G, B);
            RG = float2(R, G);
        }
        
        void Unity_Divide_float(float A, float B, out float Out)
        {
            Out = A / B;
        }
        
        void Unity_Multiply_float4_float4(float4 A, float4 B, out float4 Out)
        {
        Out = A * B;
        }
        
        void Unity_Branch_float4(float Predicate, float4 True, float4 False, out float4 Out)
        {
            Out = Predicate ? True : False;
        }
        
        void Unity_TilingAndOffset_float(float2 UV, float2 Tiling, float2 Offset, out float2 Out)
        {
            Out = UV * Tiling + Offset;
        }
        
        void Unity_Branch_float2(float Predicate, float2 True, float2 False, out float2 Out)
        {
            Out = Predicate ? True : False;
        }
        
        struct Bindings_PlanarNM_c0f081da9c567704ea36e7dd38cedcf6_float
        {
        float3 AbsoluteWorldSpacePosition;
        half4 uv0;
        half4 uv3;
        };
        
        void SG_PlanarNM_c0f081da9c567704ea36e7dd38cedcf6_float(UnityTexture2D Texture2D_80A3D28F, float4 Vector4_2EBA7A3B, float Boolean_7ABB9909, UnitySamplerState _SamplerState, float Boolean_5ddfe6daabcc4715a44b5f34fc19becb, Bindings_PlanarNM_c0f081da9c567704ea36e7dd38cedcf6_float IN, out float4 XZ_2)
        {
        UnityTexture2D _Property_3e01b4d2fc68d48ba3acbba9d5881e59_Out_0_Texture2D = Texture2D_80A3D28F;
        float _Property_30834f691775a0898a45b1c868520436_Out_0_Boolean = Boolean_7ABB9909;
        float _Split_89ed63cb625cb3878c183d0b71c03400_R_1_Float = IN.AbsoluteWorldSpacePosition[0];
        float _Split_89ed63cb625cb3878c183d0b71c03400_G_2_Float = IN.AbsoluteWorldSpacePosition[1];
        float _Split_89ed63cb625cb3878c183d0b71c03400_B_3_Float = IN.AbsoluteWorldSpacePosition[2];
        float _Split_89ed63cb625cb3878c183d0b71c03400_A_4_Float = 0;
        float4 _Combine_cf2d04ff119ad88493f6460431765cbb_RGBA_4_Vector4;
        float3 _Combine_cf2d04ff119ad88493f6460431765cbb_RGB_5_Vector3;
        float2 _Combine_cf2d04ff119ad88493f6460431765cbb_RG_6_Vector2;
        Unity_Combine_float(_Split_89ed63cb625cb3878c183d0b71c03400_R_1_Float, _Split_89ed63cb625cb3878c183d0b71c03400_B_3_Float, float(0), float(0), _Combine_cf2d04ff119ad88493f6460431765cbb_RGBA_4_Vector4, _Combine_cf2d04ff119ad88493f6460431765cbb_RGB_5_Vector3, _Combine_cf2d04ff119ad88493f6460431765cbb_RG_6_Vector2);
        float4 _Property_8a66888ec47d0687ab1cb2f8abdc9da8_Out_0_Vector4 = Vector4_2EBA7A3B;
        float _Split_2f0f52f6ef8c0e81af0da6476402bc1f_R_1_Float = _Property_8a66888ec47d0687ab1cb2f8abdc9da8_Out_0_Vector4[0];
        float _Split_2f0f52f6ef8c0e81af0da6476402bc1f_G_2_Float = _Property_8a66888ec47d0687ab1cb2f8abdc9da8_Out_0_Vector4[1];
        float _Split_2f0f52f6ef8c0e81af0da6476402bc1f_B_3_Float = _Property_8a66888ec47d0687ab1cb2f8abdc9da8_Out_0_Vector4[2];
        float _Split_2f0f52f6ef8c0e81af0da6476402bc1f_A_4_Float = _Property_8a66888ec47d0687ab1cb2f8abdc9da8_Out_0_Vector4[3];
        float _Divide_e64179199923c58289b6aa94ea6c9178_Out_2_Float;
        Unity_Divide_float(float(1), _Split_2f0f52f6ef8c0e81af0da6476402bc1f_R_1_Float, _Divide_e64179199923c58289b6aa94ea6c9178_Out_2_Float);
        float4 _Multiply_14cec4902d0a00829e4555071a1b8ad1_Out_2_Vector4;
        Unity_Multiply_float4_float4(_Combine_cf2d04ff119ad88493f6460431765cbb_RGBA_4_Vector4, (_Divide_e64179199923c58289b6aa94ea6c9178_Out_2_Float.xxxx), _Multiply_14cec4902d0a00829e4555071a1b8ad1_Out_2_Vector4);
        float _Property_f17c7bf877e64b6abdd66b1fe9f5accc_Out_0_Boolean = Boolean_5ddfe6daabcc4715a44b5f34fc19becb;
        float4 _UV_029e8e8198564838b9389b902a09fb22_Out_0_Vector4 = IN.uv0;
        float4 _UV_7a6209af1506424fb75c81e87e42035a_Out_0_Vector4 = IN.uv3;
        float4 _Branch_fc37bb4bf641457cbbc6e290603056ff_Out_3_Vector4;
        Unity_Branch_float4(_Property_f17c7bf877e64b6abdd66b1fe9f5accc_Out_0_Boolean, _UV_029e8e8198564838b9389b902a09fb22_Out_0_Vector4, _UV_7a6209af1506424fb75c81e87e42035a_Out_0_Vector4, _Branch_fc37bb4bf641457cbbc6e290603056ff_Out_3_Vector4);
        float2 _Vector2_16c15d3bbdd14b85bd48e3a6cb318af7_Out_0_Vector2 = float2(_Split_2f0f52f6ef8c0e81af0da6476402bc1f_R_1_Float, _Split_2f0f52f6ef8c0e81af0da6476402bc1f_G_2_Float);
        float2 _Vector2_f8d75f54e7705083bbec539a60185577_Out_0_Vector2 = float2(_Split_2f0f52f6ef8c0e81af0da6476402bc1f_B_3_Float, _Split_2f0f52f6ef8c0e81af0da6476402bc1f_A_4_Float);
        float2 _TilingAndOffset_d91e2d25acd34686b562b7fe7e9d1d27_Out_3_Vector2;
        Unity_TilingAndOffset_float((_Branch_fc37bb4bf641457cbbc6e290603056ff_Out_3_Vector4.xy), _Vector2_16c15d3bbdd14b85bd48e3a6cb318af7_Out_0_Vector2, _Vector2_f8d75f54e7705083bbec539a60185577_Out_0_Vector2, _TilingAndOffset_d91e2d25acd34686b562b7fe7e9d1d27_Out_3_Vector2);
        float2 _Branch_8e5a4e8f4d52fc8aadd1f46485afc933_Out_3_Vector2;
        Unity_Branch_float2(_Property_30834f691775a0898a45b1c868520436_Out_0_Boolean, (_Multiply_14cec4902d0a00829e4555071a1b8ad1_Out_2_Vector4.xy), _TilingAndOffset_d91e2d25acd34686b562b7fe7e9d1d27_Out_3_Vector2, _Branch_8e5a4e8f4d52fc8aadd1f46485afc933_Out_3_Vector2);
        UnitySamplerState _Property_e8746b9475c94530ba35ba8019ad2ae0_Out_0_SamplerState = _SamplerState;
        float4 _SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_RGBA_0_Vector4 = SAMPLE_TEXTURE2D(_Property_3e01b4d2fc68d48ba3acbba9d5881e59_Out_0_Texture2D.tex, _Property_e8746b9475c94530ba35ba8019ad2ae0_Out_0_SamplerState.samplerstate, _Property_3e01b4d2fc68d48ba3acbba9d5881e59_Out_0_Texture2D.GetTransformedUV(_Branch_8e5a4e8f4d52fc8aadd1f46485afc933_Out_3_Vector2) );
        float _SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_R_4_Float = _SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_RGBA_0_Vector4.r;
        float _SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_G_5_Float = _SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_RGBA_0_Vector4.g;
        float _SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_B_6_Float = _SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_RGBA_0_Vector4.b;
        float _SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_A_7_Float = _SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_RGBA_0_Vector4.a;
        XZ_2 = _SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_RGBA_0_Vector4;
        }
        
        void Unity_ColorspaceConversion_Linear_RGB_float(float3 In, out float3 Out)
        {
            float3 sRGBLo = In * 12.92;
            float3 sRGBHi = (pow(max(abs(In), 1.192092896e-07), float3(1.0 / 2.4, 1.0 / 2.4, 1.0 / 2.4)) * 1.055) - 0.055;
            Out = float3(In <= 0.0031308) ? sRGBLo : sRGBHi;
        }
        
        void Unity_Blend_Overlay_float3(float3 Base, float3 Blend, out float3 Out, float Opacity)
        {
            float3 result1 = 1.0 - 2.0 * (1.0 - Base) * (1.0 - Blend);
            float3 result2 = 2.0 * Base * Blend;
            float3 zeroOrOne = step(Base, 0.5);
            Out = result2 * zeroOrOne + (1 - zeroOrOne) * result1;
            Out = lerp(Base, Out, Opacity);
        }
        
        void Unity_ColorspaceConversion_RGB_Linear_float(float3 In, out float3 Out)
        {
            float3 linearRGBLo = In / 12.92;
            float3 linearRGBHi = pow(max(abs((In + 0.055) / 1.055), 1.192092896e-07), float3(2.4, 2.4, 2.4));
            Out = float3(In <= 0.04045) ? linearRGBLo : linearRGBHi;
        }
        
        void Unity_Clamp_float3(float3 In, float3 Min, float3 Max, out float3 Out)
        {
            Out = clamp(In, Min, Max);
        }
        
        void Unity_Add_float2(float2 A, float2 B, out float2 Out)
        {
            Out = A + B;
        }
        
        void Unity_Remap_float(float In, float2 InMinMax, float2 OutMinMax, out float Out)
        {
            Out = OutMinMax.x + (In - InMinMax.x) * (OutMinMax.y - OutMinMax.x) / (InMinMax.y - InMinMax.x);
        }
        
        void Unity_Clamp_float(float In, float Min, float Max, out float Out)
        {
            Out = clamp(In, Min, Max);
        }
        
        void Unity_Multiply_float2_float2(float2 A, float2 B, out float2 Out)
        {
            Out = A * B;
        }
        
        void Unity_DotProduct_float2(float2 A, float2 B, out float Out)
        {
            Out = dot(A, B);
        }
        
        void Unity_Saturate_float(float In, out float Out)
        {
            Out = saturate(In);
        }
        
        void Unity_OneMinus_float(float In, out float Out)
        {
            Out = 1 - In;
        }
        
        void Unity_SquareRoot_float(float In, out float Out)
        {
            Out = sqrt(In);
        }
        
        void Unity_Sign_float3(float3 In, out float3 Out)
        {
            Out = sign(In);
        }
        
        void Unity_Multiply_float_float(float A, float B, out float Out)
        {
        Out = A * B;
        }
        
        void Unity_Normalize_float3(float3 In, out float3 Out)
        {
            Out = normalize(In);
        }
        
        void Unity_Branch_float3(float Predicate, float3 True, float3 False, out float3 Out)
        {
            Out = Predicate ? True : False;
        }
        
        struct Bindings_PlanarNMn_1b93a87456f9d4c419321d0cd92bd6c8_float
        {
        float3 WorldSpaceNormal;
        float3 WorldSpaceTangent;
        float3 WorldSpaceBiTangent;
        float3 AbsoluteWorldSpacePosition;
        half4 uv0;
        half4 uv3;
        };
        
        void SG_PlanarNMn_1b93a87456f9d4c419321d0cd92bd6c8_float(UnityTexture2D Texture2D_80A3D28F, float4 Vector4_82674548, float Boolean_9FF42DF6, UnitySamplerState _SamplerState, float Boolean_5ddfe6daabcc4715a44b5f34fc19becb, Bindings_PlanarNMn_1b93a87456f9d4c419321d0cd92bd6c8_float IN, out float4 XZ_2)
        {
        float _Property_1ef12cf3201a938993fe6a7951b0e754_Out_0_Boolean = Boolean_9FF42DF6;
        UnityTexture2D _Property_3e01b4d2fc68d48ba3acbba9d5881e59_Out_0_Texture2D = Texture2D_80A3D28F;
        float _Split_89ed63cb625cb3878c183d0b71c03400_R_1_Float = IN.AbsoluteWorldSpacePosition[0];
        float _Split_89ed63cb625cb3878c183d0b71c03400_G_2_Float = IN.AbsoluteWorldSpacePosition[1];
        float _Split_89ed63cb625cb3878c183d0b71c03400_B_3_Float = IN.AbsoluteWorldSpacePosition[2];
        float _Split_89ed63cb625cb3878c183d0b71c03400_A_4_Float = 0;
        float4 _Combine_cf2d04ff119ad88493f6460431765cbb_RGBA_4_Vector4;
        float3 _Combine_cf2d04ff119ad88493f6460431765cbb_RGB_5_Vector3;
        float2 _Combine_cf2d04ff119ad88493f6460431765cbb_RG_6_Vector2;
        Unity_Combine_float(_Split_89ed63cb625cb3878c183d0b71c03400_R_1_Float, _Split_89ed63cb625cb3878c183d0b71c03400_B_3_Float, float(0), float(0), _Combine_cf2d04ff119ad88493f6460431765cbb_RGBA_4_Vector4, _Combine_cf2d04ff119ad88493f6460431765cbb_RGB_5_Vector3, _Combine_cf2d04ff119ad88493f6460431765cbb_RG_6_Vector2);
        float4 _Property_3fa1d6f912feb481ba60f2e55e62e746_Out_0_Vector4 = Vector4_82674548;
        float _Split_a2e12fa5931da084b2949343a539dfd8_R_1_Float = _Property_3fa1d6f912feb481ba60f2e55e62e746_Out_0_Vector4[0];
        float _Split_a2e12fa5931da084b2949343a539dfd8_G_2_Float = _Property_3fa1d6f912feb481ba60f2e55e62e746_Out_0_Vector4[1];
        float _Split_a2e12fa5931da084b2949343a539dfd8_B_3_Float = _Property_3fa1d6f912feb481ba60f2e55e62e746_Out_0_Vector4[2];
        float _Split_a2e12fa5931da084b2949343a539dfd8_A_4_Float = _Property_3fa1d6f912feb481ba60f2e55e62e746_Out_0_Vector4[3];
        float _Divide_c36b770dfaa0bb8f85ab27da5fd794f0_Out_2_Float;
        Unity_Divide_float(float(1), _Split_a2e12fa5931da084b2949343a539dfd8_R_1_Float, _Divide_c36b770dfaa0bb8f85ab27da5fd794f0_Out_2_Float);
        float4 _Multiply_14cec4902d0a00829e4555071a1b8ad1_Out_2_Vector4;
        Unity_Multiply_float4_float4(_Combine_cf2d04ff119ad88493f6460431765cbb_RGBA_4_Vector4, (_Divide_c36b770dfaa0bb8f85ab27da5fd794f0_Out_2_Float.xxxx), _Multiply_14cec4902d0a00829e4555071a1b8ad1_Out_2_Vector4);
        float _Property_058f4fba88c3437288219f1929444bf2_Out_0_Boolean = Boolean_5ddfe6daabcc4715a44b5f34fc19becb;
        float4 _UV_43d85b3291324c848dfbeec6adac2a71_Out_0_Vector4 = IN.uv0;
        float4 _UV_36881dcaab9040168fc5215dcd00f352_Out_0_Vector4 = IN.uv3;
        float4 _Branch_8054d58a73be4ce1b22d48a84389ae07_Out_3_Vector4;
        Unity_Branch_float4(_Property_058f4fba88c3437288219f1929444bf2_Out_0_Boolean, _UV_43d85b3291324c848dfbeec6adac2a71_Out_0_Vector4, _UV_36881dcaab9040168fc5215dcd00f352_Out_0_Vector4, _Branch_8054d58a73be4ce1b22d48a84389ae07_Out_3_Vector4);
        float2 _Vector2_6845d21872714d889783b0cb707df3e9_Out_0_Vector2 = float2(_Split_a2e12fa5931da084b2949343a539dfd8_R_1_Float, _Split_a2e12fa5931da084b2949343a539dfd8_G_2_Float);
        float2 _Vector2_e2e2263627c6098e96a5b5d29350ad03_Out_0_Vector2 = float2(_Split_a2e12fa5931da084b2949343a539dfd8_B_3_Float, _Split_a2e12fa5931da084b2949343a539dfd8_A_4_Float);
        float2 _TilingAndOffset_17582d056c0b8a8dab1017d37497fe59_Out_3_Vector2;
        Unity_TilingAndOffset_float((_Branch_8054d58a73be4ce1b22d48a84389ae07_Out_3_Vector4.xy), _Vector2_6845d21872714d889783b0cb707df3e9_Out_0_Vector2, _Vector2_e2e2263627c6098e96a5b5d29350ad03_Out_0_Vector2, _TilingAndOffset_17582d056c0b8a8dab1017d37497fe59_Out_3_Vector2);
        float2 _Branch_1e152f3aac57448f8518bf2852c000c3_Out_3_Vector2;
        Unity_Branch_float2(_Property_1ef12cf3201a938993fe6a7951b0e754_Out_0_Boolean, (_Multiply_14cec4902d0a00829e4555071a1b8ad1_Out_2_Vector4.xy), _TilingAndOffset_17582d056c0b8a8dab1017d37497fe59_Out_3_Vector2, _Branch_1e152f3aac57448f8518bf2852c000c3_Out_3_Vector2);
        UnitySamplerState _Property_69f1ed7efd1b494e91f626b88ab2363c_Out_0_SamplerState = _SamplerState;
        float4 _SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_RGBA_0_Vector4 = SAMPLE_TEXTURE2D(_Property_3e01b4d2fc68d48ba3acbba9d5881e59_Out_0_Texture2D.tex, _Property_69f1ed7efd1b494e91f626b88ab2363c_Out_0_SamplerState.samplerstate, _Property_3e01b4d2fc68d48ba3acbba9d5881e59_Out_0_Texture2D.GetTransformedUV(_Branch_1e152f3aac57448f8518bf2852c000c3_Out_3_Vector2) );
        _SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_RGBA_0_Vector4.rgb = UnpackNormal(_SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_RGBA_0_Vector4);
        float _SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_R_4_Float = _SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_RGBA_0_Vector4.r;
        float _SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_G_5_Float = _SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_RGBA_0_Vector4.g;
        float _SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_B_6_Float = _SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_RGBA_0_Vector4.b;
        float _SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_A_7_Float = _SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_RGBA_0_Vector4.a;
        float2 _Vector2_ad6bd100e273d78fa409a30a77bfa2cc_Out_0_Vector2 = float2(_SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_R_4_Float, _SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_G_5_Float);
        float3 _Sign_3a6ebf59931cf08cb0482e0144ddac24_Out_1_Vector3;
        Unity_Sign_float3(IN.WorldSpaceNormal, _Sign_3a6ebf59931cf08cb0482e0144ddac24_Out_1_Vector3);
        float _Split_6299d4ddcc4c74828aea40a46fdb896e_R_1_Float = _Sign_3a6ebf59931cf08cb0482e0144ddac24_Out_1_Vector3[0];
        float _Split_6299d4ddcc4c74828aea40a46fdb896e_G_2_Float = _Sign_3a6ebf59931cf08cb0482e0144ddac24_Out_1_Vector3[1];
        float _Split_6299d4ddcc4c74828aea40a46fdb896e_B_3_Float = _Sign_3a6ebf59931cf08cb0482e0144ddac24_Out_1_Vector3[2];
        float _Split_6299d4ddcc4c74828aea40a46fdb896e_A_4_Float = 0;
        float2 _Vector2_b76cb1842101e58b9e636d49b075c612_Out_0_Vector2 = float2(_Split_6299d4ddcc4c74828aea40a46fdb896e_G_2_Float, float(1));
        float2 _Multiply_31e8db88ee20c985a9850d1a58f3282b_Out_2_Vector2;
        Unity_Multiply_float2_float2(_Vector2_ad6bd100e273d78fa409a30a77bfa2cc_Out_0_Vector2, _Vector2_b76cb1842101e58b9e636d49b075c612_Out_0_Vector2, _Multiply_31e8db88ee20c985a9850d1a58f3282b_Out_2_Vector2);
        float _Split_5ed44bf2eca0868f81eb18100f49d1fa_R_1_Float = IN.WorldSpaceNormal[0];
        float _Split_5ed44bf2eca0868f81eb18100f49d1fa_G_2_Float = IN.WorldSpaceNormal[1];
        float _Split_5ed44bf2eca0868f81eb18100f49d1fa_B_3_Float = IN.WorldSpaceNormal[2];
        float _Split_5ed44bf2eca0868f81eb18100f49d1fa_A_4_Float = 0;
        float2 _Vector2_70e5837843f28b8b9d64cada3697bd5a_Out_0_Vector2 = float2(_Split_5ed44bf2eca0868f81eb18100f49d1fa_R_1_Float, _Split_5ed44bf2eca0868f81eb18100f49d1fa_B_3_Float);
        float2 _Add_1145b2f896593d80aa864a34e6702562_Out_2_Vector2;
        Unity_Add_float2(_Multiply_31e8db88ee20c985a9850d1a58f3282b_Out_2_Vector2, _Vector2_70e5837843f28b8b9d64cada3697bd5a_Out_0_Vector2, _Add_1145b2f896593d80aa864a34e6702562_Out_2_Vector2);
        float _Split_2bc77ca2d17bd78cb2383770ce50b179_R_1_Float = _Add_1145b2f896593d80aa864a34e6702562_Out_2_Vector2[0];
        float _Split_2bc77ca2d17bd78cb2383770ce50b179_G_2_Float = _Add_1145b2f896593d80aa864a34e6702562_Out_2_Vector2[1];
        float _Split_2bc77ca2d17bd78cb2383770ce50b179_B_3_Float = 0;
        float _Split_2bc77ca2d17bd78cb2383770ce50b179_A_4_Float = 0;
        float _Multiply_ab12aea87465a78eaf7fc66c2598d266_Out_2_Float;
        Unity_Multiply_float_float(_SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_B_6_Float, _Split_5ed44bf2eca0868f81eb18100f49d1fa_G_2_Float, _Multiply_ab12aea87465a78eaf7fc66c2598d266_Out_2_Float);
        float3 _Vector3_433840b555db308b97e9b14b6a957195_Out_0_Vector3 = float3(_Split_2bc77ca2d17bd78cb2383770ce50b179_R_1_Float, _Multiply_ab12aea87465a78eaf7fc66c2598d266_Out_2_Float, _Split_2bc77ca2d17bd78cb2383770ce50b179_G_2_Float);
        float3 _Transform_c7914cc45a011c89b3f53c55afb51673_Out_1_Vector3;
        {
        float3x3 tangentTransform = float3x3(IN.WorldSpaceTangent, IN.WorldSpaceBiTangent, IN.WorldSpaceNormal);
        _Transform_c7914cc45a011c89b3f53c55afb51673_Out_1_Vector3 = TransformWorldToTangentDir(_Vector3_433840b555db308b97e9b14b6a957195_Out_0_Vector3.xyz, tangentTransform, true);
        }
        float3 _Clamp_3837949a36b5428a82af01e7bcd29952_Out_3_Vector3;
        Unity_Clamp_float3(_Transform_c7914cc45a011c89b3f53c55afb51673_Out_1_Vector3, float3(-1, -1, -1), float3(1, 1, 1), _Clamp_3837949a36b5428a82af01e7bcd29952_Out_3_Vector3);
        float3 _Normalize_09bf8a2bd0a4d38e8b97d5c674f79b44_Out_1_Vector3;
        Unity_Normalize_float3(_Clamp_3837949a36b5428a82af01e7bcd29952_Out_3_Vector3, _Normalize_09bf8a2bd0a4d38e8b97d5c674f79b44_Out_1_Vector3);
        float3 _Branch_9eadf909a90f2f80880f8c56ecc2a91f_Out_3_Vector3;
        Unity_Branch_float3(_Property_1ef12cf3201a938993fe6a7951b0e754_Out_0_Boolean, _Normalize_09bf8a2bd0a4d38e8b97d5c674f79b44_Out_1_Vector3, (_SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_RGBA_0_Vector4.xyz), _Branch_9eadf909a90f2f80880f8c56ecc2a91f_Out_3_Vector3);
        XZ_2 = (float4(_Branch_9eadf909a90f2f80880f8c56ecc2a91f_Out_3_Vector3, 1.0));
        }
        
        void Unity_NormalStrength_float(float3 In, float Strength, out float3 Out)
        {
            Out = float3(In.rg * Strength, lerp(1, In.b, saturate(Strength)));
        }
        
        void Unity_NormalBlend_Reoriented_float(float3 A, float3 B, out float3 Out)
        {
            float3 t = A.xyz + float3(0.0, 0.0, 1.0);
            float3 u = B.xyz * float3(-1.0, -1.0, 1.0);
            Out = (t / t.z) * dot(t, u) - u;
        }
        
        void Unity_Subtract_float(float A, float B, out float Out)
        {
            Out = A - B;
        }
        
        void Unity_Absolute_float(float In, out float Out)
        {
            Out = abs(In);
        }
        
        void Unity_Power_float(float A, float B, out float Out)
        {
            Out = pow(A, B);
        }
        
        void Unity_Add_float(float A, float B, out float Out)
        {
            Out = A + B;
        }
        
        void Unity_Lerp_float3(float3 A, float3 B, float3 T, out float3 Out)
        {
            Out = lerp(A, B, T);
        }
        
        void Unity_Comparison_Greater_float(float A, float B, out float Out)
        {
            Out = A > B ? 1 : 0;
        }
        
        void Unity_Branch_float(float Predicate, float True, float False, out float Out)
        {
            Out = Predicate ? True : False;
        }
        
        struct Bindings_UniversalHeighblend_3b5c31b864970d04197cd420b6c4b0fa_float
        {
        };
        
        void SG_UniversalHeighblend_3b5c31b864970d04197cd420b6c4b0fa_float(float _Vertex_Color, float _Blend_Hardness, float _Use_Layer_1_Height_T, float _Layer_1_Height, float2 _Layer_1_Before_Remap, float _Use_Layer_2_Height_T, float _Layer_2_Height, float2 _Layer_2_Before_Remap, float _Angle_Blend, Bindings_UniversalHeighblend_3b5c31b864970d04197cd420b6c4b0fa_float IN, out float Heightmap_1)
        {
        float _Property_b3ca7054ef0043de85912fc45d997ea2_Out_0_Float = _Vertex_Color;
        float _Clamp_852774a2be524975babf4eeb54af6d64_Out_3_Float;
        Unity_Clamp_float(_Property_b3ca7054ef0043de85912fc45d997ea2_Out_0_Float, float(0), float(1), _Clamp_852774a2be524975babf4eeb54af6d64_Out_3_Float);
        float _OneMinus_85e3550f37814cd3ab5ea5dde7f63a73_Out_1_Float;
        Unity_OneMinus_float(_Clamp_852774a2be524975babf4eeb54af6d64_Out_3_Float, _OneMinus_85e3550f37814cd3ab5ea5dde7f63a73_Out_1_Float);
        float _Comparison_5be6aeaa514b4921b5eb68269b58b028_Out_2_Boolean;
        Unity_Comparison_Greater_float(_OneMinus_85e3550f37814cd3ab5ea5dde7f63a73_Out_1_Float, float(0.99), _Comparison_5be6aeaa514b4921b5eb68269b58b028_Out_2_Boolean);
        float _Property_cfe724908035497c918d6d3f8dafe439_Out_0_Boolean = _Use_Layer_1_Height_T;
        float _Property_9634fd87d3374fdaa60181281a01f9b5_Out_0_Float = _Layer_1_Height;
        float2 _Property_e748f6c127e0479a9a01040378a4129b_Out_0_Vector2 = _Layer_1_Before_Remap;
        float _Split_cde172ab161d44cb81ea7874aec65560_R_1_Float = _Property_e748f6c127e0479a9a01040378a4129b_Out_0_Vector2[0];
        float _Split_cde172ab161d44cb81ea7874aec65560_G_2_Float = _Property_e748f6c127e0479a9a01040378a4129b_Out_0_Vector2[1];
        float _Split_cde172ab161d44cb81ea7874aec65560_B_3_Float = 0;
        float _Split_cde172ab161d44cb81ea7874aec65560_A_4_Float = 0;
        float _Subtract_e1e98a956721410caddfb467ae0eca8b_Out_2_Float;
        Unity_Subtract_float(_Split_cde172ab161d44cb81ea7874aec65560_R_1_Float, _Split_cde172ab161d44cb81ea7874aec65560_G_2_Float, _Subtract_e1e98a956721410caddfb467ae0eca8b_Out_2_Float);
        float _Clamp_ac4097026e6248dbb7a95fe910cc776e_Out_3_Float;
        Unity_Clamp_float(_OneMinus_85e3550f37814cd3ab5ea5dde7f63a73_Out_1_Float, float(0), float(1), _Clamp_ac4097026e6248dbb7a95fe910cc776e_Out_3_Float);
        float _Multiply_41691d316de74fef8a4ab5f63ed5474e_Out_2_Float;
        Unity_Multiply_float_float(_Subtract_e1e98a956721410caddfb467ae0eca8b_Out_2_Float, _Clamp_ac4097026e6248dbb7a95fe910cc776e_Out_3_Float, _Multiply_41691d316de74fef8a4ab5f63ed5474e_Out_2_Float);
        float2 _Add_48d37f8b8a464788860db14f0da8a66e_Out_2_Vector2;
        Unity_Add_float2(_Property_e748f6c127e0479a9a01040378a4129b_Out_0_Vector2, (_Multiply_41691d316de74fef8a4ab5f63ed5474e_Out_2_Float.xx), _Add_48d37f8b8a464788860db14f0da8a66e_Out_2_Vector2);
        float _Remap_21f3372608424df090026adc73778a39_Out_3_Float;
        Unity_Remap_float(_Property_9634fd87d3374fdaa60181281a01f9b5_Out_0_Float, float2 (0, 1), _Add_48d37f8b8a464788860db14f0da8a66e_Out_2_Vector2, _Remap_21f3372608424df090026adc73778a39_Out_3_Float);
        float _Clamp_8ea719b357b44537b42b2d05c22046f6_Out_3_Float;
        Unity_Clamp_float(_Remap_21f3372608424df090026adc73778a39_Out_3_Float, float(0), float(1), _Clamp_8ea719b357b44537b42b2d05c22046f6_Out_3_Float);
        float _Property_457e05a76c034ada998b3ff30a7781c3_Out_0_Boolean = _Use_Layer_2_Height_T;
        float _Property_9dfafa1ca8c94866a52535f412aff89a_Out_0_Float = _Angle_Blend;
        float _Property_b0e4a5720c374e2eb6f203a1bd075243_Out_0_Float = _Layer_2_Height;
        float _Multiply_00b31c7f720343caa4ded6df80a61899_Out_2_Float;
        Unity_Multiply_float_float(_Property_9dfafa1ca8c94866a52535f412aff89a_Out_0_Float, _Property_b0e4a5720c374e2eb6f203a1bd075243_Out_0_Float, _Multiply_00b31c7f720343caa4ded6df80a61899_Out_2_Float);
        float2 _Property_555a7734da754b989d8f80ef0bc86bea_Out_0_Vector2 = _Layer_2_Before_Remap;
        float _Split_bad56a0d03154ccc8cbfb53ea0e381d4_R_1_Float = _Property_555a7734da754b989d8f80ef0bc86bea_Out_0_Vector2[0];
        float _Split_bad56a0d03154ccc8cbfb53ea0e381d4_G_2_Float = _Property_555a7734da754b989d8f80ef0bc86bea_Out_0_Vector2[1];
        float _Split_bad56a0d03154ccc8cbfb53ea0e381d4_B_3_Float = 0;
        float _Split_bad56a0d03154ccc8cbfb53ea0e381d4_A_4_Float = 0;
        float _Subtract_2a7908018c384526a00494520503a83d_Out_2_Float;
        Unity_Subtract_float(_Split_bad56a0d03154ccc8cbfb53ea0e381d4_R_1_Float, _Split_bad56a0d03154ccc8cbfb53ea0e381d4_G_2_Float, _Subtract_2a7908018c384526a00494520503a83d_Out_2_Float);
        float _Multiply_417d72157b5f4930aed43775db746964_Out_2_Float;
        Unity_Multiply_float_float(_Subtract_2a7908018c384526a00494520503a83d_Out_2_Float, _Clamp_ac4097026e6248dbb7a95fe910cc776e_Out_3_Float, _Multiply_417d72157b5f4930aed43775db746964_Out_2_Float);
        float2 _Add_3d7e111e917c44e8a6800ce926fac67d_Out_2_Vector2;
        Unity_Add_float2((_Multiply_417d72157b5f4930aed43775db746964_Out_2_Float.xx), _Property_555a7734da754b989d8f80ef0bc86bea_Out_0_Vector2, _Add_3d7e111e917c44e8a6800ce926fac67d_Out_2_Vector2);
        float _Remap_931f83440e6c4c1588456788f84cbd9a_Out_3_Float;
        Unity_Remap_float(_Multiply_00b31c7f720343caa4ded6df80a61899_Out_2_Float, float2 (0, 1), _Add_3d7e111e917c44e8a6800ce926fac67d_Out_2_Vector2, _Remap_931f83440e6c4c1588456788f84cbd9a_Out_3_Float);
        float _Branch_a840aba5bca34588a2665f9794c96c38_Out_3_Float;
        Unity_Branch_float(_Property_457e05a76c034ada998b3ff30a7781c3_Out_0_Boolean, _Remap_931f83440e6c4c1588456788f84cbd9a_Out_3_Float, _Property_9dfafa1ca8c94866a52535f412aff89a_Out_0_Float, _Branch_a840aba5bca34588a2665f9794c96c38_Out_3_Float);
        float _Clamp_b1fe959daf444bf99c57756b8be77768_Out_3_Float;
        Unity_Clamp_float(_Branch_a840aba5bca34588a2665f9794c96c38_Out_3_Float, float(0), float(1), _Clamp_b1fe959daf444bf99c57756b8be77768_Out_3_Float);
        float _Multiply_c045ae9912ac409b9734c687968d47f6_Out_2_Float;
        Unity_Multiply_float_float(_Clamp_8ea719b357b44537b42b2d05c22046f6_Out_3_Float, _Clamp_b1fe959daf444bf99c57756b8be77768_Out_3_Float, _Multiply_c045ae9912ac409b9734c687968d47f6_Out_2_Float);
        float _Branch_5198cfc0a080466e93cf89aea61886e6_Out_3_Float;
        Unity_Branch_float(_Property_cfe724908035497c918d6d3f8dafe439_Out_0_Boolean, _Multiply_c045ae9912ac409b9734c687968d47f6_Out_2_Float, _Clamp_b1fe959daf444bf99c57756b8be77768_Out_3_Float, _Branch_5198cfc0a080466e93cf89aea61886e6_Out_3_Float);
        float _Saturate_ceafe30b0bae4f45a2f2ec500925b553_Out_1_Float;
        Unity_Saturate_float(_Branch_5198cfc0a080466e93cf89aea61886e6_Out_3_Float, _Saturate_ceafe30b0bae4f45a2f2ec500925b553_Out_1_Float);
        float _Absolute_274083e3f9f645bfb86074d91f3b7c62_Out_1_Float;
        Unity_Absolute_float(_Saturate_ceafe30b0bae4f45a2f2ec500925b553_Out_1_Float, _Absolute_274083e3f9f645bfb86074d91f3b7c62_Out_1_Float);
        float _Property_c68e0b8a84a549a582d4723036344b0e_Out_0_Float = _Blend_Hardness;
        float _Power_c9d62a3092174d9cb5674d87bcb7b5c5_Out_2_Float;
        Unity_Power_float(_Absolute_274083e3f9f645bfb86074d91f3b7c62_Out_1_Float, _Property_c68e0b8a84a549a582d4723036344b0e_Out_0_Float, _Power_c9d62a3092174d9cb5674d87bcb7b5c5_Out_2_Float);
        float _Branch_2425ee869bde4930bb8f36a5273bdc33_Out_3_Float;
        Unity_Branch_float(_Comparison_5be6aeaa514b4921b5eb68269b58b028_Out_2_Boolean, float(0), _Power_c9d62a3092174d9cb5674d87bcb7b5c5_Out_2_Float, _Branch_2425ee869bde4930bb8f36a5273bdc33_Out_3_Float);
        float _Clamp_9a5c5cfe52824e248ea0a8e38c593d84_Out_3_Float;
        Unity_Clamp_float(_Branch_2425ee869bde4930bb8f36a5273bdc33_Out_3_Float, float(0), float(1), _Clamp_9a5c5cfe52824e248ea0a8e38c593d84_Out_3_Float);
        Heightmap_1 = _Clamp_9a5c5cfe52824e248ea0a8e38c593d84_Out_3_Float;
        }
        
        void Unity_Lerp_float4(float4 A, float4 B, float4 T, out float4 Out)
        {
            Out = lerp(A, B, T);
        }
        
        void Unity_Clamp_float4(float4 In, float4 Min, float4 Max, out float4 Out)
        {
            Out = clamp(In, Min, Max);
        }
        
        // Custom interpolators pre vertex
        /* WARNING: $splice Could not find named fragment 'CustomInterpolatorPreVertex' */
        
        // Graph Vertex
        struct VertexDescription
        {
            float3 Position;
        };
        
        VertexDescription VertexDescriptionFunction(VertexDescriptionInputs IN)
        {
            VertexDescription description = (VertexDescription)0;
            description.Position = IN.ObjectSpacePosition;
            return description;
        }
        
        // Custom interpolators, pre surface
        #ifdef FEATURES_GRAPH_VERTEX
        Varyings CustomInterpolatorPassThroughFunc(inout Varyings output, VertexDescription input)
        {
        return output;
        }
        #define CUSTOMINTERPOLATOR_VARYPASSTHROUGH_FUNC
        #endif
        
        // Graph Pixel
        struct SurfaceDescription
        {
            float Alpha;
            float AlphaClipThreshold;
        };
        
        SurfaceDescription SurfaceDescriptionFunction(SurfaceDescriptionInputs IN)
        {
            SurfaceDescription surface = (SurfaceDescription)0;
            UnityTexture2D _Property_821e07b38fd0a08d85c4dd6e5b6bbac9_Out_0_Texture2D = UnityBuildTexture2DStructNoScale(_BaseColorMap);
            float4 _Property_8ec0d512145619859d288abab740e3bf_Out_0_Vector4 = _BaseTilingOffset;
            float _Property_122c0f9ef0a1c4818a140c75e512abe4_Out_0_Boolean = _BaseUsePlanarUV;
            Bindings_PlanarNM_c0f081da9c567704ea36e7dd38cedcf6_float _PlanarNM_cb7ded32e6af3382bbe06b62977afab6;
            _PlanarNM_cb7ded32e6af3382bbe06b62977afab6.AbsoluteWorldSpacePosition = IN.AbsoluteWorldSpacePosition;
            _PlanarNM_cb7ded32e6af3382bbe06b62977afab6.uv0 = IN.uv0;
            _PlanarNM_cb7ded32e6af3382bbe06b62977afab6.uv3 = IN.uv3;
            float4 _PlanarNM_cb7ded32e6af3382bbe06b62977afab6_XZ_2_Vector4;
            SG_PlanarNM_c0f081da9c567704ea36e7dd38cedcf6_float(_Property_821e07b38fd0a08d85c4dd6e5b6bbac9_Out_0_Texture2D, _Property_8ec0d512145619859d288abab740e3bf_Out_0_Vector4, _Property_122c0f9ef0a1c4818a140c75e512abe4_Out_0_Boolean, UnityBuildSamplerStateStruct(SamplerState_Linear_Repeat_Aniso8), 1, _PlanarNM_cb7ded32e6af3382bbe06b62977afab6, _PlanarNM_cb7ded32e6af3382bbe06b62977afab6_XZ_2_Vector4);
            float4 _Property_41859d117584758eb8002ecc938f9bce_Out_0_Vector4 = _BaseColor;
            float4 _Multiply_4d0f82599060228a9092027fd43912c8_Out_2_Vector4;
            Unity_Multiply_float4_float4(_PlanarNM_cb7ded32e6af3382bbe06b62977afab6_XZ_2_Vector4, _Property_41859d117584758eb8002ecc938f9bce_Out_0_Vector4, _Multiply_4d0f82599060228a9092027fd43912c8_Out_2_Vector4);
            float3 _ColorspaceConversion_30c5042ef70343cd92056cde73cd3ecb_Out_1_Vector3;
            Unity_ColorspaceConversion_Linear_RGB_float((_Multiply_4d0f82599060228a9092027fd43912c8_Out_2_Vector4.xyz), _ColorspaceConversion_30c5042ef70343cd92056cde73cd3ecb_Out_1_Vector3);
            UnityTexture2D _Property_50403cc6b1e3998a82afc21c6a6332ae_Out_0_Texture2D = UnityBuildTexture2DStructNoScale(_DetailMap);
            float4 _Property_256e5676e1089881ae3214634430b140_Out_0_Vector4 = _DetailTilingOffset;
            float _Split_257d0b6ea953418d97fd7daa8128bf35_R_1_Float = _Property_256e5676e1089881ae3214634430b140_Out_0_Vector4[0];
            float _Split_257d0b6ea953418d97fd7daa8128bf35_G_2_Float = _Property_256e5676e1089881ae3214634430b140_Out_0_Vector4[1];
            float _Split_257d0b6ea953418d97fd7daa8128bf35_B_3_Float = _Property_256e5676e1089881ae3214634430b140_Out_0_Vector4[2];
            float _Split_257d0b6ea953418d97fd7daa8128bf35_A_4_Float = _Property_256e5676e1089881ae3214634430b140_Out_0_Vector4[3];
            float2 _Vector2_98295494172421878c7a16cb2baddf9a_Out_0_Vector2 = float2(_Split_257d0b6ea953418d97fd7daa8128bf35_R_1_Float, _Split_257d0b6ea953418d97fd7daa8128bf35_G_2_Float);
            float2 _Vector2_130e8faa59837a81a7506636fcb30b8a_Out_0_Vector2 = float2(_Split_257d0b6ea953418d97fd7daa8128bf35_B_3_Float, _Split_257d0b6ea953418d97fd7daa8128bf35_A_4_Float);
            float2 _TilingAndOffset_1dfb2b4859ec3680ad3a74cf8f1bc17b_Out_3_Vector2;
            Unity_TilingAndOffset_float(IN.uv0.xy, _Vector2_98295494172421878c7a16cb2baddf9a_Out_0_Vector2, _Vector2_130e8faa59837a81a7506636fcb30b8a_Out_0_Vector2, _TilingAndOffset_1dfb2b4859ec3680ad3a74cf8f1bc17b_Out_3_Vector2);
            float4 _SampleTexture2D_d8eb0186b9a0cd819cde65431b4ea5ea_RGBA_0_Vector4 = SAMPLE_TEXTURE2D(_Property_50403cc6b1e3998a82afc21c6a6332ae_Out_0_Texture2D.tex, UnityBuildSamplerStateStruct(SamplerState_Linear_Repeat_Aniso8).samplerstate, _Property_50403cc6b1e3998a82afc21c6a6332ae_Out_0_Texture2D.GetTransformedUV(_TilingAndOffset_1dfb2b4859ec3680ad3a74cf8f1bc17b_Out_3_Vector2) );
            float _SampleTexture2D_d8eb0186b9a0cd819cde65431b4ea5ea_R_4_Float = _SampleTexture2D_d8eb0186b9a0cd819cde65431b4ea5ea_RGBA_0_Vector4.r;
            float _SampleTexture2D_d8eb0186b9a0cd819cde65431b4ea5ea_G_5_Float = _SampleTexture2D_d8eb0186b9a0cd819cde65431b4ea5ea_RGBA_0_Vector4.g;
            float _SampleTexture2D_d8eb0186b9a0cd819cde65431b4ea5ea_B_6_Float = _SampleTexture2D_d8eb0186b9a0cd819cde65431b4ea5ea_RGBA_0_Vector4.b;
            float _SampleTexture2D_d8eb0186b9a0cd819cde65431b4ea5ea_A_7_Float = _SampleTexture2D_d8eb0186b9a0cd819cde65431b4ea5ea_RGBA_0_Vector4.a;
            float _Property_605f29777330a58ba88ac032e905433b_Out_0_Float = _DetailAlbedoScale;
            float3 _Blend_de85bf99257f4eb7bb321fd973539f10_Out_2_Vector3;
            Unity_Blend_Overlay_float3(_ColorspaceConversion_30c5042ef70343cd92056cde73cd3ecb_Out_1_Vector3, (_SampleTexture2D_d8eb0186b9a0cd819cde65431b4ea5ea_R_4_Float.xxx), _Blend_de85bf99257f4eb7bb321fd973539f10_Out_2_Vector3, _Property_605f29777330a58ba88ac032e905433b_Out_0_Float);
            float3 _ColorspaceConversion_635670d250654503b34efa53a99ba43e_Out_1_Vector3;
            Unity_ColorspaceConversion_RGB_Linear_float(_Blend_de85bf99257f4eb7bb321fd973539f10_Out_2_Vector3, _ColorspaceConversion_635670d250654503b34efa53a99ba43e_Out_1_Vector3);
            float3 _Clamp_8913f48f801c43c2879f2e1ce926507e_Out_3_Vector3;
            Unity_Clamp_float3(_ColorspaceConversion_635670d250654503b34efa53a99ba43e_Out_1_Vector3, float3(0, 0, 0), float3(1, 1, 1), _Clamp_8913f48f801c43c2879f2e1ce926507e_Out_3_Vector3);
            float _Split_ddfe447fbb7845e88cc5cfb8158b2248_R_1_Float = _Clamp_8913f48f801c43c2879f2e1ce926507e_Out_3_Vector3[0];
            float _Split_ddfe447fbb7845e88cc5cfb8158b2248_G_2_Float = _Clamp_8913f48f801c43c2879f2e1ce926507e_Out_3_Vector3[1];
            float _Split_ddfe447fbb7845e88cc5cfb8158b2248_B_3_Float = _Clamp_8913f48f801c43c2879f2e1ce926507e_Out_3_Vector3[2];
            float _Split_ddfe447fbb7845e88cc5cfb8158b2248_A_4_Float = 0;
            float _Split_6d7debfd2b20440e932d58108f8e7f75_R_1_Float = _Multiply_4d0f82599060228a9092027fd43912c8_Out_2_Vector4[0];
            float _Split_6d7debfd2b20440e932d58108f8e7f75_G_2_Float = _Multiply_4d0f82599060228a9092027fd43912c8_Out_2_Vector4[1];
            float _Split_6d7debfd2b20440e932d58108f8e7f75_B_3_Float = _Multiply_4d0f82599060228a9092027fd43912c8_Out_2_Vector4[2];
            float _Split_6d7debfd2b20440e932d58108f8e7f75_A_4_Float = _Multiply_4d0f82599060228a9092027fd43912c8_Out_2_Vector4[3];
            float4 _Combine_b0f28916143e4b94af6bec53f5328b52_RGBA_4_Vector4;
            float3 _Combine_b0f28916143e4b94af6bec53f5328b52_RGB_5_Vector3;
            float2 _Combine_b0f28916143e4b94af6bec53f5328b52_RG_6_Vector2;
            Unity_Combine_float(_Split_ddfe447fbb7845e88cc5cfb8158b2248_R_1_Float, _Split_ddfe447fbb7845e88cc5cfb8158b2248_G_2_Float, _Split_ddfe447fbb7845e88cc5cfb8158b2248_B_3_Float, _Split_6d7debfd2b20440e932d58108f8e7f75_A_4_Float, _Combine_b0f28916143e4b94af6bec53f5328b52_RGBA_4_Vector4, _Combine_b0f28916143e4b94af6bec53f5328b52_RGB_5_Vector3, _Combine_b0f28916143e4b94af6bec53f5328b52_RG_6_Vector2);
            UnityTexture2D _Property_a155ddc33ed90685a5ab0edcf158a343_Out_0_Texture2D = UnityBuildTexture2DStructNoScale(_CoverBaseColorMap);
            float4 _Property_256beda96caf2d8aa05d3de41fc08d3d_Out_0_Vector4 = _CoverTilingOffset;
            float _Property_bd9dfe8dd615798f9f2d72d139e56d61_Out_0_Boolean = _CoverUsePlanarUV;
            Bindings_PlanarNM_c0f081da9c567704ea36e7dd38cedcf6_float _PlanarNM_e00e057d3d7c4181b1c7775c6ebbab5b;
            _PlanarNM_e00e057d3d7c4181b1c7775c6ebbab5b.AbsoluteWorldSpacePosition = IN.AbsoluteWorldSpacePosition;
            _PlanarNM_e00e057d3d7c4181b1c7775c6ebbab5b.uv0 = IN.uv0;
            _PlanarNM_e00e057d3d7c4181b1c7775c6ebbab5b.uv3 = IN.uv3;
            float4 _PlanarNM_e00e057d3d7c4181b1c7775c6ebbab5b_XZ_2_Vector4;
            SG_PlanarNM_c0f081da9c567704ea36e7dd38cedcf6_float(_Property_a155ddc33ed90685a5ab0edcf158a343_Out_0_Texture2D, _Property_256beda96caf2d8aa05d3de41fc08d3d_Out_0_Vector4, _Property_bd9dfe8dd615798f9f2d72d139e56d61_Out_0_Boolean, UnityBuildSamplerStateStruct(SamplerState_Linear_Repeat_Aniso8), 1, _PlanarNM_e00e057d3d7c4181b1c7775c6ebbab5b, _PlanarNM_e00e057d3d7c4181b1c7775c6ebbab5b_XZ_2_Vector4);
            float4 _Property_c3be5593fd661b8dafbd04f26b8ec9ac_Out_0_Vector4 = _CoverBaseColor;
            float4 _Multiply_b08794693505bd8e8c04b9ba1610d394_Out_2_Vector4;
            Unity_Multiply_float4_float4(_PlanarNM_e00e057d3d7c4181b1c7775c6ebbab5b_XZ_2_Vector4, _Property_c3be5593fd661b8dafbd04f26b8ec9ac_Out_0_Vector4, _Multiply_b08794693505bd8e8c04b9ba1610d394_Out_2_Vector4);
            float _Split_a80936a3c75945efb8cf9f2b95c76642_R_1_Float = IN.VertexColor[0];
            float _Split_a80936a3c75945efb8cf9f2b95c76642_G_2_Float = IN.VertexColor[1];
            float _Split_a80936a3c75945efb8cf9f2b95c76642_B_3_Float = IN.VertexColor[2];
            float _Split_a80936a3c75945efb8cf9f2b95c76642_A_4_Float = IN.VertexColor[3];
            float _Property_14a6757619d64822a44a69b34f85276d_Out_0_Float = _VertexColorGBlendStrenght;
            float _Property_c0d9ffba7dee497c885a54170977d874_Out_0_Boolean = _USEBaseHeightT;
            UnityTexture2D _Property_bb9b47702e64ec8c8d8ad011fd521576_Out_0_Texture2D = UnityBuildTexture2DStructNoScale(_BaseMaskMap);
            Bindings_PlanarNM_c0f081da9c567704ea36e7dd38cedcf6_float _PlanarNM_e51306c84cde8e84a1fb06a45d8d037f;
            _PlanarNM_e51306c84cde8e84a1fb06a45d8d037f.AbsoluteWorldSpacePosition = IN.AbsoluteWorldSpacePosition;
            _PlanarNM_e51306c84cde8e84a1fb06a45d8d037f.uv0 = IN.uv0;
            _PlanarNM_e51306c84cde8e84a1fb06a45d8d037f.uv3 = IN.uv3;
            float4 _PlanarNM_e51306c84cde8e84a1fb06a45d8d037f_XZ_2_Vector4;
            SG_PlanarNM_c0f081da9c567704ea36e7dd38cedcf6_float(_Property_bb9b47702e64ec8c8d8ad011fd521576_Out_0_Texture2D, _Property_8ec0d512145619859d288abab740e3bf_Out_0_Vector4, _Property_122c0f9ef0a1c4818a140c75e512abe4_Out_0_Boolean, UnityBuildSamplerStateStruct(SamplerState_Linear_Repeat_Aniso8), 1, _PlanarNM_e51306c84cde8e84a1fb06a45d8d037f, _PlanarNM_e51306c84cde8e84a1fb06a45d8d037f_XZ_2_Vector4);
            float _Split_218e1cfd00b30984921b5fc0ec63de60_R_1_Float = _PlanarNM_e51306c84cde8e84a1fb06a45d8d037f_XZ_2_Vector4[0];
            float _Split_218e1cfd00b30984921b5fc0ec63de60_G_2_Float = _PlanarNM_e51306c84cde8e84a1fb06a45d8d037f_XZ_2_Vector4[1];
            float _Split_218e1cfd00b30984921b5fc0ec63de60_B_3_Float = _PlanarNM_e51306c84cde8e84a1fb06a45d8d037f_XZ_2_Vector4[2];
            float _Split_218e1cfd00b30984921b5fc0ec63de60_A_4_Float = _PlanarNM_e51306c84cde8e84a1fb06a45d8d037f_XZ_2_Vector4[3];
            float _Property_1d4a1a93707b42c3abf0baa799c514e5_Out_0_Float = _HeightMin;
            float _Property_8f4f3606868d4028a34c2a9a5a59f99d_Out_0_Float = _HeightMax;
            float2 _Vector2_721b6f4d7077463490b4504fe6c940bf_Out_0_Vector2 = float2(_Property_1d4a1a93707b42c3abf0baa799c514e5_Out_0_Float, _Property_8f4f3606868d4028a34c2a9a5a59f99d_Out_0_Float);
            float _Property_a1ae2f61da87421b9f3839691e9dd8af_Out_0_Float = _HeightOffset;
            float2 _Add_1f9ea9bdf36544b59f763806e7eea80d_Out_2_Vector2;
            Unity_Add_float2(_Vector2_721b6f4d7077463490b4504fe6c940bf_Out_0_Vector2, (_Property_a1ae2f61da87421b9f3839691e9dd8af_Out_0_Float.xx), _Add_1f9ea9bdf36544b59f763806e7eea80d_Out_2_Vector2);
            float _Property_0fbef18600294e199eeda9905e3304e4_Out_0_Boolean = _USECoverHeightT;
            UnityTexture2D _Property_3702de305e11e085a40d7731b582d541_Out_0_Texture2D = UnityBuildTexture2DStructNoScale(_CoverMaskMap);
            Bindings_PlanarNM_c0f081da9c567704ea36e7dd38cedcf6_float _PlanarNM_2217ca3c12141a8cb1e0c7235b369601;
            _PlanarNM_2217ca3c12141a8cb1e0c7235b369601.AbsoluteWorldSpacePosition = IN.AbsoluteWorldSpacePosition;
            _PlanarNM_2217ca3c12141a8cb1e0c7235b369601.uv0 = IN.uv0;
            _PlanarNM_2217ca3c12141a8cb1e0c7235b369601.uv3 = IN.uv3;
            float4 _PlanarNM_2217ca3c12141a8cb1e0c7235b369601_XZ_2_Vector4;
            SG_PlanarNM_c0f081da9c567704ea36e7dd38cedcf6_float(_Property_3702de305e11e085a40d7731b582d541_Out_0_Texture2D, _Property_256beda96caf2d8aa05d3de41fc08d3d_Out_0_Vector4, _Property_bd9dfe8dd615798f9f2d72d139e56d61_Out_0_Boolean, UnityBuildSamplerStateStruct(SamplerState_Linear_Repeat_Aniso8), 1, _PlanarNM_2217ca3c12141a8cb1e0c7235b369601, _PlanarNM_2217ca3c12141a8cb1e0c7235b369601_XZ_2_Vector4);
            float _Split_2f45bca363698c859e51492899bc58f8_R_1_Float = _PlanarNM_2217ca3c12141a8cb1e0c7235b369601_XZ_2_Vector4[0];
            float _Split_2f45bca363698c859e51492899bc58f8_G_2_Float = _PlanarNM_2217ca3c12141a8cb1e0c7235b369601_XZ_2_Vector4[1];
            float _Split_2f45bca363698c859e51492899bc58f8_B_3_Float = _PlanarNM_2217ca3c12141a8cb1e0c7235b369601_XZ_2_Vector4[2];
            float _Split_2f45bca363698c859e51492899bc58f8_A_4_Float = _PlanarNM_2217ca3c12141a8cb1e0c7235b369601_XZ_2_Vector4[3];
            float _Property_32b48052fdbb4641bf4eeb294bc65050_Out_0_Float = _CoverHeightMapMin;
            float _Property_0e120eb0a0a14b12a31a3c1f5b961121_Out_0_Float = _CoverHeightMapMax;
            float2 _Vector2_6955747f7f0a4ff98fae60dbada25e89_Out_0_Vector2 = float2(_Property_32b48052fdbb4641bf4eeb294bc65050_Out_0_Float, _Property_0e120eb0a0a14b12a31a3c1f5b961121_Out_0_Float);
            float _Property_6b467710b0ba48058e003aebe9119249_Out_0_Float = _CoverHeightMapOffset;
            float2 _Add_28628d641d58481084e9c00e4ad5fc8d_Out_2_Vector2;
            Unity_Add_float2(_Vector2_6955747f7f0a4ff98fae60dbada25e89_Out_0_Vector2, (_Property_6b467710b0ba48058e003aebe9119249_Out_0_Float.xx), _Add_28628d641d58481084e9c00e4ad5fc8d_Out_2_Vector2);
            UnityTexture2D _Property_7bea2d9dd5651a8bbbd61ecde71faa54_Out_0_Texture2D = UnityBuildTexture2DStructNoScale(_Masks);
            float4 _UV_429c95affe88aa8694076115c99a0769_Out_0_Vector4 = IN.uv0;
            float4 _SampleTexture2D_2723da80b8a2528381ef199c0415beae_RGBA_0_Vector4 = SAMPLE_TEXTURE2D(_Property_7bea2d9dd5651a8bbbd61ecde71faa54_Out_0_Texture2D.tex, UnityBuildSamplerStateStruct(SamplerState_Linear_Repeat_Aniso8).samplerstate, _Property_7bea2d9dd5651a8bbbd61ecde71faa54_Out_0_Texture2D.GetTransformedUV((_UV_429c95affe88aa8694076115c99a0769_Out_0_Vector4.xy)) );
            float _SampleTexture2D_2723da80b8a2528381ef199c0415beae_R_4_Float = _SampleTexture2D_2723da80b8a2528381ef199c0415beae_RGBA_0_Vector4.r;
            float _SampleTexture2D_2723da80b8a2528381ef199c0415beae_G_5_Float = _SampleTexture2D_2723da80b8a2528381ef199c0415beae_RGBA_0_Vector4.g;
            float _SampleTexture2D_2723da80b8a2528381ef199c0415beae_B_6_Float = _SampleTexture2D_2723da80b8a2528381ef199c0415beae_RGBA_0_Vector4.b;
            float _SampleTexture2D_2723da80b8a2528381ef199c0415beae_A_7_Float = _SampleTexture2D_2723da80b8a2528381ef199c0415beae_RGBA_0_Vector4.a;
            float _Property_7bea2851849541b28a2bc695d39a7606_Out_0_Float = _Cover_Mask_A_Remap_Min;
            float _Property_3be0ae138e414a5cb43d60264b1bcfeb_Out_0_Float = _Cover_Mask_A_Remap_Max;
            float2 _Vector2_44ac029de1e440a799fbdfadc778af0c_Out_0_Vector2 = float2(_Property_7bea2851849541b28a2bc695d39a7606_Out_0_Float, _Property_3be0ae138e414a5cb43d60264b1bcfeb_Out_0_Float);
            float _Remap_0c551a3055a54f16b85b519194883552_Out_3_Float;
            Unity_Remap_float(_SampleTexture2D_2723da80b8a2528381ef199c0415beae_A_7_Float, float2 (0, 1), _Vector2_44ac029de1e440a799fbdfadc778af0c_Out_0_Vector2, _Remap_0c551a3055a54f16b85b519194883552_Out_3_Float);
            float _Clamp_bb1427696ce14fe987f799fecc5f9fac_Out_3_Float;
            Unity_Clamp_float(_Remap_0c551a3055a54f16b85b519194883552_Out_3_Float, float(0), float(1), _Clamp_bb1427696ce14fe987f799fecc5f9fac_Out_3_Float);
            float2 _Vector2_0d28074858599a88940dfc8b57b9a60f_Out_0_Vector2 = float2(_SampleTexture2D_d8eb0186b9a0cd819cde65431b4ea5ea_A_7_Float, _SampleTexture2D_d8eb0186b9a0cd819cde65431b4ea5ea_G_5_Float);
            float2 _Multiply_fac8d94f82a53486bc0142a1e64b3d32_Out_2_Vector2;
            Unity_Multiply_float2_float2(_Vector2_0d28074858599a88940dfc8b57b9a60f_Out_0_Vector2, float2(2, 2), _Multiply_fac8d94f82a53486bc0142a1e64b3d32_Out_2_Vector2);
            float2 _Add_f0e6e847d8d8798ab3ca8c4d878bafc0_Out_2_Vector2;
            Unity_Add_float2(_Multiply_fac8d94f82a53486bc0142a1e64b3d32_Out_2_Vector2, float2(-1, -1), _Add_f0e6e847d8d8798ab3ca8c4d878bafc0_Out_2_Vector2);
            float _Property_d0e8d8f7fd10f0829e8fd86c278c8226_Out_0_Float = _DetailNormalScale;
            float2 _Multiply_11f3dfc5283ea188ad9c83e552cf7e0f_Out_2_Vector2;
            Unity_Multiply_float2_float2(_Add_f0e6e847d8d8798ab3ca8c4d878bafc0_Out_2_Vector2, (_Property_d0e8d8f7fd10f0829e8fd86c278c8226_Out_0_Float.xx), _Multiply_11f3dfc5283ea188ad9c83e552cf7e0f_Out_2_Vector2);
            float _Split_c4822b8eaff9b185be7c059792345712_R_1_Float = _Multiply_11f3dfc5283ea188ad9c83e552cf7e0f_Out_2_Vector2[0];
            float _Split_c4822b8eaff9b185be7c059792345712_G_2_Float = _Multiply_11f3dfc5283ea188ad9c83e552cf7e0f_Out_2_Vector2[1];
            float _Split_c4822b8eaff9b185be7c059792345712_B_3_Float = 0;
            float _Split_c4822b8eaff9b185be7c059792345712_A_4_Float = 0;
            float _DotProduct_1a01939a143c548c8ccd7e8a04fe680d_Out_2_Float;
            Unity_DotProduct_float2(_Multiply_11f3dfc5283ea188ad9c83e552cf7e0f_Out_2_Vector2, _Multiply_11f3dfc5283ea188ad9c83e552cf7e0f_Out_2_Vector2, _DotProduct_1a01939a143c548c8ccd7e8a04fe680d_Out_2_Float);
            float _Saturate_bf3d57899db77f86a1689105ce6a373a_Out_1_Float;
            Unity_Saturate_float(_DotProduct_1a01939a143c548c8ccd7e8a04fe680d_Out_2_Float, _Saturate_bf3d57899db77f86a1689105ce6a373a_Out_1_Float);
            float _OneMinus_052960238cc4a18cb83109d2bcae6d09_Out_1_Float;
            Unity_OneMinus_float(_Saturate_bf3d57899db77f86a1689105ce6a373a_Out_1_Float, _OneMinus_052960238cc4a18cb83109d2bcae6d09_Out_1_Float);
            float _SquareRoot_d4f67288e4dbf5898bea492a70b89ab9_Out_1_Float;
            Unity_SquareRoot_float(_OneMinus_052960238cc4a18cb83109d2bcae6d09_Out_1_Float, _SquareRoot_d4f67288e4dbf5898bea492a70b89ab9_Out_1_Float);
            float3 _Vector3_1e56146bdd567884bb8d5ae769df4d29_Out_0_Vector3 = float3(_Split_c4822b8eaff9b185be7c059792345712_R_1_Float, _Split_c4822b8eaff9b185be7c059792345712_G_2_Float, _SquareRoot_d4f67288e4dbf5898bea492a70b89ab9_Out_1_Float);
            UnityTexture2D _Property_147b07430832c98eb0a470557ee61c5e_Out_0_Texture2D = UnityBuildTexture2DStructNoScale(_BaseNormalMap);
            Bindings_PlanarNMn_1b93a87456f9d4c419321d0cd92bd6c8_float _PlanarNMn_ecad9f1f260c6c8bbd0960b2a8976daf;
            _PlanarNMn_ecad9f1f260c6c8bbd0960b2a8976daf.WorldSpaceNormal = IN.WorldSpaceNormal;
            _PlanarNMn_ecad9f1f260c6c8bbd0960b2a8976daf.WorldSpaceTangent = IN.WorldSpaceTangent;
            _PlanarNMn_ecad9f1f260c6c8bbd0960b2a8976daf.WorldSpaceBiTangent = IN.WorldSpaceBiTangent;
            _PlanarNMn_ecad9f1f260c6c8bbd0960b2a8976daf.AbsoluteWorldSpacePosition = IN.AbsoluteWorldSpacePosition;
            _PlanarNMn_ecad9f1f260c6c8bbd0960b2a8976daf.uv0 = IN.uv0;
            _PlanarNMn_ecad9f1f260c6c8bbd0960b2a8976daf.uv3 = IN.uv3;
            float4 _PlanarNMn_ecad9f1f260c6c8bbd0960b2a8976daf_XZ_2_Vector4;
            SG_PlanarNMn_1b93a87456f9d4c419321d0cd92bd6c8_float(_Property_147b07430832c98eb0a470557ee61c5e_Out_0_Texture2D, _Property_8ec0d512145619859d288abab740e3bf_Out_0_Vector4, _Property_122c0f9ef0a1c4818a140c75e512abe4_Out_0_Boolean, UnityBuildSamplerStateStruct(SamplerState_Linear_Repeat_Aniso8), 1, _PlanarNMn_ecad9f1f260c6c8bbd0960b2a8976daf, _PlanarNMn_ecad9f1f260c6c8bbd0960b2a8976daf_XZ_2_Vector4);
            float _Property_72e436a108ad64868e46d548c585c5f3_Out_0_Float = _BaseNormalScale;
            float3 _NormalStrength_366affc5c8b42482a633d201ef52b9d6_Out_2_Vector3;
            Unity_NormalStrength_float((_PlanarNMn_ecad9f1f260c6c8bbd0960b2a8976daf_XZ_2_Vector4.xyz), _Property_72e436a108ad64868e46d548c585c5f3_Out_0_Float, _NormalStrength_366affc5c8b42482a633d201ef52b9d6_Out_2_Vector3);
            float3 _NormalBlend_9f531c87e2e45580b1d0f65f06c23526_Out_2_Vector3;
            Unity_NormalBlend_Reoriented_float(_Vector3_1e56146bdd567884bb8d5ae769df4d29_Out_0_Vector3, _NormalStrength_366affc5c8b42482a633d201ef52b9d6_Out_2_Vector3, _NormalBlend_9f531c87e2e45580b1d0f65f06c23526_Out_2_Vector3);
            UnityTexture2D _Property_d7e9139e0ac6718b89c610009c28a25a_Out_0_Texture2D = UnityBuildTexture2DStructNoScale(_CoverNormalMap);
            Bindings_PlanarNMn_1b93a87456f9d4c419321d0cd92bd6c8_float _PlanarNMn_690e893d26999680a5cea3604ed0ce16;
            _PlanarNMn_690e893d26999680a5cea3604ed0ce16.WorldSpaceNormal = IN.WorldSpaceNormal;
            _PlanarNMn_690e893d26999680a5cea3604ed0ce16.WorldSpaceTangent = IN.WorldSpaceTangent;
            _PlanarNMn_690e893d26999680a5cea3604ed0ce16.WorldSpaceBiTangent = IN.WorldSpaceBiTangent;
            _PlanarNMn_690e893d26999680a5cea3604ed0ce16.AbsoluteWorldSpacePosition = IN.AbsoluteWorldSpacePosition;
            _PlanarNMn_690e893d26999680a5cea3604ed0ce16.uv0 = IN.uv0;
            _PlanarNMn_690e893d26999680a5cea3604ed0ce16.uv3 = IN.uv3;
            float4 _PlanarNMn_690e893d26999680a5cea3604ed0ce16_XZ_2_Vector4;
            SG_PlanarNMn_1b93a87456f9d4c419321d0cd92bd6c8_float(_Property_d7e9139e0ac6718b89c610009c28a25a_Out_0_Texture2D, _Property_256beda96caf2d8aa05d3de41fc08d3d_Out_0_Vector4, _Property_bd9dfe8dd615798f9f2d72d139e56d61_Out_0_Boolean, UnityBuildSamplerStateStruct(SamplerState_Linear_Repeat_Aniso8), 1, _PlanarNMn_690e893d26999680a5cea3604ed0ce16, _PlanarNMn_690e893d26999680a5cea3604ed0ce16_XZ_2_Vector4);
            float _Property_0fd4d87ded104c829a6110c044eaa5f2_Out_0_Float = _CoverNormalBlendHardness;
            float3 _NormalStrength_c4639a6dd3dfde85b591971db2700eaf_Out_2_Vector3;
            Unity_NormalStrength_float((_PlanarNMn_690e893d26999680a5cea3604ed0ce16_XZ_2_Vector4.xyz), _Property_0fd4d87ded104c829a6110c044eaa5f2_Out_0_Float, _NormalStrength_c4639a6dd3dfde85b591971db2700eaf_Out_2_Vector3);
            float _Split_8ff22a6bdd437780ac7ea5963e1c5bb4_R_1_Float = IN.WorldSpaceNormal[0];
            float _Split_8ff22a6bdd437780ac7ea5963e1c5bb4_G_2_Float = IN.WorldSpaceNormal[1];
            float _Split_8ff22a6bdd437780ac7ea5963e1c5bb4_B_3_Float = IN.WorldSpaceNormal[2];
            float _Split_8ff22a6bdd437780ac7ea5963e1c5bb4_A_4_Float = 0;
            float _Property_28052b023ac35c8e9a95b30327681cc5_Out_0_Float = _Cover_Amount;
            float _Property_7749c0d5b28c14869ab3ba35d226788b_Out_0_Float = _Cover_Amount_Grow_Speed;
            float _Subtract_e5dc2afce7ff588fa1d4c91f78de7575_Out_2_Float;
            Unity_Subtract_float(float(4), _Property_7749c0d5b28c14869ab3ba35d226788b_Out_0_Float, _Subtract_e5dc2afce7ff588fa1d4c91f78de7575_Out_2_Float);
            float _Divide_c77b003bf1ce13828c94a705676e2b30_Out_2_Float;
            Unity_Divide_float(_Property_28052b023ac35c8e9a95b30327681cc5_Out_0_Float, _Subtract_e5dc2afce7ff588fa1d4c91f78de7575_Out_2_Float, _Divide_c77b003bf1ce13828c94a705676e2b30_Out_2_Float);
            float _Absolute_c7499cf07bdd0582abd82adbf367b0fc_Out_1_Float;
            Unity_Absolute_float(_Divide_c77b003bf1ce13828c94a705676e2b30_Out_2_Float, _Absolute_c7499cf07bdd0582abd82adbf367b0fc_Out_1_Float);
            float _Power_a9431dbce44a528f9ee7095adfa10556_Out_2_Float;
            Unity_Power_float(_Absolute_c7499cf07bdd0582abd82adbf367b0fc_Out_1_Float, _Subtract_e5dc2afce7ff588fa1d4c91f78de7575_Out_2_Float, _Power_a9431dbce44a528f9ee7095adfa10556_Out_2_Float);
            float _Clamp_815ffdd53cc1c889aa00f73784cb71e7_Out_3_Float;
            Unity_Clamp_float(_Power_a9431dbce44a528f9ee7095adfa10556_Out_2_Float, float(0), float(2), _Clamp_815ffdd53cc1c889aa00f73784cb71e7_Out_3_Float);
            float _Multiply_143da4886728ff868f10e9cfa6940ea0_Out_2_Float;
            Unity_Multiply_float_float(_Split_8ff22a6bdd437780ac7ea5963e1c5bb4_G_2_Float, _Clamp_815ffdd53cc1c889aa00f73784cb71e7_Out_3_Float, _Multiply_143da4886728ff868f10e9cfa6940ea0_Out_2_Float);
            float _Saturate_04686ab19029f68c8fb9e7a115b207b1_Out_1_Float;
            Unity_Saturate_float(_Multiply_143da4886728ff868f10e9cfa6940ea0_Out_2_Float, _Saturate_04686ab19029f68c8fb9e7a115b207b1_Out_1_Float);
            float _Clamp_9c0a88ffc7be288cbe97d3e13a014fe8_Out_3_Float;
            Unity_Clamp_float(_Split_8ff22a6bdd437780ac7ea5963e1c5bb4_G_2_Float, float(0), float(0.9999), _Clamp_9c0a88ffc7be288cbe97d3e13a014fe8_Out_3_Float);
            float _Property_58f42b34c7f0728f8c98e00a3e3a5726_Out_0_Float = _Cover_Max_Angle;
            float _Divide_b785767ecc1928889893fa60eac4e5fb_Out_2_Float;
            Unity_Divide_float(_Property_58f42b34c7f0728f8c98e00a3e3a5726_Out_0_Float, float(45), _Divide_b785767ecc1928889893fa60eac4e5fb_Out_2_Float);
            float _OneMinus_8e6f5b1570dc8c8b8afb036328281675_Out_1_Float;
            Unity_OneMinus_float(_Divide_b785767ecc1928889893fa60eac4e5fb_Out_2_Float, _OneMinus_8e6f5b1570dc8c8b8afb036328281675_Out_1_Float);
            float _Subtract_5348fb3702fea78d9ee10dbf81ede29c_Out_2_Float;
            Unity_Subtract_float(_Clamp_9c0a88ffc7be288cbe97d3e13a014fe8_Out_3_Float, _OneMinus_8e6f5b1570dc8c8b8afb036328281675_Out_1_Float, _Subtract_5348fb3702fea78d9ee10dbf81ede29c_Out_2_Float);
            float _Clamp_2b888688983edd82ac250226d9378893_Out_3_Float;
            Unity_Clamp_float(_Subtract_5348fb3702fea78d9ee10dbf81ede29c_Out_2_Float, float(0), float(2), _Clamp_2b888688983edd82ac250226d9378893_Out_3_Float);
            float _Divide_5615f16c20214d888a2e727ff7c5f5ff_Out_2_Float;
            Unity_Divide_float(float(1), _Divide_b785767ecc1928889893fa60eac4e5fb_Out_2_Float, _Divide_5615f16c20214d888a2e727ff7c5f5ff_Out_2_Float);
            float _Multiply_89aeffc0ad067981a18e6a77948b2b49_Out_2_Float;
            Unity_Multiply_float_float(_Clamp_2b888688983edd82ac250226d9378893_Out_3_Float, _Divide_5615f16c20214d888a2e727ff7c5f5ff_Out_2_Float, _Multiply_89aeffc0ad067981a18e6a77948b2b49_Out_2_Float);
            float _Absolute_b91ed8e326de8f88bf52e49cc5f641d4_Out_1_Float;
            Unity_Absolute_float(_Multiply_89aeffc0ad067981a18e6a77948b2b49_Out_2_Float, _Absolute_b91ed8e326de8f88bf52e49cc5f641d4_Out_1_Float);
            float _Property_4879e96694aee98c9d4ecd329a571123_Out_0_Float = _CoverHardness;
            float _Power_ca1f1906c90fb785bfe520b7faefc3cd_Out_2_Float;
            Unity_Power_float(_Absolute_b91ed8e326de8f88bf52e49cc5f641d4_Out_1_Float, _Property_4879e96694aee98c9d4ecd329a571123_Out_0_Float, _Power_ca1f1906c90fb785bfe520b7faefc3cd_Out_2_Float);
            float _Property_b66201e787ab7b83a55abc6ddd3fe1fd_Out_0_Float = _Cover_Min_Height;
            float _OneMinus_87c740d245de388db4fe5f4958de0668_Out_1_Float;
            Unity_OneMinus_float(_Property_b66201e787ab7b83a55abc6ddd3fe1fd_Out_0_Float, _OneMinus_87c740d245de388db4fe5f4958de0668_Out_1_Float);
            float _Split_ae16de7cacf9d0878aba1467f193d681_R_1_Float = IN.AbsoluteWorldSpacePosition[0];
            float _Split_ae16de7cacf9d0878aba1467f193d681_G_2_Float = IN.AbsoluteWorldSpacePosition[1];
            float _Split_ae16de7cacf9d0878aba1467f193d681_B_3_Float = IN.AbsoluteWorldSpacePosition[2];
            float _Split_ae16de7cacf9d0878aba1467f193d681_A_4_Float = 0;
            float _Add_9d6e1dd03919c88bb01e77a9a2b6b59c_Out_2_Float;
            Unity_Add_float(_OneMinus_87c740d245de388db4fe5f4958de0668_Out_1_Float, _Split_ae16de7cacf9d0878aba1467f193d681_G_2_Float, _Add_9d6e1dd03919c88bb01e77a9a2b6b59c_Out_2_Float);
            float _Add_448f30a2cd792b868416a253a1c502bb_Out_2_Float;
            Unity_Add_float(_Add_9d6e1dd03919c88bb01e77a9a2b6b59c_Out_2_Float, float(1), _Add_448f30a2cd792b868416a253a1c502bb_Out_2_Float);
            float _Clamp_53d91568d0627d8a9cac8deecdd003a8_Out_3_Float;
            Unity_Clamp_float(_Add_448f30a2cd792b868416a253a1c502bb_Out_2_Float, float(0), float(1), _Clamp_53d91568d0627d8a9cac8deecdd003a8_Out_3_Float);
            float _Property_98b8c0fc7e8f9b88b8d7d9dd28ed8aca_Out_0_Float = _Cover_Min_Height_Blending;
            float _Add_0edbe9f424de6d8089b453804bc6ec74_Out_2_Float;
            Unity_Add_float(_Add_9d6e1dd03919c88bb01e77a9a2b6b59c_Out_2_Float, _Property_98b8c0fc7e8f9b88b8d7d9dd28ed8aca_Out_0_Float, _Add_0edbe9f424de6d8089b453804bc6ec74_Out_2_Float);
            float _Divide_bacd243000beaa86b28174bd47716791_Out_2_Float;
            Unity_Divide_float(_Add_0edbe9f424de6d8089b453804bc6ec74_Out_2_Float, _Add_9d6e1dd03919c88bb01e77a9a2b6b59c_Out_2_Float, _Divide_bacd243000beaa86b28174bd47716791_Out_2_Float);
            float _OneMinus_dd51a0c56dbb9b8b8882c6d36bfadd50_Out_1_Float;
            Unity_OneMinus_float(_Divide_bacd243000beaa86b28174bd47716791_Out_2_Float, _OneMinus_dd51a0c56dbb9b8b8882c6d36bfadd50_Out_1_Float);
            float _Add_58dd4a9dfd5655818255c74dd17921da_Out_2_Float;
            Unity_Add_float(_OneMinus_dd51a0c56dbb9b8b8882c6d36bfadd50_Out_1_Float, float(-0.5), _Add_58dd4a9dfd5655818255c74dd17921da_Out_2_Float);
            float _Clamp_5b36f07b81ef6f87a93aefa8fcb815b4_Out_3_Float;
            Unity_Clamp_float(_Add_58dd4a9dfd5655818255c74dd17921da_Out_2_Float, float(0), float(1), _Clamp_5b36f07b81ef6f87a93aefa8fcb815b4_Out_3_Float);
            float _Add_5ef49a57de2cdf85b0e894bfa07f6f14_Out_2_Float;
            Unity_Add_float(_Clamp_53d91568d0627d8a9cac8deecdd003a8_Out_3_Float, _Clamp_5b36f07b81ef6f87a93aefa8fcb815b4_Out_3_Float, _Add_5ef49a57de2cdf85b0e894bfa07f6f14_Out_2_Float);
            float _Clamp_130844801cc2148bb64804d2328686eb_Out_3_Float;
            Unity_Clamp_float(_Add_5ef49a57de2cdf85b0e894bfa07f6f14_Out_2_Float, float(0), float(1), _Clamp_130844801cc2148bb64804d2328686eb_Out_3_Float);
            float _Multiply_4a38c41b77a2458085ff4ae52ba3c21c_Out_2_Float;
            Unity_Multiply_float_float(_Power_ca1f1906c90fb785bfe520b7faefc3cd_Out_2_Float, _Clamp_130844801cc2148bb64804d2328686eb_Out_3_Float, _Multiply_4a38c41b77a2458085ff4ae52ba3c21c_Out_2_Float);
            float _Multiply_edc44afd10069b8e80460ceee1cba8f0_Out_2_Float;
            Unity_Multiply_float_float(_Saturate_04686ab19029f68c8fb9e7a115b207b1_Out_1_Float, _Multiply_4a38c41b77a2458085ff4ae52ba3c21c_Out_2_Float, _Multiply_edc44afd10069b8e80460ceee1cba8f0_Out_2_Float);
            float3 _Lerp_05179f1a9a06b084b2d83e8bce908cce_Out_3_Vector3;
            Unity_Lerp_float3(_NormalBlend_9f531c87e2e45580b1d0f65f06c23526_Out_2_Vector3, _NormalStrength_c4639a6dd3dfde85b591971db2700eaf_Out_2_Vector3, (_Multiply_edc44afd10069b8e80460ceee1cba8f0_Out_2_Float.xxx), _Lerp_05179f1a9a06b084b2d83e8bce908cce_Out_3_Vector3);
            float3 _Transform_d583fb35b7a2838399ae5ff4e71be918_Out_1_Vector3;
            {
                float3x3 tangentTransform = float3x3(IN.WorldSpaceTangent, IN.WorldSpaceBiTangent, IN.WorldSpaceNormal);
                _Transform_d583fb35b7a2838399ae5ff4e71be918_Out_1_Vector3 = TransformTangentToWorldDir(_Lerp_05179f1a9a06b084b2d83e8bce908cce_Out_3_Vector3.xyz, tangentTransform, false).xyz;
            }
            float _Split_44ee9f8d0d54618cabce22ec49a8e7d3_R_1_Float = _Transform_d583fb35b7a2838399ae5ff4e71be918_Out_1_Vector3[0];
            float _Split_44ee9f8d0d54618cabce22ec49a8e7d3_G_2_Float = _Transform_d583fb35b7a2838399ae5ff4e71be918_Out_1_Vector3[1];
            float _Split_44ee9f8d0d54618cabce22ec49a8e7d3_B_3_Float = _Transform_d583fb35b7a2838399ae5ff4e71be918_Out_1_Vector3[2];
            float _Split_44ee9f8d0d54618cabce22ec49a8e7d3_A_4_Float = 0;
            float _Multiply_61fc6a92f0e952858b5d99f2caeb09a3_Out_2_Float;
            Unity_Multiply_float_float(_Split_44ee9f8d0d54618cabce22ec49a8e7d3_G_2_Float, _Clamp_815ffdd53cc1c889aa00f73784cb71e7_Out_3_Float, _Multiply_61fc6a92f0e952858b5d99f2caeb09a3_Out_2_Float);
            float _Multiply_1e7ca8eeb2afb68a96897072c537d835_Out_2_Float;
            Unity_Multiply_float_float(_Clamp_815ffdd53cc1c889aa00f73784cb71e7_Out_3_Float, _Property_4879e96694aee98c9d4ecd329a571123_Out_0_Float, _Multiply_1e7ca8eeb2afb68a96897072c537d835_Out_2_Float);
            float _Multiply_a16d49a3ef8d76899c86b7d84d20ef1f_Out_2_Float;
            Unity_Multiply_float_float(_Multiply_1e7ca8eeb2afb68a96897072c537d835_Out_2_Float, _Multiply_4a38c41b77a2458085ff4ae52ba3c21c_Out_2_Float, _Multiply_a16d49a3ef8d76899c86b7d84d20ef1f_Out_2_Float);
            float _Multiply_dd6ce40548593687a3441a83047275eb_Out_2_Float;
            Unity_Multiply_float_float(_Multiply_61fc6a92f0e952858b5d99f2caeb09a3_Out_2_Float, _Multiply_a16d49a3ef8d76899c86b7d84d20ef1f_Out_2_Float, _Multiply_dd6ce40548593687a3441a83047275eb_Out_2_Float);
            float _Clamp_a3bc14da42d1452f9459b4703c528466_Out_3_Float;
            Unity_Clamp_float(_Multiply_dd6ce40548593687a3441a83047275eb_Out_2_Float, float(0), float(1), _Clamp_a3bc14da42d1452f9459b4703c528466_Out_3_Float);
            float _Multiply_ce9d0ae57259445ba0ff1b83b3eac7be_Out_2_Float;
            Unity_Multiply_float_float(_Clamp_bb1427696ce14fe987f799fecc5f9fac_Out_3_Float, _Clamp_a3bc14da42d1452f9459b4703c528466_Out_3_Float, _Multiply_ce9d0ae57259445ba0ff1b83b3eac7be_Out_2_Float);
            #if defined(_USEDYNAMICCOVERTSTATICMASKF)
            float _UseDynamicCover_5ab22e0469924273a6c7c42f82abda85_Out_0_Float = _Multiply_ce9d0ae57259445ba0ff1b83b3eac7be_Out_2_Float;
            #else
            float _UseDynamicCover_5ab22e0469924273a6c7c42f82abda85_Out_0_Float = _Clamp_bb1427696ce14fe987f799fecc5f9fac_Out_3_Float;
            #endif
            Bindings_UniversalHeighblend_3b5c31b864970d04197cd420b6c4b0fa_float _UniversalHeighblend_21bd55d8d402489499f7ea440e52eb45;
            float _UniversalHeighblend_21bd55d8d402489499f7ea440e52eb45_Heightmap_1_Float;
            SG_UniversalHeighblend_3b5c31b864970d04197cd420b6c4b0fa_float(_Split_a80936a3c75945efb8cf9f2b95c76642_G_2_Float, _Property_14a6757619d64822a44a69b34f85276d_Out_0_Float, _Property_c0d9ffba7dee497c885a54170977d874_Out_0_Boolean, _Split_218e1cfd00b30984921b5fc0ec63de60_B_3_Float, _Add_1f9ea9bdf36544b59f763806e7eea80d_Out_2_Vector2, _Property_0fbef18600294e199eeda9905e3304e4_Out_0_Boolean, _Split_2f45bca363698c859e51492899bc58f8_B_3_Float, _Add_28628d641d58481084e9c00e4ad5fc8d_Out_2_Vector2, _UseDynamicCover_5ab22e0469924273a6c7c42f82abda85_Out_0_Float, _UniversalHeighblend_21bd55d8d402489499f7ea440e52eb45, _UniversalHeighblend_21bd55d8d402489499f7ea440e52eb45_Heightmap_1_Float);
            float _Split_05a25ef5bb1c4867950074f8c86410e8_R_1_Float = IN.VertexColor[0];
            float _Split_05a25ef5bb1c4867950074f8c86410e8_G_2_Float = IN.VertexColor[1];
            float _Split_05a25ef5bb1c4867950074f8c86410e8_B_3_Float = IN.VertexColor[2];
            float _Split_05a25ef5bb1c4867950074f8c86410e8_A_4_Float = IN.VertexColor[3];
            float _OneMinus_0527b7625ff14e8c8ca27817ac4fe9f9_Out_1_Float;
            Unity_OneMinus_float(_Split_05a25ef5bb1c4867950074f8c86410e8_B_3_Float, _OneMinus_0527b7625ff14e8c8ca27817ac4fe9f9_Out_1_Float);
            float _Property_defdd10d24ee4948b18af67062372fb7_Out_0_Float = _VertexColorBBlendStrenght;
            float _Property_f600c3fa0837403fa7000ace8a7aa949_Out_0_Boolean = _USEBaseHeightT;
            float _Property_cc1df5222a194b39870a1906a95881c7_Out_0_Boolean = _USECoverHeightT;
            float _Subtract_df32895ca10a49a6adc84378c30ceb7c_Out_2_Float;
            Unity_Subtract_float(_Property_0e120eb0a0a14b12a31a3c1f5b961121_Out_0_Float, _Property_32b48052fdbb4641bf4eeb294bc65050_Out_0_Float, _Subtract_df32895ca10a49a6adc84378c30ceb7c_Out_2_Float);
            float _Split_a090b28818f34dd8945b893c7fd769f1_R_1_Float = IN.VertexColor[0];
            float _Split_a090b28818f34dd8945b893c7fd769f1_G_2_Float = IN.VertexColor[1];
            float _Split_a090b28818f34dd8945b893c7fd769f1_B_3_Float = IN.VertexColor[2];
            float _Split_a090b28818f34dd8945b893c7fd769f1_A_4_Float = IN.VertexColor[3];
            float _OneMinus_d11f0c4a04b345419edf8e146b9c0221_Out_1_Float;
            Unity_OneMinus_float(_Split_a090b28818f34dd8945b893c7fd769f1_B_3_Float, _OneMinus_d11f0c4a04b345419edf8e146b9c0221_Out_1_Float);
            float _Multiply_b7ff184632b347e9b3d331daaed81a77_Out_2_Float;
            Unity_Multiply_float_float(_Subtract_df32895ca10a49a6adc84378c30ceb7c_Out_2_Float, _OneMinus_d11f0c4a04b345419edf8e146b9c0221_Out_1_Float, _Multiply_b7ff184632b347e9b3d331daaed81a77_Out_2_Float);
            float _Add_ff8ced5a04044788a5de3632a403c505_Out_2_Float;
            Unity_Add_float(_Property_6b467710b0ba48058e003aebe9119249_Out_0_Float, _Multiply_b7ff184632b347e9b3d331daaed81a77_Out_2_Float, _Add_ff8ced5a04044788a5de3632a403c505_Out_2_Float);
            float2 _Add_8ec067f807d04641bea7fd38ab0c8165_Out_2_Vector2;
            Unity_Add_float2(_Vector2_6955747f7f0a4ff98fae60dbada25e89_Out_0_Vector2, (_Add_ff8ced5a04044788a5de3632a403c505_Out_2_Float.xx), _Add_8ec067f807d04641bea7fd38ab0c8165_Out_2_Vector2);
            Bindings_UniversalHeighblend_3b5c31b864970d04197cd420b6c4b0fa_float _UniversalHeighblend_69e2f839a11b4aa7b8e84d65b0ac8307;
            float _UniversalHeighblend_69e2f839a11b4aa7b8e84d65b0ac8307_Heightmap_1_Float;
            SG_UniversalHeighblend_3b5c31b864970d04197cd420b6c4b0fa_float(_OneMinus_0527b7625ff14e8c8ca27817ac4fe9f9_Out_1_Float, _Property_defdd10d24ee4948b18af67062372fb7_Out_0_Float, _Property_f600c3fa0837403fa7000ace8a7aa949_Out_0_Boolean, _Split_218e1cfd00b30984921b5fc0ec63de60_B_3_Float, _Add_1f9ea9bdf36544b59f763806e7eea80d_Out_2_Vector2, _Property_cc1df5222a194b39870a1906a95881c7_Out_0_Boolean, _Split_2f45bca363698c859e51492899bc58f8_B_3_Float, _Add_8ec067f807d04641bea7fd38ab0c8165_Out_2_Vector2, float(1), _UniversalHeighblend_69e2f839a11b4aa7b8e84d65b0ac8307, _UniversalHeighblend_69e2f839a11b4aa7b8e84d65b0ac8307_Heightmap_1_Float);
            float _Add_facc0ab0661749d4bda41177c639b438_Out_2_Float;
            Unity_Add_float(_UniversalHeighblend_21bd55d8d402489499f7ea440e52eb45_Heightmap_1_Float, _UniversalHeighblend_69e2f839a11b4aa7b8e84d65b0ac8307_Heightmap_1_Float, _Add_facc0ab0661749d4bda41177c639b438_Out_2_Float);
            float _Saturate_269cfab86e2abe83819a3afa7b3eeda2_Out_1_Float;
            Unity_Saturate_float(_Add_facc0ab0661749d4bda41177c639b438_Out_2_Float, _Saturate_269cfab86e2abe83819a3afa7b3eeda2_Out_1_Float);
            float4 _Lerp_562b79f1df34b88e9a8a7431d434b435_Out_3_Vector4;
            Unity_Lerp_float4(_Combine_b0f28916143e4b94af6bec53f5328b52_RGBA_4_Vector4, _Multiply_b08794693505bd8e8c04b9ba1610d394_Out_2_Vector4, (_Saturate_269cfab86e2abe83819a3afa7b3eeda2_Out_1_Float.xxxx), _Lerp_562b79f1df34b88e9a8a7431d434b435_Out_3_Vector4);
            float _Split_546cdec490fe4753bb0983eea82b45b5_R_1_Float = _Lerp_562b79f1df34b88e9a8a7431d434b435_Out_3_Vector4[0];
            float _Split_546cdec490fe4753bb0983eea82b45b5_G_2_Float = _Lerp_562b79f1df34b88e9a8a7431d434b435_Out_3_Vector4[1];
            float _Split_546cdec490fe4753bb0983eea82b45b5_B_3_Float = _Lerp_562b79f1df34b88e9a8a7431d434b435_Out_3_Vector4[2];
            float _Split_546cdec490fe4753bb0983eea82b45b5_A_4_Float = _Lerp_562b79f1df34b88e9a8a7431d434b435_Out_3_Vector4[3];
            float4 _Clamp_33ec4dd182654e108c0f4ee43f91e820_Out_3_Vector4;
            Unity_Clamp_float4(IN.VertexColor, float4(0, 0, 0, 0), float4(1, 1, 1, 1), _Clamp_33ec4dd182654e108c0f4ee43f91e820_Out_3_Vector4);
            float _Split_5b2299b48b10138ea40c141b79bfe90e_R_1_Float = _Clamp_33ec4dd182654e108c0f4ee43f91e820_Out_3_Vector4[0];
            float _Split_5b2299b48b10138ea40c141b79bfe90e_G_2_Float = _Clamp_33ec4dd182654e108c0f4ee43f91e820_Out_3_Vector4[1];
            float _Split_5b2299b48b10138ea40c141b79bfe90e_B_3_Float = _Clamp_33ec4dd182654e108c0f4ee43f91e820_Out_3_Vector4[2];
            float _Split_5b2299b48b10138ea40c141b79bfe90e_A_4_Float = _Clamp_33ec4dd182654e108c0f4ee43f91e820_Out_3_Vector4[3];
            float _Multiply_a7796e97d268424b880f9cb87fc6e42c_Out_2_Float;
            Unity_Multiply_float_float(_Split_546cdec490fe4753bb0983eea82b45b5_A_4_Float, _Split_5b2299b48b10138ea40c141b79bfe90e_A_4_Float, _Multiply_a7796e97d268424b880f9cb87fc6e42c_Out_2_Float);
            float _Property_7ae68b65d6ed4f37aec08ecb89701e8e_Out_0_Float = _AlphaCutoff;
            surface.Alpha = _Multiply_a7796e97d268424b880f9cb87fc6e42c_Out_2_Float;
            surface.AlphaClipThreshold = _Property_7ae68b65d6ed4f37aec08ecb89701e8e_Out_0_Float;
            return surface;
        }
        
        // --------------------------------------------------
        // Build Graph Inputs
        #ifdef HAVE_VFX_MODIFICATION
        #define VFX_SRP_ATTRIBUTES Attributes
        #define VFX_SRP_VARYINGS Varyings
        #define VFX_SRP_SURFACE_INPUTS SurfaceDescriptionInputs
        #endif
        VertexDescriptionInputs BuildVertexDescriptionInputs(Attributes input)
        {
            VertexDescriptionInputs output;
            ZERO_INITIALIZE(VertexDescriptionInputs, output);
        
            output.ObjectSpacePosition =                        input.positionOS;
        #if UNITY_ANY_INSTANCING_ENABLED
        #else // TODO: XR support for procedural instancing because in this case UNITY_ANY_INSTANCING_ENABLED is not defined and instanceID is incorrect.
        #endif
        
            return output;
        }
        SurfaceDescriptionInputs BuildSurfaceDescriptionInputs(Varyings input)
        {
            SurfaceDescriptionInputs output;
            ZERO_INITIALIZE(SurfaceDescriptionInputs, output);
        
        #ifdef HAVE_VFX_MODIFICATION
        #if VFX_USE_GRAPH_VALUES
            uint instanceActiveIndex = asuint(UNITY_ACCESS_INSTANCED_PROP(PerInstance, _InstanceActiveIndex));
            /* WARNING: $splice Could not find named fragment 'VFXLoadGraphValues' */
        #endif
            /* WARNING: $splice Could not find named fragment 'VFXSetFragInputs' */
        
        #endif
        
            
        
            // must use interpolated tangent, bitangent and normal before they are normalized in the pixel shader.
            float3 unnormalizedNormalWS = input.normalWS;
            const float renormFactor = 1.0 / length(unnormalizedNormalWS);
        
            // use bitangent on the fly like in hdrp
            // IMPORTANT! If we ever support Flip on double sided materials ensure bitangent and tangent are NOT flipped.
            float crossSign = (input.tangentWS.w > 0.0 ? 1.0 : -1.0)* GetOddNegativeScale();
            float3 bitang = crossSign * cross(input.normalWS.xyz, input.tangentWS.xyz);
        
            output.WorldSpaceNormal = renormFactor * input.normalWS.xyz;      // we want a unit length Normal Vector node in shader graph
        
            // to pr               eserve mikktspace compliance we use same scale renormFactor as was used on the normal.
            // This                is explained in section 2.2 in "surface gradient based bump mapping framework"
            output.WorldSpaceTangent = renormFactor * input.tangentWS.xyz;
            output.WorldSpaceBiTangent = renormFactor * bitang;
        
            output.AbsoluteWorldSpacePosition = GetAbsolutePositionWS(input.positionWS);
        
            #if UNITY_UV_STARTS_AT_TOP
            #else
            #endif
        
        
            output.uv0 = input.texCoord0;
            output.uv3 = input.texCoord3;
            output.VertexColor = input.color;
        #if UNITY_ANY_INSTANCING_ENABLED
        #else // TODO: XR support for procedural instancing because in this case UNITY_ANY_INSTANCING_ENABLED is not defined and instanceID is incorrect.
        #endif
        #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
        #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN output.FaceSign =                    IS_FRONT_VFACE(input.cullFace, true, false);
        #else
        #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
        #endif
        #undef BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
        
                return output;
        }
        
        // --------------------------------------------------
        // Main
        
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/Varyings.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/MotionVectorPass.hlsl"
        
        // --------------------------------------------------
        // Visual Effect Vertex Invocations
        #ifdef HAVE_VFX_MODIFICATION
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/VisualEffectVertex.hlsl"
        #endif
        
        ENDHLSL
        }
        Pass
        {
            Name "DepthOnly"
            Tags
            {
                "LightMode" = "DepthOnly"
            }
        
        // Render State
        Cull [_Cull]
        ZTest LEqual
        ZWrite On
        ColorMask R
        
        // Debug
        // <None>
        
        // --------------------------------------------------
        // Pass
        
        HLSLPROGRAM
        
        // Pragmas
        #pragma target 2.0
        #pragma multi_compile_instancing
        #pragma vertex vert
        #pragma fragment frag
        
        // Keywords
        #pragma shader_feature_local_fragment _ _ALPHATEST_ON
        #pragma multi_compile _ LOD_FADE_CROSSFADE
        #pragma shader_feature_local _ _USEDYNAMICCOVERTSTATICMASKF
        #pragma shader_feature_local _ _WETNESS_T_HEAT_F
        
        #if defined(_USEDYNAMICCOVERTSTATICMASKF) && defined(_WETNESS_T_HEAT_F)
            #define KEYWORD_PERMUTATION_0
        #elif defined(_USEDYNAMICCOVERTSTATICMASKF)
            #define KEYWORD_PERMUTATION_1
        #elif defined(_WETNESS_T_HEAT_F)
            #define KEYWORD_PERMUTATION_2
        #else
            #define KEYWORD_PERMUTATION_3
        #endif
        
        
        // Defines
        
        #define _NORMALMAP 1
        #define _NORMAL_DROPOFF_TS 1
        #define ATTRIBUTES_NEED_NORMAL
        #define ATTRIBUTES_NEED_TANGENT
        #define ATTRIBUTES_NEED_TEXCOORD0
        #define ATTRIBUTES_NEED_TEXCOORD3
        #define ATTRIBUTES_NEED_COLOR
        #define FEATURES_GRAPH_VERTEX_NORMAL_OUTPUT
        #define FEATURES_GRAPH_VERTEX_TANGENT_OUTPUT
        #define VARYINGS_NEED_POSITION_WS
        #define VARYINGS_NEED_NORMAL_WS
        #define VARYINGS_NEED_TANGENT_WS
        #define VARYINGS_NEED_TEXCOORD0
        #define VARYINGS_NEED_TEXCOORD3
        #define VARYINGS_NEED_COLOR
        #define FEATURES_GRAPH_VERTEX
        /* WARNING: $splice Could not find named fragment 'PassInstancing' */
        #define SHADERPASS SHADERPASS_DEPTHONLY
        #define USE_UNITY_CROSSFADE 1
        
        
        // custom interpolator pre-include
        /* WARNING: $splice Could not find named fragment 'sgci_CustomInterpolatorPreInclude' */
        
        // Includes
        #include_with_pragmas "Packages/com.unity.render-pipelines.universal/ShaderLibrary/DOTS.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Texture.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
        #include_with_pragmas "Packages/com.unity.render-pipelines.core/ShaderLibrary/FoveatedRenderingKeywords.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/FoveatedRendering.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Input.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/TextureStack.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/DebugMipmapStreamingMacros.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShaderPass.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/LODCrossFade.hlsl"
        
        // --------------------------------------------------
        // Structs and Packing
        
        // custom interpolators pre packing
        /* WARNING: $splice Could not find named fragment 'CustomInterpolatorPrePacking' */
        
        struct Attributes
        {
             float3 positionOS : POSITION;
             float3 normalOS : NORMAL;
             float4 tangentOS : TANGENT;
             float4 uv0 : TEXCOORD0;
             float4 uv3 : TEXCOORD3;
             float4 color : COLOR;
            #if UNITY_ANY_INSTANCING_ENABLED || defined(ATTRIBUTES_NEED_INSTANCEID)
             uint instanceID : INSTANCEID_SEMANTIC;
            #endif
        };
        struct Varyings
        {
             float4 positionCS : SV_POSITION;
             float3 positionWS;
             float3 normalWS;
             float4 tangentWS;
             float4 texCoord0;
             float4 texCoord3;
             float4 color;
            #if UNITY_ANY_INSTANCING_ENABLED || defined(VARYINGS_NEED_INSTANCEID)
             uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
             uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
             uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
             FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
        };
        struct SurfaceDescriptionInputs
        {
             float3 WorldSpaceNormal;
             float3 WorldSpaceTangent;
             float3 WorldSpaceBiTangent;
             float3 AbsoluteWorldSpacePosition;
             float4 uv0;
             float4 uv3;
             float4 VertexColor;
        };
        struct VertexDescriptionInputs
        {
             float3 ObjectSpaceNormal;
             float3 ObjectSpaceTangent;
             float3 ObjectSpacePosition;
        };
        struct PackedVaryings
        {
             float4 positionCS : SV_POSITION;
             float4 tangentWS : INTERP0;
             float4 texCoord0 : INTERP1;
             float4 texCoord3 : INTERP2;
             float4 color : INTERP3;
             float3 positionWS : INTERP4;
             float3 normalWS : INTERP5;
            #if UNITY_ANY_INSTANCING_ENABLED || defined(VARYINGS_NEED_INSTANCEID)
             uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
             uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
             uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
             FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
        };
        
        PackedVaryings PackVaryings (Varyings input)
        {
            PackedVaryings output;
            ZERO_INITIALIZE(PackedVaryings, output);
            output.positionCS = input.positionCS;
            output.tangentWS.xyzw = input.tangentWS;
            output.texCoord0.xyzw = input.texCoord0;
            output.texCoord3.xyzw = input.texCoord3;
            output.color.xyzw = input.color;
            output.positionWS.xyz = input.positionWS;
            output.normalWS.xyz = input.normalWS;
            #if UNITY_ANY_INSTANCING_ENABLED || defined(VARYINGS_NEED_INSTANCEID)
            output.instanceID = input.instanceID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            output.cullFace = input.cullFace;
            #endif
            return output;
        }
        
        Varyings UnpackVaryings (PackedVaryings input)
        {
            Varyings output;
            output.positionCS = input.positionCS;
            output.tangentWS = input.tangentWS.xyzw;
            output.texCoord0 = input.texCoord0.xyzw;
            output.texCoord3 = input.texCoord3.xyzw;
            output.color = input.color.xyzw;
            output.positionWS = input.positionWS.xyz;
            output.normalWS = input.normalWS.xyz;
            #if UNITY_ANY_INSTANCING_ENABLED || defined(VARYINGS_NEED_INSTANCEID)
            output.instanceID = input.instanceID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            output.cullFace = input.cullFace;
            #endif
            return output;
        }
        
        
        // --------------------------------------------------
        // Graph
        
        // Graph Properties
        CBUFFER_START(UnityPerMaterial)
        float _EmissionNoiseMultiply;
        float _EmissionNoisePower;
        float Emission_Noise_UV0_UV3;
        float _EmissionNoiseUsePlanarUV;
        float _BaseEmissionMaskTreshold;
        float _CoverEmissionMaskIntensivity;
        float _CoverEmissionMaskTreshold;
        float4 _RimColor;
        float _RimLightPower;
        float4 _Noise_TexelSize;
        float2 _NoiseSpeed;
        float _BaseEmissionMaskIntensivity;
        float4 _LavaEmissionColor;
        float4 _Emission_Noise_Tiling_and_Offset;
        float _Cover_Mask_A_Remap_Min;
        float _Cover_Mask_A_Remap_Max;
        float _HeightMin;
        float _HeightMax;
        float _HeightOffset;
        float _VertexColorBBlendStrenght;
        float _USECoverHeightT;
        float _AlphaCutoff;
        float4 _WetColor;
        float4 _BaseColor;
        float _USEBaseHeightT;
        float4 _BaseColorMap_TexelSize;
        float _BaseUsePlanarUV;
        float4 _BaseTilingOffset;
        float4 _BaseNormalMap_TexelSize;
        float _BaseNormalScale;
        float4 _BaseMaskMap_TexelSize;
        float _BaseMetallic;
        float _VertexColorGBlendStrenght;
        float _BaseAORemapMin;
        float _BaseAORemapMax;
        float _BaseSmoothnessRemapMin;
        float _BaseSmoothnessRemapMax;
        float4 _Masks_TexelSize;
        float _Cover_Amount;
        float _Cover_Amount_Grow_Speed;
        float _Cover_Max_Angle;
        float _Cover_Min_Height;
        float _Cover_Min_Height_Blending;
        float4 _CoverBaseColor;
        float4 _CoverBaseColorMap_TexelSize;
        float _CoverUsePlanarUV;
        float4 _CoverTilingOffset;
        float4 _CoverNormalMap_TexelSize;
        float _CoverNormalScale;
        float _CoverNormalBlendHardness;
        float _CoverHardness;
        float _CoverHeightMapMin;
        float _CoverHeightMapMax;
        float _CoverHeightMapOffset;
        float4 _CoverMaskMap_TexelSize;
        float _CoverMetallic;
        float _CoverAORemapMin;
        float _CoverAORemapMax;
        float _CoverSmoothnessRemapMin;
        float _CoverSmoothnessRemapMax;
        float4 _DetailMap_TexelSize;
        float4 _DetailTilingOffset;
        float _DetailAlbedoScale;
        float _DetailNormalScale;
        float _DetailSmoothnessScale;
        float _WetSmoothness;
        UNITY_TEXTURE_STREAMING_DEBUG_VARS;
        CBUFFER_END
        
        
        // Object and Global properties
        SAMPLER(SamplerState_Linear_Repeat);
        SAMPLER(SamplerState_Linear_Repeat_Aniso8);
        TEXTURE2D(_Noise);
        SAMPLER(sampler_Noise);
        TEXTURE2D(_BaseColorMap);
        SAMPLER(sampler_BaseColorMap);
        TEXTURE2D(_BaseNormalMap);
        SAMPLER(sampler_BaseNormalMap);
        TEXTURE2D(_BaseMaskMap);
        SAMPLER(sampler_BaseMaskMap);
        TEXTURE2D(_Masks);
        SAMPLER(sampler_Masks);
        TEXTURE2D(_CoverBaseColorMap);
        SAMPLER(sampler_CoverBaseColorMap);
        TEXTURE2D(_CoverNormalMap);
        SAMPLER(sampler_CoverNormalMap);
        TEXTURE2D(_CoverMaskMap);
        SAMPLER(sampler_CoverMaskMap);
        TEXTURE2D(_DetailMap);
        SAMPLER(sampler_DetailMap);
        
        // Graph Includes
        // GraphIncludes: <None>
        
        // -- Property used by ScenePickingPass
        #ifdef SCENEPICKINGPASS
        float4 _SelectionID;
        #endif
        
        // -- Properties used by SceneSelectionPass
        #ifdef SCENESELECTIONPASS
        int _ObjectId;
        int _PassValue;
        #endif
        
        // Graph Functions
        
        void Unity_Combine_float(float R, float G, float B, float A, out float4 RGBA, out float3 RGB, out float2 RG)
        {
            RGBA = float4(R, G, B, A);
            RGB = float3(R, G, B);
            RG = float2(R, G);
        }
        
        void Unity_Divide_float(float A, float B, out float Out)
        {
            Out = A / B;
        }
        
        void Unity_Multiply_float4_float4(float4 A, float4 B, out float4 Out)
        {
        Out = A * B;
        }
        
        void Unity_Branch_float4(float Predicate, float4 True, float4 False, out float4 Out)
        {
            Out = Predicate ? True : False;
        }
        
        void Unity_TilingAndOffset_float(float2 UV, float2 Tiling, float2 Offset, out float2 Out)
        {
            Out = UV * Tiling + Offset;
        }
        
        void Unity_Branch_float2(float Predicate, float2 True, float2 False, out float2 Out)
        {
            Out = Predicate ? True : False;
        }
        
        struct Bindings_PlanarNM_c0f081da9c567704ea36e7dd38cedcf6_float
        {
        float3 AbsoluteWorldSpacePosition;
        half4 uv0;
        half4 uv3;
        };
        
        void SG_PlanarNM_c0f081da9c567704ea36e7dd38cedcf6_float(UnityTexture2D Texture2D_80A3D28F, float4 Vector4_2EBA7A3B, float Boolean_7ABB9909, UnitySamplerState _SamplerState, float Boolean_5ddfe6daabcc4715a44b5f34fc19becb, Bindings_PlanarNM_c0f081da9c567704ea36e7dd38cedcf6_float IN, out float4 XZ_2)
        {
        UnityTexture2D _Property_3e01b4d2fc68d48ba3acbba9d5881e59_Out_0_Texture2D = Texture2D_80A3D28F;
        float _Property_30834f691775a0898a45b1c868520436_Out_0_Boolean = Boolean_7ABB9909;
        float _Split_89ed63cb625cb3878c183d0b71c03400_R_1_Float = IN.AbsoluteWorldSpacePosition[0];
        float _Split_89ed63cb625cb3878c183d0b71c03400_G_2_Float = IN.AbsoluteWorldSpacePosition[1];
        float _Split_89ed63cb625cb3878c183d0b71c03400_B_3_Float = IN.AbsoluteWorldSpacePosition[2];
        float _Split_89ed63cb625cb3878c183d0b71c03400_A_4_Float = 0;
        float4 _Combine_cf2d04ff119ad88493f6460431765cbb_RGBA_4_Vector4;
        float3 _Combine_cf2d04ff119ad88493f6460431765cbb_RGB_5_Vector3;
        float2 _Combine_cf2d04ff119ad88493f6460431765cbb_RG_6_Vector2;
        Unity_Combine_float(_Split_89ed63cb625cb3878c183d0b71c03400_R_1_Float, _Split_89ed63cb625cb3878c183d0b71c03400_B_3_Float, float(0), float(0), _Combine_cf2d04ff119ad88493f6460431765cbb_RGBA_4_Vector4, _Combine_cf2d04ff119ad88493f6460431765cbb_RGB_5_Vector3, _Combine_cf2d04ff119ad88493f6460431765cbb_RG_6_Vector2);
        float4 _Property_8a66888ec47d0687ab1cb2f8abdc9da8_Out_0_Vector4 = Vector4_2EBA7A3B;
        float _Split_2f0f52f6ef8c0e81af0da6476402bc1f_R_1_Float = _Property_8a66888ec47d0687ab1cb2f8abdc9da8_Out_0_Vector4[0];
        float _Split_2f0f52f6ef8c0e81af0da6476402bc1f_G_2_Float = _Property_8a66888ec47d0687ab1cb2f8abdc9da8_Out_0_Vector4[1];
        float _Split_2f0f52f6ef8c0e81af0da6476402bc1f_B_3_Float = _Property_8a66888ec47d0687ab1cb2f8abdc9da8_Out_0_Vector4[2];
        float _Split_2f0f52f6ef8c0e81af0da6476402bc1f_A_4_Float = _Property_8a66888ec47d0687ab1cb2f8abdc9da8_Out_0_Vector4[3];
        float _Divide_e64179199923c58289b6aa94ea6c9178_Out_2_Float;
        Unity_Divide_float(float(1), _Split_2f0f52f6ef8c0e81af0da6476402bc1f_R_1_Float, _Divide_e64179199923c58289b6aa94ea6c9178_Out_2_Float);
        float4 _Multiply_14cec4902d0a00829e4555071a1b8ad1_Out_2_Vector4;
        Unity_Multiply_float4_float4(_Combine_cf2d04ff119ad88493f6460431765cbb_RGBA_4_Vector4, (_Divide_e64179199923c58289b6aa94ea6c9178_Out_2_Float.xxxx), _Multiply_14cec4902d0a00829e4555071a1b8ad1_Out_2_Vector4);
        float _Property_f17c7bf877e64b6abdd66b1fe9f5accc_Out_0_Boolean = Boolean_5ddfe6daabcc4715a44b5f34fc19becb;
        float4 _UV_029e8e8198564838b9389b902a09fb22_Out_0_Vector4 = IN.uv0;
        float4 _UV_7a6209af1506424fb75c81e87e42035a_Out_0_Vector4 = IN.uv3;
        float4 _Branch_fc37bb4bf641457cbbc6e290603056ff_Out_3_Vector4;
        Unity_Branch_float4(_Property_f17c7bf877e64b6abdd66b1fe9f5accc_Out_0_Boolean, _UV_029e8e8198564838b9389b902a09fb22_Out_0_Vector4, _UV_7a6209af1506424fb75c81e87e42035a_Out_0_Vector4, _Branch_fc37bb4bf641457cbbc6e290603056ff_Out_3_Vector4);
        float2 _Vector2_16c15d3bbdd14b85bd48e3a6cb318af7_Out_0_Vector2 = float2(_Split_2f0f52f6ef8c0e81af0da6476402bc1f_R_1_Float, _Split_2f0f52f6ef8c0e81af0da6476402bc1f_G_2_Float);
        float2 _Vector2_f8d75f54e7705083bbec539a60185577_Out_0_Vector2 = float2(_Split_2f0f52f6ef8c0e81af0da6476402bc1f_B_3_Float, _Split_2f0f52f6ef8c0e81af0da6476402bc1f_A_4_Float);
        float2 _TilingAndOffset_d91e2d25acd34686b562b7fe7e9d1d27_Out_3_Vector2;
        Unity_TilingAndOffset_float((_Branch_fc37bb4bf641457cbbc6e290603056ff_Out_3_Vector4.xy), _Vector2_16c15d3bbdd14b85bd48e3a6cb318af7_Out_0_Vector2, _Vector2_f8d75f54e7705083bbec539a60185577_Out_0_Vector2, _TilingAndOffset_d91e2d25acd34686b562b7fe7e9d1d27_Out_3_Vector2);
        float2 _Branch_8e5a4e8f4d52fc8aadd1f46485afc933_Out_3_Vector2;
        Unity_Branch_float2(_Property_30834f691775a0898a45b1c868520436_Out_0_Boolean, (_Multiply_14cec4902d0a00829e4555071a1b8ad1_Out_2_Vector4.xy), _TilingAndOffset_d91e2d25acd34686b562b7fe7e9d1d27_Out_3_Vector2, _Branch_8e5a4e8f4d52fc8aadd1f46485afc933_Out_3_Vector2);
        UnitySamplerState _Property_e8746b9475c94530ba35ba8019ad2ae0_Out_0_SamplerState = _SamplerState;
        float4 _SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_RGBA_0_Vector4 = SAMPLE_TEXTURE2D(_Property_3e01b4d2fc68d48ba3acbba9d5881e59_Out_0_Texture2D.tex, _Property_e8746b9475c94530ba35ba8019ad2ae0_Out_0_SamplerState.samplerstate, _Property_3e01b4d2fc68d48ba3acbba9d5881e59_Out_0_Texture2D.GetTransformedUV(_Branch_8e5a4e8f4d52fc8aadd1f46485afc933_Out_3_Vector2) );
        float _SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_R_4_Float = _SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_RGBA_0_Vector4.r;
        float _SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_G_5_Float = _SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_RGBA_0_Vector4.g;
        float _SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_B_6_Float = _SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_RGBA_0_Vector4.b;
        float _SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_A_7_Float = _SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_RGBA_0_Vector4.a;
        XZ_2 = _SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_RGBA_0_Vector4;
        }
        
        void Unity_ColorspaceConversion_Linear_RGB_float(float3 In, out float3 Out)
        {
            float3 sRGBLo = In * 12.92;
            float3 sRGBHi = (pow(max(abs(In), 1.192092896e-07), float3(1.0 / 2.4, 1.0 / 2.4, 1.0 / 2.4)) * 1.055) - 0.055;
            Out = float3(In <= 0.0031308) ? sRGBLo : sRGBHi;
        }
        
        void Unity_Blend_Overlay_float3(float3 Base, float3 Blend, out float3 Out, float Opacity)
        {
            float3 result1 = 1.0 - 2.0 * (1.0 - Base) * (1.0 - Blend);
            float3 result2 = 2.0 * Base * Blend;
            float3 zeroOrOne = step(Base, 0.5);
            Out = result2 * zeroOrOne + (1 - zeroOrOne) * result1;
            Out = lerp(Base, Out, Opacity);
        }
        
        void Unity_ColorspaceConversion_RGB_Linear_float(float3 In, out float3 Out)
        {
            float3 linearRGBLo = In / 12.92;
            float3 linearRGBHi = pow(max(abs((In + 0.055) / 1.055), 1.192092896e-07), float3(2.4, 2.4, 2.4));
            Out = float3(In <= 0.04045) ? linearRGBLo : linearRGBHi;
        }
        
        void Unity_Clamp_float3(float3 In, float3 Min, float3 Max, out float3 Out)
        {
            Out = clamp(In, Min, Max);
        }
        
        void Unity_Add_float2(float2 A, float2 B, out float2 Out)
        {
            Out = A + B;
        }
        
        void Unity_Remap_float(float In, float2 InMinMax, float2 OutMinMax, out float Out)
        {
            Out = OutMinMax.x + (In - InMinMax.x) * (OutMinMax.y - OutMinMax.x) / (InMinMax.y - InMinMax.x);
        }
        
        void Unity_Clamp_float(float In, float Min, float Max, out float Out)
        {
            Out = clamp(In, Min, Max);
        }
        
        void Unity_Multiply_float2_float2(float2 A, float2 B, out float2 Out)
        {
            Out = A * B;
        }
        
        void Unity_DotProduct_float2(float2 A, float2 B, out float Out)
        {
            Out = dot(A, B);
        }
        
        void Unity_Saturate_float(float In, out float Out)
        {
            Out = saturate(In);
        }
        
        void Unity_OneMinus_float(float In, out float Out)
        {
            Out = 1 - In;
        }
        
        void Unity_SquareRoot_float(float In, out float Out)
        {
            Out = sqrt(In);
        }
        
        void Unity_Sign_float3(float3 In, out float3 Out)
        {
            Out = sign(In);
        }
        
        void Unity_Multiply_float_float(float A, float B, out float Out)
        {
        Out = A * B;
        }
        
        void Unity_Normalize_float3(float3 In, out float3 Out)
        {
            Out = normalize(In);
        }
        
        void Unity_Branch_float3(float Predicate, float3 True, float3 False, out float3 Out)
        {
            Out = Predicate ? True : False;
        }
        
        struct Bindings_PlanarNMn_1b93a87456f9d4c419321d0cd92bd6c8_float
        {
        float3 WorldSpaceNormal;
        float3 WorldSpaceTangent;
        float3 WorldSpaceBiTangent;
        float3 AbsoluteWorldSpacePosition;
        half4 uv0;
        half4 uv3;
        };
        
        void SG_PlanarNMn_1b93a87456f9d4c419321d0cd92bd6c8_float(UnityTexture2D Texture2D_80A3D28F, float4 Vector4_82674548, float Boolean_9FF42DF6, UnitySamplerState _SamplerState, float Boolean_5ddfe6daabcc4715a44b5f34fc19becb, Bindings_PlanarNMn_1b93a87456f9d4c419321d0cd92bd6c8_float IN, out float4 XZ_2)
        {
        float _Property_1ef12cf3201a938993fe6a7951b0e754_Out_0_Boolean = Boolean_9FF42DF6;
        UnityTexture2D _Property_3e01b4d2fc68d48ba3acbba9d5881e59_Out_0_Texture2D = Texture2D_80A3D28F;
        float _Split_89ed63cb625cb3878c183d0b71c03400_R_1_Float = IN.AbsoluteWorldSpacePosition[0];
        float _Split_89ed63cb625cb3878c183d0b71c03400_G_2_Float = IN.AbsoluteWorldSpacePosition[1];
        float _Split_89ed63cb625cb3878c183d0b71c03400_B_3_Float = IN.AbsoluteWorldSpacePosition[2];
        float _Split_89ed63cb625cb3878c183d0b71c03400_A_4_Float = 0;
        float4 _Combine_cf2d04ff119ad88493f6460431765cbb_RGBA_4_Vector4;
        float3 _Combine_cf2d04ff119ad88493f6460431765cbb_RGB_5_Vector3;
        float2 _Combine_cf2d04ff119ad88493f6460431765cbb_RG_6_Vector2;
        Unity_Combine_float(_Split_89ed63cb625cb3878c183d0b71c03400_R_1_Float, _Split_89ed63cb625cb3878c183d0b71c03400_B_3_Float, float(0), float(0), _Combine_cf2d04ff119ad88493f6460431765cbb_RGBA_4_Vector4, _Combine_cf2d04ff119ad88493f6460431765cbb_RGB_5_Vector3, _Combine_cf2d04ff119ad88493f6460431765cbb_RG_6_Vector2);
        float4 _Property_3fa1d6f912feb481ba60f2e55e62e746_Out_0_Vector4 = Vector4_82674548;
        float _Split_a2e12fa5931da084b2949343a539dfd8_R_1_Float = _Property_3fa1d6f912feb481ba60f2e55e62e746_Out_0_Vector4[0];
        float _Split_a2e12fa5931da084b2949343a539dfd8_G_2_Float = _Property_3fa1d6f912feb481ba60f2e55e62e746_Out_0_Vector4[1];
        float _Split_a2e12fa5931da084b2949343a539dfd8_B_3_Float = _Property_3fa1d6f912feb481ba60f2e55e62e746_Out_0_Vector4[2];
        float _Split_a2e12fa5931da084b2949343a539dfd8_A_4_Float = _Property_3fa1d6f912feb481ba60f2e55e62e746_Out_0_Vector4[3];
        float _Divide_c36b770dfaa0bb8f85ab27da5fd794f0_Out_2_Float;
        Unity_Divide_float(float(1), _Split_a2e12fa5931da084b2949343a539dfd8_R_1_Float, _Divide_c36b770dfaa0bb8f85ab27da5fd794f0_Out_2_Float);
        float4 _Multiply_14cec4902d0a00829e4555071a1b8ad1_Out_2_Vector4;
        Unity_Multiply_float4_float4(_Combine_cf2d04ff119ad88493f6460431765cbb_RGBA_4_Vector4, (_Divide_c36b770dfaa0bb8f85ab27da5fd794f0_Out_2_Float.xxxx), _Multiply_14cec4902d0a00829e4555071a1b8ad1_Out_2_Vector4);
        float _Property_058f4fba88c3437288219f1929444bf2_Out_0_Boolean = Boolean_5ddfe6daabcc4715a44b5f34fc19becb;
        float4 _UV_43d85b3291324c848dfbeec6adac2a71_Out_0_Vector4 = IN.uv0;
        float4 _UV_36881dcaab9040168fc5215dcd00f352_Out_0_Vector4 = IN.uv3;
        float4 _Branch_8054d58a73be4ce1b22d48a84389ae07_Out_3_Vector4;
        Unity_Branch_float4(_Property_058f4fba88c3437288219f1929444bf2_Out_0_Boolean, _UV_43d85b3291324c848dfbeec6adac2a71_Out_0_Vector4, _UV_36881dcaab9040168fc5215dcd00f352_Out_0_Vector4, _Branch_8054d58a73be4ce1b22d48a84389ae07_Out_3_Vector4);
        float2 _Vector2_6845d21872714d889783b0cb707df3e9_Out_0_Vector2 = float2(_Split_a2e12fa5931da084b2949343a539dfd8_R_1_Float, _Split_a2e12fa5931da084b2949343a539dfd8_G_2_Float);
        float2 _Vector2_e2e2263627c6098e96a5b5d29350ad03_Out_0_Vector2 = float2(_Split_a2e12fa5931da084b2949343a539dfd8_B_3_Float, _Split_a2e12fa5931da084b2949343a539dfd8_A_4_Float);
        float2 _TilingAndOffset_17582d056c0b8a8dab1017d37497fe59_Out_3_Vector2;
        Unity_TilingAndOffset_float((_Branch_8054d58a73be4ce1b22d48a84389ae07_Out_3_Vector4.xy), _Vector2_6845d21872714d889783b0cb707df3e9_Out_0_Vector2, _Vector2_e2e2263627c6098e96a5b5d29350ad03_Out_0_Vector2, _TilingAndOffset_17582d056c0b8a8dab1017d37497fe59_Out_3_Vector2);
        float2 _Branch_1e152f3aac57448f8518bf2852c000c3_Out_3_Vector2;
        Unity_Branch_float2(_Property_1ef12cf3201a938993fe6a7951b0e754_Out_0_Boolean, (_Multiply_14cec4902d0a00829e4555071a1b8ad1_Out_2_Vector4.xy), _TilingAndOffset_17582d056c0b8a8dab1017d37497fe59_Out_3_Vector2, _Branch_1e152f3aac57448f8518bf2852c000c3_Out_3_Vector2);
        UnitySamplerState _Property_69f1ed7efd1b494e91f626b88ab2363c_Out_0_SamplerState = _SamplerState;
        float4 _SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_RGBA_0_Vector4 = SAMPLE_TEXTURE2D(_Property_3e01b4d2fc68d48ba3acbba9d5881e59_Out_0_Texture2D.tex, _Property_69f1ed7efd1b494e91f626b88ab2363c_Out_0_SamplerState.samplerstate, _Property_3e01b4d2fc68d48ba3acbba9d5881e59_Out_0_Texture2D.GetTransformedUV(_Branch_1e152f3aac57448f8518bf2852c000c3_Out_3_Vector2) );
        _SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_RGBA_0_Vector4.rgb = UnpackNormal(_SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_RGBA_0_Vector4);
        float _SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_R_4_Float = _SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_RGBA_0_Vector4.r;
        float _SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_G_5_Float = _SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_RGBA_0_Vector4.g;
        float _SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_B_6_Float = _SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_RGBA_0_Vector4.b;
        float _SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_A_7_Float = _SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_RGBA_0_Vector4.a;
        float2 _Vector2_ad6bd100e273d78fa409a30a77bfa2cc_Out_0_Vector2 = float2(_SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_R_4_Float, _SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_G_5_Float);
        float3 _Sign_3a6ebf59931cf08cb0482e0144ddac24_Out_1_Vector3;
        Unity_Sign_float3(IN.WorldSpaceNormal, _Sign_3a6ebf59931cf08cb0482e0144ddac24_Out_1_Vector3);
        float _Split_6299d4ddcc4c74828aea40a46fdb896e_R_1_Float = _Sign_3a6ebf59931cf08cb0482e0144ddac24_Out_1_Vector3[0];
        float _Split_6299d4ddcc4c74828aea40a46fdb896e_G_2_Float = _Sign_3a6ebf59931cf08cb0482e0144ddac24_Out_1_Vector3[1];
        float _Split_6299d4ddcc4c74828aea40a46fdb896e_B_3_Float = _Sign_3a6ebf59931cf08cb0482e0144ddac24_Out_1_Vector3[2];
        float _Split_6299d4ddcc4c74828aea40a46fdb896e_A_4_Float = 0;
        float2 _Vector2_b76cb1842101e58b9e636d49b075c612_Out_0_Vector2 = float2(_Split_6299d4ddcc4c74828aea40a46fdb896e_G_2_Float, float(1));
        float2 _Multiply_31e8db88ee20c985a9850d1a58f3282b_Out_2_Vector2;
        Unity_Multiply_float2_float2(_Vector2_ad6bd100e273d78fa409a30a77bfa2cc_Out_0_Vector2, _Vector2_b76cb1842101e58b9e636d49b075c612_Out_0_Vector2, _Multiply_31e8db88ee20c985a9850d1a58f3282b_Out_2_Vector2);
        float _Split_5ed44bf2eca0868f81eb18100f49d1fa_R_1_Float = IN.WorldSpaceNormal[0];
        float _Split_5ed44bf2eca0868f81eb18100f49d1fa_G_2_Float = IN.WorldSpaceNormal[1];
        float _Split_5ed44bf2eca0868f81eb18100f49d1fa_B_3_Float = IN.WorldSpaceNormal[2];
        float _Split_5ed44bf2eca0868f81eb18100f49d1fa_A_4_Float = 0;
        float2 _Vector2_70e5837843f28b8b9d64cada3697bd5a_Out_0_Vector2 = float2(_Split_5ed44bf2eca0868f81eb18100f49d1fa_R_1_Float, _Split_5ed44bf2eca0868f81eb18100f49d1fa_B_3_Float);
        float2 _Add_1145b2f896593d80aa864a34e6702562_Out_2_Vector2;
        Unity_Add_float2(_Multiply_31e8db88ee20c985a9850d1a58f3282b_Out_2_Vector2, _Vector2_70e5837843f28b8b9d64cada3697bd5a_Out_0_Vector2, _Add_1145b2f896593d80aa864a34e6702562_Out_2_Vector2);
        float _Split_2bc77ca2d17bd78cb2383770ce50b179_R_1_Float = _Add_1145b2f896593d80aa864a34e6702562_Out_2_Vector2[0];
        float _Split_2bc77ca2d17bd78cb2383770ce50b179_G_2_Float = _Add_1145b2f896593d80aa864a34e6702562_Out_2_Vector2[1];
        float _Split_2bc77ca2d17bd78cb2383770ce50b179_B_3_Float = 0;
        float _Split_2bc77ca2d17bd78cb2383770ce50b179_A_4_Float = 0;
        float _Multiply_ab12aea87465a78eaf7fc66c2598d266_Out_2_Float;
        Unity_Multiply_float_float(_SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_B_6_Float, _Split_5ed44bf2eca0868f81eb18100f49d1fa_G_2_Float, _Multiply_ab12aea87465a78eaf7fc66c2598d266_Out_2_Float);
        float3 _Vector3_433840b555db308b97e9b14b6a957195_Out_0_Vector3 = float3(_Split_2bc77ca2d17bd78cb2383770ce50b179_R_1_Float, _Multiply_ab12aea87465a78eaf7fc66c2598d266_Out_2_Float, _Split_2bc77ca2d17bd78cb2383770ce50b179_G_2_Float);
        float3 _Transform_c7914cc45a011c89b3f53c55afb51673_Out_1_Vector3;
        {
        float3x3 tangentTransform = float3x3(IN.WorldSpaceTangent, IN.WorldSpaceBiTangent, IN.WorldSpaceNormal);
        _Transform_c7914cc45a011c89b3f53c55afb51673_Out_1_Vector3 = TransformWorldToTangentDir(_Vector3_433840b555db308b97e9b14b6a957195_Out_0_Vector3.xyz, tangentTransform, true);
        }
        float3 _Clamp_3837949a36b5428a82af01e7bcd29952_Out_3_Vector3;
        Unity_Clamp_float3(_Transform_c7914cc45a011c89b3f53c55afb51673_Out_1_Vector3, float3(-1, -1, -1), float3(1, 1, 1), _Clamp_3837949a36b5428a82af01e7bcd29952_Out_3_Vector3);
        float3 _Normalize_09bf8a2bd0a4d38e8b97d5c674f79b44_Out_1_Vector3;
        Unity_Normalize_float3(_Clamp_3837949a36b5428a82af01e7bcd29952_Out_3_Vector3, _Normalize_09bf8a2bd0a4d38e8b97d5c674f79b44_Out_1_Vector3);
        float3 _Branch_9eadf909a90f2f80880f8c56ecc2a91f_Out_3_Vector3;
        Unity_Branch_float3(_Property_1ef12cf3201a938993fe6a7951b0e754_Out_0_Boolean, _Normalize_09bf8a2bd0a4d38e8b97d5c674f79b44_Out_1_Vector3, (_SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_RGBA_0_Vector4.xyz), _Branch_9eadf909a90f2f80880f8c56ecc2a91f_Out_3_Vector3);
        XZ_2 = (float4(_Branch_9eadf909a90f2f80880f8c56ecc2a91f_Out_3_Vector3, 1.0));
        }
        
        void Unity_NormalStrength_float(float3 In, float Strength, out float3 Out)
        {
            Out = float3(In.rg * Strength, lerp(1, In.b, saturate(Strength)));
        }
        
        void Unity_NormalBlend_Reoriented_float(float3 A, float3 B, out float3 Out)
        {
            float3 t = A.xyz + float3(0.0, 0.0, 1.0);
            float3 u = B.xyz * float3(-1.0, -1.0, 1.0);
            Out = (t / t.z) * dot(t, u) - u;
        }
        
        void Unity_Subtract_float(float A, float B, out float Out)
        {
            Out = A - B;
        }
        
        void Unity_Absolute_float(float In, out float Out)
        {
            Out = abs(In);
        }
        
        void Unity_Power_float(float A, float B, out float Out)
        {
            Out = pow(A, B);
        }
        
        void Unity_Add_float(float A, float B, out float Out)
        {
            Out = A + B;
        }
        
        void Unity_Lerp_float3(float3 A, float3 B, float3 T, out float3 Out)
        {
            Out = lerp(A, B, T);
        }
        
        void Unity_Comparison_Greater_float(float A, float B, out float Out)
        {
            Out = A > B ? 1 : 0;
        }
        
        void Unity_Branch_float(float Predicate, float True, float False, out float Out)
        {
            Out = Predicate ? True : False;
        }
        
        struct Bindings_UniversalHeighblend_3b5c31b864970d04197cd420b6c4b0fa_float
        {
        };
        
        void SG_UniversalHeighblend_3b5c31b864970d04197cd420b6c4b0fa_float(float _Vertex_Color, float _Blend_Hardness, float _Use_Layer_1_Height_T, float _Layer_1_Height, float2 _Layer_1_Before_Remap, float _Use_Layer_2_Height_T, float _Layer_2_Height, float2 _Layer_2_Before_Remap, float _Angle_Blend, Bindings_UniversalHeighblend_3b5c31b864970d04197cd420b6c4b0fa_float IN, out float Heightmap_1)
        {
        float _Property_b3ca7054ef0043de85912fc45d997ea2_Out_0_Float = _Vertex_Color;
        float _Clamp_852774a2be524975babf4eeb54af6d64_Out_3_Float;
        Unity_Clamp_float(_Property_b3ca7054ef0043de85912fc45d997ea2_Out_0_Float, float(0), float(1), _Clamp_852774a2be524975babf4eeb54af6d64_Out_3_Float);
        float _OneMinus_85e3550f37814cd3ab5ea5dde7f63a73_Out_1_Float;
        Unity_OneMinus_float(_Clamp_852774a2be524975babf4eeb54af6d64_Out_3_Float, _OneMinus_85e3550f37814cd3ab5ea5dde7f63a73_Out_1_Float);
        float _Comparison_5be6aeaa514b4921b5eb68269b58b028_Out_2_Boolean;
        Unity_Comparison_Greater_float(_OneMinus_85e3550f37814cd3ab5ea5dde7f63a73_Out_1_Float, float(0.99), _Comparison_5be6aeaa514b4921b5eb68269b58b028_Out_2_Boolean);
        float _Property_cfe724908035497c918d6d3f8dafe439_Out_0_Boolean = _Use_Layer_1_Height_T;
        float _Property_9634fd87d3374fdaa60181281a01f9b5_Out_0_Float = _Layer_1_Height;
        float2 _Property_e748f6c127e0479a9a01040378a4129b_Out_0_Vector2 = _Layer_1_Before_Remap;
        float _Split_cde172ab161d44cb81ea7874aec65560_R_1_Float = _Property_e748f6c127e0479a9a01040378a4129b_Out_0_Vector2[0];
        float _Split_cde172ab161d44cb81ea7874aec65560_G_2_Float = _Property_e748f6c127e0479a9a01040378a4129b_Out_0_Vector2[1];
        float _Split_cde172ab161d44cb81ea7874aec65560_B_3_Float = 0;
        float _Split_cde172ab161d44cb81ea7874aec65560_A_4_Float = 0;
        float _Subtract_e1e98a956721410caddfb467ae0eca8b_Out_2_Float;
        Unity_Subtract_float(_Split_cde172ab161d44cb81ea7874aec65560_R_1_Float, _Split_cde172ab161d44cb81ea7874aec65560_G_2_Float, _Subtract_e1e98a956721410caddfb467ae0eca8b_Out_2_Float);
        float _Clamp_ac4097026e6248dbb7a95fe910cc776e_Out_3_Float;
        Unity_Clamp_float(_OneMinus_85e3550f37814cd3ab5ea5dde7f63a73_Out_1_Float, float(0), float(1), _Clamp_ac4097026e6248dbb7a95fe910cc776e_Out_3_Float);
        float _Multiply_41691d316de74fef8a4ab5f63ed5474e_Out_2_Float;
        Unity_Multiply_float_float(_Subtract_e1e98a956721410caddfb467ae0eca8b_Out_2_Float, _Clamp_ac4097026e6248dbb7a95fe910cc776e_Out_3_Float, _Multiply_41691d316de74fef8a4ab5f63ed5474e_Out_2_Float);
        float2 _Add_48d37f8b8a464788860db14f0da8a66e_Out_2_Vector2;
        Unity_Add_float2(_Property_e748f6c127e0479a9a01040378a4129b_Out_0_Vector2, (_Multiply_41691d316de74fef8a4ab5f63ed5474e_Out_2_Float.xx), _Add_48d37f8b8a464788860db14f0da8a66e_Out_2_Vector2);
        float _Remap_21f3372608424df090026adc73778a39_Out_3_Float;
        Unity_Remap_float(_Property_9634fd87d3374fdaa60181281a01f9b5_Out_0_Float, float2 (0, 1), _Add_48d37f8b8a464788860db14f0da8a66e_Out_2_Vector2, _Remap_21f3372608424df090026adc73778a39_Out_3_Float);
        float _Clamp_8ea719b357b44537b42b2d05c22046f6_Out_3_Float;
        Unity_Clamp_float(_Remap_21f3372608424df090026adc73778a39_Out_3_Float, float(0), float(1), _Clamp_8ea719b357b44537b42b2d05c22046f6_Out_3_Float);
        float _Property_457e05a76c034ada998b3ff30a7781c3_Out_0_Boolean = _Use_Layer_2_Height_T;
        float _Property_9dfafa1ca8c94866a52535f412aff89a_Out_0_Float = _Angle_Blend;
        float _Property_b0e4a5720c374e2eb6f203a1bd075243_Out_0_Float = _Layer_2_Height;
        float _Multiply_00b31c7f720343caa4ded6df80a61899_Out_2_Float;
        Unity_Multiply_float_float(_Property_9dfafa1ca8c94866a52535f412aff89a_Out_0_Float, _Property_b0e4a5720c374e2eb6f203a1bd075243_Out_0_Float, _Multiply_00b31c7f720343caa4ded6df80a61899_Out_2_Float);
        float2 _Property_555a7734da754b989d8f80ef0bc86bea_Out_0_Vector2 = _Layer_2_Before_Remap;
        float _Split_bad56a0d03154ccc8cbfb53ea0e381d4_R_1_Float = _Property_555a7734da754b989d8f80ef0bc86bea_Out_0_Vector2[0];
        float _Split_bad56a0d03154ccc8cbfb53ea0e381d4_G_2_Float = _Property_555a7734da754b989d8f80ef0bc86bea_Out_0_Vector2[1];
        float _Split_bad56a0d03154ccc8cbfb53ea0e381d4_B_3_Float = 0;
        float _Split_bad56a0d03154ccc8cbfb53ea0e381d4_A_4_Float = 0;
        float _Subtract_2a7908018c384526a00494520503a83d_Out_2_Float;
        Unity_Subtract_float(_Split_bad56a0d03154ccc8cbfb53ea0e381d4_R_1_Float, _Split_bad56a0d03154ccc8cbfb53ea0e381d4_G_2_Float, _Subtract_2a7908018c384526a00494520503a83d_Out_2_Float);
        float _Multiply_417d72157b5f4930aed43775db746964_Out_2_Float;
        Unity_Multiply_float_float(_Subtract_2a7908018c384526a00494520503a83d_Out_2_Float, _Clamp_ac4097026e6248dbb7a95fe910cc776e_Out_3_Float, _Multiply_417d72157b5f4930aed43775db746964_Out_2_Float);
        float2 _Add_3d7e111e917c44e8a6800ce926fac67d_Out_2_Vector2;
        Unity_Add_float2((_Multiply_417d72157b5f4930aed43775db746964_Out_2_Float.xx), _Property_555a7734da754b989d8f80ef0bc86bea_Out_0_Vector2, _Add_3d7e111e917c44e8a6800ce926fac67d_Out_2_Vector2);
        float _Remap_931f83440e6c4c1588456788f84cbd9a_Out_3_Float;
        Unity_Remap_float(_Multiply_00b31c7f720343caa4ded6df80a61899_Out_2_Float, float2 (0, 1), _Add_3d7e111e917c44e8a6800ce926fac67d_Out_2_Vector2, _Remap_931f83440e6c4c1588456788f84cbd9a_Out_3_Float);
        float _Branch_a840aba5bca34588a2665f9794c96c38_Out_3_Float;
        Unity_Branch_float(_Property_457e05a76c034ada998b3ff30a7781c3_Out_0_Boolean, _Remap_931f83440e6c4c1588456788f84cbd9a_Out_3_Float, _Property_9dfafa1ca8c94866a52535f412aff89a_Out_0_Float, _Branch_a840aba5bca34588a2665f9794c96c38_Out_3_Float);
        float _Clamp_b1fe959daf444bf99c57756b8be77768_Out_3_Float;
        Unity_Clamp_float(_Branch_a840aba5bca34588a2665f9794c96c38_Out_3_Float, float(0), float(1), _Clamp_b1fe959daf444bf99c57756b8be77768_Out_3_Float);
        float _Multiply_c045ae9912ac409b9734c687968d47f6_Out_2_Float;
        Unity_Multiply_float_float(_Clamp_8ea719b357b44537b42b2d05c22046f6_Out_3_Float, _Clamp_b1fe959daf444bf99c57756b8be77768_Out_3_Float, _Multiply_c045ae9912ac409b9734c687968d47f6_Out_2_Float);
        float _Branch_5198cfc0a080466e93cf89aea61886e6_Out_3_Float;
        Unity_Branch_float(_Property_cfe724908035497c918d6d3f8dafe439_Out_0_Boolean, _Multiply_c045ae9912ac409b9734c687968d47f6_Out_2_Float, _Clamp_b1fe959daf444bf99c57756b8be77768_Out_3_Float, _Branch_5198cfc0a080466e93cf89aea61886e6_Out_3_Float);
        float _Saturate_ceafe30b0bae4f45a2f2ec500925b553_Out_1_Float;
        Unity_Saturate_float(_Branch_5198cfc0a080466e93cf89aea61886e6_Out_3_Float, _Saturate_ceafe30b0bae4f45a2f2ec500925b553_Out_1_Float);
        float _Absolute_274083e3f9f645bfb86074d91f3b7c62_Out_1_Float;
        Unity_Absolute_float(_Saturate_ceafe30b0bae4f45a2f2ec500925b553_Out_1_Float, _Absolute_274083e3f9f645bfb86074d91f3b7c62_Out_1_Float);
        float _Property_c68e0b8a84a549a582d4723036344b0e_Out_0_Float = _Blend_Hardness;
        float _Power_c9d62a3092174d9cb5674d87bcb7b5c5_Out_2_Float;
        Unity_Power_float(_Absolute_274083e3f9f645bfb86074d91f3b7c62_Out_1_Float, _Property_c68e0b8a84a549a582d4723036344b0e_Out_0_Float, _Power_c9d62a3092174d9cb5674d87bcb7b5c5_Out_2_Float);
        float _Branch_2425ee869bde4930bb8f36a5273bdc33_Out_3_Float;
        Unity_Branch_float(_Comparison_5be6aeaa514b4921b5eb68269b58b028_Out_2_Boolean, float(0), _Power_c9d62a3092174d9cb5674d87bcb7b5c5_Out_2_Float, _Branch_2425ee869bde4930bb8f36a5273bdc33_Out_3_Float);
        float _Clamp_9a5c5cfe52824e248ea0a8e38c593d84_Out_3_Float;
        Unity_Clamp_float(_Branch_2425ee869bde4930bb8f36a5273bdc33_Out_3_Float, float(0), float(1), _Clamp_9a5c5cfe52824e248ea0a8e38c593d84_Out_3_Float);
        Heightmap_1 = _Clamp_9a5c5cfe52824e248ea0a8e38c593d84_Out_3_Float;
        }
        
        void Unity_Lerp_float4(float4 A, float4 B, float4 T, out float4 Out)
        {
            Out = lerp(A, B, T);
        }
        
        void Unity_Clamp_float4(float4 In, float4 Min, float4 Max, out float4 Out)
        {
            Out = clamp(In, Min, Max);
        }
        
        // Custom interpolators pre vertex
        /* WARNING: $splice Could not find named fragment 'CustomInterpolatorPreVertex' */
        
        // Graph Vertex
        struct VertexDescription
        {
            float3 Position;
            float3 Normal;
            float3 Tangent;
        };
        
        VertexDescription VertexDescriptionFunction(VertexDescriptionInputs IN)
        {
            VertexDescription description = (VertexDescription)0;
            description.Position = IN.ObjectSpacePosition;
            description.Normal = IN.ObjectSpaceNormal;
            description.Tangent = IN.ObjectSpaceTangent;
            return description;
        }
        
        // Custom interpolators, pre surface
        #ifdef FEATURES_GRAPH_VERTEX
        Varyings CustomInterpolatorPassThroughFunc(inout Varyings output, VertexDescription input)
        {
        return output;
        }
        #define CUSTOMINTERPOLATOR_VARYPASSTHROUGH_FUNC
        #endif
        
        // Graph Pixel
        struct SurfaceDescription
        {
            float Alpha;
            float AlphaClipThreshold;
        };
        
        SurfaceDescription SurfaceDescriptionFunction(SurfaceDescriptionInputs IN)
        {
            SurfaceDescription surface = (SurfaceDescription)0;
            UnityTexture2D _Property_821e07b38fd0a08d85c4dd6e5b6bbac9_Out_0_Texture2D = UnityBuildTexture2DStructNoScale(_BaseColorMap);
            float4 _Property_8ec0d512145619859d288abab740e3bf_Out_0_Vector4 = _BaseTilingOffset;
            float _Property_122c0f9ef0a1c4818a140c75e512abe4_Out_0_Boolean = _BaseUsePlanarUV;
            Bindings_PlanarNM_c0f081da9c567704ea36e7dd38cedcf6_float _PlanarNM_cb7ded32e6af3382bbe06b62977afab6;
            _PlanarNM_cb7ded32e6af3382bbe06b62977afab6.AbsoluteWorldSpacePosition = IN.AbsoluteWorldSpacePosition;
            _PlanarNM_cb7ded32e6af3382bbe06b62977afab6.uv0 = IN.uv0;
            _PlanarNM_cb7ded32e6af3382bbe06b62977afab6.uv3 = IN.uv3;
            float4 _PlanarNM_cb7ded32e6af3382bbe06b62977afab6_XZ_2_Vector4;
            SG_PlanarNM_c0f081da9c567704ea36e7dd38cedcf6_float(_Property_821e07b38fd0a08d85c4dd6e5b6bbac9_Out_0_Texture2D, _Property_8ec0d512145619859d288abab740e3bf_Out_0_Vector4, _Property_122c0f9ef0a1c4818a140c75e512abe4_Out_0_Boolean, UnityBuildSamplerStateStruct(SamplerState_Linear_Repeat_Aniso8), 1, _PlanarNM_cb7ded32e6af3382bbe06b62977afab6, _PlanarNM_cb7ded32e6af3382bbe06b62977afab6_XZ_2_Vector4);
            float4 _Property_41859d117584758eb8002ecc938f9bce_Out_0_Vector4 = _BaseColor;
            float4 _Multiply_4d0f82599060228a9092027fd43912c8_Out_2_Vector4;
            Unity_Multiply_float4_float4(_PlanarNM_cb7ded32e6af3382bbe06b62977afab6_XZ_2_Vector4, _Property_41859d117584758eb8002ecc938f9bce_Out_0_Vector4, _Multiply_4d0f82599060228a9092027fd43912c8_Out_2_Vector4);
            float3 _ColorspaceConversion_30c5042ef70343cd92056cde73cd3ecb_Out_1_Vector3;
            Unity_ColorspaceConversion_Linear_RGB_float((_Multiply_4d0f82599060228a9092027fd43912c8_Out_2_Vector4.xyz), _ColorspaceConversion_30c5042ef70343cd92056cde73cd3ecb_Out_1_Vector3);
            UnityTexture2D _Property_50403cc6b1e3998a82afc21c6a6332ae_Out_0_Texture2D = UnityBuildTexture2DStructNoScale(_DetailMap);
            float4 _Property_256e5676e1089881ae3214634430b140_Out_0_Vector4 = _DetailTilingOffset;
            float _Split_257d0b6ea953418d97fd7daa8128bf35_R_1_Float = _Property_256e5676e1089881ae3214634430b140_Out_0_Vector4[0];
            float _Split_257d0b6ea953418d97fd7daa8128bf35_G_2_Float = _Property_256e5676e1089881ae3214634430b140_Out_0_Vector4[1];
            float _Split_257d0b6ea953418d97fd7daa8128bf35_B_3_Float = _Property_256e5676e1089881ae3214634430b140_Out_0_Vector4[2];
            float _Split_257d0b6ea953418d97fd7daa8128bf35_A_4_Float = _Property_256e5676e1089881ae3214634430b140_Out_0_Vector4[3];
            float2 _Vector2_98295494172421878c7a16cb2baddf9a_Out_0_Vector2 = float2(_Split_257d0b6ea953418d97fd7daa8128bf35_R_1_Float, _Split_257d0b6ea953418d97fd7daa8128bf35_G_2_Float);
            float2 _Vector2_130e8faa59837a81a7506636fcb30b8a_Out_0_Vector2 = float2(_Split_257d0b6ea953418d97fd7daa8128bf35_B_3_Float, _Split_257d0b6ea953418d97fd7daa8128bf35_A_4_Float);
            float2 _TilingAndOffset_1dfb2b4859ec3680ad3a74cf8f1bc17b_Out_3_Vector2;
            Unity_TilingAndOffset_float(IN.uv0.xy, _Vector2_98295494172421878c7a16cb2baddf9a_Out_0_Vector2, _Vector2_130e8faa59837a81a7506636fcb30b8a_Out_0_Vector2, _TilingAndOffset_1dfb2b4859ec3680ad3a74cf8f1bc17b_Out_3_Vector2);
            float4 _SampleTexture2D_d8eb0186b9a0cd819cde65431b4ea5ea_RGBA_0_Vector4 = SAMPLE_TEXTURE2D(_Property_50403cc6b1e3998a82afc21c6a6332ae_Out_0_Texture2D.tex, UnityBuildSamplerStateStruct(SamplerState_Linear_Repeat_Aniso8).samplerstate, _Property_50403cc6b1e3998a82afc21c6a6332ae_Out_0_Texture2D.GetTransformedUV(_TilingAndOffset_1dfb2b4859ec3680ad3a74cf8f1bc17b_Out_3_Vector2) );
            float _SampleTexture2D_d8eb0186b9a0cd819cde65431b4ea5ea_R_4_Float = _SampleTexture2D_d8eb0186b9a0cd819cde65431b4ea5ea_RGBA_0_Vector4.r;
            float _SampleTexture2D_d8eb0186b9a0cd819cde65431b4ea5ea_G_5_Float = _SampleTexture2D_d8eb0186b9a0cd819cde65431b4ea5ea_RGBA_0_Vector4.g;
            float _SampleTexture2D_d8eb0186b9a0cd819cde65431b4ea5ea_B_6_Float = _SampleTexture2D_d8eb0186b9a0cd819cde65431b4ea5ea_RGBA_0_Vector4.b;
            float _SampleTexture2D_d8eb0186b9a0cd819cde65431b4ea5ea_A_7_Float = _SampleTexture2D_d8eb0186b9a0cd819cde65431b4ea5ea_RGBA_0_Vector4.a;
            float _Property_605f29777330a58ba88ac032e905433b_Out_0_Float = _DetailAlbedoScale;
            float3 _Blend_de85bf99257f4eb7bb321fd973539f10_Out_2_Vector3;
            Unity_Blend_Overlay_float3(_ColorspaceConversion_30c5042ef70343cd92056cde73cd3ecb_Out_1_Vector3, (_SampleTexture2D_d8eb0186b9a0cd819cde65431b4ea5ea_R_4_Float.xxx), _Blend_de85bf99257f4eb7bb321fd973539f10_Out_2_Vector3, _Property_605f29777330a58ba88ac032e905433b_Out_0_Float);
            float3 _ColorspaceConversion_635670d250654503b34efa53a99ba43e_Out_1_Vector3;
            Unity_ColorspaceConversion_RGB_Linear_float(_Blend_de85bf99257f4eb7bb321fd973539f10_Out_2_Vector3, _ColorspaceConversion_635670d250654503b34efa53a99ba43e_Out_1_Vector3);
            float3 _Clamp_8913f48f801c43c2879f2e1ce926507e_Out_3_Vector3;
            Unity_Clamp_float3(_ColorspaceConversion_635670d250654503b34efa53a99ba43e_Out_1_Vector3, float3(0, 0, 0), float3(1, 1, 1), _Clamp_8913f48f801c43c2879f2e1ce926507e_Out_3_Vector3);
            float _Split_ddfe447fbb7845e88cc5cfb8158b2248_R_1_Float = _Clamp_8913f48f801c43c2879f2e1ce926507e_Out_3_Vector3[0];
            float _Split_ddfe447fbb7845e88cc5cfb8158b2248_G_2_Float = _Clamp_8913f48f801c43c2879f2e1ce926507e_Out_3_Vector3[1];
            float _Split_ddfe447fbb7845e88cc5cfb8158b2248_B_3_Float = _Clamp_8913f48f801c43c2879f2e1ce926507e_Out_3_Vector3[2];
            float _Split_ddfe447fbb7845e88cc5cfb8158b2248_A_4_Float = 0;
            float _Split_6d7debfd2b20440e932d58108f8e7f75_R_1_Float = _Multiply_4d0f82599060228a9092027fd43912c8_Out_2_Vector4[0];
            float _Split_6d7debfd2b20440e932d58108f8e7f75_G_2_Float = _Multiply_4d0f82599060228a9092027fd43912c8_Out_2_Vector4[1];
            float _Split_6d7debfd2b20440e932d58108f8e7f75_B_3_Float = _Multiply_4d0f82599060228a9092027fd43912c8_Out_2_Vector4[2];
            float _Split_6d7debfd2b20440e932d58108f8e7f75_A_4_Float = _Multiply_4d0f82599060228a9092027fd43912c8_Out_2_Vector4[3];
            float4 _Combine_b0f28916143e4b94af6bec53f5328b52_RGBA_4_Vector4;
            float3 _Combine_b0f28916143e4b94af6bec53f5328b52_RGB_5_Vector3;
            float2 _Combine_b0f28916143e4b94af6bec53f5328b52_RG_6_Vector2;
            Unity_Combine_float(_Split_ddfe447fbb7845e88cc5cfb8158b2248_R_1_Float, _Split_ddfe447fbb7845e88cc5cfb8158b2248_G_2_Float, _Split_ddfe447fbb7845e88cc5cfb8158b2248_B_3_Float, _Split_6d7debfd2b20440e932d58108f8e7f75_A_4_Float, _Combine_b0f28916143e4b94af6bec53f5328b52_RGBA_4_Vector4, _Combine_b0f28916143e4b94af6bec53f5328b52_RGB_5_Vector3, _Combine_b0f28916143e4b94af6bec53f5328b52_RG_6_Vector2);
            UnityTexture2D _Property_a155ddc33ed90685a5ab0edcf158a343_Out_0_Texture2D = UnityBuildTexture2DStructNoScale(_CoverBaseColorMap);
            float4 _Property_256beda96caf2d8aa05d3de41fc08d3d_Out_0_Vector4 = _CoverTilingOffset;
            float _Property_bd9dfe8dd615798f9f2d72d139e56d61_Out_0_Boolean = _CoverUsePlanarUV;
            Bindings_PlanarNM_c0f081da9c567704ea36e7dd38cedcf6_float _PlanarNM_e00e057d3d7c4181b1c7775c6ebbab5b;
            _PlanarNM_e00e057d3d7c4181b1c7775c6ebbab5b.AbsoluteWorldSpacePosition = IN.AbsoluteWorldSpacePosition;
            _PlanarNM_e00e057d3d7c4181b1c7775c6ebbab5b.uv0 = IN.uv0;
            _PlanarNM_e00e057d3d7c4181b1c7775c6ebbab5b.uv3 = IN.uv3;
            float4 _PlanarNM_e00e057d3d7c4181b1c7775c6ebbab5b_XZ_2_Vector4;
            SG_PlanarNM_c0f081da9c567704ea36e7dd38cedcf6_float(_Property_a155ddc33ed90685a5ab0edcf158a343_Out_0_Texture2D, _Property_256beda96caf2d8aa05d3de41fc08d3d_Out_0_Vector4, _Property_bd9dfe8dd615798f9f2d72d139e56d61_Out_0_Boolean, UnityBuildSamplerStateStruct(SamplerState_Linear_Repeat_Aniso8), 1, _PlanarNM_e00e057d3d7c4181b1c7775c6ebbab5b, _PlanarNM_e00e057d3d7c4181b1c7775c6ebbab5b_XZ_2_Vector4);
            float4 _Property_c3be5593fd661b8dafbd04f26b8ec9ac_Out_0_Vector4 = _CoverBaseColor;
            float4 _Multiply_b08794693505bd8e8c04b9ba1610d394_Out_2_Vector4;
            Unity_Multiply_float4_float4(_PlanarNM_e00e057d3d7c4181b1c7775c6ebbab5b_XZ_2_Vector4, _Property_c3be5593fd661b8dafbd04f26b8ec9ac_Out_0_Vector4, _Multiply_b08794693505bd8e8c04b9ba1610d394_Out_2_Vector4);
            float _Split_a80936a3c75945efb8cf9f2b95c76642_R_1_Float = IN.VertexColor[0];
            float _Split_a80936a3c75945efb8cf9f2b95c76642_G_2_Float = IN.VertexColor[1];
            float _Split_a80936a3c75945efb8cf9f2b95c76642_B_3_Float = IN.VertexColor[2];
            float _Split_a80936a3c75945efb8cf9f2b95c76642_A_4_Float = IN.VertexColor[3];
            float _Property_14a6757619d64822a44a69b34f85276d_Out_0_Float = _VertexColorGBlendStrenght;
            float _Property_c0d9ffba7dee497c885a54170977d874_Out_0_Boolean = _USEBaseHeightT;
            UnityTexture2D _Property_bb9b47702e64ec8c8d8ad011fd521576_Out_0_Texture2D = UnityBuildTexture2DStructNoScale(_BaseMaskMap);
            Bindings_PlanarNM_c0f081da9c567704ea36e7dd38cedcf6_float _PlanarNM_e51306c84cde8e84a1fb06a45d8d037f;
            _PlanarNM_e51306c84cde8e84a1fb06a45d8d037f.AbsoluteWorldSpacePosition = IN.AbsoluteWorldSpacePosition;
            _PlanarNM_e51306c84cde8e84a1fb06a45d8d037f.uv0 = IN.uv0;
            _PlanarNM_e51306c84cde8e84a1fb06a45d8d037f.uv3 = IN.uv3;
            float4 _PlanarNM_e51306c84cde8e84a1fb06a45d8d037f_XZ_2_Vector4;
            SG_PlanarNM_c0f081da9c567704ea36e7dd38cedcf6_float(_Property_bb9b47702e64ec8c8d8ad011fd521576_Out_0_Texture2D, _Property_8ec0d512145619859d288abab740e3bf_Out_0_Vector4, _Property_122c0f9ef0a1c4818a140c75e512abe4_Out_0_Boolean, UnityBuildSamplerStateStruct(SamplerState_Linear_Repeat_Aniso8), 1, _PlanarNM_e51306c84cde8e84a1fb06a45d8d037f, _PlanarNM_e51306c84cde8e84a1fb06a45d8d037f_XZ_2_Vector4);
            float _Split_218e1cfd00b30984921b5fc0ec63de60_R_1_Float = _PlanarNM_e51306c84cde8e84a1fb06a45d8d037f_XZ_2_Vector4[0];
            float _Split_218e1cfd00b30984921b5fc0ec63de60_G_2_Float = _PlanarNM_e51306c84cde8e84a1fb06a45d8d037f_XZ_2_Vector4[1];
            float _Split_218e1cfd00b30984921b5fc0ec63de60_B_3_Float = _PlanarNM_e51306c84cde8e84a1fb06a45d8d037f_XZ_2_Vector4[2];
            float _Split_218e1cfd00b30984921b5fc0ec63de60_A_4_Float = _PlanarNM_e51306c84cde8e84a1fb06a45d8d037f_XZ_2_Vector4[3];
            float _Property_1d4a1a93707b42c3abf0baa799c514e5_Out_0_Float = _HeightMin;
            float _Property_8f4f3606868d4028a34c2a9a5a59f99d_Out_0_Float = _HeightMax;
            float2 _Vector2_721b6f4d7077463490b4504fe6c940bf_Out_0_Vector2 = float2(_Property_1d4a1a93707b42c3abf0baa799c514e5_Out_0_Float, _Property_8f4f3606868d4028a34c2a9a5a59f99d_Out_0_Float);
            float _Property_a1ae2f61da87421b9f3839691e9dd8af_Out_0_Float = _HeightOffset;
            float2 _Add_1f9ea9bdf36544b59f763806e7eea80d_Out_2_Vector2;
            Unity_Add_float2(_Vector2_721b6f4d7077463490b4504fe6c940bf_Out_0_Vector2, (_Property_a1ae2f61da87421b9f3839691e9dd8af_Out_0_Float.xx), _Add_1f9ea9bdf36544b59f763806e7eea80d_Out_2_Vector2);
            float _Property_0fbef18600294e199eeda9905e3304e4_Out_0_Boolean = _USECoverHeightT;
            UnityTexture2D _Property_3702de305e11e085a40d7731b582d541_Out_0_Texture2D = UnityBuildTexture2DStructNoScale(_CoverMaskMap);
            Bindings_PlanarNM_c0f081da9c567704ea36e7dd38cedcf6_float _PlanarNM_2217ca3c12141a8cb1e0c7235b369601;
            _PlanarNM_2217ca3c12141a8cb1e0c7235b369601.AbsoluteWorldSpacePosition = IN.AbsoluteWorldSpacePosition;
            _PlanarNM_2217ca3c12141a8cb1e0c7235b369601.uv0 = IN.uv0;
            _PlanarNM_2217ca3c12141a8cb1e0c7235b369601.uv3 = IN.uv3;
            float4 _PlanarNM_2217ca3c12141a8cb1e0c7235b369601_XZ_2_Vector4;
            SG_PlanarNM_c0f081da9c567704ea36e7dd38cedcf6_float(_Property_3702de305e11e085a40d7731b582d541_Out_0_Texture2D, _Property_256beda96caf2d8aa05d3de41fc08d3d_Out_0_Vector4, _Property_bd9dfe8dd615798f9f2d72d139e56d61_Out_0_Boolean, UnityBuildSamplerStateStruct(SamplerState_Linear_Repeat_Aniso8), 1, _PlanarNM_2217ca3c12141a8cb1e0c7235b369601, _PlanarNM_2217ca3c12141a8cb1e0c7235b369601_XZ_2_Vector4);
            float _Split_2f45bca363698c859e51492899bc58f8_R_1_Float = _PlanarNM_2217ca3c12141a8cb1e0c7235b369601_XZ_2_Vector4[0];
            float _Split_2f45bca363698c859e51492899bc58f8_G_2_Float = _PlanarNM_2217ca3c12141a8cb1e0c7235b369601_XZ_2_Vector4[1];
            float _Split_2f45bca363698c859e51492899bc58f8_B_3_Float = _PlanarNM_2217ca3c12141a8cb1e0c7235b369601_XZ_2_Vector4[2];
            float _Split_2f45bca363698c859e51492899bc58f8_A_4_Float = _PlanarNM_2217ca3c12141a8cb1e0c7235b369601_XZ_2_Vector4[3];
            float _Property_32b48052fdbb4641bf4eeb294bc65050_Out_0_Float = _CoverHeightMapMin;
            float _Property_0e120eb0a0a14b12a31a3c1f5b961121_Out_0_Float = _CoverHeightMapMax;
            float2 _Vector2_6955747f7f0a4ff98fae60dbada25e89_Out_0_Vector2 = float2(_Property_32b48052fdbb4641bf4eeb294bc65050_Out_0_Float, _Property_0e120eb0a0a14b12a31a3c1f5b961121_Out_0_Float);
            float _Property_6b467710b0ba48058e003aebe9119249_Out_0_Float = _CoverHeightMapOffset;
            float2 _Add_28628d641d58481084e9c00e4ad5fc8d_Out_2_Vector2;
            Unity_Add_float2(_Vector2_6955747f7f0a4ff98fae60dbada25e89_Out_0_Vector2, (_Property_6b467710b0ba48058e003aebe9119249_Out_0_Float.xx), _Add_28628d641d58481084e9c00e4ad5fc8d_Out_2_Vector2);
            UnityTexture2D _Property_7bea2d9dd5651a8bbbd61ecde71faa54_Out_0_Texture2D = UnityBuildTexture2DStructNoScale(_Masks);
            float4 _UV_429c95affe88aa8694076115c99a0769_Out_0_Vector4 = IN.uv0;
            float4 _SampleTexture2D_2723da80b8a2528381ef199c0415beae_RGBA_0_Vector4 = SAMPLE_TEXTURE2D(_Property_7bea2d9dd5651a8bbbd61ecde71faa54_Out_0_Texture2D.tex, UnityBuildSamplerStateStruct(SamplerState_Linear_Repeat_Aniso8).samplerstate, _Property_7bea2d9dd5651a8bbbd61ecde71faa54_Out_0_Texture2D.GetTransformedUV((_UV_429c95affe88aa8694076115c99a0769_Out_0_Vector4.xy)) );
            float _SampleTexture2D_2723da80b8a2528381ef199c0415beae_R_4_Float = _SampleTexture2D_2723da80b8a2528381ef199c0415beae_RGBA_0_Vector4.r;
            float _SampleTexture2D_2723da80b8a2528381ef199c0415beae_G_5_Float = _SampleTexture2D_2723da80b8a2528381ef199c0415beae_RGBA_0_Vector4.g;
            float _SampleTexture2D_2723da80b8a2528381ef199c0415beae_B_6_Float = _SampleTexture2D_2723da80b8a2528381ef199c0415beae_RGBA_0_Vector4.b;
            float _SampleTexture2D_2723da80b8a2528381ef199c0415beae_A_7_Float = _SampleTexture2D_2723da80b8a2528381ef199c0415beae_RGBA_0_Vector4.a;
            float _Property_7bea2851849541b28a2bc695d39a7606_Out_0_Float = _Cover_Mask_A_Remap_Min;
            float _Property_3be0ae138e414a5cb43d60264b1bcfeb_Out_0_Float = _Cover_Mask_A_Remap_Max;
            float2 _Vector2_44ac029de1e440a799fbdfadc778af0c_Out_0_Vector2 = float2(_Property_7bea2851849541b28a2bc695d39a7606_Out_0_Float, _Property_3be0ae138e414a5cb43d60264b1bcfeb_Out_0_Float);
            float _Remap_0c551a3055a54f16b85b519194883552_Out_3_Float;
            Unity_Remap_float(_SampleTexture2D_2723da80b8a2528381ef199c0415beae_A_7_Float, float2 (0, 1), _Vector2_44ac029de1e440a799fbdfadc778af0c_Out_0_Vector2, _Remap_0c551a3055a54f16b85b519194883552_Out_3_Float);
            float _Clamp_bb1427696ce14fe987f799fecc5f9fac_Out_3_Float;
            Unity_Clamp_float(_Remap_0c551a3055a54f16b85b519194883552_Out_3_Float, float(0), float(1), _Clamp_bb1427696ce14fe987f799fecc5f9fac_Out_3_Float);
            float2 _Vector2_0d28074858599a88940dfc8b57b9a60f_Out_0_Vector2 = float2(_SampleTexture2D_d8eb0186b9a0cd819cde65431b4ea5ea_A_7_Float, _SampleTexture2D_d8eb0186b9a0cd819cde65431b4ea5ea_G_5_Float);
            float2 _Multiply_fac8d94f82a53486bc0142a1e64b3d32_Out_2_Vector2;
            Unity_Multiply_float2_float2(_Vector2_0d28074858599a88940dfc8b57b9a60f_Out_0_Vector2, float2(2, 2), _Multiply_fac8d94f82a53486bc0142a1e64b3d32_Out_2_Vector2);
            float2 _Add_f0e6e847d8d8798ab3ca8c4d878bafc0_Out_2_Vector2;
            Unity_Add_float2(_Multiply_fac8d94f82a53486bc0142a1e64b3d32_Out_2_Vector2, float2(-1, -1), _Add_f0e6e847d8d8798ab3ca8c4d878bafc0_Out_2_Vector2);
            float _Property_d0e8d8f7fd10f0829e8fd86c278c8226_Out_0_Float = _DetailNormalScale;
            float2 _Multiply_11f3dfc5283ea188ad9c83e552cf7e0f_Out_2_Vector2;
            Unity_Multiply_float2_float2(_Add_f0e6e847d8d8798ab3ca8c4d878bafc0_Out_2_Vector2, (_Property_d0e8d8f7fd10f0829e8fd86c278c8226_Out_0_Float.xx), _Multiply_11f3dfc5283ea188ad9c83e552cf7e0f_Out_2_Vector2);
            float _Split_c4822b8eaff9b185be7c059792345712_R_1_Float = _Multiply_11f3dfc5283ea188ad9c83e552cf7e0f_Out_2_Vector2[0];
            float _Split_c4822b8eaff9b185be7c059792345712_G_2_Float = _Multiply_11f3dfc5283ea188ad9c83e552cf7e0f_Out_2_Vector2[1];
            float _Split_c4822b8eaff9b185be7c059792345712_B_3_Float = 0;
            float _Split_c4822b8eaff9b185be7c059792345712_A_4_Float = 0;
            float _DotProduct_1a01939a143c548c8ccd7e8a04fe680d_Out_2_Float;
            Unity_DotProduct_float2(_Multiply_11f3dfc5283ea188ad9c83e552cf7e0f_Out_2_Vector2, _Multiply_11f3dfc5283ea188ad9c83e552cf7e0f_Out_2_Vector2, _DotProduct_1a01939a143c548c8ccd7e8a04fe680d_Out_2_Float);
            float _Saturate_bf3d57899db77f86a1689105ce6a373a_Out_1_Float;
            Unity_Saturate_float(_DotProduct_1a01939a143c548c8ccd7e8a04fe680d_Out_2_Float, _Saturate_bf3d57899db77f86a1689105ce6a373a_Out_1_Float);
            float _OneMinus_052960238cc4a18cb83109d2bcae6d09_Out_1_Float;
            Unity_OneMinus_float(_Saturate_bf3d57899db77f86a1689105ce6a373a_Out_1_Float, _OneMinus_052960238cc4a18cb83109d2bcae6d09_Out_1_Float);
            float _SquareRoot_d4f67288e4dbf5898bea492a70b89ab9_Out_1_Float;
            Unity_SquareRoot_float(_OneMinus_052960238cc4a18cb83109d2bcae6d09_Out_1_Float, _SquareRoot_d4f67288e4dbf5898bea492a70b89ab9_Out_1_Float);
            float3 _Vector3_1e56146bdd567884bb8d5ae769df4d29_Out_0_Vector3 = float3(_Split_c4822b8eaff9b185be7c059792345712_R_1_Float, _Split_c4822b8eaff9b185be7c059792345712_G_2_Float, _SquareRoot_d4f67288e4dbf5898bea492a70b89ab9_Out_1_Float);
            UnityTexture2D _Property_147b07430832c98eb0a470557ee61c5e_Out_0_Texture2D = UnityBuildTexture2DStructNoScale(_BaseNormalMap);
            Bindings_PlanarNMn_1b93a87456f9d4c419321d0cd92bd6c8_float _PlanarNMn_ecad9f1f260c6c8bbd0960b2a8976daf;
            _PlanarNMn_ecad9f1f260c6c8bbd0960b2a8976daf.WorldSpaceNormal = IN.WorldSpaceNormal;
            _PlanarNMn_ecad9f1f260c6c8bbd0960b2a8976daf.WorldSpaceTangent = IN.WorldSpaceTangent;
            _PlanarNMn_ecad9f1f260c6c8bbd0960b2a8976daf.WorldSpaceBiTangent = IN.WorldSpaceBiTangent;
            _PlanarNMn_ecad9f1f260c6c8bbd0960b2a8976daf.AbsoluteWorldSpacePosition = IN.AbsoluteWorldSpacePosition;
            _PlanarNMn_ecad9f1f260c6c8bbd0960b2a8976daf.uv0 = IN.uv0;
            _PlanarNMn_ecad9f1f260c6c8bbd0960b2a8976daf.uv3 = IN.uv3;
            float4 _PlanarNMn_ecad9f1f260c6c8bbd0960b2a8976daf_XZ_2_Vector4;
            SG_PlanarNMn_1b93a87456f9d4c419321d0cd92bd6c8_float(_Property_147b07430832c98eb0a470557ee61c5e_Out_0_Texture2D, _Property_8ec0d512145619859d288abab740e3bf_Out_0_Vector4, _Property_122c0f9ef0a1c4818a140c75e512abe4_Out_0_Boolean, UnityBuildSamplerStateStruct(SamplerState_Linear_Repeat_Aniso8), 1, _PlanarNMn_ecad9f1f260c6c8bbd0960b2a8976daf, _PlanarNMn_ecad9f1f260c6c8bbd0960b2a8976daf_XZ_2_Vector4);
            float _Property_72e436a108ad64868e46d548c585c5f3_Out_0_Float = _BaseNormalScale;
            float3 _NormalStrength_366affc5c8b42482a633d201ef52b9d6_Out_2_Vector3;
            Unity_NormalStrength_float((_PlanarNMn_ecad9f1f260c6c8bbd0960b2a8976daf_XZ_2_Vector4.xyz), _Property_72e436a108ad64868e46d548c585c5f3_Out_0_Float, _NormalStrength_366affc5c8b42482a633d201ef52b9d6_Out_2_Vector3);
            float3 _NormalBlend_9f531c87e2e45580b1d0f65f06c23526_Out_2_Vector3;
            Unity_NormalBlend_Reoriented_float(_Vector3_1e56146bdd567884bb8d5ae769df4d29_Out_0_Vector3, _NormalStrength_366affc5c8b42482a633d201ef52b9d6_Out_2_Vector3, _NormalBlend_9f531c87e2e45580b1d0f65f06c23526_Out_2_Vector3);
            UnityTexture2D _Property_d7e9139e0ac6718b89c610009c28a25a_Out_0_Texture2D = UnityBuildTexture2DStructNoScale(_CoverNormalMap);
            Bindings_PlanarNMn_1b93a87456f9d4c419321d0cd92bd6c8_float _PlanarNMn_690e893d26999680a5cea3604ed0ce16;
            _PlanarNMn_690e893d26999680a5cea3604ed0ce16.WorldSpaceNormal = IN.WorldSpaceNormal;
            _PlanarNMn_690e893d26999680a5cea3604ed0ce16.WorldSpaceTangent = IN.WorldSpaceTangent;
            _PlanarNMn_690e893d26999680a5cea3604ed0ce16.WorldSpaceBiTangent = IN.WorldSpaceBiTangent;
            _PlanarNMn_690e893d26999680a5cea3604ed0ce16.AbsoluteWorldSpacePosition = IN.AbsoluteWorldSpacePosition;
            _PlanarNMn_690e893d26999680a5cea3604ed0ce16.uv0 = IN.uv0;
            _PlanarNMn_690e893d26999680a5cea3604ed0ce16.uv3 = IN.uv3;
            float4 _PlanarNMn_690e893d26999680a5cea3604ed0ce16_XZ_2_Vector4;
            SG_PlanarNMn_1b93a87456f9d4c419321d0cd92bd6c8_float(_Property_d7e9139e0ac6718b89c610009c28a25a_Out_0_Texture2D, _Property_256beda96caf2d8aa05d3de41fc08d3d_Out_0_Vector4, _Property_bd9dfe8dd615798f9f2d72d139e56d61_Out_0_Boolean, UnityBuildSamplerStateStruct(SamplerState_Linear_Repeat_Aniso8), 1, _PlanarNMn_690e893d26999680a5cea3604ed0ce16, _PlanarNMn_690e893d26999680a5cea3604ed0ce16_XZ_2_Vector4);
            float _Property_0fd4d87ded104c829a6110c044eaa5f2_Out_0_Float = _CoverNormalBlendHardness;
            float3 _NormalStrength_c4639a6dd3dfde85b591971db2700eaf_Out_2_Vector3;
            Unity_NormalStrength_float((_PlanarNMn_690e893d26999680a5cea3604ed0ce16_XZ_2_Vector4.xyz), _Property_0fd4d87ded104c829a6110c044eaa5f2_Out_0_Float, _NormalStrength_c4639a6dd3dfde85b591971db2700eaf_Out_2_Vector3);
            float _Split_8ff22a6bdd437780ac7ea5963e1c5bb4_R_1_Float = IN.WorldSpaceNormal[0];
            float _Split_8ff22a6bdd437780ac7ea5963e1c5bb4_G_2_Float = IN.WorldSpaceNormal[1];
            float _Split_8ff22a6bdd437780ac7ea5963e1c5bb4_B_3_Float = IN.WorldSpaceNormal[2];
            float _Split_8ff22a6bdd437780ac7ea5963e1c5bb4_A_4_Float = 0;
            float _Property_28052b023ac35c8e9a95b30327681cc5_Out_0_Float = _Cover_Amount;
            float _Property_7749c0d5b28c14869ab3ba35d226788b_Out_0_Float = _Cover_Amount_Grow_Speed;
            float _Subtract_e5dc2afce7ff588fa1d4c91f78de7575_Out_2_Float;
            Unity_Subtract_float(float(4), _Property_7749c0d5b28c14869ab3ba35d226788b_Out_0_Float, _Subtract_e5dc2afce7ff588fa1d4c91f78de7575_Out_2_Float);
            float _Divide_c77b003bf1ce13828c94a705676e2b30_Out_2_Float;
            Unity_Divide_float(_Property_28052b023ac35c8e9a95b30327681cc5_Out_0_Float, _Subtract_e5dc2afce7ff588fa1d4c91f78de7575_Out_2_Float, _Divide_c77b003bf1ce13828c94a705676e2b30_Out_2_Float);
            float _Absolute_c7499cf07bdd0582abd82adbf367b0fc_Out_1_Float;
            Unity_Absolute_float(_Divide_c77b003bf1ce13828c94a705676e2b30_Out_2_Float, _Absolute_c7499cf07bdd0582abd82adbf367b0fc_Out_1_Float);
            float _Power_a9431dbce44a528f9ee7095adfa10556_Out_2_Float;
            Unity_Power_float(_Absolute_c7499cf07bdd0582abd82adbf367b0fc_Out_1_Float, _Subtract_e5dc2afce7ff588fa1d4c91f78de7575_Out_2_Float, _Power_a9431dbce44a528f9ee7095adfa10556_Out_2_Float);
            float _Clamp_815ffdd53cc1c889aa00f73784cb71e7_Out_3_Float;
            Unity_Clamp_float(_Power_a9431dbce44a528f9ee7095adfa10556_Out_2_Float, float(0), float(2), _Clamp_815ffdd53cc1c889aa00f73784cb71e7_Out_3_Float);
            float _Multiply_143da4886728ff868f10e9cfa6940ea0_Out_2_Float;
            Unity_Multiply_float_float(_Split_8ff22a6bdd437780ac7ea5963e1c5bb4_G_2_Float, _Clamp_815ffdd53cc1c889aa00f73784cb71e7_Out_3_Float, _Multiply_143da4886728ff868f10e9cfa6940ea0_Out_2_Float);
            float _Saturate_04686ab19029f68c8fb9e7a115b207b1_Out_1_Float;
            Unity_Saturate_float(_Multiply_143da4886728ff868f10e9cfa6940ea0_Out_2_Float, _Saturate_04686ab19029f68c8fb9e7a115b207b1_Out_1_Float);
            float _Clamp_9c0a88ffc7be288cbe97d3e13a014fe8_Out_3_Float;
            Unity_Clamp_float(_Split_8ff22a6bdd437780ac7ea5963e1c5bb4_G_2_Float, float(0), float(0.9999), _Clamp_9c0a88ffc7be288cbe97d3e13a014fe8_Out_3_Float);
            float _Property_58f42b34c7f0728f8c98e00a3e3a5726_Out_0_Float = _Cover_Max_Angle;
            float _Divide_b785767ecc1928889893fa60eac4e5fb_Out_2_Float;
            Unity_Divide_float(_Property_58f42b34c7f0728f8c98e00a3e3a5726_Out_0_Float, float(45), _Divide_b785767ecc1928889893fa60eac4e5fb_Out_2_Float);
            float _OneMinus_8e6f5b1570dc8c8b8afb036328281675_Out_1_Float;
            Unity_OneMinus_float(_Divide_b785767ecc1928889893fa60eac4e5fb_Out_2_Float, _OneMinus_8e6f5b1570dc8c8b8afb036328281675_Out_1_Float);
            float _Subtract_5348fb3702fea78d9ee10dbf81ede29c_Out_2_Float;
            Unity_Subtract_float(_Clamp_9c0a88ffc7be288cbe97d3e13a014fe8_Out_3_Float, _OneMinus_8e6f5b1570dc8c8b8afb036328281675_Out_1_Float, _Subtract_5348fb3702fea78d9ee10dbf81ede29c_Out_2_Float);
            float _Clamp_2b888688983edd82ac250226d9378893_Out_3_Float;
            Unity_Clamp_float(_Subtract_5348fb3702fea78d9ee10dbf81ede29c_Out_2_Float, float(0), float(2), _Clamp_2b888688983edd82ac250226d9378893_Out_3_Float);
            float _Divide_5615f16c20214d888a2e727ff7c5f5ff_Out_2_Float;
            Unity_Divide_float(float(1), _Divide_b785767ecc1928889893fa60eac4e5fb_Out_2_Float, _Divide_5615f16c20214d888a2e727ff7c5f5ff_Out_2_Float);
            float _Multiply_89aeffc0ad067981a18e6a77948b2b49_Out_2_Float;
            Unity_Multiply_float_float(_Clamp_2b888688983edd82ac250226d9378893_Out_3_Float, _Divide_5615f16c20214d888a2e727ff7c5f5ff_Out_2_Float, _Multiply_89aeffc0ad067981a18e6a77948b2b49_Out_2_Float);
            float _Absolute_b91ed8e326de8f88bf52e49cc5f641d4_Out_1_Float;
            Unity_Absolute_float(_Multiply_89aeffc0ad067981a18e6a77948b2b49_Out_2_Float, _Absolute_b91ed8e326de8f88bf52e49cc5f641d4_Out_1_Float);
            float _Property_4879e96694aee98c9d4ecd329a571123_Out_0_Float = _CoverHardness;
            float _Power_ca1f1906c90fb785bfe520b7faefc3cd_Out_2_Float;
            Unity_Power_float(_Absolute_b91ed8e326de8f88bf52e49cc5f641d4_Out_1_Float, _Property_4879e96694aee98c9d4ecd329a571123_Out_0_Float, _Power_ca1f1906c90fb785bfe520b7faefc3cd_Out_2_Float);
            float _Property_b66201e787ab7b83a55abc6ddd3fe1fd_Out_0_Float = _Cover_Min_Height;
            float _OneMinus_87c740d245de388db4fe5f4958de0668_Out_1_Float;
            Unity_OneMinus_float(_Property_b66201e787ab7b83a55abc6ddd3fe1fd_Out_0_Float, _OneMinus_87c740d245de388db4fe5f4958de0668_Out_1_Float);
            float _Split_ae16de7cacf9d0878aba1467f193d681_R_1_Float = IN.AbsoluteWorldSpacePosition[0];
            float _Split_ae16de7cacf9d0878aba1467f193d681_G_2_Float = IN.AbsoluteWorldSpacePosition[1];
            float _Split_ae16de7cacf9d0878aba1467f193d681_B_3_Float = IN.AbsoluteWorldSpacePosition[2];
            float _Split_ae16de7cacf9d0878aba1467f193d681_A_4_Float = 0;
            float _Add_9d6e1dd03919c88bb01e77a9a2b6b59c_Out_2_Float;
            Unity_Add_float(_OneMinus_87c740d245de388db4fe5f4958de0668_Out_1_Float, _Split_ae16de7cacf9d0878aba1467f193d681_G_2_Float, _Add_9d6e1dd03919c88bb01e77a9a2b6b59c_Out_2_Float);
            float _Add_448f30a2cd792b868416a253a1c502bb_Out_2_Float;
            Unity_Add_float(_Add_9d6e1dd03919c88bb01e77a9a2b6b59c_Out_2_Float, float(1), _Add_448f30a2cd792b868416a253a1c502bb_Out_2_Float);
            float _Clamp_53d91568d0627d8a9cac8deecdd003a8_Out_3_Float;
            Unity_Clamp_float(_Add_448f30a2cd792b868416a253a1c502bb_Out_2_Float, float(0), float(1), _Clamp_53d91568d0627d8a9cac8deecdd003a8_Out_3_Float);
            float _Property_98b8c0fc7e8f9b88b8d7d9dd28ed8aca_Out_0_Float = _Cover_Min_Height_Blending;
            float _Add_0edbe9f424de6d8089b453804bc6ec74_Out_2_Float;
            Unity_Add_float(_Add_9d6e1dd03919c88bb01e77a9a2b6b59c_Out_2_Float, _Property_98b8c0fc7e8f9b88b8d7d9dd28ed8aca_Out_0_Float, _Add_0edbe9f424de6d8089b453804bc6ec74_Out_2_Float);
            float _Divide_bacd243000beaa86b28174bd47716791_Out_2_Float;
            Unity_Divide_float(_Add_0edbe9f424de6d8089b453804bc6ec74_Out_2_Float, _Add_9d6e1dd03919c88bb01e77a9a2b6b59c_Out_2_Float, _Divide_bacd243000beaa86b28174bd47716791_Out_2_Float);
            float _OneMinus_dd51a0c56dbb9b8b8882c6d36bfadd50_Out_1_Float;
            Unity_OneMinus_float(_Divide_bacd243000beaa86b28174bd47716791_Out_2_Float, _OneMinus_dd51a0c56dbb9b8b8882c6d36bfadd50_Out_1_Float);
            float _Add_58dd4a9dfd5655818255c74dd17921da_Out_2_Float;
            Unity_Add_float(_OneMinus_dd51a0c56dbb9b8b8882c6d36bfadd50_Out_1_Float, float(-0.5), _Add_58dd4a9dfd5655818255c74dd17921da_Out_2_Float);
            float _Clamp_5b36f07b81ef6f87a93aefa8fcb815b4_Out_3_Float;
            Unity_Clamp_float(_Add_58dd4a9dfd5655818255c74dd17921da_Out_2_Float, float(0), float(1), _Clamp_5b36f07b81ef6f87a93aefa8fcb815b4_Out_3_Float);
            float _Add_5ef49a57de2cdf85b0e894bfa07f6f14_Out_2_Float;
            Unity_Add_float(_Clamp_53d91568d0627d8a9cac8deecdd003a8_Out_3_Float, _Clamp_5b36f07b81ef6f87a93aefa8fcb815b4_Out_3_Float, _Add_5ef49a57de2cdf85b0e894bfa07f6f14_Out_2_Float);
            float _Clamp_130844801cc2148bb64804d2328686eb_Out_3_Float;
            Unity_Clamp_float(_Add_5ef49a57de2cdf85b0e894bfa07f6f14_Out_2_Float, float(0), float(1), _Clamp_130844801cc2148bb64804d2328686eb_Out_3_Float);
            float _Multiply_4a38c41b77a2458085ff4ae52ba3c21c_Out_2_Float;
            Unity_Multiply_float_float(_Power_ca1f1906c90fb785bfe520b7faefc3cd_Out_2_Float, _Clamp_130844801cc2148bb64804d2328686eb_Out_3_Float, _Multiply_4a38c41b77a2458085ff4ae52ba3c21c_Out_2_Float);
            float _Multiply_edc44afd10069b8e80460ceee1cba8f0_Out_2_Float;
            Unity_Multiply_float_float(_Saturate_04686ab19029f68c8fb9e7a115b207b1_Out_1_Float, _Multiply_4a38c41b77a2458085ff4ae52ba3c21c_Out_2_Float, _Multiply_edc44afd10069b8e80460ceee1cba8f0_Out_2_Float);
            float3 _Lerp_05179f1a9a06b084b2d83e8bce908cce_Out_3_Vector3;
            Unity_Lerp_float3(_NormalBlend_9f531c87e2e45580b1d0f65f06c23526_Out_2_Vector3, _NormalStrength_c4639a6dd3dfde85b591971db2700eaf_Out_2_Vector3, (_Multiply_edc44afd10069b8e80460ceee1cba8f0_Out_2_Float.xxx), _Lerp_05179f1a9a06b084b2d83e8bce908cce_Out_3_Vector3);
            float3 _Transform_d583fb35b7a2838399ae5ff4e71be918_Out_1_Vector3;
            {
                float3x3 tangentTransform = float3x3(IN.WorldSpaceTangent, IN.WorldSpaceBiTangent, IN.WorldSpaceNormal);
                _Transform_d583fb35b7a2838399ae5ff4e71be918_Out_1_Vector3 = TransformTangentToWorldDir(_Lerp_05179f1a9a06b084b2d83e8bce908cce_Out_3_Vector3.xyz, tangentTransform, false).xyz;
            }
            float _Split_44ee9f8d0d54618cabce22ec49a8e7d3_R_1_Float = _Transform_d583fb35b7a2838399ae5ff4e71be918_Out_1_Vector3[0];
            float _Split_44ee9f8d0d54618cabce22ec49a8e7d3_G_2_Float = _Transform_d583fb35b7a2838399ae5ff4e71be918_Out_1_Vector3[1];
            float _Split_44ee9f8d0d54618cabce22ec49a8e7d3_B_3_Float = _Transform_d583fb35b7a2838399ae5ff4e71be918_Out_1_Vector3[2];
            float _Split_44ee9f8d0d54618cabce22ec49a8e7d3_A_4_Float = 0;
            float _Multiply_61fc6a92f0e952858b5d99f2caeb09a3_Out_2_Float;
            Unity_Multiply_float_float(_Split_44ee9f8d0d54618cabce22ec49a8e7d3_G_2_Float, _Clamp_815ffdd53cc1c889aa00f73784cb71e7_Out_3_Float, _Multiply_61fc6a92f0e952858b5d99f2caeb09a3_Out_2_Float);
            float _Multiply_1e7ca8eeb2afb68a96897072c537d835_Out_2_Float;
            Unity_Multiply_float_float(_Clamp_815ffdd53cc1c889aa00f73784cb71e7_Out_3_Float, _Property_4879e96694aee98c9d4ecd329a571123_Out_0_Float, _Multiply_1e7ca8eeb2afb68a96897072c537d835_Out_2_Float);
            float _Multiply_a16d49a3ef8d76899c86b7d84d20ef1f_Out_2_Float;
            Unity_Multiply_float_float(_Multiply_1e7ca8eeb2afb68a96897072c537d835_Out_2_Float, _Multiply_4a38c41b77a2458085ff4ae52ba3c21c_Out_2_Float, _Multiply_a16d49a3ef8d76899c86b7d84d20ef1f_Out_2_Float);
            float _Multiply_dd6ce40548593687a3441a83047275eb_Out_2_Float;
            Unity_Multiply_float_float(_Multiply_61fc6a92f0e952858b5d99f2caeb09a3_Out_2_Float, _Multiply_a16d49a3ef8d76899c86b7d84d20ef1f_Out_2_Float, _Multiply_dd6ce40548593687a3441a83047275eb_Out_2_Float);
            float _Clamp_a3bc14da42d1452f9459b4703c528466_Out_3_Float;
            Unity_Clamp_float(_Multiply_dd6ce40548593687a3441a83047275eb_Out_2_Float, float(0), float(1), _Clamp_a3bc14da42d1452f9459b4703c528466_Out_3_Float);
            float _Multiply_ce9d0ae57259445ba0ff1b83b3eac7be_Out_2_Float;
            Unity_Multiply_float_float(_Clamp_bb1427696ce14fe987f799fecc5f9fac_Out_3_Float, _Clamp_a3bc14da42d1452f9459b4703c528466_Out_3_Float, _Multiply_ce9d0ae57259445ba0ff1b83b3eac7be_Out_2_Float);
            #if defined(_USEDYNAMICCOVERTSTATICMASKF)
            float _UseDynamicCover_5ab22e0469924273a6c7c42f82abda85_Out_0_Float = _Multiply_ce9d0ae57259445ba0ff1b83b3eac7be_Out_2_Float;
            #else
            float _UseDynamicCover_5ab22e0469924273a6c7c42f82abda85_Out_0_Float = _Clamp_bb1427696ce14fe987f799fecc5f9fac_Out_3_Float;
            #endif
            Bindings_UniversalHeighblend_3b5c31b864970d04197cd420b6c4b0fa_float _UniversalHeighblend_21bd55d8d402489499f7ea440e52eb45;
            float _UniversalHeighblend_21bd55d8d402489499f7ea440e52eb45_Heightmap_1_Float;
            SG_UniversalHeighblend_3b5c31b864970d04197cd420b6c4b0fa_float(_Split_a80936a3c75945efb8cf9f2b95c76642_G_2_Float, _Property_14a6757619d64822a44a69b34f85276d_Out_0_Float, _Property_c0d9ffba7dee497c885a54170977d874_Out_0_Boolean, _Split_218e1cfd00b30984921b5fc0ec63de60_B_3_Float, _Add_1f9ea9bdf36544b59f763806e7eea80d_Out_2_Vector2, _Property_0fbef18600294e199eeda9905e3304e4_Out_0_Boolean, _Split_2f45bca363698c859e51492899bc58f8_B_3_Float, _Add_28628d641d58481084e9c00e4ad5fc8d_Out_2_Vector2, _UseDynamicCover_5ab22e0469924273a6c7c42f82abda85_Out_0_Float, _UniversalHeighblend_21bd55d8d402489499f7ea440e52eb45, _UniversalHeighblend_21bd55d8d402489499f7ea440e52eb45_Heightmap_1_Float);
            float _Split_05a25ef5bb1c4867950074f8c86410e8_R_1_Float = IN.VertexColor[0];
            float _Split_05a25ef5bb1c4867950074f8c86410e8_G_2_Float = IN.VertexColor[1];
            float _Split_05a25ef5bb1c4867950074f8c86410e8_B_3_Float = IN.VertexColor[2];
            float _Split_05a25ef5bb1c4867950074f8c86410e8_A_4_Float = IN.VertexColor[3];
            float _OneMinus_0527b7625ff14e8c8ca27817ac4fe9f9_Out_1_Float;
            Unity_OneMinus_float(_Split_05a25ef5bb1c4867950074f8c86410e8_B_3_Float, _OneMinus_0527b7625ff14e8c8ca27817ac4fe9f9_Out_1_Float);
            float _Property_defdd10d24ee4948b18af67062372fb7_Out_0_Float = _VertexColorBBlendStrenght;
            float _Property_f600c3fa0837403fa7000ace8a7aa949_Out_0_Boolean = _USEBaseHeightT;
            float _Property_cc1df5222a194b39870a1906a95881c7_Out_0_Boolean = _USECoverHeightT;
            float _Subtract_df32895ca10a49a6adc84378c30ceb7c_Out_2_Float;
            Unity_Subtract_float(_Property_0e120eb0a0a14b12a31a3c1f5b961121_Out_0_Float, _Property_32b48052fdbb4641bf4eeb294bc65050_Out_0_Float, _Subtract_df32895ca10a49a6adc84378c30ceb7c_Out_2_Float);
            float _Split_a090b28818f34dd8945b893c7fd769f1_R_1_Float = IN.VertexColor[0];
            float _Split_a090b28818f34dd8945b893c7fd769f1_G_2_Float = IN.VertexColor[1];
            float _Split_a090b28818f34dd8945b893c7fd769f1_B_3_Float = IN.VertexColor[2];
            float _Split_a090b28818f34dd8945b893c7fd769f1_A_4_Float = IN.VertexColor[3];
            float _OneMinus_d11f0c4a04b345419edf8e146b9c0221_Out_1_Float;
            Unity_OneMinus_float(_Split_a090b28818f34dd8945b893c7fd769f1_B_3_Float, _OneMinus_d11f0c4a04b345419edf8e146b9c0221_Out_1_Float);
            float _Multiply_b7ff184632b347e9b3d331daaed81a77_Out_2_Float;
            Unity_Multiply_float_float(_Subtract_df32895ca10a49a6adc84378c30ceb7c_Out_2_Float, _OneMinus_d11f0c4a04b345419edf8e146b9c0221_Out_1_Float, _Multiply_b7ff184632b347e9b3d331daaed81a77_Out_2_Float);
            float _Add_ff8ced5a04044788a5de3632a403c505_Out_2_Float;
            Unity_Add_float(_Property_6b467710b0ba48058e003aebe9119249_Out_0_Float, _Multiply_b7ff184632b347e9b3d331daaed81a77_Out_2_Float, _Add_ff8ced5a04044788a5de3632a403c505_Out_2_Float);
            float2 _Add_8ec067f807d04641bea7fd38ab0c8165_Out_2_Vector2;
            Unity_Add_float2(_Vector2_6955747f7f0a4ff98fae60dbada25e89_Out_0_Vector2, (_Add_ff8ced5a04044788a5de3632a403c505_Out_2_Float.xx), _Add_8ec067f807d04641bea7fd38ab0c8165_Out_2_Vector2);
            Bindings_UniversalHeighblend_3b5c31b864970d04197cd420b6c4b0fa_float _UniversalHeighblend_69e2f839a11b4aa7b8e84d65b0ac8307;
            float _UniversalHeighblend_69e2f839a11b4aa7b8e84d65b0ac8307_Heightmap_1_Float;
            SG_UniversalHeighblend_3b5c31b864970d04197cd420b6c4b0fa_float(_OneMinus_0527b7625ff14e8c8ca27817ac4fe9f9_Out_1_Float, _Property_defdd10d24ee4948b18af67062372fb7_Out_0_Float, _Property_f600c3fa0837403fa7000ace8a7aa949_Out_0_Boolean, _Split_218e1cfd00b30984921b5fc0ec63de60_B_3_Float, _Add_1f9ea9bdf36544b59f763806e7eea80d_Out_2_Vector2, _Property_cc1df5222a194b39870a1906a95881c7_Out_0_Boolean, _Split_2f45bca363698c859e51492899bc58f8_B_3_Float, _Add_8ec067f807d04641bea7fd38ab0c8165_Out_2_Vector2, float(1), _UniversalHeighblend_69e2f839a11b4aa7b8e84d65b0ac8307, _UniversalHeighblend_69e2f839a11b4aa7b8e84d65b0ac8307_Heightmap_1_Float);
            float _Add_facc0ab0661749d4bda41177c639b438_Out_2_Float;
            Unity_Add_float(_UniversalHeighblend_21bd55d8d402489499f7ea440e52eb45_Heightmap_1_Float, _UniversalHeighblend_69e2f839a11b4aa7b8e84d65b0ac8307_Heightmap_1_Float, _Add_facc0ab0661749d4bda41177c639b438_Out_2_Float);
            float _Saturate_269cfab86e2abe83819a3afa7b3eeda2_Out_1_Float;
            Unity_Saturate_float(_Add_facc0ab0661749d4bda41177c639b438_Out_2_Float, _Saturate_269cfab86e2abe83819a3afa7b3eeda2_Out_1_Float);
            float4 _Lerp_562b79f1df34b88e9a8a7431d434b435_Out_3_Vector4;
            Unity_Lerp_float4(_Combine_b0f28916143e4b94af6bec53f5328b52_RGBA_4_Vector4, _Multiply_b08794693505bd8e8c04b9ba1610d394_Out_2_Vector4, (_Saturate_269cfab86e2abe83819a3afa7b3eeda2_Out_1_Float.xxxx), _Lerp_562b79f1df34b88e9a8a7431d434b435_Out_3_Vector4);
            float _Split_546cdec490fe4753bb0983eea82b45b5_R_1_Float = _Lerp_562b79f1df34b88e9a8a7431d434b435_Out_3_Vector4[0];
            float _Split_546cdec490fe4753bb0983eea82b45b5_G_2_Float = _Lerp_562b79f1df34b88e9a8a7431d434b435_Out_3_Vector4[1];
            float _Split_546cdec490fe4753bb0983eea82b45b5_B_3_Float = _Lerp_562b79f1df34b88e9a8a7431d434b435_Out_3_Vector4[2];
            float _Split_546cdec490fe4753bb0983eea82b45b5_A_4_Float = _Lerp_562b79f1df34b88e9a8a7431d434b435_Out_3_Vector4[3];
            float4 _Clamp_33ec4dd182654e108c0f4ee43f91e820_Out_3_Vector4;
            Unity_Clamp_float4(IN.VertexColor, float4(0, 0, 0, 0), float4(1, 1, 1, 1), _Clamp_33ec4dd182654e108c0f4ee43f91e820_Out_3_Vector4);
            float _Split_5b2299b48b10138ea40c141b79bfe90e_R_1_Float = _Clamp_33ec4dd182654e108c0f4ee43f91e820_Out_3_Vector4[0];
            float _Split_5b2299b48b10138ea40c141b79bfe90e_G_2_Float = _Clamp_33ec4dd182654e108c0f4ee43f91e820_Out_3_Vector4[1];
            float _Split_5b2299b48b10138ea40c141b79bfe90e_B_3_Float = _Clamp_33ec4dd182654e108c0f4ee43f91e820_Out_3_Vector4[2];
            float _Split_5b2299b48b10138ea40c141b79bfe90e_A_4_Float = _Clamp_33ec4dd182654e108c0f4ee43f91e820_Out_3_Vector4[3];
            float _Multiply_a7796e97d268424b880f9cb87fc6e42c_Out_2_Float;
            Unity_Multiply_float_float(_Split_546cdec490fe4753bb0983eea82b45b5_A_4_Float, _Split_5b2299b48b10138ea40c141b79bfe90e_A_4_Float, _Multiply_a7796e97d268424b880f9cb87fc6e42c_Out_2_Float);
            float _Property_7ae68b65d6ed4f37aec08ecb89701e8e_Out_0_Float = _AlphaCutoff;
            surface.Alpha = _Multiply_a7796e97d268424b880f9cb87fc6e42c_Out_2_Float;
            surface.AlphaClipThreshold = _Property_7ae68b65d6ed4f37aec08ecb89701e8e_Out_0_Float;
            return surface;
        }
        
        // --------------------------------------------------
        // Build Graph Inputs
        #ifdef HAVE_VFX_MODIFICATION
        #define VFX_SRP_ATTRIBUTES Attributes
        #define VFX_SRP_VARYINGS Varyings
        #define VFX_SRP_SURFACE_INPUTS SurfaceDescriptionInputs
        #endif
        VertexDescriptionInputs BuildVertexDescriptionInputs(Attributes input)
        {
            VertexDescriptionInputs output;
            ZERO_INITIALIZE(VertexDescriptionInputs, output);
        
            output.ObjectSpaceNormal =                          input.normalOS;
            output.ObjectSpaceTangent =                         input.tangentOS.xyz;
            output.ObjectSpacePosition =                        input.positionOS;
        #if UNITY_ANY_INSTANCING_ENABLED
        #else // TODO: XR support for procedural instancing because in this case UNITY_ANY_INSTANCING_ENABLED is not defined and instanceID is incorrect.
        #endif
        
            return output;
        }
        SurfaceDescriptionInputs BuildSurfaceDescriptionInputs(Varyings input)
        {
            SurfaceDescriptionInputs output;
            ZERO_INITIALIZE(SurfaceDescriptionInputs, output);
        
        #ifdef HAVE_VFX_MODIFICATION
        #if VFX_USE_GRAPH_VALUES
            uint instanceActiveIndex = asuint(UNITY_ACCESS_INSTANCED_PROP(PerInstance, _InstanceActiveIndex));
            /* WARNING: $splice Could not find named fragment 'VFXLoadGraphValues' */
        #endif
            /* WARNING: $splice Could not find named fragment 'VFXSetFragInputs' */
        
        #endif
        
            
        
            // must use interpolated tangent, bitangent and normal before they are normalized in the pixel shader.
            float3 unnormalizedNormalWS = input.normalWS;
            const float renormFactor = 1.0 / length(unnormalizedNormalWS);
        
            // use bitangent on the fly like in hdrp
            // IMPORTANT! If we ever support Flip on double sided materials ensure bitangent and tangent are NOT flipped.
            float crossSign = (input.tangentWS.w > 0.0 ? 1.0 : -1.0)* GetOddNegativeScale();
            float3 bitang = crossSign * cross(input.normalWS.xyz, input.tangentWS.xyz);
        
            output.WorldSpaceNormal = renormFactor * input.normalWS.xyz;      // we want a unit length Normal Vector node in shader graph
        
            // to pr               eserve mikktspace compliance we use same scale renormFactor as was used on the normal.
            // This                is explained in section 2.2 in "surface gradient based bump mapping framework"
            output.WorldSpaceTangent = renormFactor * input.tangentWS.xyz;
            output.WorldSpaceBiTangent = renormFactor * bitang;
        
            output.AbsoluteWorldSpacePosition = GetAbsolutePositionWS(input.positionWS);
        
            #if UNITY_UV_STARTS_AT_TOP
            #else
            #endif
        
        
            output.uv0 = input.texCoord0;
            output.uv3 = input.texCoord3;
            output.VertexColor = input.color;
        #if UNITY_ANY_INSTANCING_ENABLED
        #else // TODO: XR support for procedural instancing because in this case UNITY_ANY_INSTANCING_ENABLED is not defined and instanceID is incorrect.
        #endif
        #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
        #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN output.FaceSign =                    IS_FRONT_VFACE(input.cullFace, true, false);
        #else
        #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
        #endif
        #undef BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
        
                return output;
        }
        
        // --------------------------------------------------
        // Main
        
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/Varyings.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/DepthOnlyPass.hlsl"
        
        // --------------------------------------------------
        // Visual Effect Vertex Invocations
        #ifdef HAVE_VFX_MODIFICATION
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/VisualEffectVertex.hlsl"
        #endif
        
        ENDHLSL
        }
        Pass
        {
            Name "DepthNormals"
            Tags
            {
                "LightMode" = "DepthNormals"
            }
        
        // Render State
        Cull [_Cull]
        ZTest LEqual
        ZWrite On
        
        // Debug
        // <None>
        
        // --------------------------------------------------
        // Pass
        
        HLSLPROGRAM
        
        // Pragmas
        #pragma target 2.0
        #pragma multi_compile_instancing
        #pragma vertex vert
        #pragma fragment frag
        
        // Keywords
        #pragma shader_feature_local_fragment _ _ALPHATEST_ON
        #pragma multi_compile _ LOD_FADE_CROSSFADE
        #pragma shader_feature_local _ _USEDYNAMICCOVERTSTATICMASKF
        #pragma shader_feature_local _ _WETNESS_T_HEAT_F
        
        #if defined(_USEDYNAMICCOVERTSTATICMASKF) && defined(_WETNESS_T_HEAT_F)
            #define KEYWORD_PERMUTATION_0
        #elif defined(_USEDYNAMICCOVERTSTATICMASKF)
            #define KEYWORD_PERMUTATION_1
        #elif defined(_WETNESS_T_HEAT_F)
            #define KEYWORD_PERMUTATION_2
        #else
            #define KEYWORD_PERMUTATION_3
        #endif
        
        
        // Defines
        
        #define _NORMALMAP 1
        #define _NORMAL_DROPOFF_TS 1
        #define ATTRIBUTES_NEED_NORMAL
        #define ATTRIBUTES_NEED_TANGENT
        #define ATTRIBUTES_NEED_TEXCOORD0
        #define ATTRIBUTES_NEED_TEXCOORD1
        #define ATTRIBUTES_NEED_TEXCOORD3
        #define ATTRIBUTES_NEED_COLOR
        #define FEATURES_GRAPH_VERTEX_NORMAL_OUTPUT
        #define FEATURES_GRAPH_VERTEX_TANGENT_OUTPUT
        #define VARYINGS_NEED_POSITION_WS
        #define VARYINGS_NEED_NORMAL_WS
        #define VARYINGS_NEED_TANGENT_WS
        #define VARYINGS_NEED_TEXCOORD0
        #define VARYINGS_NEED_TEXCOORD3
        #define VARYINGS_NEED_COLOR
        #define FEATURES_GRAPH_VERTEX
        /* WARNING: $splice Could not find named fragment 'PassInstancing' */
        #define SHADERPASS SHADERPASS_DEPTHNORMALS
        #define USE_UNITY_CROSSFADE 1
        
        
        // custom interpolator pre-include
        /* WARNING: $splice Could not find named fragment 'sgci_CustomInterpolatorPreInclude' */
        
        // Includes
        #include_with_pragmas "Packages/com.unity.render-pipelines.universal/ShaderLibrary/DOTS.hlsl"
        #include_with_pragmas "Packages/com.unity.render-pipelines.universal/ShaderLibrary/RenderingLayers.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Texture.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
        #include_with_pragmas "Packages/com.unity.render-pipelines.core/ShaderLibrary/FoveatedRenderingKeywords.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/FoveatedRendering.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Input.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/TextureStack.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/DebugMipmapStreamingMacros.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShaderPass.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/LODCrossFade.hlsl"
        
        // --------------------------------------------------
        // Structs and Packing
        
        // custom interpolators pre packing
        /* WARNING: $splice Could not find named fragment 'CustomInterpolatorPrePacking' */
        
        struct Attributes
        {
             float3 positionOS : POSITION;
             float3 normalOS : NORMAL;
             float4 tangentOS : TANGENT;
             float4 uv0 : TEXCOORD0;
             float4 uv1 : TEXCOORD1;
             float4 uv3 : TEXCOORD3;
             float4 color : COLOR;
            #if UNITY_ANY_INSTANCING_ENABLED || defined(ATTRIBUTES_NEED_INSTANCEID)
             uint instanceID : INSTANCEID_SEMANTIC;
            #endif
        };
        struct Varyings
        {
             float4 positionCS : SV_POSITION;
             float3 positionWS;
             float3 normalWS;
             float4 tangentWS;
             float4 texCoord0;
             float4 texCoord3;
             float4 color;
            #if UNITY_ANY_INSTANCING_ENABLED || defined(VARYINGS_NEED_INSTANCEID)
             uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
             uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
             uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
             FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
        };
        struct SurfaceDescriptionInputs
        {
             float3 WorldSpaceNormal;
             float3 TangentSpaceNormal;
             float3 WorldSpaceTangent;
             float3 WorldSpaceBiTangent;
             float3 AbsoluteWorldSpacePosition;
             float4 uv0;
             float4 uv3;
             float4 VertexColor;
        };
        struct VertexDescriptionInputs
        {
             float3 ObjectSpaceNormal;
             float3 ObjectSpaceTangent;
             float3 ObjectSpacePosition;
        };
        struct PackedVaryings
        {
             float4 positionCS : SV_POSITION;
             float4 tangentWS : INTERP0;
             float4 texCoord0 : INTERP1;
             float4 texCoord3 : INTERP2;
             float4 color : INTERP3;
             float3 positionWS : INTERP4;
             float3 normalWS : INTERP5;
            #if UNITY_ANY_INSTANCING_ENABLED || defined(VARYINGS_NEED_INSTANCEID)
             uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
             uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
             uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
             FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
        };
        
        PackedVaryings PackVaryings (Varyings input)
        {
            PackedVaryings output;
            ZERO_INITIALIZE(PackedVaryings, output);
            output.positionCS = input.positionCS;
            output.tangentWS.xyzw = input.tangentWS;
            output.texCoord0.xyzw = input.texCoord0;
            output.texCoord3.xyzw = input.texCoord3;
            output.color.xyzw = input.color;
            output.positionWS.xyz = input.positionWS;
            output.normalWS.xyz = input.normalWS;
            #if UNITY_ANY_INSTANCING_ENABLED || defined(VARYINGS_NEED_INSTANCEID)
            output.instanceID = input.instanceID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            output.cullFace = input.cullFace;
            #endif
            return output;
        }
        
        Varyings UnpackVaryings (PackedVaryings input)
        {
            Varyings output;
            output.positionCS = input.positionCS;
            output.tangentWS = input.tangentWS.xyzw;
            output.texCoord0 = input.texCoord0.xyzw;
            output.texCoord3 = input.texCoord3.xyzw;
            output.color = input.color.xyzw;
            output.positionWS = input.positionWS.xyz;
            output.normalWS = input.normalWS.xyz;
            #if UNITY_ANY_INSTANCING_ENABLED || defined(VARYINGS_NEED_INSTANCEID)
            output.instanceID = input.instanceID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            output.cullFace = input.cullFace;
            #endif
            return output;
        }
        
        
        // --------------------------------------------------
        // Graph
        
        // Graph Properties
        CBUFFER_START(UnityPerMaterial)
        float _EmissionNoiseMultiply;
        float _EmissionNoisePower;
        float Emission_Noise_UV0_UV3;
        float _EmissionNoiseUsePlanarUV;
        float _BaseEmissionMaskTreshold;
        float _CoverEmissionMaskIntensivity;
        float _CoverEmissionMaskTreshold;
        float4 _RimColor;
        float _RimLightPower;
        float4 _Noise_TexelSize;
        float2 _NoiseSpeed;
        float _BaseEmissionMaskIntensivity;
        float4 _LavaEmissionColor;
        float4 _Emission_Noise_Tiling_and_Offset;
        float _Cover_Mask_A_Remap_Min;
        float _Cover_Mask_A_Remap_Max;
        float _HeightMin;
        float _HeightMax;
        float _HeightOffset;
        float _VertexColorBBlendStrenght;
        float _USECoverHeightT;
        float _AlphaCutoff;
        float4 _WetColor;
        float4 _BaseColor;
        float _USEBaseHeightT;
        float4 _BaseColorMap_TexelSize;
        float _BaseUsePlanarUV;
        float4 _BaseTilingOffset;
        float4 _BaseNormalMap_TexelSize;
        float _BaseNormalScale;
        float4 _BaseMaskMap_TexelSize;
        float _BaseMetallic;
        float _VertexColorGBlendStrenght;
        float _BaseAORemapMin;
        float _BaseAORemapMax;
        float _BaseSmoothnessRemapMin;
        float _BaseSmoothnessRemapMax;
        float4 _Masks_TexelSize;
        float _Cover_Amount;
        float _Cover_Amount_Grow_Speed;
        float _Cover_Max_Angle;
        float _Cover_Min_Height;
        float _Cover_Min_Height_Blending;
        float4 _CoverBaseColor;
        float4 _CoverBaseColorMap_TexelSize;
        float _CoverUsePlanarUV;
        float4 _CoverTilingOffset;
        float4 _CoverNormalMap_TexelSize;
        float _CoverNormalScale;
        float _CoverNormalBlendHardness;
        float _CoverHardness;
        float _CoverHeightMapMin;
        float _CoverHeightMapMax;
        float _CoverHeightMapOffset;
        float4 _CoverMaskMap_TexelSize;
        float _CoverMetallic;
        float _CoverAORemapMin;
        float _CoverAORemapMax;
        float _CoverSmoothnessRemapMin;
        float _CoverSmoothnessRemapMax;
        float4 _DetailMap_TexelSize;
        float4 _DetailTilingOffset;
        float _DetailAlbedoScale;
        float _DetailNormalScale;
        float _DetailSmoothnessScale;
        float _WetSmoothness;
        UNITY_TEXTURE_STREAMING_DEBUG_VARS;
        CBUFFER_END
        
        
        // Object and Global properties
        SAMPLER(SamplerState_Linear_Repeat);
        SAMPLER(SamplerState_Linear_Repeat_Aniso8);
        TEXTURE2D(_Noise);
        SAMPLER(sampler_Noise);
        TEXTURE2D(_BaseColorMap);
        SAMPLER(sampler_BaseColorMap);
        TEXTURE2D(_BaseNormalMap);
        SAMPLER(sampler_BaseNormalMap);
        TEXTURE2D(_BaseMaskMap);
        SAMPLER(sampler_BaseMaskMap);
        TEXTURE2D(_Masks);
        SAMPLER(sampler_Masks);
        TEXTURE2D(_CoverBaseColorMap);
        SAMPLER(sampler_CoverBaseColorMap);
        TEXTURE2D(_CoverNormalMap);
        SAMPLER(sampler_CoverNormalMap);
        TEXTURE2D(_CoverMaskMap);
        SAMPLER(sampler_CoverMaskMap);
        TEXTURE2D(_DetailMap);
        SAMPLER(sampler_DetailMap);
        
        // Graph Includes
        // GraphIncludes: <None>
        
        // -- Property used by ScenePickingPass
        #ifdef SCENEPICKINGPASS
        float4 _SelectionID;
        #endif
        
        // -- Properties used by SceneSelectionPass
        #ifdef SCENESELECTIONPASS
        int _ObjectId;
        int _PassValue;
        #endif
        
        // Graph Functions
        
        void Unity_TilingAndOffset_float(float2 UV, float2 Tiling, float2 Offset, out float2 Out)
        {
            Out = UV * Tiling + Offset;
        }
        
        void Unity_Multiply_float2_float2(float2 A, float2 B, out float2 Out)
        {
            Out = A * B;
        }
        
        void Unity_Add_float2(float2 A, float2 B, out float2 Out)
        {
            Out = A + B;
        }
        
        void Unity_DotProduct_float2(float2 A, float2 B, out float Out)
        {
            Out = dot(A, B);
        }
        
        void Unity_Saturate_float(float In, out float Out)
        {
            Out = saturate(In);
        }
        
        void Unity_OneMinus_float(float In, out float Out)
        {
            Out = 1 - In;
        }
        
        void Unity_SquareRoot_float(float In, out float Out)
        {
            Out = sqrt(In);
        }
        
        void Unity_Combine_float(float R, float G, float B, float A, out float4 RGBA, out float3 RGB, out float2 RG)
        {
            RGBA = float4(R, G, B, A);
            RGB = float3(R, G, B);
            RG = float2(R, G);
        }
        
        void Unity_Divide_float(float A, float B, out float Out)
        {
            Out = A / B;
        }
        
        void Unity_Multiply_float4_float4(float4 A, float4 B, out float4 Out)
        {
        Out = A * B;
        }
        
        void Unity_Branch_float4(float Predicate, float4 True, float4 False, out float4 Out)
        {
            Out = Predicate ? True : False;
        }
        
        void Unity_Branch_float2(float Predicate, float2 True, float2 False, out float2 Out)
        {
            Out = Predicate ? True : False;
        }
        
        void Unity_Sign_float3(float3 In, out float3 Out)
        {
            Out = sign(In);
        }
        
        void Unity_Multiply_float_float(float A, float B, out float Out)
        {
        Out = A * B;
        }
        
        void Unity_Clamp_float3(float3 In, float3 Min, float3 Max, out float3 Out)
        {
            Out = clamp(In, Min, Max);
        }
        
        void Unity_Normalize_float3(float3 In, out float3 Out)
        {
            Out = normalize(In);
        }
        
        void Unity_Branch_float3(float Predicate, float3 True, float3 False, out float3 Out)
        {
            Out = Predicate ? True : False;
        }
        
        struct Bindings_PlanarNMn_1b93a87456f9d4c419321d0cd92bd6c8_float
        {
        float3 WorldSpaceNormal;
        float3 WorldSpaceTangent;
        float3 WorldSpaceBiTangent;
        float3 AbsoluteWorldSpacePosition;
        half4 uv0;
        half4 uv3;
        };
        
        void SG_PlanarNMn_1b93a87456f9d4c419321d0cd92bd6c8_float(UnityTexture2D Texture2D_80A3D28F, float4 Vector4_82674548, float Boolean_9FF42DF6, UnitySamplerState _SamplerState, float Boolean_5ddfe6daabcc4715a44b5f34fc19becb, Bindings_PlanarNMn_1b93a87456f9d4c419321d0cd92bd6c8_float IN, out float4 XZ_2)
        {
        float _Property_1ef12cf3201a938993fe6a7951b0e754_Out_0_Boolean = Boolean_9FF42DF6;
        UnityTexture2D _Property_3e01b4d2fc68d48ba3acbba9d5881e59_Out_0_Texture2D = Texture2D_80A3D28F;
        float _Split_89ed63cb625cb3878c183d0b71c03400_R_1_Float = IN.AbsoluteWorldSpacePosition[0];
        float _Split_89ed63cb625cb3878c183d0b71c03400_G_2_Float = IN.AbsoluteWorldSpacePosition[1];
        float _Split_89ed63cb625cb3878c183d0b71c03400_B_3_Float = IN.AbsoluteWorldSpacePosition[2];
        float _Split_89ed63cb625cb3878c183d0b71c03400_A_4_Float = 0;
        float4 _Combine_cf2d04ff119ad88493f6460431765cbb_RGBA_4_Vector4;
        float3 _Combine_cf2d04ff119ad88493f6460431765cbb_RGB_5_Vector3;
        float2 _Combine_cf2d04ff119ad88493f6460431765cbb_RG_6_Vector2;
        Unity_Combine_float(_Split_89ed63cb625cb3878c183d0b71c03400_R_1_Float, _Split_89ed63cb625cb3878c183d0b71c03400_B_3_Float, float(0), float(0), _Combine_cf2d04ff119ad88493f6460431765cbb_RGBA_4_Vector4, _Combine_cf2d04ff119ad88493f6460431765cbb_RGB_5_Vector3, _Combine_cf2d04ff119ad88493f6460431765cbb_RG_6_Vector2);
        float4 _Property_3fa1d6f912feb481ba60f2e55e62e746_Out_0_Vector4 = Vector4_82674548;
        float _Split_a2e12fa5931da084b2949343a539dfd8_R_1_Float = _Property_3fa1d6f912feb481ba60f2e55e62e746_Out_0_Vector4[0];
        float _Split_a2e12fa5931da084b2949343a539dfd8_G_2_Float = _Property_3fa1d6f912feb481ba60f2e55e62e746_Out_0_Vector4[1];
        float _Split_a2e12fa5931da084b2949343a539dfd8_B_3_Float = _Property_3fa1d6f912feb481ba60f2e55e62e746_Out_0_Vector4[2];
        float _Split_a2e12fa5931da084b2949343a539dfd8_A_4_Float = _Property_3fa1d6f912feb481ba60f2e55e62e746_Out_0_Vector4[3];
        float _Divide_c36b770dfaa0bb8f85ab27da5fd794f0_Out_2_Float;
        Unity_Divide_float(float(1), _Split_a2e12fa5931da084b2949343a539dfd8_R_1_Float, _Divide_c36b770dfaa0bb8f85ab27da5fd794f0_Out_2_Float);
        float4 _Multiply_14cec4902d0a00829e4555071a1b8ad1_Out_2_Vector4;
        Unity_Multiply_float4_float4(_Combine_cf2d04ff119ad88493f6460431765cbb_RGBA_4_Vector4, (_Divide_c36b770dfaa0bb8f85ab27da5fd794f0_Out_2_Float.xxxx), _Multiply_14cec4902d0a00829e4555071a1b8ad1_Out_2_Vector4);
        float _Property_058f4fba88c3437288219f1929444bf2_Out_0_Boolean = Boolean_5ddfe6daabcc4715a44b5f34fc19becb;
        float4 _UV_43d85b3291324c848dfbeec6adac2a71_Out_0_Vector4 = IN.uv0;
        float4 _UV_36881dcaab9040168fc5215dcd00f352_Out_0_Vector4 = IN.uv3;
        float4 _Branch_8054d58a73be4ce1b22d48a84389ae07_Out_3_Vector4;
        Unity_Branch_float4(_Property_058f4fba88c3437288219f1929444bf2_Out_0_Boolean, _UV_43d85b3291324c848dfbeec6adac2a71_Out_0_Vector4, _UV_36881dcaab9040168fc5215dcd00f352_Out_0_Vector4, _Branch_8054d58a73be4ce1b22d48a84389ae07_Out_3_Vector4);
        float2 _Vector2_6845d21872714d889783b0cb707df3e9_Out_0_Vector2 = float2(_Split_a2e12fa5931da084b2949343a539dfd8_R_1_Float, _Split_a2e12fa5931da084b2949343a539dfd8_G_2_Float);
        float2 _Vector2_e2e2263627c6098e96a5b5d29350ad03_Out_0_Vector2 = float2(_Split_a2e12fa5931da084b2949343a539dfd8_B_3_Float, _Split_a2e12fa5931da084b2949343a539dfd8_A_4_Float);
        float2 _TilingAndOffset_17582d056c0b8a8dab1017d37497fe59_Out_3_Vector2;
        Unity_TilingAndOffset_float((_Branch_8054d58a73be4ce1b22d48a84389ae07_Out_3_Vector4.xy), _Vector2_6845d21872714d889783b0cb707df3e9_Out_0_Vector2, _Vector2_e2e2263627c6098e96a5b5d29350ad03_Out_0_Vector2, _TilingAndOffset_17582d056c0b8a8dab1017d37497fe59_Out_3_Vector2);
        float2 _Branch_1e152f3aac57448f8518bf2852c000c3_Out_3_Vector2;
        Unity_Branch_float2(_Property_1ef12cf3201a938993fe6a7951b0e754_Out_0_Boolean, (_Multiply_14cec4902d0a00829e4555071a1b8ad1_Out_2_Vector4.xy), _TilingAndOffset_17582d056c0b8a8dab1017d37497fe59_Out_3_Vector2, _Branch_1e152f3aac57448f8518bf2852c000c3_Out_3_Vector2);
        UnitySamplerState _Property_69f1ed7efd1b494e91f626b88ab2363c_Out_0_SamplerState = _SamplerState;
        float4 _SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_RGBA_0_Vector4 = SAMPLE_TEXTURE2D(_Property_3e01b4d2fc68d48ba3acbba9d5881e59_Out_0_Texture2D.tex, _Property_69f1ed7efd1b494e91f626b88ab2363c_Out_0_SamplerState.samplerstate, _Property_3e01b4d2fc68d48ba3acbba9d5881e59_Out_0_Texture2D.GetTransformedUV(_Branch_1e152f3aac57448f8518bf2852c000c3_Out_3_Vector2) );
        _SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_RGBA_0_Vector4.rgb = UnpackNormal(_SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_RGBA_0_Vector4);
        float _SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_R_4_Float = _SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_RGBA_0_Vector4.r;
        float _SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_G_5_Float = _SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_RGBA_0_Vector4.g;
        float _SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_B_6_Float = _SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_RGBA_0_Vector4.b;
        float _SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_A_7_Float = _SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_RGBA_0_Vector4.a;
        float2 _Vector2_ad6bd100e273d78fa409a30a77bfa2cc_Out_0_Vector2 = float2(_SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_R_4_Float, _SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_G_5_Float);
        float3 _Sign_3a6ebf59931cf08cb0482e0144ddac24_Out_1_Vector3;
        Unity_Sign_float3(IN.WorldSpaceNormal, _Sign_3a6ebf59931cf08cb0482e0144ddac24_Out_1_Vector3);
        float _Split_6299d4ddcc4c74828aea40a46fdb896e_R_1_Float = _Sign_3a6ebf59931cf08cb0482e0144ddac24_Out_1_Vector3[0];
        float _Split_6299d4ddcc4c74828aea40a46fdb896e_G_2_Float = _Sign_3a6ebf59931cf08cb0482e0144ddac24_Out_1_Vector3[1];
        float _Split_6299d4ddcc4c74828aea40a46fdb896e_B_3_Float = _Sign_3a6ebf59931cf08cb0482e0144ddac24_Out_1_Vector3[2];
        float _Split_6299d4ddcc4c74828aea40a46fdb896e_A_4_Float = 0;
        float2 _Vector2_b76cb1842101e58b9e636d49b075c612_Out_0_Vector2 = float2(_Split_6299d4ddcc4c74828aea40a46fdb896e_G_2_Float, float(1));
        float2 _Multiply_31e8db88ee20c985a9850d1a58f3282b_Out_2_Vector2;
        Unity_Multiply_float2_float2(_Vector2_ad6bd100e273d78fa409a30a77bfa2cc_Out_0_Vector2, _Vector2_b76cb1842101e58b9e636d49b075c612_Out_0_Vector2, _Multiply_31e8db88ee20c985a9850d1a58f3282b_Out_2_Vector2);
        float _Split_5ed44bf2eca0868f81eb18100f49d1fa_R_1_Float = IN.WorldSpaceNormal[0];
        float _Split_5ed44bf2eca0868f81eb18100f49d1fa_G_2_Float = IN.WorldSpaceNormal[1];
        float _Split_5ed44bf2eca0868f81eb18100f49d1fa_B_3_Float = IN.WorldSpaceNormal[2];
        float _Split_5ed44bf2eca0868f81eb18100f49d1fa_A_4_Float = 0;
        float2 _Vector2_70e5837843f28b8b9d64cada3697bd5a_Out_0_Vector2 = float2(_Split_5ed44bf2eca0868f81eb18100f49d1fa_R_1_Float, _Split_5ed44bf2eca0868f81eb18100f49d1fa_B_3_Float);
        float2 _Add_1145b2f896593d80aa864a34e6702562_Out_2_Vector2;
        Unity_Add_float2(_Multiply_31e8db88ee20c985a9850d1a58f3282b_Out_2_Vector2, _Vector2_70e5837843f28b8b9d64cada3697bd5a_Out_0_Vector2, _Add_1145b2f896593d80aa864a34e6702562_Out_2_Vector2);
        float _Split_2bc77ca2d17bd78cb2383770ce50b179_R_1_Float = _Add_1145b2f896593d80aa864a34e6702562_Out_2_Vector2[0];
        float _Split_2bc77ca2d17bd78cb2383770ce50b179_G_2_Float = _Add_1145b2f896593d80aa864a34e6702562_Out_2_Vector2[1];
        float _Split_2bc77ca2d17bd78cb2383770ce50b179_B_3_Float = 0;
        float _Split_2bc77ca2d17bd78cb2383770ce50b179_A_4_Float = 0;
        float _Multiply_ab12aea87465a78eaf7fc66c2598d266_Out_2_Float;
        Unity_Multiply_float_float(_SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_B_6_Float, _Split_5ed44bf2eca0868f81eb18100f49d1fa_G_2_Float, _Multiply_ab12aea87465a78eaf7fc66c2598d266_Out_2_Float);
        float3 _Vector3_433840b555db308b97e9b14b6a957195_Out_0_Vector3 = float3(_Split_2bc77ca2d17bd78cb2383770ce50b179_R_1_Float, _Multiply_ab12aea87465a78eaf7fc66c2598d266_Out_2_Float, _Split_2bc77ca2d17bd78cb2383770ce50b179_G_2_Float);
        float3 _Transform_c7914cc45a011c89b3f53c55afb51673_Out_1_Vector3;
        {
        float3x3 tangentTransform = float3x3(IN.WorldSpaceTangent, IN.WorldSpaceBiTangent, IN.WorldSpaceNormal);
        _Transform_c7914cc45a011c89b3f53c55afb51673_Out_1_Vector3 = TransformWorldToTangentDir(_Vector3_433840b555db308b97e9b14b6a957195_Out_0_Vector3.xyz, tangentTransform, true);
        }
        float3 _Clamp_3837949a36b5428a82af01e7bcd29952_Out_3_Vector3;
        Unity_Clamp_float3(_Transform_c7914cc45a011c89b3f53c55afb51673_Out_1_Vector3, float3(-1, -1, -1), float3(1, 1, 1), _Clamp_3837949a36b5428a82af01e7bcd29952_Out_3_Vector3);
        float3 _Normalize_09bf8a2bd0a4d38e8b97d5c674f79b44_Out_1_Vector3;
        Unity_Normalize_float3(_Clamp_3837949a36b5428a82af01e7bcd29952_Out_3_Vector3, _Normalize_09bf8a2bd0a4d38e8b97d5c674f79b44_Out_1_Vector3);
        float3 _Branch_9eadf909a90f2f80880f8c56ecc2a91f_Out_3_Vector3;
        Unity_Branch_float3(_Property_1ef12cf3201a938993fe6a7951b0e754_Out_0_Boolean, _Normalize_09bf8a2bd0a4d38e8b97d5c674f79b44_Out_1_Vector3, (_SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_RGBA_0_Vector4.xyz), _Branch_9eadf909a90f2f80880f8c56ecc2a91f_Out_3_Vector3);
        XZ_2 = (float4(_Branch_9eadf909a90f2f80880f8c56ecc2a91f_Out_3_Vector3, 1.0));
        }
        
        void Unity_NormalStrength_float(float3 In, float Strength, out float3 Out)
        {
            Out = float3(In.rg * Strength, lerp(1, In.b, saturate(Strength)));
        }
        
        void Unity_NormalBlend_Reoriented_float(float3 A, float3 B, out float3 Out)
        {
            float3 t = A.xyz + float3(0.0, 0.0, 1.0);
            float3 u = B.xyz * float3(-1.0, -1.0, 1.0);
            Out = (t / t.z) * dot(t, u) - u;
        }
        
        struct Bindings_PlanarNM_c0f081da9c567704ea36e7dd38cedcf6_float
        {
        float3 AbsoluteWorldSpacePosition;
        half4 uv0;
        half4 uv3;
        };
        
        void SG_PlanarNM_c0f081da9c567704ea36e7dd38cedcf6_float(UnityTexture2D Texture2D_80A3D28F, float4 Vector4_2EBA7A3B, float Boolean_7ABB9909, UnitySamplerState _SamplerState, float Boolean_5ddfe6daabcc4715a44b5f34fc19becb, Bindings_PlanarNM_c0f081da9c567704ea36e7dd38cedcf6_float IN, out float4 XZ_2)
        {
        UnityTexture2D _Property_3e01b4d2fc68d48ba3acbba9d5881e59_Out_0_Texture2D = Texture2D_80A3D28F;
        float _Property_30834f691775a0898a45b1c868520436_Out_0_Boolean = Boolean_7ABB9909;
        float _Split_89ed63cb625cb3878c183d0b71c03400_R_1_Float = IN.AbsoluteWorldSpacePosition[0];
        float _Split_89ed63cb625cb3878c183d0b71c03400_G_2_Float = IN.AbsoluteWorldSpacePosition[1];
        float _Split_89ed63cb625cb3878c183d0b71c03400_B_3_Float = IN.AbsoluteWorldSpacePosition[2];
        float _Split_89ed63cb625cb3878c183d0b71c03400_A_4_Float = 0;
        float4 _Combine_cf2d04ff119ad88493f6460431765cbb_RGBA_4_Vector4;
        float3 _Combine_cf2d04ff119ad88493f6460431765cbb_RGB_5_Vector3;
        float2 _Combine_cf2d04ff119ad88493f6460431765cbb_RG_6_Vector2;
        Unity_Combine_float(_Split_89ed63cb625cb3878c183d0b71c03400_R_1_Float, _Split_89ed63cb625cb3878c183d0b71c03400_B_3_Float, float(0), float(0), _Combine_cf2d04ff119ad88493f6460431765cbb_RGBA_4_Vector4, _Combine_cf2d04ff119ad88493f6460431765cbb_RGB_5_Vector3, _Combine_cf2d04ff119ad88493f6460431765cbb_RG_6_Vector2);
        float4 _Property_8a66888ec47d0687ab1cb2f8abdc9da8_Out_0_Vector4 = Vector4_2EBA7A3B;
        float _Split_2f0f52f6ef8c0e81af0da6476402bc1f_R_1_Float = _Property_8a66888ec47d0687ab1cb2f8abdc9da8_Out_0_Vector4[0];
        float _Split_2f0f52f6ef8c0e81af0da6476402bc1f_G_2_Float = _Property_8a66888ec47d0687ab1cb2f8abdc9da8_Out_0_Vector4[1];
        float _Split_2f0f52f6ef8c0e81af0da6476402bc1f_B_3_Float = _Property_8a66888ec47d0687ab1cb2f8abdc9da8_Out_0_Vector4[2];
        float _Split_2f0f52f6ef8c0e81af0da6476402bc1f_A_4_Float = _Property_8a66888ec47d0687ab1cb2f8abdc9da8_Out_0_Vector4[3];
        float _Divide_e64179199923c58289b6aa94ea6c9178_Out_2_Float;
        Unity_Divide_float(float(1), _Split_2f0f52f6ef8c0e81af0da6476402bc1f_R_1_Float, _Divide_e64179199923c58289b6aa94ea6c9178_Out_2_Float);
        float4 _Multiply_14cec4902d0a00829e4555071a1b8ad1_Out_2_Vector4;
        Unity_Multiply_float4_float4(_Combine_cf2d04ff119ad88493f6460431765cbb_RGBA_4_Vector4, (_Divide_e64179199923c58289b6aa94ea6c9178_Out_2_Float.xxxx), _Multiply_14cec4902d0a00829e4555071a1b8ad1_Out_2_Vector4);
        float _Property_f17c7bf877e64b6abdd66b1fe9f5accc_Out_0_Boolean = Boolean_5ddfe6daabcc4715a44b5f34fc19becb;
        float4 _UV_029e8e8198564838b9389b902a09fb22_Out_0_Vector4 = IN.uv0;
        float4 _UV_7a6209af1506424fb75c81e87e42035a_Out_0_Vector4 = IN.uv3;
        float4 _Branch_fc37bb4bf641457cbbc6e290603056ff_Out_3_Vector4;
        Unity_Branch_float4(_Property_f17c7bf877e64b6abdd66b1fe9f5accc_Out_0_Boolean, _UV_029e8e8198564838b9389b902a09fb22_Out_0_Vector4, _UV_7a6209af1506424fb75c81e87e42035a_Out_0_Vector4, _Branch_fc37bb4bf641457cbbc6e290603056ff_Out_3_Vector4);
        float2 _Vector2_16c15d3bbdd14b85bd48e3a6cb318af7_Out_0_Vector2 = float2(_Split_2f0f52f6ef8c0e81af0da6476402bc1f_R_1_Float, _Split_2f0f52f6ef8c0e81af0da6476402bc1f_G_2_Float);
        float2 _Vector2_f8d75f54e7705083bbec539a60185577_Out_0_Vector2 = float2(_Split_2f0f52f6ef8c0e81af0da6476402bc1f_B_3_Float, _Split_2f0f52f6ef8c0e81af0da6476402bc1f_A_4_Float);
        float2 _TilingAndOffset_d91e2d25acd34686b562b7fe7e9d1d27_Out_3_Vector2;
        Unity_TilingAndOffset_float((_Branch_fc37bb4bf641457cbbc6e290603056ff_Out_3_Vector4.xy), _Vector2_16c15d3bbdd14b85bd48e3a6cb318af7_Out_0_Vector2, _Vector2_f8d75f54e7705083bbec539a60185577_Out_0_Vector2, _TilingAndOffset_d91e2d25acd34686b562b7fe7e9d1d27_Out_3_Vector2);
        float2 _Branch_8e5a4e8f4d52fc8aadd1f46485afc933_Out_3_Vector2;
        Unity_Branch_float2(_Property_30834f691775a0898a45b1c868520436_Out_0_Boolean, (_Multiply_14cec4902d0a00829e4555071a1b8ad1_Out_2_Vector4.xy), _TilingAndOffset_d91e2d25acd34686b562b7fe7e9d1d27_Out_3_Vector2, _Branch_8e5a4e8f4d52fc8aadd1f46485afc933_Out_3_Vector2);
        UnitySamplerState _Property_e8746b9475c94530ba35ba8019ad2ae0_Out_0_SamplerState = _SamplerState;
        float4 _SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_RGBA_0_Vector4 = SAMPLE_TEXTURE2D(_Property_3e01b4d2fc68d48ba3acbba9d5881e59_Out_0_Texture2D.tex, _Property_e8746b9475c94530ba35ba8019ad2ae0_Out_0_SamplerState.samplerstate, _Property_3e01b4d2fc68d48ba3acbba9d5881e59_Out_0_Texture2D.GetTransformedUV(_Branch_8e5a4e8f4d52fc8aadd1f46485afc933_Out_3_Vector2) );
        float _SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_R_4_Float = _SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_RGBA_0_Vector4.r;
        float _SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_G_5_Float = _SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_RGBA_0_Vector4.g;
        float _SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_B_6_Float = _SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_RGBA_0_Vector4.b;
        float _SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_A_7_Float = _SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_RGBA_0_Vector4.a;
        XZ_2 = _SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_RGBA_0_Vector4;
        }
        
        void Unity_Remap_float(float In, float2 InMinMax, float2 OutMinMax, out float Out)
        {
            Out = OutMinMax.x + (In - InMinMax.x) * (OutMinMax.y - OutMinMax.x) / (InMinMax.y - InMinMax.x);
        }
        
        void Unity_Clamp_float(float In, float Min, float Max, out float Out)
        {
            Out = clamp(In, Min, Max);
        }
        
        void Unity_Subtract_float(float A, float B, out float Out)
        {
            Out = A - B;
        }
        
        void Unity_Absolute_float(float In, out float Out)
        {
            Out = abs(In);
        }
        
        void Unity_Power_float(float A, float B, out float Out)
        {
            Out = pow(A, B);
        }
        
        void Unity_Add_float(float A, float B, out float Out)
        {
            Out = A + B;
        }
        
        void Unity_Lerp_float3(float3 A, float3 B, float3 T, out float3 Out)
        {
            Out = lerp(A, B, T);
        }
        
        void Unity_Comparison_Greater_float(float A, float B, out float Out)
        {
            Out = A > B ? 1 : 0;
        }
        
        void Unity_Branch_float(float Predicate, float True, float False, out float Out)
        {
            Out = Predicate ? True : False;
        }
        
        struct Bindings_UniversalHeighblend_3b5c31b864970d04197cd420b6c4b0fa_float
        {
        };
        
        void SG_UniversalHeighblend_3b5c31b864970d04197cd420b6c4b0fa_float(float _Vertex_Color, float _Blend_Hardness, float _Use_Layer_1_Height_T, float _Layer_1_Height, float2 _Layer_1_Before_Remap, float _Use_Layer_2_Height_T, float _Layer_2_Height, float2 _Layer_2_Before_Remap, float _Angle_Blend, Bindings_UniversalHeighblend_3b5c31b864970d04197cd420b6c4b0fa_float IN, out float Heightmap_1)
        {
        float _Property_b3ca7054ef0043de85912fc45d997ea2_Out_0_Float = _Vertex_Color;
        float _Clamp_852774a2be524975babf4eeb54af6d64_Out_3_Float;
        Unity_Clamp_float(_Property_b3ca7054ef0043de85912fc45d997ea2_Out_0_Float, float(0), float(1), _Clamp_852774a2be524975babf4eeb54af6d64_Out_3_Float);
        float _OneMinus_85e3550f37814cd3ab5ea5dde7f63a73_Out_1_Float;
        Unity_OneMinus_float(_Clamp_852774a2be524975babf4eeb54af6d64_Out_3_Float, _OneMinus_85e3550f37814cd3ab5ea5dde7f63a73_Out_1_Float);
        float _Comparison_5be6aeaa514b4921b5eb68269b58b028_Out_2_Boolean;
        Unity_Comparison_Greater_float(_OneMinus_85e3550f37814cd3ab5ea5dde7f63a73_Out_1_Float, float(0.99), _Comparison_5be6aeaa514b4921b5eb68269b58b028_Out_2_Boolean);
        float _Property_cfe724908035497c918d6d3f8dafe439_Out_0_Boolean = _Use_Layer_1_Height_T;
        float _Property_9634fd87d3374fdaa60181281a01f9b5_Out_0_Float = _Layer_1_Height;
        float2 _Property_e748f6c127e0479a9a01040378a4129b_Out_0_Vector2 = _Layer_1_Before_Remap;
        float _Split_cde172ab161d44cb81ea7874aec65560_R_1_Float = _Property_e748f6c127e0479a9a01040378a4129b_Out_0_Vector2[0];
        float _Split_cde172ab161d44cb81ea7874aec65560_G_2_Float = _Property_e748f6c127e0479a9a01040378a4129b_Out_0_Vector2[1];
        float _Split_cde172ab161d44cb81ea7874aec65560_B_3_Float = 0;
        float _Split_cde172ab161d44cb81ea7874aec65560_A_4_Float = 0;
        float _Subtract_e1e98a956721410caddfb467ae0eca8b_Out_2_Float;
        Unity_Subtract_float(_Split_cde172ab161d44cb81ea7874aec65560_R_1_Float, _Split_cde172ab161d44cb81ea7874aec65560_G_2_Float, _Subtract_e1e98a956721410caddfb467ae0eca8b_Out_2_Float);
        float _Clamp_ac4097026e6248dbb7a95fe910cc776e_Out_3_Float;
        Unity_Clamp_float(_OneMinus_85e3550f37814cd3ab5ea5dde7f63a73_Out_1_Float, float(0), float(1), _Clamp_ac4097026e6248dbb7a95fe910cc776e_Out_3_Float);
        float _Multiply_41691d316de74fef8a4ab5f63ed5474e_Out_2_Float;
        Unity_Multiply_float_float(_Subtract_e1e98a956721410caddfb467ae0eca8b_Out_2_Float, _Clamp_ac4097026e6248dbb7a95fe910cc776e_Out_3_Float, _Multiply_41691d316de74fef8a4ab5f63ed5474e_Out_2_Float);
        float2 _Add_48d37f8b8a464788860db14f0da8a66e_Out_2_Vector2;
        Unity_Add_float2(_Property_e748f6c127e0479a9a01040378a4129b_Out_0_Vector2, (_Multiply_41691d316de74fef8a4ab5f63ed5474e_Out_2_Float.xx), _Add_48d37f8b8a464788860db14f0da8a66e_Out_2_Vector2);
        float _Remap_21f3372608424df090026adc73778a39_Out_3_Float;
        Unity_Remap_float(_Property_9634fd87d3374fdaa60181281a01f9b5_Out_0_Float, float2 (0, 1), _Add_48d37f8b8a464788860db14f0da8a66e_Out_2_Vector2, _Remap_21f3372608424df090026adc73778a39_Out_3_Float);
        float _Clamp_8ea719b357b44537b42b2d05c22046f6_Out_3_Float;
        Unity_Clamp_float(_Remap_21f3372608424df090026adc73778a39_Out_3_Float, float(0), float(1), _Clamp_8ea719b357b44537b42b2d05c22046f6_Out_3_Float);
        float _Property_457e05a76c034ada998b3ff30a7781c3_Out_0_Boolean = _Use_Layer_2_Height_T;
        float _Property_9dfafa1ca8c94866a52535f412aff89a_Out_0_Float = _Angle_Blend;
        float _Property_b0e4a5720c374e2eb6f203a1bd075243_Out_0_Float = _Layer_2_Height;
        float _Multiply_00b31c7f720343caa4ded6df80a61899_Out_2_Float;
        Unity_Multiply_float_float(_Property_9dfafa1ca8c94866a52535f412aff89a_Out_0_Float, _Property_b0e4a5720c374e2eb6f203a1bd075243_Out_0_Float, _Multiply_00b31c7f720343caa4ded6df80a61899_Out_2_Float);
        float2 _Property_555a7734da754b989d8f80ef0bc86bea_Out_0_Vector2 = _Layer_2_Before_Remap;
        float _Split_bad56a0d03154ccc8cbfb53ea0e381d4_R_1_Float = _Property_555a7734da754b989d8f80ef0bc86bea_Out_0_Vector2[0];
        float _Split_bad56a0d03154ccc8cbfb53ea0e381d4_G_2_Float = _Property_555a7734da754b989d8f80ef0bc86bea_Out_0_Vector2[1];
        float _Split_bad56a0d03154ccc8cbfb53ea0e381d4_B_3_Float = 0;
        float _Split_bad56a0d03154ccc8cbfb53ea0e381d4_A_4_Float = 0;
        float _Subtract_2a7908018c384526a00494520503a83d_Out_2_Float;
        Unity_Subtract_float(_Split_bad56a0d03154ccc8cbfb53ea0e381d4_R_1_Float, _Split_bad56a0d03154ccc8cbfb53ea0e381d4_G_2_Float, _Subtract_2a7908018c384526a00494520503a83d_Out_2_Float);
        float _Multiply_417d72157b5f4930aed43775db746964_Out_2_Float;
        Unity_Multiply_float_float(_Subtract_2a7908018c384526a00494520503a83d_Out_2_Float, _Clamp_ac4097026e6248dbb7a95fe910cc776e_Out_3_Float, _Multiply_417d72157b5f4930aed43775db746964_Out_2_Float);
        float2 _Add_3d7e111e917c44e8a6800ce926fac67d_Out_2_Vector2;
        Unity_Add_float2((_Multiply_417d72157b5f4930aed43775db746964_Out_2_Float.xx), _Property_555a7734da754b989d8f80ef0bc86bea_Out_0_Vector2, _Add_3d7e111e917c44e8a6800ce926fac67d_Out_2_Vector2);
        float _Remap_931f83440e6c4c1588456788f84cbd9a_Out_3_Float;
        Unity_Remap_float(_Multiply_00b31c7f720343caa4ded6df80a61899_Out_2_Float, float2 (0, 1), _Add_3d7e111e917c44e8a6800ce926fac67d_Out_2_Vector2, _Remap_931f83440e6c4c1588456788f84cbd9a_Out_3_Float);
        float _Branch_a840aba5bca34588a2665f9794c96c38_Out_3_Float;
        Unity_Branch_float(_Property_457e05a76c034ada998b3ff30a7781c3_Out_0_Boolean, _Remap_931f83440e6c4c1588456788f84cbd9a_Out_3_Float, _Property_9dfafa1ca8c94866a52535f412aff89a_Out_0_Float, _Branch_a840aba5bca34588a2665f9794c96c38_Out_3_Float);
        float _Clamp_b1fe959daf444bf99c57756b8be77768_Out_3_Float;
        Unity_Clamp_float(_Branch_a840aba5bca34588a2665f9794c96c38_Out_3_Float, float(0), float(1), _Clamp_b1fe959daf444bf99c57756b8be77768_Out_3_Float);
        float _Multiply_c045ae9912ac409b9734c687968d47f6_Out_2_Float;
        Unity_Multiply_float_float(_Clamp_8ea719b357b44537b42b2d05c22046f6_Out_3_Float, _Clamp_b1fe959daf444bf99c57756b8be77768_Out_3_Float, _Multiply_c045ae9912ac409b9734c687968d47f6_Out_2_Float);
        float _Branch_5198cfc0a080466e93cf89aea61886e6_Out_3_Float;
        Unity_Branch_float(_Property_cfe724908035497c918d6d3f8dafe439_Out_0_Boolean, _Multiply_c045ae9912ac409b9734c687968d47f6_Out_2_Float, _Clamp_b1fe959daf444bf99c57756b8be77768_Out_3_Float, _Branch_5198cfc0a080466e93cf89aea61886e6_Out_3_Float);
        float _Saturate_ceafe30b0bae4f45a2f2ec500925b553_Out_1_Float;
        Unity_Saturate_float(_Branch_5198cfc0a080466e93cf89aea61886e6_Out_3_Float, _Saturate_ceafe30b0bae4f45a2f2ec500925b553_Out_1_Float);
        float _Absolute_274083e3f9f645bfb86074d91f3b7c62_Out_1_Float;
        Unity_Absolute_float(_Saturate_ceafe30b0bae4f45a2f2ec500925b553_Out_1_Float, _Absolute_274083e3f9f645bfb86074d91f3b7c62_Out_1_Float);
        float _Property_c68e0b8a84a549a582d4723036344b0e_Out_0_Float = _Blend_Hardness;
        float _Power_c9d62a3092174d9cb5674d87bcb7b5c5_Out_2_Float;
        Unity_Power_float(_Absolute_274083e3f9f645bfb86074d91f3b7c62_Out_1_Float, _Property_c68e0b8a84a549a582d4723036344b0e_Out_0_Float, _Power_c9d62a3092174d9cb5674d87bcb7b5c5_Out_2_Float);
        float _Branch_2425ee869bde4930bb8f36a5273bdc33_Out_3_Float;
        Unity_Branch_float(_Comparison_5be6aeaa514b4921b5eb68269b58b028_Out_2_Boolean, float(0), _Power_c9d62a3092174d9cb5674d87bcb7b5c5_Out_2_Float, _Branch_2425ee869bde4930bb8f36a5273bdc33_Out_3_Float);
        float _Clamp_9a5c5cfe52824e248ea0a8e38c593d84_Out_3_Float;
        Unity_Clamp_float(_Branch_2425ee869bde4930bb8f36a5273bdc33_Out_3_Float, float(0), float(1), _Clamp_9a5c5cfe52824e248ea0a8e38c593d84_Out_3_Float);
        Heightmap_1 = _Clamp_9a5c5cfe52824e248ea0a8e38c593d84_Out_3_Float;
        }
        
        void Unity_ColorspaceConversion_Linear_RGB_float(float3 In, out float3 Out)
        {
            float3 sRGBLo = In * 12.92;
            float3 sRGBHi = (pow(max(abs(In), 1.192092896e-07), float3(1.0 / 2.4, 1.0 / 2.4, 1.0 / 2.4)) * 1.055) - 0.055;
            Out = float3(In <= 0.0031308) ? sRGBLo : sRGBHi;
        }
        
        void Unity_Blend_Overlay_float3(float3 Base, float3 Blend, out float3 Out, float Opacity)
        {
            float3 result1 = 1.0 - 2.0 * (1.0 - Base) * (1.0 - Blend);
            float3 result2 = 2.0 * Base * Blend;
            float3 zeroOrOne = step(Base, 0.5);
            Out = result2 * zeroOrOne + (1 - zeroOrOne) * result1;
            Out = lerp(Base, Out, Opacity);
        }
        
        void Unity_ColorspaceConversion_RGB_Linear_float(float3 In, out float3 Out)
        {
            float3 linearRGBLo = In / 12.92;
            float3 linearRGBHi = pow(max(abs((In + 0.055) / 1.055), 1.192092896e-07), float3(2.4, 2.4, 2.4));
            Out = float3(In <= 0.04045) ? linearRGBLo : linearRGBHi;
        }
        
        void Unity_Lerp_float4(float4 A, float4 B, float4 T, out float4 Out)
        {
            Out = lerp(A, B, T);
        }
        
        void Unity_Clamp_float4(float4 In, float4 Min, float4 Max, out float4 Out)
        {
            Out = clamp(In, Min, Max);
        }
        
        // Custom interpolators pre vertex
        /* WARNING: $splice Could not find named fragment 'CustomInterpolatorPreVertex' */
        
        // Graph Vertex
        struct VertexDescription
        {
            float3 Position;
            float3 Normal;
            float3 Tangent;
        };
        
        VertexDescription VertexDescriptionFunction(VertexDescriptionInputs IN)
        {
            VertexDescription description = (VertexDescription)0;
            description.Position = IN.ObjectSpacePosition;
            description.Normal = IN.ObjectSpaceNormal;
            description.Tangent = IN.ObjectSpaceTangent;
            return description;
        }
        
        // Custom interpolators, pre surface
        #ifdef FEATURES_GRAPH_VERTEX
        Varyings CustomInterpolatorPassThroughFunc(inout Varyings output, VertexDescription input)
        {
        return output;
        }
        #define CUSTOMINTERPOLATOR_VARYPASSTHROUGH_FUNC
        #endif
        
        // Graph Pixel
        struct SurfaceDescription
        {
            float3 NormalTS;
            float Alpha;
            float AlphaClipThreshold;
        };
        
        SurfaceDescription SurfaceDescriptionFunction(SurfaceDescriptionInputs IN)
        {
            SurfaceDescription surface = (SurfaceDescription)0;
            UnityTexture2D _Property_50403cc6b1e3998a82afc21c6a6332ae_Out_0_Texture2D = UnityBuildTexture2DStructNoScale(_DetailMap);
            float4 _Property_256e5676e1089881ae3214634430b140_Out_0_Vector4 = _DetailTilingOffset;
            float _Split_257d0b6ea953418d97fd7daa8128bf35_R_1_Float = _Property_256e5676e1089881ae3214634430b140_Out_0_Vector4[0];
            float _Split_257d0b6ea953418d97fd7daa8128bf35_G_2_Float = _Property_256e5676e1089881ae3214634430b140_Out_0_Vector4[1];
            float _Split_257d0b6ea953418d97fd7daa8128bf35_B_3_Float = _Property_256e5676e1089881ae3214634430b140_Out_0_Vector4[2];
            float _Split_257d0b6ea953418d97fd7daa8128bf35_A_4_Float = _Property_256e5676e1089881ae3214634430b140_Out_0_Vector4[3];
            float2 _Vector2_98295494172421878c7a16cb2baddf9a_Out_0_Vector2 = float2(_Split_257d0b6ea953418d97fd7daa8128bf35_R_1_Float, _Split_257d0b6ea953418d97fd7daa8128bf35_G_2_Float);
            float2 _Vector2_130e8faa59837a81a7506636fcb30b8a_Out_0_Vector2 = float2(_Split_257d0b6ea953418d97fd7daa8128bf35_B_3_Float, _Split_257d0b6ea953418d97fd7daa8128bf35_A_4_Float);
            float2 _TilingAndOffset_1dfb2b4859ec3680ad3a74cf8f1bc17b_Out_3_Vector2;
            Unity_TilingAndOffset_float(IN.uv0.xy, _Vector2_98295494172421878c7a16cb2baddf9a_Out_0_Vector2, _Vector2_130e8faa59837a81a7506636fcb30b8a_Out_0_Vector2, _TilingAndOffset_1dfb2b4859ec3680ad3a74cf8f1bc17b_Out_3_Vector2);
            float4 _SampleTexture2D_d8eb0186b9a0cd819cde65431b4ea5ea_RGBA_0_Vector4 = SAMPLE_TEXTURE2D(_Property_50403cc6b1e3998a82afc21c6a6332ae_Out_0_Texture2D.tex, UnityBuildSamplerStateStruct(SamplerState_Linear_Repeat_Aniso8).samplerstate, _Property_50403cc6b1e3998a82afc21c6a6332ae_Out_0_Texture2D.GetTransformedUV(_TilingAndOffset_1dfb2b4859ec3680ad3a74cf8f1bc17b_Out_3_Vector2) );
            float _SampleTexture2D_d8eb0186b9a0cd819cde65431b4ea5ea_R_4_Float = _SampleTexture2D_d8eb0186b9a0cd819cde65431b4ea5ea_RGBA_0_Vector4.r;
            float _SampleTexture2D_d8eb0186b9a0cd819cde65431b4ea5ea_G_5_Float = _SampleTexture2D_d8eb0186b9a0cd819cde65431b4ea5ea_RGBA_0_Vector4.g;
            float _SampleTexture2D_d8eb0186b9a0cd819cde65431b4ea5ea_B_6_Float = _SampleTexture2D_d8eb0186b9a0cd819cde65431b4ea5ea_RGBA_0_Vector4.b;
            float _SampleTexture2D_d8eb0186b9a0cd819cde65431b4ea5ea_A_7_Float = _SampleTexture2D_d8eb0186b9a0cd819cde65431b4ea5ea_RGBA_0_Vector4.a;
            float2 _Vector2_0d28074858599a88940dfc8b57b9a60f_Out_0_Vector2 = float2(_SampleTexture2D_d8eb0186b9a0cd819cde65431b4ea5ea_A_7_Float, _SampleTexture2D_d8eb0186b9a0cd819cde65431b4ea5ea_G_5_Float);
            float2 _Multiply_fac8d94f82a53486bc0142a1e64b3d32_Out_2_Vector2;
            Unity_Multiply_float2_float2(_Vector2_0d28074858599a88940dfc8b57b9a60f_Out_0_Vector2, float2(2, 2), _Multiply_fac8d94f82a53486bc0142a1e64b3d32_Out_2_Vector2);
            float2 _Add_f0e6e847d8d8798ab3ca8c4d878bafc0_Out_2_Vector2;
            Unity_Add_float2(_Multiply_fac8d94f82a53486bc0142a1e64b3d32_Out_2_Vector2, float2(-1, -1), _Add_f0e6e847d8d8798ab3ca8c4d878bafc0_Out_2_Vector2);
            float _Property_d0e8d8f7fd10f0829e8fd86c278c8226_Out_0_Float = _DetailNormalScale;
            float2 _Multiply_11f3dfc5283ea188ad9c83e552cf7e0f_Out_2_Vector2;
            Unity_Multiply_float2_float2(_Add_f0e6e847d8d8798ab3ca8c4d878bafc0_Out_2_Vector2, (_Property_d0e8d8f7fd10f0829e8fd86c278c8226_Out_0_Float.xx), _Multiply_11f3dfc5283ea188ad9c83e552cf7e0f_Out_2_Vector2);
            float _Split_c4822b8eaff9b185be7c059792345712_R_1_Float = _Multiply_11f3dfc5283ea188ad9c83e552cf7e0f_Out_2_Vector2[0];
            float _Split_c4822b8eaff9b185be7c059792345712_G_2_Float = _Multiply_11f3dfc5283ea188ad9c83e552cf7e0f_Out_2_Vector2[1];
            float _Split_c4822b8eaff9b185be7c059792345712_B_3_Float = 0;
            float _Split_c4822b8eaff9b185be7c059792345712_A_4_Float = 0;
            float _DotProduct_1a01939a143c548c8ccd7e8a04fe680d_Out_2_Float;
            Unity_DotProduct_float2(_Multiply_11f3dfc5283ea188ad9c83e552cf7e0f_Out_2_Vector2, _Multiply_11f3dfc5283ea188ad9c83e552cf7e0f_Out_2_Vector2, _DotProduct_1a01939a143c548c8ccd7e8a04fe680d_Out_2_Float);
            float _Saturate_bf3d57899db77f86a1689105ce6a373a_Out_1_Float;
            Unity_Saturate_float(_DotProduct_1a01939a143c548c8ccd7e8a04fe680d_Out_2_Float, _Saturate_bf3d57899db77f86a1689105ce6a373a_Out_1_Float);
            float _OneMinus_052960238cc4a18cb83109d2bcae6d09_Out_1_Float;
            Unity_OneMinus_float(_Saturate_bf3d57899db77f86a1689105ce6a373a_Out_1_Float, _OneMinus_052960238cc4a18cb83109d2bcae6d09_Out_1_Float);
            float _SquareRoot_d4f67288e4dbf5898bea492a70b89ab9_Out_1_Float;
            Unity_SquareRoot_float(_OneMinus_052960238cc4a18cb83109d2bcae6d09_Out_1_Float, _SquareRoot_d4f67288e4dbf5898bea492a70b89ab9_Out_1_Float);
            float3 _Vector3_1e56146bdd567884bb8d5ae769df4d29_Out_0_Vector3 = float3(_Split_c4822b8eaff9b185be7c059792345712_R_1_Float, _Split_c4822b8eaff9b185be7c059792345712_G_2_Float, _SquareRoot_d4f67288e4dbf5898bea492a70b89ab9_Out_1_Float);
            UnityTexture2D _Property_147b07430832c98eb0a470557ee61c5e_Out_0_Texture2D = UnityBuildTexture2DStructNoScale(_BaseNormalMap);
            float4 _Property_8ec0d512145619859d288abab740e3bf_Out_0_Vector4 = _BaseTilingOffset;
            float _Property_122c0f9ef0a1c4818a140c75e512abe4_Out_0_Boolean = _BaseUsePlanarUV;
            Bindings_PlanarNMn_1b93a87456f9d4c419321d0cd92bd6c8_float _PlanarNMn_ecad9f1f260c6c8bbd0960b2a8976daf;
            _PlanarNMn_ecad9f1f260c6c8bbd0960b2a8976daf.WorldSpaceNormal = IN.WorldSpaceNormal;
            _PlanarNMn_ecad9f1f260c6c8bbd0960b2a8976daf.WorldSpaceTangent = IN.WorldSpaceTangent;
            _PlanarNMn_ecad9f1f260c6c8bbd0960b2a8976daf.WorldSpaceBiTangent = IN.WorldSpaceBiTangent;
            _PlanarNMn_ecad9f1f260c6c8bbd0960b2a8976daf.AbsoluteWorldSpacePosition = IN.AbsoluteWorldSpacePosition;
            _PlanarNMn_ecad9f1f260c6c8bbd0960b2a8976daf.uv0 = IN.uv0;
            _PlanarNMn_ecad9f1f260c6c8bbd0960b2a8976daf.uv3 = IN.uv3;
            float4 _PlanarNMn_ecad9f1f260c6c8bbd0960b2a8976daf_XZ_2_Vector4;
            SG_PlanarNMn_1b93a87456f9d4c419321d0cd92bd6c8_float(_Property_147b07430832c98eb0a470557ee61c5e_Out_0_Texture2D, _Property_8ec0d512145619859d288abab740e3bf_Out_0_Vector4, _Property_122c0f9ef0a1c4818a140c75e512abe4_Out_0_Boolean, UnityBuildSamplerStateStruct(SamplerState_Linear_Repeat_Aniso8), 1, _PlanarNMn_ecad9f1f260c6c8bbd0960b2a8976daf, _PlanarNMn_ecad9f1f260c6c8bbd0960b2a8976daf_XZ_2_Vector4);
            float _Property_72e436a108ad64868e46d548c585c5f3_Out_0_Float = _BaseNormalScale;
            float3 _NormalStrength_366affc5c8b42482a633d201ef52b9d6_Out_2_Vector3;
            Unity_NormalStrength_float((_PlanarNMn_ecad9f1f260c6c8bbd0960b2a8976daf_XZ_2_Vector4.xyz), _Property_72e436a108ad64868e46d548c585c5f3_Out_0_Float, _NormalStrength_366affc5c8b42482a633d201ef52b9d6_Out_2_Vector3);
            float3 _NormalBlend_9f531c87e2e45580b1d0f65f06c23526_Out_2_Vector3;
            Unity_NormalBlend_Reoriented_float(_Vector3_1e56146bdd567884bb8d5ae769df4d29_Out_0_Vector3, _NormalStrength_366affc5c8b42482a633d201ef52b9d6_Out_2_Vector3, _NormalBlend_9f531c87e2e45580b1d0f65f06c23526_Out_2_Vector3);
            UnityTexture2D _Property_d7e9139e0ac6718b89c610009c28a25a_Out_0_Texture2D = UnityBuildTexture2DStructNoScale(_CoverNormalMap);
            float4 _Property_256beda96caf2d8aa05d3de41fc08d3d_Out_0_Vector4 = _CoverTilingOffset;
            float _Property_bd9dfe8dd615798f9f2d72d139e56d61_Out_0_Boolean = _CoverUsePlanarUV;
            Bindings_PlanarNMn_1b93a87456f9d4c419321d0cd92bd6c8_float _PlanarNMn_690e893d26999680a5cea3604ed0ce16;
            _PlanarNMn_690e893d26999680a5cea3604ed0ce16.WorldSpaceNormal = IN.WorldSpaceNormal;
            _PlanarNMn_690e893d26999680a5cea3604ed0ce16.WorldSpaceTangent = IN.WorldSpaceTangent;
            _PlanarNMn_690e893d26999680a5cea3604ed0ce16.WorldSpaceBiTangent = IN.WorldSpaceBiTangent;
            _PlanarNMn_690e893d26999680a5cea3604ed0ce16.AbsoluteWorldSpacePosition = IN.AbsoluteWorldSpacePosition;
            _PlanarNMn_690e893d26999680a5cea3604ed0ce16.uv0 = IN.uv0;
            _PlanarNMn_690e893d26999680a5cea3604ed0ce16.uv3 = IN.uv3;
            float4 _PlanarNMn_690e893d26999680a5cea3604ed0ce16_XZ_2_Vector4;
            SG_PlanarNMn_1b93a87456f9d4c419321d0cd92bd6c8_float(_Property_d7e9139e0ac6718b89c610009c28a25a_Out_0_Texture2D, _Property_256beda96caf2d8aa05d3de41fc08d3d_Out_0_Vector4, _Property_bd9dfe8dd615798f9f2d72d139e56d61_Out_0_Boolean, UnityBuildSamplerStateStruct(SamplerState_Linear_Repeat_Aniso8), 1, _PlanarNMn_690e893d26999680a5cea3604ed0ce16, _PlanarNMn_690e893d26999680a5cea3604ed0ce16_XZ_2_Vector4);
            float _Property_16c4ac023c82618b9a5117de14716c25_Out_0_Float = _CoverNormalScale;
            float3 _NormalStrength_76b1f6b709c2558a897aa152a50733b3_Out_2_Vector3;
            Unity_NormalStrength_float((_PlanarNMn_690e893d26999680a5cea3604ed0ce16_XZ_2_Vector4.xyz), _Property_16c4ac023c82618b9a5117de14716c25_Out_0_Float, _NormalStrength_76b1f6b709c2558a897aa152a50733b3_Out_2_Vector3);
            float _Split_a80936a3c75945efb8cf9f2b95c76642_R_1_Float = IN.VertexColor[0];
            float _Split_a80936a3c75945efb8cf9f2b95c76642_G_2_Float = IN.VertexColor[1];
            float _Split_a80936a3c75945efb8cf9f2b95c76642_B_3_Float = IN.VertexColor[2];
            float _Split_a80936a3c75945efb8cf9f2b95c76642_A_4_Float = IN.VertexColor[3];
            float _Property_14a6757619d64822a44a69b34f85276d_Out_0_Float = _VertexColorGBlendStrenght;
            float _Property_c0d9ffba7dee497c885a54170977d874_Out_0_Boolean = _USEBaseHeightT;
            UnityTexture2D _Property_bb9b47702e64ec8c8d8ad011fd521576_Out_0_Texture2D = UnityBuildTexture2DStructNoScale(_BaseMaskMap);
            Bindings_PlanarNM_c0f081da9c567704ea36e7dd38cedcf6_float _PlanarNM_e51306c84cde8e84a1fb06a45d8d037f;
            _PlanarNM_e51306c84cde8e84a1fb06a45d8d037f.AbsoluteWorldSpacePosition = IN.AbsoluteWorldSpacePosition;
            _PlanarNM_e51306c84cde8e84a1fb06a45d8d037f.uv0 = IN.uv0;
            _PlanarNM_e51306c84cde8e84a1fb06a45d8d037f.uv3 = IN.uv3;
            float4 _PlanarNM_e51306c84cde8e84a1fb06a45d8d037f_XZ_2_Vector4;
            SG_PlanarNM_c0f081da9c567704ea36e7dd38cedcf6_float(_Property_bb9b47702e64ec8c8d8ad011fd521576_Out_0_Texture2D, _Property_8ec0d512145619859d288abab740e3bf_Out_0_Vector4, _Property_122c0f9ef0a1c4818a140c75e512abe4_Out_0_Boolean, UnityBuildSamplerStateStruct(SamplerState_Linear_Repeat_Aniso8), 1, _PlanarNM_e51306c84cde8e84a1fb06a45d8d037f, _PlanarNM_e51306c84cde8e84a1fb06a45d8d037f_XZ_2_Vector4);
            float _Split_218e1cfd00b30984921b5fc0ec63de60_R_1_Float = _PlanarNM_e51306c84cde8e84a1fb06a45d8d037f_XZ_2_Vector4[0];
            float _Split_218e1cfd00b30984921b5fc0ec63de60_G_2_Float = _PlanarNM_e51306c84cde8e84a1fb06a45d8d037f_XZ_2_Vector4[1];
            float _Split_218e1cfd00b30984921b5fc0ec63de60_B_3_Float = _PlanarNM_e51306c84cde8e84a1fb06a45d8d037f_XZ_2_Vector4[2];
            float _Split_218e1cfd00b30984921b5fc0ec63de60_A_4_Float = _PlanarNM_e51306c84cde8e84a1fb06a45d8d037f_XZ_2_Vector4[3];
            float _Property_1d4a1a93707b42c3abf0baa799c514e5_Out_0_Float = _HeightMin;
            float _Property_8f4f3606868d4028a34c2a9a5a59f99d_Out_0_Float = _HeightMax;
            float2 _Vector2_721b6f4d7077463490b4504fe6c940bf_Out_0_Vector2 = float2(_Property_1d4a1a93707b42c3abf0baa799c514e5_Out_0_Float, _Property_8f4f3606868d4028a34c2a9a5a59f99d_Out_0_Float);
            float _Property_a1ae2f61da87421b9f3839691e9dd8af_Out_0_Float = _HeightOffset;
            float2 _Add_1f9ea9bdf36544b59f763806e7eea80d_Out_2_Vector2;
            Unity_Add_float2(_Vector2_721b6f4d7077463490b4504fe6c940bf_Out_0_Vector2, (_Property_a1ae2f61da87421b9f3839691e9dd8af_Out_0_Float.xx), _Add_1f9ea9bdf36544b59f763806e7eea80d_Out_2_Vector2);
            float _Property_0fbef18600294e199eeda9905e3304e4_Out_0_Boolean = _USECoverHeightT;
            UnityTexture2D _Property_3702de305e11e085a40d7731b582d541_Out_0_Texture2D = UnityBuildTexture2DStructNoScale(_CoverMaskMap);
            Bindings_PlanarNM_c0f081da9c567704ea36e7dd38cedcf6_float _PlanarNM_2217ca3c12141a8cb1e0c7235b369601;
            _PlanarNM_2217ca3c12141a8cb1e0c7235b369601.AbsoluteWorldSpacePosition = IN.AbsoluteWorldSpacePosition;
            _PlanarNM_2217ca3c12141a8cb1e0c7235b369601.uv0 = IN.uv0;
            _PlanarNM_2217ca3c12141a8cb1e0c7235b369601.uv3 = IN.uv3;
            float4 _PlanarNM_2217ca3c12141a8cb1e0c7235b369601_XZ_2_Vector4;
            SG_PlanarNM_c0f081da9c567704ea36e7dd38cedcf6_float(_Property_3702de305e11e085a40d7731b582d541_Out_0_Texture2D, _Property_256beda96caf2d8aa05d3de41fc08d3d_Out_0_Vector4, _Property_bd9dfe8dd615798f9f2d72d139e56d61_Out_0_Boolean, UnityBuildSamplerStateStruct(SamplerState_Linear_Repeat_Aniso8), 1, _PlanarNM_2217ca3c12141a8cb1e0c7235b369601, _PlanarNM_2217ca3c12141a8cb1e0c7235b369601_XZ_2_Vector4);
            float _Split_2f45bca363698c859e51492899bc58f8_R_1_Float = _PlanarNM_2217ca3c12141a8cb1e0c7235b369601_XZ_2_Vector4[0];
            float _Split_2f45bca363698c859e51492899bc58f8_G_2_Float = _PlanarNM_2217ca3c12141a8cb1e0c7235b369601_XZ_2_Vector4[1];
            float _Split_2f45bca363698c859e51492899bc58f8_B_3_Float = _PlanarNM_2217ca3c12141a8cb1e0c7235b369601_XZ_2_Vector4[2];
            float _Split_2f45bca363698c859e51492899bc58f8_A_4_Float = _PlanarNM_2217ca3c12141a8cb1e0c7235b369601_XZ_2_Vector4[3];
            float _Property_32b48052fdbb4641bf4eeb294bc65050_Out_0_Float = _CoverHeightMapMin;
            float _Property_0e120eb0a0a14b12a31a3c1f5b961121_Out_0_Float = _CoverHeightMapMax;
            float2 _Vector2_6955747f7f0a4ff98fae60dbada25e89_Out_0_Vector2 = float2(_Property_32b48052fdbb4641bf4eeb294bc65050_Out_0_Float, _Property_0e120eb0a0a14b12a31a3c1f5b961121_Out_0_Float);
            float _Property_6b467710b0ba48058e003aebe9119249_Out_0_Float = _CoverHeightMapOffset;
            float2 _Add_28628d641d58481084e9c00e4ad5fc8d_Out_2_Vector2;
            Unity_Add_float2(_Vector2_6955747f7f0a4ff98fae60dbada25e89_Out_0_Vector2, (_Property_6b467710b0ba48058e003aebe9119249_Out_0_Float.xx), _Add_28628d641d58481084e9c00e4ad5fc8d_Out_2_Vector2);
            UnityTexture2D _Property_7bea2d9dd5651a8bbbd61ecde71faa54_Out_0_Texture2D = UnityBuildTexture2DStructNoScale(_Masks);
            float4 _UV_429c95affe88aa8694076115c99a0769_Out_0_Vector4 = IN.uv0;
            float4 _SampleTexture2D_2723da80b8a2528381ef199c0415beae_RGBA_0_Vector4 = SAMPLE_TEXTURE2D(_Property_7bea2d9dd5651a8bbbd61ecde71faa54_Out_0_Texture2D.tex, UnityBuildSamplerStateStruct(SamplerState_Linear_Repeat_Aniso8).samplerstate, _Property_7bea2d9dd5651a8bbbd61ecde71faa54_Out_0_Texture2D.GetTransformedUV((_UV_429c95affe88aa8694076115c99a0769_Out_0_Vector4.xy)) );
            float _SampleTexture2D_2723da80b8a2528381ef199c0415beae_R_4_Float = _SampleTexture2D_2723da80b8a2528381ef199c0415beae_RGBA_0_Vector4.r;
            float _SampleTexture2D_2723da80b8a2528381ef199c0415beae_G_5_Float = _SampleTexture2D_2723da80b8a2528381ef199c0415beae_RGBA_0_Vector4.g;
            float _SampleTexture2D_2723da80b8a2528381ef199c0415beae_B_6_Float = _SampleTexture2D_2723da80b8a2528381ef199c0415beae_RGBA_0_Vector4.b;
            float _SampleTexture2D_2723da80b8a2528381ef199c0415beae_A_7_Float = _SampleTexture2D_2723da80b8a2528381ef199c0415beae_RGBA_0_Vector4.a;
            float _Property_7bea2851849541b28a2bc695d39a7606_Out_0_Float = _Cover_Mask_A_Remap_Min;
            float _Property_3be0ae138e414a5cb43d60264b1bcfeb_Out_0_Float = _Cover_Mask_A_Remap_Max;
            float2 _Vector2_44ac029de1e440a799fbdfadc778af0c_Out_0_Vector2 = float2(_Property_7bea2851849541b28a2bc695d39a7606_Out_0_Float, _Property_3be0ae138e414a5cb43d60264b1bcfeb_Out_0_Float);
            float _Remap_0c551a3055a54f16b85b519194883552_Out_3_Float;
            Unity_Remap_float(_SampleTexture2D_2723da80b8a2528381ef199c0415beae_A_7_Float, float2 (0, 1), _Vector2_44ac029de1e440a799fbdfadc778af0c_Out_0_Vector2, _Remap_0c551a3055a54f16b85b519194883552_Out_3_Float);
            float _Clamp_bb1427696ce14fe987f799fecc5f9fac_Out_3_Float;
            Unity_Clamp_float(_Remap_0c551a3055a54f16b85b519194883552_Out_3_Float, float(0), float(1), _Clamp_bb1427696ce14fe987f799fecc5f9fac_Out_3_Float);
            float _Property_0fd4d87ded104c829a6110c044eaa5f2_Out_0_Float = _CoverNormalBlendHardness;
            float3 _NormalStrength_c4639a6dd3dfde85b591971db2700eaf_Out_2_Vector3;
            Unity_NormalStrength_float((_PlanarNMn_690e893d26999680a5cea3604ed0ce16_XZ_2_Vector4.xyz), _Property_0fd4d87ded104c829a6110c044eaa5f2_Out_0_Float, _NormalStrength_c4639a6dd3dfde85b591971db2700eaf_Out_2_Vector3);
            float _Split_8ff22a6bdd437780ac7ea5963e1c5bb4_R_1_Float = IN.WorldSpaceNormal[0];
            float _Split_8ff22a6bdd437780ac7ea5963e1c5bb4_G_2_Float = IN.WorldSpaceNormal[1];
            float _Split_8ff22a6bdd437780ac7ea5963e1c5bb4_B_3_Float = IN.WorldSpaceNormal[2];
            float _Split_8ff22a6bdd437780ac7ea5963e1c5bb4_A_4_Float = 0;
            float _Property_28052b023ac35c8e9a95b30327681cc5_Out_0_Float = _Cover_Amount;
            float _Property_7749c0d5b28c14869ab3ba35d226788b_Out_0_Float = _Cover_Amount_Grow_Speed;
            float _Subtract_e5dc2afce7ff588fa1d4c91f78de7575_Out_2_Float;
            Unity_Subtract_float(float(4), _Property_7749c0d5b28c14869ab3ba35d226788b_Out_0_Float, _Subtract_e5dc2afce7ff588fa1d4c91f78de7575_Out_2_Float);
            float _Divide_c77b003bf1ce13828c94a705676e2b30_Out_2_Float;
            Unity_Divide_float(_Property_28052b023ac35c8e9a95b30327681cc5_Out_0_Float, _Subtract_e5dc2afce7ff588fa1d4c91f78de7575_Out_2_Float, _Divide_c77b003bf1ce13828c94a705676e2b30_Out_2_Float);
            float _Absolute_c7499cf07bdd0582abd82adbf367b0fc_Out_1_Float;
            Unity_Absolute_float(_Divide_c77b003bf1ce13828c94a705676e2b30_Out_2_Float, _Absolute_c7499cf07bdd0582abd82adbf367b0fc_Out_1_Float);
            float _Power_a9431dbce44a528f9ee7095adfa10556_Out_2_Float;
            Unity_Power_float(_Absolute_c7499cf07bdd0582abd82adbf367b0fc_Out_1_Float, _Subtract_e5dc2afce7ff588fa1d4c91f78de7575_Out_2_Float, _Power_a9431dbce44a528f9ee7095adfa10556_Out_2_Float);
            float _Clamp_815ffdd53cc1c889aa00f73784cb71e7_Out_3_Float;
            Unity_Clamp_float(_Power_a9431dbce44a528f9ee7095adfa10556_Out_2_Float, float(0), float(2), _Clamp_815ffdd53cc1c889aa00f73784cb71e7_Out_3_Float);
            float _Multiply_143da4886728ff868f10e9cfa6940ea0_Out_2_Float;
            Unity_Multiply_float_float(_Split_8ff22a6bdd437780ac7ea5963e1c5bb4_G_2_Float, _Clamp_815ffdd53cc1c889aa00f73784cb71e7_Out_3_Float, _Multiply_143da4886728ff868f10e9cfa6940ea0_Out_2_Float);
            float _Saturate_04686ab19029f68c8fb9e7a115b207b1_Out_1_Float;
            Unity_Saturate_float(_Multiply_143da4886728ff868f10e9cfa6940ea0_Out_2_Float, _Saturate_04686ab19029f68c8fb9e7a115b207b1_Out_1_Float);
            float _Clamp_9c0a88ffc7be288cbe97d3e13a014fe8_Out_3_Float;
            Unity_Clamp_float(_Split_8ff22a6bdd437780ac7ea5963e1c5bb4_G_2_Float, float(0), float(0.9999), _Clamp_9c0a88ffc7be288cbe97d3e13a014fe8_Out_3_Float);
            float _Property_58f42b34c7f0728f8c98e00a3e3a5726_Out_0_Float = _Cover_Max_Angle;
            float _Divide_b785767ecc1928889893fa60eac4e5fb_Out_2_Float;
            Unity_Divide_float(_Property_58f42b34c7f0728f8c98e00a3e3a5726_Out_0_Float, float(45), _Divide_b785767ecc1928889893fa60eac4e5fb_Out_2_Float);
            float _OneMinus_8e6f5b1570dc8c8b8afb036328281675_Out_1_Float;
            Unity_OneMinus_float(_Divide_b785767ecc1928889893fa60eac4e5fb_Out_2_Float, _OneMinus_8e6f5b1570dc8c8b8afb036328281675_Out_1_Float);
            float _Subtract_5348fb3702fea78d9ee10dbf81ede29c_Out_2_Float;
            Unity_Subtract_float(_Clamp_9c0a88ffc7be288cbe97d3e13a014fe8_Out_3_Float, _OneMinus_8e6f5b1570dc8c8b8afb036328281675_Out_1_Float, _Subtract_5348fb3702fea78d9ee10dbf81ede29c_Out_2_Float);
            float _Clamp_2b888688983edd82ac250226d9378893_Out_3_Float;
            Unity_Clamp_float(_Subtract_5348fb3702fea78d9ee10dbf81ede29c_Out_2_Float, float(0), float(2), _Clamp_2b888688983edd82ac250226d9378893_Out_3_Float);
            float _Divide_5615f16c20214d888a2e727ff7c5f5ff_Out_2_Float;
            Unity_Divide_float(float(1), _Divide_b785767ecc1928889893fa60eac4e5fb_Out_2_Float, _Divide_5615f16c20214d888a2e727ff7c5f5ff_Out_2_Float);
            float _Multiply_89aeffc0ad067981a18e6a77948b2b49_Out_2_Float;
            Unity_Multiply_float_float(_Clamp_2b888688983edd82ac250226d9378893_Out_3_Float, _Divide_5615f16c20214d888a2e727ff7c5f5ff_Out_2_Float, _Multiply_89aeffc0ad067981a18e6a77948b2b49_Out_2_Float);
            float _Absolute_b91ed8e326de8f88bf52e49cc5f641d4_Out_1_Float;
            Unity_Absolute_float(_Multiply_89aeffc0ad067981a18e6a77948b2b49_Out_2_Float, _Absolute_b91ed8e326de8f88bf52e49cc5f641d4_Out_1_Float);
            float _Property_4879e96694aee98c9d4ecd329a571123_Out_0_Float = _CoverHardness;
            float _Power_ca1f1906c90fb785bfe520b7faefc3cd_Out_2_Float;
            Unity_Power_float(_Absolute_b91ed8e326de8f88bf52e49cc5f641d4_Out_1_Float, _Property_4879e96694aee98c9d4ecd329a571123_Out_0_Float, _Power_ca1f1906c90fb785bfe520b7faefc3cd_Out_2_Float);
            float _Property_b66201e787ab7b83a55abc6ddd3fe1fd_Out_0_Float = _Cover_Min_Height;
            float _OneMinus_87c740d245de388db4fe5f4958de0668_Out_1_Float;
            Unity_OneMinus_float(_Property_b66201e787ab7b83a55abc6ddd3fe1fd_Out_0_Float, _OneMinus_87c740d245de388db4fe5f4958de0668_Out_1_Float);
            float _Split_ae16de7cacf9d0878aba1467f193d681_R_1_Float = IN.AbsoluteWorldSpacePosition[0];
            float _Split_ae16de7cacf9d0878aba1467f193d681_G_2_Float = IN.AbsoluteWorldSpacePosition[1];
            float _Split_ae16de7cacf9d0878aba1467f193d681_B_3_Float = IN.AbsoluteWorldSpacePosition[2];
            float _Split_ae16de7cacf9d0878aba1467f193d681_A_4_Float = 0;
            float _Add_9d6e1dd03919c88bb01e77a9a2b6b59c_Out_2_Float;
            Unity_Add_float(_OneMinus_87c740d245de388db4fe5f4958de0668_Out_1_Float, _Split_ae16de7cacf9d0878aba1467f193d681_G_2_Float, _Add_9d6e1dd03919c88bb01e77a9a2b6b59c_Out_2_Float);
            float _Add_448f30a2cd792b868416a253a1c502bb_Out_2_Float;
            Unity_Add_float(_Add_9d6e1dd03919c88bb01e77a9a2b6b59c_Out_2_Float, float(1), _Add_448f30a2cd792b868416a253a1c502bb_Out_2_Float);
            float _Clamp_53d91568d0627d8a9cac8deecdd003a8_Out_3_Float;
            Unity_Clamp_float(_Add_448f30a2cd792b868416a253a1c502bb_Out_2_Float, float(0), float(1), _Clamp_53d91568d0627d8a9cac8deecdd003a8_Out_3_Float);
            float _Property_98b8c0fc7e8f9b88b8d7d9dd28ed8aca_Out_0_Float = _Cover_Min_Height_Blending;
            float _Add_0edbe9f424de6d8089b453804bc6ec74_Out_2_Float;
            Unity_Add_float(_Add_9d6e1dd03919c88bb01e77a9a2b6b59c_Out_2_Float, _Property_98b8c0fc7e8f9b88b8d7d9dd28ed8aca_Out_0_Float, _Add_0edbe9f424de6d8089b453804bc6ec74_Out_2_Float);
            float _Divide_bacd243000beaa86b28174bd47716791_Out_2_Float;
            Unity_Divide_float(_Add_0edbe9f424de6d8089b453804bc6ec74_Out_2_Float, _Add_9d6e1dd03919c88bb01e77a9a2b6b59c_Out_2_Float, _Divide_bacd243000beaa86b28174bd47716791_Out_2_Float);
            float _OneMinus_dd51a0c56dbb9b8b8882c6d36bfadd50_Out_1_Float;
            Unity_OneMinus_float(_Divide_bacd243000beaa86b28174bd47716791_Out_2_Float, _OneMinus_dd51a0c56dbb9b8b8882c6d36bfadd50_Out_1_Float);
            float _Add_58dd4a9dfd5655818255c74dd17921da_Out_2_Float;
            Unity_Add_float(_OneMinus_dd51a0c56dbb9b8b8882c6d36bfadd50_Out_1_Float, float(-0.5), _Add_58dd4a9dfd5655818255c74dd17921da_Out_2_Float);
            float _Clamp_5b36f07b81ef6f87a93aefa8fcb815b4_Out_3_Float;
            Unity_Clamp_float(_Add_58dd4a9dfd5655818255c74dd17921da_Out_2_Float, float(0), float(1), _Clamp_5b36f07b81ef6f87a93aefa8fcb815b4_Out_3_Float);
            float _Add_5ef49a57de2cdf85b0e894bfa07f6f14_Out_2_Float;
            Unity_Add_float(_Clamp_53d91568d0627d8a9cac8deecdd003a8_Out_3_Float, _Clamp_5b36f07b81ef6f87a93aefa8fcb815b4_Out_3_Float, _Add_5ef49a57de2cdf85b0e894bfa07f6f14_Out_2_Float);
            float _Clamp_130844801cc2148bb64804d2328686eb_Out_3_Float;
            Unity_Clamp_float(_Add_5ef49a57de2cdf85b0e894bfa07f6f14_Out_2_Float, float(0), float(1), _Clamp_130844801cc2148bb64804d2328686eb_Out_3_Float);
            float _Multiply_4a38c41b77a2458085ff4ae52ba3c21c_Out_2_Float;
            Unity_Multiply_float_float(_Power_ca1f1906c90fb785bfe520b7faefc3cd_Out_2_Float, _Clamp_130844801cc2148bb64804d2328686eb_Out_3_Float, _Multiply_4a38c41b77a2458085ff4ae52ba3c21c_Out_2_Float);
            float _Multiply_edc44afd10069b8e80460ceee1cba8f0_Out_2_Float;
            Unity_Multiply_float_float(_Saturate_04686ab19029f68c8fb9e7a115b207b1_Out_1_Float, _Multiply_4a38c41b77a2458085ff4ae52ba3c21c_Out_2_Float, _Multiply_edc44afd10069b8e80460ceee1cba8f0_Out_2_Float);
            float3 _Lerp_05179f1a9a06b084b2d83e8bce908cce_Out_3_Vector3;
            Unity_Lerp_float3(_NormalBlend_9f531c87e2e45580b1d0f65f06c23526_Out_2_Vector3, _NormalStrength_c4639a6dd3dfde85b591971db2700eaf_Out_2_Vector3, (_Multiply_edc44afd10069b8e80460ceee1cba8f0_Out_2_Float.xxx), _Lerp_05179f1a9a06b084b2d83e8bce908cce_Out_3_Vector3);
            float3 _Transform_d583fb35b7a2838399ae5ff4e71be918_Out_1_Vector3;
            {
                float3x3 tangentTransform = float3x3(IN.WorldSpaceTangent, IN.WorldSpaceBiTangent, IN.WorldSpaceNormal);
                _Transform_d583fb35b7a2838399ae5ff4e71be918_Out_1_Vector3 = TransformTangentToWorldDir(_Lerp_05179f1a9a06b084b2d83e8bce908cce_Out_3_Vector3.xyz, tangentTransform, false).xyz;
            }
            float _Split_44ee9f8d0d54618cabce22ec49a8e7d3_R_1_Float = _Transform_d583fb35b7a2838399ae5ff4e71be918_Out_1_Vector3[0];
            float _Split_44ee9f8d0d54618cabce22ec49a8e7d3_G_2_Float = _Transform_d583fb35b7a2838399ae5ff4e71be918_Out_1_Vector3[1];
            float _Split_44ee9f8d0d54618cabce22ec49a8e7d3_B_3_Float = _Transform_d583fb35b7a2838399ae5ff4e71be918_Out_1_Vector3[2];
            float _Split_44ee9f8d0d54618cabce22ec49a8e7d3_A_4_Float = 0;
            float _Multiply_61fc6a92f0e952858b5d99f2caeb09a3_Out_2_Float;
            Unity_Multiply_float_float(_Split_44ee9f8d0d54618cabce22ec49a8e7d3_G_2_Float, _Clamp_815ffdd53cc1c889aa00f73784cb71e7_Out_3_Float, _Multiply_61fc6a92f0e952858b5d99f2caeb09a3_Out_2_Float);
            float _Multiply_1e7ca8eeb2afb68a96897072c537d835_Out_2_Float;
            Unity_Multiply_float_float(_Clamp_815ffdd53cc1c889aa00f73784cb71e7_Out_3_Float, _Property_4879e96694aee98c9d4ecd329a571123_Out_0_Float, _Multiply_1e7ca8eeb2afb68a96897072c537d835_Out_2_Float);
            float _Multiply_a16d49a3ef8d76899c86b7d84d20ef1f_Out_2_Float;
            Unity_Multiply_float_float(_Multiply_1e7ca8eeb2afb68a96897072c537d835_Out_2_Float, _Multiply_4a38c41b77a2458085ff4ae52ba3c21c_Out_2_Float, _Multiply_a16d49a3ef8d76899c86b7d84d20ef1f_Out_2_Float);
            float _Multiply_dd6ce40548593687a3441a83047275eb_Out_2_Float;
            Unity_Multiply_float_float(_Multiply_61fc6a92f0e952858b5d99f2caeb09a3_Out_2_Float, _Multiply_a16d49a3ef8d76899c86b7d84d20ef1f_Out_2_Float, _Multiply_dd6ce40548593687a3441a83047275eb_Out_2_Float);
            float _Clamp_a3bc14da42d1452f9459b4703c528466_Out_3_Float;
            Unity_Clamp_float(_Multiply_dd6ce40548593687a3441a83047275eb_Out_2_Float, float(0), float(1), _Clamp_a3bc14da42d1452f9459b4703c528466_Out_3_Float);
            float _Multiply_ce9d0ae57259445ba0ff1b83b3eac7be_Out_2_Float;
            Unity_Multiply_float_float(_Clamp_bb1427696ce14fe987f799fecc5f9fac_Out_3_Float, _Clamp_a3bc14da42d1452f9459b4703c528466_Out_3_Float, _Multiply_ce9d0ae57259445ba0ff1b83b3eac7be_Out_2_Float);
            #if defined(_USEDYNAMICCOVERTSTATICMASKF)
            float _UseDynamicCover_5ab22e0469924273a6c7c42f82abda85_Out_0_Float = _Multiply_ce9d0ae57259445ba0ff1b83b3eac7be_Out_2_Float;
            #else
            float _UseDynamicCover_5ab22e0469924273a6c7c42f82abda85_Out_0_Float = _Clamp_bb1427696ce14fe987f799fecc5f9fac_Out_3_Float;
            #endif
            Bindings_UniversalHeighblend_3b5c31b864970d04197cd420b6c4b0fa_float _UniversalHeighblend_21bd55d8d402489499f7ea440e52eb45;
            float _UniversalHeighblend_21bd55d8d402489499f7ea440e52eb45_Heightmap_1_Float;
            SG_UniversalHeighblend_3b5c31b864970d04197cd420b6c4b0fa_float(_Split_a80936a3c75945efb8cf9f2b95c76642_G_2_Float, _Property_14a6757619d64822a44a69b34f85276d_Out_0_Float, _Property_c0d9ffba7dee497c885a54170977d874_Out_0_Boolean, _Split_218e1cfd00b30984921b5fc0ec63de60_B_3_Float, _Add_1f9ea9bdf36544b59f763806e7eea80d_Out_2_Vector2, _Property_0fbef18600294e199eeda9905e3304e4_Out_0_Boolean, _Split_2f45bca363698c859e51492899bc58f8_B_3_Float, _Add_28628d641d58481084e9c00e4ad5fc8d_Out_2_Vector2, _UseDynamicCover_5ab22e0469924273a6c7c42f82abda85_Out_0_Float, _UniversalHeighblend_21bd55d8d402489499f7ea440e52eb45, _UniversalHeighblend_21bd55d8d402489499f7ea440e52eb45_Heightmap_1_Float);
            float _Split_05a25ef5bb1c4867950074f8c86410e8_R_1_Float = IN.VertexColor[0];
            float _Split_05a25ef5bb1c4867950074f8c86410e8_G_2_Float = IN.VertexColor[1];
            float _Split_05a25ef5bb1c4867950074f8c86410e8_B_3_Float = IN.VertexColor[2];
            float _Split_05a25ef5bb1c4867950074f8c86410e8_A_4_Float = IN.VertexColor[3];
            float _OneMinus_0527b7625ff14e8c8ca27817ac4fe9f9_Out_1_Float;
            Unity_OneMinus_float(_Split_05a25ef5bb1c4867950074f8c86410e8_B_3_Float, _OneMinus_0527b7625ff14e8c8ca27817ac4fe9f9_Out_1_Float);
            float _Property_defdd10d24ee4948b18af67062372fb7_Out_0_Float = _VertexColorBBlendStrenght;
            float _Property_f600c3fa0837403fa7000ace8a7aa949_Out_0_Boolean = _USEBaseHeightT;
            float _Property_cc1df5222a194b39870a1906a95881c7_Out_0_Boolean = _USECoverHeightT;
            float _Subtract_df32895ca10a49a6adc84378c30ceb7c_Out_2_Float;
            Unity_Subtract_float(_Property_0e120eb0a0a14b12a31a3c1f5b961121_Out_0_Float, _Property_32b48052fdbb4641bf4eeb294bc65050_Out_0_Float, _Subtract_df32895ca10a49a6adc84378c30ceb7c_Out_2_Float);
            float _Split_a090b28818f34dd8945b893c7fd769f1_R_1_Float = IN.VertexColor[0];
            float _Split_a090b28818f34dd8945b893c7fd769f1_G_2_Float = IN.VertexColor[1];
            float _Split_a090b28818f34dd8945b893c7fd769f1_B_3_Float = IN.VertexColor[2];
            float _Split_a090b28818f34dd8945b893c7fd769f1_A_4_Float = IN.VertexColor[3];
            float _OneMinus_d11f0c4a04b345419edf8e146b9c0221_Out_1_Float;
            Unity_OneMinus_float(_Split_a090b28818f34dd8945b893c7fd769f1_B_3_Float, _OneMinus_d11f0c4a04b345419edf8e146b9c0221_Out_1_Float);
            float _Multiply_b7ff184632b347e9b3d331daaed81a77_Out_2_Float;
            Unity_Multiply_float_float(_Subtract_df32895ca10a49a6adc84378c30ceb7c_Out_2_Float, _OneMinus_d11f0c4a04b345419edf8e146b9c0221_Out_1_Float, _Multiply_b7ff184632b347e9b3d331daaed81a77_Out_2_Float);
            float _Add_ff8ced5a04044788a5de3632a403c505_Out_2_Float;
            Unity_Add_float(_Property_6b467710b0ba48058e003aebe9119249_Out_0_Float, _Multiply_b7ff184632b347e9b3d331daaed81a77_Out_2_Float, _Add_ff8ced5a04044788a5de3632a403c505_Out_2_Float);
            float2 _Add_8ec067f807d04641bea7fd38ab0c8165_Out_2_Vector2;
            Unity_Add_float2(_Vector2_6955747f7f0a4ff98fae60dbada25e89_Out_0_Vector2, (_Add_ff8ced5a04044788a5de3632a403c505_Out_2_Float.xx), _Add_8ec067f807d04641bea7fd38ab0c8165_Out_2_Vector2);
            Bindings_UniversalHeighblend_3b5c31b864970d04197cd420b6c4b0fa_float _UniversalHeighblend_69e2f839a11b4aa7b8e84d65b0ac8307;
            float _UniversalHeighblend_69e2f839a11b4aa7b8e84d65b0ac8307_Heightmap_1_Float;
            SG_UniversalHeighblend_3b5c31b864970d04197cd420b6c4b0fa_float(_OneMinus_0527b7625ff14e8c8ca27817ac4fe9f9_Out_1_Float, _Property_defdd10d24ee4948b18af67062372fb7_Out_0_Float, _Property_f600c3fa0837403fa7000ace8a7aa949_Out_0_Boolean, _Split_218e1cfd00b30984921b5fc0ec63de60_B_3_Float, _Add_1f9ea9bdf36544b59f763806e7eea80d_Out_2_Vector2, _Property_cc1df5222a194b39870a1906a95881c7_Out_0_Boolean, _Split_2f45bca363698c859e51492899bc58f8_B_3_Float, _Add_8ec067f807d04641bea7fd38ab0c8165_Out_2_Vector2, float(1), _UniversalHeighblend_69e2f839a11b4aa7b8e84d65b0ac8307, _UniversalHeighblend_69e2f839a11b4aa7b8e84d65b0ac8307_Heightmap_1_Float);
            float _Add_facc0ab0661749d4bda41177c639b438_Out_2_Float;
            Unity_Add_float(_UniversalHeighblend_21bd55d8d402489499f7ea440e52eb45_Heightmap_1_Float, _UniversalHeighblend_69e2f839a11b4aa7b8e84d65b0ac8307_Heightmap_1_Float, _Add_facc0ab0661749d4bda41177c639b438_Out_2_Float);
            float _Saturate_269cfab86e2abe83819a3afa7b3eeda2_Out_1_Float;
            Unity_Saturate_float(_Add_facc0ab0661749d4bda41177c639b438_Out_2_Float, _Saturate_269cfab86e2abe83819a3afa7b3eeda2_Out_1_Float);
            float3 _Lerp_337d63ad6393ae88af4c89b066722a45_Out_3_Vector3;
            Unity_Lerp_float3(_NormalBlend_9f531c87e2e45580b1d0f65f06c23526_Out_2_Vector3, _NormalStrength_76b1f6b709c2558a897aa152a50733b3_Out_2_Vector3, (_Saturate_269cfab86e2abe83819a3afa7b3eeda2_Out_1_Float.xxx), _Lerp_337d63ad6393ae88af4c89b066722a45_Out_3_Vector3);
            UnityTexture2D _Property_821e07b38fd0a08d85c4dd6e5b6bbac9_Out_0_Texture2D = UnityBuildTexture2DStructNoScale(_BaseColorMap);
            Bindings_PlanarNM_c0f081da9c567704ea36e7dd38cedcf6_float _PlanarNM_cb7ded32e6af3382bbe06b62977afab6;
            _PlanarNM_cb7ded32e6af3382bbe06b62977afab6.AbsoluteWorldSpacePosition = IN.AbsoluteWorldSpacePosition;
            _PlanarNM_cb7ded32e6af3382bbe06b62977afab6.uv0 = IN.uv0;
            _PlanarNM_cb7ded32e6af3382bbe06b62977afab6.uv3 = IN.uv3;
            float4 _PlanarNM_cb7ded32e6af3382bbe06b62977afab6_XZ_2_Vector4;
            SG_PlanarNM_c0f081da9c567704ea36e7dd38cedcf6_float(_Property_821e07b38fd0a08d85c4dd6e5b6bbac9_Out_0_Texture2D, _Property_8ec0d512145619859d288abab740e3bf_Out_0_Vector4, _Property_122c0f9ef0a1c4818a140c75e512abe4_Out_0_Boolean, UnityBuildSamplerStateStruct(SamplerState_Linear_Repeat_Aniso8), 1, _PlanarNM_cb7ded32e6af3382bbe06b62977afab6, _PlanarNM_cb7ded32e6af3382bbe06b62977afab6_XZ_2_Vector4);
            float4 _Property_41859d117584758eb8002ecc938f9bce_Out_0_Vector4 = _BaseColor;
            float4 _Multiply_4d0f82599060228a9092027fd43912c8_Out_2_Vector4;
            Unity_Multiply_float4_float4(_PlanarNM_cb7ded32e6af3382bbe06b62977afab6_XZ_2_Vector4, _Property_41859d117584758eb8002ecc938f9bce_Out_0_Vector4, _Multiply_4d0f82599060228a9092027fd43912c8_Out_2_Vector4);
            float3 _ColorspaceConversion_30c5042ef70343cd92056cde73cd3ecb_Out_1_Vector3;
            Unity_ColorspaceConversion_Linear_RGB_float((_Multiply_4d0f82599060228a9092027fd43912c8_Out_2_Vector4.xyz), _ColorspaceConversion_30c5042ef70343cd92056cde73cd3ecb_Out_1_Vector3);
            float _Property_605f29777330a58ba88ac032e905433b_Out_0_Float = _DetailAlbedoScale;
            float3 _Blend_de85bf99257f4eb7bb321fd973539f10_Out_2_Vector3;
            Unity_Blend_Overlay_float3(_ColorspaceConversion_30c5042ef70343cd92056cde73cd3ecb_Out_1_Vector3, (_SampleTexture2D_d8eb0186b9a0cd819cde65431b4ea5ea_R_4_Float.xxx), _Blend_de85bf99257f4eb7bb321fd973539f10_Out_2_Vector3, _Property_605f29777330a58ba88ac032e905433b_Out_0_Float);
            float3 _ColorspaceConversion_635670d250654503b34efa53a99ba43e_Out_1_Vector3;
            Unity_ColorspaceConversion_RGB_Linear_float(_Blend_de85bf99257f4eb7bb321fd973539f10_Out_2_Vector3, _ColorspaceConversion_635670d250654503b34efa53a99ba43e_Out_1_Vector3);
            float3 _Clamp_8913f48f801c43c2879f2e1ce926507e_Out_3_Vector3;
            Unity_Clamp_float3(_ColorspaceConversion_635670d250654503b34efa53a99ba43e_Out_1_Vector3, float3(0, 0, 0), float3(1, 1, 1), _Clamp_8913f48f801c43c2879f2e1ce926507e_Out_3_Vector3);
            float _Split_ddfe447fbb7845e88cc5cfb8158b2248_R_1_Float = _Clamp_8913f48f801c43c2879f2e1ce926507e_Out_3_Vector3[0];
            float _Split_ddfe447fbb7845e88cc5cfb8158b2248_G_2_Float = _Clamp_8913f48f801c43c2879f2e1ce926507e_Out_3_Vector3[1];
            float _Split_ddfe447fbb7845e88cc5cfb8158b2248_B_3_Float = _Clamp_8913f48f801c43c2879f2e1ce926507e_Out_3_Vector3[2];
            float _Split_ddfe447fbb7845e88cc5cfb8158b2248_A_4_Float = 0;
            float _Split_6d7debfd2b20440e932d58108f8e7f75_R_1_Float = _Multiply_4d0f82599060228a9092027fd43912c8_Out_2_Vector4[0];
            float _Split_6d7debfd2b20440e932d58108f8e7f75_G_2_Float = _Multiply_4d0f82599060228a9092027fd43912c8_Out_2_Vector4[1];
            float _Split_6d7debfd2b20440e932d58108f8e7f75_B_3_Float = _Multiply_4d0f82599060228a9092027fd43912c8_Out_2_Vector4[2];
            float _Split_6d7debfd2b20440e932d58108f8e7f75_A_4_Float = _Multiply_4d0f82599060228a9092027fd43912c8_Out_2_Vector4[3];
            float4 _Combine_b0f28916143e4b94af6bec53f5328b52_RGBA_4_Vector4;
            float3 _Combine_b0f28916143e4b94af6bec53f5328b52_RGB_5_Vector3;
            float2 _Combine_b0f28916143e4b94af6bec53f5328b52_RG_6_Vector2;
            Unity_Combine_float(_Split_ddfe447fbb7845e88cc5cfb8158b2248_R_1_Float, _Split_ddfe447fbb7845e88cc5cfb8158b2248_G_2_Float, _Split_ddfe447fbb7845e88cc5cfb8158b2248_B_3_Float, _Split_6d7debfd2b20440e932d58108f8e7f75_A_4_Float, _Combine_b0f28916143e4b94af6bec53f5328b52_RGBA_4_Vector4, _Combine_b0f28916143e4b94af6bec53f5328b52_RGB_5_Vector3, _Combine_b0f28916143e4b94af6bec53f5328b52_RG_6_Vector2);
            UnityTexture2D _Property_a155ddc33ed90685a5ab0edcf158a343_Out_0_Texture2D = UnityBuildTexture2DStructNoScale(_CoverBaseColorMap);
            Bindings_PlanarNM_c0f081da9c567704ea36e7dd38cedcf6_float _PlanarNM_e00e057d3d7c4181b1c7775c6ebbab5b;
            _PlanarNM_e00e057d3d7c4181b1c7775c6ebbab5b.AbsoluteWorldSpacePosition = IN.AbsoluteWorldSpacePosition;
            _PlanarNM_e00e057d3d7c4181b1c7775c6ebbab5b.uv0 = IN.uv0;
            _PlanarNM_e00e057d3d7c4181b1c7775c6ebbab5b.uv3 = IN.uv3;
            float4 _PlanarNM_e00e057d3d7c4181b1c7775c6ebbab5b_XZ_2_Vector4;
            SG_PlanarNM_c0f081da9c567704ea36e7dd38cedcf6_float(_Property_a155ddc33ed90685a5ab0edcf158a343_Out_0_Texture2D, _Property_256beda96caf2d8aa05d3de41fc08d3d_Out_0_Vector4, _Property_bd9dfe8dd615798f9f2d72d139e56d61_Out_0_Boolean, UnityBuildSamplerStateStruct(SamplerState_Linear_Repeat_Aniso8), 1, _PlanarNM_e00e057d3d7c4181b1c7775c6ebbab5b, _PlanarNM_e00e057d3d7c4181b1c7775c6ebbab5b_XZ_2_Vector4);
            float4 _Property_c3be5593fd661b8dafbd04f26b8ec9ac_Out_0_Vector4 = _CoverBaseColor;
            float4 _Multiply_b08794693505bd8e8c04b9ba1610d394_Out_2_Vector4;
            Unity_Multiply_float4_float4(_PlanarNM_e00e057d3d7c4181b1c7775c6ebbab5b_XZ_2_Vector4, _Property_c3be5593fd661b8dafbd04f26b8ec9ac_Out_0_Vector4, _Multiply_b08794693505bd8e8c04b9ba1610d394_Out_2_Vector4);
            float4 _Lerp_562b79f1df34b88e9a8a7431d434b435_Out_3_Vector4;
            Unity_Lerp_float4(_Combine_b0f28916143e4b94af6bec53f5328b52_RGBA_4_Vector4, _Multiply_b08794693505bd8e8c04b9ba1610d394_Out_2_Vector4, (_Saturate_269cfab86e2abe83819a3afa7b3eeda2_Out_1_Float.xxxx), _Lerp_562b79f1df34b88e9a8a7431d434b435_Out_3_Vector4);
            float _Split_546cdec490fe4753bb0983eea82b45b5_R_1_Float = _Lerp_562b79f1df34b88e9a8a7431d434b435_Out_3_Vector4[0];
            float _Split_546cdec490fe4753bb0983eea82b45b5_G_2_Float = _Lerp_562b79f1df34b88e9a8a7431d434b435_Out_3_Vector4[1];
            float _Split_546cdec490fe4753bb0983eea82b45b5_B_3_Float = _Lerp_562b79f1df34b88e9a8a7431d434b435_Out_3_Vector4[2];
            float _Split_546cdec490fe4753bb0983eea82b45b5_A_4_Float = _Lerp_562b79f1df34b88e9a8a7431d434b435_Out_3_Vector4[3];
            float4 _Clamp_33ec4dd182654e108c0f4ee43f91e820_Out_3_Vector4;
            Unity_Clamp_float4(IN.VertexColor, float4(0, 0, 0, 0), float4(1, 1, 1, 1), _Clamp_33ec4dd182654e108c0f4ee43f91e820_Out_3_Vector4);
            float _Split_5b2299b48b10138ea40c141b79bfe90e_R_1_Float = _Clamp_33ec4dd182654e108c0f4ee43f91e820_Out_3_Vector4[0];
            float _Split_5b2299b48b10138ea40c141b79bfe90e_G_2_Float = _Clamp_33ec4dd182654e108c0f4ee43f91e820_Out_3_Vector4[1];
            float _Split_5b2299b48b10138ea40c141b79bfe90e_B_3_Float = _Clamp_33ec4dd182654e108c0f4ee43f91e820_Out_3_Vector4[2];
            float _Split_5b2299b48b10138ea40c141b79bfe90e_A_4_Float = _Clamp_33ec4dd182654e108c0f4ee43f91e820_Out_3_Vector4[3];
            float _Multiply_a7796e97d268424b880f9cb87fc6e42c_Out_2_Float;
            Unity_Multiply_float_float(_Split_546cdec490fe4753bb0983eea82b45b5_A_4_Float, _Split_5b2299b48b10138ea40c141b79bfe90e_A_4_Float, _Multiply_a7796e97d268424b880f9cb87fc6e42c_Out_2_Float);
            float _Property_7ae68b65d6ed4f37aec08ecb89701e8e_Out_0_Float = _AlphaCutoff;
            surface.NormalTS = _Lerp_337d63ad6393ae88af4c89b066722a45_Out_3_Vector3;
            surface.Alpha = _Multiply_a7796e97d268424b880f9cb87fc6e42c_Out_2_Float;
            surface.AlphaClipThreshold = _Property_7ae68b65d6ed4f37aec08ecb89701e8e_Out_0_Float;
            return surface;
        }
        
        // --------------------------------------------------
        // Build Graph Inputs
        #ifdef HAVE_VFX_MODIFICATION
        #define VFX_SRP_ATTRIBUTES Attributes
        #define VFX_SRP_VARYINGS Varyings
        #define VFX_SRP_SURFACE_INPUTS SurfaceDescriptionInputs
        #endif
        VertexDescriptionInputs BuildVertexDescriptionInputs(Attributes input)
        {
            VertexDescriptionInputs output;
            ZERO_INITIALIZE(VertexDescriptionInputs, output);
        
            output.ObjectSpaceNormal =                          input.normalOS;
            output.ObjectSpaceTangent =                         input.tangentOS.xyz;
            output.ObjectSpacePosition =                        input.positionOS;
        #if UNITY_ANY_INSTANCING_ENABLED
        #else // TODO: XR support for procedural instancing because in this case UNITY_ANY_INSTANCING_ENABLED is not defined and instanceID is incorrect.
        #endif
        
            return output;
        }
        SurfaceDescriptionInputs BuildSurfaceDescriptionInputs(Varyings input)
        {
            SurfaceDescriptionInputs output;
            ZERO_INITIALIZE(SurfaceDescriptionInputs, output);
        
        #ifdef HAVE_VFX_MODIFICATION
        #if VFX_USE_GRAPH_VALUES
            uint instanceActiveIndex = asuint(UNITY_ACCESS_INSTANCED_PROP(PerInstance, _InstanceActiveIndex));
            /* WARNING: $splice Could not find named fragment 'VFXLoadGraphValues' */
        #endif
            /* WARNING: $splice Could not find named fragment 'VFXSetFragInputs' */
        
        #endif
        
            
        
            // must use interpolated tangent, bitangent and normal before they are normalized in the pixel shader.
            float3 unnormalizedNormalWS = input.normalWS;
            const float renormFactor = 1.0 / length(unnormalizedNormalWS);
        
            // use bitangent on the fly like in hdrp
            // IMPORTANT! If we ever support Flip on double sided materials ensure bitangent and tangent are NOT flipped.
            float crossSign = (input.tangentWS.w > 0.0 ? 1.0 : -1.0)* GetOddNegativeScale();
            float3 bitang = crossSign * cross(input.normalWS.xyz, input.tangentWS.xyz);
        
            output.WorldSpaceNormal = renormFactor * input.normalWS.xyz;      // we want a unit length Normal Vector node in shader graph
            output.TangentSpaceNormal = float3(0.0f, 0.0f, 1.0f);
        
            // to pr               eserve mikktspace compliance we use same scale renormFactor as was used on the normal.
            // This                is explained in section 2.2 in "surface gradient based bump mapping framework"
            output.WorldSpaceTangent = renormFactor * input.tangentWS.xyz;
            output.WorldSpaceBiTangent = renormFactor * bitang;
        
            output.AbsoluteWorldSpacePosition = GetAbsolutePositionWS(input.positionWS);
        
            #if UNITY_UV_STARTS_AT_TOP
            #else
            #endif
        
        
            output.uv0 = input.texCoord0;
            output.uv3 = input.texCoord3;
            output.VertexColor = input.color;
        #if UNITY_ANY_INSTANCING_ENABLED
        #else // TODO: XR support for procedural instancing because in this case UNITY_ANY_INSTANCING_ENABLED is not defined and instanceID is incorrect.
        #endif
        #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
        #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN output.FaceSign =                    IS_FRONT_VFACE(input.cullFace, true, false);
        #else
        #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
        #endif
        #undef BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
        
                return output;
        }
        
        // --------------------------------------------------
        // Main
        
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/Varyings.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/DepthNormalsOnlyPass.hlsl"
        
        // --------------------------------------------------
        // Visual Effect Vertex Invocations
        #ifdef HAVE_VFX_MODIFICATION
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/VisualEffectVertex.hlsl"
        #endif
        
        ENDHLSL
        }
        Pass
        {
            Name "Meta"
            Tags
            {
                "LightMode" = "Meta"
            }
        
        // Render State
        Cull Off
        
        // Debug
        // <None>
        
        // --------------------------------------------------
        // Pass
        
        HLSLPROGRAM
        
        // Pragmas
        #pragma target 2.0
        #pragma vertex vert
        #pragma fragment frag
        
        // Keywords
        #pragma shader_feature _ EDITOR_VISUALIZATION
        #pragma shader_feature_local_fragment _ _ALPHATEST_ON
        #pragma shader_feature_local _ _USEDYNAMICCOVERTSTATICMASKF
        #pragma shader_feature_local _ _WETNESS_T_HEAT_F
        
        #if defined(_USEDYNAMICCOVERTSTATICMASKF) && defined(_WETNESS_T_HEAT_F)
            #define KEYWORD_PERMUTATION_0
        #elif defined(_USEDYNAMICCOVERTSTATICMASKF)
            #define KEYWORD_PERMUTATION_1
        #elif defined(_WETNESS_T_HEAT_F)
            #define KEYWORD_PERMUTATION_2
        #else
            #define KEYWORD_PERMUTATION_3
        #endif
        
        
        // Defines
        
        #define _NORMALMAP 1
        #define _NORMAL_DROPOFF_TS 1
        #define ATTRIBUTES_NEED_NORMAL
        #define ATTRIBUTES_NEED_TANGENT
        #define ATTRIBUTES_NEED_TEXCOORD0
        #define ATTRIBUTES_NEED_TEXCOORD1
        #define ATTRIBUTES_NEED_TEXCOORD2
        #define ATTRIBUTES_NEED_TEXCOORD3
        #define ATTRIBUTES_NEED_COLOR
        #define ATTRIBUTES_NEED_INSTANCEID
        #define FEATURES_GRAPH_VERTEX_NORMAL_OUTPUT
        #define FEATURES_GRAPH_VERTEX_TANGENT_OUTPUT
        #define VARYINGS_NEED_POSITION_WS
        #define VARYINGS_NEED_NORMAL_WS
        #define VARYINGS_NEED_TANGENT_WS
        #define VARYINGS_NEED_TEXCOORD0
        #define VARYINGS_NEED_TEXCOORD1
        #define VARYINGS_NEED_TEXCOORD2
        #define VARYINGS_NEED_TEXCOORD3
        #define VARYINGS_NEED_COLOR
        #define FEATURES_GRAPH_VERTEX
        /* WARNING: $splice Could not find named fragment 'PassInstancing' */
        #define SHADERPASS SHADERPASS_META
        #define _FOG_FRAGMENT 1
        
        
        // custom interpolator pre-include
        /* WARNING: $splice Could not find named fragment 'sgci_CustomInterpolatorPreInclude' */
        
        // Includes
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Texture.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
        #include_with_pragmas "Packages/com.unity.render-pipelines.core/ShaderLibrary/FoveatedRenderingKeywords.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/FoveatedRendering.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Input.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/TextureStack.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/DebugMipmapStreamingMacros.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/MetaInput.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShaderPass.hlsl"
        
        // --------------------------------------------------
        // Structs and Packing
        
        // custom interpolators pre packing
        /* WARNING: $splice Could not find named fragment 'CustomInterpolatorPrePacking' */
        
        struct Attributes
        {
             float3 positionOS : POSITION;
             float3 normalOS : NORMAL;
             float4 tangentOS : TANGENT;
             float4 uv0 : TEXCOORD0;
             float4 uv1 : TEXCOORD1;
             float4 uv2 : TEXCOORD2;
             float4 uv3 : TEXCOORD3;
             float4 color : COLOR;
            #if UNITY_ANY_INSTANCING_ENABLED || defined(ATTRIBUTES_NEED_INSTANCEID)
             uint instanceID : INSTANCEID_SEMANTIC;
            #endif
        };
        struct Varyings
        {
             float4 positionCS : SV_POSITION;
             float3 positionWS;
             float3 normalWS;
             float4 tangentWS;
             float4 texCoord0;
             float4 texCoord1;
             float4 texCoord2;
             float4 texCoord3;
             float4 color;
            #if UNITY_ANY_INSTANCING_ENABLED || defined(VARYINGS_NEED_INSTANCEID)
             uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
             uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
             uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
             FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
        };
        struct SurfaceDescriptionInputs
        {
             float3 WorldSpaceNormal;
             float3 WorldSpaceTangent;
             float3 WorldSpaceBiTangent;
             float3 WorldSpaceViewDirection;
             float3 TangentSpaceViewDirection;
             float3 AbsoluteWorldSpacePosition;
             float4 uv0;
             float4 uv3;
             float4 VertexColor;
        };
        struct VertexDescriptionInputs
        {
             float3 ObjectSpaceNormal;
             float3 ObjectSpaceTangent;
             float3 ObjectSpacePosition;
        };
        struct PackedVaryings
        {
             float4 positionCS : SV_POSITION;
             float4 tangentWS : INTERP0;
             float4 texCoord0 : INTERP1;
             float4 texCoord1 : INTERP2;
             float4 texCoord2 : INTERP3;
             float4 texCoord3 : INTERP4;
             float4 color : INTERP5;
             float3 positionWS : INTERP6;
             float3 normalWS : INTERP7;
            #if UNITY_ANY_INSTANCING_ENABLED || defined(VARYINGS_NEED_INSTANCEID)
             uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
             uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
             uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
             FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
        };
        
        PackedVaryings PackVaryings (Varyings input)
        {
            PackedVaryings output;
            ZERO_INITIALIZE(PackedVaryings, output);
            output.positionCS = input.positionCS;
            output.tangentWS.xyzw = input.tangentWS;
            output.texCoord0.xyzw = input.texCoord0;
            output.texCoord1.xyzw = input.texCoord1;
            output.texCoord2.xyzw = input.texCoord2;
            output.texCoord3.xyzw = input.texCoord3;
            output.color.xyzw = input.color;
            output.positionWS.xyz = input.positionWS;
            output.normalWS.xyz = input.normalWS;
            #if UNITY_ANY_INSTANCING_ENABLED || defined(VARYINGS_NEED_INSTANCEID)
            output.instanceID = input.instanceID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            output.cullFace = input.cullFace;
            #endif
            return output;
        }
        
        Varyings UnpackVaryings (PackedVaryings input)
        {
            Varyings output;
            output.positionCS = input.positionCS;
            output.tangentWS = input.tangentWS.xyzw;
            output.texCoord0 = input.texCoord0.xyzw;
            output.texCoord1 = input.texCoord1.xyzw;
            output.texCoord2 = input.texCoord2.xyzw;
            output.texCoord3 = input.texCoord3.xyzw;
            output.color = input.color.xyzw;
            output.positionWS = input.positionWS.xyz;
            output.normalWS = input.normalWS.xyz;
            #if UNITY_ANY_INSTANCING_ENABLED || defined(VARYINGS_NEED_INSTANCEID)
            output.instanceID = input.instanceID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            output.cullFace = input.cullFace;
            #endif
            return output;
        }
        
        
        // --------------------------------------------------
        // Graph
        
        // Graph Properties
        CBUFFER_START(UnityPerMaterial)
        float _EmissionNoiseMultiply;
        float _EmissionNoisePower;
        float Emission_Noise_UV0_UV3;
        float _EmissionNoiseUsePlanarUV;
        float _BaseEmissionMaskTreshold;
        float _CoverEmissionMaskIntensivity;
        float _CoverEmissionMaskTreshold;
        float4 _RimColor;
        float _RimLightPower;
        float4 _Noise_TexelSize;
        float2 _NoiseSpeed;
        float _BaseEmissionMaskIntensivity;
        float4 _LavaEmissionColor;
        float4 _Emission_Noise_Tiling_and_Offset;
        float _Cover_Mask_A_Remap_Min;
        float _Cover_Mask_A_Remap_Max;
        float _HeightMin;
        float _HeightMax;
        float _HeightOffset;
        float _VertexColorBBlendStrenght;
        float _USECoverHeightT;
        float _AlphaCutoff;
        float4 _WetColor;
        float4 _BaseColor;
        float _USEBaseHeightT;
        float4 _BaseColorMap_TexelSize;
        float _BaseUsePlanarUV;
        float4 _BaseTilingOffset;
        float4 _BaseNormalMap_TexelSize;
        float _BaseNormalScale;
        float4 _BaseMaskMap_TexelSize;
        float _BaseMetallic;
        float _VertexColorGBlendStrenght;
        float _BaseAORemapMin;
        float _BaseAORemapMax;
        float _BaseSmoothnessRemapMin;
        float _BaseSmoothnessRemapMax;
        float4 _Masks_TexelSize;
        float _Cover_Amount;
        float _Cover_Amount_Grow_Speed;
        float _Cover_Max_Angle;
        float _Cover_Min_Height;
        float _Cover_Min_Height_Blending;
        float4 _CoverBaseColor;
        float4 _CoverBaseColorMap_TexelSize;
        float _CoverUsePlanarUV;
        float4 _CoverTilingOffset;
        float4 _CoverNormalMap_TexelSize;
        float _CoverNormalScale;
        float _CoverNormalBlendHardness;
        float _CoverHardness;
        float _CoverHeightMapMin;
        float _CoverHeightMapMax;
        float _CoverHeightMapOffset;
        float4 _CoverMaskMap_TexelSize;
        float _CoverMetallic;
        float _CoverAORemapMin;
        float _CoverAORemapMax;
        float _CoverSmoothnessRemapMin;
        float _CoverSmoothnessRemapMax;
        float4 _DetailMap_TexelSize;
        float4 _DetailTilingOffset;
        float _DetailAlbedoScale;
        float _DetailNormalScale;
        float _DetailSmoothnessScale;
        float _WetSmoothness;
        UNITY_TEXTURE_STREAMING_DEBUG_VARS;
        CBUFFER_END
        
        
        // Object and Global properties
        SAMPLER(SamplerState_Linear_Repeat);
        SAMPLER(SamplerState_Linear_Repeat_Aniso8);
        TEXTURE2D(_Noise);
        SAMPLER(sampler_Noise);
        TEXTURE2D(_BaseColorMap);
        SAMPLER(sampler_BaseColorMap);
        TEXTURE2D(_BaseNormalMap);
        SAMPLER(sampler_BaseNormalMap);
        TEXTURE2D(_BaseMaskMap);
        SAMPLER(sampler_BaseMaskMap);
        TEXTURE2D(_Masks);
        SAMPLER(sampler_Masks);
        TEXTURE2D(_CoverBaseColorMap);
        SAMPLER(sampler_CoverBaseColorMap);
        TEXTURE2D(_CoverNormalMap);
        SAMPLER(sampler_CoverNormalMap);
        TEXTURE2D(_CoverMaskMap);
        SAMPLER(sampler_CoverMaskMap);
        TEXTURE2D(_DetailMap);
        SAMPLER(sampler_DetailMap);
        
        // Graph Includes
        // GraphIncludes: <None>
        
        // -- Property used by ScenePickingPass
        #ifdef SCENEPICKINGPASS
        float4 _SelectionID;
        #endif
        
        // -- Properties used by SceneSelectionPass
        #ifdef SCENESELECTIONPASS
        int _ObjectId;
        int _PassValue;
        #endif
        
        // Graph Functions
        
        void Unity_Combine_float(float R, float G, float B, float A, out float4 RGBA, out float3 RGB, out float2 RG)
        {
            RGBA = float4(R, G, B, A);
            RGB = float3(R, G, B);
            RG = float2(R, G);
        }
        
        void Unity_Divide_float(float A, float B, out float Out)
        {
            Out = A / B;
        }
        
        void Unity_Multiply_float4_float4(float4 A, float4 B, out float4 Out)
        {
        Out = A * B;
        }
        
        void Unity_Branch_float4(float Predicate, float4 True, float4 False, out float4 Out)
        {
            Out = Predicate ? True : False;
        }
        
        void Unity_TilingAndOffset_float(float2 UV, float2 Tiling, float2 Offset, out float2 Out)
        {
            Out = UV * Tiling + Offset;
        }
        
        void Unity_Branch_float2(float Predicate, float2 True, float2 False, out float2 Out)
        {
            Out = Predicate ? True : False;
        }
        
        struct Bindings_PlanarNM_c0f081da9c567704ea36e7dd38cedcf6_float
        {
        float3 AbsoluteWorldSpacePosition;
        half4 uv0;
        half4 uv3;
        };
        
        void SG_PlanarNM_c0f081da9c567704ea36e7dd38cedcf6_float(UnityTexture2D Texture2D_80A3D28F, float4 Vector4_2EBA7A3B, float Boolean_7ABB9909, UnitySamplerState _SamplerState, float Boolean_5ddfe6daabcc4715a44b5f34fc19becb, Bindings_PlanarNM_c0f081da9c567704ea36e7dd38cedcf6_float IN, out float4 XZ_2)
        {
        UnityTexture2D _Property_3e01b4d2fc68d48ba3acbba9d5881e59_Out_0_Texture2D = Texture2D_80A3D28F;
        float _Property_30834f691775a0898a45b1c868520436_Out_0_Boolean = Boolean_7ABB9909;
        float _Split_89ed63cb625cb3878c183d0b71c03400_R_1_Float = IN.AbsoluteWorldSpacePosition[0];
        float _Split_89ed63cb625cb3878c183d0b71c03400_G_2_Float = IN.AbsoluteWorldSpacePosition[1];
        float _Split_89ed63cb625cb3878c183d0b71c03400_B_3_Float = IN.AbsoluteWorldSpacePosition[2];
        float _Split_89ed63cb625cb3878c183d0b71c03400_A_4_Float = 0;
        float4 _Combine_cf2d04ff119ad88493f6460431765cbb_RGBA_4_Vector4;
        float3 _Combine_cf2d04ff119ad88493f6460431765cbb_RGB_5_Vector3;
        float2 _Combine_cf2d04ff119ad88493f6460431765cbb_RG_6_Vector2;
        Unity_Combine_float(_Split_89ed63cb625cb3878c183d0b71c03400_R_1_Float, _Split_89ed63cb625cb3878c183d0b71c03400_B_3_Float, float(0), float(0), _Combine_cf2d04ff119ad88493f6460431765cbb_RGBA_4_Vector4, _Combine_cf2d04ff119ad88493f6460431765cbb_RGB_5_Vector3, _Combine_cf2d04ff119ad88493f6460431765cbb_RG_6_Vector2);
        float4 _Property_8a66888ec47d0687ab1cb2f8abdc9da8_Out_0_Vector4 = Vector4_2EBA7A3B;
        float _Split_2f0f52f6ef8c0e81af0da6476402bc1f_R_1_Float = _Property_8a66888ec47d0687ab1cb2f8abdc9da8_Out_0_Vector4[0];
        float _Split_2f0f52f6ef8c0e81af0da6476402bc1f_G_2_Float = _Property_8a66888ec47d0687ab1cb2f8abdc9da8_Out_0_Vector4[1];
        float _Split_2f0f52f6ef8c0e81af0da6476402bc1f_B_3_Float = _Property_8a66888ec47d0687ab1cb2f8abdc9da8_Out_0_Vector4[2];
        float _Split_2f0f52f6ef8c0e81af0da6476402bc1f_A_4_Float = _Property_8a66888ec47d0687ab1cb2f8abdc9da8_Out_0_Vector4[3];
        float _Divide_e64179199923c58289b6aa94ea6c9178_Out_2_Float;
        Unity_Divide_float(float(1), _Split_2f0f52f6ef8c0e81af0da6476402bc1f_R_1_Float, _Divide_e64179199923c58289b6aa94ea6c9178_Out_2_Float);
        float4 _Multiply_14cec4902d0a00829e4555071a1b8ad1_Out_2_Vector4;
        Unity_Multiply_float4_float4(_Combine_cf2d04ff119ad88493f6460431765cbb_RGBA_4_Vector4, (_Divide_e64179199923c58289b6aa94ea6c9178_Out_2_Float.xxxx), _Multiply_14cec4902d0a00829e4555071a1b8ad1_Out_2_Vector4);
        float _Property_f17c7bf877e64b6abdd66b1fe9f5accc_Out_0_Boolean = Boolean_5ddfe6daabcc4715a44b5f34fc19becb;
        float4 _UV_029e8e8198564838b9389b902a09fb22_Out_0_Vector4 = IN.uv0;
        float4 _UV_7a6209af1506424fb75c81e87e42035a_Out_0_Vector4 = IN.uv3;
        float4 _Branch_fc37bb4bf641457cbbc6e290603056ff_Out_3_Vector4;
        Unity_Branch_float4(_Property_f17c7bf877e64b6abdd66b1fe9f5accc_Out_0_Boolean, _UV_029e8e8198564838b9389b902a09fb22_Out_0_Vector4, _UV_7a6209af1506424fb75c81e87e42035a_Out_0_Vector4, _Branch_fc37bb4bf641457cbbc6e290603056ff_Out_3_Vector4);
        float2 _Vector2_16c15d3bbdd14b85bd48e3a6cb318af7_Out_0_Vector2 = float2(_Split_2f0f52f6ef8c0e81af0da6476402bc1f_R_1_Float, _Split_2f0f52f6ef8c0e81af0da6476402bc1f_G_2_Float);
        float2 _Vector2_f8d75f54e7705083bbec539a60185577_Out_0_Vector2 = float2(_Split_2f0f52f6ef8c0e81af0da6476402bc1f_B_3_Float, _Split_2f0f52f6ef8c0e81af0da6476402bc1f_A_4_Float);
        float2 _TilingAndOffset_d91e2d25acd34686b562b7fe7e9d1d27_Out_3_Vector2;
        Unity_TilingAndOffset_float((_Branch_fc37bb4bf641457cbbc6e290603056ff_Out_3_Vector4.xy), _Vector2_16c15d3bbdd14b85bd48e3a6cb318af7_Out_0_Vector2, _Vector2_f8d75f54e7705083bbec539a60185577_Out_0_Vector2, _TilingAndOffset_d91e2d25acd34686b562b7fe7e9d1d27_Out_3_Vector2);
        float2 _Branch_8e5a4e8f4d52fc8aadd1f46485afc933_Out_3_Vector2;
        Unity_Branch_float2(_Property_30834f691775a0898a45b1c868520436_Out_0_Boolean, (_Multiply_14cec4902d0a00829e4555071a1b8ad1_Out_2_Vector4.xy), _TilingAndOffset_d91e2d25acd34686b562b7fe7e9d1d27_Out_3_Vector2, _Branch_8e5a4e8f4d52fc8aadd1f46485afc933_Out_3_Vector2);
        UnitySamplerState _Property_e8746b9475c94530ba35ba8019ad2ae0_Out_0_SamplerState = _SamplerState;
        float4 _SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_RGBA_0_Vector4 = SAMPLE_TEXTURE2D(_Property_3e01b4d2fc68d48ba3acbba9d5881e59_Out_0_Texture2D.tex, _Property_e8746b9475c94530ba35ba8019ad2ae0_Out_0_SamplerState.samplerstate, _Property_3e01b4d2fc68d48ba3acbba9d5881e59_Out_0_Texture2D.GetTransformedUV(_Branch_8e5a4e8f4d52fc8aadd1f46485afc933_Out_3_Vector2) );
        float _SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_R_4_Float = _SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_RGBA_0_Vector4.r;
        float _SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_G_5_Float = _SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_RGBA_0_Vector4.g;
        float _SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_B_6_Float = _SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_RGBA_0_Vector4.b;
        float _SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_A_7_Float = _SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_RGBA_0_Vector4.a;
        XZ_2 = _SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_RGBA_0_Vector4;
        }
        
        void Unity_ColorspaceConversion_Linear_RGB_float(float3 In, out float3 Out)
        {
            float3 sRGBLo = In * 12.92;
            float3 sRGBHi = (pow(max(abs(In), 1.192092896e-07), float3(1.0 / 2.4, 1.0 / 2.4, 1.0 / 2.4)) * 1.055) - 0.055;
            Out = float3(In <= 0.0031308) ? sRGBLo : sRGBHi;
        }
        
        void Unity_Blend_Overlay_float3(float3 Base, float3 Blend, out float3 Out, float Opacity)
        {
            float3 result1 = 1.0 - 2.0 * (1.0 - Base) * (1.0 - Blend);
            float3 result2 = 2.0 * Base * Blend;
            float3 zeroOrOne = step(Base, 0.5);
            Out = result2 * zeroOrOne + (1 - zeroOrOne) * result1;
            Out = lerp(Base, Out, Opacity);
        }
        
        void Unity_ColorspaceConversion_RGB_Linear_float(float3 In, out float3 Out)
        {
            float3 linearRGBLo = In / 12.92;
            float3 linearRGBHi = pow(max(abs((In + 0.055) / 1.055), 1.192092896e-07), float3(2.4, 2.4, 2.4));
            Out = float3(In <= 0.04045) ? linearRGBLo : linearRGBHi;
        }
        
        void Unity_Clamp_float3(float3 In, float3 Min, float3 Max, out float3 Out)
        {
            Out = clamp(In, Min, Max);
        }
        
        void Unity_Add_float2(float2 A, float2 B, out float2 Out)
        {
            Out = A + B;
        }
        
        void Unity_Remap_float(float In, float2 InMinMax, float2 OutMinMax, out float Out)
        {
            Out = OutMinMax.x + (In - InMinMax.x) * (OutMinMax.y - OutMinMax.x) / (InMinMax.y - InMinMax.x);
        }
        
        void Unity_Clamp_float(float In, float Min, float Max, out float Out)
        {
            Out = clamp(In, Min, Max);
        }
        
        void Unity_Multiply_float2_float2(float2 A, float2 B, out float2 Out)
        {
            Out = A * B;
        }
        
        void Unity_DotProduct_float2(float2 A, float2 B, out float Out)
        {
            Out = dot(A, B);
        }
        
        void Unity_Saturate_float(float In, out float Out)
        {
            Out = saturate(In);
        }
        
        void Unity_OneMinus_float(float In, out float Out)
        {
            Out = 1 - In;
        }
        
        void Unity_SquareRoot_float(float In, out float Out)
        {
            Out = sqrt(In);
        }
        
        void Unity_Sign_float3(float3 In, out float3 Out)
        {
            Out = sign(In);
        }
        
        void Unity_Multiply_float_float(float A, float B, out float Out)
        {
        Out = A * B;
        }
        
        void Unity_Normalize_float3(float3 In, out float3 Out)
        {
            Out = normalize(In);
        }
        
        void Unity_Branch_float3(float Predicate, float3 True, float3 False, out float3 Out)
        {
            Out = Predicate ? True : False;
        }
        
        struct Bindings_PlanarNMn_1b93a87456f9d4c419321d0cd92bd6c8_float
        {
        float3 WorldSpaceNormal;
        float3 WorldSpaceTangent;
        float3 WorldSpaceBiTangent;
        float3 AbsoluteWorldSpacePosition;
        half4 uv0;
        half4 uv3;
        };
        
        void SG_PlanarNMn_1b93a87456f9d4c419321d0cd92bd6c8_float(UnityTexture2D Texture2D_80A3D28F, float4 Vector4_82674548, float Boolean_9FF42DF6, UnitySamplerState _SamplerState, float Boolean_5ddfe6daabcc4715a44b5f34fc19becb, Bindings_PlanarNMn_1b93a87456f9d4c419321d0cd92bd6c8_float IN, out float4 XZ_2)
        {
        float _Property_1ef12cf3201a938993fe6a7951b0e754_Out_0_Boolean = Boolean_9FF42DF6;
        UnityTexture2D _Property_3e01b4d2fc68d48ba3acbba9d5881e59_Out_0_Texture2D = Texture2D_80A3D28F;
        float _Split_89ed63cb625cb3878c183d0b71c03400_R_1_Float = IN.AbsoluteWorldSpacePosition[0];
        float _Split_89ed63cb625cb3878c183d0b71c03400_G_2_Float = IN.AbsoluteWorldSpacePosition[1];
        float _Split_89ed63cb625cb3878c183d0b71c03400_B_3_Float = IN.AbsoluteWorldSpacePosition[2];
        float _Split_89ed63cb625cb3878c183d0b71c03400_A_4_Float = 0;
        float4 _Combine_cf2d04ff119ad88493f6460431765cbb_RGBA_4_Vector4;
        float3 _Combine_cf2d04ff119ad88493f6460431765cbb_RGB_5_Vector3;
        float2 _Combine_cf2d04ff119ad88493f6460431765cbb_RG_6_Vector2;
        Unity_Combine_float(_Split_89ed63cb625cb3878c183d0b71c03400_R_1_Float, _Split_89ed63cb625cb3878c183d0b71c03400_B_3_Float, float(0), float(0), _Combine_cf2d04ff119ad88493f6460431765cbb_RGBA_4_Vector4, _Combine_cf2d04ff119ad88493f6460431765cbb_RGB_5_Vector3, _Combine_cf2d04ff119ad88493f6460431765cbb_RG_6_Vector2);
        float4 _Property_3fa1d6f912feb481ba60f2e55e62e746_Out_0_Vector4 = Vector4_82674548;
        float _Split_a2e12fa5931da084b2949343a539dfd8_R_1_Float = _Property_3fa1d6f912feb481ba60f2e55e62e746_Out_0_Vector4[0];
        float _Split_a2e12fa5931da084b2949343a539dfd8_G_2_Float = _Property_3fa1d6f912feb481ba60f2e55e62e746_Out_0_Vector4[1];
        float _Split_a2e12fa5931da084b2949343a539dfd8_B_3_Float = _Property_3fa1d6f912feb481ba60f2e55e62e746_Out_0_Vector4[2];
        float _Split_a2e12fa5931da084b2949343a539dfd8_A_4_Float = _Property_3fa1d6f912feb481ba60f2e55e62e746_Out_0_Vector4[3];
        float _Divide_c36b770dfaa0bb8f85ab27da5fd794f0_Out_2_Float;
        Unity_Divide_float(float(1), _Split_a2e12fa5931da084b2949343a539dfd8_R_1_Float, _Divide_c36b770dfaa0bb8f85ab27da5fd794f0_Out_2_Float);
        float4 _Multiply_14cec4902d0a00829e4555071a1b8ad1_Out_2_Vector4;
        Unity_Multiply_float4_float4(_Combine_cf2d04ff119ad88493f6460431765cbb_RGBA_4_Vector4, (_Divide_c36b770dfaa0bb8f85ab27da5fd794f0_Out_2_Float.xxxx), _Multiply_14cec4902d0a00829e4555071a1b8ad1_Out_2_Vector4);
        float _Property_058f4fba88c3437288219f1929444bf2_Out_0_Boolean = Boolean_5ddfe6daabcc4715a44b5f34fc19becb;
        float4 _UV_43d85b3291324c848dfbeec6adac2a71_Out_0_Vector4 = IN.uv0;
        float4 _UV_36881dcaab9040168fc5215dcd00f352_Out_0_Vector4 = IN.uv3;
        float4 _Branch_8054d58a73be4ce1b22d48a84389ae07_Out_3_Vector4;
        Unity_Branch_float4(_Property_058f4fba88c3437288219f1929444bf2_Out_0_Boolean, _UV_43d85b3291324c848dfbeec6adac2a71_Out_0_Vector4, _UV_36881dcaab9040168fc5215dcd00f352_Out_0_Vector4, _Branch_8054d58a73be4ce1b22d48a84389ae07_Out_3_Vector4);
        float2 _Vector2_6845d21872714d889783b0cb707df3e9_Out_0_Vector2 = float2(_Split_a2e12fa5931da084b2949343a539dfd8_R_1_Float, _Split_a2e12fa5931da084b2949343a539dfd8_G_2_Float);
        float2 _Vector2_e2e2263627c6098e96a5b5d29350ad03_Out_0_Vector2 = float2(_Split_a2e12fa5931da084b2949343a539dfd8_B_3_Float, _Split_a2e12fa5931da084b2949343a539dfd8_A_4_Float);
        float2 _TilingAndOffset_17582d056c0b8a8dab1017d37497fe59_Out_3_Vector2;
        Unity_TilingAndOffset_float((_Branch_8054d58a73be4ce1b22d48a84389ae07_Out_3_Vector4.xy), _Vector2_6845d21872714d889783b0cb707df3e9_Out_0_Vector2, _Vector2_e2e2263627c6098e96a5b5d29350ad03_Out_0_Vector2, _TilingAndOffset_17582d056c0b8a8dab1017d37497fe59_Out_3_Vector2);
        float2 _Branch_1e152f3aac57448f8518bf2852c000c3_Out_3_Vector2;
        Unity_Branch_float2(_Property_1ef12cf3201a938993fe6a7951b0e754_Out_0_Boolean, (_Multiply_14cec4902d0a00829e4555071a1b8ad1_Out_2_Vector4.xy), _TilingAndOffset_17582d056c0b8a8dab1017d37497fe59_Out_3_Vector2, _Branch_1e152f3aac57448f8518bf2852c000c3_Out_3_Vector2);
        UnitySamplerState _Property_69f1ed7efd1b494e91f626b88ab2363c_Out_0_SamplerState = _SamplerState;
        float4 _SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_RGBA_0_Vector4 = SAMPLE_TEXTURE2D(_Property_3e01b4d2fc68d48ba3acbba9d5881e59_Out_0_Texture2D.tex, _Property_69f1ed7efd1b494e91f626b88ab2363c_Out_0_SamplerState.samplerstate, _Property_3e01b4d2fc68d48ba3acbba9d5881e59_Out_0_Texture2D.GetTransformedUV(_Branch_1e152f3aac57448f8518bf2852c000c3_Out_3_Vector2) );
        _SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_RGBA_0_Vector4.rgb = UnpackNormal(_SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_RGBA_0_Vector4);
        float _SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_R_4_Float = _SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_RGBA_0_Vector4.r;
        float _SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_G_5_Float = _SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_RGBA_0_Vector4.g;
        float _SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_B_6_Float = _SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_RGBA_0_Vector4.b;
        float _SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_A_7_Float = _SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_RGBA_0_Vector4.a;
        float2 _Vector2_ad6bd100e273d78fa409a30a77bfa2cc_Out_0_Vector2 = float2(_SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_R_4_Float, _SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_G_5_Float);
        float3 _Sign_3a6ebf59931cf08cb0482e0144ddac24_Out_1_Vector3;
        Unity_Sign_float3(IN.WorldSpaceNormal, _Sign_3a6ebf59931cf08cb0482e0144ddac24_Out_1_Vector3);
        float _Split_6299d4ddcc4c74828aea40a46fdb896e_R_1_Float = _Sign_3a6ebf59931cf08cb0482e0144ddac24_Out_1_Vector3[0];
        float _Split_6299d4ddcc4c74828aea40a46fdb896e_G_2_Float = _Sign_3a6ebf59931cf08cb0482e0144ddac24_Out_1_Vector3[1];
        float _Split_6299d4ddcc4c74828aea40a46fdb896e_B_3_Float = _Sign_3a6ebf59931cf08cb0482e0144ddac24_Out_1_Vector3[2];
        float _Split_6299d4ddcc4c74828aea40a46fdb896e_A_4_Float = 0;
        float2 _Vector2_b76cb1842101e58b9e636d49b075c612_Out_0_Vector2 = float2(_Split_6299d4ddcc4c74828aea40a46fdb896e_G_2_Float, float(1));
        float2 _Multiply_31e8db88ee20c985a9850d1a58f3282b_Out_2_Vector2;
        Unity_Multiply_float2_float2(_Vector2_ad6bd100e273d78fa409a30a77bfa2cc_Out_0_Vector2, _Vector2_b76cb1842101e58b9e636d49b075c612_Out_0_Vector2, _Multiply_31e8db88ee20c985a9850d1a58f3282b_Out_2_Vector2);
        float _Split_5ed44bf2eca0868f81eb18100f49d1fa_R_1_Float = IN.WorldSpaceNormal[0];
        float _Split_5ed44bf2eca0868f81eb18100f49d1fa_G_2_Float = IN.WorldSpaceNormal[1];
        float _Split_5ed44bf2eca0868f81eb18100f49d1fa_B_3_Float = IN.WorldSpaceNormal[2];
        float _Split_5ed44bf2eca0868f81eb18100f49d1fa_A_4_Float = 0;
        float2 _Vector2_70e5837843f28b8b9d64cada3697bd5a_Out_0_Vector2 = float2(_Split_5ed44bf2eca0868f81eb18100f49d1fa_R_1_Float, _Split_5ed44bf2eca0868f81eb18100f49d1fa_B_3_Float);
        float2 _Add_1145b2f896593d80aa864a34e6702562_Out_2_Vector2;
        Unity_Add_float2(_Multiply_31e8db88ee20c985a9850d1a58f3282b_Out_2_Vector2, _Vector2_70e5837843f28b8b9d64cada3697bd5a_Out_0_Vector2, _Add_1145b2f896593d80aa864a34e6702562_Out_2_Vector2);
        float _Split_2bc77ca2d17bd78cb2383770ce50b179_R_1_Float = _Add_1145b2f896593d80aa864a34e6702562_Out_2_Vector2[0];
        float _Split_2bc77ca2d17bd78cb2383770ce50b179_G_2_Float = _Add_1145b2f896593d80aa864a34e6702562_Out_2_Vector2[1];
        float _Split_2bc77ca2d17bd78cb2383770ce50b179_B_3_Float = 0;
        float _Split_2bc77ca2d17bd78cb2383770ce50b179_A_4_Float = 0;
        float _Multiply_ab12aea87465a78eaf7fc66c2598d266_Out_2_Float;
        Unity_Multiply_float_float(_SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_B_6_Float, _Split_5ed44bf2eca0868f81eb18100f49d1fa_G_2_Float, _Multiply_ab12aea87465a78eaf7fc66c2598d266_Out_2_Float);
        float3 _Vector3_433840b555db308b97e9b14b6a957195_Out_0_Vector3 = float3(_Split_2bc77ca2d17bd78cb2383770ce50b179_R_1_Float, _Multiply_ab12aea87465a78eaf7fc66c2598d266_Out_2_Float, _Split_2bc77ca2d17bd78cb2383770ce50b179_G_2_Float);
        float3 _Transform_c7914cc45a011c89b3f53c55afb51673_Out_1_Vector3;
        {
        float3x3 tangentTransform = float3x3(IN.WorldSpaceTangent, IN.WorldSpaceBiTangent, IN.WorldSpaceNormal);
        _Transform_c7914cc45a011c89b3f53c55afb51673_Out_1_Vector3 = TransformWorldToTangentDir(_Vector3_433840b555db308b97e9b14b6a957195_Out_0_Vector3.xyz, tangentTransform, true);
        }
        float3 _Clamp_3837949a36b5428a82af01e7bcd29952_Out_3_Vector3;
        Unity_Clamp_float3(_Transform_c7914cc45a011c89b3f53c55afb51673_Out_1_Vector3, float3(-1, -1, -1), float3(1, 1, 1), _Clamp_3837949a36b5428a82af01e7bcd29952_Out_3_Vector3);
        float3 _Normalize_09bf8a2bd0a4d38e8b97d5c674f79b44_Out_1_Vector3;
        Unity_Normalize_float3(_Clamp_3837949a36b5428a82af01e7bcd29952_Out_3_Vector3, _Normalize_09bf8a2bd0a4d38e8b97d5c674f79b44_Out_1_Vector3);
        float3 _Branch_9eadf909a90f2f80880f8c56ecc2a91f_Out_3_Vector3;
        Unity_Branch_float3(_Property_1ef12cf3201a938993fe6a7951b0e754_Out_0_Boolean, _Normalize_09bf8a2bd0a4d38e8b97d5c674f79b44_Out_1_Vector3, (_SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_RGBA_0_Vector4.xyz), _Branch_9eadf909a90f2f80880f8c56ecc2a91f_Out_3_Vector3);
        XZ_2 = (float4(_Branch_9eadf909a90f2f80880f8c56ecc2a91f_Out_3_Vector3, 1.0));
        }
        
        void Unity_NormalStrength_float(float3 In, float Strength, out float3 Out)
        {
            Out = float3(In.rg * Strength, lerp(1, In.b, saturate(Strength)));
        }
        
        void Unity_NormalBlend_Reoriented_float(float3 A, float3 B, out float3 Out)
        {
            float3 t = A.xyz + float3(0.0, 0.0, 1.0);
            float3 u = B.xyz * float3(-1.0, -1.0, 1.0);
            Out = (t / t.z) * dot(t, u) - u;
        }
        
        void Unity_Subtract_float(float A, float B, out float Out)
        {
            Out = A - B;
        }
        
        void Unity_Absolute_float(float In, out float Out)
        {
            Out = abs(In);
        }
        
        void Unity_Power_float(float A, float B, out float Out)
        {
            Out = pow(A, B);
        }
        
        void Unity_Add_float(float A, float B, out float Out)
        {
            Out = A + B;
        }
        
        void Unity_Lerp_float3(float3 A, float3 B, float3 T, out float3 Out)
        {
            Out = lerp(A, B, T);
        }
        
        void Unity_Comparison_Greater_float(float A, float B, out float Out)
        {
            Out = A > B ? 1 : 0;
        }
        
        void Unity_Branch_float(float Predicate, float True, float False, out float Out)
        {
            Out = Predicate ? True : False;
        }
        
        struct Bindings_UniversalHeighblend_3b5c31b864970d04197cd420b6c4b0fa_float
        {
        };
        
        void SG_UniversalHeighblend_3b5c31b864970d04197cd420b6c4b0fa_float(float _Vertex_Color, float _Blend_Hardness, float _Use_Layer_1_Height_T, float _Layer_1_Height, float2 _Layer_1_Before_Remap, float _Use_Layer_2_Height_T, float _Layer_2_Height, float2 _Layer_2_Before_Remap, float _Angle_Blend, Bindings_UniversalHeighblend_3b5c31b864970d04197cd420b6c4b0fa_float IN, out float Heightmap_1)
        {
        float _Property_b3ca7054ef0043de85912fc45d997ea2_Out_0_Float = _Vertex_Color;
        float _Clamp_852774a2be524975babf4eeb54af6d64_Out_3_Float;
        Unity_Clamp_float(_Property_b3ca7054ef0043de85912fc45d997ea2_Out_0_Float, float(0), float(1), _Clamp_852774a2be524975babf4eeb54af6d64_Out_3_Float);
        float _OneMinus_85e3550f37814cd3ab5ea5dde7f63a73_Out_1_Float;
        Unity_OneMinus_float(_Clamp_852774a2be524975babf4eeb54af6d64_Out_3_Float, _OneMinus_85e3550f37814cd3ab5ea5dde7f63a73_Out_1_Float);
        float _Comparison_5be6aeaa514b4921b5eb68269b58b028_Out_2_Boolean;
        Unity_Comparison_Greater_float(_OneMinus_85e3550f37814cd3ab5ea5dde7f63a73_Out_1_Float, float(0.99), _Comparison_5be6aeaa514b4921b5eb68269b58b028_Out_2_Boolean);
        float _Property_cfe724908035497c918d6d3f8dafe439_Out_0_Boolean = _Use_Layer_1_Height_T;
        float _Property_9634fd87d3374fdaa60181281a01f9b5_Out_0_Float = _Layer_1_Height;
        float2 _Property_e748f6c127e0479a9a01040378a4129b_Out_0_Vector2 = _Layer_1_Before_Remap;
        float _Split_cde172ab161d44cb81ea7874aec65560_R_1_Float = _Property_e748f6c127e0479a9a01040378a4129b_Out_0_Vector2[0];
        float _Split_cde172ab161d44cb81ea7874aec65560_G_2_Float = _Property_e748f6c127e0479a9a01040378a4129b_Out_0_Vector2[1];
        float _Split_cde172ab161d44cb81ea7874aec65560_B_3_Float = 0;
        float _Split_cde172ab161d44cb81ea7874aec65560_A_4_Float = 0;
        float _Subtract_e1e98a956721410caddfb467ae0eca8b_Out_2_Float;
        Unity_Subtract_float(_Split_cde172ab161d44cb81ea7874aec65560_R_1_Float, _Split_cde172ab161d44cb81ea7874aec65560_G_2_Float, _Subtract_e1e98a956721410caddfb467ae0eca8b_Out_2_Float);
        float _Clamp_ac4097026e6248dbb7a95fe910cc776e_Out_3_Float;
        Unity_Clamp_float(_OneMinus_85e3550f37814cd3ab5ea5dde7f63a73_Out_1_Float, float(0), float(1), _Clamp_ac4097026e6248dbb7a95fe910cc776e_Out_3_Float);
        float _Multiply_41691d316de74fef8a4ab5f63ed5474e_Out_2_Float;
        Unity_Multiply_float_float(_Subtract_e1e98a956721410caddfb467ae0eca8b_Out_2_Float, _Clamp_ac4097026e6248dbb7a95fe910cc776e_Out_3_Float, _Multiply_41691d316de74fef8a4ab5f63ed5474e_Out_2_Float);
        float2 _Add_48d37f8b8a464788860db14f0da8a66e_Out_2_Vector2;
        Unity_Add_float2(_Property_e748f6c127e0479a9a01040378a4129b_Out_0_Vector2, (_Multiply_41691d316de74fef8a4ab5f63ed5474e_Out_2_Float.xx), _Add_48d37f8b8a464788860db14f0da8a66e_Out_2_Vector2);
        float _Remap_21f3372608424df090026adc73778a39_Out_3_Float;
        Unity_Remap_float(_Property_9634fd87d3374fdaa60181281a01f9b5_Out_0_Float, float2 (0, 1), _Add_48d37f8b8a464788860db14f0da8a66e_Out_2_Vector2, _Remap_21f3372608424df090026adc73778a39_Out_3_Float);
        float _Clamp_8ea719b357b44537b42b2d05c22046f6_Out_3_Float;
        Unity_Clamp_float(_Remap_21f3372608424df090026adc73778a39_Out_3_Float, float(0), float(1), _Clamp_8ea719b357b44537b42b2d05c22046f6_Out_3_Float);
        float _Property_457e05a76c034ada998b3ff30a7781c3_Out_0_Boolean = _Use_Layer_2_Height_T;
        float _Property_9dfafa1ca8c94866a52535f412aff89a_Out_0_Float = _Angle_Blend;
        float _Property_b0e4a5720c374e2eb6f203a1bd075243_Out_0_Float = _Layer_2_Height;
        float _Multiply_00b31c7f720343caa4ded6df80a61899_Out_2_Float;
        Unity_Multiply_float_float(_Property_9dfafa1ca8c94866a52535f412aff89a_Out_0_Float, _Property_b0e4a5720c374e2eb6f203a1bd075243_Out_0_Float, _Multiply_00b31c7f720343caa4ded6df80a61899_Out_2_Float);
        float2 _Property_555a7734da754b989d8f80ef0bc86bea_Out_0_Vector2 = _Layer_2_Before_Remap;
        float _Split_bad56a0d03154ccc8cbfb53ea0e381d4_R_1_Float = _Property_555a7734da754b989d8f80ef0bc86bea_Out_0_Vector2[0];
        float _Split_bad56a0d03154ccc8cbfb53ea0e381d4_G_2_Float = _Property_555a7734da754b989d8f80ef0bc86bea_Out_0_Vector2[1];
        float _Split_bad56a0d03154ccc8cbfb53ea0e381d4_B_3_Float = 0;
        float _Split_bad56a0d03154ccc8cbfb53ea0e381d4_A_4_Float = 0;
        float _Subtract_2a7908018c384526a00494520503a83d_Out_2_Float;
        Unity_Subtract_float(_Split_bad56a0d03154ccc8cbfb53ea0e381d4_R_1_Float, _Split_bad56a0d03154ccc8cbfb53ea0e381d4_G_2_Float, _Subtract_2a7908018c384526a00494520503a83d_Out_2_Float);
        float _Multiply_417d72157b5f4930aed43775db746964_Out_2_Float;
        Unity_Multiply_float_float(_Subtract_2a7908018c384526a00494520503a83d_Out_2_Float, _Clamp_ac4097026e6248dbb7a95fe910cc776e_Out_3_Float, _Multiply_417d72157b5f4930aed43775db746964_Out_2_Float);
        float2 _Add_3d7e111e917c44e8a6800ce926fac67d_Out_2_Vector2;
        Unity_Add_float2((_Multiply_417d72157b5f4930aed43775db746964_Out_2_Float.xx), _Property_555a7734da754b989d8f80ef0bc86bea_Out_0_Vector2, _Add_3d7e111e917c44e8a6800ce926fac67d_Out_2_Vector2);
        float _Remap_931f83440e6c4c1588456788f84cbd9a_Out_3_Float;
        Unity_Remap_float(_Multiply_00b31c7f720343caa4ded6df80a61899_Out_2_Float, float2 (0, 1), _Add_3d7e111e917c44e8a6800ce926fac67d_Out_2_Vector2, _Remap_931f83440e6c4c1588456788f84cbd9a_Out_3_Float);
        float _Branch_a840aba5bca34588a2665f9794c96c38_Out_3_Float;
        Unity_Branch_float(_Property_457e05a76c034ada998b3ff30a7781c3_Out_0_Boolean, _Remap_931f83440e6c4c1588456788f84cbd9a_Out_3_Float, _Property_9dfafa1ca8c94866a52535f412aff89a_Out_0_Float, _Branch_a840aba5bca34588a2665f9794c96c38_Out_3_Float);
        float _Clamp_b1fe959daf444bf99c57756b8be77768_Out_3_Float;
        Unity_Clamp_float(_Branch_a840aba5bca34588a2665f9794c96c38_Out_3_Float, float(0), float(1), _Clamp_b1fe959daf444bf99c57756b8be77768_Out_3_Float);
        float _Multiply_c045ae9912ac409b9734c687968d47f6_Out_2_Float;
        Unity_Multiply_float_float(_Clamp_8ea719b357b44537b42b2d05c22046f6_Out_3_Float, _Clamp_b1fe959daf444bf99c57756b8be77768_Out_3_Float, _Multiply_c045ae9912ac409b9734c687968d47f6_Out_2_Float);
        float _Branch_5198cfc0a080466e93cf89aea61886e6_Out_3_Float;
        Unity_Branch_float(_Property_cfe724908035497c918d6d3f8dafe439_Out_0_Boolean, _Multiply_c045ae9912ac409b9734c687968d47f6_Out_2_Float, _Clamp_b1fe959daf444bf99c57756b8be77768_Out_3_Float, _Branch_5198cfc0a080466e93cf89aea61886e6_Out_3_Float);
        float _Saturate_ceafe30b0bae4f45a2f2ec500925b553_Out_1_Float;
        Unity_Saturate_float(_Branch_5198cfc0a080466e93cf89aea61886e6_Out_3_Float, _Saturate_ceafe30b0bae4f45a2f2ec500925b553_Out_1_Float);
        float _Absolute_274083e3f9f645bfb86074d91f3b7c62_Out_1_Float;
        Unity_Absolute_float(_Saturate_ceafe30b0bae4f45a2f2ec500925b553_Out_1_Float, _Absolute_274083e3f9f645bfb86074d91f3b7c62_Out_1_Float);
        float _Property_c68e0b8a84a549a582d4723036344b0e_Out_0_Float = _Blend_Hardness;
        float _Power_c9d62a3092174d9cb5674d87bcb7b5c5_Out_2_Float;
        Unity_Power_float(_Absolute_274083e3f9f645bfb86074d91f3b7c62_Out_1_Float, _Property_c68e0b8a84a549a582d4723036344b0e_Out_0_Float, _Power_c9d62a3092174d9cb5674d87bcb7b5c5_Out_2_Float);
        float _Branch_2425ee869bde4930bb8f36a5273bdc33_Out_3_Float;
        Unity_Branch_float(_Comparison_5be6aeaa514b4921b5eb68269b58b028_Out_2_Boolean, float(0), _Power_c9d62a3092174d9cb5674d87bcb7b5c5_Out_2_Float, _Branch_2425ee869bde4930bb8f36a5273bdc33_Out_3_Float);
        float _Clamp_9a5c5cfe52824e248ea0a8e38c593d84_Out_3_Float;
        Unity_Clamp_float(_Branch_2425ee869bde4930bb8f36a5273bdc33_Out_3_Float, float(0), float(1), _Clamp_9a5c5cfe52824e248ea0a8e38c593d84_Out_3_Float);
        Heightmap_1 = _Clamp_9a5c5cfe52824e248ea0a8e38c593d84_Out_3_Float;
        }
        
        void Unity_Lerp_float4(float4 A, float4 B, float4 T, out float4 Out)
        {
            Out = lerp(A, B, T);
        }
        
        void Unity_Clamp_float4(float4 In, float4 Min, float4 Max, out float4 Out)
        {
            Out = clamp(In, Min, Max);
        }
        
        void Unity_Lerp_float(float A, float B, float T, out float Out)
        {
            Out = lerp(A, B, T);
        }
        
        // unity-custom-func-begin
        void Time_float(out float Out){
            Out = _Time.y;
        }
        // unity-custom-func-end
        
        void Unity_Minimum_float(float A, float B, out float Out)
        {
            Out = min(A, B);
        };
        
        void Unity_DotProduct_float3(float3 A, float3 B, out float Out)
        {
            Out = dot(A, B);
        }
        
        void Unity_Add_float4(float4 A, float4 B, out float4 Out)
        {
            Out = A + B;
        }
        
        // Custom interpolators pre vertex
        /* WARNING: $splice Could not find named fragment 'CustomInterpolatorPreVertex' */
        
        // Graph Vertex
        struct VertexDescription
        {
            float3 Position;
            float3 Normal;
            float3 Tangent;
        };
        
        VertexDescription VertexDescriptionFunction(VertexDescriptionInputs IN)
        {
            VertexDescription description = (VertexDescription)0;
            description.Position = IN.ObjectSpacePosition;
            description.Normal = IN.ObjectSpaceNormal;
            description.Tangent = IN.ObjectSpaceTangent;
            return description;
        }
        
        // Custom interpolators, pre surface
        #ifdef FEATURES_GRAPH_VERTEX
        Varyings CustomInterpolatorPassThroughFunc(inout Varyings output, VertexDescription input)
        {
        return output;
        }
        #define CUSTOMINTERPOLATOR_VARYPASSTHROUGH_FUNC
        #endif
        
        // Graph Pixel
        struct SurfaceDescription
        {
            float3 BaseColor;
            float3 Emission;
            float Alpha;
            float AlphaClipThreshold;
        };
        
        SurfaceDescription SurfaceDescriptionFunction(SurfaceDescriptionInputs IN)
        {
            SurfaceDescription surface = (SurfaceDescription)0;
            UnityTexture2D _Property_821e07b38fd0a08d85c4dd6e5b6bbac9_Out_0_Texture2D = UnityBuildTexture2DStructNoScale(_BaseColorMap);
            float4 _Property_8ec0d512145619859d288abab740e3bf_Out_0_Vector4 = _BaseTilingOffset;
            float _Property_122c0f9ef0a1c4818a140c75e512abe4_Out_0_Boolean = _BaseUsePlanarUV;
            Bindings_PlanarNM_c0f081da9c567704ea36e7dd38cedcf6_float _PlanarNM_cb7ded32e6af3382bbe06b62977afab6;
            _PlanarNM_cb7ded32e6af3382bbe06b62977afab6.AbsoluteWorldSpacePosition = IN.AbsoluteWorldSpacePosition;
            _PlanarNM_cb7ded32e6af3382bbe06b62977afab6.uv0 = IN.uv0;
            _PlanarNM_cb7ded32e6af3382bbe06b62977afab6.uv3 = IN.uv3;
            float4 _PlanarNM_cb7ded32e6af3382bbe06b62977afab6_XZ_2_Vector4;
            SG_PlanarNM_c0f081da9c567704ea36e7dd38cedcf6_float(_Property_821e07b38fd0a08d85c4dd6e5b6bbac9_Out_0_Texture2D, _Property_8ec0d512145619859d288abab740e3bf_Out_0_Vector4, _Property_122c0f9ef0a1c4818a140c75e512abe4_Out_0_Boolean, UnityBuildSamplerStateStruct(SamplerState_Linear_Repeat_Aniso8), 1, _PlanarNM_cb7ded32e6af3382bbe06b62977afab6, _PlanarNM_cb7ded32e6af3382bbe06b62977afab6_XZ_2_Vector4);
            float4 _Property_41859d117584758eb8002ecc938f9bce_Out_0_Vector4 = _BaseColor;
            float4 _Multiply_4d0f82599060228a9092027fd43912c8_Out_2_Vector4;
            Unity_Multiply_float4_float4(_PlanarNM_cb7ded32e6af3382bbe06b62977afab6_XZ_2_Vector4, _Property_41859d117584758eb8002ecc938f9bce_Out_0_Vector4, _Multiply_4d0f82599060228a9092027fd43912c8_Out_2_Vector4);
            float3 _ColorspaceConversion_30c5042ef70343cd92056cde73cd3ecb_Out_1_Vector3;
            Unity_ColorspaceConversion_Linear_RGB_float((_Multiply_4d0f82599060228a9092027fd43912c8_Out_2_Vector4.xyz), _ColorspaceConversion_30c5042ef70343cd92056cde73cd3ecb_Out_1_Vector3);
            UnityTexture2D _Property_50403cc6b1e3998a82afc21c6a6332ae_Out_0_Texture2D = UnityBuildTexture2DStructNoScale(_DetailMap);
            float4 _Property_256e5676e1089881ae3214634430b140_Out_0_Vector4 = _DetailTilingOffset;
            float _Split_257d0b6ea953418d97fd7daa8128bf35_R_1_Float = _Property_256e5676e1089881ae3214634430b140_Out_0_Vector4[0];
            float _Split_257d0b6ea953418d97fd7daa8128bf35_G_2_Float = _Property_256e5676e1089881ae3214634430b140_Out_0_Vector4[1];
            float _Split_257d0b6ea953418d97fd7daa8128bf35_B_3_Float = _Property_256e5676e1089881ae3214634430b140_Out_0_Vector4[2];
            float _Split_257d0b6ea953418d97fd7daa8128bf35_A_4_Float = _Property_256e5676e1089881ae3214634430b140_Out_0_Vector4[3];
            float2 _Vector2_98295494172421878c7a16cb2baddf9a_Out_0_Vector2 = float2(_Split_257d0b6ea953418d97fd7daa8128bf35_R_1_Float, _Split_257d0b6ea953418d97fd7daa8128bf35_G_2_Float);
            float2 _Vector2_130e8faa59837a81a7506636fcb30b8a_Out_0_Vector2 = float2(_Split_257d0b6ea953418d97fd7daa8128bf35_B_3_Float, _Split_257d0b6ea953418d97fd7daa8128bf35_A_4_Float);
            float2 _TilingAndOffset_1dfb2b4859ec3680ad3a74cf8f1bc17b_Out_3_Vector2;
            Unity_TilingAndOffset_float(IN.uv0.xy, _Vector2_98295494172421878c7a16cb2baddf9a_Out_0_Vector2, _Vector2_130e8faa59837a81a7506636fcb30b8a_Out_0_Vector2, _TilingAndOffset_1dfb2b4859ec3680ad3a74cf8f1bc17b_Out_3_Vector2);
            float4 _SampleTexture2D_d8eb0186b9a0cd819cde65431b4ea5ea_RGBA_0_Vector4 = SAMPLE_TEXTURE2D(_Property_50403cc6b1e3998a82afc21c6a6332ae_Out_0_Texture2D.tex, UnityBuildSamplerStateStruct(SamplerState_Linear_Repeat_Aniso8).samplerstate, _Property_50403cc6b1e3998a82afc21c6a6332ae_Out_0_Texture2D.GetTransformedUV(_TilingAndOffset_1dfb2b4859ec3680ad3a74cf8f1bc17b_Out_3_Vector2) );
            float _SampleTexture2D_d8eb0186b9a0cd819cde65431b4ea5ea_R_4_Float = _SampleTexture2D_d8eb0186b9a0cd819cde65431b4ea5ea_RGBA_0_Vector4.r;
            float _SampleTexture2D_d8eb0186b9a0cd819cde65431b4ea5ea_G_5_Float = _SampleTexture2D_d8eb0186b9a0cd819cde65431b4ea5ea_RGBA_0_Vector4.g;
            float _SampleTexture2D_d8eb0186b9a0cd819cde65431b4ea5ea_B_6_Float = _SampleTexture2D_d8eb0186b9a0cd819cde65431b4ea5ea_RGBA_0_Vector4.b;
            float _SampleTexture2D_d8eb0186b9a0cd819cde65431b4ea5ea_A_7_Float = _SampleTexture2D_d8eb0186b9a0cd819cde65431b4ea5ea_RGBA_0_Vector4.a;
            float _Property_605f29777330a58ba88ac032e905433b_Out_0_Float = _DetailAlbedoScale;
            float3 _Blend_de85bf99257f4eb7bb321fd973539f10_Out_2_Vector3;
            Unity_Blend_Overlay_float3(_ColorspaceConversion_30c5042ef70343cd92056cde73cd3ecb_Out_1_Vector3, (_SampleTexture2D_d8eb0186b9a0cd819cde65431b4ea5ea_R_4_Float.xxx), _Blend_de85bf99257f4eb7bb321fd973539f10_Out_2_Vector3, _Property_605f29777330a58ba88ac032e905433b_Out_0_Float);
            float3 _ColorspaceConversion_635670d250654503b34efa53a99ba43e_Out_1_Vector3;
            Unity_ColorspaceConversion_RGB_Linear_float(_Blend_de85bf99257f4eb7bb321fd973539f10_Out_2_Vector3, _ColorspaceConversion_635670d250654503b34efa53a99ba43e_Out_1_Vector3);
            float3 _Clamp_8913f48f801c43c2879f2e1ce926507e_Out_3_Vector3;
            Unity_Clamp_float3(_ColorspaceConversion_635670d250654503b34efa53a99ba43e_Out_1_Vector3, float3(0, 0, 0), float3(1, 1, 1), _Clamp_8913f48f801c43c2879f2e1ce926507e_Out_3_Vector3);
            float _Split_ddfe447fbb7845e88cc5cfb8158b2248_R_1_Float = _Clamp_8913f48f801c43c2879f2e1ce926507e_Out_3_Vector3[0];
            float _Split_ddfe447fbb7845e88cc5cfb8158b2248_G_2_Float = _Clamp_8913f48f801c43c2879f2e1ce926507e_Out_3_Vector3[1];
            float _Split_ddfe447fbb7845e88cc5cfb8158b2248_B_3_Float = _Clamp_8913f48f801c43c2879f2e1ce926507e_Out_3_Vector3[2];
            float _Split_ddfe447fbb7845e88cc5cfb8158b2248_A_4_Float = 0;
            float _Split_6d7debfd2b20440e932d58108f8e7f75_R_1_Float = _Multiply_4d0f82599060228a9092027fd43912c8_Out_2_Vector4[0];
            float _Split_6d7debfd2b20440e932d58108f8e7f75_G_2_Float = _Multiply_4d0f82599060228a9092027fd43912c8_Out_2_Vector4[1];
            float _Split_6d7debfd2b20440e932d58108f8e7f75_B_3_Float = _Multiply_4d0f82599060228a9092027fd43912c8_Out_2_Vector4[2];
            float _Split_6d7debfd2b20440e932d58108f8e7f75_A_4_Float = _Multiply_4d0f82599060228a9092027fd43912c8_Out_2_Vector4[3];
            float4 _Combine_b0f28916143e4b94af6bec53f5328b52_RGBA_4_Vector4;
            float3 _Combine_b0f28916143e4b94af6bec53f5328b52_RGB_5_Vector3;
            float2 _Combine_b0f28916143e4b94af6bec53f5328b52_RG_6_Vector2;
            Unity_Combine_float(_Split_ddfe447fbb7845e88cc5cfb8158b2248_R_1_Float, _Split_ddfe447fbb7845e88cc5cfb8158b2248_G_2_Float, _Split_ddfe447fbb7845e88cc5cfb8158b2248_B_3_Float, _Split_6d7debfd2b20440e932d58108f8e7f75_A_4_Float, _Combine_b0f28916143e4b94af6bec53f5328b52_RGBA_4_Vector4, _Combine_b0f28916143e4b94af6bec53f5328b52_RGB_5_Vector3, _Combine_b0f28916143e4b94af6bec53f5328b52_RG_6_Vector2);
            UnityTexture2D _Property_a155ddc33ed90685a5ab0edcf158a343_Out_0_Texture2D = UnityBuildTexture2DStructNoScale(_CoverBaseColorMap);
            float4 _Property_256beda96caf2d8aa05d3de41fc08d3d_Out_0_Vector4 = _CoverTilingOffset;
            float _Property_bd9dfe8dd615798f9f2d72d139e56d61_Out_0_Boolean = _CoverUsePlanarUV;
            Bindings_PlanarNM_c0f081da9c567704ea36e7dd38cedcf6_float _PlanarNM_e00e057d3d7c4181b1c7775c6ebbab5b;
            _PlanarNM_e00e057d3d7c4181b1c7775c6ebbab5b.AbsoluteWorldSpacePosition = IN.AbsoluteWorldSpacePosition;
            _PlanarNM_e00e057d3d7c4181b1c7775c6ebbab5b.uv0 = IN.uv0;
            _PlanarNM_e00e057d3d7c4181b1c7775c6ebbab5b.uv3 = IN.uv3;
            float4 _PlanarNM_e00e057d3d7c4181b1c7775c6ebbab5b_XZ_2_Vector4;
            SG_PlanarNM_c0f081da9c567704ea36e7dd38cedcf6_float(_Property_a155ddc33ed90685a5ab0edcf158a343_Out_0_Texture2D, _Property_256beda96caf2d8aa05d3de41fc08d3d_Out_0_Vector4, _Property_bd9dfe8dd615798f9f2d72d139e56d61_Out_0_Boolean, UnityBuildSamplerStateStruct(SamplerState_Linear_Repeat_Aniso8), 1, _PlanarNM_e00e057d3d7c4181b1c7775c6ebbab5b, _PlanarNM_e00e057d3d7c4181b1c7775c6ebbab5b_XZ_2_Vector4);
            float4 _Property_c3be5593fd661b8dafbd04f26b8ec9ac_Out_0_Vector4 = _CoverBaseColor;
            float4 _Multiply_b08794693505bd8e8c04b9ba1610d394_Out_2_Vector4;
            Unity_Multiply_float4_float4(_PlanarNM_e00e057d3d7c4181b1c7775c6ebbab5b_XZ_2_Vector4, _Property_c3be5593fd661b8dafbd04f26b8ec9ac_Out_0_Vector4, _Multiply_b08794693505bd8e8c04b9ba1610d394_Out_2_Vector4);
            float _Split_a80936a3c75945efb8cf9f2b95c76642_R_1_Float = IN.VertexColor[0];
            float _Split_a80936a3c75945efb8cf9f2b95c76642_G_2_Float = IN.VertexColor[1];
            float _Split_a80936a3c75945efb8cf9f2b95c76642_B_3_Float = IN.VertexColor[2];
            float _Split_a80936a3c75945efb8cf9f2b95c76642_A_4_Float = IN.VertexColor[3];
            float _Property_14a6757619d64822a44a69b34f85276d_Out_0_Float = _VertexColorGBlendStrenght;
            float _Property_c0d9ffba7dee497c885a54170977d874_Out_0_Boolean = _USEBaseHeightT;
            UnityTexture2D _Property_bb9b47702e64ec8c8d8ad011fd521576_Out_0_Texture2D = UnityBuildTexture2DStructNoScale(_BaseMaskMap);
            Bindings_PlanarNM_c0f081da9c567704ea36e7dd38cedcf6_float _PlanarNM_e51306c84cde8e84a1fb06a45d8d037f;
            _PlanarNM_e51306c84cde8e84a1fb06a45d8d037f.AbsoluteWorldSpacePosition = IN.AbsoluteWorldSpacePosition;
            _PlanarNM_e51306c84cde8e84a1fb06a45d8d037f.uv0 = IN.uv0;
            _PlanarNM_e51306c84cde8e84a1fb06a45d8d037f.uv3 = IN.uv3;
            float4 _PlanarNM_e51306c84cde8e84a1fb06a45d8d037f_XZ_2_Vector4;
            SG_PlanarNM_c0f081da9c567704ea36e7dd38cedcf6_float(_Property_bb9b47702e64ec8c8d8ad011fd521576_Out_0_Texture2D, _Property_8ec0d512145619859d288abab740e3bf_Out_0_Vector4, _Property_122c0f9ef0a1c4818a140c75e512abe4_Out_0_Boolean, UnityBuildSamplerStateStruct(SamplerState_Linear_Repeat_Aniso8), 1, _PlanarNM_e51306c84cde8e84a1fb06a45d8d037f, _PlanarNM_e51306c84cde8e84a1fb06a45d8d037f_XZ_2_Vector4);
            float _Split_218e1cfd00b30984921b5fc0ec63de60_R_1_Float = _PlanarNM_e51306c84cde8e84a1fb06a45d8d037f_XZ_2_Vector4[0];
            float _Split_218e1cfd00b30984921b5fc0ec63de60_G_2_Float = _PlanarNM_e51306c84cde8e84a1fb06a45d8d037f_XZ_2_Vector4[1];
            float _Split_218e1cfd00b30984921b5fc0ec63de60_B_3_Float = _PlanarNM_e51306c84cde8e84a1fb06a45d8d037f_XZ_2_Vector4[2];
            float _Split_218e1cfd00b30984921b5fc0ec63de60_A_4_Float = _PlanarNM_e51306c84cde8e84a1fb06a45d8d037f_XZ_2_Vector4[3];
            float _Property_1d4a1a93707b42c3abf0baa799c514e5_Out_0_Float = _HeightMin;
            float _Property_8f4f3606868d4028a34c2a9a5a59f99d_Out_0_Float = _HeightMax;
            float2 _Vector2_721b6f4d7077463490b4504fe6c940bf_Out_0_Vector2 = float2(_Property_1d4a1a93707b42c3abf0baa799c514e5_Out_0_Float, _Property_8f4f3606868d4028a34c2a9a5a59f99d_Out_0_Float);
            float _Property_a1ae2f61da87421b9f3839691e9dd8af_Out_0_Float = _HeightOffset;
            float2 _Add_1f9ea9bdf36544b59f763806e7eea80d_Out_2_Vector2;
            Unity_Add_float2(_Vector2_721b6f4d7077463490b4504fe6c940bf_Out_0_Vector2, (_Property_a1ae2f61da87421b9f3839691e9dd8af_Out_0_Float.xx), _Add_1f9ea9bdf36544b59f763806e7eea80d_Out_2_Vector2);
            float _Property_0fbef18600294e199eeda9905e3304e4_Out_0_Boolean = _USECoverHeightT;
            UnityTexture2D _Property_3702de305e11e085a40d7731b582d541_Out_0_Texture2D = UnityBuildTexture2DStructNoScale(_CoverMaskMap);
            Bindings_PlanarNM_c0f081da9c567704ea36e7dd38cedcf6_float _PlanarNM_2217ca3c12141a8cb1e0c7235b369601;
            _PlanarNM_2217ca3c12141a8cb1e0c7235b369601.AbsoluteWorldSpacePosition = IN.AbsoluteWorldSpacePosition;
            _PlanarNM_2217ca3c12141a8cb1e0c7235b369601.uv0 = IN.uv0;
            _PlanarNM_2217ca3c12141a8cb1e0c7235b369601.uv3 = IN.uv3;
            float4 _PlanarNM_2217ca3c12141a8cb1e0c7235b369601_XZ_2_Vector4;
            SG_PlanarNM_c0f081da9c567704ea36e7dd38cedcf6_float(_Property_3702de305e11e085a40d7731b582d541_Out_0_Texture2D, _Property_256beda96caf2d8aa05d3de41fc08d3d_Out_0_Vector4, _Property_bd9dfe8dd615798f9f2d72d139e56d61_Out_0_Boolean, UnityBuildSamplerStateStruct(SamplerState_Linear_Repeat_Aniso8), 1, _PlanarNM_2217ca3c12141a8cb1e0c7235b369601, _PlanarNM_2217ca3c12141a8cb1e0c7235b369601_XZ_2_Vector4);
            float _Split_2f45bca363698c859e51492899bc58f8_R_1_Float = _PlanarNM_2217ca3c12141a8cb1e0c7235b369601_XZ_2_Vector4[0];
            float _Split_2f45bca363698c859e51492899bc58f8_G_2_Float = _PlanarNM_2217ca3c12141a8cb1e0c7235b369601_XZ_2_Vector4[1];
            float _Split_2f45bca363698c859e51492899bc58f8_B_3_Float = _PlanarNM_2217ca3c12141a8cb1e0c7235b369601_XZ_2_Vector4[2];
            float _Split_2f45bca363698c859e51492899bc58f8_A_4_Float = _PlanarNM_2217ca3c12141a8cb1e0c7235b369601_XZ_2_Vector4[3];
            float _Property_32b48052fdbb4641bf4eeb294bc65050_Out_0_Float = _CoverHeightMapMin;
            float _Property_0e120eb0a0a14b12a31a3c1f5b961121_Out_0_Float = _CoverHeightMapMax;
            float2 _Vector2_6955747f7f0a4ff98fae60dbada25e89_Out_0_Vector2 = float2(_Property_32b48052fdbb4641bf4eeb294bc65050_Out_0_Float, _Property_0e120eb0a0a14b12a31a3c1f5b961121_Out_0_Float);
            float _Property_6b467710b0ba48058e003aebe9119249_Out_0_Float = _CoverHeightMapOffset;
            float2 _Add_28628d641d58481084e9c00e4ad5fc8d_Out_2_Vector2;
            Unity_Add_float2(_Vector2_6955747f7f0a4ff98fae60dbada25e89_Out_0_Vector2, (_Property_6b467710b0ba48058e003aebe9119249_Out_0_Float.xx), _Add_28628d641d58481084e9c00e4ad5fc8d_Out_2_Vector2);
            UnityTexture2D _Property_7bea2d9dd5651a8bbbd61ecde71faa54_Out_0_Texture2D = UnityBuildTexture2DStructNoScale(_Masks);
            float4 _UV_429c95affe88aa8694076115c99a0769_Out_0_Vector4 = IN.uv0;
            float4 _SampleTexture2D_2723da80b8a2528381ef199c0415beae_RGBA_0_Vector4 = SAMPLE_TEXTURE2D(_Property_7bea2d9dd5651a8bbbd61ecde71faa54_Out_0_Texture2D.tex, UnityBuildSamplerStateStruct(SamplerState_Linear_Repeat_Aniso8).samplerstate, _Property_7bea2d9dd5651a8bbbd61ecde71faa54_Out_0_Texture2D.GetTransformedUV((_UV_429c95affe88aa8694076115c99a0769_Out_0_Vector4.xy)) );
            float _SampleTexture2D_2723da80b8a2528381ef199c0415beae_R_4_Float = _SampleTexture2D_2723da80b8a2528381ef199c0415beae_RGBA_0_Vector4.r;
            float _SampleTexture2D_2723da80b8a2528381ef199c0415beae_G_5_Float = _SampleTexture2D_2723da80b8a2528381ef199c0415beae_RGBA_0_Vector4.g;
            float _SampleTexture2D_2723da80b8a2528381ef199c0415beae_B_6_Float = _SampleTexture2D_2723da80b8a2528381ef199c0415beae_RGBA_0_Vector4.b;
            float _SampleTexture2D_2723da80b8a2528381ef199c0415beae_A_7_Float = _SampleTexture2D_2723da80b8a2528381ef199c0415beae_RGBA_0_Vector4.a;
            float _Property_7bea2851849541b28a2bc695d39a7606_Out_0_Float = _Cover_Mask_A_Remap_Min;
            float _Property_3be0ae138e414a5cb43d60264b1bcfeb_Out_0_Float = _Cover_Mask_A_Remap_Max;
            float2 _Vector2_44ac029de1e440a799fbdfadc778af0c_Out_0_Vector2 = float2(_Property_7bea2851849541b28a2bc695d39a7606_Out_0_Float, _Property_3be0ae138e414a5cb43d60264b1bcfeb_Out_0_Float);
            float _Remap_0c551a3055a54f16b85b519194883552_Out_3_Float;
            Unity_Remap_float(_SampleTexture2D_2723da80b8a2528381ef199c0415beae_A_7_Float, float2 (0, 1), _Vector2_44ac029de1e440a799fbdfadc778af0c_Out_0_Vector2, _Remap_0c551a3055a54f16b85b519194883552_Out_3_Float);
            float _Clamp_bb1427696ce14fe987f799fecc5f9fac_Out_3_Float;
            Unity_Clamp_float(_Remap_0c551a3055a54f16b85b519194883552_Out_3_Float, float(0), float(1), _Clamp_bb1427696ce14fe987f799fecc5f9fac_Out_3_Float);
            float2 _Vector2_0d28074858599a88940dfc8b57b9a60f_Out_0_Vector2 = float2(_SampleTexture2D_d8eb0186b9a0cd819cde65431b4ea5ea_A_7_Float, _SampleTexture2D_d8eb0186b9a0cd819cde65431b4ea5ea_G_5_Float);
            float2 _Multiply_fac8d94f82a53486bc0142a1e64b3d32_Out_2_Vector2;
            Unity_Multiply_float2_float2(_Vector2_0d28074858599a88940dfc8b57b9a60f_Out_0_Vector2, float2(2, 2), _Multiply_fac8d94f82a53486bc0142a1e64b3d32_Out_2_Vector2);
            float2 _Add_f0e6e847d8d8798ab3ca8c4d878bafc0_Out_2_Vector2;
            Unity_Add_float2(_Multiply_fac8d94f82a53486bc0142a1e64b3d32_Out_2_Vector2, float2(-1, -1), _Add_f0e6e847d8d8798ab3ca8c4d878bafc0_Out_2_Vector2);
            float _Property_d0e8d8f7fd10f0829e8fd86c278c8226_Out_0_Float = _DetailNormalScale;
            float2 _Multiply_11f3dfc5283ea188ad9c83e552cf7e0f_Out_2_Vector2;
            Unity_Multiply_float2_float2(_Add_f0e6e847d8d8798ab3ca8c4d878bafc0_Out_2_Vector2, (_Property_d0e8d8f7fd10f0829e8fd86c278c8226_Out_0_Float.xx), _Multiply_11f3dfc5283ea188ad9c83e552cf7e0f_Out_2_Vector2);
            float _Split_c4822b8eaff9b185be7c059792345712_R_1_Float = _Multiply_11f3dfc5283ea188ad9c83e552cf7e0f_Out_2_Vector2[0];
            float _Split_c4822b8eaff9b185be7c059792345712_G_2_Float = _Multiply_11f3dfc5283ea188ad9c83e552cf7e0f_Out_2_Vector2[1];
            float _Split_c4822b8eaff9b185be7c059792345712_B_3_Float = 0;
            float _Split_c4822b8eaff9b185be7c059792345712_A_4_Float = 0;
            float _DotProduct_1a01939a143c548c8ccd7e8a04fe680d_Out_2_Float;
            Unity_DotProduct_float2(_Multiply_11f3dfc5283ea188ad9c83e552cf7e0f_Out_2_Vector2, _Multiply_11f3dfc5283ea188ad9c83e552cf7e0f_Out_2_Vector2, _DotProduct_1a01939a143c548c8ccd7e8a04fe680d_Out_2_Float);
            float _Saturate_bf3d57899db77f86a1689105ce6a373a_Out_1_Float;
            Unity_Saturate_float(_DotProduct_1a01939a143c548c8ccd7e8a04fe680d_Out_2_Float, _Saturate_bf3d57899db77f86a1689105ce6a373a_Out_1_Float);
            float _OneMinus_052960238cc4a18cb83109d2bcae6d09_Out_1_Float;
            Unity_OneMinus_float(_Saturate_bf3d57899db77f86a1689105ce6a373a_Out_1_Float, _OneMinus_052960238cc4a18cb83109d2bcae6d09_Out_1_Float);
            float _SquareRoot_d4f67288e4dbf5898bea492a70b89ab9_Out_1_Float;
            Unity_SquareRoot_float(_OneMinus_052960238cc4a18cb83109d2bcae6d09_Out_1_Float, _SquareRoot_d4f67288e4dbf5898bea492a70b89ab9_Out_1_Float);
            float3 _Vector3_1e56146bdd567884bb8d5ae769df4d29_Out_0_Vector3 = float3(_Split_c4822b8eaff9b185be7c059792345712_R_1_Float, _Split_c4822b8eaff9b185be7c059792345712_G_2_Float, _SquareRoot_d4f67288e4dbf5898bea492a70b89ab9_Out_1_Float);
            UnityTexture2D _Property_147b07430832c98eb0a470557ee61c5e_Out_0_Texture2D = UnityBuildTexture2DStructNoScale(_BaseNormalMap);
            Bindings_PlanarNMn_1b93a87456f9d4c419321d0cd92bd6c8_float _PlanarNMn_ecad9f1f260c6c8bbd0960b2a8976daf;
            _PlanarNMn_ecad9f1f260c6c8bbd0960b2a8976daf.WorldSpaceNormal = IN.WorldSpaceNormal;
            _PlanarNMn_ecad9f1f260c6c8bbd0960b2a8976daf.WorldSpaceTangent = IN.WorldSpaceTangent;
            _PlanarNMn_ecad9f1f260c6c8bbd0960b2a8976daf.WorldSpaceBiTangent = IN.WorldSpaceBiTangent;
            _PlanarNMn_ecad9f1f260c6c8bbd0960b2a8976daf.AbsoluteWorldSpacePosition = IN.AbsoluteWorldSpacePosition;
            _PlanarNMn_ecad9f1f260c6c8bbd0960b2a8976daf.uv0 = IN.uv0;
            _PlanarNMn_ecad9f1f260c6c8bbd0960b2a8976daf.uv3 = IN.uv3;
            float4 _PlanarNMn_ecad9f1f260c6c8bbd0960b2a8976daf_XZ_2_Vector4;
            SG_PlanarNMn_1b93a87456f9d4c419321d0cd92bd6c8_float(_Property_147b07430832c98eb0a470557ee61c5e_Out_0_Texture2D, _Property_8ec0d512145619859d288abab740e3bf_Out_0_Vector4, _Property_122c0f9ef0a1c4818a140c75e512abe4_Out_0_Boolean, UnityBuildSamplerStateStruct(SamplerState_Linear_Repeat_Aniso8), 1, _PlanarNMn_ecad9f1f260c6c8bbd0960b2a8976daf, _PlanarNMn_ecad9f1f260c6c8bbd0960b2a8976daf_XZ_2_Vector4);
            float _Property_72e436a108ad64868e46d548c585c5f3_Out_0_Float = _BaseNormalScale;
            float3 _NormalStrength_366affc5c8b42482a633d201ef52b9d6_Out_2_Vector3;
            Unity_NormalStrength_float((_PlanarNMn_ecad9f1f260c6c8bbd0960b2a8976daf_XZ_2_Vector4.xyz), _Property_72e436a108ad64868e46d548c585c5f3_Out_0_Float, _NormalStrength_366affc5c8b42482a633d201ef52b9d6_Out_2_Vector3);
            float3 _NormalBlend_9f531c87e2e45580b1d0f65f06c23526_Out_2_Vector3;
            Unity_NormalBlend_Reoriented_float(_Vector3_1e56146bdd567884bb8d5ae769df4d29_Out_0_Vector3, _NormalStrength_366affc5c8b42482a633d201ef52b9d6_Out_2_Vector3, _NormalBlend_9f531c87e2e45580b1d0f65f06c23526_Out_2_Vector3);
            UnityTexture2D _Property_d7e9139e0ac6718b89c610009c28a25a_Out_0_Texture2D = UnityBuildTexture2DStructNoScale(_CoverNormalMap);
            Bindings_PlanarNMn_1b93a87456f9d4c419321d0cd92bd6c8_float _PlanarNMn_690e893d26999680a5cea3604ed0ce16;
            _PlanarNMn_690e893d26999680a5cea3604ed0ce16.WorldSpaceNormal = IN.WorldSpaceNormal;
            _PlanarNMn_690e893d26999680a5cea3604ed0ce16.WorldSpaceTangent = IN.WorldSpaceTangent;
            _PlanarNMn_690e893d26999680a5cea3604ed0ce16.WorldSpaceBiTangent = IN.WorldSpaceBiTangent;
            _PlanarNMn_690e893d26999680a5cea3604ed0ce16.AbsoluteWorldSpacePosition = IN.AbsoluteWorldSpacePosition;
            _PlanarNMn_690e893d26999680a5cea3604ed0ce16.uv0 = IN.uv0;
            _PlanarNMn_690e893d26999680a5cea3604ed0ce16.uv3 = IN.uv3;
            float4 _PlanarNMn_690e893d26999680a5cea3604ed0ce16_XZ_2_Vector4;
            SG_PlanarNMn_1b93a87456f9d4c419321d0cd92bd6c8_float(_Property_d7e9139e0ac6718b89c610009c28a25a_Out_0_Texture2D, _Property_256beda96caf2d8aa05d3de41fc08d3d_Out_0_Vector4, _Property_bd9dfe8dd615798f9f2d72d139e56d61_Out_0_Boolean, UnityBuildSamplerStateStruct(SamplerState_Linear_Repeat_Aniso8), 1, _PlanarNMn_690e893d26999680a5cea3604ed0ce16, _PlanarNMn_690e893d26999680a5cea3604ed0ce16_XZ_2_Vector4);
            float _Property_0fd4d87ded104c829a6110c044eaa5f2_Out_0_Float = _CoverNormalBlendHardness;
            float3 _NormalStrength_c4639a6dd3dfde85b591971db2700eaf_Out_2_Vector3;
            Unity_NormalStrength_float((_PlanarNMn_690e893d26999680a5cea3604ed0ce16_XZ_2_Vector4.xyz), _Property_0fd4d87ded104c829a6110c044eaa5f2_Out_0_Float, _NormalStrength_c4639a6dd3dfde85b591971db2700eaf_Out_2_Vector3);
            float _Split_8ff22a6bdd437780ac7ea5963e1c5bb4_R_1_Float = IN.WorldSpaceNormal[0];
            float _Split_8ff22a6bdd437780ac7ea5963e1c5bb4_G_2_Float = IN.WorldSpaceNormal[1];
            float _Split_8ff22a6bdd437780ac7ea5963e1c5bb4_B_3_Float = IN.WorldSpaceNormal[2];
            float _Split_8ff22a6bdd437780ac7ea5963e1c5bb4_A_4_Float = 0;
            float _Property_28052b023ac35c8e9a95b30327681cc5_Out_0_Float = _Cover_Amount;
            float _Property_7749c0d5b28c14869ab3ba35d226788b_Out_0_Float = _Cover_Amount_Grow_Speed;
            float _Subtract_e5dc2afce7ff588fa1d4c91f78de7575_Out_2_Float;
            Unity_Subtract_float(float(4), _Property_7749c0d5b28c14869ab3ba35d226788b_Out_0_Float, _Subtract_e5dc2afce7ff588fa1d4c91f78de7575_Out_2_Float);
            float _Divide_c77b003bf1ce13828c94a705676e2b30_Out_2_Float;
            Unity_Divide_float(_Property_28052b023ac35c8e9a95b30327681cc5_Out_0_Float, _Subtract_e5dc2afce7ff588fa1d4c91f78de7575_Out_2_Float, _Divide_c77b003bf1ce13828c94a705676e2b30_Out_2_Float);
            float _Absolute_c7499cf07bdd0582abd82adbf367b0fc_Out_1_Float;
            Unity_Absolute_float(_Divide_c77b003bf1ce13828c94a705676e2b30_Out_2_Float, _Absolute_c7499cf07bdd0582abd82adbf367b0fc_Out_1_Float);
            float _Power_a9431dbce44a528f9ee7095adfa10556_Out_2_Float;
            Unity_Power_float(_Absolute_c7499cf07bdd0582abd82adbf367b0fc_Out_1_Float, _Subtract_e5dc2afce7ff588fa1d4c91f78de7575_Out_2_Float, _Power_a9431dbce44a528f9ee7095adfa10556_Out_2_Float);
            float _Clamp_815ffdd53cc1c889aa00f73784cb71e7_Out_3_Float;
            Unity_Clamp_float(_Power_a9431dbce44a528f9ee7095adfa10556_Out_2_Float, float(0), float(2), _Clamp_815ffdd53cc1c889aa00f73784cb71e7_Out_3_Float);
            float _Multiply_143da4886728ff868f10e9cfa6940ea0_Out_2_Float;
            Unity_Multiply_float_float(_Split_8ff22a6bdd437780ac7ea5963e1c5bb4_G_2_Float, _Clamp_815ffdd53cc1c889aa00f73784cb71e7_Out_3_Float, _Multiply_143da4886728ff868f10e9cfa6940ea0_Out_2_Float);
            float _Saturate_04686ab19029f68c8fb9e7a115b207b1_Out_1_Float;
            Unity_Saturate_float(_Multiply_143da4886728ff868f10e9cfa6940ea0_Out_2_Float, _Saturate_04686ab19029f68c8fb9e7a115b207b1_Out_1_Float);
            float _Clamp_9c0a88ffc7be288cbe97d3e13a014fe8_Out_3_Float;
            Unity_Clamp_float(_Split_8ff22a6bdd437780ac7ea5963e1c5bb4_G_2_Float, float(0), float(0.9999), _Clamp_9c0a88ffc7be288cbe97d3e13a014fe8_Out_3_Float);
            float _Property_58f42b34c7f0728f8c98e00a3e3a5726_Out_0_Float = _Cover_Max_Angle;
            float _Divide_b785767ecc1928889893fa60eac4e5fb_Out_2_Float;
            Unity_Divide_float(_Property_58f42b34c7f0728f8c98e00a3e3a5726_Out_0_Float, float(45), _Divide_b785767ecc1928889893fa60eac4e5fb_Out_2_Float);
            float _OneMinus_8e6f5b1570dc8c8b8afb036328281675_Out_1_Float;
            Unity_OneMinus_float(_Divide_b785767ecc1928889893fa60eac4e5fb_Out_2_Float, _OneMinus_8e6f5b1570dc8c8b8afb036328281675_Out_1_Float);
            float _Subtract_5348fb3702fea78d9ee10dbf81ede29c_Out_2_Float;
            Unity_Subtract_float(_Clamp_9c0a88ffc7be288cbe97d3e13a014fe8_Out_3_Float, _OneMinus_8e6f5b1570dc8c8b8afb036328281675_Out_1_Float, _Subtract_5348fb3702fea78d9ee10dbf81ede29c_Out_2_Float);
            float _Clamp_2b888688983edd82ac250226d9378893_Out_3_Float;
            Unity_Clamp_float(_Subtract_5348fb3702fea78d9ee10dbf81ede29c_Out_2_Float, float(0), float(2), _Clamp_2b888688983edd82ac250226d9378893_Out_3_Float);
            float _Divide_5615f16c20214d888a2e727ff7c5f5ff_Out_2_Float;
            Unity_Divide_float(float(1), _Divide_b785767ecc1928889893fa60eac4e5fb_Out_2_Float, _Divide_5615f16c20214d888a2e727ff7c5f5ff_Out_2_Float);
            float _Multiply_89aeffc0ad067981a18e6a77948b2b49_Out_2_Float;
            Unity_Multiply_float_float(_Clamp_2b888688983edd82ac250226d9378893_Out_3_Float, _Divide_5615f16c20214d888a2e727ff7c5f5ff_Out_2_Float, _Multiply_89aeffc0ad067981a18e6a77948b2b49_Out_2_Float);
            float _Absolute_b91ed8e326de8f88bf52e49cc5f641d4_Out_1_Float;
            Unity_Absolute_float(_Multiply_89aeffc0ad067981a18e6a77948b2b49_Out_2_Float, _Absolute_b91ed8e326de8f88bf52e49cc5f641d4_Out_1_Float);
            float _Property_4879e96694aee98c9d4ecd329a571123_Out_0_Float = _CoverHardness;
            float _Power_ca1f1906c90fb785bfe520b7faefc3cd_Out_2_Float;
            Unity_Power_float(_Absolute_b91ed8e326de8f88bf52e49cc5f641d4_Out_1_Float, _Property_4879e96694aee98c9d4ecd329a571123_Out_0_Float, _Power_ca1f1906c90fb785bfe520b7faefc3cd_Out_2_Float);
            float _Property_b66201e787ab7b83a55abc6ddd3fe1fd_Out_0_Float = _Cover_Min_Height;
            float _OneMinus_87c740d245de388db4fe5f4958de0668_Out_1_Float;
            Unity_OneMinus_float(_Property_b66201e787ab7b83a55abc6ddd3fe1fd_Out_0_Float, _OneMinus_87c740d245de388db4fe5f4958de0668_Out_1_Float);
            float _Split_ae16de7cacf9d0878aba1467f193d681_R_1_Float = IN.AbsoluteWorldSpacePosition[0];
            float _Split_ae16de7cacf9d0878aba1467f193d681_G_2_Float = IN.AbsoluteWorldSpacePosition[1];
            float _Split_ae16de7cacf9d0878aba1467f193d681_B_3_Float = IN.AbsoluteWorldSpacePosition[2];
            float _Split_ae16de7cacf9d0878aba1467f193d681_A_4_Float = 0;
            float _Add_9d6e1dd03919c88bb01e77a9a2b6b59c_Out_2_Float;
            Unity_Add_float(_OneMinus_87c740d245de388db4fe5f4958de0668_Out_1_Float, _Split_ae16de7cacf9d0878aba1467f193d681_G_2_Float, _Add_9d6e1dd03919c88bb01e77a9a2b6b59c_Out_2_Float);
            float _Add_448f30a2cd792b868416a253a1c502bb_Out_2_Float;
            Unity_Add_float(_Add_9d6e1dd03919c88bb01e77a9a2b6b59c_Out_2_Float, float(1), _Add_448f30a2cd792b868416a253a1c502bb_Out_2_Float);
            float _Clamp_53d91568d0627d8a9cac8deecdd003a8_Out_3_Float;
            Unity_Clamp_float(_Add_448f30a2cd792b868416a253a1c502bb_Out_2_Float, float(0), float(1), _Clamp_53d91568d0627d8a9cac8deecdd003a8_Out_3_Float);
            float _Property_98b8c0fc7e8f9b88b8d7d9dd28ed8aca_Out_0_Float = _Cover_Min_Height_Blending;
            float _Add_0edbe9f424de6d8089b453804bc6ec74_Out_2_Float;
            Unity_Add_float(_Add_9d6e1dd03919c88bb01e77a9a2b6b59c_Out_2_Float, _Property_98b8c0fc7e8f9b88b8d7d9dd28ed8aca_Out_0_Float, _Add_0edbe9f424de6d8089b453804bc6ec74_Out_2_Float);
            float _Divide_bacd243000beaa86b28174bd47716791_Out_2_Float;
            Unity_Divide_float(_Add_0edbe9f424de6d8089b453804bc6ec74_Out_2_Float, _Add_9d6e1dd03919c88bb01e77a9a2b6b59c_Out_2_Float, _Divide_bacd243000beaa86b28174bd47716791_Out_2_Float);
            float _OneMinus_dd51a0c56dbb9b8b8882c6d36bfadd50_Out_1_Float;
            Unity_OneMinus_float(_Divide_bacd243000beaa86b28174bd47716791_Out_2_Float, _OneMinus_dd51a0c56dbb9b8b8882c6d36bfadd50_Out_1_Float);
            float _Add_58dd4a9dfd5655818255c74dd17921da_Out_2_Float;
            Unity_Add_float(_OneMinus_dd51a0c56dbb9b8b8882c6d36bfadd50_Out_1_Float, float(-0.5), _Add_58dd4a9dfd5655818255c74dd17921da_Out_2_Float);
            float _Clamp_5b36f07b81ef6f87a93aefa8fcb815b4_Out_3_Float;
            Unity_Clamp_float(_Add_58dd4a9dfd5655818255c74dd17921da_Out_2_Float, float(0), float(1), _Clamp_5b36f07b81ef6f87a93aefa8fcb815b4_Out_3_Float);
            float _Add_5ef49a57de2cdf85b0e894bfa07f6f14_Out_2_Float;
            Unity_Add_float(_Clamp_53d91568d0627d8a9cac8deecdd003a8_Out_3_Float, _Clamp_5b36f07b81ef6f87a93aefa8fcb815b4_Out_3_Float, _Add_5ef49a57de2cdf85b0e894bfa07f6f14_Out_2_Float);
            float _Clamp_130844801cc2148bb64804d2328686eb_Out_3_Float;
            Unity_Clamp_float(_Add_5ef49a57de2cdf85b0e894bfa07f6f14_Out_2_Float, float(0), float(1), _Clamp_130844801cc2148bb64804d2328686eb_Out_3_Float);
            float _Multiply_4a38c41b77a2458085ff4ae52ba3c21c_Out_2_Float;
            Unity_Multiply_float_float(_Power_ca1f1906c90fb785bfe520b7faefc3cd_Out_2_Float, _Clamp_130844801cc2148bb64804d2328686eb_Out_3_Float, _Multiply_4a38c41b77a2458085ff4ae52ba3c21c_Out_2_Float);
            float _Multiply_edc44afd10069b8e80460ceee1cba8f0_Out_2_Float;
            Unity_Multiply_float_float(_Saturate_04686ab19029f68c8fb9e7a115b207b1_Out_1_Float, _Multiply_4a38c41b77a2458085ff4ae52ba3c21c_Out_2_Float, _Multiply_edc44afd10069b8e80460ceee1cba8f0_Out_2_Float);
            float3 _Lerp_05179f1a9a06b084b2d83e8bce908cce_Out_3_Vector3;
            Unity_Lerp_float3(_NormalBlend_9f531c87e2e45580b1d0f65f06c23526_Out_2_Vector3, _NormalStrength_c4639a6dd3dfde85b591971db2700eaf_Out_2_Vector3, (_Multiply_edc44afd10069b8e80460ceee1cba8f0_Out_2_Float.xxx), _Lerp_05179f1a9a06b084b2d83e8bce908cce_Out_3_Vector3);
            float3 _Transform_d583fb35b7a2838399ae5ff4e71be918_Out_1_Vector3;
            {
                float3x3 tangentTransform = float3x3(IN.WorldSpaceTangent, IN.WorldSpaceBiTangent, IN.WorldSpaceNormal);
                _Transform_d583fb35b7a2838399ae5ff4e71be918_Out_1_Vector3 = TransformTangentToWorldDir(_Lerp_05179f1a9a06b084b2d83e8bce908cce_Out_3_Vector3.xyz, tangentTransform, false).xyz;
            }
            float _Split_44ee9f8d0d54618cabce22ec49a8e7d3_R_1_Float = _Transform_d583fb35b7a2838399ae5ff4e71be918_Out_1_Vector3[0];
            float _Split_44ee9f8d0d54618cabce22ec49a8e7d3_G_2_Float = _Transform_d583fb35b7a2838399ae5ff4e71be918_Out_1_Vector3[1];
            float _Split_44ee9f8d0d54618cabce22ec49a8e7d3_B_3_Float = _Transform_d583fb35b7a2838399ae5ff4e71be918_Out_1_Vector3[2];
            float _Split_44ee9f8d0d54618cabce22ec49a8e7d3_A_4_Float = 0;
            float _Multiply_61fc6a92f0e952858b5d99f2caeb09a3_Out_2_Float;
            Unity_Multiply_float_float(_Split_44ee9f8d0d54618cabce22ec49a8e7d3_G_2_Float, _Clamp_815ffdd53cc1c889aa00f73784cb71e7_Out_3_Float, _Multiply_61fc6a92f0e952858b5d99f2caeb09a3_Out_2_Float);
            float _Multiply_1e7ca8eeb2afb68a96897072c537d835_Out_2_Float;
            Unity_Multiply_float_float(_Clamp_815ffdd53cc1c889aa00f73784cb71e7_Out_3_Float, _Property_4879e96694aee98c9d4ecd329a571123_Out_0_Float, _Multiply_1e7ca8eeb2afb68a96897072c537d835_Out_2_Float);
            float _Multiply_a16d49a3ef8d76899c86b7d84d20ef1f_Out_2_Float;
            Unity_Multiply_float_float(_Multiply_1e7ca8eeb2afb68a96897072c537d835_Out_2_Float, _Multiply_4a38c41b77a2458085ff4ae52ba3c21c_Out_2_Float, _Multiply_a16d49a3ef8d76899c86b7d84d20ef1f_Out_2_Float);
            float _Multiply_dd6ce40548593687a3441a83047275eb_Out_2_Float;
            Unity_Multiply_float_float(_Multiply_61fc6a92f0e952858b5d99f2caeb09a3_Out_2_Float, _Multiply_a16d49a3ef8d76899c86b7d84d20ef1f_Out_2_Float, _Multiply_dd6ce40548593687a3441a83047275eb_Out_2_Float);
            float _Clamp_a3bc14da42d1452f9459b4703c528466_Out_3_Float;
            Unity_Clamp_float(_Multiply_dd6ce40548593687a3441a83047275eb_Out_2_Float, float(0), float(1), _Clamp_a3bc14da42d1452f9459b4703c528466_Out_3_Float);
            float _Multiply_ce9d0ae57259445ba0ff1b83b3eac7be_Out_2_Float;
            Unity_Multiply_float_float(_Clamp_bb1427696ce14fe987f799fecc5f9fac_Out_3_Float, _Clamp_a3bc14da42d1452f9459b4703c528466_Out_3_Float, _Multiply_ce9d0ae57259445ba0ff1b83b3eac7be_Out_2_Float);
            #if defined(_USEDYNAMICCOVERTSTATICMASKF)
            float _UseDynamicCover_5ab22e0469924273a6c7c42f82abda85_Out_0_Float = _Multiply_ce9d0ae57259445ba0ff1b83b3eac7be_Out_2_Float;
            #else
            float _UseDynamicCover_5ab22e0469924273a6c7c42f82abda85_Out_0_Float = _Clamp_bb1427696ce14fe987f799fecc5f9fac_Out_3_Float;
            #endif
            Bindings_UniversalHeighblend_3b5c31b864970d04197cd420b6c4b0fa_float _UniversalHeighblend_21bd55d8d402489499f7ea440e52eb45;
            float _UniversalHeighblend_21bd55d8d402489499f7ea440e52eb45_Heightmap_1_Float;
            SG_UniversalHeighblend_3b5c31b864970d04197cd420b6c4b0fa_float(_Split_a80936a3c75945efb8cf9f2b95c76642_G_2_Float, _Property_14a6757619d64822a44a69b34f85276d_Out_0_Float, _Property_c0d9ffba7dee497c885a54170977d874_Out_0_Boolean, _Split_218e1cfd00b30984921b5fc0ec63de60_B_3_Float, _Add_1f9ea9bdf36544b59f763806e7eea80d_Out_2_Vector2, _Property_0fbef18600294e199eeda9905e3304e4_Out_0_Boolean, _Split_2f45bca363698c859e51492899bc58f8_B_3_Float, _Add_28628d641d58481084e9c00e4ad5fc8d_Out_2_Vector2, _UseDynamicCover_5ab22e0469924273a6c7c42f82abda85_Out_0_Float, _UniversalHeighblend_21bd55d8d402489499f7ea440e52eb45, _UniversalHeighblend_21bd55d8d402489499f7ea440e52eb45_Heightmap_1_Float);
            float _Split_05a25ef5bb1c4867950074f8c86410e8_R_1_Float = IN.VertexColor[0];
            float _Split_05a25ef5bb1c4867950074f8c86410e8_G_2_Float = IN.VertexColor[1];
            float _Split_05a25ef5bb1c4867950074f8c86410e8_B_3_Float = IN.VertexColor[2];
            float _Split_05a25ef5bb1c4867950074f8c86410e8_A_4_Float = IN.VertexColor[3];
            float _OneMinus_0527b7625ff14e8c8ca27817ac4fe9f9_Out_1_Float;
            Unity_OneMinus_float(_Split_05a25ef5bb1c4867950074f8c86410e8_B_3_Float, _OneMinus_0527b7625ff14e8c8ca27817ac4fe9f9_Out_1_Float);
            float _Property_defdd10d24ee4948b18af67062372fb7_Out_0_Float = _VertexColorBBlendStrenght;
            float _Property_f600c3fa0837403fa7000ace8a7aa949_Out_0_Boolean = _USEBaseHeightT;
            float _Property_cc1df5222a194b39870a1906a95881c7_Out_0_Boolean = _USECoverHeightT;
            float _Subtract_df32895ca10a49a6adc84378c30ceb7c_Out_2_Float;
            Unity_Subtract_float(_Property_0e120eb0a0a14b12a31a3c1f5b961121_Out_0_Float, _Property_32b48052fdbb4641bf4eeb294bc65050_Out_0_Float, _Subtract_df32895ca10a49a6adc84378c30ceb7c_Out_2_Float);
            float _Split_a090b28818f34dd8945b893c7fd769f1_R_1_Float = IN.VertexColor[0];
            float _Split_a090b28818f34dd8945b893c7fd769f1_G_2_Float = IN.VertexColor[1];
            float _Split_a090b28818f34dd8945b893c7fd769f1_B_3_Float = IN.VertexColor[2];
            float _Split_a090b28818f34dd8945b893c7fd769f1_A_4_Float = IN.VertexColor[3];
            float _OneMinus_d11f0c4a04b345419edf8e146b9c0221_Out_1_Float;
            Unity_OneMinus_float(_Split_a090b28818f34dd8945b893c7fd769f1_B_3_Float, _OneMinus_d11f0c4a04b345419edf8e146b9c0221_Out_1_Float);
            float _Multiply_b7ff184632b347e9b3d331daaed81a77_Out_2_Float;
            Unity_Multiply_float_float(_Subtract_df32895ca10a49a6adc84378c30ceb7c_Out_2_Float, _OneMinus_d11f0c4a04b345419edf8e146b9c0221_Out_1_Float, _Multiply_b7ff184632b347e9b3d331daaed81a77_Out_2_Float);
            float _Add_ff8ced5a04044788a5de3632a403c505_Out_2_Float;
            Unity_Add_float(_Property_6b467710b0ba48058e003aebe9119249_Out_0_Float, _Multiply_b7ff184632b347e9b3d331daaed81a77_Out_2_Float, _Add_ff8ced5a04044788a5de3632a403c505_Out_2_Float);
            float2 _Add_8ec067f807d04641bea7fd38ab0c8165_Out_2_Vector2;
            Unity_Add_float2(_Vector2_6955747f7f0a4ff98fae60dbada25e89_Out_0_Vector2, (_Add_ff8ced5a04044788a5de3632a403c505_Out_2_Float.xx), _Add_8ec067f807d04641bea7fd38ab0c8165_Out_2_Vector2);
            Bindings_UniversalHeighblend_3b5c31b864970d04197cd420b6c4b0fa_float _UniversalHeighblend_69e2f839a11b4aa7b8e84d65b0ac8307;
            float _UniversalHeighblend_69e2f839a11b4aa7b8e84d65b0ac8307_Heightmap_1_Float;
            SG_UniversalHeighblend_3b5c31b864970d04197cd420b6c4b0fa_float(_OneMinus_0527b7625ff14e8c8ca27817ac4fe9f9_Out_1_Float, _Property_defdd10d24ee4948b18af67062372fb7_Out_0_Float, _Property_f600c3fa0837403fa7000ace8a7aa949_Out_0_Boolean, _Split_218e1cfd00b30984921b5fc0ec63de60_B_3_Float, _Add_1f9ea9bdf36544b59f763806e7eea80d_Out_2_Vector2, _Property_cc1df5222a194b39870a1906a95881c7_Out_0_Boolean, _Split_2f45bca363698c859e51492899bc58f8_B_3_Float, _Add_8ec067f807d04641bea7fd38ab0c8165_Out_2_Vector2, float(1), _UniversalHeighblend_69e2f839a11b4aa7b8e84d65b0ac8307, _UniversalHeighblend_69e2f839a11b4aa7b8e84d65b0ac8307_Heightmap_1_Float);
            float _Add_facc0ab0661749d4bda41177c639b438_Out_2_Float;
            Unity_Add_float(_UniversalHeighblend_21bd55d8d402489499f7ea440e52eb45_Heightmap_1_Float, _UniversalHeighblend_69e2f839a11b4aa7b8e84d65b0ac8307_Heightmap_1_Float, _Add_facc0ab0661749d4bda41177c639b438_Out_2_Float);
            float _Saturate_269cfab86e2abe83819a3afa7b3eeda2_Out_1_Float;
            Unity_Saturate_float(_Add_facc0ab0661749d4bda41177c639b438_Out_2_Float, _Saturate_269cfab86e2abe83819a3afa7b3eeda2_Out_1_Float);
            float4 _Lerp_562b79f1df34b88e9a8a7431d434b435_Out_3_Vector4;
            Unity_Lerp_float4(_Combine_b0f28916143e4b94af6bec53f5328b52_RGBA_4_Vector4, _Multiply_b08794693505bd8e8c04b9ba1610d394_Out_2_Vector4, (_Saturate_269cfab86e2abe83819a3afa7b3eeda2_Out_1_Float.xxxx), _Lerp_562b79f1df34b88e9a8a7431d434b435_Out_3_Vector4);
            float4 _Property_44d9b71d47bc4d02b6d549b527e9d094_Out_0_Vector4 = _WetColor;
            float4 _Multiply_388c575a3467b88ab4d3719bf2b02ad5_Out_2_Vector4;
            Unity_Multiply_float4_float4(_Property_44d9b71d47bc4d02b6d549b527e9d094_Out_0_Vector4, _Lerp_562b79f1df34b88e9a8a7431d434b435_Out_3_Vector4, _Multiply_388c575a3467b88ab4d3719bf2b02ad5_Out_2_Vector4);
            float4 _Clamp_33ec4dd182654e108c0f4ee43f91e820_Out_3_Vector4;
            Unity_Clamp_float4(IN.VertexColor, float4(0, 0, 0, 0), float4(1, 1, 1, 1), _Clamp_33ec4dd182654e108c0f4ee43f91e820_Out_3_Vector4);
            float _Split_5b2299b48b10138ea40c141b79bfe90e_R_1_Float = _Clamp_33ec4dd182654e108c0f4ee43f91e820_Out_3_Vector4[0];
            float _Split_5b2299b48b10138ea40c141b79bfe90e_G_2_Float = _Clamp_33ec4dd182654e108c0f4ee43f91e820_Out_3_Vector4[1];
            float _Split_5b2299b48b10138ea40c141b79bfe90e_B_3_Float = _Clamp_33ec4dd182654e108c0f4ee43f91e820_Out_3_Vector4[2];
            float _Split_5b2299b48b10138ea40c141b79bfe90e_A_4_Float = _Clamp_33ec4dd182654e108c0f4ee43f91e820_Out_3_Vector4[3];
            float _OneMinus_489965dacb44928393bb0c19acfc1dad_Out_1_Float;
            Unity_OneMinus_float(_Split_5b2299b48b10138ea40c141b79bfe90e_R_1_Float, _OneMinus_489965dacb44928393bb0c19acfc1dad_Out_1_Float);
            float4 _Lerp_9f334e8d59abc78798691219f06b2fdb_Out_3_Vector4;
            Unity_Lerp_float4(_Lerp_562b79f1df34b88e9a8a7431d434b435_Out_3_Vector4, _Multiply_388c575a3467b88ab4d3719bf2b02ad5_Out_2_Vector4, (_OneMinus_489965dacb44928393bb0c19acfc1dad_Out_1_Float.xxxx), _Lerp_9f334e8d59abc78798691219f06b2fdb_Out_3_Vector4);
            #if defined(_WETNESS_T_HEAT_F)
            float4 _WetnessTHeatF_7390507dc4254612ae0a227e5143183d_Out_0_Vector4 = _Lerp_9f334e8d59abc78798691219f06b2fdb_Out_3_Vector4;
            #else
            float4 _WetnessTHeatF_7390507dc4254612ae0a227e5143183d_Out_0_Vector4 = _Lerp_562b79f1df34b88e9a8a7431d434b435_Out_3_Vector4;
            #endif
            float4 Color_e553016c85254743b6051ed07aa64a6b = IsGammaSpace() ? LinearToSRGB(float4(0, 0, 0, 0)) : float4(0, 0, 0, 0);
            float _OneMinus_4d3b7f38bc644deaa5f1d244c0b9d1ee_Out_1_Float;
            Unity_OneMinus_float(_Split_218e1cfd00b30984921b5fc0ec63de60_G_2_Float, _OneMinus_4d3b7f38bc644deaa5f1d244c0b9d1ee_Out_1_Float);
            float _Split_c179bdbdbe5d44bdb614c4a9dd684f08_R_1_Float = IN.VertexColor[0];
            float _Split_c179bdbdbe5d44bdb614c4a9dd684f08_G_2_Float = IN.VertexColor[1];
            float _Split_c179bdbdbe5d44bdb614c4a9dd684f08_B_3_Float = IN.VertexColor[2];
            float _Split_c179bdbdbe5d44bdb614c4a9dd684f08_A_4_Float = IN.VertexColor[3];
            float _Clamp_0a7dd8a8d15f4e2a9eadb3d1f311e68c_Out_3_Float;
            Unity_Clamp_float(_Split_c179bdbdbe5d44bdb614c4a9dd684f08_R_1_Float, float(0), float(1), _Clamp_0a7dd8a8d15f4e2a9eadb3d1f311e68c_Out_3_Float);
            float _OneMinus_c85200bd0b22447a928d6f06eb113bb4_Out_1_Float;
            Unity_OneMinus_float(_Clamp_0a7dd8a8d15f4e2a9eadb3d1f311e68c_Out_3_Float, _OneMinus_c85200bd0b22447a928d6f06eb113bb4_Out_1_Float);
            float _Lerp_42887225ab924c5897118a743ddf24af_Out_3_Float;
            Unity_Lerp_float(float(0), _OneMinus_4d3b7f38bc644deaa5f1d244c0b9d1ee_Out_1_Float, _OneMinus_c85200bd0b22447a928d6f06eb113bb4_Out_1_Float, _Lerp_42887225ab924c5897118a743ddf24af_Out_3_Float);
            float _Property_606dc338aeef47969895771d12f2d38b_Out_0_Float = _BaseEmissionMaskIntensivity;
            float _Multiply_ce3fb5c46004495291e3a5c1c4124a48_Out_2_Float;
            Unity_Multiply_float_float(_Lerp_42887225ab924c5897118a743ddf24af_Out_3_Float, _Property_606dc338aeef47969895771d12f2d38b_Out_0_Float, _Multiply_ce3fb5c46004495291e3a5c1c4124a48_Out_2_Float);
            float _Absolute_db426b4c7ff34d91af15c6055c7523d1_Out_1_Float;
            Unity_Absolute_float(_Multiply_ce3fb5c46004495291e3a5c1c4124a48_Out_2_Float, _Absolute_db426b4c7ff34d91af15c6055c7523d1_Out_1_Float);
            float _Property_f0a12955c88c45d4839682aabc178f68_Out_0_Float = _BaseEmissionMaskTreshold;
            float _Power_948bdcff83b44a68b06dab91a4acb8aa_Out_2_Float;
            Unity_Power_float(_Absolute_db426b4c7ff34d91af15c6055c7523d1_Out_1_Float, _Property_f0a12955c88c45d4839682aabc178f68_Out_0_Float, _Power_948bdcff83b44a68b06dab91a4acb8aa_Out_2_Float);
            float _Split_f79493bbeb184f9fa903dd435dddf63e_R_1_Float = _Power_948bdcff83b44a68b06dab91a4acb8aa_Out_2_Float;
            float _Split_f79493bbeb184f9fa903dd435dddf63e_G_2_Float = 0;
            float _Split_f79493bbeb184f9fa903dd435dddf63e_B_3_Float = 0;
            float _Split_f79493bbeb184f9fa903dd435dddf63e_A_4_Float = 0;
            float _OneMinus_859309a0dff444b080fd5111ebbfdeb1_Out_1_Float;
            Unity_OneMinus_float(_Split_2f45bca363698c859e51492899bc58f8_G_2_Float, _OneMinus_859309a0dff444b080fd5111ebbfdeb1_Out_1_Float);
            float _Lerp_45c734cedcc74e2f868233751038d219_Out_3_Float;
            Unity_Lerp_float(float(0), _OneMinus_859309a0dff444b080fd5111ebbfdeb1_Out_1_Float, _OneMinus_c85200bd0b22447a928d6f06eb113bb4_Out_1_Float, _Lerp_45c734cedcc74e2f868233751038d219_Out_3_Float);
            float _Property_16d7b20087974f05a44a14a7d1d4e79b_Out_0_Float = _CoverEmissionMaskIntensivity;
            float _Multiply_624708dce85442e5bfe57d872f174df9_Out_2_Float;
            Unity_Multiply_float_float(_Lerp_45c734cedcc74e2f868233751038d219_Out_3_Float, _Property_16d7b20087974f05a44a14a7d1d4e79b_Out_0_Float, _Multiply_624708dce85442e5bfe57d872f174df9_Out_2_Float);
            float _Absolute_4b837863fc2044808429eeb18aafedae_Out_1_Float;
            Unity_Absolute_float(_Multiply_624708dce85442e5bfe57d872f174df9_Out_2_Float, _Absolute_4b837863fc2044808429eeb18aafedae_Out_1_Float);
            float _Property_2e664738eae4446c97ad4ec20f7e2028_Out_0_Float = _CoverEmissionMaskTreshold;
            float _Power_ab72ec0c8d604ed4a93dde47371091a6_Out_2_Float;
            Unity_Power_float(_Absolute_4b837863fc2044808429eeb18aafedae_Out_1_Float, _Property_2e664738eae4446c97ad4ec20f7e2028_Out_0_Float, _Power_ab72ec0c8d604ed4a93dde47371091a6_Out_2_Float);
            float _Lerp_023dc09265f14e56ae5473ca7b26294d_Out_3_Float;
            Unity_Lerp_float(_Split_f79493bbeb184f9fa903dd435dddf63e_R_1_Float, _Power_ab72ec0c8d604ed4a93dde47371091a6_Out_2_Float, _Saturate_269cfab86e2abe83819a3afa7b3eeda2_Out_1_Float, _Lerp_023dc09265f14e56ae5473ca7b26294d_Out_3_Float);
            float4 _Property_f4a77722436441c9a77e3c23dad8b88e_Out_0_Vector4 = IsGammaSpace() ? LinearToSRGB(_LavaEmissionColor) : _LavaEmissionColor;
            float4 _Multiply_4ffe85e4185949c6ac7d540068494138_Out_2_Vector4;
            Unity_Multiply_float4_float4((_Lerp_023dc09265f14e56ae5473ca7b26294d_Out_3_Float.xxxx), _Property_f4a77722436441c9a77e3c23dad8b88e_Out_0_Vector4, _Multiply_4ffe85e4185949c6ac7d540068494138_Out_2_Vector4);
            UnityTexture2D _Property_00795552653740bb881853e3daf2cf3f_Out_0_Texture2D = UnityBuildTexture2DStructNoScale(_Noise);
            float4 _Property_006d4241a7524b2583b5cc3097ff74ca_Out_0_Vector4 = _Emission_Noise_Tiling_and_Offset;
            float _Split_73d52870da5a455bb786b2c0fc9492c2_R_1_Float = _Property_006d4241a7524b2583b5cc3097ff74ca_Out_0_Vector4[0];
            float _Split_73d52870da5a455bb786b2c0fc9492c2_G_2_Float = _Property_006d4241a7524b2583b5cc3097ff74ca_Out_0_Vector4[1];
            float _Split_73d52870da5a455bb786b2c0fc9492c2_B_3_Float = _Property_006d4241a7524b2583b5cc3097ff74ca_Out_0_Vector4[2];
            float _Split_73d52870da5a455bb786b2c0fc9492c2_A_4_Float = _Property_006d4241a7524b2583b5cc3097ff74ca_Out_0_Vector4[3];
            float2 _Vector2_158f933d3fcd425392974c5cbc3cd56d_Out_0_Vector2 = float2(_Split_73d52870da5a455bb786b2c0fc9492c2_B_3_Float, _Split_73d52870da5a455bb786b2c0fc9492c2_A_4_Float);
            float2 _Property_40c7afe0030e415f8a1d31eeeb6b7393_Out_0_Vector2 = _NoiseSpeed;
            float _TimeCustomFunction_e6f001ad051b4ab78d1e2e9ddff8a244_Out_0_Float;
            Time_float(_TimeCustomFunction_e6f001ad051b4ab78d1e2e9ddff8a244_Out_0_Float);
            float2 _Multiply_8c6b65dd9b814c2da6a4483fda26ec51_Out_2_Vector2;
            Unity_Multiply_float2_float2(_Property_40c7afe0030e415f8a1d31eeeb6b7393_Out_0_Vector2, (_TimeCustomFunction_e6f001ad051b4ab78d1e2e9ddff8a244_Out_0_Float.xx), _Multiply_8c6b65dd9b814c2da6a4483fda26ec51_Out_2_Vector2);
            float2 _Add_4e8254b7e8c447d1af503ec6b1d99df6_Out_2_Vector2;
            Unity_Add_float2(_Vector2_158f933d3fcd425392974c5cbc3cd56d_Out_0_Vector2, _Multiply_8c6b65dd9b814c2da6a4483fda26ec51_Out_2_Vector2, _Add_4e8254b7e8c447d1af503ec6b1d99df6_Out_2_Vector2);
            float _Split_952b7b5a519048aeb5301164f67dd18a_R_1_Float = _Add_4e8254b7e8c447d1af503ec6b1d99df6_Out_2_Vector2[0];
            float _Split_952b7b5a519048aeb5301164f67dd18a_G_2_Float = _Add_4e8254b7e8c447d1af503ec6b1d99df6_Out_2_Vector2[1];
            float _Split_952b7b5a519048aeb5301164f67dd18a_B_3_Float = 0;
            float _Split_952b7b5a519048aeb5301164f67dd18a_A_4_Float = 0;
            float4 _Vector4_92e5675ce4234ea8a8198220bb39b015_Out_0_Vector4 = float4(_Split_73d52870da5a455bb786b2c0fc9492c2_R_1_Float, _Split_73d52870da5a455bb786b2c0fc9492c2_G_2_Float, _Split_952b7b5a519048aeb5301164f67dd18a_R_1_Float, _Split_952b7b5a519048aeb5301164f67dd18a_G_2_Float);
            float _Property_278fd9fc173e4625a1df64a92ba39390_Out_0_Boolean = _EmissionNoiseUsePlanarUV;
            float _Property_4b43a2e8035f4d20a5aa3c0d056dc9b8_Out_0_Boolean = Emission_Noise_UV0_UV3;
            Bindings_PlanarNM_c0f081da9c567704ea36e7dd38cedcf6_float _PlanarNM_9f397ccc775f4957b919b19d5b986acf;
            _PlanarNM_9f397ccc775f4957b919b19d5b986acf.AbsoluteWorldSpacePosition = IN.AbsoluteWorldSpacePosition;
            _PlanarNM_9f397ccc775f4957b919b19d5b986acf.uv0 = IN.uv0;
            _PlanarNM_9f397ccc775f4957b919b19d5b986acf.uv3 = IN.uv3;
            float4 _PlanarNM_9f397ccc775f4957b919b19d5b986acf_XZ_2_Vector4;
            SG_PlanarNM_c0f081da9c567704ea36e7dd38cedcf6_float(_Property_00795552653740bb881853e3daf2cf3f_Out_0_Texture2D, _Vector4_92e5675ce4234ea8a8198220bb39b015_Out_0_Vector4, _Property_278fd9fc173e4625a1df64a92ba39390_Out_0_Boolean, UnityBuildSamplerStateStruct(SamplerState_Linear_Repeat), _Property_4b43a2e8035f4d20a5aa3c0d056dc9b8_Out_0_Boolean, _PlanarNM_9f397ccc775f4957b919b19d5b986acf, _PlanarNM_9f397ccc775f4957b919b19d5b986acf_XZ_2_Vector4);
            float _Split_ad5f3d981abc4297be097b02598cbf16_R_1_Float = _PlanarNM_9f397ccc775f4957b919b19d5b986acf_XZ_2_Vector4[0];
            float _Split_ad5f3d981abc4297be097b02598cbf16_G_2_Float = _PlanarNM_9f397ccc775f4957b919b19d5b986acf_XZ_2_Vector4[1];
            float _Split_ad5f3d981abc4297be097b02598cbf16_B_3_Float = _PlanarNM_9f397ccc775f4957b919b19d5b986acf_XZ_2_Vector4[2];
            float _Split_ad5f3d981abc4297be097b02598cbf16_A_4_Float = _PlanarNM_9f397ccc775f4957b919b19d5b986acf_XZ_2_Vector4[3];
            float2 _Multiply_10da8cfb1b844c91b029f95ae9ec5b8f_Out_2_Vector2;
            Unity_Multiply_float2_float2(_Add_4e8254b7e8c447d1af503ec6b1d99df6_Out_2_Vector2, float2(-1.2, -0.9), _Multiply_10da8cfb1b844c91b029f95ae9ec5b8f_Out_2_Vector2);
            float2 _Add_307dce75a10243509597c2a661e556e7_Out_2_Vector2;
            Unity_Add_float2(_Multiply_10da8cfb1b844c91b029f95ae9ec5b8f_Out_2_Vector2, float2(0.5, 0.5), _Add_307dce75a10243509597c2a661e556e7_Out_2_Vector2);
            float _Split_d80e19706e9c48a69346db34ed2e1279_R_1_Float = _Add_307dce75a10243509597c2a661e556e7_Out_2_Vector2[0];
            float _Split_d80e19706e9c48a69346db34ed2e1279_G_2_Float = _Add_307dce75a10243509597c2a661e556e7_Out_2_Vector2[1];
            float _Split_d80e19706e9c48a69346db34ed2e1279_B_3_Float = 0;
            float _Split_d80e19706e9c48a69346db34ed2e1279_A_4_Float = 0;
            float4 _Vector4_96981646541d4722b5ef09551f6c683c_Out_0_Vector4 = float4(_Split_73d52870da5a455bb786b2c0fc9492c2_R_1_Float, _Split_73d52870da5a455bb786b2c0fc9492c2_G_2_Float, _Split_d80e19706e9c48a69346db34ed2e1279_R_1_Float, _Split_d80e19706e9c48a69346db34ed2e1279_G_2_Float);
            Bindings_PlanarNM_c0f081da9c567704ea36e7dd38cedcf6_float _PlanarNM_f19fcf05a02e4741a756f5cc341b4f5e;
            _PlanarNM_f19fcf05a02e4741a756f5cc341b4f5e.AbsoluteWorldSpacePosition = IN.AbsoluteWorldSpacePosition;
            _PlanarNM_f19fcf05a02e4741a756f5cc341b4f5e.uv0 = IN.uv0;
            _PlanarNM_f19fcf05a02e4741a756f5cc341b4f5e.uv3 = IN.uv3;
            float4 _PlanarNM_f19fcf05a02e4741a756f5cc341b4f5e_XZ_2_Vector4;
            SG_PlanarNM_c0f081da9c567704ea36e7dd38cedcf6_float(_Property_00795552653740bb881853e3daf2cf3f_Out_0_Texture2D, _Vector4_96981646541d4722b5ef09551f6c683c_Out_0_Vector4, _Property_278fd9fc173e4625a1df64a92ba39390_Out_0_Boolean, UnityBuildSamplerStateStruct(SamplerState_Linear_Repeat), _Property_4b43a2e8035f4d20a5aa3c0d056dc9b8_Out_0_Boolean, _PlanarNM_f19fcf05a02e4741a756f5cc341b4f5e, _PlanarNM_f19fcf05a02e4741a756f5cc341b4f5e_XZ_2_Vector4);
            float _Split_d5ec4f4d1e024709846d0576eb89bbca_R_1_Float = _PlanarNM_f19fcf05a02e4741a756f5cc341b4f5e_XZ_2_Vector4[0];
            float _Split_d5ec4f4d1e024709846d0576eb89bbca_G_2_Float = _PlanarNM_f19fcf05a02e4741a756f5cc341b4f5e_XZ_2_Vector4[1];
            float _Split_d5ec4f4d1e024709846d0576eb89bbca_B_3_Float = _PlanarNM_f19fcf05a02e4741a756f5cc341b4f5e_XZ_2_Vector4[2];
            float _Split_d5ec4f4d1e024709846d0576eb89bbca_A_4_Float = _PlanarNM_f19fcf05a02e4741a756f5cc341b4f5e_XZ_2_Vector4[3];
            float _Minimum_cd1daa7571e84585a203f83a48d8831a_Out_2_Float;
            Unity_Minimum_float(_Split_ad5f3d981abc4297be097b02598cbf16_A_4_Float, _Split_d5ec4f4d1e024709846d0576eb89bbca_A_4_Float, _Minimum_cd1daa7571e84585a203f83a48d8831a_Out_2_Float);
            float _Property_e7aef1fd7db945f2b6cf08be86efb1da_Out_0_Float = _EmissionNoiseMultiply;
            float _Multiply_36ffbb52845a491aa68eb4198a1a38e1_Out_2_Float;
            Unity_Multiply_float_float(_Minimum_cd1daa7571e84585a203f83a48d8831a_Out_2_Float, _Property_e7aef1fd7db945f2b6cf08be86efb1da_Out_0_Float, _Multiply_36ffbb52845a491aa68eb4198a1a38e1_Out_2_Float);
            float _Clamp_1406bf6d718c47639db90df3e930ec88_Out_3_Float;
            Unity_Clamp_float(_Multiply_36ffbb52845a491aa68eb4198a1a38e1_Out_2_Float, float(0), float(1), _Clamp_1406bf6d718c47639db90df3e930ec88_Out_3_Float);
            float _Absolute_25371384e8aa40f7a1a8143c24daafa7_Out_1_Float;
            Unity_Absolute_float(_Clamp_1406bf6d718c47639db90df3e930ec88_Out_3_Float, _Absolute_25371384e8aa40f7a1a8143c24daafa7_Out_1_Float);
            float _Property_b14cce2aa2354622a768385b02f85470_Out_0_Float = _EmissionNoisePower;
            float _Power_f1ee1566c8384717963cc242dd98650a_Out_2_Float;
            Unity_Power_float(_Absolute_25371384e8aa40f7a1a8143c24daafa7_Out_1_Float, _Property_b14cce2aa2354622a768385b02f85470_Out_0_Float, _Power_f1ee1566c8384717963cc242dd98650a_Out_2_Float);
            float _Multiply_34e318c6bc414a92baf58b6c0c43c29f_Out_2_Float;
            Unity_Multiply_float_float(_Power_f1ee1566c8384717963cc242dd98650a_Out_2_Float, 20, _Multiply_34e318c6bc414a92baf58b6c0c43c29f_Out_2_Float);
            float _Clamp_bec0a9e722c641748d5e70491cb9a2b2_Out_3_Float;
            Unity_Clamp_float(_Multiply_34e318c6bc414a92baf58b6c0c43c29f_Out_2_Float, float(0.05), float(1.2), _Clamp_bec0a9e722c641748d5e70491cb9a2b2_Out_3_Float);
            float4 _Multiply_7645a5b5112a49bca08420cfface3451_Out_2_Vector4;
            Unity_Multiply_float4_float4(_Multiply_4ffe85e4185949c6ac7d540068494138_Out_2_Vector4, (_Clamp_bec0a9e722c641748d5e70491cb9a2b2_Out_3_Float.xxxx), _Multiply_7645a5b5112a49bca08420cfface3451_Out_2_Vector4);
            float4 _Property_ca86ca33c2ae4885ba38452d9e56a7e5_Out_0_Vector4 = IsGammaSpace() ? LinearToSRGB(_RimColor) : _RimColor;
            float _Property_16c4ac023c82618b9a5117de14716c25_Out_0_Float = _CoverNormalScale;
            float3 _NormalStrength_76b1f6b709c2558a897aa152a50733b3_Out_2_Vector3;
            Unity_NormalStrength_float((_PlanarNMn_690e893d26999680a5cea3604ed0ce16_XZ_2_Vector4.xyz), _Property_16c4ac023c82618b9a5117de14716c25_Out_0_Float, _NormalStrength_76b1f6b709c2558a897aa152a50733b3_Out_2_Vector3);
            float3 _Lerp_337d63ad6393ae88af4c89b066722a45_Out_3_Vector3;
            Unity_Lerp_float3(_NormalBlend_9f531c87e2e45580b1d0f65f06c23526_Out_2_Vector3, _NormalStrength_76b1f6b709c2558a897aa152a50733b3_Out_2_Vector3, (_Saturate_269cfab86e2abe83819a3afa7b3eeda2_Out_1_Float.xxx), _Lerp_337d63ad6393ae88af4c89b066722a45_Out_3_Vector3);
            float3 _Normalize_c4982c8cad634f628b5c428f3d903c7d_Out_1_Vector3;
            Unity_Normalize_float3(IN.TangentSpaceViewDirection, _Normalize_c4982c8cad634f628b5c428f3d903c7d_Out_1_Vector3);
            float _DotProduct_159813334d0546d1b48a9b61ad70a171_Out_2_Float;
            Unity_DotProduct_float3(_Lerp_337d63ad6393ae88af4c89b066722a45_Out_3_Vector3, _Normalize_c4982c8cad634f628b5c428f3d903c7d_Out_1_Vector3, _DotProduct_159813334d0546d1b48a9b61ad70a171_Out_2_Float);
            float _Saturate_5a5aac19081c4d4b8903fc7860f9a0c2_Out_1_Float;
            Unity_Saturate_float(_DotProduct_159813334d0546d1b48a9b61ad70a171_Out_2_Float, _Saturate_5a5aac19081c4d4b8903fc7860f9a0c2_Out_1_Float);
            float _OneMinus_ef8f9d7083b54e2885c1382b817e2652_Out_1_Float;
            Unity_OneMinus_float(_Saturate_5a5aac19081c4d4b8903fc7860f9a0c2_Out_1_Float, _OneMinus_ef8f9d7083b54e2885c1382b817e2652_Out_1_Float);
            float _Absolute_f6a29424054e4847b2545876315446e9_Out_1_Float;
            Unity_Absolute_float(_OneMinus_ef8f9d7083b54e2885c1382b817e2652_Out_1_Float, _Absolute_f6a29424054e4847b2545876315446e9_Out_1_Float);
            float _Power_57bee61abc694e7d8946acd86e5c7471_Out_2_Float;
            Unity_Power_float(_Absolute_f6a29424054e4847b2545876315446e9_Out_1_Float, float(10), _Power_57bee61abc694e7d8946acd86e5c7471_Out_2_Float);
            float4 _Multiply_8bcb4ce8918a4b2a9e321cfb7b2212ed_Out_2_Vector4;
            Unity_Multiply_float4_float4(_Property_ca86ca33c2ae4885ba38452d9e56a7e5_Out_0_Vector4, (_Power_57bee61abc694e7d8946acd86e5c7471_Out_2_Float.xxxx), _Multiply_8bcb4ce8918a4b2a9e321cfb7b2212ed_Out_2_Vector4);
            float _Property_aee69b4a68284a749ad0eeb6f13105cd_Out_0_Float = _RimLightPower;
            float4 _Multiply_5626d1059bb54a5e9499b3f53d1b5904_Out_2_Vector4;
            Unity_Multiply_float4_float4(_Multiply_8bcb4ce8918a4b2a9e321cfb7b2212ed_Out_2_Vector4, (_Property_aee69b4a68284a749ad0eeb6f13105cd_Out_0_Float.xxxx), _Multiply_5626d1059bb54a5e9499b3f53d1b5904_Out_2_Vector4);
            float4 _Multiply_c4b66106a8a0468aab2f1323013186d7_Out_2_Vector4;
            Unity_Multiply_float4_float4((_Lerp_023dc09265f14e56ae5473ca7b26294d_Out_3_Float.xxxx), _Multiply_5626d1059bb54a5e9499b3f53d1b5904_Out_2_Vector4, _Multiply_c4b66106a8a0468aab2f1323013186d7_Out_2_Vector4);
            float4 _Add_74f0b45c2e704e74a319f41d62506eed_Out_2_Vector4;
            Unity_Add_float4(_Multiply_7645a5b5112a49bca08420cfface3451_Out_2_Vector4, _Multiply_c4b66106a8a0468aab2f1323013186d7_Out_2_Vector4, _Add_74f0b45c2e704e74a319f41d62506eed_Out_2_Vector4);
            float4 _Clamp_cacf98ce9e9044c4986500fac50caa89_Out_3_Vector4;
            Unity_Clamp_float4(_Add_74f0b45c2e704e74a319f41d62506eed_Out_2_Vector4, float4(0, 0, 0, 0), _Add_74f0b45c2e704e74a319f41d62506eed_Out_2_Vector4, _Clamp_cacf98ce9e9044c4986500fac50caa89_Out_3_Vector4);
            #if defined(_WETNESS_T_HEAT_F)
            float4 _WetnessTHeatF_e4281f82d9f54deca38dcc29b0789b9b_Out_0_Vector4 = Color_e553016c85254743b6051ed07aa64a6b;
            #else
            float4 _WetnessTHeatF_e4281f82d9f54deca38dcc29b0789b9b_Out_0_Vector4 = _Clamp_cacf98ce9e9044c4986500fac50caa89_Out_3_Vector4;
            #endif
            float _Split_546cdec490fe4753bb0983eea82b45b5_R_1_Float = _Lerp_562b79f1df34b88e9a8a7431d434b435_Out_3_Vector4[0];
            float _Split_546cdec490fe4753bb0983eea82b45b5_G_2_Float = _Lerp_562b79f1df34b88e9a8a7431d434b435_Out_3_Vector4[1];
            float _Split_546cdec490fe4753bb0983eea82b45b5_B_3_Float = _Lerp_562b79f1df34b88e9a8a7431d434b435_Out_3_Vector4[2];
            float _Split_546cdec490fe4753bb0983eea82b45b5_A_4_Float = _Lerp_562b79f1df34b88e9a8a7431d434b435_Out_3_Vector4[3];
            float _Multiply_a7796e97d268424b880f9cb87fc6e42c_Out_2_Float;
            Unity_Multiply_float_float(_Split_546cdec490fe4753bb0983eea82b45b5_A_4_Float, _Split_5b2299b48b10138ea40c141b79bfe90e_A_4_Float, _Multiply_a7796e97d268424b880f9cb87fc6e42c_Out_2_Float);
            float _Property_7ae68b65d6ed4f37aec08ecb89701e8e_Out_0_Float = _AlphaCutoff;
            surface.BaseColor = (_WetnessTHeatF_7390507dc4254612ae0a227e5143183d_Out_0_Vector4.xyz);
            surface.Emission = (_WetnessTHeatF_e4281f82d9f54deca38dcc29b0789b9b_Out_0_Vector4.xyz);
            surface.Alpha = _Multiply_a7796e97d268424b880f9cb87fc6e42c_Out_2_Float;
            surface.AlphaClipThreshold = _Property_7ae68b65d6ed4f37aec08ecb89701e8e_Out_0_Float;
            return surface;
        }
        
        // --------------------------------------------------
        // Build Graph Inputs
        #ifdef HAVE_VFX_MODIFICATION
        #define VFX_SRP_ATTRIBUTES Attributes
        #define VFX_SRP_VARYINGS Varyings
        #define VFX_SRP_SURFACE_INPUTS SurfaceDescriptionInputs
        #endif
        VertexDescriptionInputs BuildVertexDescriptionInputs(Attributes input)
        {
            VertexDescriptionInputs output;
            ZERO_INITIALIZE(VertexDescriptionInputs, output);
        
            output.ObjectSpaceNormal =                          input.normalOS;
            output.ObjectSpaceTangent =                         input.tangentOS.xyz;
            output.ObjectSpacePosition =                        input.positionOS;
        #if UNITY_ANY_INSTANCING_ENABLED
        #else // TODO: XR support for procedural instancing because in this case UNITY_ANY_INSTANCING_ENABLED is not defined and instanceID is incorrect.
        #endif
        
            return output;
        }
        SurfaceDescriptionInputs BuildSurfaceDescriptionInputs(Varyings input)
        {
            SurfaceDescriptionInputs output;
            ZERO_INITIALIZE(SurfaceDescriptionInputs, output);
        
        #ifdef HAVE_VFX_MODIFICATION
        #if VFX_USE_GRAPH_VALUES
            uint instanceActiveIndex = asuint(UNITY_ACCESS_INSTANCED_PROP(PerInstance, _InstanceActiveIndex));
            /* WARNING: $splice Could not find named fragment 'VFXLoadGraphValues' */
        #endif
            /* WARNING: $splice Could not find named fragment 'VFXSetFragInputs' */
        
        #endif
        
            
        
            // must use interpolated tangent, bitangent and normal before they are normalized in the pixel shader.
            float3 unnormalizedNormalWS = input.normalWS;
            const float renormFactor = 1.0 / length(unnormalizedNormalWS);
        
            // use bitangent on the fly like in hdrp
            // IMPORTANT! If we ever support Flip on double sided materials ensure bitangent and tangent are NOT flipped.
            float crossSign = (input.tangentWS.w > 0.0 ? 1.0 : -1.0)* GetOddNegativeScale();
            float3 bitang = crossSign * cross(input.normalWS.xyz, input.tangentWS.xyz);
        
            output.WorldSpaceNormal = renormFactor * input.normalWS.xyz;      // we want a unit length Normal Vector node in shader graph
        
            // to pr               eserve mikktspace compliance we use same scale renormFactor as was used on the normal.
            // This                is explained in section 2.2 in "surface gradient based bump mapping framework"
            output.WorldSpaceTangent = renormFactor * input.tangentWS.xyz;
            output.WorldSpaceBiTangent = renormFactor * bitang;
        
            output.WorldSpaceViewDirection = GetWorldSpaceNormalizeViewDir(input.positionWS);
            float3x3 tangentSpaceTransform = float3x3(output.WorldSpaceTangent, output.WorldSpaceBiTangent, output.WorldSpaceNormal);
            output.TangentSpaceViewDirection = mul(tangentSpaceTransform, output.WorldSpaceViewDirection);
            output.AbsoluteWorldSpacePosition = GetAbsolutePositionWS(input.positionWS);
        
            #if UNITY_UV_STARTS_AT_TOP
            #else
            #endif
        
        
            output.uv0 = input.texCoord0;
            output.uv3 = input.texCoord3;
            output.VertexColor = input.color;
        #if UNITY_ANY_INSTANCING_ENABLED
        #else // TODO: XR support for procedural instancing because in this case UNITY_ANY_INSTANCING_ENABLED is not defined and instanceID is incorrect.
        #endif
        #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
        #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN output.FaceSign =                    IS_FRONT_VFACE(input.cullFace, true, false);
        #else
        #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
        #endif
        #undef BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
        
                return output;
        }
        
        // --------------------------------------------------
        // Main
        
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/Varyings.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/LightingMetaPass.hlsl"
        
        // --------------------------------------------------
        // Visual Effect Vertex Invocations
        #ifdef HAVE_VFX_MODIFICATION
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/VisualEffectVertex.hlsl"
        #endif
        
        ENDHLSL
        }
        Pass
        {
            Name "SceneSelectionPass"
            Tags
            {
                "LightMode" = "SceneSelectionPass"
            }
        
        // Render State
        Cull Off
        
        // Debug
        // <None>
        
        // --------------------------------------------------
        // Pass
        
        HLSLPROGRAM
        
        // Pragmas
        #pragma target 2.0
        #pragma vertex vert
        #pragma fragment frag
        
        // Keywords
        #pragma shader_feature_local_fragment _ _ALPHATEST_ON
        #pragma shader_feature_local _ _USEDYNAMICCOVERTSTATICMASKF
        #pragma shader_feature_local _ _WETNESS_T_HEAT_F
        
        #if defined(_USEDYNAMICCOVERTSTATICMASKF) && defined(_WETNESS_T_HEAT_F)
            #define KEYWORD_PERMUTATION_0
        #elif defined(_USEDYNAMICCOVERTSTATICMASKF)
            #define KEYWORD_PERMUTATION_1
        #elif defined(_WETNESS_T_HEAT_F)
            #define KEYWORD_PERMUTATION_2
        #else
            #define KEYWORD_PERMUTATION_3
        #endif
        
        
        // Defines
        
        #define _NORMALMAP 1
        #define _NORMAL_DROPOFF_TS 1
        #define ATTRIBUTES_NEED_NORMAL
        #define ATTRIBUTES_NEED_TANGENT
        #define ATTRIBUTES_NEED_TEXCOORD0
        #define ATTRIBUTES_NEED_TEXCOORD3
        #define ATTRIBUTES_NEED_COLOR
        #define FEATURES_GRAPH_VERTEX_NORMAL_OUTPUT
        #define FEATURES_GRAPH_VERTEX_TANGENT_OUTPUT
        #define VARYINGS_NEED_POSITION_WS
        #define VARYINGS_NEED_NORMAL_WS
        #define VARYINGS_NEED_TANGENT_WS
        #define VARYINGS_NEED_TEXCOORD0
        #define VARYINGS_NEED_TEXCOORD3
        #define VARYINGS_NEED_COLOR
        #define FEATURES_GRAPH_VERTEX
        /* WARNING: $splice Could not find named fragment 'PassInstancing' */
        #define SHADERPASS SHADERPASS_DEPTHONLY
        #define SCENESELECTIONPASS 1
        #define ALPHA_CLIP_THRESHOLD 1
        
        
        // custom interpolator pre-include
        /* WARNING: $splice Could not find named fragment 'sgci_CustomInterpolatorPreInclude' */
        
        // Includes
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Texture.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
        #include_with_pragmas "Packages/com.unity.render-pipelines.core/ShaderLibrary/FoveatedRenderingKeywords.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/FoveatedRendering.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Input.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/TextureStack.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/DebugMipmapStreamingMacros.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"
        #include_with_pragmas "Packages/com.unity.render-pipelines.universal/ShaderLibrary/DOTS.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShaderPass.hlsl"
        
        // --------------------------------------------------
        // Structs and Packing
        
        // custom interpolators pre packing
        /* WARNING: $splice Could not find named fragment 'CustomInterpolatorPrePacking' */
        
        struct Attributes
        {
             float3 positionOS : POSITION;
             float3 normalOS : NORMAL;
             float4 tangentOS : TANGENT;
             float4 uv0 : TEXCOORD0;
             float4 uv3 : TEXCOORD3;
             float4 color : COLOR;
            #if UNITY_ANY_INSTANCING_ENABLED || defined(ATTRIBUTES_NEED_INSTANCEID)
             uint instanceID : INSTANCEID_SEMANTIC;
            #endif
        };
        struct Varyings
        {
             float4 positionCS : SV_POSITION;
             float3 positionWS;
             float3 normalWS;
             float4 tangentWS;
             float4 texCoord0;
             float4 texCoord3;
             float4 color;
            #if UNITY_ANY_INSTANCING_ENABLED || defined(VARYINGS_NEED_INSTANCEID)
             uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
             uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
             uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
             FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
        };
        struct SurfaceDescriptionInputs
        {
             float3 WorldSpaceNormal;
             float3 WorldSpaceTangent;
             float3 WorldSpaceBiTangent;
             float3 AbsoluteWorldSpacePosition;
             float4 uv0;
             float4 uv3;
             float4 VertexColor;
        };
        struct VertexDescriptionInputs
        {
             float3 ObjectSpaceNormal;
             float3 ObjectSpaceTangent;
             float3 ObjectSpacePosition;
        };
        struct PackedVaryings
        {
             float4 positionCS : SV_POSITION;
             float4 tangentWS : INTERP0;
             float4 texCoord0 : INTERP1;
             float4 texCoord3 : INTERP2;
             float4 color : INTERP3;
             float3 positionWS : INTERP4;
             float3 normalWS : INTERP5;
            #if UNITY_ANY_INSTANCING_ENABLED || defined(VARYINGS_NEED_INSTANCEID)
             uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
             uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
             uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
             FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
        };
        
        PackedVaryings PackVaryings (Varyings input)
        {
            PackedVaryings output;
            ZERO_INITIALIZE(PackedVaryings, output);
            output.positionCS = input.positionCS;
            output.tangentWS.xyzw = input.tangentWS;
            output.texCoord0.xyzw = input.texCoord0;
            output.texCoord3.xyzw = input.texCoord3;
            output.color.xyzw = input.color;
            output.positionWS.xyz = input.positionWS;
            output.normalWS.xyz = input.normalWS;
            #if UNITY_ANY_INSTANCING_ENABLED || defined(VARYINGS_NEED_INSTANCEID)
            output.instanceID = input.instanceID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            output.cullFace = input.cullFace;
            #endif
            return output;
        }
        
        Varyings UnpackVaryings (PackedVaryings input)
        {
            Varyings output;
            output.positionCS = input.positionCS;
            output.tangentWS = input.tangentWS.xyzw;
            output.texCoord0 = input.texCoord0.xyzw;
            output.texCoord3 = input.texCoord3.xyzw;
            output.color = input.color.xyzw;
            output.positionWS = input.positionWS.xyz;
            output.normalWS = input.normalWS.xyz;
            #if UNITY_ANY_INSTANCING_ENABLED || defined(VARYINGS_NEED_INSTANCEID)
            output.instanceID = input.instanceID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            output.cullFace = input.cullFace;
            #endif
            return output;
        }
        
        
        // --------------------------------------------------
        // Graph
        
        // Graph Properties
        CBUFFER_START(UnityPerMaterial)
        float _EmissionNoiseMultiply;
        float _EmissionNoisePower;
        float Emission_Noise_UV0_UV3;
        float _EmissionNoiseUsePlanarUV;
        float _BaseEmissionMaskTreshold;
        float _CoverEmissionMaskIntensivity;
        float _CoverEmissionMaskTreshold;
        float4 _RimColor;
        float _RimLightPower;
        float4 _Noise_TexelSize;
        float2 _NoiseSpeed;
        float _BaseEmissionMaskIntensivity;
        float4 _LavaEmissionColor;
        float4 _Emission_Noise_Tiling_and_Offset;
        float _Cover_Mask_A_Remap_Min;
        float _Cover_Mask_A_Remap_Max;
        float _HeightMin;
        float _HeightMax;
        float _HeightOffset;
        float _VertexColorBBlendStrenght;
        float _USECoverHeightT;
        float _AlphaCutoff;
        float4 _WetColor;
        float4 _BaseColor;
        float _USEBaseHeightT;
        float4 _BaseColorMap_TexelSize;
        float _BaseUsePlanarUV;
        float4 _BaseTilingOffset;
        float4 _BaseNormalMap_TexelSize;
        float _BaseNormalScale;
        float4 _BaseMaskMap_TexelSize;
        float _BaseMetallic;
        float _VertexColorGBlendStrenght;
        float _BaseAORemapMin;
        float _BaseAORemapMax;
        float _BaseSmoothnessRemapMin;
        float _BaseSmoothnessRemapMax;
        float4 _Masks_TexelSize;
        float _Cover_Amount;
        float _Cover_Amount_Grow_Speed;
        float _Cover_Max_Angle;
        float _Cover_Min_Height;
        float _Cover_Min_Height_Blending;
        float4 _CoverBaseColor;
        float4 _CoverBaseColorMap_TexelSize;
        float _CoverUsePlanarUV;
        float4 _CoverTilingOffset;
        float4 _CoverNormalMap_TexelSize;
        float _CoverNormalScale;
        float _CoverNormalBlendHardness;
        float _CoverHardness;
        float _CoverHeightMapMin;
        float _CoverHeightMapMax;
        float _CoverHeightMapOffset;
        float4 _CoverMaskMap_TexelSize;
        float _CoverMetallic;
        float _CoverAORemapMin;
        float _CoverAORemapMax;
        float _CoverSmoothnessRemapMin;
        float _CoverSmoothnessRemapMax;
        float4 _DetailMap_TexelSize;
        float4 _DetailTilingOffset;
        float _DetailAlbedoScale;
        float _DetailNormalScale;
        float _DetailSmoothnessScale;
        float _WetSmoothness;
        UNITY_TEXTURE_STREAMING_DEBUG_VARS;
        CBUFFER_END
        
        
        // Object and Global properties
        SAMPLER(SamplerState_Linear_Repeat);
        SAMPLER(SamplerState_Linear_Repeat_Aniso8);
        TEXTURE2D(_Noise);
        SAMPLER(sampler_Noise);
        TEXTURE2D(_BaseColorMap);
        SAMPLER(sampler_BaseColorMap);
        TEXTURE2D(_BaseNormalMap);
        SAMPLER(sampler_BaseNormalMap);
        TEXTURE2D(_BaseMaskMap);
        SAMPLER(sampler_BaseMaskMap);
        TEXTURE2D(_Masks);
        SAMPLER(sampler_Masks);
        TEXTURE2D(_CoverBaseColorMap);
        SAMPLER(sampler_CoverBaseColorMap);
        TEXTURE2D(_CoverNormalMap);
        SAMPLER(sampler_CoverNormalMap);
        TEXTURE2D(_CoverMaskMap);
        SAMPLER(sampler_CoverMaskMap);
        TEXTURE2D(_DetailMap);
        SAMPLER(sampler_DetailMap);
        
        // Graph Includes
        // GraphIncludes: <None>
        
        // -- Property used by ScenePickingPass
        #ifdef SCENEPICKINGPASS
        float4 _SelectionID;
        #endif
        
        // -- Properties used by SceneSelectionPass
        #ifdef SCENESELECTIONPASS
        int _ObjectId;
        int _PassValue;
        #endif
        
        // Graph Functions
        
        void Unity_Combine_float(float R, float G, float B, float A, out float4 RGBA, out float3 RGB, out float2 RG)
        {
            RGBA = float4(R, G, B, A);
            RGB = float3(R, G, B);
            RG = float2(R, G);
        }
        
        void Unity_Divide_float(float A, float B, out float Out)
        {
            Out = A / B;
        }
        
        void Unity_Multiply_float4_float4(float4 A, float4 B, out float4 Out)
        {
        Out = A * B;
        }
        
        void Unity_Branch_float4(float Predicate, float4 True, float4 False, out float4 Out)
        {
            Out = Predicate ? True : False;
        }
        
        void Unity_TilingAndOffset_float(float2 UV, float2 Tiling, float2 Offset, out float2 Out)
        {
            Out = UV * Tiling + Offset;
        }
        
        void Unity_Branch_float2(float Predicate, float2 True, float2 False, out float2 Out)
        {
            Out = Predicate ? True : False;
        }
        
        struct Bindings_PlanarNM_c0f081da9c567704ea36e7dd38cedcf6_float
        {
        float3 AbsoluteWorldSpacePosition;
        half4 uv0;
        half4 uv3;
        };
        
        void SG_PlanarNM_c0f081da9c567704ea36e7dd38cedcf6_float(UnityTexture2D Texture2D_80A3D28F, float4 Vector4_2EBA7A3B, float Boolean_7ABB9909, UnitySamplerState _SamplerState, float Boolean_5ddfe6daabcc4715a44b5f34fc19becb, Bindings_PlanarNM_c0f081da9c567704ea36e7dd38cedcf6_float IN, out float4 XZ_2)
        {
        UnityTexture2D _Property_3e01b4d2fc68d48ba3acbba9d5881e59_Out_0_Texture2D = Texture2D_80A3D28F;
        float _Property_30834f691775a0898a45b1c868520436_Out_0_Boolean = Boolean_7ABB9909;
        float _Split_89ed63cb625cb3878c183d0b71c03400_R_1_Float = IN.AbsoluteWorldSpacePosition[0];
        float _Split_89ed63cb625cb3878c183d0b71c03400_G_2_Float = IN.AbsoluteWorldSpacePosition[1];
        float _Split_89ed63cb625cb3878c183d0b71c03400_B_3_Float = IN.AbsoluteWorldSpacePosition[2];
        float _Split_89ed63cb625cb3878c183d0b71c03400_A_4_Float = 0;
        float4 _Combine_cf2d04ff119ad88493f6460431765cbb_RGBA_4_Vector4;
        float3 _Combine_cf2d04ff119ad88493f6460431765cbb_RGB_5_Vector3;
        float2 _Combine_cf2d04ff119ad88493f6460431765cbb_RG_6_Vector2;
        Unity_Combine_float(_Split_89ed63cb625cb3878c183d0b71c03400_R_1_Float, _Split_89ed63cb625cb3878c183d0b71c03400_B_3_Float, float(0), float(0), _Combine_cf2d04ff119ad88493f6460431765cbb_RGBA_4_Vector4, _Combine_cf2d04ff119ad88493f6460431765cbb_RGB_5_Vector3, _Combine_cf2d04ff119ad88493f6460431765cbb_RG_6_Vector2);
        float4 _Property_8a66888ec47d0687ab1cb2f8abdc9da8_Out_0_Vector4 = Vector4_2EBA7A3B;
        float _Split_2f0f52f6ef8c0e81af0da6476402bc1f_R_1_Float = _Property_8a66888ec47d0687ab1cb2f8abdc9da8_Out_0_Vector4[0];
        float _Split_2f0f52f6ef8c0e81af0da6476402bc1f_G_2_Float = _Property_8a66888ec47d0687ab1cb2f8abdc9da8_Out_0_Vector4[1];
        float _Split_2f0f52f6ef8c0e81af0da6476402bc1f_B_3_Float = _Property_8a66888ec47d0687ab1cb2f8abdc9da8_Out_0_Vector4[2];
        float _Split_2f0f52f6ef8c0e81af0da6476402bc1f_A_4_Float = _Property_8a66888ec47d0687ab1cb2f8abdc9da8_Out_0_Vector4[3];
        float _Divide_e64179199923c58289b6aa94ea6c9178_Out_2_Float;
        Unity_Divide_float(float(1), _Split_2f0f52f6ef8c0e81af0da6476402bc1f_R_1_Float, _Divide_e64179199923c58289b6aa94ea6c9178_Out_2_Float);
        float4 _Multiply_14cec4902d0a00829e4555071a1b8ad1_Out_2_Vector4;
        Unity_Multiply_float4_float4(_Combine_cf2d04ff119ad88493f6460431765cbb_RGBA_4_Vector4, (_Divide_e64179199923c58289b6aa94ea6c9178_Out_2_Float.xxxx), _Multiply_14cec4902d0a00829e4555071a1b8ad1_Out_2_Vector4);
        float _Property_f17c7bf877e64b6abdd66b1fe9f5accc_Out_0_Boolean = Boolean_5ddfe6daabcc4715a44b5f34fc19becb;
        float4 _UV_029e8e8198564838b9389b902a09fb22_Out_0_Vector4 = IN.uv0;
        float4 _UV_7a6209af1506424fb75c81e87e42035a_Out_0_Vector4 = IN.uv3;
        float4 _Branch_fc37bb4bf641457cbbc6e290603056ff_Out_3_Vector4;
        Unity_Branch_float4(_Property_f17c7bf877e64b6abdd66b1fe9f5accc_Out_0_Boolean, _UV_029e8e8198564838b9389b902a09fb22_Out_0_Vector4, _UV_7a6209af1506424fb75c81e87e42035a_Out_0_Vector4, _Branch_fc37bb4bf641457cbbc6e290603056ff_Out_3_Vector4);
        float2 _Vector2_16c15d3bbdd14b85bd48e3a6cb318af7_Out_0_Vector2 = float2(_Split_2f0f52f6ef8c0e81af0da6476402bc1f_R_1_Float, _Split_2f0f52f6ef8c0e81af0da6476402bc1f_G_2_Float);
        float2 _Vector2_f8d75f54e7705083bbec539a60185577_Out_0_Vector2 = float2(_Split_2f0f52f6ef8c0e81af0da6476402bc1f_B_3_Float, _Split_2f0f52f6ef8c0e81af0da6476402bc1f_A_4_Float);
        float2 _TilingAndOffset_d91e2d25acd34686b562b7fe7e9d1d27_Out_3_Vector2;
        Unity_TilingAndOffset_float((_Branch_fc37bb4bf641457cbbc6e290603056ff_Out_3_Vector4.xy), _Vector2_16c15d3bbdd14b85bd48e3a6cb318af7_Out_0_Vector2, _Vector2_f8d75f54e7705083bbec539a60185577_Out_0_Vector2, _TilingAndOffset_d91e2d25acd34686b562b7fe7e9d1d27_Out_3_Vector2);
        float2 _Branch_8e5a4e8f4d52fc8aadd1f46485afc933_Out_3_Vector2;
        Unity_Branch_float2(_Property_30834f691775a0898a45b1c868520436_Out_0_Boolean, (_Multiply_14cec4902d0a00829e4555071a1b8ad1_Out_2_Vector4.xy), _TilingAndOffset_d91e2d25acd34686b562b7fe7e9d1d27_Out_3_Vector2, _Branch_8e5a4e8f4d52fc8aadd1f46485afc933_Out_3_Vector2);
        UnitySamplerState _Property_e8746b9475c94530ba35ba8019ad2ae0_Out_0_SamplerState = _SamplerState;
        float4 _SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_RGBA_0_Vector4 = SAMPLE_TEXTURE2D(_Property_3e01b4d2fc68d48ba3acbba9d5881e59_Out_0_Texture2D.tex, _Property_e8746b9475c94530ba35ba8019ad2ae0_Out_0_SamplerState.samplerstate, _Property_3e01b4d2fc68d48ba3acbba9d5881e59_Out_0_Texture2D.GetTransformedUV(_Branch_8e5a4e8f4d52fc8aadd1f46485afc933_Out_3_Vector2) );
        float _SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_R_4_Float = _SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_RGBA_0_Vector4.r;
        float _SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_G_5_Float = _SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_RGBA_0_Vector4.g;
        float _SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_B_6_Float = _SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_RGBA_0_Vector4.b;
        float _SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_A_7_Float = _SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_RGBA_0_Vector4.a;
        XZ_2 = _SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_RGBA_0_Vector4;
        }
        
        void Unity_ColorspaceConversion_Linear_RGB_float(float3 In, out float3 Out)
        {
            float3 sRGBLo = In * 12.92;
            float3 sRGBHi = (pow(max(abs(In), 1.192092896e-07), float3(1.0 / 2.4, 1.0 / 2.4, 1.0 / 2.4)) * 1.055) - 0.055;
            Out = float3(In <= 0.0031308) ? sRGBLo : sRGBHi;
        }
        
        void Unity_Blend_Overlay_float3(float3 Base, float3 Blend, out float3 Out, float Opacity)
        {
            float3 result1 = 1.0 - 2.0 * (1.0 - Base) * (1.0 - Blend);
            float3 result2 = 2.0 * Base * Blend;
            float3 zeroOrOne = step(Base, 0.5);
            Out = result2 * zeroOrOne + (1 - zeroOrOne) * result1;
            Out = lerp(Base, Out, Opacity);
        }
        
        void Unity_ColorspaceConversion_RGB_Linear_float(float3 In, out float3 Out)
        {
            float3 linearRGBLo = In / 12.92;
            float3 linearRGBHi = pow(max(abs((In + 0.055) / 1.055), 1.192092896e-07), float3(2.4, 2.4, 2.4));
            Out = float3(In <= 0.04045) ? linearRGBLo : linearRGBHi;
        }
        
        void Unity_Clamp_float3(float3 In, float3 Min, float3 Max, out float3 Out)
        {
            Out = clamp(In, Min, Max);
        }
        
        void Unity_Add_float2(float2 A, float2 B, out float2 Out)
        {
            Out = A + B;
        }
        
        void Unity_Remap_float(float In, float2 InMinMax, float2 OutMinMax, out float Out)
        {
            Out = OutMinMax.x + (In - InMinMax.x) * (OutMinMax.y - OutMinMax.x) / (InMinMax.y - InMinMax.x);
        }
        
        void Unity_Clamp_float(float In, float Min, float Max, out float Out)
        {
            Out = clamp(In, Min, Max);
        }
        
        void Unity_Multiply_float2_float2(float2 A, float2 B, out float2 Out)
        {
            Out = A * B;
        }
        
        void Unity_DotProduct_float2(float2 A, float2 B, out float Out)
        {
            Out = dot(A, B);
        }
        
        void Unity_Saturate_float(float In, out float Out)
        {
            Out = saturate(In);
        }
        
        void Unity_OneMinus_float(float In, out float Out)
        {
            Out = 1 - In;
        }
        
        void Unity_SquareRoot_float(float In, out float Out)
        {
            Out = sqrt(In);
        }
        
        void Unity_Sign_float3(float3 In, out float3 Out)
        {
            Out = sign(In);
        }
        
        void Unity_Multiply_float_float(float A, float B, out float Out)
        {
        Out = A * B;
        }
        
        void Unity_Normalize_float3(float3 In, out float3 Out)
        {
            Out = normalize(In);
        }
        
        void Unity_Branch_float3(float Predicate, float3 True, float3 False, out float3 Out)
        {
            Out = Predicate ? True : False;
        }
        
        struct Bindings_PlanarNMn_1b93a87456f9d4c419321d0cd92bd6c8_float
        {
        float3 WorldSpaceNormal;
        float3 WorldSpaceTangent;
        float3 WorldSpaceBiTangent;
        float3 AbsoluteWorldSpacePosition;
        half4 uv0;
        half4 uv3;
        };
        
        void SG_PlanarNMn_1b93a87456f9d4c419321d0cd92bd6c8_float(UnityTexture2D Texture2D_80A3D28F, float4 Vector4_82674548, float Boolean_9FF42DF6, UnitySamplerState _SamplerState, float Boolean_5ddfe6daabcc4715a44b5f34fc19becb, Bindings_PlanarNMn_1b93a87456f9d4c419321d0cd92bd6c8_float IN, out float4 XZ_2)
        {
        float _Property_1ef12cf3201a938993fe6a7951b0e754_Out_0_Boolean = Boolean_9FF42DF6;
        UnityTexture2D _Property_3e01b4d2fc68d48ba3acbba9d5881e59_Out_0_Texture2D = Texture2D_80A3D28F;
        float _Split_89ed63cb625cb3878c183d0b71c03400_R_1_Float = IN.AbsoluteWorldSpacePosition[0];
        float _Split_89ed63cb625cb3878c183d0b71c03400_G_2_Float = IN.AbsoluteWorldSpacePosition[1];
        float _Split_89ed63cb625cb3878c183d0b71c03400_B_3_Float = IN.AbsoluteWorldSpacePosition[2];
        float _Split_89ed63cb625cb3878c183d0b71c03400_A_4_Float = 0;
        float4 _Combine_cf2d04ff119ad88493f6460431765cbb_RGBA_4_Vector4;
        float3 _Combine_cf2d04ff119ad88493f6460431765cbb_RGB_5_Vector3;
        float2 _Combine_cf2d04ff119ad88493f6460431765cbb_RG_6_Vector2;
        Unity_Combine_float(_Split_89ed63cb625cb3878c183d0b71c03400_R_1_Float, _Split_89ed63cb625cb3878c183d0b71c03400_B_3_Float, float(0), float(0), _Combine_cf2d04ff119ad88493f6460431765cbb_RGBA_4_Vector4, _Combine_cf2d04ff119ad88493f6460431765cbb_RGB_5_Vector3, _Combine_cf2d04ff119ad88493f6460431765cbb_RG_6_Vector2);
        float4 _Property_3fa1d6f912feb481ba60f2e55e62e746_Out_0_Vector4 = Vector4_82674548;
        float _Split_a2e12fa5931da084b2949343a539dfd8_R_1_Float = _Property_3fa1d6f912feb481ba60f2e55e62e746_Out_0_Vector4[0];
        float _Split_a2e12fa5931da084b2949343a539dfd8_G_2_Float = _Property_3fa1d6f912feb481ba60f2e55e62e746_Out_0_Vector4[1];
        float _Split_a2e12fa5931da084b2949343a539dfd8_B_3_Float = _Property_3fa1d6f912feb481ba60f2e55e62e746_Out_0_Vector4[2];
        float _Split_a2e12fa5931da084b2949343a539dfd8_A_4_Float = _Property_3fa1d6f912feb481ba60f2e55e62e746_Out_0_Vector4[3];
        float _Divide_c36b770dfaa0bb8f85ab27da5fd794f0_Out_2_Float;
        Unity_Divide_float(float(1), _Split_a2e12fa5931da084b2949343a539dfd8_R_1_Float, _Divide_c36b770dfaa0bb8f85ab27da5fd794f0_Out_2_Float);
        float4 _Multiply_14cec4902d0a00829e4555071a1b8ad1_Out_2_Vector4;
        Unity_Multiply_float4_float4(_Combine_cf2d04ff119ad88493f6460431765cbb_RGBA_4_Vector4, (_Divide_c36b770dfaa0bb8f85ab27da5fd794f0_Out_2_Float.xxxx), _Multiply_14cec4902d0a00829e4555071a1b8ad1_Out_2_Vector4);
        float _Property_058f4fba88c3437288219f1929444bf2_Out_0_Boolean = Boolean_5ddfe6daabcc4715a44b5f34fc19becb;
        float4 _UV_43d85b3291324c848dfbeec6adac2a71_Out_0_Vector4 = IN.uv0;
        float4 _UV_36881dcaab9040168fc5215dcd00f352_Out_0_Vector4 = IN.uv3;
        float4 _Branch_8054d58a73be4ce1b22d48a84389ae07_Out_3_Vector4;
        Unity_Branch_float4(_Property_058f4fba88c3437288219f1929444bf2_Out_0_Boolean, _UV_43d85b3291324c848dfbeec6adac2a71_Out_0_Vector4, _UV_36881dcaab9040168fc5215dcd00f352_Out_0_Vector4, _Branch_8054d58a73be4ce1b22d48a84389ae07_Out_3_Vector4);
        float2 _Vector2_6845d21872714d889783b0cb707df3e9_Out_0_Vector2 = float2(_Split_a2e12fa5931da084b2949343a539dfd8_R_1_Float, _Split_a2e12fa5931da084b2949343a539dfd8_G_2_Float);
        float2 _Vector2_e2e2263627c6098e96a5b5d29350ad03_Out_0_Vector2 = float2(_Split_a2e12fa5931da084b2949343a539dfd8_B_3_Float, _Split_a2e12fa5931da084b2949343a539dfd8_A_4_Float);
        float2 _TilingAndOffset_17582d056c0b8a8dab1017d37497fe59_Out_3_Vector2;
        Unity_TilingAndOffset_float((_Branch_8054d58a73be4ce1b22d48a84389ae07_Out_3_Vector4.xy), _Vector2_6845d21872714d889783b0cb707df3e9_Out_0_Vector2, _Vector2_e2e2263627c6098e96a5b5d29350ad03_Out_0_Vector2, _TilingAndOffset_17582d056c0b8a8dab1017d37497fe59_Out_3_Vector2);
        float2 _Branch_1e152f3aac57448f8518bf2852c000c3_Out_3_Vector2;
        Unity_Branch_float2(_Property_1ef12cf3201a938993fe6a7951b0e754_Out_0_Boolean, (_Multiply_14cec4902d0a00829e4555071a1b8ad1_Out_2_Vector4.xy), _TilingAndOffset_17582d056c0b8a8dab1017d37497fe59_Out_3_Vector2, _Branch_1e152f3aac57448f8518bf2852c000c3_Out_3_Vector2);
        UnitySamplerState _Property_69f1ed7efd1b494e91f626b88ab2363c_Out_0_SamplerState = _SamplerState;
        float4 _SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_RGBA_0_Vector4 = SAMPLE_TEXTURE2D(_Property_3e01b4d2fc68d48ba3acbba9d5881e59_Out_0_Texture2D.tex, _Property_69f1ed7efd1b494e91f626b88ab2363c_Out_0_SamplerState.samplerstate, _Property_3e01b4d2fc68d48ba3acbba9d5881e59_Out_0_Texture2D.GetTransformedUV(_Branch_1e152f3aac57448f8518bf2852c000c3_Out_3_Vector2) );
        _SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_RGBA_0_Vector4.rgb = UnpackNormal(_SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_RGBA_0_Vector4);
        float _SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_R_4_Float = _SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_RGBA_0_Vector4.r;
        float _SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_G_5_Float = _SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_RGBA_0_Vector4.g;
        float _SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_B_6_Float = _SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_RGBA_0_Vector4.b;
        float _SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_A_7_Float = _SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_RGBA_0_Vector4.a;
        float2 _Vector2_ad6bd100e273d78fa409a30a77bfa2cc_Out_0_Vector2 = float2(_SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_R_4_Float, _SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_G_5_Float);
        float3 _Sign_3a6ebf59931cf08cb0482e0144ddac24_Out_1_Vector3;
        Unity_Sign_float3(IN.WorldSpaceNormal, _Sign_3a6ebf59931cf08cb0482e0144ddac24_Out_1_Vector3);
        float _Split_6299d4ddcc4c74828aea40a46fdb896e_R_1_Float = _Sign_3a6ebf59931cf08cb0482e0144ddac24_Out_1_Vector3[0];
        float _Split_6299d4ddcc4c74828aea40a46fdb896e_G_2_Float = _Sign_3a6ebf59931cf08cb0482e0144ddac24_Out_1_Vector3[1];
        float _Split_6299d4ddcc4c74828aea40a46fdb896e_B_3_Float = _Sign_3a6ebf59931cf08cb0482e0144ddac24_Out_1_Vector3[2];
        float _Split_6299d4ddcc4c74828aea40a46fdb896e_A_4_Float = 0;
        float2 _Vector2_b76cb1842101e58b9e636d49b075c612_Out_0_Vector2 = float2(_Split_6299d4ddcc4c74828aea40a46fdb896e_G_2_Float, float(1));
        float2 _Multiply_31e8db88ee20c985a9850d1a58f3282b_Out_2_Vector2;
        Unity_Multiply_float2_float2(_Vector2_ad6bd100e273d78fa409a30a77bfa2cc_Out_0_Vector2, _Vector2_b76cb1842101e58b9e636d49b075c612_Out_0_Vector2, _Multiply_31e8db88ee20c985a9850d1a58f3282b_Out_2_Vector2);
        float _Split_5ed44bf2eca0868f81eb18100f49d1fa_R_1_Float = IN.WorldSpaceNormal[0];
        float _Split_5ed44bf2eca0868f81eb18100f49d1fa_G_2_Float = IN.WorldSpaceNormal[1];
        float _Split_5ed44bf2eca0868f81eb18100f49d1fa_B_3_Float = IN.WorldSpaceNormal[2];
        float _Split_5ed44bf2eca0868f81eb18100f49d1fa_A_4_Float = 0;
        float2 _Vector2_70e5837843f28b8b9d64cada3697bd5a_Out_0_Vector2 = float2(_Split_5ed44bf2eca0868f81eb18100f49d1fa_R_1_Float, _Split_5ed44bf2eca0868f81eb18100f49d1fa_B_3_Float);
        float2 _Add_1145b2f896593d80aa864a34e6702562_Out_2_Vector2;
        Unity_Add_float2(_Multiply_31e8db88ee20c985a9850d1a58f3282b_Out_2_Vector2, _Vector2_70e5837843f28b8b9d64cada3697bd5a_Out_0_Vector2, _Add_1145b2f896593d80aa864a34e6702562_Out_2_Vector2);
        float _Split_2bc77ca2d17bd78cb2383770ce50b179_R_1_Float = _Add_1145b2f896593d80aa864a34e6702562_Out_2_Vector2[0];
        float _Split_2bc77ca2d17bd78cb2383770ce50b179_G_2_Float = _Add_1145b2f896593d80aa864a34e6702562_Out_2_Vector2[1];
        float _Split_2bc77ca2d17bd78cb2383770ce50b179_B_3_Float = 0;
        float _Split_2bc77ca2d17bd78cb2383770ce50b179_A_4_Float = 0;
        float _Multiply_ab12aea87465a78eaf7fc66c2598d266_Out_2_Float;
        Unity_Multiply_float_float(_SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_B_6_Float, _Split_5ed44bf2eca0868f81eb18100f49d1fa_G_2_Float, _Multiply_ab12aea87465a78eaf7fc66c2598d266_Out_2_Float);
        float3 _Vector3_433840b555db308b97e9b14b6a957195_Out_0_Vector3 = float3(_Split_2bc77ca2d17bd78cb2383770ce50b179_R_1_Float, _Multiply_ab12aea87465a78eaf7fc66c2598d266_Out_2_Float, _Split_2bc77ca2d17bd78cb2383770ce50b179_G_2_Float);
        float3 _Transform_c7914cc45a011c89b3f53c55afb51673_Out_1_Vector3;
        {
        float3x3 tangentTransform = float3x3(IN.WorldSpaceTangent, IN.WorldSpaceBiTangent, IN.WorldSpaceNormal);
        _Transform_c7914cc45a011c89b3f53c55afb51673_Out_1_Vector3 = TransformWorldToTangentDir(_Vector3_433840b555db308b97e9b14b6a957195_Out_0_Vector3.xyz, tangentTransform, true);
        }
        float3 _Clamp_3837949a36b5428a82af01e7bcd29952_Out_3_Vector3;
        Unity_Clamp_float3(_Transform_c7914cc45a011c89b3f53c55afb51673_Out_1_Vector3, float3(-1, -1, -1), float3(1, 1, 1), _Clamp_3837949a36b5428a82af01e7bcd29952_Out_3_Vector3);
        float3 _Normalize_09bf8a2bd0a4d38e8b97d5c674f79b44_Out_1_Vector3;
        Unity_Normalize_float3(_Clamp_3837949a36b5428a82af01e7bcd29952_Out_3_Vector3, _Normalize_09bf8a2bd0a4d38e8b97d5c674f79b44_Out_1_Vector3);
        float3 _Branch_9eadf909a90f2f80880f8c56ecc2a91f_Out_3_Vector3;
        Unity_Branch_float3(_Property_1ef12cf3201a938993fe6a7951b0e754_Out_0_Boolean, _Normalize_09bf8a2bd0a4d38e8b97d5c674f79b44_Out_1_Vector3, (_SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_RGBA_0_Vector4.xyz), _Branch_9eadf909a90f2f80880f8c56ecc2a91f_Out_3_Vector3);
        XZ_2 = (float4(_Branch_9eadf909a90f2f80880f8c56ecc2a91f_Out_3_Vector3, 1.0));
        }
        
        void Unity_NormalStrength_float(float3 In, float Strength, out float3 Out)
        {
            Out = float3(In.rg * Strength, lerp(1, In.b, saturate(Strength)));
        }
        
        void Unity_NormalBlend_Reoriented_float(float3 A, float3 B, out float3 Out)
        {
            float3 t = A.xyz + float3(0.0, 0.0, 1.0);
            float3 u = B.xyz * float3(-1.0, -1.0, 1.0);
            Out = (t / t.z) * dot(t, u) - u;
        }
        
        void Unity_Subtract_float(float A, float B, out float Out)
        {
            Out = A - B;
        }
        
        void Unity_Absolute_float(float In, out float Out)
        {
            Out = abs(In);
        }
        
        void Unity_Power_float(float A, float B, out float Out)
        {
            Out = pow(A, B);
        }
        
        void Unity_Add_float(float A, float B, out float Out)
        {
            Out = A + B;
        }
        
        void Unity_Lerp_float3(float3 A, float3 B, float3 T, out float3 Out)
        {
            Out = lerp(A, B, T);
        }
        
        void Unity_Comparison_Greater_float(float A, float B, out float Out)
        {
            Out = A > B ? 1 : 0;
        }
        
        void Unity_Branch_float(float Predicate, float True, float False, out float Out)
        {
            Out = Predicate ? True : False;
        }
        
        struct Bindings_UniversalHeighblend_3b5c31b864970d04197cd420b6c4b0fa_float
        {
        };
        
        void SG_UniversalHeighblend_3b5c31b864970d04197cd420b6c4b0fa_float(float _Vertex_Color, float _Blend_Hardness, float _Use_Layer_1_Height_T, float _Layer_1_Height, float2 _Layer_1_Before_Remap, float _Use_Layer_2_Height_T, float _Layer_2_Height, float2 _Layer_2_Before_Remap, float _Angle_Blend, Bindings_UniversalHeighblend_3b5c31b864970d04197cd420b6c4b0fa_float IN, out float Heightmap_1)
        {
        float _Property_b3ca7054ef0043de85912fc45d997ea2_Out_0_Float = _Vertex_Color;
        float _Clamp_852774a2be524975babf4eeb54af6d64_Out_3_Float;
        Unity_Clamp_float(_Property_b3ca7054ef0043de85912fc45d997ea2_Out_0_Float, float(0), float(1), _Clamp_852774a2be524975babf4eeb54af6d64_Out_3_Float);
        float _OneMinus_85e3550f37814cd3ab5ea5dde7f63a73_Out_1_Float;
        Unity_OneMinus_float(_Clamp_852774a2be524975babf4eeb54af6d64_Out_3_Float, _OneMinus_85e3550f37814cd3ab5ea5dde7f63a73_Out_1_Float);
        float _Comparison_5be6aeaa514b4921b5eb68269b58b028_Out_2_Boolean;
        Unity_Comparison_Greater_float(_OneMinus_85e3550f37814cd3ab5ea5dde7f63a73_Out_1_Float, float(0.99), _Comparison_5be6aeaa514b4921b5eb68269b58b028_Out_2_Boolean);
        float _Property_cfe724908035497c918d6d3f8dafe439_Out_0_Boolean = _Use_Layer_1_Height_T;
        float _Property_9634fd87d3374fdaa60181281a01f9b5_Out_0_Float = _Layer_1_Height;
        float2 _Property_e748f6c127e0479a9a01040378a4129b_Out_0_Vector2 = _Layer_1_Before_Remap;
        float _Split_cde172ab161d44cb81ea7874aec65560_R_1_Float = _Property_e748f6c127e0479a9a01040378a4129b_Out_0_Vector2[0];
        float _Split_cde172ab161d44cb81ea7874aec65560_G_2_Float = _Property_e748f6c127e0479a9a01040378a4129b_Out_0_Vector2[1];
        float _Split_cde172ab161d44cb81ea7874aec65560_B_3_Float = 0;
        float _Split_cde172ab161d44cb81ea7874aec65560_A_4_Float = 0;
        float _Subtract_e1e98a956721410caddfb467ae0eca8b_Out_2_Float;
        Unity_Subtract_float(_Split_cde172ab161d44cb81ea7874aec65560_R_1_Float, _Split_cde172ab161d44cb81ea7874aec65560_G_2_Float, _Subtract_e1e98a956721410caddfb467ae0eca8b_Out_2_Float);
        float _Clamp_ac4097026e6248dbb7a95fe910cc776e_Out_3_Float;
        Unity_Clamp_float(_OneMinus_85e3550f37814cd3ab5ea5dde7f63a73_Out_1_Float, float(0), float(1), _Clamp_ac4097026e6248dbb7a95fe910cc776e_Out_3_Float);
        float _Multiply_41691d316de74fef8a4ab5f63ed5474e_Out_2_Float;
        Unity_Multiply_float_float(_Subtract_e1e98a956721410caddfb467ae0eca8b_Out_2_Float, _Clamp_ac4097026e6248dbb7a95fe910cc776e_Out_3_Float, _Multiply_41691d316de74fef8a4ab5f63ed5474e_Out_2_Float);
        float2 _Add_48d37f8b8a464788860db14f0da8a66e_Out_2_Vector2;
        Unity_Add_float2(_Property_e748f6c127e0479a9a01040378a4129b_Out_0_Vector2, (_Multiply_41691d316de74fef8a4ab5f63ed5474e_Out_2_Float.xx), _Add_48d37f8b8a464788860db14f0da8a66e_Out_2_Vector2);
        float _Remap_21f3372608424df090026adc73778a39_Out_3_Float;
        Unity_Remap_float(_Property_9634fd87d3374fdaa60181281a01f9b5_Out_0_Float, float2 (0, 1), _Add_48d37f8b8a464788860db14f0da8a66e_Out_2_Vector2, _Remap_21f3372608424df090026adc73778a39_Out_3_Float);
        float _Clamp_8ea719b357b44537b42b2d05c22046f6_Out_3_Float;
        Unity_Clamp_float(_Remap_21f3372608424df090026adc73778a39_Out_3_Float, float(0), float(1), _Clamp_8ea719b357b44537b42b2d05c22046f6_Out_3_Float);
        float _Property_457e05a76c034ada998b3ff30a7781c3_Out_0_Boolean = _Use_Layer_2_Height_T;
        float _Property_9dfafa1ca8c94866a52535f412aff89a_Out_0_Float = _Angle_Blend;
        float _Property_b0e4a5720c374e2eb6f203a1bd075243_Out_0_Float = _Layer_2_Height;
        float _Multiply_00b31c7f720343caa4ded6df80a61899_Out_2_Float;
        Unity_Multiply_float_float(_Property_9dfafa1ca8c94866a52535f412aff89a_Out_0_Float, _Property_b0e4a5720c374e2eb6f203a1bd075243_Out_0_Float, _Multiply_00b31c7f720343caa4ded6df80a61899_Out_2_Float);
        float2 _Property_555a7734da754b989d8f80ef0bc86bea_Out_0_Vector2 = _Layer_2_Before_Remap;
        float _Split_bad56a0d03154ccc8cbfb53ea0e381d4_R_1_Float = _Property_555a7734da754b989d8f80ef0bc86bea_Out_0_Vector2[0];
        float _Split_bad56a0d03154ccc8cbfb53ea0e381d4_G_2_Float = _Property_555a7734da754b989d8f80ef0bc86bea_Out_0_Vector2[1];
        float _Split_bad56a0d03154ccc8cbfb53ea0e381d4_B_3_Float = 0;
        float _Split_bad56a0d03154ccc8cbfb53ea0e381d4_A_4_Float = 0;
        float _Subtract_2a7908018c384526a00494520503a83d_Out_2_Float;
        Unity_Subtract_float(_Split_bad56a0d03154ccc8cbfb53ea0e381d4_R_1_Float, _Split_bad56a0d03154ccc8cbfb53ea0e381d4_G_2_Float, _Subtract_2a7908018c384526a00494520503a83d_Out_2_Float);
        float _Multiply_417d72157b5f4930aed43775db746964_Out_2_Float;
        Unity_Multiply_float_float(_Subtract_2a7908018c384526a00494520503a83d_Out_2_Float, _Clamp_ac4097026e6248dbb7a95fe910cc776e_Out_3_Float, _Multiply_417d72157b5f4930aed43775db746964_Out_2_Float);
        float2 _Add_3d7e111e917c44e8a6800ce926fac67d_Out_2_Vector2;
        Unity_Add_float2((_Multiply_417d72157b5f4930aed43775db746964_Out_2_Float.xx), _Property_555a7734da754b989d8f80ef0bc86bea_Out_0_Vector2, _Add_3d7e111e917c44e8a6800ce926fac67d_Out_2_Vector2);
        float _Remap_931f83440e6c4c1588456788f84cbd9a_Out_3_Float;
        Unity_Remap_float(_Multiply_00b31c7f720343caa4ded6df80a61899_Out_2_Float, float2 (0, 1), _Add_3d7e111e917c44e8a6800ce926fac67d_Out_2_Vector2, _Remap_931f83440e6c4c1588456788f84cbd9a_Out_3_Float);
        float _Branch_a840aba5bca34588a2665f9794c96c38_Out_3_Float;
        Unity_Branch_float(_Property_457e05a76c034ada998b3ff30a7781c3_Out_0_Boolean, _Remap_931f83440e6c4c1588456788f84cbd9a_Out_3_Float, _Property_9dfafa1ca8c94866a52535f412aff89a_Out_0_Float, _Branch_a840aba5bca34588a2665f9794c96c38_Out_3_Float);
        float _Clamp_b1fe959daf444bf99c57756b8be77768_Out_3_Float;
        Unity_Clamp_float(_Branch_a840aba5bca34588a2665f9794c96c38_Out_3_Float, float(0), float(1), _Clamp_b1fe959daf444bf99c57756b8be77768_Out_3_Float);
        float _Multiply_c045ae9912ac409b9734c687968d47f6_Out_2_Float;
        Unity_Multiply_float_float(_Clamp_8ea719b357b44537b42b2d05c22046f6_Out_3_Float, _Clamp_b1fe959daf444bf99c57756b8be77768_Out_3_Float, _Multiply_c045ae9912ac409b9734c687968d47f6_Out_2_Float);
        float _Branch_5198cfc0a080466e93cf89aea61886e6_Out_3_Float;
        Unity_Branch_float(_Property_cfe724908035497c918d6d3f8dafe439_Out_0_Boolean, _Multiply_c045ae9912ac409b9734c687968d47f6_Out_2_Float, _Clamp_b1fe959daf444bf99c57756b8be77768_Out_3_Float, _Branch_5198cfc0a080466e93cf89aea61886e6_Out_3_Float);
        float _Saturate_ceafe30b0bae4f45a2f2ec500925b553_Out_1_Float;
        Unity_Saturate_float(_Branch_5198cfc0a080466e93cf89aea61886e6_Out_3_Float, _Saturate_ceafe30b0bae4f45a2f2ec500925b553_Out_1_Float);
        float _Absolute_274083e3f9f645bfb86074d91f3b7c62_Out_1_Float;
        Unity_Absolute_float(_Saturate_ceafe30b0bae4f45a2f2ec500925b553_Out_1_Float, _Absolute_274083e3f9f645bfb86074d91f3b7c62_Out_1_Float);
        float _Property_c68e0b8a84a549a582d4723036344b0e_Out_0_Float = _Blend_Hardness;
        float _Power_c9d62a3092174d9cb5674d87bcb7b5c5_Out_2_Float;
        Unity_Power_float(_Absolute_274083e3f9f645bfb86074d91f3b7c62_Out_1_Float, _Property_c68e0b8a84a549a582d4723036344b0e_Out_0_Float, _Power_c9d62a3092174d9cb5674d87bcb7b5c5_Out_2_Float);
        float _Branch_2425ee869bde4930bb8f36a5273bdc33_Out_3_Float;
        Unity_Branch_float(_Comparison_5be6aeaa514b4921b5eb68269b58b028_Out_2_Boolean, float(0), _Power_c9d62a3092174d9cb5674d87bcb7b5c5_Out_2_Float, _Branch_2425ee869bde4930bb8f36a5273bdc33_Out_3_Float);
        float _Clamp_9a5c5cfe52824e248ea0a8e38c593d84_Out_3_Float;
        Unity_Clamp_float(_Branch_2425ee869bde4930bb8f36a5273bdc33_Out_3_Float, float(0), float(1), _Clamp_9a5c5cfe52824e248ea0a8e38c593d84_Out_3_Float);
        Heightmap_1 = _Clamp_9a5c5cfe52824e248ea0a8e38c593d84_Out_3_Float;
        }
        
        void Unity_Lerp_float4(float4 A, float4 B, float4 T, out float4 Out)
        {
            Out = lerp(A, B, T);
        }
        
        void Unity_Clamp_float4(float4 In, float4 Min, float4 Max, out float4 Out)
        {
            Out = clamp(In, Min, Max);
        }
        
        // Custom interpolators pre vertex
        /* WARNING: $splice Could not find named fragment 'CustomInterpolatorPreVertex' */
        
        // Graph Vertex
        struct VertexDescription
        {
            float3 Position;
            float3 Normal;
            float3 Tangent;
        };
        
        VertexDescription VertexDescriptionFunction(VertexDescriptionInputs IN)
        {
            VertexDescription description = (VertexDescription)0;
            description.Position = IN.ObjectSpacePosition;
            description.Normal = IN.ObjectSpaceNormal;
            description.Tangent = IN.ObjectSpaceTangent;
            return description;
        }
        
        // Custom interpolators, pre surface
        #ifdef FEATURES_GRAPH_VERTEX
        Varyings CustomInterpolatorPassThroughFunc(inout Varyings output, VertexDescription input)
        {
        return output;
        }
        #define CUSTOMINTERPOLATOR_VARYPASSTHROUGH_FUNC
        #endif
        
        // Graph Pixel
        struct SurfaceDescription
        {
            float Alpha;
            float AlphaClipThreshold;
        };
        
        SurfaceDescription SurfaceDescriptionFunction(SurfaceDescriptionInputs IN)
        {
            SurfaceDescription surface = (SurfaceDescription)0;
            UnityTexture2D _Property_821e07b38fd0a08d85c4dd6e5b6bbac9_Out_0_Texture2D = UnityBuildTexture2DStructNoScale(_BaseColorMap);
            float4 _Property_8ec0d512145619859d288abab740e3bf_Out_0_Vector4 = _BaseTilingOffset;
            float _Property_122c0f9ef0a1c4818a140c75e512abe4_Out_0_Boolean = _BaseUsePlanarUV;
            Bindings_PlanarNM_c0f081da9c567704ea36e7dd38cedcf6_float _PlanarNM_cb7ded32e6af3382bbe06b62977afab6;
            _PlanarNM_cb7ded32e6af3382bbe06b62977afab6.AbsoluteWorldSpacePosition = IN.AbsoluteWorldSpacePosition;
            _PlanarNM_cb7ded32e6af3382bbe06b62977afab6.uv0 = IN.uv0;
            _PlanarNM_cb7ded32e6af3382bbe06b62977afab6.uv3 = IN.uv3;
            float4 _PlanarNM_cb7ded32e6af3382bbe06b62977afab6_XZ_2_Vector4;
            SG_PlanarNM_c0f081da9c567704ea36e7dd38cedcf6_float(_Property_821e07b38fd0a08d85c4dd6e5b6bbac9_Out_0_Texture2D, _Property_8ec0d512145619859d288abab740e3bf_Out_0_Vector4, _Property_122c0f9ef0a1c4818a140c75e512abe4_Out_0_Boolean, UnityBuildSamplerStateStruct(SamplerState_Linear_Repeat_Aniso8), 1, _PlanarNM_cb7ded32e6af3382bbe06b62977afab6, _PlanarNM_cb7ded32e6af3382bbe06b62977afab6_XZ_2_Vector4);
            float4 _Property_41859d117584758eb8002ecc938f9bce_Out_0_Vector4 = _BaseColor;
            float4 _Multiply_4d0f82599060228a9092027fd43912c8_Out_2_Vector4;
            Unity_Multiply_float4_float4(_PlanarNM_cb7ded32e6af3382bbe06b62977afab6_XZ_2_Vector4, _Property_41859d117584758eb8002ecc938f9bce_Out_0_Vector4, _Multiply_4d0f82599060228a9092027fd43912c8_Out_2_Vector4);
            float3 _ColorspaceConversion_30c5042ef70343cd92056cde73cd3ecb_Out_1_Vector3;
            Unity_ColorspaceConversion_Linear_RGB_float((_Multiply_4d0f82599060228a9092027fd43912c8_Out_2_Vector4.xyz), _ColorspaceConversion_30c5042ef70343cd92056cde73cd3ecb_Out_1_Vector3);
            UnityTexture2D _Property_50403cc6b1e3998a82afc21c6a6332ae_Out_0_Texture2D = UnityBuildTexture2DStructNoScale(_DetailMap);
            float4 _Property_256e5676e1089881ae3214634430b140_Out_0_Vector4 = _DetailTilingOffset;
            float _Split_257d0b6ea953418d97fd7daa8128bf35_R_1_Float = _Property_256e5676e1089881ae3214634430b140_Out_0_Vector4[0];
            float _Split_257d0b6ea953418d97fd7daa8128bf35_G_2_Float = _Property_256e5676e1089881ae3214634430b140_Out_0_Vector4[1];
            float _Split_257d0b6ea953418d97fd7daa8128bf35_B_3_Float = _Property_256e5676e1089881ae3214634430b140_Out_0_Vector4[2];
            float _Split_257d0b6ea953418d97fd7daa8128bf35_A_4_Float = _Property_256e5676e1089881ae3214634430b140_Out_0_Vector4[3];
            float2 _Vector2_98295494172421878c7a16cb2baddf9a_Out_0_Vector2 = float2(_Split_257d0b6ea953418d97fd7daa8128bf35_R_1_Float, _Split_257d0b6ea953418d97fd7daa8128bf35_G_2_Float);
            float2 _Vector2_130e8faa59837a81a7506636fcb30b8a_Out_0_Vector2 = float2(_Split_257d0b6ea953418d97fd7daa8128bf35_B_3_Float, _Split_257d0b6ea953418d97fd7daa8128bf35_A_4_Float);
            float2 _TilingAndOffset_1dfb2b4859ec3680ad3a74cf8f1bc17b_Out_3_Vector2;
            Unity_TilingAndOffset_float(IN.uv0.xy, _Vector2_98295494172421878c7a16cb2baddf9a_Out_0_Vector2, _Vector2_130e8faa59837a81a7506636fcb30b8a_Out_0_Vector2, _TilingAndOffset_1dfb2b4859ec3680ad3a74cf8f1bc17b_Out_3_Vector2);
            float4 _SampleTexture2D_d8eb0186b9a0cd819cde65431b4ea5ea_RGBA_0_Vector4 = SAMPLE_TEXTURE2D(_Property_50403cc6b1e3998a82afc21c6a6332ae_Out_0_Texture2D.tex, UnityBuildSamplerStateStruct(SamplerState_Linear_Repeat_Aniso8).samplerstate, _Property_50403cc6b1e3998a82afc21c6a6332ae_Out_0_Texture2D.GetTransformedUV(_TilingAndOffset_1dfb2b4859ec3680ad3a74cf8f1bc17b_Out_3_Vector2) );
            float _SampleTexture2D_d8eb0186b9a0cd819cde65431b4ea5ea_R_4_Float = _SampleTexture2D_d8eb0186b9a0cd819cde65431b4ea5ea_RGBA_0_Vector4.r;
            float _SampleTexture2D_d8eb0186b9a0cd819cde65431b4ea5ea_G_5_Float = _SampleTexture2D_d8eb0186b9a0cd819cde65431b4ea5ea_RGBA_0_Vector4.g;
            float _SampleTexture2D_d8eb0186b9a0cd819cde65431b4ea5ea_B_6_Float = _SampleTexture2D_d8eb0186b9a0cd819cde65431b4ea5ea_RGBA_0_Vector4.b;
            float _SampleTexture2D_d8eb0186b9a0cd819cde65431b4ea5ea_A_7_Float = _SampleTexture2D_d8eb0186b9a0cd819cde65431b4ea5ea_RGBA_0_Vector4.a;
            float _Property_605f29777330a58ba88ac032e905433b_Out_0_Float = _DetailAlbedoScale;
            float3 _Blend_de85bf99257f4eb7bb321fd973539f10_Out_2_Vector3;
            Unity_Blend_Overlay_float3(_ColorspaceConversion_30c5042ef70343cd92056cde73cd3ecb_Out_1_Vector3, (_SampleTexture2D_d8eb0186b9a0cd819cde65431b4ea5ea_R_4_Float.xxx), _Blend_de85bf99257f4eb7bb321fd973539f10_Out_2_Vector3, _Property_605f29777330a58ba88ac032e905433b_Out_0_Float);
            float3 _ColorspaceConversion_635670d250654503b34efa53a99ba43e_Out_1_Vector3;
            Unity_ColorspaceConversion_RGB_Linear_float(_Blend_de85bf99257f4eb7bb321fd973539f10_Out_2_Vector3, _ColorspaceConversion_635670d250654503b34efa53a99ba43e_Out_1_Vector3);
            float3 _Clamp_8913f48f801c43c2879f2e1ce926507e_Out_3_Vector3;
            Unity_Clamp_float3(_ColorspaceConversion_635670d250654503b34efa53a99ba43e_Out_1_Vector3, float3(0, 0, 0), float3(1, 1, 1), _Clamp_8913f48f801c43c2879f2e1ce926507e_Out_3_Vector3);
            float _Split_ddfe447fbb7845e88cc5cfb8158b2248_R_1_Float = _Clamp_8913f48f801c43c2879f2e1ce926507e_Out_3_Vector3[0];
            float _Split_ddfe447fbb7845e88cc5cfb8158b2248_G_2_Float = _Clamp_8913f48f801c43c2879f2e1ce926507e_Out_3_Vector3[1];
            float _Split_ddfe447fbb7845e88cc5cfb8158b2248_B_3_Float = _Clamp_8913f48f801c43c2879f2e1ce926507e_Out_3_Vector3[2];
            float _Split_ddfe447fbb7845e88cc5cfb8158b2248_A_4_Float = 0;
            float _Split_6d7debfd2b20440e932d58108f8e7f75_R_1_Float = _Multiply_4d0f82599060228a9092027fd43912c8_Out_2_Vector4[0];
            float _Split_6d7debfd2b20440e932d58108f8e7f75_G_2_Float = _Multiply_4d0f82599060228a9092027fd43912c8_Out_2_Vector4[1];
            float _Split_6d7debfd2b20440e932d58108f8e7f75_B_3_Float = _Multiply_4d0f82599060228a9092027fd43912c8_Out_2_Vector4[2];
            float _Split_6d7debfd2b20440e932d58108f8e7f75_A_4_Float = _Multiply_4d0f82599060228a9092027fd43912c8_Out_2_Vector4[3];
            float4 _Combine_b0f28916143e4b94af6bec53f5328b52_RGBA_4_Vector4;
            float3 _Combine_b0f28916143e4b94af6bec53f5328b52_RGB_5_Vector3;
            float2 _Combine_b0f28916143e4b94af6bec53f5328b52_RG_6_Vector2;
            Unity_Combine_float(_Split_ddfe447fbb7845e88cc5cfb8158b2248_R_1_Float, _Split_ddfe447fbb7845e88cc5cfb8158b2248_G_2_Float, _Split_ddfe447fbb7845e88cc5cfb8158b2248_B_3_Float, _Split_6d7debfd2b20440e932d58108f8e7f75_A_4_Float, _Combine_b0f28916143e4b94af6bec53f5328b52_RGBA_4_Vector4, _Combine_b0f28916143e4b94af6bec53f5328b52_RGB_5_Vector3, _Combine_b0f28916143e4b94af6bec53f5328b52_RG_6_Vector2);
            UnityTexture2D _Property_a155ddc33ed90685a5ab0edcf158a343_Out_0_Texture2D = UnityBuildTexture2DStructNoScale(_CoverBaseColorMap);
            float4 _Property_256beda96caf2d8aa05d3de41fc08d3d_Out_0_Vector4 = _CoverTilingOffset;
            float _Property_bd9dfe8dd615798f9f2d72d139e56d61_Out_0_Boolean = _CoverUsePlanarUV;
            Bindings_PlanarNM_c0f081da9c567704ea36e7dd38cedcf6_float _PlanarNM_e00e057d3d7c4181b1c7775c6ebbab5b;
            _PlanarNM_e00e057d3d7c4181b1c7775c6ebbab5b.AbsoluteWorldSpacePosition = IN.AbsoluteWorldSpacePosition;
            _PlanarNM_e00e057d3d7c4181b1c7775c6ebbab5b.uv0 = IN.uv0;
            _PlanarNM_e00e057d3d7c4181b1c7775c6ebbab5b.uv3 = IN.uv3;
            float4 _PlanarNM_e00e057d3d7c4181b1c7775c6ebbab5b_XZ_2_Vector4;
            SG_PlanarNM_c0f081da9c567704ea36e7dd38cedcf6_float(_Property_a155ddc33ed90685a5ab0edcf158a343_Out_0_Texture2D, _Property_256beda96caf2d8aa05d3de41fc08d3d_Out_0_Vector4, _Property_bd9dfe8dd615798f9f2d72d139e56d61_Out_0_Boolean, UnityBuildSamplerStateStruct(SamplerState_Linear_Repeat_Aniso8), 1, _PlanarNM_e00e057d3d7c4181b1c7775c6ebbab5b, _PlanarNM_e00e057d3d7c4181b1c7775c6ebbab5b_XZ_2_Vector4);
            float4 _Property_c3be5593fd661b8dafbd04f26b8ec9ac_Out_0_Vector4 = _CoverBaseColor;
            float4 _Multiply_b08794693505bd8e8c04b9ba1610d394_Out_2_Vector4;
            Unity_Multiply_float4_float4(_PlanarNM_e00e057d3d7c4181b1c7775c6ebbab5b_XZ_2_Vector4, _Property_c3be5593fd661b8dafbd04f26b8ec9ac_Out_0_Vector4, _Multiply_b08794693505bd8e8c04b9ba1610d394_Out_2_Vector4);
            float _Split_a80936a3c75945efb8cf9f2b95c76642_R_1_Float = IN.VertexColor[0];
            float _Split_a80936a3c75945efb8cf9f2b95c76642_G_2_Float = IN.VertexColor[1];
            float _Split_a80936a3c75945efb8cf9f2b95c76642_B_3_Float = IN.VertexColor[2];
            float _Split_a80936a3c75945efb8cf9f2b95c76642_A_4_Float = IN.VertexColor[3];
            float _Property_14a6757619d64822a44a69b34f85276d_Out_0_Float = _VertexColorGBlendStrenght;
            float _Property_c0d9ffba7dee497c885a54170977d874_Out_0_Boolean = _USEBaseHeightT;
            UnityTexture2D _Property_bb9b47702e64ec8c8d8ad011fd521576_Out_0_Texture2D = UnityBuildTexture2DStructNoScale(_BaseMaskMap);
            Bindings_PlanarNM_c0f081da9c567704ea36e7dd38cedcf6_float _PlanarNM_e51306c84cde8e84a1fb06a45d8d037f;
            _PlanarNM_e51306c84cde8e84a1fb06a45d8d037f.AbsoluteWorldSpacePosition = IN.AbsoluteWorldSpacePosition;
            _PlanarNM_e51306c84cde8e84a1fb06a45d8d037f.uv0 = IN.uv0;
            _PlanarNM_e51306c84cde8e84a1fb06a45d8d037f.uv3 = IN.uv3;
            float4 _PlanarNM_e51306c84cde8e84a1fb06a45d8d037f_XZ_2_Vector4;
            SG_PlanarNM_c0f081da9c567704ea36e7dd38cedcf6_float(_Property_bb9b47702e64ec8c8d8ad011fd521576_Out_0_Texture2D, _Property_8ec0d512145619859d288abab740e3bf_Out_0_Vector4, _Property_122c0f9ef0a1c4818a140c75e512abe4_Out_0_Boolean, UnityBuildSamplerStateStruct(SamplerState_Linear_Repeat_Aniso8), 1, _PlanarNM_e51306c84cde8e84a1fb06a45d8d037f, _PlanarNM_e51306c84cde8e84a1fb06a45d8d037f_XZ_2_Vector4);
            float _Split_218e1cfd00b30984921b5fc0ec63de60_R_1_Float = _PlanarNM_e51306c84cde8e84a1fb06a45d8d037f_XZ_2_Vector4[0];
            float _Split_218e1cfd00b30984921b5fc0ec63de60_G_2_Float = _PlanarNM_e51306c84cde8e84a1fb06a45d8d037f_XZ_2_Vector4[1];
            float _Split_218e1cfd00b30984921b5fc0ec63de60_B_3_Float = _PlanarNM_e51306c84cde8e84a1fb06a45d8d037f_XZ_2_Vector4[2];
            float _Split_218e1cfd00b30984921b5fc0ec63de60_A_4_Float = _PlanarNM_e51306c84cde8e84a1fb06a45d8d037f_XZ_2_Vector4[3];
            float _Property_1d4a1a93707b42c3abf0baa799c514e5_Out_0_Float = _HeightMin;
            float _Property_8f4f3606868d4028a34c2a9a5a59f99d_Out_0_Float = _HeightMax;
            float2 _Vector2_721b6f4d7077463490b4504fe6c940bf_Out_0_Vector2 = float2(_Property_1d4a1a93707b42c3abf0baa799c514e5_Out_0_Float, _Property_8f4f3606868d4028a34c2a9a5a59f99d_Out_0_Float);
            float _Property_a1ae2f61da87421b9f3839691e9dd8af_Out_0_Float = _HeightOffset;
            float2 _Add_1f9ea9bdf36544b59f763806e7eea80d_Out_2_Vector2;
            Unity_Add_float2(_Vector2_721b6f4d7077463490b4504fe6c940bf_Out_0_Vector2, (_Property_a1ae2f61da87421b9f3839691e9dd8af_Out_0_Float.xx), _Add_1f9ea9bdf36544b59f763806e7eea80d_Out_2_Vector2);
            float _Property_0fbef18600294e199eeda9905e3304e4_Out_0_Boolean = _USECoverHeightT;
            UnityTexture2D _Property_3702de305e11e085a40d7731b582d541_Out_0_Texture2D = UnityBuildTexture2DStructNoScale(_CoverMaskMap);
            Bindings_PlanarNM_c0f081da9c567704ea36e7dd38cedcf6_float _PlanarNM_2217ca3c12141a8cb1e0c7235b369601;
            _PlanarNM_2217ca3c12141a8cb1e0c7235b369601.AbsoluteWorldSpacePosition = IN.AbsoluteWorldSpacePosition;
            _PlanarNM_2217ca3c12141a8cb1e0c7235b369601.uv0 = IN.uv0;
            _PlanarNM_2217ca3c12141a8cb1e0c7235b369601.uv3 = IN.uv3;
            float4 _PlanarNM_2217ca3c12141a8cb1e0c7235b369601_XZ_2_Vector4;
            SG_PlanarNM_c0f081da9c567704ea36e7dd38cedcf6_float(_Property_3702de305e11e085a40d7731b582d541_Out_0_Texture2D, _Property_256beda96caf2d8aa05d3de41fc08d3d_Out_0_Vector4, _Property_bd9dfe8dd615798f9f2d72d139e56d61_Out_0_Boolean, UnityBuildSamplerStateStruct(SamplerState_Linear_Repeat_Aniso8), 1, _PlanarNM_2217ca3c12141a8cb1e0c7235b369601, _PlanarNM_2217ca3c12141a8cb1e0c7235b369601_XZ_2_Vector4);
            float _Split_2f45bca363698c859e51492899bc58f8_R_1_Float = _PlanarNM_2217ca3c12141a8cb1e0c7235b369601_XZ_2_Vector4[0];
            float _Split_2f45bca363698c859e51492899bc58f8_G_2_Float = _PlanarNM_2217ca3c12141a8cb1e0c7235b369601_XZ_2_Vector4[1];
            float _Split_2f45bca363698c859e51492899bc58f8_B_3_Float = _PlanarNM_2217ca3c12141a8cb1e0c7235b369601_XZ_2_Vector4[2];
            float _Split_2f45bca363698c859e51492899bc58f8_A_4_Float = _PlanarNM_2217ca3c12141a8cb1e0c7235b369601_XZ_2_Vector4[3];
            float _Property_32b48052fdbb4641bf4eeb294bc65050_Out_0_Float = _CoverHeightMapMin;
            float _Property_0e120eb0a0a14b12a31a3c1f5b961121_Out_0_Float = _CoverHeightMapMax;
            float2 _Vector2_6955747f7f0a4ff98fae60dbada25e89_Out_0_Vector2 = float2(_Property_32b48052fdbb4641bf4eeb294bc65050_Out_0_Float, _Property_0e120eb0a0a14b12a31a3c1f5b961121_Out_0_Float);
            float _Property_6b467710b0ba48058e003aebe9119249_Out_0_Float = _CoverHeightMapOffset;
            float2 _Add_28628d641d58481084e9c00e4ad5fc8d_Out_2_Vector2;
            Unity_Add_float2(_Vector2_6955747f7f0a4ff98fae60dbada25e89_Out_0_Vector2, (_Property_6b467710b0ba48058e003aebe9119249_Out_0_Float.xx), _Add_28628d641d58481084e9c00e4ad5fc8d_Out_2_Vector2);
            UnityTexture2D _Property_7bea2d9dd5651a8bbbd61ecde71faa54_Out_0_Texture2D = UnityBuildTexture2DStructNoScale(_Masks);
            float4 _UV_429c95affe88aa8694076115c99a0769_Out_0_Vector4 = IN.uv0;
            float4 _SampleTexture2D_2723da80b8a2528381ef199c0415beae_RGBA_0_Vector4 = SAMPLE_TEXTURE2D(_Property_7bea2d9dd5651a8bbbd61ecde71faa54_Out_0_Texture2D.tex, UnityBuildSamplerStateStruct(SamplerState_Linear_Repeat_Aniso8).samplerstate, _Property_7bea2d9dd5651a8bbbd61ecde71faa54_Out_0_Texture2D.GetTransformedUV((_UV_429c95affe88aa8694076115c99a0769_Out_0_Vector4.xy)) );
            float _SampleTexture2D_2723da80b8a2528381ef199c0415beae_R_4_Float = _SampleTexture2D_2723da80b8a2528381ef199c0415beae_RGBA_0_Vector4.r;
            float _SampleTexture2D_2723da80b8a2528381ef199c0415beae_G_5_Float = _SampleTexture2D_2723da80b8a2528381ef199c0415beae_RGBA_0_Vector4.g;
            float _SampleTexture2D_2723da80b8a2528381ef199c0415beae_B_6_Float = _SampleTexture2D_2723da80b8a2528381ef199c0415beae_RGBA_0_Vector4.b;
            float _SampleTexture2D_2723da80b8a2528381ef199c0415beae_A_7_Float = _SampleTexture2D_2723da80b8a2528381ef199c0415beae_RGBA_0_Vector4.a;
            float _Property_7bea2851849541b28a2bc695d39a7606_Out_0_Float = _Cover_Mask_A_Remap_Min;
            float _Property_3be0ae138e414a5cb43d60264b1bcfeb_Out_0_Float = _Cover_Mask_A_Remap_Max;
            float2 _Vector2_44ac029de1e440a799fbdfadc778af0c_Out_0_Vector2 = float2(_Property_7bea2851849541b28a2bc695d39a7606_Out_0_Float, _Property_3be0ae138e414a5cb43d60264b1bcfeb_Out_0_Float);
            float _Remap_0c551a3055a54f16b85b519194883552_Out_3_Float;
            Unity_Remap_float(_SampleTexture2D_2723da80b8a2528381ef199c0415beae_A_7_Float, float2 (0, 1), _Vector2_44ac029de1e440a799fbdfadc778af0c_Out_0_Vector2, _Remap_0c551a3055a54f16b85b519194883552_Out_3_Float);
            float _Clamp_bb1427696ce14fe987f799fecc5f9fac_Out_3_Float;
            Unity_Clamp_float(_Remap_0c551a3055a54f16b85b519194883552_Out_3_Float, float(0), float(1), _Clamp_bb1427696ce14fe987f799fecc5f9fac_Out_3_Float);
            float2 _Vector2_0d28074858599a88940dfc8b57b9a60f_Out_0_Vector2 = float2(_SampleTexture2D_d8eb0186b9a0cd819cde65431b4ea5ea_A_7_Float, _SampleTexture2D_d8eb0186b9a0cd819cde65431b4ea5ea_G_5_Float);
            float2 _Multiply_fac8d94f82a53486bc0142a1e64b3d32_Out_2_Vector2;
            Unity_Multiply_float2_float2(_Vector2_0d28074858599a88940dfc8b57b9a60f_Out_0_Vector2, float2(2, 2), _Multiply_fac8d94f82a53486bc0142a1e64b3d32_Out_2_Vector2);
            float2 _Add_f0e6e847d8d8798ab3ca8c4d878bafc0_Out_2_Vector2;
            Unity_Add_float2(_Multiply_fac8d94f82a53486bc0142a1e64b3d32_Out_2_Vector2, float2(-1, -1), _Add_f0e6e847d8d8798ab3ca8c4d878bafc0_Out_2_Vector2);
            float _Property_d0e8d8f7fd10f0829e8fd86c278c8226_Out_0_Float = _DetailNormalScale;
            float2 _Multiply_11f3dfc5283ea188ad9c83e552cf7e0f_Out_2_Vector2;
            Unity_Multiply_float2_float2(_Add_f0e6e847d8d8798ab3ca8c4d878bafc0_Out_2_Vector2, (_Property_d0e8d8f7fd10f0829e8fd86c278c8226_Out_0_Float.xx), _Multiply_11f3dfc5283ea188ad9c83e552cf7e0f_Out_2_Vector2);
            float _Split_c4822b8eaff9b185be7c059792345712_R_1_Float = _Multiply_11f3dfc5283ea188ad9c83e552cf7e0f_Out_2_Vector2[0];
            float _Split_c4822b8eaff9b185be7c059792345712_G_2_Float = _Multiply_11f3dfc5283ea188ad9c83e552cf7e0f_Out_2_Vector2[1];
            float _Split_c4822b8eaff9b185be7c059792345712_B_3_Float = 0;
            float _Split_c4822b8eaff9b185be7c059792345712_A_4_Float = 0;
            float _DotProduct_1a01939a143c548c8ccd7e8a04fe680d_Out_2_Float;
            Unity_DotProduct_float2(_Multiply_11f3dfc5283ea188ad9c83e552cf7e0f_Out_2_Vector2, _Multiply_11f3dfc5283ea188ad9c83e552cf7e0f_Out_2_Vector2, _DotProduct_1a01939a143c548c8ccd7e8a04fe680d_Out_2_Float);
            float _Saturate_bf3d57899db77f86a1689105ce6a373a_Out_1_Float;
            Unity_Saturate_float(_DotProduct_1a01939a143c548c8ccd7e8a04fe680d_Out_2_Float, _Saturate_bf3d57899db77f86a1689105ce6a373a_Out_1_Float);
            float _OneMinus_052960238cc4a18cb83109d2bcae6d09_Out_1_Float;
            Unity_OneMinus_float(_Saturate_bf3d57899db77f86a1689105ce6a373a_Out_1_Float, _OneMinus_052960238cc4a18cb83109d2bcae6d09_Out_1_Float);
            float _SquareRoot_d4f67288e4dbf5898bea492a70b89ab9_Out_1_Float;
            Unity_SquareRoot_float(_OneMinus_052960238cc4a18cb83109d2bcae6d09_Out_1_Float, _SquareRoot_d4f67288e4dbf5898bea492a70b89ab9_Out_1_Float);
            float3 _Vector3_1e56146bdd567884bb8d5ae769df4d29_Out_0_Vector3 = float3(_Split_c4822b8eaff9b185be7c059792345712_R_1_Float, _Split_c4822b8eaff9b185be7c059792345712_G_2_Float, _SquareRoot_d4f67288e4dbf5898bea492a70b89ab9_Out_1_Float);
            UnityTexture2D _Property_147b07430832c98eb0a470557ee61c5e_Out_0_Texture2D = UnityBuildTexture2DStructNoScale(_BaseNormalMap);
            Bindings_PlanarNMn_1b93a87456f9d4c419321d0cd92bd6c8_float _PlanarNMn_ecad9f1f260c6c8bbd0960b2a8976daf;
            _PlanarNMn_ecad9f1f260c6c8bbd0960b2a8976daf.WorldSpaceNormal = IN.WorldSpaceNormal;
            _PlanarNMn_ecad9f1f260c6c8bbd0960b2a8976daf.WorldSpaceTangent = IN.WorldSpaceTangent;
            _PlanarNMn_ecad9f1f260c6c8bbd0960b2a8976daf.WorldSpaceBiTangent = IN.WorldSpaceBiTangent;
            _PlanarNMn_ecad9f1f260c6c8bbd0960b2a8976daf.AbsoluteWorldSpacePosition = IN.AbsoluteWorldSpacePosition;
            _PlanarNMn_ecad9f1f260c6c8bbd0960b2a8976daf.uv0 = IN.uv0;
            _PlanarNMn_ecad9f1f260c6c8bbd0960b2a8976daf.uv3 = IN.uv3;
            float4 _PlanarNMn_ecad9f1f260c6c8bbd0960b2a8976daf_XZ_2_Vector4;
            SG_PlanarNMn_1b93a87456f9d4c419321d0cd92bd6c8_float(_Property_147b07430832c98eb0a470557ee61c5e_Out_0_Texture2D, _Property_8ec0d512145619859d288abab740e3bf_Out_0_Vector4, _Property_122c0f9ef0a1c4818a140c75e512abe4_Out_0_Boolean, UnityBuildSamplerStateStruct(SamplerState_Linear_Repeat_Aniso8), 1, _PlanarNMn_ecad9f1f260c6c8bbd0960b2a8976daf, _PlanarNMn_ecad9f1f260c6c8bbd0960b2a8976daf_XZ_2_Vector4);
            float _Property_72e436a108ad64868e46d548c585c5f3_Out_0_Float = _BaseNormalScale;
            float3 _NormalStrength_366affc5c8b42482a633d201ef52b9d6_Out_2_Vector3;
            Unity_NormalStrength_float((_PlanarNMn_ecad9f1f260c6c8bbd0960b2a8976daf_XZ_2_Vector4.xyz), _Property_72e436a108ad64868e46d548c585c5f3_Out_0_Float, _NormalStrength_366affc5c8b42482a633d201ef52b9d6_Out_2_Vector3);
            float3 _NormalBlend_9f531c87e2e45580b1d0f65f06c23526_Out_2_Vector3;
            Unity_NormalBlend_Reoriented_float(_Vector3_1e56146bdd567884bb8d5ae769df4d29_Out_0_Vector3, _NormalStrength_366affc5c8b42482a633d201ef52b9d6_Out_2_Vector3, _NormalBlend_9f531c87e2e45580b1d0f65f06c23526_Out_2_Vector3);
            UnityTexture2D _Property_d7e9139e0ac6718b89c610009c28a25a_Out_0_Texture2D = UnityBuildTexture2DStructNoScale(_CoverNormalMap);
            Bindings_PlanarNMn_1b93a87456f9d4c419321d0cd92bd6c8_float _PlanarNMn_690e893d26999680a5cea3604ed0ce16;
            _PlanarNMn_690e893d26999680a5cea3604ed0ce16.WorldSpaceNormal = IN.WorldSpaceNormal;
            _PlanarNMn_690e893d26999680a5cea3604ed0ce16.WorldSpaceTangent = IN.WorldSpaceTangent;
            _PlanarNMn_690e893d26999680a5cea3604ed0ce16.WorldSpaceBiTangent = IN.WorldSpaceBiTangent;
            _PlanarNMn_690e893d26999680a5cea3604ed0ce16.AbsoluteWorldSpacePosition = IN.AbsoluteWorldSpacePosition;
            _PlanarNMn_690e893d26999680a5cea3604ed0ce16.uv0 = IN.uv0;
            _PlanarNMn_690e893d26999680a5cea3604ed0ce16.uv3 = IN.uv3;
            float4 _PlanarNMn_690e893d26999680a5cea3604ed0ce16_XZ_2_Vector4;
            SG_PlanarNMn_1b93a87456f9d4c419321d0cd92bd6c8_float(_Property_d7e9139e0ac6718b89c610009c28a25a_Out_0_Texture2D, _Property_256beda96caf2d8aa05d3de41fc08d3d_Out_0_Vector4, _Property_bd9dfe8dd615798f9f2d72d139e56d61_Out_0_Boolean, UnityBuildSamplerStateStruct(SamplerState_Linear_Repeat_Aniso8), 1, _PlanarNMn_690e893d26999680a5cea3604ed0ce16, _PlanarNMn_690e893d26999680a5cea3604ed0ce16_XZ_2_Vector4);
            float _Property_0fd4d87ded104c829a6110c044eaa5f2_Out_0_Float = _CoverNormalBlendHardness;
            float3 _NormalStrength_c4639a6dd3dfde85b591971db2700eaf_Out_2_Vector3;
            Unity_NormalStrength_float((_PlanarNMn_690e893d26999680a5cea3604ed0ce16_XZ_2_Vector4.xyz), _Property_0fd4d87ded104c829a6110c044eaa5f2_Out_0_Float, _NormalStrength_c4639a6dd3dfde85b591971db2700eaf_Out_2_Vector3);
            float _Split_8ff22a6bdd437780ac7ea5963e1c5bb4_R_1_Float = IN.WorldSpaceNormal[0];
            float _Split_8ff22a6bdd437780ac7ea5963e1c5bb4_G_2_Float = IN.WorldSpaceNormal[1];
            float _Split_8ff22a6bdd437780ac7ea5963e1c5bb4_B_3_Float = IN.WorldSpaceNormal[2];
            float _Split_8ff22a6bdd437780ac7ea5963e1c5bb4_A_4_Float = 0;
            float _Property_28052b023ac35c8e9a95b30327681cc5_Out_0_Float = _Cover_Amount;
            float _Property_7749c0d5b28c14869ab3ba35d226788b_Out_0_Float = _Cover_Amount_Grow_Speed;
            float _Subtract_e5dc2afce7ff588fa1d4c91f78de7575_Out_2_Float;
            Unity_Subtract_float(float(4), _Property_7749c0d5b28c14869ab3ba35d226788b_Out_0_Float, _Subtract_e5dc2afce7ff588fa1d4c91f78de7575_Out_2_Float);
            float _Divide_c77b003bf1ce13828c94a705676e2b30_Out_2_Float;
            Unity_Divide_float(_Property_28052b023ac35c8e9a95b30327681cc5_Out_0_Float, _Subtract_e5dc2afce7ff588fa1d4c91f78de7575_Out_2_Float, _Divide_c77b003bf1ce13828c94a705676e2b30_Out_2_Float);
            float _Absolute_c7499cf07bdd0582abd82adbf367b0fc_Out_1_Float;
            Unity_Absolute_float(_Divide_c77b003bf1ce13828c94a705676e2b30_Out_2_Float, _Absolute_c7499cf07bdd0582abd82adbf367b0fc_Out_1_Float);
            float _Power_a9431dbce44a528f9ee7095adfa10556_Out_2_Float;
            Unity_Power_float(_Absolute_c7499cf07bdd0582abd82adbf367b0fc_Out_1_Float, _Subtract_e5dc2afce7ff588fa1d4c91f78de7575_Out_2_Float, _Power_a9431dbce44a528f9ee7095adfa10556_Out_2_Float);
            float _Clamp_815ffdd53cc1c889aa00f73784cb71e7_Out_3_Float;
            Unity_Clamp_float(_Power_a9431dbce44a528f9ee7095adfa10556_Out_2_Float, float(0), float(2), _Clamp_815ffdd53cc1c889aa00f73784cb71e7_Out_3_Float);
            float _Multiply_143da4886728ff868f10e9cfa6940ea0_Out_2_Float;
            Unity_Multiply_float_float(_Split_8ff22a6bdd437780ac7ea5963e1c5bb4_G_2_Float, _Clamp_815ffdd53cc1c889aa00f73784cb71e7_Out_3_Float, _Multiply_143da4886728ff868f10e9cfa6940ea0_Out_2_Float);
            float _Saturate_04686ab19029f68c8fb9e7a115b207b1_Out_1_Float;
            Unity_Saturate_float(_Multiply_143da4886728ff868f10e9cfa6940ea0_Out_2_Float, _Saturate_04686ab19029f68c8fb9e7a115b207b1_Out_1_Float);
            float _Clamp_9c0a88ffc7be288cbe97d3e13a014fe8_Out_3_Float;
            Unity_Clamp_float(_Split_8ff22a6bdd437780ac7ea5963e1c5bb4_G_2_Float, float(0), float(0.9999), _Clamp_9c0a88ffc7be288cbe97d3e13a014fe8_Out_3_Float);
            float _Property_58f42b34c7f0728f8c98e00a3e3a5726_Out_0_Float = _Cover_Max_Angle;
            float _Divide_b785767ecc1928889893fa60eac4e5fb_Out_2_Float;
            Unity_Divide_float(_Property_58f42b34c7f0728f8c98e00a3e3a5726_Out_0_Float, float(45), _Divide_b785767ecc1928889893fa60eac4e5fb_Out_2_Float);
            float _OneMinus_8e6f5b1570dc8c8b8afb036328281675_Out_1_Float;
            Unity_OneMinus_float(_Divide_b785767ecc1928889893fa60eac4e5fb_Out_2_Float, _OneMinus_8e6f5b1570dc8c8b8afb036328281675_Out_1_Float);
            float _Subtract_5348fb3702fea78d9ee10dbf81ede29c_Out_2_Float;
            Unity_Subtract_float(_Clamp_9c0a88ffc7be288cbe97d3e13a014fe8_Out_3_Float, _OneMinus_8e6f5b1570dc8c8b8afb036328281675_Out_1_Float, _Subtract_5348fb3702fea78d9ee10dbf81ede29c_Out_2_Float);
            float _Clamp_2b888688983edd82ac250226d9378893_Out_3_Float;
            Unity_Clamp_float(_Subtract_5348fb3702fea78d9ee10dbf81ede29c_Out_2_Float, float(0), float(2), _Clamp_2b888688983edd82ac250226d9378893_Out_3_Float);
            float _Divide_5615f16c20214d888a2e727ff7c5f5ff_Out_2_Float;
            Unity_Divide_float(float(1), _Divide_b785767ecc1928889893fa60eac4e5fb_Out_2_Float, _Divide_5615f16c20214d888a2e727ff7c5f5ff_Out_2_Float);
            float _Multiply_89aeffc0ad067981a18e6a77948b2b49_Out_2_Float;
            Unity_Multiply_float_float(_Clamp_2b888688983edd82ac250226d9378893_Out_3_Float, _Divide_5615f16c20214d888a2e727ff7c5f5ff_Out_2_Float, _Multiply_89aeffc0ad067981a18e6a77948b2b49_Out_2_Float);
            float _Absolute_b91ed8e326de8f88bf52e49cc5f641d4_Out_1_Float;
            Unity_Absolute_float(_Multiply_89aeffc0ad067981a18e6a77948b2b49_Out_2_Float, _Absolute_b91ed8e326de8f88bf52e49cc5f641d4_Out_1_Float);
            float _Property_4879e96694aee98c9d4ecd329a571123_Out_0_Float = _CoverHardness;
            float _Power_ca1f1906c90fb785bfe520b7faefc3cd_Out_2_Float;
            Unity_Power_float(_Absolute_b91ed8e326de8f88bf52e49cc5f641d4_Out_1_Float, _Property_4879e96694aee98c9d4ecd329a571123_Out_0_Float, _Power_ca1f1906c90fb785bfe520b7faefc3cd_Out_2_Float);
            float _Property_b66201e787ab7b83a55abc6ddd3fe1fd_Out_0_Float = _Cover_Min_Height;
            float _OneMinus_87c740d245de388db4fe5f4958de0668_Out_1_Float;
            Unity_OneMinus_float(_Property_b66201e787ab7b83a55abc6ddd3fe1fd_Out_0_Float, _OneMinus_87c740d245de388db4fe5f4958de0668_Out_1_Float);
            float _Split_ae16de7cacf9d0878aba1467f193d681_R_1_Float = IN.AbsoluteWorldSpacePosition[0];
            float _Split_ae16de7cacf9d0878aba1467f193d681_G_2_Float = IN.AbsoluteWorldSpacePosition[1];
            float _Split_ae16de7cacf9d0878aba1467f193d681_B_3_Float = IN.AbsoluteWorldSpacePosition[2];
            float _Split_ae16de7cacf9d0878aba1467f193d681_A_4_Float = 0;
            float _Add_9d6e1dd03919c88bb01e77a9a2b6b59c_Out_2_Float;
            Unity_Add_float(_OneMinus_87c740d245de388db4fe5f4958de0668_Out_1_Float, _Split_ae16de7cacf9d0878aba1467f193d681_G_2_Float, _Add_9d6e1dd03919c88bb01e77a9a2b6b59c_Out_2_Float);
            float _Add_448f30a2cd792b868416a253a1c502bb_Out_2_Float;
            Unity_Add_float(_Add_9d6e1dd03919c88bb01e77a9a2b6b59c_Out_2_Float, float(1), _Add_448f30a2cd792b868416a253a1c502bb_Out_2_Float);
            float _Clamp_53d91568d0627d8a9cac8deecdd003a8_Out_3_Float;
            Unity_Clamp_float(_Add_448f30a2cd792b868416a253a1c502bb_Out_2_Float, float(0), float(1), _Clamp_53d91568d0627d8a9cac8deecdd003a8_Out_3_Float);
            float _Property_98b8c0fc7e8f9b88b8d7d9dd28ed8aca_Out_0_Float = _Cover_Min_Height_Blending;
            float _Add_0edbe9f424de6d8089b453804bc6ec74_Out_2_Float;
            Unity_Add_float(_Add_9d6e1dd03919c88bb01e77a9a2b6b59c_Out_2_Float, _Property_98b8c0fc7e8f9b88b8d7d9dd28ed8aca_Out_0_Float, _Add_0edbe9f424de6d8089b453804bc6ec74_Out_2_Float);
            float _Divide_bacd243000beaa86b28174bd47716791_Out_2_Float;
            Unity_Divide_float(_Add_0edbe9f424de6d8089b453804bc6ec74_Out_2_Float, _Add_9d6e1dd03919c88bb01e77a9a2b6b59c_Out_2_Float, _Divide_bacd243000beaa86b28174bd47716791_Out_2_Float);
            float _OneMinus_dd51a0c56dbb9b8b8882c6d36bfadd50_Out_1_Float;
            Unity_OneMinus_float(_Divide_bacd243000beaa86b28174bd47716791_Out_2_Float, _OneMinus_dd51a0c56dbb9b8b8882c6d36bfadd50_Out_1_Float);
            float _Add_58dd4a9dfd5655818255c74dd17921da_Out_2_Float;
            Unity_Add_float(_OneMinus_dd51a0c56dbb9b8b8882c6d36bfadd50_Out_1_Float, float(-0.5), _Add_58dd4a9dfd5655818255c74dd17921da_Out_2_Float);
            float _Clamp_5b36f07b81ef6f87a93aefa8fcb815b4_Out_3_Float;
            Unity_Clamp_float(_Add_58dd4a9dfd5655818255c74dd17921da_Out_2_Float, float(0), float(1), _Clamp_5b36f07b81ef6f87a93aefa8fcb815b4_Out_3_Float);
            float _Add_5ef49a57de2cdf85b0e894bfa07f6f14_Out_2_Float;
            Unity_Add_float(_Clamp_53d91568d0627d8a9cac8deecdd003a8_Out_3_Float, _Clamp_5b36f07b81ef6f87a93aefa8fcb815b4_Out_3_Float, _Add_5ef49a57de2cdf85b0e894bfa07f6f14_Out_2_Float);
            float _Clamp_130844801cc2148bb64804d2328686eb_Out_3_Float;
            Unity_Clamp_float(_Add_5ef49a57de2cdf85b0e894bfa07f6f14_Out_2_Float, float(0), float(1), _Clamp_130844801cc2148bb64804d2328686eb_Out_3_Float);
            float _Multiply_4a38c41b77a2458085ff4ae52ba3c21c_Out_2_Float;
            Unity_Multiply_float_float(_Power_ca1f1906c90fb785bfe520b7faefc3cd_Out_2_Float, _Clamp_130844801cc2148bb64804d2328686eb_Out_3_Float, _Multiply_4a38c41b77a2458085ff4ae52ba3c21c_Out_2_Float);
            float _Multiply_edc44afd10069b8e80460ceee1cba8f0_Out_2_Float;
            Unity_Multiply_float_float(_Saturate_04686ab19029f68c8fb9e7a115b207b1_Out_1_Float, _Multiply_4a38c41b77a2458085ff4ae52ba3c21c_Out_2_Float, _Multiply_edc44afd10069b8e80460ceee1cba8f0_Out_2_Float);
            float3 _Lerp_05179f1a9a06b084b2d83e8bce908cce_Out_3_Vector3;
            Unity_Lerp_float3(_NormalBlend_9f531c87e2e45580b1d0f65f06c23526_Out_2_Vector3, _NormalStrength_c4639a6dd3dfde85b591971db2700eaf_Out_2_Vector3, (_Multiply_edc44afd10069b8e80460ceee1cba8f0_Out_2_Float.xxx), _Lerp_05179f1a9a06b084b2d83e8bce908cce_Out_3_Vector3);
            float3 _Transform_d583fb35b7a2838399ae5ff4e71be918_Out_1_Vector3;
            {
                float3x3 tangentTransform = float3x3(IN.WorldSpaceTangent, IN.WorldSpaceBiTangent, IN.WorldSpaceNormal);
                _Transform_d583fb35b7a2838399ae5ff4e71be918_Out_1_Vector3 = TransformTangentToWorldDir(_Lerp_05179f1a9a06b084b2d83e8bce908cce_Out_3_Vector3.xyz, tangentTransform, false).xyz;
            }
            float _Split_44ee9f8d0d54618cabce22ec49a8e7d3_R_1_Float = _Transform_d583fb35b7a2838399ae5ff4e71be918_Out_1_Vector3[0];
            float _Split_44ee9f8d0d54618cabce22ec49a8e7d3_G_2_Float = _Transform_d583fb35b7a2838399ae5ff4e71be918_Out_1_Vector3[1];
            float _Split_44ee9f8d0d54618cabce22ec49a8e7d3_B_3_Float = _Transform_d583fb35b7a2838399ae5ff4e71be918_Out_1_Vector3[2];
            float _Split_44ee9f8d0d54618cabce22ec49a8e7d3_A_4_Float = 0;
            float _Multiply_61fc6a92f0e952858b5d99f2caeb09a3_Out_2_Float;
            Unity_Multiply_float_float(_Split_44ee9f8d0d54618cabce22ec49a8e7d3_G_2_Float, _Clamp_815ffdd53cc1c889aa00f73784cb71e7_Out_3_Float, _Multiply_61fc6a92f0e952858b5d99f2caeb09a3_Out_2_Float);
            float _Multiply_1e7ca8eeb2afb68a96897072c537d835_Out_2_Float;
            Unity_Multiply_float_float(_Clamp_815ffdd53cc1c889aa00f73784cb71e7_Out_3_Float, _Property_4879e96694aee98c9d4ecd329a571123_Out_0_Float, _Multiply_1e7ca8eeb2afb68a96897072c537d835_Out_2_Float);
            float _Multiply_a16d49a3ef8d76899c86b7d84d20ef1f_Out_2_Float;
            Unity_Multiply_float_float(_Multiply_1e7ca8eeb2afb68a96897072c537d835_Out_2_Float, _Multiply_4a38c41b77a2458085ff4ae52ba3c21c_Out_2_Float, _Multiply_a16d49a3ef8d76899c86b7d84d20ef1f_Out_2_Float);
            float _Multiply_dd6ce40548593687a3441a83047275eb_Out_2_Float;
            Unity_Multiply_float_float(_Multiply_61fc6a92f0e952858b5d99f2caeb09a3_Out_2_Float, _Multiply_a16d49a3ef8d76899c86b7d84d20ef1f_Out_2_Float, _Multiply_dd6ce40548593687a3441a83047275eb_Out_2_Float);
            float _Clamp_a3bc14da42d1452f9459b4703c528466_Out_3_Float;
            Unity_Clamp_float(_Multiply_dd6ce40548593687a3441a83047275eb_Out_2_Float, float(0), float(1), _Clamp_a3bc14da42d1452f9459b4703c528466_Out_3_Float);
            float _Multiply_ce9d0ae57259445ba0ff1b83b3eac7be_Out_2_Float;
            Unity_Multiply_float_float(_Clamp_bb1427696ce14fe987f799fecc5f9fac_Out_3_Float, _Clamp_a3bc14da42d1452f9459b4703c528466_Out_3_Float, _Multiply_ce9d0ae57259445ba0ff1b83b3eac7be_Out_2_Float);
            #if defined(_USEDYNAMICCOVERTSTATICMASKF)
            float _UseDynamicCover_5ab22e0469924273a6c7c42f82abda85_Out_0_Float = _Multiply_ce9d0ae57259445ba0ff1b83b3eac7be_Out_2_Float;
            #else
            float _UseDynamicCover_5ab22e0469924273a6c7c42f82abda85_Out_0_Float = _Clamp_bb1427696ce14fe987f799fecc5f9fac_Out_3_Float;
            #endif
            Bindings_UniversalHeighblend_3b5c31b864970d04197cd420b6c4b0fa_float _UniversalHeighblend_21bd55d8d402489499f7ea440e52eb45;
            float _UniversalHeighblend_21bd55d8d402489499f7ea440e52eb45_Heightmap_1_Float;
            SG_UniversalHeighblend_3b5c31b864970d04197cd420b6c4b0fa_float(_Split_a80936a3c75945efb8cf9f2b95c76642_G_2_Float, _Property_14a6757619d64822a44a69b34f85276d_Out_0_Float, _Property_c0d9ffba7dee497c885a54170977d874_Out_0_Boolean, _Split_218e1cfd00b30984921b5fc0ec63de60_B_3_Float, _Add_1f9ea9bdf36544b59f763806e7eea80d_Out_2_Vector2, _Property_0fbef18600294e199eeda9905e3304e4_Out_0_Boolean, _Split_2f45bca363698c859e51492899bc58f8_B_3_Float, _Add_28628d641d58481084e9c00e4ad5fc8d_Out_2_Vector2, _UseDynamicCover_5ab22e0469924273a6c7c42f82abda85_Out_0_Float, _UniversalHeighblend_21bd55d8d402489499f7ea440e52eb45, _UniversalHeighblend_21bd55d8d402489499f7ea440e52eb45_Heightmap_1_Float);
            float _Split_05a25ef5bb1c4867950074f8c86410e8_R_1_Float = IN.VertexColor[0];
            float _Split_05a25ef5bb1c4867950074f8c86410e8_G_2_Float = IN.VertexColor[1];
            float _Split_05a25ef5bb1c4867950074f8c86410e8_B_3_Float = IN.VertexColor[2];
            float _Split_05a25ef5bb1c4867950074f8c86410e8_A_4_Float = IN.VertexColor[3];
            float _OneMinus_0527b7625ff14e8c8ca27817ac4fe9f9_Out_1_Float;
            Unity_OneMinus_float(_Split_05a25ef5bb1c4867950074f8c86410e8_B_3_Float, _OneMinus_0527b7625ff14e8c8ca27817ac4fe9f9_Out_1_Float);
            float _Property_defdd10d24ee4948b18af67062372fb7_Out_0_Float = _VertexColorBBlendStrenght;
            float _Property_f600c3fa0837403fa7000ace8a7aa949_Out_0_Boolean = _USEBaseHeightT;
            float _Property_cc1df5222a194b39870a1906a95881c7_Out_0_Boolean = _USECoverHeightT;
            float _Subtract_df32895ca10a49a6adc84378c30ceb7c_Out_2_Float;
            Unity_Subtract_float(_Property_0e120eb0a0a14b12a31a3c1f5b961121_Out_0_Float, _Property_32b48052fdbb4641bf4eeb294bc65050_Out_0_Float, _Subtract_df32895ca10a49a6adc84378c30ceb7c_Out_2_Float);
            float _Split_a090b28818f34dd8945b893c7fd769f1_R_1_Float = IN.VertexColor[0];
            float _Split_a090b28818f34dd8945b893c7fd769f1_G_2_Float = IN.VertexColor[1];
            float _Split_a090b28818f34dd8945b893c7fd769f1_B_3_Float = IN.VertexColor[2];
            float _Split_a090b28818f34dd8945b893c7fd769f1_A_4_Float = IN.VertexColor[3];
            float _OneMinus_d11f0c4a04b345419edf8e146b9c0221_Out_1_Float;
            Unity_OneMinus_float(_Split_a090b28818f34dd8945b893c7fd769f1_B_3_Float, _OneMinus_d11f0c4a04b345419edf8e146b9c0221_Out_1_Float);
            float _Multiply_b7ff184632b347e9b3d331daaed81a77_Out_2_Float;
            Unity_Multiply_float_float(_Subtract_df32895ca10a49a6adc84378c30ceb7c_Out_2_Float, _OneMinus_d11f0c4a04b345419edf8e146b9c0221_Out_1_Float, _Multiply_b7ff184632b347e9b3d331daaed81a77_Out_2_Float);
            float _Add_ff8ced5a04044788a5de3632a403c505_Out_2_Float;
            Unity_Add_float(_Property_6b467710b0ba48058e003aebe9119249_Out_0_Float, _Multiply_b7ff184632b347e9b3d331daaed81a77_Out_2_Float, _Add_ff8ced5a04044788a5de3632a403c505_Out_2_Float);
            float2 _Add_8ec067f807d04641bea7fd38ab0c8165_Out_2_Vector2;
            Unity_Add_float2(_Vector2_6955747f7f0a4ff98fae60dbada25e89_Out_0_Vector2, (_Add_ff8ced5a04044788a5de3632a403c505_Out_2_Float.xx), _Add_8ec067f807d04641bea7fd38ab0c8165_Out_2_Vector2);
            Bindings_UniversalHeighblend_3b5c31b864970d04197cd420b6c4b0fa_float _UniversalHeighblend_69e2f839a11b4aa7b8e84d65b0ac8307;
            float _UniversalHeighblend_69e2f839a11b4aa7b8e84d65b0ac8307_Heightmap_1_Float;
            SG_UniversalHeighblend_3b5c31b864970d04197cd420b6c4b0fa_float(_OneMinus_0527b7625ff14e8c8ca27817ac4fe9f9_Out_1_Float, _Property_defdd10d24ee4948b18af67062372fb7_Out_0_Float, _Property_f600c3fa0837403fa7000ace8a7aa949_Out_0_Boolean, _Split_218e1cfd00b30984921b5fc0ec63de60_B_3_Float, _Add_1f9ea9bdf36544b59f763806e7eea80d_Out_2_Vector2, _Property_cc1df5222a194b39870a1906a95881c7_Out_0_Boolean, _Split_2f45bca363698c859e51492899bc58f8_B_3_Float, _Add_8ec067f807d04641bea7fd38ab0c8165_Out_2_Vector2, float(1), _UniversalHeighblend_69e2f839a11b4aa7b8e84d65b0ac8307, _UniversalHeighblend_69e2f839a11b4aa7b8e84d65b0ac8307_Heightmap_1_Float);
            float _Add_facc0ab0661749d4bda41177c639b438_Out_2_Float;
            Unity_Add_float(_UniversalHeighblend_21bd55d8d402489499f7ea440e52eb45_Heightmap_1_Float, _UniversalHeighblend_69e2f839a11b4aa7b8e84d65b0ac8307_Heightmap_1_Float, _Add_facc0ab0661749d4bda41177c639b438_Out_2_Float);
            float _Saturate_269cfab86e2abe83819a3afa7b3eeda2_Out_1_Float;
            Unity_Saturate_float(_Add_facc0ab0661749d4bda41177c639b438_Out_2_Float, _Saturate_269cfab86e2abe83819a3afa7b3eeda2_Out_1_Float);
            float4 _Lerp_562b79f1df34b88e9a8a7431d434b435_Out_3_Vector4;
            Unity_Lerp_float4(_Combine_b0f28916143e4b94af6bec53f5328b52_RGBA_4_Vector4, _Multiply_b08794693505bd8e8c04b9ba1610d394_Out_2_Vector4, (_Saturate_269cfab86e2abe83819a3afa7b3eeda2_Out_1_Float.xxxx), _Lerp_562b79f1df34b88e9a8a7431d434b435_Out_3_Vector4);
            float _Split_546cdec490fe4753bb0983eea82b45b5_R_1_Float = _Lerp_562b79f1df34b88e9a8a7431d434b435_Out_3_Vector4[0];
            float _Split_546cdec490fe4753bb0983eea82b45b5_G_2_Float = _Lerp_562b79f1df34b88e9a8a7431d434b435_Out_3_Vector4[1];
            float _Split_546cdec490fe4753bb0983eea82b45b5_B_3_Float = _Lerp_562b79f1df34b88e9a8a7431d434b435_Out_3_Vector4[2];
            float _Split_546cdec490fe4753bb0983eea82b45b5_A_4_Float = _Lerp_562b79f1df34b88e9a8a7431d434b435_Out_3_Vector4[3];
            float4 _Clamp_33ec4dd182654e108c0f4ee43f91e820_Out_3_Vector4;
            Unity_Clamp_float4(IN.VertexColor, float4(0, 0, 0, 0), float4(1, 1, 1, 1), _Clamp_33ec4dd182654e108c0f4ee43f91e820_Out_3_Vector4);
            float _Split_5b2299b48b10138ea40c141b79bfe90e_R_1_Float = _Clamp_33ec4dd182654e108c0f4ee43f91e820_Out_3_Vector4[0];
            float _Split_5b2299b48b10138ea40c141b79bfe90e_G_2_Float = _Clamp_33ec4dd182654e108c0f4ee43f91e820_Out_3_Vector4[1];
            float _Split_5b2299b48b10138ea40c141b79bfe90e_B_3_Float = _Clamp_33ec4dd182654e108c0f4ee43f91e820_Out_3_Vector4[2];
            float _Split_5b2299b48b10138ea40c141b79bfe90e_A_4_Float = _Clamp_33ec4dd182654e108c0f4ee43f91e820_Out_3_Vector4[3];
            float _Multiply_a7796e97d268424b880f9cb87fc6e42c_Out_2_Float;
            Unity_Multiply_float_float(_Split_546cdec490fe4753bb0983eea82b45b5_A_4_Float, _Split_5b2299b48b10138ea40c141b79bfe90e_A_4_Float, _Multiply_a7796e97d268424b880f9cb87fc6e42c_Out_2_Float);
            float _Property_7ae68b65d6ed4f37aec08ecb89701e8e_Out_0_Float = _AlphaCutoff;
            surface.Alpha = _Multiply_a7796e97d268424b880f9cb87fc6e42c_Out_2_Float;
            surface.AlphaClipThreshold = _Property_7ae68b65d6ed4f37aec08ecb89701e8e_Out_0_Float;
            return surface;
        }
        
        // --------------------------------------------------
        // Build Graph Inputs
        #ifdef HAVE_VFX_MODIFICATION
        #define VFX_SRP_ATTRIBUTES Attributes
        #define VFX_SRP_VARYINGS Varyings
        #define VFX_SRP_SURFACE_INPUTS SurfaceDescriptionInputs
        #endif
        VertexDescriptionInputs BuildVertexDescriptionInputs(Attributes input)
        {
            VertexDescriptionInputs output;
            ZERO_INITIALIZE(VertexDescriptionInputs, output);
        
            output.ObjectSpaceNormal =                          input.normalOS;
            output.ObjectSpaceTangent =                         input.tangentOS.xyz;
            output.ObjectSpacePosition =                        input.positionOS;
        #if UNITY_ANY_INSTANCING_ENABLED
        #else // TODO: XR support for procedural instancing because in this case UNITY_ANY_INSTANCING_ENABLED is not defined and instanceID is incorrect.
        #endif
        
            return output;
        }
        SurfaceDescriptionInputs BuildSurfaceDescriptionInputs(Varyings input)
        {
            SurfaceDescriptionInputs output;
            ZERO_INITIALIZE(SurfaceDescriptionInputs, output);
        
        #ifdef HAVE_VFX_MODIFICATION
        #if VFX_USE_GRAPH_VALUES
            uint instanceActiveIndex = asuint(UNITY_ACCESS_INSTANCED_PROP(PerInstance, _InstanceActiveIndex));
            /* WARNING: $splice Could not find named fragment 'VFXLoadGraphValues' */
        #endif
            /* WARNING: $splice Could not find named fragment 'VFXSetFragInputs' */
        
        #endif
        
            
        
            // must use interpolated tangent, bitangent and normal before they are normalized in the pixel shader.
            float3 unnormalizedNormalWS = input.normalWS;
            const float renormFactor = 1.0 / length(unnormalizedNormalWS);
        
            // use bitangent on the fly like in hdrp
            // IMPORTANT! If we ever support Flip on double sided materials ensure bitangent and tangent are NOT flipped.
            float crossSign = (input.tangentWS.w > 0.0 ? 1.0 : -1.0)* GetOddNegativeScale();
            float3 bitang = crossSign * cross(input.normalWS.xyz, input.tangentWS.xyz);
        
            output.WorldSpaceNormal = renormFactor * input.normalWS.xyz;      // we want a unit length Normal Vector node in shader graph
        
            // to pr               eserve mikktspace compliance we use same scale renormFactor as was used on the normal.
            // This                is explained in section 2.2 in "surface gradient based bump mapping framework"
            output.WorldSpaceTangent = renormFactor * input.tangentWS.xyz;
            output.WorldSpaceBiTangent = renormFactor * bitang;
        
            output.AbsoluteWorldSpacePosition = GetAbsolutePositionWS(input.positionWS);
        
            #if UNITY_UV_STARTS_AT_TOP
            #else
            #endif
        
        
            output.uv0 = input.texCoord0;
            output.uv3 = input.texCoord3;
            output.VertexColor = input.color;
        #if UNITY_ANY_INSTANCING_ENABLED
        #else // TODO: XR support for procedural instancing because in this case UNITY_ANY_INSTANCING_ENABLED is not defined and instanceID is incorrect.
        #endif
        #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
        #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN output.FaceSign =                    IS_FRONT_VFACE(input.cullFace, true, false);
        #else
        #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
        #endif
        #undef BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
        
                return output;
        }
        
        // --------------------------------------------------
        // Main
        
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/Varyings.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/SelectionPickingPass.hlsl"
        
        // --------------------------------------------------
        // Visual Effect Vertex Invocations
        #ifdef HAVE_VFX_MODIFICATION
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/VisualEffectVertex.hlsl"
        #endif
        
        ENDHLSL
        }
        Pass
        {
            Name "ScenePickingPass"
            Tags
            {
                "LightMode" = "Picking"
            }
        
        // Render State
        Cull [_Cull]
        
        // Debug
        // <None>
        
        // --------------------------------------------------
        // Pass
        
        HLSLPROGRAM
        
        // Pragmas
        #pragma target 2.0
        #pragma vertex vert
        #pragma fragment frag
        
        // Keywords
        #pragma shader_feature_local_fragment _ _ALPHATEST_ON
        #pragma shader_feature_local _ _USEDYNAMICCOVERTSTATICMASKF
        #pragma shader_feature_local _ _WETNESS_T_HEAT_F
        
        #if defined(_USEDYNAMICCOVERTSTATICMASKF) && defined(_WETNESS_T_HEAT_F)
            #define KEYWORD_PERMUTATION_0
        #elif defined(_USEDYNAMICCOVERTSTATICMASKF)
            #define KEYWORD_PERMUTATION_1
        #elif defined(_WETNESS_T_HEAT_F)
            #define KEYWORD_PERMUTATION_2
        #else
            #define KEYWORD_PERMUTATION_3
        #endif
        
        
        // Defines
        
        #define _NORMALMAP 1
        #define _NORMAL_DROPOFF_TS 1
        #define ATTRIBUTES_NEED_NORMAL
        #define ATTRIBUTES_NEED_TANGENT
        #define ATTRIBUTES_NEED_TEXCOORD0
        #define ATTRIBUTES_NEED_TEXCOORD3
        #define ATTRIBUTES_NEED_COLOR
        #define FEATURES_GRAPH_VERTEX_NORMAL_OUTPUT
        #define FEATURES_GRAPH_VERTEX_TANGENT_OUTPUT
        #define VARYINGS_NEED_POSITION_WS
        #define VARYINGS_NEED_NORMAL_WS
        #define VARYINGS_NEED_TANGENT_WS
        #define VARYINGS_NEED_TEXCOORD0
        #define VARYINGS_NEED_TEXCOORD3
        #define VARYINGS_NEED_COLOR
        #define FEATURES_GRAPH_VERTEX
        /* WARNING: $splice Could not find named fragment 'PassInstancing' */
        #define SHADERPASS SHADERPASS_DEPTHONLY
        #define SCENEPICKINGPASS 1
        #define ALPHA_CLIP_THRESHOLD 1
        
        
        // custom interpolator pre-include
        /* WARNING: $splice Could not find named fragment 'sgci_CustomInterpolatorPreInclude' */
        
        // Includes
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Texture.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
        #include_with_pragmas "Packages/com.unity.render-pipelines.core/ShaderLibrary/FoveatedRenderingKeywords.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/FoveatedRendering.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Input.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/TextureStack.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/DebugMipmapStreamingMacros.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"
        #include_with_pragmas "Packages/com.unity.render-pipelines.universal/ShaderLibrary/DOTS.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShaderPass.hlsl"
        
        // --------------------------------------------------
        // Structs and Packing
        
        // custom interpolators pre packing
        /* WARNING: $splice Could not find named fragment 'CustomInterpolatorPrePacking' */
        
        struct Attributes
        {
             float3 positionOS : POSITION;
             float3 normalOS : NORMAL;
             float4 tangentOS : TANGENT;
             float4 uv0 : TEXCOORD0;
             float4 uv3 : TEXCOORD3;
             float4 color : COLOR;
            #if UNITY_ANY_INSTANCING_ENABLED || defined(ATTRIBUTES_NEED_INSTANCEID)
             uint instanceID : INSTANCEID_SEMANTIC;
            #endif
        };
        struct Varyings
        {
             float4 positionCS : SV_POSITION;
             float3 positionWS;
             float3 normalWS;
             float4 tangentWS;
             float4 texCoord0;
             float4 texCoord3;
             float4 color;
            #if UNITY_ANY_INSTANCING_ENABLED || defined(VARYINGS_NEED_INSTANCEID)
             uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
             uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
             uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
             FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
        };
        struct SurfaceDescriptionInputs
        {
             float3 WorldSpaceNormal;
             float3 WorldSpaceTangent;
             float3 WorldSpaceBiTangent;
             float3 AbsoluteWorldSpacePosition;
             float4 uv0;
             float4 uv3;
             float4 VertexColor;
        };
        struct VertexDescriptionInputs
        {
             float3 ObjectSpaceNormal;
             float3 ObjectSpaceTangent;
             float3 ObjectSpacePosition;
        };
        struct PackedVaryings
        {
             float4 positionCS : SV_POSITION;
             float4 tangentWS : INTERP0;
             float4 texCoord0 : INTERP1;
             float4 texCoord3 : INTERP2;
             float4 color : INTERP3;
             float3 positionWS : INTERP4;
             float3 normalWS : INTERP5;
            #if UNITY_ANY_INSTANCING_ENABLED || defined(VARYINGS_NEED_INSTANCEID)
             uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
             uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
             uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
             FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
        };
        
        PackedVaryings PackVaryings (Varyings input)
        {
            PackedVaryings output;
            ZERO_INITIALIZE(PackedVaryings, output);
            output.positionCS = input.positionCS;
            output.tangentWS.xyzw = input.tangentWS;
            output.texCoord0.xyzw = input.texCoord0;
            output.texCoord3.xyzw = input.texCoord3;
            output.color.xyzw = input.color;
            output.positionWS.xyz = input.positionWS;
            output.normalWS.xyz = input.normalWS;
            #if UNITY_ANY_INSTANCING_ENABLED || defined(VARYINGS_NEED_INSTANCEID)
            output.instanceID = input.instanceID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            output.cullFace = input.cullFace;
            #endif
            return output;
        }
        
        Varyings UnpackVaryings (PackedVaryings input)
        {
            Varyings output;
            output.positionCS = input.positionCS;
            output.tangentWS = input.tangentWS.xyzw;
            output.texCoord0 = input.texCoord0.xyzw;
            output.texCoord3 = input.texCoord3.xyzw;
            output.color = input.color.xyzw;
            output.positionWS = input.positionWS.xyz;
            output.normalWS = input.normalWS.xyz;
            #if UNITY_ANY_INSTANCING_ENABLED || defined(VARYINGS_NEED_INSTANCEID)
            output.instanceID = input.instanceID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            output.cullFace = input.cullFace;
            #endif
            return output;
        }
        
        
        // --------------------------------------------------
        // Graph
        
        // Graph Properties
        CBUFFER_START(UnityPerMaterial)
        float _EmissionNoiseMultiply;
        float _EmissionNoisePower;
        float Emission_Noise_UV0_UV3;
        float _EmissionNoiseUsePlanarUV;
        float _BaseEmissionMaskTreshold;
        float _CoverEmissionMaskIntensivity;
        float _CoverEmissionMaskTreshold;
        float4 _RimColor;
        float _RimLightPower;
        float4 _Noise_TexelSize;
        float2 _NoiseSpeed;
        float _BaseEmissionMaskIntensivity;
        float4 _LavaEmissionColor;
        float4 _Emission_Noise_Tiling_and_Offset;
        float _Cover_Mask_A_Remap_Min;
        float _Cover_Mask_A_Remap_Max;
        float _HeightMin;
        float _HeightMax;
        float _HeightOffset;
        float _VertexColorBBlendStrenght;
        float _USECoverHeightT;
        float _AlphaCutoff;
        float4 _WetColor;
        float4 _BaseColor;
        float _USEBaseHeightT;
        float4 _BaseColorMap_TexelSize;
        float _BaseUsePlanarUV;
        float4 _BaseTilingOffset;
        float4 _BaseNormalMap_TexelSize;
        float _BaseNormalScale;
        float4 _BaseMaskMap_TexelSize;
        float _BaseMetallic;
        float _VertexColorGBlendStrenght;
        float _BaseAORemapMin;
        float _BaseAORemapMax;
        float _BaseSmoothnessRemapMin;
        float _BaseSmoothnessRemapMax;
        float4 _Masks_TexelSize;
        float _Cover_Amount;
        float _Cover_Amount_Grow_Speed;
        float _Cover_Max_Angle;
        float _Cover_Min_Height;
        float _Cover_Min_Height_Blending;
        float4 _CoverBaseColor;
        float4 _CoverBaseColorMap_TexelSize;
        float _CoverUsePlanarUV;
        float4 _CoverTilingOffset;
        float4 _CoverNormalMap_TexelSize;
        float _CoverNormalScale;
        float _CoverNormalBlendHardness;
        float _CoverHardness;
        float _CoverHeightMapMin;
        float _CoverHeightMapMax;
        float _CoverHeightMapOffset;
        float4 _CoverMaskMap_TexelSize;
        float _CoverMetallic;
        float _CoverAORemapMin;
        float _CoverAORemapMax;
        float _CoverSmoothnessRemapMin;
        float _CoverSmoothnessRemapMax;
        float4 _DetailMap_TexelSize;
        float4 _DetailTilingOffset;
        float _DetailAlbedoScale;
        float _DetailNormalScale;
        float _DetailSmoothnessScale;
        float _WetSmoothness;
        UNITY_TEXTURE_STREAMING_DEBUG_VARS;
        CBUFFER_END
        
        
        // Object and Global properties
        SAMPLER(SamplerState_Linear_Repeat);
        SAMPLER(SamplerState_Linear_Repeat_Aniso8);
        TEXTURE2D(_Noise);
        SAMPLER(sampler_Noise);
        TEXTURE2D(_BaseColorMap);
        SAMPLER(sampler_BaseColorMap);
        TEXTURE2D(_BaseNormalMap);
        SAMPLER(sampler_BaseNormalMap);
        TEXTURE2D(_BaseMaskMap);
        SAMPLER(sampler_BaseMaskMap);
        TEXTURE2D(_Masks);
        SAMPLER(sampler_Masks);
        TEXTURE2D(_CoverBaseColorMap);
        SAMPLER(sampler_CoverBaseColorMap);
        TEXTURE2D(_CoverNormalMap);
        SAMPLER(sampler_CoverNormalMap);
        TEXTURE2D(_CoverMaskMap);
        SAMPLER(sampler_CoverMaskMap);
        TEXTURE2D(_DetailMap);
        SAMPLER(sampler_DetailMap);
        
        // Graph Includes
        // GraphIncludes: <None>
        
        // -- Property used by ScenePickingPass
        #ifdef SCENEPICKINGPASS
        float4 _SelectionID;
        #endif
        
        // -- Properties used by SceneSelectionPass
        #ifdef SCENESELECTIONPASS
        int _ObjectId;
        int _PassValue;
        #endif
        
        // Graph Functions
        
        void Unity_Combine_float(float R, float G, float B, float A, out float4 RGBA, out float3 RGB, out float2 RG)
        {
            RGBA = float4(R, G, B, A);
            RGB = float3(R, G, B);
            RG = float2(R, G);
        }
        
        void Unity_Divide_float(float A, float B, out float Out)
        {
            Out = A / B;
        }
        
        void Unity_Multiply_float4_float4(float4 A, float4 B, out float4 Out)
        {
        Out = A * B;
        }
        
        void Unity_Branch_float4(float Predicate, float4 True, float4 False, out float4 Out)
        {
            Out = Predicate ? True : False;
        }
        
        void Unity_TilingAndOffset_float(float2 UV, float2 Tiling, float2 Offset, out float2 Out)
        {
            Out = UV * Tiling + Offset;
        }
        
        void Unity_Branch_float2(float Predicate, float2 True, float2 False, out float2 Out)
        {
            Out = Predicate ? True : False;
        }
        
        struct Bindings_PlanarNM_c0f081da9c567704ea36e7dd38cedcf6_float
        {
        float3 AbsoluteWorldSpacePosition;
        half4 uv0;
        half4 uv3;
        };
        
        void SG_PlanarNM_c0f081da9c567704ea36e7dd38cedcf6_float(UnityTexture2D Texture2D_80A3D28F, float4 Vector4_2EBA7A3B, float Boolean_7ABB9909, UnitySamplerState _SamplerState, float Boolean_5ddfe6daabcc4715a44b5f34fc19becb, Bindings_PlanarNM_c0f081da9c567704ea36e7dd38cedcf6_float IN, out float4 XZ_2)
        {
        UnityTexture2D _Property_3e01b4d2fc68d48ba3acbba9d5881e59_Out_0_Texture2D = Texture2D_80A3D28F;
        float _Property_30834f691775a0898a45b1c868520436_Out_0_Boolean = Boolean_7ABB9909;
        float _Split_89ed63cb625cb3878c183d0b71c03400_R_1_Float = IN.AbsoluteWorldSpacePosition[0];
        float _Split_89ed63cb625cb3878c183d0b71c03400_G_2_Float = IN.AbsoluteWorldSpacePosition[1];
        float _Split_89ed63cb625cb3878c183d0b71c03400_B_3_Float = IN.AbsoluteWorldSpacePosition[2];
        float _Split_89ed63cb625cb3878c183d0b71c03400_A_4_Float = 0;
        float4 _Combine_cf2d04ff119ad88493f6460431765cbb_RGBA_4_Vector4;
        float3 _Combine_cf2d04ff119ad88493f6460431765cbb_RGB_5_Vector3;
        float2 _Combine_cf2d04ff119ad88493f6460431765cbb_RG_6_Vector2;
        Unity_Combine_float(_Split_89ed63cb625cb3878c183d0b71c03400_R_1_Float, _Split_89ed63cb625cb3878c183d0b71c03400_B_3_Float, float(0), float(0), _Combine_cf2d04ff119ad88493f6460431765cbb_RGBA_4_Vector4, _Combine_cf2d04ff119ad88493f6460431765cbb_RGB_5_Vector3, _Combine_cf2d04ff119ad88493f6460431765cbb_RG_6_Vector2);
        float4 _Property_8a66888ec47d0687ab1cb2f8abdc9da8_Out_0_Vector4 = Vector4_2EBA7A3B;
        float _Split_2f0f52f6ef8c0e81af0da6476402bc1f_R_1_Float = _Property_8a66888ec47d0687ab1cb2f8abdc9da8_Out_0_Vector4[0];
        float _Split_2f0f52f6ef8c0e81af0da6476402bc1f_G_2_Float = _Property_8a66888ec47d0687ab1cb2f8abdc9da8_Out_0_Vector4[1];
        float _Split_2f0f52f6ef8c0e81af0da6476402bc1f_B_3_Float = _Property_8a66888ec47d0687ab1cb2f8abdc9da8_Out_0_Vector4[2];
        float _Split_2f0f52f6ef8c0e81af0da6476402bc1f_A_4_Float = _Property_8a66888ec47d0687ab1cb2f8abdc9da8_Out_0_Vector4[3];
        float _Divide_e64179199923c58289b6aa94ea6c9178_Out_2_Float;
        Unity_Divide_float(float(1), _Split_2f0f52f6ef8c0e81af0da6476402bc1f_R_1_Float, _Divide_e64179199923c58289b6aa94ea6c9178_Out_2_Float);
        float4 _Multiply_14cec4902d0a00829e4555071a1b8ad1_Out_2_Vector4;
        Unity_Multiply_float4_float4(_Combine_cf2d04ff119ad88493f6460431765cbb_RGBA_4_Vector4, (_Divide_e64179199923c58289b6aa94ea6c9178_Out_2_Float.xxxx), _Multiply_14cec4902d0a00829e4555071a1b8ad1_Out_2_Vector4);
        float _Property_f17c7bf877e64b6abdd66b1fe9f5accc_Out_0_Boolean = Boolean_5ddfe6daabcc4715a44b5f34fc19becb;
        float4 _UV_029e8e8198564838b9389b902a09fb22_Out_0_Vector4 = IN.uv0;
        float4 _UV_7a6209af1506424fb75c81e87e42035a_Out_0_Vector4 = IN.uv3;
        float4 _Branch_fc37bb4bf641457cbbc6e290603056ff_Out_3_Vector4;
        Unity_Branch_float4(_Property_f17c7bf877e64b6abdd66b1fe9f5accc_Out_0_Boolean, _UV_029e8e8198564838b9389b902a09fb22_Out_0_Vector4, _UV_7a6209af1506424fb75c81e87e42035a_Out_0_Vector4, _Branch_fc37bb4bf641457cbbc6e290603056ff_Out_3_Vector4);
        float2 _Vector2_16c15d3bbdd14b85bd48e3a6cb318af7_Out_0_Vector2 = float2(_Split_2f0f52f6ef8c0e81af0da6476402bc1f_R_1_Float, _Split_2f0f52f6ef8c0e81af0da6476402bc1f_G_2_Float);
        float2 _Vector2_f8d75f54e7705083bbec539a60185577_Out_0_Vector2 = float2(_Split_2f0f52f6ef8c0e81af0da6476402bc1f_B_3_Float, _Split_2f0f52f6ef8c0e81af0da6476402bc1f_A_4_Float);
        float2 _TilingAndOffset_d91e2d25acd34686b562b7fe7e9d1d27_Out_3_Vector2;
        Unity_TilingAndOffset_float((_Branch_fc37bb4bf641457cbbc6e290603056ff_Out_3_Vector4.xy), _Vector2_16c15d3bbdd14b85bd48e3a6cb318af7_Out_0_Vector2, _Vector2_f8d75f54e7705083bbec539a60185577_Out_0_Vector2, _TilingAndOffset_d91e2d25acd34686b562b7fe7e9d1d27_Out_3_Vector2);
        float2 _Branch_8e5a4e8f4d52fc8aadd1f46485afc933_Out_3_Vector2;
        Unity_Branch_float2(_Property_30834f691775a0898a45b1c868520436_Out_0_Boolean, (_Multiply_14cec4902d0a00829e4555071a1b8ad1_Out_2_Vector4.xy), _TilingAndOffset_d91e2d25acd34686b562b7fe7e9d1d27_Out_3_Vector2, _Branch_8e5a4e8f4d52fc8aadd1f46485afc933_Out_3_Vector2);
        UnitySamplerState _Property_e8746b9475c94530ba35ba8019ad2ae0_Out_0_SamplerState = _SamplerState;
        float4 _SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_RGBA_0_Vector4 = SAMPLE_TEXTURE2D(_Property_3e01b4d2fc68d48ba3acbba9d5881e59_Out_0_Texture2D.tex, _Property_e8746b9475c94530ba35ba8019ad2ae0_Out_0_SamplerState.samplerstate, _Property_3e01b4d2fc68d48ba3acbba9d5881e59_Out_0_Texture2D.GetTransformedUV(_Branch_8e5a4e8f4d52fc8aadd1f46485afc933_Out_3_Vector2) );
        float _SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_R_4_Float = _SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_RGBA_0_Vector4.r;
        float _SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_G_5_Float = _SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_RGBA_0_Vector4.g;
        float _SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_B_6_Float = _SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_RGBA_0_Vector4.b;
        float _SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_A_7_Float = _SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_RGBA_0_Vector4.a;
        XZ_2 = _SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_RGBA_0_Vector4;
        }
        
        void Unity_ColorspaceConversion_Linear_RGB_float(float3 In, out float3 Out)
        {
            float3 sRGBLo = In * 12.92;
            float3 sRGBHi = (pow(max(abs(In), 1.192092896e-07), float3(1.0 / 2.4, 1.0 / 2.4, 1.0 / 2.4)) * 1.055) - 0.055;
            Out = float3(In <= 0.0031308) ? sRGBLo : sRGBHi;
        }
        
        void Unity_Blend_Overlay_float3(float3 Base, float3 Blend, out float3 Out, float Opacity)
        {
            float3 result1 = 1.0 - 2.0 * (1.0 - Base) * (1.0 - Blend);
            float3 result2 = 2.0 * Base * Blend;
            float3 zeroOrOne = step(Base, 0.5);
            Out = result2 * zeroOrOne + (1 - zeroOrOne) * result1;
            Out = lerp(Base, Out, Opacity);
        }
        
        void Unity_ColorspaceConversion_RGB_Linear_float(float3 In, out float3 Out)
        {
            float3 linearRGBLo = In / 12.92;
            float3 linearRGBHi = pow(max(abs((In + 0.055) / 1.055), 1.192092896e-07), float3(2.4, 2.4, 2.4));
            Out = float3(In <= 0.04045) ? linearRGBLo : linearRGBHi;
        }
        
        void Unity_Clamp_float3(float3 In, float3 Min, float3 Max, out float3 Out)
        {
            Out = clamp(In, Min, Max);
        }
        
        void Unity_Add_float2(float2 A, float2 B, out float2 Out)
        {
            Out = A + B;
        }
        
        void Unity_Remap_float(float In, float2 InMinMax, float2 OutMinMax, out float Out)
        {
            Out = OutMinMax.x + (In - InMinMax.x) * (OutMinMax.y - OutMinMax.x) / (InMinMax.y - InMinMax.x);
        }
        
        void Unity_Clamp_float(float In, float Min, float Max, out float Out)
        {
            Out = clamp(In, Min, Max);
        }
        
        void Unity_Multiply_float2_float2(float2 A, float2 B, out float2 Out)
        {
            Out = A * B;
        }
        
        void Unity_DotProduct_float2(float2 A, float2 B, out float Out)
        {
            Out = dot(A, B);
        }
        
        void Unity_Saturate_float(float In, out float Out)
        {
            Out = saturate(In);
        }
        
        void Unity_OneMinus_float(float In, out float Out)
        {
            Out = 1 - In;
        }
        
        void Unity_SquareRoot_float(float In, out float Out)
        {
            Out = sqrt(In);
        }
        
        void Unity_Sign_float3(float3 In, out float3 Out)
        {
            Out = sign(In);
        }
        
        void Unity_Multiply_float_float(float A, float B, out float Out)
        {
        Out = A * B;
        }
        
        void Unity_Normalize_float3(float3 In, out float3 Out)
        {
            Out = normalize(In);
        }
        
        void Unity_Branch_float3(float Predicate, float3 True, float3 False, out float3 Out)
        {
            Out = Predicate ? True : False;
        }
        
        struct Bindings_PlanarNMn_1b93a87456f9d4c419321d0cd92bd6c8_float
        {
        float3 WorldSpaceNormal;
        float3 WorldSpaceTangent;
        float3 WorldSpaceBiTangent;
        float3 AbsoluteWorldSpacePosition;
        half4 uv0;
        half4 uv3;
        };
        
        void SG_PlanarNMn_1b93a87456f9d4c419321d0cd92bd6c8_float(UnityTexture2D Texture2D_80A3D28F, float4 Vector4_82674548, float Boolean_9FF42DF6, UnitySamplerState _SamplerState, float Boolean_5ddfe6daabcc4715a44b5f34fc19becb, Bindings_PlanarNMn_1b93a87456f9d4c419321d0cd92bd6c8_float IN, out float4 XZ_2)
        {
        float _Property_1ef12cf3201a938993fe6a7951b0e754_Out_0_Boolean = Boolean_9FF42DF6;
        UnityTexture2D _Property_3e01b4d2fc68d48ba3acbba9d5881e59_Out_0_Texture2D = Texture2D_80A3D28F;
        float _Split_89ed63cb625cb3878c183d0b71c03400_R_1_Float = IN.AbsoluteWorldSpacePosition[0];
        float _Split_89ed63cb625cb3878c183d0b71c03400_G_2_Float = IN.AbsoluteWorldSpacePosition[1];
        float _Split_89ed63cb625cb3878c183d0b71c03400_B_3_Float = IN.AbsoluteWorldSpacePosition[2];
        float _Split_89ed63cb625cb3878c183d0b71c03400_A_4_Float = 0;
        float4 _Combine_cf2d04ff119ad88493f6460431765cbb_RGBA_4_Vector4;
        float3 _Combine_cf2d04ff119ad88493f6460431765cbb_RGB_5_Vector3;
        float2 _Combine_cf2d04ff119ad88493f6460431765cbb_RG_6_Vector2;
        Unity_Combine_float(_Split_89ed63cb625cb3878c183d0b71c03400_R_1_Float, _Split_89ed63cb625cb3878c183d0b71c03400_B_3_Float, float(0), float(0), _Combine_cf2d04ff119ad88493f6460431765cbb_RGBA_4_Vector4, _Combine_cf2d04ff119ad88493f6460431765cbb_RGB_5_Vector3, _Combine_cf2d04ff119ad88493f6460431765cbb_RG_6_Vector2);
        float4 _Property_3fa1d6f912feb481ba60f2e55e62e746_Out_0_Vector4 = Vector4_82674548;
        float _Split_a2e12fa5931da084b2949343a539dfd8_R_1_Float = _Property_3fa1d6f912feb481ba60f2e55e62e746_Out_0_Vector4[0];
        float _Split_a2e12fa5931da084b2949343a539dfd8_G_2_Float = _Property_3fa1d6f912feb481ba60f2e55e62e746_Out_0_Vector4[1];
        float _Split_a2e12fa5931da084b2949343a539dfd8_B_3_Float = _Property_3fa1d6f912feb481ba60f2e55e62e746_Out_0_Vector4[2];
        float _Split_a2e12fa5931da084b2949343a539dfd8_A_4_Float = _Property_3fa1d6f912feb481ba60f2e55e62e746_Out_0_Vector4[3];
        float _Divide_c36b770dfaa0bb8f85ab27da5fd794f0_Out_2_Float;
        Unity_Divide_float(float(1), _Split_a2e12fa5931da084b2949343a539dfd8_R_1_Float, _Divide_c36b770dfaa0bb8f85ab27da5fd794f0_Out_2_Float);
        float4 _Multiply_14cec4902d0a00829e4555071a1b8ad1_Out_2_Vector4;
        Unity_Multiply_float4_float4(_Combine_cf2d04ff119ad88493f6460431765cbb_RGBA_4_Vector4, (_Divide_c36b770dfaa0bb8f85ab27da5fd794f0_Out_2_Float.xxxx), _Multiply_14cec4902d0a00829e4555071a1b8ad1_Out_2_Vector4);
        float _Property_058f4fba88c3437288219f1929444bf2_Out_0_Boolean = Boolean_5ddfe6daabcc4715a44b5f34fc19becb;
        float4 _UV_43d85b3291324c848dfbeec6adac2a71_Out_0_Vector4 = IN.uv0;
        float4 _UV_36881dcaab9040168fc5215dcd00f352_Out_0_Vector4 = IN.uv3;
        float4 _Branch_8054d58a73be4ce1b22d48a84389ae07_Out_3_Vector4;
        Unity_Branch_float4(_Property_058f4fba88c3437288219f1929444bf2_Out_0_Boolean, _UV_43d85b3291324c848dfbeec6adac2a71_Out_0_Vector4, _UV_36881dcaab9040168fc5215dcd00f352_Out_0_Vector4, _Branch_8054d58a73be4ce1b22d48a84389ae07_Out_3_Vector4);
        float2 _Vector2_6845d21872714d889783b0cb707df3e9_Out_0_Vector2 = float2(_Split_a2e12fa5931da084b2949343a539dfd8_R_1_Float, _Split_a2e12fa5931da084b2949343a539dfd8_G_2_Float);
        float2 _Vector2_e2e2263627c6098e96a5b5d29350ad03_Out_0_Vector2 = float2(_Split_a2e12fa5931da084b2949343a539dfd8_B_3_Float, _Split_a2e12fa5931da084b2949343a539dfd8_A_4_Float);
        float2 _TilingAndOffset_17582d056c0b8a8dab1017d37497fe59_Out_3_Vector2;
        Unity_TilingAndOffset_float((_Branch_8054d58a73be4ce1b22d48a84389ae07_Out_3_Vector4.xy), _Vector2_6845d21872714d889783b0cb707df3e9_Out_0_Vector2, _Vector2_e2e2263627c6098e96a5b5d29350ad03_Out_0_Vector2, _TilingAndOffset_17582d056c0b8a8dab1017d37497fe59_Out_3_Vector2);
        float2 _Branch_1e152f3aac57448f8518bf2852c000c3_Out_3_Vector2;
        Unity_Branch_float2(_Property_1ef12cf3201a938993fe6a7951b0e754_Out_0_Boolean, (_Multiply_14cec4902d0a00829e4555071a1b8ad1_Out_2_Vector4.xy), _TilingAndOffset_17582d056c0b8a8dab1017d37497fe59_Out_3_Vector2, _Branch_1e152f3aac57448f8518bf2852c000c3_Out_3_Vector2);
        UnitySamplerState _Property_69f1ed7efd1b494e91f626b88ab2363c_Out_0_SamplerState = _SamplerState;
        float4 _SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_RGBA_0_Vector4 = SAMPLE_TEXTURE2D(_Property_3e01b4d2fc68d48ba3acbba9d5881e59_Out_0_Texture2D.tex, _Property_69f1ed7efd1b494e91f626b88ab2363c_Out_0_SamplerState.samplerstate, _Property_3e01b4d2fc68d48ba3acbba9d5881e59_Out_0_Texture2D.GetTransformedUV(_Branch_1e152f3aac57448f8518bf2852c000c3_Out_3_Vector2) );
        _SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_RGBA_0_Vector4.rgb = UnpackNormal(_SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_RGBA_0_Vector4);
        float _SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_R_4_Float = _SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_RGBA_0_Vector4.r;
        float _SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_G_5_Float = _SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_RGBA_0_Vector4.g;
        float _SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_B_6_Float = _SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_RGBA_0_Vector4.b;
        float _SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_A_7_Float = _SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_RGBA_0_Vector4.a;
        float2 _Vector2_ad6bd100e273d78fa409a30a77bfa2cc_Out_0_Vector2 = float2(_SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_R_4_Float, _SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_G_5_Float);
        float3 _Sign_3a6ebf59931cf08cb0482e0144ddac24_Out_1_Vector3;
        Unity_Sign_float3(IN.WorldSpaceNormal, _Sign_3a6ebf59931cf08cb0482e0144ddac24_Out_1_Vector3);
        float _Split_6299d4ddcc4c74828aea40a46fdb896e_R_1_Float = _Sign_3a6ebf59931cf08cb0482e0144ddac24_Out_1_Vector3[0];
        float _Split_6299d4ddcc4c74828aea40a46fdb896e_G_2_Float = _Sign_3a6ebf59931cf08cb0482e0144ddac24_Out_1_Vector3[1];
        float _Split_6299d4ddcc4c74828aea40a46fdb896e_B_3_Float = _Sign_3a6ebf59931cf08cb0482e0144ddac24_Out_1_Vector3[2];
        float _Split_6299d4ddcc4c74828aea40a46fdb896e_A_4_Float = 0;
        float2 _Vector2_b76cb1842101e58b9e636d49b075c612_Out_0_Vector2 = float2(_Split_6299d4ddcc4c74828aea40a46fdb896e_G_2_Float, float(1));
        float2 _Multiply_31e8db88ee20c985a9850d1a58f3282b_Out_2_Vector2;
        Unity_Multiply_float2_float2(_Vector2_ad6bd100e273d78fa409a30a77bfa2cc_Out_0_Vector2, _Vector2_b76cb1842101e58b9e636d49b075c612_Out_0_Vector2, _Multiply_31e8db88ee20c985a9850d1a58f3282b_Out_2_Vector2);
        float _Split_5ed44bf2eca0868f81eb18100f49d1fa_R_1_Float = IN.WorldSpaceNormal[0];
        float _Split_5ed44bf2eca0868f81eb18100f49d1fa_G_2_Float = IN.WorldSpaceNormal[1];
        float _Split_5ed44bf2eca0868f81eb18100f49d1fa_B_3_Float = IN.WorldSpaceNormal[2];
        float _Split_5ed44bf2eca0868f81eb18100f49d1fa_A_4_Float = 0;
        float2 _Vector2_70e5837843f28b8b9d64cada3697bd5a_Out_0_Vector2 = float2(_Split_5ed44bf2eca0868f81eb18100f49d1fa_R_1_Float, _Split_5ed44bf2eca0868f81eb18100f49d1fa_B_3_Float);
        float2 _Add_1145b2f896593d80aa864a34e6702562_Out_2_Vector2;
        Unity_Add_float2(_Multiply_31e8db88ee20c985a9850d1a58f3282b_Out_2_Vector2, _Vector2_70e5837843f28b8b9d64cada3697bd5a_Out_0_Vector2, _Add_1145b2f896593d80aa864a34e6702562_Out_2_Vector2);
        float _Split_2bc77ca2d17bd78cb2383770ce50b179_R_1_Float = _Add_1145b2f896593d80aa864a34e6702562_Out_2_Vector2[0];
        float _Split_2bc77ca2d17bd78cb2383770ce50b179_G_2_Float = _Add_1145b2f896593d80aa864a34e6702562_Out_2_Vector2[1];
        float _Split_2bc77ca2d17bd78cb2383770ce50b179_B_3_Float = 0;
        float _Split_2bc77ca2d17bd78cb2383770ce50b179_A_4_Float = 0;
        float _Multiply_ab12aea87465a78eaf7fc66c2598d266_Out_2_Float;
        Unity_Multiply_float_float(_SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_B_6_Float, _Split_5ed44bf2eca0868f81eb18100f49d1fa_G_2_Float, _Multiply_ab12aea87465a78eaf7fc66c2598d266_Out_2_Float);
        float3 _Vector3_433840b555db308b97e9b14b6a957195_Out_0_Vector3 = float3(_Split_2bc77ca2d17bd78cb2383770ce50b179_R_1_Float, _Multiply_ab12aea87465a78eaf7fc66c2598d266_Out_2_Float, _Split_2bc77ca2d17bd78cb2383770ce50b179_G_2_Float);
        float3 _Transform_c7914cc45a011c89b3f53c55afb51673_Out_1_Vector3;
        {
        float3x3 tangentTransform = float3x3(IN.WorldSpaceTangent, IN.WorldSpaceBiTangent, IN.WorldSpaceNormal);
        _Transform_c7914cc45a011c89b3f53c55afb51673_Out_1_Vector3 = TransformWorldToTangentDir(_Vector3_433840b555db308b97e9b14b6a957195_Out_0_Vector3.xyz, tangentTransform, true);
        }
        float3 _Clamp_3837949a36b5428a82af01e7bcd29952_Out_3_Vector3;
        Unity_Clamp_float3(_Transform_c7914cc45a011c89b3f53c55afb51673_Out_1_Vector3, float3(-1, -1, -1), float3(1, 1, 1), _Clamp_3837949a36b5428a82af01e7bcd29952_Out_3_Vector3);
        float3 _Normalize_09bf8a2bd0a4d38e8b97d5c674f79b44_Out_1_Vector3;
        Unity_Normalize_float3(_Clamp_3837949a36b5428a82af01e7bcd29952_Out_3_Vector3, _Normalize_09bf8a2bd0a4d38e8b97d5c674f79b44_Out_1_Vector3);
        float3 _Branch_9eadf909a90f2f80880f8c56ecc2a91f_Out_3_Vector3;
        Unity_Branch_float3(_Property_1ef12cf3201a938993fe6a7951b0e754_Out_0_Boolean, _Normalize_09bf8a2bd0a4d38e8b97d5c674f79b44_Out_1_Vector3, (_SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_RGBA_0_Vector4.xyz), _Branch_9eadf909a90f2f80880f8c56ecc2a91f_Out_3_Vector3);
        XZ_2 = (float4(_Branch_9eadf909a90f2f80880f8c56ecc2a91f_Out_3_Vector3, 1.0));
        }
        
        void Unity_NormalStrength_float(float3 In, float Strength, out float3 Out)
        {
            Out = float3(In.rg * Strength, lerp(1, In.b, saturate(Strength)));
        }
        
        void Unity_NormalBlend_Reoriented_float(float3 A, float3 B, out float3 Out)
        {
            float3 t = A.xyz + float3(0.0, 0.0, 1.0);
            float3 u = B.xyz * float3(-1.0, -1.0, 1.0);
            Out = (t / t.z) * dot(t, u) - u;
        }
        
        void Unity_Subtract_float(float A, float B, out float Out)
        {
            Out = A - B;
        }
        
        void Unity_Absolute_float(float In, out float Out)
        {
            Out = abs(In);
        }
        
        void Unity_Power_float(float A, float B, out float Out)
        {
            Out = pow(A, B);
        }
        
        void Unity_Add_float(float A, float B, out float Out)
        {
            Out = A + B;
        }
        
        void Unity_Lerp_float3(float3 A, float3 B, float3 T, out float3 Out)
        {
            Out = lerp(A, B, T);
        }
        
        void Unity_Comparison_Greater_float(float A, float B, out float Out)
        {
            Out = A > B ? 1 : 0;
        }
        
        void Unity_Branch_float(float Predicate, float True, float False, out float Out)
        {
            Out = Predicate ? True : False;
        }
        
        struct Bindings_UniversalHeighblend_3b5c31b864970d04197cd420b6c4b0fa_float
        {
        };
        
        void SG_UniversalHeighblend_3b5c31b864970d04197cd420b6c4b0fa_float(float _Vertex_Color, float _Blend_Hardness, float _Use_Layer_1_Height_T, float _Layer_1_Height, float2 _Layer_1_Before_Remap, float _Use_Layer_2_Height_T, float _Layer_2_Height, float2 _Layer_2_Before_Remap, float _Angle_Blend, Bindings_UniversalHeighblend_3b5c31b864970d04197cd420b6c4b0fa_float IN, out float Heightmap_1)
        {
        float _Property_b3ca7054ef0043de85912fc45d997ea2_Out_0_Float = _Vertex_Color;
        float _Clamp_852774a2be524975babf4eeb54af6d64_Out_3_Float;
        Unity_Clamp_float(_Property_b3ca7054ef0043de85912fc45d997ea2_Out_0_Float, float(0), float(1), _Clamp_852774a2be524975babf4eeb54af6d64_Out_3_Float);
        float _OneMinus_85e3550f37814cd3ab5ea5dde7f63a73_Out_1_Float;
        Unity_OneMinus_float(_Clamp_852774a2be524975babf4eeb54af6d64_Out_3_Float, _OneMinus_85e3550f37814cd3ab5ea5dde7f63a73_Out_1_Float);
        float _Comparison_5be6aeaa514b4921b5eb68269b58b028_Out_2_Boolean;
        Unity_Comparison_Greater_float(_OneMinus_85e3550f37814cd3ab5ea5dde7f63a73_Out_1_Float, float(0.99), _Comparison_5be6aeaa514b4921b5eb68269b58b028_Out_2_Boolean);
        float _Property_cfe724908035497c918d6d3f8dafe439_Out_0_Boolean = _Use_Layer_1_Height_T;
        float _Property_9634fd87d3374fdaa60181281a01f9b5_Out_0_Float = _Layer_1_Height;
        float2 _Property_e748f6c127e0479a9a01040378a4129b_Out_0_Vector2 = _Layer_1_Before_Remap;
        float _Split_cde172ab161d44cb81ea7874aec65560_R_1_Float = _Property_e748f6c127e0479a9a01040378a4129b_Out_0_Vector2[0];
        float _Split_cde172ab161d44cb81ea7874aec65560_G_2_Float = _Property_e748f6c127e0479a9a01040378a4129b_Out_0_Vector2[1];
        float _Split_cde172ab161d44cb81ea7874aec65560_B_3_Float = 0;
        float _Split_cde172ab161d44cb81ea7874aec65560_A_4_Float = 0;
        float _Subtract_e1e98a956721410caddfb467ae0eca8b_Out_2_Float;
        Unity_Subtract_float(_Split_cde172ab161d44cb81ea7874aec65560_R_1_Float, _Split_cde172ab161d44cb81ea7874aec65560_G_2_Float, _Subtract_e1e98a956721410caddfb467ae0eca8b_Out_2_Float);
        float _Clamp_ac4097026e6248dbb7a95fe910cc776e_Out_3_Float;
        Unity_Clamp_float(_OneMinus_85e3550f37814cd3ab5ea5dde7f63a73_Out_1_Float, float(0), float(1), _Clamp_ac4097026e6248dbb7a95fe910cc776e_Out_3_Float);
        float _Multiply_41691d316de74fef8a4ab5f63ed5474e_Out_2_Float;
        Unity_Multiply_float_float(_Subtract_e1e98a956721410caddfb467ae0eca8b_Out_2_Float, _Clamp_ac4097026e6248dbb7a95fe910cc776e_Out_3_Float, _Multiply_41691d316de74fef8a4ab5f63ed5474e_Out_2_Float);
        float2 _Add_48d37f8b8a464788860db14f0da8a66e_Out_2_Vector2;
        Unity_Add_float2(_Property_e748f6c127e0479a9a01040378a4129b_Out_0_Vector2, (_Multiply_41691d316de74fef8a4ab5f63ed5474e_Out_2_Float.xx), _Add_48d37f8b8a464788860db14f0da8a66e_Out_2_Vector2);
        float _Remap_21f3372608424df090026adc73778a39_Out_3_Float;
        Unity_Remap_float(_Property_9634fd87d3374fdaa60181281a01f9b5_Out_0_Float, float2 (0, 1), _Add_48d37f8b8a464788860db14f0da8a66e_Out_2_Vector2, _Remap_21f3372608424df090026adc73778a39_Out_3_Float);
        float _Clamp_8ea719b357b44537b42b2d05c22046f6_Out_3_Float;
        Unity_Clamp_float(_Remap_21f3372608424df090026adc73778a39_Out_3_Float, float(0), float(1), _Clamp_8ea719b357b44537b42b2d05c22046f6_Out_3_Float);
        float _Property_457e05a76c034ada998b3ff30a7781c3_Out_0_Boolean = _Use_Layer_2_Height_T;
        float _Property_9dfafa1ca8c94866a52535f412aff89a_Out_0_Float = _Angle_Blend;
        float _Property_b0e4a5720c374e2eb6f203a1bd075243_Out_0_Float = _Layer_2_Height;
        float _Multiply_00b31c7f720343caa4ded6df80a61899_Out_2_Float;
        Unity_Multiply_float_float(_Property_9dfafa1ca8c94866a52535f412aff89a_Out_0_Float, _Property_b0e4a5720c374e2eb6f203a1bd075243_Out_0_Float, _Multiply_00b31c7f720343caa4ded6df80a61899_Out_2_Float);
        float2 _Property_555a7734da754b989d8f80ef0bc86bea_Out_0_Vector2 = _Layer_2_Before_Remap;
        float _Split_bad56a0d03154ccc8cbfb53ea0e381d4_R_1_Float = _Property_555a7734da754b989d8f80ef0bc86bea_Out_0_Vector2[0];
        float _Split_bad56a0d03154ccc8cbfb53ea0e381d4_G_2_Float = _Property_555a7734da754b989d8f80ef0bc86bea_Out_0_Vector2[1];
        float _Split_bad56a0d03154ccc8cbfb53ea0e381d4_B_3_Float = 0;
        float _Split_bad56a0d03154ccc8cbfb53ea0e381d4_A_4_Float = 0;
        float _Subtract_2a7908018c384526a00494520503a83d_Out_2_Float;
        Unity_Subtract_float(_Split_bad56a0d03154ccc8cbfb53ea0e381d4_R_1_Float, _Split_bad56a0d03154ccc8cbfb53ea0e381d4_G_2_Float, _Subtract_2a7908018c384526a00494520503a83d_Out_2_Float);
        float _Multiply_417d72157b5f4930aed43775db746964_Out_2_Float;
        Unity_Multiply_float_float(_Subtract_2a7908018c384526a00494520503a83d_Out_2_Float, _Clamp_ac4097026e6248dbb7a95fe910cc776e_Out_3_Float, _Multiply_417d72157b5f4930aed43775db746964_Out_2_Float);
        float2 _Add_3d7e111e917c44e8a6800ce926fac67d_Out_2_Vector2;
        Unity_Add_float2((_Multiply_417d72157b5f4930aed43775db746964_Out_2_Float.xx), _Property_555a7734da754b989d8f80ef0bc86bea_Out_0_Vector2, _Add_3d7e111e917c44e8a6800ce926fac67d_Out_2_Vector2);
        float _Remap_931f83440e6c4c1588456788f84cbd9a_Out_3_Float;
        Unity_Remap_float(_Multiply_00b31c7f720343caa4ded6df80a61899_Out_2_Float, float2 (0, 1), _Add_3d7e111e917c44e8a6800ce926fac67d_Out_2_Vector2, _Remap_931f83440e6c4c1588456788f84cbd9a_Out_3_Float);
        float _Branch_a840aba5bca34588a2665f9794c96c38_Out_3_Float;
        Unity_Branch_float(_Property_457e05a76c034ada998b3ff30a7781c3_Out_0_Boolean, _Remap_931f83440e6c4c1588456788f84cbd9a_Out_3_Float, _Property_9dfafa1ca8c94866a52535f412aff89a_Out_0_Float, _Branch_a840aba5bca34588a2665f9794c96c38_Out_3_Float);
        float _Clamp_b1fe959daf444bf99c57756b8be77768_Out_3_Float;
        Unity_Clamp_float(_Branch_a840aba5bca34588a2665f9794c96c38_Out_3_Float, float(0), float(1), _Clamp_b1fe959daf444bf99c57756b8be77768_Out_3_Float);
        float _Multiply_c045ae9912ac409b9734c687968d47f6_Out_2_Float;
        Unity_Multiply_float_float(_Clamp_8ea719b357b44537b42b2d05c22046f6_Out_3_Float, _Clamp_b1fe959daf444bf99c57756b8be77768_Out_3_Float, _Multiply_c045ae9912ac409b9734c687968d47f6_Out_2_Float);
        float _Branch_5198cfc0a080466e93cf89aea61886e6_Out_3_Float;
        Unity_Branch_float(_Property_cfe724908035497c918d6d3f8dafe439_Out_0_Boolean, _Multiply_c045ae9912ac409b9734c687968d47f6_Out_2_Float, _Clamp_b1fe959daf444bf99c57756b8be77768_Out_3_Float, _Branch_5198cfc0a080466e93cf89aea61886e6_Out_3_Float);
        float _Saturate_ceafe30b0bae4f45a2f2ec500925b553_Out_1_Float;
        Unity_Saturate_float(_Branch_5198cfc0a080466e93cf89aea61886e6_Out_3_Float, _Saturate_ceafe30b0bae4f45a2f2ec500925b553_Out_1_Float);
        float _Absolute_274083e3f9f645bfb86074d91f3b7c62_Out_1_Float;
        Unity_Absolute_float(_Saturate_ceafe30b0bae4f45a2f2ec500925b553_Out_1_Float, _Absolute_274083e3f9f645bfb86074d91f3b7c62_Out_1_Float);
        float _Property_c68e0b8a84a549a582d4723036344b0e_Out_0_Float = _Blend_Hardness;
        float _Power_c9d62a3092174d9cb5674d87bcb7b5c5_Out_2_Float;
        Unity_Power_float(_Absolute_274083e3f9f645bfb86074d91f3b7c62_Out_1_Float, _Property_c68e0b8a84a549a582d4723036344b0e_Out_0_Float, _Power_c9d62a3092174d9cb5674d87bcb7b5c5_Out_2_Float);
        float _Branch_2425ee869bde4930bb8f36a5273bdc33_Out_3_Float;
        Unity_Branch_float(_Comparison_5be6aeaa514b4921b5eb68269b58b028_Out_2_Boolean, float(0), _Power_c9d62a3092174d9cb5674d87bcb7b5c5_Out_2_Float, _Branch_2425ee869bde4930bb8f36a5273bdc33_Out_3_Float);
        float _Clamp_9a5c5cfe52824e248ea0a8e38c593d84_Out_3_Float;
        Unity_Clamp_float(_Branch_2425ee869bde4930bb8f36a5273bdc33_Out_3_Float, float(0), float(1), _Clamp_9a5c5cfe52824e248ea0a8e38c593d84_Out_3_Float);
        Heightmap_1 = _Clamp_9a5c5cfe52824e248ea0a8e38c593d84_Out_3_Float;
        }
        
        void Unity_Lerp_float4(float4 A, float4 B, float4 T, out float4 Out)
        {
            Out = lerp(A, B, T);
        }
        
        void Unity_Clamp_float4(float4 In, float4 Min, float4 Max, out float4 Out)
        {
            Out = clamp(In, Min, Max);
        }
        
        // Custom interpolators pre vertex
        /* WARNING: $splice Could not find named fragment 'CustomInterpolatorPreVertex' */
        
        // Graph Vertex
        struct VertexDescription
        {
            float3 Position;
            float3 Normal;
            float3 Tangent;
        };
        
        VertexDescription VertexDescriptionFunction(VertexDescriptionInputs IN)
        {
            VertexDescription description = (VertexDescription)0;
            description.Position = IN.ObjectSpacePosition;
            description.Normal = IN.ObjectSpaceNormal;
            description.Tangent = IN.ObjectSpaceTangent;
            return description;
        }
        
        // Custom interpolators, pre surface
        #ifdef FEATURES_GRAPH_VERTEX
        Varyings CustomInterpolatorPassThroughFunc(inout Varyings output, VertexDescription input)
        {
        return output;
        }
        #define CUSTOMINTERPOLATOR_VARYPASSTHROUGH_FUNC
        #endif
        
        // Graph Pixel
        struct SurfaceDescription
        {
            float3 BaseColor;
            float Alpha;
            float AlphaClipThreshold;
        };
        
        SurfaceDescription SurfaceDescriptionFunction(SurfaceDescriptionInputs IN)
        {
            SurfaceDescription surface = (SurfaceDescription)0;
            UnityTexture2D _Property_821e07b38fd0a08d85c4dd6e5b6bbac9_Out_0_Texture2D = UnityBuildTexture2DStructNoScale(_BaseColorMap);
            float4 _Property_8ec0d512145619859d288abab740e3bf_Out_0_Vector4 = _BaseTilingOffset;
            float _Property_122c0f9ef0a1c4818a140c75e512abe4_Out_0_Boolean = _BaseUsePlanarUV;
            Bindings_PlanarNM_c0f081da9c567704ea36e7dd38cedcf6_float _PlanarNM_cb7ded32e6af3382bbe06b62977afab6;
            _PlanarNM_cb7ded32e6af3382bbe06b62977afab6.AbsoluteWorldSpacePosition = IN.AbsoluteWorldSpacePosition;
            _PlanarNM_cb7ded32e6af3382bbe06b62977afab6.uv0 = IN.uv0;
            _PlanarNM_cb7ded32e6af3382bbe06b62977afab6.uv3 = IN.uv3;
            float4 _PlanarNM_cb7ded32e6af3382bbe06b62977afab6_XZ_2_Vector4;
            SG_PlanarNM_c0f081da9c567704ea36e7dd38cedcf6_float(_Property_821e07b38fd0a08d85c4dd6e5b6bbac9_Out_0_Texture2D, _Property_8ec0d512145619859d288abab740e3bf_Out_0_Vector4, _Property_122c0f9ef0a1c4818a140c75e512abe4_Out_0_Boolean, UnityBuildSamplerStateStruct(SamplerState_Linear_Repeat_Aniso8), 1, _PlanarNM_cb7ded32e6af3382bbe06b62977afab6, _PlanarNM_cb7ded32e6af3382bbe06b62977afab6_XZ_2_Vector4);
            float4 _Property_41859d117584758eb8002ecc938f9bce_Out_0_Vector4 = _BaseColor;
            float4 _Multiply_4d0f82599060228a9092027fd43912c8_Out_2_Vector4;
            Unity_Multiply_float4_float4(_PlanarNM_cb7ded32e6af3382bbe06b62977afab6_XZ_2_Vector4, _Property_41859d117584758eb8002ecc938f9bce_Out_0_Vector4, _Multiply_4d0f82599060228a9092027fd43912c8_Out_2_Vector4);
            float3 _ColorspaceConversion_30c5042ef70343cd92056cde73cd3ecb_Out_1_Vector3;
            Unity_ColorspaceConversion_Linear_RGB_float((_Multiply_4d0f82599060228a9092027fd43912c8_Out_2_Vector4.xyz), _ColorspaceConversion_30c5042ef70343cd92056cde73cd3ecb_Out_1_Vector3);
            UnityTexture2D _Property_50403cc6b1e3998a82afc21c6a6332ae_Out_0_Texture2D = UnityBuildTexture2DStructNoScale(_DetailMap);
            float4 _Property_256e5676e1089881ae3214634430b140_Out_0_Vector4 = _DetailTilingOffset;
            float _Split_257d0b6ea953418d97fd7daa8128bf35_R_1_Float = _Property_256e5676e1089881ae3214634430b140_Out_0_Vector4[0];
            float _Split_257d0b6ea953418d97fd7daa8128bf35_G_2_Float = _Property_256e5676e1089881ae3214634430b140_Out_0_Vector4[1];
            float _Split_257d0b6ea953418d97fd7daa8128bf35_B_3_Float = _Property_256e5676e1089881ae3214634430b140_Out_0_Vector4[2];
            float _Split_257d0b6ea953418d97fd7daa8128bf35_A_4_Float = _Property_256e5676e1089881ae3214634430b140_Out_0_Vector4[3];
            float2 _Vector2_98295494172421878c7a16cb2baddf9a_Out_0_Vector2 = float2(_Split_257d0b6ea953418d97fd7daa8128bf35_R_1_Float, _Split_257d0b6ea953418d97fd7daa8128bf35_G_2_Float);
            float2 _Vector2_130e8faa59837a81a7506636fcb30b8a_Out_0_Vector2 = float2(_Split_257d0b6ea953418d97fd7daa8128bf35_B_3_Float, _Split_257d0b6ea953418d97fd7daa8128bf35_A_4_Float);
            float2 _TilingAndOffset_1dfb2b4859ec3680ad3a74cf8f1bc17b_Out_3_Vector2;
            Unity_TilingAndOffset_float(IN.uv0.xy, _Vector2_98295494172421878c7a16cb2baddf9a_Out_0_Vector2, _Vector2_130e8faa59837a81a7506636fcb30b8a_Out_0_Vector2, _TilingAndOffset_1dfb2b4859ec3680ad3a74cf8f1bc17b_Out_3_Vector2);
            float4 _SampleTexture2D_d8eb0186b9a0cd819cde65431b4ea5ea_RGBA_0_Vector4 = SAMPLE_TEXTURE2D(_Property_50403cc6b1e3998a82afc21c6a6332ae_Out_0_Texture2D.tex, UnityBuildSamplerStateStruct(SamplerState_Linear_Repeat_Aniso8).samplerstate, _Property_50403cc6b1e3998a82afc21c6a6332ae_Out_0_Texture2D.GetTransformedUV(_TilingAndOffset_1dfb2b4859ec3680ad3a74cf8f1bc17b_Out_3_Vector2) );
            float _SampleTexture2D_d8eb0186b9a0cd819cde65431b4ea5ea_R_4_Float = _SampleTexture2D_d8eb0186b9a0cd819cde65431b4ea5ea_RGBA_0_Vector4.r;
            float _SampleTexture2D_d8eb0186b9a0cd819cde65431b4ea5ea_G_5_Float = _SampleTexture2D_d8eb0186b9a0cd819cde65431b4ea5ea_RGBA_0_Vector4.g;
            float _SampleTexture2D_d8eb0186b9a0cd819cde65431b4ea5ea_B_6_Float = _SampleTexture2D_d8eb0186b9a0cd819cde65431b4ea5ea_RGBA_0_Vector4.b;
            float _SampleTexture2D_d8eb0186b9a0cd819cde65431b4ea5ea_A_7_Float = _SampleTexture2D_d8eb0186b9a0cd819cde65431b4ea5ea_RGBA_0_Vector4.a;
            float _Property_605f29777330a58ba88ac032e905433b_Out_0_Float = _DetailAlbedoScale;
            float3 _Blend_de85bf99257f4eb7bb321fd973539f10_Out_2_Vector3;
            Unity_Blend_Overlay_float3(_ColorspaceConversion_30c5042ef70343cd92056cde73cd3ecb_Out_1_Vector3, (_SampleTexture2D_d8eb0186b9a0cd819cde65431b4ea5ea_R_4_Float.xxx), _Blend_de85bf99257f4eb7bb321fd973539f10_Out_2_Vector3, _Property_605f29777330a58ba88ac032e905433b_Out_0_Float);
            float3 _ColorspaceConversion_635670d250654503b34efa53a99ba43e_Out_1_Vector3;
            Unity_ColorspaceConversion_RGB_Linear_float(_Blend_de85bf99257f4eb7bb321fd973539f10_Out_2_Vector3, _ColorspaceConversion_635670d250654503b34efa53a99ba43e_Out_1_Vector3);
            float3 _Clamp_8913f48f801c43c2879f2e1ce926507e_Out_3_Vector3;
            Unity_Clamp_float3(_ColorspaceConversion_635670d250654503b34efa53a99ba43e_Out_1_Vector3, float3(0, 0, 0), float3(1, 1, 1), _Clamp_8913f48f801c43c2879f2e1ce926507e_Out_3_Vector3);
            float _Split_ddfe447fbb7845e88cc5cfb8158b2248_R_1_Float = _Clamp_8913f48f801c43c2879f2e1ce926507e_Out_3_Vector3[0];
            float _Split_ddfe447fbb7845e88cc5cfb8158b2248_G_2_Float = _Clamp_8913f48f801c43c2879f2e1ce926507e_Out_3_Vector3[1];
            float _Split_ddfe447fbb7845e88cc5cfb8158b2248_B_3_Float = _Clamp_8913f48f801c43c2879f2e1ce926507e_Out_3_Vector3[2];
            float _Split_ddfe447fbb7845e88cc5cfb8158b2248_A_4_Float = 0;
            float _Split_6d7debfd2b20440e932d58108f8e7f75_R_1_Float = _Multiply_4d0f82599060228a9092027fd43912c8_Out_2_Vector4[0];
            float _Split_6d7debfd2b20440e932d58108f8e7f75_G_2_Float = _Multiply_4d0f82599060228a9092027fd43912c8_Out_2_Vector4[1];
            float _Split_6d7debfd2b20440e932d58108f8e7f75_B_3_Float = _Multiply_4d0f82599060228a9092027fd43912c8_Out_2_Vector4[2];
            float _Split_6d7debfd2b20440e932d58108f8e7f75_A_4_Float = _Multiply_4d0f82599060228a9092027fd43912c8_Out_2_Vector4[3];
            float4 _Combine_b0f28916143e4b94af6bec53f5328b52_RGBA_4_Vector4;
            float3 _Combine_b0f28916143e4b94af6bec53f5328b52_RGB_5_Vector3;
            float2 _Combine_b0f28916143e4b94af6bec53f5328b52_RG_6_Vector2;
            Unity_Combine_float(_Split_ddfe447fbb7845e88cc5cfb8158b2248_R_1_Float, _Split_ddfe447fbb7845e88cc5cfb8158b2248_G_2_Float, _Split_ddfe447fbb7845e88cc5cfb8158b2248_B_3_Float, _Split_6d7debfd2b20440e932d58108f8e7f75_A_4_Float, _Combine_b0f28916143e4b94af6bec53f5328b52_RGBA_4_Vector4, _Combine_b0f28916143e4b94af6bec53f5328b52_RGB_5_Vector3, _Combine_b0f28916143e4b94af6bec53f5328b52_RG_6_Vector2);
            UnityTexture2D _Property_a155ddc33ed90685a5ab0edcf158a343_Out_0_Texture2D = UnityBuildTexture2DStructNoScale(_CoverBaseColorMap);
            float4 _Property_256beda96caf2d8aa05d3de41fc08d3d_Out_0_Vector4 = _CoverTilingOffset;
            float _Property_bd9dfe8dd615798f9f2d72d139e56d61_Out_0_Boolean = _CoverUsePlanarUV;
            Bindings_PlanarNM_c0f081da9c567704ea36e7dd38cedcf6_float _PlanarNM_e00e057d3d7c4181b1c7775c6ebbab5b;
            _PlanarNM_e00e057d3d7c4181b1c7775c6ebbab5b.AbsoluteWorldSpacePosition = IN.AbsoluteWorldSpacePosition;
            _PlanarNM_e00e057d3d7c4181b1c7775c6ebbab5b.uv0 = IN.uv0;
            _PlanarNM_e00e057d3d7c4181b1c7775c6ebbab5b.uv3 = IN.uv3;
            float4 _PlanarNM_e00e057d3d7c4181b1c7775c6ebbab5b_XZ_2_Vector4;
            SG_PlanarNM_c0f081da9c567704ea36e7dd38cedcf6_float(_Property_a155ddc33ed90685a5ab0edcf158a343_Out_0_Texture2D, _Property_256beda96caf2d8aa05d3de41fc08d3d_Out_0_Vector4, _Property_bd9dfe8dd615798f9f2d72d139e56d61_Out_0_Boolean, UnityBuildSamplerStateStruct(SamplerState_Linear_Repeat_Aniso8), 1, _PlanarNM_e00e057d3d7c4181b1c7775c6ebbab5b, _PlanarNM_e00e057d3d7c4181b1c7775c6ebbab5b_XZ_2_Vector4);
            float4 _Property_c3be5593fd661b8dafbd04f26b8ec9ac_Out_0_Vector4 = _CoverBaseColor;
            float4 _Multiply_b08794693505bd8e8c04b9ba1610d394_Out_2_Vector4;
            Unity_Multiply_float4_float4(_PlanarNM_e00e057d3d7c4181b1c7775c6ebbab5b_XZ_2_Vector4, _Property_c3be5593fd661b8dafbd04f26b8ec9ac_Out_0_Vector4, _Multiply_b08794693505bd8e8c04b9ba1610d394_Out_2_Vector4);
            float _Split_a80936a3c75945efb8cf9f2b95c76642_R_1_Float = IN.VertexColor[0];
            float _Split_a80936a3c75945efb8cf9f2b95c76642_G_2_Float = IN.VertexColor[1];
            float _Split_a80936a3c75945efb8cf9f2b95c76642_B_3_Float = IN.VertexColor[2];
            float _Split_a80936a3c75945efb8cf9f2b95c76642_A_4_Float = IN.VertexColor[3];
            float _Property_14a6757619d64822a44a69b34f85276d_Out_0_Float = _VertexColorGBlendStrenght;
            float _Property_c0d9ffba7dee497c885a54170977d874_Out_0_Boolean = _USEBaseHeightT;
            UnityTexture2D _Property_bb9b47702e64ec8c8d8ad011fd521576_Out_0_Texture2D = UnityBuildTexture2DStructNoScale(_BaseMaskMap);
            Bindings_PlanarNM_c0f081da9c567704ea36e7dd38cedcf6_float _PlanarNM_e51306c84cde8e84a1fb06a45d8d037f;
            _PlanarNM_e51306c84cde8e84a1fb06a45d8d037f.AbsoluteWorldSpacePosition = IN.AbsoluteWorldSpacePosition;
            _PlanarNM_e51306c84cde8e84a1fb06a45d8d037f.uv0 = IN.uv0;
            _PlanarNM_e51306c84cde8e84a1fb06a45d8d037f.uv3 = IN.uv3;
            float4 _PlanarNM_e51306c84cde8e84a1fb06a45d8d037f_XZ_2_Vector4;
            SG_PlanarNM_c0f081da9c567704ea36e7dd38cedcf6_float(_Property_bb9b47702e64ec8c8d8ad011fd521576_Out_0_Texture2D, _Property_8ec0d512145619859d288abab740e3bf_Out_0_Vector4, _Property_122c0f9ef0a1c4818a140c75e512abe4_Out_0_Boolean, UnityBuildSamplerStateStruct(SamplerState_Linear_Repeat_Aniso8), 1, _PlanarNM_e51306c84cde8e84a1fb06a45d8d037f, _PlanarNM_e51306c84cde8e84a1fb06a45d8d037f_XZ_2_Vector4);
            float _Split_218e1cfd00b30984921b5fc0ec63de60_R_1_Float = _PlanarNM_e51306c84cde8e84a1fb06a45d8d037f_XZ_2_Vector4[0];
            float _Split_218e1cfd00b30984921b5fc0ec63de60_G_2_Float = _PlanarNM_e51306c84cde8e84a1fb06a45d8d037f_XZ_2_Vector4[1];
            float _Split_218e1cfd00b30984921b5fc0ec63de60_B_3_Float = _PlanarNM_e51306c84cde8e84a1fb06a45d8d037f_XZ_2_Vector4[2];
            float _Split_218e1cfd00b30984921b5fc0ec63de60_A_4_Float = _PlanarNM_e51306c84cde8e84a1fb06a45d8d037f_XZ_2_Vector4[3];
            float _Property_1d4a1a93707b42c3abf0baa799c514e5_Out_0_Float = _HeightMin;
            float _Property_8f4f3606868d4028a34c2a9a5a59f99d_Out_0_Float = _HeightMax;
            float2 _Vector2_721b6f4d7077463490b4504fe6c940bf_Out_0_Vector2 = float2(_Property_1d4a1a93707b42c3abf0baa799c514e5_Out_0_Float, _Property_8f4f3606868d4028a34c2a9a5a59f99d_Out_0_Float);
            float _Property_a1ae2f61da87421b9f3839691e9dd8af_Out_0_Float = _HeightOffset;
            float2 _Add_1f9ea9bdf36544b59f763806e7eea80d_Out_2_Vector2;
            Unity_Add_float2(_Vector2_721b6f4d7077463490b4504fe6c940bf_Out_0_Vector2, (_Property_a1ae2f61da87421b9f3839691e9dd8af_Out_0_Float.xx), _Add_1f9ea9bdf36544b59f763806e7eea80d_Out_2_Vector2);
            float _Property_0fbef18600294e199eeda9905e3304e4_Out_0_Boolean = _USECoverHeightT;
            UnityTexture2D _Property_3702de305e11e085a40d7731b582d541_Out_0_Texture2D = UnityBuildTexture2DStructNoScale(_CoverMaskMap);
            Bindings_PlanarNM_c0f081da9c567704ea36e7dd38cedcf6_float _PlanarNM_2217ca3c12141a8cb1e0c7235b369601;
            _PlanarNM_2217ca3c12141a8cb1e0c7235b369601.AbsoluteWorldSpacePosition = IN.AbsoluteWorldSpacePosition;
            _PlanarNM_2217ca3c12141a8cb1e0c7235b369601.uv0 = IN.uv0;
            _PlanarNM_2217ca3c12141a8cb1e0c7235b369601.uv3 = IN.uv3;
            float4 _PlanarNM_2217ca3c12141a8cb1e0c7235b369601_XZ_2_Vector4;
            SG_PlanarNM_c0f081da9c567704ea36e7dd38cedcf6_float(_Property_3702de305e11e085a40d7731b582d541_Out_0_Texture2D, _Property_256beda96caf2d8aa05d3de41fc08d3d_Out_0_Vector4, _Property_bd9dfe8dd615798f9f2d72d139e56d61_Out_0_Boolean, UnityBuildSamplerStateStruct(SamplerState_Linear_Repeat_Aniso8), 1, _PlanarNM_2217ca3c12141a8cb1e0c7235b369601, _PlanarNM_2217ca3c12141a8cb1e0c7235b369601_XZ_2_Vector4);
            float _Split_2f45bca363698c859e51492899bc58f8_R_1_Float = _PlanarNM_2217ca3c12141a8cb1e0c7235b369601_XZ_2_Vector4[0];
            float _Split_2f45bca363698c859e51492899bc58f8_G_2_Float = _PlanarNM_2217ca3c12141a8cb1e0c7235b369601_XZ_2_Vector4[1];
            float _Split_2f45bca363698c859e51492899bc58f8_B_3_Float = _PlanarNM_2217ca3c12141a8cb1e0c7235b369601_XZ_2_Vector4[2];
            float _Split_2f45bca363698c859e51492899bc58f8_A_4_Float = _PlanarNM_2217ca3c12141a8cb1e0c7235b369601_XZ_2_Vector4[3];
            float _Property_32b48052fdbb4641bf4eeb294bc65050_Out_0_Float = _CoverHeightMapMin;
            float _Property_0e120eb0a0a14b12a31a3c1f5b961121_Out_0_Float = _CoverHeightMapMax;
            float2 _Vector2_6955747f7f0a4ff98fae60dbada25e89_Out_0_Vector2 = float2(_Property_32b48052fdbb4641bf4eeb294bc65050_Out_0_Float, _Property_0e120eb0a0a14b12a31a3c1f5b961121_Out_0_Float);
            float _Property_6b467710b0ba48058e003aebe9119249_Out_0_Float = _CoverHeightMapOffset;
            float2 _Add_28628d641d58481084e9c00e4ad5fc8d_Out_2_Vector2;
            Unity_Add_float2(_Vector2_6955747f7f0a4ff98fae60dbada25e89_Out_0_Vector2, (_Property_6b467710b0ba48058e003aebe9119249_Out_0_Float.xx), _Add_28628d641d58481084e9c00e4ad5fc8d_Out_2_Vector2);
            UnityTexture2D _Property_7bea2d9dd5651a8bbbd61ecde71faa54_Out_0_Texture2D = UnityBuildTexture2DStructNoScale(_Masks);
            float4 _UV_429c95affe88aa8694076115c99a0769_Out_0_Vector4 = IN.uv0;
            float4 _SampleTexture2D_2723da80b8a2528381ef199c0415beae_RGBA_0_Vector4 = SAMPLE_TEXTURE2D(_Property_7bea2d9dd5651a8bbbd61ecde71faa54_Out_0_Texture2D.tex, UnityBuildSamplerStateStruct(SamplerState_Linear_Repeat_Aniso8).samplerstate, _Property_7bea2d9dd5651a8bbbd61ecde71faa54_Out_0_Texture2D.GetTransformedUV((_UV_429c95affe88aa8694076115c99a0769_Out_0_Vector4.xy)) );
            float _SampleTexture2D_2723da80b8a2528381ef199c0415beae_R_4_Float = _SampleTexture2D_2723da80b8a2528381ef199c0415beae_RGBA_0_Vector4.r;
            float _SampleTexture2D_2723da80b8a2528381ef199c0415beae_G_5_Float = _SampleTexture2D_2723da80b8a2528381ef199c0415beae_RGBA_0_Vector4.g;
            float _SampleTexture2D_2723da80b8a2528381ef199c0415beae_B_6_Float = _SampleTexture2D_2723da80b8a2528381ef199c0415beae_RGBA_0_Vector4.b;
            float _SampleTexture2D_2723da80b8a2528381ef199c0415beae_A_7_Float = _SampleTexture2D_2723da80b8a2528381ef199c0415beae_RGBA_0_Vector4.a;
            float _Property_7bea2851849541b28a2bc695d39a7606_Out_0_Float = _Cover_Mask_A_Remap_Min;
            float _Property_3be0ae138e414a5cb43d60264b1bcfeb_Out_0_Float = _Cover_Mask_A_Remap_Max;
            float2 _Vector2_44ac029de1e440a799fbdfadc778af0c_Out_0_Vector2 = float2(_Property_7bea2851849541b28a2bc695d39a7606_Out_0_Float, _Property_3be0ae138e414a5cb43d60264b1bcfeb_Out_0_Float);
            float _Remap_0c551a3055a54f16b85b519194883552_Out_3_Float;
            Unity_Remap_float(_SampleTexture2D_2723da80b8a2528381ef199c0415beae_A_7_Float, float2 (0, 1), _Vector2_44ac029de1e440a799fbdfadc778af0c_Out_0_Vector2, _Remap_0c551a3055a54f16b85b519194883552_Out_3_Float);
            float _Clamp_bb1427696ce14fe987f799fecc5f9fac_Out_3_Float;
            Unity_Clamp_float(_Remap_0c551a3055a54f16b85b519194883552_Out_3_Float, float(0), float(1), _Clamp_bb1427696ce14fe987f799fecc5f9fac_Out_3_Float);
            float2 _Vector2_0d28074858599a88940dfc8b57b9a60f_Out_0_Vector2 = float2(_SampleTexture2D_d8eb0186b9a0cd819cde65431b4ea5ea_A_7_Float, _SampleTexture2D_d8eb0186b9a0cd819cde65431b4ea5ea_G_5_Float);
            float2 _Multiply_fac8d94f82a53486bc0142a1e64b3d32_Out_2_Vector2;
            Unity_Multiply_float2_float2(_Vector2_0d28074858599a88940dfc8b57b9a60f_Out_0_Vector2, float2(2, 2), _Multiply_fac8d94f82a53486bc0142a1e64b3d32_Out_2_Vector2);
            float2 _Add_f0e6e847d8d8798ab3ca8c4d878bafc0_Out_2_Vector2;
            Unity_Add_float2(_Multiply_fac8d94f82a53486bc0142a1e64b3d32_Out_2_Vector2, float2(-1, -1), _Add_f0e6e847d8d8798ab3ca8c4d878bafc0_Out_2_Vector2);
            float _Property_d0e8d8f7fd10f0829e8fd86c278c8226_Out_0_Float = _DetailNormalScale;
            float2 _Multiply_11f3dfc5283ea188ad9c83e552cf7e0f_Out_2_Vector2;
            Unity_Multiply_float2_float2(_Add_f0e6e847d8d8798ab3ca8c4d878bafc0_Out_2_Vector2, (_Property_d0e8d8f7fd10f0829e8fd86c278c8226_Out_0_Float.xx), _Multiply_11f3dfc5283ea188ad9c83e552cf7e0f_Out_2_Vector2);
            float _Split_c4822b8eaff9b185be7c059792345712_R_1_Float = _Multiply_11f3dfc5283ea188ad9c83e552cf7e0f_Out_2_Vector2[0];
            float _Split_c4822b8eaff9b185be7c059792345712_G_2_Float = _Multiply_11f3dfc5283ea188ad9c83e552cf7e0f_Out_2_Vector2[1];
            float _Split_c4822b8eaff9b185be7c059792345712_B_3_Float = 0;
            float _Split_c4822b8eaff9b185be7c059792345712_A_4_Float = 0;
            float _DotProduct_1a01939a143c548c8ccd7e8a04fe680d_Out_2_Float;
            Unity_DotProduct_float2(_Multiply_11f3dfc5283ea188ad9c83e552cf7e0f_Out_2_Vector2, _Multiply_11f3dfc5283ea188ad9c83e552cf7e0f_Out_2_Vector2, _DotProduct_1a01939a143c548c8ccd7e8a04fe680d_Out_2_Float);
            float _Saturate_bf3d57899db77f86a1689105ce6a373a_Out_1_Float;
            Unity_Saturate_float(_DotProduct_1a01939a143c548c8ccd7e8a04fe680d_Out_2_Float, _Saturate_bf3d57899db77f86a1689105ce6a373a_Out_1_Float);
            float _OneMinus_052960238cc4a18cb83109d2bcae6d09_Out_1_Float;
            Unity_OneMinus_float(_Saturate_bf3d57899db77f86a1689105ce6a373a_Out_1_Float, _OneMinus_052960238cc4a18cb83109d2bcae6d09_Out_1_Float);
            float _SquareRoot_d4f67288e4dbf5898bea492a70b89ab9_Out_1_Float;
            Unity_SquareRoot_float(_OneMinus_052960238cc4a18cb83109d2bcae6d09_Out_1_Float, _SquareRoot_d4f67288e4dbf5898bea492a70b89ab9_Out_1_Float);
            float3 _Vector3_1e56146bdd567884bb8d5ae769df4d29_Out_0_Vector3 = float3(_Split_c4822b8eaff9b185be7c059792345712_R_1_Float, _Split_c4822b8eaff9b185be7c059792345712_G_2_Float, _SquareRoot_d4f67288e4dbf5898bea492a70b89ab9_Out_1_Float);
            UnityTexture2D _Property_147b07430832c98eb0a470557ee61c5e_Out_0_Texture2D = UnityBuildTexture2DStructNoScale(_BaseNormalMap);
            Bindings_PlanarNMn_1b93a87456f9d4c419321d0cd92bd6c8_float _PlanarNMn_ecad9f1f260c6c8bbd0960b2a8976daf;
            _PlanarNMn_ecad9f1f260c6c8bbd0960b2a8976daf.WorldSpaceNormal = IN.WorldSpaceNormal;
            _PlanarNMn_ecad9f1f260c6c8bbd0960b2a8976daf.WorldSpaceTangent = IN.WorldSpaceTangent;
            _PlanarNMn_ecad9f1f260c6c8bbd0960b2a8976daf.WorldSpaceBiTangent = IN.WorldSpaceBiTangent;
            _PlanarNMn_ecad9f1f260c6c8bbd0960b2a8976daf.AbsoluteWorldSpacePosition = IN.AbsoluteWorldSpacePosition;
            _PlanarNMn_ecad9f1f260c6c8bbd0960b2a8976daf.uv0 = IN.uv0;
            _PlanarNMn_ecad9f1f260c6c8bbd0960b2a8976daf.uv3 = IN.uv3;
            float4 _PlanarNMn_ecad9f1f260c6c8bbd0960b2a8976daf_XZ_2_Vector4;
            SG_PlanarNMn_1b93a87456f9d4c419321d0cd92bd6c8_float(_Property_147b07430832c98eb0a470557ee61c5e_Out_0_Texture2D, _Property_8ec0d512145619859d288abab740e3bf_Out_0_Vector4, _Property_122c0f9ef0a1c4818a140c75e512abe4_Out_0_Boolean, UnityBuildSamplerStateStruct(SamplerState_Linear_Repeat_Aniso8), 1, _PlanarNMn_ecad9f1f260c6c8bbd0960b2a8976daf, _PlanarNMn_ecad9f1f260c6c8bbd0960b2a8976daf_XZ_2_Vector4);
            float _Property_72e436a108ad64868e46d548c585c5f3_Out_0_Float = _BaseNormalScale;
            float3 _NormalStrength_366affc5c8b42482a633d201ef52b9d6_Out_2_Vector3;
            Unity_NormalStrength_float((_PlanarNMn_ecad9f1f260c6c8bbd0960b2a8976daf_XZ_2_Vector4.xyz), _Property_72e436a108ad64868e46d548c585c5f3_Out_0_Float, _NormalStrength_366affc5c8b42482a633d201ef52b9d6_Out_2_Vector3);
            float3 _NormalBlend_9f531c87e2e45580b1d0f65f06c23526_Out_2_Vector3;
            Unity_NormalBlend_Reoriented_float(_Vector3_1e56146bdd567884bb8d5ae769df4d29_Out_0_Vector3, _NormalStrength_366affc5c8b42482a633d201ef52b9d6_Out_2_Vector3, _NormalBlend_9f531c87e2e45580b1d0f65f06c23526_Out_2_Vector3);
            UnityTexture2D _Property_d7e9139e0ac6718b89c610009c28a25a_Out_0_Texture2D = UnityBuildTexture2DStructNoScale(_CoverNormalMap);
            Bindings_PlanarNMn_1b93a87456f9d4c419321d0cd92bd6c8_float _PlanarNMn_690e893d26999680a5cea3604ed0ce16;
            _PlanarNMn_690e893d26999680a5cea3604ed0ce16.WorldSpaceNormal = IN.WorldSpaceNormal;
            _PlanarNMn_690e893d26999680a5cea3604ed0ce16.WorldSpaceTangent = IN.WorldSpaceTangent;
            _PlanarNMn_690e893d26999680a5cea3604ed0ce16.WorldSpaceBiTangent = IN.WorldSpaceBiTangent;
            _PlanarNMn_690e893d26999680a5cea3604ed0ce16.AbsoluteWorldSpacePosition = IN.AbsoluteWorldSpacePosition;
            _PlanarNMn_690e893d26999680a5cea3604ed0ce16.uv0 = IN.uv0;
            _PlanarNMn_690e893d26999680a5cea3604ed0ce16.uv3 = IN.uv3;
            float4 _PlanarNMn_690e893d26999680a5cea3604ed0ce16_XZ_2_Vector4;
            SG_PlanarNMn_1b93a87456f9d4c419321d0cd92bd6c8_float(_Property_d7e9139e0ac6718b89c610009c28a25a_Out_0_Texture2D, _Property_256beda96caf2d8aa05d3de41fc08d3d_Out_0_Vector4, _Property_bd9dfe8dd615798f9f2d72d139e56d61_Out_0_Boolean, UnityBuildSamplerStateStruct(SamplerState_Linear_Repeat_Aniso8), 1, _PlanarNMn_690e893d26999680a5cea3604ed0ce16, _PlanarNMn_690e893d26999680a5cea3604ed0ce16_XZ_2_Vector4);
            float _Property_0fd4d87ded104c829a6110c044eaa5f2_Out_0_Float = _CoverNormalBlendHardness;
            float3 _NormalStrength_c4639a6dd3dfde85b591971db2700eaf_Out_2_Vector3;
            Unity_NormalStrength_float((_PlanarNMn_690e893d26999680a5cea3604ed0ce16_XZ_2_Vector4.xyz), _Property_0fd4d87ded104c829a6110c044eaa5f2_Out_0_Float, _NormalStrength_c4639a6dd3dfde85b591971db2700eaf_Out_2_Vector3);
            float _Split_8ff22a6bdd437780ac7ea5963e1c5bb4_R_1_Float = IN.WorldSpaceNormal[0];
            float _Split_8ff22a6bdd437780ac7ea5963e1c5bb4_G_2_Float = IN.WorldSpaceNormal[1];
            float _Split_8ff22a6bdd437780ac7ea5963e1c5bb4_B_3_Float = IN.WorldSpaceNormal[2];
            float _Split_8ff22a6bdd437780ac7ea5963e1c5bb4_A_4_Float = 0;
            float _Property_28052b023ac35c8e9a95b30327681cc5_Out_0_Float = _Cover_Amount;
            float _Property_7749c0d5b28c14869ab3ba35d226788b_Out_0_Float = _Cover_Amount_Grow_Speed;
            float _Subtract_e5dc2afce7ff588fa1d4c91f78de7575_Out_2_Float;
            Unity_Subtract_float(float(4), _Property_7749c0d5b28c14869ab3ba35d226788b_Out_0_Float, _Subtract_e5dc2afce7ff588fa1d4c91f78de7575_Out_2_Float);
            float _Divide_c77b003bf1ce13828c94a705676e2b30_Out_2_Float;
            Unity_Divide_float(_Property_28052b023ac35c8e9a95b30327681cc5_Out_0_Float, _Subtract_e5dc2afce7ff588fa1d4c91f78de7575_Out_2_Float, _Divide_c77b003bf1ce13828c94a705676e2b30_Out_2_Float);
            float _Absolute_c7499cf07bdd0582abd82adbf367b0fc_Out_1_Float;
            Unity_Absolute_float(_Divide_c77b003bf1ce13828c94a705676e2b30_Out_2_Float, _Absolute_c7499cf07bdd0582abd82adbf367b0fc_Out_1_Float);
            float _Power_a9431dbce44a528f9ee7095adfa10556_Out_2_Float;
            Unity_Power_float(_Absolute_c7499cf07bdd0582abd82adbf367b0fc_Out_1_Float, _Subtract_e5dc2afce7ff588fa1d4c91f78de7575_Out_2_Float, _Power_a9431dbce44a528f9ee7095adfa10556_Out_2_Float);
            float _Clamp_815ffdd53cc1c889aa00f73784cb71e7_Out_3_Float;
            Unity_Clamp_float(_Power_a9431dbce44a528f9ee7095adfa10556_Out_2_Float, float(0), float(2), _Clamp_815ffdd53cc1c889aa00f73784cb71e7_Out_3_Float);
            float _Multiply_143da4886728ff868f10e9cfa6940ea0_Out_2_Float;
            Unity_Multiply_float_float(_Split_8ff22a6bdd437780ac7ea5963e1c5bb4_G_2_Float, _Clamp_815ffdd53cc1c889aa00f73784cb71e7_Out_3_Float, _Multiply_143da4886728ff868f10e9cfa6940ea0_Out_2_Float);
            float _Saturate_04686ab19029f68c8fb9e7a115b207b1_Out_1_Float;
            Unity_Saturate_float(_Multiply_143da4886728ff868f10e9cfa6940ea0_Out_2_Float, _Saturate_04686ab19029f68c8fb9e7a115b207b1_Out_1_Float);
            float _Clamp_9c0a88ffc7be288cbe97d3e13a014fe8_Out_3_Float;
            Unity_Clamp_float(_Split_8ff22a6bdd437780ac7ea5963e1c5bb4_G_2_Float, float(0), float(0.9999), _Clamp_9c0a88ffc7be288cbe97d3e13a014fe8_Out_3_Float);
            float _Property_58f42b34c7f0728f8c98e00a3e3a5726_Out_0_Float = _Cover_Max_Angle;
            float _Divide_b785767ecc1928889893fa60eac4e5fb_Out_2_Float;
            Unity_Divide_float(_Property_58f42b34c7f0728f8c98e00a3e3a5726_Out_0_Float, float(45), _Divide_b785767ecc1928889893fa60eac4e5fb_Out_2_Float);
            float _OneMinus_8e6f5b1570dc8c8b8afb036328281675_Out_1_Float;
            Unity_OneMinus_float(_Divide_b785767ecc1928889893fa60eac4e5fb_Out_2_Float, _OneMinus_8e6f5b1570dc8c8b8afb036328281675_Out_1_Float);
            float _Subtract_5348fb3702fea78d9ee10dbf81ede29c_Out_2_Float;
            Unity_Subtract_float(_Clamp_9c0a88ffc7be288cbe97d3e13a014fe8_Out_3_Float, _OneMinus_8e6f5b1570dc8c8b8afb036328281675_Out_1_Float, _Subtract_5348fb3702fea78d9ee10dbf81ede29c_Out_2_Float);
            float _Clamp_2b888688983edd82ac250226d9378893_Out_3_Float;
            Unity_Clamp_float(_Subtract_5348fb3702fea78d9ee10dbf81ede29c_Out_2_Float, float(0), float(2), _Clamp_2b888688983edd82ac250226d9378893_Out_3_Float);
            float _Divide_5615f16c20214d888a2e727ff7c5f5ff_Out_2_Float;
            Unity_Divide_float(float(1), _Divide_b785767ecc1928889893fa60eac4e5fb_Out_2_Float, _Divide_5615f16c20214d888a2e727ff7c5f5ff_Out_2_Float);
            float _Multiply_89aeffc0ad067981a18e6a77948b2b49_Out_2_Float;
            Unity_Multiply_float_float(_Clamp_2b888688983edd82ac250226d9378893_Out_3_Float, _Divide_5615f16c20214d888a2e727ff7c5f5ff_Out_2_Float, _Multiply_89aeffc0ad067981a18e6a77948b2b49_Out_2_Float);
            float _Absolute_b91ed8e326de8f88bf52e49cc5f641d4_Out_1_Float;
            Unity_Absolute_float(_Multiply_89aeffc0ad067981a18e6a77948b2b49_Out_2_Float, _Absolute_b91ed8e326de8f88bf52e49cc5f641d4_Out_1_Float);
            float _Property_4879e96694aee98c9d4ecd329a571123_Out_0_Float = _CoverHardness;
            float _Power_ca1f1906c90fb785bfe520b7faefc3cd_Out_2_Float;
            Unity_Power_float(_Absolute_b91ed8e326de8f88bf52e49cc5f641d4_Out_1_Float, _Property_4879e96694aee98c9d4ecd329a571123_Out_0_Float, _Power_ca1f1906c90fb785bfe520b7faefc3cd_Out_2_Float);
            float _Property_b66201e787ab7b83a55abc6ddd3fe1fd_Out_0_Float = _Cover_Min_Height;
            float _OneMinus_87c740d245de388db4fe5f4958de0668_Out_1_Float;
            Unity_OneMinus_float(_Property_b66201e787ab7b83a55abc6ddd3fe1fd_Out_0_Float, _OneMinus_87c740d245de388db4fe5f4958de0668_Out_1_Float);
            float _Split_ae16de7cacf9d0878aba1467f193d681_R_1_Float = IN.AbsoluteWorldSpacePosition[0];
            float _Split_ae16de7cacf9d0878aba1467f193d681_G_2_Float = IN.AbsoluteWorldSpacePosition[1];
            float _Split_ae16de7cacf9d0878aba1467f193d681_B_3_Float = IN.AbsoluteWorldSpacePosition[2];
            float _Split_ae16de7cacf9d0878aba1467f193d681_A_4_Float = 0;
            float _Add_9d6e1dd03919c88bb01e77a9a2b6b59c_Out_2_Float;
            Unity_Add_float(_OneMinus_87c740d245de388db4fe5f4958de0668_Out_1_Float, _Split_ae16de7cacf9d0878aba1467f193d681_G_2_Float, _Add_9d6e1dd03919c88bb01e77a9a2b6b59c_Out_2_Float);
            float _Add_448f30a2cd792b868416a253a1c502bb_Out_2_Float;
            Unity_Add_float(_Add_9d6e1dd03919c88bb01e77a9a2b6b59c_Out_2_Float, float(1), _Add_448f30a2cd792b868416a253a1c502bb_Out_2_Float);
            float _Clamp_53d91568d0627d8a9cac8deecdd003a8_Out_3_Float;
            Unity_Clamp_float(_Add_448f30a2cd792b868416a253a1c502bb_Out_2_Float, float(0), float(1), _Clamp_53d91568d0627d8a9cac8deecdd003a8_Out_3_Float);
            float _Property_98b8c0fc7e8f9b88b8d7d9dd28ed8aca_Out_0_Float = _Cover_Min_Height_Blending;
            float _Add_0edbe9f424de6d8089b453804bc6ec74_Out_2_Float;
            Unity_Add_float(_Add_9d6e1dd03919c88bb01e77a9a2b6b59c_Out_2_Float, _Property_98b8c0fc7e8f9b88b8d7d9dd28ed8aca_Out_0_Float, _Add_0edbe9f424de6d8089b453804bc6ec74_Out_2_Float);
            float _Divide_bacd243000beaa86b28174bd47716791_Out_2_Float;
            Unity_Divide_float(_Add_0edbe9f424de6d8089b453804bc6ec74_Out_2_Float, _Add_9d6e1dd03919c88bb01e77a9a2b6b59c_Out_2_Float, _Divide_bacd243000beaa86b28174bd47716791_Out_2_Float);
            float _OneMinus_dd51a0c56dbb9b8b8882c6d36bfadd50_Out_1_Float;
            Unity_OneMinus_float(_Divide_bacd243000beaa86b28174bd47716791_Out_2_Float, _OneMinus_dd51a0c56dbb9b8b8882c6d36bfadd50_Out_1_Float);
            float _Add_58dd4a9dfd5655818255c74dd17921da_Out_2_Float;
            Unity_Add_float(_OneMinus_dd51a0c56dbb9b8b8882c6d36bfadd50_Out_1_Float, float(-0.5), _Add_58dd4a9dfd5655818255c74dd17921da_Out_2_Float);
            float _Clamp_5b36f07b81ef6f87a93aefa8fcb815b4_Out_3_Float;
            Unity_Clamp_float(_Add_58dd4a9dfd5655818255c74dd17921da_Out_2_Float, float(0), float(1), _Clamp_5b36f07b81ef6f87a93aefa8fcb815b4_Out_3_Float);
            float _Add_5ef49a57de2cdf85b0e894bfa07f6f14_Out_2_Float;
            Unity_Add_float(_Clamp_53d91568d0627d8a9cac8deecdd003a8_Out_3_Float, _Clamp_5b36f07b81ef6f87a93aefa8fcb815b4_Out_3_Float, _Add_5ef49a57de2cdf85b0e894bfa07f6f14_Out_2_Float);
            float _Clamp_130844801cc2148bb64804d2328686eb_Out_3_Float;
            Unity_Clamp_float(_Add_5ef49a57de2cdf85b0e894bfa07f6f14_Out_2_Float, float(0), float(1), _Clamp_130844801cc2148bb64804d2328686eb_Out_3_Float);
            float _Multiply_4a38c41b77a2458085ff4ae52ba3c21c_Out_2_Float;
            Unity_Multiply_float_float(_Power_ca1f1906c90fb785bfe520b7faefc3cd_Out_2_Float, _Clamp_130844801cc2148bb64804d2328686eb_Out_3_Float, _Multiply_4a38c41b77a2458085ff4ae52ba3c21c_Out_2_Float);
            float _Multiply_edc44afd10069b8e80460ceee1cba8f0_Out_2_Float;
            Unity_Multiply_float_float(_Saturate_04686ab19029f68c8fb9e7a115b207b1_Out_1_Float, _Multiply_4a38c41b77a2458085ff4ae52ba3c21c_Out_2_Float, _Multiply_edc44afd10069b8e80460ceee1cba8f0_Out_2_Float);
            float3 _Lerp_05179f1a9a06b084b2d83e8bce908cce_Out_3_Vector3;
            Unity_Lerp_float3(_NormalBlend_9f531c87e2e45580b1d0f65f06c23526_Out_2_Vector3, _NormalStrength_c4639a6dd3dfde85b591971db2700eaf_Out_2_Vector3, (_Multiply_edc44afd10069b8e80460ceee1cba8f0_Out_2_Float.xxx), _Lerp_05179f1a9a06b084b2d83e8bce908cce_Out_3_Vector3);
            float3 _Transform_d583fb35b7a2838399ae5ff4e71be918_Out_1_Vector3;
            {
                float3x3 tangentTransform = float3x3(IN.WorldSpaceTangent, IN.WorldSpaceBiTangent, IN.WorldSpaceNormal);
                _Transform_d583fb35b7a2838399ae5ff4e71be918_Out_1_Vector3 = TransformTangentToWorldDir(_Lerp_05179f1a9a06b084b2d83e8bce908cce_Out_3_Vector3.xyz, tangentTransform, false).xyz;
            }
            float _Split_44ee9f8d0d54618cabce22ec49a8e7d3_R_1_Float = _Transform_d583fb35b7a2838399ae5ff4e71be918_Out_1_Vector3[0];
            float _Split_44ee9f8d0d54618cabce22ec49a8e7d3_G_2_Float = _Transform_d583fb35b7a2838399ae5ff4e71be918_Out_1_Vector3[1];
            float _Split_44ee9f8d0d54618cabce22ec49a8e7d3_B_3_Float = _Transform_d583fb35b7a2838399ae5ff4e71be918_Out_1_Vector3[2];
            float _Split_44ee9f8d0d54618cabce22ec49a8e7d3_A_4_Float = 0;
            float _Multiply_61fc6a92f0e952858b5d99f2caeb09a3_Out_2_Float;
            Unity_Multiply_float_float(_Split_44ee9f8d0d54618cabce22ec49a8e7d3_G_2_Float, _Clamp_815ffdd53cc1c889aa00f73784cb71e7_Out_3_Float, _Multiply_61fc6a92f0e952858b5d99f2caeb09a3_Out_2_Float);
            float _Multiply_1e7ca8eeb2afb68a96897072c537d835_Out_2_Float;
            Unity_Multiply_float_float(_Clamp_815ffdd53cc1c889aa00f73784cb71e7_Out_3_Float, _Property_4879e96694aee98c9d4ecd329a571123_Out_0_Float, _Multiply_1e7ca8eeb2afb68a96897072c537d835_Out_2_Float);
            float _Multiply_a16d49a3ef8d76899c86b7d84d20ef1f_Out_2_Float;
            Unity_Multiply_float_float(_Multiply_1e7ca8eeb2afb68a96897072c537d835_Out_2_Float, _Multiply_4a38c41b77a2458085ff4ae52ba3c21c_Out_2_Float, _Multiply_a16d49a3ef8d76899c86b7d84d20ef1f_Out_2_Float);
            float _Multiply_dd6ce40548593687a3441a83047275eb_Out_2_Float;
            Unity_Multiply_float_float(_Multiply_61fc6a92f0e952858b5d99f2caeb09a3_Out_2_Float, _Multiply_a16d49a3ef8d76899c86b7d84d20ef1f_Out_2_Float, _Multiply_dd6ce40548593687a3441a83047275eb_Out_2_Float);
            float _Clamp_a3bc14da42d1452f9459b4703c528466_Out_3_Float;
            Unity_Clamp_float(_Multiply_dd6ce40548593687a3441a83047275eb_Out_2_Float, float(0), float(1), _Clamp_a3bc14da42d1452f9459b4703c528466_Out_3_Float);
            float _Multiply_ce9d0ae57259445ba0ff1b83b3eac7be_Out_2_Float;
            Unity_Multiply_float_float(_Clamp_bb1427696ce14fe987f799fecc5f9fac_Out_3_Float, _Clamp_a3bc14da42d1452f9459b4703c528466_Out_3_Float, _Multiply_ce9d0ae57259445ba0ff1b83b3eac7be_Out_2_Float);
            #if defined(_USEDYNAMICCOVERTSTATICMASKF)
            float _UseDynamicCover_5ab22e0469924273a6c7c42f82abda85_Out_0_Float = _Multiply_ce9d0ae57259445ba0ff1b83b3eac7be_Out_2_Float;
            #else
            float _UseDynamicCover_5ab22e0469924273a6c7c42f82abda85_Out_0_Float = _Clamp_bb1427696ce14fe987f799fecc5f9fac_Out_3_Float;
            #endif
            Bindings_UniversalHeighblend_3b5c31b864970d04197cd420b6c4b0fa_float _UniversalHeighblend_21bd55d8d402489499f7ea440e52eb45;
            float _UniversalHeighblend_21bd55d8d402489499f7ea440e52eb45_Heightmap_1_Float;
            SG_UniversalHeighblend_3b5c31b864970d04197cd420b6c4b0fa_float(_Split_a80936a3c75945efb8cf9f2b95c76642_G_2_Float, _Property_14a6757619d64822a44a69b34f85276d_Out_0_Float, _Property_c0d9ffba7dee497c885a54170977d874_Out_0_Boolean, _Split_218e1cfd00b30984921b5fc0ec63de60_B_3_Float, _Add_1f9ea9bdf36544b59f763806e7eea80d_Out_2_Vector2, _Property_0fbef18600294e199eeda9905e3304e4_Out_0_Boolean, _Split_2f45bca363698c859e51492899bc58f8_B_3_Float, _Add_28628d641d58481084e9c00e4ad5fc8d_Out_2_Vector2, _UseDynamicCover_5ab22e0469924273a6c7c42f82abda85_Out_0_Float, _UniversalHeighblend_21bd55d8d402489499f7ea440e52eb45, _UniversalHeighblend_21bd55d8d402489499f7ea440e52eb45_Heightmap_1_Float);
            float _Split_05a25ef5bb1c4867950074f8c86410e8_R_1_Float = IN.VertexColor[0];
            float _Split_05a25ef5bb1c4867950074f8c86410e8_G_2_Float = IN.VertexColor[1];
            float _Split_05a25ef5bb1c4867950074f8c86410e8_B_3_Float = IN.VertexColor[2];
            float _Split_05a25ef5bb1c4867950074f8c86410e8_A_4_Float = IN.VertexColor[3];
            float _OneMinus_0527b7625ff14e8c8ca27817ac4fe9f9_Out_1_Float;
            Unity_OneMinus_float(_Split_05a25ef5bb1c4867950074f8c86410e8_B_3_Float, _OneMinus_0527b7625ff14e8c8ca27817ac4fe9f9_Out_1_Float);
            float _Property_defdd10d24ee4948b18af67062372fb7_Out_0_Float = _VertexColorBBlendStrenght;
            float _Property_f600c3fa0837403fa7000ace8a7aa949_Out_0_Boolean = _USEBaseHeightT;
            float _Property_cc1df5222a194b39870a1906a95881c7_Out_0_Boolean = _USECoverHeightT;
            float _Subtract_df32895ca10a49a6adc84378c30ceb7c_Out_2_Float;
            Unity_Subtract_float(_Property_0e120eb0a0a14b12a31a3c1f5b961121_Out_0_Float, _Property_32b48052fdbb4641bf4eeb294bc65050_Out_0_Float, _Subtract_df32895ca10a49a6adc84378c30ceb7c_Out_2_Float);
            float _Split_a090b28818f34dd8945b893c7fd769f1_R_1_Float = IN.VertexColor[0];
            float _Split_a090b28818f34dd8945b893c7fd769f1_G_2_Float = IN.VertexColor[1];
            float _Split_a090b28818f34dd8945b893c7fd769f1_B_3_Float = IN.VertexColor[2];
            float _Split_a090b28818f34dd8945b893c7fd769f1_A_4_Float = IN.VertexColor[3];
            float _OneMinus_d11f0c4a04b345419edf8e146b9c0221_Out_1_Float;
            Unity_OneMinus_float(_Split_a090b28818f34dd8945b893c7fd769f1_B_3_Float, _OneMinus_d11f0c4a04b345419edf8e146b9c0221_Out_1_Float);
            float _Multiply_b7ff184632b347e9b3d331daaed81a77_Out_2_Float;
            Unity_Multiply_float_float(_Subtract_df32895ca10a49a6adc84378c30ceb7c_Out_2_Float, _OneMinus_d11f0c4a04b345419edf8e146b9c0221_Out_1_Float, _Multiply_b7ff184632b347e9b3d331daaed81a77_Out_2_Float);
            float _Add_ff8ced5a04044788a5de3632a403c505_Out_2_Float;
            Unity_Add_float(_Property_6b467710b0ba48058e003aebe9119249_Out_0_Float, _Multiply_b7ff184632b347e9b3d331daaed81a77_Out_2_Float, _Add_ff8ced5a04044788a5de3632a403c505_Out_2_Float);
            float2 _Add_8ec067f807d04641bea7fd38ab0c8165_Out_2_Vector2;
            Unity_Add_float2(_Vector2_6955747f7f0a4ff98fae60dbada25e89_Out_0_Vector2, (_Add_ff8ced5a04044788a5de3632a403c505_Out_2_Float.xx), _Add_8ec067f807d04641bea7fd38ab0c8165_Out_2_Vector2);
            Bindings_UniversalHeighblend_3b5c31b864970d04197cd420b6c4b0fa_float _UniversalHeighblend_69e2f839a11b4aa7b8e84d65b0ac8307;
            float _UniversalHeighblend_69e2f839a11b4aa7b8e84d65b0ac8307_Heightmap_1_Float;
            SG_UniversalHeighblend_3b5c31b864970d04197cd420b6c4b0fa_float(_OneMinus_0527b7625ff14e8c8ca27817ac4fe9f9_Out_1_Float, _Property_defdd10d24ee4948b18af67062372fb7_Out_0_Float, _Property_f600c3fa0837403fa7000ace8a7aa949_Out_0_Boolean, _Split_218e1cfd00b30984921b5fc0ec63de60_B_3_Float, _Add_1f9ea9bdf36544b59f763806e7eea80d_Out_2_Vector2, _Property_cc1df5222a194b39870a1906a95881c7_Out_0_Boolean, _Split_2f45bca363698c859e51492899bc58f8_B_3_Float, _Add_8ec067f807d04641bea7fd38ab0c8165_Out_2_Vector2, float(1), _UniversalHeighblend_69e2f839a11b4aa7b8e84d65b0ac8307, _UniversalHeighblend_69e2f839a11b4aa7b8e84d65b0ac8307_Heightmap_1_Float);
            float _Add_facc0ab0661749d4bda41177c639b438_Out_2_Float;
            Unity_Add_float(_UniversalHeighblend_21bd55d8d402489499f7ea440e52eb45_Heightmap_1_Float, _UniversalHeighblend_69e2f839a11b4aa7b8e84d65b0ac8307_Heightmap_1_Float, _Add_facc0ab0661749d4bda41177c639b438_Out_2_Float);
            float _Saturate_269cfab86e2abe83819a3afa7b3eeda2_Out_1_Float;
            Unity_Saturate_float(_Add_facc0ab0661749d4bda41177c639b438_Out_2_Float, _Saturate_269cfab86e2abe83819a3afa7b3eeda2_Out_1_Float);
            float4 _Lerp_562b79f1df34b88e9a8a7431d434b435_Out_3_Vector4;
            Unity_Lerp_float4(_Combine_b0f28916143e4b94af6bec53f5328b52_RGBA_4_Vector4, _Multiply_b08794693505bd8e8c04b9ba1610d394_Out_2_Vector4, (_Saturate_269cfab86e2abe83819a3afa7b3eeda2_Out_1_Float.xxxx), _Lerp_562b79f1df34b88e9a8a7431d434b435_Out_3_Vector4);
            float4 _Property_44d9b71d47bc4d02b6d549b527e9d094_Out_0_Vector4 = _WetColor;
            float4 _Multiply_388c575a3467b88ab4d3719bf2b02ad5_Out_2_Vector4;
            Unity_Multiply_float4_float4(_Property_44d9b71d47bc4d02b6d549b527e9d094_Out_0_Vector4, _Lerp_562b79f1df34b88e9a8a7431d434b435_Out_3_Vector4, _Multiply_388c575a3467b88ab4d3719bf2b02ad5_Out_2_Vector4);
            float4 _Clamp_33ec4dd182654e108c0f4ee43f91e820_Out_3_Vector4;
            Unity_Clamp_float4(IN.VertexColor, float4(0, 0, 0, 0), float4(1, 1, 1, 1), _Clamp_33ec4dd182654e108c0f4ee43f91e820_Out_3_Vector4);
            float _Split_5b2299b48b10138ea40c141b79bfe90e_R_1_Float = _Clamp_33ec4dd182654e108c0f4ee43f91e820_Out_3_Vector4[0];
            float _Split_5b2299b48b10138ea40c141b79bfe90e_G_2_Float = _Clamp_33ec4dd182654e108c0f4ee43f91e820_Out_3_Vector4[1];
            float _Split_5b2299b48b10138ea40c141b79bfe90e_B_3_Float = _Clamp_33ec4dd182654e108c0f4ee43f91e820_Out_3_Vector4[2];
            float _Split_5b2299b48b10138ea40c141b79bfe90e_A_4_Float = _Clamp_33ec4dd182654e108c0f4ee43f91e820_Out_3_Vector4[3];
            float _OneMinus_489965dacb44928393bb0c19acfc1dad_Out_1_Float;
            Unity_OneMinus_float(_Split_5b2299b48b10138ea40c141b79bfe90e_R_1_Float, _OneMinus_489965dacb44928393bb0c19acfc1dad_Out_1_Float);
            float4 _Lerp_9f334e8d59abc78798691219f06b2fdb_Out_3_Vector4;
            Unity_Lerp_float4(_Lerp_562b79f1df34b88e9a8a7431d434b435_Out_3_Vector4, _Multiply_388c575a3467b88ab4d3719bf2b02ad5_Out_2_Vector4, (_OneMinus_489965dacb44928393bb0c19acfc1dad_Out_1_Float.xxxx), _Lerp_9f334e8d59abc78798691219f06b2fdb_Out_3_Vector4);
            #if defined(_WETNESS_T_HEAT_F)
            float4 _WetnessTHeatF_7390507dc4254612ae0a227e5143183d_Out_0_Vector4 = _Lerp_9f334e8d59abc78798691219f06b2fdb_Out_3_Vector4;
            #else
            float4 _WetnessTHeatF_7390507dc4254612ae0a227e5143183d_Out_0_Vector4 = _Lerp_562b79f1df34b88e9a8a7431d434b435_Out_3_Vector4;
            #endif
            float _Split_546cdec490fe4753bb0983eea82b45b5_R_1_Float = _Lerp_562b79f1df34b88e9a8a7431d434b435_Out_3_Vector4[0];
            float _Split_546cdec490fe4753bb0983eea82b45b5_G_2_Float = _Lerp_562b79f1df34b88e9a8a7431d434b435_Out_3_Vector4[1];
            float _Split_546cdec490fe4753bb0983eea82b45b5_B_3_Float = _Lerp_562b79f1df34b88e9a8a7431d434b435_Out_3_Vector4[2];
            float _Split_546cdec490fe4753bb0983eea82b45b5_A_4_Float = _Lerp_562b79f1df34b88e9a8a7431d434b435_Out_3_Vector4[3];
            float _Multiply_a7796e97d268424b880f9cb87fc6e42c_Out_2_Float;
            Unity_Multiply_float_float(_Split_546cdec490fe4753bb0983eea82b45b5_A_4_Float, _Split_5b2299b48b10138ea40c141b79bfe90e_A_4_Float, _Multiply_a7796e97d268424b880f9cb87fc6e42c_Out_2_Float);
            float _Property_7ae68b65d6ed4f37aec08ecb89701e8e_Out_0_Float = _AlphaCutoff;
            surface.BaseColor = (_WetnessTHeatF_7390507dc4254612ae0a227e5143183d_Out_0_Vector4.xyz);
            surface.Alpha = _Multiply_a7796e97d268424b880f9cb87fc6e42c_Out_2_Float;
            surface.AlphaClipThreshold = _Property_7ae68b65d6ed4f37aec08ecb89701e8e_Out_0_Float;
            return surface;
        }
        
        // --------------------------------------------------
        // Build Graph Inputs
        #ifdef HAVE_VFX_MODIFICATION
        #define VFX_SRP_ATTRIBUTES Attributes
        #define VFX_SRP_VARYINGS Varyings
        #define VFX_SRP_SURFACE_INPUTS SurfaceDescriptionInputs
        #endif
        VertexDescriptionInputs BuildVertexDescriptionInputs(Attributes input)
        {
            VertexDescriptionInputs output;
            ZERO_INITIALIZE(VertexDescriptionInputs, output);
        
            output.ObjectSpaceNormal =                          input.normalOS;
            output.ObjectSpaceTangent =                         input.tangentOS.xyz;
            output.ObjectSpacePosition =                        input.positionOS;
        #if UNITY_ANY_INSTANCING_ENABLED
        #else // TODO: XR support for procedural instancing because in this case UNITY_ANY_INSTANCING_ENABLED is not defined and instanceID is incorrect.
        #endif
        
            return output;
        }
        SurfaceDescriptionInputs BuildSurfaceDescriptionInputs(Varyings input)
        {
            SurfaceDescriptionInputs output;
            ZERO_INITIALIZE(SurfaceDescriptionInputs, output);
        
        #ifdef HAVE_VFX_MODIFICATION
        #if VFX_USE_GRAPH_VALUES
            uint instanceActiveIndex = asuint(UNITY_ACCESS_INSTANCED_PROP(PerInstance, _InstanceActiveIndex));
            /* WARNING: $splice Could not find named fragment 'VFXLoadGraphValues' */
        #endif
            /* WARNING: $splice Could not find named fragment 'VFXSetFragInputs' */
        
        #endif
        
            
        
            // must use interpolated tangent, bitangent and normal before they are normalized in the pixel shader.
            float3 unnormalizedNormalWS = input.normalWS;
            const float renormFactor = 1.0 / length(unnormalizedNormalWS);
        
            // use bitangent on the fly like in hdrp
            // IMPORTANT! If we ever support Flip on double sided materials ensure bitangent and tangent are NOT flipped.
            float crossSign = (input.tangentWS.w > 0.0 ? 1.0 : -1.0)* GetOddNegativeScale();
            float3 bitang = crossSign * cross(input.normalWS.xyz, input.tangentWS.xyz);
        
            output.WorldSpaceNormal = renormFactor * input.normalWS.xyz;      // we want a unit length Normal Vector node in shader graph
        
            // to pr               eserve mikktspace compliance we use same scale renormFactor as was used on the normal.
            // This                is explained in section 2.2 in "surface gradient based bump mapping framework"
            output.WorldSpaceTangent = renormFactor * input.tangentWS.xyz;
            output.WorldSpaceBiTangent = renormFactor * bitang;
        
            output.AbsoluteWorldSpacePosition = GetAbsolutePositionWS(input.positionWS);
        
            #if UNITY_UV_STARTS_AT_TOP
            #else
            #endif
        
        
            output.uv0 = input.texCoord0;
            output.uv3 = input.texCoord3;
            output.VertexColor = input.color;
        #if UNITY_ANY_INSTANCING_ENABLED
        #else // TODO: XR support for procedural instancing because in this case UNITY_ANY_INSTANCING_ENABLED is not defined and instanceID is incorrect.
        #endif
        #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
        #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN output.FaceSign =                    IS_FRONT_VFACE(input.cullFace, true, false);
        #else
        #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
        #endif
        #undef BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
        
                return output;
        }
        
        // --------------------------------------------------
        // Main
        
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/Varyings.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/SelectionPickingPass.hlsl"
        
        // --------------------------------------------------
        // Visual Effect Vertex Invocations
        #ifdef HAVE_VFX_MODIFICATION
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/VisualEffectVertex.hlsl"
        #endif
        
        ENDHLSL
        }
        Pass
        {
            Name "Universal 2D"
            Tags
            {
                "LightMode" = "Universal2D"
            }
        
        // Render State
        Cull [_Cull]
        Blend [_SrcBlend] [_DstBlend], [_SrcBlendAlpha] [_DstBlendAlpha]
        ZTest [_ZTest]
        ZWrite [_ZWrite]
        
        // Debug
        // <None>
        
        // --------------------------------------------------
        // Pass
        
        HLSLPROGRAM
        
        // Pragmas
        #pragma target 2.0
        #pragma vertex vert
        #pragma fragment frag
        
        // Keywords
        #pragma shader_feature_local_fragment _ _ALPHATEST_ON
        #pragma shader_feature_local _ _USEDYNAMICCOVERTSTATICMASKF
        #pragma shader_feature_local _ _WETNESS_T_HEAT_F
        
        #if defined(_USEDYNAMICCOVERTSTATICMASKF) && defined(_WETNESS_T_HEAT_F)
            #define KEYWORD_PERMUTATION_0
        #elif defined(_USEDYNAMICCOVERTSTATICMASKF)
            #define KEYWORD_PERMUTATION_1
        #elif defined(_WETNESS_T_HEAT_F)
            #define KEYWORD_PERMUTATION_2
        #else
            #define KEYWORD_PERMUTATION_3
        #endif
        
        
        // Defines
        
        #define _NORMALMAP 1
        #define _NORMAL_DROPOFF_TS 1
        #define ATTRIBUTES_NEED_NORMAL
        #define ATTRIBUTES_NEED_TANGENT
        #define ATTRIBUTES_NEED_TEXCOORD0
        #define ATTRIBUTES_NEED_TEXCOORD3
        #define ATTRIBUTES_NEED_COLOR
        #define FEATURES_GRAPH_VERTEX_NORMAL_OUTPUT
        #define FEATURES_GRAPH_VERTEX_TANGENT_OUTPUT
        #define VARYINGS_NEED_POSITION_WS
        #define VARYINGS_NEED_NORMAL_WS
        #define VARYINGS_NEED_TANGENT_WS
        #define VARYINGS_NEED_TEXCOORD0
        #define VARYINGS_NEED_TEXCOORD3
        #define VARYINGS_NEED_COLOR
        #define FEATURES_GRAPH_VERTEX
        /* WARNING: $splice Could not find named fragment 'PassInstancing' */
        #define SHADERPASS SHADERPASS_2D
        
        
        // custom interpolator pre-include
        /* WARNING: $splice Could not find named fragment 'sgci_CustomInterpolatorPreInclude' */
        
        // Includes
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Texture.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
        #include_with_pragmas "Packages/com.unity.render-pipelines.core/ShaderLibrary/FoveatedRenderingKeywords.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/FoveatedRendering.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Input.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/TextureStack.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/DebugMipmapStreamingMacros.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShaderPass.hlsl"
        
        // --------------------------------------------------
        // Structs and Packing
        
        // custom interpolators pre packing
        /* WARNING: $splice Could not find named fragment 'CustomInterpolatorPrePacking' */
        
        struct Attributes
        {
             float3 positionOS : POSITION;
             float3 normalOS : NORMAL;
             float4 tangentOS : TANGENT;
             float4 uv0 : TEXCOORD0;
             float4 uv3 : TEXCOORD3;
             float4 color : COLOR;
            #if UNITY_ANY_INSTANCING_ENABLED || defined(ATTRIBUTES_NEED_INSTANCEID)
             uint instanceID : INSTANCEID_SEMANTIC;
            #endif
        };
        struct Varyings
        {
             float4 positionCS : SV_POSITION;
             float3 positionWS;
             float3 normalWS;
             float4 tangentWS;
             float4 texCoord0;
             float4 texCoord3;
             float4 color;
            #if UNITY_ANY_INSTANCING_ENABLED || defined(VARYINGS_NEED_INSTANCEID)
             uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
             uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
             uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
             FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
        };
        struct SurfaceDescriptionInputs
        {
             float3 WorldSpaceNormal;
             float3 WorldSpaceTangent;
             float3 WorldSpaceBiTangent;
             float3 AbsoluteWorldSpacePosition;
             float4 uv0;
             float4 uv3;
             float4 VertexColor;
        };
        struct VertexDescriptionInputs
        {
             float3 ObjectSpaceNormal;
             float3 ObjectSpaceTangent;
             float3 ObjectSpacePosition;
        };
        struct PackedVaryings
        {
             float4 positionCS : SV_POSITION;
             float4 tangentWS : INTERP0;
             float4 texCoord0 : INTERP1;
             float4 texCoord3 : INTERP2;
             float4 color : INTERP3;
             float3 positionWS : INTERP4;
             float3 normalWS : INTERP5;
            #if UNITY_ANY_INSTANCING_ENABLED || defined(VARYINGS_NEED_INSTANCEID)
             uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
             uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
             uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
             FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
        };
        
        PackedVaryings PackVaryings (Varyings input)
        {
            PackedVaryings output;
            ZERO_INITIALIZE(PackedVaryings, output);
            output.positionCS = input.positionCS;
            output.tangentWS.xyzw = input.tangentWS;
            output.texCoord0.xyzw = input.texCoord0;
            output.texCoord3.xyzw = input.texCoord3;
            output.color.xyzw = input.color;
            output.positionWS.xyz = input.positionWS;
            output.normalWS.xyz = input.normalWS;
            #if UNITY_ANY_INSTANCING_ENABLED || defined(VARYINGS_NEED_INSTANCEID)
            output.instanceID = input.instanceID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            output.cullFace = input.cullFace;
            #endif
            return output;
        }
        
        Varyings UnpackVaryings (PackedVaryings input)
        {
            Varyings output;
            output.positionCS = input.positionCS;
            output.tangentWS = input.tangentWS.xyzw;
            output.texCoord0 = input.texCoord0.xyzw;
            output.texCoord3 = input.texCoord3.xyzw;
            output.color = input.color.xyzw;
            output.positionWS = input.positionWS.xyz;
            output.normalWS = input.normalWS.xyz;
            #if UNITY_ANY_INSTANCING_ENABLED || defined(VARYINGS_NEED_INSTANCEID)
            output.instanceID = input.instanceID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            output.cullFace = input.cullFace;
            #endif
            return output;
        }
        
        
        // --------------------------------------------------
        // Graph
        
        // Graph Properties
        CBUFFER_START(UnityPerMaterial)
        float _EmissionNoiseMultiply;
        float _EmissionNoisePower;
        float Emission_Noise_UV0_UV3;
        float _EmissionNoiseUsePlanarUV;
        float _BaseEmissionMaskTreshold;
        float _CoverEmissionMaskIntensivity;
        float _CoverEmissionMaskTreshold;
        float4 _RimColor;
        float _RimLightPower;
        float4 _Noise_TexelSize;
        float2 _NoiseSpeed;
        float _BaseEmissionMaskIntensivity;
        float4 _LavaEmissionColor;
        float4 _Emission_Noise_Tiling_and_Offset;
        float _Cover_Mask_A_Remap_Min;
        float _Cover_Mask_A_Remap_Max;
        float _HeightMin;
        float _HeightMax;
        float _HeightOffset;
        float _VertexColorBBlendStrenght;
        float _USECoverHeightT;
        float _AlphaCutoff;
        float4 _WetColor;
        float4 _BaseColor;
        float _USEBaseHeightT;
        float4 _BaseColorMap_TexelSize;
        float _BaseUsePlanarUV;
        float4 _BaseTilingOffset;
        float4 _BaseNormalMap_TexelSize;
        float _BaseNormalScale;
        float4 _BaseMaskMap_TexelSize;
        float _BaseMetallic;
        float _VertexColorGBlendStrenght;
        float _BaseAORemapMin;
        float _BaseAORemapMax;
        float _BaseSmoothnessRemapMin;
        float _BaseSmoothnessRemapMax;
        float4 _Masks_TexelSize;
        float _Cover_Amount;
        float _Cover_Amount_Grow_Speed;
        float _Cover_Max_Angle;
        float _Cover_Min_Height;
        float _Cover_Min_Height_Blending;
        float4 _CoverBaseColor;
        float4 _CoverBaseColorMap_TexelSize;
        float _CoverUsePlanarUV;
        float4 _CoverTilingOffset;
        float4 _CoverNormalMap_TexelSize;
        float _CoverNormalScale;
        float _CoverNormalBlendHardness;
        float _CoverHardness;
        float _CoverHeightMapMin;
        float _CoverHeightMapMax;
        float _CoverHeightMapOffset;
        float4 _CoverMaskMap_TexelSize;
        float _CoverMetallic;
        float _CoverAORemapMin;
        float _CoverAORemapMax;
        float _CoverSmoothnessRemapMin;
        float _CoverSmoothnessRemapMax;
        float4 _DetailMap_TexelSize;
        float4 _DetailTilingOffset;
        float _DetailAlbedoScale;
        float _DetailNormalScale;
        float _DetailSmoothnessScale;
        float _WetSmoothness;
        UNITY_TEXTURE_STREAMING_DEBUG_VARS;
        CBUFFER_END
        
        
        // Object and Global properties
        SAMPLER(SamplerState_Linear_Repeat);
        SAMPLER(SamplerState_Linear_Repeat_Aniso8);
        TEXTURE2D(_Noise);
        SAMPLER(sampler_Noise);
        TEXTURE2D(_BaseColorMap);
        SAMPLER(sampler_BaseColorMap);
        TEXTURE2D(_BaseNormalMap);
        SAMPLER(sampler_BaseNormalMap);
        TEXTURE2D(_BaseMaskMap);
        SAMPLER(sampler_BaseMaskMap);
        TEXTURE2D(_Masks);
        SAMPLER(sampler_Masks);
        TEXTURE2D(_CoverBaseColorMap);
        SAMPLER(sampler_CoverBaseColorMap);
        TEXTURE2D(_CoverNormalMap);
        SAMPLER(sampler_CoverNormalMap);
        TEXTURE2D(_CoverMaskMap);
        SAMPLER(sampler_CoverMaskMap);
        TEXTURE2D(_DetailMap);
        SAMPLER(sampler_DetailMap);
        
        // Graph Includes
        // GraphIncludes: <None>
        
        // -- Property used by ScenePickingPass
        #ifdef SCENEPICKINGPASS
        float4 _SelectionID;
        #endif
        
        // -- Properties used by SceneSelectionPass
        #ifdef SCENESELECTIONPASS
        int _ObjectId;
        int _PassValue;
        #endif
        
        // Graph Functions
        
        void Unity_Combine_float(float R, float G, float B, float A, out float4 RGBA, out float3 RGB, out float2 RG)
        {
            RGBA = float4(R, G, B, A);
            RGB = float3(R, G, B);
            RG = float2(R, G);
        }
        
        void Unity_Divide_float(float A, float B, out float Out)
        {
            Out = A / B;
        }
        
        void Unity_Multiply_float4_float4(float4 A, float4 B, out float4 Out)
        {
        Out = A * B;
        }
        
        void Unity_Branch_float4(float Predicate, float4 True, float4 False, out float4 Out)
        {
            Out = Predicate ? True : False;
        }
        
        void Unity_TilingAndOffset_float(float2 UV, float2 Tiling, float2 Offset, out float2 Out)
        {
            Out = UV * Tiling + Offset;
        }
        
        void Unity_Branch_float2(float Predicate, float2 True, float2 False, out float2 Out)
        {
            Out = Predicate ? True : False;
        }
        
        struct Bindings_PlanarNM_c0f081da9c567704ea36e7dd38cedcf6_float
        {
        float3 AbsoluteWorldSpacePosition;
        half4 uv0;
        half4 uv3;
        };
        
        void SG_PlanarNM_c0f081da9c567704ea36e7dd38cedcf6_float(UnityTexture2D Texture2D_80A3D28F, float4 Vector4_2EBA7A3B, float Boolean_7ABB9909, UnitySamplerState _SamplerState, float Boolean_5ddfe6daabcc4715a44b5f34fc19becb, Bindings_PlanarNM_c0f081da9c567704ea36e7dd38cedcf6_float IN, out float4 XZ_2)
        {
        UnityTexture2D _Property_3e01b4d2fc68d48ba3acbba9d5881e59_Out_0_Texture2D = Texture2D_80A3D28F;
        float _Property_30834f691775a0898a45b1c868520436_Out_0_Boolean = Boolean_7ABB9909;
        float _Split_89ed63cb625cb3878c183d0b71c03400_R_1_Float = IN.AbsoluteWorldSpacePosition[0];
        float _Split_89ed63cb625cb3878c183d0b71c03400_G_2_Float = IN.AbsoluteWorldSpacePosition[1];
        float _Split_89ed63cb625cb3878c183d0b71c03400_B_3_Float = IN.AbsoluteWorldSpacePosition[2];
        float _Split_89ed63cb625cb3878c183d0b71c03400_A_4_Float = 0;
        float4 _Combine_cf2d04ff119ad88493f6460431765cbb_RGBA_4_Vector4;
        float3 _Combine_cf2d04ff119ad88493f6460431765cbb_RGB_5_Vector3;
        float2 _Combine_cf2d04ff119ad88493f6460431765cbb_RG_6_Vector2;
        Unity_Combine_float(_Split_89ed63cb625cb3878c183d0b71c03400_R_1_Float, _Split_89ed63cb625cb3878c183d0b71c03400_B_3_Float, float(0), float(0), _Combine_cf2d04ff119ad88493f6460431765cbb_RGBA_4_Vector4, _Combine_cf2d04ff119ad88493f6460431765cbb_RGB_5_Vector3, _Combine_cf2d04ff119ad88493f6460431765cbb_RG_6_Vector2);
        float4 _Property_8a66888ec47d0687ab1cb2f8abdc9da8_Out_0_Vector4 = Vector4_2EBA7A3B;
        float _Split_2f0f52f6ef8c0e81af0da6476402bc1f_R_1_Float = _Property_8a66888ec47d0687ab1cb2f8abdc9da8_Out_0_Vector4[0];
        float _Split_2f0f52f6ef8c0e81af0da6476402bc1f_G_2_Float = _Property_8a66888ec47d0687ab1cb2f8abdc9da8_Out_0_Vector4[1];
        float _Split_2f0f52f6ef8c0e81af0da6476402bc1f_B_3_Float = _Property_8a66888ec47d0687ab1cb2f8abdc9da8_Out_0_Vector4[2];
        float _Split_2f0f52f6ef8c0e81af0da6476402bc1f_A_4_Float = _Property_8a66888ec47d0687ab1cb2f8abdc9da8_Out_0_Vector4[3];
        float _Divide_e64179199923c58289b6aa94ea6c9178_Out_2_Float;
        Unity_Divide_float(float(1), _Split_2f0f52f6ef8c0e81af0da6476402bc1f_R_1_Float, _Divide_e64179199923c58289b6aa94ea6c9178_Out_2_Float);
        float4 _Multiply_14cec4902d0a00829e4555071a1b8ad1_Out_2_Vector4;
        Unity_Multiply_float4_float4(_Combine_cf2d04ff119ad88493f6460431765cbb_RGBA_4_Vector4, (_Divide_e64179199923c58289b6aa94ea6c9178_Out_2_Float.xxxx), _Multiply_14cec4902d0a00829e4555071a1b8ad1_Out_2_Vector4);
        float _Property_f17c7bf877e64b6abdd66b1fe9f5accc_Out_0_Boolean = Boolean_5ddfe6daabcc4715a44b5f34fc19becb;
        float4 _UV_029e8e8198564838b9389b902a09fb22_Out_0_Vector4 = IN.uv0;
        float4 _UV_7a6209af1506424fb75c81e87e42035a_Out_0_Vector4 = IN.uv3;
        float4 _Branch_fc37bb4bf641457cbbc6e290603056ff_Out_3_Vector4;
        Unity_Branch_float4(_Property_f17c7bf877e64b6abdd66b1fe9f5accc_Out_0_Boolean, _UV_029e8e8198564838b9389b902a09fb22_Out_0_Vector4, _UV_7a6209af1506424fb75c81e87e42035a_Out_0_Vector4, _Branch_fc37bb4bf641457cbbc6e290603056ff_Out_3_Vector4);
        float2 _Vector2_16c15d3bbdd14b85bd48e3a6cb318af7_Out_0_Vector2 = float2(_Split_2f0f52f6ef8c0e81af0da6476402bc1f_R_1_Float, _Split_2f0f52f6ef8c0e81af0da6476402bc1f_G_2_Float);
        float2 _Vector2_f8d75f54e7705083bbec539a60185577_Out_0_Vector2 = float2(_Split_2f0f52f6ef8c0e81af0da6476402bc1f_B_3_Float, _Split_2f0f52f6ef8c0e81af0da6476402bc1f_A_4_Float);
        float2 _TilingAndOffset_d91e2d25acd34686b562b7fe7e9d1d27_Out_3_Vector2;
        Unity_TilingAndOffset_float((_Branch_fc37bb4bf641457cbbc6e290603056ff_Out_3_Vector4.xy), _Vector2_16c15d3bbdd14b85bd48e3a6cb318af7_Out_0_Vector2, _Vector2_f8d75f54e7705083bbec539a60185577_Out_0_Vector2, _TilingAndOffset_d91e2d25acd34686b562b7fe7e9d1d27_Out_3_Vector2);
        float2 _Branch_8e5a4e8f4d52fc8aadd1f46485afc933_Out_3_Vector2;
        Unity_Branch_float2(_Property_30834f691775a0898a45b1c868520436_Out_0_Boolean, (_Multiply_14cec4902d0a00829e4555071a1b8ad1_Out_2_Vector4.xy), _TilingAndOffset_d91e2d25acd34686b562b7fe7e9d1d27_Out_3_Vector2, _Branch_8e5a4e8f4d52fc8aadd1f46485afc933_Out_3_Vector2);
        UnitySamplerState _Property_e8746b9475c94530ba35ba8019ad2ae0_Out_0_SamplerState = _SamplerState;
        float4 _SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_RGBA_0_Vector4 = SAMPLE_TEXTURE2D(_Property_3e01b4d2fc68d48ba3acbba9d5881e59_Out_0_Texture2D.tex, _Property_e8746b9475c94530ba35ba8019ad2ae0_Out_0_SamplerState.samplerstate, _Property_3e01b4d2fc68d48ba3acbba9d5881e59_Out_0_Texture2D.GetTransformedUV(_Branch_8e5a4e8f4d52fc8aadd1f46485afc933_Out_3_Vector2) );
        float _SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_R_4_Float = _SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_RGBA_0_Vector4.r;
        float _SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_G_5_Float = _SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_RGBA_0_Vector4.g;
        float _SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_B_6_Float = _SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_RGBA_0_Vector4.b;
        float _SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_A_7_Float = _SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_RGBA_0_Vector4.a;
        XZ_2 = _SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_RGBA_0_Vector4;
        }
        
        void Unity_ColorspaceConversion_Linear_RGB_float(float3 In, out float3 Out)
        {
            float3 sRGBLo = In * 12.92;
            float3 sRGBHi = (pow(max(abs(In), 1.192092896e-07), float3(1.0 / 2.4, 1.0 / 2.4, 1.0 / 2.4)) * 1.055) - 0.055;
            Out = float3(In <= 0.0031308) ? sRGBLo : sRGBHi;
        }
        
        void Unity_Blend_Overlay_float3(float3 Base, float3 Blend, out float3 Out, float Opacity)
        {
            float3 result1 = 1.0 - 2.0 * (1.0 - Base) * (1.0 - Blend);
            float3 result2 = 2.0 * Base * Blend;
            float3 zeroOrOne = step(Base, 0.5);
            Out = result2 * zeroOrOne + (1 - zeroOrOne) * result1;
            Out = lerp(Base, Out, Opacity);
        }
        
        void Unity_ColorspaceConversion_RGB_Linear_float(float3 In, out float3 Out)
        {
            float3 linearRGBLo = In / 12.92;
            float3 linearRGBHi = pow(max(abs((In + 0.055) / 1.055), 1.192092896e-07), float3(2.4, 2.4, 2.4));
            Out = float3(In <= 0.04045) ? linearRGBLo : linearRGBHi;
        }
        
        void Unity_Clamp_float3(float3 In, float3 Min, float3 Max, out float3 Out)
        {
            Out = clamp(In, Min, Max);
        }
        
        void Unity_Add_float2(float2 A, float2 B, out float2 Out)
        {
            Out = A + B;
        }
        
        void Unity_Remap_float(float In, float2 InMinMax, float2 OutMinMax, out float Out)
        {
            Out = OutMinMax.x + (In - InMinMax.x) * (OutMinMax.y - OutMinMax.x) / (InMinMax.y - InMinMax.x);
        }
        
        void Unity_Clamp_float(float In, float Min, float Max, out float Out)
        {
            Out = clamp(In, Min, Max);
        }
        
        void Unity_Multiply_float2_float2(float2 A, float2 B, out float2 Out)
        {
            Out = A * B;
        }
        
        void Unity_DotProduct_float2(float2 A, float2 B, out float Out)
        {
            Out = dot(A, B);
        }
        
        void Unity_Saturate_float(float In, out float Out)
        {
            Out = saturate(In);
        }
        
        void Unity_OneMinus_float(float In, out float Out)
        {
            Out = 1 - In;
        }
        
        void Unity_SquareRoot_float(float In, out float Out)
        {
            Out = sqrt(In);
        }
        
        void Unity_Sign_float3(float3 In, out float3 Out)
        {
            Out = sign(In);
        }
        
        void Unity_Multiply_float_float(float A, float B, out float Out)
        {
        Out = A * B;
        }
        
        void Unity_Normalize_float3(float3 In, out float3 Out)
        {
            Out = normalize(In);
        }
        
        void Unity_Branch_float3(float Predicate, float3 True, float3 False, out float3 Out)
        {
            Out = Predicate ? True : False;
        }
        
        struct Bindings_PlanarNMn_1b93a87456f9d4c419321d0cd92bd6c8_float
        {
        float3 WorldSpaceNormal;
        float3 WorldSpaceTangent;
        float3 WorldSpaceBiTangent;
        float3 AbsoluteWorldSpacePosition;
        half4 uv0;
        half4 uv3;
        };
        
        void SG_PlanarNMn_1b93a87456f9d4c419321d0cd92bd6c8_float(UnityTexture2D Texture2D_80A3D28F, float4 Vector4_82674548, float Boolean_9FF42DF6, UnitySamplerState _SamplerState, float Boolean_5ddfe6daabcc4715a44b5f34fc19becb, Bindings_PlanarNMn_1b93a87456f9d4c419321d0cd92bd6c8_float IN, out float4 XZ_2)
        {
        float _Property_1ef12cf3201a938993fe6a7951b0e754_Out_0_Boolean = Boolean_9FF42DF6;
        UnityTexture2D _Property_3e01b4d2fc68d48ba3acbba9d5881e59_Out_0_Texture2D = Texture2D_80A3D28F;
        float _Split_89ed63cb625cb3878c183d0b71c03400_R_1_Float = IN.AbsoluteWorldSpacePosition[0];
        float _Split_89ed63cb625cb3878c183d0b71c03400_G_2_Float = IN.AbsoluteWorldSpacePosition[1];
        float _Split_89ed63cb625cb3878c183d0b71c03400_B_3_Float = IN.AbsoluteWorldSpacePosition[2];
        float _Split_89ed63cb625cb3878c183d0b71c03400_A_4_Float = 0;
        float4 _Combine_cf2d04ff119ad88493f6460431765cbb_RGBA_4_Vector4;
        float3 _Combine_cf2d04ff119ad88493f6460431765cbb_RGB_5_Vector3;
        float2 _Combine_cf2d04ff119ad88493f6460431765cbb_RG_6_Vector2;
        Unity_Combine_float(_Split_89ed63cb625cb3878c183d0b71c03400_R_1_Float, _Split_89ed63cb625cb3878c183d0b71c03400_B_3_Float, float(0), float(0), _Combine_cf2d04ff119ad88493f6460431765cbb_RGBA_4_Vector4, _Combine_cf2d04ff119ad88493f6460431765cbb_RGB_5_Vector3, _Combine_cf2d04ff119ad88493f6460431765cbb_RG_6_Vector2);
        float4 _Property_3fa1d6f912feb481ba60f2e55e62e746_Out_0_Vector4 = Vector4_82674548;
        float _Split_a2e12fa5931da084b2949343a539dfd8_R_1_Float = _Property_3fa1d6f912feb481ba60f2e55e62e746_Out_0_Vector4[0];
        float _Split_a2e12fa5931da084b2949343a539dfd8_G_2_Float = _Property_3fa1d6f912feb481ba60f2e55e62e746_Out_0_Vector4[1];
        float _Split_a2e12fa5931da084b2949343a539dfd8_B_3_Float = _Property_3fa1d6f912feb481ba60f2e55e62e746_Out_0_Vector4[2];
        float _Split_a2e12fa5931da084b2949343a539dfd8_A_4_Float = _Property_3fa1d6f912feb481ba60f2e55e62e746_Out_0_Vector4[3];
        float _Divide_c36b770dfaa0bb8f85ab27da5fd794f0_Out_2_Float;
        Unity_Divide_float(float(1), _Split_a2e12fa5931da084b2949343a539dfd8_R_1_Float, _Divide_c36b770dfaa0bb8f85ab27da5fd794f0_Out_2_Float);
        float4 _Multiply_14cec4902d0a00829e4555071a1b8ad1_Out_2_Vector4;
        Unity_Multiply_float4_float4(_Combine_cf2d04ff119ad88493f6460431765cbb_RGBA_4_Vector4, (_Divide_c36b770dfaa0bb8f85ab27da5fd794f0_Out_2_Float.xxxx), _Multiply_14cec4902d0a00829e4555071a1b8ad1_Out_2_Vector4);
        float _Property_058f4fba88c3437288219f1929444bf2_Out_0_Boolean = Boolean_5ddfe6daabcc4715a44b5f34fc19becb;
        float4 _UV_43d85b3291324c848dfbeec6adac2a71_Out_0_Vector4 = IN.uv0;
        float4 _UV_36881dcaab9040168fc5215dcd00f352_Out_0_Vector4 = IN.uv3;
        float4 _Branch_8054d58a73be4ce1b22d48a84389ae07_Out_3_Vector4;
        Unity_Branch_float4(_Property_058f4fba88c3437288219f1929444bf2_Out_0_Boolean, _UV_43d85b3291324c848dfbeec6adac2a71_Out_0_Vector4, _UV_36881dcaab9040168fc5215dcd00f352_Out_0_Vector4, _Branch_8054d58a73be4ce1b22d48a84389ae07_Out_3_Vector4);
        float2 _Vector2_6845d21872714d889783b0cb707df3e9_Out_0_Vector2 = float2(_Split_a2e12fa5931da084b2949343a539dfd8_R_1_Float, _Split_a2e12fa5931da084b2949343a539dfd8_G_2_Float);
        float2 _Vector2_e2e2263627c6098e96a5b5d29350ad03_Out_0_Vector2 = float2(_Split_a2e12fa5931da084b2949343a539dfd8_B_3_Float, _Split_a2e12fa5931da084b2949343a539dfd8_A_4_Float);
        float2 _TilingAndOffset_17582d056c0b8a8dab1017d37497fe59_Out_3_Vector2;
        Unity_TilingAndOffset_float((_Branch_8054d58a73be4ce1b22d48a84389ae07_Out_3_Vector4.xy), _Vector2_6845d21872714d889783b0cb707df3e9_Out_0_Vector2, _Vector2_e2e2263627c6098e96a5b5d29350ad03_Out_0_Vector2, _TilingAndOffset_17582d056c0b8a8dab1017d37497fe59_Out_3_Vector2);
        float2 _Branch_1e152f3aac57448f8518bf2852c000c3_Out_3_Vector2;
        Unity_Branch_float2(_Property_1ef12cf3201a938993fe6a7951b0e754_Out_0_Boolean, (_Multiply_14cec4902d0a00829e4555071a1b8ad1_Out_2_Vector4.xy), _TilingAndOffset_17582d056c0b8a8dab1017d37497fe59_Out_3_Vector2, _Branch_1e152f3aac57448f8518bf2852c000c3_Out_3_Vector2);
        UnitySamplerState _Property_69f1ed7efd1b494e91f626b88ab2363c_Out_0_SamplerState = _SamplerState;
        float4 _SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_RGBA_0_Vector4 = SAMPLE_TEXTURE2D(_Property_3e01b4d2fc68d48ba3acbba9d5881e59_Out_0_Texture2D.tex, _Property_69f1ed7efd1b494e91f626b88ab2363c_Out_0_SamplerState.samplerstate, _Property_3e01b4d2fc68d48ba3acbba9d5881e59_Out_0_Texture2D.GetTransformedUV(_Branch_1e152f3aac57448f8518bf2852c000c3_Out_3_Vector2) );
        _SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_RGBA_0_Vector4.rgb = UnpackNormal(_SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_RGBA_0_Vector4);
        float _SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_R_4_Float = _SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_RGBA_0_Vector4.r;
        float _SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_G_5_Float = _SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_RGBA_0_Vector4.g;
        float _SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_B_6_Float = _SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_RGBA_0_Vector4.b;
        float _SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_A_7_Float = _SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_RGBA_0_Vector4.a;
        float2 _Vector2_ad6bd100e273d78fa409a30a77bfa2cc_Out_0_Vector2 = float2(_SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_R_4_Float, _SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_G_5_Float);
        float3 _Sign_3a6ebf59931cf08cb0482e0144ddac24_Out_1_Vector3;
        Unity_Sign_float3(IN.WorldSpaceNormal, _Sign_3a6ebf59931cf08cb0482e0144ddac24_Out_1_Vector3);
        float _Split_6299d4ddcc4c74828aea40a46fdb896e_R_1_Float = _Sign_3a6ebf59931cf08cb0482e0144ddac24_Out_1_Vector3[0];
        float _Split_6299d4ddcc4c74828aea40a46fdb896e_G_2_Float = _Sign_3a6ebf59931cf08cb0482e0144ddac24_Out_1_Vector3[1];
        float _Split_6299d4ddcc4c74828aea40a46fdb896e_B_3_Float = _Sign_3a6ebf59931cf08cb0482e0144ddac24_Out_1_Vector3[2];
        float _Split_6299d4ddcc4c74828aea40a46fdb896e_A_4_Float = 0;
        float2 _Vector2_b76cb1842101e58b9e636d49b075c612_Out_0_Vector2 = float2(_Split_6299d4ddcc4c74828aea40a46fdb896e_G_2_Float, float(1));
        float2 _Multiply_31e8db88ee20c985a9850d1a58f3282b_Out_2_Vector2;
        Unity_Multiply_float2_float2(_Vector2_ad6bd100e273d78fa409a30a77bfa2cc_Out_0_Vector2, _Vector2_b76cb1842101e58b9e636d49b075c612_Out_0_Vector2, _Multiply_31e8db88ee20c985a9850d1a58f3282b_Out_2_Vector2);
        float _Split_5ed44bf2eca0868f81eb18100f49d1fa_R_1_Float = IN.WorldSpaceNormal[0];
        float _Split_5ed44bf2eca0868f81eb18100f49d1fa_G_2_Float = IN.WorldSpaceNormal[1];
        float _Split_5ed44bf2eca0868f81eb18100f49d1fa_B_3_Float = IN.WorldSpaceNormal[2];
        float _Split_5ed44bf2eca0868f81eb18100f49d1fa_A_4_Float = 0;
        float2 _Vector2_70e5837843f28b8b9d64cada3697bd5a_Out_0_Vector2 = float2(_Split_5ed44bf2eca0868f81eb18100f49d1fa_R_1_Float, _Split_5ed44bf2eca0868f81eb18100f49d1fa_B_3_Float);
        float2 _Add_1145b2f896593d80aa864a34e6702562_Out_2_Vector2;
        Unity_Add_float2(_Multiply_31e8db88ee20c985a9850d1a58f3282b_Out_2_Vector2, _Vector2_70e5837843f28b8b9d64cada3697bd5a_Out_0_Vector2, _Add_1145b2f896593d80aa864a34e6702562_Out_2_Vector2);
        float _Split_2bc77ca2d17bd78cb2383770ce50b179_R_1_Float = _Add_1145b2f896593d80aa864a34e6702562_Out_2_Vector2[0];
        float _Split_2bc77ca2d17bd78cb2383770ce50b179_G_2_Float = _Add_1145b2f896593d80aa864a34e6702562_Out_2_Vector2[1];
        float _Split_2bc77ca2d17bd78cb2383770ce50b179_B_3_Float = 0;
        float _Split_2bc77ca2d17bd78cb2383770ce50b179_A_4_Float = 0;
        float _Multiply_ab12aea87465a78eaf7fc66c2598d266_Out_2_Float;
        Unity_Multiply_float_float(_SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_B_6_Float, _Split_5ed44bf2eca0868f81eb18100f49d1fa_G_2_Float, _Multiply_ab12aea87465a78eaf7fc66c2598d266_Out_2_Float);
        float3 _Vector3_433840b555db308b97e9b14b6a957195_Out_0_Vector3 = float3(_Split_2bc77ca2d17bd78cb2383770ce50b179_R_1_Float, _Multiply_ab12aea87465a78eaf7fc66c2598d266_Out_2_Float, _Split_2bc77ca2d17bd78cb2383770ce50b179_G_2_Float);
        float3 _Transform_c7914cc45a011c89b3f53c55afb51673_Out_1_Vector3;
        {
        float3x3 tangentTransform = float3x3(IN.WorldSpaceTangent, IN.WorldSpaceBiTangent, IN.WorldSpaceNormal);
        _Transform_c7914cc45a011c89b3f53c55afb51673_Out_1_Vector3 = TransformWorldToTangentDir(_Vector3_433840b555db308b97e9b14b6a957195_Out_0_Vector3.xyz, tangentTransform, true);
        }
        float3 _Clamp_3837949a36b5428a82af01e7bcd29952_Out_3_Vector3;
        Unity_Clamp_float3(_Transform_c7914cc45a011c89b3f53c55afb51673_Out_1_Vector3, float3(-1, -1, -1), float3(1, 1, 1), _Clamp_3837949a36b5428a82af01e7bcd29952_Out_3_Vector3);
        float3 _Normalize_09bf8a2bd0a4d38e8b97d5c674f79b44_Out_1_Vector3;
        Unity_Normalize_float3(_Clamp_3837949a36b5428a82af01e7bcd29952_Out_3_Vector3, _Normalize_09bf8a2bd0a4d38e8b97d5c674f79b44_Out_1_Vector3);
        float3 _Branch_9eadf909a90f2f80880f8c56ecc2a91f_Out_3_Vector3;
        Unity_Branch_float3(_Property_1ef12cf3201a938993fe6a7951b0e754_Out_0_Boolean, _Normalize_09bf8a2bd0a4d38e8b97d5c674f79b44_Out_1_Vector3, (_SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_RGBA_0_Vector4.xyz), _Branch_9eadf909a90f2f80880f8c56ecc2a91f_Out_3_Vector3);
        XZ_2 = (float4(_Branch_9eadf909a90f2f80880f8c56ecc2a91f_Out_3_Vector3, 1.0));
        }
        
        void Unity_NormalStrength_float(float3 In, float Strength, out float3 Out)
        {
            Out = float3(In.rg * Strength, lerp(1, In.b, saturate(Strength)));
        }
        
        void Unity_NormalBlend_Reoriented_float(float3 A, float3 B, out float3 Out)
        {
            float3 t = A.xyz + float3(0.0, 0.0, 1.0);
            float3 u = B.xyz * float3(-1.0, -1.0, 1.0);
            Out = (t / t.z) * dot(t, u) - u;
        }
        
        void Unity_Subtract_float(float A, float B, out float Out)
        {
            Out = A - B;
        }
        
        void Unity_Absolute_float(float In, out float Out)
        {
            Out = abs(In);
        }
        
        void Unity_Power_float(float A, float B, out float Out)
        {
            Out = pow(A, B);
        }
        
        void Unity_Add_float(float A, float B, out float Out)
        {
            Out = A + B;
        }
        
        void Unity_Lerp_float3(float3 A, float3 B, float3 T, out float3 Out)
        {
            Out = lerp(A, B, T);
        }
        
        void Unity_Comparison_Greater_float(float A, float B, out float Out)
        {
            Out = A > B ? 1 : 0;
        }
        
        void Unity_Branch_float(float Predicate, float True, float False, out float Out)
        {
            Out = Predicate ? True : False;
        }
        
        struct Bindings_UniversalHeighblend_3b5c31b864970d04197cd420b6c4b0fa_float
        {
        };
        
        void SG_UniversalHeighblend_3b5c31b864970d04197cd420b6c4b0fa_float(float _Vertex_Color, float _Blend_Hardness, float _Use_Layer_1_Height_T, float _Layer_1_Height, float2 _Layer_1_Before_Remap, float _Use_Layer_2_Height_T, float _Layer_2_Height, float2 _Layer_2_Before_Remap, float _Angle_Blend, Bindings_UniversalHeighblend_3b5c31b864970d04197cd420b6c4b0fa_float IN, out float Heightmap_1)
        {
        float _Property_b3ca7054ef0043de85912fc45d997ea2_Out_0_Float = _Vertex_Color;
        float _Clamp_852774a2be524975babf4eeb54af6d64_Out_3_Float;
        Unity_Clamp_float(_Property_b3ca7054ef0043de85912fc45d997ea2_Out_0_Float, float(0), float(1), _Clamp_852774a2be524975babf4eeb54af6d64_Out_3_Float);
        float _OneMinus_85e3550f37814cd3ab5ea5dde7f63a73_Out_1_Float;
        Unity_OneMinus_float(_Clamp_852774a2be524975babf4eeb54af6d64_Out_3_Float, _OneMinus_85e3550f37814cd3ab5ea5dde7f63a73_Out_1_Float);
        float _Comparison_5be6aeaa514b4921b5eb68269b58b028_Out_2_Boolean;
        Unity_Comparison_Greater_float(_OneMinus_85e3550f37814cd3ab5ea5dde7f63a73_Out_1_Float, float(0.99), _Comparison_5be6aeaa514b4921b5eb68269b58b028_Out_2_Boolean);
        float _Property_cfe724908035497c918d6d3f8dafe439_Out_0_Boolean = _Use_Layer_1_Height_T;
        float _Property_9634fd87d3374fdaa60181281a01f9b5_Out_0_Float = _Layer_1_Height;
        float2 _Property_e748f6c127e0479a9a01040378a4129b_Out_0_Vector2 = _Layer_1_Before_Remap;
        float _Split_cde172ab161d44cb81ea7874aec65560_R_1_Float = _Property_e748f6c127e0479a9a01040378a4129b_Out_0_Vector2[0];
        float _Split_cde172ab161d44cb81ea7874aec65560_G_2_Float = _Property_e748f6c127e0479a9a01040378a4129b_Out_0_Vector2[1];
        float _Split_cde172ab161d44cb81ea7874aec65560_B_3_Float = 0;
        float _Split_cde172ab161d44cb81ea7874aec65560_A_4_Float = 0;
        float _Subtract_e1e98a956721410caddfb467ae0eca8b_Out_2_Float;
        Unity_Subtract_float(_Split_cde172ab161d44cb81ea7874aec65560_R_1_Float, _Split_cde172ab161d44cb81ea7874aec65560_G_2_Float, _Subtract_e1e98a956721410caddfb467ae0eca8b_Out_2_Float);
        float _Clamp_ac4097026e6248dbb7a95fe910cc776e_Out_3_Float;
        Unity_Clamp_float(_OneMinus_85e3550f37814cd3ab5ea5dde7f63a73_Out_1_Float, float(0), float(1), _Clamp_ac4097026e6248dbb7a95fe910cc776e_Out_3_Float);
        float _Multiply_41691d316de74fef8a4ab5f63ed5474e_Out_2_Float;
        Unity_Multiply_float_float(_Subtract_e1e98a956721410caddfb467ae0eca8b_Out_2_Float, _Clamp_ac4097026e6248dbb7a95fe910cc776e_Out_3_Float, _Multiply_41691d316de74fef8a4ab5f63ed5474e_Out_2_Float);
        float2 _Add_48d37f8b8a464788860db14f0da8a66e_Out_2_Vector2;
        Unity_Add_float2(_Property_e748f6c127e0479a9a01040378a4129b_Out_0_Vector2, (_Multiply_41691d316de74fef8a4ab5f63ed5474e_Out_2_Float.xx), _Add_48d37f8b8a464788860db14f0da8a66e_Out_2_Vector2);
        float _Remap_21f3372608424df090026adc73778a39_Out_3_Float;
        Unity_Remap_float(_Property_9634fd87d3374fdaa60181281a01f9b5_Out_0_Float, float2 (0, 1), _Add_48d37f8b8a464788860db14f0da8a66e_Out_2_Vector2, _Remap_21f3372608424df090026adc73778a39_Out_3_Float);
        float _Clamp_8ea719b357b44537b42b2d05c22046f6_Out_3_Float;
        Unity_Clamp_float(_Remap_21f3372608424df090026adc73778a39_Out_3_Float, float(0), float(1), _Clamp_8ea719b357b44537b42b2d05c22046f6_Out_3_Float);
        float _Property_457e05a76c034ada998b3ff30a7781c3_Out_0_Boolean = _Use_Layer_2_Height_T;
        float _Property_9dfafa1ca8c94866a52535f412aff89a_Out_0_Float = _Angle_Blend;
        float _Property_b0e4a5720c374e2eb6f203a1bd075243_Out_0_Float = _Layer_2_Height;
        float _Multiply_00b31c7f720343caa4ded6df80a61899_Out_2_Float;
        Unity_Multiply_float_float(_Property_9dfafa1ca8c94866a52535f412aff89a_Out_0_Float, _Property_b0e4a5720c374e2eb6f203a1bd075243_Out_0_Float, _Multiply_00b31c7f720343caa4ded6df80a61899_Out_2_Float);
        float2 _Property_555a7734da754b989d8f80ef0bc86bea_Out_0_Vector2 = _Layer_2_Before_Remap;
        float _Split_bad56a0d03154ccc8cbfb53ea0e381d4_R_1_Float = _Property_555a7734da754b989d8f80ef0bc86bea_Out_0_Vector2[0];
        float _Split_bad56a0d03154ccc8cbfb53ea0e381d4_G_2_Float = _Property_555a7734da754b989d8f80ef0bc86bea_Out_0_Vector2[1];
        float _Split_bad56a0d03154ccc8cbfb53ea0e381d4_B_3_Float = 0;
        float _Split_bad56a0d03154ccc8cbfb53ea0e381d4_A_4_Float = 0;
        float _Subtract_2a7908018c384526a00494520503a83d_Out_2_Float;
        Unity_Subtract_float(_Split_bad56a0d03154ccc8cbfb53ea0e381d4_R_1_Float, _Split_bad56a0d03154ccc8cbfb53ea0e381d4_G_2_Float, _Subtract_2a7908018c384526a00494520503a83d_Out_2_Float);
        float _Multiply_417d72157b5f4930aed43775db746964_Out_2_Float;
        Unity_Multiply_float_float(_Subtract_2a7908018c384526a00494520503a83d_Out_2_Float, _Clamp_ac4097026e6248dbb7a95fe910cc776e_Out_3_Float, _Multiply_417d72157b5f4930aed43775db746964_Out_2_Float);
        float2 _Add_3d7e111e917c44e8a6800ce926fac67d_Out_2_Vector2;
        Unity_Add_float2((_Multiply_417d72157b5f4930aed43775db746964_Out_2_Float.xx), _Property_555a7734da754b989d8f80ef0bc86bea_Out_0_Vector2, _Add_3d7e111e917c44e8a6800ce926fac67d_Out_2_Vector2);
        float _Remap_931f83440e6c4c1588456788f84cbd9a_Out_3_Float;
        Unity_Remap_float(_Multiply_00b31c7f720343caa4ded6df80a61899_Out_2_Float, float2 (0, 1), _Add_3d7e111e917c44e8a6800ce926fac67d_Out_2_Vector2, _Remap_931f83440e6c4c1588456788f84cbd9a_Out_3_Float);
        float _Branch_a840aba5bca34588a2665f9794c96c38_Out_3_Float;
        Unity_Branch_float(_Property_457e05a76c034ada998b3ff30a7781c3_Out_0_Boolean, _Remap_931f83440e6c4c1588456788f84cbd9a_Out_3_Float, _Property_9dfafa1ca8c94866a52535f412aff89a_Out_0_Float, _Branch_a840aba5bca34588a2665f9794c96c38_Out_3_Float);
        float _Clamp_b1fe959daf444bf99c57756b8be77768_Out_3_Float;
        Unity_Clamp_float(_Branch_a840aba5bca34588a2665f9794c96c38_Out_3_Float, float(0), float(1), _Clamp_b1fe959daf444bf99c57756b8be77768_Out_3_Float);
        float _Multiply_c045ae9912ac409b9734c687968d47f6_Out_2_Float;
        Unity_Multiply_float_float(_Clamp_8ea719b357b44537b42b2d05c22046f6_Out_3_Float, _Clamp_b1fe959daf444bf99c57756b8be77768_Out_3_Float, _Multiply_c045ae9912ac409b9734c687968d47f6_Out_2_Float);
        float _Branch_5198cfc0a080466e93cf89aea61886e6_Out_3_Float;
        Unity_Branch_float(_Property_cfe724908035497c918d6d3f8dafe439_Out_0_Boolean, _Multiply_c045ae9912ac409b9734c687968d47f6_Out_2_Float, _Clamp_b1fe959daf444bf99c57756b8be77768_Out_3_Float, _Branch_5198cfc0a080466e93cf89aea61886e6_Out_3_Float);
        float _Saturate_ceafe30b0bae4f45a2f2ec500925b553_Out_1_Float;
        Unity_Saturate_float(_Branch_5198cfc0a080466e93cf89aea61886e6_Out_3_Float, _Saturate_ceafe30b0bae4f45a2f2ec500925b553_Out_1_Float);
        float _Absolute_274083e3f9f645bfb86074d91f3b7c62_Out_1_Float;
        Unity_Absolute_float(_Saturate_ceafe30b0bae4f45a2f2ec500925b553_Out_1_Float, _Absolute_274083e3f9f645bfb86074d91f3b7c62_Out_1_Float);
        float _Property_c68e0b8a84a549a582d4723036344b0e_Out_0_Float = _Blend_Hardness;
        float _Power_c9d62a3092174d9cb5674d87bcb7b5c5_Out_2_Float;
        Unity_Power_float(_Absolute_274083e3f9f645bfb86074d91f3b7c62_Out_1_Float, _Property_c68e0b8a84a549a582d4723036344b0e_Out_0_Float, _Power_c9d62a3092174d9cb5674d87bcb7b5c5_Out_2_Float);
        float _Branch_2425ee869bde4930bb8f36a5273bdc33_Out_3_Float;
        Unity_Branch_float(_Comparison_5be6aeaa514b4921b5eb68269b58b028_Out_2_Boolean, float(0), _Power_c9d62a3092174d9cb5674d87bcb7b5c5_Out_2_Float, _Branch_2425ee869bde4930bb8f36a5273bdc33_Out_3_Float);
        float _Clamp_9a5c5cfe52824e248ea0a8e38c593d84_Out_3_Float;
        Unity_Clamp_float(_Branch_2425ee869bde4930bb8f36a5273bdc33_Out_3_Float, float(0), float(1), _Clamp_9a5c5cfe52824e248ea0a8e38c593d84_Out_3_Float);
        Heightmap_1 = _Clamp_9a5c5cfe52824e248ea0a8e38c593d84_Out_3_Float;
        }
        
        void Unity_Lerp_float4(float4 A, float4 B, float4 T, out float4 Out)
        {
            Out = lerp(A, B, T);
        }
        
        void Unity_Clamp_float4(float4 In, float4 Min, float4 Max, out float4 Out)
        {
            Out = clamp(In, Min, Max);
        }
        
        // Custom interpolators pre vertex
        /* WARNING: $splice Could not find named fragment 'CustomInterpolatorPreVertex' */
        
        // Graph Vertex
        struct VertexDescription
        {
            float3 Position;
            float3 Normal;
            float3 Tangent;
        };
        
        VertexDescription VertexDescriptionFunction(VertexDescriptionInputs IN)
        {
            VertexDescription description = (VertexDescription)0;
            description.Position = IN.ObjectSpacePosition;
            description.Normal = IN.ObjectSpaceNormal;
            description.Tangent = IN.ObjectSpaceTangent;
            return description;
        }
        
        // Custom interpolators, pre surface
        #ifdef FEATURES_GRAPH_VERTEX
        Varyings CustomInterpolatorPassThroughFunc(inout Varyings output, VertexDescription input)
        {
        return output;
        }
        #define CUSTOMINTERPOLATOR_VARYPASSTHROUGH_FUNC
        #endif
        
        // Graph Pixel
        struct SurfaceDescription
        {
            float3 BaseColor;
            float Alpha;
            float AlphaClipThreshold;
        };
        
        SurfaceDescription SurfaceDescriptionFunction(SurfaceDescriptionInputs IN)
        {
            SurfaceDescription surface = (SurfaceDescription)0;
            UnityTexture2D _Property_821e07b38fd0a08d85c4dd6e5b6bbac9_Out_0_Texture2D = UnityBuildTexture2DStructNoScale(_BaseColorMap);
            float4 _Property_8ec0d512145619859d288abab740e3bf_Out_0_Vector4 = _BaseTilingOffset;
            float _Property_122c0f9ef0a1c4818a140c75e512abe4_Out_0_Boolean = _BaseUsePlanarUV;
            Bindings_PlanarNM_c0f081da9c567704ea36e7dd38cedcf6_float _PlanarNM_cb7ded32e6af3382bbe06b62977afab6;
            _PlanarNM_cb7ded32e6af3382bbe06b62977afab6.AbsoluteWorldSpacePosition = IN.AbsoluteWorldSpacePosition;
            _PlanarNM_cb7ded32e6af3382bbe06b62977afab6.uv0 = IN.uv0;
            _PlanarNM_cb7ded32e6af3382bbe06b62977afab6.uv3 = IN.uv3;
            float4 _PlanarNM_cb7ded32e6af3382bbe06b62977afab6_XZ_2_Vector4;
            SG_PlanarNM_c0f081da9c567704ea36e7dd38cedcf6_float(_Property_821e07b38fd0a08d85c4dd6e5b6bbac9_Out_0_Texture2D, _Property_8ec0d512145619859d288abab740e3bf_Out_0_Vector4, _Property_122c0f9ef0a1c4818a140c75e512abe4_Out_0_Boolean, UnityBuildSamplerStateStruct(SamplerState_Linear_Repeat_Aniso8), 1, _PlanarNM_cb7ded32e6af3382bbe06b62977afab6, _PlanarNM_cb7ded32e6af3382bbe06b62977afab6_XZ_2_Vector4);
            float4 _Property_41859d117584758eb8002ecc938f9bce_Out_0_Vector4 = _BaseColor;
            float4 _Multiply_4d0f82599060228a9092027fd43912c8_Out_2_Vector4;
            Unity_Multiply_float4_float4(_PlanarNM_cb7ded32e6af3382bbe06b62977afab6_XZ_2_Vector4, _Property_41859d117584758eb8002ecc938f9bce_Out_0_Vector4, _Multiply_4d0f82599060228a9092027fd43912c8_Out_2_Vector4);
            float3 _ColorspaceConversion_30c5042ef70343cd92056cde73cd3ecb_Out_1_Vector3;
            Unity_ColorspaceConversion_Linear_RGB_float((_Multiply_4d0f82599060228a9092027fd43912c8_Out_2_Vector4.xyz), _ColorspaceConversion_30c5042ef70343cd92056cde73cd3ecb_Out_1_Vector3);
            UnityTexture2D _Property_50403cc6b1e3998a82afc21c6a6332ae_Out_0_Texture2D = UnityBuildTexture2DStructNoScale(_DetailMap);
            float4 _Property_256e5676e1089881ae3214634430b140_Out_0_Vector4 = _DetailTilingOffset;
            float _Split_257d0b6ea953418d97fd7daa8128bf35_R_1_Float = _Property_256e5676e1089881ae3214634430b140_Out_0_Vector4[0];
            float _Split_257d0b6ea953418d97fd7daa8128bf35_G_2_Float = _Property_256e5676e1089881ae3214634430b140_Out_0_Vector4[1];
            float _Split_257d0b6ea953418d97fd7daa8128bf35_B_3_Float = _Property_256e5676e1089881ae3214634430b140_Out_0_Vector4[2];
            float _Split_257d0b6ea953418d97fd7daa8128bf35_A_4_Float = _Property_256e5676e1089881ae3214634430b140_Out_0_Vector4[3];
            float2 _Vector2_98295494172421878c7a16cb2baddf9a_Out_0_Vector2 = float2(_Split_257d0b6ea953418d97fd7daa8128bf35_R_1_Float, _Split_257d0b6ea953418d97fd7daa8128bf35_G_2_Float);
            float2 _Vector2_130e8faa59837a81a7506636fcb30b8a_Out_0_Vector2 = float2(_Split_257d0b6ea953418d97fd7daa8128bf35_B_3_Float, _Split_257d0b6ea953418d97fd7daa8128bf35_A_4_Float);
            float2 _TilingAndOffset_1dfb2b4859ec3680ad3a74cf8f1bc17b_Out_3_Vector2;
            Unity_TilingAndOffset_float(IN.uv0.xy, _Vector2_98295494172421878c7a16cb2baddf9a_Out_0_Vector2, _Vector2_130e8faa59837a81a7506636fcb30b8a_Out_0_Vector2, _TilingAndOffset_1dfb2b4859ec3680ad3a74cf8f1bc17b_Out_3_Vector2);
            float4 _SampleTexture2D_d8eb0186b9a0cd819cde65431b4ea5ea_RGBA_0_Vector4 = SAMPLE_TEXTURE2D(_Property_50403cc6b1e3998a82afc21c6a6332ae_Out_0_Texture2D.tex, UnityBuildSamplerStateStruct(SamplerState_Linear_Repeat_Aniso8).samplerstate, _Property_50403cc6b1e3998a82afc21c6a6332ae_Out_0_Texture2D.GetTransformedUV(_TilingAndOffset_1dfb2b4859ec3680ad3a74cf8f1bc17b_Out_3_Vector2) );
            float _SampleTexture2D_d8eb0186b9a0cd819cde65431b4ea5ea_R_4_Float = _SampleTexture2D_d8eb0186b9a0cd819cde65431b4ea5ea_RGBA_0_Vector4.r;
            float _SampleTexture2D_d8eb0186b9a0cd819cde65431b4ea5ea_G_5_Float = _SampleTexture2D_d8eb0186b9a0cd819cde65431b4ea5ea_RGBA_0_Vector4.g;
            float _SampleTexture2D_d8eb0186b9a0cd819cde65431b4ea5ea_B_6_Float = _SampleTexture2D_d8eb0186b9a0cd819cde65431b4ea5ea_RGBA_0_Vector4.b;
            float _SampleTexture2D_d8eb0186b9a0cd819cde65431b4ea5ea_A_7_Float = _SampleTexture2D_d8eb0186b9a0cd819cde65431b4ea5ea_RGBA_0_Vector4.a;
            float _Property_605f29777330a58ba88ac032e905433b_Out_0_Float = _DetailAlbedoScale;
            float3 _Blend_de85bf99257f4eb7bb321fd973539f10_Out_2_Vector3;
            Unity_Blend_Overlay_float3(_ColorspaceConversion_30c5042ef70343cd92056cde73cd3ecb_Out_1_Vector3, (_SampleTexture2D_d8eb0186b9a0cd819cde65431b4ea5ea_R_4_Float.xxx), _Blend_de85bf99257f4eb7bb321fd973539f10_Out_2_Vector3, _Property_605f29777330a58ba88ac032e905433b_Out_0_Float);
            float3 _ColorspaceConversion_635670d250654503b34efa53a99ba43e_Out_1_Vector3;
            Unity_ColorspaceConversion_RGB_Linear_float(_Blend_de85bf99257f4eb7bb321fd973539f10_Out_2_Vector3, _ColorspaceConversion_635670d250654503b34efa53a99ba43e_Out_1_Vector3);
            float3 _Clamp_8913f48f801c43c2879f2e1ce926507e_Out_3_Vector3;
            Unity_Clamp_float3(_ColorspaceConversion_635670d250654503b34efa53a99ba43e_Out_1_Vector3, float3(0, 0, 0), float3(1, 1, 1), _Clamp_8913f48f801c43c2879f2e1ce926507e_Out_3_Vector3);
            float _Split_ddfe447fbb7845e88cc5cfb8158b2248_R_1_Float = _Clamp_8913f48f801c43c2879f2e1ce926507e_Out_3_Vector3[0];
            float _Split_ddfe447fbb7845e88cc5cfb8158b2248_G_2_Float = _Clamp_8913f48f801c43c2879f2e1ce926507e_Out_3_Vector3[1];
            float _Split_ddfe447fbb7845e88cc5cfb8158b2248_B_3_Float = _Clamp_8913f48f801c43c2879f2e1ce926507e_Out_3_Vector3[2];
            float _Split_ddfe447fbb7845e88cc5cfb8158b2248_A_4_Float = 0;
            float _Split_6d7debfd2b20440e932d58108f8e7f75_R_1_Float = _Multiply_4d0f82599060228a9092027fd43912c8_Out_2_Vector4[0];
            float _Split_6d7debfd2b20440e932d58108f8e7f75_G_2_Float = _Multiply_4d0f82599060228a9092027fd43912c8_Out_2_Vector4[1];
            float _Split_6d7debfd2b20440e932d58108f8e7f75_B_3_Float = _Multiply_4d0f82599060228a9092027fd43912c8_Out_2_Vector4[2];
            float _Split_6d7debfd2b20440e932d58108f8e7f75_A_4_Float = _Multiply_4d0f82599060228a9092027fd43912c8_Out_2_Vector4[3];
            float4 _Combine_b0f28916143e4b94af6bec53f5328b52_RGBA_4_Vector4;
            float3 _Combine_b0f28916143e4b94af6bec53f5328b52_RGB_5_Vector3;
            float2 _Combine_b0f28916143e4b94af6bec53f5328b52_RG_6_Vector2;
            Unity_Combine_float(_Split_ddfe447fbb7845e88cc5cfb8158b2248_R_1_Float, _Split_ddfe447fbb7845e88cc5cfb8158b2248_G_2_Float, _Split_ddfe447fbb7845e88cc5cfb8158b2248_B_3_Float, _Split_6d7debfd2b20440e932d58108f8e7f75_A_4_Float, _Combine_b0f28916143e4b94af6bec53f5328b52_RGBA_4_Vector4, _Combine_b0f28916143e4b94af6bec53f5328b52_RGB_5_Vector3, _Combine_b0f28916143e4b94af6bec53f5328b52_RG_6_Vector2);
            UnityTexture2D _Property_a155ddc33ed90685a5ab0edcf158a343_Out_0_Texture2D = UnityBuildTexture2DStructNoScale(_CoverBaseColorMap);
            float4 _Property_256beda96caf2d8aa05d3de41fc08d3d_Out_0_Vector4 = _CoverTilingOffset;
            float _Property_bd9dfe8dd615798f9f2d72d139e56d61_Out_0_Boolean = _CoverUsePlanarUV;
            Bindings_PlanarNM_c0f081da9c567704ea36e7dd38cedcf6_float _PlanarNM_e00e057d3d7c4181b1c7775c6ebbab5b;
            _PlanarNM_e00e057d3d7c4181b1c7775c6ebbab5b.AbsoluteWorldSpacePosition = IN.AbsoluteWorldSpacePosition;
            _PlanarNM_e00e057d3d7c4181b1c7775c6ebbab5b.uv0 = IN.uv0;
            _PlanarNM_e00e057d3d7c4181b1c7775c6ebbab5b.uv3 = IN.uv3;
            float4 _PlanarNM_e00e057d3d7c4181b1c7775c6ebbab5b_XZ_2_Vector4;
            SG_PlanarNM_c0f081da9c567704ea36e7dd38cedcf6_float(_Property_a155ddc33ed90685a5ab0edcf158a343_Out_0_Texture2D, _Property_256beda96caf2d8aa05d3de41fc08d3d_Out_0_Vector4, _Property_bd9dfe8dd615798f9f2d72d139e56d61_Out_0_Boolean, UnityBuildSamplerStateStruct(SamplerState_Linear_Repeat_Aniso8), 1, _PlanarNM_e00e057d3d7c4181b1c7775c6ebbab5b, _PlanarNM_e00e057d3d7c4181b1c7775c6ebbab5b_XZ_2_Vector4);
            float4 _Property_c3be5593fd661b8dafbd04f26b8ec9ac_Out_0_Vector4 = _CoverBaseColor;
            float4 _Multiply_b08794693505bd8e8c04b9ba1610d394_Out_2_Vector4;
            Unity_Multiply_float4_float4(_PlanarNM_e00e057d3d7c4181b1c7775c6ebbab5b_XZ_2_Vector4, _Property_c3be5593fd661b8dafbd04f26b8ec9ac_Out_0_Vector4, _Multiply_b08794693505bd8e8c04b9ba1610d394_Out_2_Vector4);
            float _Split_a80936a3c75945efb8cf9f2b95c76642_R_1_Float = IN.VertexColor[0];
            float _Split_a80936a3c75945efb8cf9f2b95c76642_G_2_Float = IN.VertexColor[1];
            float _Split_a80936a3c75945efb8cf9f2b95c76642_B_3_Float = IN.VertexColor[2];
            float _Split_a80936a3c75945efb8cf9f2b95c76642_A_4_Float = IN.VertexColor[3];
            float _Property_14a6757619d64822a44a69b34f85276d_Out_0_Float = _VertexColorGBlendStrenght;
            float _Property_c0d9ffba7dee497c885a54170977d874_Out_0_Boolean = _USEBaseHeightT;
            UnityTexture2D _Property_bb9b47702e64ec8c8d8ad011fd521576_Out_0_Texture2D = UnityBuildTexture2DStructNoScale(_BaseMaskMap);
            Bindings_PlanarNM_c0f081da9c567704ea36e7dd38cedcf6_float _PlanarNM_e51306c84cde8e84a1fb06a45d8d037f;
            _PlanarNM_e51306c84cde8e84a1fb06a45d8d037f.AbsoluteWorldSpacePosition = IN.AbsoluteWorldSpacePosition;
            _PlanarNM_e51306c84cde8e84a1fb06a45d8d037f.uv0 = IN.uv0;
            _PlanarNM_e51306c84cde8e84a1fb06a45d8d037f.uv3 = IN.uv3;
            float4 _PlanarNM_e51306c84cde8e84a1fb06a45d8d037f_XZ_2_Vector4;
            SG_PlanarNM_c0f081da9c567704ea36e7dd38cedcf6_float(_Property_bb9b47702e64ec8c8d8ad011fd521576_Out_0_Texture2D, _Property_8ec0d512145619859d288abab740e3bf_Out_0_Vector4, _Property_122c0f9ef0a1c4818a140c75e512abe4_Out_0_Boolean, UnityBuildSamplerStateStruct(SamplerState_Linear_Repeat_Aniso8), 1, _PlanarNM_e51306c84cde8e84a1fb06a45d8d037f, _PlanarNM_e51306c84cde8e84a1fb06a45d8d037f_XZ_2_Vector4);
            float _Split_218e1cfd00b30984921b5fc0ec63de60_R_1_Float = _PlanarNM_e51306c84cde8e84a1fb06a45d8d037f_XZ_2_Vector4[0];
            float _Split_218e1cfd00b30984921b5fc0ec63de60_G_2_Float = _PlanarNM_e51306c84cde8e84a1fb06a45d8d037f_XZ_2_Vector4[1];
            float _Split_218e1cfd00b30984921b5fc0ec63de60_B_3_Float = _PlanarNM_e51306c84cde8e84a1fb06a45d8d037f_XZ_2_Vector4[2];
            float _Split_218e1cfd00b30984921b5fc0ec63de60_A_4_Float = _PlanarNM_e51306c84cde8e84a1fb06a45d8d037f_XZ_2_Vector4[3];
            float _Property_1d4a1a93707b42c3abf0baa799c514e5_Out_0_Float = _HeightMin;
            float _Property_8f4f3606868d4028a34c2a9a5a59f99d_Out_0_Float = _HeightMax;
            float2 _Vector2_721b6f4d7077463490b4504fe6c940bf_Out_0_Vector2 = float2(_Property_1d4a1a93707b42c3abf0baa799c514e5_Out_0_Float, _Property_8f4f3606868d4028a34c2a9a5a59f99d_Out_0_Float);
            float _Property_a1ae2f61da87421b9f3839691e9dd8af_Out_0_Float = _HeightOffset;
            float2 _Add_1f9ea9bdf36544b59f763806e7eea80d_Out_2_Vector2;
            Unity_Add_float2(_Vector2_721b6f4d7077463490b4504fe6c940bf_Out_0_Vector2, (_Property_a1ae2f61da87421b9f3839691e9dd8af_Out_0_Float.xx), _Add_1f9ea9bdf36544b59f763806e7eea80d_Out_2_Vector2);
            float _Property_0fbef18600294e199eeda9905e3304e4_Out_0_Boolean = _USECoverHeightT;
            UnityTexture2D _Property_3702de305e11e085a40d7731b582d541_Out_0_Texture2D = UnityBuildTexture2DStructNoScale(_CoverMaskMap);
            Bindings_PlanarNM_c0f081da9c567704ea36e7dd38cedcf6_float _PlanarNM_2217ca3c12141a8cb1e0c7235b369601;
            _PlanarNM_2217ca3c12141a8cb1e0c7235b369601.AbsoluteWorldSpacePosition = IN.AbsoluteWorldSpacePosition;
            _PlanarNM_2217ca3c12141a8cb1e0c7235b369601.uv0 = IN.uv0;
            _PlanarNM_2217ca3c12141a8cb1e0c7235b369601.uv3 = IN.uv3;
            float4 _PlanarNM_2217ca3c12141a8cb1e0c7235b369601_XZ_2_Vector4;
            SG_PlanarNM_c0f081da9c567704ea36e7dd38cedcf6_float(_Property_3702de305e11e085a40d7731b582d541_Out_0_Texture2D, _Property_256beda96caf2d8aa05d3de41fc08d3d_Out_0_Vector4, _Property_bd9dfe8dd615798f9f2d72d139e56d61_Out_0_Boolean, UnityBuildSamplerStateStruct(SamplerState_Linear_Repeat_Aniso8), 1, _PlanarNM_2217ca3c12141a8cb1e0c7235b369601, _PlanarNM_2217ca3c12141a8cb1e0c7235b369601_XZ_2_Vector4);
            float _Split_2f45bca363698c859e51492899bc58f8_R_1_Float = _PlanarNM_2217ca3c12141a8cb1e0c7235b369601_XZ_2_Vector4[0];
            float _Split_2f45bca363698c859e51492899bc58f8_G_2_Float = _PlanarNM_2217ca3c12141a8cb1e0c7235b369601_XZ_2_Vector4[1];
            float _Split_2f45bca363698c859e51492899bc58f8_B_3_Float = _PlanarNM_2217ca3c12141a8cb1e0c7235b369601_XZ_2_Vector4[2];
            float _Split_2f45bca363698c859e51492899bc58f8_A_4_Float = _PlanarNM_2217ca3c12141a8cb1e0c7235b369601_XZ_2_Vector4[3];
            float _Property_32b48052fdbb4641bf4eeb294bc65050_Out_0_Float = _CoverHeightMapMin;
            float _Property_0e120eb0a0a14b12a31a3c1f5b961121_Out_0_Float = _CoverHeightMapMax;
            float2 _Vector2_6955747f7f0a4ff98fae60dbada25e89_Out_0_Vector2 = float2(_Property_32b48052fdbb4641bf4eeb294bc65050_Out_0_Float, _Property_0e120eb0a0a14b12a31a3c1f5b961121_Out_0_Float);
            float _Property_6b467710b0ba48058e003aebe9119249_Out_0_Float = _CoverHeightMapOffset;
            float2 _Add_28628d641d58481084e9c00e4ad5fc8d_Out_2_Vector2;
            Unity_Add_float2(_Vector2_6955747f7f0a4ff98fae60dbada25e89_Out_0_Vector2, (_Property_6b467710b0ba48058e003aebe9119249_Out_0_Float.xx), _Add_28628d641d58481084e9c00e4ad5fc8d_Out_2_Vector2);
            UnityTexture2D _Property_7bea2d9dd5651a8bbbd61ecde71faa54_Out_0_Texture2D = UnityBuildTexture2DStructNoScale(_Masks);
            float4 _UV_429c95affe88aa8694076115c99a0769_Out_0_Vector4 = IN.uv0;
            float4 _SampleTexture2D_2723da80b8a2528381ef199c0415beae_RGBA_0_Vector4 = SAMPLE_TEXTURE2D(_Property_7bea2d9dd5651a8bbbd61ecde71faa54_Out_0_Texture2D.tex, UnityBuildSamplerStateStruct(SamplerState_Linear_Repeat_Aniso8).samplerstate, _Property_7bea2d9dd5651a8bbbd61ecde71faa54_Out_0_Texture2D.GetTransformedUV((_UV_429c95affe88aa8694076115c99a0769_Out_0_Vector4.xy)) );
            float _SampleTexture2D_2723da80b8a2528381ef199c0415beae_R_4_Float = _SampleTexture2D_2723da80b8a2528381ef199c0415beae_RGBA_0_Vector4.r;
            float _SampleTexture2D_2723da80b8a2528381ef199c0415beae_G_5_Float = _SampleTexture2D_2723da80b8a2528381ef199c0415beae_RGBA_0_Vector4.g;
            float _SampleTexture2D_2723da80b8a2528381ef199c0415beae_B_6_Float = _SampleTexture2D_2723da80b8a2528381ef199c0415beae_RGBA_0_Vector4.b;
            float _SampleTexture2D_2723da80b8a2528381ef199c0415beae_A_7_Float = _SampleTexture2D_2723da80b8a2528381ef199c0415beae_RGBA_0_Vector4.a;
            float _Property_7bea2851849541b28a2bc695d39a7606_Out_0_Float = _Cover_Mask_A_Remap_Min;
            float _Property_3be0ae138e414a5cb43d60264b1bcfeb_Out_0_Float = _Cover_Mask_A_Remap_Max;
            float2 _Vector2_44ac029de1e440a799fbdfadc778af0c_Out_0_Vector2 = float2(_Property_7bea2851849541b28a2bc695d39a7606_Out_0_Float, _Property_3be0ae138e414a5cb43d60264b1bcfeb_Out_0_Float);
            float _Remap_0c551a3055a54f16b85b519194883552_Out_3_Float;
            Unity_Remap_float(_SampleTexture2D_2723da80b8a2528381ef199c0415beae_A_7_Float, float2 (0, 1), _Vector2_44ac029de1e440a799fbdfadc778af0c_Out_0_Vector2, _Remap_0c551a3055a54f16b85b519194883552_Out_3_Float);
            float _Clamp_bb1427696ce14fe987f799fecc5f9fac_Out_3_Float;
            Unity_Clamp_float(_Remap_0c551a3055a54f16b85b519194883552_Out_3_Float, float(0), float(1), _Clamp_bb1427696ce14fe987f799fecc5f9fac_Out_3_Float);
            float2 _Vector2_0d28074858599a88940dfc8b57b9a60f_Out_0_Vector2 = float2(_SampleTexture2D_d8eb0186b9a0cd819cde65431b4ea5ea_A_7_Float, _SampleTexture2D_d8eb0186b9a0cd819cde65431b4ea5ea_G_5_Float);
            float2 _Multiply_fac8d94f82a53486bc0142a1e64b3d32_Out_2_Vector2;
            Unity_Multiply_float2_float2(_Vector2_0d28074858599a88940dfc8b57b9a60f_Out_0_Vector2, float2(2, 2), _Multiply_fac8d94f82a53486bc0142a1e64b3d32_Out_2_Vector2);
            float2 _Add_f0e6e847d8d8798ab3ca8c4d878bafc0_Out_2_Vector2;
            Unity_Add_float2(_Multiply_fac8d94f82a53486bc0142a1e64b3d32_Out_2_Vector2, float2(-1, -1), _Add_f0e6e847d8d8798ab3ca8c4d878bafc0_Out_2_Vector2);
            float _Property_d0e8d8f7fd10f0829e8fd86c278c8226_Out_0_Float = _DetailNormalScale;
            float2 _Multiply_11f3dfc5283ea188ad9c83e552cf7e0f_Out_2_Vector2;
            Unity_Multiply_float2_float2(_Add_f0e6e847d8d8798ab3ca8c4d878bafc0_Out_2_Vector2, (_Property_d0e8d8f7fd10f0829e8fd86c278c8226_Out_0_Float.xx), _Multiply_11f3dfc5283ea188ad9c83e552cf7e0f_Out_2_Vector2);
            float _Split_c4822b8eaff9b185be7c059792345712_R_1_Float = _Multiply_11f3dfc5283ea188ad9c83e552cf7e0f_Out_2_Vector2[0];
            float _Split_c4822b8eaff9b185be7c059792345712_G_2_Float = _Multiply_11f3dfc5283ea188ad9c83e552cf7e0f_Out_2_Vector2[1];
            float _Split_c4822b8eaff9b185be7c059792345712_B_3_Float = 0;
            float _Split_c4822b8eaff9b185be7c059792345712_A_4_Float = 0;
            float _DotProduct_1a01939a143c548c8ccd7e8a04fe680d_Out_2_Float;
            Unity_DotProduct_float2(_Multiply_11f3dfc5283ea188ad9c83e552cf7e0f_Out_2_Vector2, _Multiply_11f3dfc5283ea188ad9c83e552cf7e0f_Out_2_Vector2, _DotProduct_1a01939a143c548c8ccd7e8a04fe680d_Out_2_Float);
            float _Saturate_bf3d57899db77f86a1689105ce6a373a_Out_1_Float;
            Unity_Saturate_float(_DotProduct_1a01939a143c548c8ccd7e8a04fe680d_Out_2_Float, _Saturate_bf3d57899db77f86a1689105ce6a373a_Out_1_Float);
            float _OneMinus_052960238cc4a18cb83109d2bcae6d09_Out_1_Float;
            Unity_OneMinus_float(_Saturate_bf3d57899db77f86a1689105ce6a373a_Out_1_Float, _OneMinus_052960238cc4a18cb83109d2bcae6d09_Out_1_Float);
            float _SquareRoot_d4f67288e4dbf5898bea492a70b89ab9_Out_1_Float;
            Unity_SquareRoot_float(_OneMinus_052960238cc4a18cb83109d2bcae6d09_Out_1_Float, _SquareRoot_d4f67288e4dbf5898bea492a70b89ab9_Out_1_Float);
            float3 _Vector3_1e56146bdd567884bb8d5ae769df4d29_Out_0_Vector3 = float3(_Split_c4822b8eaff9b185be7c059792345712_R_1_Float, _Split_c4822b8eaff9b185be7c059792345712_G_2_Float, _SquareRoot_d4f67288e4dbf5898bea492a70b89ab9_Out_1_Float);
            UnityTexture2D _Property_147b07430832c98eb0a470557ee61c5e_Out_0_Texture2D = UnityBuildTexture2DStructNoScale(_BaseNormalMap);
            Bindings_PlanarNMn_1b93a87456f9d4c419321d0cd92bd6c8_float _PlanarNMn_ecad9f1f260c6c8bbd0960b2a8976daf;
            _PlanarNMn_ecad9f1f260c6c8bbd0960b2a8976daf.WorldSpaceNormal = IN.WorldSpaceNormal;
            _PlanarNMn_ecad9f1f260c6c8bbd0960b2a8976daf.WorldSpaceTangent = IN.WorldSpaceTangent;
            _PlanarNMn_ecad9f1f260c6c8bbd0960b2a8976daf.WorldSpaceBiTangent = IN.WorldSpaceBiTangent;
            _PlanarNMn_ecad9f1f260c6c8bbd0960b2a8976daf.AbsoluteWorldSpacePosition = IN.AbsoluteWorldSpacePosition;
            _PlanarNMn_ecad9f1f260c6c8bbd0960b2a8976daf.uv0 = IN.uv0;
            _PlanarNMn_ecad9f1f260c6c8bbd0960b2a8976daf.uv3 = IN.uv3;
            float4 _PlanarNMn_ecad9f1f260c6c8bbd0960b2a8976daf_XZ_2_Vector4;
            SG_PlanarNMn_1b93a87456f9d4c419321d0cd92bd6c8_float(_Property_147b07430832c98eb0a470557ee61c5e_Out_0_Texture2D, _Property_8ec0d512145619859d288abab740e3bf_Out_0_Vector4, _Property_122c0f9ef0a1c4818a140c75e512abe4_Out_0_Boolean, UnityBuildSamplerStateStruct(SamplerState_Linear_Repeat_Aniso8), 1, _PlanarNMn_ecad9f1f260c6c8bbd0960b2a8976daf, _PlanarNMn_ecad9f1f260c6c8bbd0960b2a8976daf_XZ_2_Vector4);
            float _Property_72e436a108ad64868e46d548c585c5f3_Out_0_Float = _BaseNormalScale;
            float3 _NormalStrength_366affc5c8b42482a633d201ef52b9d6_Out_2_Vector3;
            Unity_NormalStrength_float((_PlanarNMn_ecad9f1f260c6c8bbd0960b2a8976daf_XZ_2_Vector4.xyz), _Property_72e436a108ad64868e46d548c585c5f3_Out_0_Float, _NormalStrength_366affc5c8b42482a633d201ef52b9d6_Out_2_Vector3);
            float3 _NormalBlend_9f531c87e2e45580b1d0f65f06c23526_Out_2_Vector3;
            Unity_NormalBlend_Reoriented_float(_Vector3_1e56146bdd567884bb8d5ae769df4d29_Out_0_Vector3, _NormalStrength_366affc5c8b42482a633d201ef52b9d6_Out_2_Vector3, _NormalBlend_9f531c87e2e45580b1d0f65f06c23526_Out_2_Vector3);
            UnityTexture2D _Property_d7e9139e0ac6718b89c610009c28a25a_Out_0_Texture2D = UnityBuildTexture2DStructNoScale(_CoverNormalMap);
            Bindings_PlanarNMn_1b93a87456f9d4c419321d0cd92bd6c8_float _PlanarNMn_690e893d26999680a5cea3604ed0ce16;
            _PlanarNMn_690e893d26999680a5cea3604ed0ce16.WorldSpaceNormal = IN.WorldSpaceNormal;
            _PlanarNMn_690e893d26999680a5cea3604ed0ce16.WorldSpaceTangent = IN.WorldSpaceTangent;
            _PlanarNMn_690e893d26999680a5cea3604ed0ce16.WorldSpaceBiTangent = IN.WorldSpaceBiTangent;
            _PlanarNMn_690e893d26999680a5cea3604ed0ce16.AbsoluteWorldSpacePosition = IN.AbsoluteWorldSpacePosition;
            _PlanarNMn_690e893d26999680a5cea3604ed0ce16.uv0 = IN.uv0;
            _PlanarNMn_690e893d26999680a5cea3604ed0ce16.uv3 = IN.uv3;
            float4 _PlanarNMn_690e893d26999680a5cea3604ed0ce16_XZ_2_Vector4;
            SG_PlanarNMn_1b93a87456f9d4c419321d0cd92bd6c8_float(_Property_d7e9139e0ac6718b89c610009c28a25a_Out_0_Texture2D, _Property_256beda96caf2d8aa05d3de41fc08d3d_Out_0_Vector4, _Property_bd9dfe8dd615798f9f2d72d139e56d61_Out_0_Boolean, UnityBuildSamplerStateStruct(SamplerState_Linear_Repeat_Aniso8), 1, _PlanarNMn_690e893d26999680a5cea3604ed0ce16, _PlanarNMn_690e893d26999680a5cea3604ed0ce16_XZ_2_Vector4);
            float _Property_0fd4d87ded104c829a6110c044eaa5f2_Out_0_Float = _CoverNormalBlendHardness;
            float3 _NormalStrength_c4639a6dd3dfde85b591971db2700eaf_Out_2_Vector3;
            Unity_NormalStrength_float((_PlanarNMn_690e893d26999680a5cea3604ed0ce16_XZ_2_Vector4.xyz), _Property_0fd4d87ded104c829a6110c044eaa5f2_Out_0_Float, _NormalStrength_c4639a6dd3dfde85b591971db2700eaf_Out_2_Vector3);
            float _Split_8ff22a6bdd437780ac7ea5963e1c5bb4_R_1_Float = IN.WorldSpaceNormal[0];
            float _Split_8ff22a6bdd437780ac7ea5963e1c5bb4_G_2_Float = IN.WorldSpaceNormal[1];
            float _Split_8ff22a6bdd437780ac7ea5963e1c5bb4_B_3_Float = IN.WorldSpaceNormal[2];
            float _Split_8ff22a6bdd437780ac7ea5963e1c5bb4_A_4_Float = 0;
            float _Property_28052b023ac35c8e9a95b30327681cc5_Out_0_Float = _Cover_Amount;
            float _Property_7749c0d5b28c14869ab3ba35d226788b_Out_0_Float = _Cover_Amount_Grow_Speed;
            float _Subtract_e5dc2afce7ff588fa1d4c91f78de7575_Out_2_Float;
            Unity_Subtract_float(float(4), _Property_7749c0d5b28c14869ab3ba35d226788b_Out_0_Float, _Subtract_e5dc2afce7ff588fa1d4c91f78de7575_Out_2_Float);
            float _Divide_c77b003bf1ce13828c94a705676e2b30_Out_2_Float;
            Unity_Divide_float(_Property_28052b023ac35c8e9a95b30327681cc5_Out_0_Float, _Subtract_e5dc2afce7ff588fa1d4c91f78de7575_Out_2_Float, _Divide_c77b003bf1ce13828c94a705676e2b30_Out_2_Float);
            float _Absolute_c7499cf07bdd0582abd82adbf367b0fc_Out_1_Float;
            Unity_Absolute_float(_Divide_c77b003bf1ce13828c94a705676e2b30_Out_2_Float, _Absolute_c7499cf07bdd0582abd82adbf367b0fc_Out_1_Float);
            float _Power_a9431dbce44a528f9ee7095adfa10556_Out_2_Float;
            Unity_Power_float(_Absolute_c7499cf07bdd0582abd82adbf367b0fc_Out_1_Float, _Subtract_e5dc2afce7ff588fa1d4c91f78de7575_Out_2_Float, _Power_a9431dbce44a528f9ee7095adfa10556_Out_2_Float);
            float _Clamp_815ffdd53cc1c889aa00f73784cb71e7_Out_3_Float;
            Unity_Clamp_float(_Power_a9431dbce44a528f9ee7095adfa10556_Out_2_Float, float(0), float(2), _Clamp_815ffdd53cc1c889aa00f73784cb71e7_Out_3_Float);
            float _Multiply_143da4886728ff868f10e9cfa6940ea0_Out_2_Float;
            Unity_Multiply_float_float(_Split_8ff22a6bdd437780ac7ea5963e1c5bb4_G_2_Float, _Clamp_815ffdd53cc1c889aa00f73784cb71e7_Out_3_Float, _Multiply_143da4886728ff868f10e9cfa6940ea0_Out_2_Float);
            float _Saturate_04686ab19029f68c8fb9e7a115b207b1_Out_1_Float;
            Unity_Saturate_float(_Multiply_143da4886728ff868f10e9cfa6940ea0_Out_2_Float, _Saturate_04686ab19029f68c8fb9e7a115b207b1_Out_1_Float);
            float _Clamp_9c0a88ffc7be288cbe97d3e13a014fe8_Out_3_Float;
            Unity_Clamp_float(_Split_8ff22a6bdd437780ac7ea5963e1c5bb4_G_2_Float, float(0), float(0.9999), _Clamp_9c0a88ffc7be288cbe97d3e13a014fe8_Out_3_Float);
            float _Property_58f42b34c7f0728f8c98e00a3e3a5726_Out_0_Float = _Cover_Max_Angle;
            float _Divide_b785767ecc1928889893fa60eac4e5fb_Out_2_Float;
            Unity_Divide_float(_Property_58f42b34c7f0728f8c98e00a3e3a5726_Out_0_Float, float(45), _Divide_b785767ecc1928889893fa60eac4e5fb_Out_2_Float);
            float _OneMinus_8e6f5b1570dc8c8b8afb036328281675_Out_1_Float;
            Unity_OneMinus_float(_Divide_b785767ecc1928889893fa60eac4e5fb_Out_2_Float, _OneMinus_8e6f5b1570dc8c8b8afb036328281675_Out_1_Float);
            float _Subtract_5348fb3702fea78d9ee10dbf81ede29c_Out_2_Float;
            Unity_Subtract_float(_Clamp_9c0a88ffc7be288cbe97d3e13a014fe8_Out_3_Float, _OneMinus_8e6f5b1570dc8c8b8afb036328281675_Out_1_Float, _Subtract_5348fb3702fea78d9ee10dbf81ede29c_Out_2_Float);
            float _Clamp_2b888688983edd82ac250226d9378893_Out_3_Float;
            Unity_Clamp_float(_Subtract_5348fb3702fea78d9ee10dbf81ede29c_Out_2_Float, float(0), float(2), _Clamp_2b888688983edd82ac250226d9378893_Out_3_Float);
            float _Divide_5615f16c20214d888a2e727ff7c5f5ff_Out_2_Float;
            Unity_Divide_float(float(1), _Divide_b785767ecc1928889893fa60eac4e5fb_Out_2_Float, _Divide_5615f16c20214d888a2e727ff7c5f5ff_Out_2_Float);
            float _Multiply_89aeffc0ad067981a18e6a77948b2b49_Out_2_Float;
            Unity_Multiply_float_float(_Clamp_2b888688983edd82ac250226d9378893_Out_3_Float, _Divide_5615f16c20214d888a2e727ff7c5f5ff_Out_2_Float, _Multiply_89aeffc0ad067981a18e6a77948b2b49_Out_2_Float);
            float _Absolute_b91ed8e326de8f88bf52e49cc5f641d4_Out_1_Float;
            Unity_Absolute_float(_Multiply_89aeffc0ad067981a18e6a77948b2b49_Out_2_Float, _Absolute_b91ed8e326de8f88bf52e49cc5f641d4_Out_1_Float);
            float _Property_4879e96694aee98c9d4ecd329a571123_Out_0_Float = _CoverHardness;
            float _Power_ca1f1906c90fb785bfe520b7faefc3cd_Out_2_Float;
            Unity_Power_float(_Absolute_b91ed8e326de8f88bf52e49cc5f641d4_Out_1_Float, _Property_4879e96694aee98c9d4ecd329a571123_Out_0_Float, _Power_ca1f1906c90fb785bfe520b7faefc3cd_Out_2_Float);
            float _Property_b66201e787ab7b83a55abc6ddd3fe1fd_Out_0_Float = _Cover_Min_Height;
            float _OneMinus_87c740d245de388db4fe5f4958de0668_Out_1_Float;
            Unity_OneMinus_float(_Property_b66201e787ab7b83a55abc6ddd3fe1fd_Out_0_Float, _OneMinus_87c740d245de388db4fe5f4958de0668_Out_1_Float);
            float _Split_ae16de7cacf9d0878aba1467f193d681_R_1_Float = IN.AbsoluteWorldSpacePosition[0];
            float _Split_ae16de7cacf9d0878aba1467f193d681_G_2_Float = IN.AbsoluteWorldSpacePosition[1];
            float _Split_ae16de7cacf9d0878aba1467f193d681_B_3_Float = IN.AbsoluteWorldSpacePosition[2];
            float _Split_ae16de7cacf9d0878aba1467f193d681_A_4_Float = 0;
            float _Add_9d6e1dd03919c88bb01e77a9a2b6b59c_Out_2_Float;
            Unity_Add_float(_OneMinus_87c740d245de388db4fe5f4958de0668_Out_1_Float, _Split_ae16de7cacf9d0878aba1467f193d681_G_2_Float, _Add_9d6e1dd03919c88bb01e77a9a2b6b59c_Out_2_Float);
            float _Add_448f30a2cd792b868416a253a1c502bb_Out_2_Float;
            Unity_Add_float(_Add_9d6e1dd03919c88bb01e77a9a2b6b59c_Out_2_Float, float(1), _Add_448f30a2cd792b868416a253a1c502bb_Out_2_Float);
            float _Clamp_53d91568d0627d8a9cac8deecdd003a8_Out_3_Float;
            Unity_Clamp_float(_Add_448f30a2cd792b868416a253a1c502bb_Out_2_Float, float(0), float(1), _Clamp_53d91568d0627d8a9cac8deecdd003a8_Out_3_Float);
            float _Property_98b8c0fc7e8f9b88b8d7d9dd28ed8aca_Out_0_Float = _Cover_Min_Height_Blending;
            float _Add_0edbe9f424de6d8089b453804bc6ec74_Out_2_Float;
            Unity_Add_float(_Add_9d6e1dd03919c88bb01e77a9a2b6b59c_Out_2_Float, _Property_98b8c0fc7e8f9b88b8d7d9dd28ed8aca_Out_0_Float, _Add_0edbe9f424de6d8089b453804bc6ec74_Out_2_Float);
            float _Divide_bacd243000beaa86b28174bd47716791_Out_2_Float;
            Unity_Divide_float(_Add_0edbe9f424de6d8089b453804bc6ec74_Out_2_Float, _Add_9d6e1dd03919c88bb01e77a9a2b6b59c_Out_2_Float, _Divide_bacd243000beaa86b28174bd47716791_Out_2_Float);
            float _OneMinus_dd51a0c56dbb9b8b8882c6d36bfadd50_Out_1_Float;
            Unity_OneMinus_float(_Divide_bacd243000beaa86b28174bd47716791_Out_2_Float, _OneMinus_dd51a0c56dbb9b8b8882c6d36bfadd50_Out_1_Float);
            float _Add_58dd4a9dfd5655818255c74dd17921da_Out_2_Float;
            Unity_Add_float(_OneMinus_dd51a0c56dbb9b8b8882c6d36bfadd50_Out_1_Float, float(-0.5), _Add_58dd4a9dfd5655818255c74dd17921da_Out_2_Float);
            float _Clamp_5b36f07b81ef6f87a93aefa8fcb815b4_Out_3_Float;
            Unity_Clamp_float(_Add_58dd4a9dfd5655818255c74dd17921da_Out_2_Float, float(0), float(1), _Clamp_5b36f07b81ef6f87a93aefa8fcb815b4_Out_3_Float);
            float _Add_5ef49a57de2cdf85b0e894bfa07f6f14_Out_2_Float;
            Unity_Add_float(_Clamp_53d91568d0627d8a9cac8deecdd003a8_Out_3_Float, _Clamp_5b36f07b81ef6f87a93aefa8fcb815b4_Out_3_Float, _Add_5ef49a57de2cdf85b0e894bfa07f6f14_Out_2_Float);
            float _Clamp_130844801cc2148bb64804d2328686eb_Out_3_Float;
            Unity_Clamp_float(_Add_5ef49a57de2cdf85b0e894bfa07f6f14_Out_2_Float, float(0), float(1), _Clamp_130844801cc2148bb64804d2328686eb_Out_3_Float);
            float _Multiply_4a38c41b77a2458085ff4ae52ba3c21c_Out_2_Float;
            Unity_Multiply_float_float(_Power_ca1f1906c90fb785bfe520b7faefc3cd_Out_2_Float, _Clamp_130844801cc2148bb64804d2328686eb_Out_3_Float, _Multiply_4a38c41b77a2458085ff4ae52ba3c21c_Out_2_Float);
            float _Multiply_edc44afd10069b8e80460ceee1cba8f0_Out_2_Float;
            Unity_Multiply_float_float(_Saturate_04686ab19029f68c8fb9e7a115b207b1_Out_1_Float, _Multiply_4a38c41b77a2458085ff4ae52ba3c21c_Out_2_Float, _Multiply_edc44afd10069b8e80460ceee1cba8f0_Out_2_Float);
            float3 _Lerp_05179f1a9a06b084b2d83e8bce908cce_Out_3_Vector3;
            Unity_Lerp_float3(_NormalBlend_9f531c87e2e45580b1d0f65f06c23526_Out_2_Vector3, _NormalStrength_c4639a6dd3dfde85b591971db2700eaf_Out_2_Vector3, (_Multiply_edc44afd10069b8e80460ceee1cba8f0_Out_2_Float.xxx), _Lerp_05179f1a9a06b084b2d83e8bce908cce_Out_3_Vector3);
            float3 _Transform_d583fb35b7a2838399ae5ff4e71be918_Out_1_Vector3;
            {
                float3x3 tangentTransform = float3x3(IN.WorldSpaceTangent, IN.WorldSpaceBiTangent, IN.WorldSpaceNormal);
                _Transform_d583fb35b7a2838399ae5ff4e71be918_Out_1_Vector3 = TransformTangentToWorldDir(_Lerp_05179f1a9a06b084b2d83e8bce908cce_Out_3_Vector3.xyz, tangentTransform, false).xyz;
            }
            float _Split_44ee9f8d0d54618cabce22ec49a8e7d3_R_1_Float = _Transform_d583fb35b7a2838399ae5ff4e71be918_Out_1_Vector3[0];
            float _Split_44ee9f8d0d54618cabce22ec49a8e7d3_G_2_Float = _Transform_d583fb35b7a2838399ae5ff4e71be918_Out_1_Vector3[1];
            float _Split_44ee9f8d0d54618cabce22ec49a8e7d3_B_3_Float = _Transform_d583fb35b7a2838399ae5ff4e71be918_Out_1_Vector3[2];
            float _Split_44ee9f8d0d54618cabce22ec49a8e7d3_A_4_Float = 0;
            float _Multiply_61fc6a92f0e952858b5d99f2caeb09a3_Out_2_Float;
            Unity_Multiply_float_float(_Split_44ee9f8d0d54618cabce22ec49a8e7d3_G_2_Float, _Clamp_815ffdd53cc1c889aa00f73784cb71e7_Out_3_Float, _Multiply_61fc6a92f0e952858b5d99f2caeb09a3_Out_2_Float);
            float _Multiply_1e7ca8eeb2afb68a96897072c537d835_Out_2_Float;
            Unity_Multiply_float_float(_Clamp_815ffdd53cc1c889aa00f73784cb71e7_Out_3_Float, _Property_4879e96694aee98c9d4ecd329a571123_Out_0_Float, _Multiply_1e7ca8eeb2afb68a96897072c537d835_Out_2_Float);
            float _Multiply_a16d49a3ef8d76899c86b7d84d20ef1f_Out_2_Float;
            Unity_Multiply_float_float(_Multiply_1e7ca8eeb2afb68a96897072c537d835_Out_2_Float, _Multiply_4a38c41b77a2458085ff4ae52ba3c21c_Out_2_Float, _Multiply_a16d49a3ef8d76899c86b7d84d20ef1f_Out_2_Float);
            float _Multiply_dd6ce40548593687a3441a83047275eb_Out_2_Float;
            Unity_Multiply_float_float(_Multiply_61fc6a92f0e952858b5d99f2caeb09a3_Out_2_Float, _Multiply_a16d49a3ef8d76899c86b7d84d20ef1f_Out_2_Float, _Multiply_dd6ce40548593687a3441a83047275eb_Out_2_Float);
            float _Clamp_a3bc14da42d1452f9459b4703c528466_Out_3_Float;
            Unity_Clamp_float(_Multiply_dd6ce40548593687a3441a83047275eb_Out_2_Float, float(0), float(1), _Clamp_a3bc14da42d1452f9459b4703c528466_Out_3_Float);
            float _Multiply_ce9d0ae57259445ba0ff1b83b3eac7be_Out_2_Float;
            Unity_Multiply_float_float(_Clamp_bb1427696ce14fe987f799fecc5f9fac_Out_3_Float, _Clamp_a3bc14da42d1452f9459b4703c528466_Out_3_Float, _Multiply_ce9d0ae57259445ba0ff1b83b3eac7be_Out_2_Float);
            #if defined(_USEDYNAMICCOVERTSTATICMASKF)
            float _UseDynamicCover_5ab22e0469924273a6c7c42f82abda85_Out_0_Float = _Multiply_ce9d0ae57259445ba0ff1b83b3eac7be_Out_2_Float;
            #else
            float _UseDynamicCover_5ab22e0469924273a6c7c42f82abda85_Out_0_Float = _Clamp_bb1427696ce14fe987f799fecc5f9fac_Out_3_Float;
            #endif
            Bindings_UniversalHeighblend_3b5c31b864970d04197cd420b6c4b0fa_float _UniversalHeighblend_21bd55d8d402489499f7ea440e52eb45;
            float _UniversalHeighblend_21bd55d8d402489499f7ea440e52eb45_Heightmap_1_Float;
            SG_UniversalHeighblend_3b5c31b864970d04197cd420b6c4b0fa_float(_Split_a80936a3c75945efb8cf9f2b95c76642_G_2_Float, _Property_14a6757619d64822a44a69b34f85276d_Out_0_Float, _Property_c0d9ffba7dee497c885a54170977d874_Out_0_Boolean, _Split_218e1cfd00b30984921b5fc0ec63de60_B_3_Float, _Add_1f9ea9bdf36544b59f763806e7eea80d_Out_2_Vector2, _Property_0fbef18600294e199eeda9905e3304e4_Out_0_Boolean, _Split_2f45bca363698c859e51492899bc58f8_B_3_Float, _Add_28628d641d58481084e9c00e4ad5fc8d_Out_2_Vector2, _UseDynamicCover_5ab22e0469924273a6c7c42f82abda85_Out_0_Float, _UniversalHeighblend_21bd55d8d402489499f7ea440e52eb45, _UniversalHeighblend_21bd55d8d402489499f7ea440e52eb45_Heightmap_1_Float);
            float _Split_05a25ef5bb1c4867950074f8c86410e8_R_1_Float = IN.VertexColor[0];
            float _Split_05a25ef5bb1c4867950074f8c86410e8_G_2_Float = IN.VertexColor[1];
            float _Split_05a25ef5bb1c4867950074f8c86410e8_B_3_Float = IN.VertexColor[2];
            float _Split_05a25ef5bb1c4867950074f8c86410e8_A_4_Float = IN.VertexColor[3];
            float _OneMinus_0527b7625ff14e8c8ca27817ac4fe9f9_Out_1_Float;
            Unity_OneMinus_float(_Split_05a25ef5bb1c4867950074f8c86410e8_B_3_Float, _OneMinus_0527b7625ff14e8c8ca27817ac4fe9f9_Out_1_Float);
            float _Property_defdd10d24ee4948b18af67062372fb7_Out_0_Float = _VertexColorBBlendStrenght;
            float _Property_f600c3fa0837403fa7000ace8a7aa949_Out_0_Boolean = _USEBaseHeightT;
            float _Property_cc1df5222a194b39870a1906a95881c7_Out_0_Boolean = _USECoverHeightT;
            float _Subtract_df32895ca10a49a6adc84378c30ceb7c_Out_2_Float;
            Unity_Subtract_float(_Property_0e120eb0a0a14b12a31a3c1f5b961121_Out_0_Float, _Property_32b48052fdbb4641bf4eeb294bc65050_Out_0_Float, _Subtract_df32895ca10a49a6adc84378c30ceb7c_Out_2_Float);
            float _Split_a090b28818f34dd8945b893c7fd769f1_R_1_Float = IN.VertexColor[0];
            float _Split_a090b28818f34dd8945b893c7fd769f1_G_2_Float = IN.VertexColor[1];
            float _Split_a090b28818f34dd8945b893c7fd769f1_B_3_Float = IN.VertexColor[2];
            float _Split_a090b28818f34dd8945b893c7fd769f1_A_4_Float = IN.VertexColor[3];
            float _OneMinus_d11f0c4a04b345419edf8e146b9c0221_Out_1_Float;
            Unity_OneMinus_float(_Split_a090b28818f34dd8945b893c7fd769f1_B_3_Float, _OneMinus_d11f0c4a04b345419edf8e146b9c0221_Out_1_Float);
            float _Multiply_b7ff184632b347e9b3d331daaed81a77_Out_2_Float;
            Unity_Multiply_float_float(_Subtract_df32895ca10a49a6adc84378c30ceb7c_Out_2_Float, _OneMinus_d11f0c4a04b345419edf8e146b9c0221_Out_1_Float, _Multiply_b7ff184632b347e9b3d331daaed81a77_Out_2_Float);
            float _Add_ff8ced5a04044788a5de3632a403c505_Out_2_Float;
            Unity_Add_float(_Property_6b467710b0ba48058e003aebe9119249_Out_0_Float, _Multiply_b7ff184632b347e9b3d331daaed81a77_Out_2_Float, _Add_ff8ced5a04044788a5de3632a403c505_Out_2_Float);
            float2 _Add_8ec067f807d04641bea7fd38ab0c8165_Out_2_Vector2;
            Unity_Add_float2(_Vector2_6955747f7f0a4ff98fae60dbada25e89_Out_0_Vector2, (_Add_ff8ced5a04044788a5de3632a403c505_Out_2_Float.xx), _Add_8ec067f807d04641bea7fd38ab0c8165_Out_2_Vector2);
            Bindings_UniversalHeighblend_3b5c31b864970d04197cd420b6c4b0fa_float _UniversalHeighblend_69e2f839a11b4aa7b8e84d65b0ac8307;
            float _UniversalHeighblend_69e2f839a11b4aa7b8e84d65b0ac8307_Heightmap_1_Float;
            SG_UniversalHeighblend_3b5c31b864970d04197cd420b6c4b0fa_float(_OneMinus_0527b7625ff14e8c8ca27817ac4fe9f9_Out_1_Float, _Property_defdd10d24ee4948b18af67062372fb7_Out_0_Float, _Property_f600c3fa0837403fa7000ace8a7aa949_Out_0_Boolean, _Split_218e1cfd00b30984921b5fc0ec63de60_B_3_Float, _Add_1f9ea9bdf36544b59f763806e7eea80d_Out_2_Vector2, _Property_cc1df5222a194b39870a1906a95881c7_Out_0_Boolean, _Split_2f45bca363698c859e51492899bc58f8_B_3_Float, _Add_8ec067f807d04641bea7fd38ab0c8165_Out_2_Vector2, float(1), _UniversalHeighblend_69e2f839a11b4aa7b8e84d65b0ac8307, _UniversalHeighblend_69e2f839a11b4aa7b8e84d65b0ac8307_Heightmap_1_Float);
            float _Add_facc0ab0661749d4bda41177c639b438_Out_2_Float;
            Unity_Add_float(_UniversalHeighblend_21bd55d8d402489499f7ea440e52eb45_Heightmap_1_Float, _UniversalHeighblend_69e2f839a11b4aa7b8e84d65b0ac8307_Heightmap_1_Float, _Add_facc0ab0661749d4bda41177c639b438_Out_2_Float);
            float _Saturate_269cfab86e2abe83819a3afa7b3eeda2_Out_1_Float;
            Unity_Saturate_float(_Add_facc0ab0661749d4bda41177c639b438_Out_2_Float, _Saturate_269cfab86e2abe83819a3afa7b3eeda2_Out_1_Float);
            float4 _Lerp_562b79f1df34b88e9a8a7431d434b435_Out_3_Vector4;
            Unity_Lerp_float4(_Combine_b0f28916143e4b94af6bec53f5328b52_RGBA_4_Vector4, _Multiply_b08794693505bd8e8c04b9ba1610d394_Out_2_Vector4, (_Saturate_269cfab86e2abe83819a3afa7b3eeda2_Out_1_Float.xxxx), _Lerp_562b79f1df34b88e9a8a7431d434b435_Out_3_Vector4);
            float4 _Property_44d9b71d47bc4d02b6d549b527e9d094_Out_0_Vector4 = _WetColor;
            float4 _Multiply_388c575a3467b88ab4d3719bf2b02ad5_Out_2_Vector4;
            Unity_Multiply_float4_float4(_Property_44d9b71d47bc4d02b6d549b527e9d094_Out_0_Vector4, _Lerp_562b79f1df34b88e9a8a7431d434b435_Out_3_Vector4, _Multiply_388c575a3467b88ab4d3719bf2b02ad5_Out_2_Vector4);
            float4 _Clamp_33ec4dd182654e108c0f4ee43f91e820_Out_3_Vector4;
            Unity_Clamp_float4(IN.VertexColor, float4(0, 0, 0, 0), float4(1, 1, 1, 1), _Clamp_33ec4dd182654e108c0f4ee43f91e820_Out_3_Vector4);
            float _Split_5b2299b48b10138ea40c141b79bfe90e_R_1_Float = _Clamp_33ec4dd182654e108c0f4ee43f91e820_Out_3_Vector4[0];
            float _Split_5b2299b48b10138ea40c141b79bfe90e_G_2_Float = _Clamp_33ec4dd182654e108c0f4ee43f91e820_Out_3_Vector4[1];
            float _Split_5b2299b48b10138ea40c141b79bfe90e_B_3_Float = _Clamp_33ec4dd182654e108c0f4ee43f91e820_Out_3_Vector4[2];
            float _Split_5b2299b48b10138ea40c141b79bfe90e_A_4_Float = _Clamp_33ec4dd182654e108c0f4ee43f91e820_Out_3_Vector4[3];
            float _OneMinus_489965dacb44928393bb0c19acfc1dad_Out_1_Float;
            Unity_OneMinus_float(_Split_5b2299b48b10138ea40c141b79bfe90e_R_1_Float, _OneMinus_489965dacb44928393bb0c19acfc1dad_Out_1_Float);
            float4 _Lerp_9f334e8d59abc78798691219f06b2fdb_Out_3_Vector4;
            Unity_Lerp_float4(_Lerp_562b79f1df34b88e9a8a7431d434b435_Out_3_Vector4, _Multiply_388c575a3467b88ab4d3719bf2b02ad5_Out_2_Vector4, (_OneMinus_489965dacb44928393bb0c19acfc1dad_Out_1_Float.xxxx), _Lerp_9f334e8d59abc78798691219f06b2fdb_Out_3_Vector4);
            #if defined(_WETNESS_T_HEAT_F)
            float4 _WetnessTHeatF_7390507dc4254612ae0a227e5143183d_Out_0_Vector4 = _Lerp_9f334e8d59abc78798691219f06b2fdb_Out_3_Vector4;
            #else
            float4 _WetnessTHeatF_7390507dc4254612ae0a227e5143183d_Out_0_Vector4 = _Lerp_562b79f1df34b88e9a8a7431d434b435_Out_3_Vector4;
            #endif
            float _Split_546cdec490fe4753bb0983eea82b45b5_R_1_Float = _Lerp_562b79f1df34b88e9a8a7431d434b435_Out_3_Vector4[0];
            float _Split_546cdec490fe4753bb0983eea82b45b5_G_2_Float = _Lerp_562b79f1df34b88e9a8a7431d434b435_Out_3_Vector4[1];
            float _Split_546cdec490fe4753bb0983eea82b45b5_B_3_Float = _Lerp_562b79f1df34b88e9a8a7431d434b435_Out_3_Vector4[2];
            float _Split_546cdec490fe4753bb0983eea82b45b5_A_4_Float = _Lerp_562b79f1df34b88e9a8a7431d434b435_Out_3_Vector4[3];
            float _Multiply_a7796e97d268424b880f9cb87fc6e42c_Out_2_Float;
            Unity_Multiply_float_float(_Split_546cdec490fe4753bb0983eea82b45b5_A_4_Float, _Split_5b2299b48b10138ea40c141b79bfe90e_A_4_Float, _Multiply_a7796e97d268424b880f9cb87fc6e42c_Out_2_Float);
            float _Property_7ae68b65d6ed4f37aec08ecb89701e8e_Out_0_Float = _AlphaCutoff;
            surface.BaseColor = (_WetnessTHeatF_7390507dc4254612ae0a227e5143183d_Out_0_Vector4.xyz);
            surface.Alpha = _Multiply_a7796e97d268424b880f9cb87fc6e42c_Out_2_Float;
            surface.AlphaClipThreshold = _Property_7ae68b65d6ed4f37aec08ecb89701e8e_Out_0_Float;
            return surface;
        }
        
        // --------------------------------------------------
        // Build Graph Inputs
        #ifdef HAVE_VFX_MODIFICATION
        #define VFX_SRP_ATTRIBUTES Attributes
        #define VFX_SRP_VARYINGS Varyings
        #define VFX_SRP_SURFACE_INPUTS SurfaceDescriptionInputs
        #endif
        VertexDescriptionInputs BuildVertexDescriptionInputs(Attributes input)
        {
            VertexDescriptionInputs output;
            ZERO_INITIALIZE(VertexDescriptionInputs, output);
        
            output.ObjectSpaceNormal =                          input.normalOS;
            output.ObjectSpaceTangent =                         input.tangentOS.xyz;
            output.ObjectSpacePosition =                        input.positionOS;
        #if UNITY_ANY_INSTANCING_ENABLED
        #else // TODO: XR support for procedural instancing because in this case UNITY_ANY_INSTANCING_ENABLED is not defined and instanceID is incorrect.
        #endif
        
            return output;
        }
        SurfaceDescriptionInputs BuildSurfaceDescriptionInputs(Varyings input)
        {
            SurfaceDescriptionInputs output;
            ZERO_INITIALIZE(SurfaceDescriptionInputs, output);
        
        #ifdef HAVE_VFX_MODIFICATION
        #if VFX_USE_GRAPH_VALUES
            uint instanceActiveIndex = asuint(UNITY_ACCESS_INSTANCED_PROP(PerInstance, _InstanceActiveIndex));
            /* WARNING: $splice Could not find named fragment 'VFXLoadGraphValues' */
        #endif
            /* WARNING: $splice Could not find named fragment 'VFXSetFragInputs' */
        
        #endif
        
            
        
            // must use interpolated tangent, bitangent and normal before they are normalized in the pixel shader.
            float3 unnormalizedNormalWS = input.normalWS;
            const float renormFactor = 1.0 / length(unnormalizedNormalWS);
        
            // use bitangent on the fly like in hdrp
            // IMPORTANT! If we ever support Flip on double sided materials ensure bitangent and tangent are NOT flipped.
            float crossSign = (input.tangentWS.w > 0.0 ? 1.0 : -1.0)* GetOddNegativeScale();
            float3 bitang = crossSign * cross(input.normalWS.xyz, input.tangentWS.xyz);
        
            output.WorldSpaceNormal = renormFactor * input.normalWS.xyz;      // we want a unit length Normal Vector node in shader graph
        
            // to pr               eserve mikktspace compliance we use same scale renormFactor as was used on the normal.
            // This                is explained in section 2.2 in "surface gradient based bump mapping framework"
            output.WorldSpaceTangent = renormFactor * input.tangentWS.xyz;
            output.WorldSpaceBiTangent = renormFactor * bitang;
        
            output.AbsoluteWorldSpacePosition = GetAbsolutePositionWS(input.positionWS);
        
            #if UNITY_UV_STARTS_AT_TOP
            #else
            #endif
        
        
            output.uv0 = input.texCoord0;
            output.uv3 = input.texCoord3;
            output.VertexColor = input.color;
        #if UNITY_ANY_INSTANCING_ENABLED
        #else // TODO: XR support for procedural instancing because in this case UNITY_ANY_INSTANCING_ENABLED is not defined and instanceID is incorrect.
        #endif
        #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
        #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN output.FaceSign =                    IS_FRONT_VFACE(input.cullFace, true, false);
        #else
        #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
        #endif
        #undef BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
        
                return output;
        }
        
        // --------------------------------------------------
        // Main
        
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/Varyings.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/PBR2DPass.hlsl"
        
        // --------------------------------------------------
        // Visual Effect Vertex Invocations
        #ifdef HAVE_VFX_MODIFICATION
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/VisualEffectVertex.hlsl"
        #endif
        
        ENDHLSL
        }
    }
    CustomEditor "UnityEditor.ShaderGraph.GenericShaderGraphMaterialGUI"
    CustomEditorForRenderPipeline "UnityEditor.ShaderGraphLitGUI" "UnityEngine.Rendering.Universal.UniversalRenderPipelineAsset"
    FallBack "Hidden/Shader Graph/FallbackError"
}