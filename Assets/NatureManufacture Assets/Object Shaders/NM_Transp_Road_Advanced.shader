Shader "NatureManufacture/URP/Road/Transparent Road Cover Advanced"
{
    Properties
    {
        _AlphaCutoff("Alpha Cutoff", Range(0, 1)) = 0
        _BaseColor("Base Color", Color) = (1, 1, 1, 1)
        [NoScaleOffset]_BaseColorMap("Base Map(RGB) Alpha(A)", 2D) = "white" {}
        [ToggleUI]_BaseUsePlanarUV("Base Use Planar UV", Float) = 0
        _BaseTilingOffset("Base Tiling and Offset", Vector, 4) = (1, 1, 0, 0)
        [Normal][NoScaleOffset]_BaseNormalMap("Base Normal Map", 2D) = "bump" {}
        _BaseNormalScale("Base Normal Scale", Range(0, 8)) = 1
        [NoScaleOffset]_BaseMaskMap("Base Mask Map MT(R) AO(G) H(B) SM(A)", 2D) = "white" {}
        _BaseMetallic("Base Metallic", Range(0, 1)) = 1
        _BaseAORemapMin("Base AO Remap Min", Range(0, 1)) = 0
        _BaseAORemapMax("Base AO Remap Max", Range(0, 1)) = 1
        _BaseSmoothnessRemapMin("Base Smoothness Remap Min", Range(0, 1)) = 0
        _BaseSmoothnessRemapMax("Base Smoothness Remap Max", Range(0, 1)) = 1
        [NoScaleOffset]_LayerMask("Layer Mask (R)", 2D) = "black" {}
        [ToggleUI]_Invert_Layer_Mask("Invert Layer Mask", Float) = 0
        _Height_Transition("Height Blend Transition", Range(0.001, 1)) = 1
        _HeightMin("Height Min", Float) = 0
        _HeightMax("Height Max", Float) = 1
        _HeightOffset("Height Offset", Float) = 0
        _HeightMin2("Height 2 Min", Float) = 0
        _HeightMax2("Height 2 Max", Float) = 1
        _HeightOffset2("Height 2 Offset", Float) = 0
        [ToggleUI]IgnoreBase2Alpha("Ignore Base 2 Alpha", Float) = 0
        _Base2Color("Base 2 Color", Color) = (1, 1, 1, 1)
        [NoScaleOffset]_Base2ColorMap("Base 2 Map", 2D) = "white" {}
        _Base2TilingOffset("Base 2 Tiling and Offset", Vector, 4) = (1, 1, 0, 0)
        [ToggleUI]_Base2UsePlanarUV("Base 2 Use Planar UV", Float) = 0
        [Normal][NoScaleOffset]_Base2NormalMap("Base 2 Normal Map", 2D) = "bump" {}
        _Base2NormalScale("Base 2 Normal Scale", Range(0, 8)) = 1
        [NoScaleOffset]_Base2MaskMap("Base 2 Mask Map MT(R) AO(G) H(B) SM(A)", 2D) = "white" {}
        _Base2Metallic("Base 2 Metallic", Range(0, 1)) = 1
        _Base2SmoothnessRemapMin("Base 2 Smoothness Remap Min", Range(0, 1)) = 0
        _Base2SmoothnessRemapMax("Base 2 Smoothness Remap Max", Range(0, 1)) = 1
        _Base2AORemapMin("Base 2 AO Remap Min", Range(0, 1)) = 0
        _Base2AORemapMax("Base 2 AO Remap Max", Range(0, 1)) = 1
        [Toggle]_USEDYNAMICCOVERTSTATICMASKF("Use Dynamic Cover (T) Static Mask (F)", Float) = 1
        _CoverMaskPower("Cover Mask Power", Range(0, 10)) = 1
        _Cover_Amount("Cover Amount", Range(0, 2)) = 0
        _Cover_Amount_Grow_Speed("Cover Amount Grow Speed", Range(0, 3)) = 3
        _Cover_Max_Angle("Cover Max Angle", Range(0.001, 90)) = 35
        _Cover_Min_Height("Cover Min Height", Float) = -10000
        _Cover_Min_Height_Blending("Cover Min Height Blending", Range(0, 500)) = 1
        _CoverBaseColor("Cover Base Color", Color) = (1, 1, 1, 0)
        [NoScaleOffset]_CoverBaseColorMap("Cover Base Map (RGB) Mask (A)", 2D) = "white" {}
        _CoverTilingOffset("Cover Tiling Offset", Vector, 4) = (1, 1, 0, 0)
        [ToggleUI]_CoverUsePlanarUV("Cover Use Planar UV", Float) = 0
        [Normal][NoScaleOffset]_CoverNormalMap("Cover Normal Map", 2D) = "bump" {}
        _CoverNormalScale("Cover Normal Scale", Range(0, 8)) = 1
        _CoverNormalBlendHardness("Cover Normal Blend Hardness", Range(0, 8)) = 1
        _CoverHardness("Cover Hardness", Range(0, 10)) = 5
        _CoverHeightMapMin("Cover Height Map Min", Float) = 0
        _CoverHeightMapMax("Cover Height Map Max", Float) = 1
        _CoverHeightMapOffset("Cover Height Map Offset", Float) = 0
        [NoScaleOffset]_CoverMaskMap("Cover Mask Map MT(R) AO(G) H(B) SM(A)", 2D) = "white" {}
        _CoverMetallic("Cover Metallic", Range(0, 1)) = 1
        _CoverAORemapMin("Cover AO Remap Min", Range(0, 1)) = 0
        _CoverAORemapMax("Cover AO Remap Max", Range(0, 1)) = 1
        _CoverSmoothnessRemapMin("Cover Smoothness Remap Min", Range(0, 1)) = 0
        _CoverSmoothnessRemapMax("Cover Smoothness Remap Max", Range(0, 1)) = 1
        _WetColor("Wet Color Vertex(R)", Color) = (0.7735849, 0.7735849, 0.7735849, 0)
        _WetSmoothness("Wet Smoothness Vertex(R)", Range(0, 1)) = 1
        [HideInInspector]_WorkflowMode("_WorkflowMode", Float) = 1
        [HideInInspector]_CastShadows("_CastShadows", Float) = 1
        [HideInInspector]_ReceiveShadows("_ReceiveShadows", Float) = 1
        [HideInInspector]_Surface("_Surface", Float) = 1
        [HideInInspector]_Blend("_Blend", Float) = 0
        [HideInInspector]_AlphaClip("_AlphaClip", Float) = 1
        [HideInInspector]_BlendModePreserveSpecular("_BlendModePreserveSpecular", Float) = 0
        [HideInInspector]_SrcBlend("_SrcBlend", Float) = 1
        [HideInInspector]_DstBlend("_DstBlend", Float) = 0
        [HideInInspector]_SrcBlendAlpha("_SrcBlendAlpha", Float) = 1
        [HideInInspector]_DstBlendAlpha("_DstBlendAlpha", Float) = 0
        [HideInInspector][ToggleUI]_ZWrite("_ZWrite", Float) = 0
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
            "RenderType"="Transparent"
            "UniversalMaterialType" = "Lit"
            "Queue"="Transparent"
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
        #pragma shader_feature_local _ _USEDYNAMICCOVERTSTATICMASKF_ON
        
        #if defined(_USEDYNAMICCOVERTSTATICMASKF_ON)
            #define KEYWORD_PERMUTATION_0
        #else
            #define KEYWORD_PERMUTATION_1
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
        float4 _WetColor;
        float _WetSmoothness;
        float _AlphaCutoff;
        float4 _BaseColor;
        float4 _BaseColorMap_TexelSize;
        float _BaseUsePlanarUV;
        float4 _BaseTilingOffset;
        float4 _BaseNormalMap_TexelSize;
        float _BaseNormalScale;
        float4 _BaseMaskMap_TexelSize;
        float _BaseMetallic;
        float _BaseAORemapMin;
        float _BaseAORemapMax;
        float _BaseSmoothnessRemapMin;
        float _BaseSmoothnessRemapMax;
        float4 _LayerMask_TexelSize;
        float _Invert_Layer_Mask;
        float _Height_Transition;
        float _HeightMin;
        float _HeightMax;
        float _HeightOffset;
        float _HeightMin2;
        float _HeightMax2;
        float _HeightOffset2;
        float IgnoreBase2Alpha;
        float4 _Base2Color;
        float4 _Base2ColorMap_TexelSize;
        float4 _Base2TilingOffset;
        float _Base2UsePlanarUV;
        float4 _Base2NormalMap_TexelSize;
        float _Base2NormalScale;
        float4 _Base2MaskMap_TexelSize;
        float _Base2Metallic;
        float _Base2SmoothnessRemapMin;
        float _Base2SmoothnessRemapMax;
        float _Base2AORemapMin;
        float _Base2AORemapMax;
        float _CoverMaskPower;
        float _Cover_Amount;
        float _Cover_Amount_Grow_Speed;
        float _Cover_Max_Angle;
        float _Cover_Min_Height;
        float _Cover_Min_Height_Blending;
        float4 _CoverBaseColor;
        float4 _CoverBaseColorMap_TexelSize;
        float4 _CoverTilingOffset;
        float _CoverUsePlanarUV;
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
        UNITY_TEXTURE_STREAMING_DEBUG_VARS;
        CBUFFER_END
        
        
        // Object and Global properties
        SAMPLER(SamplerState_Linear_Repeat);
        SAMPLER(SamplerState_Linear_Repeat_Aniso8);
        TEXTURE2D(_BaseColorMap);
        SAMPLER(sampler_BaseColorMap);
        TEXTURE2D(_BaseNormalMap);
        SAMPLER(sampler_BaseNormalMap);
        TEXTURE2D(_BaseMaskMap);
        SAMPLER(sampler_BaseMaskMap);
        TEXTURE2D(_LayerMask);
        SAMPLER(sampler_LayerMask);
        TEXTURE2D(_Base2ColorMap);
        SAMPLER(sampler_Base2ColorMap);
        TEXTURE2D(_Base2NormalMap);
        SAMPLER(sampler_Base2NormalMap);
        TEXTURE2D(_Base2MaskMap);
        SAMPLER(sampler_Base2MaskMap);
        TEXTURE2D(_CoverBaseColorMap);
        SAMPLER(sampler_CoverBaseColorMap);
        TEXTURE2D(_CoverNormalMap);
        SAMPLER(sampler_CoverNormalMap);
        TEXTURE2D(_CoverMaskMap);
        SAMPLER(sampler_CoverMaskMap);
        
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
        
        void Unity_Add_float2(float2 A, float2 B, out float2 Out)
        {
            Out = A + B;
        }
        
        void Unity_Remap_float(float In, float2 InMinMax, float2 OutMinMax, out float Out)
        {
            Out = OutMinMax.x + (In - InMinMax.x) * (OutMinMax.y - OutMinMax.x) / (InMinMax.y - InMinMax.x);
        }
        
        void Unity_OneMinus_float(float In, out float Out)
        {
            Out = 1 - In;
        }
        
        void Unity_Branch_float(float Predicate, float True, float False, out float Out)
        {
            Out = Predicate ? True : False;
        }
        
        void Unity_Multiply_float_float(float A, float B, out float Out)
        {
            Out = A * B;
        }
        
        void Unity_Maximum_float(float A, float B, out float Out)
        {
            Out = max(A, B);
        }
        
        void Unity_Subtract_float(float A, float B, out float Out)
        {
            Out = A - B;
        }
        
        void Unity_Multiply_float3_float3(float3 A, float3 B, out float3 Out)
        {
        Out = A * B;
        }
        
        void Unity_Add_float3(float3 A, float3 B, out float3 Out)
        {
            Out = A + B;
        }
        
        void Unity_Add_float(float A, float B, out float Out)
        {
            Out = A + B;
        }
        
        void Unity_Divide_float3(float3 A, float3 B, out float3 Out)
        {
            Out = A / B;
        }
        
        struct Bindings_HeightBlend_d15b6fb865d3b6d4ebc1fd476c3ad135_float
        {
        };
        
        void SG_HeightBlend_d15b6fb865d3b6d4ebc1fd476c3ad135_float(float3 Vector3_88EEBB5E, float Vector1_DA0A37FA, float3 Vector3_79AA92F, float Vector1_F7E83F1E, float Vector1_1C9222A6, Bindings_HeightBlend_d15b6fb865d3b6d4ebc1fd476c3ad135_float IN, out float3 OutVector4_1)
        {
        float3 _Property_dd1c841a04c03f8c85e7b00eb025ecda_Out_0_Vector3 = Vector3_88EEBB5E;
        float _Property_14119cc7eaf4128f991283d47cf72d85_Out_0_Float = Vector1_DA0A37FA;
        float _Property_48af0ad45e3f7f82932b938695d21391_Out_0_Float = Vector1_DA0A37FA;
        float _Property_8a30b3ca12ff518fa473ccd686c7d503_Out_0_Float = Vector1_F7E83F1E;
        float _Maximum_c196e4a61637ea8381a3437c93f89ce2_Out_2_Float;
        Unity_Maximum_float(_Property_48af0ad45e3f7f82932b938695d21391_Out_0_Float, _Property_8a30b3ca12ff518fa473ccd686c7d503_Out_0_Float, _Maximum_c196e4a61637ea8381a3437c93f89ce2_Out_2_Float);
        float _Property_ee8d5fc69475d181be60c57e04ea8708_Out_0_Float = Vector1_1C9222A6;
        float _Subtract_61ca880c04c1758eb128f25c9faabd63_Out_2_Float;
        Unity_Subtract_float(_Maximum_c196e4a61637ea8381a3437c93f89ce2_Out_2_Float, _Property_ee8d5fc69475d181be60c57e04ea8708_Out_0_Float, _Subtract_61ca880c04c1758eb128f25c9faabd63_Out_2_Float);
        float _Subtract_e3a7713b556a1b8cb40aad97fc58d619_Out_2_Float;
        Unity_Subtract_float(_Property_14119cc7eaf4128f991283d47cf72d85_Out_0_Float, _Subtract_61ca880c04c1758eb128f25c9faabd63_Out_2_Float, _Subtract_e3a7713b556a1b8cb40aad97fc58d619_Out_2_Float);
        float _Maximum_d02e48d92038448cb0345e5cf3779071_Out_2_Float;
        Unity_Maximum_float(_Subtract_e3a7713b556a1b8cb40aad97fc58d619_Out_2_Float, float(0), _Maximum_d02e48d92038448cb0345e5cf3779071_Out_2_Float);
        float3 _Multiply_79b0b5d7d3528b8395e1135339a090f2_Out_2_Vector3;
        Unity_Multiply_float3_float3(_Property_dd1c841a04c03f8c85e7b00eb025ecda_Out_0_Vector3, (_Maximum_d02e48d92038448cb0345e5cf3779071_Out_2_Float.xxx), _Multiply_79b0b5d7d3528b8395e1135339a090f2_Out_2_Vector3);
        float3 _Property_c7292b3b08585f8c8670172b9a220bf0_Out_0_Vector3 = Vector3_79AA92F;
        float _Property_5e920479576fad83ba1947728dcceab4_Out_0_Float = Vector1_F7E83F1E;
        float _Subtract_b7368f21be9e048aae7f90c8a2bfaae1_Out_2_Float;
        Unity_Subtract_float(_Property_5e920479576fad83ba1947728dcceab4_Out_0_Float, _Subtract_61ca880c04c1758eb128f25c9faabd63_Out_2_Float, _Subtract_b7368f21be9e048aae7f90c8a2bfaae1_Out_2_Float);
        float _Maximum_216777d30802328eab607c8fe68ba3a1_Out_2_Float;
        Unity_Maximum_float(_Subtract_b7368f21be9e048aae7f90c8a2bfaae1_Out_2_Float, float(0), _Maximum_216777d30802328eab607c8fe68ba3a1_Out_2_Float);
        float3 _Multiply_a856b52cd0848f86a6ae1af9b175935c_Out_2_Vector3;
        Unity_Multiply_float3_float3(_Property_c7292b3b08585f8c8670172b9a220bf0_Out_0_Vector3, (_Maximum_216777d30802328eab607c8fe68ba3a1_Out_2_Float.xxx), _Multiply_a856b52cd0848f86a6ae1af9b175935c_Out_2_Vector3);
        float3 _Add_86c6109dc4530b8c9763ef62b056ad4c_Out_2_Vector3;
        Unity_Add_float3(_Multiply_79b0b5d7d3528b8395e1135339a090f2_Out_2_Vector3, _Multiply_a856b52cd0848f86a6ae1af9b175935c_Out_2_Vector3, _Add_86c6109dc4530b8c9763ef62b056ad4c_Out_2_Vector3);
        float _Add_356384b52728f583bd6e694bc1fc3738_Out_2_Float;
        Unity_Add_float(_Maximum_d02e48d92038448cb0345e5cf3779071_Out_2_Float, _Maximum_216777d30802328eab607c8fe68ba3a1_Out_2_Float, _Add_356384b52728f583bd6e694bc1fc3738_Out_2_Float);
        float _Maximum_94a22f5ceb706e88bc16350a5d5d2a82_Out_2_Float;
        Unity_Maximum_float(_Add_356384b52728f583bd6e694bc1fc3738_Out_2_Float, float(1E-05), _Maximum_94a22f5ceb706e88bc16350a5d5d2a82_Out_2_Float);
        float3 _Divide_d7291d1701d7058dbb5263194c1bed22_Out_2_Vector3;
        Unity_Divide_float3(_Add_86c6109dc4530b8c9763ef62b056ad4c_Out_2_Vector3, (_Maximum_94a22f5ceb706e88bc16350a5d5d2a82_Out_2_Float.xxx), _Divide_d7291d1701d7058dbb5263194c1bed22_Out_2_Vector3);
        OutVector4_1 = _Divide_d7291d1701d7058dbb5263194c1bed22_Out_2_Vector3;
        }
        
        void Unity_Clamp_float(float In, float Min, float Max, out float Out)
        {
            Out = clamp(In, Min, Max);
        }
        
        void Unity_Sign_float3(float3 In, out float3 Out)
        {
            Out = sign(In);
        }
        
        void Unity_Multiply_float2_float2(float2 A, float2 B, out float2 Out)
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
        
        void Unity_Absolute_float(float In, out float Out)
        {
            Out = abs(In);
        }
        
        void Unity_Power_float(float A, float B, out float Out)
        {
            Out = pow(A, B);
        }
        
        void Unity_Saturate_float(float In, out float Out)
        {
            Out = saturate(In);
        }
        
        void Unity_Lerp_float3(float3 A, float3 B, float3 T, out float3 Out)
        {
            Out = lerp(A, B, T);
        }
        
        void Unity_Lerp_float(float A, float B, float T, out float Out)
        {
            Out = lerp(A, B, T);
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
            UnityTexture2D _Property_07d75b1d2628da808a2efb93a1d6219e_Out_0_Texture2D = UnityBuildTexture2DStructNoScale(_BaseColorMap);
            float4 _Property_587a28253857318a9b2e59bfc8fb56a4_Out_0_Vector4 = _BaseTilingOffset;
            float _Property_7f998178363b4188ba2f07298ef869c1_Out_0_Boolean = _BaseUsePlanarUV;
            Bindings_PlanarNM_c0f081da9c567704ea36e7dd38cedcf6_float _PlanarNM_0b8fbae0d009788d8cd595a3b9bf9f6e;
            _PlanarNM_0b8fbae0d009788d8cd595a3b9bf9f6e.AbsoluteWorldSpacePosition = IN.AbsoluteWorldSpacePosition;
            _PlanarNM_0b8fbae0d009788d8cd595a3b9bf9f6e.uv0 = IN.uv0;
            _PlanarNM_0b8fbae0d009788d8cd595a3b9bf9f6e.uv3 = IN.uv3;
            float4 _PlanarNM_0b8fbae0d009788d8cd595a3b9bf9f6e_XZ_2_Vector4;
            SG_PlanarNM_c0f081da9c567704ea36e7dd38cedcf6_float(_Property_07d75b1d2628da808a2efb93a1d6219e_Out_0_Texture2D, _Property_587a28253857318a9b2e59bfc8fb56a4_Out_0_Vector4, _Property_7f998178363b4188ba2f07298ef869c1_Out_0_Boolean, UnityBuildSamplerStateStruct(SamplerState_Linear_Repeat_Aniso8), 1, _PlanarNM_0b8fbae0d009788d8cd595a3b9bf9f6e, _PlanarNM_0b8fbae0d009788d8cd595a3b9bf9f6e_XZ_2_Vector4);
            float4 _Property_b83097c58639858680bf43881a95b0af_Out_0_Vector4 = _BaseColor;
            float4 _Multiply_f572ff0def2d308e87a64e94a46c0d96_Out_2_Vector4;
            Unity_Multiply_float4_float4(_PlanarNM_0b8fbae0d009788d8cd595a3b9bf9f6e_XZ_2_Vector4, _Property_b83097c58639858680bf43881a95b0af_Out_0_Vector4, _Multiply_f572ff0def2d308e87a64e94a46c0d96_Out_2_Vector4);
            UnityTexture2D _Property_1e449ff9f8e8ec828507233e8240eb11_Out_0_Texture2D = UnityBuildTexture2DStructNoScale(_BaseMaskMap);
            Bindings_PlanarNM_c0f081da9c567704ea36e7dd38cedcf6_float _PlanarNM_4245c3b264047180b5c90a697d6cb278;
            _PlanarNM_4245c3b264047180b5c90a697d6cb278.AbsoluteWorldSpacePosition = IN.AbsoluteWorldSpacePosition;
            _PlanarNM_4245c3b264047180b5c90a697d6cb278.uv0 = IN.uv0;
            _PlanarNM_4245c3b264047180b5c90a697d6cb278.uv3 = IN.uv3;
            float4 _PlanarNM_4245c3b264047180b5c90a697d6cb278_XZ_2_Vector4;
            SG_PlanarNM_c0f081da9c567704ea36e7dd38cedcf6_float(_Property_1e449ff9f8e8ec828507233e8240eb11_Out_0_Texture2D, _Property_587a28253857318a9b2e59bfc8fb56a4_Out_0_Vector4, _Property_7f998178363b4188ba2f07298ef869c1_Out_0_Boolean, UnityBuildSamplerStateStruct(SamplerState_Linear_Repeat_Aniso8), 1, _PlanarNM_4245c3b264047180b5c90a697d6cb278, _PlanarNM_4245c3b264047180b5c90a697d6cb278_XZ_2_Vector4);
            float _Split_91a015dea8acd38b904ba0935328a5bc_R_1_Float = _PlanarNM_4245c3b264047180b5c90a697d6cb278_XZ_2_Vector4[0];
            float _Split_91a015dea8acd38b904ba0935328a5bc_G_2_Float = _PlanarNM_4245c3b264047180b5c90a697d6cb278_XZ_2_Vector4[1];
            float _Split_91a015dea8acd38b904ba0935328a5bc_B_3_Float = _PlanarNM_4245c3b264047180b5c90a697d6cb278_XZ_2_Vector4[2];
            float _Split_91a015dea8acd38b904ba0935328a5bc_A_4_Float = _PlanarNM_4245c3b264047180b5c90a697d6cb278_XZ_2_Vector4[3];
            float _Property_fbcff1469ebf488394a8a89ddaf0eb2a_Out_0_Float = _HeightMin;
            float _Property_9df7a44c8225168683743ac60c0c3c34_Out_0_Float = _HeightMax;
            float2 _Vector2_9b1e95888c28bc8893f28c02b87fa448_Out_0_Vector2 = float2(_Property_fbcff1469ebf488394a8a89ddaf0eb2a_Out_0_Float, _Property_9df7a44c8225168683743ac60c0c3c34_Out_0_Float);
            float _Property_29ca14fd0b712983a38d63d2dd326e96_Out_0_Float = _HeightOffset;
            float2 _Add_cb503f8a09720d84bb03cbd89e37b80c_Out_2_Vector2;
            Unity_Add_float2(_Vector2_9b1e95888c28bc8893f28c02b87fa448_Out_0_Vector2, (_Property_29ca14fd0b712983a38d63d2dd326e96_Out_0_Float.xx), _Add_cb503f8a09720d84bb03cbd89e37b80c_Out_2_Vector2);
            float _Remap_18f2e96a438d6584ae2fd56f880de9ee_Out_3_Float;
            Unity_Remap_float(_Split_91a015dea8acd38b904ba0935328a5bc_B_3_Float, float2 (0, 1), _Add_cb503f8a09720d84bb03cbd89e37b80c_Out_2_Vector2, _Remap_18f2e96a438d6584ae2fd56f880de9ee_Out_3_Float);
            UnityTexture2D _Property_ba3a5f4cba7d0a8fa288ffc8267d6c0e_Out_0_Texture2D = UnityBuildTexture2DStructNoScale(_Base2ColorMap);
            float4 _Property_86a4657df480d48e8d3ad3b036731380_Out_0_Vector4 = _Base2TilingOffset;
            float _Property_6c5e16c615cab08a97c2a577642b9d83_Out_0_Boolean = _Base2UsePlanarUV;
            Bindings_PlanarNM_c0f081da9c567704ea36e7dd38cedcf6_float _PlanarNM_5aeab444ca6fd78ea56a01215880a5a4;
            _PlanarNM_5aeab444ca6fd78ea56a01215880a5a4.AbsoluteWorldSpacePosition = IN.AbsoluteWorldSpacePosition;
            _PlanarNM_5aeab444ca6fd78ea56a01215880a5a4.uv0 = IN.uv0;
            _PlanarNM_5aeab444ca6fd78ea56a01215880a5a4.uv3 = IN.uv3;
            float4 _PlanarNM_5aeab444ca6fd78ea56a01215880a5a4_XZ_2_Vector4;
            SG_PlanarNM_c0f081da9c567704ea36e7dd38cedcf6_float(_Property_ba3a5f4cba7d0a8fa288ffc8267d6c0e_Out_0_Texture2D, _Property_86a4657df480d48e8d3ad3b036731380_Out_0_Vector4, _Property_6c5e16c615cab08a97c2a577642b9d83_Out_0_Boolean, UnityBuildSamplerStateStruct(SamplerState_Linear_Repeat_Aniso8), 1, _PlanarNM_5aeab444ca6fd78ea56a01215880a5a4, _PlanarNM_5aeab444ca6fd78ea56a01215880a5a4_XZ_2_Vector4);
            float4 _Property_3561b11b899bda8e855826445cf628aa_Out_0_Vector4 = _Base2Color;
            float4 _Multiply_d2ec682582195e84acc4a8510f50f4b0_Out_2_Vector4;
            Unity_Multiply_float4_float4(_PlanarNM_5aeab444ca6fd78ea56a01215880a5a4_XZ_2_Vector4, _Property_3561b11b899bda8e855826445cf628aa_Out_0_Vector4, _Multiply_d2ec682582195e84acc4a8510f50f4b0_Out_2_Vector4);
            float _Split_c34b73d933404283983f9c8bdb5365d3_R_1_Float = IN.VertexColor[0];
            float _Split_c34b73d933404283983f9c8bdb5365d3_G_2_Float = IN.VertexColor[1];
            float _Split_c34b73d933404283983f9c8bdb5365d3_B_3_Float = IN.VertexColor[2];
            float _Split_c34b73d933404283983f9c8bdb5365d3_A_4_Float = IN.VertexColor[3];
            float _Property_df2df7bb5cfc3381beee7ec454da7542_Out_0_Boolean = _Invert_Layer_Mask;
            UnityTexture2D _Property_c7b1e2df9f9b0e8eace9b2274924e69c_Out_0_Texture2D = UnityBuildTexture2DStructNoScale(_LayerMask);
            float4 _SampleTexture2D_175fb18fafc9598382f1f5f7e97bf30a_RGBA_0_Vector4 = SAMPLE_TEXTURE2D(_Property_c7b1e2df9f9b0e8eace9b2274924e69c_Out_0_Texture2D.tex, _Property_c7b1e2df9f9b0e8eace9b2274924e69c_Out_0_Texture2D.samplerstate, _Property_c7b1e2df9f9b0e8eace9b2274924e69c_Out_0_Texture2D.GetTransformedUV(IN.uv0.xy) );
            float _SampleTexture2D_175fb18fafc9598382f1f5f7e97bf30a_R_4_Float = _SampleTexture2D_175fb18fafc9598382f1f5f7e97bf30a_RGBA_0_Vector4.r;
            float _SampleTexture2D_175fb18fafc9598382f1f5f7e97bf30a_G_5_Float = _SampleTexture2D_175fb18fafc9598382f1f5f7e97bf30a_RGBA_0_Vector4.g;
            float _SampleTexture2D_175fb18fafc9598382f1f5f7e97bf30a_B_6_Float = _SampleTexture2D_175fb18fafc9598382f1f5f7e97bf30a_RGBA_0_Vector4.b;
            float _SampleTexture2D_175fb18fafc9598382f1f5f7e97bf30a_A_7_Float = _SampleTexture2D_175fb18fafc9598382f1f5f7e97bf30a_RGBA_0_Vector4.a;
            float _OneMinus_ce5c3c0635d4ac86beb55115d0ebaed7_Out_1_Float;
            Unity_OneMinus_float(_SampleTexture2D_175fb18fafc9598382f1f5f7e97bf30a_R_4_Float, _OneMinus_ce5c3c0635d4ac86beb55115d0ebaed7_Out_1_Float);
            float _Branch_af0c5e511241ce8eae748ae487df50fa_Out_3_Float;
            Unity_Branch_float(_Property_df2df7bb5cfc3381beee7ec454da7542_Out_0_Boolean, _OneMinus_ce5c3c0635d4ac86beb55115d0ebaed7_Out_1_Float, _SampleTexture2D_175fb18fafc9598382f1f5f7e97bf30a_R_4_Float, _Branch_af0c5e511241ce8eae748ae487df50fa_Out_3_Float);
            UnityTexture2D _Property_de4f6eb48a629285a664dad7fb06438f_Out_0_Texture2D = UnityBuildTexture2DStructNoScale(_Base2MaskMap);
            Bindings_PlanarNM_c0f081da9c567704ea36e7dd38cedcf6_float _PlanarNM_d5657f470f05ef839e4c257a20ace8cb;
            _PlanarNM_d5657f470f05ef839e4c257a20ace8cb.AbsoluteWorldSpacePosition = IN.AbsoluteWorldSpacePosition;
            _PlanarNM_d5657f470f05ef839e4c257a20ace8cb.uv0 = IN.uv0;
            _PlanarNM_d5657f470f05ef839e4c257a20ace8cb.uv3 = IN.uv3;
            float4 _PlanarNM_d5657f470f05ef839e4c257a20ace8cb_XZ_2_Vector4;
            SG_PlanarNM_c0f081da9c567704ea36e7dd38cedcf6_float(_Property_de4f6eb48a629285a664dad7fb06438f_Out_0_Texture2D, _Property_86a4657df480d48e8d3ad3b036731380_Out_0_Vector4, _Property_6c5e16c615cab08a97c2a577642b9d83_Out_0_Boolean, UnityBuildSamplerStateStruct(SamplerState_Linear_Repeat_Aniso8), 1, _PlanarNM_d5657f470f05ef839e4c257a20ace8cb, _PlanarNM_d5657f470f05ef839e4c257a20ace8cb_XZ_2_Vector4);
            float _Split_83ec66b648ab6c84848b42686c256cd7_R_1_Float = _PlanarNM_d5657f470f05ef839e4c257a20ace8cb_XZ_2_Vector4[0];
            float _Split_83ec66b648ab6c84848b42686c256cd7_G_2_Float = _PlanarNM_d5657f470f05ef839e4c257a20ace8cb_XZ_2_Vector4[1];
            float _Split_83ec66b648ab6c84848b42686c256cd7_B_3_Float = _PlanarNM_d5657f470f05ef839e4c257a20ace8cb_XZ_2_Vector4[2];
            float _Split_83ec66b648ab6c84848b42686c256cd7_A_4_Float = _PlanarNM_d5657f470f05ef839e4c257a20ace8cb_XZ_2_Vector4[3];
            float _Property_ce1750e5c69e97818667b412fc3f9f2c_Out_0_Float = _HeightMin2;
            float _Property_8e0f2ea54d8ede89bbabdf31a9bafd57_Out_0_Float = _HeightMax2;
            float2 _Vector2_fb6c6dd7e70e768ba686e8e94153bb96_Out_0_Vector2 = float2(_Property_ce1750e5c69e97818667b412fc3f9f2c_Out_0_Float, _Property_8e0f2ea54d8ede89bbabdf31a9bafd57_Out_0_Float);
            float _Property_151ae2702b614585af2000f0a812960f_Out_0_Float = _HeightOffset2;
            float2 _Add_fd1b3d8e24e77087a55888eeb238f1a6_Out_2_Vector2;
            Unity_Add_float2(_Vector2_fb6c6dd7e70e768ba686e8e94153bb96_Out_0_Vector2, (_Property_151ae2702b614585af2000f0a812960f_Out_0_Float.xx), _Add_fd1b3d8e24e77087a55888eeb238f1a6_Out_2_Vector2);
            float _Remap_3d4180c0ab36ba86a5517b2645f0bfa7_Out_3_Float;
            Unity_Remap_float(_Split_83ec66b648ab6c84848b42686c256cd7_B_3_Float, float2 (0, 1), _Add_fd1b3d8e24e77087a55888eeb238f1a6_Out_2_Vector2, _Remap_3d4180c0ab36ba86a5517b2645f0bfa7_Out_3_Float);
            float _Multiply_2cb0e5aa384654828f0453a44884573c_Out_2_Float;
            Unity_Multiply_float_float(_Branch_af0c5e511241ce8eae748ae487df50fa_Out_3_Float, _Remap_3d4180c0ab36ba86a5517b2645f0bfa7_Out_3_Float, _Multiply_2cb0e5aa384654828f0453a44884573c_Out_2_Float);
            float _Multiply_74def30593cbbb8bbed03613a31cb89a_Out_2_Float;
            Unity_Multiply_float_float(_Split_c34b73d933404283983f9c8bdb5365d3_G_2_Float, _Multiply_2cb0e5aa384654828f0453a44884573c_Out_2_Float, _Multiply_74def30593cbbb8bbed03613a31cb89a_Out_2_Float);
            float _Property_818c8af4b930138e81034c886614171d_Out_0_Float = _Height_Transition;
            Bindings_HeightBlend_d15b6fb865d3b6d4ebc1fd476c3ad135_float _HeightBlend_7501025b3a60738a9a9d362e35a9ab48;
            float3 _HeightBlend_7501025b3a60738a9a9d362e35a9ab48_OutVector4_1_Vector3;
            SG_HeightBlend_d15b6fb865d3b6d4ebc1fd476c3ad135_float((_Multiply_f572ff0def2d308e87a64e94a46c0d96_Out_2_Vector4.xyz), _Remap_18f2e96a438d6584ae2fd56f880de9ee_Out_3_Float, (_Multiply_d2ec682582195e84acc4a8510f50f4b0_Out_2_Vector4.xyz), _Multiply_74def30593cbbb8bbed03613a31cb89a_Out_2_Float, _Property_818c8af4b930138e81034c886614171d_Out_0_Float, _HeightBlend_7501025b3a60738a9a9d362e35a9ab48, _HeightBlend_7501025b3a60738a9a9d362e35a9ab48_OutVector4_1_Vector3);
            UnityTexture2D _Property_c0ebdab0f71ace8aabaa865fd7293599_Out_0_Texture2D = UnityBuildTexture2DStructNoScale(_CoverBaseColorMap);
            float4 _Property_822489d2e6d3e08590c64f085ffd9b2e_Out_0_Vector4 = _CoverTilingOffset;
            float _Property_2ae4a163bd21d98789af282d6e469175_Out_0_Boolean = _CoverUsePlanarUV;
            Bindings_PlanarNM_c0f081da9c567704ea36e7dd38cedcf6_float _PlanarNM_8bb420494d19b28e9ccdff489802dc81;
            _PlanarNM_8bb420494d19b28e9ccdff489802dc81.AbsoluteWorldSpacePosition = IN.AbsoluteWorldSpacePosition;
            _PlanarNM_8bb420494d19b28e9ccdff489802dc81.uv0 = IN.uv0;
            _PlanarNM_8bb420494d19b28e9ccdff489802dc81.uv3 = IN.uv3;
            float4 _PlanarNM_8bb420494d19b28e9ccdff489802dc81_XZ_2_Vector4;
            SG_PlanarNM_c0f081da9c567704ea36e7dd38cedcf6_float(_Property_c0ebdab0f71ace8aabaa865fd7293599_Out_0_Texture2D, _Property_822489d2e6d3e08590c64f085ffd9b2e_Out_0_Vector4, _Property_2ae4a163bd21d98789af282d6e469175_Out_0_Boolean, UnityBuildSamplerStateStruct(SamplerState_Linear_Repeat_Aniso8), 1, _PlanarNM_8bb420494d19b28e9ccdff489802dc81, _PlanarNM_8bb420494d19b28e9ccdff489802dc81_XZ_2_Vector4);
            float4 _Property_55e7941fa7ac5f8387aa9bb633b08883_Out_0_Vector4 = _CoverBaseColor;
            float4 _Multiply_a38ba695a2660c8691763f0bd7fe159c_Out_2_Vector4;
            Unity_Multiply_float4_float4(_PlanarNM_8bb420494d19b28e9ccdff489802dc81_XZ_2_Vector4, _Property_55e7941fa7ac5f8387aa9bb633b08883_Out_0_Vector4, _Multiply_a38ba695a2660c8691763f0bd7fe159c_Out_2_Vector4);
            UnityTexture2D _Property_3b351481f7b944ffaf5f59649df41ba9_Out_0_Texture2D = UnityBuildTexture2DStructNoScale(_CoverBaseColorMap);
            float4 _UV_5352c8dd0add178ba83a5421c2c0b3f0_Out_0_Vector4 = IN.uv0;
            float4 _SampleTexture2D_024ba490c015248988a12a9d670014ea_RGBA_0_Vector4 = SAMPLE_TEXTURE2D(_Property_3b351481f7b944ffaf5f59649df41ba9_Out_0_Texture2D.tex, _Property_3b351481f7b944ffaf5f59649df41ba9_Out_0_Texture2D.samplerstate, _Property_3b351481f7b944ffaf5f59649df41ba9_Out_0_Texture2D.GetTransformedUV((_UV_5352c8dd0add178ba83a5421c2c0b3f0_Out_0_Vector4.xy)) );
            float _SampleTexture2D_024ba490c015248988a12a9d670014ea_R_4_Float = _SampleTexture2D_024ba490c015248988a12a9d670014ea_RGBA_0_Vector4.r;
            float _SampleTexture2D_024ba490c015248988a12a9d670014ea_G_5_Float = _SampleTexture2D_024ba490c015248988a12a9d670014ea_RGBA_0_Vector4.g;
            float _SampleTexture2D_024ba490c015248988a12a9d670014ea_B_6_Float = _SampleTexture2D_024ba490c015248988a12a9d670014ea_RGBA_0_Vector4.b;
            float _SampleTexture2D_024ba490c015248988a12a9d670014ea_A_7_Float = _SampleTexture2D_024ba490c015248988a12a9d670014ea_RGBA_0_Vector4.a;
            float _Property_b80e7b96604b7c82bbf9bff4981fad76_Out_0_Float = _CoverMaskPower;
            float _Multiply_abe410d256783480b1b58468bf78a882_Out_2_Float;
            Unity_Multiply_float_float(_SampleTexture2D_024ba490c015248988a12a9d670014ea_A_7_Float, _Property_b80e7b96604b7c82bbf9bff4981fad76_Out_0_Float, _Multiply_abe410d256783480b1b58468bf78a882_Out_2_Float);
            float _Clamp_a78f6f28770afd869adb9d12cd47370b_Out_3_Float;
            Unity_Clamp_float(_Multiply_abe410d256783480b1b58468bf78a882_Out_2_Float, float(0), float(1), _Clamp_a78f6f28770afd869adb9d12cd47370b_Out_3_Float);
            UnityTexture2D _Property_7c7049e15fdff386b535790d8666f609_Out_0_Texture2D = UnityBuildTexture2DStructNoScale(_BaseNormalMap);
            Bindings_PlanarNMn_1b93a87456f9d4c419321d0cd92bd6c8_float _PlanarNMn_a3713a9c3874b6838d0eda971b9c62d8;
            _PlanarNMn_a3713a9c3874b6838d0eda971b9c62d8.WorldSpaceNormal = IN.WorldSpaceNormal;
            _PlanarNMn_a3713a9c3874b6838d0eda971b9c62d8.WorldSpaceTangent = IN.WorldSpaceTangent;
            _PlanarNMn_a3713a9c3874b6838d0eda971b9c62d8.WorldSpaceBiTangent = IN.WorldSpaceBiTangent;
            _PlanarNMn_a3713a9c3874b6838d0eda971b9c62d8.AbsoluteWorldSpacePosition = IN.AbsoluteWorldSpacePosition;
            _PlanarNMn_a3713a9c3874b6838d0eda971b9c62d8.uv0 = IN.uv0;
            _PlanarNMn_a3713a9c3874b6838d0eda971b9c62d8.uv3 = IN.uv3;
            float4 _PlanarNMn_a3713a9c3874b6838d0eda971b9c62d8_XZ_2_Vector4;
            SG_PlanarNMn_1b93a87456f9d4c419321d0cd92bd6c8_float(_Property_7c7049e15fdff386b535790d8666f609_Out_0_Texture2D, _Property_587a28253857318a9b2e59bfc8fb56a4_Out_0_Vector4, _Property_7f998178363b4188ba2f07298ef869c1_Out_0_Boolean, UnityBuildSamplerStateStruct(SamplerState_Linear_Repeat_Aniso8), 1, _PlanarNMn_a3713a9c3874b6838d0eda971b9c62d8, _PlanarNMn_a3713a9c3874b6838d0eda971b9c62d8_XZ_2_Vector4);
            float _Property_d4b0759cf4647e81be065ec1465ce2b4_Out_0_Float = _BaseNormalScale;
            float3 _NormalStrength_f66a9108ea294886acc61513b41cc5e4_Out_2_Vector3;
            Unity_NormalStrength_float((_PlanarNMn_a3713a9c3874b6838d0eda971b9c62d8_XZ_2_Vector4.xyz), _Property_d4b0759cf4647e81be065ec1465ce2b4_Out_0_Float, _NormalStrength_f66a9108ea294886acc61513b41cc5e4_Out_2_Vector3);
            UnityTexture2D _Property_fa9f7890b20ad481a92543c04b237bde_Out_0_Texture2D = UnityBuildTexture2DStructNoScale(_Base2NormalMap);
            Bindings_PlanarNMn_1b93a87456f9d4c419321d0cd92bd6c8_float _PlanarNMn_d7b3ec528088a085a5102e025a1b45cf;
            _PlanarNMn_d7b3ec528088a085a5102e025a1b45cf.WorldSpaceNormal = IN.WorldSpaceNormal;
            _PlanarNMn_d7b3ec528088a085a5102e025a1b45cf.WorldSpaceTangent = IN.WorldSpaceTangent;
            _PlanarNMn_d7b3ec528088a085a5102e025a1b45cf.WorldSpaceBiTangent = IN.WorldSpaceBiTangent;
            _PlanarNMn_d7b3ec528088a085a5102e025a1b45cf.AbsoluteWorldSpacePosition = IN.AbsoluteWorldSpacePosition;
            _PlanarNMn_d7b3ec528088a085a5102e025a1b45cf.uv0 = IN.uv0;
            _PlanarNMn_d7b3ec528088a085a5102e025a1b45cf.uv3 = IN.uv3;
            float4 _PlanarNMn_d7b3ec528088a085a5102e025a1b45cf_XZ_2_Vector4;
            SG_PlanarNMn_1b93a87456f9d4c419321d0cd92bd6c8_float(_Property_fa9f7890b20ad481a92543c04b237bde_Out_0_Texture2D, _Property_86a4657df480d48e8d3ad3b036731380_Out_0_Vector4, _Property_6c5e16c615cab08a97c2a577642b9d83_Out_0_Boolean, UnityBuildSamplerStateStruct(SamplerState_Linear_Repeat_Aniso8), 1, _PlanarNMn_d7b3ec528088a085a5102e025a1b45cf, _PlanarNMn_d7b3ec528088a085a5102e025a1b45cf_XZ_2_Vector4);
            float _Property_8c31443b776727819a663c7ddce79064_Out_0_Float = _Base2NormalScale;
            float3 _NormalStrength_0fb86880ab8e368dac6d01b830e20ed8_Out_2_Vector3;
            Unity_NormalStrength_float((_PlanarNMn_d7b3ec528088a085a5102e025a1b45cf_XZ_2_Vector4.xyz), _Property_8c31443b776727819a663c7ddce79064_Out_0_Float, _NormalStrength_0fb86880ab8e368dac6d01b830e20ed8_Out_2_Vector3);
            Bindings_HeightBlend_d15b6fb865d3b6d4ebc1fd476c3ad135_float _HeightBlend_7c09d97625efce898e21b66cd039be8b;
            float3 _HeightBlend_7c09d97625efce898e21b66cd039be8b_OutVector4_1_Vector3;
            SG_HeightBlend_d15b6fb865d3b6d4ebc1fd476c3ad135_float(_NormalStrength_f66a9108ea294886acc61513b41cc5e4_Out_2_Vector3, _Remap_18f2e96a438d6584ae2fd56f880de9ee_Out_3_Float, _NormalStrength_0fb86880ab8e368dac6d01b830e20ed8_Out_2_Vector3, _Multiply_74def30593cbbb8bbed03613a31cb89a_Out_2_Float, _Property_818c8af4b930138e81034c886614171d_Out_0_Float, _HeightBlend_7c09d97625efce898e21b66cd039be8b, _HeightBlend_7c09d97625efce898e21b66cd039be8b_OutVector4_1_Vector3);
            UnityTexture2D _Property_65f7dd6fe6c29b83913af586c597a1ef_Out_0_Texture2D = UnityBuildTexture2DStructNoScale(_CoverNormalMap);
            Bindings_PlanarNMn_1b93a87456f9d4c419321d0cd92bd6c8_float _PlanarNMn_248bc5b7421d3f828d166902c73ca6c3;
            _PlanarNMn_248bc5b7421d3f828d166902c73ca6c3.WorldSpaceNormal = IN.WorldSpaceNormal;
            _PlanarNMn_248bc5b7421d3f828d166902c73ca6c3.WorldSpaceTangent = IN.WorldSpaceTangent;
            _PlanarNMn_248bc5b7421d3f828d166902c73ca6c3.WorldSpaceBiTangent = IN.WorldSpaceBiTangent;
            _PlanarNMn_248bc5b7421d3f828d166902c73ca6c3.AbsoluteWorldSpacePosition = IN.AbsoluteWorldSpacePosition;
            _PlanarNMn_248bc5b7421d3f828d166902c73ca6c3.uv0 = IN.uv0;
            _PlanarNMn_248bc5b7421d3f828d166902c73ca6c3.uv3 = IN.uv3;
            float4 _PlanarNMn_248bc5b7421d3f828d166902c73ca6c3_XZ_2_Vector4;
            SG_PlanarNMn_1b93a87456f9d4c419321d0cd92bd6c8_float(_Property_65f7dd6fe6c29b83913af586c597a1ef_Out_0_Texture2D, _Property_822489d2e6d3e08590c64f085ffd9b2e_Out_0_Vector4, _Property_2ae4a163bd21d98789af282d6e469175_Out_0_Boolean, UnityBuildSamplerStateStruct(SamplerState_Linear_Repeat_Aniso8), 1, _PlanarNMn_248bc5b7421d3f828d166902c73ca6c3, _PlanarNMn_248bc5b7421d3f828d166902c73ca6c3_XZ_2_Vector4);
            float _Property_19f92cae42737480a95820c51d4ba124_Out_0_Float = _CoverNormalBlendHardness;
            float3 _NormalStrength_2c3488591b8345869feb25a3dee06c3f_Out_2_Vector3;
            Unity_NormalStrength_float((_PlanarNMn_248bc5b7421d3f828d166902c73ca6c3_XZ_2_Vector4.xyz), _Property_19f92cae42737480a95820c51d4ba124_Out_0_Float, _NormalStrength_2c3488591b8345869feb25a3dee06c3f_Out_2_Vector3);
            float _Split_96bfe9cb80ad308385c191d094b3d071_R_1_Float = IN.WorldSpaceNormal[0];
            float _Split_96bfe9cb80ad308385c191d094b3d071_G_2_Float = IN.WorldSpaceNormal[1];
            float _Split_96bfe9cb80ad308385c191d094b3d071_B_3_Float = IN.WorldSpaceNormal[2];
            float _Split_96bfe9cb80ad308385c191d094b3d071_A_4_Float = 0;
            float _Property_0dd796aae8cd9f878bef13ceac4fe3ec_Out_0_Float = _Cover_Amount;
            float _Property_67285cdc688aa38d83f62d5bb095d597_Out_0_Float = _Cover_Amount_Grow_Speed;
            float _Subtract_fcefec675e7536888eccf5574d921972_Out_2_Float;
            Unity_Subtract_float(float(4), _Property_67285cdc688aa38d83f62d5bb095d597_Out_0_Float, _Subtract_fcefec675e7536888eccf5574d921972_Out_2_Float);
            float _Divide_1e25465528e612839a4ce1faedd89e7d_Out_2_Float;
            Unity_Divide_float(_Property_0dd796aae8cd9f878bef13ceac4fe3ec_Out_0_Float, _Subtract_fcefec675e7536888eccf5574d921972_Out_2_Float, _Divide_1e25465528e612839a4ce1faedd89e7d_Out_2_Float);
            float _Absolute_d20b810ffdec828ab74dd6692d82f01b_Out_1_Float;
            Unity_Absolute_float(_Divide_1e25465528e612839a4ce1faedd89e7d_Out_2_Float, _Absolute_d20b810ffdec828ab74dd6692d82f01b_Out_1_Float);
            float _Power_181fbf47cfdb258da1fe0b72a450986f_Out_2_Float;
            Unity_Power_float(_Absolute_d20b810ffdec828ab74dd6692d82f01b_Out_1_Float, _Subtract_fcefec675e7536888eccf5574d921972_Out_2_Float, _Power_181fbf47cfdb258da1fe0b72a450986f_Out_2_Float);
            float _Clamp_11f62dba01f1a38c9e0a9972ccd19246_Out_3_Float;
            Unity_Clamp_float(_Power_181fbf47cfdb258da1fe0b72a450986f_Out_2_Float, float(0), float(2), _Clamp_11f62dba01f1a38c9e0a9972ccd19246_Out_3_Float);
            float _Multiply_9810f6d76275cd8fbe5e3a02360b98a7_Out_2_Float;
            Unity_Multiply_float_float(_Split_96bfe9cb80ad308385c191d094b3d071_G_2_Float, _Clamp_11f62dba01f1a38c9e0a9972ccd19246_Out_3_Float, _Multiply_9810f6d76275cd8fbe5e3a02360b98a7_Out_2_Float);
            float _Saturate_a007c5f214685c87bf6ca3e64c06b488_Out_1_Float;
            Unity_Saturate_float(_Multiply_9810f6d76275cd8fbe5e3a02360b98a7_Out_2_Float, _Saturate_a007c5f214685c87bf6ca3e64c06b488_Out_1_Float);
            float _Clamp_1b2b25b617fc508b9835f0309136fd00_Out_3_Float;
            Unity_Clamp_float(_Split_96bfe9cb80ad308385c191d094b3d071_G_2_Float, float(0), float(0.9999), _Clamp_1b2b25b617fc508b9835f0309136fd00_Out_3_Float);
            float _Property_7b12276ea7a4538db6804507b30a830c_Out_0_Float = _Cover_Max_Angle;
            float _Divide_54c523ff4b7acb858e9e368fd1e4d34a_Out_2_Float;
            Unity_Divide_float(_Property_7b12276ea7a4538db6804507b30a830c_Out_0_Float, float(45), _Divide_54c523ff4b7acb858e9e368fd1e4d34a_Out_2_Float);
            float _OneMinus_6cf431985b651e8e9546ae6cb2d4d668_Out_1_Float;
            Unity_OneMinus_float(_Divide_54c523ff4b7acb858e9e368fd1e4d34a_Out_2_Float, _OneMinus_6cf431985b651e8e9546ae6cb2d4d668_Out_1_Float);
            float _Subtract_4ef7b60aeab8d589bf2d2423737642bc_Out_2_Float;
            Unity_Subtract_float(_Clamp_1b2b25b617fc508b9835f0309136fd00_Out_3_Float, _OneMinus_6cf431985b651e8e9546ae6cb2d4d668_Out_1_Float, _Subtract_4ef7b60aeab8d589bf2d2423737642bc_Out_2_Float);
            float _Clamp_a4b51894ea17818c9a27bb533a2ebe74_Out_3_Float;
            Unity_Clamp_float(_Subtract_4ef7b60aeab8d589bf2d2423737642bc_Out_2_Float, float(0), float(2), _Clamp_a4b51894ea17818c9a27bb533a2ebe74_Out_3_Float);
            float _Divide_c4196d4f02190b89ba827ccd4ae8a74d_Out_2_Float;
            Unity_Divide_float(float(1), _Divide_54c523ff4b7acb858e9e368fd1e4d34a_Out_2_Float, _Divide_c4196d4f02190b89ba827ccd4ae8a74d_Out_2_Float);
            float _Multiply_ffc22433163d1184846ede424b44bcb2_Out_2_Float;
            Unity_Multiply_float_float(_Clamp_a4b51894ea17818c9a27bb533a2ebe74_Out_3_Float, _Divide_c4196d4f02190b89ba827ccd4ae8a74d_Out_2_Float, _Multiply_ffc22433163d1184846ede424b44bcb2_Out_2_Float);
            float _Absolute_c2e5757082de5d878d4c023806fb2108_Out_1_Float;
            Unity_Absolute_float(_Multiply_ffc22433163d1184846ede424b44bcb2_Out_2_Float, _Absolute_c2e5757082de5d878d4c023806fb2108_Out_1_Float);
            float _Property_849d9f217c95f38c9d49ab251578d8d5_Out_0_Float = _CoverHardness;
            float _Power_578546d66d69a5829b745ebba1279adf_Out_2_Float;
            Unity_Power_float(_Absolute_c2e5757082de5d878d4c023806fb2108_Out_1_Float, _Property_849d9f217c95f38c9d49ab251578d8d5_Out_0_Float, _Power_578546d66d69a5829b745ebba1279adf_Out_2_Float);
            float _Property_34d2d3aff4814e8e83d2894b3512c6c8_Out_0_Float = _Cover_Min_Height;
            float _OneMinus_474df64227f004849b34c68fe8df93f2_Out_1_Float;
            Unity_OneMinus_float(_Property_34d2d3aff4814e8e83d2894b3512c6c8_Out_0_Float, _OneMinus_474df64227f004849b34c68fe8df93f2_Out_1_Float);
            float _Split_ee4d9dc934b3508397d5a3dece110ab0_R_1_Float = IN.AbsoluteWorldSpacePosition[0];
            float _Split_ee4d9dc934b3508397d5a3dece110ab0_G_2_Float = IN.AbsoluteWorldSpacePosition[1];
            float _Split_ee4d9dc934b3508397d5a3dece110ab0_B_3_Float = IN.AbsoluteWorldSpacePosition[2];
            float _Split_ee4d9dc934b3508397d5a3dece110ab0_A_4_Float = 0;
            float _Add_d6bc513aa82d918ea24e279f4353d971_Out_2_Float;
            Unity_Add_float(_OneMinus_474df64227f004849b34c68fe8df93f2_Out_1_Float, _Split_ee4d9dc934b3508397d5a3dece110ab0_G_2_Float, _Add_d6bc513aa82d918ea24e279f4353d971_Out_2_Float);
            float _Add_a6a61cb12180108c9e1364b90d2673e2_Out_2_Float;
            Unity_Add_float(_Add_d6bc513aa82d918ea24e279f4353d971_Out_2_Float, float(1), _Add_a6a61cb12180108c9e1364b90d2673e2_Out_2_Float);
            float _Clamp_1874fdd00cb9aa839d93ab8536e2414d_Out_3_Float;
            Unity_Clamp_float(_Add_a6a61cb12180108c9e1364b90d2673e2_Out_2_Float, float(0), float(1), _Clamp_1874fdd00cb9aa839d93ab8536e2414d_Out_3_Float);
            float _Property_7b91fd6e21b46c85816c7b681307cbe4_Out_0_Float = _Cover_Min_Height_Blending;
            float _Add_6dca9453f6a35e8185c4b8e9782db0a9_Out_2_Float;
            Unity_Add_float(_Add_d6bc513aa82d918ea24e279f4353d971_Out_2_Float, _Property_7b91fd6e21b46c85816c7b681307cbe4_Out_0_Float, _Add_6dca9453f6a35e8185c4b8e9782db0a9_Out_2_Float);
            float _Divide_83415a319ecfba83af914cbc5487b546_Out_2_Float;
            Unity_Divide_float(_Add_6dca9453f6a35e8185c4b8e9782db0a9_Out_2_Float, _Add_d6bc513aa82d918ea24e279f4353d971_Out_2_Float, _Divide_83415a319ecfba83af914cbc5487b546_Out_2_Float);
            float _OneMinus_bf150b22fcad5a87b7c825c9c6cf1687_Out_1_Float;
            Unity_OneMinus_float(_Divide_83415a319ecfba83af914cbc5487b546_Out_2_Float, _OneMinus_bf150b22fcad5a87b7c825c9c6cf1687_Out_1_Float);
            float _Add_86ff9fa850efbe8c80705d8266609dab_Out_2_Float;
            Unity_Add_float(_OneMinus_bf150b22fcad5a87b7c825c9c6cf1687_Out_1_Float, float(-0.5), _Add_86ff9fa850efbe8c80705d8266609dab_Out_2_Float);
            float _Clamp_906e140f01222d8ba61252ec6ec9d6a4_Out_3_Float;
            Unity_Clamp_float(_Add_86ff9fa850efbe8c80705d8266609dab_Out_2_Float, float(0), float(1), _Clamp_906e140f01222d8ba61252ec6ec9d6a4_Out_3_Float);
            float _Add_c1ec5849bf72f585a30b3e11a91ada52_Out_2_Float;
            Unity_Add_float(_Clamp_1874fdd00cb9aa839d93ab8536e2414d_Out_3_Float, _Clamp_906e140f01222d8ba61252ec6ec9d6a4_Out_3_Float, _Add_c1ec5849bf72f585a30b3e11a91ada52_Out_2_Float);
            float _Clamp_17a8a0cf209a038b9e9c7f5681cdd1fb_Out_3_Float;
            Unity_Clamp_float(_Add_c1ec5849bf72f585a30b3e11a91ada52_Out_2_Float, float(0), float(1), _Clamp_17a8a0cf209a038b9e9c7f5681cdd1fb_Out_3_Float);
            float _Multiply_8c2759ac24a9b289b1e9610cfd161bb0_Out_2_Float;
            Unity_Multiply_float_float(_Power_578546d66d69a5829b745ebba1279adf_Out_2_Float, _Clamp_17a8a0cf209a038b9e9c7f5681cdd1fb_Out_3_Float, _Multiply_8c2759ac24a9b289b1e9610cfd161bb0_Out_2_Float);
            float _Multiply_1a723f136ec7fa8c957b5d29e03d3051_Out_2_Float;
            Unity_Multiply_float_float(_Saturate_a007c5f214685c87bf6ca3e64c06b488_Out_1_Float, _Multiply_8c2759ac24a9b289b1e9610cfd161bb0_Out_2_Float, _Multiply_1a723f136ec7fa8c957b5d29e03d3051_Out_2_Float);
            float3 _Lerp_d1c72e47b283948584479177786ae8d5_Out_3_Vector3;
            Unity_Lerp_float3(_HeightBlend_7c09d97625efce898e21b66cd039be8b_OutVector4_1_Vector3, _NormalStrength_2c3488591b8345869feb25a3dee06c3f_Out_2_Vector3, (_Multiply_1a723f136ec7fa8c957b5d29e03d3051_Out_2_Float.xxx), _Lerp_d1c72e47b283948584479177786ae8d5_Out_3_Vector3);
            float3 _Transform_180fb403b53f318db002e8eba7616644_Out_1_Vector3;
            {
                float3x3 tangentTransform = float3x3(IN.WorldSpaceTangent, IN.WorldSpaceBiTangent, IN.WorldSpaceNormal);
                _Transform_180fb403b53f318db002e8eba7616644_Out_1_Vector3 = TransformTangentToWorldDir(_Lerp_d1c72e47b283948584479177786ae8d5_Out_3_Vector3.xyz, tangentTransform, true).xyz;
            }
            float _Split_c9a2b4fb4f688b8ebfc1436535cd5ba4_R_1_Float = _Transform_180fb403b53f318db002e8eba7616644_Out_1_Vector3[0];
            float _Split_c9a2b4fb4f688b8ebfc1436535cd5ba4_G_2_Float = _Transform_180fb403b53f318db002e8eba7616644_Out_1_Vector3[1];
            float _Split_c9a2b4fb4f688b8ebfc1436535cd5ba4_B_3_Float = _Transform_180fb403b53f318db002e8eba7616644_Out_1_Vector3[2];
            float _Split_c9a2b4fb4f688b8ebfc1436535cd5ba4_A_4_Float = 0;
            float _Multiply_4c7631d0688102819e6d388d624855a1_Out_2_Float;
            Unity_Multiply_float_float(_Split_c9a2b4fb4f688b8ebfc1436535cd5ba4_G_2_Float, _Clamp_11f62dba01f1a38c9e0a9972ccd19246_Out_3_Float, _Multiply_4c7631d0688102819e6d388d624855a1_Out_2_Float);
            float _Multiply_f2887eb409f6bb81ae4caad2b01b17f1_Out_2_Float;
            Unity_Multiply_float_float(_Clamp_11f62dba01f1a38c9e0a9972ccd19246_Out_3_Float, _Property_849d9f217c95f38c9d49ab251578d8d5_Out_0_Float, _Multiply_f2887eb409f6bb81ae4caad2b01b17f1_Out_2_Float);
            float _Multiply_2e348ed31331e78791b2b3130a009f30_Out_2_Float;
            Unity_Multiply_float_float(_Multiply_f2887eb409f6bb81ae4caad2b01b17f1_Out_2_Float, _Multiply_8c2759ac24a9b289b1e9610cfd161bb0_Out_2_Float, _Multiply_2e348ed31331e78791b2b3130a009f30_Out_2_Float);
            float _Multiply_622e54e9a77b08839c0954ce5715ad1c_Out_2_Float;
            Unity_Multiply_float_float(_Multiply_4c7631d0688102819e6d388d624855a1_Out_2_Float, _Multiply_2e348ed31331e78791b2b3130a009f30_Out_2_Float, _Multiply_622e54e9a77b08839c0954ce5715ad1c_Out_2_Float);
            UnityTexture2D _Property_608db04fab7d768d9a8b5fb9cf0768e1_Out_0_Texture2D = UnityBuildTexture2DStructNoScale(_CoverMaskMap);
            Bindings_PlanarNM_c0f081da9c567704ea36e7dd38cedcf6_float _PlanarNM_819c993d9b62a28ea640d2bacdc62c6e;
            _PlanarNM_819c993d9b62a28ea640d2bacdc62c6e.AbsoluteWorldSpacePosition = IN.AbsoluteWorldSpacePosition;
            _PlanarNM_819c993d9b62a28ea640d2bacdc62c6e.uv0 = IN.uv0;
            _PlanarNM_819c993d9b62a28ea640d2bacdc62c6e.uv3 = IN.uv3;
            float4 _PlanarNM_819c993d9b62a28ea640d2bacdc62c6e_XZ_2_Vector4;
            SG_PlanarNM_c0f081da9c567704ea36e7dd38cedcf6_float(_Property_608db04fab7d768d9a8b5fb9cf0768e1_Out_0_Texture2D, _Property_822489d2e6d3e08590c64f085ffd9b2e_Out_0_Vector4, _Property_2ae4a163bd21d98789af282d6e469175_Out_0_Boolean, UnityBuildSamplerStateStruct(SamplerState_Linear_Repeat_Aniso8), 1, _PlanarNM_819c993d9b62a28ea640d2bacdc62c6e, _PlanarNM_819c993d9b62a28ea640d2bacdc62c6e_XZ_2_Vector4);
            float _Split_86ec1aefda4f9e8e82b79c6195b397b0_R_1_Float = _PlanarNM_819c993d9b62a28ea640d2bacdc62c6e_XZ_2_Vector4[0];
            float _Split_86ec1aefda4f9e8e82b79c6195b397b0_G_2_Float = _PlanarNM_819c993d9b62a28ea640d2bacdc62c6e_XZ_2_Vector4[1];
            float _Split_86ec1aefda4f9e8e82b79c6195b397b0_B_3_Float = _PlanarNM_819c993d9b62a28ea640d2bacdc62c6e_XZ_2_Vector4[2];
            float _Split_86ec1aefda4f9e8e82b79c6195b397b0_A_4_Float = _PlanarNM_819c993d9b62a28ea640d2bacdc62c6e_XZ_2_Vector4[3];
            float _Property_c9c6897e00458b8f8aa07df49fa519bc_Out_0_Float = _CoverHeightMapMin;
            float _Property_ab94650b8edd82828661fe99e3c0e849_Out_0_Float = _CoverHeightMapMax;
            float2 _Vector2_fe489f7321f6568686816b9eecbc16d1_Out_0_Vector2 = float2(_Property_c9c6897e00458b8f8aa07df49fa519bc_Out_0_Float, _Property_ab94650b8edd82828661fe99e3c0e849_Out_0_Float);
            float _Property_c1ab40024cb83b87960e4327efbd997f_Out_0_Float = _CoverHeightMapOffset;
            float2 _Add_4a359522fc231c83b55ef23f341b6fb3_Out_2_Vector2;
            Unity_Add_float2(_Vector2_fe489f7321f6568686816b9eecbc16d1_Out_0_Vector2, (_Property_c1ab40024cb83b87960e4327efbd997f_Out_0_Float.xx), _Add_4a359522fc231c83b55ef23f341b6fb3_Out_2_Vector2);
            float _Remap_5aee5b64d41562858dc7c42d8b748894_Out_3_Float;
            Unity_Remap_float(_Split_86ec1aefda4f9e8e82b79c6195b397b0_B_3_Float, float2 (0, 1), _Add_4a359522fc231c83b55ef23f341b6fb3_Out_2_Vector2, _Remap_5aee5b64d41562858dc7c42d8b748894_Out_3_Float);
            float _Multiply_f0228e1cfd9c858dbb36367f551733c4_Out_2_Float;
            Unity_Multiply_float_float(_Multiply_622e54e9a77b08839c0954ce5715ad1c_Out_2_Float, _Remap_5aee5b64d41562858dc7c42d8b748894_Out_3_Float, _Multiply_f0228e1cfd9c858dbb36367f551733c4_Out_2_Float);
            float _Multiply_bb4d60728db93b8a9af9635fa1d69891_Out_2_Float;
            Unity_Multiply_float_float(_Split_c34b73d933404283983f9c8bdb5365d3_B_3_Float, _Multiply_f0228e1cfd9c858dbb36367f551733c4_Out_2_Float, _Multiply_bb4d60728db93b8a9af9635fa1d69891_Out_2_Float);
            float _Saturate_9b052a9bb99eff89bb11bdc387a0c2fd_Out_1_Float;
            Unity_Saturate_float(_Multiply_bb4d60728db93b8a9af9635fa1d69891_Out_2_Float, _Saturate_9b052a9bb99eff89bb11bdc387a0c2fd_Out_1_Float);
            float _Multiply_22fb8c1cfd28b687a991e101aa13ff5b_Out_2_Float;
            Unity_Multiply_float_float(_Clamp_a78f6f28770afd869adb9d12cd47370b_Out_3_Float, _Saturate_9b052a9bb99eff89bb11bdc387a0c2fd_Out_1_Float, _Multiply_22fb8c1cfd28b687a991e101aa13ff5b_Out_2_Float);
            #if defined(_USEDYNAMICCOVERTSTATICMASKF_ON)
            float _UseDynamicCoverTStaticMaskF_20dcbac2f16cf78ebd6fd1debcd7f281_Out_0_Float = _Multiply_22fb8c1cfd28b687a991e101aa13ff5b_Out_2_Float;
            #else
            float _UseDynamicCoverTStaticMaskF_20dcbac2f16cf78ebd6fd1debcd7f281_Out_0_Float = _Clamp_a78f6f28770afd869adb9d12cd47370b_Out_3_Float;
            #endif
            float3 _Lerp_e5620b57c917728fa1416e2ffce9b0db_Out_3_Vector3;
            Unity_Lerp_float3(_HeightBlend_7501025b3a60738a9a9d362e35a9ab48_OutVector4_1_Vector3, (_Multiply_a38ba695a2660c8691763f0bd7fe159c_Out_2_Vector4.xyz), (_UseDynamicCoverTStaticMaskF_20dcbac2f16cf78ebd6fd1debcd7f281_Out_0_Float.xxx), _Lerp_e5620b57c917728fa1416e2ffce9b0db_Out_3_Vector3);
            float4 _Property_7946b761100c49199abc52129949bc94_Out_0_Vector4 = _WetColor;
            float3 _Multiply_f722561c89f8451497c9823ad4f29f4a_Out_2_Vector3;
            Unity_Multiply_float3_float3((_Property_7946b761100c49199abc52129949bc94_Out_0_Vector4.xyz), _Lerp_e5620b57c917728fa1416e2ffce9b0db_Out_3_Vector3, _Multiply_f722561c89f8451497c9823ad4f29f4a_Out_2_Vector3);
            float _OneMinus_6ed96e068e394cd09ae03c32446777c8_Out_1_Float;
            Unity_OneMinus_float(_Split_c34b73d933404283983f9c8bdb5365d3_R_1_Float, _OneMinus_6ed96e068e394cd09ae03c32446777c8_Out_1_Float);
            float3 _Lerp_c16da1ee314d4393a798b1d36f6733d8_Out_3_Vector3;
            Unity_Lerp_float3(_Lerp_e5620b57c917728fa1416e2ffce9b0db_Out_3_Vector3, _Multiply_f722561c89f8451497c9823ad4f29f4a_Out_2_Vector3, (_OneMinus_6ed96e068e394cd09ae03c32446777c8_Out_1_Float.xxx), _Lerp_c16da1ee314d4393a798b1d36f6733d8_Out_3_Vector3);
            float _Property_7b9efcab84158389b4a4ea1e24b5601a_Out_0_Float = _CoverNormalScale;
            float3 _NormalStrength_8f42544d1b3ae08092fb1812b8119cfa_Out_2_Vector3;
            Unity_NormalStrength_float((_PlanarNMn_248bc5b7421d3f828d166902c73ca6c3_XZ_2_Vector4.xyz), _Property_7b9efcab84158389b4a4ea1e24b5601a_Out_0_Float, _NormalStrength_8f42544d1b3ae08092fb1812b8119cfa_Out_2_Vector3);
            float3 _Lerp_18ca18da5861e688a3fb637172636eda_Out_3_Vector3;
            Unity_Lerp_float3(_HeightBlend_7c09d97625efce898e21b66cd039be8b_OutVector4_1_Vector3, _NormalStrength_8f42544d1b3ae08092fb1812b8119cfa_Out_2_Vector3, (_UseDynamicCoverTStaticMaskF_20dcbac2f16cf78ebd6fd1debcd7f281_Out_0_Float.xxx), _Lerp_18ca18da5861e688a3fb637172636eda_Out_3_Vector3);
            float _Property_afd0f3561038ef8487e614f350d364dd_Out_0_Float = _BaseMetallic;
            float _Multiply_154e0f89b19c8e86926222afb13691e3_Out_2_Float;
            Unity_Multiply_float_float(_Split_91a015dea8acd38b904ba0935328a5bc_R_1_Float, _Property_afd0f3561038ef8487e614f350d364dd_Out_0_Float, _Multiply_154e0f89b19c8e86926222afb13691e3_Out_2_Float);
            float _Property_b82ce26778f44c8fa3510d1a8ed92d0d_Out_0_Float = _BaseAORemapMin;
            float _Property_9d07c7a09a85da809f1d4661406e0888_Out_0_Float = _BaseAORemapMax;
            float2 _Vector2_10162c774de2a7838426399cfe98be82_Out_0_Vector2 = float2(_Property_b82ce26778f44c8fa3510d1a8ed92d0d_Out_0_Float, _Property_9d07c7a09a85da809f1d4661406e0888_Out_0_Float);
            float _Remap_c45fda31db668c81a9e89e11297ec993_Out_3_Float;
            Unity_Remap_float(_Split_91a015dea8acd38b904ba0935328a5bc_G_2_Float, float2 (0, 1), _Vector2_10162c774de2a7838426399cfe98be82_Out_0_Vector2, _Remap_c45fda31db668c81a9e89e11297ec993_Out_3_Float);
            float _Property_04a7bb2753456b8293b3e46e346b646e_Out_0_Float = _BaseSmoothnessRemapMin;
            float _Property_75c8631fc908bb8ba8542d2e70d18cbf_Out_0_Float = _BaseSmoothnessRemapMax;
            float2 _Vector2_b2e1a3c487cdf88f9b5992b831ba24d6_Out_0_Vector2 = float2(_Property_04a7bb2753456b8293b3e46e346b646e_Out_0_Float, _Property_75c8631fc908bb8ba8542d2e70d18cbf_Out_0_Float);
            float _Remap_65ca5af95590f88da70777476b6efd40_Out_3_Float;
            Unity_Remap_float(_Split_91a015dea8acd38b904ba0935328a5bc_A_4_Float, float2 (0, 1), _Vector2_b2e1a3c487cdf88f9b5992b831ba24d6_Out_0_Vector2, _Remap_65ca5af95590f88da70777476b6efd40_Out_3_Float);
            float3 _Vector3_28c1e2dadb10138a9799d970043db9b0_Out_0_Vector3 = float3(_Multiply_154e0f89b19c8e86926222afb13691e3_Out_2_Float, _Remap_c45fda31db668c81a9e89e11297ec993_Out_3_Float, _Remap_65ca5af95590f88da70777476b6efd40_Out_3_Float);
            float _Property_4ead43cc6d37b68eb268dd80c3a561e9_Out_0_Float = _Base2Metallic;
            float _Multiply_eef7838a4634498b9cf12d1bee89d853_Out_2_Float;
            Unity_Multiply_float_float(_Split_83ec66b648ab6c84848b42686c256cd7_R_1_Float, _Property_4ead43cc6d37b68eb268dd80c3a561e9_Out_0_Float, _Multiply_eef7838a4634498b9cf12d1bee89d853_Out_2_Float);
            float _Property_e1ed9fe432388887abb17b07dcc5ca6b_Out_0_Float = _Base2AORemapMin;
            float _Property_cb0cf7882dcbcf88989a12f73fb7c917_Out_0_Float = _Base2AORemapMax;
            float2 _Vector2_2d74d82ae79d5681a097c2e3ce20c913_Out_0_Vector2 = float2(_Property_e1ed9fe432388887abb17b07dcc5ca6b_Out_0_Float, _Property_cb0cf7882dcbcf88989a12f73fb7c917_Out_0_Float);
            float _Remap_dcd2e2871e334281a15cdd1da6103c7f_Out_3_Float;
            Unity_Remap_float(_Split_83ec66b648ab6c84848b42686c256cd7_G_2_Float, float2 (0, 1), _Vector2_2d74d82ae79d5681a097c2e3ce20c913_Out_0_Vector2, _Remap_dcd2e2871e334281a15cdd1da6103c7f_Out_3_Float);
            float _Property_159cd47513de4f85a992da1f43f77c51_Out_0_Float = _Base2SmoothnessRemapMin;
            float _Property_b1f3c7061cf84380b1a0ffc2c5f770db_Out_0_Float = _Base2SmoothnessRemapMax;
            float2 _Vector2_eb0fcc98def54d83abe1cfec60457b78_Out_0_Vector2 = float2(_Property_159cd47513de4f85a992da1f43f77c51_Out_0_Float, _Property_b1f3c7061cf84380b1a0ffc2c5f770db_Out_0_Float);
            float _Remap_1214803bb0f7c387adc088fb938f7971_Out_3_Float;
            Unity_Remap_float(_Split_83ec66b648ab6c84848b42686c256cd7_A_4_Float, float2 (0, 1), _Vector2_eb0fcc98def54d83abe1cfec60457b78_Out_0_Vector2, _Remap_1214803bb0f7c387adc088fb938f7971_Out_3_Float);
            float3 _Vector3_ddb5452f73a0dc819b57dbe981a5f4e7_Out_0_Vector3 = float3(_Multiply_eef7838a4634498b9cf12d1bee89d853_Out_2_Float, _Remap_dcd2e2871e334281a15cdd1da6103c7f_Out_3_Float, _Remap_1214803bb0f7c387adc088fb938f7971_Out_3_Float);
            Bindings_HeightBlend_d15b6fb865d3b6d4ebc1fd476c3ad135_float _HeightBlend_3ef23bc9c463ea8f91d2c1bc27c32dff;
            float3 _HeightBlend_3ef23bc9c463ea8f91d2c1bc27c32dff_OutVector4_1_Vector3;
            SG_HeightBlend_d15b6fb865d3b6d4ebc1fd476c3ad135_float(_Vector3_28c1e2dadb10138a9799d970043db9b0_Out_0_Vector3, _Remap_18f2e96a438d6584ae2fd56f880de9ee_Out_3_Float, _Vector3_ddb5452f73a0dc819b57dbe981a5f4e7_Out_0_Vector3, _Multiply_74def30593cbbb8bbed03613a31cb89a_Out_2_Float, _Property_818c8af4b930138e81034c886614171d_Out_0_Float, _HeightBlend_3ef23bc9c463ea8f91d2c1bc27c32dff, _HeightBlend_3ef23bc9c463ea8f91d2c1bc27c32dff_OutVector4_1_Vector3);
            float _Property_6dbb3498614f2088a1315529ed864ea3_Out_0_Float = _CoverMetallic;
            float _Multiply_7a0f3f362f18fd86b9191e28255508f8_Out_2_Float;
            Unity_Multiply_float_float(_Split_86ec1aefda4f9e8e82b79c6195b397b0_R_1_Float, _Property_6dbb3498614f2088a1315529ed864ea3_Out_0_Float, _Multiply_7a0f3f362f18fd86b9191e28255508f8_Out_2_Float);
            float _Property_840e5ecb6a2ddb83abffd7be403ecd68_Out_0_Float = _CoverAORemapMin;
            float _Property_92176ee70059d28abbfcad689b580f1a_Out_0_Float = _CoverAORemapMax;
            float2 _Vector2_2b0ddb771cc86988a6f70ca3c4d0145b_Out_0_Vector2 = float2(_Property_840e5ecb6a2ddb83abffd7be403ecd68_Out_0_Float, _Property_92176ee70059d28abbfcad689b580f1a_Out_0_Float);
            float _Remap_1091f204ac00858d804a3785be14a17e_Out_3_Float;
            Unity_Remap_float(_Split_86ec1aefda4f9e8e82b79c6195b397b0_G_2_Float, float2 (0, 1), _Vector2_2b0ddb771cc86988a6f70ca3c4d0145b_Out_0_Vector2, _Remap_1091f204ac00858d804a3785be14a17e_Out_3_Float);
            float _Property_4cd4964a0372a3858a89e499b8d810a1_Out_0_Float = _CoverSmoothnessRemapMin;
            float _Property_f7e67cf191e5c38388370531311427cf_Out_0_Float = _CoverSmoothnessRemapMax;
            float2 _Vector2_60ae45a9f680358085440c61ca0118da_Out_0_Vector2 = float2(_Property_4cd4964a0372a3858a89e499b8d810a1_Out_0_Float, _Property_f7e67cf191e5c38388370531311427cf_Out_0_Float);
            float _Remap_e88a1283399b2187be29c818a3fc3543_Out_3_Float;
            Unity_Remap_float(_Split_86ec1aefda4f9e8e82b79c6195b397b0_A_4_Float, float2 (0, 1), _Vector2_60ae45a9f680358085440c61ca0118da_Out_0_Vector2, _Remap_e88a1283399b2187be29c818a3fc3543_Out_3_Float);
            float3 _Vector3_83d0f92fd33a1d8799fdafb5ae407cb7_Out_0_Vector3 = float3(_Multiply_7a0f3f362f18fd86b9191e28255508f8_Out_2_Float, _Remap_1091f204ac00858d804a3785be14a17e_Out_3_Float, _Remap_e88a1283399b2187be29c818a3fc3543_Out_3_Float);
            float3 _Lerp_afcfe197cbc3818eb5aaaa1cf503c7d4_Out_3_Vector3;
            Unity_Lerp_float3(_HeightBlend_3ef23bc9c463ea8f91d2c1bc27c32dff_OutVector4_1_Vector3, _Vector3_83d0f92fd33a1d8799fdafb5ae407cb7_Out_0_Vector3, (_UseDynamicCoverTStaticMaskF_20dcbac2f16cf78ebd6fd1debcd7f281_Out_0_Float.xxx), _Lerp_afcfe197cbc3818eb5aaaa1cf503c7d4_Out_3_Vector3);
            float _Split_93a6a2f8a95a1b80bea53b3c9628de7b_R_1_Float = _Lerp_afcfe197cbc3818eb5aaaa1cf503c7d4_Out_3_Vector3[0];
            float _Split_93a6a2f8a95a1b80bea53b3c9628de7b_G_2_Float = _Lerp_afcfe197cbc3818eb5aaaa1cf503c7d4_Out_3_Vector3[1];
            float _Split_93a6a2f8a95a1b80bea53b3c9628de7b_B_3_Float = _Lerp_afcfe197cbc3818eb5aaaa1cf503c7d4_Out_3_Vector3[2];
            float _Split_93a6a2f8a95a1b80bea53b3c9628de7b_A_4_Float = 0;
            float _Property_9e7eba3ba76f44e696fc2af012d437a5_Out_0_Float = _WetSmoothness;
            float _Lerp_b882eb16978042e3b7f6df830e253797_Out_3_Float;
            Unity_Lerp_float(_Split_93a6a2f8a95a1b80bea53b3c9628de7b_B_3_Float, _Property_9e7eba3ba76f44e696fc2af012d437a5_Out_0_Float, _OneMinus_6ed96e068e394cd09ae03c32446777c8_Out_1_Float, _Lerp_b882eb16978042e3b7f6df830e253797_Out_3_Float);
            float _Split_c7a719bf7da79a8ea38d7311fd844f92_R_1_Float = _Multiply_f572ff0def2d308e87a64e94a46c0d96_Out_2_Vector4[0];
            float _Split_c7a719bf7da79a8ea38d7311fd844f92_G_2_Float = _Multiply_f572ff0def2d308e87a64e94a46c0d96_Out_2_Vector4[1];
            float _Split_c7a719bf7da79a8ea38d7311fd844f92_B_3_Float = _Multiply_f572ff0def2d308e87a64e94a46c0d96_Out_2_Vector4[2];
            float _Split_c7a719bf7da79a8ea38d7311fd844f92_A_4_Float = _Multiply_f572ff0def2d308e87a64e94a46c0d96_Out_2_Vector4[3];
            float _Property_7c5dae9b46c9e686b49e58fa996a104a_Out_0_Boolean = IgnoreBase2Alpha;
            float _Split_e9060f5c0433ec889696d3e462f3229b_R_1_Float = _Multiply_d2ec682582195e84acc4a8510f50f4b0_Out_2_Vector4[0];
            float _Split_e9060f5c0433ec889696d3e462f3229b_G_2_Float = _Multiply_d2ec682582195e84acc4a8510f50f4b0_Out_2_Vector4[1];
            float _Split_e9060f5c0433ec889696d3e462f3229b_B_3_Float = _Multiply_d2ec682582195e84acc4a8510f50f4b0_Out_2_Vector4[2];
            float _Split_e9060f5c0433ec889696d3e462f3229b_A_4_Float = _Multiply_d2ec682582195e84acc4a8510f50f4b0_Out_2_Vector4[3];
            float _Branch_a7d7aece30fd9b8eb456d191fdd37a06_Out_3_Float;
            Unity_Branch_float(_Property_7c5dae9b46c9e686b49e58fa996a104a_Out_0_Boolean, _Split_c7a719bf7da79a8ea38d7311fd844f92_A_4_Float, _Split_e9060f5c0433ec889696d3e462f3229b_A_4_Float, _Branch_a7d7aece30fd9b8eb456d191fdd37a06_Out_3_Float);
            float _Lerp_8692ca93f568998fbc97130b6dbc4556_Out_3_Float;
            Unity_Lerp_float(_Split_c7a719bf7da79a8ea38d7311fd844f92_A_4_Float, _Branch_a7d7aece30fd9b8eb456d191fdd37a06_Out_3_Float, _Multiply_74def30593cbbb8bbed03613a31cb89a_Out_2_Float, _Lerp_8692ca93f568998fbc97130b6dbc4556_Out_3_Float);
            float _Clamp_0c8b7b55b9f82588ab2dcff09ee7a16d_Out_3_Float;
            Unity_Clamp_float(_Lerp_8692ca93f568998fbc97130b6dbc4556_Out_3_Float, float(0), float(1), _Clamp_0c8b7b55b9f82588ab2dcff09ee7a16d_Out_3_Float);
            float _Multiply_6333dc4a6348088bb7281602ce6bff5f_Out_2_Float;
            Unity_Multiply_float_float(_Clamp_0c8b7b55b9f82588ab2dcff09ee7a16d_Out_3_Float, _Split_c34b73d933404283983f9c8bdb5365d3_A_4_Float, _Multiply_6333dc4a6348088bb7281602ce6bff5f_Out_2_Float);
            float _Clamp_9642b8fb7e32b18a91da1888c9bc375b_Out_3_Float;
            Unity_Clamp_float(_Multiply_6333dc4a6348088bb7281602ce6bff5f_Out_2_Float, float(0), float(1), _Clamp_9642b8fb7e32b18a91da1888c9bc375b_Out_3_Float);
            float _Property_8bc98dd454a5508b9864a6ba09772356_Out_0_Float = _AlphaCutoff;
            surface.BaseColor = _Lerp_c16da1ee314d4393a798b1d36f6733d8_Out_3_Vector3;
            surface.NormalTS = _Lerp_18ca18da5861e688a3fb637172636eda_Out_3_Vector3;
            surface.Emission = float3(0, 0, 0);
            surface.Metallic = _Split_93a6a2f8a95a1b80bea53b3c9628de7b_R_1_Float;
            surface.Specular = IsGammaSpace() ? float3(0.5, 0.5, 0.5) : SRGBToLinear(float3(0.5, 0.5, 0.5));
            surface.Smoothness = _Lerp_b882eb16978042e3b7f6df830e253797_Out_3_Float;
            surface.Occlusion = _Split_93a6a2f8a95a1b80bea53b3c9628de7b_G_2_Float;
            surface.Alpha = _Clamp_9642b8fb7e32b18a91da1888c9bc375b_Out_3_Float;
            surface.AlphaClipThreshold = _Property_8bc98dd454a5508b9864a6ba09772356_Out_0_Float;
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
        #pragma shader_feature_local _ _USEDYNAMICCOVERTSTATICMASKF_ON
        
        #if defined(_USEDYNAMICCOVERTSTATICMASKF_ON)
            #define KEYWORD_PERMUTATION_0
        #else
            #define KEYWORD_PERMUTATION_1
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
        float4 _WetColor;
        float _WetSmoothness;
        float _AlphaCutoff;
        float4 _BaseColor;
        float4 _BaseColorMap_TexelSize;
        float _BaseUsePlanarUV;
        float4 _BaseTilingOffset;
        float4 _BaseNormalMap_TexelSize;
        float _BaseNormalScale;
        float4 _BaseMaskMap_TexelSize;
        float _BaseMetallic;
        float _BaseAORemapMin;
        float _BaseAORemapMax;
        float _BaseSmoothnessRemapMin;
        float _BaseSmoothnessRemapMax;
        float4 _LayerMask_TexelSize;
        float _Invert_Layer_Mask;
        float _Height_Transition;
        float _HeightMin;
        float _HeightMax;
        float _HeightOffset;
        float _HeightMin2;
        float _HeightMax2;
        float _HeightOffset2;
        float IgnoreBase2Alpha;
        float4 _Base2Color;
        float4 _Base2ColorMap_TexelSize;
        float4 _Base2TilingOffset;
        float _Base2UsePlanarUV;
        float4 _Base2NormalMap_TexelSize;
        float _Base2NormalScale;
        float4 _Base2MaskMap_TexelSize;
        float _Base2Metallic;
        float _Base2SmoothnessRemapMin;
        float _Base2SmoothnessRemapMax;
        float _Base2AORemapMin;
        float _Base2AORemapMax;
        float _CoverMaskPower;
        float _Cover_Amount;
        float _Cover_Amount_Grow_Speed;
        float _Cover_Max_Angle;
        float _Cover_Min_Height;
        float _Cover_Min_Height_Blending;
        float4 _CoverBaseColor;
        float4 _CoverBaseColorMap_TexelSize;
        float4 _CoverTilingOffset;
        float _CoverUsePlanarUV;
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
        UNITY_TEXTURE_STREAMING_DEBUG_VARS;
        CBUFFER_END
        
        
        // Object and Global properties
        SAMPLER(SamplerState_Linear_Repeat);
        SAMPLER(SamplerState_Linear_Repeat_Aniso8);
        TEXTURE2D(_BaseColorMap);
        SAMPLER(sampler_BaseColorMap);
        TEXTURE2D(_BaseNormalMap);
        SAMPLER(sampler_BaseNormalMap);
        TEXTURE2D(_BaseMaskMap);
        SAMPLER(sampler_BaseMaskMap);
        TEXTURE2D(_LayerMask);
        SAMPLER(sampler_LayerMask);
        TEXTURE2D(_Base2ColorMap);
        SAMPLER(sampler_Base2ColorMap);
        TEXTURE2D(_Base2NormalMap);
        SAMPLER(sampler_Base2NormalMap);
        TEXTURE2D(_Base2MaskMap);
        SAMPLER(sampler_Base2MaskMap);
        TEXTURE2D(_CoverBaseColorMap);
        SAMPLER(sampler_CoverBaseColorMap);
        TEXTURE2D(_CoverNormalMap);
        SAMPLER(sampler_CoverNormalMap);
        TEXTURE2D(_CoverMaskMap);
        SAMPLER(sampler_CoverMaskMap);
        
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
        
        void Unity_Add_float2(float2 A, float2 B, out float2 Out)
        {
            Out = A + B;
        }
        
        void Unity_Remap_float(float In, float2 InMinMax, float2 OutMinMax, out float Out)
        {
            Out = OutMinMax.x + (In - InMinMax.x) * (OutMinMax.y - OutMinMax.x) / (InMinMax.y - InMinMax.x);
        }
        
        void Unity_OneMinus_float(float In, out float Out)
        {
            Out = 1 - In;
        }
        
        void Unity_Branch_float(float Predicate, float True, float False, out float Out)
        {
            Out = Predicate ? True : False;
        }
        
        void Unity_Multiply_float_float(float A, float B, out float Out)
        {
            Out = A * B;
        }
        
        void Unity_Maximum_float(float A, float B, out float Out)
        {
            Out = max(A, B);
        }
        
        void Unity_Subtract_float(float A, float B, out float Out)
        {
            Out = A - B;
        }
        
        void Unity_Multiply_float3_float3(float3 A, float3 B, out float3 Out)
        {
        Out = A * B;
        }
        
        void Unity_Add_float3(float3 A, float3 B, out float3 Out)
        {
            Out = A + B;
        }
        
        void Unity_Add_float(float A, float B, out float Out)
        {
            Out = A + B;
        }
        
        void Unity_Divide_float3(float3 A, float3 B, out float3 Out)
        {
            Out = A / B;
        }
        
        struct Bindings_HeightBlend_d15b6fb865d3b6d4ebc1fd476c3ad135_float
        {
        };
        
        void SG_HeightBlend_d15b6fb865d3b6d4ebc1fd476c3ad135_float(float3 Vector3_88EEBB5E, float Vector1_DA0A37FA, float3 Vector3_79AA92F, float Vector1_F7E83F1E, float Vector1_1C9222A6, Bindings_HeightBlend_d15b6fb865d3b6d4ebc1fd476c3ad135_float IN, out float3 OutVector4_1)
        {
        float3 _Property_dd1c841a04c03f8c85e7b00eb025ecda_Out_0_Vector3 = Vector3_88EEBB5E;
        float _Property_14119cc7eaf4128f991283d47cf72d85_Out_0_Float = Vector1_DA0A37FA;
        float _Property_48af0ad45e3f7f82932b938695d21391_Out_0_Float = Vector1_DA0A37FA;
        float _Property_8a30b3ca12ff518fa473ccd686c7d503_Out_0_Float = Vector1_F7E83F1E;
        float _Maximum_c196e4a61637ea8381a3437c93f89ce2_Out_2_Float;
        Unity_Maximum_float(_Property_48af0ad45e3f7f82932b938695d21391_Out_0_Float, _Property_8a30b3ca12ff518fa473ccd686c7d503_Out_0_Float, _Maximum_c196e4a61637ea8381a3437c93f89ce2_Out_2_Float);
        float _Property_ee8d5fc69475d181be60c57e04ea8708_Out_0_Float = Vector1_1C9222A6;
        float _Subtract_61ca880c04c1758eb128f25c9faabd63_Out_2_Float;
        Unity_Subtract_float(_Maximum_c196e4a61637ea8381a3437c93f89ce2_Out_2_Float, _Property_ee8d5fc69475d181be60c57e04ea8708_Out_0_Float, _Subtract_61ca880c04c1758eb128f25c9faabd63_Out_2_Float);
        float _Subtract_e3a7713b556a1b8cb40aad97fc58d619_Out_2_Float;
        Unity_Subtract_float(_Property_14119cc7eaf4128f991283d47cf72d85_Out_0_Float, _Subtract_61ca880c04c1758eb128f25c9faabd63_Out_2_Float, _Subtract_e3a7713b556a1b8cb40aad97fc58d619_Out_2_Float);
        float _Maximum_d02e48d92038448cb0345e5cf3779071_Out_2_Float;
        Unity_Maximum_float(_Subtract_e3a7713b556a1b8cb40aad97fc58d619_Out_2_Float, float(0), _Maximum_d02e48d92038448cb0345e5cf3779071_Out_2_Float);
        float3 _Multiply_79b0b5d7d3528b8395e1135339a090f2_Out_2_Vector3;
        Unity_Multiply_float3_float3(_Property_dd1c841a04c03f8c85e7b00eb025ecda_Out_0_Vector3, (_Maximum_d02e48d92038448cb0345e5cf3779071_Out_2_Float.xxx), _Multiply_79b0b5d7d3528b8395e1135339a090f2_Out_2_Vector3);
        float3 _Property_c7292b3b08585f8c8670172b9a220bf0_Out_0_Vector3 = Vector3_79AA92F;
        float _Property_5e920479576fad83ba1947728dcceab4_Out_0_Float = Vector1_F7E83F1E;
        float _Subtract_b7368f21be9e048aae7f90c8a2bfaae1_Out_2_Float;
        Unity_Subtract_float(_Property_5e920479576fad83ba1947728dcceab4_Out_0_Float, _Subtract_61ca880c04c1758eb128f25c9faabd63_Out_2_Float, _Subtract_b7368f21be9e048aae7f90c8a2bfaae1_Out_2_Float);
        float _Maximum_216777d30802328eab607c8fe68ba3a1_Out_2_Float;
        Unity_Maximum_float(_Subtract_b7368f21be9e048aae7f90c8a2bfaae1_Out_2_Float, float(0), _Maximum_216777d30802328eab607c8fe68ba3a1_Out_2_Float);
        float3 _Multiply_a856b52cd0848f86a6ae1af9b175935c_Out_2_Vector3;
        Unity_Multiply_float3_float3(_Property_c7292b3b08585f8c8670172b9a220bf0_Out_0_Vector3, (_Maximum_216777d30802328eab607c8fe68ba3a1_Out_2_Float.xxx), _Multiply_a856b52cd0848f86a6ae1af9b175935c_Out_2_Vector3);
        float3 _Add_86c6109dc4530b8c9763ef62b056ad4c_Out_2_Vector3;
        Unity_Add_float3(_Multiply_79b0b5d7d3528b8395e1135339a090f2_Out_2_Vector3, _Multiply_a856b52cd0848f86a6ae1af9b175935c_Out_2_Vector3, _Add_86c6109dc4530b8c9763ef62b056ad4c_Out_2_Vector3);
        float _Add_356384b52728f583bd6e694bc1fc3738_Out_2_Float;
        Unity_Add_float(_Maximum_d02e48d92038448cb0345e5cf3779071_Out_2_Float, _Maximum_216777d30802328eab607c8fe68ba3a1_Out_2_Float, _Add_356384b52728f583bd6e694bc1fc3738_Out_2_Float);
        float _Maximum_94a22f5ceb706e88bc16350a5d5d2a82_Out_2_Float;
        Unity_Maximum_float(_Add_356384b52728f583bd6e694bc1fc3738_Out_2_Float, float(1E-05), _Maximum_94a22f5ceb706e88bc16350a5d5d2a82_Out_2_Float);
        float3 _Divide_d7291d1701d7058dbb5263194c1bed22_Out_2_Vector3;
        Unity_Divide_float3(_Add_86c6109dc4530b8c9763ef62b056ad4c_Out_2_Vector3, (_Maximum_94a22f5ceb706e88bc16350a5d5d2a82_Out_2_Float.xxx), _Divide_d7291d1701d7058dbb5263194c1bed22_Out_2_Vector3);
        OutVector4_1 = _Divide_d7291d1701d7058dbb5263194c1bed22_Out_2_Vector3;
        }
        
        void Unity_Clamp_float(float In, float Min, float Max, out float Out)
        {
            Out = clamp(In, Min, Max);
        }
        
        void Unity_Sign_float3(float3 In, out float3 Out)
        {
            Out = sign(In);
        }
        
        void Unity_Multiply_float2_float2(float2 A, float2 B, out float2 Out)
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
        
        void Unity_Absolute_float(float In, out float Out)
        {
            Out = abs(In);
        }
        
        void Unity_Power_float(float A, float B, out float Out)
        {
            Out = pow(A, B);
        }
        
        void Unity_Saturate_float(float In, out float Out)
        {
            Out = saturate(In);
        }
        
        void Unity_Lerp_float3(float3 A, float3 B, float3 T, out float3 Out)
        {
            Out = lerp(A, B, T);
        }
        
        void Unity_Lerp_float(float A, float B, float T, out float Out)
        {
            Out = lerp(A, B, T);
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
            UnityTexture2D _Property_07d75b1d2628da808a2efb93a1d6219e_Out_0_Texture2D = UnityBuildTexture2DStructNoScale(_BaseColorMap);
            float4 _Property_587a28253857318a9b2e59bfc8fb56a4_Out_0_Vector4 = _BaseTilingOffset;
            float _Property_7f998178363b4188ba2f07298ef869c1_Out_0_Boolean = _BaseUsePlanarUV;
            Bindings_PlanarNM_c0f081da9c567704ea36e7dd38cedcf6_float _PlanarNM_0b8fbae0d009788d8cd595a3b9bf9f6e;
            _PlanarNM_0b8fbae0d009788d8cd595a3b9bf9f6e.AbsoluteWorldSpacePosition = IN.AbsoluteWorldSpacePosition;
            _PlanarNM_0b8fbae0d009788d8cd595a3b9bf9f6e.uv0 = IN.uv0;
            _PlanarNM_0b8fbae0d009788d8cd595a3b9bf9f6e.uv3 = IN.uv3;
            float4 _PlanarNM_0b8fbae0d009788d8cd595a3b9bf9f6e_XZ_2_Vector4;
            SG_PlanarNM_c0f081da9c567704ea36e7dd38cedcf6_float(_Property_07d75b1d2628da808a2efb93a1d6219e_Out_0_Texture2D, _Property_587a28253857318a9b2e59bfc8fb56a4_Out_0_Vector4, _Property_7f998178363b4188ba2f07298ef869c1_Out_0_Boolean, UnityBuildSamplerStateStruct(SamplerState_Linear_Repeat_Aniso8), 1, _PlanarNM_0b8fbae0d009788d8cd595a3b9bf9f6e, _PlanarNM_0b8fbae0d009788d8cd595a3b9bf9f6e_XZ_2_Vector4);
            float4 _Property_b83097c58639858680bf43881a95b0af_Out_0_Vector4 = _BaseColor;
            float4 _Multiply_f572ff0def2d308e87a64e94a46c0d96_Out_2_Vector4;
            Unity_Multiply_float4_float4(_PlanarNM_0b8fbae0d009788d8cd595a3b9bf9f6e_XZ_2_Vector4, _Property_b83097c58639858680bf43881a95b0af_Out_0_Vector4, _Multiply_f572ff0def2d308e87a64e94a46c0d96_Out_2_Vector4);
            UnityTexture2D _Property_1e449ff9f8e8ec828507233e8240eb11_Out_0_Texture2D = UnityBuildTexture2DStructNoScale(_BaseMaskMap);
            Bindings_PlanarNM_c0f081da9c567704ea36e7dd38cedcf6_float _PlanarNM_4245c3b264047180b5c90a697d6cb278;
            _PlanarNM_4245c3b264047180b5c90a697d6cb278.AbsoluteWorldSpacePosition = IN.AbsoluteWorldSpacePosition;
            _PlanarNM_4245c3b264047180b5c90a697d6cb278.uv0 = IN.uv0;
            _PlanarNM_4245c3b264047180b5c90a697d6cb278.uv3 = IN.uv3;
            float4 _PlanarNM_4245c3b264047180b5c90a697d6cb278_XZ_2_Vector4;
            SG_PlanarNM_c0f081da9c567704ea36e7dd38cedcf6_float(_Property_1e449ff9f8e8ec828507233e8240eb11_Out_0_Texture2D, _Property_587a28253857318a9b2e59bfc8fb56a4_Out_0_Vector4, _Property_7f998178363b4188ba2f07298ef869c1_Out_0_Boolean, UnityBuildSamplerStateStruct(SamplerState_Linear_Repeat_Aniso8), 1, _PlanarNM_4245c3b264047180b5c90a697d6cb278, _PlanarNM_4245c3b264047180b5c90a697d6cb278_XZ_2_Vector4);
            float _Split_91a015dea8acd38b904ba0935328a5bc_R_1_Float = _PlanarNM_4245c3b264047180b5c90a697d6cb278_XZ_2_Vector4[0];
            float _Split_91a015dea8acd38b904ba0935328a5bc_G_2_Float = _PlanarNM_4245c3b264047180b5c90a697d6cb278_XZ_2_Vector4[1];
            float _Split_91a015dea8acd38b904ba0935328a5bc_B_3_Float = _PlanarNM_4245c3b264047180b5c90a697d6cb278_XZ_2_Vector4[2];
            float _Split_91a015dea8acd38b904ba0935328a5bc_A_4_Float = _PlanarNM_4245c3b264047180b5c90a697d6cb278_XZ_2_Vector4[3];
            float _Property_fbcff1469ebf488394a8a89ddaf0eb2a_Out_0_Float = _HeightMin;
            float _Property_9df7a44c8225168683743ac60c0c3c34_Out_0_Float = _HeightMax;
            float2 _Vector2_9b1e95888c28bc8893f28c02b87fa448_Out_0_Vector2 = float2(_Property_fbcff1469ebf488394a8a89ddaf0eb2a_Out_0_Float, _Property_9df7a44c8225168683743ac60c0c3c34_Out_0_Float);
            float _Property_29ca14fd0b712983a38d63d2dd326e96_Out_0_Float = _HeightOffset;
            float2 _Add_cb503f8a09720d84bb03cbd89e37b80c_Out_2_Vector2;
            Unity_Add_float2(_Vector2_9b1e95888c28bc8893f28c02b87fa448_Out_0_Vector2, (_Property_29ca14fd0b712983a38d63d2dd326e96_Out_0_Float.xx), _Add_cb503f8a09720d84bb03cbd89e37b80c_Out_2_Vector2);
            float _Remap_18f2e96a438d6584ae2fd56f880de9ee_Out_3_Float;
            Unity_Remap_float(_Split_91a015dea8acd38b904ba0935328a5bc_B_3_Float, float2 (0, 1), _Add_cb503f8a09720d84bb03cbd89e37b80c_Out_2_Vector2, _Remap_18f2e96a438d6584ae2fd56f880de9ee_Out_3_Float);
            UnityTexture2D _Property_ba3a5f4cba7d0a8fa288ffc8267d6c0e_Out_0_Texture2D = UnityBuildTexture2DStructNoScale(_Base2ColorMap);
            float4 _Property_86a4657df480d48e8d3ad3b036731380_Out_0_Vector4 = _Base2TilingOffset;
            float _Property_6c5e16c615cab08a97c2a577642b9d83_Out_0_Boolean = _Base2UsePlanarUV;
            Bindings_PlanarNM_c0f081da9c567704ea36e7dd38cedcf6_float _PlanarNM_5aeab444ca6fd78ea56a01215880a5a4;
            _PlanarNM_5aeab444ca6fd78ea56a01215880a5a4.AbsoluteWorldSpacePosition = IN.AbsoluteWorldSpacePosition;
            _PlanarNM_5aeab444ca6fd78ea56a01215880a5a4.uv0 = IN.uv0;
            _PlanarNM_5aeab444ca6fd78ea56a01215880a5a4.uv3 = IN.uv3;
            float4 _PlanarNM_5aeab444ca6fd78ea56a01215880a5a4_XZ_2_Vector4;
            SG_PlanarNM_c0f081da9c567704ea36e7dd38cedcf6_float(_Property_ba3a5f4cba7d0a8fa288ffc8267d6c0e_Out_0_Texture2D, _Property_86a4657df480d48e8d3ad3b036731380_Out_0_Vector4, _Property_6c5e16c615cab08a97c2a577642b9d83_Out_0_Boolean, UnityBuildSamplerStateStruct(SamplerState_Linear_Repeat_Aniso8), 1, _PlanarNM_5aeab444ca6fd78ea56a01215880a5a4, _PlanarNM_5aeab444ca6fd78ea56a01215880a5a4_XZ_2_Vector4);
            float4 _Property_3561b11b899bda8e855826445cf628aa_Out_0_Vector4 = _Base2Color;
            float4 _Multiply_d2ec682582195e84acc4a8510f50f4b0_Out_2_Vector4;
            Unity_Multiply_float4_float4(_PlanarNM_5aeab444ca6fd78ea56a01215880a5a4_XZ_2_Vector4, _Property_3561b11b899bda8e855826445cf628aa_Out_0_Vector4, _Multiply_d2ec682582195e84acc4a8510f50f4b0_Out_2_Vector4);
            float _Split_c34b73d933404283983f9c8bdb5365d3_R_1_Float = IN.VertexColor[0];
            float _Split_c34b73d933404283983f9c8bdb5365d3_G_2_Float = IN.VertexColor[1];
            float _Split_c34b73d933404283983f9c8bdb5365d3_B_3_Float = IN.VertexColor[2];
            float _Split_c34b73d933404283983f9c8bdb5365d3_A_4_Float = IN.VertexColor[3];
            float _Property_df2df7bb5cfc3381beee7ec454da7542_Out_0_Boolean = _Invert_Layer_Mask;
            UnityTexture2D _Property_c7b1e2df9f9b0e8eace9b2274924e69c_Out_0_Texture2D = UnityBuildTexture2DStructNoScale(_LayerMask);
            float4 _SampleTexture2D_175fb18fafc9598382f1f5f7e97bf30a_RGBA_0_Vector4 = SAMPLE_TEXTURE2D(_Property_c7b1e2df9f9b0e8eace9b2274924e69c_Out_0_Texture2D.tex, _Property_c7b1e2df9f9b0e8eace9b2274924e69c_Out_0_Texture2D.samplerstate, _Property_c7b1e2df9f9b0e8eace9b2274924e69c_Out_0_Texture2D.GetTransformedUV(IN.uv0.xy) );
            float _SampleTexture2D_175fb18fafc9598382f1f5f7e97bf30a_R_4_Float = _SampleTexture2D_175fb18fafc9598382f1f5f7e97bf30a_RGBA_0_Vector4.r;
            float _SampleTexture2D_175fb18fafc9598382f1f5f7e97bf30a_G_5_Float = _SampleTexture2D_175fb18fafc9598382f1f5f7e97bf30a_RGBA_0_Vector4.g;
            float _SampleTexture2D_175fb18fafc9598382f1f5f7e97bf30a_B_6_Float = _SampleTexture2D_175fb18fafc9598382f1f5f7e97bf30a_RGBA_0_Vector4.b;
            float _SampleTexture2D_175fb18fafc9598382f1f5f7e97bf30a_A_7_Float = _SampleTexture2D_175fb18fafc9598382f1f5f7e97bf30a_RGBA_0_Vector4.a;
            float _OneMinus_ce5c3c0635d4ac86beb55115d0ebaed7_Out_1_Float;
            Unity_OneMinus_float(_SampleTexture2D_175fb18fafc9598382f1f5f7e97bf30a_R_4_Float, _OneMinus_ce5c3c0635d4ac86beb55115d0ebaed7_Out_1_Float);
            float _Branch_af0c5e511241ce8eae748ae487df50fa_Out_3_Float;
            Unity_Branch_float(_Property_df2df7bb5cfc3381beee7ec454da7542_Out_0_Boolean, _OneMinus_ce5c3c0635d4ac86beb55115d0ebaed7_Out_1_Float, _SampleTexture2D_175fb18fafc9598382f1f5f7e97bf30a_R_4_Float, _Branch_af0c5e511241ce8eae748ae487df50fa_Out_3_Float);
            UnityTexture2D _Property_de4f6eb48a629285a664dad7fb06438f_Out_0_Texture2D = UnityBuildTexture2DStructNoScale(_Base2MaskMap);
            Bindings_PlanarNM_c0f081da9c567704ea36e7dd38cedcf6_float _PlanarNM_d5657f470f05ef839e4c257a20ace8cb;
            _PlanarNM_d5657f470f05ef839e4c257a20ace8cb.AbsoluteWorldSpacePosition = IN.AbsoluteWorldSpacePosition;
            _PlanarNM_d5657f470f05ef839e4c257a20ace8cb.uv0 = IN.uv0;
            _PlanarNM_d5657f470f05ef839e4c257a20ace8cb.uv3 = IN.uv3;
            float4 _PlanarNM_d5657f470f05ef839e4c257a20ace8cb_XZ_2_Vector4;
            SG_PlanarNM_c0f081da9c567704ea36e7dd38cedcf6_float(_Property_de4f6eb48a629285a664dad7fb06438f_Out_0_Texture2D, _Property_86a4657df480d48e8d3ad3b036731380_Out_0_Vector4, _Property_6c5e16c615cab08a97c2a577642b9d83_Out_0_Boolean, UnityBuildSamplerStateStruct(SamplerState_Linear_Repeat_Aniso8), 1, _PlanarNM_d5657f470f05ef839e4c257a20ace8cb, _PlanarNM_d5657f470f05ef839e4c257a20ace8cb_XZ_2_Vector4);
            float _Split_83ec66b648ab6c84848b42686c256cd7_R_1_Float = _PlanarNM_d5657f470f05ef839e4c257a20ace8cb_XZ_2_Vector4[0];
            float _Split_83ec66b648ab6c84848b42686c256cd7_G_2_Float = _PlanarNM_d5657f470f05ef839e4c257a20ace8cb_XZ_2_Vector4[1];
            float _Split_83ec66b648ab6c84848b42686c256cd7_B_3_Float = _PlanarNM_d5657f470f05ef839e4c257a20ace8cb_XZ_2_Vector4[2];
            float _Split_83ec66b648ab6c84848b42686c256cd7_A_4_Float = _PlanarNM_d5657f470f05ef839e4c257a20ace8cb_XZ_2_Vector4[3];
            float _Property_ce1750e5c69e97818667b412fc3f9f2c_Out_0_Float = _HeightMin2;
            float _Property_8e0f2ea54d8ede89bbabdf31a9bafd57_Out_0_Float = _HeightMax2;
            float2 _Vector2_fb6c6dd7e70e768ba686e8e94153bb96_Out_0_Vector2 = float2(_Property_ce1750e5c69e97818667b412fc3f9f2c_Out_0_Float, _Property_8e0f2ea54d8ede89bbabdf31a9bafd57_Out_0_Float);
            float _Property_151ae2702b614585af2000f0a812960f_Out_0_Float = _HeightOffset2;
            float2 _Add_fd1b3d8e24e77087a55888eeb238f1a6_Out_2_Vector2;
            Unity_Add_float2(_Vector2_fb6c6dd7e70e768ba686e8e94153bb96_Out_0_Vector2, (_Property_151ae2702b614585af2000f0a812960f_Out_0_Float.xx), _Add_fd1b3d8e24e77087a55888eeb238f1a6_Out_2_Vector2);
            float _Remap_3d4180c0ab36ba86a5517b2645f0bfa7_Out_3_Float;
            Unity_Remap_float(_Split_83ec66b648ab6c84848b42686c256cd7_B_3_Float, float2 (0, 1), _Add_fd1b3d8e24e77087a55888eeb238f1a6_Out_2_Vector2, _Remap_3d4180c0ab36ba86a5517b2645f0bfa7_Out_3_Float);
            float _Multiply_2cb0e5aa384654828f0453a44884573c_Out_2_Float;
            Unity_Multiply_float_float(_Branch_af0c5e511241ce8eae748ae487df50fa_Out_3_Float, _Remap_3d4180c0ab36ba86a5517b2645f0bfa7_Out_3_Float, _Multiply_2cb0e5aa384654828f0453a44884573c_Out_2_Float);
            float _Multiply_74def30593cbbb8bbed03613a31cb89a_Out_2_Float;
            Unity_Multiply_float_float(_Split_c34b73d933404283983f9c8bdb5365d3_G_2_Float, _Multiply_2cb0e5aa384654828f0453a44884573c_Out_2_Float, _Multiply_74def30593cbbb8bbed03613a31cb89a_Out_2_Float);
            float _Property_818c8af4b930138e81034c886614171d_Out_0_Float = _Height_Transition;
            Bindings_HeightBlend_d15b6fb865d3b6d4ebc1fd476c3ad135_float _HeightBlend_7501025b3a60738a9a9d362e35a9ab48;
            float3 _HeightBlend_7501025b3a60738a9a9d362e35a9ab48_OutVector4_1_Vector3;
            SG_HeightBlend_d15b6fb865d3b6d4ebc1fd476c3ad135_float((_Multiply_f572ff0def2d308e87a64e94a46c0d96_Out_2_Vector4.xyz), _Remap_18f2e96a438d6584ae2fd56f880de9ee_Out_3_Float, (_Multiply_d2ec682582195e84acc4a8510f50f4b0_Out_2_Vector4.xyz), _Multiply_74def30593cbbb8bbed03613a31cb89a_Out_2_Float, _Property_818c8af4b930138e81034c886614171d_Out_0_Float, _HeightBlend_7501025b3a60738a9a9d362e35a9ab48, _HeightBlend_7501025b3a60738a9a9d362e35a9ab48_OutVector4_1_Vector3);
            UnityTexture2D _Property_c0ebdab0f71ace8aabaa865fd7293599_Out_0_Texture2D = UnityBuildTexture2DStructNoScale(_CoverBaseColorMap);
            float4 _Property_822489d2e6d3e08590c64f085ffd9b2e_Out_0_Vector4 = _CoverTilingOffset;
            float _Property_2ae4a163bd21d98789af282d6e469175_Out_0_Boolean = _CoverUsePlanarUV;
            Bindings_PlanarNM_c0f081da9c567704ea36e7dd38cedcf6_float _PlanarNM_8bb420494d19b28e9ccdff489802dc81;
            _PlanarNM_8bb420494d19b28e9ccdff489802dc81.AbsoluteWorldSpacePosition = IN.AbsoluteWorldSpacePosition;
            _PlanarNM_8bb420494d19b28e9ccdff489802dc81.uv0 = IN.uv0;
            _PlanarNM_8bb420494d19b28e9ccdff489802dc81.uv3 = IN.uv3;
            float4 _PlanarNM_8bb420494d19b28e9ccdff489802dc81_XZ_2_Vector4;
            SG_PlanarNM_c0f081da9c567704ea36e7dd38cedcf6_float(_Property_c0ebdab0f71ace8aabaa865fd7293599_Out_0_Texture2D, _Property_822489d2e6d3e08590c64f085ffd9b2e_Out_0_Vector4, _Property_2ae4a163bd21d98789af282d6e469175_Out_0_Boolean, UnityBuildSamplerStateStruct(SamplerState_Linear_Repeat_Aniso8), 1, _PlanarNM_8bb420494d19b28e9ccdff489802dc81, _PlanarNM_8bb420494d19b28e9ccdff489802dc81_XZ_2_Vector4);
            float4 _Property_55e7941fa7ac5f8387aa9bb633b08883_Out_0_Vector4 = _CoverBaseColor;
            float4 _Multiply_a38ba695a2660c8691763f0bd7fe159c_Out_2_Vector4;
            Unity_Multiply_float4_float4(_PlanarNM_8bb420494d19b28e9ccdff489802dc81_XZ_2_Vector4, _Property_55e7941fa7ac5f8387aa9bb633b08883_Out_0_Vector4, _Multiply_a38ba695a2660c8691763f0bd7fe159c_Out_2_Vector4);
            UnityTexture2D _Property_3b351481f7b944ffaf5f59649df41ba9_Out_0_Texture2D = UnityBuildTexture2DStructNoScale(_CoverBaseColorMap);
            float4 _UV_5352c8dd0add178ba83a5421c2c0b3f0_Out_0_Vector4 = IN.uv0;
            float4 _SampleTexture2D_024ba490c015248988a12a9d670014ea_RGBA_0_Vector4 = SAMPLE_TEXTURE2D(_Property_3b351481f7b944ffaf5f59649df41ba9_Out_0_Texture2D.tex, _Property_3b351481f7b944ffaf5f59649df41ba9_Out_0_Texture2D.samplerstate, _Property_3b351481f7b944ffaf5f59649df41ba9_Out_0_Texture2D.GetTransformedUV((_UV_5352c8dd0add178ba83a5421c2c0b3f0_Out_0_Vector4.xy)) );
            float _SampleTexture2D_024ba490c015248988a12a9d670014ea_R_4_Float = _SampleTexture2D_024ba490c015248988a12a9d670014ea_RGBA_0_Vector4.r;
            float _SampleTexture2D_024ba490c015248988a12a9d670014ea_G_5_Float = _SampleTexture2D_024ba490c015248988a12a9d670014ea_RGBA_0_Vector4.g;
            float _SampleTexture2D_024ba490c015248988a12a9d670014ea_B_6_Float = _SampleTexture2D_024ba490c015248988a12a9d670014ea_RGBA_0_Vector4.b;
            float _SampleTexture2D_024ba490c015248988a12a9d670014ea_A_7_Float = _SampleTexture2D_024ba490c015248988a12a9d670014ea_RGBA_0_Vector4.a;
            float _Property_b80e7b96604b7c82bbf9bff4981fad76_Out_0_Float = _CoverMaskPower;
            float _Multiply_abe410d256783480b1b58468bf78a882_Out_2_Float;
            Unity_Multiply_float_float(_SampleTexture2D_024ba490c015248988a12a9d670014ea_A_7_Float, _Property_b80e7b96604b7c82bbf9bff4981fad76_Out_0_Float, _Multiply_abe410d256783480b1b58468bf78a882_Out_2_Float);
            float _Clamp_a78f6f28770afd869adb9d12cd47370b_Out_3_Float;
            Unity_Clamp_float(_Multiply_abe410d256783480b1b58468bf78a882_Out_2_Float, float(0), float(1), _Clamp_a78f6f28770afd869adb9d12cd47370b_Out_3_Float);
            UnityTexture2D _Property_7c7049e15fdff386b535790d8666f609_Out_0_Texture2D = UnityBuildTexture2DStructNoScale(_BaseNormalMap);
            Bindings_PlanarNMn_1b93a87456f9d4c419321d0cd92bd6c8_float _PlanarNMn_a3713a9c3874b6838d0eda971b9c62d8;
            _PlanarNMn_a3713a9c3874b6838d0eda971b9c62d8.WorldSpaceNormal = IN.WorldSpaceNormal;
            _PlanarNMn_a3713a9c3874b6838d0eda971b9c62d8.WorldSpaceTangent = IN.WorldSpaceTangent;
            _PlanarNMn_a3713a9c3874b6838d0eda971b9c62d8.WorldSpaceBiTangent = IN.WorldSpaceBiTangent;
            _PlanarNMn_a3713a9c3874b6838d0eda971b9c62d8.AbsoluteWorldSpacePosition = IN.AbsoluteWorldSpacePosition;
            _PlanarNMn_a3713a9c3874b6838d0eda971b9c62d8.uv0 = IN.uv0;
            _PlanarNMn_a3713a9c3874b6838d0eda971b9c62d8.uv3 = IN.uv3;
            float4 _PlanarNMn_a3713a9c3874b6838d0eda971b9c62d8_XZ_2_Vector4;
            SG_PlanarNMn_1b93a87456f9d4c419321d0cd92bd6c8_float(_Property_7c7049e15fdff386b535790d8666f609_Out_0_Texture2D, _Property_587a28253857318a9b2e59bfc8fb56a4_Out_0_Vector4, _Property_7f998178363b4188ba2f07298ef869c1_Out_0_Boolean, UnityBuildSamplerStateStruct(SamplerState_Linear_Repeat_Aniso8), 1, _PlanarNMn_a3713a9c3874b6838d0eda971b9c62d8, _PlanarNMn_a3713a9c3874b6838d0eda971b9c62d8_XZ_2_Vector4);
            float _Property_d4b0759cf4647e81be065ec1465ce2b4_Out_0_Float = _BaseNormalScale;
            float3 _NormalStrength_f66a9108ea294886acc61513b41cc5e4_Out_2_Vector3;
            Unity_NormalStrength_float((_PlanarNMn_a3713a9c3874b6838d0eda971b9c62d8_XZ_2_Vector4.xyz), _Property_d4b0759cf4647e81be065ec1465ce2b4_Out_0_Float, _NormalStrength_f66a9108ea294886acc61513b41cc5e4_Out_2_Vector3);
            UnityTexture2D _Property_fa9f7890b20ad481a92543c04b237bde_Out_0_Texture2D = UnityBuildTexture2DStructNoScale(_Base2NormalMap);
            Bindings_PlanarNMn_1b93a87456f9d4c419321d0cd92bd6c8_float _PlanarNMn_d7b3ec528088a085a5102e025a1b45cf;
            _PlanarNMn_d7b3ec528088a085a5102e025a1b45cf.WorldSpaceNormal = IN.WorldSpaceNormal;
            _PlanarNMn_d7b3ec528088a085a5102e025a1b45cf.WorldSpaceTangent = IN.WorldSpaceTangent;
            _PlanarNMn_d7b3ec528088a085a5102e025a1b45cf.WorldSpaceBiTangent = IN.WorldSpaceBiTangent;
            _PlanarNMn_d7b3ec528088a085a5102e025a1b45cf.AbsoluteWorldSpacePosition = IN.AbsoluteWorldSpacePosition;
            _PlanarNMn_d7b3ec528088a085a5102e025a1b45cf.uv0 = IN.uv0;
            _PlanarNMn_d7b3ec528088a085a5102e025a1b45cf.uv3 = IN.uv3;
            float4 _PlanarNMn_d7b3ec528088a085a5102e025a1b45cf_XZ_2_Vector4;
            SG_PlanarNMn_1b93a87456f9d4c419321d0cd92bd6c8_float(_Property_fa9f7890b20ad481a92543c04b237bde_Out_0_Texture2D, _Property_86a4657df480d48e8d3ad3b036731380_Out_0_Vector4, _Property_6c5e16c615cab08a97c2a577642b9d83_Out_0_Boolean, UnityBuildSamplerStateStruct(SamplerState_Linear_Repeat_Aniso8), 1, _PlanarNMn_d7b3ec528088a085a5102e025a1b45cf, _PlanarNMn_d7b3ec528088a085a5102e025a1b45cf_XZ_2_Vector4);
            float _Property_8c31443b776727819a663c7ddce79064_Out_0_Float = _Base2NormalScale;
            float3 _NormalStrength_0fb86880ab8e368dac6d01b830e20ed8_Out_2_Vector3;
            Unity_NormalStrength_float((_PlanarNMn_d7b3ec528088a085a5102e025a1b45cf_XZ_2_Vector4.xyz), _Property_8c31443b776727819a663c7ddce79064_Out_0_Float, _NormalStrength_0fb86880ab8e368dac6d01b830e20ed8_Out_2_Vector3);
            Bindings_HeightBlend_d15b6fb865d3b6d4ebc1fd476c3ad135_float _HeightBlend_7c09d97625efce898e21b66cd039be8b;
            float3 _HeightBlend_7c09d97625efce898e21b66cd039be8b_OutVector4_1_Vector3;
            SG_HeightBlend_d15b6fb865d3b6d4ebc1fd476c3ad135_float(_NormalStrength_f66a9108ea294886acc61513b41cc5e4_Out_2_Vector3, _Remap_18f2e96a438d6584ae2fd56f880de9ee_Out_3_Float, _NormalStrength_0fb86880ab8e368dac6d01b830e20ed8_Out_2_Vector3, _Multiply_74def30593cbbb8bbed03613a31cb89a_Out_2_Float, _Property_818c8af4b930138e81034c886614171d_Out_0_Float, _HeightBlend_7c09d97625efce898e21b66cd039be8b, _HeightBlend_7c09d97625efce898e21b66cd039be8b_OutVector4_1_Vector3);
            UnityTexture2D _Property_65f7dd6fe6c29b83913af586c597a1ef_Out_0_Texture2D = UnityBuildTexture2DStructNoScale(_CoverNormalMap);
            Bindings_PlanarNMn_1b93a87456f9d4c419321d0cd92bd6c8_float _PlanarNMn_248bc5b7421d3f828d166902c73ca6c3;
            _PlanarNMn_248bc5b7421d3f828d166902c73ca6c3.WorldSpaceNormal = IN.WorldSpaceNormal;
            _PlanarNMn_248bc5b7421d3f828d166902c73ca6c3.WorldSpaceTangent = IN.WorldSpaceTangent;
            _PlanarNMn_248bc5b7421d3f828d166902c73ca6c3.WorldSpaceBiTangent = IN.WorldSpaceBiTangent;
            _PlanarNMn_248bc5b7421d3f828d166902c73ca6c3.AbsoluteWorldSpacePosition = IN.AbsoluteWorldSpacePosition;
            _PlanarNMn_248bc5b7421d3f828d166902c73ca6c3.uv0 = IN.uv0;
            _PlanarNMn_248bc5b7421d3f828d166902c73ca6c3.uv3 = IN.uv3;
            float4 _PlanarNMn_248bc5b7421d3f828d166902c73ca6c3_XZ_2_Vector4;
            SG_PlanarNMn_1b93a87456f9d4c419321d0cd92bd6c8_float(_Property_65f7dd6fe6c29b83913af586c597a1ef_Out_0_Texture2D, _Property_822489d2e6d3e08590c64f085ffd9b2e_Out_0_Vector4, _Property_2ae4a163bd21d98789af282d6e469175_Out_0_Boolean, UnityBuildSamplerStateStruct(SamplerState_Linear_Repeat_Aniso8), 1, _PlanarNMn_248bc5b7421d3f828d166902c73ca6c3, _PlanarNMn_248bc5b7421d3f828d166902c73ca6c3_XZ_2_Vector4);
            float _Property_19f92cae42737480a95820c51d4ba124_Out_0_Float = _CoverNormalBlendHardness;
            float3 _NormalStrength_2c3488591b8345869feb25a3dee06c3f_Out_2_Vector3;
            Unity_NormalStrength_float((_PlanarNMn_248bc5b7421d3f828d166902c73ca6c3_XZ_2_Vector4.xyz), _Property_19f92cae42737480a95820c51d4ba124_Out_0_Float, _NormalStrength_2c3488591b8345869feb25a3dee06c3f_Out_2_Vector3);
            float _Split_96bfe9cb80ad308385c191d094b3d071_R_1_Float = IN.WorldSpaceNormal[0];
            float _Split_96bfe9cb80ad308385c191d094b3d071_G_2_Float = IN.WorldSpaceNormal[1];
            float _Split_96bfe9cb80ad308385c191d094b3d071_B_3_Float = IN.WorldSpaceNormal[2];
            float _Split_96bfe9cb80ad308385c191d094b3d071_A_4_Float = 0;
            float _Property_0dd796aae8cd9f878bef13ceac4fe3ec_Out_0_Float = _Cover_Amount;
            float _Property_67285cdc688aa38d83f62d5bb095d597_Out_0_Float = _Cover_Amount_Grow_Speed;
            float _Subtract_fcefec675e7536888eccf5574d921972_Out_2_Float;
            Unity_Subtract_float(float(4), _Property_67285cdc688aa38d83f62d5bb095d597_Out_0_Float, _Subtract_fcefec675e7536888eccf5574d921972_Out_2_Float);
            float _Divide_1e25465528e612839a4ce1faedd89e7d_Out_2_Float;
            Unity_Divide_float(_Property_0dd796aae8cd9f878bef13ceac4fe3ec_Out_0_Float, _Subtract_fcefec675e7536888eccf5574d921972_Out_2_Float, _Divide_1e25465528e612839a4ce1faedd89e7d_Out_2_Float);
            float _Absolute_d20b810ffdec828ab74dd6692d82f01b_Out_1_Float;
            Unity_Absolute_float(_Divide_1e25465528e612839a4ce1faedd89e7d_Out_2_Float, _Absolute_d20b810ffdec828ab74dd6692d82f01b_Out_1_Float);
            float _Power_181fbf47cfdb258da1fe0b72a450986f_Out_2_Float;
            Unity_Power_float(_Absolute_d20b810ffdec828ab74dd6692d82f01b_Out_1_Float, _Subtract_fcefec675e7536888eccf5574d921972_Out_2_Float, _Power_181fbf47cfdb258da1fe0b72a450986f_Out_2_Float);
            float _Clamp_11f62dba01f1a38c9e0a9972ccd19246_Out_3_Float;
            Unity_Clamp_float(_Power_181fbf47cfdb258da1fe0b72a450986f_Out_2_Float, float(0), float(2), _Clamp_11f62dba01f1a38c9e0a9972ccd19246_Out_3_Float);
            float _Multiply_9810f6d76275cd8fbe5e3a02360b98a7_Out_2_Float;
            Unity_Multiply_float_float(_Split_96bfe9cb80ad308385c191d094b3d071_G_2_Float, _Clamp_11f62dba01f1a38c9e0a9972ccd19246_Out_3_Float, _Multiply_9810f6d76275cd8fbe5e3a02360b98a7_Out_2_Float);
            float _Saturate_a007c5f214685c87bf6ca3e64c06b488_Out_1_Float;
            Unity_Saturate_float(_Multiply_9810f6d76275cd8fbe5e3a02360b98a7_Out_2_Float, _Saturate_a007c5f214685c87bf6ca3e64c06b488_Out_1_Float);
            float _Clamp_1b2b25b617fc508b9835f0309136fd00_Out_3_Float;
            Unity_Clamp_float(_Split_96bfe9cb80ad308385c191d094b3d071_G_2_Float, float(0), float(0.9999), _Clamp_1b2b25b617fc508b9835f0309136fd00_Out_3_Float);
            float _Property_7b12276ea7a4538db6804507b30a830c_Out_0_Float = _Cover_Max_Angle;
            float _Divide_54c523ff4b7acb858e9e368fd1e4d34a_Out_2_Float;
            Unity_Divide_float(_Property_7b12276ea7a4538db6804507b30a830c_Out_0_Float, float(45), _Divide_54c523ff4b7acb858e9e368fd1e4d34a_Out_2_Float);
            float _OneMinus_6cf431985b651e8e9546ae6cb2d4d668_Out_1_Float;
            Unity_OneMinus_float(_Divide_54c523ff4b7acb858e9e368fd1e4d34a_Out_2_Float, _OneMinus_6cf431985b651e8e9546ae6cb2d4d668_Out_1_Float);
            float _Subtract_4ef7b60aeab8d589bf2d2423737642bc_Out_2_Float;
            Unity_Subtract_float(_Clamp_1b2b25b617fc508b9835f0309136fd00_Out_3_Float, _OneMinus_6cf431985b651e8e9546ae6cb2d4d668_Out_1_Float, _Subtract_4ef7b60aeab8d589bf2d2423737642bc_Out_2_Float);
            float _Clamp_a4b51894ea17818c9a27bb533a2ebe74_Out_3_Float;
            Unity_Clamp_float(_Subtract_4ef7b60aeab8d589bf2d2423737642bc_Out_2_Float, float(0), float(2), _Clamp_a4b51894ea17818c9a27bb533a2ebe74_Out_3_Float);
            float _Divide_c4196d4f02190b89ba827ccd4ae8a74d_Out_2_Float;
            Unity_Divide_float(float(1), _Divide_54c523ff4b7acb858e9e368fd1e4d34a_Out_2_Float, _Divide_c4196d4f02190b89ba827ccd4ae8a74d_Out_2_Float);
            float _Multiply_ffc22433163d1184846ede424b44bcb2_Out_2_Float;
            Unity_Multiply_float_float(_Clamp_a4b51894ea17818c9a27bb533a2ebe74_Out_3_Float, _Divide_c4196d4f02190b89ba827ccd4ae8a74d_Out_2_Float, _Multiply_ffc22433163d1184846ede424b44bcb2_Out_2_Float);
            float _Absolute_c2e5757082de5d878d4c023806fb2108_Out_1_Float;
            Unity_Absolute_float(_Multiply_ffc22433163d1184846ede424b44bcb2_Out_2_Float, _Absolute_c2e5757082de5d878d4c023806fb2108_Out_1_Float);
            float _Property_849d9f217c95f38c9d49ab251578d8d5_Out_0_Float = _CoverHardness;
            float _Power_578546d66d69a5829b745ebba1279adf_Out_2_Float;
            Unity_Power_float(_Absolute_c2e5757082de5d878d4c023806fb2108_Out_1_Float, _Property_849d9f217c95f38c9d49ab251578d8d5_Out_0_Float, _Power_578546d66d69a5829b745ebba1279adf_Out_2_Float);
            float _Property_34d2d3aff4814e8e83d2894b3512c6c8_Out_0_Float = _Cover_Min_Height;
            float _OneMinus_474df64227f004849b34c68fe8df93f2_Out_1_Float;
            Unity_OneMinus_float(_Property_34d2d3aff4814e8e83d2894b3512c6c8_Out_0_Float, _OneMinus_474df64227f004849b34c68fe8df93f2_Out_1_Float);
            float _Split_ee4d9dc934b3508397d5a3dece110ab0_R_1_Float = IN.AbsoluteWorldSpacePosition[0];
            float _Split_ee4d9dc934b3508397d5a3dece110ab0_G_2_Float = IN.AbsoluteWorldSpacePosition[1];
            float _Split_ee4d9dc934b3508397d5a3dece110ab0_B_3_Float = IN.AbsoluteWorldSpacePosition[2];
            float _Split_ee4d9dc934b3508397d5a3dece110ab0_A_4_Float = 0;
            float _Add_d6bc513aa82d918ea24e279f4353d971_Out_2_Float;
            Unity_Add_float(_OneMinus_474df64227f004849b34c68fe8df93f2_Out_1_Float, _Split_ee4d9dc934b3508397d5a3dece110ab0_G_2_Float, _Add_d6bc513aa82d918ea24e279f4353d971_Out_2_Float);
            float _Add_a6a61cb12180108c9e1364b90d2673e2_Out_2_Float;
            Unity_Add_float(_Add_d6bc513aa82d918ea24e279f4353d971_Out_2_Float, float(1), _Add_a6a61cb12180108c9e1364b90d2673e2_Out_2_Float);
            float _Clamp_1874fdd00cb9aa839d93ab8536e2414d_Out_3_Float;
            Unity_Clamp_float(_Add_a6a61cb12180108c9e1364b90d2673e2_Out_2_Float, float(0), float(1), _Clamp_1874fdd00cb9aa839d93ab8536e2414d_Out_3_Float);
            float _Property_7b91fd6e21b46c85816c7b681307cbe4_Out_0_Float = _Cover_Min_Height_Blending;
            float _Add_6dca9453f6a35e8185c4b8e9782db0a9_Out_2_Float;
            Unity_Add_float(_Add_d6bc513aa82d918ea24e279f4353d971_Out_2_Float, _Property_7b91fd6e21b46c85816c7b681307cbe4_Out_0_Float, _Add_6dca9453f6a35e8185c4b8e9782db0a9_Out_2_Float);
            float _Divide_83415a319ecfba83af914cbc5487b546_Out_2_Float;
            Unity_Divide_float(_Add_6dca9453f6a35e8185c4b8e9782db0a9_Out_2_Float, _Add_d6bc513aa82d918ea24e279f4353d971_Out_2_Float, _Divide_83415a319ecfba83af914cbc5487b546_Out_2_Float);
            float _OneMinus_bf150b22fcad5a87b7c825c9c6cf1687_Out_1_Float;
            Unity_OneMinus_float(_Divide_83415a319ecfba83af914cbc5487b546_Out_2_Float, _OneMinus_bf150b22fcad5a87b7c825c9c6cf1687_Out_1_Float);
            float _Add_86ff9fa850efbe8c80705d8266609dab_Out_2_Float;
            Unity_Add_float(_OneMinus_bf150b22fcad5a87b7c825c9c6cf1687_Out_1_Float, float(-0.5), _Add_86ff9fa850efbe8c80705d8266609dab_Out_2_Float);
            float _Clamp_906e140f01222d8ba61252ec6ec9d6a4_Out_3_Float;
            Unity_Clamp_float(_Add_86ff9fa850efbe8c80705d8266609dab_Out_2_Float, float(0), float(1), _Clamp_906e140f01222d8ba61252ec6ec9d6a4_Out_3_Float);
            float _Add_c1ec5849bf72f585a30b3e11a91ada52_Out_2_Float;
            Unity_Add_float(_Clamp_1874fdd00cb9aa839d93ab8536e2414d_Out_3_Float, _Clamp_906e140f01222d8ba61252ec6ec9d6a4_Out_3_Float, _Add_c1ec5849bf72f585a30b3e11a91ada52_Out_2_Float);
            float _Clamp_17a8a0cf209a038b9e9c7f5681cdd1fb_Out_3_Float;
            Unity_Clamp_float(_Add_c1ec5849bf72f585a30b3e11a91ada52_Out_2_Float, float(0), float(1), _Clamp_17a8a0cf209a038b9e9c7f5681cdd1fb_Out_3_Float);
            float _Multiply_8c2759ac24a9b289b1e9610cfd161bb0_Out_2_Float;
            Unity_Multiply_float_float(_Power_578546d66d69a5829b745ebba1279adf_Out_2_Float, _Clamp_17a8a0cf209a038b9e9c7f5681cdd1fb_Out_3_Float, _Multiply_8c2759ac24a9b289b1e9610cfd161bb0_Out_2_Float);
            float _Multiply_1a723f136ec7fa8c957b5d29e03d3051_Out_2_Float;
            Unity_Multiply_float_float(_Saturate_a007c5f214685c87bf6ca3e64c06b488_Out_1_Float, _Multiply_8c2759ac24a9b289b1e9610cfd161bb0_Out_2_Float, _Multiply_1a723f136ec7fa8c957b5d29e03d3051_Out_2_Float);
            float3 _Lerp_d1c72e47b283948584479177786ae8d5_Out_3_Vector3;
            Unity_Lerp_float3(_HeightBlend_7c09d97625efce898e21b66cd039be8b_OutVector4_1_Vector3, _NormalStrength_2c3488591b8345869feb25a3dee06c3f_Out_2_Vector3, (_Multiply_1a723f136ec7fa8c957b5d29e03d3051_Out_2_Float.xxx), _Lerp_d1c72e47b283948584479177786ae8d5_Out_3_Vector3);
            float3 _Transform_180fb403b53f318db002e8eba7616644_Out_1_Vector3;
            {
                float3x3 tangentTransform = float3x3(IN.WorldSpaceTangent, IN.WorldSpaceBiTangent, IN.WorldSpaceNormal);
                _Transform_180fb403b53f318db002e8eba7616644_Out_1_Vector3 = TransformTangentToWorldDir(_Lerp_d1c72e47b283948584479177786ae8d5_Out_3_Vector3.xyz, tangentTransform, true).xyz;
            }
            float _Split_c9a2b4fb4f688b8ebfc1436535cd5ba4_R_1_Float = _Transform_180fb403b53f318db002e8eba7616644_Out_1_Vector3[0];
            float _Split_c9a2b4fb4f688b8ebfc1436535cd5ba4_G_2_Float = _Transform_180fb403b53f318db002e8eba7616644_Out_1_Vector3[1];
            float _Split_c9a2b4fb4f688b8ebfc1436535cd5ba4_B_3_Float = _Transform_180fb403b53f318db002e8eba7616644_Out_1_Vector3[2];
            float _Split_c9a2b4fb4f688b8ebfc1436535cd5ba4_A_4_Float = 0;
            float _Multiply_4c7631d0688102819e6d388d624855a1_Out_2_Float;
            Unity_Multiply_float_float(_Split_c9a2b4fb4f688b8ebfc1436535cd5ba4_G_2_Float, _Clamp_11f62dba01f1a38c9e0a9972ccd19246_Out_3_Float, _Multiply_4c7631d0688102819e6d388d624855a1_Out_2_Float);
            float _Multiply_f2887eb409f6bb81ae4caad2b01b17f1_Out_2_Float;
            Unity_Multiply_float_float(_Clamp_11f62dba01f1a38c9e0a9972ccd19246_Out_3_Float, _Property_849d9f217c95f38c9d49ab251578d8d5_Out_0_Float, _Multiply_f2887eb409f6bb81ae4caad2b01b17f1_Out_2_Float);
            float _Multiply_2e348ed31331e78791b2b3130a009f30_Out_2_Float;
            Unity_Multiply_float_float(_Multiply_f2887eb409f6bb81ae4caad2b01b17f1_Out_2_Float, _Multiply_8c2759ac24a9b289b1e9610cfd161bb0_Out_2_Float, _Multiply_2e348ed31331e78791b2b3130a009f30_Out_2_Float);
            float _Multiply_622e54e9a77b08839c0954ce5715ad1c_Out_2_Float;
            Unity_Multiply_float_float(_Multiply_4c7631d0688102819e6d388d624855a1_Out_2_Float, _Multiply_2e348ed31331e78791b2b3130a009f30_Out_2_Float, _Multiply_622e54e9a77b08839c0954ce5715ad1c_Out_2_Float);
            UnityTexture2D _Property_608db04fab7d768d9a8b5fb9cf0768e1_Out_0_Texture2D = UnityBuildTexture2DStructNoScale(_CoverMaskMap);
            Bindings_PlanarNM_c0f081da9c567704ea36e7dd38cedcf6_float _PlanarNM_819c993d9b62a28ea640d2bacdc62c6e;
            _PlanarNM_819c993d9b62a28ea640d2bacdc62c6e.AbsoluteWorldSpacePosition = IN.AbsoluteWorldSpacePosition;
            _PlanarNM_819c993d9b62a28ea640d2bacdc62c6e.uv0 = IN.uv0;
            _PlanarNM_819c993d9b62a28ea640d2bacdc62c6e.uv3 = IN.uv3;
            float4 _PlanarNM_819c993d9b62a28ea640d2bacdc62c6e_XZ_2_Vector4;
            SG_PlanarNM_c0f081da9c567704ea36e7dd38cedcf6_float(_Property_608db04fab7d768d9a8b5fb9cf0768e1_Out_0_Texture2D, _Property_822489d2e6d3e08590c64f085ffd9b2e_Out_0_Vector4, _Property_2ae4a163bd21d98789af282d6e469175_Out_0_Boolean, UnityBuildSamplerStateStruct(SamplerState_Linear_Repeat_Aniso8), 1, _PlanarNM_819c993d9b62a28ea640d2bacdc62c6e, _PlanarNM_819c993d9b62a28ea640d2bacdc62c6e_XZ_2_Vector4);
            float _Split_86ec1aefda4f9e8e82b79c6195b397b0_R_1_Float = _PlanarNM_819c993d9b62a28ea640d2bacdc62c6e_XZ_2_Vector4[0];
            float _Split_86ec1aefda4f9e8e82b79c6195b397b0_G_2_Float = _PlanarNM_819c993d9b62a28ea640d2bacdc62c6e_XZ_2_Vector4[1];
            float _Split_86ec1aefda4f9e8e82b79c6195b397b0_B_3_Float = _PlanarNM_819c993d9b62a28ea640d2bacdc62c6e_XZ_2_Vector4[2];
            float _Split_86ec1aefda4f9e8e82b79c6195b397b0_A_4_Float = _PlanarNM_819c993d9b62a28ea640d2bacdc62c6e_XZ_2_Vector4[3];
            float _Property_c9c6897e00458b8f8aa07df49fa519bc_Out_0_Float = _CoverHeightMapMin;
            float _Property_ab94650b8edd82828661fe99e3c0e849_Out_0_Float = _CoverHeightMapMax;
            float2 _Vector2_fe489f7321f6568686816b9eecbc16d1_Out_0_Vector2 = float2(_Property_c9c6897e00458b8f8aa07df49fa519bc_Out_0_Float, _Property_ab94650b8edd82828661fe99e3c0e849_Out_0_Float);
            float _Property_c1ab40024cb83b87960e4327efbd997f_Out_0_Float = _CoverHeightMapOffset;
            float2 _Add_4a359522fc231c83b55ef23f341b6fb3_Out_2_Vector2;
            Unity_Add_float2(_Vector2_fe489f7321f6568686816b9eecbc16d1_Out_0_Vector2, (_Property_c1ab40024cb83b87960e4327efbd997f_Out_0_Float.xx), _Add_4a359522fc231c83b55ef23f341b6fb3_Out_2_Vector2);
            float _Remap_5aee5b64d41562858dc7c42d8b748894_Out_3_Float;
            Unity_Remap_float(_Split_86ec1aefda4f9e8e82b79c6195b397b0_B_3_Float, float2 (0, 1), _Add_4a359522fc231c83b55ef23f341b6fb3_Out_2_Vector2, _Remap_5aee5b64d41562858dc7c42d8b748894_Out_3_Float);
            float _Multiply_f0228e1cfd9c858dbb36367f551733c4_Out_2_Float;
            Unity_Multiply_float_float(_Multiply_622e54e9a77b08839c0954ce5715ad1c_Out_2_Float, _Remap_5aee5b64d41562858dc7c42d8b748894_Out_3_Float, _Multiply_f0228e1cfd9c858dbb36367f551733c4_Out_2_Float);
            float _Multiply_bb4d60728db93b8a9af9635fa1d69891_Out_2_Float;
            Unity_Multiply_float_float(_Split_c34b73d933404283983f9c8bdb5365d3_B_3_Float, _Multiply_f0228e1cfd9c858dbb36367f551733c4_Out_2_Float, _Multiply_bb4d60728db93b8a9af9635fa1d69891_Out_2_Float);
            float _Saturate_9b052a9bb99eff89bb11bdc387a0c2fd_Out_1_Float;
            Unity_Saturate_float(_Multiply_bb4d60728db93b8a9af9635fa1d69891_Out_2_Float, _Saturate_9b052a9bb99eff89bb11bdc387a0c2fd_Out_1_Float);
            float _Multiply_22fb8c1cfd28b687a991e101aa13ff5b_Out_2_Float;
            Unity_Multiply_float_float(_Clamp_a78f6f28770afd869adb9d12cd47370b_Out_3_Float, _Saturate_9b052a9bb99eff89bb11bdc387a0c2fd_Out_1_Float, _Multiply_22fb8c1cfd28b687a991e101aa13ff5b_Out_2_Float);
            #if defined(_USEDYNAMICCOVERTSTATICMASKF_ON)
            float _UseDynamicCoverTStaticMaskF_20dcbac2f16cf78ebd6fd1debcd7f281_Out_0_Float = _Multiply_22fb8c1cfd28b687a991e101aa13ff5b_Out_2_Float;
            #else
            float _UseDynamicCoverTStaticMaskF_20dcbac2f16cf78ebd6fd1debcd7f281_Out_0_Float = _Clamp_a78f6f28770afd869adb9d12cd47370b_Out_3_Float;
            #endif
            float3 _Lerp_e5620b57c917728fa1416e2ffce9b0db_Out_3_Vector3;
            Unity_Lerp_float3(_HeightBlend_7501025b3a60738a9a9d362e35a9ab48_OutVector4_1_Vector3, (_Multiply_a38ba695a2660c8691763f0bd7fe159c_Out_2_Vector4.xyz), (_UseDynamicCoverTStaticMaskF_20dcbac2f16cf78ebd6fd1debcd7f281_Out_0_Float.xxx), _Lerp_e5620b57c917728fa1416e2ffce9b0db_Out_3_Vector3);
            float4 _Property_7946b761100c49199abc52129949bc94_Out_0_Vector4 = _WetColor;
            float3 _Multiply_f722561c89f8451497c9823ad4f29f4a_Out_2_Vector3;
            Unity_Multiply_float3_float3((_Property_7946b761100c49199abc52129949bc94_Out_0_Vector4.xyz), _Lerp_e5620b57c917728fa1416e2ffce9b0db_Out_3_Vector3, _Multiply_f722561c89f8451497c9823ad4f29f4a_Out_2_Vector3);
            float _OneMinus_6ed96e068e394cd09ae03c32446777c8_Out_1_Float;
            Unity_OneMinus_float(_Split_c34b73d933404283983f9c8bdb5365d3_R_1_Float, _OneMinus_6ed96e068e394cd09ae03c32446777c8_Out_1_Float);
            float3 _Lerp_c16da1ee314d4393a798b1d36f6733d8_Out_3_Vector3;
            Unity_Lerp_float3(_Lerp_e5620b57c917728fa1416e2ffce9b0db_Out_3_Vector3, _Multiply_f722561c89f8451497c9823ad4f29f4a_Out_2_Vector3, (_OneMinus_6ed96e068e394cd09ae03c32446777c8_Out_1_Float.xxx), _Lerp_c16da1ee314d4393a798b1d36f6733d8_Out_3_Vector3);
            float _Property_7b9efcab84158389b4a4ea1e24b5601a_Out_0_Float = _CoverNormalScale;
            float3 _NormalStrength_8f42544d1b3ae08092fb1812b8119cfa_Out_2_Vector3;
            Unity_NormalStrength_float((_PlanarNMn_248bc5b7421d3f828d166902c73ca6c3_XZ_2_Vector4.xyz), _Property_7b9efcab84158389b4a4ea1e24b5601a_Out_0_Float, _NormalStrength_8f42544d1b3ae08092fb1812b8119cfa_Out_2_Vector3);
            float3 _Lerp_18ca18da5861e688a3fb637172636eda_Out_3_Vector3;
            Unity_Lerp_float3(_HeightBlend_7c09d97625efce898e21b66cd039be8b_OutVector4_1_Vector3, _NormalStrength_8f42544d1b3ae08092fb1812b8119cfa_Out_2_Vector3, (_UseDynamicCoverTStaticMaskF_20dcbac2f16cf78ebd6fd1debcd7f281_Out_0_Float.xxx), _Lerp_18ca18da5861e688a3fb637172636eda_Out_3_Vector3);
            float _Property_afd0f3561038ef8487e614f350d364dd_Out_0_Float = _BaseMetallic;
            float _Multiply_154e0f89b19c8e86926222afb13691e3_Out_2_Float;
            Unity_Multiply_float_float(_Split_91a015dea8acd38b904ba0935328a5bc_R_1_Float, _Property_afd0f3561038ef8487e614f350d364dd_Out_0_Float, _Multiply_154e0f89b19c8e86926222afb13691e3_Out_2_Float);
            float _Property_b82ce26778f44c8fa3510d1a8ed92d0d_Out_0_Float = _BaseAORemapMin;
            float _Property_9d07c7a09a85da809f1d4661406e0888_Out_0_Float = _BaseAORemapMax;
            float2 _Vector2_10162c774de2a7838426399cfe98be82_Out_0_Vector2 = float2(_Property_b82ce26778f44c8fa3510d1a8ed92d0d_Out_0_Float, _Property_9d07c7a09a85da809f1d4661406e0888_Out_0_Float);
            float _Remap_c45fda31db668c81a9e89e11297ec993_Out_3_Float;
            Unity_Remap_float(_Split_91a015dea8acd38b904ba0935328a5bc_G_2_Float, float2 (0, 1), _Vector2_10162c774de2a7838426399cfe98be82_Out_0_Vector2, _Remap_c45fda31db668c81a9e89e11297ec993_Out_3_Float);
            float _Property_04a7bb2753456b8293b3e46e346b646e_Out_0_Float = _BaseSmoothnessRemapMin;
            float _Property_75c8631fc908bb8ba8542d2e70d18cbf_Out_0_Float = _BaseSmoothnessRemapMax;
            float2 _Vector2_b2e1a3c487cdf88f9b5992b831ba24d6_Out_0_Vector2 = float2(_Property_04a7bb2753456b8293b3e46e346b646e_Out_0_Float, _Property_75c8631fc908bb8ba8542d2e70d18cbf_Out_0_Float);
            float _Remap_65ca5af95590f88da70777476b6efd40_Out_3_Float;
            Unity_Remap_float(_Split_91a015dea8acd38b904ba0935328a5bc_A_4_Float, float2 (0, 1), _Vector2_b2e1a3c487cdf88f9b5992b831ba24d6_Out_0_Vector2, _Remap_65ca5af95590f88da70777476b6efd40_Out_3_Float);
            float3 _Vector3_28c1e2dadb10138a9799d970043db9b0_Out_0_Vector3 = float3(_Multiply_154e0f89b19c8e86926222afb13691e3_Out_2_Float, _Remap_c45fda31db668c81a9e89e11297ec993_Out_3_Float, _Remap_65ca5af95590f88da70777476b6efd40_Out_3_Float);
            float _Property_4ead43cc6d37b68eb268dd80c3a561e9_Out_0_Float = _Base2Metallic;
            float _Multiply_eef7838a4634498b9cf12d1bee89d853_Out_2_Float;
            Unity_Multiply_float_float(_Split_83ec66b648ab6c84848b42686c256cd7_R_1_Float, _Property_4ead43cc6d37b68eb268dd80c3a561e9_Out_0_Float, _Multiply_eef7838a4634498b9cf12d1bee89d853_Out_2_Float);
            float _Property_e1ed9fe432388887abb17b07dcc5ca6b_Out_0_Float = _Base2AORemapMin;
            float _Property_cb0cf7882dcbcf88989a12f73fb7c917_Out_0_Float = _Base2AORemapMax;
            float2 _Vector2_2d74d82ae79d5681a097c2e3ce20c913_Out_0_Vector2 = float2(_Property_e1ed9fe432388887abb17b07dcc5ca6b_Out_0_Float, _Property_cb0cf7882dcbcf88989a12f73fb7c917_Out_0_Float);
            float _Remap_dcd2e2871e334281a15cdd1da6103c7f_Out_3_Float;
            Unity_Remap_float(_Split_83ec66b648ab6c84848b42686c256cd7_G_2_Float, float2 (0, 1), _Vector2_2d74d82ae79d5681a097c2e3ce20c913_Out_0_Vector2, _Remap_dcd2e2871e334281a15cdd1da6103c7f_Out_3_Float);
            float _Property_159cd47513de4f85a992da1f43f77c51_Out_0_Float = _Base2SmoothnessRemapMin;
            float _Property_b1f3c7061cf84380b1a0ffc2c5f770db_Out_0_Float = _Base2SmoothnessRemapMax;
            float2 _Vector2_eb0fcc98def54d83abe1cfec60457b78_Out_0_Vector2 = float2(_Property_159cd47513de4f85a992da1f43f77c51_Out_0_Float, _Property_b1f3c7061cf84380b1a0ffc2c5f770db_Out_0_Float);
            float _Remap_1214803bb0f7c387adc088fb938f7971_Out_3_Float;
            Unity_Remap_float(_Split_83ec66b648ab6c84848b42686c256cd7_A_4_Float, float2 (0, 1), _Vector2_eb0fcc98def54d83abe1cfec60457b78_Out_0_Vector2, _Remap_1214803bb0f7c387adc088fb938f7971_Out_3_Float);
            float3 _Vector3_ddb5452f73a0dc819b57dbe981a5f4e7_Out_0_Vector3 = float3(_Multiply_eef7838a4634498b9cf12d1bee89d853_Out_2_Float, _Remap_dcd2e2871e334281a15cdd1da6103c7f_Out_3_Float, _Remap_1214803bb0f7c387adc088fb938f7971_Out_3_Float);
            Bindings_HeightBlend_d15b6fb865d3b6d4ebc1fd476c3ad135_float _HeightBlend_3ef23bc9c463ea8f91d2c1bc27c32dff;
            float3 _HeightBlend_3ef23bc9c463ea8f91d2c1bc27c32dff_OutVector4_1_Vector3;
            SG_HeightBlend_d15b6fb865d3b6d4ebc1fd476c3ad135_float(_Vector3_28c1e2dadb10138a9799d970043db9b0_Out_0_Vector3, _Remap_18f2e96a438d6584ae2fd56f880de9ee_Out_3_Float, _Vector3_ddb5452f73a0dc819b57dbe981a5f4e7_Out_0_Vector3, _Multiply_74def30593cbbb8bbed03613a31cb89a_Out_2_Float, _Property_818c8af4b930138e81034c886614171d_Out_0_Float, _HeightBlend_3ef23bc9c463ea8f91d2c1bc27c32dff, _HeightBlend_3ef23bc9c463ea8f91d2c1bc27c32dff_OutVector4_1_Vector3);
            float _Property_6dbb3498614f2088a1315529ed864ea3_Out_0_Float = _CoverMetallic;
            float _Multiply_7a0f3f362f18fd86b9191e28255508f8_Out_2_Float;
            Unity_Multiply_float_float(_Split_86ec1aefda4f9e8e82b79c6195b397b0_R_1_Float, _Property_6dbb3498614f2088a1315529ed864ea3_Out_0_Float, _Multiply_7a0f3f362f18fd86b9191e28255508f8_Out_2_Float);
            float _Property_840e5ecb6a2ddb83abffd7be403ecd68_Out_0_Float = _CoverAORemapMin;
            float _Property_92176ee70059d28abbfcad689b580f1a_Out_0_Float = _CoverAORemapMax;
            float2 _Vector2_2b0ddb771cc86988a6f70ca3c4d0145b_Out_0_Vector2 = float2(_Property_840e5ecb6a2ddb83abffd7be403ecd68_Out_0_Float, _Property_92176ee70059d28abbfcad689b580f1a_Out_0_Float);
            float _Remap_1091f204ac00858d804a3785be14a17e_Out_3_Float;
            Unity_Remap_float(_Split_86ec1aefda4f9e8e82b79c6195b397b0_G_2_Float, float2 (0, 1), _Vector2_2b0ddb771cc86988a6f70ca3c4d0145b_Out_0_Vector2, _Remap_1091f204ac00858d804a3785be14a17e_Out_3_Float);
            float _Property_4cd4964a0372a3858a89e499b8d810a1_Out_0_Float = _CoverSmoothnessRemapMin;
            float _Property_f7e67cf191e5c38388370531311427cf_Out_0_Float = _CoverSmoothnessRemapMax;
            float2 _Vector2_60ae45a9f680358085440c61ca0118da_Out_0_Vector2 = float2(_Property_4cd4964a0372a3858a89e499b8d810a1_Out_0_Float, _Property_f7e67cf191e5c38388370531311427cf_Out_0_Float);
            float _Remap_e88a1283399b2187be29c818a3fc3543_Out_3_Float;
            Unity_Remap_float(_Split_86ec1aefda4f9e8e82b79c6195b397b0_A_4_Float, float2 (0, 1), _Vector2_60ae45a9f680358085440c61ca0118da_Out_0_Vector2, _Remap_e88a1283399b2187be29c818a3fc3543_Out_3_Float);
            float3 _Vector3_83d0f92fd33a1d8799fdafb5ae407cb7_Out_0_Vector3 = float3(_Multiply_7a0f3f362f18fd86b9191e28255508f8_Out_2_Float, _Remap_1091f204ac00858d804a3785be14a17e_Out_3_Float, _Remap_e88a1283399b2187be29c818a3fc3543_Out_3_Float);
            float3 _Lerp_afcfe197cbc3818eb5aaaa1cf503c7d4_Out_3_Vector3;
            Unity_Lerp_float3(_HeightBlend_3ef23bc9c463ea8f91d2c1bc27c32dff_OutVector4_1_Vector3, _Vector3_83d0f92fd33a1d8799fdafb5ae407cb7_Out_0_Vector3, (_UseDynamicCoverTStaticMaskF_20dcbac2f16cf78ebd6fd1debcd7f281_Out_0_Float.xxx), _Lerp_afcfe197cbc3818eb5aaaa1cf503c7d4_Out_3_Vector3);
            float _Split_93a6a2f8a95a1b80bea53b3c9628de7b_R_1_Float = _Lerp_afcfe197cbc3818eb5aaaa1cf503c7d4_Out_3_Vector3[0];
            float _Split_93a6a2f8a95a1b80bea53b3c9628de7b_G_2_Float = _Lerp_afcfe197cbc3818eb5aaaa1cf503c7d4_Out_3_Vector3[1];
            float _Split_93a6a2f8a95a1b80bea53b3c9628de7b_B_3_Float = _Lerp_afcfe197cbc3818eb5aaaa1cf503c7d4_Out_3_Vector3[2];
            float _Split_93a6a2f8a95a1b80bea53b3c9628de7b_A_4_Float = 0;
            float _Property_9e7eba3ba76f44e696fc2af012d437a5_Out_0_Float = _WetSmoothness;
            float _Lerp_b882eb16978042e3b7f6df830e253797_Out_3_Float;
            Unity_Lerp_float(_Split_93a6a2f8a95a1b80bea53b3c9628de7b_B_3_Float, _Property_9e7eba3ba76f44e696fc2af012d437a5_Out_0_Float, _OneMinus_6ed96e068e394cd09ae03c32446777c8_Out_1_Float, _Lerp_b882eb16978042e3b7f6df830e253797_Out_3_Float);
            float _Split_c7a719bf7da79a8ea38d7311fd844f92_R_1_Float = _Multiply_f572ff0def2d308e87a64e94a46c0d96_Out_2_Vector4[0];
            float _Split_c7a719bf7da79a8ea38d7311fd844f92_G_2_Float = _Multiply_f572ff0def2d308e87a64e94a46c0d96_Out_2_Vector4[1];
            float _Split_c7a719bf7da79a8ea38d7311fd844f92_B_3_Float = _Multiply_f572ff0def2d308e87a64e94a46c0d96_Out_2_Vector4[2];
            float _Split_c7a719bf7da79a8ea38d7311fd844f92_A_4_Float = _Multiply_f572ff0def2d308e87a64e94a46c0d96_Out_2_Vector4[3];
            float _Property_7c5dae9b46c9e686b49e58fa996a104a_Out_0_Boolean = IgnoreBase2Alpha;
            float _Split_e9060f5c0433ec889696d3e462f3229b_R_1_Float = _Multiply_d2ec682582195e84acc4a8510f50f4b0_Out_2_Vector4[0];
            float _Split_e9060f5c0433ec889696d3e462f3229b_G_2_Float = _Multiply_d2ec682582195e84acc4a8510f50f4b0_Out_2_Vector4[1];
            float _Split_e9060f5c0433ec889696d3e462f3229b_B_3_Float = _Multiply_d2ec682582195e84acc4a8510f50f4b0_Out_2_Vector4[2];
            float _Split_e9060f5c0433ec889696d3e462f3229b_A_4_Float = _Multiply_d2ec682582195e84acc4a8510f50f4b0_Out_2_Vector4[3];
            float _Branch_a7d7aece30fd9b8eb456d191fdd37a06_Out_3_Float;
            Unity_Branch_float(_Property_7c5dae9b46c9e686b49e58fa996a104a_Out_0_Boolean, _Split_c7a719bf7da79a8ea38d7311fd844f92_A_4_Float, _Split_e9060f5c0433ec889696d3e462f3229b_A_4_Float, _Branch_a7d7aece30fd9b8eb456d191fdd37a06_Out_3_Float);
            float _Lerp_8692ca93f568998fbc97130b6dbc4556_Out_3_Float;
            Unity_Lerp_float(_Split_c7a719bf7da79a8ea38d7311fd844f92_A_4_Float, _Branch_a7d7aece30fd9b8eb456d191fdd37a06_Out_3_Float, _Multiply_74def30593cbbb8bbed03613a31cb89a_Out_2_Float, _Lerp_8692ca93f568998fbc97130b6dbc4556_Out_3_Float);
            float _Clamp_0c8b7b55b9f82588ab2dcff09ee7a16d_Out_3_Float;
            Unity_Clamp_float(_Lerp_8692ca93f568998fbc97130b6dbc4556_Out_3_Float, float(0), float(1), _Clamp_0c8b7b55b9f82588ab2dcff09ee7a16d_Out_3_Float);
            float _Multiply_6333dc4a6348088bb7281602ce6bff5f_Out_2_Float;
            Unity_Multiply_float_float(_Clamp_0c8b7b55b9f82588ab2dcff09ee7a16d_Out_3_Float, _Split_c34b73d933404283983f9c8bdb5365d3_A_4_Float, _Multiply_6333dc4a6348088bb7281602ce6bff5f_Out_2_Float);
            float _Clamp_9642b8fb7e32b18a91da1888c9bc375b_Out_3_Float;
            Unity_Clamp_float(_Multiply_6333dc4a6348088bb7281602ce6bff5f_Out_2_Float, float(0), float(1), _Clamp_9642b8fb7e32b18a91da1888c9bc375b_Out_3_Float);
            float _Property_8bc98dd454a5508b9864a6ba09772356_Out_0_Float = _AlphaCutoff;
            surface.BaseColor = _Lerp_c16da1ee314d4393a798b1d36f6733d8_Out_3_Vector3;
            surface.NormalTS = _Lerp_18ca18da5861e688a3fb637172636eda_Out_3_Vector3;
            surface.Emission = float3(0, 0, 0);
            surface.Metallic = _Split_93a6a2f8a95a1b80bea53b3c9628de7b_R_1_Float;
            surface.Specular = IsGammaSpace() ? float3(0.5, 0.5, 0.5) : SRGBToLinear(float3(0.5, 0.5, 0.5));
            surface.Smoothness = _Lerp_b882eb16978042e3b7f6df830e253797_Out_3_Float;
            surface.Occlusion = _Split_93a6a2f8a95a1b80bea53b3c9628de7b_G_2_Float;
            surface.Alpha = _Clamp_9642b8fb7e32b18a91da1888c9bc375b_Out_3_Float;
            surface.AlphaClipThreshold = _Property_8bc98dd454a5508b9864a6ba09772356_Out_0_Float;
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
        #pragma shader_feature_local _ _USEDYNAMICCOVERTSTATICMASKF_ON
        
        #if defined(_USEDYNAMICCOVERTSTATICMASKF_ON)
            #define KEYWORD_PERMUTATION_0
        #else
            #define KEYWORD_PERMUTATION_1
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
             float4 texCoord0 : INTERP0;
             float4 texCoord3 : INTERP1;
             float4 color : INTERP2;
             float3 positionWS : INTERP3;
             float3 normalWS : INTERP4;
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
        float4 _WetColor;
        float _WetSmoothness;
        float _AlphaCutoff;
        float4 _BaseColor;
        float4 _BaseColorMap_TexelSize;
        float _BaseUsePlanarUV;
        float4 _BaseTilingOffset;
        float4 _BaseNormalMap_TexelSize;
        float _BaseNormalScale;
        float4 _BaseMaskMap_TexelSize;
        float _BaseMetallic;
        float _BaseAORemapMin;
        float _BaseAORemapMax;
        float _BaseSmoothnessRemapMin;
        float _BaseSmoothnessRemapMax;
        float4 _LayerMask_TexelSize;
        float _Invert_Layer_Mask;
        float _Height_Transition;
        float _HeightMin;
        float _HeightMax;
        float _HeightOffset;
        float _HeightMin2;
        float _HeightMax2;
        float _HeightOffset2;
        float IgnoreBase2Alpha;
        float4 _Base2Color;
        float4 _Base2ColorMap_TexelSize;
        float4 _Base2TilingOffset;
        float _Base2UsePlanarUV;
        float4 _Base2NormalMap_TexelSize;
        float _Base2NormalScale;
        float4 _Base2MaskMap_TexelSize;
        float _Base2Metallic;
        float _Base2SmoothnessRemapMin;
        float _Base2SmoothnessRemapMax;
        float _Base2AORemapMin;
        float _Base2AORemapMax;
        float _CoverMaskPower;
        float _Cover_Amount;
        float _Cover_Amount_Grow_Speed;
        float _Cover_Max_Angle;
        float _Cover_Min_Height;
        float _Cover_Min_Height_Blending;
        float4 _CoverBaseColor;
        float4 _CoverBaseColorMap_TexelSize;
        float4 _CoverTilingOffset;
        float _CoverUsePlanarUV;
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
        UNITY_TEXTURE_STREAMING_DEBUG_VARS;
        CBUFFER_END
        
        
        // Object and Global properties
        SAMPLER(SamplerState_Linear_Repeat);
        SAMPLER(SamplerState_Linear_Repeat_Aniso8);
        TEXTURE2D(_BaseColorMap);
        SAMPLER(sampler_BaseColorMap);
        TEXTURE2D(_BaseNormalMap);
        SAMPLER(sampler_BaseNormalMap);
        TEXTURE2D(_BaseMaskMap);
        SAMPLER(sampler_BaseMaskMap);
        TEXTURE2D(_LayerMask);
        SAMPLER(sampler_LayerMask);
        TEXTURE2D(_Base2ColorMap);
        SAMPLER(sampler_Base2ColorMap);
        TEXTURE2D(_Base2NormalMap);
        SAMPLER(sampler_Base2NormalMap);
        TEXTURE2D(_Base2MaskMap);
        SAMPLER(sampler_Base2MaskMap);
        TEXTURE2D(_CoverBaseColorMap);
        SAMPLER(sampler_CoverBaseColorMap);
        TEXTURE2D(_CoverNormalMap);
        SAMPLER(sampler_CoverNormalMap);
        TEXTURE2D(_CoverMaskMap);
        SAMPLER(sampler_CoverMaskMap);
        
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
        
        void Unity_Branch_float(float Predicate, float True, float False, out float Out)
        {
            Out = Predicate ? True : False;
        }
        
        void Unity_OneMinus_float(float In, out float Out)
        {
            Out = 1 - In;
        }
        
        void Unity_Add_float2(float2 A, float2 B, out float2 Out)
        {
            Out = A + B;
        }
        
        void Unity_Remap_float(float In, float2 InMinMax, float2 OutMinMax, out float Out)
        {
            Out = OutMinMax.x + (In - InMinMax.x) * (OutMinMax.y - OutMinMax.x) / (InMinMax.y - InMinMax.x);
        }
        
        void Unity_Multiply_float_float(float A, float B, out float Out)
        {
            Out = A * B;
        }
        
        void Unity_Lerp_float(float A, float B, float T, out float Out)
        {
            Out = lerp(A, B, T);
        }
        
        void Unity_Clamp_float(float In, float Min, float Max, out float Out)
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
            UnityTexture2D _Property_07d75b1d2628da808a2efb93a1d6219e_Out_0_Texture2D = UnityBuildTexture2DStructNoScale(_BaseColorMap);
            float4 _Property_587a28253857318a9b2e59bfc8fb56a4_Out_0_Vector4 = _BaseTilingOffset;
            float _Property_7f998178363b4188ba2f07298ef869c1_Out_0_Boolean = _BaseUsePlanarUV;
            Bindings_PlanarNM_c0f081da9c567704ea36e7dd38cedcf6_float _PlanarNM_0b8fbae0d009788d8cd595a3b9bf9f6e;
            _PlanarNM_0b8fbae0d009788d8cd595a3b9bf9f6e.AbsoluteWorldSpacePosition = IN.AbsoluteWorldSpacePosition;
            _PlanarNM_0b8fbae0d009788d8cd595a3b9bf9f6e.uv0 = IN.uv0;
            _PlanarNM_0b8fbae0d009788d8cd595a3b9bf9f6e.uv3 = IN.uv3;
            float4 _PlanarNM_0b8fbae0d009788d8cd595a3b9bf9f6e_XZ_2_Vector4;
            SG_PlanarNM_c0f081da9c567704ea36e7dd38cedcf6_float(_Property_07d75b1d2628da808a2efb93a1d6219e_Out_0_Texture2D, _Property_587a28253857318a9b2e59bfc8fb56a4_Out_0_Vector4, _Property_7f998178363b4188ba2f07298ef869c1_Out_0_Boolean, UnityBuildSamplerStateStruct(SamplerState_Linear_Repeat_Aniso8), 1, _PlanarNM_0b8fbae0d009788d8cd595a3b9bf9f6e, _PlanarNM_0b8fbae0d009788d8cd595a3b9bf9f6e_XZ_2_Vector4);
            float4 _Property_b83097c58639858680bf43881a95b0af_Out_0_Vector4 = _BaseColor;
            float4 _Multiply_f572ff0def2d308e87a64e94a46c0d96_Out_2_Vector4;
            Unity_Multiply_float4_float4(_PlanarNM_0b8fbae0d009788d8cd595a3b9bf9f6e_XZ_2_Vector4, _Property_b83097c58639858680bf43881a95b0af_Out_0_Vector4, _Multiply_f572ff0def2d308e87a64e94a46c0d96_Out_2_Vector4);
            float _Split_c7a719bf7da79a8ea38d7311fd844f92_R_1_Float = _Multiply_f572ff0def2d308e87a64e94a46c0d96_Out_2_Vector4[0];
            float _Split_c7a719bf7da79a8ea38d7311fd844f92_G_2_Float = _Multiply_f572ff0def2d308e87a64e94a46c0d96_Out_2_Vector4[1];
            float _Split_c7a719bf7da79a8ea38d7311fd844f92_B_3_Float = _Multiply_f572ff0def2d308e87a64e94a46c0d96_Out_2_Vector4[2];
            float _Split_c7a719bf7da79a8ea38d7311fd844f92_A_4_Float = _Multiply_f572ff0def2d308e87a64e94a46c0d96_Out_2_Vector4[3];
            float _Property_7c5dae9b46c9e686b49e58fa996a104a_Out_0_Boolean = IgnoreBase2Alpha;
            UnityTexture2D _Property_ba3a5f4cba7d0a8fa288ffc8267d6c0e_Out_0_Texture2D = UnityBuildTexture2DStructNoScale(_Base2ColorMap);
            float4 _Property_86a4657df480d48e8d3ad3b036731380_Out_0_Vector4 = _Base2TilingOffset;
            float _Property_6c5e16c615cab08a97c2a577642b9d83_Out_0_Boolean = _Base2UsePlanarUV;
            Bindings_PlanarNM_c0f081da9c567704ea36e7dd38cedcf6_float _PlanarNM_5aeab444ca6fd78ea56a01215880a5a4;
            _PlanarNM_5aeab444ca6fd78ea56a01215880a5a4.AbsoluteWorldSpacePosition = IN.AbsoluteWorldSpacePosition;
            _PlanarNM_5aeab444ca6fd78ea56a01215880a5a4.uv0 = IN.uv0;
            _PlanarNM_5aeab444ca6fd78ea56a01215880a5a4.uv3 = IN.uv3;
            float4 _PlanarNM_5aeab444ca6fd78ea56a01215880a5a4_XZ_2_Vector4;
            SG_PlanarNM_c0f081da9c567704ea36e7dd38cedcf6_float(_Property_ba3a5f4cba7d0a8fa288ffc8267d6c0e_Out_0_Texture2D, _Property_86a4657df480d48e8d3ad3b036731380_Out_0_Vector4, _Property_6c5e16c615cab08a97c2a577642b9d83_Out_0_Boolean, UnityBuildSamplerStateStruct(SamplerState_Linear_Repeat_Aniso8), 1, _PlanarNM_5aeab444ca6fd78ea56a01215880a5a4, _PlanarNM_5aeab444ca6fd78ea56a01215880a5a4_XZ_2_Vector4);
            float4 _Property_3561b11b899bda8e855826445cf628aa_Out_0_Vector4 = _Base2Color;
            float4 _Multiply_d2ec682582195e84acc4a8510f50f4b0_Out_2_Vector4;
            Unity_Multiply_float4_float4(_PlanarNM_5aeab444ca6fd78ea56a01215880a5a4_XZ_2_Vector4, _Property_3561b11b899bda8e855826445cf628aa_Out_0_Vector4, _Multiply_d2ec682582195e84acc4a8510f50f4b0_Out_2_Vector4);
            float _Split_e9060f5c0433ec889696d3e462f3229b_R_1_Float = _Multiply_d2ec682582195e84acc4a8510f50f4b0_Out_2_Vector4[0];
            float _Split_e9060f5c0433ec889696d3e462f3229b_G_2_Float = _Multiply_d2ec682582195e84acc4a8510f50f4b0_Out_2_Vector4[1];
            float _Split_e9060f5c0433ec889696d3e462f3229b_B_3_Float = _Multiply_d2ec682582195e84acc4a8510f50f4b0_Out_2_Vector4[2];
            float _Split_e9060f5c0433ec889696d3e462f3229b_A_4_Float = _Multiply_d2ec682582195e84acc4a8510f50f4b0_Out_2_Vector4[3];
            float _Branch_a7d7aece30fd9b8eb456d191fdd37a06_Out_3_Float;
            Unity_Branch_float(_Property_7c5dae9b46c9e686b49e58fa996a104a_Out_0_Boolean, _Split_c7a719bf7da79a8ea38d7311fd844f92_A_4_Float, _Split_e9060f5c0433ec889696d3e462f3229b_A_4_Float, _Branch_a7d7aece30fd9b8eb456d191fdd37a06_Out_3_Float);
            float _Split_c34b73d933404283983f9c8bdb5365d3_R_1_Float = IN.VertexColor[0];
            float _Split_c34b73d933404283983f9c8bdb5365d3_G_2_Float = IN.VertexColor[1];
            float _Split_c34b73d933404283983f9c8bdb5365d3_B_3_Float = IN.VertexColor[2];
            float _Split_c34b73d933404283983f9c8bdb5365d3_A_4_Float = IN.VertexColor[3];
            float _Property_df2df7bb5cfc3381beee7ec454da7542_Out_0_Boolean = _Invert_Layer_Mask;
            UnityTexture2D _Property_c7b1e2df9f9b0e8eace9b2274924e69c_Out_0_Texture2D = UnityBuildTexture2DStructNoScale(_LayerMask);
            float4 _SampleTexture2D_175fb18fafc9598382f1f5f7e97bf30a_RGBA_0_Vector4 = SAMPLE_TEXTURE2D(_Property_c7b1e2df9f9b0e8eace9b2274924e69c_Out_0_Texture2D.tex, _Property_c7b1e2df9f9b0e8eace9b2274924e69c_Out_0_Texture2D.samplerstate, _Property_c7b1e2df9f9b0e8eace9b2274924e69c_Out_0_Texture2D.GetTransformedUV(IN.uv0.xy) );
            float _SampleTexture2D_175fb18fafc9598382f1f5f7e97bf30a_R_4_Float = _SampleTexture2D_175fb18fafc9598382f1f5f7e97bf30a_RGBA_0_Vector4.r;
            float _SampleTexture2D_175fb18fafc9598382f1f5f7e97bf30a_G_5_Float = _SampleTexture2D_175fb18fafc9598382f1f5f7e97bf30a_RGBA_0_Vector4.g;
            float _SampleTexture2D_175fb18fafc9598382f1f5f7e97bf30a_B_6_Float = _SampleTexture2D_175fb18fafc9598382f1f5f7e97bf30a_RGBA_0_Vector4.b;
            float _SampleTexture2D_175fb18fafc9598382f1f5f7e97bf30a_A_7_Float = _SampleTexture2D_175fb18fafc9598382f1f5f7e97bf30a_RGBA_0_Vector4.a;
            float _OneMinus_ce5c3c0635d4ac86beb55115d0ebaed7_Out_1_Float;
            Unity_OneMinus_float(_SampleTexture2D_175fb18fafc9598382f1f5f7e97bf30a_R_4_Float, _OneMinus_ce5c3c0635d4ac86beb55115d0ebaed7_Out_1_Float);
            float _Branch_af0c5e511241ce8eae748ae487df50fa_Out_3_Float;
            Unity_Branch_float(_Property_df2df7bb5cfc3381beee7ec454da7542_Out_0_Boolean, _OneMinus_ce5c3c0635d4ac86beb55115d0ebaed7_Out_1_Float, _SampleTexture2D_175fb18fafc9598382f1f5f7e97bf30a_R_4_Float, _Branch_af0c5e511241ce8eae748ae487df50fa_Out_3_Float);
            UnityTexture2D _Property_de4f6eb48a629285a664dad7fb06438f_Out_0_Texture2D = UnityBuildTexture2DStructNoScale(_Base2MaskMap);
            Bindings_PlanarNM_c0f081da9c567704ea36e7dd38cedcf6_float _PlanarNM_d5657f470f05ef839e4c257a20ace8cb;
            _PlanarNM_d5657f470f05ef839e4c257a20ace8cb.AbsoluteWorldSpacePosition = IN.AbsoluteWorldSpacePosition;
            _PlanarNM_d5657f470f05ef839e4c257a20ace8cb.uv0 = IN.uv0;
            _PlanarNM_d5657f470f05ef839e4c257a20ace8cb.uv3 = IN.uv3;
            float4 _PlanarNM_d5657f470f05ef839e4c257a20ace8cb_XZ_2_Vector4;
            SG_PlanarNM_c0f081da9c567704ea36e7dd38cedcf6_float(_Property_de4f6eb48a629285a664dad7fb06438f_Out_0_Texture2D, _Property_86a4657df480d48e8d3ad3b036731380_Out_0_Vector4, _Property_6c5e16c615cab08a97c2a577642b9d83_Out_0_Boolean, UnityBuildSamplerStateStruct(SamplerState_Linear_Repeat_Aniso8), 1, _PlanarNM_d5657f470f05ef839e4c257a20ace8cb, _PlanarNM_d5657f470f05ef839e4c257a20ace8cb_XZ_2_Vector4);
            float _Split_83ec66b648ab6c84848b42686c256cd7_R_1_Float = _PlanarNM_d5657f470f05ef839e4c257a20ace8cb_XZ_2_Vector4[0];
            float _Split_83ec66b648ab6c84848b42686c256cd7_G_2_Float = _PlanarNM_d5657f470f05ef839e4c257a20ace8cb_XZ_2_Vector4[1];
            float _Split_83ec66b648ab6c84848b42686c256cd7_B_3_Float = _PlanarNM_d5657f470f05ef839e4c257a20ace8cb_XZ_2_Vector4[2];
            float _Split_83ec66b648ab6c84848b42686c256cd7_A_4_Float = _PlanarNM_d5657f470f05ef839e4c257a20ace8cb_XZ_2_Vector4[3];
            float _Property_ce1750e5c69e97818667b412fc3f9f2c_Out_0_Float = _HeightMin2;
            float _Property_8e0f2ea54d8ede89bbabdf31a9bafd57_Out_0_Float = _HeightMax2;
            float2 _Vector2_fb6c6dd7e70e768ba686e8e94153bb96_Out_0_Vector2 = float2(_Property_ce1750e5c69e97818667b412fc3f9f2c_Out_0_Float, _Property_8e0f2ea54d8ede89bbabdf31a9bafd57_Out_0_Float);
            float _Property_151ae2702b614585af2000f0a812960f_Out_0_Float = _HeightOffset2;
            float2 _Add_fd1b3d8e24e77087a55888eeb238f1a6_Out_2_Vector2;
            Unity_Add_float2(_Vector2_fb6c6dd7e70e768ba686e8e94153bb96_Out_0_Vector2, (_Property_151ae2702b614585af2000f0a812960f_Out_0_Float.xx), _Add_fd1b3d8e24e77087a55888eeb238f1a6_Out_2_Vector2);
            float _Remap_3d4180c0ab36ba86a5517b2645f0bfa7_Out_3_Float;
            Unity_Remap_float(_Split_83ec66b648ab6c84848b42686c256cd7_B_3_Float, float2 (0, 1), _Add_fd1b3d8e24e77087a55888eeb238f1a6_Out_2_Vector2, _Remap_3d4180c0ab36ba86a5517b2645f0bfa7_Out_3_Float);
            float _Multiply_2cb0e5aa384654828f0453a44884573c_Out_2_Float;
            Unity_Multiply_float_float(_Branch_af0c5e511241ce8eae748ae487df50fa_Out_3_Float, _Remap_3d4180c0ab36ba86a5517b2645f0bfa7_Out_3_Float, _Multiply_2cb0e5aa384654828f0453a44884573c_Out_2_Float);
            float _Multiply_74def30593cbbb8bbed03613a31cb89a_Out_2_Float;
            Unity_Multiply_float_float(_Split_c34b73d933404283983f9c8bdb5365d3_G_2_Float, _Multiply_2cb0e5aa384654828f0453a44884573c_Out_2_Float, _Multiply_74def30593cbbb8bbed03613a31cb89a_Out_2_Float);
            float _Lerp_8692ca93f568998fbc97130b6dbc4556_Out_3_Float;
            Unity_Lerp_float(_Split_c7a719bf7da79a8ea38d7311fd844f92_A_4_Float, _Branch_a7d7aece30fd9b8eb456d191fdd37a06_Out_3_Float, _Multiply_74def30593cbbb8bbed03613a31cb89a_Out_2_Float, _Lerp_8692ca93f568998fbc97130b6dbc4556_Out_3_Float);
            float _Clamp_0c8b7b55b9f82588ab2dcff09ee7a16d_Out_3_Float;
            Unity_Clamp_float(_Lerp_8692ca93f568998fbc97130b6dbc4556_Out_3_Float, float(0), float(1), _Clamp_0c8b7b55b9f82588ab2dcff09ee7a16d_Out_3_Float);
            float _Multiply_6333dc4a6348088bb7281602ce6bff5f_Out_2_Float;
            Unity_Multiply_float_float(_Clamp_0c8b7b55b9f82588ab2dcff09ee7a16d_Out_3_Float, _Split_c34b73d933404283983f9c8bdb5365d3_A_4_Float, _Multiply_6333dc4a6348088bb7281602ce6bff5f_Out_2_Float);
            float _Clamp_9642b8fb7e32b18a91da1888c9bc375b_Out_3_Float;
            Unity_Clamp_float(_Multiply_6333dc4a6348088bb7281602ce6bff5f_Out_2_Float, float(0), float(1), _Clamp_9642b8fb7e32b18a91da1888c9bc375b_Out_3_Float);
            float _Property_8bc98dd454a5508b9864a6ba09772356_Out_0_Float = _AlphaCutoff;
            surface.Alpha = _Clamp_9642b8fb7e32b18a91da1888c9bc375b_Out_3_Float;
            surface.AlphaClipThreshold = _Property_8bc98dd454a5508b9864a6ba09772356_Out_0_Float;
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
        #pragma shader_feature_local _ _USEDYNAMICCOVERTSTATICMASKF_ON
        
        #if defined(_USEDYNAMICCOVERTSTATICMASKF_ON)
            #define KEYWORD_PERMUTATION_0
        #else
            #define KEYWORD_PERMUTATION_1
        #endif
        
        
        // Defines
        
        #define _NORMALMAP 1
        #define _NORMAL_DROPOFF_TS 1
        #define ATTRIBUTES_NEED_TEXCOORD0
        #define ATTRIBUTES_NEED_TEXCOORD3
        #define ATTRIBUTES_NEED_COLOR
        #define VARYINGS_NEED_POSITION_WS
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
             float4 texCoord0 : INTERP0;
             float4 texCoord3 : INTERP1;
             float4 color : INTERP2;
             float3 positionWS : INTERP3;
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
            output.texCoord0.xyzw = input.texCoord0;
            output.texCoord3.xyzw = input.texCoord3;
            output.color.xyzw = input.color;
            output.positionWS.xyz = input.positionWS;
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
            output.texCoord0 = input.texCoord0.xyzw;
            output.texCoord3 = input.texCoord3.xyzw;
            output.color = input.color.xyzw;
            output.positionWS = input.positionWS.xyz;
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
        float4 _WetColor;
        float _WetSmoothness;
        float _AlphaCutoff;
        float4 _BaseColor;
        float4 _BaseColorMap_TexelSize;
        float _BaseUsePlanarUV;
        float4 _BaseTilingOffset;
        float4 _BaseNormalMap_TexelSize;
        float _BaseNormalScale;
        float4 _BaseMaskMap_TexelSize;
        float _BaseMetallic;
        float _BaseAORemapMin;
        float _BaseAORemapMax;
        float _BaseSmoothnessRemapMin;
        float _BaseSmoothnessRemapMax;
        float4 _LayerMask_TexelSize;
        float _Invert_Layer_Mask;
        float _Height_Transition;
        float _HeightMin;
        float _HeightMax;
        float _HeightOffset;
        float _HeightMin2;
        float _HeightMax2;
        float _HeightOffset2;
        float IgnoreBase2Alpha;
        float4 _Base2Color;
        float4 _Base2ColorMap_TexelSize;
        float4 _Base2TilingOffset;
        float _Base2UsePlanarUV;
        float4 _Base2NormalMap_TexelSize;
        float _Base2NormalScale;
        float4 _Base2MaskMap_TexelSize;
        float _Base2Metallic;
        float _Base2SmoothnessRemapMin;
        float _Base2SmoothnessRemapMax;
        float _Base2AORemapMin;
        float _Base2AORemapMax;
        float _CoverMaskPower;
        float _Cover_Amount;
        float _Cover_Amount_Grow_Speed;
        float _Cover_Max_Angle;
        float _Cover_Min_Height;
        float _Cover_Min_Height_Blending;
        float4 _CoverBaseColor;
        float4 _CoverBaseColorMap_TexelSize;
        float4 _CoverTilingOffset;
        float _CoverUsePlanarUV;
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
        UNITY_TEXTURE_STREAMING_DEBUG_VARS;
        CBUFFER_END
        
        
        // Object and Global properties
        SAMPLER(SamplerState_Linear_Repeat);
        SAMPLER(SamplerState_Linear_Repeat_Aniso8);
        TEXTURE2D(_BaseColorMap);
        SAMPLER(sampler_BaseColorMap);
        TEXTURE2D(_BaseNormalMap);
        SAMPLER(sampler_BaseNormalMap);
        TEXTURE2D(_BaseMaskMap);
        SAMPLER(sampler_BaseMaskMap);
        TEXTURE2D(_LayerMask);
        SAMPLER(sampler_LayerMask);
        TEXTURE2D(_Base2ColorMap);
        SAMPLER(sampler_Base2ColorMap);
        TEXTURE2D(_Base2NormalMap);
        SAMPLER(sampler_Base2NormalMap);
        TEXTURE2D(_Base2MaskMap);
        SAMPLER(sampler_Base2MaskMap);
        TEXTURE2D(_CoverBaseColorMap);
        SAMPLER(sampler_CoverBaseColorMap);
        TEXTURE2D(_CoverNormalMap);
        SAMPLER(sampler_CoverNormalMap);
        TEXTURE2D(_CoverMaskMap);
        SAMPLER(sampler_CoverMaskMap);
        
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
        
        void Unity_Branch_float(float Predicate, float True, float False, out float Out)
        {
            Out = Predicate ? True : False;
        }
        
        void Unity_OneMinus_float(float In, out float Out)
        {
            Out = 1 - In;
        }
        
        void Unity_Add_float2(float2 A, float2 B, out float2 Out)
        {
            Out = A + B;
        }
        
        void Unity_Remap_float(float In, float2 InMinMax, float2 OutMinMax, out float Out)
        {
            Out = OutMinMax.x + (In - InMinMax.x) * (OutMinMax.y - OutMinMax.x) / (InMinMax.y - InMinMax.x);
        }
        
        void Unity_Multiply_float_float(float A, float B, out float Out)
        {
            Out = A * B;
        }
        
        void Unity_Lerp_float(float A, float B, float T, out float Out)
        {
            Out = lerp(A, B, T);
        }
        
        void Unity_Clamp_float(float In, float Min, float Max, out float Out)
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
            UnityTexture2D _Property_07d75b1d2628da808a2efb93a1d6219e_Out_0_Texture2D = UnityBuildTexture2DStructNoScale(_BaseColorMap);
            float4 _Property_587a28253857318a9b2e59bfc8fb56a4_Out_0_Vector4 = _BaseTilingOffset;
            float _Property_7f998178363b4188ba2f07298ef869c1_Out_0_Boolean = _BaseUsePlanarUV;
            Bindings_PlanarNM_c0f081da9c567704ea36e7dd38cedcf6_float _PlanarNM_0b8fbae0d009788d8cd595a3b9bf9f6e;
            _PlanarNM_0b8fbae0d009788d8cd595a3b9bf9f6e.AbsoluteWorldSpacePosition = IN.AbsoluteWorldSpacePosition;
            _PlanarNM_0b8fbae0d009788d8cd595a3b9bf9f6e.uv0 = IN.uv0;
            _PlanarNM_0b8fbae0d009788d8cd595a3b9bf9f6e.uv3 = IN.uv3;
            float4 _PlanarNM_0b8fbae0d009788d8cd595a3b9bf9f6e_XZ_2_Vector4;
            SG_PlanarNM_c0f081da9c567704ea36e7dd38cedcf6_float(_Property_07d75b1d2628da808a2efb93a1d6219e_Out_0_Texture2D, _Property_587a28253857318a9b2e59bfc8fb56a4_Out_0_Vector4, _Property_7f998178363b4188ba2f07298ef869c1_Out_0_Boolean, UnityBuildSamplerStateStruct(SamplerState_Linear_Repeat_Aniso8), 1, _PlanarNM_0b8fbae0d009788d8cd595a3b9bf9f6e, _PlanarNM_0b8fbae0d009788d8cd595a3b9bf9f6e_XZ_2_Vector4);
            float4 _Property_b83097c58639858680bf43881a95b0af_Out_0_Vector4 = _BaseColor;
            float4 _Multiply_f572ff0def2d308e87a64e94a46c0d96_Out_2_Vector4;
            Unity_Multiply_float4_float4(_PlanarNM_0b8fbae0d009788d8cd595a3b9bf9f6e_XZ_2_Vector4, _Property_b83097c58639858680bf43881a95b0af_Out_0_Vector4, _Multiply_f572ff0def2d308e87a64e94a46c0d96_Out_2_Vector4);
            float _Split_c7a719bf7da79a8ea38d7311fd844f92_R_1_Float = _Multiply_f572ff0def2d308e87a64e94a46c0d96_Out_2_Vector4[0];
            float _Split_c7a719bf7da79a8ea38d7311fd844f92_G_2_Float = _Multiply_f572ff0def2d308e87a64e94a46c0d96_Out_2_Vector4[1];
            float _Split_c7a719bf7da79a8ea38d7311fd844f92_B_3_Float = _Multiply_f572ff0def2d308e87a64e94a46c0d96_Out_2_Vector4[2];
            float _Split_c7a719bf7da79a8ea38d7311fd844f92_A_4_Float = _Multiply_f572ff0def2d308e87a64e94a46c0d96_Out_2_Vector4[3];
            float _Property_7c5dae9b46c9e686b49e58fa996a104a_Out_0_Boolean = IgnoreBase2Alpha;
            UnityTexture2D _Property_ba3a5f4cba7d0a8fa288ffc8267d6c0e_Out_0_Texture2D = UnityBuildTexture2DStructNoScale(_Base2ColorMap);
            float4 _Property_86a4657df480d48e8d3ad3b036731380_Out_0_Vector4 = _Base2TilingOffset;
            float _Property_6c5e16c615cab08a97c2a577642b9d83_Out_0_Boolean = _Base2UsePlanarUV;
            Bindings_PlanarNM_c0f081da9c567704ea36e7dd38cedcf6_float _PlanarNM_5aeab444ca6fd78ea56a01215880a5a4;
            _PlanarNM_5aeab444ca6fd78ea56a01215880a5a4.AbsoluteWorldSpacePosition = IN.AbsoluteWorldSpacePosition;
            _PlanarNM_5aeab444ca6fd78ea56a01215880a5a4.uv0 = IN.uv0;
            _PlanarNM_5aeab444ca6fd78ea56a01215880a5a4.uv3 = IN.uv3;
            float4 _PlanarNM_5aeab444ca6fd78ea56a01215880a5a4_XZ_2_Vector4;
            SG_PlanarNM_c0f081da9c567704ea36e7dd38cedcf6_float(_Property_ba3a5f4cba7d0a8fa288ffc8267d6c0e_Out_0_Texture2D, _Property_86a4657df480d48e8d3ad3b036731380_Out_0_Vector4, _Property_6c5e16c615cab08a97c2a577642b9d83_Out_0_Boolean, UnityBuildSamplerStateStruct(SamplerState_Linear_Repeat_Aniso8), 1, _PlanarNM_5aeab444ca6fd78ea56a01215880a5a4, _PlanarNM_5aeab444ca6fd78ea56a01215880a5a4_XZ_2_Vector4);
            float4 _Property_3561b11b899bda8e855826445cf628aa_Out_0_Vector4 = _Base2Color;
            float4 _Multiply_d2ec682582195e84acc4a8510f50f4b0_Out_2_Vector4;
            Unity_Multiply_float4_float4(_PlanarNM_5aeab444ca6fd78ea56a01215880a5a4_XZ_2_Vector4, _Property_3561b11b899bda8e855826445cf628aa_Out_0_Vector4, _Multiply_d2ec682582195e84acc4a8510f50f4b0_Out_2_Vector4);
            float _Split_e9060f5c0433ec889696d3e462f3229b_R_1_Float = _Multiply_d2ec682582195e84acc4a8510f50f4b0_Out_2_Vector4[0];
            float _Split_e9060f5c0433ec889696d3e462f3229b_G_2_Float = _Multiply_d2ec682582195e84acc4a8510f50f4b0_Out_2_Vector4[1];
            float _Split_e9060f5c0433ec889696d3e462f3229b_B_3_Float = _Multiply_d2ec682582195e84acc4a8510f50f4b0_Out_2_Vector4[2];
            float _Split_e9060f5c0433ec889696d3e462f3229b_A_4_Float = _Multiply_d2ec682582195e84acc4a8510f50f4b0_Out_2_Vector4[3];
            float _Branch_a7d7aece30fd9b8eb456d191fdd37a06_Out_3_Float;
            Unity_Branch_float(_Property_7c5dae9b46c9e686b49e58fa996a104a_Out_0_Boolean, _Split_c7a719bf7da79a8ea38d7311fd844f92_A_4_Float, _Split_e9060f5c0433ec889696d3e462f3229b_A_4_Float, _Branch_a7d7aece30fd9b8eb456d191fdd37a06_Out_3_Float);
            float _Split_c34b73d933404283983f9c8bdb5365d3_R_1_Float = IN.VertexColor[0];
            float _Split_c34b73d933404283983f9c8bdb5365d3_G_2_Float = IN.VertexColor[1];
            float _Split_c34b73d933404283983f9c8bdb5365d3_B_3_Float = IN.VertexColor[2];
            float _Split_c34b73d933404283983f9c8bdb5365d3_A_4_Float = IN.VertexColor[3];
            float _Property_df2df7bb5cfc3381beee7ec454da7542_Out_0_Boolean = _Invert_Layer_Mask;
            UnityTexture2D _Property_c7b1e2df9f9b0e8eace9b2274924e69c_Out_0_Texture2D = UnityBuildTexture2DStructNoScale(_LayerMask);
            float4 _SampleTexture2D_175fb18fafc9598382f1f5f7e97bf30a_RGBA_0_Vector4 = SAMPLE_TEXTURE2D(_Property_c7b1e2df9f9b0e8eace9b2274924e69c_Out_0_Texture2D.tex, _Property_c7b1e2df9f9b0e8eace9b2274924e69c_Out_0_Texture2D.samplerstate, _Property_c7b1e2df9f9b0e8eace9b2274924e69c_Out_0_Texture2D.GetTransformedUV(IN.uv0.xy) );
            float _SampleTexture2D_175fb18fafc9598382f1f5f7e97bf30a_R_4_Float = _SampleTexture2D_175fb18fafc9598382f1f5f7e97bf30a_RGBA_0_Vector4.r;
            float _SampleTexture2D_175fb18fafc9598382f1f5f7e97bf30a_G_5_Float = _SampleTexture2D_175fb18fafc9598382f1f5f7e97bf30a_RGBA_0_Vector4.g;
            float _SampleTexture2D_175fb18fafc9598382f1f5f7e97bf30a_B_6_Float = _SampleTexture2D_175fb18fafc9598382f1f5f7e97bf30a_RGBA_0_Vector4.b;
            float _SampleTexture2D_175fb18fafc9598382f1f5f7e97bf30a_A_7_Float = _SampleTexture2D_175fb18fafc9598382f1f5f7e97bf30a_RGBA_0_Vector4.a;
            float _OneMinus_ce5c3c0635d4ac86beb55115d0ebaed7_Out_1_Float;
            Unity_OneMinus_float(_SampleTexture2D_175fb18fafc9598382f1f5f7e97bf30a_R_4_Float, _OneMinus_ce5c3c0635d4ac86beb55115d0ebaed7_Out_1_Float);
            float _Branch_af0c5e511241ce8eae748ae487df50fa_Out_3_Float;
            Unity_Branch_float(_Property_df2df7bb5cfc3381beee7ec454da7542_Out_0_Boolean, _OneMinus_ce5c3c0635d4ac86beb55115d0ebaed7_Out_1_Float, _SampleTexture2D_175fb18fafc9598382f1f5f7e97bf30a_R_4_Float, _Branch_af0c5e511241ce8eae748ae487df50fa_Out_3_Float);
            UnityTexture2D _Property_de4f6eb48a629285a664dad7fb06438f_Out_0_Texture2D = UnityBuildTexture2DStructNoScale(_Base2MaskMap);
            Bindings_PlanarNM_c0f081da9c567704ea36e7dd38cedcf6_float _PlanarNM_d5657f470f05ef839e4c257a20ace8cb;
            _PlanarNM_d5657f470f05ef839e4c257a20ace8cb.AbsoluteWorldSpacePosition = IN.AbsoluteWorldSpacePosition;
            _PlanarNM_d5657f470f05ef839e4c257a20ace8cb.uv0 = IN.uv0;
            _PlanarNM_d5657f470f05ef839e4c257a20ace8cb.uv3 = IN.uv3;
            float4 _PlanarNM_d5657f470f05ef839e4c257a20ace8cb_XZ_2_Vector4;
            SG_PlanarNM_c0f081da9c567704ea36e7dd38cedcf6_float(_Property_de4f6eb48a629285a664dad7fb06438f_Out_0_Texture2D, _Property_86a4657df480d48e8d3ad3b036731380_Out_0_Vector4, _Property_6c5e16c615cab08a97c2a577642b9d83_Out_0_Boolean, UnityBuildSamplerStateStruct(SamplerState_Linear_Repeat_Aniso8), 1, _PlanarNM_d5657f470f05ef839e4c257a20ace8cb, _PlanarNM_d5657f470f05ef839e4c257a20ace8cb_XZ_2_Vector4);
            float _Split_83ec66b648ab6c84848b42686c256cd7_R_1_Float = _PlanarNM_d5657f470f05ef839e4c257a20ace8cb_XZ_2_Vector4[0];
            float _Split_83ec66b648ab6c84848b42686c256cd7_G_2_Float = _PlanarNM_d5657f470f05ef839e4c257a20ace8cb_XZ_2_Vector4[1];
            float _Split_83ec66b648ab6c84848b42686c256cd7_B_3_Float = _PlanarNM_d5657f470f05ef839e4c257a20ace8cb_XZ_2_Vector4[2];
            float _Split_83ec66b648ab6c84848b42686c256cd7_A_4_Float = _PlanarNM_d5657f470f05ef839e4c257a20ace8cb_XZ_2_Vector4[3];
            float _Property_ce1750e5c69e97818667b412fc3f9f2c_Out_0_Float = _HeightMin2;
            float _Property_8e0f2ea54d8ede89bbabdf31a9bafd57_Out_0_Float = _HeightMax2;
            float2 _Vector2_fb6c6dd7e70e768ba686e8e94153bb96_Out_0_Vector2 = float2(_Property_ce1750e5c69e97818667b412fc3f9f2c_Out_0_Float, _Property_8e0f2ea54d8ede89bbabdf31a9bafd57_Out_0_Float);
            float _Property_151ae2702b614585af2000f0a812960f_Out_0_Float = _HeightOffset2;
            float2 _Add_fd1b3d8e24e77087a55888eeb238f1a6_Out_2_Vector2;
            Unity_Add_float2(_Vector2_fb6c6dd7e70e768ba686e8e94153bb96_Out_0_Vector2, (_Property_151ae2702b614585af2000f0a812960f_Out_0_Float.xx), _Add_fd1b3d8e24e77087a55888eeb238f1a6_Out_2_Vector2);
            float _Remap_3d4180c0ab36ba86a5517b2645f0bfa7_Out_3_Float;
            Unity_Remap_float(_Split_83ec66b648ab6c84848b42686c256cd7_B_3_Float, float2 (0, 1), _Add_fd1b3d8e24e77087a55888eeb238f1a6_Out_2_Vector2, _Remap_3d4180c0ab36ba86a5517b2645f0bfa7_Out_3_Float);
            float _Multiply_2cb0e5aa384654828f0453a44884573c_Out_2_Float;
            Unity_Multiply_float_float(_Branch_af0c5e511241ce8eae748ae487df50fa_Out_3_Float, _Remap_3d4180c0ab36ba86a5517b2645f0bfa7_Out_3_Float, _Multiply_2cb0e5aa384654828f0453a44884573c_Out_2_Float);
            float _Multiply_74def30593cbbb8bbed03613a31cb89a_Out_2_Float;
            Unity_Multiply_float_float(_Split_c34b73d933404283983f9c8bdb5365d3_G_2_Float, _Multiply_2cb0e5aa384654828f0453a44884573c_Out_2_Float, _Multiply_74def30593cbbb8bbed03613a31cb89a_Out_2_Float);
            float _Lerp_8692ca93f568998fbc97130b6dbc4556_Out_3_Float;
            Unity_Lerp_float(_Split_c7a719bf7da79a8ea38d7311fd844f92_A_4_Float, _Branch_a7d7aece30fd9b8eb456d191fdd37a06_Out_3_Float, _Multiply_74def30593cbbb8bbed03613a31cb89a_Out_2_Float, _Lerp_8692ca93f568998fbc97130b6dbc4556_Out_3_Float);
            float _Clamp_0c8b7b55b9f82588ab2dcff09ee7a16d_Out_3_Float;
            Unity_Clamp_float(_Lerp_8692ca93f568998fbc97130b6dbc4556_Out_3_Float, float(0), float(1), _Clamp_0c8b7b55b9f82588ab2dcff09ee7a16d_Out_3_Float);
            float _Multiply_6333dc4a6348088bb7281602ce6bff5f_Out_2_Float;
            Unity_Multiply_float_float(_Clamp_0c8b7b55b9f82588ab2dcff09ee7a16d_Out_3_Float, _Split_c34b73d933404283983f9c8bdb5365d3_A_4_Float, _Multiply_6333dc4a6348088bb7281602ce6bff5f_Out_2_Float);
            float _Clamp_9642b8fb7e32b18a91da1888c9bc375b_Out_3_Float;
            Unity_Clamp_float(_Multiply_6333dc4a6348088bb7281602ce6bff5f_Out_2_Float, float(0), float(1), _Clamp_9642b8fb7e32b18a91da1888c9bc375b_Out_3_Float);
            float _Property_8bc98dd454a5508b9864a6ba09772356_Out_0_Float = _AlphaCutoff;
            surface.Alpha = _Clamp_9642b8fb7e32b18a91da1888c9bc375b_Out_3_Float;
            surface.AlphaClipThreshold = _Property_8bc98dd454a5508b9864a6ba09772356_Out_0_Float;
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
        #pragma shader_feature_local _ _USEDYNAMICCOVERTSTATICMASKF_ON
        
        #if defined(_USEDYNAMICCOVERTSTATICMASKF_ON)
            #define KEYWORD_PERMUTATION_0
        #else
            #define KEYWORD_PERMUTATION_1
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
             float4 texCoord0 : INTERP0;
             float4 texCoord3 : INTERP1;
             float4 color : INTERP2;
             float3 positionWS : INTERP3;
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
            output.texCoord0.xyzw = input.texCoord0;
            output.texCoord3.xyzw = input.texCoord3;
            output.color.xyzw = input.color;
            output.positionWS.xyz = input.positionWS;
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
            output.texCoord0 = input.texCoord0.xyzw;
            output.texCoord3 = input.texCoord3.xyzw;
            output.color = input.color.xyzw;
            output.positionWS = input.positionWS.xyz;
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
        float4 _WetColor;
        float _WetSmoothness;
        float _AlphaCutoff;
        float4 _BaseColor;
        float4 _BaseColorMap_TexelSize;
        float _BaseUsePlanarUV;
        float4 _BaseTilingOffset;
        float4 _BaseNormalMap_TexelSize;
        float _BaseNormalScale;
        float4 _BaseMaskMap_TexelSize;
        float _BaseMetallic;
        float _BaseAORemapMin;
        float _BaseAORemapMax;
        float _BaseSmoothnessRemapMin;
        float _BaseSmoothnessRemapMax;
        float4 _LayerMask_TexelSize;
        float _Invert_Layer_Mask;
        float _Height_Transition;
        float _HeightMin;
        float _HeightMax;
        float _HeightOffset;
        float _HeightMin2;
        float _HeightMax2;
        float _HeightOffset2;
        float IgnoreBase2Alpha;
        float4 _Base2Color;
        float4 _Base2ColorMap_TexelSize;
        float4 _Base2TilingOffset;
        float _Base2UsePlanarUV;
        float4 _Base2NormalMap_TexelSize;
        float _Base2NormalScale;
        float4 _Base2MaskMap_TexelSize;
        float _Base2Metallic;
        float _Base2SmoothnessRemapMin;
        float _Base2SmoothnessRemapMax;
        float _Base2AORemapMin;
        float _Base2AORemapMax;
        float _CoverMaskPower;
        float _Cover_Amount;
        float _Cover_Amount_Grow_Speed;
        float _Cover_Max_Angle;
        float _Cover_Min_Height;
        float _Cover_Min_Height_Blending;
        float4 _CoverBaseColor;
        float4 _CoverBaseColorMap_TexelSize;
        float4 _CoverTilingOffset;
        float _CoverUsePlanarUV;
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
        UNITY_TEXTURE_STREAMING_DEBUG_VARS;
        CBUFFER_END
        
        
        // Object and Global properties
        SAMPLER(SamplerState_Linear_Repeat);
        SAMPLER(SamplerState_Linear_Repeat_Aniso8);
        TEXTURE2D(_BaseColorMap);
        SAMPLER(sampler_BaseColorMap);
        TEXTURE2D(_BaseNormalMap);
        SAMPLER(sampler_BaseNormalMap);
        TEXTURE2D(_BaseMaskMap);
        SAMPLER(sampler_BaseMaskMap);
        TEXTURE2D(_LayerMask);
        SAMPLER(sampler_LayerMask);
        TEXTURE2D(_Base2ColorMap);
        SAMPLER(sampler_Base2ColorMap);
        TEXTURE2D(_Base2NormalMap);
        SAMPLER(sampler_Base2NormalMap);
        TEXTURE2D(_Base2MaskMap);
        SAMPLER(sampler_Base2MaskMap);
        TEXTURE2D(_CoverBaseColorMap);
        SAMPLER(sampler_CoverBaseColorMap);
        TEXTURE2D(_CoverNormalMap);
        SAMPLER(sampler_CoverNormalMap);
        TEXTURE2D(_CoverMaskMap);
        SAMPLER(sampler_CoverMaskMap);
        
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
        
        void Unity_Branch_float(float Predicate, float True, float False, out float Out)
        {
            Out = Predicate ? True : False;
        }
        
        void Unity_OneMinus_float(float In, out float Out)
        {
            Out = 1 - In;
        }
        
        void Unity_Add_float2(float2 A, float2 B, out float2 Out)
        {
            Out = A + B;
        }
        
        void Unity_Remap_float(float In, float2 InMinMax, float2 OutMinMax, out float Out)
        {
            Out = OutMinMax.x + (In - InMinMax.x) * (OutMinMax.y - OutMinMax.x) / (InMinMax.y - InMinMax.x);
        }
        
        void Unity_Multiply_float_float(float A, float B, out float Out)
        {
            Out = A * B;
        }
        
        void Unity_Lerp_float(float A, float B, float T, out float Out)
        {
            Out = lerp(A, B, T);
        }
        
        void Unity_Clamp_float(float In, float Min, float Max, out float Out)
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
            UnityTexture2D _Property_07d75b1d2628da808a2efb93a1d6219e_Out_0_Texture2D = UnityBuildTexture2DStructNoScale(_BaseColorMap);
            float4 _Property_587a28253857318a9b2e59bfc8fb56a4_Out_0_Vector4 = _BaseTilingOffset;
            float _Property_7f998178363b4188ba2f07298ef869c1_Out_0_Boolean = _BaseUsePlanarUV;
            Bindings_PlanarNM_c0f081da9c567704ea36e7dd38cedcf6_float _PlanarNM_0b8fbae0d009788d8cd595a3b9bf9f6e;
            _PlanarNM_0b8fbae0d009788d8cd595a3b9bf9f6e.AbsoluteWorldSpacePosition = IN.AbsoluteWorldSpacePosition;
            _PlanarNM_0b8fbae0d009788d8cd595a3b9bf9f6e.uv0 = IN.uv0;
            _PlanarNM_0b8fbae0d009788d8cd595a3b9bf9f6e.uv3 = IN.uv3;
            float4 _PlanarNM_0b8fbae0d009788d8cd595a3b9bf9f6e_XZ_2_Vector4;
            SG_PlanarNM_c0f081da9c567704ea36e7dd38cedcf6_float(_Property_07d75b1d2628da808a2efb93a1d6219e_Out_0_Texture2D, _Property_587a28253857318a9b2e59bfc8fb56a4_Out_0_Vector4, _Property_7f998178363b4188ba2f07298ef869c1_Out_0_Boolean, UnityBuildSamplerStateStruct(SamplerState_Linear_Repeat_Aniso8), 1, _PlanarNM_0b8fbae0d009788d8cd595a3b9bf9f6e, _PlanarNM_0b8fbae0d009788d8cd595a3b9bf9f6e_XZ_2_Vector4);
            float4 _Property_b83097c58639858680bf43881a95b0af_Out_0_Vector4 = _BaseColor;
            float4 _Multiply_f572ff0def2d308e87a64e94a46c0d96_Out_2_Vector4;
            Unity_Multiply_float4_float4(_PlanarNM_0b8fbae0d009788d8cd595a3b9bf9f6e_XZ_2_Vector4, _Property_b83097c58639858680bf43881a95b0af_Out_0_Vector4, _Multiply_f572ff0def2d308e87a64e94a46c0d96_Out_2_Vector4);
            float _Split_c7a719bf7da79a8ea38d7311fd844f92_R_1_Float = _Multiply_f572ff0def2d308e87a64e94a46c0d96_Out_2_Vector4[0];
            float _Split_c7a719bf7da79a8ea38d7311fd844f92_G_2_Float = _Multiply_f572ff0def2d308e87a64e94a46c0d96_Out_2_Vector4[1];
            float _Split_c7a719bf7da79a8ea38d7311fd844f92_B_3_Float = _Multiply_f572ff0def2d308e87a64e94a46c0d96_Out_2_Vector4[2];
            float _Split_c7a719bf7da79a8ea38d7311fd844f92_A_4_Float = _Multiply_f572ff0def2d308e87a64e94a46c0d96_Out_2_Vector4[3];
            float _Property_7c5dae9b46c9e686b49e58fa996a104a_Out_0_Boolean = IgnoreBase2Alpha;
            UnityTexture2D _Property_ba3a5f4cba7d0a8fa288ffc8267d6c0e_Out_0_Texture2D = UnityBuildTexture2DStructNoScale(_Base2ColorMap);
            float4 _Property_86a4657df480d48e8d3ad3b036731380_Out_0_Vector4 = _Base2TilingOffset;
            float _Property_6c5e16c615cab08a97c2a577642b9d83_Out_0_Boolean = _Base2UsePlanarUV;
            Bindings_PlanarNM_c0f081da9c567704ea36e7dd38cedcf6_float _PlanarNM_5aeab444ca6fd78ea56a01215880a5a4;
            _PlanarNM_5aeab444ca6fd78ea56a01215880a5a4.AbsoluteWorldSpacePosition = IN.AbsoluteWorldSpacePosition;
            _PlanarNM_5aeab444ca6fd78ea56a01215880a5a4.uv0 = IN.uv0;
            _PlanarNM_5aeab444ca6fd78ea56a01215880a5a4.uv3 = IN.uv3;
            float4 _PlanarNM_5aeab444ca6fd78ea56a01215880a5a4_XZ_2_Vector4;
            SG_PlanarNM_c0f081da9c567704ea36e7dd38cedcf6_float(_Property_ba3a5f4cba7d0a8fa288ffc8267d6c0e_Out_0_Texture2D, _Property_86a4657df480d48e8d3ad3b036731380_Out_0_Vector4, _Property_6c5e16c615cab08a97c2a577642b9d83_Out_0_Boolean, UnityBuildSamplerStateStruct(SamplerState_Linear_Repeat_Aniso8), 1, _PlanarNM_5aeab444ca6fd78ea56a01215880a5a4, _PlanarNM_5aeab444ca6fd78ea56a01215880a5a4_XZ_2_Vector4);
            float4 _Property_3561b11b899bda8e855826445cf628aa_Out_0_Vector4 = _Base2Color;
            float4 _Multiply_d2ec682582195e84acc4a8510f50f4b0_Out_2_Vector4;
            Unity_Multiply_float4_float4(_PlanarNM_5aeab444ca6fd78ea56a01215880a5a4_XZ_2_Vector4, _Property_3561b11b899bda8e855826445cf628aa_Out_0_Vector4, _Multiply_d2ec682582195e84acc4a8510f50f4b0_Out_2_Vector4);
            float _Split_e9060f5c0433ec889696d3e462f3229b_R_1_Float = _Multiply_d2ec682582195e84acc4a8510f50f4b0_Out_2_Vector4[0];
            float _Split_e9060f5c0433ec889696d3e462f3229b_G_2_Float = _Multiply_d2ec682582195e84acc4a8510f50f4b0_Out_2_Vector4[1];
            float _Split_e9060f5c0433ec889696d3e462f3229b_B_3_Float = _Multiply_d2ec682582195e84acc4a8510f50f4b0_Out_2_Vector4[2];
            float _Split_e9060f5c0433ec889696d3e462f3229b_A_4_Float = _Multiply_d2ec682582195e84acc4a8510f50f4b0_Out_2_Vector4[3];
            float _Branch_a7d7aece30fd9b8eb456d191fdd37a06_Out_3_Float;
            Unity_Branch_float(_Property_7c5dae9b46c9e686b49e58fa996a104a_Out_0_Boolean, _Split_c7a719bf7da79a8ea38d7311fd844f92_A_4_Float, _Split_e9060f5c0433ec889696d3e462f3229b_A_4_Float, _Branch_a7d7aece30fd9b8eb456d191fdd37a06_Out_3_Float);
            float _Split_c34b73d933404283983f9c8bdb5365d3_R_1_Float = IN.VertexColor[0];
            float _Split_c34b73d933404283983f9c8bdb5365d3_G_2_Float = IN.VertexColor[1];
            float _Split_c34b73d933404283983f9c8bdb5365d3_B_3_Float = IN.VertexColor[2];
            float _Split_c34b73d933404283983f9c8bdb5365d3_A_4_Float = IN.VertexColor[3];
            float _Property_df2df7bb5cfc3381beee7ec454da7542_Out_0_Boolean = _Invert_Layer_Mask;
            UnityTexture2D _Property_c7b1e2df9f9b0e8eace9b2274924e69c_Out_0_Texture2D = UnityBuildTexture2DStructNoScale(_LayerMask);
            float4 _SampleTexture2D_175fb18fafc9598382f1f5f7e97bf30a_RGBA_0_Vector4 = SAMPLE_TEXTURE2D(_Property_c7b1e2df9f9b0e8eace9b2274924e69c_Out_0_Texture2D.tex, _Property_c7b1e2df9f9b0e8eace9b2274924e69c_Out_0_Texture2D.samplerstate, _Property_c7b1e2df9f9b0e8eace9b2274924e69c_Out_0_Texture2D.GetTransformedUV(IN.uv0.xy) );
            float _SampleTexture2D_175fb18fafc9598382f1f5f7e97bf30a_R_4_Float = _SampleTexture2D_175fb18fafc9598382f1f5f7e97bf30a_RGBA_0_Vector4.r;
            float _SampleTexture2D_175fb18fafc9598382f1f5f7e97bf30a_G_5_Float = _SampleTexture2D_175fb18fafc9598382f1f5f7e97bf30a_RGBA_0_Vector4.g;
            float _SampleTexture2D_175fb18fafc9598382f1f5f7e97bf30a_B_6_Float = _SampleTexture2D_175fb18fafc9598382f1f5f7e97bf30a_RGBA_0_Vector4.b;
            float _SampleTexture2D_175fb18fafc9598382f1f5f7e97bf30a_A_7_Float = _SampleTexture2D_175fb18fafc9598382f1f5f7e97bf30a_RGBA_0_Vector4.a;
            float _OneMinus_ce5c3c0635d4ac86beb55115d0ebaed7_Out_1_Float;
            Unity_OneMinus_float(_SampleTexture2D_175fb18fafc9598382f1f5f7e97bf30a_R_4_Float, _OneMinus_ce5c3c0635d4ac86beb55115d0ebaed7_Out_1_Float);
            float _Branch_af0c5e511241ce8eae748ae487df50fa_Out_3_Float;
            Unity_Branch_float(_Property_df2df7bb5cfc3381beee7ec454da7542_Out_0_Boolean, _OneMinus_ce5c3c0635d4ac86beb55115d0ebaed7_Out_1_Float, _SampleTexture2D_175fb18fafc9598382f1f5f7e97bf30a_R_4_Float, _Branch_af0c5e511241ce8eae748ae487df50fa_Out_3_Float);
            UnityTexture2D _Property_de4f6eb48a629285a664dad7fb06438f_Out_0_Texture2D = UnityBuildTexture2DStructNoScale(_Base2MaskMap);
            Bindings_PlanarNM_c0f081da9c567704ea36e7dd38cedcf6_float _PlanarNM_d5657f470f05ef839e4c257a20ace8cb;
            _PlanarNM_d5657f470f05ef839e4c257a20ace8cb.AbsoluteWorldSpacePosition = IN.AbsoluteWorldSpacePosition;
            _PlanarNM_d5657f470f05ef839e4c257a20ace8cb.uv0 = IN.uv0;
            _PlanarNM_d5657f470f05ef839e4c257a20ace8cb.uv3 = IN.uv3;
            float4 _PlanarNM_d5657f470f05ef839e4c257a20ace8cb_XZ_2_Vector4;
            SG_PlanarNM_c0f081da9c567704ea36e7dd38cedcf6_float(_Property_de4f6eb48a629285a664dad7fb06438f_Out_0_Texture2D, _Property_86a4657df480d48e8d3ad3b036731380_Out_0_Vector4, _Property_6c5e16c615cab08a97c2a577642b9d83_Out_0_Boolean, UnityBuildSamplerStateStruct(SamplerState_Linear_Repeat_Aniso8), 1, _PlanarNM_d5657f470f05ef839e4c257a20ace8cb, _PlanarNM_d5657f470f05ef839e4c257a20ace8cb_XZ_2_Vector4);
            float _Split_83ec66b648ab6c84848b42686c256cd7_R_1_Float = _PlanarNM_d5657f470f05ef839e4c257a20ace8cb_XZ_2_Vector4[0];
            float _Split_83ec66b648ab6c84848b42686c256cd7_G_2_Float = _PlanarNM_d5657f470f05ef839e4c257a20ace8cb_XZ_2_Vector4[1];
            float _Split_83ec66b648ab6c84848b42686c256cd7_B_3_Float = _PlanarNM_d5657f470f05ef839e4c257a20ace8cb_XZ_2_Vector4[2];
            float _Split_83ec66b648ab6c84848b42686c256cd7_A_4_Float = _PlanarNM_d5657f470f05ef839e4c257a20ace8cb_XZ_2_Vector4[3];
            float _Property_ce1750e5c69e97818667b412fc3f9f2c_Out_0_Float = _HeightMin2;
            float _Property_8e0f2ea54d8ede89bbabdf31a9bafd57_Out_0_Float = _HeightMax2;
            float2 _Vector2_fb6c6dd7e70e768ba686e8e94153bb96_Out_0_Vector2 = float2(_Property_ce1750e5c69e97818667b412fc3f9f2c_Out_0_Float, _Property_8e0f2ea54d8ede89bbabdf31a9bafd57_Out_0_Float);
            float _Property_151ae2702b614585af2000f0a812960f_Out_0_Float = _HeightOffset2;
            float2 _Add_fd1b3d8e24e77087a55888eeb238f1a6_Out_2_Vector2;
            Unity_Add_float2(_Vector2_fb6c6dd7e70e768ba686e8e94153bb96_Out_0_Vector2, (_Property_151ae2702b614585af2000f0a812960f_Out_0_Float.xx), _Add_fd1b3d8e24e77087a55888eeb238f1a6_Out_2_Vector2);
            float _Remap_3d4180c0ab36ba86a5517b2645f0bfa7_Out_3_Float;
            Unity_Remap_float(_Split_83ec66b648ab6c84848b42686c256cd7_B_3_Float, float2 (0, 1), _Add_fd1b3d8e24e77087a55888eeb238f1a6_Out_2_Vector2, _Remap_3d4180c0ab36ba86a5517b2645f0bfa7_Out_3_Float);
            float _Multiply_2cb0e5aa384654828f0453a44884573c_Out_2_Float;
            Unity_Multiply_float_float(_Branch_af0c5e511241ce8eae748ae487df50fa_Out_3_Float, _Remap_3d4180c0ab36ba86a5517b2645f0bfa7_Out_3_Float, _Multiply_2cb0e5aa384654828f0453a44884573c_Out_2_Float);
            float _Multiply_74def30593cbbb8bbed03613a31cb89a_Out_2_Float;
            Unity_Multiply_float_float(_Split_c34b73d933404283983f9c8bdb5365d3_G_2_Float, _Multiply_2cb0e5aa384654828f0453a44884573c_Out_2_Float, _Multiply_74def30593cbbb8bbed03613a31cb89a_Out_2_Float);
            float _Lerp_8692ca93f568998fbc97130b6dbc4556_Out_3_Float;
            Unity_Lerp_float(_Split_c7a719bf7da79a8ea38d7311fd844f92_A_4_Float, _Branch_a7d7aece30fd9b8eb456d191fdd37a06_Out_3_Float, _Multiply_74def30593cbbb8bbed03613a31cb89a_Out_2_Float, _Lerp_8692ca93f568998fbc97130b6dbc4556_Out_3_Float);
            float _Clamp_0c8b7b55b9f82588ab2dcff09ee7a16d_Out_3_Float;
            Unity_Clamp_float(_Lerp_8692ca93f568998fbc97130b6dbc4556_Out_3_Float, float(0), float(1), _Clamp_0c8b7b55b9f82588ab2dcff09ee7a16d_Out_3_Float);
            float _Multiply_6333dc4a6348088bb7281602ce6bff5f_Out_2_Float;
            Unity_Multiply_float_float(_Clamp_0c8b7b55b9f82588ab2dcff09ee7a16d_Out_3_Float, _Split_c34b73d933404283983f9c8bdb5365d3_A_4_Float, _Multiply_6333dc4a6348088bb7281602ce6bff5f_Out_2_Float);
            float _Clamp_9642b8fb7e32b18a91da1888c9bc375b_Out_3_Float;
            Unity_Clamp_float(_Multiply_6333dc4a6348088bb7281602ce6bff5f_Out_2_Float, float(0), float(1), _Clamp_9642b8fb7e32b18a91da1888c9bc375b_Out_3_Float);
            float _Property_8bc98dd454a5508b9864a6ba09772356_Out_0_Float = _AlphaCutoff;
            surface.Alpha = _Clamp_9642b8fb7e32b18a91da1888c9bc375b_Out_3_Float;
            surface.AlphaClipThreshold = _Property_8bc98dd454a5508b9864a6ba09772356_Out_0_Float;
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
        #pragma shader_feature_local _ _USEDYNAMICCOVERTSTATICMASKF_ON
        
        #if defined(_USEDYNAMICCOVERTSTATICMASKF_ON)
            #define KEYWORD_PERMUTATION_0
        #else
            #define KEYWORD_PERMUTATION_1
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
        float4 _WetColor;
        float _WetSmoothness;
        float _AlphaCutoff;
        float4 _BaseColor;
        float4 _BaseColorMap_TexelSize;
        float _BaseUsePlanarUV;
        float4 _BaseTilingOffset;
        float4 _BaseNormalMap_TexelSize;
        float _BaseNormalScale;
        float4 _BaseMaskMap_TexelSize;
        float _BaseMetallic;
        float _BaseAORemapMin;
        float _BaseAORemapMax;
        float _BaseSmoothnessRemapMin;
        float _BaseSmoothnessRemapMax;
        float4 _LayerMask_TexelSize;
        float _Invert_Layer_Mask;
        float _Height_Transition;
        float _HeightMin;
        float _HeightMax;
        float _HeightOffset;
        float _HeightMin2;
        float _HeightMax2;
        float _HeightOffset2;
        float IgnoreBase2Alpha;
        float4 _Base2Color;
        float4 _Base2ColorMap_TexelSize;
        float4 _Base2TilingOffset;
        float _Base2UsePlanarUV;
        float4 _Base2NormalMap_TexelSize;
        float _Base2NormalScale;
        float4 _Base2MaskMap_TexelSize;
        float _Base2Metallic;
        float _Base2SmoothnessRemapMin;
        float _Base2SmoothnessRemapMax;
        float _Base2AORemapMin;
        float _Base2AORemapMax;
        float _CoverMaskPower;
        float _Cover_Amount;
        float _Cover_Amount_Grow_Speed;
        float _Cover_Max_Angle;
        float _Cover_Min_Height;
        float _Cover_Min_Height_Blending;
        float4 _CoverBaseColor;
        float4 _CoverBaseColorMap_TexelSize;
        float4 _CoverTilingOffset;
        float _CoverUsePlanarUV;
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
        UNITY_TEXTURE_STREAMING_DEBUG_VARS;
        CBUFFER_END
        
        
        // Object and Global properties
        SAMPLER(SamplerState_Linear_Repeat);
        SAMPLER(SamplerState_Linear_Repeat_Aniso8);
        TEXTURE2D(_BaseColorMap);
        SAMPLER(sampler_BaseColorMap);
        TEXTURE2D(_BaseNormalMap);
        SAMPLER(sampler_BaseNormalMap);
        TEXTURE2D(_BaseMaskMap);
        SAMPLER(sampler_BaseMaskMap);
        TEXTURE2D(_LayerMask);
        SAMPLER(sampler_LayerMask);
        TEXTURE2D(_Base2ColorMap);
        SAMPLER(sampler_Base2ColorMap);
        TEXTURE2D(_Base2NormalMap);
        SAMPLER(sampler_Base2NormalMap);
        TEXTURE2D(_Base2MaskMap);
        SAMPLER(sampler_Base2MaskMap);
        TEXTURE2D(_CoverBaseColorMap);
        SAMPLER(sampler_CoverBaseColorMap);
        TEXTURE2D(_CoverNormalMap);
        SAMPLER(sampler_CoverNormalMap);
        TEXTURE2D(_CoverMaskMap);
        SAMPLER(sampler_CoverMaskMap);
        
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
        
        void Unity_Sign_float3(float3 In, out float3 Out)
        {
            Out = sign(In);
        }
        
        void Unity_Multiply_float2_float2(float2 A, float2 B, out float2 Out)
        {
        Out = A * B;
        }
        
        void Unity_Add_float2(float2 A, float2 B, out float2 Out)
        {
            Out = A + B;
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
        
        void Unity_OneMinus_float(float In, out float Out)
        {
            Out = 1 - In;
        }
        
        void Unity_Branch_float(float Predicate, float True, float False, out float Out)
        {
            Out = Predicate ? True : False;
        }
        
        void Unity_Maximum_float(float A, float B, out float Out)
        {
            Out = max(A, B);
        }
        
        void Unity_Subtract_float(float A, float B, out float Out)
        {
            Out = A - B;
        }
        
        void Unity_Multiply_float3_float3(float3 A, float3 B, out float3 Out)
        {
        Out = A * B;
        }
        
        void Unity_Add_float3(float3 A, float3 B, out float3 Out)
        {
            Out = A + B;
        }
        
        void Unity_Add_float(float A, float B, out float Out)
        {
            Out = A + B;
        }
        
        void Unity_Divide_float3(float3 A, float3 B, out float3 Out)
        {
            Out = A / B;
        }
        
        struct Bindings_HeightBlend_d15b6fb865d3b6d4ebc1fd476c3ad135_float
        {
        };
        
        void SG_HeightBlend_d15b6fb865d3b6d4ebc1fd476c3ad135_float(float3 Vector3_88EEBB5E, float Vector1_DA0A37FA, float3 Vector3_79AA92F, float Vector1_F7E83F1E, float Vector1_1C9222A6, Bindings_HeightBlend_d15b6fb865d3b6d4ebc1fd476c3ad135_float IN, out float3 OutVector4_1)
        {
        float3 _Property_dd1c841a04c03f8c85e7b00eb025ecda_Out_0_Vector3 = Vector3_88EEBB5E;
        float _Property_14119cc7eaf4128f991283d47cf72d85_Out_0_Float = Vector1_DA0A37FA;
        float _Property_48af0ad45e3f7f82932b938695d21391_Out_0_Float = Vector1_DA0A37FA;
        float _Property_8a30b3ca12ff518fa473ccd686c7d503_Out_0_Float = Vector1_F7E83F1E;
        float _Maximum_c196e4a61637ea8381a3437c93f89ce2_Out_2_Float;
        Unity_Maximum_float(_Property_48af0ad45e3f7f82932b938695d21391_Out_0_Float, _Property_8a30b3ca12ff518fa473ccd686c7d503_Out_0_Float, _Maximum_c196e4a61637ea8381a3437c93f89ce2_Out_2_Float);
        float _Property_ee8d5fc69475d181be60c57e04ea8708_Out_0_Float = Vector1_1C9222A6;
        float _Subtract_61ca880c04c1758eb128f25c9faabd63_Out_2_Float;
        Unity_Subtract_float(_Maximum_c196e4a61637ea8381a3437c93f89ce2_Out_2_Float, _Property_ee8d5fc69475d181be60c57e04ea8708_Out_0_Float, _Subtract_61ca880c04c1758eb128f25c9faabd63_Out_2_Float);
        float _Subtract_e3a7713b556a1b8cb40aad97fc58d619_Out_2_Float;
        Unity_Subtract_float(_Property_14119cc7eaf4128f991283d47cf72d85_Out_0_Float, _Subtract_61ca880c04c1758eb128f25c9faabd63_Out_2_Float, _Subtract_e3a7713b556a1b8cb40aad97fc58d619_Out_2_Float);
        float _Maximum_d02e48d92038448cb0345e5cf3779071_Out_2_Float;
        Unity_Maximum_float(_Subtract_e3a7713b556a1b8cb40aad97fc58d619_Out_2_Float, float(0), _Maximum_d02e48d92038448cb0345e5cf3779071_Out_2_Float);
        float3 _Multiply_79b0b5d7d3528b8395e1135339a090f2_Out_2_Vector3;
        Unity_Multiply_float3_float3(_Property_dd1c841a04c03f8c85e7b00eb025ecda_Out_0_Vector3, (_Maximum_d02e48d92038448cb0345e5cf3779071_Out_2_Float.xxx), _Multiply_79b0b5d7d3528b8395e1135339a090f2_Out_2_Vector3);
        float3 _Property_c7292b3b08585f8c8670172b9a220bf0_Out_0_Vector3 = Vector3_79AA92F;
        float _Property_5e920479576fad83ba1947728dcceab4_Out_0_Float = Vector1_F7E83F1E;
        float _Subtract_b7368f21be9e048aae7f90c8a2bfaae1_Out_2_Float;
        Unity_Subtract_float(_Property_5e920479576fad83ba1947728dcceab4_Out_0_Float, _Subtract_61ca880c04c1758eb128f25c9faabd63_Out_2_Float, _Subtract_b7368f21be9e048aae7f90c8a2bfaae1_Out_2_Float);
        float _Maximum_216777d30802328eab607c8fe68ba3a1_Out_2_Float;
        Unity_Maximum_float(_Subtract_b7368f21be9e048aae7f90c8a2bfaae1_Out_2_Float, float(0), _Maximum_216777d30802328eab607c8fe68ba3a1_Out_2_Float);
        float3 _Multiply_a856b52cd0848f86a6ae1af9b175935c_Out_2_Vector3;
        Unity_Multiply_float3_float3(_Property_c7292b3b08585f8c8670172b9a220bf0_Out_0_Vector3, (_Maximum_216777d30802328eab607c8fe68ba3a1_Out_2_Float.xxx), _Multiply_a856b52cd0848f86a6ae1af9b175935c_Out_2_Vector3);
        float3 _Add_86c6109dc4530b8c9763ef62b056ad4c_Out_2_Vector3;
        Unity_Add_float3(_Multiply_79b0b5d7d3528b8395e1135339a090f2_Out_2_Vector3, _Multiply_a856b52cd0848f86a6ae1af9b175935c_Out_2_Vector3, _Add_86c6109dc4530b8c9763ef62b056ad4c_Out_2_Vector3);
        float _Add_356384b52728f583bd6e694bc1fc3738_Out_2_Float;
        Unity_Add_float(_Maximum_d02e48d92038448cb0345e5cf3779071_Out_2_Float, _Maximum_216777d30802328eab607c8fe68ba3a1_Out_2_Float, _Add_356384b52728f583bd6e694bc1fc3738_Out_2_Float);
        float _Maximum_94a22f5ceb706e88bc16350a5d5d2a82_Out_2_Float;
        Unity_Maximum_float(_Add_356384b52728f583bd6e694bc1fc3738_Out_2_Float, float(1E-05), _Maximum_94a22f5ceb706e88bc16350a5d5d2a82_Out_2_Float);
        float3 _Divide_d7291d1701d7058dbb5263194c1bed22_Out_2_Vector3;
        Unity_Divide_float3(_Add_86c6109dc4530b8c9763ef62b056ad4c_Out_2_Vector3, (_Maximum_94a22f5ceb706e88bc16350a5d5d2a82_Out_2_Float.xxx), _Divide_d7291d1701d7058dbb5263194c1bed22_Out_2_Vector3);
        OutVector4_1 = _Divide_d7291d1701d7058dbb5263194c1bed22_Out_2_Vector3;
        }
        
        void Unity_Clamp_float(float In, float Min, float Max, out float Out)
        {
            Out = clamp(In, Min, Max);
        }
        
        void Unity_Absolute_float(float In, out float Out)
        {
            Out = abs(In);
        }
        
        void Unity_Power_float(float A, float B, out float Out)
        {
            Out = pow(A, B);
        }
        
        void Unity_Saturate_float(float In, out float Out)
        {
            Out = saturate(In);
        }
        
        void Unity_Lerp_float3(float3 A, float3 B, float3 T, out float3 Out)
        {
            Out = lerp(A, B, T);
        }
        
        void Unity_Lerp_float(float A, float B, float T, out float Out)
        {
            Out = lerp(A, B, T);
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
            UnityTexture2D _Property_7c7049e15fdff386b535790d8666f609_Out_0_Texture2D = UnityBuildTexture2DStructNoScale(_BaseNormalMap);
            float4 _Property_587a28253857318a9b2e59bfc8fb56a4_Out_0_Vector4 = _BaseTilingOffset;
            float _Property_7f998178363b4188ba2f07298ef869c1_Out_0_Boolean = _BaseUsePlanarUV;
            Bindings_PlanarNMn_1b93a87456f9d4c419321d0cd92bd6c8_float _PlanarNMn_a3713a9c3874b6838d0eda971b9c62d8;
            _PlanarNMn_a3713a9c3874b6838d0eda971b9c62d8.WorldSpaceNormal = IN.WorldSpaceNormal;
            _PlanarNMn_a3713a9c3874b6838d0eda971b9c62d8.WorldSpaceTangent = IN.WorldSpaceTangent;
            _PlanarNMn_a3713a9c3874b6838d0eda971b9c62d8.WorldSpaceBiTangent = IN.WorldSpaceBiTangent;
            _PlanarNMn_a3713a9c3874b6838d0eda971b9c62d8.AbsoluteWorldSpacePosition = IN.AbsoluteWorldSpacePosition;
            _PlanarNMn_a3713a9c3874b6838d0eda971b9c62d8.uv0 = IN.uv0;
            _PlanarNMn_a3713a9c3874b6838d0eda971b9c62d8.uv3 = IN.uv3;
            float4 _PlanarNMn_a3713a9c3874b6838d0eda971b9c62d8_XZ_2_Vector4;
            SG_PlanarNMn_1b93a87456f9d4c419321d0cd92bd6c8_float(_Property_7c7049e15fdff386b535790d8666f609_Out_0_Texture2D, _Property_587a28253857318a9b2e59bfc8fb56a4_Out_0_Vector4, _Property_7f998178363b4188ba2f07298ef869c1_Out_0_Boolean, UnityBuildSamplerStateStruct(SamplerState_Linear_Repeat_Aniso8), 1, _PlanarNMn_a3713a9c3874b6838d0eda971b9c62d8, _PlanarNMn_a3713a9c3874b6838d0eda971b9c62d8_XZ_2_Vector4);
            float _Property_d4b0759cf4647e81be065ec1465ce2b4_Out_0_Float = _BaseNormalScale;
            float3 _NormalStrength_f66a9108ea294886acc61513b41cc5e4_Out_2_Vector3;
            Unity_NormalStrength_float((_PlanarNMn_a3713a9c3874b6838d0eda971b9c62d8_XZ_2_Vector4.xyz), _Property_d4b0759cf4647e81be065ec1465ce2b4_Out_0_Float, _NormalStrength_f66a9108ea294886acc61513b41cc5e4_Out_2_Vector3);
            UnityTexture2D _Property_1e449ff9f8e8ec828507233e8240eb11_Out_0_Texture2D = UnityBuildTexture2DStructNoScale(_BaseMaskMap);
            Bindings_PlanarNM_c0f081da9c567704ea36e7dd38cedcf6_float _PlanarNM_4245c3b264047180b5c90a697d6cb278;
            _PlanarNM_4245c3b264047180b5c90a697d6cb278.AbsoluteWorldSpacePosition = IN.AbsoluteWorldSpacePosition;
            _PlanarNM_4245c3b264047180b5c90a697d6cb278.uv0 = IN.uv0;
            _PlanarNM_4245c3b264047180b5c90a697d6cb278.uv3 = IN.uv3;
            float4 _PlanarNM_4245c3b264047180b5c90a697d6cb278_XZ_2_Vector4;
            SG_PlanarNM_c0f081da9c567704ea36e7dd38cedcf6_float(_Property_1e449ff9f8e8ec828507233e8240eb11_Out_0_Texture2D, _Property_587a28253857318a9b2e59bfc8fb56a4_Out_0_Vector4, _Property_7f998178363b4188ba2f07298ef869c1_Out_0_Boolean, UnityBuildSamplerStateStruct(SamplerState_Linear_Repeat_Aniso8), 1, _PlanarNM_4245c3b264047180b5c90a697d6cb278, _PlanarNM_4245c3b264047180b5c90a697d6cb278_XZ_2_Vector4);
            float _Split_91a015dea8acd38b904ba0935328a5bc_R_1_Float = _PlanarNM_4245c3b264047180b5c90a697d6cb278_XZ_2_Vector4[0];
            float _Split_91a015dea8acd38b904ba0935328a5bc_G_2_Float = _PlanarNM_4245c3b264047180b5c90a697d6cb278_XZ_2_Vector4[1];
            float _Split_91a015dea8acd38b904ba0935328a5bc_B_3_Float = _PlanarNM_4245c3b264047180b5c90a697d6cb278_XZ_2_Vector4[2];
            float _Split_91a015dea8acd38b904ba0935328a5bc_A_4_Float = _PlanarNM_4245c3b264047180b5c90a697d6cb278_XZ_2_Vector4[3];
            float _Property_fbcff1469ebf488394a8a89ddaf0eb2a_Out_0_Float = _HeightMin;
            float _Property_9df7a44c8225168683743ac60c0c3c34_Out_0_Float = _HeightMax;
            float2 _Vector2_9b1e95888c28bc8893f28c02b87fa448_Out_0_Vector2 = float2(_Property_fbcff1469ebf488394a8a89ddaf0eb2a_Out_0_Float, _Property_9df7a44c8225168683743ac60c0c3c34_Out_0_Float);
            float _Property_29ca14fd0b712983a38d63d2dd326e96_Out_0_Float = _HeightOffset;
            float2 _Add_cb503f8a09720d84bb03cbd89e37b80c_Out_2_Vector2;
            Unity_Add_float2(_Vector2_9b1e95888c28bc8893f28c02b87fa448_Out_0_Vector2, (_Property_29ca14fd0b712983a38d63d2dd326e96_Out_0_Float.xx), _Add_cb503f8a09720d84bb03cbd89e37b80c_Out_2_Vector2);
            float _Remap_18f2e96a438d6584ae2fd56f880de9ee_Out_3_Float;
            Unity_Remap_float(_Split_91a015dea8acd38b904ba0935328a5bc_B_3_Float, float2 (0, 1), _Add_cb503f8a09720d84bb03cbd89e37b80c_Out_2_Vector2, _Remap_18f2e96a438d6584ae2fd56f880de9ee_Out_3_Float);
            UnityTexture2D _Property_fa9f7890b20ad481a92543c04b237bde_Out_0_Texture2D = UnityBuildTexture2DStructNoScale(_Base2NormalMap);
            float4 _Property_86a4657df480d48e8d3ad3b036731380_Out_0_Vector4 = _Base2TilingOffset;
            float _Property_6c5e16c615cab08a97c2a577642b9d83_Out_0_Boolean = _Base2UsePlanarUV;
            Bindings_PlanarNMn_1b93a87456f9d4c419321d0cd92bd6c8_float _PlanarNMn_d7b3ec528088a085a5102e025a1b45cf;
            _PlanarNMn_d7b3ec528088a085a5102e025a1b45cf.WorldSpaceNormal = IN.WorldSpaceNormal;
            _PlanarNMn_d7b3ec528088a085a5102e025a1b45cf.WorldSpaceTangent = IN.WorldSpaceTangent;
            _PlanarNMn_d7b3ec528088a085a5102e025a1b45cf.WorldSpaceBiTangent = IN.WorldSpaceBiTangent;
            _PlanarNMn_d7b3ec528088a085a5102e025a1b45cf.AbsoluteWorldSpacePosition = IN.AbsoluteWorldSpacePosition;
            _PlanarNMn_d7b3ec528088a085a5102e025a1b45cf.uv0 = IN.uv0;
            _PlanarNMn_d7b3ec528088a085a5102e025a1b45cf.uv3 = IN.uv3;
            float4 _PlanarNMn_d7b3ec528088a085a5102e025a1b45cf_XZ_2_Vector4;
            SG_PlanarNMn_1b93a87456f9d4c419321d0cd92bd6c8_float(_Property_fa9f7890b20ad481a92543c04b237bde_Out_0_Texture2D, _Property_86a4657df480d48e8d3ad3b036731380_Out_0_Vector4, _Property_6c5e16c615cab08a97c2a577642b9d83_Out_0_Boolean, UnityBuildSamplerStateStruct(SamplerState_Linear_Repeat_Aniso8), 1, _PlanarNMn_d7b3ec528088a085a5102e025a1b45cf, _PlanarNMn_d7b3ec528088a085a5102e025a1b45cf_XZ_2_Vector4);
            float _Property_8c31443b776727819a663c7ddce79064_Out_0_Float = _Base2NormalScale;
            float3 _NormalStrength_0fb86880ab8e368dac6d01b830e20ed8_Out_2_Vector3;
            Unity_NormalStrength_float((_PlanarNMn_d7b3ec528088a085a5102e025a1b45cf_XZ_2_Vector4.xyz), _Property_8c31443b776727819a663c7ddce79064_Out_0_Float, _NormalStrength_0fb86880ab8e368dac6d01b830e20ed8_Out_2_Vector3);
            float _Split_c34b73d933404283983f9c8bdb5365d3_R_1_Float = IN.VertexColor[0];
            float _Split_c34b73d933404283983f9c8bdb5365d3_G_2_Float = IN.VertexColor[1];
            float _Split_c34b73d933404283983f9c8bdb5365d3_B_3_Float = IN.VertexColor[2];
            float _Split_c34b73d933404283983f9c8bdb5365d3_A_4_Float = IN.VertexColor[3];
            float _Property_df2df7bb5cfc3381beee7ec454da7542_Out_0_Boolean = _Invert_Layer_Mask;
            UnityTexture2D _Property_c7b1e2df9f9b0e8eace9b2274924e69c_Out_0_Texture2D = UnityBuildTexture2DStructNoScale(_LayerMask);
            float4 _SampleTexture2D_175fb18fafc9598382f1f5f7e97bf30a_RGBA_0_Vector4 = SAMPLE_TEXTURE2D(_Property_c7b1e2df9f9b0e8eace9b2274924e69c_Out_0_Texture2D.tex, _Property_c7b1e2df9f9b0e8eace9b2274924e69c_Out_0_Texture2D.samplerstate, _Property_c7b1e2df9f9b0e8eace9b2274924e69c_Out_0_Texture2D.GetTransformedUV(IN.uv0.xy) );
            float _SampleTexture2D_175fb18fafc9598382f1f5f7e97bf30a_R_4_Float = _SampleTexture2D_175fb18fafc9598382f1f5f7e97bf30a_RGBA_0_Vector4.r;
            float _SampleTexture2D_175fb18fafc9598382f1f5f7e97bf30a_G_5_Float = _SampleTexture2D_175fb18fafc9598382f1f5f7e97bf30a_RGBA_0_Vector4.g;
            float _SampleTexture2D_175fb18fafc9598382f1f5f7e97bf30a_B_6_Float = _SampleTexture2D_175fb18fafc9598382f1f5f7e97bf30a_RGBA_0_Vector4.b;
            float _SampleTexture2D_175fb18fafc9598382f1f5f7e97bf30a_A_7_Float = _SampleTexture2D_175fb18fafc9598382f1f5f7e97bf30a_RGBA_0_Vector4.a;
            float _OneMinus_ce5c3c0635d4ac86beb55115d0ebaed7_Out_1_Float;
            Unity_OneMinus_float(_SampleTexture2D_175fb18fafc9598382f1f5f7e97bf30a_R_4_Float, _OneMinus_ce5c3c0635d4ac86beb55115d0ebaed7_Out_1_Float);
            float _Branch_af0c5e511241ce8eae748ae487df50fa_Out_3_Float;
            Unity_Branch_float(_Property_df2df7bb5cfc3381beee7ec454da7542_Out_0_Boolean, _OneMinus_ce5c3c0635d4ac86beb55115d0ebaed7_Out_1_Float, _SampleTexture2D_175fb18fafc9598382f1f5f7e97bf30a_R_4_Float, _Branch_af0c5e511241ce8eae748ae487df50fa_Out_3_Float);
            UnityTexture2D _Property_de4f6eb48a629285a664dad7fb06438f_Out_0_Texture2D = UnityBuildTexture2DStructNoScale(_Base2MaskMap);
            Bindings_PlanarNM_c0f081da9c567704ea36e7dd38cedcf6_float _PlanarNM_d5657f470f05ef839e4c257a20ace8cb;
            _PlanarNM_d5657f470f05ef839e4c257a20ace8cb.AbsoluteWorldSpacePosition = IN.AbsoluteWorldSpacePosition;
            _PlanarNM_d5657f470f05ef839e4c257a20ace8cb.uv0 = IN.uv0;
            _PlanarNM_d5657f470f05ef839e4c257a20ace8cb.uv3 = IN.uv3;
            float4 _PlanarNM_d5657f470f05ef839e4c257a20ace8cb_XZ_2_Vector4;
            SG_PlanarNM_c0f081da9c567704ea36e7dd38cedcf6_float(_Property_de4f6eb48a629285a664dad7fb06438f_Out_0_Texture2D, _Property_86a4657df480d48e8d3ad3b036731380_Out_0_Vector4, _Property_6c5e16c615cab08a97c2a577642b9d83_Out_0_Boolean, UnityBuildSamplerStateStruct(SamplerState_Linear_Repeat_Aniso8), 1, _PlanarNM_d5657f470f05ef839e4c257a20ace8cb, _PlanarNM_d5657f470f05ef839e4c257a20ace8cb_XZ_2_Vector4);
            float _Split_83ec66b648ab6c84848b42686c256cd7_R_1_Float = _PlanarNM_d5657f470f05ef839e4c257a20ace8cb_XZ_2_Vector4[0];
            float _Split_83ec66b648ab6c84848b42686c256cd7_G_2_Float = _PlanarNM_d5657f470f05ef839e4c257a20ace8cb_XZ_2_Vector4[1];
            float _Split_83ec66b648ab6c84848b42686c256cd7_B_3_Float = _PlanarNM_d5657f470f05ef839e4c257a20ace8cb_XZ_2_Vector4[2];
            float _Split_83ec66b648ab6c84848b42686c256cd7_A_4_Float = _PlanarNM_d5657f470f05ef839e4c257a20ace8cb_XZ_2_Vector4[3];
            float _Property_ce1750e5c69e97818667b412fc3f9f2c_Out_0_Float = _HeightMin2;
            float _Property_8e0f2ea54d8ede89bbabdf31a9bafd57_Out_0_Float = _HeightMax2;
            float2 _Vector2_fb6c6dd7e70e768ba686e8e94153bb96_Out_0_Vector2 = float2(_Property_ce1750e5c69e97818667b412fc3f9f2c_Out_0_Float, _Property_8e0f2ea54d8ede89bbabdf31a9bafd57_Out_0_Float);
            float _Property_151ae2702b614585af2000f0a812960f_Out_0_Float = _HeightOffset2;
            float2 _Add_fd1b3d8e24e77087a55888eeb238f1a6_Out_2_Vector2;
            Unity_Add_float2(_Vector2_fb6c6dd7e70e768ba686e8e94153bb96_Out_0_Vector2, (_Property_151ae2702b614585af2000f0a812960f_Out_0_Float.xx), _Add_fd1b3d8e24e77087a55888eeb238f1a6_Out_2_Vector2);
            float _Remap_3d4180c0ab36ba86a5517b2645f0bfa7_Out_3_Float;
            Unity_Remap_float(_Split_83ec66b648ab6c84848b42686c256cd7_B_3_Float, float2 (0, 1), _Add_fd1b3d8e24e77087a55888eeb238f1a6_Out_2_Vector2, _Remap_3d4180c0ab36ba86a5517b2645f0bfa7_Out_3_Float);
            float _Multiply_2cb0e5aa384654828f0453a44884573c_Out_2_Float;
            Unity_Multiply_float_float(_Branch_af0c5e511241ce8eae748ae487df50fa_Out_3_Float, _Remap_3d4180c0ab36ba86a5517b2645f0bfa7_Out_3_Float, _Multiply_2cb0e5aa384654828f0453a44884573c_Out_2_Float);
            float _Multiply_74def30593cbbb8bbed03613a31cb89a_Out_2_Float;
            Unity_Multiply_float_float(_Split_c34b73d933404283983f9c8bdb5365d3_G_2_Float, _Multiply_2cb0e5aa384654828f0453a44884573c_Out_2_Float, _Multiply_74def30593cbbb8bbed03613a31cb89a_Out_2_Float);
            float _Property_818c8af4b930138e81034c886614171d_Out_0_Float = _Height_Transition;
            Bindings_HeightBlend_d15b6fb865d3b6d4ebc1fd476c3ad135_float _HeightBlend_7c09d97625efce898e21b66cd039be8b;
            float3 _HeightBlend_7c09d97625efce898e21b66cd039be8b_OutVector4_1_Vector3;
            SG_HeightBlend_d15b6fb865d3b6d4ebc1fd476c3ad135_float(_NormalStrength_f66a9108ea294886acc61513b41cc5e4_Out_2_Vector3, _Remap_18f2e96a438d6584ae2fd56f880de9ee_Out_3_Float, _NormalStrength_0fb86880ab8e368dac6d01b830e20ed8_Out_2_Vector3, _Multiply_74def30593cbbb8bbed03613a31cb89a_Out_2_Float, _Property_818c8af4b930138e81034c886614171d_Out_0_Float, _HeightBlend_7c09d97625efce898e21b66cd039be8b, _HeightBlend_7c09d97625efce898e21b66cd039be8b_OutVector4_1_Vector3);
            UnityTexture2D _Property_65f7dd6fe6c29b83913af586c597a1ef_Out_0_Texture2D = UnityBuildTexture2DStructNoScale(_CoverNormalMap);
            float4 _Property_822489d2e6d3e08590c64f085ffd9b2e_Out_0_Vector4 = _CoverTilingOffset;
            float _Property_2ae4a163bd21d98789af282d6e469175_Out_0_Boolean = _CoverUsePlanarUV;
            Bindings_PlanarNMn_1b93a87456f9d4c419321d0cd92bd6c8_float _PlanarNMn_248bc5b7421d3f828d166902c73ca6c3;
            _PlanarNMn_248bc5b7421d3f828d166902c73ca6c3.WorldSpaceNormal = IN.WorldSpaceNormal;
            _PlanarNMn_248bc5b7421d3f828d166902c73ca6c3.WorldSpaceTangent = IN.WorldSpaceTangent;
            _PlanarNMn_248bc5b7421d3f828d166902c73ca6c3.WorldSpaceBiTangent = IN.WorldSpaceBiTangent;
            _PlanarNMn_248bc5b7421d3f828d166902c73ca6c3.AbsoluteWorldSpacePosition = IN.AbsoluteWorldSpacePosition;
            _PlanarNMn_248bc5b7421d3f828d166902c73ca6c3.uv0 = IN.uv0;
            _PlanarNMn_248bc5b7421d3f828d166902c73ca6c3.uv3 = IN.uv3;
            float4 _PlanarNMn_248bc5b7421d3f828d166902c73ca6c3_XZ_2_Vector4;
            SG_PlanarNMn_1b93a87456f9d4c419321d0cd92bd6c8_float(_Property_65f7dd6fe6c29b83913af586c597a1ef_Out_0_Texture2D, _Property_822489d2e6d3e08590c64f085ffd9b2e_Out_0_Vector4, _Property_2ae4a163bd21d98789af282d6e469175_Out_0_Boolean, UnityBuildSamplerStateStruct(SamplerState_Linear_Repeat_Aniso8), 1, _PlanarNMn_248bc5b7421d3f828d166902c73ca6c3, _PlanarNMn_248bc5b7421d3f828d166902c73ca6c3_XZ_2_Vector4);
            float _Property_7b9efcab84158389b4a4ea1e24b5601a_Out_0_Float = _CoverNormalScale;
            float3 _NormalStrength_8f42544d1b3ae08092fb1812b8119cfa_Out_2_Vector3;
            Unity_NormalStrength_float((_PlanarNMn_248bc5b7421d3f828d166902c73ca6c3_XZ_2_Vector4.xyz), _Property_7b9efcab84158389b4a4ea1e24b5601a_Out_0_Float, _NormalStrength_8f42544d1b3ae08092fb1812b8119cfa_Out_2_Vector3);
            UnityTexture2D _Property_3b351481f7b944ffaf5f59649df41ba9_Out_0_Texture2D = UnityBuildTexture2DStructNoScale(_CoverBaseColorMap);
            float4 _UV_5352c8dd0add178ba83a5421c2c0b3f0_Out_0_Vector4 = IN.uv0;
            float4 _SampleTexture2D_024ba490c015248988a12a9d670014ea_RGBA_0_Vector4 = SAMPLE_TEXTURE2D(_Property_3b351481f7b944ffaf5f59649df41ba9_Out_0_Texture2D.tex, _Property_3b351481f7b944ffaf5f59649df41ba9_Out_0_Texture2D.samplerstate, _Property_3b351481f7b944ffaf5f59649df41ba9_Out_0_Texture2D.GetTransformedUV((_UV_5352c8dd0add178ba83a5421c2c0b3f0_Out_0_Vector4.xy)) );
            float _SampleTexture2D_024ba490c015248988a12a9d670014ea_R_4_Float = _SampleTexture2D_024ba490c015248988a12a9d670014ea_RGBA_0_Vector4.r;
            float _SampleTexture2D_024ba490c015248988a12a9d670014ea_G_5_Float = _SampleTexture2D_024ba490c015248988a12a9d670014ea_RGBA_0_Vector4.g;
            float _SampleTexture2D_024ba490c015248988a12a9d670014ea_B_6_Float = _SampleTexture2D_024ba490c015248988a12a9d670014ea_RGBA_0_Vector4.b;
            float _SampleTexture2D_024ba490c015248988a12a9d670014ea_A_7_Float = _SampleTexture2D_024ba490c015248988a12a9d670014ea_RGBA_0_Vector4.a;
            float _Property_b80e7b96604b7c82bbf9bff4981fad76_Out_0_Float = _CoverMaskPower;
            float _Multiply_abe410d256783480b1b58468bf78a882_Out_2_Float;
            Unity_Multiply_float_float(_SampleTexture2D_024ba490c015248988a12a9d670014ea_A_7_Float, _Property_b80e7b96604b7c82bbf9bff4981fad76_Out_0_Float, _Multiply_abe410d256783480b1b58468bf78a882_Out_2_Float);
            float _Clamp_a78f6f28770afd869adb9d12cd47370b_Out_3_Float;
            Unity_Clamp_float(_Multiply_abe410d256783480b1b58468bf78a882_Out_2_Float, float(0), float(1), _Clamp_a78f6f28770afd869adb9d12cd47370b_Out_3_Float);
            float _Property_19f92cae42737480a95820c51d4ba124_Out_0_Float = _CoverNormalBlendHardness;
            float3 _NormalStrength_2c3488591b8345869feb25a3dee06c3f_Out_2_Vector3;
            Unity_NormalStrength_float((_PlanarNMn_248bc5b7421d3f828d166902c73ca6c3_XZ_2_Vector4.xyz), _Property_19f92cae42737480a95820c51d4ba124_Out_0_Float, _NormalStrength_2c3488591b8345869feb25a3dee06c3f_Out_2_Vector3);
            float _Split_96bfe9cb80ad308385c191d094b3d071_R_1_Float = IN.WorldSpaceNormal[0];
            float _Split_96bfe9cb80ad308385c191d094b3d071_G_2_Float = IN.WorldSpaceNormal[1];
            float _Split_96bfe9cb80ad308385c191d094b3d071_B_3_Float = IN.WorldSpaceNormal[2];
            float _Split_96bfe9cb80ad308385c191d094b3d071_A_4_Float = 0;
            float _Property_0dd796aae8cd9f878bef13ceac4fe3ec_Out_0_Float = _Cover_Amount;
            float _Property_67285cdc688aa38d83f62d5bb095d597_Out_0_Float = _Cover_Amount_Grow_Speed;
            float _Subtract_fcefec675e7536888eccf5574d921972_Out_2_Float;
            Unity_Subtract_float(float(4), _Property_67285cdc688aa38d83f62d5bb095d597_Out_0_Float, _Subtract_fcefec675e7536888eccf5574d921972_Out_2_Float);
            float _Divide_1e25465528e612839a4ce1faedd89e7d_Out_2_Float;
            Unity_Divide_float(_Property_0dd796aae8cd9f878bef13ceac4fe3ec_Out_0_Float, _Subtract_fcefec675e7536888eccf5574d921972_Out_2_Float, _Divide_1e25465528e612839a4ce1faedd89e7d_Out_2_Float);
            float _Absolute_d20b810ffdec828ab74dd6692d82f01b_Out_1_Float;
            Unity_Absolute_float(_Divide_1e25465528e612839a4ce1faedd89e7d_Out_2_Float, _Absolute_d20b810ffdec828ab74dd6692d82f01b_Out_1_Float);
            float _Power_181fbf47cfdb258da1fe0b72a450986f_Out_2_Float;
            Unity_Power_float(_Absolute_d20b810ffdec828ab74dd6692d82f01b_Out_1_Float, _Subtract_fcefec675e7536888eccf5574d921972_Out_2_Float, _Power_181fbf47cfdb258da1fe0b72a450986f_Out_2_Float);
            float _Clamp_11f62dba01f1a38c9e0a9972ccd19246_Out_3_Float;
            Unity_Clamp_float(_Power_181fbf47cfdb258da1fe0b72a450986f_Out_2_Float, float(0), float(2), _Clamp_11f62dba01f1a38c9e0a9972ccd19246_Out_3_Float);
            float _Multiply_9810f6d76275cd8fbe5e3a02360b98a7_Out_2_Float;
            Unity_Multiply_float_float(_Split_96bfe9cb80ad308385c191d094b3d071_G_2_Float, _Clamp_11f62dba01f1a38c9e0a9972ccd19246_Out_3_Float, _Multiply_9810f6d76275cd8fbe5e3a02360b98a7_Out_2_Float);
            float _Saturate_a007c5f214685c87bf6ca3e64c06b488_Out_1_Float;
            Unity_Saturate_float(_Multiply_9810f6d76275cd8fbe5e3a02360b98a7_Out_2_Float, _Saturate_a007c5f214685c87bf6ca3e64c06b488_Out_1_Float);
            float _Clamp_1b2b25b617fc508b9835f0309136fd00_Out_3_Float;
            Unity_Clamp_float(_Split_96bfe9cb80ad308385c191d094b3d071_G_2_Float, float(0), float(0.9999), _Clamp_1b2b25b617fc508b9835f0309136fd00_Out_3_Float);
            float _Property_7b12276ea7a4538db6804507b30a830c_Out_0_Float = _Cover_Max_Angle;
            float _Divide_54c523ff4b7acb858e9e368fd1e4d34a_Out_2_Float;
            Unity_Divide_float(_Property_7b12276ea7a4538db6804507b30a830c_Out_0_Float, float(45), _Divide_54c523ff4b7acb858e9e368fd1e4d34a_Out_2_Float);
            float _OneMinus_6cf431985b651e8e9546ae6cb2d4d668_Out_1_Float;
            Unity_OneMinus_float(_Divide_54c523ff4b7acb858e9e368fd1e4d34a_Out_2_Float, _OneMinus_6cf431985b651e8e9546ae6cb2d4d668_Out_1_Float);
            float _Subtract_4ef7b60aeab8d589bf2d2423737642bc_Out_2_Float;
            Unity_Subtract_float(_Clamp_1b2b25b617fc508b9835f0309136fd00_Out_3_Float, _OneMinus_6cf431985b651e8e9546ae6cb2d4d668_Out_1_Float, _Subtract_4ef7b60aeab8d589bf2d2423737642bc_Out_2_Float);
            float _Clamp_a4b51894ea17818c9a27bb533a2ebe74_Out_3_Float;
            Unity_Clamp_float(_Subtract_4ef7b60aeab8d589bf2d2423737642bc_Out_2_Float, float(0), float(2), _Clamp_a4b51894ea17818c9a27bb533a2ebe74_Out_3_Float);
            float _Divide_c4196d4f02190b89ba827ccd4ae8a74d_Out_2_Float;
            Unity_Divide_float(float(1), _Divide_54c523ff4b7acb858e9e368fd1e4d34a_Out_2_Float, _Divide_c4196d4f02190b89ba827ccd4ae8a74d_Out_2_Float);
            float _Multiply_ffc22433163d1184846ede424b44bcb2_Out_2_Float;
            Unity_Multiply_float_float(_Clamp_a4b51894ea17818c9a27bb533a2ebe74_Out_3_Float, _Divide_c4196d4f02190b89ba827ccd4ae8a74d_Out_2_Float, _Multiply_ffc22433163d1184846ede424b44bcb2_Out_2_Float);
            float _Absolute_c2e5757082de5d878d4c023806fb2108_Out_1_Float;
            Unity_Absolute_float(_Multiply_ffc22433163d1184846ede424b44bcb2_Out_2_Float, _Absolute_c2e5757082de5d878d4c023806fb2108_Out_1_Float);
            float _Property_849d9f217c95f38c9d49ab251578d8d5_Out_0_Float = _CoverHardness;
            float _Power_578546d66d69a5829b745ebba1279adf_Out_2_Float;
            Unity_Power_float(_Absolute_c2e5757082de5d878d4c023806fb2108_Out_1_Float, _Property_849d9f217c95f38c9d49ab251578d8d5_Out_0_Float, _Power_578546d66d69a5829b745ebba1279adf_Out_2_Float);
            float _Property_34d2d3aff4814e8e83d2894b3512c6c8_Out_0_Float = _Cover_Min_Height;
            float _OneMinus_474df64227f004849b34c68fe8df93f2_Out_1_Float;
            Unity_OneMinus_float(_Property_34d2d3aff4814e8e83d2894b3512c6c8_Out_0_Float, _OneMinus_474df64227f004849b34c68fe8df93f2_Out_1_Float);
            float _Split_ee4d9dc934b3508397d5a3dece110ab0_R_1_Float = IN.AbsoluteWorldSpacePosition[0];
            float _Split_ee4d9dc934b3508397d5a3dece110ab0_G_2_Float = IN.AbsoluteWorldSpacePosition[1];
            float _Split_ee4d9dc934b3508397d5a3dece110ab0_B_3_Float = IN.AbsoluteWorldSpacePosition[2];
            float _Split_ee4d9dc934b3508397d5a3dece110ab0_A_4_Float = 0;
            float _Add_d6bc513aa82d918ea24e279f4353d971_Out_2_Float;
            Unity_Add_float(_OneMinus_474df64227f004849b34c68fe8df93f2_Out_1_Float, _Split_ee4d9dc934b3508397d5a3dece110ab0_G_2_Float, _Add_d6bc513aa82d918ea24e279f4353d971_Out_2_Float);
            float _Add_a6a61cb12180108c9e1364b90d2673e2_Out_2_Float;
            Unity_Add_float(_Add_d6bc513aa82d918ea24e279f4353d971_Out_2_Float, float(1), _Add_a6a61cb12180108c9e1364b90d2673e2_Out_2_Float);
            float _Clamp_1874fdd00cb9aa839d93ab8536e2414d_Out_3_Float;
            Unity_Clamp_float(_Add_a6a61cb12180108c9e1364b90d2673e2_Out_2_Float, float(0), float(1), _Clamp_1874fdd00cb9aa839d93ab8536e2414d_Out_3_Float);
            float _Property_7b91fd6e21b46c85816c7b681307cbe4_Out_0_Float = _Cover_Min_Height_Blending;
            float _Add_6dca9453f6a35e8185c4b8e9782db0a9_Out_2_Float;
            Unity_Add_float(_Add_d6bc513aa82d918ea24e279f4353d971_Out_2_Float, _Property_7b91fd6e21b46c85816c7b681307cbe4_Out_0_Float, _Add_6dca9453f6a35e8185c4b8e9782db0a9_Out_2_Float);
            float _Divide_83415a319ecfba83af914cbc5487b546_Out_2_Float;
            Unity_Divide_float(_Add_6dca9453f6a35e8185c4b8e9782db0a9_Out_2_Float, _Add_d6bc513aa82d918ea24e279f4353d971_Out_2_Float, _Divide_83415a319ecfba83af914cbc5487b546_Out_2_Float);
            float _OneMinus_bf150b22fcad5a87b7c825c9c6cf1687_Out_1_Float;
            Unity_OneMinus_float(_Divide_83415a319ecfba83af914cbc5487b546_Out_2_Float, _OneMinus_bf150b22fcad5a87b7c825c9c6cf1687_Out_1_Float);
            float _Add_86ff9fa850efbe8c80705d8266609dab_Out_2_Float;
            Unity_Add_float(_OneMinus_bf150b22fcad5a87b7c825c9c6cf1687_Out_1_Float, float(-0.5), _Add_86ff9fa850efbe8c80705d8266609dab_Out_2_Float);
            float _Clamp_906e140f01222d8ba61252ec6ec9d6a4_Out_3_Float;
            Unity_Clamp_float(_Add_86ff9fa850efbe8c80705d8266609dab_Out_2_Float, float(0), float(1), _Clamp_906e140f01222d8ba61252ec6ec9d6a4_Out_3_Float);
            float _Add_c1ec5849bf72f585a30b3e11a91ada52_Out_2_Float;
            Unity_Add_float(_Clamp_1874fdd00cb9aa839d93ab8536e2414d_Out_3_Float, _Clamp_906e140f01222d8ba61252ec6ec9d6a4_Out_3_Float, _Add_c1ec5849bf72f585a30b3e11a91ada52_Out_2_Float);
            float _Clamp_17a8a0cf209a038b9e9c7f5681cdd1fb_Out_3_Float;
            Unity_Clamp_float(_Add_c1ec5849bf72f585a30b3e11a91ada52_Out_2_Float, float(0), float(1), _Clamp_17a8a0cf209a038b9e9c7f5681cdd1fb_Out_3_Float);
            float _Multiply_8c2759ac24a9b289b1e9610cfd161bb0_Out_2_Float;
            Unity_Multiply_float_float(_Power_578546d66d69a5829b745ebba1279adf_Out_2_Float, _Clamp_17a8a0cf209a038b9e9c7f5681cdd1fb_Out_3_Float, _Multiply_8c2759ac24a9b289b1e9610cfd161bb0_Out_2_Float);
            float _Multiply_1a723f136ec7fa8c957b5d29e03d3051_Out_2_Float;
            Unity_Multiply_float_float(_Saturate_a007c5f214685c87bf6ca3e64c06b488_Out_1_Float, _Multiply_8c2759ac24a9b289b1e9610cfd161bb0_Out_2_Float, _Multiply_1a723f136ec7fa8c957b5d29e03d3051_Out_2_Float);
            float3 _Lerp_d1c72e47b283948584479177786ae8d5_Out_3_Vector3;
            Unity_Lerp_float3(_HeightBlend_7c09d97625efce898e21b66cd039be8b_OutVector4_1_Vector3, _NormalStrength_2c3488591b8345869feb25a3dee06c3f_Out_2_Vector3, (_Multiply_1a723f136ec7fa8c957b5d29e03d3051_Out_2_Float.xxx), _Lerp_d1c72e47b283948584479177786ae8d5_Out_3_Vector3);
            float3 _Transform_180fb403b53f318db002e8eba7616644_Out_1_Vector3;
            {
                float3x3 tangentTransform = float3x3(IN.WorldSpaceTangent, IN.WorldSpaceBiTangent, IN.WorldSpaceNormal);
                _Transform_180fb403b53f318db002e8eba7616644_Out_1_Vector3 = TransformTangentToWorldDir(_Lerp_d1c72e47b283948584479177786ae8d5_Out_3_Vector3.xyz, tangentTransform, true).xyz;
            }
            float _Split_c9a2b4fb4f688b8ebfc1436535cd5ba4_R_1_Float = _Transform_180fb403b53f318db002e8eba7616644_Out_1_Vector3[0];
            float _Split_c9a2b4fb4f688b8ebfc1436535cd5ba4_G_2_Float = _Transform_180fb403b53f318db002e8eba7616644_Out_1_Vector3[1];
            float _Split_c9a2b4fb4f688b8ebfc1436535cd5ba4_B_3_Float = _Transform_180fb403b53f318db002e8eba7616644_Out_1_Vector3[2];
            float _Split_c9a2b4fb4f688b8ebfc1436535cd5ba4_A_4_Float = 0;
            float _Multiply_4c7631d0688102819e6d388d624855a1_Out_2_Float;
            Unity_Multiply_float_float(_Split_c9a2b4fb4f688b8ebfc1436535cd5ba4_G_2_Float, _Clamp_11f62dba01f1a38c9e0a9972ccd19246_Out_3_Float, _Multiply_4c7631d0688102819e6d388d624855a1_Out_2_Float);
            float _Multiply_f2887eb409f6bb81ae4caad2b01b17f1_Out_2_Float;
            Unity_Multiply_float_float(_Clamp_11f62dba01f1a38c9e0a9972ccd19246_Out_3_Float, _Property_849d9f217c95f38c9d49ab251578d8d5_Out_0_Float, _Multiply_f2887eb409f6bb81ae4caad2b01b17f1_Out_2_Float);
            float _Multiply_2e348ed31331e78791b2b3130a009f30_Out_2_Float;
            Unity_Multiply_float_float(_Multiply_f2887eb409f6bb81ae4caad2b01b17f1_Out_2_Float, _Multiply_8c2759ac24a9b289b1e9610cfd161bb0_Out_2_Float, _Multiply_2e348ed31331e78791b2b3130a009f30_Out_2_Float);
            float _Multiply_622e54e9a77b08839c0954ce5715ad1c_Out_2_Float;
            Unity_Multiply_float_float(_Multiply_4c7631d0688102819e6d388d624855a1_Out_2_Float, _Multiply_2e348ed31331e78791b2b3130a009f30_Out_2_Float, _Multiply_622e54e9a77b08839c0954ce5715ad1c_Out_2_Float);
            UnityTexture2D _Property_608db04fab7d768d9a8b5fb9cf0768e1_Out_0_Texture2D = UnityBuildTexture2DStructNoScale(_CoverMaskMap);
            Bindings_PlanarNM_c0f081da9c567704ea36e7dd38cedcf6_float _PlanarNM_819c993d9b62a28ea640d2bacdc62c6e;
            _PlanarNM_819c993d9b62a28ea640d2bacdc62c6e.AbsoluteWorldSpacePosition = IN.AbsoluteWorldSpacePosition;
            _PlanarNM_819c993d9b62a28ea640d2bacdc62c6e.uv0 = IN.uv0;
            _PlanarNM_819c993d9b62a28ea640d2bacdc62c6e.uv3 = IN.uv3;
            float4 _PlanarNM_819c993d9b62a28ea640d2bacdc62c6e_XZ_2_Vector4;
            SG_PlanarNM_c0f081da9c567704ea36e7dd38cedcf6_float(_Property_608db04fab7d768d9a8b5fb9cf0768e1_Out_0_Texture2D, _Property_822489d2e6d3e08590c64f085ffd9b2e_Out_0_Vector4, _Property_2ae4a163bd21d98789af282d6e469175_Out_0_Boolean, UnityBuildSamplerStateStruct(SamplerState_Linear_Repeat_Aniso8), 1, _PlanarNM_819c993d9b62a28ea640d2bacdc62c6e, _PlanarNM_819c993d9b62a28ea640d2bacdc62c6e_XZ_2_Vector4);
            float _Split_86ec1aefda4f9e8e82b79c6195b397b0_R_1_Float = _PlanarNM_819c993d9b62a28ea640d2bacdc62c6e_XZ_2_Vector4[0];
            float _Split_86ec1aefda4f9e8e82b79c6195b397b0_G_2_Float = _PlanarNM_819c993d9b62a28ea640d2bacdc62c6e_XZ_2_Vector4[1];
            float _Split_86ec1aefda4f9e8e82b79c6195b397b0_B_3_Float = _PlanarNM_819c993d9b62a28ea640d2bacdc62c6e_XZ_2_Vector4[2];
            float _Split_86ec1aefda4f9e8e82b79c6195b397b0_A_4_Float = _PlanarNM_819c993d9b62a28ea640d2bacdc62c6e_XZ_2_Vector4[3];
            float _Property_c9c6897e00458b8f8aa07df49fa519bc_Out_0_Float = _CoverHeightMapMin;
            float _Property_ab94650b8edd82828661fe99e3c0e849_Out_0_Float = _CoverHeightMapMax;
            float2 _Vector2_fe489f7321f6568686816b9eecbc16d1_Out_0_Vector2 = float2(_Property_c9c6897e00458b8f8aa07df49fa519bc_Out_0_Float, _Property_ab94650b8edd82828661fe99e3c0e849_Out_0_Float);
            float _Property_c1ab40024cb83b87960e4327efbd997f_Out_0_Float = _CoverHeightMapOffset;
            float2 _Add_4a359522fc231c83b55ef23f341b6fb3_Out_2_Vector2;
            Unity_Add_float2(_Vector2_fe489f7321f6568686816b9eecbc16d1_Out_0_Vector2, (_Property_c1ab40024cb83b87960e4327efbd997f_Out_0_Float.xx), _Add_4a359522fc231c83b55ef23f341b6fb3_Out_2_Vector2);
            float _Remap_5aee5b64d41562858dc7c42d8b748894_Out_3_Float;
            Unity_Remap_float(_Split_86ec1aefda4f9e8e82b79c6195b397b0_B_3_Float, float2 (0, 1), _Add_4a359522fc231c83b55ef23f341b6fb3_Out_2_Vector2, _Remap_5aee5b64d41562858dc7c42d8b748894_Out_3_Float);
            float _Multiply_f0228e1cfd9c858dbb36367f551733c4_Out_2_Float;
            Unity_Multiply_float_float(_Multiply_622e54e9a77b08839c0954ce5715ad1c_Out_2_Float, _Remap_5aee5b64d41562858dc7c42d8b748894_Out_3_Float, _Multiply_f0228e1cfd9c858dbb36367f551733c4_Out_2_Float);
            float _Multiply_bb4d60728db93b8a9af9635fa1d69891_Out_2_Float;
            Unity_Multiply_float_float(_Split_c34b73d933404283983f9c8bdb5365d3_B_3_Float, _Multiply_f0228e1cfd9c858dbb36367f551733c4_Out_2_Float, _Multiply_bb4d60728db93b8a9af9635fa1d69891_Out_2_Float);
            float _Saturate_9b052a9bb99eff89bb11bdc387a0c2fd_Out_1_Float;
            Unity_Saturate_float(_Multiply_bb4d60728db93b8a9af9635fa1d69891_Out_2_Float, _Saturate_9b052a9bb99eff89bb11bdc387a0c2fd_Out_1_Float);
            float _Multiply_22fb8c1cfd28b687a991e101aa13ff5b_Out_2_Float;
            Unity_Multiply_float_float(_Clamp_a78f6f28770afd869adb9d12cd47370b_Out_3_Float, _Saturate_9b052a9bb99eff89bb11bdc387a0c2fd_Out_1_Float, _Multiply_22fb8c1cfd28b687a991e101aa13ff5b_Out_2_Float);
            #if defined(_USEDYNAMICCOVERTSTATICMASKF_ON)
            float _UseDynamicCoverTStaticMaskF_20dcbac2f16cf78ebd6fd1debcd7f281_Out_0_Float = _Multiply_22fb8c1cfd28b687a991e101aa13ff5b_Out_2_Float;
            #else
            float _UseDynamicCoverTStaticMaskF_20dcbac2f16cf78ebd6fd1debcd7f281_Out_0_Float = _Clamp_a78f6f28770afd869adb9d12cd47370b_Out_3_Float;
            #endif
            float3 _Lerp_18ca18da5861e688a3fb637172636eda_Out_3_Vector3;
            Unity_Lerp_float3(_HeightBlend_7c09d97625efce898e21b66cd039be8b_OutVector4_1_Vector3, _NormalStrength_8f42544d1b3ae08092fb1812b8119cfa_Out_2_Vector3, (_UseDynamicCoverTStaticMaskF_20dcbac2f16cf78ebd6fd1debcd7f281_Out_0_Float.xxx), _Lerp_18ca18da5861e688a3fb637172636eda_Out_3_Vector3);
            UnityTexture2D _Property_07d75b1d2628da808a2efb93a1d6219e_Out_0_Texture2D = UnityBuildTexture2DStructNoScale(_BaseColorMap);
            Bindings_PlanarNM_c0f081da9c567704ea36e7dd38cedcf6_float _PlanarNM_0b8fbae0d009788d8cd595a3b9bf9f6e;
            _PlanarNM_0b8fbae0d009788d8cd595a3b9bf9f6e.AbsoluteWorldSpacePosition = IN.AbsoluteWorldSpacePosition;
            _PlanarNM_0b8fbae0d009788d8cd595a3b9bf9f6e.uv0 = IN.uv0;
            _PlanarNM_0b8fbae0d009788d8cd595a3b9bf9f6e.uv3 = IN.uv3;
            float4 _PlanarNM_0b8fbae0d009788d8cd595a3b9bf9f6e_XZ_2_Vector4;
            SG_PlanarNM_c0f081da9c567704ea36e7dd38cedcf6_float(_Property_07d75b1d2628da808a2efb93a1d6219e_Out_0_Texture2D, _Property_587a28253857318a9b2e59bfc8fb56a4_Out_0_Vector4, _Property_7f998178363b4188ba2f07298ef869c1_Out_0_Boolean, UnityBuildSamplerStateStruct(SamplerState_Linear_Repeat_Aniso8), 1, _PlanarNM_0b8fbae0d009788d8cd595a3b9bf9f6e, _PlanarNM_0b8fbae0d009788d8cd595a3b9bf9f6e_XZ_2_Vector4);
            float4 _Property_b83097c58639858680bf43881a95b0af_Out_0_Vector4 = _BaseColor;
            float4 _Multiply_f572ff0def2d308e87a64e94a46c0d96_Out_2_Vector4;
            Unity_Multiply_float4_float4(_PlanarNM_0b8fbae0d009788d8cd595a3b9bf9f6e_XZ_2_Vector4, _Property_b83097c58639858680bf43881a95b0af_Out_0_Vector4, _Multiply_f572ff0def2d308e87a64e94a46c0d96_Out_2_Vector4);
            float _Split_c7a719bf7da79a8ea38d7311fd844f92_R_1_Float = _Multiply_f572ff0def2d308e87a64e94a46c0d96_Out_2_Vector4[0];
            float _Split_c7a719bf7da79a8ea38d7311fd844f92_G_2_Float = _Multiply_f572ff0def2d308e87a64e94a46c0d96_Out_2_Vector4[1];
            float _Split_c7a719bf7da79a8ea38d7311fd844f92_B_3_Float = _Multiply_f572ff0def2d308e87a64e94a46c0d96_Out_2_Vector4[2];
            float _Split_c7a719bf7da79a8ea38d7311fd844f92_A_4_Float = _Multiply_f572ff0def2d308e87a64e94a46c0d96_Out_2_Vector4[3];
            float _Property_7c5dae9b46c9e686b49e58fa996a104a_Out_0_Boolean = IgnoreBase2Alpha;
            UnityTexture2D _Property_ba3a5f4cba7d0a8fa288ffc8267d6c0e_Out_0_Texture2D = UnityBuildTexture2DStructNoScale(_Base2ColorMap);
            Bindings_PlanarNM_c0f081da9c567704ea36e7dd38cedcf6_float _PlanarNM_5aeab444ca6fd78ea56a01215880a5a4;
            _PlanarNM_5aeab444ca6fd78ea56a01215880a5a4.AbsoluteWorldSpacePosition = IN.AbsoluteWorldSpacePosition;
            _PlanarNM_5aeab444ca6fd78ea56a01215880a5a4.uv0 = IN.uv0;
            _PlanarNM_5aeab444ca6fd78ea56a01215880a5a4.uv3 = IN.uv3;
            float4 _PlanarNM_5aeab444ca6fd78ea56a01215880a5a4_XZ_2_Vector4;
            SG_PlanarNM_c0f081da9c567704ea36e7dd38cedcf6_float(_Property_ba3a5f4cba7d0a8fa288ffc8267d6c0e_Out_0_Texture2D, _Property_86a4657df480d48e8d3ad3b036731380_Out_0_Vector4, _Property_6c5e16c615cab08a97c2a577642b9d83_Out_0_Boolean, UnityBuildSamplerStateStruct(SamplerState_Linear_Repeat_Aniso8), 1, _PlanarNM_5aeab444ca6fd78ea56a01215880a5a4, _PlanarNM_5aeab444ca6fd78ea56a01215880a5a4_XZ_2_Vector4);
            float4 _Property_3561b11b899bda8e855826445cf628aa_Out_0_Vector4 = _Base2Color;
            float4 _Multiply_d2ec682582195e84acc4a8510f50f4b0_Out_2_Vector4;
            Unity_Multiply_float4_float4(_PlanarNM_5aeab444ca6fd78ea56a01215880a5a4_XZ_2_Vector4, _Property_3561b11b899bda8e855826445cf628aa_Out_0_Vector4, _Multiply_d2ec682582195e84acc4a8510f50f4b0_Out_2_Vector4);
            float _Split_e9060f5c0433ec889696d3e462f3229b_R_1_Float = _Multiply_d2ec682582195e84acc4a8510f50f4b0_Out_2_Vector4[0];
            float _Split_e9060f5c0433ec889696d3e462f3229b_G_2_Float = _Multiply_d2ec682582195e84acc4a8510f50f4b0_Out_2_Vector4[1];
            float _Split_e9060f5c0433ec889696d3e462f3229b_B_3_Float = _Multiply_d2ec682582195e84acc4a8510f50f4b0_Out_2_Vector4[2];
            float _Split_e9060f5c0433ec889696d3e462f3229b_A_4_Float = _Multiply_d2ec682582195e84acc4a8510f50f4b0_Out_2_Vector4[3];
            float _Branch_a7d7aece30fd9b8eb456d191fdd37a06_Out_3_Float;
            Unity_Branch_float(_Property_7c5dae9b46c9e686b49e58fa996a104a_Out_0_Boolean, _Split_c7a719bf7da79a8ea38d7311fd844f92_A_4_Float, _Split_e9060f5c0433ec889696d3e462f3229b_A_4_Float, _Branch_a7d7aece30fd9b8eb456d191fdd37a06_Out_3_Float);
            float _Lerp_8692ca93f568998fbc97130b6dbc4556_Out_3_Float;
            Unity_Lerp_float(_Split_c7a719bf7da79a8ea38d7311fd844f92_A_4_Float, _Branch_a7d7aece30fd9b8eb456d191fdd37a06_Out_3_Float, _Multiply_74def30593cbbb8bbed03613a31cb89a_Out_2_Float, _Lerp_8692ca93f568998fbc97130b6dbc4556_Out_3_Float);
            float _Clamp_0c8b7b55b9f82588ab2dcff09ee7a16d_Out_3_Float;
            Unity_Clamp_float(_Lerp_8692ca93f568998fbc97130b6dbc4556_Out_3_Float, float(0), float(1), _Clamp_0c8b7b55b9f82588ab2dcff09ee7a16d_Out_3_Float);
            float _Multiply_6333dc4a6348088bb7281602ce6bff5f_Out_2_Float;
            Unity_Multiply_float_float(_Clamp_0c8b7b55b9f82588ab2dcff09ee7a16d_Out_3_Float, _Split_c34b73d933404283983f9c8bdb5365d3_A_4_Float, _Multiply_6333dc4a6348088bb7281602ce6bff5f_Out_2_Float);
            float _Clamp_9642b8fb7e32b18a91da1888c9bc375b_Out_3_Float;
            Unity_Clamp_float(_Multiply_6333dc4a6348088bb7281602ce6bff5f_Out_2_Float, float(0), float(1), _Clamp_9642b8fb7e32b18a91da1888c9bc375b_Out_3_Float);
            float _Property_8bc98dd454a5508b9864a6ba09772356_Out_0_Float = _AlphaCutoff;
            surface.NormalTS = _Lerp_18ca18da5861e688a3fb637172636eda_Out_3_Vector3;
            surface.Alpha = _Clamp_9642b8fb7e32b18a91da1888c9bc375b_Out_3_Float;
            surface.AlphaClipThreshold = _Property_8bc98dd454a5508b9864a6ba09772356_Out_0_Float;
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
        #pragma shader_feature_local _ _USEDYNAMICCOVERTSTATICMASKF_ON
        
        #if defined(_USEDYNAMICCOVERTSTATICMASKF_ON)
            #define KEYWORD_PERMUTATION_0
        #else
            #define KEYWORD_PERMUTATION_1
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
        float4 _WetColor;
        float _WetSmoothness;
        float _AlphaCutoff;
        float4 _BaseColor;
        float4 _BaseColorMap_TexelSize;
        float _BaseUsePlanarUV;
        float4 _BaseTilingOffset;
        float4 _BaseNormalMap_TexelSize;
        float _BaseNormalScale;
        float4 _BaseMaskMap_TexelSize;
        float _BaseMetallic;
        float _BaseAORemapMin;
        float _BaseAORemapMax;
        float _BaseSmoothnessRemapMin;
        float _BaseSmoothnessRemapMax;
        float4 _LayerMask_TexelSize;
        float _Invert_Layer_Mask;
        float _Height_Transition;
        float _HeightMin;
        float _HeightMax;
        float _HeightOffset;
        float _HeightMin2;
        float _HeightMax2;
        float _HeightOffset2;
        float IgnoreBase2Alpha;
        float4 _Base2Color;
        float4 _Base2ColorMap_TexelSize;
        float4 _Base2TilingOffset;
        float _Base2UsePlanarUV;
        float4 _Base2NormalMap_TexelSize;
        float _Base2NormalScale;
        float4 _Base2MaskMap_TexelSize;
        float _Base2Metallic;
        float _Base2SmoothnessRemapMin;
        float _Base2SmoothnessRemapMax;
        float _Base2AORemapMin;
        float _Base2AORemapMax;
        float _CoverMaskPower;
        float _Cover_Amount;
        float _Cover_Amount_Grow_Speed;
        float _Cover_Max_Angle;
        float _Cover_Min_Height;
        float _Cover_Min_Height_Blending;
        float4 _CoverBaseColor;
        float4 _CoverBaseColorMap_TexelSize;
        float4 _CoverTilingOffset;
        float _CoverUsePlanarUV;
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
        UNITY_TEXTURE_STREAMING_DEBUG_VARS;
        CBUFFER_END
        
        
        // Object and Global properties
        SAMPLER(SamplerState_Linear_Repeat);
        SAMPLER(SamplerState_Linear_Repeat_Aniso8);
        TEXTURE2D(_BaseColorMap);
        SAMPLER(sampler_BaseColorMap);
        TEXTURE2D(_BaseNormalMap);
        SAMPLER(sampler_BaseNormalMap);
        TEXTURE2D(_BaseMaskMap);
        SAMPLER(sampler_BaseMaskMap);
        TEXTURE2D(_LayerMask);
        SAMPLER(sampler_LayerMask);
        TEXTURE2D(_Base2ColorMap);
        SAMPLER(sampler_Base2ColorMap);
        TEXTURE2D(_Base2NormalMap);
        SAMPLER(sampler_Base2NormalMap);
        TEXTURE2D(_Base2MaskMap);
        SAMPLER(sampler_Base2MaskMap);
        TEXTURE2D(_CoverBaseColorMap);
        SAMPLER(sampler_CoverBaseColorMap);
        TEXTURE2D(_CoverNormalMap);
        SAMPLER(sampler_CoverNormalMap);
        TEXTURE2D(_CoverMaskMap);
        SAMPLER(sampler_CoverMaskMap);
        
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
        
        void Unity_Add_float2(float2 A, float2 B, out float2 Out)
        {
            Out = A + B;
        }
        
        void Unity_Remap_float(float In, float2 InMinMax, float2 OutMinMax, out float Out)
        {
            Out = OutMinMax.x + (In - InMinMax.x) * (OutMinMax.y - OutMinMax.x) / (InMinMax.y - InMinMax.x);
        }
        
        void Unity_OneMinus_float(float In, out float Out)
        {
            Out = 1 - In;
        }
        
        void Unity_Branch_float(float Predicate, float True, float False, out float Out)
        {
            Out = Predicate ? True : False;
        }
        
        void Unity_Multiply_float_float(float A, float B, out float Out)
        {
            Out = A * B;
        }
        
        void Unity_Maximum_float(float A, float B, out float Out)
        {
            Out = max(A, B);
        }
        
        void Unity_Subtract_float(float A, float B, out float Out)
        {
            Out = A - B;
        }
        
        void Unity_Multiply_float3_float3(float3 A, float3 B, out float3 Out)
        {
        Out = A * B;
        }
        
        void Unity_Add_float3(float3 A, float3 B, out float3 Out)
        {
            Out = A + B;
        }
        
        void Unity_Add_float(float A, float B, out float Out)
        {
            Out = A + B;
        }
        
        void Unity_Divide_float3(float3 A, float3 B, out float3 Out)
        {
            Out = A / B;
        }
        
        struct Bindings_HeightBlend_d15b6fb865d3b6d4ebc1fd476c3ad135_float
        {
        };
        
        void SG_HeightBlend_d15b6fb865d3b6d4ebc1fd476c3ad135_float(float3 Vector3_88EEBB5E, float Vector1_DA0A37FA, float3 Vector3_79AA92F, float Vector1_F7E83F1E, float Vector1_1C9222A6, Bindings_HeightBlend_d15b6fb865d3b6d4ebc1fd476c3ad135_float IN, out float3 OutVector4_1)
        {
        float3 _Property_dd1c841a04c03f8c85e7b00eb025ecda_Out_0_Vector3 = Vector3_88EEBB5E;
        float _Property_14119cc7eaf4128f991283d47cf72d85_Out_0_Float = Vector1_DA0A37FA;
        float _Property_48af0ad45e3f7f82932b938695d21391_Out_0_Float = Vector1_DA0A37FA;
        float _Property_8a30b3ca12ff518fa473ccd686c7d503_Out_0_Float = Vector1_F7E83F1E;
        float _Maximum_c196e4a61637ea8381a3437c93f89ce2_Out_2_Float;
        Unity_Maximum_float(_Property_48af0ad45e3f7f82932b938695d21391_Out_0_Float, _Property_8a30b3ca12ff518fa473ccd686c7d503_Out_0_Float, _Maximum_c196e4a61637ea8381a3437c93f89ce2_Out_2_Float);
        float _Property_ee8d5fc69475d181be60c57e04ea8708_Out_0_Float = Vector1_1C9222A6;
        float _Subtract_61ca880c04c1758eb128f25c9faabd63_Out_2_Float;
        Unity_Subtract_float(_Maximum_c196e4a61637ea8381a3437c93f89ce2_Out_2_Float, _Property_ee8d5fc69475d181be60c57e04ea8708_Out_0_Float, _Subtract_61ca880c04c1758eb128f25c9faabd63_Out_2_Float);
        float _Subtract_e3a7713b556a1b8cb40aad97fc58d619_Out_2_Float;
        Unity_Subtract_float(_Property_14119cc7eaf4128f991283d47cf72d85_Out_0_Float, _Subtract_61ca880c04c1758eb128f25c9faabd63_Out_2_Float, _Subtract_e3a7713b556a1b8cb40aad97fc58d619_Out_2_Float);
        float _Maximum_d02e48d92038448cb0345e5cf3779071_Out_2_Float;
        Unity_Maximum_float(_Subtract_e3a7713b556a1b8cb40aad97fc58d619_Out_2_Float, float(0), _Maximum_d02e48d92038448cb0345e5cf3779071_Out_2_Float);
        float3 _Multiply_79b0b5d7d3528b8395e1135339a090f2_Out_2_Vector3;
        Unity_Multiply_float3_float3(_Property_dd1c841a04c03f8c85e7b00eb025ecda_Out_0_Vector3, (_Maximum_d02e48d92038448cb0345e5cf3779071_Out_2_Float.xxx), _Multiply_79b0b5d7d3528b8395e1135339a090f2_Out_2_Vector3);
        float3 _Property_c7292b3b08585f8c8670172b9a220bf0_Out_0_Vector3 = Vector3_79AA92F;
        float _Property_5e920479576fad83ba1947728dcceab4_Out_0_Float = Vector1_F7E83F1E;
        float _Subtract_b7368f21be9e048aae7f90c8a2bfaae1_Out_2_Float;
        Unity_Subtract_float(_Property_5e920479576fad83ba1947728dcceab4_Out_0_Float, _Subtract_61ca880c04c1758eb128f25c9faabd63_Out_2_Float, _Subtract_b7368f21be9e048aae7f90c8a2bfaae1_Out_2_Float);
        float _Maximum_216777d30802328eab607c8fe68ba3a1_Out_2_Float;
        Unity_Maximum_float(_Subtract_b7368f21be9e048aae7f90c8a2bfaae1_Out_2_Float, float(0), _Maximum_216777d30802328eab607c8fe68ba3a1_Out_2_Float);
        float3 _Multiply_a856b52cd0848f86a6ae1af9b175935c_Out_2_Vector3;
        Unity_Multiply_float3_float3(_Property_c7292b3b08585f8c8670172b9a220bf0_Out_0_Vector3, (_Maximum_216777d30802328eab607c8fe68ba3a1_Out_2_Float.xxx), _Multiply_a856b52cd0848f86a6ae1af9b175935c_Out_2_Vector3);
        float3 _Add_86c6109dc4530b8c9763ef62b056ad4c_Out_2_Vector3;
        Unity_Add_float3(_Multiply_79b0b5d7d3528b8395e1135339a090f2_Out_2_Vector3, _Multiply_a856b52cd0848f86a6ae1af9b175935c_Out_2_Vector3, _Add_86c6109dc4530b8c9763ef62b056ad4c_Out_2_Vector3);
        float _Add_356384b52728f583bd6e694bc1fc3738_Out_2_Float;
        Unity_Add_float(_Maximum_d02e48d92038448cb0345e5cf3779071_Out_2_Float, _Maximum_216777d30802328eab607c8fe68ba3a1_Out_2_Float, _Add_356384b52728f583bd6e694bc1fc3738_Out_2_Float);
        float _Maximum_94a22f5ceb706e88bc16350a5d5d2a82_Out_2_Float;
        Unity_Maximum_float(_Add_356384b52728f583bd6e694bc1fc3738_Out_2_Float, float(1E-05), _Maximum_94a22f5ceb706e88bc16350a5d5d2a82_Out_2_Float);
        float3 _Divide_d7291d1701d7058dbb5263194c1bed22_Out_2_Vector3;
        Unity_Divide_float3(_Add_86c6109dc4530b8c9763ef62b056ad4c_Out_2_Vector3, (_Maximum_94a22f5ceb706e88bc16350a5d5d2a82_Out_2_Float.xxx), _Divide_d7291d1701d7058dbb5263194c1bed22_Out_2_Vector3);
        OutVector4_1 = _Divide_d7291d1701d7058dbb5263194c1bed22_Out_2_Vector3;
        }
        
        void Unity_Clamp_float(float In, float Min, float Max, out float Out)
        {
            Out = clamp(In, Min, Max);
        }
        
        void Unity_Sign_float3(float3 In, out float3 Out)
        {
            Out = sign(In);
        }
        
        void Unity_Multiply_float2_float2(float2 A, float2 B, out float2 Out)
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
        
        void Unity_Absolute_float(float In, out float Out)
        {
            Out = abs(In);
        }
        
        void Unity_Power_float(float A, float B, out float Out)
        {
            Out = pow(A, B);
        }
        
        void Unity_Saturate_float(float In, out float Out)
        {
            Out = saturate(In);
        }
        
        void Unity_Lerp_float3(float3 A, float3 B, float3 T, out float3 Out)
        {
            Out = lerp(A, B, T);
        }
        
        void Unity_Lerp_float(float A, float B, float T, out float Out)
        {
            Out = lerp(A, B, T);
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
            UnityTexture2D _Property_07d75b1d2628da808a2efb93a1d6219e_Out_0_Texture2D = UnityBuildTexture2DStructNoScale(_BaseColorMap);
            float4 _Property_587a28253857318a9b2e59bfc8fb56a4_Out_0_Vector4 = _BaseTilingOffset;
            float _Property_7f998178363b4188ba2f07298ef869c1_Out_0_Boolean = _BaseUsePlanarUV;
            Bindings_PlanarNM_c0f081da9c567704ea36e7dd38cedcf6_float _PlanarNM_0b8fbae0d009788d8cd595a3b9bf9f6e;
            _PlanarNM_0b8fbae0d009788d8cd595a3b9bf9f6e.AbsoluteWorldSpacePosition = IN.AbsoluteWorldSpacePosition;
            _PlanarNM_0b8fbae0d009788d8cd595a3b9bf9f6e.uv0 = IN.uv0;
            _PlanarNM_0b8fbae0d009788d8cd595a3b9bf9f6e.uv3 = IN.uv3;
            float4 _PlanarNM_0b8fbae0d009788d8cd595a3b9bf9f6e_XZ_2_Vector4;
            SG_PlanarNM_c0f081da9c567704ea36e7dd38cedcf6_float(_Property_07d75b1d2628da808a2efb93a1d6219e_Out_0_Texture2D, _Property_587a28253857318a9b2e59bfc8fb56a4_Out_0_Vector4, _Property_7f998178363b4188ba2f07298ef869c1_Out_0_Boolean, UnityBuildSamplerStateStruct(SamplerState_Linear_Repeat_Aniso8), 1, _PlanarNM_0b8fbae0d009788d8cd595a3b9bf9f6e, _PlanarNM_0b8fbae0d009788d8cd595a3b9bf9f6e_XZ_2_Vector4);
            float4 _Property_b83097c58639858680bf43881a95b0af_Out_0_Vector4 = _BaseColor;
            float4 _Multiply_f572ff0def2d308e87a64e94a46c0d96_Out_2_Vector4;
            Unity_Multiply_float4_float4(_PlanarNM_0b8fbae0d009788d8cd595a3b9bf9f6e_XZ_2_Vector4, _Property_b83097c58639858680bf43881a95b0af_Out_0_Vector4, _Multiply_f572ff0def2d308e87a64e94a46c0d96_Out_2_Vector4);
            UnityTexture2D _Property_1e449ff9f8e8ec828507233e8240eb11_Out_0_Texture2D = UnityBuildTexture2DStructNoScale(_BaseMaskMap);
            Bindings_PlanarNM_c0f081da9c567704ea36e7dd38cedcf6_float _PlanarNM_4245c3b264047180b5c90a697d6cb278;
            _PlanarNM_4245c3b264047180b5c90a697d6cb278.AbsoluteWorldSpacePosition = IN.AbsoluteWorldSpacePosition;
            _PlanarNM_4245c3b264047180b5c90a697d6cb278.uv0 = IN.uv0;
            _PlanarNM_4245c3b264047180b5c90a697d6cb278.uv3 = IN.uv3;
            float4 _PlanarNM_4245c3b264047180b5c90a697d6cb278_XZ_2_Vector4;
            SG_PlanarNM_c0f081da9c567704ea36e7dd38cedcf6_float(_Property_1e449ff9f8e8ec828507233e8240eb11_Out_0_Texture2D, _Property_587a28253857318a9b2e59bfc8fb56a4_Out_0_Vector4, _Property_7f998178363b4188ba2f07298ef869c1_Out_0_Boolean, UnityBuildSamplerStateStruct(SamplerState_Linear_Repeat_Aniso8), 1, _PlanarNM_4245c3b264047180b5c90a697d6cb278, _PlanarNM_4245c3b264047180b5c90a697d6cb278_XZ_2_Vector4);
            float _Split_91a015dea8acd38b904ba0935328a5bc_R_1_Float = _PlanarNM_4245c3b264047180b5c90a697d6cb278_XZ_2_Vector4[0];
            float _Split_91a015dea8acd38b904ba0935328a5bc_G_2_Float = _PlanarNM_4245c3b264047180b5c90a697d6cb278_XZ_2_Vector4[1];
            float _Split_91a015dea8acd38b904ba0935328a5bc_B_3_Float = _PlanarNM_4245c3b264047180b5c90a697d6cb278_XZ_2_Vector4[2];
            float _Split_91a015dea8acd38b904ba0935328a5bc_A_4_Float = _PlanarNM_4245c3b264047180b5c90a697d6cb278_XZ_2_Vector4[3];
            float _Property_fbcff1469ebf488394a8a89ddaf0eb2a_Out_0_Float = _HeightMin;
            float _Property_9df7a44c8225168683743ac60c0c3c34_Out_0_Float = _HeightMax;
            float2 _Vector2_9b1e95888c28bc8893f28c02b87fa448_Out_0_Vector2 = float2(_Property_fbcff1469ebf488394a8a89ddaf0eb2a_Out_0_Float, _Property_9df7a44c8225168683743ac60c0c3c34_Out_0_Float);
            float _Property_29ca14fd0b712983a38d63d2dd326e96_Out_0_Float = _HeightOffset;
            float2 _Add_cb503f8a09720d84bb03cbd89e37b80c_Out_2_Vector2;
            Unity_Add_float2(_Vector2_9b1e95888c28bc8893f28c02b87fa448_Out_0_Vector2, (_Property_29ca14fd0b712983a38d63d2dd326e96_Out_0_Float.xx), _Add_cb503f8a09720d84bb03cbd89e37b80c_Out_2_Vector2);
            float _Remap_18f2e96a438d6584ae2fd56f880de9ee_Out_3_Float;
            Unity_Remap_float(_Split_91a015dea8acd38b904ba0935328a5bc_B_3_Float, float2 (0, 1), _Add_cb503f8a09720d84bb03cbd89e37b80c_Out_2_Vector2, _Remap_18f2e96a438d6584ae2fd56f880de9ee_Out_3_Float);
            UnityTexture2D _Property_ba3a5f4cba7d0a8fa288ffc8267d6c0e_Out_0_Texture2D = UnityBuildTexture2DStructNoScale(_Base2ColorMap);
            float4 _Property_86a4657df480d48e8d3ad3b036731380_Out_0_Vector4 = _Base2TilingOffset;
            float _Property_6c5e16c615cab08a97c2a577642b9d83_Out_0_Boolean = _Base2UsePlanarUV;
            Bindings_PlanarNM_c0f081da9c567704ea36e7dd38cedcf6_float _PlanarNM_5aeab444ca6fd78ea56a01215880a5a4;
            _PlanarNM_5aeab444ca6fd78ea56a01215880a5a4.AbsoluteWorldSpacePosition = IN.AbsoluteWorldSpacePosition;
            _PlanarNM_5aeab444ca6fd78ea56a01215880a5a4.uv0 = IN.uv0;
            _PlanarNM_5aeab444ca6fd78ea56a01215880a5a4.uv3 = IN.uv3;
            float4 _PlanarNM_5aeab444ca6fd78ea56a01215880a5a4_XZ_2_Vector4;
            SG_PlanarNM_c0f081da9c567704ea36e7dd38cedcf6_float(_Property_ba3a5f4cba7d0a8fa288ffc8267d6c0e_Out_0_Texture2D, _Property_86a4657df480d48e8d3ad3b036731380_Out_0_Vector4, _Property_6c5e16c615cab08a97c2a577642b9d83_Out_0_Boolean, UnityBuildSamplerStateStruct(SamplerState_Linear_Repeat_Aniso8), 1, _PlanarNM_5aeab444ca6fd78ea56a01215880a5a4, _PlanarNM_5aeab444ca6fd78ea56a01215880a5a4_XZ_2_Vector4);
            float4 _Property_3561b11b899bda8e855826445cf628aa_Out_0_Vector4 = _Base2Color;
            float4 _Multiply_d2ec682582195e84acc4a8510f50f4b0_Out_2_Vector4;
            Unity_Multiply_float4_float4(_PlanarNM_5aeab444ca6fd78ea56a01215880a5a4_XZ_2_Vector4, _Property_3561b11b899bda8e855826445cf628aa_Out_0_Vector4, _Multiply_d2ec682582195e84acc4a8510f50f4b0_Out_2_Vector4);
            float _Split_c34b73d933404283983f9c8bdb5365d3_R_1_Float = IN.VertexColor[0];
            float _Split_c34b73d933404283983f9c8bdb5365d3_G_2_Float = IN.VertexColor[1];
            float _Split_c34b73d933404283983f9c8bdb5365d3_B_3_Float = IN.VertexColor[2];
            float _Split_c34b73d933404283983f9c8bdb5365d3_A_4_Float = IN.VertexColor[3];
            float _Property_df2df7bb5cfc3381beee7ec454da7542_Out_0_Boolean = _Invert_Layer_Mask;
            UnityTexture2D _Property_c7b1e2df9f9b0e8eace9b2274924e69c_Out_0_Texture2D = UnityBuildTexture2DStructNoScale(_LayerMask);
            float4 _SampleTexture2D_175fb18fafc9598382f1f5f7e97bf30a_RGBA_0_Vector4 = SAMPLE_TEXTURE2D(_Property_c7b1e2df9f9b0e8eace9b2274924e69c_Out_0_Texture2D.tex, _Property_c7b1e2df9f9b0e8eace9b2274924e69c_Out_0_Texture2D.samplerstate, _Property_c7b1e2df9f9b0e8eace9b2274924e69c_Out_0_Texture2D.GetTransformedUV(IN.uv0.xy) );
            float _SampleTexture2D_175fb18fafc9598382f1f5f7e97bf30a_R_4_Float = _SampleTexture2D_175fb18fafc9598382f1f5f7e97bf30a_RGBA_0_Vector4.r;
            float _SampleTexture2D_175fb18fafc9598382f1f5f7e97bf30a_G_5_Float = _SampleTexture2D_175fb18fafc9598382f1f5f7e97bf30a_RGBA_0_Vector4.g;
            float _SampleTexture2D_175fb18fafc9598382f1f5f7e97bf30a_B_6_Float = _SampleTexture2D_175fb18fafc9598382f1f5f7e97bf30a_RGBA_0_Vector4.b;
            float _SampleTexture2D_175fb18fafc9598382f1f5f7e97bf30a_A_7_Float = _SampleTexture2D_175fb18fafc9598382f1f5f7e97bf30a_RGBA_0_Vector4.a;
            float _OneMinus_ce5c3c0635d4ac86beb55115d0ebaed7_Out_1_Float;
            Unity_OneMinus_float(_SampleTexture2D_175fb18fafc9598382f1f5f7e97bf30a_R_4_Float, _OneMinus_ce5c3c0635d4ac86beb55115d0ebaed7_Out_1_Float);
            float _Branch_af0c5e511241ce8eae748ae487df50fa_Out_3_Float;
            Unity_Branch_float(_Property_df2df7bb5cfc3381beee7ec454da7542_Out_0_Boolean, _OneMinus_ce5c3c0635d4ac86beb55115d0ebaed7_Out_1_Float, _SampleTexture2D_175fb18fafc9598382f1f5f7e97bf30a_R_4_Float, _Branch_af0c5e511241ce8eae748ae487df50fa_Out_3_Float);
            UnityTexture2D _Property_de4f6eb48a629285a664dad7fb06438f_Out_0_Texture2D = UnityBuildTexture2DStructNoScale(_Base2MaskMap);
            Bindings_PlanarNM_c0f081da9c567704ea36e7dd38cedcf6_float _PlanarNM_d5657f470f05ef839e4c257a20ace8cb;
            _PlanarNM_d5657f470f05ef839e4c257a20ace8cb.AbsoluteWorldSpacePosition = IN.AbsoluteWorldSpacePosition;
            _PlanarNM_d5657f470f05ef839e4c257a20ace8cb.uv0 = IN.uv0;
            _PlanarNM_d5657f470f05ef839e4c257a20ace8cb.uv3 = IN.uv3;
            float4 _PlanarNM_d5657f470f05ef839e4c257a20ace8cb_XZ_2_Vector4;
            SG_PlanarNM_c0f081da9c567704ea36e7dd38cedcf6_float(_Property_de4f6eb48a629285a664dad7fb06438f_Out_0_Texture2D, _Property_86a4657df480d48e8d3ad3b036731380_Out_0_Vector4, _Property_6c5e16c615cab08a97c2a577642b9d83_Out_0_Boolean, UnityBuildSamplerStateStruct(SamplerState_Linear_Repeat_Aniso8), 1, _PlanarNM_d5657f470f05ef839e4c257a20ace8cb, _PlanarNM_d5657f470f05ef839e4c257a20ace8cb_XZ_2_Vector4);
            float _Split_83ec66b648ab6c84848b42686c256cd7_R_1_Float = _PlanarNM_d5657f470f05ef839e4c257a20ace8cb_XZ_2_Vector4[0];
            float _Split_83ec66b648ab6c84848b42686c256cd7_G_2_Float = _PlanarNM_d5657f470f05ef839e4c257a20ace8cb_XZ_2_Vector4[1];
            float _Split_83ec66b648ab6c84848b42686c256cd7_B_3_Float = _PlanarNM_d5657f470f05ef839e4c257a20ace8cb_XZ_2_Vector4[2];
            float _Split_83ec66b648ab6c84848b42686c256cd7_A_4_Float = _PlanarNM_d5657f470f05ef839e4c257a20ace8cb_XZ_2_Vector4[3];
            float _Property_ce1750e5c69e97818667b412fc3f9f2c_Out_0_Float = _HeightMin2;
            float _Property_8e0f2ea54d8ede89bbabdf31a9bafd57_Out_0_Float = _HeightMax2;
            float2 _Vector2_fb6c6dd7e70e768ba686e8e94153bb96_Out_0_Vector2 = float2(_Property_ce1750e5c69e97818667b412fc3f9f2c_Out_0_Float, _Property_8e0f2ea54d8ede89bbabdf31a9bafd57_Out_0_Float);
            float _Property_151ae2702b614585af2000f0a812960f_Out_0_Float = _HeightOffset2;
            float2 _Add_fd1b3d8e24e77087a55888eeb238f1a6_Out_2_Vector2;
            Unity_Add_float2(_Vector2_fb6c6dd7e70e768ba686e8e94153bb96_Out_0_Vector2, (_Property_151ae2702b614585af2000f0a812960f_Out_0_Float.xx), _Add_fd1b3d8e24e77087a55888eeb238f1a6_Out_2_Vector2);
            float _Remap_3d4180c0ab36ba86a5517b2645f0bfa7_Out_3_Float;
            Unity_Remap_float(_Split_83ec66b648ab6c84848b42686c256cd7_B_3_Float, float2 (0, 1), _Add_fd1b3d8e24e77087a55888eeb238f1a6_Out_2_Vector2, _Remap_3d4180c0ab36ba86a5517b2645f0bfa7_Out_3_Float);
            float _Multiply_2cb0e5aa384654828f0453a44884573c_Out_2_Float;
            Unity_Multiply_float_float(_Branch_af0c5e511241ce8eae748ae487df50fa_Out_3_Float, _Remap_3d4180c0ab36ba86a5517b2645f0bfa7_Out_3_Float, _Multiply_2cb0e5aa384654828f0453a44884573c_Out_2_Float);
            float _Multiply_74def30593cbbb8bbed03613a31cb89a_Out_2_Float;
            Unity_Multiply_float_float(_Split_c34b73d933404283983f9c8bdb5365d3_G_2_Float, _Multiply_2cb0e5aa384654828f0453a44884573c_Out_2_Float, _Multiply_74def30593cbbb8bbed03613a31cb89a_Out_2_Float);
            float _Property_818c8af4b930138e81034c886614171d_Out_0_Float = _Height_Transition;
            Bindings_HeightBlend_d15b6fb865d3b6d4ebc1fd476c3ad135_float _HeightBlend_7501025b3a60738a9a9d362e35a9ab48;
            float3 _HeightBlend_7501025b3a60738a9a9d362e35a9ab48_OutVector4_1_Vector3;
            SG_HeightBlend_d15b6fb865d3b6d4ebc1fd476c3ad135_float((_Multiply_f572ff0def2d308e87a64e94a46c0d96_Out_2_Vector4.xyz), _Remap_18f2e96a438d6584ae2fd56f880de9ee_Out_3_Float, (_Multiply_d2ec682582195e84acc4a8510f50f4b0_Out_2_Vector4.xyz), _Multiply_74def30593cbbb8bbed03613a31cb89a_Out_2_Float, _Property_818c8af4b930138e81034c886614171d_Out_0_Float, _HeightBlend_7501025b3a60738a9a9d362e35a9ab48, _HeightBlend_7501025b3a60738a9a9d362e35a9ab48_OutVector4_1_Vector3);
            UnityTexture2D _Property_c0ebdab0f71ace8aabaa865fd7293599_Out_0_Texture2D = UnityBuildTexture2DStructNoScale(_CoverBaseColorMap);
            float4 _Property_822489d2e6d3e08590c64f085ffd9b2e_Out_0_Vector4 = _CoverTilingOffset;
            float _Property_2ae4a163bd21d98789af282d6e469175_Out_0_Boolean = _CoverUsePlanarUV;
            Bindings_PlanarNM_c0f081da9c567704ea36e7dd38cedcf6_float _PlanarNM_8bb420494d19b28e9ccdff489802dc81;
            _PlanarNM_8bb420494d19b28e9ccdff489802dc81.AbsoluteWorldSpacePosition = IN.AbsoluteWorldSpacePosition;
            _PlanarNM_8bb420494d19b28e9ccdff489802dc81.uv0 = IN.uv0;
            _PlanarNM_8bb420494d19b28e9ccdff489802dc81.uv3 = IN.uv3;
            float4 _PlanarNM_8bb420494d19b28e9ccdff489802dc81_XZ_2_Vector4;
            SG_PlanarNM_c0f081da9c567704ea36e7dd38cedcf6_float(_Property_c0ebdab0f71ace8aabaa865fd7293599_Out_0_Texture2D, _Property_822489d2e6d3e08590c64f085ffd9b2e_Out_0_Vector4, _Property_2ae4a163bd21d98789af282d6e469175_Out_0_Boolean, UnityBuildSamplerStateStruct(SamplerState_Linear_Repeat_Aniso8), 1, _PlanarNM_8bb420494d19b28e9ccdff489802dc81, _PlanarNM_8bb420494d19b28e9ccdff489802dc81_XZ_2_Vector4);
            float4 _Property_55e7941fa7ac5f8387aa9bb633b08883_Out_0_Vector4 = _CoverBaseColor;
            float4 _Multiply_a38ba695a2660c8691763f0bd7fe159c_Out_2_Vector4;
            Unity_Multiply_float4_float4(_PlanarNM_8bb420494d19b28e9ccdff489802dc81_XZ_2_Vector4, _Property_55e7941fa7ac5f8387aa9bb633b08883_Out_0_Vector4, _Multiply_a38ba695a2660c8691763f0bd7fe159c_Out_2_Vector4);
            UnityTexture2D _Property_3b351481f7b944ffaf5f59649df41ba9_Out_0_Texture2D = UnityBuildTexture2DStructNoScale(_CoverBaseColorMap);
            float4 _UV_5352c8dd0add178ba83a5421c2c0b3f0_Out_0_Vector4 = IN.uv0;
            float4 _SampleTexture2D_024ba490c015248988a12a9d670014ea_RGBA_0_Vector4 = SAMPLE_TEXTURE2D(_Property_3b351481f7b944ffaf5f59649df41ba9_Out_0_Texture2D.tex, _Property_3b351481f7b944ffaf5f59649df41ba9_Out_0_Texture2D.samplerstate, _Property_3b351481f7b944ffaf5f59649df41ba9_Out_0_Texture2D.GetTransformedUV((_UV_5352c8dd0add178ba83a5421c2c0b3f0_Out_0_Vector4.xy)) );
            float _SampleTexture2D_024ba490c015248988a12a9d670014ea_R_4_Float = _SampleTexture2D_024ba490c015248988a12a9d670014ea_RGBA_0_Vector4.r;
            float _SampleTexture2D_024ba490c015248988a12a9d670014ea_G_5_Float = _SampleTexture2D_024ba490c015248988a12a9d670014ea_RGBA_0_Vector4.g;
            float _SampleTexture2D_024ba490c015248988a12a9d670014ea_B_6_Float = _SampleTexture2D_024ba490c015248988a12a9d670014ea_RGBA_0_Vector4.b;
            float _SampleTexture2D_024ba490c015248988a12a9d670014ea_A_7_Float = _SampleTexture2D_024ba490c015248988a12a9d670014ea_RGBA_0_Vector4.a;
            float _Property_b80e7b96604b7c82bbf9bff4981fad76_Out_0_Float = _CoverMaskPower;
            float _Multiply_abe410d256783480b1b58468bf78a882_Out_2_Float;
            Unity_Multiply_float_float(_SampleTexture2D_024ba490c015248988a12a9d670014ea_A_7_Float, _Property_b80e7b96604b7c82bbf9bff4981fad76_Out_0_Float, _Multiply_abe410d256783480b1b58468bf78a882_Out_2_Float);
            float _Clamp_a78f6f28770afd869adb9d12cd47370b_Out_3_Float;
            Unity_Clamp_float(_Multiply_abe410d256783480b1b58468bf78a882_Out_2_Float, float(0), float(1), _Clamp_a78f6f28770afd869adb9d12cd47370b_Out_3_Float);
            UnityTexture2D _Property_7c7049e15fdff386b535790d8666f609_Out_0_Texture2D = UnityBuildTexture2DStructNoScale(_BaseNormalMap);
            Bindings_PlanarNMn_1b93a87456f9d4c419321d0cd92bd6c8_float _PlanarNMn_a3713a9c3874b6838d0eda971b9c62d8;
            _PlanarNMn_a3713a9c3874b6838d0eda971b9c62d8.WorldSpaceNormal = IN.WorldSpaceNormal;
            _PlanarNMn_a3713a9c3874b6838d0eda971b9c62d8.WorldSpaceTangent = IN.WorldSpaceTangent;
            _PlanarNMn_a3713a9c3874b6838d0eda971b9c62d8.WorldSpaceBiTangent = IN.WorldSpaceBiTangent;
            _PlanarNMn_a3713a9c3874b6838d0eda971b9c62d8.AbsoluteWorldSpacePosition = IN.AbsoluteWorldSpacePosition;
            _PlanarNMn_a3713a9c3874b6838d0eda971b9c62d8.uv0 = IN.uv0;
            _PlanarNMn_a3713a9c3874b6838d0eda971b9c62d8.uv3 = IN.uv3;
            float4 _PlanarNMn_a3713a9c3874b6838d0eda971b9c62d8_XZ_2_Vector4;
            SG_PlanarNMn_1b93a87456f9d4c419321d0cd92bd6c8_float(_Property_7c7049e15fdff386b535790d8666f609_Out_0_Texture2D, _Property_587a28253857318a9b2e59bfc8fb56a4_Out_0_Vector4, _Property_7f998178363b4188ba2f07298ef869c1_Out_0_Boolean, UnityBuildSamplerStateStruct(SamplerState_Linear_Repeat_Aniso8), 1, _PlanarNMn_a3713a9c3874b6838d0eda971b9c62d8, _PlanarNMn_a3713a9c3874b6838d0eda971b9c62d8_XZ_2_Vector4);
            float _Property_d4b0759cf4647e81be065ec1465ce2b4_Out_0_Float = _BaseNormalScale;
            float3 _NormalStrength_f66a9108ea294886acc61513b41cc5e4_Out_2_Vector3;
            Unity_NormalStrength_float((_PlanarNMn_a3713a9c3874b6838d0eda971b9c62d8_XZ_2_Vector4.xyz), _Property_d4b0759cf4647e81be065ec1465ce2b4_Out_0_Float, _NormalStrength_f66a9108ea294886acc61513b41cc5e4_Out_2_Vector3);
            UnityTexture2D _Property_fa9f7890b20ad481a92543c04b237bde_Out_0_Texture2D = UnityBuildTexture2DStructNoScale(_Base2NormalMap);
            Bindings_PlanarNMn_1b93a87456f9d4c419321d0cd92bd6c8_float _PlanarNMn_d7b3ec528088a085a5102e025a1b45cf;
            _PlanarNMn_d7b3ec528088a085a5102e025a1b45cf.WorldSpaceNormal = IN.WorldSpaceNormal;
            _PlanarNMn_d7b3ec528088a085a5102e025a1b45cf.WorldSpaceTangent = IN.WorldSpaceTangent;
            _PlanarNMn_d7b3ec528088a085a5102e025a1b45cf.WorldSpaceBiTangent = IN.WorldSpaceBiTangent;
            _PlanarNMn_d7b3ec528088a085a5102e025a1b45cf.AbsoluteWorldSpacePosition = IN.AbsoluteWorldSpacePosition;
            _PlanarNMn_d7b3ec528088a085a5102e025a1b45cf.uv0 = IN.uv0;
            _PlanarNMn_d7b3ec528088a085a5102e025a1b45cf.uv3 = IN.uv3;
            float4 _PlanarNMn_d7b3ec528088a085a5102e025a1b45cf_XZ_2_Vector4;
            SG_PlanarNMn_1b93a87456f9d4c419321d0cd92bd6c8_float(_Property_fa9f7890b20ad481a92543c04b237bde_Out_0_Texture2D, _Property_86a4657df480d48e8d3ad3b036731380_Out_0_Vector4, _Property_6c5e16c615cab08a97c2a577642b9d83_Out_0_Boolean, UnityBuildSamplerStateStruct(SamplerState_Linear_Repeat_Aniso8), 1, _PlanarNMn_d7b3ec528088a085a5102e025a1b45cf, _PlanarNMn_d7b3ec528088a085a5102e025a1b45cf_XZ_2_Vector4);
            float _Property_8c31443b776727819a663c7ddce79064_Out_0_Float = _Base2NormalScale;
            float3 _NormalStrength_0fb86880ab8e368dac6d01b830e20ed8_Out_2_Vector3;
            Unity_NormalStrength_float((_PlanarNMn_d7b3ec528088a085a5102e025a1b45cf_XZ_2_Vector4.xyz), _Property_8c31443b776727819a663c7ddce79064_Out_0_Float, _NormalStrength_0fb86880ab8e368dac6d01b830e20ed8_Out_2_Vector3);
            Bindings_HeightBlend_d15b6fb865d3b6d4ebc1fd476c3ad135_float _HeightBlend_7c09d97625efce898e21b66cd039be8b;
            float3 _HeightBlend_7c09d97625efce898e21b66cd039be8b_OutVector4_1_Vector3;
            SG_HeightBlend_d15b6fb865d3b6d4ebc1fd476c3ad135_float(_NormalStrength_f66a9108ea294886acc61513b41cc5e4_Out_2_Vector3, _Remap_18f2e96a438d6584ae2fd56f880de9ee_Out_3_Float, _NormalStrength_0fb86880ab8e368dac6d01b830e20ed8_Out_2_Vector3, _Multiply_74def30593cbbb8bbed03613a31cb89a_Out_2_Float, _Property_818c8af4b930138e81034c886614171d_Out_0_Float, _HeightBlend_7c09d97625efce898e21b66cd039be8b, _HeightBlend_7c09d97625efce898e21b66cd039be8b_OutVector4_1_Vector3);
            UnityTexture2D _Property_65f7dd6fe6c29b83913af586c597a1ef_Out_0_Texture2D = UnityBuildTexture2DStructNoScale(_CoverNormalMap);
            Bindings_PlanarNMn_1b93a87456f9d4c419321d0cd92bd6c8_float _PlanarNMn_248bc5b7421d3f828d166902c73ca6c3;
            _PlanarNMn_248bc5b7421d3f828d166902c73ca6c3.WorldSpaceNormal = IN.WorldSpaceNormal;
            _PlanarNMn_248bc5b7421d3f828d166902c73ca6c3.WorldSpaceTangent = IN.WorldSpaceTangent;
            _PlanarNMn_248bc5b7421d3f828d166902c73ca6c3.WorldSpaceBiTangent = IN.WorldSpaceBiTangent;
            _PlanarNMn_248bc5b7421d3f828d166902c73ca6c3.AbsoluteWorldSpacePosition = IN.AbsoluteWorldSpacePosition;
            _PlanarNMn_248bc5b7421d3f828d166902c73ca6c3.uv0 = IN.uv0;
            _PlanarNMn_248bc5b7421d3f828d166902c73ca6c3.uv3 = IN.uv3;
            float4 _PlanarNMn_248bc5b7421d3f828d166902c73ca6c3_XZ_2_Vector4;
            SG_PlanarNMn_1b93a87456f9d4c419321d0cd92bd6c8_float(_Property_65f7dd6fe6c29b83913af586c597a1ef_Out_0_Texture2D, _Property_822489d2e6d3e08590c64f085ffd9b2e_Out_0_Vector4, _Property_2ae4a163bd21d98789af282d6e469175_Out_0_Boolean, UnityBuildSamplerStateStruct(SamplerState_Linear_Repeat_Aniso8), 1, _PlanarNMn_248bc5b7421d3f828d166902c73ca6c3, _PlanarNMn_248bc5b7421d3f828d166902c73ca6c3_XZ_2_Vector4);
            float _Property_19f92cae42737480a95820c51d4ba124_Out_0_Float = _CoverNormalBlendHardness;
            float3 _NormalStrength_2c3488591b8345869feb25a3dee06c3f_Out_2_Vector3;
            Unity_NormalStrength_float((_PlanarNMn_248bc5b7421d3f828d166902c73ca6c3_XZ_2_Vector4.xyz), _Property_19f92cae42737480a95820c51d4ba124_Out_0_Float, _NormalStrength_2c3488591b8345869feb25a3dee06c3f_Out_2_Vector3);
            float _Split_96bfe9cb80ad308385c191d094b3d071_R_1_Float = IN.WorldSpaceNormal[0];
            float _Split_96bfe9cb80ad308385c191d094b3d071_G_2_Float = IN.WorldSpaceNormal[1];
            float _Split_96bfe9cb80ad308385c191d094b3d071_B_3_Float = IN.WorldSpaceNormal[2];
            float _Split_96bfe9cb80ad308385c191d094b3d071_A_4_Float = 0;
            float _Property_0dd796aae8cd9f878bef13ceac4fe3ec_Out_0_Float = _Cover_Amount;
            float _Property_67285cdc688aa38d83f62d5bb095d597_Out_0_Float = _Cover_Amount_Grow_Speed;
            float _Subtract_fcefec675e7536888eccf5574d921972_Out_2_Float;
            Unity_Subtract_float(float(4), _Property_67285cdc688aa38d83f62d5bb095d597_Out_0_Float, _Subtract_fcefec675e7536888eccf5574d921972_Out_2_Float);
            float _Divide_1e25465528e612839a4ce1faedd89e7d_Out_2_Float;
            Unity_Divide_float(_Property_0dd796aae8cd9f878bef13ceac4fe3ec_Out_0_Float, _Subtract_fcefec675e7536888eccf5574d921972_Out_2_Float, _Divide_1e25465528e612839a4ce1faedd89e7d_Out_2_Float);
            float _Absolute_d20b810ffdec828ab74dd6692d82f01b_Out_1_Float;
            Unity_Absolute_float(_Divide_1e25465528e612839a4ce1faedd89e7d_Out_2_Float, _Absolute_d20b810ffdec828ab74dd6692d82f01b_Out_1_Float);
            float _Power_181fbf47cfdb258da1fe0b72a450986f_Out_2_Float;
            Unity_Power_float(_Absolute_d20b810ffdec828ab74dd6692d82f01b_Out_1_Float, _Subtract_fcefec675e7536888eccf5574d921972_Out_2_Float, _Power_181fbf47cfdb258da1fe0b72a450986f_Out_2_Float);
            float _Clamp_11f62dba01f1a38c9e0a9972ccd19246_Out_3_Float;
            Unity_Clamp_float(_Power_181fbf47cfdb258da1fe0b72a450986f_Out_2_Float, float(0), float(2), _Clamp_11f62dba01f1a38c9e0a9972ccd19246_Out_3_Float);
            float _Multiply_9810f6d76275cd8fbe5e3a02360b98a7_Out_2_Float;
            Unity_Multiply_float_float(_Split_96bfe9cb80ad308385c191d094b3d071_G_2_Float, _Clamp_11f62dba01f1a38c9e0a9972ccd19246_Out_3_Float, _Multiply_9810f6d76275cd8fbe5e3a02360b98a7_Out_2_Float);
            float _Saturate_a007c5f214685c87bf6ca3e64c06b488_Out_1_Float;
            Unity_Saturate_float(_Multiply_9810f6d76275cd8fbe5e3a02360b98a7_Out_2_Float, _Saturate_a007c5f214685c87bf6ca3e64c06b488_Out_1_Float);
            float _Clamp_1b2b25b617fc508b9835f0309136fd00_Out_3_Float;
            Unity_Clamp_float(_Split_96bfe9cb80ad308385c191d094b3d071_G_2_Float, float(0), float(0.9999), _Clamp_1b2b25b617fc508b9835f0309136fd00_Out_3_Float);
            float _Property_7b12276ea7a4538db6804507b30a830c_Out_0_Float = _Cover_Max_Angle;
            float _Divide_54c523ff4b7acb858e9e368fd1e4d34a_Out_2_Float;
            Unity_Divide_float(_Property_7b12276ea7a4538db6804507b30a830c_Out_0_Float, float(45), _Divide_54c523ff4b7acb858e9e368fd1e4d34a_Out_2_Float);
            float _OneMinus_6cf431985b651e8e9546ae6cb2d4d668_Out_1_Float;
            Unity_OneMinus_float(_Divide_54c523ff4b7acb858e9e368fd1e4d34a_Out_2_Float, _OneMinus_6cf431985b651e8e9546ae6cb2d4d668_Out_1_Float);
            float _Subtract_4ef7b60aeab8d589bf2d2423737642bc_Out_2_Float;
            Unity_Subtract_float(_Clamp_1b2b25b617fc508b9835f0309136fd00_Out_3_Float, _OneMinus_6cf431985b651e8e9546ae6cb2d4d668_Out_1_Float, _Subtract_4ef7b60aeab8d589bf2d2423737642bc_Out_2_Float);
            float _Clamp_a4b51894ea17818c9a27bb533a2ebe74_Out_3_Float;
            Unity_Clamp_float(_Subtract_4ef7b60aeab8d589bf2d2423737642bc_Out_2_Float, float(0), float(2), _Clamp_a4b51894ea17818c9a27bb533a2ebe74_Out_3_Float);
            float _Divide_c4196d4f02190b89ba827ccd4ae8a74d_Out_2_Float;
            Unity_Divide_float(float(1), _Divide_54c523ff4b7acb858e9e368fd1e4d34a_Out_2_Float, _Divide_c4196d4f02190b89ba827ccd4ae8a74d_Out_2_Float);
            float _Multiply_ffc22433163d1184846ede424b44bcb2_Out_2_Float;
            Unity_Multiply_float_float(_Clamp_a4b51894ea17818c9a27bb533a2ebe74_Out_3_Float, _Divide_c4196d4f02190b89ba827ccd4ae8a74d_Out_2_Float, _Multiply_ffc22433163d1184846ede424b44bcb2_Out_2_Float);
            float _Absolute_c2e5757082de5d878d4c023806fb2108_Out_1_Float;
            Unity_Absolute_float(_Multiply_ffc22433163d1184846ede424b44bcb2_Out_2_Float, _Absolute_c2e5757082de5d878d4c023806fb2108_Out_1_Float);
            float _Property_849d9f217c95f38c9d49ab251578d8d5_Out_0_Float = _CoverHardness;
            float _Power_578546d66d69a5829b745ebba1279adf_Out_2_Float;
            Unity_Power_float(_Absolute_c2e5757082de5d878d4c023806fb2108_Out_1_Float, _Property_849d9f217c95f38c9d49ab251578d8d5_Out_0_Float, _Power_578546d66d69a5829b745ebba1279adf_Out_2_Float);
            float _Property_34d2d3aff4814e8e83d2894b3512c6c8_Out_0_Float = _Cover_Min_Height;
            float _OneMinus_474df64227f004849b34c68fe8df93f2_Out_1_Float;
            Unity_OneMinus_float(_Property_34d2d3aff4814e8e83d2894b3512c6c8_Out_0_Float, _OneMinus_474df64227f004849b34c68fe8df93f2_Out_1_Float);
            float _Split_ee4d9dc934b3508397d5a3dece110ab0_R_1_Float = IN.AbsoluteWorldSpacePosition[0];
            float _Split_ee4d9dc934b3508397d5a3dece110ab0_G_2_Float = IN.AbsoluteWorldSpacePosition[1];
            float _Split_ee4d9dc934b3508397d5a3dece110ab0_B_3_Float = IN.AbsoluteWorldSpacePosition[2];
            float _Split_ee4d9dc934b3508397d5a3dece110ab0_A_4_Float = 0;
            float _Add_d6bc513aa82d918ea24e279f4353d971_Out_2_Float;
            Unity_Add_float(_OneMinus_474df64227f004849b34c68fe8df93f2_Out_1_Float, _Split_ee4d9dc934b3508397d5a3dece110ab0_G_2_Float, _Add_d6bc513aa82d918ea24e279f4353d971_Out_2_Float);
            float _Add_a6a61cb12180108c9e1364b90d2673e2_Out_2_Float;
            Unity_Add_float(_Add_d6bc513aa82d918ea24e279f4353d971_Out_2_Float, float(1), _Add_a6a61cb12180108c9e1364b90d2673e2_Out_2_Float);
            float _Clamp_1874fdd00cb9aa839d93ab8536e2414d_Out_3_Float;
            Unity_Clamp_float(_Add_a6a61cb12180108c9e1364b90d2673e2_Out_2_Float, float(0), float(1), _Clamp_1874fdd00cb9aa839d93ab8536e2414d_Out_3_Float);
            float _Property_7b91fd6e21b46c85816c7b681307cbe4_Out_0_Float = _Cover_Min_Height_Blending;
            float _Add_6dca9453f6a35e8185c4b8e9782db0a9_Out_2_Float;
            Unity_Add_float(_Add_d6bc513aa82d918ea24e279f4353d971_Out_2_Float, _Property_7b91fd6e21b46c85816c7b681307cbe4_Out_0_Float, _Add_6dca9453f6a35e8185c4b8e9782db0a9_Out_2_Float);
            float _Divide_83415a319ecfba83af914cbc5487b546_Out_2_Float;
            Unity_Divide_float(_Add_6dca9453f6a35e8185c4b8e9782db0a9_Out_2_Float, _Add_d6bc513aa82d918ea24e279f4353d971_Out_2_Float, _Divide_83415a319ecfba83af914cbc5487b546_Out_2_Float);
            float _OneMinus_bf150b22fcad5a87b7c825c9c6cf1687_Out_1_Float;
            Unity_OneMinus_float(_Divide_83415a319ecfba83af914cbc5487b546_Out_2_Float, _OneMinus_bf150b22fcad5a87b7c825c9c6cf1687_Out_1_Float);
            float _Add_86ff9fa850efbe8c80705d8266609dab_Out_2_Float;
            Unity_Add_float(_OneMinus_bf150b22fcad5a87b7c825c9c6cf1687_Out_1_Float, float(-0.5), _Add_86ff9fa850efbe8c80705d8266609dab_Out_2_Float);
            float _Clamp_906e140f01222d8ba61252ec6ec9d6a4_Out_3_Float;
            Unity_Clamp_float(_Add_86ff9fa850efbe8c80705d8266609dab_Out_2_Float, float(0), float(1), _Clamp_906e140f01222d8ba61252ec6ec9d6a4_Out_3_Float);
            float _Add_c1ec5849bf72f585a30b3e11a91ada52_Out_2_Float;
            Unity_Add_float(_Clamp_1874fdd00cb9aa839d93ab8536e2414d_Out_3_Float, _Clamp_906e140f01222d8ba61252ec6ec9d6a4_Out_3_Float, _Add_c1ec5849bf72f585a30b3e11a91ada52_Out_2_Float);
            float _Clamp_17a8a0cf209a038b9e9c7f5681cdd1fb_Out_3_Float;
            Unity_Clamp_float(_Add_c1ec5849bf72f585a30b3e11a91ada52_Out_2_Float, float(0), float(1), _Clamp_17a8a0cf209a038b9e9c7f5681cdd1fb_Out_3_Float);
            float _Multiply_8c2759ac24a9b289b1e9610cfd161bb0_Out_2_Float;
            Unity_Multiply_float_float(_Power_578546d66d69a5829b745ebba1279adf_Out_2_Float, _Clamp_17a8a0cf209a038b9e9c7f5681cdd1fb_Out_3_Float, _Multiply_8c2759ac24a9b289b1e9610cfd161bb0_Out_2_Float);
            float _Multiply_1a723f136ec7fa8c957b5d29e03d3051_Out_2_Float;
            Unity_Multiply_float_float(_Saturate_a007c5f214685c87bf6ca3e64c06b488_Out_1_Float, _Multiply_8c2759ac24a9b289b1e9610cfd161bb0_Out_2_Float, _Multiply_1a723f136ec7fa8c957b5d29e03d3051_Out_2_Float);
            float3 _Lerp_d1c72e47b283948584479177786ae8d5_Out_3_Vector3;
            Unity_Lerp_float3(_HeightBlend_7c09d97625efce898e21b66cd039be8b_OutVector4_1_Vector3, _NormalStrength_2c3488591b8345869feb25a3dee06c3f_Out_2_Vector3, (_Multiply_1a723f136ec7fa8c957b5d29e03d3051_Out_2_Float.xxx), _Lerp_d1c72e47b283948584479177786ae8d5_Out_3_Vector3);
            float3 _Transform_180fb403b53f318db002e8eba7616644_Out_1_Vector3;
            {
                float3x3 tangentTransform = float3x3(IN.WorldSpaceTangent, IN.WorldSpaceBiTangent, IN.WorldSpaceNormal);
                _Transform_180fb403b53f318db002e8eba7616644_Out_1_Vector3 = TransformTangentToWorldDir(_Lerp_d1c72e47b283948584479177786ae8d5_Out_3_Vector3.xyz, tangentTransform, true).xyz;
            }
            float _Split_c9a2b4fb4f688b8ebfc1436535cd5ba4_R_1_Float = _Transform_180fb403b53f318db002e8eba7616644_Out_1_Vector3[0];
            float _Split_c9a2b4fb4f688b8ebfc1436535cd5ba4_G_2_Float = _Transform_180fb403b53f318db002e8eba7616644_Out_1_Vector3[1];
            float _Split_c9a2b4fb4f688b8ebfc1436535cd5ba4_B_3_Float = _Transform_180fb403b53f318db002e8eba7616644_Out_1_Vector3[2];
            float _Split_c9a2b4fb4f688b8ebfc1436535cd5ba4_A_4_Float = 0;
            float _Multiply_4c7631d0688102819e6d388d624855a1_Out_2_Float;
            Unity_Multiply_float_float(_Split_c9a2b4fb4f688b8ebfc1436535cd5ba4_G_2_Float, _Clamp_11f62dba01f1a38c9e0a9972ccd19246_Out_3_Float, _Multiply_4c7631d0688102819e6d388d624855a1_Out_2_Float);
            float _Multiply_f2887eb409f6bb81ae4caad2b01b17f1_Out_2_Float;
            Unity_Multiply_float_float(_Clamp_11f62dba01f1a38c9e0a9972ccd19246_Out_3_Float, _Property_849d9f217c95f38c9d49ab251578d8d5_Out_0_Float, _Multiply_f2887eb409f6bb81ae4caad2b01b17f1_Out_2_Float);
            float _Multiply_2e348ed31331e78791b2b3130a009f30_Out_2_Float;
            Unity_Multiply_float_float(_Multiply_f2887eb409f6bb81ae4caad2b01b17f1_Out_2_Float, _Multiply_8c2759ac24a9b289b1e9610cfd161bb0_Out_2_Float, _Multiply_2e348ed31331e78791b2b3130a009f30_Out_2_Float);
            float _Multiply_622e54e9a77b08839c0954ce5715ad1c_Out_2_Float;
            Unity_Multiply_float_float(_Multiply_4c7631d0688102819e6d388d624855a1_Out_2_Float, _Multiply_2e348ed31331e78791b2b3130a009f30_Out_2_Float, _Multiply_622e54e9a77b08839c0954ce5715ad1c_Out_2_Float);
            UnityTexture2D _Property_608db04fab7d768d9a8b5fb9cf0768e1_Out_0_Texture2D = UnityBuildTexture2DStructNoScale(_CoverMaskMap);
            Bindings_PlanarNM_c0f081da9c567704ea36e7dd38cedcf6_float _PlanarNM_819c993d9b62a28ea640d2bacdc62c6e;
            _PlanarNM_819c993d9b62a28ea640d2bacdc62c6e.AbsoluteWorldSpacePosition = IN.AbsoluteWorldSpacePosition;
            _PlanarNM_819c993d9b62a28ea640d2bacdc62c6e.uv0 = IN.uv0;
            _PlanarNM_819c993d9b62a28ea640d2bacdc62c6e.uv3 = IN.uv3;
            float4 _PlanarNM_819c993d9b62a28ea640d2bacdc62c6e_XZ_2_Vector4;
            SG_PlanarNM_c0f081da9c567704ea36e7dd38cedcf6_float(_Property_608db04fab7d768d9a8b5fb9cf0768e1_Out_0_Texture2D, _Property_822489d2e6d3e08590c64f085ffd9b2e_Out_0_Vector4, _Property_2ae4a163bd21d98789af282d6e469175_Out_0_Boolean, UnityBuildSamplerStateStruct(SamplerState_Linear_Repeat_Aniso8), 1, _PlanarNM_819c993d9b62a28ea640d2bacdc62c6e, _PlanarNM_819c993d9b62a28ea640d2bacdc62c6e_XZ_2_Vector4);
            float _Split_86ec1aefda4f9e8e82b79c6195b397b0_R_1_Float = _PlanarNM_819c993d9b62a28ea640d2bacdc62c6e_XZ_2_Vector4[0];
            float _Split_86ec1aefda4f9e8e82b79c6195b397b0_G_2_Float = _PlanarNM_819c993d9b62a28ea640d2bacdc62c6e_XZ_2_Vector4[1];
            float _Split_86ec1aefda4f9e8e82b79c6195b397b0_B_3_Float = _PlanarNM_819c993d9b62a28ea640d2bacdc62c6e_XZ_2_Vector4[2];
            float _Split_86ec1aefda4f9e8e82b79c6195b397b0_A_4_Float = _PlanarNM_819c993d9b62a28ea640d2bacdc62c6e_XZ_2_Vector4[3];
            float _Property_c9c6897e00458b8f8aa07df49fa519bc_Out_0_Float = _CoverHeightMapMin;
            float _Property_ab94650b8edd82828661fe99e3c0e849_Out_0_Float = _CoverHeightMapMax;
            float2 _Vector2_fe489f7321f6568686816b9eecbc16d1_Out_0_Vector2 = float2(_Property_c9c6897e00458b8f8aa07df49fa519bc_Out_0_Float, _Property_ab94650b8edd82828661fe99e3c0e849_Out_0_Float);
            float _Property_c1ab40024cb83b87960e4327efbd997f_Out_0_Float = _CoverHeightMapOffset;
            float2 _Add_4a359522fc231c83b55ef23f341b6fb3_Out_2_Vector2;
            Unity_Add_float2(_Vector2_fe489f7321f6568686816b9eecbc16d1_Out_0_Vector2, (_Property_c1ab40024cb83b87960e4327efbd997f_Out_0_Float.xx), _Add_4a359522fc231c83b55ef23f341b6fb3_Out_2_Vector2);
            float _Remap_5aee5b64d41562858dc7c42d8b748894_Out_3_Float;
            Unity_Remap_float(_Split_86ec1aefda4f9e8e82b79c6195b397b0_B_3_Float, float2 (0, 1), _Add_4a359522fc231c83b55ef23f341b6fb3_Out_2_Vector2, _Remap_5aee5b64d41562858dc7c42d8b748894_Out_3_Float);
            float _Multiply_f0228e1cfd9c858dbb36367f551733c4_Out_2_Float;
            Unity_Multiply_float_float(_Multiply_622e54e9a77b08839c0954ce5715ad1c_Out_2_Float, _Remap_5aee5b64d41562858dc7c42d8b748894_Out_3_Float, _Multiply_f0228e1cfd9c858dbb36367f551733c4_Out_2_Float);
            float _Multiply_bb4d60728db93b8a9af9635fa1d69891_Out_2_Float;
            Unity_Multiply_float_float(_Split_c34b73d933404283983f9c8bdb5365d3_B_3_Float, _Multiply_f0228e1cfd9c858dbb36367f551733c4_Out_2_Float, _Multiply_bb4d60728db93b8a9af9635fa1d69891_Out_2_Float);
            float _Saturate_9b052a9bb99eff89bb11bdc387a0c2fd_Out_1_Float;
            Unity_Saturate_float(_Multiply_bb4d60728db93b8a9af9635fa1d69891_Out_2_Float, _Saturate_9b052a9bb99eff89bb11bdc387a0c2fd_Out_1_Float);
            float _Multiply_22fb8c1cfd28b687a991e101aa13ff5b_Out_2_Float;
            Unity_Multiply_float_float(_Clamp_a78f6f28770afd869adb9d12cd47370b_Out_3_Float, _Saturate_9b052a9bb99eff89bb11bdc387a0c2fd_Out_1_Float, _Multiply_22fb8c1cfd28b687a991e101aa13ff5b_Out_2_Float);
            #if defined(_USEDYNAMICCOVERTSTATICMASKF_ON)
            float _UseDynamicCoverTStaticMaskF_20dcbac2f16cf78ebd6fd1debcd7f281_Out_0_Float = _Multiply_22fb8c1cfd28b687a991e101aa13ff5b_Out_2_Float;
            #else
            float _UseDynamicCoverTStaticMaskF_20dcbac2f16cf78ebd6fd1debcd7f281_Out_0_Float = _Clamp_a78f6f28770afd869adb9d12cd47370b_Out_3_Float;
            #endif
            float3 _Lerp_e5620b57c917728fa1416e2ffce9b0db_Out_3_Vector3;
            Unity_Lerp_float3(_HeightBlend_7501025b3a60738a9a9d362e35a9ab48_OutVector4_1_Vector3, (_Multiply_a38ba695a2660c8691763f0bd7fe159c_Out_2_Vector4.xyz), (_UseDynamicCoverTStaticMaskF_20dcbac2f16cf78ebd6fd1debcd7f281_Out_0_Float.xxx), _Lerp_e5620b57c917728fa1416e2ffce9b0db_Out_3_Vector3);
            float4 _Property_7946b761100c49199abc52129949bc94_Out_0_Vector4 = _WetColor;
            float3 _Multiply_f722561c89f8451497c9823ad4f29f4a_Out_2_Vector3;
            Unity_Multiply_float3_float3((_Property_7946b761100c49199abc52129949bc94_Out_0_Vector4.xyz), _Lerp_e5620b57c917728fa1416e2ffce9b0db_Out_3_Vector3, _Multiply_f722561c89f8451497c9823ad4f29f4a_Out_2_Vector3);
            float _OneMinus_6ed96e068e394cd09ae03c32446777c8_Out_1_Float;
            Unity_OneMinus_float(_Split_c34b73d933404283983f9c8bdb5365d3_R_1_Float, _OneMinus_6ed96e068e394cd09ae03c32446777c8_Out_1_Float);
            float3 _Lerp_c16da1ee314d4393a798b1d36f6733d8_Out_3_Vector3;
            Unity_Lerp_float3(_Lerp_e5620b57c917728fa1416e2ffce9b0db_Out_3_Vector3, _Multiply_f722561c89f8451497c9823ad4f29f4a_Out_2_Vector3, (_OneMinus_6ed96e068e394cd09ae03c32446777c8_Out_1_Float.xxx), _Lerp_c16da1ee314d4393a798b1d36f6733d8_Out_3_Vector3);
            float _Split_c7a719bf7da79a8ea38d7311fd844f92_R_1_Float = _Multiply_f572ff0def2d308e87a64e94a46c0d96_Out_2_Vector4[0];
            float _Split_c7a719bf7da79a8ea38d7311fd844f92_G_2_Float = _Multiply_f572ff0def2d308e87a64e94a46c0d96_Out_2_Vector4[1];
            float _Split_c7a719bf7da79a8ea38d7311fd844f92_B_3_Float = _Multiply_f572ff0def2d308e87a64e94a46c0d96_Out_2_Vector4[2];
            float _Split_c7a719bf7da79a8ea38d7311fd844f92_A_4_Float = _Multiply_f572ff0def2d308e87a64e94a46c0d96_Out_2_Vector4[3];
            float _Property_7c5dae9b46c9e686b49e58fa996a104a_Out_0_Boolean = IgnoreBase2Alpha;
            float _Split_e9060f5c0433ec889696d3e462f3229b_R_1_Float = _Multiply_d2ec682582195e84acc4a8510f50f4b0_Out_2_Vector4[0];
            float _Split_e9060f5c0433ec889696d3e462f3229b_G_2_Float = _Multiply_d2ec682582195e84acc4a8510f50f4b0_Out_2_Vector4[1];
            float _Split_e9060f5c0433ec889696d3e462f3229b_B_3_Float = _Multiply_d2ec682582195e84acc4a8510f50f4b0_Out_2_Vector4[2];
            float _Split_e9060f5c0433ec889696d3e462f3229b_A_4_Float = _Multiply_d2ec682582195e84acc4a8510f50f4b0_Out_2_Vector4[3];
            float _Branch_a7d7aece30fd9b8eb456d191fdd37a06_Out_3_Float;
            Unity_Branch_float(_Property_7c5dae9b46c9e686b49e58fa996a104a_Out_0_Boolean, _Split_c7a719bf7da79a8ea38d7311fd844f92_A_4_Float, _Split_e9060f5c0433ec889696d3e462f3229b_A_4_Float, _Branch_a7d7aece30fd9b8eb456d191fdd37a06_Out_3_Float);
            float _Lerp_8692ca93f568998fbc97130b6dbc4556_Out_3_Float;
            Unity_Lerp_float(_Split_c7a719bf7da79a8ea38d7311fd844f92_A_4_Float, _Branch_a7d7aece30fd9b8eb456d191fdd37a06_Out_3_Float, _Multiply_74def30593cbbb8bbed03613a31cb89a_Out_2_Float, _Lerp_8692ca93f568998fbc97130b6dbc4556_Out_3_Float);
            float _Clamp_0c8b7b55b9f82588ab2dcff09ee7a16d_Out_3_Float;
            Unity_Clamp_float(_Lerp_8692ca93f568998fbc97130b6dbc4556_Out_3_Float, float(0), float(1), _Clamp_0c8b7b55b9f82588ab2dcff09ee7a16d_Out_3_Float);
            float _Multiply_6333dc4a6348088bb7281602ce6bff5f_Out_2_Float;
            Unity_Multiply_float_float(_Clamp_0c8b7b55b9f82588ab2dcff09ee7a16d_Out_3_Float, _Split_c34b73d933404283983f9c8bdb5365d3_A_4_Float, _Multiply_6333dc4a6348088bb7281602ce6bff5f_Out_2_Float);
            float _Clamp_9642b8fb7e32b18a91da1888c9bc375b_Out_3_Float;
            Unity_Clamp_float(_Multiply_6333dc4a6348088bb7281602ce6bff5f_Out_2_Float, float(0), float(1), _Clamp_9642b8fb7e32b18a91da1888c9bc375b_Out_3_Float);
            float _Property_8bc98dd454a5508b9864a6ba09772356_Out_0_Float = _AlphaCutoff;
            surface.BaseColor = _Lerp_c16da1ee314d4393a798b1d36f6733d8_Out_3_Vector3;
            surface.Emission = float3(0, 0, 0);
            surface.Alpha = _Clamp_9642b8fb7e32b18a91da1888c9bc375b_Out_3_Float;
            surface.AlphaClipThreshold = _Property_8bc98dd454a5508b9864a6ba09772356_Out_0_Float;
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
        #pragma shader_feature_local _ _USEDYNAMICCOVERTSTATICMASKF_ON
        
        #if defined(_USEDYNAMICCOVERTSTATICMASKF_ON)
            #define KEYWORD_PERMUTATION_0
        #else
            #define KEYWORD_PERMUTATION_1
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
             float4 texCoord0 : INTERP0;
             float4 texCoord3 : INTERP1;
             float4 color : INTERP2;
             float3 positionWS : INTERP3;
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
            output.texCoord0.xyzw = input.texCoord0;
            output.texCoord3.xyzw = input.texCoord3;
            output.color.xyzw = input.color;
            output.positionWS.xyz = input.positionWS;
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
            output.texCoord0 = input.texCoord0.xyzw;
            output.texCoord3 = input.texCoord3.xyzw;
            output.color = input.color.xyzw;
            output.positionWS = input.positionWS.xyz;
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
        float4 _WetColor;
        float _WetSmoothness;
        float _AlphaCutoff;
        float4 _BaseColor;
        float4 _BaseColorMap_TexelSize;
        float _BaseUsePlanarUV;
        float4 _BaseTilingOffset;
        float4 _BaseNormalMap_TexelSize;
        float _BaseNormalScale;
        float4 _BaseMaskMap_TexelSize;
        float _BaseMetallic;
        float _BaseAORemapMin;
        float _BaseAORemapMax;
        float _BaseSmoothnessRemapMin;
        float _BaseSmoothnessRemapMax;
        float4 _LayerMask_TexelSize;
        float _Invert_Layer_Mask;
        float _Height_Transition;
        float _HeightMin;
        float _HeightMax;
        float _HeightOffset;
        float _HeightMin2;
        float _HeightMax2;
        float _HeightOffset2;
        float IgnoreBase2Alpha;
        float4 _Base2Color;
        float4 _Base2ColorMap_TexelSize;
        float4 _Base2TilingOffset;
        float _Base2UsePlanarUV;
        float4 _Base2NormalMap_TexelSize;
        float _Base2NormalScale;
        float4 _Base2MaskMap_TexelSize;
        float _Base2Metallic;
        float _Base2SmoothnessRemapMin;
        float _Base2SmoothnessRemapMax;
        float _Base2AORemapMin;
        float _Base2AORemapMax;
        float _CoverMaskPower;
        float _Cover_Amount;
        float _Cover_Amount_Grow_Speed;
        float _Cover_Max_Angle;
        float _Cover_Min_Height;
        float _Cover_Min_Height_Blending;
        float4 _CoverBaseColor;
        float4 _CoverBaseColorMap_TexelSize;
        float4 _CoverTilingOffset;
        float _CoverUsePlanarUV;
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
        UNITY_TEXTURE_STREAMING_DEBUG_VARS;
        CBUFFER_END
        
        
        // Object and Global properties
        SAMPLER(SamplerState_Linear_Repeat);
        SAMPLER(SamplerState_Linear_Repeat_Aniso8);
        TEXTURE2D(_BaseColorMap);
        SAMPLER(sampler_BaseColorMap);
        TEXTURE2D(_BaseNormalMap);
        SAMPLER(sampler_BaseNormalMap);
        TEXTURE2D(_BaseMaskMap);
        SAMPLER(sampler_BaseMaskMap);
        TEXTURE2D(_LayerMask);
        SAMPLER(sampler_LayerMask);
        TEXTURE2D(_Base2ColorMap);
        SAMPLER(sampler_Base2ColorMap);
        TEXTURE2D(_Base2NormalMap);
        SAMPLER(sampler_Base2NormalMap);
        TEXTURE2D(_Base2MaskMap);
        SAMPLER(sampler_Base2MaskMap);
        TEXTURE2D(_CoverBaseColorMap);
        SAMPLER(sampler_CoverBaseColorMap);
        TEXTURE2D(_CoverNormalMap);
        SAMPLER(sampler_CoverNormalMap);
        TEXTURE2D(_CoverMaskMap);
        SAMPLER(sampler_CoverMaskMap);
        
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
        
        void Unity_Branch_float(float Predicate, float True, float False, out float Out)
        {
            Out = Predicate ? True : False;
        }
        
        void Unity_OneMinus_float(float In, out float Out)
        {
            Out = 1 - In;
        }
        
        void Unity_Add_float2(float2 A, float2 B, out float2 Out)
        {
            Out = A + B;
        }
        
        void Unity_Remap_float(float In, float2 InMinMax, float2 OutMinMax, out float Out)
        {
            Out = OutMinMax.x + (In - InMinMax.x) * (OutMinMax.y - OutMinMax.x) / (InMinMax.y - InMinMax.x);
        }
        
        void Unity_Multiply_float_float(float A, float B, out float Out)
        {
            Out = A * B;
        }
        
        void Unity_Lerp_float(float A, float B, float T, out float Out)
        {
            Out = lerp(A, B, T);
        }
        
        void Unity_Clamp_float(float In, float Min, float Max, out float Out)
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
            UnityTexture2D _Property_07d75b1d2628da808a2efb93a1d6219e_Out_0_Texture2D = UnityBuildTexture2DStructNoScale(_BaseColorMap);
            float4 _Property_587a28253857318a9b2e59bfc8fb56a4_Out_0_Vector4 = _BaseTilingOffset;
            float _Property_7f998178363b4188ba2f07298ef869c1_Out_0_Boolean = _BaseUsePlanarUV;
            Bindings_PlanarNM_c0f081da9c567704ea36e7dd38cedcf6_float _PlanarNM_0b8fbae0d009788d8cd595a3b9bf9f6e;
            _PlanarNM_0b8fbae0d009788d8cd595a3b9bf9f6e.AbsoluteWorldSpacePosition = IN.AbsoluteWorldSpacePosition;
            _PlanarNM_0b8fbae0d009788d8cd595a3b9bf9f6e.uv0 = IN.uv0;
            _PlanarNM_0b8fbae0d009788d8cd595a3b9bf9f6e.uv3 = IN.uv3;
            float4 _PlanarNM_0b8fbae0d009788d8cd595a3b9bf9f6e_XZ_2_Vector4;
            SG_PlanarNM_c0f081da9c567704ea36e7dd38cedcf6_float(_Property_07d75b1d2628da808a2efb93a1d6219e_Out_0_Texture2D, _Property_587a28253857318a9b2e59bfc8fb56a4_Out_0_Vector4, _Property_7f998178363b4188ba2f07298ef869c1_Out_0_Boolean, UnityBuildSamplerStateStruct(SamplerState_Linear_Repeat_Aniso8), 1, _PlanarNM_0b8fbae0d009788d8cd595a3b9bf9f6e, _PlanarNM_0b8fbae0d009788d8cd595a3b9bf9f6e_XZ_2_Vector4);
            float4 _Property_b83097c58639858680bf43881a95b0af_Out_0_Vector4 = _BaseColor;
            float4 _Multiply_f572ff0def2d308e87a64e94a46c0d96_Out_2_Vector4;
            Unity_Multiply_float4_float4(_PlanarNM_0b8fbae0d009788d8cd595a3b9bf9f6e_XZ_2_Vector4, _Property_b83097c58639858680bf43881a95b0af_Out_0_Vector4, _Multiply_f572ff0def2d308e87a64e94a46c0d96_Out_2_Vector4);
            float _Split_c7a719bf7da79a8ea38d7311fd844f92_R_1_Float = _Multiply_f572ff0def2d308e87a64e94a46c0d96_Out_2_Vector4[0];
            float _Split_c7a719bf7da79a8ea38d7311fd844f92_G_2_Float = _Multiply_f572ff0def2d308e87a64e94a46c0d96_Out_2_Vector4[1];
            float _Split_c7a719bf7da79a8ea38d7311fd844f92_B_3_Float = _Multiply_f572ff0def2d308e87a64e94a46c0d96_Out_2_Vector4[2];
            float _Split_c7a719bf7da79a8ea38d7311fd844f92_A_4_Float = _Multiply_f572ff0def2d308e87a64e94a46c0d96_Out_2_Vector4[3];
            float _Property_7c5dae9b46c9e686b49e58fa996a104a_Out_0_Boolean = IgnoreBase2Alpha;
            UnityTexture2D _Property_ba3a5f4cba7d0a8fa288ffc8267d6c0e_Out_0_Texture2D = UnityBuildTexture2DStructNoScale(_Base2ColorMap);
            float4 _Property_86a4657df480d48e8d3ad3b036731380_Out_0_Vector4 = _Base2TilingOffset;
            float _Property_6c5e16c615cab08a97c2a577642b9d83_Out_0_Boolean = _Base2UsePlanarUV;
            Bindings_PlanarNM_c0f081da9c567704ea36e7dd38cedcf6_float _PlanarNM_5aeab444ca6fd78ea56a01215880a5a4;
            _PlanarNM_5aeab444ca6fd78ea56a01215880a5a4.AbsoluteWorldSpacePosition = IN.AbsoluteWorldSpacePosition;
            _PlanarNM_5aeab444ca6fd78ea56a01215880a5a4.uv0 = IN.uv0;
            _PlanarNM_5aeab444ca6fd78ea56a01215880a5a4.uv3 = IN.uv3;
            float4 _PlanarNM_5aeab444ca6fd78ea56a01215880a5a4_XZ_2_Vector4;
            SG_PlanarNM_c0f081da9c567704ea36e7dd38cedcf6_float(_Property_ba3a5f4cba7d0a8fa288ffc8267d6c0e_Out_0_Texture2D, _Property_86a4657df480d48e8d3ad3b036731380_Out_0_Vector4, _Property_6c5e16c615cab08a97c2a577642b9d83_Out_0_Boolean, UnityBuildSamplerStateStruct(SamplerState_Linear_Repeat_Aniso8), 1, _PlanarNM_5aeab444ca6fd78ea56a01215880a5a4, _PlanarNM_5aeab444ca6fd78ea56a01215880a5a4_XZ_2_Vector4);
            float4 _Property_3561b11b899bda8e855826445cf628aa_Out_0_Vector4 = _Base2Color;
            float4 _Multiply_d2ec682582195e84acc4a8510f50f4b0_Out_2_Vector4;
            Unity_Multiply_float4_float4(_PlanarNM_5aeab444ca6fd78ea56a01215880a5a4_XZ_2_Vector4, _Property_3561b11b899bda8e855826445cf628aa_Out_0_Vector4, _Multiply_d2ec682582195e84acc4a8510f50f4b0_Out_2_Vector4);
            float _Split_e9060f5c0433ec889696d3e462f3229b_R_1_Float = _Multiply_d2ec682582195e84acc4a8510f50f4b0_Out_2_Vector4[0];
            float _Split_e9060f5c0433ec889696d3e462f3229b_G_2_Float = _Multiply_d2ec682582195e84acc4a8510f50f4b0_Out_2_Vector4[1];
            float _Split_e9060f5c0433ec889696d3e462f3229b_B_3_Float = _Multiply_d2ec682582195e84acc4a8510f50f4b0_Out_2_Vector4[2];
            float _Split_e9060f5c0433ec889696d3e462f3229b_A_4_Float = _Multiply_d2ec682582195e84acc4a8510f50f4b0_Out_2_Vector4[3];
            float _Branch_a7d7aece30fd9b8eb456d191fdd37a06_Out_3_Float;
            Unity_Branch_float(_Property_7c5dae9b46c9e686b49e58fa996a104a_Out_0_Boolean, _Split_c7a719bf7da79a8ea38d7311fd844f92_A_4_Float, _Split_e9060f5c0433ec889696d3e462f3229b_A_4_Float, _Branch_a7d7aece30fd9b8eb456d191fdd37a06_Out_3_Float);
            float _Split_c34b73d933404283983f9c8bdb5365d3_R_1_Float = IN.VertexColor[0];
            float _Split_c34b73d933404283983f9c8bdb5365d3_G_2_Float = IN.VertexColor[1];
            float _Split_c34b73d933404283983f9c8bdb5365d3_B_3_Float = IN.VertexColor[2];
            float _Split_c34b73d933404283983f9c8bdb5365d3_A_4_Float = IN.VertexColor[3];
            float _Property_df2df7bb5cfc3381beee7ec454da7542_Out_0_Boolean = _Invert_Layer_Mask;
            UnityTexture2D _Property_c7b1e2df9f9b0e8eace9b2274924e69c_Out_0_Texture2D = UnityBuildTexture2DStructNoScale(_LayerMask);
            float4 _SampleTexture2D_175fb18fafc9598382f1f5f7e97bf30a_RGBA_0_Vector4 = SAMPLE_TEXTURE2D(_Property_c7b1e2df9f9b0e8eace9b2274924e69c_Out_0_Texture2D.tex, _Property_c7b1e2df9f9b0e8eace9b2274924e69c_Out_0_Texture2D.samplerstate, _Property_c7b1e2df9f9b0e8eace9b2274924e69c_Out_0_Texture2D.GetTransformedUV(IN.uv0.xy) );
            float _SampleTexture2D_175fb18fafc9598382f1f5f7e97bf30a_R_4_Float = _SampleTexture2D_175fb18fafc9598382f1f5f7e97bf30a_RGBA_0_Vector4.r;
            float _SampleTexture2D_175fb18fafc9598382f1f5f7e97bf30a_G_5_Float = _SampleTexture2D_175fb18fafc9598382f1f5f7e97bf30a_RGBA_0_Vector4.g;
            float _SampleTexture2D_175fb18fafc9598382f1f5f7e97bf30a_B_6_Float = _SampleTexture2D_175fb18fafc9598382f1f5f7e97bf30a_RGBA_0_Vector4.b;
            float _SampleTexture2D_175fb18fafc9598382f1f5f7e97bf30a_A_7_Float = _SampleTexture2D_175fb18fafc9598382f1f5f7e97bf30a_RGBA_0_Vector4.a;
            float _OneMinus_ce5c3c0635d4ac86beb55115d0ebaed7_Out_1_Float;
            Unity_OneMinus_float(_SampleTexture2D_175fb18fafc9598382f1f5f7e97bf30a_R_4_Float, _OneMinus_ce5c3c0635d4ac86beb55115d0ebaed7_Out_1_Float);
            float _Branch_af0c5e511241ce8eae748ae487df50fa_Out_3_Float;
            Unity_Branch_float(_Property_df2df7bb5cfc3381beee7ec454da7542_Out_0_Boolean, _OneMinus_ce5c3c0635d4ac86beb55115d0ebaed7_Out_1_Float, _SampleTexture2D_175fb18fafc9598382f1f5f7e97bf30a_R_4_Float, _Branch_af0c5e511241ce8eae748ae487df50fa_Out_3_Float);
            UnityTexture2D _Property_de4f6eb48a629285a664dad7fb06438f_Out_0_Texture2D = UnityBuildTexture2DStructNoScale(_Base2MaskMap);
            Bindings_PlanarNM_c0f081da9c567704ea36e7dd38cedcf6_float _PlanarNM_d5657f470f05ef839e4c257a20ace8cb;
            _PlanarNM_d5657f470f05ef839e4c257a20ace8cb.AbsoluteWorldSpacePosition = IN.AbsoluteWorldSpacePosition;
            _PlanarNM_d5657f470f05ef839e4c257a20ace8cb.uv0 = IN.uv0;
            _PlanarNM_d5657f470f05ef839e4c257a20ace8cb.uv3 = IN.uv3;
            float4 _PlanarNM_d5657f470f05ef839e4c257a20ace8cb_XZ_2_Vector4;
            SG_PlanarNM_c0f081da9c567704ea36e7dd38cedcf6_float(_Property_de4f6eb48a629285a664dad7fb06438f_Out_0_Texture2D, _Property_86a4657df480d48e8d3ad3b036731380_Out_0_Vector4, _Property_6c5e16c615cab08a97c2a577642b9d83_Out_0_Boolean, UnityBuildSamplerStateStruct(SamplerState_Linear_Repeat_Aniso8), 1, _PlanarNM_d5657f470f05ef839e4c257a20ace8cb, _PlanarNM_d5657f470f05ef839e4c257a20ace8cb_XZ_2_Vector4);
            float _Split_83ec66b648ab6c84848b42686c256cd7_R_1_Float = _PlanarNM_d5657f470f05ef839e4c257a20ace8cb_XZ_2_Vector4[0];
            float _Split_83ec66b648ab6c84848b42686c256cd7_G_2_Float = _PlanarNM_d5657f470f05ef839e4c257a20ace8cb_XZ_2_Vector4[1];
            float _Split_83ec66b648ab6c84848b42686c256cd7_B_3_Float = _PlanarNM_d5657f470f05ef839e4c257a20ace8cb_XZ_2_Vector4[2];
            float _Split_83ec66b648ab6c84848b42686c256cd7_A_4_Float = _PlanarNM_d5657f470f05ef839e4c257a20ace8cb_XZ_2_Vector4[3];
            float _Property_ce1750e5c69e97818667b412fc3f9f2c_Out_0_Float = _HeightMin2;
            float _Property_8e0f2ea54d8ede89bbabdf31a9bafd57_Out_0_Float = _HeightMax2;
            float2 _Vector2_fb6c6dd7e70e768ba686e8e94153bb96_Out_0_Vector2 = float2(_Property_ce1750e5c69e97818667b412fc3f9f2c_Out_0_Float, _Property_8e0f2ea54d8ede89bbabdf31a9bafd57_Out_0_Float);
            float _Property_151ae2702b614585af2000f0a812960f_Out_0_Float = _HeightOffset2;
            float2 _Add_fd1b3d8e24e77087a55888eeb238f1a6_Out_2_Vector2;
            Unity_Add_float2(_Vector2_fb6c6dd7e70e768ba686e8e94153bb96_Out_0_Vector2, (_Property_151ae2702b614585af2000f0a812960f_Out_0_Float.xx), _Add_fd1b3d8e24e77087a55888eeb238f1a6_Out_2_Vector2);
            float _Remap_3d4180c0ab36ba86a5517b2645f0bfa7_Out_3_Float;
            Unity_Remap_float(_Split_83ec66b648ab6c84848b42686c256cd7_B_3_Float, float2 (0, 1), _Add_fd1b3d8e24e77087a55888eeb238f1a6_Out_2_Vector2, _Remap_3d4180c0ab36ba86a5517b2645f0bfa7_Out_3_Float);
            float _Multiply_2cb0e5aa384654828f0453a44884573c_Out_2_Float;
            Unity_Multiply_float_float(_Branch_af0c5e511241ce8eae748ae487df50fa_Out_3_Float, _Remap_3d4180c0ab36ba86a5517b2645f0bfa7_Out_3_Float, _Multiply_2cb0e5aa384654828f0453a44884573c_Out_2_Float);
            float _Multiply_74def30593cbbb8bbed03613a31cb89a_Out_2_Float;
            Unity_Multiply_float_float(_Split_c34b73d933404283983f9c8bdb5365d3_G_2_Float, _Multiply_2cb0e5aa384654828f0453a44884573c_Out_2_Float, _Multiply_74def30593cbbb8bbed03613a31cb89a_Out_2_Float);
            float _Lerp_8692ca93f568998fbc97130b6dbc4556_Out_3_Float;
            Unity_Lerp_float(_Split_c7a719bf7da79a8ea38d7311fd844f92_A_4_Float, _Branch_a7d7aece30fd9b8eb456d191fdd37a06_Out_3_Float, _Multiply_74def30593cbbb8bbed03613a31cb89a_Out_2_Float, _Lerp_8692ca93f568998fbc97130b6dbc4556_Out_3_Float);
            float _Clamp_0c8b7b55b9f82588ab2dcff09ee7a16d_Out_3_Float;
            Unity_Clamp_float(_Lerp_8692ca93f568998fbc97130b6dbc4556_Out_3_Float, float(0), float(1), _Clamp_0c8b7b55b9f82588ab2dcff09ee7a16d_Out_3_Float);
            float _Multiply_6333dc4a6348088bb7281602ce6bff5f_Out_2_Float;
            Unity_Multiply_float_float(_Clamp_0c8b7b55b9f82588ab2dcff09ee7a16d_Out_3_Float, _Split_c34b73d933404283983f9c8bdb5365d3_A_4_Float, _Multiply_6333dc4a6348088bb7281602ce6bff5f_Out_2_Float);
            float _Clamp_9642b8fb7e32b18a91da1888c9bc375b_Out_3_Float;
            Unity_Clamp_float(_Multiply_6333dc4a6348088bb7281602ce6bff5f_Out_2_Float, float(0), float(1), _Clamp_9642b8fb7e32b18a91da1888c9bc375b_Out_3_Float);
            float _Property_8bc98dd454a5508b9864a6ba09772356_Out_0_Float = _AlphaCutoff;
            surface.Alpha = _Clamp_9642b8fb7e32b18a91da1888c9bc375b_Out_3_Float;
            surface.AlphaClipThreshold = _Property_8bc98dd454a5508b9864a6ba09772356_Out_0_Float;
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
        #pragma shader_feature_local _ _USEDYNAMICCOVERTSTATICMASKF_ON
        
        #if defined(_USEDYNAMICCOVERTSTATICMASKF_ON)
            #define KEYWORD_PERMUTATION_0
        #else
            #define KEYWORD_PERMUTATION_1
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
        float4 _WetColor;
        float _WetSmoothness;
        float _AlphaCutoff;
        float4 _BaseColor;
        float4 _BaseColorMap_TexelSize;
        float _BaseUsePlanarUV;
        float4 _BaseTilingOffset;
        float4 _BaseNormalMap_TexelSize;
        float _BaseNormalScale;
        float4 _BaseMaskMap_TexelSize;
        float _BaseMetallic;
        float _BaseAORemapMin;
        float _BaseAORemapMax;
        float _BaseSmoothnessRemapMin;
        float _BaseSmoothnessRemapMax;
        float4 _LayerMask_TexelSize;
        float _Invert_Layer_Mask;
        float _Height_Transition;
        float _HeightMin;
        float _HeightMax;
        float _HeightOffset;
        float _HeightMin2;
        float _HeightMax2;
        float _HeightOffset2;
        float IgnoreBase2Alpha;
        float4 _Base2Color;
        float4 _Base2ColorMap_TexelSize;
        float4 _Base2TilingOffset;
        float _Base2UsePlanarUV;
        float4 _Base2NormalMap_TexelSize;
        float _Base2NormalScale;
        float4 _Base2MaskMap_TexelSize;
        float _Base2Metallic;
        float _Base2SmoothnessRemapMin;
        float _Base2SmoothnessRemapMax;
        float _Base2AORemapMin;
        float _Base2AORemapMax;
        float _CoverMaskPower;
        float _Cover_Amount;
        float _Cover_Amount_Grow_Speed;
        float _Cover_Max_Angle;
        float _Cover_Min_Height;
        float _Cover_Min_Height_Blending;
        float4 _CoverBaseColor;
        float4 _CoverBaseColorMap_TexelSize;
        float4 _CoverTilingOffset;
        float _CoverUsePlanarUV;
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
        UNITY_TEXTURE_STREAMING_DEBUG_VARS;
        CBUFFER_END
        
        
        // Object and Global properties
        SAMPLER(SamplerState_Linear_Repeat);
        SAMPLER(SamplerState_Linear_Repeat_Aniso8);
        TEXTURE2D(_BaseColorMap);
        SAMPLER(sampler_BaseColorMap);
        TEXTURE2D(_BaseNormalMap);
        SAMPLER(sampler_BaseNormalMap);
        TEXTURE2D(_BaseMaskMap);
        SAMPLER(sampler_BaseMaskMap);
        TEXTURE2D(_LayerMask);
        SAMPLER(sampler_LayerMask);
        TEXTURE2D(_Base2ColorMap);
        SAMPLER(sampler_Base2ColorMap);
        TEXTURE2D(_Base2NormalMap);
        SAMPLER(sampler_Base2NormalMap);
        TEXTURE2D(_Base2MaskMap);
        SAMPLER(sampler_Base2MaskMap);
        TEXTURE2D(_CoverBaseColorMap);
        SAMPLER(sampler_CoverBaseColorMap);
        TEXTURE2D(_CoverNormalMap);
        SAMPLER(sampler_CoverNormalMap);
        TEXTURE2D(_CoverMaskMap);
        SAMPLER(sampler_CoverMaskMap);
        
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
        
        void Unity_Add_float2(float2 A, float2 B, out float2 Out)
        {
            Out = A + B;
        }
        
        void Unity_Remap_float(float In, float2 InMinMax, float2 OutMinMax, out float Out)
        {
            Out = OutMinMax.x + (In - InMinMax.x) * (OutMinMax.y - OutMinMax.x) / (InMinMax.y - InMinMax.x);
        }
        
        void Unity_OneMinus_float(float In, out float Out)
        {
            Out = 1 - In;
        }
        
        void Unity_Branch_float(float Predicate, float True, float False, out float Out)
        {
            Out = Predicate ? True : False;
        }
        
        void Unity_Multiply_float_float(float A, float B, out float Out)
        {
            Out = A * B;
        }
        
        void Unity_Maximum_float(float A, float B, out float Out)
        {
            Out = max(A, B);
        }
        
        void Unity_Subtract_float(float A, float B, out float Out)
        {
            Out = A - B;
        }
        
        void Unity_Multiply_float3_float3(float3 A, float3 B, out float3 Out)
        {
        Out = A * B;
        }
        
        void Unity_Add_float3(float3 A, float3 B, out float3 Out)
        {
            Out = A + B;
        }
        
        void Unity_Add_float(float A, float B, out float Out)
        {
            Out = A + B;
        }
        
        void Unity_Divide_float3(float3 A, float3 B, out float3 Out)
        {
            Out = A / B;
        }
        
        struct Bindings_HeightBlend_d15b6fb865d3b6d4ebc1fd476c3ad135_float
        {
        };
        
        void SG_HeightBlend_d15b6fb865d3b6d4ebc1fd476c3ad135_float(float3 Vector3_88EEBB5E, float Vector1_DA0A37FA, float3 Vector3_79AA92F, float Vector1_F7E83F1E, float Vector1_1C9222A6, Bindings_HeightBlend_d15b6fb865d3b6d4ebc1fd476c3ad135_float IN, out float3 OutVector4_1)
        {
        float3 _Property_dd1c841a04c03f8c85e7b00eb025ecda_Out_0_Vector3 = Vector3_88EEBB5E;
        float _Property_14119cc7eaf4128f991283d47cf72d85_Out_0_Float = Vector1_DA0A37FA;
        float _Property_48af0ad45e3f7f82932b938695d21391_Out_0_Float = Vector1_DA0A37FA;
        float _Property_8a30b3ca12ff518fa473ccd686c7d503_Out_0_Float = Vector1_F7E83F1E;
        float _Maximum_c196e4a61637ea8381a3437c93f89ce2_Out_2_Float;
        Unity_Maximum_float(_Property_48af0ad45e3f7f82932b938695d21391_Out_0_Float, _Property_8a30b3ca12ff518fa473ccd686c7d503_Out_0_Float, _Maximum_c196e4a61637ea8381a3437c93f89ce2_Out_2_Float);
        float _Property_ee8d5fc69475d181be60c57e04ea8708_Out_0_Float = Vector1_1C9222A6;
        float _Subtract_61ca880c04c1758eb128f25c9faabd63_Out_2_Float;
        Unity_Subtract_float(_Maximum_c196e4a61637ea8381a3437c93f89ce2_Out_2_Float, _Property_ee8d5fc69475d181be60c57e04ea8708_Out_0_Float, _Subtract_61ca880c04c1758eb128f25c9faabd63_Out_2_Float);
        float _Subtract_e3a7713b556a1b8cb40aad97fc58d619_Out_2_Float;
        Unity_Subtract_float(_Property_14119cc7eaf4128f991283d47cf72d85_Out_0_Float, _Subtract_61ca880c04c1758eb128f25c9faabd63_Out_2_Float, _Subtract_e3a7713b556a1b8cb40aad97fc58d619_Out_2_Float);
        float _Maximum_d02e48d92038448cb0345e5cf3779071_Out_2_Float;
        Unity_Maximum_float(_Subtract_e3a7713b556a1b8cb40aad97fc58d619_Out_2_Float, float(0), _Maximum_d02e48d92038448cb0345e5cf3779071_Out_2_Float);
        float3 _Multiply_79b0b5d7d3528b8395e1135339a090f2_Out_2_Vector3;
        Unity_Multiply_float3_float3(_Property_dd1c841a04c03f8c85e7b00eb025ecda_Out_0_Vector3, (_Maximum_d02e48d92038448cb0345e5cf3779071_Out_2_Float.xxx), _Multiply_79b0b5d7d3528b8395e1135339a090f2_Out_2_Vector3);
        float3 _Property_c7292b3b08585f8c8670172b9a220bf0_Out_0_Vector3 = Vector3_79AA92F;
        float _Property_5e920479576fad83ba1947728dcceab4_Out_0_Float = Vector1_F7E83F1E;
        float _Subtract_b7368f21be9e048aae7f90c8a2bfaae1_Out_2_Float;
        Unity_Subtract_float(_Property_5e920479576fad83ba1947728dcceab4_Out_0_Float, _Subtract_61ca880c04c1758eb128f25c9faabd63_Out_2_Float, _Subtract_b7368f21be9e048aae7f90c8a2bfaae1_Out_2_Float);
        float _Maximum_216777d30802328eab607c8fe68ba3a1_Out_2_Float;
        Unity_Maximum_float(_Subtract_b7368f21be9e048aae7f90c8a2bfaae1_Out_2_Float, float(0), _Maximum_216777d30802328eab607c8fe68ba3a1_Out_2_Float);
        float3 _Multiply_a856b52cd0848f86a6ae1af9b175935c_Out_2_Vector3;
        Unity_Multiply_float3_float3(_Property_c7292b3b08585f8c8670172b9a220bf0_Out_0_Vector3, (_Maximum_216777d30802328eab607c8fe68ba3a1_Out_2_Float.xxx), _Multiply_a856b52cd0848f86a6ae1af9b175935c_Out_2_Vector3);
        float3 _Add_86c6109dc4530b8c9763ef62b056ad4c_Out_2_Vector3;
        Unity_Add_float3(_Multiply_79b0b5d7d3528b8395e1135339a090f2_Out_2_Vector3, _Multiply_a856b52cd0848f86a6ae1af9b175935c_Out_2_Vector3, _Add_86c6109dc4530b8c9763ef62b056ad4c_Out_2_Vector3);
        float _Add_356384b52728f583bd6e694bc1fc3738_Out_2_Float;
        Unity_Add_float(_Maximum_d02e48d92038448cb0345e5cf3779071_Out_2_Float, _Maximum_216777d30802328eab607c8fe68ba3a1_Out_2_Float, _Add_356384b52728f583bd6e694bc1fc3738_Out_2_Float);
        float _Maximum_94a22f5ceb706e88bc16350a5d5d2a82_Out_2_Float;
        Unity_Maximum_float(_Add_356384b52728f583bd6e694bc1fc3738_Out_2_Float, float(1E-05), _Maximum_94a22f5ceb706e88bc16350a5d5d2a82_Out_2_Float);
        float3 _Divide_d7291d1701d7058dbb5263194c1bed22_Out_2_Vector3;
        Unity_Divide_float3(_Add_86c6109dc4530b8c9763ef62b056ad4c_Out_2_Vector3, (_Maximum_94a22f5ceb706e88bc16350a5d5d2a82_Out_2_Float.xxx), _Divide_d7291d1701d7058dbb5263194c1bed22_Out_2_Vector3);
        OutVector4_1 = _Divide_d7291d1701d7058dbb5263194c1bed22_Out_2_Vector3;
        }
        
        void Unity_Clamp_float(float In, float Min, float Max, out float Out)
        {
            Out = clamp(In, Min, Max);
        }
        
        void Unity_Sign_float3(float3 In, out float3 Out)
        {
            Out = sign(In);
        }
        
        void Unity_Multiply_float2_float2(float2 A, float2 B, out float2 Out)
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
        
        void Unity_Absolute_float(float In, out float Out)
        {
            Out = abs(In);
        }
        
        void Unity_Power_float(float A, float B, out float Out)
        {
            Out = pow(A, B);
        }
        
        void Unity_Saturate_float(float In, out float Out)
        {
            Out = saturate(In);
        }
        
        void Unity_Lerp_float3(float3 A, float3 B, float3 T, out float3 Out)
        {
            Out = lerp(A, B, T);
        }
        
        void Unity_Lerp_float(float A, float B, float T, out float Out)
        {
            Out = lerp(A, B, T);
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
            UnityTexture2D _Property_07d75b1d2628da808a2efb93a1d6219e_Out_0_Texture2D = UnityBuildTexture2DStructNoScale(_BaseColorMap);
            float4 _Property_587a28253857318a9b2e59bfc8fb56a4_Out_0_Vector4 = _BaseTilingOffset;
            float _Property_7f998178363b4188ba2f07298ef869c1_Out_0_Boolean = _BaseUsePlanarUV;
            Bindings_PlanarNM_c0f081da9c567704ea36e7dd38cedcf6_float _PlanarNM_0b8fbae0d009788d8cd595a3b9bf9f6e;
            _PlanarNM_0b8fbae0d009788d8cd595a3b9bf9f6e.AbsoluteWorldSpacePosition = IN.AbsoluteWorldSpacePosition;
            _PlanarNM_0b8fbae0d009788d8cd595a3b9bf9f6e.uv0 = IN.uv0;
            _PlanarNM_0b8fbae0d009788d8cd595a3b9bf9f6e.uv3 = IN.uv3;
            float4 _PlanarNM_0b8fbae0d009788d8cd595a3b9bf9f6e_XZ_2_Vector4;
            SG_PlanarNM_c0f081da9c567704ea36e7dd38cedcf6_float(_Property_07d75b1d2628da808a2efb93a1d6219e_Out_0_Texture2D, _Property_587a28253857318a9b2e59bfc8fb56a4_Out_0_Vector4, _Property_7f998178363b4188ba2f07298ef869c1_Out_0_Boolean, UnityBuildSamplerStateStruct(SamplerState_Linear_Repeat_Aniso8), 1, _PlanarNM_0b8fbae0d009788d8cd595a3b9bf9f6e, _PlanarNM_0b8fbae0d009788d8cd595a3b9bf9f6e_XZ_2_Vector4);
            float4 _Property_b83097c58639858680bf43881a95b0af_Out_0_Vector4 = _BaseColor;
            float4 _Multiply_f572ff0def2d308e87a64e94a46c0d96_Out_2_Vector4;
            Unity_Multiply_float4_float4(_PlanarNM_0b8fbae0d009788d8cd595a3b9bf9f6e_XZ_2_Vector4, _Property_b83097c58639858680bf43881a95b0af_Out_0_Vector4, _Multiply_f572ff0def2d308e87a64e94a46c0d96_Out_2_Vector4);
            UnityTexture2D _Property_1e449ff9f8e8ec828507233e8240eb11_Out_0_Texture2D = UnityBuildTexture2DStructNoScale(_BaseMaskMap);
            Bindings_PlanarNM_c0f081da9c567704ea36e7dd38cedcf6_float _PlanarNM_4245c3b264047180b5c90a697d6cb278;
            _PlanarNM_4245c3b264047180b5c90a697d6cb278.AbsoluteWorldSpacePosition = IN.AbsoluteWorldSpacePosition;
            _PlanarNM_4245c3b264047180b5c90a697d6cb278.uv0 = IN.uv0;
            _PlanarNM_4245c3b264047180b5c90a697d6cb278.uv3 = IN.uv3;
            float4 _PlanarNM_4245c3b264047180b5c90a697d6cb278_XZ_2_Vector4;
            SG_PlanarNM_c0f081da9c567704ea36e7dd38cedcf6_float(_Property_1e449ff9f8e8ec828507233e8240eb11_Out_0_Texture2D, _Property_587a28253857318a9b2e59bfc8fb56a4_Out_0_Vector4, _Property_7f998178363b4188ba2f07298ef869c1_Out_0_Boolean, UnityBuildSamplerStateStruct(SamplerState_Linear_Repeat_Aniso8), 1, _PlanarNM_4245c3b264047180b5c90a697d6cb278, _PlanarNM_4245c3b264047180b5c90a697d6cb278_XZ_2_Vector4);
            float _Split_91a015dea8acd38b904ba0935328a5bc_R_1_Float = _PlanarNM_4245c3b264047180b5c90a697d6cb278_XZ_2_Vector4[0];
            float _Split_91a015dea8acd38b904ba0935328a5bc_G_2_Float = _PlanarNM_4245c3b264047180b5c90a697d6cb278_XZ_2_Vector4[1];
            float _Split_91a015dea8acd38b904ba0935328a5bc_B_3_Float = _PlanarNM_4245c3b264047180b5c90a697d6cb278_XZ_2_Vector4[2];
            float _Split_91a015dea8acd38b904ba0935328a5bc_A_4_Float = _PlanarNM_4245c3b264047180b5c90a697d6cb278_XZ_2_Vector4[3];
            float _Property_fbcff1469ebf488394a8a89ddaf0eb2a_Out_0_Float = _HeightMin;
            float _Property_9df7a44c8225168683743ac60c0c3c34_Out_0_Float = _HeightMax;
            float2 _Vector2_9b1e95888c28bc8893f28c02b87fa448_Out_0_Vector2 = float2(_Property_fbcff1469ebf488394a8a89ddaf0eb2a_Out_0_Float, _Property_9df7a44c8225168683743ac60c0c3c34_Out_0_Float);
            float _Property_29ca14fd0b712983a38d63d2dd326e96_Out_0_Float = _HeightOffset;
            float2 _Add_cb503f8a09720d84bb03cbd89e37b80c_Out_2_Vector2;
            Unity_Add_float2(_Vector2_9b1e95888c28bc8893f28c02b87fa448_Out_0_Vector2, (_Property_29ca14fd0b712983a38d63d2dd326e96_Out_0_Float.xx), _Add_cb503f8a09720d84bb03cbd89e37b80c_Out_2_Vector2);
            float _Remap_18f2e96a438d6584ae2fd56f880de9ee_Out_3_Float;
            Unity_Remap_float(_Split_91a015dea8acd38b904ba0935328a5bc_B_3_Float, float2 (0, 1), _Add_cb503f8a09720d84bb03cbd89e37b80c_Out_2_Vector2, _Remap_18f2e96a438d6584ae2fd56f880de9ee_Out_3_Float);
            UnityTexture2D _Property_ba3a5f4cba7d0a8fa288ffc8267d6c0e_Out_0_Texture2D = UnityBuildTexture2DStructNoScale(_Base2ColorMap);
            float4 _Property_86a4657df480d48e8d3ad3b036731380_Out_0_Vector4 = _Base2TilingOffset;
            float _Property_6c5e16c615cab08a97c2a577642b9d83_Out_0_Boolean = _Base2UsePlanarUV;
            Bindings_PlanarNM_c0f081da9c567704ea36e7dd38cedcf6_float _PlanarNM_5aeab444ca6fd78ea56a01215880a5a4;
            _PlanarNM_5aeab444ca6fd78ea56a01215880a5a4.AbsoluteWorldSpacePosition = IN.AbsoluteWorldSpacePosition;
            _PlanarNM_5aeab444ca6fd78ea56a01215880a5a4.uv0 = IN.uv0;
            _PlanarNM_5aeab444ca6fd78ea56a01215880a5a4.uv3 = IN.uv3;
            float4 _PlanarNM_5aeab444ca6fd78ea56a01215880a5a4_XZ_2_Vector4;
            SG_PlanarNM_c0f081da9c567704ea36e7dd38cedcf6_float(_Property_ba3a5f4cba7d0a8fa288ffc8267d6c0e_Out_0_Texture2D, _Property_86a4657df480d48e8d3ad3b036731380_Out_0_Vector4, _Property_6c5e16c615cab08a97c2a577642b9d83_Out_0_Boolean, UnityBuildSamplerStateStruct(SamplerState_Linear_Repeat_Aniso8), 1, _PlanarNM_5aeab444ca6fd78ea56a01215880a5a4, _PlanarNM_5aeab444ca6fd78ea56a01215880a5a4_XZ_2_Vector4);
            float4 _Property_3561b11b899bda8e855826445cf628aa_Out_0_Vector4 = _Base2Color;
            float4 _Multiply_d2ec682582195e84acc4a8510f50f4b0_Out_2_Vector4;
            Unity_Multiply_float4_float4(_PlanarNM_5aeab444ca6fd78ea56a01215880a5a4_XZ_2_Vector4, _Property_3561b11b899bda8e855826445cf628aa_Out_0_Vector4, _Multiply_d2ec682582195e84acc4a8510f50f4b0_Out_2_Vector4);
            float _Split_c34b73d933404283983f9c8bdb5365d3_R_1_Float = IN.VertexColor[0];
            float _Split_c34b73d933404283983f9c8bdb5365d3_G_2_Float = IN.VertexColor[1];
            float _Split_c34b73d933404283983f9c8bdb5365d3_B_3_Float = IN.VertexColor[2];
            float _Split_c34b73d933404283983f9c8bdb5365d3_A_4_Float = IN.VertexColor[3];
            float _Property_df2df7bb5cfc3381beee7ec454da7542_Out_0_Boolean = _Invert_Layer_Mask;
            UnityTexture2D _Property_c7b1e2df9f9b0e8eace9b2274924e69c_Out_0_Texture2D = UnityBuildTexture2DStructNoScale(_LayerMask);
            float4 _SampleTexture2D_175fb18fafc9598382f1f5f7e97bf30a_RGBA_0_Vector4 = SAMPLE_TEXTURE2D(_Property_c7b1e2df9f9b0e8eace9b2274924e69c_Out_0_Texture2D.tex, _Property_c7b1e2df9f9b0e8eace9b2274924e69c_Out_0_Texture2D.samplerstate, _Property_c7b1e2df9f9b0e8eace9b2274924e69c_Out_0_Texture2D.GetTransformedUV(IN.uv0.xy) );
            float _SampleTexture2D_175fb18fafc9598382f1f5f7e97bf30a_R_4_Float = _SampleTexture2D_175fb18fafc9598382f1f5f7e97bf30a_RGBA_0_Vector4.r;
            float _SampleTexture2D_175fb18fafc9598382f1f5f7e97bf30a_G_5_Float = _SampleTexture2D_175fb18fafc9598382f1f5f7e97bf30a_RGBA_0_Vector4.g;
            float _SampleTexture2D_175fb18fafc9598382f1f5f7e97bf30a_B_6_Float = _SampleTexture2D_175fb18fafc9598382f1f5f7e97bf30a_RGBA_0_Vector4.b;
            float _SampleTexture2D_175fb18fafc9598382f1f5f7e97bf30a_A_7_Float = _SampleTexture2D_175fb18fafc9598382f1f5f7e97bf30a_RGBA_0_Vector4.a;
            float _OneMinus_ce5c3c0635d4ac86beb55115d0ebaed7_Out_1_Float;
            Unity_OneMinus_float(_SampleTexture2D_175fb18fafc9598382f1f5f7e97bf30a_R_4_Float, _OneMinus_ce5c3c0635d4ac86beb55115d0ebaed7_Out_1_Float);
            float _Branch_af0c5e511241ce8eae748ae487df50fa_Out_3_Float;
            Unity_Branch_float(_Property_df2df7bb5cfc3381beee7ec454da7542_Out_0_Boolean, _OneMinus_ce5c3c0635d4ac86beb55115d0ebaed7_Out_1_Float, _SampleTexture2D_175fb18fafc9598382f1f5f7e97bf30a_R_4_Float, _Branch_af0c5e511241ce8eae748ae487df50fa_Out_3_Float);
            UnityTexture2D _Property_de4f6eb48a629285a664dad7fb06438f_Out_0_Texture2D = UnityBuildTexture2DStructNoScale(_Base2MaskMap);
            Bindings_PlanarNM_c0f081da9c567704ea36e7dd38cedcf6_float _PlanarNM_d5657f470f05ef839e4c257a20ace8cb;
            _PlanarNM_d5657f470f05ef839e4c257a20ace8cb.AbsoluteWorldSpacePosition = IN.AbsoluteWorldSpacePosition;
            _PlanarNM_d5657f470f05ef839e4c257a20ace8cb.uv0 = IN.uv0;
            _PlanarNM_d5657f470f05ef839e4c257a20ace8cb.uv3 = IN.uv3;
            float4 _PlanarNM_d5657f470f05ef839e4c257a20ace8cb_XZ_2_Vector4;
            SG_PlanarNM_c0f081da9c567704ea36e7dd38cedcf6_float(_Property_de4f6eb48a629285a664dad7fb06438f_Out_0_Texture2D, _Property_86a4657df480d48e8d3ad3b036731380_Out_0_Vector4, _Property_6c5e16c615cab08a97c2a577642b9d83_Out_0_Boolean, UnityBuildSamplerStateStruct(SamplerState_Linear_Repeat_Aniso8), 1, _PlanarNM_d5657f470f05ef839e4c257a20ace8cb, _PlanarNM_d5657f470f05ef839e4c257a20ace8cb_XZ_2_Vector4);
            float _Split_83ec66b648ab6c84848b42686c256cd7_R_1_Float = _PlanarNM_d5657f470f05ef839e4c257a20ace8cb_XZ_2_Vector4[0];
            float _Split_83ec66b648ab6c84848b42686c256cd7_G_2_Float = _PlanarNM_d5657f470f05ef839e4c257a20ace8cb_XZ_2_Vector4[1];
            float _Split_83ec66b648ab6c84848b42686c256cd7_B_3_Float = _PlanarNM_d5657f470f05ef839e4c257a20ace8cb_XZ_2_Vector4[2];
            float _Split_83ec66b648ab6c84848b42686c256cd7_A_4_Float = _PlanarNM_d5657f470f05ef839e4c257a20ace8cb_XZ_2_Vector4[3];
            float _Property_ce1750e5c69e97818667b412fc3f9f2c_Out_0_Float = _HeightMin2;
            float _Property_8e0f2ea54d8ede89bbabdf31a9bafd57_Out_0_Float = _HeightMax2;
            float2 _Vector2_fb6c6dd7e70e768ba686e8e94153bb96_Out_0_Vector2 = float2(_Property_ce1750e5c69e97818667b412fc3f9f2c_Out_0_Float, _Property_8e0f2ea54d8ede89bbabdf31a9bafd57_Out_0_Float);
            float _Property_151ae2702b614585af2000f0a812960f_Out_0_Float = _HeightOffset2;
            float2 _Add_fd1b3d8e24e77087a55888eeb238f1a6_Out_2_Vector2;
            Unity_Add_float2(_Vector2_fb6c6dd7e70e768ba686e8e94153bb96_Out_0_Vector2, (_Property_151ae2702b614585af2000f0a812960f_Out_0_Float.xx), _Add_fd1b3d8e24e77087a55888eeb238f1a6_Out_2_Vector2);
            float _Remap_3d4180c0ab36ba86a5517b2645f0bfa7_Out_3_Float;
            Unity_Remap_float(_Split_83ec66b648ab6c84848b42686c256cd7_B_3_Float, float2 (0, 1), _Add_fd1b3d8e24e77087a55888eeb238f1a6_Out_2_Vector2, _Remap_3d4180c0ab36ba86a5517b2645f0bfa7_Out_3_Float);
            float _Multiply_2cb0e5aa384654828f0453a44884573c_Out_2_Float;
            Unity_Multiply_float_float(_Branch_af0c5e511241ce8eae748ae487df50fa_Out_3_Float, _Remap_3d4180c0ab36ba86a5517b2645f0bfa7_Out_3_Float, _Multiply_2cb0e5aa384654828f0453a44884573c_Out_2_Float);
            float _Multiply_74def30593cbbb8bbed03613a31cb89a_Out_2_Float;
            Unity_Multiply_float_float(_Split_c34b73d933404283983f9c8bdb5365d3_G_2_Float, _Multiply_2cb0e5aa384654828f0453a44884573c_Out_2_Float, _Multiply_74def30593cbbb8bbed03613a31cb89a_Out_2_Float);
            float _Property_818c8af4b930138e81034c886614171d_Out_0_Float = _Height_Transition;
            Bindings_HeightBlend_d15b6fb865d3b6d4ebc1fd476c3ad135_float _HeightBlend_7501025b3a60738a9a9d362e35a9ab48;
            float3 _HeightBlend_7501025b3a60738a9a9d362e35a9ab48_OutVector4_1_Vector3;
            SG_HeightBlend_d15b6fb865d3b6d4ebc1fd476c3ad135_float((_Multiply_f572ff0def2d308e87a64e94a46c0d96_Out_2_Vector4.xyz), _Remap_18f2e96a438d6584ae2fd56f880de9ee_Out_3_Float, (_Multiply_d2ec682582195e84acc4a8510f50f4b0_Out_2_Vector4.xyz), _Multiply_74def30593cbbb8bbed03613a31cb89a_Out_2_Float, _Property_818c8af4b930138e81034c886614171d_Out_0_Float, _HeightBlend_7501025b3a60738a9a9d362e35a9ab48, _HeightBlend_7501025b3a60738a9a9d362e35a9ab48_OutVector4_1_Vector3);
            UnityTexture2D _Property_c0ebdab0f71ace8aabaa865fd7293599_Out_0_Texture2D = UnityBuildTexture2DStructNoScale(_CoverBaseColorMap);
            float4 _Property_822489d2e6d3e08590c64f085ffd9b2e_Out_0_Vector4 = _CoverTilingOffset;
            float _Property_2ae4a163bd21d98789af282d6e469175_Out_0_Boolean = _CoverUsePlanarUV;
            Bindings_PlanarNM_c0f081da9c567704ea36e7dd38cedcf6_float _PlanarNM_8bb420494d19b28e9ccdff489802dc81;
            _PlanarNM_8bb420494d19b28e9ccdff489802dc81.AbsoluteWorldSpacePosition = IN.AbsoluteWorldSpacePosition;
            _PlanarNM_8bb420494d19b28e9ccdff489802dc81.uv0 = IN.uv0;
            _PlanarNM_8bb420494d19b28e9ccdff489802dc81.uv3 = IN.uv3;
            float4 _PlanarNM_8bb420494d19b28e9ccdff489802dc81_XZ_2_Vector4;
            SG_PlanarNM_c0f081da9c567704ea36e7dd38cedcf6_float(_Property_c0ebdab0f71ace8aabaa865fd7293599_Out_0_Texture2D, _Property_822489d2e6d3e08590c64f085ffd9b2e_Out_0_Vector4, _Property_2ae4a163bd21d98789af282d6e469175_Out_0_Boolean, UnityBuildSamplerStateStruct(SamplerState_Linear_Repeat_Aniso8), 1, _PlanarNM_8bb420494d19b28e9ccdff489802dc81, _PlanarNM_8bb420494d19b28e9ccdff489802dc81_XZ_2_Vector4);
            float4 _Property_55e7941fa7ac5f8387aa9bb633b08883_Out_0_Vector4 = _CoverBaseColor;
            float4 _Multiply_a38ba695a2660c8691763f0bd7fe159c_Out_2_Vector4;
            Unity_Multiply_float4_float4(_PlanarNM_8bb420494d19b28e9ccdff489802dc81_XZ_2_Vector4, _Property_55e7941fa7ac5f8387aa9bb633b08883_Out_0_Vector4, _Multiply_a38ba695a2660c8691763f0bd7fe159c_Out_2_Vector4);
            UnityTexture2D _Property_3b351481f7b944ffaf5f59649df41ba9_Out_0_Texture2D = UnityBuildTexture2DStructNoScale(_CoverBaseColorMap);
            float4 _UV_5352c8dd0add178ba83a5421c2c0b3f0_Out_0_Vector4 = IN.uv0;
            float4 _SampleTexture2D_024ba490c015248988a12a9d670014ea_RGBA_0_Vector4 = SAMPLE_TEXTURE2D(_Property_3b351481f7b944ffaf5f59649df41ba9_Out_0_Texture2D.tex, _Property_3b351481f7b944ffaf5f59649df41ba9_Out_0_Texture2D.samplerstate, _Property_3b351481f7b944ffaf5f59649df41ba9_Out_0_Texture2D.GetTransformedUV((_UV_5352c8dd0add178ba83a5421c2c0b3f0_Out_0_Vector4.xy)) );
            float _SampleTexture2D_024ba490c015248988a12a9d670014ea_R_4_Float = _SampleTexture2D_024ba490c015248988a12a9d670014ea_RGBA_0_Vector4.r;
            float _SampleTexture2D_024ba490c015248988a12a9d670014ea_G_5_Float = _SampleTexture2D_024ba490c015248988a12a9d670014ea_RGBA_0_Vector4.g;
            float _SampleTexture2D_024ba490c015248988a12a9d670014ea_B_6_Float = _SampleTexture2D_024ba490c015248988a12a9d670014ea_RGBA_0_Vector4.b;
            float _SampleTexture2D_024ba490c015248988a12a9d670014ea_A_7_Float = _SampleTexture2D_024ba490c015248988a12a9d670014ea_RGBA_0_Vector4.a;
            float _Property_b80e7b96604b7c82bbf9bff4981fad76_Out_0_Float = _CoverMaskPower;
            float _Multiply_abe410d256783480b1b58468bf78a882_Out_2_Float;
            Unity_Multiply_float_float(_SampleTexture2D_024ba490c015248988a12a9d670014ea_A_7_Float, _Property_b80e7b96604b7c82bbf9bff4981fad76_Out_0_Float, _Multiply_abe410d256783480b1b58468bf78a882_Out_2_Float);
            float _Clamp_a78f6f28770afd869adb9d12cd47370b_Out_3_Float;
            Unity_Clamp_float(_Multiply_abe410d256783480b1b58468bf78a882_Out_2_Float, float(0), float(1), _Clamp_a78f6f28770afd869adb9d12cd47370b_Out_3_Float);
            UnityTexture2D _Property_7c7049e15fdff386b535790d8666f609_Out_0_Texture2D = UnityBuildTexture2DStructNoScale(_BaseNormalMap);
            Bindings_PlanarNMn_1b93a87456f9d4c419321d0cd92bd6c8_float _PlanarNMn_a3713a9c3874b6838d0eda971b9c62d8;
            _PlanarNMn_a3713a9c3874b6838d0eda971b9c62d8.WorldSpaceNormal = IN.WorldSpaceNormal;
            _PlanarNMn_a3713a9c3874b6838d0eda971b9c62d8.WorldSpaceTangent = IN.WorldSpaceTangent;
            _PlanarNMn_a3713a9c3874b6838d0eda971b9c62d8.WorldSpaceBiTangent = IN.WorldSpaceBiTangent;
            _PlanarNMn_a3713a9c3874b6838d0eda971b9c62d8.AbsoluteWorldSpacePosition = IN.AbsoluteWorldSpacePosition;
            _PlanarNMn_a3713a9c3874b6838d0eda971b9c62d8.uv0 = IN.uv0;
            _PlanarNMn_a3713a9c3874b6838d0eda971b9c62d8.uv3 = IN.uv3;
            float4 _PlanarNMn_a3713a9c3874b6838d0eda971b9c62d8_XZ_2_Vector4;
            SG_PlanarNMn_1b93a87456f9d4c419321d0cd92bd6c8_float(_Property_7c7049e15fdff386b535790d8666f609_Out_0_Texture2D, _Property_587a28253857318a9b2e59bfc8fb56a4_Out_0_Vector4, _Property_7f998178363b4188ba2f07298ef869c1_Out_0_Boolean, UnityBuildSamplerStateStruct(SamplerState_Linear_Repeat_Aniso8), 1, _PlanarNMn_a3713a9c3874b6838d0eda971b9c62d8, _PlanarNMn_a3713a9c3874b6838d0eda971b9c62d8_XZ_2_Vector4);
            float _Property_d4b0759cf4647e81be065ec1465ce2b4_Out_0_Float = _BaseNormalScale;
            float3 _NormalStrength_f66a9108ea294886acc61513b41cc5e4_Out_2_Vector3;
            Unity_NormalStrength_float((_PlanarNMn_a3713a9c3874b6838d0eda971b9c62d8_XZ_2_Vector4.xyz), _Property_d4b0759cf4647e81be065ec1465ce2b4_Out_0_Float, _NormalStrength_f66a9108ea294886acc61513b41cc5e4_Out_2_Vector3);
            UnityTexture2D _Property_fa9f7890b20ad481a92543c04b237bde_Out_0_Texture2D = UnityBuildTexture2DStructNoScale(_Base2NormalMap);
            Bindings_PlanarNMn_1b93a87456f9d4c419321d0cd92bd6c8_float _PlanarNMn_d7b3ec528088a085a5102e025a1b45cf;
            _PlanarNMn_d7b3ec528088a085a5102e025a1b45cf.WorldSpaceNormal = IN.WorldSpaceNormal;
            _PlanarNMn_d7b3ec528088a085a5102e025a1b45cf.WorldSpaceTangent = IN.WorldSpaceTangent;
            _PlanarNMn_d7b3ec528088a085a5102e025a1b45cf.WorldSpaceBiTangent = IN.WorldSpaceBiTangent;
            _PlanarNMn_d7b3ec528088a085a5102e025a1b45cf.AbsoluteWorldSpacePosition = IN.AbsoluteWorldSpacePosition;
            _PlanarNMn_d7b3ec528088a085a5102e025a1b45cf.uv0 = IN.uv0;
            _PlanarNMn_d7b3ec528088a085a5102e025a1b45cf.uv3 = IN.uv3;
            float4 _PlanarNMn_d7b3ec528088a085a5102e025a1b45cf_XZ_2_Vector4;
            SG_PlanarNMn_1b93a87456f9d4c419321d0cd92bd6c8_float(_Property_fa9f7890b20ad481a92543c04b237bde_Out_0_Texture2D, _Property_86a4657df480d48e8d3ad3b036731380_Out_0_Vector4, _Property_6c5e16c615cab08a97c2a577642b9d83_Out_0_Boolean, UnityBuildSamplerStateStruct(SamplerState_Linear_Repeat_Aniso8), 1, _PlanarNMn_d7b3ec528088a085a5102e025a1b45cf, _PlanarNMn_d7b3ec528088a085a5102e025a1b45cf_XZ_2_Vector4);
            float _Property_8c31443b776727819a663c7ddce79064_Out_0_Float = _Base2NormalScale;
            float3 _NormalStrength_0fb86880ab8e368dac6d01b830e20ed8_Out_2_Vector3;
            Unity_NormalStrength_float((_PlanarNMn_d7b3ec528088a085a5102e025a1b45cf_XZ_2_Vector4.xyz), _Property_8c31443b776727819a663c7ddce79064_Out_0_Float, _NormalStrength_0fb86880ab8e368dac6d01b830e20ed8_Out_2_Vector3);
            Bindings_HeightBlend_d15b6fb865d3b6d4ebc1fd476c3ad135_float _HeightBlend_7c09d97625efce898e21b66cd039be8b;
            float3 _HeightBlend_7c09d97625efce898e21b66cd039be8b_OutVector4_1_Vector3;
            SG_HeightBlend_d15b6fb865d3b6d4ebc1fd476c3ad135_float(_NormalStrength_f66a9108ea294886acc61513b41cc5e4_Out_2_Vector3, _Remap_18f2e96a438d6584ae2fd56f880de9ee_Out_3_Float, _NormalStrength_0fb86880ab8e368dac6d01b830e20ed8_Out_2_Vector3, _Multiply_74def30593cbbb8bbed03613a31cb89a_Out_2_Float, _Property_818c8af4b930138e81034c886614171d_Out_0_Float, _HeightBlend_7c09d97625efce898e21b66cd039be8b, _HeightBlend_7c09d97625efce898e21b66cd039be8b_OutVector4_1_Vector3);
            UnityTexture2D _Property_65f7dd6fe6c29b83913af586c597a1ef_Out_0_Texture2D = UnityBuildTexture2DStructNoScale(_CoverNormalMap);
            Bindings_PlanarNMn_1b93a87456f9d4c419321d0cd92bd6c8_float _PlanarNMn_248bc5b7421d3f828d166902c73ca6c3;
            _PlanarNMn_248bc5b7421d3f828d166902c73ca6c3.WorldSpaceNormal = IN.WorldSpaceNormal;
            _PlanarNMn_248bc5b7421d3f828d166902c73ca6c3.WorldSpaceTangent = IN.WorldSpaceTangent;
            _PlanarNMn_248bc5b7421d3f828d166902c73ca6c3.WorldSpaceBiTangent = IN.WorldSpaceBiTangent;
            _PlanarNMn_248bc5b7421d3f828d166902c73ca6c3.AbsoluteWorldSpacePosition = IN.AbsoluteWorldSpacePosition;
            _PlanarNMn_248bc5b7421d3f828d166902c73ca6c3.uv0 = IN.uv0;
            _PlanarNMn_248bc5b7421d3f828d166902c73ca6c3.uv3 = IN.uv3;
            float4 _PlanarNMn_248bc5b7421d3f828d166902c73ca6c3_XZ_2_Vector4;
            SG_PlanarNMn_1b93a87456f9d4c419321d0cd92bd6c8_float(_Property_65f7dd6fe6c29b83913af586c597a1ef_Out_0_Texture2D, _Property_822489d2e6d3e08590c64f085ffd9b2e_Out_0_Vector4, _Property_2ae4a163bd21d98789af282d6e469175_Out_0_Boolean, UnityBuildSamplerStateStruct(SamplerState_Linear_Repeat_Aniso8), 1, _PlanarNMn_248bc5b7421d3f828d166902c73ca6c3, _PlanarNMn_248bc5b7421d3f828d166902c73ca6c3_XZ_2_Vector4);
            float _Property_19f92cae42737480a95820c51d4ba124_Out_0_Float = _CoverNormalBlendHardness;
            float3 _NormalStrength_2c3488591b8345869feb25a3dee06c3f_Out_2_Vector3;
            Unity_NormalStrength_float((_PlanarNMn_248bc5b7421d3f828d166902c73ca6c3_XZ_2_Vector4.xyz), _Property_19f92cae42737480a95820c51d4ba124_Out_0_Float, _NormalStrength_2c3488591b8345869feb25a3dee06c3f_Out_2_Vector3);
            float _Split_96bfe9cb80ad308385c191d094b3d071_R_1_Float = IN.WorldSpaceNormal[0];
            float _Split_96bfe9cb80ad308385c191d094b3d071_G_2_Float = IN.WorldSpaceNormal[1];
            float _Split_96bfe9cb80ad308385c191d094b3d071_B_3_Float = IN.WorldSpaceNormal[2];
            float _Split_96bfe9cb80ad308385c191d094b3d071_A_4_Float = 0;
            float _Property_0dd796aae8cd9f878bef13ceac4fe3ec_Out_0_Float = _Cover_Amount;
            float _Property_67285cdc688aa38d83f62d5bb095d597_Out_0_Float = _Cover_Amount_Grow_Speed;
            float _Subtract_fcefec675e7536888eccf5574d921972_Out_2_Float;
            Unity_Subtract_float(float(4), _Property_67285cdc688aa38d83f62d5bb095d597_Out_0_Float, _Subtract_fcefec675e7536888eccf5574d921972_Out_2_Float);
            float _Divide_1e25465528e612839a4ce1faedd89e7d_Out_2_Float;
            Unity_Divide_float(_Property_0dd796aae8cd9f878bef13ceac4fe3ec_Out_0_Float, _Subtract_fcefec675e7536888eccf5574d921972_Out_2_Float, _Divide_1e25465528e612839a4ce1faedd89e7d_Out_2_Float);
            float _Absolute_d20b810ffdec828ab74dd6692d82f01b_Out_1_Float;
            Unity_Absolute_float(_Divide_1e25465528e612839a4ce1faedd89e7d_Out_2_Float, _Absolute_d20b810ffdec828ab74dd6692d82f01b_Out_1_Float);
            float _Power_181fbf47cfdb258da1fe0b72a450986f_Out_2_Float;
            Unity_Power_float(_Absolute_d20b810ffdec828ab74dd6692d82f01b_Out_1_Float, _Subtract_fcefec675e7536888eccf5574d921972_Out_2_Float, _Power_181fbf47cfdb258da1fe0b72a450986f_Out_2_Float);
            float _Clamp_11f62dba01f1a38c9e0a9972ccd19246_Out_3_Float;
            Unity_Clamp_float(_Power_181fbf47cfdb258da1fe0b72a450986f_Out_2_Float, float(0), float(2), _Clamp_11f62dba01f1a38c9e0a9972ccd19246_Out_3_Float);
            float _Multiply_9810f6d76275cd8fbe5e3a02360b98a7_Out_2_Float;
            Unity_Multiply_float_float(_Split_96bfe9cb80ad308385c191d094b3d071_G_2_Float, _Clamp_11f62dba01f1a38c9e0a9972ccd19246_Out_3_Float, _Multiply_9810f6d76275cd8fbe5e3a02360b98a7_Out_2_Float);
            float _Saturate_a007c5f214685c87bf6ca3e64c06b488_Out_1_Float;
            Unity_Saturate_float(_Multiply_9810f6d76275cd8fbe5e3a02360b98a7_Out_2_Float, _Saturate_a007c5f214685c87bf6ca3e64c06b488_Out_1_Float);
            float _Clamp_1b2b25b617fc508b9835f0309136fd00_Out_3_Float;
            Unity_Clamp_float(_Split_96bfe9cb80ad308385c191d094b3d071_G_2_Float, float(0), float(0.9999), _Clamp_1b2b25b617fc508b9835f0309136fd00_Out_3_Float);
            float _Property_7b12276ea7a4538db6804507b30a830c_Out_0_Float = _Cover_Max_Angle;
            float _Divide_54c523ff4b7acb858e9e368fd1e4d34a_Out_2_Float;
            Unity_Divide_float(_Property_7b12276ea7a4538db6804507b30a830c_Out_0_Float, float(45), _Divide_54c523ff4b7acb858e9e368fd1e4d34a_Out_2_Float);
            float _OneMinus_6cf431985b651e8e9546ae6cb2d4d668_Out_1_Float;
            Unity_OneMinus_float(_Divide_54c523ff4b7acb858e9e368fd1e4d34a_Out_2_Float, _OneMinus_6cf431985b651e8e9546ae6cb2d4d668_Out_1_Float);
            float _Subtract_4ef7b60aeab8d589bf2d2423737642bc_Out_2_Float;
            Unity_Subtract_float(_Clamp_1b2b25b617fc508b9835f0309136fd00_Out_3_Float, _OneMinus_6cf431985b651e8e9546ae6cb2d4d668_Out_1_Float, _Subtract_4ef7b60aeab8d589bf2d2423737642bc_Out_2_Float);
            float _Clamp_a4b51894ea17818c9a27bb533a2ebe74_Out_3_Float;
            Unity_Clamp_float(_Subtract_4ef7b60aeab8d589bf2d2423737642bc_Out_2_Float, float(0), float(2), _Clamp_a4b51894ea17818c9a27bb533a2ebe74_Out_3_Float);
            float _Divide_c4196d4f02190b89ba827ccd4ae8a74d_Out_2_Float;
            Unity_Divide_float(float(1), _Divide_54c523ff4b7acb858e9e368fd1e4d34a_Out_2_Float, _Divide_c4196d4f02190b89ba827ccd4ae8a74d_Out_2_Float);
            float _Multiply_ffc22433163d1184846ede424b44bcb2_Out_2_Float;
            Unity_Multiply_float_float(_Clamp_a4b51894ea17818c9a27bb533a2ebe74_Out_3_Float, _Divide_c4196d4f02190b89ba827ccd4ae8a74d_Out_2_Float, _Multiply_ffc22433163d1184846ede424b44bcb2_Out_2_Float);
            float _Absolute_c2e5757082de5d878d4c023806fb2108_Out_1_Float;
            Unity_Absolute_float(_Multiply_ffc22433163d1184846ede424b44bcb2_Out_2_Float, _Absolute_c2e5757082de5d878d4c023806fb2108_Out_1_Float);
            float _Property_849d9f217c95f38c9d49ab251578d8d5_Out_0_Float = _CoverHardness;
            float _Power_578546d66d69a5829b745ebba1279adf_Out_2_Float;
            Unity_Power_float(_Absolute_c2e5757082de5d878d4c023806fb2108_Out_1_Float, _Property_849d9f217c95f38c9d49ab251578d8d5_Out_0_Float, _Power_578546d66d69a5829b745ebba1279adf_Out_2_Float);
            float _Property_34d2d3aff4814e8e83d2894b3512c6c8_Out_0_Float = _Cover_Min_Height;
            float _OneMinus_474df64227f004849b34c68fe8df93f2_Out_1_Float;
            Unity_OneMinus_float(_Property_34d2d3aff4814e8e83d2894b3512c6c8_Out_0_Float, _OneMinus_474df64227f004849b34c68fe8df93f2_Out_1_Float);
            float _Split_ee4d9dc934b3508397d5a3dece110ab0_R_1_Float = IN.AbsoluteWorldSpacePosition[0];
            float _Split_ee4d9dc934b3508397d5a3dece110ab0_G_2_Float = IN.AbsoluteWorldSpacePosition[1];
            float _Split_ee4d9dc934b3508397d5a3dece110ab0_B_3_Float = IN.AbsoluteWorldSpacePosition[2];
            float _Split_ee4d9dc934b3508397d5a3dece110ab0_A_4_Float = 0;
            float _Add_d6bc513aa82d918ea24e279f4353d971_Out_2_Float;
            Unity_Add_float(_OneMinus_474df64227f004849b34c68fe8df93f2_Out_1_Float, _Split_ee4d9dc934b3508397d5a3dece110ab0_G_2_Float, _Add_d6bc513aa82d918ea24e279f4353d971_Out_2_Float);
            float _Add_a6a61cb12180108c9e1364b90d2673e2_Out_2_Float;
            Unity_Add_float(_Add_d6bc513aa82d918ea24e279f4353d971_Out_2_Float, float(1), _Add_a6a61cb12180108c9e1364b90d2673e2_Out_2_Float);
            float _Clamp_1874fdd00cb9aa839d93ab8536e2414d_Out_3_Float;
            Unity_Clamp_float(_Add_a6a61cb12180108c9e1364b90d2673e2_Out_2_Float, float(0), float(1), _Clamp_1874fdd00cb9aa839d93ab8536e2414d_Out_3_Float);
            float _Property_7b91fd6e21b46c85816c7b681307cbe4_Out_0_Float = _Cover_Min_Height_Blending;
            float _Add_6dca9453f6a35e8185c4b8e9782db0a9_Out_2_Float;
            Unity_Add_float(_Add_d6bc513aa82d918ea24e279f4353d971_Out_2_Float, _Property_7b91fd6e21b46c85816c7b681307cbe4_Out_0_Float, _Add_6dca9453f6a35e8185c4b8e9782db0a9_Out_2_Float);
            float _Divide_83415a319ecfba83af914cbc5487b546_Out_2_Float;
            Unity_Divide_float(_Add_6dca9453f6a35e8185c4b8e9782db0a9_Out_2_Float, _Add_d6bc513aa82d918ea24e279f4353d971_Out_2_Float, _Divide_83415a319ecfba83af914cbc5487b546_Out_2_Float);
            float _OneMinus_bf150b22fcad5a87b7c825c9c6cf1687_Out_1_Float;
            Unity_OneMinus_float(_Divide_83415a319ecfba83af914cbc5487b546_Out_2_Float, _OneMinus_bf150b22fcad5a87b7c825c9c6cf1687_Out_1_Float);
            float _Add_86ff9fa850efbe8c80705d8266609dab_Out_2_Float;
            Unity_Add_float(_OneMinus_bf150b22fcad5a87b7c825c9c6cf1687_Out_1_Float, float(-0.5), _Add_86ff9fa850efbe8c80705d8266609dab_Out_2_Float);
            float _Clamp_906e140f01222d8ba61252ec6ec9d6a4_Out_3_Float;
            Unity_Clamp_float(_Add_86ff9fa850efbe8c80705d8266609dab_Out_2_Float, float(0), float(1), _Clamp_906e140f01222d8ba61252ec6ec9d6a4_Out_3_Float);
            float _Add_c1ec5849bf72f585a30b3e11a91ada52_Out_2_Float;
            Unity_Add_float(_Clamp_1874fdd00cb9aa839d93ab8536e2414d_Out_3_Float, _Clamp_906e140f01222d8ba61252ec6ec9d6a4_Out_3_Float, _Add_c1ec5849bf72f585a30b3e11a91ada52_Out_2_Float);
            float _Clamp_17a8a0cf209a038b9e9c7f5681cdd1fb_Out_3_Float;
            Unity_Clamp_float(_Add_c1ec5849bf72f585a30b3e11a91ada52_Out_2_Float, float(0), float(1), _Clamp_17a8a0cf209a038b9e9c7f5681cdd1fb_Out_3_Float);
            float _Multiply_8c2759ac24a9b289b1e9610cfd161bb0_Out_2_Float;
            Unity_Multiply_float_float(_Power_578546d66d69a5829b745ebba1279adf_Out_2_Float, _Clamp_17a8a0cf209a038b9e9c7f5681cdd1fb_Out_3_Float, _Multiply_8c2759ac24a9b289b1e9610cfd161bb0_Out_2_Float);
            float _Multiply_1a723f136ec7fa8c957b5d29e03d3051_Out_2_Float;
            Unity_Multiply_float_float(_Saturate_a007c5f214685c87bf6ca3e64c06b488_Out_1_Float, _Multiply_8c2759ac24a9b289b1e9610cfd161bb0_Out_2_Float, _Multiply_1a723f136ec7fa8c957b5d29e03d3051_Out_2_Float);
            float3 _Lerp_d1c72e47b283948584479177786ae8d5_Out_3_Vector3;
            Unity_Lerp_float3(_HeightBlend_7c09d97625efce898e21b66cd039be8b_OutVector4_1_Vector3, _NormalStrength_2c3488591b8345869feb25a3dee06c3f_Out_2_Vector3, (_Multiply_1a723f136ec7fa8c957b5d29e03d3051_Out_2_Float.xxx), _Lerp_d1c72e47b283948584479177786ae8d5_Out_3_Vector3);
            float3 _Transform_180fb403b53f318db002e8eba7616644_Out_1_Vector3;
            {
                float3x3 tangentTransform = float3x3(IN.WorldSpaceTangent, IN.WorldSpaceBiTangent, IN.WorldSpaceNormal);
                _Transform_180fb403b53f318db002e8eba7616644_Out_1_Vector3 = TransformTangentToWorldDir(_Lerp_d1c72e47b283948584479177786ae8d5_Out_3_Vector3.xyz, tangentTransform, true).xyz;
            }
            float _Split_c9a2b4fb4f688b8ebfc1436535cd5ba4_R_1_Float = _Transform_180fb403b53f318db002e8eba7616644_Out_1_Vector3[0];
            float _Split_c9a2b4fb4f688b8ebfc1436535cd5ba4_G_2_Float = _Transform_180fb403b53f318db002e8eba7616644_Out_1_Vector3[1];
            float _Split_c9a2b4fb4f688b8ebfc1436535cd5ba4_B_3_Float = _Transform_180fb403b53f318db002e8eba7616644_Out_1_Vector3[2];
            float _Split_c9a2b4fb4f688b8ebfc1436535cd5ba4_A_4_Float = 0;
            float _Multiply_4c7631d0688102819e6d388d624855a1_Out_2_Float;
            Unity_Multiply_float_float(_Split_c9a2b4fb4f688b8ebfc1436535cd5ba4_G_2_Float, _Clamp_11f62dba01f1a38c9e0a9972ccd19246_Out_3_Float, _Multiply_4c7631d0688102819e6d388d624855a1_Out_2_Float);
            float _Multiply_f2887eb409f6bb81ae4caad2b01b17f1_Out_2_Float;
            Unity_Multiply_float_float(_Clamp_11f62dba01f1a38c9e0a9972ccd19246_Out_3_Float, _Property_849d9f217c95f38c9d49ab251578d8d5_Out_0_Float, _Multiply_f2887eb409f6bb81ae4caad2b01b17f1_Out_2_Float);
            float _Multiply_2e348ed31331e78791b2b3130a009f30_Out_2_Float;
            Unity_Multiply_float_float(_Multiply_f2887eb409f6bb81ae4caad2b01b17f1_Out_2_Float, _Multiply_8c2759ac24a9b289b1e9610cfd161bb0_Out_2_Float, _Multiply_2e348ed31331e78791b2b3130a009f30_Out_2_Float);
            float _Multiply_622e54e9a77b08839c0954ce5715ad1c_Out_2_Float;
            Unity_Multiply_float_float(_Multiply_4c7631d0688102819e6d388d624855a1_Out_2_Float, _Multiply_2e348ed31331e78791b2b3130a009f30_Out_2_Float, _Multiply_622e54e9a77b08839c0954ce5715ad1c_Out_2_Float);
            UnityTexture2D _Property_608db04fab7d768d9a8b5fb9cf0768e1_Out_0_Texture2D = UnityBuildTexture2DStructNoScale(_CoverMaskMap);
            Bindings_PlanarNM_c0f081da9c567704ea36e7dd38cedcf6_float _PlanarNM_819c993d9b62a28ea640d2bacdc62c6e;
            _PlanarNM_819c993d9b62a28ea640d2bacdc62c6e.AbsoluteWorldSpacePosition = IN.AbsoluteWorldSpacePosition;
            _PlanarNM_819c993d9b62a28ea640d2bacdc62c6e.uv0 = IN.uv0;
            _PlanarNM_819c993d9b62a28ea640d2bacdc62c6e.uv3 = IN.uv3;
            float4 _PlanarNM_819c993d9b62a28ea640d2bacdc62c6e_XZ_2_Vector4;
            SG_PlanarNM_c0f081da9c567704ea36e7dd38cedcf6_float(_Property_608db04fab7d768d9a8b5fb9cf0768e1_Out_0_Texture2D, _Property_822489d2e6d3e08590c64f085ffd9b2e_Out_0_Vector4, _Property_2ae4a163bd21d98789af282d6e469175_Out_0_Boolean, UnityBuildSamplerStateStruct(SamplerState_Linear_Repeat_Aniso8), 1, _PlanarNM_819c993d9b62a28ea640d2bacdc62c6e, _PlanarNM_819c993d9b62a28ea640d2bacdc62c6e_XZ_2_Vector4);
            float _Split_86ec1aefda4f9e8e82b79c6195b397b0_R_1_Float = _PlanarNM_819c993d9b62a28ea640d2bacdc62c6e_XZ_2_Vector4[0];
            float _Split_86ec1aefda4f9e8e82b79c6195b397b0_G_2_Float = _PlanarNM_819c993d9b62a28ea640d2bacdc62c6e_XZ_2_Vector4[1];
            float _Split_86ec1aefda4f9e8e82b79c6195b397b0_B_3_Float = _PlanarNM_819c993d9b62a28ea640d2bacdc62c6e_XZ_2_Vector4[2];
            float _Split_86ec1aefda4f9e8e82b79c6195b397b0_A_4_Float = _PlanarNM_819c993d9b62a28ea640d2bacdc62c6e_XZ_2_Vector4[3];
            float _Property_c9c6897e00458b8f8aa07df49fa519bc_Out_0_Float = _CoverHeightMapMin;
            float _Property_ab94650b8edd82828661fe99e3c0e849_Out_0_Float = _CoverHeightMapMax;
            float2 _Vector2_fe489f7321f6568686816b9eecbc16d1_Out_0_Vector2 = float2(_Property_c9c6897e00458b8f8aa07df49fa519bc_Out_0_Float, _Property_ab94650b8edd82828661fe99e3c0e849_Out_0_Float);
            float _Property_c1ab40024cb83b87960e4327efbd997f_Out_0_Float = _CoverHeightMapOffset;
            float2 _Add_4a359522fc231c83b55ef23f341b6fb3_Out_2_Vector2;
            Unity_Add_float2(_Vector2_fe489f7321f6568686816b9eecbc16d1_Out_0_Vector2, (_Property_c1ab40024cb83b87960e4327efbd997f_Out_0_Float.xx), _Add_4a359522fc231c83b55ef23f341b6fb3_Out_2_Vector2);
            float _Remap_5aee5b64d41562858dc7c42d8b748894_Out_3_Float;
            Unity_Remap_float(_Split_86ec1aefda4f9e8e82b79c6195b397b0_B_3_Float, float2 (0, 1), _Add_4a359522fc231c83b55ef23f341b6fb3_Out_2_Vector2, _Remap_5aee5b64d41562858dc7c42d8b748894_Out_3_Float);
            float _Multiply_f0228e1cfd9c858dbb36367f551733c4_Out_2_Float;
            Unity_Multiply_float_float(_Multiply_622e54e9a77b08839c0954ce5715ad1c_Out_2_Float, _Remap_5aee5b64d41562858dc7c42d8b748894_Out_3_Float, _Multiply_f0228e1cfd9c858dbb36367f551733c4_Out_2_Float);
            float _Multiply_bb4d60728db93b8a9af9635fa1d69891_Out_2_Float;
            Unity_Multiply_float_float(_Split_c34b73d933404283983f9c8bdb5365d3_B_3_Float, _Multiply_f0228e1cfd9c858dbb36367f551733c4_Out_2_Float, _Multiply_bb4d60728db93b8a9af9635fa1d69891_Out_2_Float);
            float _Saturate_9b052a9bb99eff89bb11bdc387a0c2fd_Out_1_Float;
            Unity_Saturate_float(_Multiply_bb4d60728db93b8a9af9635fa1d69891_Out_2_Float, _Saturate_9b052a9bb99eff89bb11bdc387a0c2fd_Out_1_Float);
            float _Multiply_22fb8c1cfd28b687a991e101aa13ff5b_Out_2_Float;
            Unity_Multiply_float_float(_Clamp_a78f6f28770afd869adb9d12cd47370b_Out_3_Float, _Saturate_9b052a9bb99eff89bb11bdc387a0c2fd_Out_1_Float, _Multiply_22fb8c1cfd28b687a991e101aa13ff5b_Out_2_Float);
            #if defined(_USEDYNAMICCOVERTSTATICMASKF_ON)
            float _UseDynamicCoverTStaticMaskF_20dcbac2f16cf78ebd6fd1debcd7f281_Out_0_Float = _Multiply_22fb8c1cfd28b687a991e101aa13ff5b_Out_2_Float;
            #else
            float _UseDynamicCoverTStaticMaskF_20dcbac2f16cf78ebd6fd1debcd7f281_Out_0_Float = _Clamp_a78f6f28770afd869adb9d12cd47370b_Out_3_Float;
            #endif
            float3 _Lerp_e5620b57c917728fa1416e2ffce9b0db_Out_3_Vector3;
            Unity_Lerp_float3(_HeightBlend_7501025b3a60738a9a9d362e35a9ab48_OutVector4_1_Vector3, (_Multiply_a38ba695a2660c8691763f0bd7fe159c_Out_2_Vector4.xyz), (_UseDynamicCoverTStaticMaskF_20dcbac2f16cf78ebd6fd1debcd7f281_Out_0_Float.xxx), _Lerp_e5620b57c917728fa1416e2ffce9b0db_Out_3_Vector3);
            float4 _Property_7946b761100c49199abc52129949bc94_Out_0_Vector4 = _WetColor;
            float3 _Multiply_f722561c89f8451497c9823ad4f29f4a_Out_2_Vector3;
            Unity_Multiply_float3_float3((_Property_7946b761100c49199abc52129949bc94_Out_0_Vector4.xyz), _Lerp_e5620b57c917728fa1416e2ffce9b0db_Out_3_Vector3, _Multiply_f722561c89f8451497c9823ad4f29f4a_Out_2_Vector3);
            float _OneMinus_6ed96e068e394cd09ae03c32446777c8_Out_1_Float;
            Unity_OneMinus_float(_Split_c34b73d933404283983f9c8bdb5365d3_R_1_Float, _OneMinus_6ed96e068e394cd09ae03c32446777c8_Out_1_Float);
            float3 _Lerp_c16da1ee314d4393a798b1d36f6733d8_Out_3_Vector3;
            Unity_Lerp_float3(_Lerp_e5620b57c917728fa1416e2ffce9b0db_Out_3_Vector3, _Multiply_f722561c89f8451497c9823ad4f29f4a_Out_2_Vector3, (_OneMinus_6ed96e068e394cd09ae03c32446777c8_Out_1_Float.xxx), _Lerp_c16da1ee314d4393a798b1d36f6733d8_Out_3_Vector3);
            float _Split_c7a719bf7da79a8ea38d7311fd844f92_R_1_Float = _Multiply_f572ff0def2d308e87a64e94a46c0d96_Out_2_Vector4[0];
            float _Split_c7a719bf7da79a8ea38d7311fd844f92_G_2_Float = _Multiply_f572ff0def2d308e87a64e94a46c0d96_Out_2_Vector4[1];
            float _Split_c7a719bf7da79a8ea38d7311fd844f92_B_3_Float = _Multiply_f572ff0def2d308e87a64e94a46c0d96_Out_2_Vector4[2];
            float _Split_c7a719bf7da79a8ea38d7311fd844f92_A_4_Float = _Multiply_f572ff0def2d308e87a64e94a46c0d96_Out_2_Vector4[3];
            float _Property_7c5dae9b46c9e686b49e58fa996a104a_Out_0_Boolean = IgnoreBase2Alpha;
            float _Split_e9060f5c0433ec889696d3e462f3229b_R_1_Float = _Multiply_d2ec682582195e84acc4a8510f50f4b0_Out_2_Vector4[0];
            float _Split_e9060f5c0433ec889696d3e462f3229b_G_2_Float = _Multiply_d2ec682582195e84acc4a8510f50f4b0_Out_2_Vector4[1];
            float _Split_e9060f5c0433ec889696d3e462f3229b_B_3_Float = _Multiply_d2ec682582195e84acc4a8510f50f4b0_Out_2_Vector4[2];
            float _Split_e9060f5c0433ec889696d3e462f3229b_A_4_Float = _Multiply_d2ec682582195e84acc4a8510f50f4b0_Out_2_Vector4[3];
            float _Branch_a7d7aece30fd9b8eb456d191fdd37a06_Out_3_Float;
            Unity_Branch_float(_Property_7c5dae9b46c9e686b49e58fa996a104a_Out_0_Boolean, _Split_c7a719bf7da79a8ea38d7311fd844f92_A_4_Float, _Split_e9060f5c0433ec889696d3e462f3229b_A_4_Float, _Branch_a7d7aece30fd9b8eb456d191fdd37a06_Out_3_Float);
            float _Lerp_8692ca93f568998fbc97130b6dbc4556_Out_3_Float;
            Unity_Lerp_float(_Split_c7a719bf7da79a8ea38d7311fd844f92_A_4_Float, _Branch_a7d7aece30fd9b8eb456d191fdd37a06_Out_3_Float, _Multiply_74def30593cbbb8bbed03613a31cb89a_Out_2_Float, _Lerp_8692ca93f568998fbc97130b6dbc4556_Out_3_Float);
            float _Clamp_0c8b7b55b9f82588ab2dcff09ee7a16d_Out_3_Float;
            Unity_Clamp_float(_Lerp_8692ca93f568998fbc97130b6dbc4556_Out_3_Float, float(0), float(1), _Clamp_0c8b7b55b9f82588ab2dcff09ee7a16d_Out_3_Float);
            float _Multiply_6333dc4a6348088bb7281602ce6bff5f_Out_2_Float;
            Unity_Multiply_float_float(_Clamp_0c8b7b55b9f82588ab2dcff09ee7a16d_Out_3_Float, _Split_c34b73d933404283983f9c8bdb5365d3_A_4_Float, _Multiply_6333dc4a6348088bb7281602ce6bff5f_Out_2_Float);
            float _Clamp_9642b8fb7e32b18a91da1888c9bc375b_Out_3_Float;
            Unity_Clamp_float(_Multiply_6333dc4a6348088bb7281602ce6bff5f_Out_2_Float, float(0), float(1), _Clamp_9642b8fb7e32b18a91da1888c9bc375b_Out_3_Float);
            float _Property_8bc98dd454a5508b9864a6ba09772356_Out_0_Float = _AlphaCutoff;
            surface.BaseColor = _Lerp_c16da1ee314d4393a798b1d36f6733d8_Out_3_Vector3;
            surface.Alpha = _Clamp_9642b8fb7e32b18a91da1888c9bc375b_Out_3_Float;
            surface.AlphaClipThreshold = _Property_8bc98dd454a5508b9864a6ba09772356_Out_0_Float;
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
        #pragma shader_feature_local _ _USEDYNAMICCOVERTSTATICMASKF_ON
        
        #if defined(_USEDYNAMICCOVERTSTATICMASKF_ON)
            #define KEYWORD_PERMUTATION_0
        #else
            #define KEYWORD_PERMUTATION_1
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
        float4 _WetColor;
        float _WetSmoothness;
        float _AlphaCutoff;
        float4 _BaseColor;
        float4 _BaseColorMap_TexelSize;
        float _BaseUsePlanarUV;
        float4 _BaseTilingOffset;
        float4 _BaseNormalMap_TexelSize;
        float _BaseNormalScale;
        float4 _BaseMaskMap_TexelSize;
        float _BaseMetallic;
        float _BaseAORemapMin;
        float _BaseAORemapMax;
        float _BaseSmoothnessRemapMin;
        float _BaseSmoothnessRemapMax;
        float4 _LayerMask_TexelSize;
        float _Invert_Layer_Mask;
        float _Height_Transition;
        float _HeightMin;
        float _HeightMax;
        float _HeightOffset;
        float _HeightMin2;
        float _HeightMax2;
        float _HeightOffset2;
        float IgnoreBase2Alpha;
        float4 _Base2Color;
        float4 _Base2ColorMap_TexelSize;
        float4 _Base2TilingOffset;
        float _Base2UsePlanarUV;
        float4 _Base2NormalMap_TexelSize;
        float _Base2NormalScale;
        float4 _Base2MaskMap_TexelSize;
        float _Base2Metallic;
        float _Base2SmoothnessRemapMin;
        float _Base2SmoothnessRemapMax;
        float _Base2AORemapMin;
        float _Base2AORemapMax;
        float _CoverMaskPower;
        float _Cover_Amount;
        float _Cover_Amount_Grow_Speed;
        float _Cover_Max_Angle;
        float _Cover_Min_Height;
        float _Cover_Min_Height_Blending;
        float4 _CoverBaseColor;
        float4 _CoverBaseColorMap_TexelSize;
        float4 _CoverTilingOffset;
        float _CoverUsePlanarUV;
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
        UNITY_TEXTURE_STREAMING_DEBUG_VARS;
        CBUFFER_END
        
        
        // Object and Global properties
        SAMPLER(SamplerState_Linear_Repeat);
        SAMPLER(SamplerState_Linear_Repeat_Aniso8);
        TEXTURE2D(_BaseColorMap);
        SAMPLER(sampler_BaseColorMap);
        TEXTURE2D(_BaseNormalMap);
        SAMPLER(sampler_BaseNormalMap);
        TEXTURE2D(_BaseMaskMap);
        SAMPLER(sampler_BaseMaskMap);
        TEXTURE2D(_LayerMask);
        SAMPLER(sampler_LayerMask);
        TEXTURE2D(_Base2ColorMap);
        SAMPLER(sampler_Base2ColorMap);
        TEXTURE2D(_Base2NormalMap);
        SAMPLER(sampler_Base2NormalMap);
        TEXTURE2D(_Base2MaskMap);
        SAMPLER(sampler_Base2MaskMap);
        TEXTURE2D(_CoverBaseColorMap);
        SAMPLER(sampler_CoverBaseColorMap);
        TEXTURE2D(_CoverNormalMap);
        SAMPLER(sampler_CoverNormalMap);
        TEXTURE2D(_CoverMaskMap);
        SAMPLER(sampler_CoverMaskMap);
        
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
        
        void Unity_Add_float2(float2 A, float2 B, out float2 Out)
        {
            Out = A + B;
        }
        
        void Unity_Remap_float(float In, float2 InMinMax, float2 OutMinMax, out float Out)
        {
            Out = OutMinMax.x + (In - InMinMax.x) * (OutMinMax.y - OutMinMax.x) / (InMinMax.y - InMinMax.x);
        }
        
        void Unity_OneMinus_float(float In, out float Out)
        {
            Out = 1 - In;
        }
        
        void Unity_Branch_float(float Predicate, float True, float False, out float Out)
        {
            Out = Predicate ? True : False;
        }
        
        void Unity_Multiply_float_float(float A, float B, out float Out)
        {
            Out = A * B;
        }
        
        void Unity_Maximum_float(float A, float B, out float Out)
        {
            Out = max(A, B);
        }
        
        void Unity_Subtract_float(float A, float B, out float Out)
        {
            Out = A - B;
        }
        
        void Unity_Multiply_float3_float3(float3 A, float3 B, out float3 Out)
        {
        Out = A * B;
        }
        
        void Unity_Add_float3(float3 A, float3 B, out float3 Out)
        {
            Out = A + B;
        }
        
        void Unity_Add_float(float A, float B, out float Out)
        {
            Out = A + B;
        }
        
        void Unity_Divide_float3(float3 A, float3 B, out float3 Out)
        {
            Out = A / B;
        }
        
        struct Bindings_HeightBlend_d15b6fb865d3b6d4ebc1fd476c3ad135_float
        {
        };
        
        void SG_HeightBlend_d15b6fb865d3b6d4ebc1fd476c3ad135_float(float3 Vector3_88EEBB5E, float Vector1_DA0A37FA, float3 Vector3_79AA92F, float Vector1_F7E83F1E, float Vector1_1C9222A6, Bindings_HeightBlend_d15b6fb865d3b6d4ebc1fd476c3ad135_float IN, out float3 OutVector4_1)
        {
        float3 _Property_dd1c841a04c03f8c85e7b00eb025ecda_Out_0_Vector3 = Vector3_88EEBB5E;
        float _Property_14119cc7eaf4128f991283d47cf72d85_Out_0_Float = Vector1_DA0A37FA;
        float _Property_48af0ad45e3f7f82932b938695d21391_Out_0_Float = Vector1_DA0A37FA;
        float _Property_8a30b3ca12ff518fa473ccd686c7d503_Out_0_Float = Vector1_F7E83F1E;
        float _Maximum_c196e4a61637ea8381a3437c93f89ce2_Out_2_Float;
        Unity_Maximum_float(_Property_48af0ad45e3f7f82932b938695d21391_Out_0_Float, _Property_8a30b3ca12ff518fa473ccd686c7d503_Out_0_Float, _Maximum_c196e4a61637ea8381a3437c93f89ce2_Out_2_Float);
        float _Property_ee8d5fc69475d181be60c57e04ea8708_Out_0_Float = Vector1_1C9222A6;
        float _Subtract_61ca880c04c1758eb128f25c9faabd63_Out_2_Float;
        Unity_Subtract_float(_Maximum_c196e4a61637ea8381a3437c93f89ce2_Out_2_Float, _Property_ee8d5fc69475d181be60c57e04ea8708_Out_0_Float, _Subtract_61ca880c04c1758eb128f25c9faabd63_Out_2_Float);
        float _Subtract_e3a7713b556a1b8cb40aad97fc58d619_Out_2_Float;
        Unity_Subtract_float(_Property_14119cc7eaf4128f991283d47cf72d85_Out_0_Float, _Subtract_61ca880c04c1758eb128f25c9faabd63_Out_2_Float, _Subtract_e3a7713b556a1b8cb40aad97fc58d619_Out_2_Float);
        float _Maximum_d02e48d92038448cb0345e5cf3779071_Out_2_Float;
        Unity_Maximum_float(_Subtract_e3a7713b556a1b8cb40aad97fc58d619_Out_2_Float, float(0), _Maximum_d02e48d92038448cb0345e5cf3779071_Out_2_Float);
        float3 _Multiply_79b0b5d7d3528b8395e1135339a090f2_Out_2_Vector3;
        Unity_Multiply_float3_float3(_Property_dd1c841a04c03f8c85e7b00eb025ecda_Out_0_Vector3, (_Maximum_d02e48d92038448cb0345e5cf3779071_Out_2_Float.xxx), _Multiply_79b0b5d7d3528b8395e1135339a090f2_Out_2_Vector3);
        float3 _Property_c7292b3b08585f8c8670172b9a220bf0_Out_0_Vector3 = Vector3_79AA92F;
        float _Property_5e920479576fad83ba1947728dcceab4_Out_0_Float = Vector1_F7E83F1E;
        float _Subtract_b7368f21be9e048aae7f90c8a2bfaae1_Out_2_Float;
        Unity_Subtract_float(_Property_5e920479576fad83ba1947728dcceab4_Out_0_Float, _Subtract_61ca880c04c1758eb128f25c9faabd63_Out_2_Float, _Subtract_b7368f21be9e048aae7f90c8a2bfaae1_Out_2_Float);
        float _Maximum_216777d30802328eab607c8fe68ba3a1_Out_2_Float;
        Unity_Maximum_float(_Subtract_b7368f21be9e048aae7f90c8a2bfaae1_Out_2_Float, float(0), _Maximum_216777d30802328eab607c8fe68ba3a1_Out_2_Float);
        float3 _Multiply_a856b52cd0848f86a6ae1af9b175935c_Out_2_Vector3;
        Unity_Multiply_float3_float3(_Property_c7292b3b08585f8c8670172b9a220bf0_Out_0_Vector3, (_Maximum_216777d30802328eab607c8fe68ba3a1_Out_2_Float.xxx), _Multiply_a856b52cd0848f86a6ae1af9b175935c_Out_2_Vector3);
        float3 _Add_86c6109dc4530b8c9763ef62b056ad4c_Out_2_Vector3;
        Unity_Add_float3(_Multiply_79b0b5d7d3528b8395e1135339a090f2_Out_2_Vector3, _Multiply_a856b52cd0848f86a6ae1af9b175935c_Out_2_Vector3, _Add_86c6109dc4530b8c9763ef62b056ad4c_Out_2_Vector3);
        float _Add_356384b52728f583bd6e694bc1fc3738_Out_2_Float;
        Unity_Add_float(_Maximum_d02e48d92038448cb0345e5cf3779071_Out_2_Float, _Maximum_216777d30802328eab607c8fe68ba3a1_Out_2_Float, _Add_356384b52728f583bd6e694bc1fc3738_Out_2_Float);
        float _Maximum_94a22f5ceb706e88bc16350a5d5d2a82_Out_2_Float;
        Unity_Maximum_float(_Add_356384b52728f583bd6e694bc1fc3738_Out_2_Float, float(1E-05), _Maximum_94a22f5ceb706e88bc16350a5d5d2a82_Out_2_Float);
        float3 _Divide_d7291d1701d7058dbb5263194c1bed22_Out_2_Vector3;
        Unity_Divide_float3(_Add_86c6109dc4530b8c9763ef62b056ad4c_Out_2_Vector3, (_Maximum_94a22f5ceb706e88bc16350a5d5d2a82_Out_2_Float.xxx), _Divide_d7291d1701d7058dbb5263194c1bed22_Out_2_Vector3);
        OutVector4_1 = _Divide_d7291d1701d7058dbb5263194c1bed22_Out_2_Vector3;
        }
        
        void Unity_Clamp_float(float In, float Min, float Max, out float Out)
        {
            Out = clamp(In, Min, Max);
        }
        
        void Unity_Sign_float3(float3 In, out float3 Out)
        {
            Out = sign(In);
        }
        
        void Unity_Multiply_float2_float2(float2 A, float2 B, out float2 Out)
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
        
        void Unity_Absolute_float(float In, out float Out)
        {
            Out = abs(In);
        }
        
        void Unity_Power_float(float A, float B, out float Out)
        {
            Out = pow(A, B);
        }
        
        void Unity_Saturate_float(float In, out float Out)
        {
            Out = saturate(In);
        }
        
        void Unity_Lerp_float3(float3 A, float3 B, float3 T, out float3 Out)
        {
            Out = lerp(A, B, T);
        }
        
        void Unity_Lerp_float(float A, float B, float T, out float Out)
        {
            Out = lerp(A, B, T);
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
            UnityTexture2D _Property_07d75b1d2628da808a2efb93a1d6219e_Out_0_Texture2D = UnityBuildTexture2DStructNoScale(_BaseColorMap);
            float4 _Property_587a28253857318a9b2e59bfc8fb56a4_Out_0_Vector4 = _BaseTilingOffset;
            float _Property_7f998178363b4188ba2f07298ef869c1_Out_0_Boolean = _BaseUsePlanarUV;
            Bindings_PlanarNM_c0f081da9c567704ea36e7dd38cedcf6_float _PlanarNM_0b8fbae0d009788d8cd595a3b9bf9f6e;
            _PlanarNM_0b8fbae0d009788d8cd595a3b9bf9f6e.AbsoluteWorldSpacePosition = IN.AbsoluteWorldSpacePosition;
            _PlanarNM_0b8fbae0d009788d8cd595a3b9bf9f6e.uv0 = IN.uv0;
            _PlanarNM_0b8fbae0d009788d8cd595a3b9bf9f6e.uv3 = IN.uv3;
            float4 _PlanarNM_0b8fbae0d009788d8cd595a3b9bf9f6e_XZ_2_Vector4;
            SG_PlanarNM_c0f081da9c567704ea36e7dd38cedcf6_float(_Property_07d75b1d2628da808a2efb93a1d6219e_Out_0_Texture2D, _Property_587a28253857318a9b2e59bfc8fb56a4_Out_0_Vector4, _Property_7f998178363b4188ba2f07298ef869c1_Out_0_Boolean, UnityBuildSamplerStateStruct(SamplerState_Linear_Repeat_Aniso8), 1, _PlanarNM_0b8fbae0d009788d8cd595a3b9bf9f6e, _PlanarNM_0b8fbae0d009788d8cd595a3b9bf9f6e_XZ_2_Vector4);
            float4 _Property_b83097c58639858680bf43881a95b0af_Out_0_Vector4 = _BaseColor;
            float4 _Multiply_f572ff0def2d308e87a64e94a46c0d96_Out_2_Vector4;
            Unity_Multiply_float4_float4(_PlanarNM_0b8fbae0d009788d8cd595a3b9bf9f6e_XZ_2_Vector4, _Property_b83097c58639858680bf43881a95b0af_Out_0_Vector4, _Multiply_f572ff0def2d308e87a64e94a46c0d96_Out_2_Vector4);
            UnityTexture2D _Property_1e449ff9f8e8ec828507233e8240eb11_Out_0_Texture2D = UnityBuildTexture2DStructNoScale(_BaseMaskMap);
            Bindings_PlanarNM_c0f081da9c567704ea36e7dd38cedcf6_float _PlanarNM_4245c3b264047180b5c90a697d6cb278;
            _PlanarNM_4245c3b264047180b5c90a697d6cb278.AbsoluteWorldSpacePosition = IN.AbsoluteWorldSpacePosition;
            _PlanarNM_4245c3b264047180b5c90a697d6cb278.uv0 = IN.uv0;
            _PlanarNM_4245c3b264047180b5c90a697d6cb278.uv3 = IN.uv3;
            float4 _PlanarNM_4245c3b264047180b5c90a697d6cb278_XZ_2_Vector4;
            SG_PlanarNM_c0f081da9c567704ea36e7dd38cedcf6_float(_Property_1e449ff9f8e8ec828507233e8240eb11_Out_0_Texture2D, _Property_587a28253857318a9b2e59bfc8fb56a4_Out_0_Vector4, _Property_7f998178363b4188ba2f07298ef869c1_Out_0_Boolean, UnityBuildSamplerStateStruct(SamplerState_Linear_Repeat_Aniso8), 1, _PlanarNM_4245c3b264047180b5c90a697d6cb278, _PlanarNM_4245c3b264047180b5c90a697d6cb278_XZ_2_Vector4);
            float _Split_91a015dea8acd38b904ba0935328a5bc_R_1_Float = _PlanarNM_4245c3b264047180b5c90a697d6cb278_XZ_2_Vector4[0];
            float _Split_91a015dea8acd38b904ba0935328a5bc_G_2_Float = _PlanarNM_4245c3b264047180b5c90a697d6cb278_XZ_2_Vector4[1];
            float _Split_91a015dea8acd38b904ba0935328a5bc_B_3_Float = _PlanarNM_4245c3b264047180b5c90a697d6cb278_XZ_2_Vector4[2];
            float _Split_91a015dea8acd38b904ba0935328a5bc_A_4_Float = _PlanarNM_4245c3b264047180b5c90a697d6cb278_XZ_2_Vector4[3];
            float _Property_fbcff1469ebf488394a8a89ddaf0eb2a_Out_0_Float = _HeightMin;
            float _Property_9df7a44c8225168683743ac60c0c3c34_Out_0_Float = _HeightMax;
            float2 _Vector2_9b1e95888c28bc8893f28c02b87fa448_Out_0_Vector2 = float2(_Property_fbcff1469ebf488394a8a89ddaf0eb2a_Out_0_Float, _Property_9df7a44c8225168683743ac60c0c3c34_Out_0_Float);
            float _Property_29ca14fd0b712983a38d63d2dd326e96_Out_0_Float = _HeightOffset;
            float2 _Add_cb503f8a09720d84bb03cbd89e37b80c_Out_2_Vector2;
            Unity_Add_float2(_Vector2_9b1e95888c28bc8893f28c02b87fa448_Out_0_Vector2, (_Property_29ca14fd0b712983a38d63d2dd326e96_Out_0_Float.xx), _Add_cb503f8a09720d84bb03cbd89e37b80c_Out_2_Vector2);
            float _Remap_18f2e96a438d6584ae2fd56f880de9ee_Out_3_Float;
            Unity_Remap_float(_Split_91a015dea8acd38b904ba0935328a5bc_B_3_Float, float2 (0, 1), _Add_cb503f8a09720d84bb03cbd89e37b80c_Out_2_Vector2, _Remap_18f2e96a438d6584ae2fd56f880de9ee_Out_3_Float);
            UnityTexture2D _Property_ba3a5f4cba7d0a8fa288ffc8267d6c0e_Out_0_Texture2D = UnityBuildTexture2DStructNoScale(_Base2ColorMap);
            float4 _Property_86a4657df480d48e8d3ad3b036731380_Out_0_Vector4 = _Base2TilingOffset;
            float _Property_6c5e16c615cab08a97c2a577642b9d83_Out_0_Boolean = _Base2UsePlanarUV;
            Bindings_PlanarNM_c0f081da9c567704ea36e7dd38cedcf6_float _PlanarNM_5aeab444ca6fd78ea56a01215880a5a4;
            _PlanarNM_5aeab444ca6fd78ea56a01215880a5a4.AbsoluteWorldSpacePosition = IN.AbsoluteWorldSpacePosition;
            _PlanarNM_5aeab444ca6fd78ea56a01215880a5a4.uv0 = IN.uv0;
            _PlanarNM_5aeab444ca6fd78ea56a01215880a5a4.uv3 = IN.uv3;
            float4 _PlanarNM_5aeab444ca6fd78ea56a01215880a5a4_XZ_2_Vector4;
            SG_PlanarNM_c0f081da9c567704ea36e7dd38cedcf6_float(_Property_ba3a5f4cba7d0a8fa288ffc8267d6c0e_Out_0_Texture2D, _Property_86a4657df480d48e8d3ad3b036731380_Out_0_Vector4, _Property_6c5e16c615cab08a97c2a577642b9d83_Out_0_Boolean, UnityBuildSamplerStateStruct(SamplerState_Linear_Repeat_Aniso8), 1, _PlanarNM_5aeab444ca6fd78ea56a01215880a5a4, _PlanarNM_5aeab444ca6fd78ea56a01215880a5a4_XZ_2_Vector4);
            float4 _Property_3561b11b899bda8e855826445cf628aa_Out_0_Vector4 = _Base2Color;
            float4 _Multiply_d2ec682582195e84acc4a8510f50f4b0_Out_2_Vector4;
            Unity_Multiply_float4_float4(_PlanarNM_5aeab444ca6fd78ea56a01215880a5a4_XZ_2_Vector4, _Property_3561b11b899bda8e855826445cf628aa_Out_0_Vector4, _Multiply_d2ec682582195e84acc4a8510f50f4b0_Out_2_Vector4);
            float _Split_c34b73d933404283983f9c8bdb5365d3_R_1_Float = IN.VertexColor[0];
            float _Split_c34b73d933404283983f9c8bdb5365d3_G_2_Float = IN.VertexColor[1];
            float _Split_c34b73d933404283983f9c8bdb5365d3_B_3_Float = IN.VertexColor[2];
            float _Split_c34b73d933404283983f9c8bdb5365d3_A_4_Float = IN.VertexColor[3];
            float _Property_df2df7bb5cfc3381beee7ec454da7542_Out_0_Boolean = _Invert_Layer_Mask;
            UnityTexture2D _Property_c7b1e2df9f9b0e8eace9b2274924e69c_Out_0_Texture2D = UnityBuildTexture2DStructNoScale(_LayerMask);
            float4 _SampleTexture2D_175fb18fafc9598382f1f5f7e97bf30a_RGBA_0_Vector4 = SAMPLE_TEXTURE2D(_Property_c7b1e2df9f9b0e8eace9b2274924e69c_Out_0_Texture2D.tex, _Property_c7b1e2df9f9b0e8eace9b2274924e69c_Out_0_Texture2D.samplerstate, _Property_c7b1e2df9f9b0e8eace9b2274924e69c_Out_0_Texture2D.GetTransformedUV(IN.uv0.xy) );
            float _SampleTexture2D_175fb18fafc9598382f1f5f7e97bf30a_R_4_Float = _SampleTexture2D_175fb18fafc9598382f1f5f7e97bf30a_RGBA_0_Vector4.r;
            float _SampleTexture2D_175fb18fafc9598382f1f5f7e97bf30a_G_5_Float = _SampleTexture2D_175fb18fafc9598382f1f5f7e97bf30a_RGBA_0_Vector4.g;
            float _SampleTexture2D_175fb18fafc9598382f1f5f7e97bf30a_B_6_Float = _SampleTexture2D_175fb18fafc9598382f1f5f7e97bf30a_RGBA_0_Vector4.b;
            float _SampleTexture2D_175fb18fafc9598382f1f5f7e97bf30a_A_7_Float = _SampleTexture2D_175fb18fafc9598382f1f5f7e97bf30a_RGBA_0_Vector4.a;
            float _OneMinus_ce5c3c0635d4ac86beb55115d0ebaed7_Out_1_Float;
            Unity_OneMinus_float(_SampleTexture2D_175fb18fafc9598382f1f5f7e97bf30a_R_4_Float, _OneMinus_ce5c3c0635d4ac86beb55115d0ebaed7_Out_1_Float);
            float _Branch_af0c5e511241ce8eae748ae487df50fa_Out_3_Float;
            Unity_Branch_float(_Property_df2df7bb5cfc3381beee7ec454da7542_Out_0_Boolean, _OneMinus_ce5c3c0635d4ac86beb55115d0ebaed7_Out_1_Float, _SampleTexture2D_175fb18fafc9598382f1f5f7e97bf30a_R_4_Float, _Branch_af0c5e511241ce8eae748ae487df50fa_Out_3_Float);
            UnityTexture2D _Property_de4f6eb48a629285a664dad7fb06438f_Out_0_Texture2D = UnityBuildTexture2DStructNoScale(_Base2MaskMap);
            Bindings_PlanarNM_c0f081da9c567704ea36e7dd38cedcf6_float _PlanarNM_d5657f470f05ef839e4c257a20ace8cb;
            _PlanarNM_d5657f470f05ef839e4c257a20ace8cb.AbsoluteWorldSpacePosition = IN.AbsoluteWorldSpacePosition;
            _PlanarNM_d5657f470f05ef839e4c257a20ace8cb.uv0 = IN.uv0;
            _PlanarNM_d5657f470f05ef839e4c257a20ace8cb.uv3 = IN.uv3;
            float4 _PlanarNM_d5657f470f05ef839e4c257a20ace8cb_XZ_2_Vector4;
            SG_PlanarNM_c0f081da9c567704ea36e7dd38cedcf6_float(_Property_de4f6eb48a629285a664dad7fb06438f_Out_0_Texture2D, _Property_86a4657df480d48e8d3ad3b036731380_Out_0_Vector4, _Property_6c5e16c615cab08a97c2a577642b9d83_Out_0_Boolean, UnityBuildSamplerStateStruct(SamplerState_Linear_Repeat_Aniso8), 1, _PlanarNM_d5657f470f05ef839e4c257a20ace8cb, _PlanarNM_d5657f470f05ef839e4c257a20ace8cb_XZ_2_Vector4);
            float _Split_83ec66b648ab6c84848b42686c256cd7_R_1_Float = _PlanarNM_d5657f470f05ef839e4c257a20ace8cb_XZ_2_Vector4[0];
            float _Split_83ec66b648ab6c84848b42686c256cd7_G_2_Float = _PlanarNM_d5657f470f05ef839e4c257a20ace8cb_XZ_2_Vector4[1];
            float _Split_83ec66b648ab6c84848b42686c256cd7_B_3_Float = _PlanarNM_d5657f470f05ef839e4c257a20ace8cb_XZ_2_Vector4[2];
            float _Split_83ec66b648ab6c84848b42686c256cd7_A_4_Float = _PlanarNM_d5657f470f05ef839e4c257a20ace8cb_XZ_2_Vector4[3];
            float _Property_ce1750e5c69e97818667b412fc3f9f2c_Out_0_Float = _HeightMin2;
            float _Property_8e0f2ea54d8ede89bbabdf31a9bafd57_Out_0_Float = _HeightMax2;
            float2 _Vector2_fb6c6dd7e70e768ba686e8e94153bb96_Out_0_Vector2 = float2(_Property_ce1750e5c69e97818667b412fc3f9f2c_Out_0_Float, _Property_8e0f2ea54d8ede89bbabdf31a9bafd57_Out_0_Float);
            float _Property_151ae2702b614585af2000f0a812960f_Out_0_Float = _HeightOffset2;
            float2 _Add_fd1b3d8e24e77087a55888eeb238f1a6_Out_2_Vector2;
            Unity_Add_float2(_Vector2_fb6c6dd7e70e768ba686e8e94153bb96_Out_0_Vector2, (_Property_151ae2702b614585af2000f0a812960f_Out_0_Float.xx), _Add_fd1b3d8e24e77087a55888eeb238f1a6_Out_2_Vector2);
            float _Remap_3d4180c0ab36ba86a5517b2645f0bfa7_Out_3_Float;
            Unity_Remap_float(_Split_83ec66b648ab6c84848b42686c256cd7_B_3_Float, float2 (0, 1), _Add_fd1b3d8e24e77087a55888eeb238f1a6_Out_2_Vector2, _Remap_3d4180c0ab36ba86a5517b2645f0bfa7_Out_3_Float);
            float _Multiply_2cb0e5aa384654828f0453a44884573c_Out_2_Float;
            Unity_Multiply_float_float(_Branch_af0c5e511241ce8eae748ae487df50fa_Out_3_Float, _Remap_3d4180c0ab36ba86a5517b2645f0bfa7_Out_3_Float, _Multiply_2cb0e5aa384654828f0453a44884573c_Out_2_Float);
            float _Multiply_74def30593cbbb8bbed03613a31cb89a_Out_2_Float;
            Unity_Multiply_float_float(_Split_c34b73d933404283983f9c8bdb5365d3_G_2_Float, _Multiply_2cb0e5aa384654828f0453a44884573c_Out_2_Float, _Multiply_74def30593cbbb8bbed03613a31cb89a_Out_2_Float);
            float _Property_818c8af4b930138e81034c886614171d_Out_0_Float = _Height_Transition;
            Bindings_HeightBlend_d15b6fb865d3b6d4ebc1fd476c3ad135_float _HeightBlend_7501025b3a60738a9a9d362e35a9ab48;
            float3 _HeightBlend_7501025b3a60738a9a9d362e35a9ab48_OutVector4_1_Vector3;
            SG_HeightBlend_d15b6fb865d3b6d4ebc1fd476c3ad135_float((_Multiply_f572ff0def2d308e87a64e94a46c0d96_Out_2_Vector4.xyz), _Remap_18f2e96a438d6584ae2fd56f880de9ee_Out_3_Float, (_Multiply_d2ec682582195e84acc4a8510f50f4b0_Out_2_Vector4.xyz), _Multiply_74def30593cbbb8bbed03613a31cb89a_Out_2_Float, _Property_818c8af4b930138e81034c886614171d_Out_0_Float, _HeightBlend_7501025b3a60738a9a9d362e35a9ab48, _HeightBlend_7501025b3a60738a9a9d362e35a9ab48_OutVector4_1_Vector3);
            UnityTexture2D _Property_c0ebdab0f71ace8aabaa865fd7293599_Out_0_Texture2D = UnityBuildTexture2DStructNoScale(_CoverBaseColorMap);
            float4 _Property_822489d2e6d3e08590c64f085ffd9b2e_Out_0_Vector4 = _CoverTilingOffset;
            float _Property_2ae4a163bd21d98789af282d6e469175_Out_0_Boolean = _CoverUsePlanarUV;
            Bindings_PlanarNM_c0f081da9c567704ea36e7dd38cedcf6_float _PlanarNM_8bb420494d19b28e9ccdff489802dc81;
            _PlanarNM_8bb420494d19b28e9ccdff489802dc81.AbsoluteWorldSpacePosition = IN.AbsoluteWorldSpacePosition;
            _PlanarNM_8bb420494d19b28e9ccdff489802dc81.uv0 = IN.uv0;
            _PlanarNM_8bb420494d19b28e9ccdff489802dc81.uv3 = IN.uv3;
            float4 _PlanarNM_8bb420494d19b28e9ccdff489802dc81_XZ_2_Vector4;
            SG_PlanarNM_c0f081da9c567704ea36e7dd38cedcf6_float(_Property_c0ebdab0f71ace8aabaa865fd7293599_Out_0_Texture2D, _Property_822489d2e6d3e08590c64f085ffd9b2e_Out_0_Vector4, _Property_2ae4a163bd21d98789af282d6e469175_Out_0_Boolean, UnityBuildSamplerStateStruct(SamplerState_Linear_Repeat_Aniso8), 1, _PlanarNM_8bb420494d19b28e9ccdff489802dc81, _PlanarNM_8bb420494d19b28e9ccdff489802dc81_XZ_2_Vector4);
            float4 _Property_55e7941fa7ac5f8387aa9bb633b08883_Out_0_Vector4 = _CoverBaseColor;
            float4 _Multiply_a38ba695a2660c8691763f0bd7fe159c_Out_2_Vector4;
            Unity_Multiply_float4_float4(_PlanarNM_8bb420494d19b28e9ccdff489802dc81_XZ_2_Vector4, _Property_55e7941fa7ac5f8387aa9bb633b08883_Out_0_Vector4, _Multiply_a38ba695a2660c8691763f0bd7fe159c_Out_2_Vector4);
            UnityTexture2D _Property_3b351481f7b944ffaf5f59649df41ba9_Out_0_Texture2D = UnityBuildTexture2DStructNoScale(_CoverBaseColorMap);
            float4 _UV_5352c8dd0add178ba83a5421c2c0b3f0_Out_0_Vector4 = IN.uv0;
            float4 _SampleTexture2D_024ba490c015248988a12a9d670014ea_RGBA_0_Vector4 = SAMPLE_TEXTURE2D(_Property_3b351481f7b944ffaf5f59649df41ba9_Out_0_Texture2D.tex, _Property_3b351481f7b944ffaf5f59649df41ba9_Out_0_Texture2D.samplerstate, _Property_3b351481f7b944ffaf5f59649df41ba9_Out_0_Texture2D.GetTransformedUV((_UV_5352c8dd0add178ba83a5421c2c0b3f0_Out_0_Vector4.xy)) );
            float _SampleTexture2D_024ba490c015248988a12a9d670014ea_R_4_Float = _SampleTexture2D_024ba490c015248988a12a9d670014ea_RGBA_0_Vector4.r;
            float _SampleTexture2D_024ba490c015248988a12a9d670014ea_G_5_Float = _SampleTexture2D_024ba490c015248988a12a9d670014ea_RGBA_0_Vector4.g;
            float _SampleTexture2D_024ba490c015248988a12a9d670014ea_B_6_Float = _SampleTexture2D_024ba490c015248988a12a9d670014ea_RGBA_0_Vector4.b;
            float _SampleTexture2D_024ba490c015248988a12a9d670014ea_A_7_Float = _SampleTexture2D_024ba490c015248988a12a9d670014ea_RGBA_0_Vector4.a;
            float _Property_b80e7b96604b7c82bbf9bff4981fad76_Out_0_Float = _CoverMaskPower;
            float _Multiply_abe410d256783480b1b58468bf78a882_Out_2_Float;
            Unity_Multiply_float_float(_SampleTexture2D_024ba490c015248988a12a9d670014ea_A_7_Float, _Property_b80e7b96604b7c82bbf9bff4981fad76_Out_0_Float, _Multiply_abe410d256783480b1b58468bf78a882_Out_2_Float);
            float _Clamp_a78f6f28770afd869adb9d12cd47370b_Out_3_Float;
            Unity_Clamp_float(_Multiply_abe410d256783480b1b58468bf78a882_Out_2_Float, float(0), float(1), _Clamp_a78f6f28770afd869adb9d12cd47370b_Out_3_Float);
            UnityTexture2D _Property_7c7049e15fdff386b535790d8666f609_Out_0_Texture2D = UnityBuildTexture2DStructNoScale(_BaseNormalMap);
            Bindings_PlanarNMn_1b93a87456f9d4c419321d0cd92bd6c8_float _PlanarNMn_a3713a9c3874b6838d0eda971b9c62d8;
            _PlanarNMn_a3713a9c3874b6838d0eda971b9c62d8.WorldSpaceNormal = IN.WorldSpaceNormal;
            _PlanarNMn_a3713a9c3874b6838d0eda971b9c62d8.WorldSpaceTangent = IN.WorldSpaceTangent;
            _PlanarNMn_a3713a9c3874b6838d0eda971b9c62d8.WorldSpaceBiTangent = IN.WorldSpaceBiTangent;
            _PlanarNMn_a3713a9c3874b6838d0eda971b9c62d8.AbsoluteWorldSpacePosition = IN.AbsoluteWorldSpacePosition;
            _PlanarNMn_a3713a9c3874b6838d0eda971b9c62d8.uv0 = IN.uv0;
            _PlanarNMn_a3713a9c3874b6838d0eda971b9c62d8.uv3 = IN.uv3;
            float4 _PlanarNMn_a3713a9c3874b6838d0eda971b9c62d8_XZ_2_Vector4;
            SG_PlanarNMn_1b93a87456f9d4c419321d0cd92bd6c8_float(_Property_7c7049e15fdff386b535790d8666f609_Out_0_Texture2D, _Property_587a28253857318a9b2e59bfc8fb56a4_Out_0_Vector4, _Property_7f998178363b4188ba2f07298ef869c1_Out_0_Boolean, UnityBuildSamplerStateStruct(SamplerState_Linear_Repeat_Aniso8), 1, _PlanarNMn_a3713a9c3874b6838d0eda971b9c62d8, _PlanarNMn_a3713a9c3874b6838d0eda971b9c62d8_XZ_2_Vector4);
            float _Property_d4b0759cf4647e81be065ec1465ce2b4_Out_0_Float = _BaseNormalScale;
            float3 _NormalStrength_f66a9108ea294886acc61513b41cc5e4_Out_2_Vector3;
            Unity_NormalStrength_float((_PlanarNMn_a3713a9c3874b6838d0eda971b9c62d8_XZ_2_Vector4.xyz), _Property_d4b0759cf4647e81be065ec1465ce2b4_Out_0_Float, _NormalStrength_f66a9108ea294886acc61513b41cc5e4_Out_2_Vector3);
            UnityTexture2D _Property_fa9f7890b20ad481a92543c04b237bde_Out_0_Texture2D = UnityBuildTexture2DStructNoScale(_Base2NormalMap);
            Bindings_PlanarNMn_1b93a87456f9d4c419321d0cd92bd6c8_float _PlanarNMn_d7b3ec528088a085a5102e025a1b45cf;
            _PlanarNMn_d7b3ec528088a085a5102e025a1b45cf.WorldSpaceNormal = IN.WorldSpaceNormal;
            _PlanarNMn_d7b3ec528088a085a5102e025a1b45cf.WorldSpaceTangent = IN.WorldSpaceTangent;
            _PlanarNMn_d7b3ec528088a085a5102e025a1b45cf.WorldSpaceBiTangent = IN.WorldSpaceBiTangent;
            _PlanarNMn_d7b3ec528088a085a5102e025a1b45cf.AbsoluteWorldSpacePosition = IN.AbsoluteWorldSpacePosition;
            _PlanarNMn_d7b3ec528088a085a5102e025a1b45cf.uv0 = IN.uv0;
            _PlanarNMn_d7b3ec528088a085a5102e025a1b45cf.uv3 = IN.uv3;
            float4 _PlanarNMn_d7b3ec528088a085a5102e025a1b45cf_XZ_2_Vector4;
            SG_PlanarNMn_1b93a87456f9d4c419321d0cd92bd6c8_float(_Property_fa9f7890b20ad481a92543c04b237bde_Out_0_Texture2D, _Property_86a4657df480d48e8d3ad3b036731380_Out_0_Vector4, _Property_6c5e16c615cab08a97c2a577642b9d83_Out_0_Boolean, UnityBuildSamplerStateStruct(SamplerState_Linear_Repeat_Aniso8), 1, _PlanarNMn_d7b3ec528088a085a5102e025a1b45cf, _PlanarNMn_d7b3ec528088a085a5102e025a1b45cf_XZ_2_Vector4);
            float _Property_8c31443b776727819a663c7ddce79064_Out_0_Float = _Base2NormalScale;
            float3 _NormalStrength_0fb86880ab8e368dac6d01b830e20ed8_Out_2_Vector3;
            Unity_NormalStrength_float((_PlanarNMn_d7b3ec528088a085a5102e025a1b45cf_XZ_2_Vector4.xyz), _Property_8c31443b776727819a663c7ddce79064_Out_0_Float, _NormalStrength_0fb86880ab8e368dac6d01b830e20ed8_Out_2_Vector3);
            Bindings_HeightBlend_d15b6fb865d3b6d4ebc1fd476c3ad135_float _HeightBlend_7c09d97625efce898e21b66cd039be8b;
            float3 _HeightBlend_7c09d97625efce898e21b66cd039be8b_OutVector4_1_Vector3;
            SG_HeightBlend_d15b6fb865d3b6d4ebc1fd476c3ad135_float(_NormalStrength_f66a9108ea294886acc61513b41cc5e4_Out_2_Vector3, _Remap_18f2e96a438d6584ae2fd56f880de9ee_Out_3_Float, _NormalStrength_0fb86880ab8e368dac6d01b830e20ed8_Out_2_Vector3, _Multiply_74def30593cbbb8bbed03613a31cb89a_Out_2_Float, _Property_818c8af4b930138e81034c886614171d_Out_0_Float, _HeightBlend_7c09d97625efce898e21b66cd039be8b, _HeightBlend_7c09d97625efce898e21b66cd039be8b_OutVector4_1_Vector3);
            UnityTexture2D _Property_65f7dd6fe6c29b83913af586c597a1ef_Out_0_Texture2D = UnityBuildTexture2DStructNoScale(_CoverNormalMap);
            Bindings_PlanarNMn_1b93a87456f9d4c419321d0cd92bd6c8_float _PlanarNMn_248bc5b7421d3f828d166902c73ca6c3;
            _PlanarNMn_248bc5b7421d3f828d166902c73ca6c3.WorldSpaceNormal = IN.WorldSpaceNormal;
            _PlanarNMn_248bc5b7421d3f828d166902c73ca6c3.WorldSpaceTangent = IN.WorldSpaceTangent;
            _PlanarNMn_248bc5b7421d3f828d166902c73ca6c3.WorldSpaceBiTangent = IN.WorldSpaceBiTangent;
            _PlanarNMn_248bc5b7421d3f828d166902c73ca6c3.AbsoluteWorldSpacePosition = IN.AbsoluteWorldSpacePosition;
            _PlanarNMn_248bc5b7421d3f828d166902c73ca6c3.uv0 = IN.uv0;
            _PlanarNMn_248bc5b7421d3f828d166902c73ca6c3.uv3 = IN.uv3;
            float4 _PlanarNMn_248bc5b7421d3f828d166902c73ca6c3_XZ_2_Vector4;
            SG_PlanarNMn_1b93a87456f9d4c419321d0cd92bd6c8_float(_Property_65f7dd6fe6c29b83913af586c597a1ef_Out_0_Texture2D, _Property_822489d2e6d3e08590c64f085ffd9b2e_Out_0_Vector4, _Property_2ae4a163bd21d98789af282d6e469175_Out_0_Boolean, UnityBuildSamplerStateStruct(SamplerState_Linear_Repeat_Aniso8), 1, _PlanarNMn_248bc5b7421d3f828d166902c73ca6c3, _PlanarNMn_248bc5b7421d3f828d166902c73ca6c3_XZ_2_Vector4);
            float _Property_19f92cae42737480a95820c51d4ba124_Out_0_Float = _CoverNormalBlendHardness;
            float3 _NormalStrength_2c3488591b8345869feb25a3dee06c3f_Out_2_Vector3;
            Unity_NormalStrength_float((_PlanarNMn_248bc5b7421d3f828d166902c73ca6c3_XZ_2_Vector4.xyz), _Property_19f92cae42737480a95820c51d4ba124_Out_0_Float, _NormalStrength_2c3488591b8345869feb25a3dee06c3f_Out_2_Vector3);
            float _Split_96bfe9cb80ad308385c191d094b3d071_R_1_Float = IN.WorldSpaceNormal[0];
            float _Split_96bfe9cb80ad308385c191d094b3d071_G_2_Float = IN.WorldSpaceNormal[1];
            float _Split_96bfe9cb80ad308385c191d094b3d071_B_3_Float = IN.WorldSpaceNormal[2];
            float _Split_96bfe9cb80ad308385c191d094b3d071_A_4_Float = 0;
            float _Property_0dd796aae8cd9f878bef13ceac4fe3ec_Out_0_Float = _Cover_Amount;
            float _Property_67285cdc688aa38d83f62d5bb095d597_Out_0_Float = _Cover_Amount_Grow_Speed;
            float _Subtract_fcefec675e7536888eccf5574d921972_Out_2_Float;
            Unity_Subtract_float(float(4), _Property_67285cdc688aa38d83f62d5bb095d597_Out_0_Float, _Subtract_fcefec675e7536888eccf5574d921972_Out_2_Float);
            float _Divide_1e25465528e612839a4ce1faedd89e7d_Out_2_Float;
            Unity_Divide_float(_Property_0dd796aae8cd9f878bef13ceac4fe3ec_Out_0_Float, _Subtract_fcefec675e7536888eccf5574d921972_Out_2_Float, _Divide_1e25465528e612839a4ce1faedd89e7d_Out_2_Float);
            float _Absolute_d20b810ffdec828ab74dd6692d82f01b_Out_1_Float;
            Unity_Absolute_float(_Divide_1e25465528e612839a4ce1faedd89e7d_Out_2_Float, _Absolute_d20b810ffdec828ab74dd6692d82f01b_Out_1_Float);
            float _Power_181fbf47cfdb258da1fe0b72a450986f_Out_2_Float;
            Unity_Power_float(_Absolute_d20b810ffdec828ab74dd6692d82f01b_Out_1_Float, _Subtract_fcefec675e7536888eccf5574d921972_Out_2_Float, _Power_181fbf47cfdb258da1fe0b72a450986f_Out_2_Float);
            float _Clamp_11f62dba01f1a38c9e0a9972ccd19246_Out_3_Float;
            Unity_Clamp_float(_Power_181fbf47cfdb258da1fe0b72a450986f_Out_2_Float, float(0), float(2), _Clamp_11f62dba01f1a38c9e0a9972ccd19246_Out_3_Float);
            float _Multiply_9810f6d76275cd8fbe5e3a02360b98a7_Out_2_Float;
            Unity_Multiply_float_float(_Split_96bfe9cb80ad308385c191d094b3d071_G_2_Float, _Clamp_11f62dba01f1a38c9e0a9972ccd19246_Out_3_Float, _Multiply_9810f6d76275cd8fbe5e3a02360b98a7_Out_2_Float);
            float _Saturate_a007c5f214685c87bf6ca3e64c06b488_Out_1_Float;
            Unity_Saturate_float(_Multiply_9810f6d76275cd8fbe5e3a02360b98a7_Out_2_Float, _Saturate_a007c5f214685c87bf6ca3e64c06b488_Out_1_Float);
            float _Clamp_1b2b25b617fc508b9835f0309136fd00_Out_3_Float;
            Unity_Clamp_float(_Split_96bfe9cb80ad308385c191d094b3d071_G_2_Float, float(0), float(0.9999), _Clamp_1b2b25b617fc508b9835f0309136fd00_Out_3_Float);
            float _Property_7b12276ea7a4538db6804507b30a830c_Out_0_Float = _Cover_Max_Angle;
            float _Divide_54c523ff4b7acb858e9e368fd1e4d34a_Out_2_Float;
            Unity_Divide_float(_Property_7b12276ea7a4538db6804507b30a830c_Out_0_Float, float(45), _Divide_54c523ff4b7acb858e9e368fd1e4d34a_Out_2_Float);
            float _OneMinus_6cf431985b651e8e9546ae6cb2d4d668_Out_1_Float;
            Unity_OneMinus_float(_Divide_54c523ff4b7acb858e9e368fd1e4d34a_Out_2_Float, _OneMinus_6cf431985b651e8e9546ae6cb2d4d668_Out_1_Float);
            float _Subtract_4ef7b60aeab8d589bf2d2423737642bc_Out_2_Float;
            Unity_Subtract_float(_Clamp_1b2b25b617fc508b9835f0309136fd00_Out_3_Float, _OneMinus_6cf431985b651e8e9546ae6cb2d4d668_Out_1_Float, _Subtract_4ef7b60aeab8d589bf2d2423737642bc_Out_2_Float);
            float _Clamp_a4b51894ea17818c9a27bb533a2ebe74_Out_3_Float;
            Unity_Clamp_float(_Subtract_4ef7b60aeab8d589bf2d2423737642bc_Out_2_Float, float(0), float(2), _Clamp_a4b51894ea17818c9a27bb533a2ebe74_Out_3_Float);
            float _Divide_c4196d4f02190b89ba827ccd4ae8a74d_Out_2_Float;
            Unity_Divide_float(float(1), _Divide_54c523ff4b7acb858e9e368fd1e4d34a_Out_2_Float, _Divide_c4196d4f02190b89ba827ccd4ae8a74d_Out_2_Float);
            float _Multiply_ffc22433163d1184846ede424b44bcb2_Out_2_Float;
            Unity_Multiply_float_float(_Clamp_a4b51894ea17818c9a27bb533a2ebe74_Out_3_Float, _Divide_c4196d4f02190b89ba827ccd4ae8a74d_Out_2_Float, _Multiply_ffc22433163d1184846ede424b44bcb2_Out_2_Float);
            float _Absolute_c2e5757082de5d878d4c023806fb2108_Out_1_Float;
            Unity_Absolute_float(_Multiply_ffc22433163d1184846ede424b44bcb2_Out_2_Float, _Absolute_c2e5757082de5d878d4c023806fb2108_Out_1_Float);
            float _Property_849d9f217c95f38c9d49ab251578d8d5_Out_0_Float = _CoverHardness;
            float _Power_578546d66d69a5829b745ebba1279adf_Out_2_Float;
            Unity_Power_float(_Absolute_c2e5757082de5d878d4c023806fb2108_Out_1_Float, _Property_849d9f217c95f38c9d49ab251578d8d5_Out_0_Float, _Power_578546d66d69a5829b745ebba1279adf_Out_2_Float);
            float _Property_34d2d3aff4814e8e83d2894b3512c6c8_Out_0_Float = _Cover_Min_Height;
            float _OneMinus_474df64227f004849b34c68fe8df93f2_Out_1_Float;
            Unity_OneMinus_float(_Property_34d2d3aff4814e8e83d2894b3512c6c8_Out_0_Float, _OneMinus_474df64227f004849b34c68fe8df93f2_Out_1_Float);
            float _Split_ee4d9dc934b3508397d5a3dece110ab0_R_1_Float = IN.AbsoluteWorldSpacePosition[0];
            float _Split_ee4d9dc934b3508397d5a3dece110ab0_G_2_Float = IN.AbsoluteWorldSpacePosition[1];
            float _Split_ee4d9dc934b3508397d5a3dece110ab0_B_3_Float = IN.AbsoluteWorldSpacePosition[2];
            float _Split_ee4d9dc934b3508397d5a3dece110ab0_A_4_Float = 0;
            float _Add_d6bc513aa82d918ea24e279f4353d971_Out_2_Float;
            Unity_Add_float(_OneMinus_474df64227f004849b34c68fe8df93f2_Out_1_Float, _Split_ee4d9dc934b3508397d5a3dece110ab0_G_2_Float, _Add_d6bc513aa82d918ea24e279f4353d971_Out_2_Float);
            float _Add_a6a61cb12180108c9e1364b90d2673e2_Out_2_Float;
            Unity_Add_float(_Add_d6bc513aa82d918ea24e279f4353d971_Out_2_Float, float(1), _Add_a6a61cb12180108c9e1364b90d2673e2_Out_2_Float);
            float _Clamp_1874fdd00cb9aa839d93ab8536e2414d_Out_3_Float;
            Unity_Clamp_float(_Add_a6a61cb12180108c9e1364b90d2673e2_Out_2_Float, float(0), float(1), _Clamp_1874fdd00cb9aa839d93ab8536e2414d_Out_3_Float);
            float _Property_7b91fd6e21b46c85816c7b681307cbe4_Out_0_Float = _Cover_Min_Height_Blending;
            float _Add_6dca9453f6a35e8185c4b8e9782db0a9_Out_2_Float;
            Unity_Add_float(_Add_d6bc513aa82d918ea24e279f4353d971_Out_2_Float, _Property_7b91fd6e21b46c85816c7b681307cbe4_Out_0_Float, _Add_6dca9453f6a35e8185c4b8e9782db0a9_Out_2_Float);
            float _Divide_83415a319ecfba83af914cbc5487b546_Out_2_Float;
            Unity_Divide_float(_Add_6dca9453f6a35e8185c4b8e9782db0a9_Out_2_Float, _Add_d6bc513aa82d918ea24e279f4353d971_Out_2_Float, _Divide_83415a319ecfba83af914cbc5487b546_Out_2_Float);
            float _OneMinus_bf150b22fcad5a87b7c825c9c6cf1687_Out_1_Float;
            Unity_OneMinus_float(_Divide_83415a319ecfba83af914cbc5487b546_Out_2_Float, _OneMinus_bf150b22fcad5a87b7c825c9c6cf1687_Out_1_Float);
            float _Add_86ff9fa850efbe8c80705d8266609dab_Out_2_Float;
            Unity_Add_float(_OneMinus_bf150b22fcad5a87b7c825c9c6cf1687_Out_1_Float, float(-0.5), _Add_86ff9fa850efbe8c80705d8266609dab_Out_2_Float);
            float _Clamp_906e140f01222d8ba61252ec6ec9d6a4_Out_3_Float;
            Unity_Clamp_float(_Add_86ff9fa850efbe8c80705d8266609dab_Out_2_Float, float(0), float(1), _Clamp_906e140f01222d8ba61252ec6ec9d6a4_Out_3_Float);
            float _Add_c1ec5849bf72f585a30b3e11a91ada52_Out_2_Float;
            Unity_Add_float(_Clamp_1874fdd00cb9aa839d93ab8536e2414d_Out_3_Float, _Clamp_906e140f01222d8ba61252ec6ec9d6a4_Out_3_Float, _Add_c1ec5849bf72f585a30b3e11a91ada52_Out_2_Float);
            float _Clamp_17a8a0cf209a038b9e9c7f5681cdd1fb_Out_3_Float;
            Unity_Clamp_float(_Add_c1ec5849bf72f585a30b3e11a91ada52_Out_2_Float, float(0), float(1), _Clamp_17a8a0cf209a038b9e9c7f5681cdd1fb_Out_3_Float);
            float _Multiply_8c2759ac24a9b289b1e9610cfd161bb0_Out_2_Float;
            Unity_Multiply_float_float(_Power_578546d66d69a5829b745ebba1279adf_Out_2_Float, _Clamp_17a8a0cf209a038b9e9c7f5681cdd1fb_Out_3_Float, _Multiply_8c2759ac24a9b289b1e9610cfd161bb0_Out_2_Float);
            float _Multiply_1a723f136ec7fa8c957b5d29e03d3051_Out_2_Float;
            Unity_Multiply_float_float(_Saturate_a007c5f214685c87bf6ca3e64c06b488_Out_1_Float, _Multiply_8c2759ac24a9b289b1e9610cfd161bb0_Out_2_Float, _Multiply_1a723f136ec7fa8c957b5d29e03d3051_Out_2_Float);
            float3 _Lerp_d1c72e47b283948584479177786ae8d5_Out_3_Vector3;
            Unity_Lerp_float3(_HeightBlend_7c09d97625efce898e21b66cd039be8b_OutVector4_1_Vector3, _NormalStrength_2c3488591b8345869feb25a3dee06c3f_Out_2_Vector3, (_Multiply_1a723f136ec7fa8c957b5d29e03d3051_Out_2_Float.xxx), _Lerp_d1c72e47b283948584479177786ae8d5_Out_3_Vector3);
            float3 _Transform_180fb403b53f318db002e8eba7616644_Out_1_Vector3;
            {
                float3x3 tangentTransform = float3x3(IN.WorldSpaceTangent, IN.WorldSpaceBiTangent, IN.WorldSpaceNormal);
                _Transform_180fb403b53f318db002e8eba7616644_Out_1_Vector3 = TransformTangentToWorldDir(_Lerp_d1c72e47b283948584479177786ae8d5_Out_3_Vector3.xyz, tangentTransform, true).xyz;
            }
            float _Split_c9a2b4fb4f688b8ebfc1436535cd5ba4_R_1_Float = _Transform_180fb403b53f318db002e8eba7616644_Out_1_Vector3[0];
            float _Split_c9a2b4fb4f688b8ebfc1436535cd5ba4_G_2_Float = _Transform_180fb403b53f318db002e8eba7616644_Out_1_Vector3[1];
            float _Split_c9a2b4fb4f688b8ebfc1436535cd5ba4_B_3_Float = _Transform_180fb403b53f318db002e8eba7616644_Out_1_Vector3[2];
            float _Split_c9a2b4fb4f688b8ebfc1436535cd5ba4_A_4_Float = 0;
            float _Multiply_4c7631d0688102819e6d388d624855a1_Out_2_Float;
            Unity_Multiply_float_float(_Split_c9a2b4fb4f688b8ebfc1436535cd5ba4_G_2_Float, _Clamp_11f62dba01f1a38c9e0a9972ccd19246_Out_3_Float, _Multiply_4c7631d0688102819e6d388d624855a1_Out_2_Float);
            float _Multiply_f2887eb409f6bb81ae4caad2b01b17f1_Out_2_Float;
            Unity_Multiply_float_float(_Clamp_11f62dba01f1a38c9e0a9972ccd19246_Out_3_Float, _Property_849d9f217c95f38c9d49ab251578d8d5_Out_0_Float, _Multiply_f2887eb409f6bb81ae4caad2b01b17f1_Out_2_Float);
            float _Multiply_2e348ed31331e78791b2b3130a009f30_Out_2_Float;
            Unity_Multiply_float_float(_Multiply_f2887eb409f6bb81ae4caad2b01b17f1_Out_2_Float, _Multiply_8c2759ac24a9b289b1e9610cfd161bb0_Out_2_Float, _Multiply_2e348ed31331e78791b2b3130a009f30_Out_2_Float);
            float _Multiply_622e54e9a77b08839c0954ce5715ad1c_Out_2_Float;
            Unity_Multiply_float_float(_Multiply_4c7631d0688102819e6d388d624855a1_Out_2_Float, _Multiply_2e348ed31331e78791b2b3130a009f30_Out_2_Float, _Multiply_622e54e9a77b08839c0954ce5715ad1c_Out_2_Float);
            UnityTexture2D _Property_608db04fab7d768d9a8b5fb9cf0768e1_Out_0_Texture2D = UnityBuildTexture2DStructNoScale(_CoverMaskMap);
            Bindings_PlanarNM_c0f081da9c567704ea36e7dd38cedcf6_float _PlanarNM_819c993d9b62a28ea640d2bacdc62c6e;
            _PlanarNM_819c993d9b62a28ea640d2bacdc62c6e.AbsoluteWorldSpacePosition = IN.AbsoluteWorldSpacePosition;
            _PlanarNM_819c993d9b62a28ea640d2bacdc62c6e.uv0 = IN.uv0;
            _PlanarNM_819c993d9b62a28ea640d2bacdc62c6e.uv3 = IN.uv3;
            float4 _PlanarNM_819c993d9b62a28ea640d2bacdc62c6e_XZ_2_Vector4;
            SG_PlanarNM_c0f081da9c567704ea36e7dd38cedcf6_float(_Property_608db04fab7d768d9a8b5fb9cf0768e1_Out_0_Texture2D, _Property_822489d2e6d3e08590c64f085ffd9b2e_Out_0_Vector4, _Property_2ae4a163bd21d98789af282d6e469175_Out_0_Boolean, UnityBuildSamplerStateStruct(SamplerState_Linear_Repeat_Aniso8), 1, _PlanarNM_819c993d9b62a28ea640d2bacdc62c6e, _PlanarNM_819c993d9b62a28ea640d2bacdc62c6e_XZ_2_Vector4);
            float _Split_86ec1aefda4f9e8e82b79c6195b397b0_R_1_Float = _PlanarNM_819c993d9b62a28ea640d2bacdc62c6e_XZ_2_Vector4[0];
            float _Split_86ec1aefda4f9e8e82b79c6195b397b0_G_2_Float = _PlanarNM_819c993d9b62a28ea640d2bacdc62c6e_XZ_2_Vector4[1];
            float _Split_86ec1aefda4f9e8e82b79c6195b397b0_B_3_Float = _PlanarNM_819c993d9b62a28ea640d2bacdc62c6e_XZ_2_Vector4[2];
            float _Split_86ec1aefda4f9e8e82b79c6195b397b0_A_4_Float = _PlanarNM_819c993d9b62a28ea640d2bacdc62c6e_XZ_2_Vector4[3];
            float _Property_c9c6897e00458b8f8aa07df49fa519bc_Out_0_Float = _CoverHeightMapMin;
            float _Property_ab94650b8edd82828661fe99e3c0e849_Out_0_Float = _CoverHeightMapMax;
            float2 _Vector2_fe489f7321f6568686816b9eecbc16d1_Out_0_Vector2 = float2(_Property_c9c6897e00458b8f8aa07df49fa519bc_Out_0_Float, _Property_ab94650b8edd82828661fe99e3c0e849_Out_0_Float);
            float _Property_c1ab40024cb83b87960e4327efbd997f_Out_0_Float = _CoverHeightMapOffset;
            float2 _Add_4a359522fc231c83b55ef23f341b6fb3_Out_2_Vector2;
            Unity_Add_float2(_Vector2_fe489f7321f6568686816b9eecbc16d1_Out_0_Vector2, (_Property_c1ab40024cb83b87960e4327efbd997f_Out_0_Float.xx), _Add_4a359522fc231c83b55ef23f341b6fb3_Out_2_Vector2);
            float _Remap_5aee5b64d41562858dc7c42d8b748894_Out_3_Float;
            Unity_Remap_float(_Split_86ec1aefda4f9e8e82b79c6195b397b0_B_3_Float, float2 (0, 1), _Add_4a359522fc231c83b55ef23f341b6fb3_Out_2_Vector2, _Remap_5aee5b64d41562858dc7c42d8b748894_Out_3_Float);
            float _Multiply_f0228e1cfd9c858dbb36367f551733c4_Out_2_Float;
            Unity_Multiply_float_float(_Multiply_622e54e9a77b08839c0954ce5715ad1c_Out_2_Float, _Remap_5aee5b64d41562858dc7c42d8b748894_Out_3_Float, _Multiply_f0228e1cfd9c858dbb36367f551733c4_Out_2_Float);
            float _Multiply_bb4d60728db93b8a9af9635fa1d69891_Out_2_Float;
            Unity_Multiply_float_float(_Split_c34b73d933404283983f9c8bdb5365d3_B_3_Float, _Multiply_f0228e1cfd9c858dbb36367f551733c4_Out_2_Float, _Multiply_bb4d60728db93b8a9af9635fa1d69891_Out_2_Float);
            float _Saturate_9b052a9bb99eff89bb11bdc387a0c2fd_Out_1_Float;
            Unity_Saturate_float(_Multiply_bb4d60728db93b8a9af9635fa1d69891_Out_2_Float, _Saturate_9b052a9bb99eff89bb11bdc387a0c2fd_Out_1_Float);
            float _Multiply_22fb8c1cfd28b687a991e101aa13ff5b_Out_2_Float;
            Unity_Multiply_float_float(_Clamp_a78f6f28770afd869adb9d12cd47370b_Out_3_Float, _Saturate_9b052a9bb99eff89bb11bdc387a0c2fd_Out_1_Float, _Multiply_22fb8c1cfd28b687a991e101aa13ff5b_Out_2_Float);
            #if defined(_USEDYNAMICCOVERTSTATICMASKF_ON)
            float _UseDynamicCoverTStaticMaskF_20dcbac2f16cf78ebd6fd1debcd7f281_Out_0_Float = _Multiply_22fb8c1cfd28b687a991e101aa13ff5b_Out_2_Float;
            #else
            float _UseDynamicCoverTStaticMaskF_20dcbac2f16cf78ebd6fd1debcd7f281_Out_0_Float = _Clamp_a78f6f28770afd869adb9d12cd47370b_Out_3_Float;
            #endif
            float3 _Lerp_e5620b57c917728fa1416e2ffce9b0db_Out_3_Vector3;
            Unity_Lerp_float3(_HeightBlend_7501025b3a60738a9a9d362e35a9ab48_OutVector4_1_Vector3, (_Multiply_a38ba695a2660c8691763f0bd7fe159c_Out_2_Vector4.xyz), (_UseDynamicCoverTStaticMaskF_20dcbac2f16cf78ebd6fd1debcd7f281_Out_0_Float.xxx), _Lerp_e5620b57c917728fa1416e2ffce9b0db_Out_3_Vector3);
            float4 _Property_7946b761100c49199abc52129949bc94_Out_0_Vector4 = _WetColor;
            float3 _Multiply_f722561c89f8451497c9823ad4f29f4a_Out_2_Vector3;
            Unity_Multiply_float3_float3((_Property_7946b761100c49199abc52129949bc94_Out_0_Vector4.xyz), _Lerp_e5620b57c917728fa1416e2ffce9b0db_Out_3_Vector3, _Multiply_f722561c89f8451497c9823ad4f29f4a_Out_2_Vector3);
            float _OneMinus_6ed96e068e394cd09ae03c32446777c8_Out_1_Float;
            Unity_OneMinus_float(_Split_c34b73d933404283983f9c8bdb5365d3_R_1_Float, _OneMinus_6ed96e068e394cd09ae03c32446777c8_Out_1_Float);
            float3 _Lerp_c16da1ee314d4393a798b1d36f6733d8_Out_3_Vector3;
            Unity_Lerp_float3(_Lerp_e5620b57c917728fa1416e2ffce9b0db_Out_3_Vector3, _Multiply_f722561c89f8451497c9823ad4f29f4a_Out_2_Vector3, (_OneMinus_6ed96e068e394cd09ae03c32446777c8_Out_1_Float.xxx), _Lerp_c16da1ee314d4393a798b1d36f6733d8_Out_3_Vector3);
            float _Split_c7a719bf7da79a8ea38d7311fd844f92_R_1_Float = _Multiply_f572ff0def2d308e87a64e94a46c0d96_Out_2_Vector4[0];
            float _Split_c7a719bf7da79a8ea38d7311fd844f92_G_2_Float = _Multiply_f572ff0def2d308e87a64e94a46c0d96_Out_2_Vector4[1];
            float _Split_c7a719bf7da79a8ea38d7311fd844f92_B_3_Float = _Multiply_f572ff0def2d308e87a64e94a46c0d96_Out_2_Vector4[2];
            float _Split_c7a719bf7da79a8ea38d7311fd844f92_A_4_Float = _Multiply_f572ff0def2d308e87a64e94a46c0d96_Out_2_Vector4[3];
            float _Property_7c5dae9b46c9e686b49e58fa996a104a_Out_0_Boolean = IgnoreBase2Alpha;
            float _Split_e9060f5c0433ec889696d3e462f3229b_R_1_Float = _Multiply_d2ec682582195e84acc4a8510f50f4b0_Out_2_Vector4[0];
            float _Split_e9060f5c0433ec889696d3e462f3229b_G_2_Float = _Multiply_d2ec682582195e84acc4a8510f50f4b0_Out_2_Vector4[1];
            float _Split_e9060f5c0433ec889696d3e462f3229b_B_3_Float = _Multiply_d2ec682582195e84acc4a8510f50f4b0_Out_2_Vector4[2];
            float _Split_e9060f5c0433ec889696d3e462f3229b_A_4_Float = _Multiply_d2ec682582195e84acc4a8510f50f4b0_Out_2_Vector4[3];
            float _Branch_a7d7aece30fd9b8eb456d191fdd37a06_Out_3_Float;
            Unity_Branch_float(_Property_7c5dae9b46c9e686b49e58fa996a104a_Out_0_Boolean, _Split_c7a719bf7da79a8ea38d7311fd844f92_A_4_Float, _Split_e9060f5c0433ec889696d3e462f3229b_A_4_Float, _Branch_a7d7aece30fd9b8eb456d191fdd37a06_Out_3_Float);
            float _Lerp_8692ca93f568998fbc97130b6dbc4556_Out_3_Float;
            Unity_Lerp_float(_Split_c7a719bf7da79a8ea38d7311fd844f92_A_4_Float, _Branch_a7d7aece30fd9b8eb456d191fdd37a06_Out_3_Float, _Multiply_74def30593cbbb8bbed03613a31cb89a_Out_2_Float, _Lerp_8692ca93f568998fbc97130b6dbc4556_Out_3_Float);
            float _Clamp_0c8b7b55b9f82588ab2dcff09ee7a16d_Out_3_Float;
            Unity_Clamp_float(_Lerp_8692ca93f568998fbc97130b6dbc4556_Out_3_Float, float(0), float(1), _Clamp_0c8b7b55b9f82588ab2dcff09ee7a16d_Out_3_Float);
            float _Multiply_6333dc4a6348088bb7281602ce6bff5f_Out_2_Float;
            Unity_Multiply_float_float(_Clamp_0c8b7b55b9f82588ab2dcff09ee7a16d_Out_3_Float, _Split_c34b73d933404283983f9c8bdb5365d3_A_4_Float, _Multiply_6333dc4a6348088bb7281602ce6bff5f_Out_2_Float);
            float _Clamp_9642b8fb7e32b18a91da1888c9bc375b_Out_3_Float;
            Unity_Clamp_float(_Multiply_6333dc4a6348088bb7281602ce6bff5f_Out_2_Float, float(0), float(1), _Clamp_9642b8fb7e32b18a91da1888c9bc375b_Out_3_Float);
            float _Property_8bc98dd454a5508b9864a6ba09772356_Out_0_Float = _AlphaCutoff;
            surface.BaseColor = _Lerp_c16da1ee314d4393a798b1d36f6733d8_Out_3_Vector3;
            surface.Alpha = _Clamp_9642b8fb7e32b18a91da1888c9bc375b_Out_3_Float;
            surface.AlphaClipThreshold = _Property_8bc98dd454a5508b9864a6ba09772356_Out_0_Float;
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