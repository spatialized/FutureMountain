Shader "NatureManufacture/URP/Lit/NM Decal"
{
    Properties
    {
        [ToggleUI]_Alpha_Use_T_Base_Color_A_F_Maskmap_B("Alpha Use (T) Base Color A (F) Maskmap B", Float) = 1
        _Alpha_Multiply("Alpha Multiply", Float) = 1
        _Alpha_Power("Alpha Power", Range(0.01, 10)) = 1
        _BaseColor("Base Color", Color) = (1, 1, 1, 1)
        [NoScaleOffset]_BaseColorMap("Base Map", 2D) = "white" {}
        [Normal][NoScaleOffset]_NormalMap("Normal Map", 2D) = "bump" {}
        Normal_Blend("Normal Blend", Float) = 0.5
        [ToggleUI]_MaskMap_Alpha_Use_T_Base_Color_A_F_Maskmap_B("MaskMap Alpha Use (T) Base Color A (F) Maskmap B", Float) = 1
        [NoScaleOffset]_MaskMap("MaskMap", 2D) = "white" {}
        _MetallicRemapMin("Metallic Remap Min", Range(0, 1)) = 0
        _MetallicRemapMax("Metallic Remap Max", Range(0, 1)) = 1
        _AORemapMin("AO Remap Min", Range(0, 1)) = 0
        _AORemapMax("AO Remap Max", Range(0, 1)) = 1
        _SmoothnessRemapMin("Smoothness Remap Min", Range(0, 1)) = 0
        _SmoothnessRemapMax("Smoothness Remap Max", Range(0, 1)) = 1
        _MaskBlendSrc("Mask Map Opacity", Range(0, 1)) = 1
        [HDR]_EmissiveColor("Emissive Color", Color) = (0, 0, 0, 0)
        [NoScaleOffset]_EmissiveColorMap("Emissive Color Map", 2D) = "white" {}
        [HideInInspector]_DrawOrder("Draw Order", Range(-50, 50)) = 0
        [HideInInspector][Enum(Default, 0, Depth Bias, 0, View Bias, 1)]_DecalMeshBiasType("DecalMesh BiasType", Float) = 0
        [HideInInspector]_DecalMeshDepthBias("DecalMesh DepthBias", Float) = 0
        [HideInInspector]_DecalMeshViewBias("DecalMesh ViewBias", Float) = 0
        [HideInInspector]_DecalAngleFadeSupported("Decal Angle Fade Supported", Float) = 1
        [HideInInspector][NoScaleOffset]unity_Lightmaps("unity_Lightmaps", 2DArray) = "" {}
        [HideInInspector][NoScaleOffset]unity_LightmapsInd("unity_LightmapsInd", 2DArray) = "" {}
        [HideInInspector][NoScaleOffset]unity_ShadowMasks("unity_ShadowMasks", 2DArray) = "" {}
    }
    SubShader
    {
        Tags
        {
            "RenderPipeline"="UniversalPipeline"
            // RenderType: <None>
            "PreviewType"="Plane"
            // Queue: <None>
            "DisableBatching"="False"
            "ShaderGraphShader"="true"
            "ShaderGraphTargetId"="UniversalDecalSubTarget"
        }
        Pass
        {
            Name "DBufferProjector"
            Tags
            {
                "LightMode" = "DBufferProjector"
            }
        
            // Render State
            Cull Front
        Blend 0 SrcAlpha OneMinusSrcAlpha, Zero OneMinusSrcAlpha
        Blend 1 SrcAlpha OneMinusSrcAlpha, Zero OneMinusSrcAlpha
        Blend 2 SrcAlpha OneMinusSrcAlpha, Zero OneMinusSrcAlpha
        ZTest Greater
        ZWrite Off
        ColorMask RGBA
        ColorMask RGBA 1
        ColorMask RGBA 2
        
            // Debug
            // <None>
        
            // --------------------------------------------------
            // Pass
        
            HLSLPROGRAM
        
            // Pragmas
            #pragma target 4.5
        #pragma exclude_renderers gles3 glcore
        #pragma vertex Vert
        #pragma fragment Frag
        #pragma multi_compile_instancing
        #pragma editor_sync_compilation
        
            // Keywords
            #pragma multi_compile_fragment _ _DBUFFER_MRT1 _DBUFFER_MRT2 _DBUFFER_MRT3
        #pragma multi_compile _ _DECAL_LAYERS
            // GraphKeywords: <None>
        
            #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Common.hlsl"
            #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Texture.hlsl"
            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
        
            // Defines
            #define ATTRIBUTES_NEED_TEXCOORD0
            #define VARYINGS_NEED_TEXCOORD0
        
            #define HAVE_MESH_MODIFICATION
        
        
            #define SHADERPASS SHADERPASS_DBUFFER_PROJECTOR
        #define _MATERIAL_AFFECTS_ALBEDO 1
        #define _MATERIAL_AFFECTS_NORMAL 1
        #define _MATERIAL_AFFECTS_NORMAL_BLEND 1
        #define _MATERIAL_AFFECTS_MAOS 1
        #define DECAL_ANGLE_FADE 1
        
            // Includes
            #include_with_pragmas "Packages/com.unity.render-pipelines.universal/ShaderLibrary/DOTS.hlsl"
        #include_with_pragmas "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Fog.hlsl"
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
        #include_with_pragmas "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ProbeVolumeVariants.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShaderPass.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/DecalInput.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShaderVariablesDecal.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/DBuffer.hlsl"
        
            // -- Properties used by ScenePickingPass
            #ifdef SCENEPICKINGPASS
            float4 _SelectionID;
            #endif
            #if _RENDER_PASS_ENABLED
            #define GBUFFER3 0
            FRAMEBUFFER_INPUT_X_FLOAT(GBUFFER3);
            #define GBUFFER4 1
            FRAMEBUFFER_INPUT_X_UINT(GBUFFER4);
            #endif
        
            // --------------------------------------------------
            // Structs and Packing
        
            struct Attributes
        {
             float3 positionOS : POSITION;
             float4 uv0 : TEXCOORD0;
            #if UNITY_ANY_INSTANCING_ENABLED || defined(ATTRIBUTES_NEED_INSTANCEID)
             uint instanceID : INSTANCEID_SEMANTIC;
            #endif
        };
        struct Varyings
        {
             float4 positionCS : SV_POSITION;
             float4 texCoord0;
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
             float3 TangentSpaceNormal;
             float4 uv0;
        };
        struct VertexDescriptionInputs
        {
        };
        struct PackedVaryings
        {
             float4 positionCS : SV_POSITION;
             float4 texCoord0 : INTERP0;
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
        float _Alpha_Multiply;
        float _Alpha_Power;
        float4 _BaseColorMap_TexelSize;
        float4 _NormalMap_TexelSize;
        float Normal_Blend;
        float4 _BaseColor;
        float4 _MaskMap_TexelSize;
        float _MetallicRemapMax;
        float _MetallicRemapMin;
        float _AORemapMin;
        float _AORemapMax;
        float _SmoothnessRemapMin;
        float _SmoothnessRemapMax;
        float _MaskBlendSrc;
        float4 _EmissiveColor;
        float4 _EmissiveColorMap_TexelSize;
        float _Alpha_Use_T_Base_Color_A_F_Maskmap_B;
        float _MaskMap_Alpha_Use_T_Base_Color_A_F_Maskmap_B;
        float _DrawOrder;
        float _DecalMeshBiasType;
        float _DecalMeshDepthBias;
        float _DecalMeshViewBias;
        float _DecalAngleFadeSupported;
        UNITY_TEXTURE_STREAMING_DEBUG_VARS;
        CBUFFER_END
        
        
        // Object and Global properties
        SAMPLER(SamplerState_Linear_Repeat);
        TEXTURE2D(_BaseColorMap);
        SAMPLER(sampler_BaseColorMap);
        TEXTURE2D(_NormalMap);
        SAMPLER(sampler_NormalMap);
        TEXTURE2D(_MaskMap);
        SAMPLER(sampler_MaskMap);
        TEXTURE2D(_EmissiveColorMap);
        SAMPLER(sampler_EmissiveColorMap);
        
            // Graph Includes
            // GraphIncludes: <None>
        
            // Graph Functions
            
        void Unity_Multiply_float4_float4(float4 A, float4 B, out float4 Out)
        {
            Out = A * B;
        }
        
        void Unity_Branch_float(float Predicate, float True, float False, out float Out)
        {
            Out = Predicate ? True : False;
        }
        
        void Unity_Multiply_float_float(float A, float B, out float Out)
        {
            Out = A * B;
        }
        
        void Unity_Absolute_float(float In, out float Out)
        {
            Out = abs(In);
        }
        
        void Unity_Power_float(float A, float B, out float Out)
        {
            Out = pow(A, B);
        }
        
        void Unity_Clamp_float(float In, float Min, float Max, out float Out)
        {
            Out = clamp(In, Min, Max);
        }
        
        void Unity_Remap_float(float In, float2 InMinMax, float2 OutMinMax, out float Out)
        {
            Out = OutMinMax.x + (In - InMinMax.x) * (OutMinMax.y - OutMinMax.x) / (InMinMax.y - InMinMax.x);
        }
        
            // Graph Vertex
            struct VertexDescription
        {
        };
        
        VertexDescription VertexDescriptionFunction(VertexDescriptionInputs IN)
        {
            VertexDescription description = (VertexDescription)0;
            return description;
        }
        
            // Graph Pixel
            struct SurfaceDescription
        {
            float3 BaseColor;
            float Alpha;
            float3 NormalTS;
            float NormalAlpha;
            float Metallic;
            float Occlusion;
            float Smoothness;
            float MAOSAlpha;
        };
        
        SurfaceDescription SurfaceDescriptionFunction(SurfaceDescriptionInputs IN)
        {
            SurfaceDescription surface = (SurfaceDescription)0;
            float4 _Property_320fefd883db46679cd769f61b130dd7_Out_0_Vector4 = _BaseColor;
            UnityTexture2D _Property_9f1059a7a93a46ccab349515214f3ed2_Out_0_Texture2D = UnityBuildTexture2DStructNoScale(_BaseColorMap);
            float4 _SampleTexture2D_7388a7ddbf6648ec92c3bb54ed055048_RGBA_0_Vector4 = SAMPLE_TEXTURE2D(_Property_9f1059a7a93a46ccab349515214f3ed2_Out_0_Texture2D.tex, _Property_9f1059a7a93a46ccab349515214f3ed2_Out_0_Texture2D.samplerstate, _Property_9f1059a7a93a46ccab349515214f3ed2_Out_0_Texture2D.GetTransformedUV(IN.uv0.xy) );
            float _SampleTexture2D_7388a7ddbf6648ec92c3bb54ed055048_R_4_Float = _SampleTexture2D_7388a7ddbf6648ec92c3bb54ed055048_RGBA_0_Vector4.r;
            float _SampleTexture2D_7388a7ddbf6648ec92c3bb54ed055048_G_5_Float = _SampleTexture2D_7388a7ddbf6648ec92c3bb54ed055048_RGBA_0_Vector4.g;
            float _SampleTexture2D_7388a7ddbf6648ec92c3bb54ed055048_B_6_Float = _SampleTexture2D_7388a7ddbf6648ec92c3bb54ed055048_RGBA_0_Vector4.b;
            float _SampleTexture2D_7388a7ddbf6648ec92c3bb54ed055048_A_7_Float = _SampleTexture2D_7388a7ddbf6648ec92c3bb54ed055048_RGBA_0_Vector4.a;
            float4 _Multiply_885586d42d884019a5375f12f3c61e52_Out_2_Vector4;
            Unity_Multiply_float4_float4(_Property_320fefd883db46679cd769f61b130dd7_Out_0_Vector4, _SampleTexture2D_7388a7ddbf6648ec92c3bb54ed055048_RGBA_0_Vector4, _Multiply_885586d42d884019a5375f12f3c61e52_Out_2_Vector4);
            float _Property_10cb48b77e114c99a77554a14a36ed9a_Out_0_Float = _Alpha_Multiply;
            float _Property_97f64a9c7748494dbf6dc5b32920f5a5_Out_0_Boolean = _Alpha_Use_T_Base_Color_A_F_Maskmap_B;
            float _Split_da1fca62bd1b452a906195ffb7fa6a18_R_1_Float = _Multiply_885586d42d884019a5375f12f3c61e52_Out_2_Vector4[0];
            float _Split_da1fca62bd1b452a906195ffb7fa6a18_G_2_Float = _Multiply_885586d42d884019a5375f12f3c61e52_Out_2_Vector4[1];
            float _Split_da1fca62bd1b452a906195ffb7fa6a18_B_3_Float = _Multiply_885586d42d884019a5375f12f3c61e52_Out_2_Vector4[2];
            float _Split_da1fca62bd1b452a906195ffb7fa6a18_A_4_Float = _Multiply_885586d42d884019a5375f12f3c61e52_Out_2_Vector4[3];
            UnityTexture2D _Property_b46891aff98b4364a190337410150f10_Out_0_Texture2D = UnityBuildTexture2DStructNoScale(_MaskMap);
            float4 _SampleTexture2D_2dcb30935afc407482bb065c4150e563_RGBA_0_Vector4 = SAMPLE_TEXTURE2D(_Property_b46891aff98b4364a190337410150f10_Out_0_Texture2D.tex, _Property_b46891aff98b4364a190337410150f10_Out_0_Texture2D.samplerstate, _Property_b46891aff98b4364a190337410150f10_Out_0_Texture2D.GetTransformedUV(IN.uv0.xy) );
            float _SampleTexture2D_2dcb30935afc407482bb065c4150e563_R_4_Float = _SampleTexture2D_2dcb30935afc407482bb065c4150e563_RGBA_0_Vector4.r;
            float _SampleTexture2D_2dcb30935afc407482bb065c4150e563_G_5_Float = _SampleTexture2D_2dcb30935afc407482bb065c4150e563_RGBA_0_Vector4.g;
            float _SampleTexture2D_2dcb30935afc407482bb065c4150e563_B_6_Float = _SampleTexture2D_2dcb30935afc407482bb065c4150e563_RGBA_0_Vector4.b;
            float _SampleTexture2D_2dcb30935afc407482bb065c4150e563_A_7_Float = _SampleTexture2D_2dcb30935afc407482bb065c4150e563_RGBA_0_Vector4.a;
            float _Branch_eb932f0ef97d49398f01d62d896b2b60_Out_3_Float;
            Unity_Branch_float(_Property_97f64a9c7748494dbf6dc5b32920f5a5_Out_0_Boolean, _Split_da1fca62bd1b452a906195ffb7fa6a18_A_4_Float, _SampleTexture2D_2dcb30935afc407482bb065c4150e563_B_6_Float, _Branch_eb932f0ef97d49398f01d62d896b2b60_Out_3_Float);
            float _Multiply_3c4f7578756f4e789ded2b826c933b6d_Out_2_Float;
            Unity_Multiply_float_float(_Property_10cb48b77e114c99a77554a14a36ed9a_Out_0_Float, _Branch_eb932f0ef97d49398f01d62d896b2b60_Out_3_Float, _Multiply_3c4f7578756f4e789ded2b826c933b6d_Out_2_Float);
            float _Absolute_cc8840692870447e8bc057dbbf5f18c1_Out_1_Float;
            Unity_Absolute_float(_Multiply_3c4f7578756f4e789ded2b826c933b6d_Out_2_Float, _Absolute_cc8840692870447e8bc057dbbf5f18c1_Out_1_Float);
            float _Property_472619a20fe14990a52e2bbe0c00ea22_Out_0_Float = _Alpha_Power;
            float _Power_55566f012c2d4585bb257e256506056c_Out_2_Float;
            Unity_Power_float(_Absolute_cc8840692870447e8bc057dbbf5f18c1_Out_1_Float, _Property_472619a20fe14990a52e2bbe0c00ea22_Out_0_Float, _Power_55566f012c2d4585bb257e256506056c_Out_2_Float);
            float _Clamp_4788840726ef4518b7a1fc8db3fcdd97_Out_3_Float;
            Unity_Clamp_float(_Power_55566f012c2d4585bb257e256506056c_Out_2_Float, float(0), float(1), _Clamp_4788840726ef4518b7a1fc8db3fcdd97_Out_3_Float);
            UnityTexture2D _Property_360e6833e8d64d75827ab98987b2b545_Out_0_Texture2D = UnityBuildTexture2DStructNoScale(_NormalMap);
            float4 _SampleTexture2D_1300b7cb738f4b18927411750039acd2_RGBA_0_Vector4 = SAMPLE_TEXTURE2D(_Property_360e6833e8d64d75827ab98987b2b545_Out_0_Texture2D.tex, _Property_360e6833e8d64d75827ab98987b2b545_Out_0_Texture2D.samplerstate, _Property_360e6833e8d64d75827ab98987b2b545_Out_0_Texture2D.GetTransformedUV(IN.uv0.xy) );
            _SampleTexture2D_1300b7cb738f4b18927411750039acd2_RGBA_0_Vector4.rgb = UnpackNormal(_SampleTexture2D_1300b7cb738f4b18927411750039acd2_RGBA_0_Vector4);
            float _SampleTexture2D_1300b7cb738f4b18927411750039acd2_R_4_Float = _SampleTexture2D_1300b7cb738f4b18927411750039acd2_RGBA_0_Vector4.r;
            float _SampleTexture2D_1300b7cb738f4b18927411750039acd2_G_5_Float = _SampleTexture2D_1300b7cb738f4b18927411750039acd2_RGBA_0_Vector4.g;
            float _SampleTexture2D_1300b7cb738f4b18927411750039acd2_B_6_Float = _SampleTexture2D_1300b7cb738f4b18927411750039acd2_RGBA_0_Vector4.b;
            float _SampleTexture2D_1300b7cb738f4b18927411750039acd2_A_7_Float = _SampleTexture2D_1300b7cb738f4b18927411750039acd2_RGBA_0_Vector4.a;
            float _Property_e94639b7a37847e1a4616aeed6a21034_Out_0_Boolean = _MaskMap_Alpha_Use_T_Base_Color_A_F_Maskmap_B;
            float _Branch_39df5838709544d2951602a5ba721694_Out_3_Float;
            Unity_Branch_float(_Property_e94639b7a37847e1a4616aeed6a21034_Out_0_Boolean, _Split_da1fca62bd1b452a906195ffb7fa6a18_A_4_Float, _SampleTexture2D_2dcb30935afc407482bb065c4150e563_B_6_Float, _Branch_39df5838709544d2951602a5ba721694_Out_3_Float);
            float _Property_1ed131c6c6bd4d3b9225106c761ab06c_Out_0_Float = Normal_Blend;
            float _Multiply_52cb6c63b083455c8e01c3d5ccd89afc_Out_2_Float;
            Unity_Multiply_float_float(_Branch_39df5838709544d2951602a5ba721694_Out_3_Float, _Property_1ed131c6c6bd4d3b9225106c761ab06c_Out_0_Float, _Multiply_52cb6c63b083455c8e01c3d5ccd89afc_Out_2_Float);
            float _Property_5830ed7c65ef489e93de994fcb2769e2_Out_0_Float = _MetallicRemapMin;
            float _Property_3b33ae94b35943b5bbaa24c03b7069a8_Out_0_Float = _MetallicRemapMax;
            float2 _Vector2_0ad2d19d32894d5e83e19e69d72753fd_Out_0_Vector2 = float2(_Property_5830ed7c65ef489e93de994fcb2769e2_Out_0_Float, _Property_3b33ae94b35943b5bbaa24c03b7069a8_Out_0_Float);
            float _Remap_b3145e45987e489f9b15e9672b41a608_Out_3_Float;
            Unity_Remap_float(_SampleTexture2D_2dcb30935afc407482bb065c4150e563_R_4_Float, float2 (0, 1), _Vector2_0ad2d19d32894d5e83e19e69d72753fd_Out_0_Vector2, _Remap_b3145e45987e489f9b15e9672b41a608_Out_3_Float);
            float _Property_6427dba68c8342eebff5ce521921ddc5_Out_0_Float = _AORemapMin;
            float _Property_f74a95489f364e41b53a083f89ad2365_Out_0_Float = _AORemapMax;
            float2 _Vector2_a00f84e5347b414ca0e9496b9948ba0b_Out_0_Vector2 = float2(_Property_6427dba68c8342eebff5ce521921ddc5_Out_0_Float, _Property_f74a95489f364e41b53a083f89ad2365_Out_0_Float);
            float _Remap_75ea5a896ac148bb8058b60d79c90284_Out_3_Float;
            Unity_Remap_float(_SampleTexture2D_2dcb30935afc407482bb065c4150e563_G_5_Float, float2 (0, 1), _Vector2_a00f84e5347b414ca0e9496b9948ba0b_Out_0_Vector2, _Remap_75ea5a896ac148bb8058b60d79c90284_Out_3_Float);
            float _Property_9d6993415be843799b7ec2e689c5db02_Out_0_Float = _SmoothnessRemapMin;
            float _Property_df4aa91a4fe94e5f8768553f10cd1f82_Out_0_Float = _SmoothnessRemapMax;
            float2 _Vector2_d67e05a1240344f3978c1c9e3cb9525f_Out_0_Vector2 = float2(_Property_9d6993415be843799b7ec2e689c5db02_Out_0_Float, _Property_df4aa91a4fe94e5f8768553f10cd1f82_Out_0_Float);
            float _Remap_ad26abe467c44f5284db4b4203d8242b_Out_3_Float;
            Unity_Remap_float(_SampleTexture2D_2dcb30935afc407482bb065c4150e563_A_7_Float, float2 (0, 1), _Vector2_d67e05a1240344f3978c1c9e3cb9525f_Out_0_Vector2, _Remap_ad26abe467c44f5284db4b4203d8242b_Out_3_Float);
            float _Property_5c661f4099b14a5bac0c24977977340d_Out_0_Float = _MaskBlendSrc;
            float _Multiply_fc69b6805f38404cb402d2a6b2d2b73a_Out_2_Float;
            Unity_Multiply_float_float(_Split_da1fca62bd1b452a906195ffb7fa6a18_A_4_Float, _Property_5c661f4099b14a5bac0c24977977340d_Out_0_Float, _Multiply_fc69b6805f38404cb402d2a6b2d2b73a_Out_2_Float);
            float _Multiply_2f94ef00580f43caa2427a59ed8ca124_Out_2_Float;
            Unity_Multiply_float_float(_Property_5c661f4099b14a5bac0c24977977340d_Out_0_Float, _SampleTexture2D_2dcb30935afc407482bb065c4150e563_B_6_Float, _Multiply_2f94ef00580f43caa2427a59ed8ca124_Out_2_Float);
            float _Branch_753c02949c6b4f128d654534f2d64ced_Out_3_Float;
            Unity_Branch_float(_Property_e94639b7a37847e1a4616aeed6a21034_Out_0_Boolean, _Multiply_fc69b6805f38404cb402d2a6b2d2b73a_Out_2_Float, _Multiply_2f94ef00580f43caa2427a59ed8ca124_Out_2_Float, _Branch_753c02949c6b4f128d654534f2d64ced_Out_3_Float);
            surface.BaseColor = (_Multiply_885586d42d884019a5375f12f3c61e52_Out_2_Vector4.xyz);
            surface.Alpha = _Clamp_4788840726ef4518b7a1fc8db3fcdd97_Out_3_Float;
            surface.NormalTS = (_SampleTexture2D_1300b7cb738f4b18927411750039acd2_RGBA_0_Vector4.xyz);
            surface.NormalAlpha = _Multiply_52cb6c63b083455c8e01c3d5ccd89afc_Out_2_Float;
            surface.Metallic = _Remap_b3145e45987e489f9b15e9672b41a608_Out_3_Float;
            surface.Occlusion = _Remap_75ea5a896ac148bb8058b60d79c90284_Out_3_Float;
            surface.Smoothness = _Remap_ad26abe467c44f5284db4b4203d8242b_Out_3_Float;
            surface.MAOSAlpha = _Branch_753c02949c6b4f128d654534f2d64ced_Out_3_Float;
            return surface;
        }
        
            // --------------------------------------------------
            // Build Graph Inputs
        
            
        //     $features.graphVertex:  $include("VertexAnimation.template.hlsl")
        //                                       ^ ERROR: $include cannot find file : VertexAnimation.template.hlsl. Looked into:
        // Packages/com.unity.shadergraph/Editor/Generation/Templates
        
            
        //     $features.graphPixel:   $include("SharedCode.template.hlsl")
        //                                       ^ ERROR: $include cannot find file : SharedCode.template.hlsl. Looked into:
        // Packages/com.unity.shadergraph/Editor/Generation/Templates
        
            SurfaceDescriptionInputs BuildSurfaceDescriptionInputs(Varyings input)
        {
            SurfaceDescriptionInputs output;
            ZERO_INITIALIZE(SurfaceDescriptionInputs, output);
        
            /* WARNING: $splice Could not find named fragment 'CustomInterpolatorCopyToSDI' */
        
        
        
            output.TangentSpaceNormal =                         float3(0.0f, 0.0f, 1.0f);
        
        
        
            #if UNITY_UV_STARTS_AT_TOP
            #else
            #endif
        
        
        
        #if defined(UNITY_UIE_INCLUDED)
            output.uv0 =                                        float4(input.texCoord0.x, input.texCoord0.y, 0, 0);
        #else
            output.uv0 =                                        input.texCoord0;
        #endif
            
        
            
            
        #if UNITY_ANY_INSTANCING_ENABLED
        #else // TODO: XR support for procedural instancing because in this case UNITY_ANY_INSTANCING_ENABLED is not defined and instanceID is incorrect.
        #endif
        #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
        #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN                output.FaceSign =                                   IS_FRONT_VFACE(input.cullFace, true, false);
        #else
        #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
        #endif
        #undef BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
        
            return output;
        }
        
            // --------------------------------------------------
            // Build Surface Data
        
            void GetSurfaceData(Varyings input, float4 positionCS, float angleFadeFactor, out DecalSurfaceData surfaceData)
            {
                #if (SHADERPASS == SHADERPASS_DBUFFER_PROJECTOR) || (SHADERPASS == SHADERPASS_FORWARD_EMISSIVE_PROJECTOR) || (SHADERPASS == SHADERPASS_DECAL_SCREEN_SPACE_PROJECTOR) || (SHADERPASS == SHADERPASS_DECAL_GBUFFER_PROJECTOR)
                    half4x4 normalToWorld = UNITY_ACCESS_INSTANCED_PROP(Decal, _NormalToWorld);
                    half fadeFactor = clamp(normalToWorld[0][3], 0.0f, 1.0f) * angleFadeFactor;
                    float2 scale = float2(normalToWorld[3][0], normalToWorld[3][1]);
                    float2 offset = float2(normalToWorld[3][2], normalToWorld[3][3]);
                    input.texCoord0.xy = input.texCoord0.xy * scale + offset;
                    half3 normalWS = TransformObjectToWorldDir(half3(0, 1, 0));
                    half3 tangentWS = TransformObjectToWorldDir(half3(1, 0, 0));
                    half3 bitangentWS = TransformObjectToWorldDir(half3(0, 0, 1));
                    half sign = dot(cross(normalWS, tangentWS), bitangentWS) > 0 ? 1 : -1;
                #else
                    #if defined(LOD_FADE_CROSSFADE) && USE_UNITY_CROSSFADE
                        LODFadeCrossFade(positionCS);
                    #endif
        
                    half fadeFactor = half(1.0);
                #endif
        
                SurfaceDescriptionInputs surfaceDescriptionInputs = BuildSurfaceDescriptionInputs(input);
                SurfaceDescription surfaceDescription = SurfaceDescriptionFunction(surfaceDescriptionInputs);
        
                // setup defaults -- these are used if the graph doesn't output a value
                ZERO_INITIALIZE(DecalSurfaceData, surfaceData);
                surfaceData.occlusion = half(1.0);
                surfaceData.smoothness = half(0);
        
                #ifdef _MATERIAL_AFFECTS_NORMAL
                    surfaceData.normalWS.w = half(1.0);
                #else
                    surfaceData.normalWS.w = half(0.0);
                #endif
        
        
                // copy across graph values, if defined
                surfaceData.baseColor.xyz = half3(surfaceDescription.BaseColor);
                surfaceData.baseColor.w = half(surfaceDescription.Alpha * fadeFactor);
        
                #if (SHADERPASS == SHADERPASS_DBUFFER_PROJECTOR) || (SHADERPASS == SHADERPASS_DECAL_SCREEN_SPACE_PROJECTOR) || (SHADERPASS == SHADERPASS_DECAL_GBUFFER_PROJECTOR)
                    #if defined(_MATERIAL_AFFECTS_NORMAL)
                        surfaceData.normalWS.xyz = normalize(mul((half3x3)normalToWorld, surfaceDescription.NormalTS.xyz));
                    #else
                        surfaceData.normalWS.xyz = normalize(normalToWorld[2].xyz);
                    #endif
                #elif (SHADERPASS == SHADERPASS_DBUFFER_MESH) || (SHADERPASS == SHADERPASS_DECAL_SCREEN_SPACE_MESH) || (SHADERPASS == SHADERPASS_DECAL_GBUFFER_MESH)
                    #if defined(_MATERIAL_AFFECTS_NORMAL)
                        float sgn = input.tangentWS.w;      // should be either +1 or -1
                        float3 bitangent = sgn * cross(input.normalWS.xyz, input.tangentWS.xyz);
                        half3x3 tangentToWorld = half3x3(input.tangentWS.xyz, bitangent.xyz, input.normalWS.xyz);
        
                        // We need to normalize as we use mikkt tangent space and this is expected (tangent space is not normalize)
                        surfaceData.normalWS.xyz = normalize(TransformTangentToWorld(surfaceDescription.NormalTS, tangentToWorld));
                    #else
                        surfaceData.normalWS.xyz = normalize(half3(input.normalWS)); // Default to vertex normal
                    #endif
                #endif
        
                surfaceData.normalWS.w = surfaceDescription.NormalAlpha * fadeFactor;
        
                // In case of Smoothness / AO / Metal, all the three are always computed but color mask can change
                surfaceData.metallic = half(surfaceDescription.Metallic);
                surfaceData.occlusion = half(surfaceDescription.Occlusion);
                surfaceData.smoothness = half(surfaceDescription.Smoothness);
                surfaceData.MAOSAlpha = half(surfaceDescription.MAOSAlpha * fadeFactor);
            }
        
            // --------------------------------------------------
            // Main
        
            #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/Varyings.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShaderPassDecal.hlsl"
        
            ENDHLSL
        }
        Pass
        {
            Name "DecalProjectorForwardEmissive"
            Tags
            {
                "LightMode" = "DecalProjectorForwardEmissive"
            }
        
            // Render State
            Cull Front
        Blend 0 SrcAlpha One
        ZTest Greater
        ZWrite Off
        
            // Debug
            // <None>
        
            // --------------------------------------------------
            // Pass
        
            HLSLPROGRAM
        
            // Pragmas
            #pragma target 4.5
        #pragma exclude_renderers gles3 glcore
        #pragma vertex Vert
        #pragma fragment Frag
        #pragma multi_compile_instancing
        #pragma editor_sync_compilation
        
            // Keywords
            #pragma multi_compile _ _DECAL_LAYERS
            // GraphKeywords: <None>
        
            #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Common.hlsl"
            #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Texture.hlsl"
            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
        
            // Defines
            #define ATTRIBUTES_NEED_TEXCOORD0
            #define VARYINGS_NEED_TEXCOORD0
        
            #define HAVE_MESH_MODIFICATION
        
        
            #define SHADERPASS SHADERPASS_FORWARD_EMISSIVE_PROJECTOR
        #define _MATERIAL_AFFECTS_ALBEDO 1
        #define _MATERIAL_AFFECTS_NORMAL 1
        #define _MATERIAL_AFFECTS_NORMAL_BLEND 1
        #define _MATERIAL_AFFECTS_MAOS 1
        #define DECAL_ANGLE_FADE 1
        #define _MATERIAL_AFFECTS_EMISSION 1
        
            // Includes
            #include_with_pragmas "Packages/com.unity.render-pipelines.universal/ShaderLibrary/DOTS.hlsl"
        #include_with_pragmas "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Fog.hlsl"
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
        #include_with_pragmas "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ProbeVolumeVariants.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShaderPass.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/DecalInput.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShaderVariablesDecal.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/DBuffer.hlsl"
        
            // -- Properties used by ScenePickingPass
            #ifdef SCENEPICKINGPASS
            float4 _SelectionID;
            #endif
            #if _RENDER_PASS_ENABLED
            #define GBUFFER3 0
            FRAMEBUFFER_INPUT_X_FLOAT(GBUFFER3);
            #define GBUFFER4 1
            FRAMEBUFFER_INPUT_X_UINT(GBUFFER4);
            #endif
        
            // --------------------------------------------------
            // Structs and Packing
        
            struct Attributes
        {
             float3 positionOS : POSITION;
             float4 uv0 : TEXCOORD0;
            #if UNITY_ANY_INSTANCING_ENABLED || defined(ATTRIBUTES_NEED_INSTANCEID)
             uint instanceID : INSTANCEID_SEMANTIC;
            #endif
        };
        struct Varyings
        {
             float4 positionCS : SV_POSITION;
             float4 texCoord0;
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
             float4 uv0;
        };
        struct VertexDescriptionInputs
        {
        };
        struct PackedVaryings
        {
             float4 positionCS : SV_POSITION;
             float4 texCoord0 : INTERP0;
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
        float _Alpha_Multiply;
        float _Alpha_Power;
        float4 _BaseColorMap_TexelSize;
        float4 _NormalMap_TexelSize;
        float Normal_Blend;
        float4 _BaseColor;
        float4 _MaskMap_TexelSize;
        float _MetallicRemapMax;
        float _MetallicRemapMin;
        float _AORemapMin;
        float _AORemapMax;
        float _SmoothnessRemapMin;
        float _SmoothnessRemapMax;
        float _MaskBlendSrc;
        float4 _EmissiveColor;
        float4 _EmissiveColorMap_TexelSize;
        float _Alpha_Use_T_Base_Color_A_F_Maskmap_B;
        float _MaskMap_Alpha_Use_T_Base_Color_A_F_Maskmap_B;
        float _DrawOrder;
        float _DecalMeshBiasType;
        float _DecalMeshDepthBias;
        float _DecalMeshViewBias;
        float _DecalAngleFadeSupported;
        UNITY_TEXTURE_STREAMING_DEBUG_VARS;
        CBUFFER_END
        
        
        // Object and Global properties
        SAMPLER(SamplerState_Linear_Repeat);
        TEXTURE2D(_BaseColorMap);
        SAMPLER(sampler_BaseColorMap);
        TEXTURE2D(_NormalMap);
        SAMPLER(sampler_NormalMap);
        TEXTURE2D(_MaskMap);
        SAMPLER(sampler_MaskMap);
        TEXTURE2D(_EmissiveColorMap);
        SAMPLER(sampler_EmissiveColorMap);
        
            // Graph Includes
            // GraphIncludes: <None>
        
            // Graph Functions
            
        void Unity_Multiply_float4_float4(float4 A, float4 B, out float4 Out)
        {
            Out = A * B;
        }
        
        void Unity_Branch_float(float Predicate, float True, float False, out float Out)
        {
            Out = Predicate ? True : False;
        }
        
        void Unity_Multiply_float_float(float A, float B, out float Out)
        {
            Out = A * B;
        }
        
        void Unity_Absolute_float(float In, out float Out)
        {
            Out = abs(In);
        }
        
        void Unity_Power_float(float A, float B, out float Out)
        {
            Out = pow(A, B);
        }
        
        void Unity_Clamp_float(float In, float Min, float Max, out float Out)
        {
            Out = clamp(In, Min, Max);
        }
        
            // Graph Vertex
            struct VertexDescription
        {
        };
        
        VertexDescription VertexDescriptionFunction(VertexDescriptionInputs IN)
        {
            VertexDescription description = (VertexDescription)0;
            return description;
        }
        
            // Graph Pixel
            struct SurfaceDescription
        {
            float Alpha;
            float3 Emission;
        };
        
        SurfaceDescription SurfaceDescriptionFunction(SurfaceDescriptionInputs IN)
        {
            SurfaceDescription surface = (SurfaceDescription)0;
            float _Property_10cb48b77e114c99a77554a14a36ed9a_Out_0_Float = _Alpha_Multiply;
            float _Property_97f64a9c7748494dbf6dc5b32920f5a5_Out_0_Boolean = _Alpha_Use_T_Base_Color_A_F_Maskmap_B;
            float4 _Property_320fefd883db46679cd769f61b130dd7_Out_0_Vector4 = _BaseColor;
            UnityTexture2D _Property_9f1059a7a93a46ccab349515214f3ed2_Out_0_Texture2D = UnityBuildTexture2DStructNoScale(_BaseColorMap);
            float4 _SampleTexture2D_7388a7ddbf6648ec92c3bb54ed055048_RGBA_0_Vector4 = SAMPLE_TEXTURE2D(_Property_9f1059a7a93a46ccab349515214f3ed2_Out_0_Texture2D.tex, _Property_9f1059a7a93a46ccab349515214f3ed2_Out_0_Texture2D.samplerstate, _Property_9f1059a7a93a46ccab349515214f3ed2_Out_0_Texture2D.GetTransformedUV(IN.uv0.xy) );
            float _SampleTexture2D_7388a7ddbf6648ec92c3bb54ed055048_R_4_Float = _SampleTexture2D_7388a7ddbf6648ec92c3bb54ed055048_RGBA_0_Vector4.r;
            float _SampleTexture2D_7388a7ddbf6648ec92c3bb54ed055048_G_5_Float = _SampleTexture2D_7388a7ddbf6648ec92c3bb54ed055048_RGBA_0_Vector4.g;
            float _SampleTexture2D_7388a7ddbf6648ec92c3bb54ed055048_B_6_Float = _SampleTexture2D_7388a7ddbf6648ec92c3bb54ed055048_RGBA_0_Vector4.b;
            float _SampleTexture2D_7388a7ddbf6648ec92c3bb54ed055048_A_7_Float = _SampleTexture2D_7388a7ddbf6648ec92c3bb54ed055048_RGBA_0_Vector4.a;
            float4 _Multiply_885586d42d884019a5375f12f3c61e52_Out_2_Vector4;
            Unity_Multiply_float4_float4(_Property_320fefd883db46679cd769f61b130dd7_Out_0_Vector4, _SampleTexture2D_7388a7ddbf6648ec92c3bb54ed055048_RGBA_0_Vector4, _Multiply_885586d42d884019a5375f12f3c61e52_Out_2_Vector4);
            float _Split_da1fca62bd1b452a906195ffb7fa6a18_R_1_Float = _Multiply_885586d42d884019a5375f12f3c61e52_Out_2_Vector4[0];
            float _Split_da1fca62bd1b452a906195ffb7fa6a18_G_2_Float = _Multiply_885586d42d884019a5375f12f3c61e52_Out_2_Vector4[1];
            float _Split_da1fca62bd1b452a906195ffb7fa6a18_B_3_Float = _Multiply_885586d42d884019a5375f12f3c61e52_Out_2_Vector4[2];
            float _Split_da1fca62bd1b452a906195ffb7fa6a18_A_4_Float = _Multiply_885586d42d884019a5375f12f3c61e52_Out_2_Vector4[3];
            UnityTexture2D _Property_b46891aff98b4364a190337410150f10_Out_0_Texture2D = UnityBuildTexture2DStructNoScale(_MaskMap);
            float4 _SampleTexture2D_2dcb30935afc407482bb065c4150e563_RGBA_0_Vector4 = SAMPLE_TEXTURE2D(_Property_b46891aff98b4364a190337410150f10_Out_0_Texture2D.tex, _Property_b46891aff98b4364a190337410150f10_Out_0_Texture2D.samplerstate, _Property_b46891aff98b4364a190337410150f10_Out_0_Texture2D.GetTransformedUV(IN.uv0.xy) );
            float _SampleTexture2D_2dcb30935afc407482bb065c4150e563_R_4_Float = _SampleTexture2D_2dcb30935afc407482bb065c4150e563_RGBA_0_Vector4.r;
            float _SampleTexture2D_2dcb30935afc407482bb065c4150e563_G_5_Float = _SampleTexture2D_2dcb30935afc407482bb065c4150e563_RGBA_0_Vector4.g;
            float _SampleTexture2D_2dcb30935afc407482bb065c4150e563_B_6_Float = _SampleTexture2D_2dcb30935afc407482bb065c4150e563_RGBA_0_Vector4.b;
            float _SampleTexture2D_2dcb30935afc407482bb065c4150e563_A_7_Float = _SampleTexture2D_2dcb30935afc407482bb065c4150e563_RGBA_0_Vector4.a;
            float _Branch_eb932f0ef97d49398f01d62d896b2b60_Out_3_Float;
            Unity_Branch_float(_Property_97f64a9c7748494dbf6dc5b32920f5a5_Out_0_Boolean, _Split_da1fca62bd1b452a906195ffb7fa6a18_A_4_Float, _SampleTexture2D_2dcb30935afc407482bb065c4150e563_B_6_Float, _Branch_eb932f0ef97d49398f01d62d896b2b60_Out_3_Float);
            float _Multiply_3c4f7578756f4e789ded2b826c933b6d_Out_2_Float;
            Unity_Multiply_float_float(_Property_10cb48b77e114c99a77554a14a36ed9a_Out_0_Float, _Branch_eb932f0ef97d49398f01d62d896b2b60_Out_3_Float, _Multiply_3c4f7578756f4e789ded2b826c933b6d_Out_2_Float);
            float _Absolute_cc8840692870447e8bc057dbbf5f18c1_Out_1_Float;
            Unity_Absolute_float(_Multiply_3c4f7578756f4e789ded2b826c933b6d_Out_2_Float, _Absolute_cc8840692870447e8bc057dbbf5f18c1_Out_1_Float);
            float _Property_472619a20fe14990a52e2bbe0c00ea22_Out_0_Float = _Alpha_Power;
            float _Power_55566f012c2d4585bb257e256506056c_Out_2_Float;
            Unity_Power_float(_Absolute_cc8840692870447e8bc057dbbf5f18c1_Out_1_Float, _Property_472619a20fe14990a52e2bbe0c00ea22_Out_0_Float, _Power_55566f012c2d4585bb257e256506056c_Out_2_Float);
            float _Clamp_4788840726ef4518b7a1fc8db3fcdd97_Out_3_Float;
            Unity_Clamp_float(_Power_55566f012c2d4585bb257e256506056c_Out_2_Float, float(0), float(1), _Clamp_4788840726ef4518b7a1fc8db3fcdd97_Out_3_Float);
            float4 _Property_293317916e0e41cc98bbd5377294091b_Out_0_Vector4 = IsGammaSpace() ? LinearToSRGB(_EmissiveColor) : _EmissiveColor;
            UnityTexture2D _Property_fb3929b3be5f4269845ceb27fb377d12_Out_0_Texture2D = UnityBuildTexture2DStructNoScale(_EmissiveColorMap);
            float4 _SampleTexture2D_d4d6d2f60c614e4c8b681d89316209dc_RGBA_0_Vector4 = SAMPLE_TEXTURE2D(_Property_fb3929b3be5f4269845ceb27fb377d12_Out_0_Texture2D.tex, _Property_fb3929b3be5f4269845ceb27fb377d12_Out_0_Texture2D.samplerstate, _Property_fb3929b3be5f4269845ceb27fb377d12_Out_0_Texture2D.GetTransformedUV(IN.uv0.xy) );
            float _SampleTexture2D_d4d6d2f60c614e4c8b681d89316209dc_R_4_Float = _SampleTexture2D_d4d6d2f60c614e4c8b681d89316209dc_RGBA_0_Vector4.r;
            float _SampleTexture2D_d4d6d2f60c614e4c8b681d89316209dc_G_5_Float = _SampleTexture2D_d4d6d2f60c614e4c8b681d89316209dc_RGBA_0_Vector4.g;
            float _SampleTexture2D_d4d6d2f60c614e4c8b681d89316209dc_B_6_Float = _SampleTexture2D_d4d6d2f60c614e4c8b681d89316209dc_RGBA_0_Vector4.b;
            float _SampleTexture2D_d4d6d2f60c614e4c8b681d89316209dc_A_7_Float = _SampleTexture2D_d4d6d2f60c614e4c8b681d89316209dc_RGBA_0_Vector4.a;
            float4 _Multiply_2fa508cc2b6044e09e63453927d92375_Out_2_Vector4;
            Unity_Multiply_float4_float4(_Property_293317916e0e41cc98bbd5377294091b_Out_0_Vector4, _SampleTexture2D_d4d6d2f60c614e4c8b681d89316209dc_RGBA_0_Vector4, _Multiply_2fa508cc2b6044e09e63453927d92375_Out_2_Vector4);
            surface.Alpha = _Clamp_4788840726ef4518b7a1fc8db3fcdd97_Out_3_Float;
            surface.Emission = (_Multiply_2fa508cc2b6044e09e63453927d92375_Out_2_Vector4.xyz);
            return surface;
        }
        
            // --------------------------------------------------
            // Build Graph Inputs
        
            
        //     $features.graphVertex:  $include("VertexAnimation.template.hlsl")
        //                                       ^ ERROR: $include cannot find file : VertexAnimation.template.hlsl. Looked into:
        // Packages/com.unity.shadergraph/Editor/Generation/Templates
        
            
        //     $features.graphPixel:   $include("SharedCode.template.hlsl")
        //                                       ^ ERROR: $include cannot find file : SharedCode.template.hlsl. Looked into:
        // Packages/com.unity.shadergraph/Editor/Generation/Templates
        
            SurfaceDescriptionInputs BuildSurfaceDescriptionInputs(Varyings input)
        {
            SurfaceDescriptionInputs output;
            ZERO_INITIALIZE(SurfaceDescriptionInputs, output);
        
            /* WARNING: $splice Could not find named fragment 'CustomInterpolatorCopyToSDI' */
        
        
        
        
        
        
            #if UNITY_UV_STARTS_AT_TOP
            #else
            #endif
        
        
        
        #if defined(UNITY_UIE_INCLUDED)
            output.uv0 =                                        float4(input.texCoord0.x, input.texCoord0.y, 0, 0);
        #else
            output.uv0 =                                        input.texCoord0;
        #endif
            
        
            
            
        #if UNITY_ANY_INSTANCING_ENABLED
        #else // TODO: XR support for procedural instancing because in this case UNITY_ANY_INSTANCING_ENABLED is not defined and instanceID is incorrect.
        #endif
        #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
        #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN                output.FaceSign =                                   IS_FRONT_VFACE(input.cullFace, true, false);
        #else
        #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
        #endif
        #undef BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
        
            return output;
        }
        
            // --------------------------------------------------
            // Build Surface Data
        
            void GetSurfaceData(Varyings input, float4 positionCS, float angleFadeFactor, out DecalSurfaceData surfaceData)
            {
                #if (SHADERPASS == SHADERPASS_DBUFFER_PROJECTOR) || (SHADERPASS == SHADERPASS_FORWARD_EMISSIVE_PROJECTOR) || (SHADERPASS == SHADERPASS_DECAL_SCREEN_SPACE_PROJECTOR) || (SHADERPASS == SHADERPASS_DECAL_GBUFFER_PROJECTOR)
                    half4x4 normalToWorld = UNITY_ACCESS_INSTANCED_PROP(Decal, _NormalToWorld);
                    half fadeFactor = clamp(normalToWorld[0][3], 0.0f, 1.0f) * angleFadeFactor;
                    float2 scale = float2(normalToWorld[3][0], normalToWorld[3][1]);
                    float2 offset = float2(normalToWorld[3][2], normalToWorld[3][3]);
                    input.texCoord0.xy = input.texCoord0.xy * scale + offset;
                    half3 normalWS = TransformObjectToWorldDir(half3(0, 1, 0));
                    half3 tangentWS = TransformObjectToWorldDir(half3(1, 0, 0));
                    half3 bitangentWS = TransformObjectToWorldDir(half3(0, 0, 1));
                    half sign = dot(cross(normalWS, tangentWS), bitangentWS) > 0 ? 1 : -1;
                #else
                    #if defined(LOD_FADE_CROSSFADE) && USE_UNITY_CROSSFADE
                        LODFadeCrossFade(positionCS);
                    #endif
        
                    half fadeFactor = half(1.0);
                #endif
        
                SurfaceDescriptionInputs surfaceDescriptionInputs = BuildSurfaceDescriptionInputs(input);
                SurfaceDescription surfaceDescription = SurfaceDescriptionFunction(surfaceDescriptionInputs);
        
                // setup defaults -- these are used if the graph doesn't output a value
                ZERO_INITIALIZE(DecalSurfaceData, surfaceData);
                surfaceData.occlusion = half(1.0);
                surfaceData.smoothness = half(0);
        
                #ifdef _MATERIAL_AFFECTS_NORMAL
                    surfaceData.normalWS.w = half(1.0);
                #else
                    surfaceData.normalWS.w = half(0.0);
                #endif
        
                surfaceData.emissive.rgb = half3(surfaceDescription.Emission.rgb * fadeFactor);
        
                // copy across graph values, if defined
                surfaceData.baseColor.w = half(surfaceDescription.Alpha * fadeFactor);
        
                #if (SHADERPASS == SHADERPASS_DBUFFER_PROJECTOR) || (SHADERPASS == SHADERPASS_DECAL_SCREEN_SPACE_PROJECTOR) || (SHADERPASS == SHADERPASS_DECAL_GBUFFER_PROJECTOR)
                    #if defined(_MATERIAL_AFFECTS_NORMAL)
                    #else
                        surfaceData.normalWS.xyz = normalize(normalToWorld[2].xyz);
                    #endif
                #elif (SHADERPASS == SHADERPASS_DBUFFER_MESH) || (SHADERPASS == SHADERPASS_DECAL_SCREEN_SPACE_MESH) || (SHADERPASS == SHADERPASS_DECAL_GBUFFER_MESH)
                    #if defined(_MATERIAL_AFFECTS_NORMAL)
                        float sgn = input.tangentWS.w;      // should be either +1 or -1
                        float3 bitangent = sgn * cross(input.normalWS.xyz, input.tangentWS.xyz);
                        half3x3 tangentToWorld = half3x3(input.tangentWS.xyz, bitangent.xyz, input.normalWS.xyz);
        
                        // We need to normalize as we use mikkt tangent space and this is expected (tangent space is not normalize)
                    #else
                        surfaceData.normalWS.xyz = normalize(half3(input.normalWS)); // Default to vertex normal
                    #endif
                #endif
        
        
                // In case of Smoothness / AO / Metal, all the three are always computed but color mask can change
            }
        
            // --------------------------------------------------
            // Main
        
            #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/Varyings.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShaderPassDecal.hlsl"
        
            ENDHLSL
        }
        Pass
        {
            Name "DecalScreenSpaceProjector"
            Tags
            {
                "LightMode" = "DecalScreenSpaceProjector"
            }
        
            // Render State
            Cull Front
        Blend SrcAlpha OneMinusSrcAlpha
        ZTest Greater
        ZWrite Off
        
            // Debug
            // <None>
        
            // --------------------------------------------------
            // Pass
        
            HLSLPROGRAM
        
            // Pragmas
            #pragma target 2.5
        #pragma vertex Vert
        #pragma fragment Frag
        #pragma multi_compile_instancing
        #pragma editor_sync_compilation
        
            // Keywords
            #pragma multi_compile _ _MAIN_LIGHT_SHADOWS _MAIN_LIGHT_SHADOWS_CASCADE _MAIN_LIGHT_SHADOWS_SCREEN
        #pragma multi_compile_fragment _ _SCREEN_SPACE_IRRADIANCE
        #pragma multi_compile _ _ADDITIONAL_LIGHTS_VERTEX _ADDITIONAL_LIGHTS
        #pragma multi_compile_fragment _ _ADDITIONAL_LIGHT_SHADOWS
        #pragma multi_compile_fragment _ _SHADOWS_SOFT _SHADOWS_SOFT_LOW _SHADOWS_SOFT_MEDIUM _SHADOWS_SOFT_HIGH
        #pragma multi_compile _ _CLUSTER_LIGHT_LOOP
        #pragma multi_compile_fragment _ _LIGHT_COOKIES
        #pragma multi_compile_fragment _ DEBUG_DISPLAY
        #pragma multi_compile _DECAL_NORMAL_BLEND_LOW _DECAL_NORMAL_BLEND_MEDIUM _DECAL_NORMAL_BLEND_HIGH
        #pragma multi_compile _ _DECAL_LAYERS
            // GraphKeywords: <None>
        
            #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Common.hlsl"
            #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Texture.hlsl"
            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
        
            // Defines
            #define ATTRIBUTES_NEED_NORMAL
            #define ATTRIBUTES_NEED_TEXCOORD0
            #define VARYINGS_NEED_NORMAL_WS
            #define VARYINGS_NEED_TEXCOORD0
            #define VARYINGS_NEED_FOG_AND_VERTEX_LIGHT
            #define VARYINGS_NEED_SH
            #define VARYINGS_NEED_STATIC_LIGHTMAP_UV
            #define VARYINGS_NEED_DYNAMIC_LIGHTMAP_UV
            #define VARYINGS_NEED_SHADOW_COORD
        
            #define HAVE_MESH_MODIFICATION
        
        
            #define SHADERPASS SHADERPASS_DECAL_SCREEN_SPACE_PROJECTOR
        #define _MATERIAL_AFFECTS_ALBEDO 1
        #define _MATERIAL_AFFECTS_NORMAL 1
        #define _MATERIAL_AFFECTS_NORMAL_BLEND 1
        #define _MATERIAL_AFFECTS_MAOS 1
        #define DECAL_ANGLE_FADE 1
        #define _MATERIAL_AFFECTS_EMISSION 1
        
            // Includes
            #include_with_pragmas "Packages/com.unity.render-pipelines.universal/ShaderLibrary/DOTS.hlsl"
        #include_with_pragmas "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Fog.hlsl"
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
        #include_with_pragmas "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ProbeVolumeVariants.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShaderPass.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/DecalInput.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShaderVariablesDecal.hlsl"
        
            // -- Properties used by ScenePickingPass
            #ifdef SCENEPICKINGPASS
            float4 _SelectionID;
            #endif
            #if _RENDER_PASS_ENABLED
            #define GBUFFER3 0
            FRAMEBUFFER_INPUT_X_FLOAT(GBUFFER3);
            #define GBUFFER4 1
            FRAMEBUFFER_INPUT_X_UINT(GBUFFER4);
            #endif
        
            // --------------------------------------------------
            // Structs and Packing
        
            struct Attributes
        {
             float3 positionOS : POSITION;
             float3 normalOS : NORMAL;
             float4 uv0 : TEXCOORD0;
            #if UNITY_ANY_INSTANCING_ENABLED || defined(ATTRIBUTES_NEED_INSTANCEID)
             uint instanceID : INSTANCEID_SEMANTIC;
            #endif
        };
        struct Varyings
        {
             float4 positionCS : SV_POSITION;
             float3 normalWS;
             float4 texCoord0;
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
             float3 TangentSpaceNormal;
             float4 uv0;
        };
        struct VertexDescriptionInputs
        {
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
             float4 texCoord0 : INTERP5;
             float4 fogFactorAndVertexLight : INTERP6;
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
            output.texCoord0.xyzw = input.texCoord0;
            output.fogFactorAndVertexLight.xyzw = input.fogFactorAndVertexLight;
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
            output.texCoord0 = input.texCoord0.xyzw;
            output.fogFactorAndVertexLight = input.fogFactorAndVertexLight.xyzw;
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
        float _Alpha_Multiply;
        float _Alpha_Power;
        float4 _BaseColorMap_TexelSize;
        float4 _NormalMap_TexelSize;
        float Normal_Blend;
        float4 _BaseColor;
        float4 _MaskMap_TexelSize;
        float _MetallicRemapMax;
        float _MetallicRemapMin;
        float _AORemapMin;
        float _AORemapMax;
        float _SmoothnessRemapMin;
        float _SmoothnessRemapMax;
        float _MaskBlendSrc;
        float4 _EmissiveColor;
        float4 _EmissiveColorMap_TexelSize;
        float _Alpha_Use_T_Base_Color_A_F_Maskmap_B;
        float _MaskMap_Alpha_Use_T_Base_Color_A_F_Maskmap_B;
        float _DrawOrder;
        float _DecalMeshBiasType;
        float _DecalMeshDepthBias;
        float _DecalMeshViewBias;
        float _DecalAngleFadeSupported;
        UNITY_TEXTURE_STREAMING_DEBUG_VARS;
        CBUFFER_END
        
        
        // Object and Global properties
        SAMPLER(SamplerState_Linear_Repeat);
        TEXTURE2D(_BaseColorMap);
        SAMPLER(sampler_BaseColorMap);
        TEXTURE2D(_NormalMap);
        SAMPLER(sampler_NormalMap);
        TEXTURE2D(_MaskMap);
        SAMPLER(sampler_MaskMap);
        TEXTURE2D(_EmissiveColorMap);
        SAMPLER(sampler_EmissiveColorMap);
        
            // Graph Includes
            // GraphIncludes: <None>
        
            // Graph Functions
            
        void Unity_Multiply_float4_float4(float4 A, float4 B, out float4 Out)
        {
            Out = A * B;
        }
        
        void Unity_Branch_float(float Predicate, float True, float False, out float Out)
        {
            Out = Predicate ? True : False;
        }
        
        void Unity_Multiply_float_float(float A, float B, out float Out)
        {
            Out = A * B;
        }
        
        void Unity_Absolute_float(float In, out float Out)
        {
            Out = abs(In);
        }
        
        void Unity_Power_float(float A, float B, out float Out)
        {
            Out = pow(A, B);
        }
        
        void Unity_Clamp_float(float In, float Min, float Max, out float Out)
        {
            Out = clamp(In, Min, Max);
        }
        
        void Unity_Remap_float(float In, float2 InMinMax, float2 OutMinMax, out float Out)
        {
            Out = OutMinMax.x + (In - InMinMax.x) * (OutMinMax.y - OutMinMax.x) / (InMinMax.y - InMinMax.x);
        }
        
            // Graph Vertex
            struct VertexDescription
        {
        };
        
        VertexDescription VertexDescriptionFunction(VertexDescriptionInputs IN)
        {
            VertexDescription description = (VertexDescription)0;
            return description;
        }
        
            // Graph Pixel
            struct SurfaceDescription
        {
            float3 BaseColor;
            float Alpha;
            float3 NormalTS;
            float NormalAlpha;
            float Metallic;
            float Occlusion;
            float Smoothness;
            float MAOSAlpha;
            float3 Emission;
        };
        
        SurfaceDescription SurfaceDescriptionFunction(SurfaceDescriptionInputs IN)
        {
            SurfaceDescription surface = (SurfaceDescription)0;
            float4 _Property_320fefd883db46679cd769f61b130dd7_Out_0_Vector4 = _BaseColor;
            UnityTexture2D _Property_9f1059a7a93a46ccab349515214f3ed2_Out_0_Texture2D = UnityBuildTexture2DStructNoScale(_BaseColorMap);
            float4 _SampleTexture2D_7388a7ddbf6648ec92c3bb54ed055048_RGBA_0_Vector4 = SAMPLE_TEXTURE2D(_Property_9f1059a7a93a46ccab349515214f3ed2_Out_0_Texture2D.tex, _Property_9f1059a7a93a46ccab349515214f3ed2_Out_0_Texture2D.samplerstate, _Property_9f1059a7a93a46ccab349515214f3ed2_Out_0_Texture2D.GetTransformedUV(IN.uv0.xy) );
            float _SampleTexture2D_7388a7ddbf6648ec92c3bb54ed055048_R_4_Float = _SampleTexture2D_7388a7ddbf6648ec92c3bb54ed055048_RGBA_0_Vector4.r;
            float _SampleTexture2D_7388a7ddbf6648ec92c3bb54ed055048_G_5_Float = _SampleTexture2D_7388a7ddbf6648ec92c3bb54ed055048_RGBA_0_Vector4.g;
            float _SampleTexture2D_7388a7ddbf6648ec92c3bb54ed055048_B_6_Float = _SampleTexture2D_7388a7ddbf6648ec92c3bb54ed055048_RGBA_0_Vector4.b;
            float _SampleTexture2D_7388a7ddbf6648ec92c3bb54ed055048_A_7_Float = _SampleTexture2D_7388a7ddbf6648ec92c3bb54ed055048_RGBA_0_Vector4.a;
            float4 _Multiply_885586d42d884019a5375f12f3c61e52_Out_2_Vector4;
            Unity_Multiply_float4_float4(_Property_320fefd883db46679cd769f61b130dd7_Out_0_Vector4, _SampleTexture2D_7388a7ddbf6648ec92c3bb54ed055048_RGBA_0_Vector4, _Multiply_885586d42d884019a5375f12f3c61e52_Out_2_Vector4);
            float _Property_10cb48b77e114c99a77554a14a36ed9a_Out_0_Float = _Alpha_Multiply;
            float _Property_97f64a9c7748494dbf6dc5b32920f5a5_Out_0_Boolean = _Alpha_Use_T_Base_Color_A_F_Maskmap_B;
            float _Split_da1fca62bd1b452a906195ffb7fa6a18_R_1_Float = _Multiply_885586d42d884019a5375f12f3c61e52_Out_2_Vector4[0];
            float _Split_da1fca62bd1b452a906195ffb7fa6a18_G_2_Float = _Multiply_885586d42d884019a5375f12f3c61e52_Out_2_Vector4[1];
            float _Split_da1fca62bd1b452a906195ffb7fa6a18_B_3_Float = _Multiply_885586d42d884019a5375f12f3c61e52_Out_2_Vector4[2];
            float _Split_da1fca62bd1b452a906195ffb7fa6a18_A_4_Float = _Multiply_885586d42d884019a5375f12f3c61e52_Out_2_Vector4[3];
            UnityTexture2D _Property_b46891aff98b4364a190337410150f10_Out_0_Texture2D = UnityBuildTexture2DStructNoScale(_MaskMap);
            float4 _SampleTexture2D_2dcb30935afc407482bb065c4150e563_RGBA_0_Vector4 = SAMPLE_TEXTURE2D(_Property_b46891aff98b4364a190337410150f10_Out_0_Texture2D.tex, _Property_b46891aff98b4364a190337410150f10_Out_0_Texture2D.samplerstate, _Property_b46891aff98b4364a190337410150f10_Out_0_Texture2D.GetTransformedUV(IN.uv0.xy) );
            float _SampleTexture2D_2dcb30935afc407482bb065c4150e563_R_4_Float = _SampleTexture2D_2dcb30935afc407482bb065c4150e563_RGBA_0_Vector4.r;
            float _SampleTexture2D_2dcb30935afc407482bb065c4150e563_G_5_Float = _SampleTexture2D_2dcb30935afc407482bb065c4150e563_RGBA_0_Vector4.g;
            float _SampleTexture2D_2dcb30935afc407482bb065c4150e563_B_6_Float = _SampleTexture2D_2dcb30935afc407482bb065c4150e563_RGBA_0_Vector4.b;
            float _SampleTexture2D_2dcb30935afc407482bb065c4150e563_A_7_Float = _SampleTexture2D_2dcb30935afc407482bb065c4150e563_RGBA_0_Vector4.a;
            float _Branch_eb932f0ef97d49398f01d62d896b2b60_Out_3_Float;
            Unity_Branch_float(_Property_97f64a9c7748494dbf6dc5b32920f5a5_Out_0_Boolean, _Split_da1fca62bd1b452a906195ffb7fa6a18_A_4_Float, _SampleTexture2D_2dcb30935afc407482bb065c4150e563_B_6_Float, _Branch_eb932f0ef97d49398f01d62d896b2b60_Out_3_Float);
            float _Multiply_3c4f7578756f4e789ded2b826c933b6d_Out_2_Float;
            Unity_Multiply_float_float(_Property_10cb48b77e114c99a77554a14a36ed9a_Out_0_Float, _Branch_eb932f0ef97d49398f01d62d896b2b60_Out_3_Float, _Multiply_3c4f7578756f4e789ded2b826c933b6d_Out_2_Float);
            float _Absolute_cc8840692870447e8bc057dbbf5f18c1_Out_1_Float;
            Unity_Absolute_float(_Multiply_3c4f7578756f4e789ded2b826c933b6d_Out_2_Float, _Absolute_cc8840692870447e8bc057dbbf5f18c1_Out_1_Float);
            float _Property_472619a20fe14990a52e2bbe0c00ea22_Out_0_Float = _Alpha_Power;
            float _Power_55566f012c2d4585bb257e256506056c_Out_2_Float;
            Unity_Power_float(_Absolute_cc8840692870447e8bc057dbbf5f18c1_Out_1_Float, _Property_472619a20fe14990a52e2bbe0c00ea22_Out_0_Float, _Power_55566f012c2d4585bb257e256506056c_Out_2_Float);
            float _Clamp_4788840726ef4518b7a1fc8db3fcdd97_Out_3_Float;
            Unity_Clamp_float(_Power_55566f012c2d4585bb257e256506056c_Out_2_Float, float(0), float(1), _Clamp_4788840726ef4518b7a1fc8db3fcdd97_Out_3_Float);
            UnityTexture2D _Property_360e6833e8d64d75827ab98987b2b545_Out_0_Texture2D = UnityBuildTexture2DStructNoScale(_NormalMap);
            float4 _SampleTexture2D_1300b7cb738f4b18927411750039acd2_RGBA_0_Vector4 = SAMPLE_TEXTURE2D(_Property_360e6833e8d64d75827ab98987b2b545_Out_0_Texture2D.tex, _Property_360e6833e8d64d75827ab98987b2b545_Out_0_Texture2D.samplerstate, _Property_360e6833e8d64d75827ab98987b2b545_Out_0_Texture2D.GetTransformedUV(IN.uv0.xy) );
            _SampleTexture2D_1300b7cb738f4b18927411750039acd2_RGBA_0_Vector4.rgb = UnpackNormal(_SampleTexture2D_1300b7cb738f4b18927411750039acd2_RGBA_0_Vector4);
            float _SampleTexture2D_1300b7cb738f4b18927411750039acd2_R_4_Float = _SampleTexture2D_1300b7cb738f4b18927411750039acd2_RGBA_0_Vector4.r;
            float _SampleTexture2D_1300b7cb738f4b18927411750039acd2_G_5_Float = _SampleTexture2D_1300b7cb738f4b18927411750039acd2_RGBA_0_Vector4.g;
            float _SampleTexture2D_1300b7cb738f4b18927411750039acd2_B_6_Float = _SampleTexture2D_1300b7cb738f4b18927411750039acd2_RGBA_0_Vector4.b;
            float _SampleTexture2D_1300b7cb738f4b18927411750039acd2_A_7_Float = _SampleTexture2D_1300b7cb738f4b18927411750039acd2_RGBA_0_Vector4.a;
            float _Property_e94639b7a37847e1a4616aeed6a21034_Out_0_Boolean = _MaskMap_Alpha_Use_T_Base_Color_A_F_Maskmap_B;
            float _Branch_39df5838709544d2951602a5ba721694_Out_3_Float;
            Unity_Branch_float(_Property_e94639b7a37847e1a4616aeed6a21034_Out_0_Boolean, _Split_da1fca62bd1b452a906195ffb7fa6a18_A_4_Float, _SampleTexture2D_2dcb30935afc407482bb065c4150e563_B_6_Float, _Branch_39df5838709544d2951602a5ba721694_Out_3_Float);
            float _Property_1ed131c6c6bd4d3b9225106c761ab06c_Out_0_Float = Normal_Blend;
            float _Multiply_52cb6c63b083455c8e01c3d5ccd89afc_Out_2_Float;
            Unity_Multiply_float_float(_Branch_39df5838709544d2951602a5ba721694_Out_3_Float, _Property_1ed131c6c6bd4d3b9225106c761ab06c_Out_0_Float, _Multiply_52cb6c63b083455c8e01c3d5ccd89afc_Out_2_Float);
            float _Property_5830ed7c65ef489e93de994fcb2769e2_Out_0_Float = _MetallicRemapMin;
            float _Property_3b33ae94b35943b5bbaa24c03b7069a8_Out_0_Float = _MetallicRemapMax;
            float2 _Vector2_0ad2d19d32894d5e83e19e69d72753fd_Out_0_Vector2 = float2(_Property_5830ed7c65ef489e93de994fcb2769e2_Out_0_Float, _Property_3b33ae94b35943b5bbaa24c03b7069a8_Out_0_Float);
            float _Remap_b3145e45987e489f9b15e9672b41a608_Out_3_Float;
            Unity_Remap_float(_SampleTexture2D_2dcb30935afc407482bb065c4150e563_R_4_Float, float2 (0, 1), _Vector2_0ad2d19d32894d5e83e19e69d72753fd_Out_0_Vector2, _Remap_b3145e45987e489f9b15e9672b41a608_Out_3_Float);
            float _Property_6427dba68c8342eebff5ce521921ddc5_Out_0_Float = _AORemapMin;
            float _Property_f74a95489f364e41b53a083f89ad2365_Out_0_Float = _AORemapMax;
            float2 _Vector2_a00f84e5347b414ca0e9496b9948ba0b_Out_0_Vector2 = float2(_Property_6427dba68c8342eebff5ce521921ddc5_Out_0_Float, _Property_f74a95489f364e41b53a083f89ad2365_Out_0_Float);
            float _Remap_75ea5a896ac148bb8058b60d79c90284_Out_3_Float;
            Unity_Remap_float(_SampleTexture2D_2dcb30935afc407482bb065c4150e563_G_5_Float, float2 (0, 1), _Vector2_a00f84e5347b414ca0e9496b9948ba0b_Out_0_Vector2, _Remap_75ea5a896ac148bb8058b60d79c90284_Out_3_Float);
            float _Property_9d6993415be843799b7ec2e689c5db02_Out_0_Float = _SmoothnessRemapMin;
            float _Property_df4aa91a4fe94e5f8768553f10cd1f82_Out_0_Float = _SmoothnessRemapMax;
            float2 _Vector2_d67e05a1240344f3978c1c9e3cb9525f_Out_0_Vector2 = float2(_Property_9d6993415be843799b7ec2e689c5db02_Out_0_Float, _Property_df4aa91a4fe94e5f8768553f10cd1f82_Out_0_Float);
            float _Remap_ad26abe467c44f5284db4b4203d8242b_Out_3_Float;
            Unity_Remap_float(_SampleTexture2D_2dcb30935afc407482bb065c4150e563_A_7_Float, float2 (0, 1), _Vector2_d67e05a1240344f3978c1c9e3cb9525f_Out_0_Vector2, _Remap_ad26abe467c44f5284db4b4203d8242b_Out_3_Float);
            float _Property_5c661f4099b14a5bac0c24977977340d_Out_0_Float = _MaskBlendSrc;
            float _Multiply_fc69b6805f38404cb402d2a6b2d2b73a_Out_2_Float;
            Unity_Multiply_float_float(_Split_da1fca62bd1b452a906195ffb7fa6a18_A_4_Float, _Property_5c661f4099b14a5bac0c24977977340d_Out_0_Float, _Multiply_fc69b6805f38404cb402d2a6b2d2b73a_Out_2_Float);
            float _Multiply_2f94ef00580f43caa2427a59ed8ca124_Out_2_Float;
            Unity_Multiply_float_float(_Property_5c661f4099b14a5bac0c24977977340d_Out_0_Float, _SampleTexture2D_2dcb30935afc407482bb065c4150e563_B_6_Float, _Multiply_2f94ef00580f43caa2427a59ed8ca124_Out_2_Float);
            float _Branch_753c02949c6b4f128d654534f2d64ced_Out_3_Float;
            Unity_Branch_float(_Property_e94639b7a37847e1a4616aeed6a21034_Out_0_Boolean, _Multiply_fc69b6805f38404cb402d2a6b2d2b73a_Out_2_Float, _Multiply_2f94ef00580f43caa2427a59ed8ca124_Out_2_Float, _Branch_753c02949c6b4f128d654534f2d64ced_Out_3_Float);
            float4 _Property_293317916e0e41cc98bbd5377294091b_Out_0_Vector4 = IsGammaSpace() ? LinearToSRGB(_EmissiveColor) : _EmissiveColor;
            UnityTexture2D _Property_fb3929b3be5f4269845ceb27fb377d12_Out_0_Texture2D = UnityBuildTexture2DStructNoScale(_EmissiveColorMap);
            float4 _SampleTexture2D_d4d6d2f60c614e4c8b681d89316209dc_RGBA_0_Vector4 = SAMPLE_TEXTURE2D(_Property_fb3929b3be5f4269845ceb27fb377d12_Out_0_Texture2D.tex, _Property_fb3929b3be5f4269845ceb27fb377d12_Out_0_Texture2D.samplerstate, _Property_fb3929b3be5f4269845ceb27fb377d12_Out_0_Texture2D.GetTransformedUV(IN.uv0.xy) );
            float _SampleTexture2D_d4d6d2f60c614e4c8b681d89316209dc_R_4_Float = _SampleTexture2D_d4d6d2f60c614e4c8b681d89316209dc_RGBA_0_Vector4.r;
            float _SampleTexture2D_d4d6d2f60c614e4c8b681d89316209dc_G_5_Float = _SampleTexture2D_d4d6d2f60c614e4c8b681d89316209dc_RGBA_0_Vector4.g;
            float _SampleTexture2D_d4d6d2f60c614e4c8b681d89316209dc_B_6_Float = _SampleTexture2D_d4d6d2f60c614e4c8b681d89316209dc_RGBA_0_Vector4.b;
            float _SampleTexture2D_d4d6d2f60c614e4c8b681d89316209dc_A_7_Float = _SampleTexture2D_d4d6d2f60c614e4c8b681d89316209dc_RGBA_0_Vector4.a;
            float4 _Multiply_2fa508cc2b6044e09e63453927d92375_Out_2_Vector4;
            Unity_Multiply_float4_float4(_Property_293317916e0e41cc98bbd5377294091b_Out_0_Vector4, _SampleTexture2D_d4d6d2f60c614e4c8b681d89316209dc_RGBA_0_Vector4, _Multiply_2fa508cc2b6044e09e63453927d92375_Out_2_Vector4);
            surface.BaseColor = (_Multiply_885586d42d884019a5375f12f3c61e52_Out_2_Vector4.xyz);
            surface.Alpha = _Clamp_4788840726ef4518b7a1fc8db3fcdd97_Out_3_Float;
            surface.NormalTS = (_SampleTexture2D_1300b7cb738f4b18927411750039acd2_RGBA_0_Vector4.xyz);
            surface.NormalAlpha = _Multiply_52cb6c63b083455c8e01c3d5ccd89afc_Out_2_Float;
            surface.Metallic = _Remap_b3145e45987e489f9b15e9672b41a608_Out_3_Float;
            surface.Occlusion = _Remap_75ea5a896ac148bb8058b60d79c90284_Out_3_Float;
            surface.Smoothness = _Remap_ad26abe467c44f5284db4b4203d8242b_Out_3_Float;
            surface.MAOSAlpha = _Branch_753c02949c6b4f128d654534f2d64ced_Out_3_Float;
            surface.Emission = (_Multiply_2fa508cc2b6044e09e63453927d92375_Out_2_Vector4.xyz);
            return surface;
        }
        
            // --------------------------------------------------
            // Build Graph Inputs
        
            
        //     $features.graphVertex:  $include("VertexAnimation.template.hlsl")
        //                                       ^ ERROR: $include cannot find file : VertexAnimation.template.hlsl. Looked into:
        // Packages/com.unity.shadergraph/Editor/Generation/Templates
        
            
        //     $features.graphPixel:   $include("SharedCode.template.hlsl")
        //                                       ^ ERROR: $include cannot find file : SharedCode.template.hlsl. Looked into:
        // Packages/com.unity.shadergraph/Editor/Generation/Templates
        
            SurfaceDescriptionInputs BuildSurfaceDescriptionInputs(Varyings input)
        {
            SurfaceDescriptionInputs output;
            ZERO_INITIALIZE(SurfaceDescriptionInputs, output);
        
            /* WARNING: $splice Could not find named fragment 'CustomInterpolatorCopyToSDI' */
        
        
        
            output.TangentSpaceNormal =                         float3(0.0f, 0.0f, 1.0f);
        
        
        
            #if UNITY_UV_STARTS_AT_TOP
            #else
            #endif
        
        
        
        #if defined(UNITY_UIE_INCLUDED)
            output.uv0 =                                        float4(input.texCoord0.x, input.texCoord0.y, 0, 0);
        #else
            output.uv0 =                                        input.texCoord0;
        #endif
            
        
            
            
        #if UNITY_ANY_INSTANCING_ENABLED
        #else // TODO: XR support for procedural instancing because in this case UNITY_ANY_INSTANCING_ENABLED is not defined and instanceID is incorrect.
        #endif
        #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
        #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN                output.FaceSign =                                   IS_FRONT_VFACE(input.cullFace, true, false);
        #else
        #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
        #endif
        #undef BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
        
            return output;
        }
        
            // --------------------------------------------------
            // Build Surface Data
        
            void GetSurfaceData(Varyings input, float4 positionCS, float angleFadeFactor, out DecalSurfaceData surfaceData)
            {
                #if (SHADERPASS == SHADERPASS_DBUFFER_PROJECTOR) || (SHADERPASS == SHADERPASS_FORWARD_EMISSIVE_PROJECTOR) || (SHADERPASS == SHADERPASS_DECAL_SCREEN_SPACE_PROJECTOR) || (SHADERPASS == SHADERPASS_DECAL_GBUFFER_PROJECTOR)
                    half4x4 normalToWorld = UNITY_ACCESS_INSTANCED_PROP(Decal, _NormalToWorld);
                    half fadeFactor = clamp(normalToWorld[0][3], 0.0f, 1.0f) * angleFadeFactor;
                    float2 scale = float2(normalToWorld[3][0], normalToWorld[3][1]);
                    float2 offset = float2(normalToWorld[3][2], normalToWorld[3][3]);
                    input.texCoord0.xy = input.texCoord0.xy * scale + offset;
                    half3 normalWS = TransformObjectToWorldDir(half3(0, 1, 0));
                    half3 tangentWS = TransformObjectToWorldDir(half3(1, 0, 0));
                    half3 bitangentWS = TransformObjectToWorldDir(half3(0, 0, 1));
                    half sign = dot(cross(normalWS, tangentWS), bitangentWS) > 0 ? 1 : -1;
                    input.normalWS.xyz = normalWS;
                #else
                    #if defined(LOD_FADE_CROSSFADE) && USE_UNITY_CROSSFADE
                        LODFadeCrossFade(positionCS);
                    #endif
        
                    half fadeFactor = half(1.0);
                #endif
        
                SurfaceDescriptionInputs surfaceDescriptionInputs = BuildSurfaceDescriptionInputs(input);
                SurfaceDescription surfaceDescription = SurfaceDescriptionFunction(surfaceDescriptionInputs);
        
                // setup defaults -- these are used if the graph doesn't output a value
                ZERO_INITIALIZE(DecalSurfaceData, surfaceData);
                surfaceData.occlusion = half(1.0);
                surfaceData.smoothness = half(0);
        
                #ifdef _MATERIAL_AFFECTS_NORMAL
                    surfaceData.normalWS.w = half(1.0);
                #else
                    surfaceData.normalWS.w = half(0.0);
                #endif
        
                surfaceData.emissive.rgb = half3(surfaceDescription.Emission.rgb * fadeFactor);
        
                // copy across graph values, if defined
                surfaceData.baseColor.xyz = half3(surfaceDescription.BaseColor);
                surfaceData.baseColor.w = half(surfaceDescription.Alpha * fadeFactor);
        
                #if (SHADERPASS == SHADERPASS_DBUFFER_PROJECTOR) || (SHADERPASS == SHADERPASS_DECAL_SCREEN_SPACE_PROJECTOR) || (SHADERPASS == SHADERPASS_DECAL_GBUFFER_PROJECTOR)
                    #if defined(_MATERIAL_AFFECTS_NORMAL)
                        surfaceData.normalWS.xyz = normalize(mul((half3x3)normalToWorld, surfaceDescription.NormalTS.xyz));
                    #else
                        surfaceData.normalWS.xyz = normalize(normalToWorld[2].xyz);
                    #endif
                #elif (SHADERPASS == SHADERPASS_DBUFFER_MESH) || (SHADERPASS == SHADERPASS_DECAL_SCREEN_SPACE_MESH) || (SHADERPASS == SHADERPASS_DECAL_GBUFFER_MESH)
                    #if defined(_MATERIAL_AFFECTS_NORMAL)
                        float sgn = input.tangentWS.w;      // should be either +1 or -1
                        float3 bitangent = sgn * cross(input.normalWS.xyz, input.tangentWS.xyz);
                        half3x3 tangentToWorld = half3x3(input.tangentWS.xyz, bitangent.xyz, input.normalWS.xyz);
        
                        // We need to normalize as we use mikkt tangent space and this is expected (tangent space is not normalize)
                        surfaceData.normalWS.xyz = normalize(TransformTangentToWorld(surfaceDescription.NormalTS, tangentToWorld));
                    #else
                        surfaceData.normalWS.xyz = normalize(half3(input.normalWS)); // Default to vertex normal
                    #endif
                #endif
        
                surfaceData.normalWS.w = surfaceDescription.NormalAlpha * fadeFactor;
        
                // In case of Smoothness / AO / Metal, all the three are always computed but color mask can change
                surfaceData.metallic = half(surfaceDescription.Metallic);
                surfaceData.occlusion = half(surfaceDescription.Occlusion);
                surfaceData.smoothness = half(surfaceDescription.Smoothness);
                surfaceData.MAOSAlpha = half(surfaceDescription.MAOSAlpha * fadeFactor);
            }
        
            // --------------------------------------------------
            // Main
        
            #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/Varyings.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShaderPassDecal.hlsl"
        
            ENDHLSL
        }
        Pass
        {
            Name "DecalGBufferProjector"
            Tags
            {
                "LightMode" = "DecalGBufferProjector"
            }
        
            // Render State
            Cull Front
        Blend 0 SrcAlpha OneMinusSrcAlpha
        Blend 1 SrcAlpha OneMinusSrcAlpha
        Blend 2 SrcAlpha OneMinusSrcAlpha
        Blend 3 SrcAlpha OneMinusSrcAlpha
        ZTest Greater
        ZWrite Off
        ColorMask RGB
        ColorMask 0 1
        ColorMask RGB 2
        ColorMask RGB 3
        
            // Debug
            // <None>
        
            // --------------------------------------------------
            // Pass
        
            HLSLPROGRAM
        
            // Pragmas
            #pragma target 4.5
        #pragma exclude_renderers gles3 glcore
        #pragma vertex Vert
        #pragma fragment Frag
        #pragma multi_compile_instancing
        #pragma editor_sync_compilation
        
            // Keywords
            #pragma multi_compile _ _MAIN_LIGHT_SHADOWS _MAIN_LIGHT_SHADOWS_CASCADE _MAIN_LIGHT_SHADOWS_SCREEN
        #pragma multi_compile_fragment _ _SHADOWS_SOFT _SHADOWS_SOFT_LOW _SHADOWS_SOFT_MEDIUM _SHADOWS_SOFT_HIGH
        #pragma multi_compile _DECAL_NORMAL_BLEND_LOW _DECAL_NORMAL_BLEND_MEDIUM _DECAL_NORMAL_BLEND_HIGH
        #pragma multi_compile _ _DECAL_LAYERS
        #pragma multi_compile_fragment _ _GBUFFER_NORMALS_OCT
        #pragma multi_compile_fragment _ _RENDER_PASS_ENABLED
            // GraphKeywords: <None>
        
            #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Common.hlsl"
            #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Texture.hlsl"
            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
        
            // Defines
            #define ATTRIBUTES_NEED_NORMAL
            #define ATTRIBUTES_NEED_TEXCOORD0
            #define VARYINGS_NEED_NORMAL_WS
            #define VARYINGS_NEED_TEXCOORD0
            #define VARYINGS_NEED_SH
            #define VARYINGS_NEED_STATIC_LIGHTMAP_UV
            #define VARYINGS_NEED_DYNAMIC_LIGHTMAP_UV
            #define VARYINGS_NEED_SHADOW_COORD
        
            #define HAVE_MESH_MODIFICATION
        
        
            #define SHADERPASS SHADERPASS_DECAL_GBUFFER_PROJECTOR
        #define _MATERIAL_AFFECTS_ALBEDO 1
        #define _MATERIAL_AFFECTS_NORMAL 1
        #define _MATERIAL_AFFECTS_NORMAL_BLEND 1
        #define _MATERIAL_AFFECTS_MAOS 1
        #define DECAL_ANGLE_FADE 1
        #define _MATERIAL_AFFECTS_EMISSION 1
        
            // Includes
            #include_with_pragmas "Packages/com.unity.render-pipelines.universal/ShaderLibrary/DOTS.hlsl"
        #include_with_pragmas "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Fog.hlsl"
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
        #include_with_pragmas "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ProbeVolumeVariants.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/GBufferOutput.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShaderPass.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/DecalInput.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShaderVariablesDecal.hlsl"
        
            // -- Properties used by ScenePickingPass
            #ifdef SCENEPICKINGPASS
            float4 _SelectionID;
            #endif
            #if _RENDER_PASS_ENABLED
            #define GBUFFER3 0
            FRAMEBUFFER_INPUT_X_FLOAT(GBUFFER3);
            #define GBUFFER4 1
            FRAMEBUFFER_INPUT_X_UINT(GBUFFER4);
            #endif
        
            // --------------------------------------------------
            // Structs and Packing
        
            struct Attributes
        {
             float3 positionOS : POSITION;
             float3 normalOS : NORMAL;
             float4 uv0 : TEXCOORD0;
            #if UNITY_ANY_INSTANCING_ENABLED || defined(ATTRIBUTES_NEED_INSTANCEID)
             uint instanceID : INSTANCEID_SEMANTIC;
            #endif
        };
        struct Varyings
        {
             float4 positionCS : SV_POSITION;
             float3 normalWS;
             float4 texCoord0;
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
             float3 TangentSpaceNormal;
             float4 uv0;
        };
        struct VertexDescriptionInputs
        {
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
             float4 texCoord0 : INTERP5;
             float3 normalWS : INTERP6;
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
            output.texCoord0.xyzw = input.texCoord0;
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
            output.texCoord0 = input.texCoord0.xyzw;
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
        float _Alpha_Multiply;
        float _Alpha_Power;
        float4 _BaseColorMap_TexelSize;
        float4 _NormalMap_TexelSize;
        float Normal_Blend;
        float4 _BaseColor;
        float4 _MaskMap_TexelSize;
        float _MetallicRemapMax;
        float _MetallicRemapMin;
        float _AORemapMin;
        float _AORemapMax;
        float _SmoothnessRemapMin;
        float _SmoothnessRemapMax;
        float _MaskBlendSrc;
        float4 _EmissiveColor;
        float4 _EmissiveColorMap_TexelSize;
        float _Alpha_Use_T_Base_Color_A_F_Maskmap_B;
        float _MaskMap_Alpha_Use_T_Base_Color_A_F_Maskmap_B;
        float _DrawOrder;
        float _DecalMeshBiasType;
        float _DecalMeshDepthBias;
        float _DecalMeshViewBias;
        float _DecalAngleFadeSupported;
        UNITY_TEXTURE_STREAMING_DEBUG_VARS;
        CBUFFER_END
        
        
        // Object and Global properties
        SAMPLER(SamplerState_Linear_Repeat);
        TEXTURE2D(_BaseColorMap);
        SAMPLER(sampler_BaseColorMap);
        TEXTURE2D(_NormalMap);
        SAMPLER(sampler_NormalMap);
        TEXTURE2D(_MaskMap);
        SAMPLER(sampler_MaskMap);
        TEXTURE2D(_EmissiveColorMap);
        SAMPLER(sampler_EmissiveColorMap);
        
            // Graph Includes
            // GraphIncludes: <None>
        
            // Graph Functions
            
        void Unity_Multiply_float4_float4(float4 A, float4 B, out float4 Out)
        {
            Out = A * B;
        }
        
        void Unity_Branch_float(float Predicate, float True, float False, out float Out)
        {
            Out = Predicate ? True : False;
        }
        
        void Unity_Multiply_float_float(float A, float B, out float Out)
        {
            Out = A * B;
        }
        
        void Unity_Absolute_float(float In, out float Out)
        {
            Out = abs(In);
        }
        
        void Unity_Power_float(float A, float B, out float Out)
        {
            Out = pow(A, B);
        }
        
        void Unity_Clamp_float(float In, float Min, float Max, out float Out)
        {
            Out = clamp(In, Min, Max);
        }
        
        void Unity_Remap_float(float In, float2 InMinMax, float2 OutMinMax, out float Out)
        {
            Out = OutMinMax.x + (In - InMinMax.x) * (OutMinMax.y - OutMinMax.x) / (InMinMax.y - InMinMax.x);
        }
        
            // Graph Vertex
            struct VertexDescription
        {
        };
        
        VertexDescription VertexDescriptionFunction(VertexDescriptionInputs IN)
        {
            VertexDescription description = (VertexDescription)0;
            return description;
        }
        
            // Graph Pixel
            struct SurfaceDescription
        {
            float3 BaseColor;
            float Alpha;
            float3 NormalTS;
            float NormalAlpha;
            float Metallic;
            float Occlusion;
            float Smoothness;
            float MAOSAlpha;
            float3 Emission;
        };
        
        SurfaceDescription SurfaceDescriptionFunction(SurfaceDescriptionInputs IN)
        {
            SurfaceDescription surface = (SurfaceDescription)0;
            float4 _Property_320fefd883db46679cd769f61b130dd7_Out_0_Vector4 = _BaseColor;
            UnityTexture2D _Property_9f1059a7a93a46ccab349515214f3ed2_Out_0_Texture2D = UnityBuildTexture2DStructNoScale(_BaseColorMap);
            float4 _SampleTexture2D_7388a7ddbf6648ec92c3bb54ed055048_RGBA_0_Vector4 = SAMPLE_TEXTURE2D(_Property_9f1059a7a93a46ccab349515214f3ed2_Out_0_Texture2D.tex, _Property_9f1059a7a93a46ccab349515214f3ed2_Out_0_Texture2D.samplerstate, _Property_9f1059a7a93a46ccab349515214f3ed2_Out_0_Texture2D.GetTransformedUV(IN.uv0.xy) );
            float _SampleTexture2D_7388a7ddbf6648ec92c3bb54ed055048_R_4_Float = _SampleTexture2D_7388a7ddbf6648ec92c3bb54ed055048_RGBA_0_Vector4.r;
            float _SampleTexture2D_7388a7ddbf6648ec92c3bb54ed055048_G_5_Float = _SampleTexture2D_7388a7ddbf6648ec92c3bb54ed055048_RGBA_0_Vector4.g;
            float _SampleTexture2D_7388a7ddbf6648ec92c3bb54ed055048_B_6_Float = _SampleTexture2D_7388a7ddbf6648ec92c3bb54ed055048_RGBA_0_Vector4.b;
            float _SampleTexture2D_7388a7ddbf6648ec92c3bb54ed055048_A_7_Float = _SampleTexture2D_7388a7ddbf6648ec92c3bb54ed055048_RGBA_0_Vector4.a;
            float4 _Multiply_885586d42d884019a5375f12f3c61e52_Out_2_Vector4;
            Unity_Multiply_float4_float4(_Property_320fefd883db46679cd769f61b130dd7_Out_0_Vector4, _SampleTexture2D_7388a7ddbf6648ec92c3bb54ed055048_RGBA_0_Vector4, _Multiply_885586d42d884019a5375f12f3c61e52_Out_2_Vector4);
            float _Property_10cb48b77e114c99a77554a14a36ed9a_Out_0_Float = _Alpha_Multiply;
            float _Property_97f64a9c7748494dbf6dc5b32920f5a5_Out_0_Boolean = _Alpha_Use_T_Base_Color_A_F_Maskmap_B;
            float _Split_da1fca62bd1b452a906195ffb7fa6a18_R_1_Float = _Multiply_885586d42d884019a5375f12f3c61e52_Out_2_Vector4[0];
            float _Split_da1fca62bd1b452a906195ffb7fa6a18_G_2_Float = _Multiply_885586d42d884019a5375f12f3c61e52_Out_2_Vector4[1];
            float _Split_da1fca62bd1b452a906195ffb7fa6a18_B_3_Float = _Multiply_885586d42d884019a5375f12f3c61e52_Out_2_Vector4[2];
            float _Split_da1fca62bd1b452a906195ffb7fa6a18_A_4_Float = _Multiply_885586d42d884019a5375f12f3c61e52_Out_2_Vector4[3];
            UnityTexture2D _Property_b46891aff98b4364a190337410150f10_Out_0_Texture2D = UnityBuildTexture2DStructNoScale(_MaskMap);
            float4 _SampleTexture2D_2dcb30935afc407482bb065c4150e563_RGBA_0_Vector4 = SAMPLE_TEXTURE2D(_Property_b46891aff98b4364a190337410150f10_Out_0_Texture2D.tex, _Property_b46891aff98b4364a190337410150f10_Out_0_Texture2D.samplerstate, _Property_b46891aff98b4364a190337410150f10_Out_0_Texture2D.GetTransformedUV(IN.uv0.xy) );
            float _SampleTexture2D_2dcb30935afc407482bb065c4150e563_R_4_Float = _SampleTexture2D_2dcb30935afc407482bb065c4150e563_RGBA_0_Vector4.r;
            float _SampleTexture2D_2dcb30935afc407482bb065c4150e563_G_5_Float = _SampleTexture2D_2dcb30935afc407482bb065c4150e563_RGBA_0_Vector4.g;
            float _SampleTexture2D_2dcb30935afc407482bb065c4150e563_B_6_Float = _SampleTexture2D_2dcb30935afc407482bb065c4150e563_RGBA_0_Vector4.b;
            float _SampleTexture2D_2dcb30935afc407482bb065c4150e563_A_7_Float = _SampleTexture2D_2dcb30935afc407482bb065c4150e563_RGBA_0_Vector4.a;
            float _Branch_eb932f0ef97d49398f01d62d896b2b60_Out_3_Float;
            Unity_Branch_float(_Property_97f64a9c7748494dbf6dc5b32920f5a5_Out_0_Boolean, _Split_da1fca62bd1b452a906195ffb7fa6a18_A_4_Float, _SampleTexture2D_2dcb30935afc407482bb065c4150e563_B_6_Float, _Branch_eb932f0ef97d49398f01d62d896b2b60_Out_3_Float);
            float _Multiply_3c4f7578756f4e789ded2b826c933b6d_Out_2_Float;
            Unity_Multiply_float_float(_Property_10cb48b77e114c99a77554a14a36ed9a_Out_0_Float, _Branch_eb932f0ef97d49398f01d62d896b2b60_Out_3_Float, _Multiply_3c4f7578756f4e789ded2b826c933b6d_Out_2_Float);
            float _Absolute_cc8840692870447e8bc057dbbf5f18c1_Out_1_Float;
            Unity_Absolute_float(_Multiply_3c4f7578756f4e789ded2b826c933b6d_Out_2_Float, _Absolute_cc8840692870447e8bc057dbbf5f18c1_Out_1_Float);
            float _Property_472619a20fe14990a52e2bbe0c00ea22_Out_0_Float = _Alpha_Power;
            float _Power_55566f012c2d4585bb257e256506056c_Out_2_Float;
            Unity_Power_float(_Absolute_cc8840692870447e8bc057dbbf5f18c1_Out_1_Float, _Property_472619a20fe14990a52e2bbe0c00ea22_Out_0_Float, _Power_55566f012c2d4585bb257e256506056c_Out_2_Float);
            float _Clamp_4788840726ef4518b7a1fc8db3fcdd97_Out_3_Float;
            Unity_Clamp_float(_Power_55566f012c2d4585bb257e256506056c_Out_2_Float, float(0), float(1), _Clamp_4788840726ef4518b7a1fc8db3fcdd97_Out_3_Float);
            UnityTexture2D _Property_360e6833e8d64d75827ab98987b2b545_Out_0_Texture2D = UnityBuildTexture2DStructNoScale(_NormalMap);
            float4 _SampleTexture2D_1300b7cb738f4b18927411750039acd2_RGBA_0_Vector4 = SAMPLE_TEXTURE2D(_Property_360e6833e8d64d75827ab98987b2b545_Out_0_Texture2D.tex, _Property_360e6833e8d64d75827ab98987b2b545_Out_0_Texture2D.samplerstate, _Property_360e6833e8d64d75827ab98987b2b545_Out_0_Texture2D.GetTransformedUV(IN.uv0.xy) );
            _SampleTexture2D_1300b7cb738f4b18927411750039acd2_RGBA_0_Vector4.rgb = UnpackNormal(_SampleTexture2D_1300b7cb738f4b18927411750039acd2_RGBA_0_Vector4);
            float _SampleTexture2D_1300b7cb738f4b18927411750039acd2_R_4_Float = _SampleTexture2D_1300b7cb738f4b18927411750039acd2_RGBA_0_Vector4.r;
            float _SampleTexture2D_1300b7cb738f4b18927411750039acd2_G_5_Float = _SampleTexture2D_1300b7cb738f4b18927411750039acd2_RGBA_0_Vector4.g;
            float _SampleTexture2D_1300b7cb738f4b18927411750039acd2_B_6_Float = _SampleTexture2D_1300b7cb738f4b18927411750039acd2_RGBA_0_Vector4.b;
            float _SampleTexture2D_1300b7cb738f4b18927411750039acd2_A_7_Float = _SampleTexture2D_1300b7cb738f4b18927411750039acd2_RGBA_0_Vector4.a;
            float _Property_e94639b7a37847e1a4616aeed6a21034_Out_0_Boolean = _MaskMap_Alpha_Use_T_Base_Color_A_F_Maskmap_B;
            float _Branch_39df5838709544d2951602a5ba721694_Out_3_Float;
            Unity_Branch_float(_Property_e94639b7a37847e1a4616aeed6a21034_Out_0_Boolean, _Split_da1fca62bd1b452a906195ffb7fa6a18_A_4_Float, _SampleTexture2D_2dcb30935afc407482bb065c4150e563_B_6_Float, _Branch_39df5838709544d2951602a5ba721694_Out_3_Float);
            float _Property_1ed131c6c6bd4d3b9225106c761ab06c_Out_0_Float = Normal_Blend;
            float _Multiply_52cb6c63b083455c8e01c3d5ccd89afc_Out_2_Float;
            Unity_Multiply_float_float(_Branch_39df5838709544d2951602a5ba721694_Out_3_Float, _Property_1ed131c6c6bd4d3b9225106c761ab06c_Out_0_Float, _Multiply_52cb6c63b083455c8e01c3d5ccd89afc_Out_2_Float);
            float _Property_5830ed7c65ef489e93de994fcb2769e2_Out_0_Float = _MetallicRemapMin;
            float _Property_3b33ae94b35943b5bbaa24c03b7069a8_Out_0_Float = _MetallicRemapMax;
            float2 _Vector2_0ad2d19d32894d5e83e19e69d72753fd_Out_0_Vector2 = float2(_Property_5830ed7c65ef489e93de994fcb2769e2_Out_0_Float, _Property_3b33ae94b35943b5bbaa24c03b7069a8_Out_0_Float);
            float _Remap_b3145e45987e489f9b15e9672b41a608_Out_3_Float;
            Unity_Remap_float(_SampleTexture2D_2dcb30935afc407482bb065c4150e563_R_4_Float, float2 (0, 1), _Vector2_0ad2d19d32894d5e83e19e69d72753fd_Out_0_Vector2, _Remap_b3145e45987e489f9b15e9672b41a608_Out_3_Float);
            float _Property_6427dba68c8342eebff5ce521921ddc5_Out_0_Float = _AORemapMin;
            float _Property_f74a95489f364e41b53a083f89ad2365_Out_0_Float = _AORemapMax;
            float2 _Vector2_a00f84e5347b414ca0e9496b9948ba0b_Out_0_Vector2 = float2(_Property_6427dba68c8342eebff5ce521921ddc5_Out_0_Float, _Property_f74a95489f364e41b53a083f89ad2365_Out_0_Float);
            float _Remap_75ea5a896ac148bb8058b60d79c90284_Out_3_Float;
            Unity_Remap_float(_SampleTexture2D_2dcb30935afc407482bb065c4150e563_G_5_Float, float2 (0, 1), _Vector2_a00f84e5347b414ca0e9496b9948ba0b_Out_0_Vector2, _Remap_75ea5a896ac148bb8058b60d79c90284_Out_3_Float);
            float _Property_9d6993415be843799b7ec2e689c5db02_Out_0_Float = _SmoothnessRemapMin;
            float _Property_df4aa91a4fe94e5f8768553f10cd1f82_Out_0_Float = _SmoothnessRemapMax;
            float2 _Vector2_d67e05a1240344f3978c1c9e3cb9525f_Out_0_Vector2 = float2(_Property_9d6993415be843799b7ec2e689c5db02_Out_0_Float, _Property_df4aa91a4fe94e5f8768553f10cd1f82_Out_0_Float);
            float _Remap_ad26abe467c44f5284db4b4203d8242b_Out_3_Float;
            Unity_Remap_float(_SampleTexture2D_2dcb30935afc407482bb065c4150e563_A_7_Float, float2 (0, 1), _Vector2_d67e05a1240344f3978c1c9e3cb9525f_Out_0_Vector2, _Remap_ad26abe467c44f5284db4b4203d8242b_Out_3_Float);
            float _Property_5c661f4099b14a5bac0c24977977340d_Out_0_Float = _MaskBlendSrc;
            float _Multiply_fc69b6805f38404cb402d2a6b2d2b73a_Out_2_Float;
            Unity_Multiply_float_float(_Split_da1fca62bd1b452a906195ffb7fa6a18_A_4_Float, _Property_5c661f4099b14a5bac0c24977977340d_Out_0_Float, _Multiply_fc69b6805f38404cb402d2a6b2d2b73a_Out_2_Float);
            float _Multiply_2f94ef00580f43caa2427a59ed8ca124_Out_2_Float;
            Unity_Multiply_float_float(_Property_5c661f4099b14a5bac0c24977977340d_Out_0_Float, _SampleTexture2D_2dcb30935afc407482bb065c4150e563_B_6_Float, _Multiply_2f94ef00580f43caa2427a59ed8ca124_Out_2_Float);
            float _Branch_753c02949c6b4f128d654534f2d64ced_Out_3_Float;
            Unity_Branch_float(_Property_e94639b7a37847e1a4616aeed6a21034_Out_0_Boolean, _Multiply_fc69b6805f38404cb402d2a6b2d2b73a_Out_2_Float, _Multiply_2f94ef00580f43caa2427a59ed8ca124_Out_2_Float, _Branch_753c02949c6b4f128d654534f2d64ced_Out_3_Float);
            float4 _Property_293317916e0e41cc98bbd5377294091b_Out_0_Vector4 = IsGammaSpace() ? LinearToSRGB(_EmissiveColor) : _EmissiveColor;
            UnityTexture2D _Property_fb3929b3be5f4269845ceb27fb377d12_Out_0_Texture2D = UnityBuildTexture2DStructNoScale(_EmissiveColorMap);
            float4 _SampleTexture2D_d4d6d2f60c614e4c8b681d89316209dc_RGBA_0_Vector4 = SAMPLE_TEXTURE2D(_Property_fb3929b3be5f4269845ceb27fb377d12_Out_0_Texture2D.tex, _Property_fb3929b3be5f4269845ceb27fb377d12_Out_0_Texture2D.samplerstate, _Property_fb3929b3be5f4269845ceb27fb377d12_Out_0_Texture2D.GetTransformedUV(IN.uv0.xy) );
            float _SampleTexture2D_d4d6d2f60c614e4c8b681d89316209dc_R_4_Float = _SampleTexture2D_d4d6d2f60c614e4c8b681d89316209dc_RGBA_0_Vector4.r;
            float _SampleTexture2D_d4d6d2f60c614e4c8b681d89316209dc_G_5_Float = _SampleTexture2D_d4d6d2f60c614e4c8b681d89316209dc_RGBA_0_Vector4.g;
            float _SampleTexture2D_d4d6d2f60c614e4c8b681d89316209dc_B_6_Float = _SampleTexture2D_d4d6d2f60c614e4c8b681d89316209dc_RGBA_0_Vector4.b;
            float _SampleTexture2D_d4d6d2f60c614e4c8b681d89316209dc_A_7_Float = _SampleTexture2D_d4d6d2f60c614e4c8b681d89316209dc_RGBA_0_Vector4.a;
            float4 _Multiply_2fa508cc2b6044e09e63453927d92375_Out_2_Vector4;
            Unity_Multiply_float4_float4(_Property_293317916e0e41cc98bbd5377294091b_Out_0_Vector4, _SampleTexture2D_d4d6d2f60c614e4c8b681d89316209dc_RGBA_0_Vector4, _Multiply_2fa508cc2b6044e09e63453927d92375_Out_2_Vector4);
            surface.BaseColor = (_Multiply_885586d42d884019a5375f12f3c61e52_Out_2_Vector4.xyz);
            surface.Alpha = _Clamp_4788840726ef4518b7a1fc8db3fcdd97_Out_3_Float;
            surface.NormalTS = (_SampleTexture2D_1300b7cb738f4b18927411750039acd2_RGBA_0_Vector4.xyz);
            surface.NormalAlpha = _Multiply_52cb6c63b083455c8e01c3d5ccd89afc_Out_2_Float;
            surface.Metallic = _Remap_b3145e45987e489f9b15e9672b41a608_Out_3_Float;
            surface.Occlusion = _Remap_75ea5a896ac148bb8058b60d79c90284_Out_3_Float;
            surface.Smoothness = _Remap_ad26abe467c44f5284db4b4203d8242b_Out_3_Float;
            surface.MAOSAlpha = _Branch_753c02949c6b4f128d654534f2d64ced_Out_3_Float;
            surface.Emission = (_Multiply_2fa508cc2b6044e09e63453927d92375_Out_2_Vector4.xyz);
            return surface;
        }
        
            // --------------------------------------------------
            // Build Graph Inputs
        
            
        //     $features.graphVertex:  $include("VertexAnimation.template.hlsl")
        //                                       ^ ERROR: $include cannot find file : VertexAnimation.template.hlsl. Looked into:
        // Packages/com.unity.shadergraph/Editor/Generation/Templates
        
            
        //     $features.graphPixel:   $include("SharedCode.template.hlsl")
        //                                       ^ ERROR: $include cannot find file : SharedCode.template.hlsl. Looked into:
        // Packages/com.unity.shadergraph/Editor/Generation/Templates
        
            SurfaceDescriptionInputs BuildSurfaceDescriptionInputs(Varyings input)
        {
            SurfaceDescriptionInputs output;
            ZERO_INITIALIZE(SurfaceDescriptionInputs, output);
        
            /* WARNING: $splice Could not find named fragment 'CustomInterpolatorCopyToSDI' */
        
        
        
            output.TangentSpaceNormal =                         float3(0.0f, 0.0f, 1.0f);
        
        
        
            #if UNITY_UV_STARTS_AT_TOP
            #else
            #endif
        
        
        
        #if defined(UNITY_UIE_INCLUDED)
            output.uv0 =                                        float4(input.texCoord0.x, input.texCoord0.y, 0, 0);
        #else
            output.uv0 =                                        input.texCoord0;
        #endif
            
        
            
            
        #if UNITY_ANY_INSTANCING_ENABLED
        #else // TODO: XR support for procedural instancing because in this case UNITY_ANY_INSTANCING_ENABLED is not defined and instanceID is incorrect.
        #endif
        #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
        #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN                output.FaceSign =                                   IS_FRONT_VFACE(input.cullFace, true, false);
        #else
        #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
        #endif
        #undef BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
        
            return output;
        }
        
            // --------------------------------------------------
            // Build Surface Data
        
            void GetSurfaceData(Varyings input, float4 positionCS, float angleFadeFactor, out DecalSurfaceData surfaceData)
            {
                #if (SHADERPASS == SHADERPASS_DBUFFER_PROJECTOR) || (SHADERPASS == SHADERPASS_FORWARD_EMISSIVE_PROJECTOR) || (SHADERPASS == SHADERPASS_DECAL_SCREEN_SPACE_PROJECTOR) || (SHADERPASS == SHADERPASS_DECAL_GBUFFER_PROJECTOR)
                    half4x4 normalToWorld = UNITY_ACCESS_INSTANCED_PROP(Decal, _NormalToWorld);
                    half fadeFactor = clamp(normalToWorld[0][3], 0.0f, 1.0f) * angleFadeFactor;
                    float2 scale = float2(normalToWorld[3][0], normalToWorld[3][1]);
                    float2 offset = float2(normalToWorld[3][2], normalToWorld[3][3]);
                    input.texCoord0.xy = input.texCoord0.xy * scale + offset;
                    half3 normalWS = TransformObjectToWorldDir(half3(0, 1, 0));
                    half3 tangentWS = TransformObjectToWorldDir(half3(1, 0, 0));
                    half3 bitangentWS = TransformObjectToWorldDir(half3(0, 0, 1));
                    half sign = dot(cross(normalWS, tangentWS), bitangentWS) > 0 ? 1 : -1;
                    input.normalWS.xyz = normalWS;
                #else
                    #if defined(LOD_FADE_CROSSFADE) && USE_UNITY_CROSSFADE
                        LODFadeCrossFade(positionCS);
                    #endif
        
                    half fadeFactor = half(1.0);
                #endif
        
                SurfaceDescriptionInputs surfaceDescriptionInputs = BuildSurfaceDescriptionInputs(input);
                SurfaceDescription surfaceDescription = SurfaceDescriptionFunction(surfaceDescriptionInputs);
        
                // setup defaults -- these are used if the graph doesn't output a value
                ZERO_INITIALIZE(DecalSurfaceData, surfaceData);
                surfaceData.occlusion = half(1.0);
                surfaceData.smoothness = half(0);
        
                #ifdef _MATERIAL_AFFECTS_NORMAL
                    surfaceData.normalWS.w = half(1.0);
                #else
                    surfaceData.normalWS.w = half(0.0);
                #endif
        
                surfaceData.emissive.rgb = half3(surfaceDescription.Emission.rgb * fadeFactor);
        
                // copy across graph values, if defined
                surfaceData.baseColor.xyz = half3(surfaceDescription.BaseColor);
                surfaceData.baseColor.w = half(surfaceDescription.Alpha * fadeFactor);
        
                #if (SHADERPASS == SHADERPASS_DBUFFER_PROJECTOR) || (SHADERPASS == SHADERPASS_DECAL_SCREEN_SPACE_PROJECTOR) || (SHADERPASS == SHADERPASS_DECAL_GBUFFER_PROJECTOR)
                    #if defined(_MATERIAL_AFFECTS_NORMAL)
                        surfaceData.normalWS.xyz = normalize(mul((half3x3)normalToWorld, surfaceDescription.NormalTS.xyz));
                    #else
                        surfaceData.normalWS.xyz = normalize(normalToWorld[2].xyz);
                    #endif
                #elif (SHADERPASS == SHADERPASS_DBUFFER_MESH) || (SHADERPASS == SHADERPASS_DECAL_SCREEN_SPACE_MESH) || (SHADERPASS == SHADERPASS_DECAL_GBUFFER_MESH)
                    #if defined(_MATERIAL_AFFECTS_NORMAL)
                        float sgn = input.tangentWS.w;      // should be either +1 or -1
                        float3 bitangent = sgn * cross(input.normalWS.xyz, input.tangentWS.xyz);
                        half3x3 tangentToWorld = half3x3(input.tangentWS.xyz, bitangent.xyz, input.normalWS.xyz);
        
                        // We need to normalize as we use mikkt tangent space and this is expected (tangent space is not normalize)
                        surfaceData.normalWS.xyz = normalize(TransformTangentToWorld(surfaceDescription.NormalTS, tangentToWorld));
                    #else
                        surfaceData.normalWS.xyz = normalize(half3(input.normalWS)); // Default to vertex normal
                    #endif
                #endif
        
                surfaceData.normalWS.w = surfaceDescription.NormalAlpha * fadeFactor;
        
                // In case of Smoothness / AO / Metal, all the three are always computed but color mask can change
                surfaceData.metallic = half(surfaceDescription.Metallic);
                surfaceData.occlusion = half(surfaceDescription.Occlusion);
                surfaceData.smoothness = half(surfaceDescription.Smoothness);
                surfaceData.MAOSAlpha = half(surfaceDescription.MAOSAlpha * fadeFactor);
            }
        
            // --------------------------------------------------
            // Main
        
            #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/Varyings.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShaderPassDecal.hlsl"
        
            ENDHLSL
        }
        Pass
        {
            Name "DBufferMesh"
            Tags
            {
                "LightMode" = "DBufferMesh"
            }
        
            // Render State
            Blend 0 SrcAlpha OneMinusSrcAlpha, Zero OneMinusSrcAlpha
        Blend 1 SrcAlpha OneMinusSrcAlpha, Zero OneMinusSrcAlpha
        Blend 2 SrcAlpha OneMinusSrcAlpha, Zero OneMinusSrcAlpha
        ZTest LEqual
        ZWrite Off
        ColorMask RGBA
        ColorMask RGBA 1
        ColorMask RGBA 2
        
            // Debug
            // <None>
        
            // --------------------------------------------------
            // Pass
        
            HLSLPROGRAM
        
            // Pragmas
            #pragma target 4.5
        #pragma exclude_renderers gles3 glcore
        #pragma vertex Vert
        #pragma fragment Frag
        #pragma multi_compile_instancing
        #pragma editor_sync_compilation
        
            // Keywords
            #pragma multi_compile_fragment _ _DBUFFER_MRT1 _DBUFFER_MRT2 _DBUFFER_MRT3
        #pragma multi_compile _ _DECAL_LAYERS
            // GraphKeywords: <None>
        
            #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Common.hlsl"
            #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Texture.hlsl"
            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
        
            // Defines
            #define ATTRIBUTES_NEED_NORMAL
            #define ATTRIBUTES_NEED_TANGENT
            #define ATTRIBUTES_NEED_TEXCOORD0
            #define ATTRIBUTES_NEED_TEXCOORD1
            #define ATTRIBUTES_NEED_TEXCOORD2
            #define VARYINGS_NEED_POSITION_WS
            #define VARYINGS_NEED_NORMAL_WS
            #define VARYINGS_NEED_TANGENT_WS
            #define VARYINGS_NEED_TEXCOORD0
        
            #define HAVE_MESH_MODIFICATION
        
        
            #define SHADERPASS SHADERPASS_DBUFFER_MESH
        #define _MATERIAL_AFFECTS_ALBEDO 1
        #define _MATERIAL_AFFECTS_NORMAL 1
        #define _MATERIAL_AFFECTS_NORMAL_BLEND 1
        #define _MATERIAL_AFFECTS_MAOS 1
        
            // Includes
            #include_with_pragmas "Packages/com.unity.render-pipelines.universal/ShaderLibrary/DOTS.hlsl"
        #include_with_pragmas "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Fog.hlsl"
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
        #include_with_pragmas "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ProbeVolumeVariants.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShaderPass.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/DecalInput.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShaderVariablesDecal.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/DBuffer.hlsl"
        
            // -- Properties used by ScenePickingPass
            #ifdef SCENEPICKINGPASS
            float4 _SelectionID;
            #endif
            #if _RENDER_PASS_ENABLED
            #define GBUFFER3 0
            FRAMEBUFFER_INPUT_X_FLOAT(GBUFFER3);
            #define GBUFFER4 1
            FRAMEBUFFER_INPUT_X_UINT(GBUFFER4);
            #endif
        
            // --------------------------------------------------
            // Structs and Packing
        
            struct Attributes
        {
             float3 positionOS : POSITION;
             float3 normalOS : NORMAL;
             float4 tangentOS : TANGENT;
             float4 uv0 : TEXCOORD0;
             float4 uv1 : TEXCOORD1;
             float4 uv2 : TEXCOORD2;
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
             float3 TangentSpaceNormal;
             float4 uv0;
        };
        struct VertexDescriptionInputs
        {
        };
        struct PackedVaryings
        {
             float4 positionCS : SV_POSITION;
             float4 tangentWS : INTERP0;
             float4 texCoord0 : INTERP1;
             float3 positionWS : INTERP2;
             float3 normalWS : INTERP3;
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
        float _Alpha_Multiply;
        float _Alpha_Power;
        float4 _BaseColorMap_TexelSize;
        float4 _NormalMap_TexelSize;
        float Normal_Blend;
        float4 _BaseColor;
        float4 _MaskMap_TexelSize;
        float _MetallicRemapMax;
        float _MetallicRemapMin;
        float _AORemapMin;
        float _AORemapMax;
        float _SmoothnessRemapMin;
        float _SmoothnessRemapMax;
        float _MaskBlendSrc;
        float4 _EmissiveColor;
        float4 _EmissiveColorMap_TexelSize;
        float _Alpha_Use_T_Base_Color_A_F_Maskmap_B;
        float _MaskMap_Alpha_Use_T_Base_Color_A_F_Maskmap_B;
        float _DrawOrder;
        float _DecalMeshBiasType;
        float _DecalMeshDepthBias;
        float _DecalMeshViewBias;
        float _DecalAngleFadeSupported;
        UNITY_TEXTURE_STREAMING_DEBUG_VARS;
        CBUFFER_END
        
        
        // Object and Global properties
        SAMPLER(SamplerState_Linear_Repeat);
        TEXTURE2D(_BaseColorMap);
        SAMPLER(sampler_BaseColorMap);
        TEXTURE2D(_NormalMap);
        SAMPLER(sampler_NormalMap);
        TEXTURE2D(_MaskMap);
        SAMPLER(sampler_MaskMap);
        TEXTURE2D(_EmissiveColorMap);
        SAMPLER(sampler_EmissiveColorMap);
        
            // Graph Includes
            // GraphIncludes: <None>
        
            // Graph Functions
            
        void Unity_Multiply_float4_float4(float4 A, float4 B, out float4 Out)
        {
            Out = A * B;
        }
        
        void Unity_Branch_float(float Predicate, float True, float False, out float Out)
        {
            Out = Predicate ? True : False;
        }
        
        void Unity_Multiply_float_float(float A, float B, out float Out)
        {
            Out = A * B;
        }
        
        void Unity_Absolute_float(float In, out float Out)
        {
            Out = abs(In);
        }
        
        void Unity_Power_float(float A, float B, out float Out)
        {
            Out = pow(A, B);
        }
        
        void Unity_Clamp_float(float In, float Min, float Max, out float Out)
        {
            Out = clamp(In, Min, Max);
        }
        
        void Unity_Remap_float(float In, float2 InMinMax, float2 OutMinMax, out float Out)
        {
            Out = OutMinMax.x + (In - InMinMax.x) * (OutMinMax.y - OutMinMax.x) / (InMinMax.y - InMinMax.x);
        }
        
            // Graph Vertex
            struct VertexDescription
        {
        };
        
        VertexDescription VertexDescriptionFunction(VertexDescriptionInputs IN)
        {
            VertexDescription description = (VertexDescription)0;
            return description;
        }
        
            // Graph Pixel
            struct SurfaceDescription
        {
            float3 BaseColor;
            float Alpha;
            float3 NormalTS;
            float NormalAlpha;
            float Metallic;
            float Occlusion;
            float Smoothness;
            float MAOSAlpha;
        };
        
        SurfaceDescription SurfaceDescriptionFunction(SurfaceDescriptionInputs IN)
        {
            SurfaceDescription surface = (SurfaceDescription)0;
            float4 _Property_320fefd883db46679cd769f61b130dd7_Out_0_Vector4 = _BaseColor;
            UnityTexture2D _Property_9f1059a7a93a46ccab349515214f3ed2_Out_0_Texture2D = UnityBuildTexture2DStructNoScale(_BaseColorMap);
            float4 _SampleTexture2D_7388a7ddbf6648ec92c3bb54ed055048_RGBA_0_Vector4 = SAMPLE_TEXTURE2D(_Property_9f1059a7a93a46ccab349515214f3ed2_Out_0_Texture2D.tex, _Property_9f1059a7a93a46ccab349515214f3ed2_Out_0_Texture2D.samplerstate, _Property_9f1059a7a93a46ccab349515214f3ed2_Out_0_Texture2D.GetTransformedUV(IN.uv0.xy) );
            float _SampleTexture2D_7388a7ddbf6648ec92c3bb54ed055048_R_4_Float = _SampleTexture2D_7388a7ddbf6648ec92c3bb54ed055048_RGBA_0_Vector4.r;
            float _SampleTexture2D_7388a7ddbf6648ec92c3bb54ed055048_G_5_Float = _SampleTexture2D_7388a7ddbf6648ec92c3bb54ed055048_RGBA_0_Vector4.g;
            float _SampleTexture2D_7388a7ddbf6648ec92c3bb54ed055048_B_6_Float = _SampleTexture2D_7388a7ddbf6648ec92c3bb54ed055048_RGBA_0_Vector4.b;
            float _SampleTexture2D_7388a7ddbf6648ec92c3bb54ed055048_A_7_Float = _SampleTexture2D_7388a7ddbf6648ec92c3bb54ed055048_RGBA_0_Vector4.a;
            float4 _Multiply_885586d42d884019a5375f12f3c61e52_Out_2_Vector4;
            Unity_Multiply_float4_float4(_Property_320fefd883db46679cd769f61b130dd7_Out_0_Vector4, _SampleTexture2D_7388a7ddbf6648ec92c3bb54ed055048_RGBA_0_Vector4, _Multiply_885586d42d884019a5375f12f3c61e52_Out_2_Vector4);
            float _Property_10cb48b77e114c99a77554a14a36ed9a_Out_0_Float = _Alpha_Multiply;
            float _Property_97f64a9c7748494dbf6dc5b32920f5a5_Out_0_Boolean = _Alpha_Use_T_Base_Color_A_F_Maskmap_B;
            float _Split_da1fca62bd1b452a906195ffb7fa6a18_R_1_Float = _Multiply_885586d42d884019a5375f12f3c61e52_Out_2_Vector4[0];
            float _Split_da1fca62bd1b452a906195ffb7fa6a18_G_2_Float = _Multiply_885586d42d884019a5375f12f3c61e52_Out_2_Vector4[1];
            float _Split_da1fca62bd1b452a906195ffb7fa6a18_B_3_Float = _Multiply_885586d42d884019a5375f12f3c61e52_Out_2_Vector4[2];
            float _Split_da1fca62bd1b452a906195ffb7fa6a18_A_4_Float = _Multiply_885586d42d884019a5375f12f3c61e52_Out_2_Vector4[3];
            UnityTexture2D _Property_b46891aff98b4364a190337410150f10_Out_0_Texture2D = UnityBuildTexture2DStructNoScale(_MaskMap);
            float4 _SampleTexture2D_2dcb30935afc407482bb065c4150e563_RGBA_0_Vector4 = SAMPLE_TEXTURE2D(_Property_b46891aff98b4364a190337410150f10_Out_0_Texture2D.tex, _Property_b46891aff98b4364a190337410150f10_Out_0_Texture2D.samplerstate, _Property_b46891aff98b4364a190337410150f10_Out_0_Texture2D.GetTransformedUV(IN.uv0.xy) );
            float _SampleTexture2D_2dcb30935afc407482bb065c4150e563_R_4_Float = _SampleTexture2D_2dcb30935afc407482bb065c4150e563_RGBA_0_Vector4.r;
            float _SampleTexture2D_2dcb30935afc407482bb065c4150e563_G_5_Float = _SampleTexture2D_2dcb30935afc407482bb065c4150e563_RGBA_0_Vector4.g;
            float _SampleTexture2D_2dcb30935afc407482bb065c4150e563_B_6_Float = _SampleTexture2D_2dcb30935afc407482bb065c4150e563_RGBA_0_Vector4.b;
            float _SampleTexture2D_2dcb30935afc407482bb065c4150e563_A_7_Float = _SampleTexture2D_2dcb30935afc407482bb065c4150e563_RGBA_0_Vector4.a;
            float _Branch_eb932f0ef97d49398f01d62d896b2b60_Out_3_Float;
            Unity_Branch_float(_Property_97f64a9c7748494dbf6dc5b32920f5a5_Out_0_Boolean, _Split_da1fca62bd1b452a906195ffb7fa6a18_A_4_Float, _SampleTexture2D_2dcb30935afc407482bb065c4150e563_B_6_Float, _Branch_eb932f0ef97d49398f01d62d896b2b60_Out_3_Float);
            float _Multiply_3c4f7578756f4e789ded2b826c933b6d_Out_2_Float;
            Unity_Multiply_float_float(_Property_10cb48b77e114c99a77554a14a36ed9a_Out_0_Float, _Branch_eb932f0ef97d49398f01d62d896b2b60_Out_3_Float, _Multiply_3c4f7578756f4e789ded2b826c933b6d_Out_2_Float);
            float _Absolute_cc8840692870447e8bc057dbbf5f18c1_Out_1_Float;
            Unity_Absolute_float(_Multiply_3c4f7578756f4e789ded2b826c933b6d_Out_2_Float, _Absolute_cc8840692870447e8bc057dbbf5f18c1_Out_1_Float);
            float _Property_472619a20fe14990a52e2bbe0c00ea22_Out_0_Float = _Alpha_Power;
            float _Power_55566f012c2d4585bb257e256506056c_Out_2_Float;
            Unity_Power_float(_Absolute_cc8840692870447e8bc057dbbf5f18c1_Out_1_Float, _Property_472619a20fe14990a52e2bbe0c00ea22_Out_0_Float, _Power_55566f012c2d4585bb257e256506056c_Out_2_Float);
            float _Clamp_4788840726ef4518b7a1fc8db3fcdd97_Out_3_Float;
            Unity_Clamp_float(_Power_55566f012c2d4585bb257e256506056c_Out_2_Float, float(0), float(1), _Clamp_4788840726ef4518b7a1fc8db3fcdd97_Out_3_Float);
            UnityTexture2D _Property_360e6833e8d64d75827ab98987b2b545_Out_0_Texture2D = UnityBuildTexture2DStructNoScale(_NormalMap);
            float4 _SampleTexture2D_1300b7cb738f4b18927411750039acd2_RGBA_0_Vector4 = SAMPLE_TEXTURE2D(_Property_360e6833e8d64d75827ab98987b2b545_Out_0_Texture2D.tex, _Property_360e6833e8d64d75827ab98987b2b545_Out_0_Texture2D.samplerstate, _Property_360e6833e8d64d75827ab98987b2b545_Out_0_Texture2D.GetTransformedUV(IN.uv0.xy) );
            _SampleTexture2D_1300b7cb738f4b18927411750039acd2_RGBA_0_Vector4.rgb = UnpackNormal(_SampleTexture2D_1300b7cb738f4b18927411750039acd2_RGBA_0_Vector4);
            float _SampleTexture2D_1300b7cb738f4b18927411750039acd2_R_4_Float = _SampleTexture2D_1300b7cb738f4b18927411750039acd2_RGBA_0_Vector4.r;
            float _SampleTexture2D_1300b7cb738f4b18927411750039acd2_G_5_Float = _SampleTexture2D_1300b7cb738f4b18927411750039acd2_RGBA_0_Vector4.g;
            float _SampleTexture2D_1300b7cb738f4b18927411750039acd2_B_6_Float = _SampleTexture2D_1300b7cb738f4b18927411750039acd2_RGBA_0_Vector4.b;
            float _SampleTexture2D_1300b7cb738f4b18927411750039acd2_A_7_Float = _SampleTexture2D_1300b7cb738f4b18927411750039acd2_RGBA_0_Vector4.a;
            float _Property_e94639b7a37847e1a4616aeed6a21034_Out_0_Boolean = _MaskMap_Alpha_Use_T_Base_Color_A_F_Maskmap_B;
            float _Branch_39df5838709544d2951602a5ba721694_Out_3_Float;
            Unity_Branch_float(_Property_e94639b7a37847e1a4616aeed6a21034_Out_0_Boolean, _Split_da1fca62bd1b452a906195ffb7fa6a18_A_4_Float, _SampleTexture2D_2dcb30935afc407482bb065c4150e563_B_6_Float, _Branch_39df5838709544d2951602a5ba721694_Out_3_Float);
            float _Property_1ed131c6c6bd4d3b9225106c761ab06c_Out_0_Float = Normal_Blend;
            float _Multiply_52cb6c63b083455c8e01c3d5ccd89afc_Out_2_Float;
            Unity_Multiply_float_float(_Branch_39df5838709544d2951602a5ba721694_Out_3_Float, _Property_1ed131c6c6bd4d3b9225106c761ab06c_Out_0_Float, _Multiply_52cb6c63b083455c8e01c3d5ccd89afc_Out_2_Float);
            float _Property_5830ed7c65ef489e93de994fcb2769e2_Out_0_Float = _MetallicRemapMin;
            float _Property_3b33ae94b35943b5bbaa24c03b7069a8_Out_0_Float = _MetallicRemapMax;
            float2 _Vector2_0ad2d19d32894d5e83e19e69d72753fd_Out_0_Vector2 = float2(_Property_5830ed7c65ef489e93de994fcb2769e2_Out_0_Float, _Property_3b33ae94b35943b5bbaa24c03b7069a8_Out_0_Float);
            float _Remap_b3145e45987e489f9b15e9672b41a608_Out_3_Float;
            Unity_Remap_float(_SampleTexture2D_2dcb30935afc407482bb065c4150e563_R_4_Float, float2 (0, 1), _Vector2_0ad2d19d32894d5e83e19e69d72753fd_Out_0_Vector2, _Remap_b3145e45987e489f9b15e9672b41a608_Out_3_Float);
            float _Property_6427dba68c8342eebff5ce521921ddc5_Out_0_Float = _AORemapMin;
            float _Property_f74a95489f364e41b53a083f89ad2365_Out_0_Float = _AORemapMax;
            float2 _Vector2_a00f84e5347b414ca0e9496b9948ba0b_Out_0_Vector2 = float2(_Property_6427dba68c8342eebff5ce521921ddc5_Out_0_Float, _Property_f74a95489f364e41b53a083f89ad2365_Out_0_Float);
            float _Remap_75ea5a896ac148bb8058b60d79c90284_Out_3_Float;
            Unity_Remap_float(_SampleTexture2D_2dcb30935afc407482bb065c4150e563_G_5_Float, float2 (0, 1), _Vector2_a00f84e5347b414ca0e9496b9948ba0b_Out_0_Vector2, _Remap_75ea5a896ac148bb8058b60d79c90284_Out_3_Float);
            float _Property_9d6993415be843799b7ec2e689c5db02_Out_0_Float = _SmoothnessRemapMin;
            float _Property_df4aa91a4fe94e5f8768553f10cd1f82_Out_0_Float = _SmoothnessRemapMax;
            float2 _Vector2_d67e05a1240344f3978c1c9e3cb9525f_Out_0_Vector2 = float2(_Property_9d6993415be843799b7ec2e689c5db02_Out_0_Float, _Property_df4aa91a4fe94e5f8768553f10cd1f82_Out_0_Float);
            float _Remap_ad26abe467c44f5284db4b4203d8242b_Out_3_Float;
            Unity_Remap_float(_SampleTexture2D_2dcb30935afc407482bb065c4150e563_A_7_Float, float2 (0, 1), _Vector2_d67e05a1240344f3978c1c9e3cb9525f_Out_0_Vector2, _Remap_ad26abe467c44f5284db4b4203d8242b_Out_3_Float);
            float _Property_5c661f4099b14a5bac0c24977977340d_Out_0_Float = _MaskBlendSrc;
            float _Multiply_fc69b6805f38404cb402d2a6b2d2b73a_Out_2_Float;
            Unity_Multiply_float_float(_Split_da1fca62bd1b452a906195ffb7fa6a18_A_4_Float, _Property_5c661f4099b14a5bac0c24977977340d_Out_0_Float, _Multiply_fc69b6805f38404cb402d2a6b2d2b73a_Out_2_Float);
            float _Multiply_2f94ef00580f43caa2427a59ed8ca124_Out_2_Float;
            Unity_Multiply_float_float(_Property_5c661f4099b14a5bac0c24977977340d_Out_0_Float, _SampleTexture2D_2dcb30935afc407482bb065c4150e563_B_6_Float, _Multiply_2f94ef00580f43caa2427a59ed8ca124_Out_2_Float);
            float _Branch_753c02949c6b4f128d654534f2d64ced_Out_3_Float;
            Unity_Branch_float(_Property_e94639b7a37847e1a4616aeed6a21034_Out_0_Boolean, _Multiply_fc69b6805f38404cb402d2a6b2d2b73a_Out_2_Float, _Multiply_2f94ef00580f43caa2427a59ed8ca124_Out_2_Float, _Branch_753c02949c6b4f128d654534f2d64ced_Out_3_Float);
            surface.BaseColor = (_Multiply_885586d42d884019a5375f12f3c61e52_Out_2_Vector4.xyz);
            surface.Alpha = _Clamp_4788840726ef4518b7a1fc8db3fcdd97_Out_3_Float;
            surface.NormalTS = (_SampleTexture2D_1300b7cb738f4b18927411750039acd2_RGBA_0_Vector4.xyz);
            surface.NormalAlpha = _Multiply_52cb6c63b083455c8e01c3d5ccd89afc_Out_2_Float;
            surface.Metallic = _Remap_b3145e45987e489f9b15e9672b41a608_Out_3_Float;
            surface.Occlusion = _Remap_75ea5a896ac148bb8058b60d79c90284_Out_3_Float;
            surface.Smoothness = _Remap_ad26abe467c44f5284db4b4203d8242b_Out_3_Float;
            surface.MAOSAlpha = _Branch_753c02949c6b4f128d654534f2d64ced_Out_3_Float;
            return surface;
        }
        
            // --------------------------------------------------
            // Build Graph Inputs
        
            
        //     $features.graphVertex:  $include("VertexAnimation.template.hlsl")
        //                                       ^ ERROR: $include cannot find file : VertexAnimation.template.hlsl. Looked into:
        // Packages/com.unity.shadergraph/Editor/Generation/Templates
        
            
        //     $features.graphPixel:   $include("SharedCode.template.hlsl")
        //                                       ^ ERROR: $include cannot find file : SharedCode.template.hlsl. Looked into:
        // Packages/com.unity.shadergraph/Editor/Generation/Templates
        
            SurfaceDescriptionInputs BuildSurfaceDescriptionInputs(Varyings input)
        {
            SurfaceDescriptionInputs output;
            ZERO_INITIALIZE(SurfaceDescriptionInputs, output);
        
            /* WARNING: $splice Could not find named fragment 'CustomInterpolatorCopyToSDI' */
        
        
        
            output.TangentSpaceNormal =                         float3(0.0f, 0.0f, 1.0f);
        
        
        
            #if UNITY_UV_STARTS_AT_TOP
            #else
            #endif
        
        
        
        #if defined(UNITY_UIE_INCLUDED)
            output.uv0 =                                        float4(input.texCoord0.x, input.texCoord0.y, 0, 0);
        #else
            output.uv0 =                                        input.texCoord0;
        #endif
            
        
            
            
        #if UNITY_ANY_INSTANCING_ENABLED
        #else // TODO: XR support for procedural instancing because in this case UNITY_ANY_INSTANCING_ENABLED is not defined and instanceID is incorrect.
        #endif
        #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
        #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN                output.FaceSign =                                   IS_FRONT_VFACE(input.cullFace, true, false);
        #else
        #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
        #endif
        #undef BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
        
            return output;
        }
        
            // --------------------------------------------------
            // Build Surface Data
        
            void GetSurfaceData(Varyings input, float4 positionCS, float angleFadeFactor, out DecalSurfaceData surfaceData)
            {
                #if (SHADERPASS == SHADERPASS_DBUFFER_PROJECTOR) || (SHADERPASS == SHADERPASS_FORWARD_EMISSIVE_PROJECTOR) || (SHADERPASS == SHADERPASS_DECAL_SCREEN_SPACE_PROJECTOR) || (SHADERPASS == SHADERPASS_DECAL_GBUFFER_PROJECTOR)
                    half4x4 normalToWorld = UNITY_ACCESS_INSTANCED_PROP(Decal, _NormalToWorld);
                    half fadeFactor = clamp(normalToWorld[0][3], 0.0f, 1.0f) * angleFadeFactor;
                    float2 scale = float2(normalToWorld[3][0], normalToWorld[3][1]);
                    float2 offset = float2(normalToWorld[3][2], normalToWorld[3][3]);
                    input.texCoord0.xy = input.texCoord0.xy * scale + offset;
                    half3 normalWS = TransformObjectToWorldDir(half3(0, 1, 0));
                    half3 tangentWS = TransformObjectToWorldDir(half3(1, 0, 0));
                    half3 bitangentWS = TransformObjectToWorldDir(half3(0, 0, 1));
                    half sign = dot(cross(normalWS, tangentWS), bitangentWS) > 0 ? 1 : -1;
                    input.normalWS.xyz = normalWS;
                    input.tangentWS.xyzw = half4(tangentWS, sign);
                #else
                    #if defined(LOD_FADE_CROSSFADE) && USE_UNITY_CROSSFADE
                        LODFadeCrossFade(positionCS);
                    #endif
        
                    half fadeFactor = half(1.0);
                #endif
        
                SurfaceDescriptionInputs surfaceDescriptionInputs = BuildSurfaceDescriptionInputs(input);
                SurfaceDescription surfaceDescription = SurfaceDescriptionFunction(surfaceDescriptionInputs);
        
                // setup defaults -- these are used if the graph doesn't output a value
                ZERO_INITIALIZE(DecalSurfaceData, surfaceData);
                surfaceData.occlusion = half(1.0);
                surfaceData.smoothness = half(0);
        
                #ifdef _MATERIAL_AFFECTS_NORMAL
                    surfaceData.normalWS.w = half(1.0);
                #else
                    surfaceData.normalWS.w = half(0.0);
                #endif
        
        
                // copy across graph values, if defined
                surfaceData.baseColor.xyz = half3(surfaceDescription.BaseColor);
                surfaceData.baseColor.w = half(surfaceDescription.Alpha * fadeFactor);
        
                #if (SHADERPASS == SHADERPASS_DBUFFER_PROJECTOR) || (SHADERPASS == SHADERPASS_DECAL_SCREEN_SPACE_PROJECTOR) || (SHADERPASS == SHADERPASS_DECAL_GBUFFER_PROJECTOR)
                    #if defined(_MATERIAL_AFFECTS_NORMAL)
                        surfaceData.normalWS.xyz = normalize(mul((half3x3)normalToWorld, surfaceDescription.NormalTS.xyz));
                    #else
                        surfaceData.normalWS.xyz = normalize(normalToWorld[2].xyz);
                    #endif
                #elif (SHADERPASS == SHADERPASS_DBUFFER_MESH) || (SHADERPASS == SHADERPASS_DECAL_SCREEN_SPACE_MESH) || (SHADERPASS == SHADERPASS_DECAL_GBUFFER_MESH)
                    #if defined(_MATERIAL_AFFECTS_NORMAL)
                        float sgn = input.tangentWS.w;      // should be either +1 or -1
                        float3 bitangent = sgn * cross(input.normalWS.xyz, input.tangentWS.xyz);
                        half3x3 tangentToWorld = half3x3(input.tangentWS.xyz, bitangent.xyz, input.normalWS.xyz);
        
                        // We need to normalize as we use mikkt tangent space and this is expected (tangent space is not normalize)
                        surfaceData.normalWS.xyz = normalize(TransformTangentToWorld(surfaceDescription.NormalTS, tangentToWorld));
                    #else
                        surfaceData.normalWS.xyz = normalize(half3(input.normalWS)); // Default to vertex normal
                    #endif
                #endif
        
                surfaceData.normalWS.w = surfaceDescription.NormalAlpha * fadeFactor;
        
                // In case of Smoothness / AO / Metal, all the three are always computed but color mask can change
                surfaceData.metallic = half(surfaceDescription.Metallic);
                surfaceData.occlusion = half(surfaceDescription.Occlusion);
                surfaceData.smoothness = half(surfaceDescription.Smoothness);
                surfaceData.MAOSAlpha = half(surfaceDescription.MAOSAlpha * fadeFactor);
            }
        
            // --------------------------------------------------
            // Main
        
            #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/Varyings.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShaderPassDecal.hlsl"
        
            ENDHLSL
        }
        Pass
        {
            Name "DecalMeshForwardEmissive"
            Tags
            {
                "LightMode" = "DecalMeshForwardEmissive"
            }
        
            // Render State
            Blend 0 SrcAlpha One
        ZTest LEqual
        ZWrite Off
        
            // Debug
            // <None>
        
            // --------------------------------------------------
            // Pass
        
            HLSLPROGRAM
        
            // Pragmas
            #pragma target 4.5
        #pragma exclude_renderers gles3 glcore
        #pragma vertex Vert
        #pragma fragment Frag
        #pragma multi_compile_instancing
        #pragma editor_sync_compilation
        
            // Keywords
            #pragma multi_compile _ _DECAL_LAYERS
            // GraphKeywords: <None>
        
            #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Common.hlsl"
            #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Texture.hlsl"
            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
        
            // Defines
            #define ATTRIBUTES_NEED_NORMAL
            #define ATTRIBUTES_NEED_TANGENT
            #define ATTRIBUTES_NEED_TEXCOORD0
            #define ATTRIBUTES_NEED_TEXCOORD1
            #define ATTRIBUTES_NEED_TEXCOORD2
            #define VARYINGS_NEED_POSITION_WS
            #define VARYINGS_NEED_NORMAL_WS
            #define VARYINGS_NEED_TANGENT_WS
            #define VARYINGS_NEED_TEXCOORD0
        
            #define HAVE_MESH_MODIFICATION
        
        
            #define SHADERPASS SHADERPASS_FORWARD_EMISSIVE_MESH
        #define _MATERIAL_AFFECTS_ALBEDO 1
        #define _MATERIAL_AFFECTS_NORMAL 1
        #define _MATERIAL_AFFECTS_NORMAL_BLEND 1
        #define _MATERIAL_AFFECTS_MAOS 1
        #define _MATERIAL_AFFECTS_EMISSION 1
        
            // Includes
            #include_with_pragmas "Packages/com.unity.render-pipelines.universal/ShaderLibrary/DOTS.hlsl"
        #include_with_pragmas "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Fog.hlsl"
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
        #include_with_pragmas "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ProbeVolumeVariants.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShaderPass.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/DecalInput.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShaderVariablesDecal.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/DBuffer.hlsl"
        
            // -- Properties used by ScenePickingPass
            #ifdef SCENEPICKINGPASS
            float4 _SelectionID;
            #endif
            #if _RENDER_PASS_ENABLED
            #define GBUFFER3 0
            FRAMEBUFFER_INPUT_X_FLOAT(GBUFFER3);
            #define GBUFFER4 1
            FRAMEBUFFER_INPUT_X_UINT(GBUFFER4);
            #endif
        
            // --------------------------------------------------
            // Structs and Packing
        
            struct Attributes
        {
             float3 positionOS : POSITION;
             float3 normalOS : NORMAL;
             float4 tangentOS : TANGENT;
             float4 uv0 : TEXCOORD0;
             float4 uv1 : TEXCOORD1;
             float4 uv2 : TEXCOORD2;
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
             float3 TangentSpaceNormal;
             float4 uv0;
        };
        struct VertexDescriptionInputs
        {
        };
        struct PackedVaryings
        {
             float4 positionCS : SV_POSITION;
             float4 tangentWS : INTERP0;
             float4 texCoord0 : INTERP1;
             float3 positionWS : INTERP2;
             float3 normalWS : INTERP3;
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
        float _Alpha_Multiply;
        float _Alpha_Power;
        float4 _BaseColorMap_TexelSize;
        float4 _NormalMap_TexelSize;
        float Normal_Blend;
        float4 _BaseColor;
        float4 _MaskMap_TexelSize;
        float _MetallicRemapMax;
        float _MetallicRemapMin;
        float _AORemapMin;
        float _AORemapMax;
        float _SmoothnessRemapMin;
        float _SmoothnessRemapMax;
        float _MaskBlendSrc;
        float4 _EmissiveColor;
        float4 _EmissiveColorMap_TexelSize;
        float _Alpha_Use_T_Base_Color_A_F_Maskmap_B;
        float _MaskMap_Alpha_Use_T_Base_Color_A_F_Maskmap_B;
        float _DrawOrder;
        float _DecalMeshBiasType;
        float _DecalMeshDepthBias;
        float _DecalMeshViewBias;
        float _DecalAngleFadeSupported;
        UNITY_TEXTURE_STREAMING_DEBUG_VARS;
        CBUFFER_END
        
        
        // Object and Global properties
        SAMPLER(SamplerState_Linear_Repeat);
        TEXTURE2D(_BaseColorMap);
        SAMPLER(sampler_BaseColorMap);
        TEXTURE2D(_NormalMap);
        SAMPLER(sampler_NormalMap);
        TEXTURE2D(_MaskMap);
        SAMPLER(sampler_MaskMap);
        TEXTURE2D(_EmissiveColorMap);
        SAMPLER(sampler_EmissiveColorMap);
        
            // Graph Includes
            // GraphIncludes: <None>
        
            // Graph Functions
            
        void Unity_Multiply_float4_float4(float4 A, float4 B, out float4 Out)
        {
            Out = A * B;
        }
        
        void Unity_Branch_float(float Predicate, float True, float False, out float Out)
        {
            Out = Predicate ? True : False;
        }
        
        void Unity_Multiply_float_float(float A, float B, out float Out)
        {
            Out = A * B;
        }
        
        void Unity_Absolute_float(float In, out float Out)
        {
            Out = abs(In);
        }
        
        void Unity_Power_float(float A, float B, out float Out)
        {
            Out = pow(A, B);
        }
        
        void Unity_Clamp_float(float In, float Min, float Max, out float Out)
        {
            Out = clamp(In, Min, Max);
        }
        
        void Unity_Remap_float(float In, float2 InMinMax, float2 OutMinMax, out float Out)
        {
            Out = OutMinMax.x + (In - InMinMax.x) * (OutMinMax.y - OutMinMax.x) / (InMinMax.y - InMinMax.x);
        }
        
            // Graph Vertex
            struct VertexDescription
        {
        };
        
        VertexDescription VertexDescriptionFunction(VertexDescriptionInputs IN)
        {
            VertexDescription description = (VertexDescription)0;
            return description;
        }
        
            // Graph Pixel
            struct SurfaceDescription
        {
            float3 BaseColor;
            float Alpha;
            float3 NormalTS;
            float NormalAlpha;
            float Metallic;
            float Occlusion;
            float Smoothness;
            float MAOSAlpha;
            float3 Emission;
        };
        
        SurfaceDescription SurfaceDescriptionFunction(SurfaceDescriptionInputs IN)
        {
            SurfaceDescription surface = (SurfaceDescription)0;
            float4 _Property_320fefd883db46679cd769f61b130dd7_Out_0_Vector4 = _BaseColor;
            UnityTexture2D _Property_9f1059a7a93a46ccab349515214f3ed2_Out_0_Texture2D = UnityBuildTexture2DStructNoScale(_BaseColorMap);
            float4 _SampleTexture2D_7388a7ddbf6648ec92c3bb54ed055048_RGBA_0_Vector4 = SAMPLE_TEXTURE2D(_Property_9f1059a7a93a46ccab349515214f3ed2_Out_0_Texture2D.tex, _Property_9f1059a7a93a46ccab349515214f3ed2_Out_0_Texture2D.samplerstate, _Property_9f1059a7a93a46ccab349515214f3ed2_Out_0_Texture2D.GetTransformedUV(IN.uv0.xy) );
            float _SampleTexture2D_7388a7ddbf6648ec92c3bb54ed055048_R_4_Float = _SampleTexture2D_7388a7ddbf6648ec92c3bb54ed055048_RGBA_0_Vector4.r;
            float _SampleTexture2D_7388a7ddbf6648ec92c3bb54ed055048_G_5_Float = _SampleTexture2D_7388a7ddbf6648ec92c3bb54ed055048_RGBA_0_Vector4.g;
            float _SampleTexture2D_7388a7ddbf6648ec92c3bb54ed055048_B_6_Float = _SampleTexture2D_7388a7ddbf6648ec92c3bb54ed055048_RGBA_0_Vector4.b;
            float _SampleTexture2D_7388a7ddbf6648ec92c3bb54ed055048_A_7_Float = _SampleTexture2D_7388a7ddbf6648ec92c3bb54ed055048_RGBA_0_Vector4.a;
            float4 _Multiply_885586d42d884019a5375f12f3c61e52_Out_2_Vector4;
            Unity_Multiply_float4_float4(_Property_320fefd883db46679cd769f61b130dd7_Out_0_Vector4, _SampleTexture2D_7388a7ddbf6648ec92c3bb54ed055048_RGBA_0_Vector4, _Multiply_885586d42d884019a5375f12f3c61e52_Out_2_Vector4);
            float _Property_10cb48b77e114c99a77554a14a36ed9a_Out_0_Float = _Alpha_Multiply;
            float _Property_97f64a9c7748494dbf6dc5b32920f5a5_Out_0_Boolean = _Alpha_Use_T_Base_Color_A_F_Maskmap_B;
            float _Split_da1fca62bd1b452a906195ffb7fa6a18_R_1_Float = _Multiply_885586d42d884019a5375f12f3c61e52_Out_2_Vector4[0];
            float _Split_da1fca62bd1b452a906195ffb7fa6a18_G_2_Float = _Multiply_885586d42d884019a5375f12f3c61e52_Out_2_Vector4[1];
            float _Split_da1fca62bd1b452a906195ffb7fa6a18_B_3_Float = _Multiply_885586d42d884019a5375f12f3c61e52_Out_2_Vector4[2];
            float _Split_da1fca62bd1b452a906195ffb7fa6a18_A_4_Float = _Multiply_885586d42d884019a5375f12f3c61e52_Out_2_Vector4[3];
            UnityTexture2D _Property_b46891aff98b4364a190337410150f10_Out_0_Texture2D = UnityBuildTexture2DStructNoScale(_MaskMap);
            float4 _SampleTexture2D_2dcb30935afc407482bb065c4150e563_RGBA_0_Vector4 = SAMPLE_TEXTURE2D(_Property_b46891aff98b4364a190337410150f10_Out_0_Texture2D.tex, _Property_b46891aff98b4364a190337410150f10_Out_0_Texture2D.samplerstate, _Property_b46891aff98b4364a190337410150f10_Out_0_Texture2D.GetTransformedUV(IN.uv0.xy) );
            float _SampleTexture2D_2dcb30935afc407482bb065c4150e563_R_4_Float = _SampleTexture2D_2dcb30935afc407482bb065c4150e563_RGBA_0_Vector4.r;
            float _SampleTexture2D_2dcb30935afc407482bb065c4150e563_G_5_Float = _SampleTexture2D_2dcb30935afc407482bb065c4150e563_RGBA_0_Vector4.g;
            float _SampleTexture2D_2dcb30935afc407482bb065c4150e563_B_6_Float = _SampleTexture2D_2dcb30935afc407482bb065c4150e563_RGBA_0_Vector4.b;
            float _SampleTexture2D_2dcb30935afc407482bb065c4150e563_A_7_Float = _SampleTexture2D_2dcb30935afc407482bb065c4150e563_RGBA_0_Vector4.a;
            float _Branch_eb932f0ef97d49398f01d62d896b2b60_Out_3_Float;
            Unity_Branch_float(_Property_97f64a9c7748494dbf6dc5b32920f5a5_Out_0_Boolean, _Split_da1fca62bd1b452a906195ffb7fa6a18_A_4_Float, _SampleTexture2D_2dcb30935afc407482bb065c4150e563_B_6_Float, _Branch_eb932f0ef97d49398f01d62d896b2b60_Out_3_Float);
            float _Multiply_3c4f7578756f4e789ded2b826c933b6d_Out_2_Float;
            Unity_Multiply_float_float(_Property_10cb48b77e114c99a77554a14a36ed9a_Out_0_Float, _Branch_eb932f0ef97d49398f01d62d896b2b60_Out_3_Float, _Multiply_3c4f7578756f4e789ded2b826c933b6d_Out_2_Float);
            float _Absolute_cc8840692870447e8bc057dbbf5f18c1_Out_1_Float;
            Unity_Absolute_float(_Multiply_3c4f7578756f4e789ded2b826c933b6d_Out_2_Float, _Absolute_cc8840692870447e8bc057dbbf5f18c1_Out_1_Float);
            float _Property_472619a20fe14990a52e2bbe0c00ea22_Out_0_Float = _Alpha_Power;
            float _Power_55566f012c2d4585bb257e256506056c_Out_2_Float;
            Unity_Power_float(_Absolute_cc8840692870447e8bc057dbbf5f18c1_Out_1_Float, _Property_472619a20fe14990a52e2bbe0c00ea22_Out_0_Float, _Power_55566f012c2d4585bb257e256506056c_Out_2_Float);
            float _Clamp_4788840726ef4518b7a1fc8db3fcdd97_Out_3_Float;
            Unity_Clamp_float(_Power_55566f012c2d4585bb257e256506056c_Out_2_Float, float(0), float(1), _Clamp_4788840726ef4518b7a1fc8db3fcdd97_Out_3_Float);
            UnityTexture2D _Property_360e6833e8d64d75827ab98987b2b545_Out_0_Texture2D = UnityBuildTexture2DStructNoScale(_NormalMap);
            float4 _SampleTexture2D_1300b7cb738f4b18927411750039acd2_RGBA_0_Vector4 = SAMPLE_TEXTURE2D(_Property_360e6833e8d64d75827ab98987b2b545_Out_0_Texture2D.tex, _Property_360e6833e8d64d75827ab98987b2b545_Out_0_Texture2D.samplerstate, _Property_360e6833e8d64d75827ab98987b2b545_Out_0_Texture2D.GetTransformedUV(IN.uv0.xy) );
            _SampleTexture2D_1300b7cb738f4b18927411750039acd2_RGBA_0_Vector4.rgb = UnpackNormal(_SampleTexture2D_1300b7cb738f4b18927411750039acd2_RGBA_0_Vector4);
            float _SampleTexture2D_1300b7cb738f4b18927411750039acd2_R_4_Float = _SampleTexture2D_1300b7cb738f4b18927411750039acd2_RGBA_0_Vector4.r;
            float _SampleTexture2D_1300b7cb738f4b18927411750039acd2_G_5_Float = _SampleTexture2D_1300b7cb738f4b18927411750039acd2_RGBA_0_Vector4.g;
            float _SampleTexture2D_1300b7cb738f4b18927411750039acd2_B_6_Float = _SampleTexture2D_1300b7cb738f4b18927411750039acd2_RGBA_0_Vector4.b;
            float _SampleTexture2D_1300b7cb738f4b18927411750039acd2_A_7_Float = _SampleTexture2D_1300b7cb738f4b18927411750039acd2_RGBA_0_Vector4.a;
            float _Property_e94639b7a37847e1a4616aeed6a21034_Out_0_Boolean = _MaskMap_Alpha_Use_T_Base_Color_A_F_Maskmap_B;
            float _Branch_39df5838709544d2951602a5ba721694_Out_3_Float;
            Unity_Branch_float(_Property_e94639b7a37847e1a4616aeed6a21034_Out_0_Boolean, _Split_da1fca62bd1b452a906195ffb7fa6a18_A_4_Float, _SampleTexture2D_2dcb30935afc407482bb065c4150e563_B_6_Float, _Branch_39df5838709544d2951602a5ba721694_Out_3_Float);
            float _Property_1ed131c6c6bd4d3b9225106c761ab06c_Out_0_Float = Normal_Blend;
            float _Multiply_52cb6c63b083455c8e01c3d5ccd89afc_Out_2_Float;
            Unity_Multiply_float_float(_Branch_39df5838709544d2951602a5ba721694_Out_3_Float, _Property_1ed131c6c6bd4d3b9225106c761ab06c_Out_0_Float, _Multiply_52cb6c63b083455c8e01c3d5ccd89afc_Out_2_Float);
            float _Property_5830ed7c65ef489e93de994fcb2769e2_Out_0_Float = _MetallicRemapMin;
            float _Property_3b33ae94b35943b5bbaa24c03b7069a8_Out_0_Float = _MetallicRemapMax;
            float2 _Vector2_0ad2d19d32894d5e83e19e69d72753fd_Out_0_Vector2 = float2(_Property_5830ed7c65ef489e93de994fcb2769e2_Out_0_Float, _Property_3b33ae94b35943b5bbaa24c03b7069a8_Out_0_Float);
            float _Remap_b3145e45987e489f9b15e9672b41a608_Out_3_Float;
            Unity_Remap_float(_SampleTexture2D_2dcb30935afc407482bb065c4150e563_R_4_Float, float2 (0, 1), _Vector2_0ad2d19d32894d5e83e19e69d72753fd_Out_0_Vector2, _Remap_b3145e45987e489f9b15e9672b41a608_Out_3_Float);
            float _Property_6427dba68c8342eebff5ce521921ddc5_Out_0_Float = _AORemapMin;
            float _Property_f74a95489f364e41b53a083f89ad2365_Out_0_Float = _AORemapMax;
            float2 _Vector2_a00f84e5347b414ca0e9496b9948ba0b_Out_0_Vector2 = float2(_Property_6427dba68c8342eebff5ce521921ddc5_Out_0_Float, _Property_f74a95489f364e41b53a083f89ad2365_Out_0_Float);
            float _Remap_75ea5a896ac148bb8058b60d79c90284_Out_3_Float;
            Unity_Remap_float(_SampleTexture2D_2dcb30935afc407482bb065c4150e563_G_5_Float, float2 (0, 1), _Vector2_a00f84e5347b414ca0e9496b9948ba0b_Out_0_Vector2, _Remap_75ea5a896ac148bb8058b60d79c90284_Out_3_Float);
            float _Property_9d6993415be843799b7ec2e689c5db02_Out_0_Float = _SmoothnessRemapMin;
            float _Property_df4aa91a4fe94e5f8768553f10cd1f82_Out_0_Float = _SmoothnessRemapMax;
            float2 _Vector2_d67e05a1240344f3978c1c9e3cb9525f_Out_0_Vector2 = float2(_Property_9d6993415be843799b7ec2e689c5db02_Out_0_Float, _Property_df4aa91a4fe94e5f8768553f10cd1f82_Out_0_Float);
            float _Remap_ad26abe467c44f5284db4b4203d8242b_Out_3_Float;
            Unity_Remap_float(_SampleTexture2D_2dcb30935afc407482bb065c4150e563_A_7_Float, float2 (0, 1), _Vector2_d67e05a1240344f3978c1c9e3cb9525f_Out_0_Vector2, _Remap_ad26abe467c44f5284db4b4203d8242b_Out_3_Float);
            float _Property_5c661f4099b14a5bac0c24977977340d_Out_0_Float = _MaskBlendSrc;
            float _Multiply_fc69b6805f38404cb402d2a6b2d2b73a_Out_2_Float;
            Unity_Multiply_float_float(_Split_da1fca62bd1b452a906195ffb7fa6a18_A_4_Float, _Property_5c661f4099b14a5bac0c24977977340d_Out_0_Float, _Multiply_fc69b6805f38404cb402d2a6b2d2b73a_Out_2_Float);
            float _Multiply_2f94ef00580f43caa2427a59ed8ca124_Out_2_Float;
            Unity_Multiply_float_float(_Property_5c661f4099b14a5bac0c24977977340d_Out_0_Float, _SampleTexture2D_2dcb30935afc407482bb065c4150e563_B_6_Float, _Multiply_2f94ef00580f43caa2427a59ed8ca124_Out_2_Float);
            float _Branch_753c02949c6b4f128d654534f2d64ced_Out_3_Float;
            Unity_Branch_float(_Property_e94639b7a37847e1a4616aeed6a21034_Out_0_Boolean, _Multiply_fc69b6805f38404cb402d2a6b2d2b73a_Out_2_Float, _Multiply_2f94ef00580f43caa2427a59ed8ca124_Out_2_Float, _Branch_753c02949c6b4f128d654534f2d64ced_Out_3_Float);
            float4 _Property_293317916e0e41cc98bbd5377294091b_Out_0_Vector4 = IsGammaSpace() ? LinearToSRGB(_EmissiveColor) : _EmissiveColor;
            UnityTexture2D _Property_fb3929b3be5f4269845ceb27fb377d12_Out_0_Texture2D = UnityBuildTexture2DStructNoScale(_EmissiveColorMap);
            float4 _SampleTexture2D_d4d6d2f60c614e4c8b681d89316209dc_RGBA_0_Vector4 = SAMPLE_TEXTURE2D(_Property_fb3929b3be5f4269845ceb27fb377d12_Out_0_Texture2D.tex, _Property_fb3929b3be5f4269845ceb27fb377d12_Out_0_Texture2D.samplerstate, _Property_fb3929b3be5f4269845ceb27fb377d12_Out_0_Texture2D.GetTransformedUV(IN.uv0.xy) );
            float _SampleTexture2D_d4d6d2f60c614e4c8b681d89316209dc_R_4_Float = _SampleTexture2D_d4d6d2f60c614e4c8b681d89316209dc_RGBA_0_Vector4.r;
            float _SampleTexture2D_d4d6d2f60c614e4c8b681d89316209dc_G_5_Float = _SampleTexture2D_d4d6d2f60c614e4c8b681d89316209dc_RGBA_0_Vector4.g;
            float _SampleTexture2D_d4d6d2f60c614e4c8b681d89316209dc_B_6_Float = _SampleTexture2D_d4d6d2f60c614e4c8b681d89316209dc_RGBA_0_Vector4.b;
            float _SampleTexture2D_d4d6d2f60c614e4c8b681d89316209dc_A_7_Float = _SampleTexture2D_d4d6d2f60c614e4c8b681d89316209dc_RGBA_0_Vector4.a;
            float4 _Multiply_2fa508cc2b6044e09e63453927d92375_Out_2_Vector4;
            Unity_Multiply_float4_float4(_Property_293317916e0e41cc98bbd5377294091b_Out_0_Vector4, _SampleTexture2D_d4d6d2f60c614e4c8b681d89316209dc_RGBA_0_Vector4, _Multiply_2fa508cc2b6044e09e63453927d92375_Out_2_Vector4);
            surface.BaseColor = (_Multiply_885586d42d884019a5375f12f3c61e52_Out_2_Vector4.xyz);
            surface.Alpha = _Clamp_4788840726ef4518b7a1fc8db3fcdd97_Out_3_Float;
            surface.NormalTS = (_SampleTexture2D_1300b7cb738f4b18927411750039acd2_RGBA_0_Vector4.xyz);
            surface.NormalAlpha = _Multiply_52cb6c63b083455c8e01c3d5ccd89afc_Out_2_Float;
            surface.Metallic = _Remap_b3145e45987e489f9b15e9672b41a608_Out_3_Float;
            surface.Occlusion = _Remap_75ea5a896ac148bb8058b60d79c90284_Out_3_Float;
            surface.Smoothness = _Remap_ad26abe467c44f5284db4b4203d8242b_Out_3_Float;
            surface.MAOSAlpha = _Branch_753c02949c6b4f128d654534f2d64ced_Out_3_Float;
            surface.Emission = (_Multiply_2fa508cc2b6044e09e63453927d92375_Out_2_Vector4.xyz);
            return surface;
        }
        
            // --------------------------------------------------
            // Build Graph Inputs
        
            
        //     $features.graphVertex:  $include("VertexAnimation.template.hlsl")
        //                                       ^ ERROR: $include cannot find file : VertexAnimation.template.hlsl. Looked into:
        // Packages/com.unity.shadergraph/Editor/Generation/Templates
        
            
        //     $features.graphPixel:   $include("SharedCode.template.hlsl")
        //                                       ^ ERROR: $include cannot find file : SharedCode.template.hlsl. Looked into:
        // Packages/com.unity.shadergraph/Editor/Generation/Templates
        
            SurfaceDescriptionInputs BuildSurfaceDescriptionInputs(Varyings input)
        {
            SurfaceDescriptionInputs output;
            ZERO_INITIALIZE(SurfaceDescriptionInputs, output);
        
            /* WARNING: $splice Could not find named fragment 'CustomInterpolatorCopyToSDI' */
        
        
        
            output.TangentSpaceNormal =                         float3(0.0f, 0.0f, 1.0f);
        
        
        
            #if UNITY_UV_STARTS_AT_TOP
            #else
            #endif
        
        
        
        #if defined(UNITY_UIE_INCLUDED)
            output.uv0 =                                        float4(input.texCoord0.x, input.texCoord0.y, 0, 0);
        #else
            output.uv0 =                                        input.texCoord0;
        #endif
            
        
            
            
        #if UNITY_ANY_INSTANCING_ENABLED
        #else // TODO: XR support for procedural instancing because in this case UNITY_ANY_INSTANCING_ENABLED is not defined and instanceID is incorrect.
        #endif
        #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
        #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN                output.FaceSign =                                   IS_FRONT_VFACE(input.cullFace, true, false);
        #else
        #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
        #endif
        #undef BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
        
            return output;
        }
        
            // --------------------------------------------------
            // Build Surface Data
        
            void GetSurfaceData(Varyings input, float4 positionCS, float angleFadeFactor, out DecalSurfaceData surfaceData)
            {
                #if (SHADERPASS == SHADERPASS_DBUFFER_PROJECTOR) || (SHADERPASS == SHADERPASS_FORWARD_EMISSIVE_PROJECTOR) || (SHADERPASS == SHADERPASS_DECAL_SCREEN_SPACE_PROJECTOR) || (SHADERPASS == SHADERPASS_DECAL_GBUFFER_PROJECTOR)
                    half4x4 normalToWorld = UNITY_ACCESS_INSTANCED_PROP(Decal, _NormalToWorld);
                    half fadeFactor = clamp(normalToWorld[0][3], 0.0f, 1.0f) * angleFadeFactor;
                    float2 scale = float2(normalToWorld[3][0], normalToWorld[3][1]);
                    float2 offset = float2(normalToWorld[3][2], normalToWorld[3][3]);
                    input.texCoord0.xy = input.texCoord0.xy * scale + offset;
                    half3 normalWS = TransformObjectToWorldDir(half3(0, 1, 0));
                    half3 tangentWS = TransformObjectToWorldDir(half3(1, 0, 0));
                    half3 bitangentWS = TransformObjectToWorldDir(half3(0, 0, 1));
                    half sign = dot(cross(normalWS, tangentWS), bitangentWS) > 0 ? 1 : -1;
                    input.normalWS.xyz = normalWS;
                    input.tangentWS.xyzw = half4(tangentWS, sign);
                #else
                    #if defined(LOD_FADE_CROSSFADE) && USE_UNITY_CROSSFADE
                        LODFadeCrossFade(positionCS);
                    #endif
        
                    half fadeFactor = half(1.0);
                #endif
        
                SurfaceDescriptionInputs surfaceDescriptionInputs = BuildSurfaceDescriptionInputs(input);
                SurfaceDescription surfaceDescription = SurfaceDescriptionFunction(surfaceDescriptionInputs);
        
                // setup defaults -- these are used if the graph doesn't output a value
                ZERO_INITIALIZE(DecalSurfaceData, surfaceData);
                surfaceData.occlusion = half(1.0);
                surfaceData.smoothness = half(0);
        
                #ifdef _MATERIAL_AFFECTS_NORMAL
                    surfaceData.normalWS.w = half(1.0);
                #else
                    surfaceData.normalWS.w = half(0.0);
                #endif
        
                surfaceData.emissive.rgb = half3(surfaceDescription.Emission.rgb * fadeFactor);
        
                // copy across graph values, if defined
                surfaceData.baseColor.xyz = half3(surfaceDescription.BaseColor);
                surfaceData.baseColor.w = half(surfaceDescription.Alpha * fadeFactor);
        
                #if (SHADERPASS == SHADERPASS_DBUFFER_PROJECTOR) || (SHADERPASS == SHADERPASS_DECAL_SCREEN_SPACE_PROJECTOR) || (SHADERPASS == SHADERPASS_DECAL_GBUFFER_PROJECTOR)
                    #if defined(_MATERIAL_AFFECTS_NORMAL)
                        surfaceData.normalWS.xyz = normalize(mul((half3x3)normalToWorld, surfaceDescription.NormalTS.xyz));
                    #else
                        surfaceData.normalWS.xyz = normalize(normalToWorld[2].xyz);
                    #endif
                #elif (SHADERPASS == SHADERPASS_DBUFFER_MESH) || (SHADERPASS == SHADERPASS_DECAL_SCREEN_SPACE_MESH) || (SHADERPASS == SHADERPASS_DECAL_GBUFFER_MESH)
                    #if defined(_MATERIAL_AFFECTS_NORMAL)
                        float sgn = input.tangentWS.w;      // should be either +1 or -1
                        float3 bitangent = sgn * cross(input.normalWS.xyz, input.tangentWS.xyz);
                        half3x3 tangentToWorld = half3x3(input.tangentWS.xyz, bitangent.xyz, input.normalWS.xyz);
        
                        // We need to normalize as we use mikkt tangent space and this is expected (tangent space is not normalize)
                        surfaceData.normalWS.xyz = normalize(TransformTangentToWorld(surfaceDescription.NormalTS, tangentToWorld));
                    #else
                        surfaceData.normalWS.xyz = normalize(half3(input.normalWS)); // Default to vertex normal
                    #endif
                #endif
        
                surfaceData.normalWS.w = surfaceDescription.NormalAlpha * fadeFactor;
        
                // In case of Smoothness / AO / Metal, all the three are always computed but color mask can change
                surfaceData.metallic = half(surfaceDescription.Metallic);
                surfaceData.occlusion = half(surfaceDescription.Occlusion);
                surfaceData.smoothness = half(surfaceDescription.Smoothness);
                surfaceData.MAOSAlpha = half(surfaceDescription.MAOSAlpha * fadeFactor);
            }
        
            // --------------------------------------------------
            // Main
        
            #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/Varyings.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShaderPassDecal.hlsl"
        
            ENDHLSL
        }
        Pass
        {
            Name "DecalScreenSpaceMesh"
            Tags
            {
                "LightMode" = "DecalScreenSpaceMesh"
            }
        
            // Render State
            Blend SrcAlpha OneMinusSrcAlpha
        ZTest LEqual
        ZWrite Off
        
            // Debug
            // <None>
        
            // --------------------------------------------------
            // Pass
        
            HLSLPROGRAM
        
            // Pragmas
            #pragma target 2.5
        #pragma vertex Vert
        #pragma fragment Frag
        #pragma multi_compile_instancing
        #pragma editor_sync_compilation
        
            // Keywords
            #pragma multi_compile _ LIGHTMAP_ON
        #pragma multi_compile _ DYNAMICLIGHTMAP_ON
        #pragma multi_compile _ DIRLIGHTMAP_COMBINED
        #pragma multi_compile _ USE_LEGACY_LIGHTMAPS
        #pragma multi_compile _ LIGHTMAP_BICUBIC_SAMPLING
        #pragma multi_compile _ REFLECTION_PROBE_ROTATION
        #pragma multi_compile _ _MAIN_LIGHT_SHADOWS _MAIN_LIGHT_SHADOWS_CASCADE _MAIN_LIGHT_SHADOWS_SCREEN
        #pragma multi_compile _ _ADDITIONAL_LIGHTS_VERTEX _ADDITIONAL_LIGHTS
        #pragma multi_compile_fragment _ _ADDITIONAL_LIGHT_SHADOWS
        #pragma multi_compile_fragment _ _SHADOWS_SOFT _SHADOWS_SOFT_LOW _SHADOWS_SOFT_MEDIUM _SHADOWS_SOFT_HIGH
        #pragma multi_compile _ LIGHTMAP_SHADOW_MIXING
        #pragma multi_compile _ SHADOWS_SHADOWMASK
        #pragma multi_compile _ _CLUSTER_LIGHT_LOOP
        #pragma multi_compile _DECAL_NORMAL_BLEND_LOW _DECAL_NORMAL_BLEND_MEDIUM _DECAL_NORMAL_BLEND_HIGH
        #pragma multi_compile_fragment _ DEBUG_DISPLAY
        #pragma multi_compile _ _DECAL_LAYERS
            // GraphKeywords: <None>
        
            #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Common.hlsl"
            #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Texture.hlsl"
            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
        
            // Defines
            #define ATTRIBUTES_NEED_NORMAL
            #define ATTRIBUTES_NEED_TANGENT
            #define ATTRIBUTES_NEED_TEXCOORD0
            #define ATTRIBUTES_NEED_TEXCOORD1
            #define ATTRIBUTES_NEED_TEXCOORD2
            #define VARYINGS_NEED_POSITION_WS
            #define VARYINGS_NEED_NORMAL_WS
            #define VARYINGS_NEED_TANGENT_WS
            #define VARYINGS_NEED_TEXCOORD0
            #define VARYINGS_NEED_FOG_AND_VERTEX_LIGHT
            #define VARYINGS_NEED_SH
            #define VARYINGS_NEED_STATIC_LIGHTMAP_UV
            #define VARYINGS_NEED_DYNAMIC_LIGHTMAP_UV
            #define VARYINGS_NEED_SHADOW_COORD
        
            #define HAVE_MESH_MODIFICATION
        
        
            #define SHADERPASS SHADERPASS_DECAL_SCREEN_SPACE_MESH
        #define _MATERIAL_AFFECTS_ALBEDO 1
        #define _MATERIAL_AFFECTS_NORMAL 1
        #define _MATERIAL_AFFECTS_NORMAL_BLEND 1
        #define _MATERIAL_AFFECTS_MAOS 1
        #define _MATERIAL_AFFECTS_EMISSION 1
        
            // Includes
            #include_with_pragmas "Packages/com.unity.render-pipelines.universal/ShaderLibrary/DOTS.hlsl"
        #include_with_pragmas "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Fog.hlsl"
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
        #include_with_pragmas "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ProbeVolumeVariants.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShaderPass.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/DecalInput.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShaderVariablesDecal.hlsl"
        
            // -- Properties used by ScenePickingPass
            #ifdef SCENEPICKINGPASS
            float4 _SelectionID;
            #endif
            #if _RENDER_PASS_ENABLED
            #define GBUFFER3 0
            FRAMEBUFFER_INPUT_X_FLOAT(GBUFFER3);
            #define GBUFFER4 1
            FRAMEBUFFER_INPUT_X_UINT(GBUFFER4);
            #endif
        
            // --------------------------------------------------
            // Structs and Packing
        
            struct Attributes
        {
             float3 positionOS : POSITION;
             float3 normalOS : NORMAL;
             float4 tangentOS : TANGENT;
             float4 uv0 : TEXCOORD0;
             float4 uv1 : TEXCOORD1;
             float4 uv2 : TEXCOORD2;
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
             float3 TangentSpaceNormal;
             float4 uv0;
        };
        struct VertexDescriptionInputs
        {
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
             float4 fogFactorAndVertexLight : INTERP7;
             float3 positionWS : INTERP8;
             float3 normalWS : INTERP9;
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
        float _Alpha_Multiply;
        float _Alpha_Power;
        float4 _BaseColorMap_TexelSize;
        float4 _NormalMap_TexelSize;
        float Normal_Blend;
        float4 _BaseColor;
        float4 _MaskMap_TexelSize;
        float _MetallicRemapMax;
        float _MetallicRemapMin;
        float _AORemapMin;
        float _AORemapMax;
        float _SmoothnessRemapMin;
        float _SmoothnessRemapMax;
        float _MaskBlendSrc;
        float4 _EmissiveColor;
        float4 _EmissiveColorMap_TexelSize;
        float _Alpha_Use_T_Base_Color_A_F_Maskmap_B;
        float _MaskMap_Alpha_Use_T_Base_Color_A_F_Maskmap_B;
        float _DrawOrder;
        float _DecalMeshBiasType;
        float _DecalMeshDepthBias;
        float _DecalMeshViewBias;
        float _DecalAngleFadeSupported;
        UNITY_TEXTURE_STREAMING_DEBUG_VARS;
        CBUFFER_END
        
        
        // Object and Global properties
        SAMPLER(SamplerState_Linear_Repeat);
        TEXTURE2D(_BaseColorMap);
        SAMPLER(sampler_BaseColorMap);
        TEXTURE2D(_NormalMap);
        SAMPLER(sampler_NormalMap);
        TEXTURE2D(_MaskMap);
        SAMPLER(sampler_MaskMap);
        TEXTURE2D(_EmissiveColorMap);
        SAMPLER(sampler_EmissiveColorMap);
        
            // Graph Includes
            // GraphIncludes: <None>
        
            // Graph Functions
            
        void Unity_Multiply_float4_float4(float4 A, float4 B, out float4 Out)
        {
            Out = A * B;
        }
        
        void Unity_Branch_float(float Predicate, float True, float False, out float Out)
        {
            Out = Predicate ? True : False;
        }
        
        void Unity_Multiply_float_float(float A, float B, out float Out)
        {
            Out = A * B;
        }
        
        void Unity_Absolute_float(float In, out float Out)
        {
            Out = abs(In);
        }
        
        void Unity_Power_float(float A, float B, out float Out)
        {
            Out = pow(A, B);
        }
        
        void Unity_Clamp_float(float In, float Min, float Max, out float Out)
        {
            Out = clamp(In, Min, Max);
        }
        
        void Unity_Remap_float(float In, float2 InMinMax, float2 OutMinMax, out float Out)
        {
            Out = OutMinMax.x + (In - InMinMax.x) * (OutMinMax.y - OutMinMax.x) / (InMinMax.y - InMinMax.x);
        }
        
            // Graph Vertex
            struct VertexDescription
        {
        };
        
        VertexDescription VertexDescriptionFunction(VertexDescriptionInputs IN)
        {
            VertexDescription description = (VertexDescription)0;
            return description;
        }
        
            // Graph Pixel
            struct SurfaceDescription
        {
            float3 BaseColor;
            float Alpha;
            float3 NormalTS;
            float NormalAlpha;
            float Metallic;
            float Occlusion;
            float Smoothness;
            float MAOSAlpha;
            float3 Emission;
        };
        
        SurfaceDescription SurfaceDescriptionFunction(SurfaceDescriptionInputs IN)
        {
            SurfaceDescription surface = (SurfaceDescription)0;
            float4 _Property_320fefd883db46679cd769f61b130dd7_Out_0_Vector4 = _BaseColor;
            UnityTexture2D _Property_9f1059a7a93a46ccab349515214f3ed2_Out_0_Texture2D = UnityBuildTexture2DStructNoScale(_BaseColorMap);
            float4 _SampleTexture2D_7388a7ddbf6648ec92c3bb54ed055048_RGBA_0_Vector4 = SAMPLE_TEXTURE2D(_Property_9f1059a7a93a46ccab349515214f3ed2_Out_0_Texture2D.tex, _Property_9f1059a7a93a46ccab349515214f3ed2_Out_0_Texture2D.samplerstate, _Property_9f1059a7a93a46ccab349515214f3ed2_Out_0_Texture2D.GetTransformedUV(IN.uv0.xy) );
            float _SampleTexture2D_7388a7ddbf6648ec92c3bb54ed055048_R_4_Float = _SampleTexture2D_7388a7ddbf6648ec92c3bb54ed055048_RGBA_0_Vector4.r;
            float _SampleTexture2D_7388a7ddbf6648ec92c3bb54ed055048_G_5_Float = _SampleTexture2D_7388a7ddbf6648ec92c3bb54ed055048_RGBA_0_Vector4.g;
            float _SampleTexture2D_7388a7ddbf6648ec92c3bb54ed055048_B_6_Float = _SampleTexture2D_7388a7ddbf6648ec92c3bb54ed055048_RGBA_0_Vector4.b;
            float _SampleTexture2D_7388a7ddbf6648ec92c3bb54ed055048_A_7_Float = _SampleTexture2D_7388a7ddbf6648ec92c3bb54ed055048_RGBA_0_Vector4.a;
            float4 _Multiply_885586d42d884019a5375f12f3c61e52_Out_2_Vector4;
            Unity_Multiply_float4_float4(_Property_320fefd883db46679cd769f61b130dd7_Out_0_Vector4, _SampleTexture2D_7388a7ddbf6648ec92c3bb54ed055048_RGBA_0_Vector4, _Multiply_885586d42d884019a5375f12f3c61e52_Out_2_Vector4);
            float _Property_10cb48b77e114c99a77554a14a36ed9a_Out_0_Float = _Alpha_Multiply;
            float _Property_97f64a9c7748494dbf6dc5b32920f5a5_Out_0_Boolean = _Alpha_Use_T_Base_Color_A_F_Maskmap_B;
            float _Split_da1fca62bd1b452a906195ffb7fa6a18_R_1_Float = _Multiply_885586d42d884019a5375f12f3c61e52_Out_2_Vector4[0];
            float _Split_da1fca62bd1b452a906195ffb7fa6a18_G_2_Float = _Multiply_885586d42d884019a5375f12f3c61e52_Out_2_Vector4[1];
            float _Split_da1fca62bd1b452a906195ffb7fa6a18_B_3_Float = _Multiply_885586d42d884019a5375f12f3c61e52_Out_2_Vector4[2];
            float _Split_da1fca62bd1b452a906195ffb7fa6a18_A_4_Float = _Multiply_885586d42d884019a5375f12f3c61e52_Out_2_Vector4[3];
            UnityTexture2D _Property_b46891aff98b4364a190337410150f10_Out_0_Texture2D = UnityBuildTexture2DStructNoScale(_MaskMap);
            float4 _SampleTexture2D_2dcb30935afc407482bb065c4150e563_RGBA_0_Vector4 = SAMPLE_TEXTURE2D(_Property_b46891aff98b4364a190337410150f10_Out_0_Texture2D.tex, _Property_b46891aff98b4364a190337410150f10_Out_0_Texture2D.samplerstate, _Property_b46891aff98b4364a190337410150f10_Out_0_Texture2D.GetTransformedUV(IN.uv0.xy) );
            float _SampleTexture2D_2dcb30935afc407482bb065c4150e563_R_4_Float = _SampleTexture2D_2dcb30935afc407482bb065c4150e563_RGBA_0_Vector4.r;
            float _SampleTexture2D_2dcb30935afc407482bb065c4150e563_G_5_Float = _SampleTexture2D_2dcb30935afc407482bb065c4150e563_RGBA_0_Vector4.g;
            float _SampleTexture2D_2dcb30935afc407482bb065c4150e563_B_6_Float = _SampleTexture2D_2dcb30935afc407482bb065c4150e563_RGBA_0_Vector4.b;
            float _SampleTexture2D_2dcb30935afc407482bb065c4150e563_A_7_Float = _SampleTexture2D_2dcb30935afc407482bb065c4150e563_RGBA_0_Vector4.a;
            float _Branch_eb932f0ef97d49398f01d62d896b2b60_Out_3_Float;
            Unity_Branch_float(_Property_97f64a9c7748494dbf6dc5b32920f5a5_Out_0_Boolean, _Split_da1fca62bd1b452a906195ffb7fa6a18_A_4_Float, _SampleTexture2D_2dcb30935afc407482bb065c4150e563_B_6_Float, _Branch_eb932f0ef97d49398f01d62d896b2b60_Out_3_Float);
            float _Multiply_3c4f7578756f4e789ded2b826c933b6d_Out_2_Float;
            Unity_Multiply_float_float(_Property_10cb48b77e114c99a77554a14a36ed9a_Out_0_Float, _Branch_eb932f0ef97d49398f01d62d896b2b60_Out_3_Float, _Multiply_3c4f7578756f4e789ded2b826c933b6d_Out_2_Float);
            float _Absolute_cc8840692870447e8bc057dbbf5f18c1_Out_1_Float;
            Unity_Absolute_float(_Multiply_3c4f7578756f4e789ded2b826c933b6d_Out_2_Float, _Absolute_cc8840692870447e8bc057dbbf5f18c1_Out_1_Float);
            float _Property_472619a20fe14990a52e2bbe0c00ea22_Out_0_Float = _Alpha_Power;
            float _Power_55566f012c2d4585bb257e256506056c_Out_2_Float;
            Unity_Power_float(_Absolute_cc8840692870447e8bc057dbbf5f18c1_Out_1_Float, _Property_472619a20fe14990a52e2bbe0c00ea22_Out_0_Float, _Power_55566f012c2d4585bb257e256506056c_Out_2_Float);
            float _Clamp_4788840726ef4518b7a1fc8db3fcdd97_Out_3_Float;
            Unity_Clamp_float(_Power_55566f012c2d4585bb257e256506056c_Out_2_Float, float(0), float(1), _Clamp_4788840726ef4518b7a1fc8db3fcdd97_Out_3_Float);
            UnityTexture2D _Property_360e6833e8d64d75827ab98987b2b545_Out_0_Texture2D = UnityBuildTexture2DStructNoScale(_NormalMap);
            float4 _SampleTexture2D_1300b7cb738f4b18927411750039acd2_RGBA_0_Vector4 = SAMPLE_TEXTURE2D(_Property_360e6833e8d64d75827ab98987b2b545_Out_0_Texture2D.tex, _Property_360e6833e8d64d75827ab98987b2b545_Out_0_Texture2D.samplerstate, _Property_360e6833e8d64d75827ab98987b2b545_Out_0_Texture2D.GetTransformedUV(IN.uv0.xy) );
            _SampleTexture2D_1300b7cb738f4b18927411750039acd2_RGBA_0_Vector4.rgb = UnpackNormal(_SampleTexture2D_1300b7cb738f4b18927411750039acd2_RGBA_0_Vector4);
            float _SampleTexture2D_1300b7cb738f4b18927411750039acd2_R_4_Float = _SampleTexture2D_1300b7cb738f4b18927411750039acd2_RGBA_0_Vector4.r;
            float _SampleTexture2D_1300b7cb738f4b18927411750039acd2_G_5_Float = _SampleTexture2D_1300b7cb738f4b18927411750039acd2_RGBA_0_Vector4.g;
            float _SampleTexture2D_1300b7cb738f4b18927411750039acd2_B_6_Float = _SampleTexture2D_1300b7cb738f4b18927411750039acd2_RGBA_0_Vector4.b;
            float _SampleTexture2D_1300b7cb738f4b18927411750039acd2_A_7_Float = _SampleTexture2D_1300b7cb738f4b18927411750039acd2_RGBA_0_Vector4.a;
            float _Property_e94639b7a37847e1a4616aeed6a21034_Out_0_Boolean = _MaskMap_Alpha_Use_T_Base_Color_A_F_Maskmap_B;
            float _Branch_39df5838709544d2951602a5ba721694_Out_3_Float;
            Unity_Branch_float(_Property_e94639b7a37847e1a4616aeed6a21034_Out_0_Boolean, _Split_da1fca62bd1b452a906195ffb7fa6a18_A_4_Float, _SampleTexture2D_2dcb30935afc407482bb065c4150e563_B_6_Float, _Branch_39df5838709544d2951602a5ba721694_Out_3_Float);
            float _Property_1ed131c6c6bd4d3b9225106c761ab06c_Out_0_Float = Normal_Blend;
            float _Multiply_52cb6c63b083455c8e01c3d5ccd89afc_Out_2_Float;
            Unity_Multiply_float_float(_Branch_39df5838709544d2951602a5ba721694_Out_3_Float, _Property_1ed131c6c6bd4d3b9225106c761ab06c_Out_0_Float, _Multiply_52cb6c63b083455c8e01c3d5ccd89afc_Out_2_Float);
            float _Property_5830ed7c65ef489e93de994fcb2769e2_Out_0_Float = _MetallicRemapMin;
            float _Property_3b33ae94b35943b5bbaa24c03b7069a8_Out_0_Float = _MetallicRemapMax;
            float2 _Vector2_0ad2d19d32894d5e83e19e69d72753fd_Out_0_Vector2 = float2(_Property_5830ed7c65ef489e93de994fcb2769e2_Out_0_Float, _Property_3b33ae94b35943b5bbaa24c03b7069a8_Out_0_Float);
            float _Remap_b3145e45987e489f9b15e9672b41a608_Out_3_Float;
            Unity_Remap_float(_SampleTexture2D_2dcb30935afc407482bb065c4150e563_R_4_Float, float2 (0, 1), _Vector2_0ad2d19d32894d5e83e19e69d72753fd_Out_0_Vector2, _Remap_b3145e45987e489f9b15e9672b41a608_Out_3_Float);
            float _Property_6427dba68c8342eebff5ce521921ddc5_Out_0_Float = _AORemapMin;
            float _Property_f74a95489f364e41b53a083f89ad2365_Out_0_Float = _AORemapMax;
            float2 _Vector2_a00f84e5347b414ca0e9496b9948ba0b_Out_0_Vector2 = float2(_Property_6427dba68c8342eebff5ce521921ddc5_Out_0_Float, _Property_f74a95489f364e41b53a083f89ad2365_Out_0_Float);
            float _Remap_75ea5a896ac148bb8058b60d79c90284_Out_3_Float;
            Unity_Remap_float(_SampleTexture2D_2dcb30935afc407482bb065c4150e563_G_5_Float, float2 (0, 1), _Vector2_a00f84e5347b414ca0e9496b9948ba0b_Out_0_Vector2, _Remap_75ea5a896ac148bb8058b60d79c90284_Out_3_Float);
            float _Property_9d6993415be843799b7ec2e689c5db02_Out_0_Float = _SmoothnessRemapMin;
            float _Property_df4aa91a4fe94e5f8768553f10cd1f82_Out_0_Float = _SmoothnessRemapMax;
            float2 _Vector2_d67e05a1240344f3978c1c9e3cb9525f_Out_0_Vector2 = float2(_Property_9d6993415be843799b7ec2e689c5db02_Out_0_Float, _Property_df4aa91a4fe94e5f8768553f10cd1f82_Out_0_Float);
            float _Remap_ad26abe467c44f5284db4b4203d8242b_Out_3_Float;
            Unity_Remap_float(_SampleTexture2D_2dcb30935afc407482bb065c4150e563_A_7_Float, float2 (0, 1), _Vector2_d67e05a1240344f3978c1c9e3cb9525f_Out_0_Vector2, _Remap_ad26abe467c44f5284db4b4203d8242b_Out_3_Float);
            float _Property_5c661f4099b14a5bac0c24977977340d_Out_0_Float = _MaskBlendSrc;
            float _Multiply_fc69b6805f38404cb402d2a6b2d2b73a_Out_2_Float;
            Unity_Multiply_float_float(_Split_da1fca62bd1b452a906195ffb7fa6a18_A_4_Float, _Property_5c661f4099b14a5bac0c24977977340d_Out_0_Float, _Multiply_fc69b6805f38404cb402d2a6b2d2b73a_Out_2_Float);
            float _Multiply_2f94ef00580f43caa2427a59ed8ca124_Out_2_Float;
            Unity_Multiply_float_float(_Property_5c661f4099b14a5bac0c24977977340d_Out_0_Float, _SampleTexture2D_2dcb30935afc407482bb065c4150e563_B_6_Float, _Multiply_2f94ef00580f43caa2427a59ed8ca124_Out_2_Float);
            float _Branch_753c02949c6b4f128d654534f2d64ced_Out_3_Float;
            Unity_Branch_float(_Property_e94639b7a37847e1a4616aeed6a21034_Out_0_Boolean, _Multiply_fc69b6805f38404cb402d2a6b2d2b73a_Out_2_Float, _Multiply_2f94ef00580f43caa2427a59ed8ca124_Out_2_Float, _Branch_753c02949c6b4f128d654534f2d64ced_Out_3_Float);
            float4 _Property_293317916e0e41cc98bbd5377294091b_Out_0_Vector4 = IsGammaSpace() ? LinearToSRGB(_EmissiveColor) : _EmissiveColor;
            UnityTexture2D _Property_fb3929b3be5f4269845ceb27fb377d12_Out_0_Texture2D = UnityBuildTexture2DStructNoScale(_EmissiveColorMap);
            float4 _SampleTexture2D_d4d6d2f60c614e4c8b681d89316209dc_RGBA_0_Vector4 = SAMPLE_TEXTURE2D(_Property_fb3929b3be5f4269845ceb27fb377d12_Out_0_Texture2D.tex, _Property_fb3929b3be5f4269845ceb27fb377d12_Out_0_Texture2D.samplerstate, _Property_fb3929b3be5f4269845ceb27fb377d12_Out_0_Texture2D.GetTransformedUV(IN.uv0.xy) );
            float _SampleTexture2D_d4d6d2f60c614e4c8b681d89316209dc_R_4_Float = _SampleTexture2D_d4d6d2f60c614e4c8b681d89316209dc_RGBA_0_Vector4.r;
            float _SampleTexture2D_d4d6d2f60c614e4c8b681d89316209dc_G_5_Float = _SampleTexture2D_d4d6d2f60c614e4c8b681d89316209dc_RGBA_0_Vector4.g;
            float _SampleTexture2D_d4d6d2f60c614e4c8b681d89316209dc_B_6_Float = _SampleTexture2D_d4d6d2f60c614e4c8b681d89316209dc_RGBA_0_Vector4.b;
            float _SampleTexture2D_d4d6d2f60c614e4c8b681d89316209dc_A_7_Float = _SampleTexture2D_d4d6d2f60c614e4c8b681d89316209dc_RGBA_0_Vector4.a;
            float4 _Multiply_2fa508cc2b6044e09e63453927d92375_Out_2_Vector4;
            Unity_Multiply_float4_float4(_Property_293317916e0e41cc98bbd5377294091b_Out_0_Vector4, _SampleTexture2D_d4d6d2f60c614e4c8b681d89316209dc_RGBA_0_Vector4, _Multiply_2fa508cc2b6044e09e63453927d92375_Out_2_Vector4);
            surface.BaseColor = (_Multiply_885586d42d884019a5375f12f3c61e52_Out_2_Vector4.xyz);
            surface.Alpha = _Clamp_4788840726ef4518b7a1fc8db3fcdd97_Out_3_Float;
            surface.NormalTS = (_SampleTexture2D_1300b7cb738f4b18927411750039acd2_RGBA_0_Vector4.xyz);
            surface.NormalAlpha = _Multiply_52cb6c63b083455c8e01c3d5ccd89afc_Out_2_Float;
            surface.Metallic = _Remap_b3145e45987e489f9b15e9672b41a608_Out_3_Float;
            surface.Occlusion = _Remap_75ea5a896ac148bb8058b60d79c90284_Out_3_Float;
            surface.Smoothness = _Remap_ad26abe467c44f5284db4b4203d8242b_Out_3_Float;
            surface.MAOSAlpha = _Branch_753c02949c6b4f128d654534f2d64ced_Out_3_Float;
            surface.Emission = (_Multiply_2fa508cc2b6044e09e63453927d92375_Out_2_Vector4.xyz);
            return surface;
        }
        
            // --------------------------------------------------
            // Build Graph Inputs
        
            
        //     $features.graphVertex:  $include("VertexAnimation.template.hlsl")
        //                                       ^ ERROR: $include cannot find file : VertexAnimation.template.hlsl. Looked into:
        // Packages/com.unity.shadergraph/Editor/Generation/Templates
        
            
        //     $features.graphPixel:   $include("SharedCode.template.hlsl")
        //                                       ^ ERROR: $include cannot find file : SharedCode.template.hlsl. Looked into:
        // Packages/com.unity.shadergraph/Editor/Generation/Templates
        
            SurfaceDescriptionInputs BuildSurfaceDescriptionInputs(Varyings input)
        {
            SurfaceDescriptionInputs output;
            ZERO_INITIALIZE(SurfaceDescriptionInputs, output);
        
            /* WARNING: $splice Could not find named fragment 'CustomInterpolatorCopyToSDI' */
        
        
        
            output.TangentSpaceNormal =                         float3(0.0f, 0.0f, 1.0f);
        
        
        
            #if UNITY_UV_STARTS_AT_TOP
            #else
            #endif
        
        
        
        #if defined(UNITY_UIE_INCLUDED)
            output.uv0 =                                        float4(input.texCoord0.x, input.texCoord0.y, 0, 0);
        #else
            output.uv0 =                                        input.texCoord0;
        #endif
            
        
            
            
        #if UNITY_ANY_INSTANCING_ENABLED
        #else // TODO: XR support for procedural instancing because in this case UNITY_ANY_INSTANCING_ENABLED is not defined and instanceID is incorrect.
        #endif
        #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
        #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN                output.FaceSign =                                   IS_FRONT_VFACE(input.cullFace, true, false);
        #else
        #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
        #endif
        #undef BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
        
            return output;
        }
        
            // --------------------------------------------------
            // Build Surface Data
        
            void GetSurfaceData(Varyings input, float4 positionCS, float angleFadeFactor, out DecalSurfaceData surfaceData)
            {
                #if (SHADERPASS == SHADERPASS_DBUFFER_PROJECTOR) || (SHADERPASS == SHADERPASS_FORWARD_EMISSIVE_PROJECTOR) || (SHADERPASS == SHADERPASS_DECAL_SCREEN_SPACE_PROJECTOR) || (SHADERPASS == SHADERPASS_DECAL_GBUFFER_PROJECTOR)
                    half4x4 normalToWorld = UNITY_ACCESS_INSTANCED_PROP(Decal, _NormalToWorld);
                    half fadeFactor = clamp(normalToWorld[0][3], 0.0f, 1.0f) * angleFadeFactor;
                    float2 scale = float2(normalToWorld[3][0], normalToWorld[3][1]);
                    float2 offset = float2(normalToWorld[3][2], normalToWorld[3][3]);
                    input.texCoord0.xy = input.texCoord0.xy * scale + offset;
                    half3 normalWS = TransformObjectToWorldDir(half3(0, 1, 0));
                    half3 tangentWS = TransformObjectToWorldDir(half3(1, 0, 0));
                    half3 bitangentWS = TransformObjectToWorldDir(half3(0, 0, 1));
                    half sign = dot(cross(normalWS, tangentWS), bitangentWS) > 0 ? 1 : -1;
                    input.normalWS.xyz = normalWS;
                    input.tangentWS.xyzw = half4(tangentWS, sign);
                #else
                    #if defined(LOD_FADE_CROSSFADE) && USE_UNITY_CROSSFADE
                        LODFadeCrossFade(positionCS);
                    #endif
        
                    half fadeFactor = half(1.0);
                #endif
        
                SurfaceDescriptionInputs surfaceDescriptionInputs = BuildSurfaceDescriptionInputs(input);
                SurfaceDescription surfaceDescription = SurfaceDescriptionFunction(surfaceDescriptionInputs);
        
                // setup defaults -- these are used if the graph doesn't output a value
                ZERO_INITIALIZE(DecalSurfaceData, surfaceData);
                surfaceData.occlusion = half(1.0);
                surfaceData.smoothness = half(0);
        
                #ifdef _MATERIAL_AFFECTS_NORMAL
                    surfaceData.normalWS.w = half(1.0);
                #else
                    surfaceData.normalWS.w = half(0.0);
                #endif
        
                surfaceData.emissive.rgb = half3(surfaceDescription.Emission.rgb * fadeFactor);
        
                // copy across graph values, if defined
                surfaceData.baseColor.xyz = half3(surfaceDescription.BaseColor);
                surfaceData.baseColor.w = half(surfaceDescription.Alpha * fadeFactor);
        
                #if (SHADERPASS == SHADERPASS_DBUFFER_PROJECTOR) || (SHADERPASS == SHADERPASS_DECAL_SCREEN_SPACE_PROJECTOR) || (SHADERPASS == SHADERPASS_DECAL_GBUFFER_PROJECTOR)
                    #if defined(_MATERIAL_AFFECTS_NORMAL)
                        surfaceData.normalWS.xyz = normalize(mul((half3x3)normalToWorld, surfaceDescription.NormalTS.xyz));
                    #else
                        surfaceData.normalWS.xyz = normalize(normalToWorld[2].xyz);
                    #endif
                #elif (SHADERPASS == SHADERPASS_DBUFFER_MESH) || (SHADERPASS == SHADERPASS_DECAL_SCREEN_SPACE_MESH) || (SHADERPASS == SHADERPASS_DECAL_GBUFFER_MESH)
                    #if defined(_MATERIAL_AFFECTS_NORMAL)
                        float sgn = input.tangentWS.w;      // should be either +1 or -1
                        float3 bitangent = sgn * cross(input.normalWS.xyz, input.tangentWS.xyz);
                        half3x3 tangentToWorld = half3x3(input.tangentWS.xyz, bitangent.xyz, input.normalWS.xyz);
        
                        // We need to normalize as we use mikkt tangent space and this is expected (tangent space is not normalize)
                        surfaceData.normalWS.xyz = normalize(TransformTangentToWorld(surfaceDescription.NormalTS, tangentToWorld));
                    #else
                        surfaceData.normalWS.xyz = normalize(half3(input.normalWS)); // Default to vertex normal
                    #endif
                #endif
        
                surfaceData.normalWS.w = surfaceDescription.NormalAlpha * fadeFactor;
        
                // In case of Smoothness / AO / Metal, all the three are always computed but color mask can change
                surfaceData.metallic = half(surfaceDescription.Metallic);
                surfaceData.occlusion = half(surfaceDescription.Occlusion);
                surfaceData.smoothness = half(surfaceDescription.Smoothness);
                surfaceData.MAOSAlpha = half(surfaceDescription.MAOSAlpha * fadeFactor);
            }
        
            // --------------------------------------------------
            // Main
        
            #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/Varyings.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShaderPassDecal.hlsl"
        
            ENDHLSL
        }
        Pass
        {
            Name "DecalGBufferMesh"
            Tags
            {
                "LightMode" = "DecalGBufferMesh"
            }
        
            // Render State
            Blend 0 SrcAlpha OneMinusSrcAlpha
        Blend 1 SrcAlpha OneMinusSrcAlpha
        Blend 2 SrcAlpha OneMinusSrcAlpha
        Blend 3 SrcAlpha OneMinusSrcAlpha
        ZWrite Off
        ColorMask RGB
        ColorMask 0 1
        ColorMask RGB 2
        ColorMask RGB 3
        
            // Debug
            // <None>
        
            // --------------------------------------------------
            // Pass
        
            HLSLPROGRAM
        
            // Pragmas
            #pragma target 4.5
        #pragma exclude_renderers gles3 glcore
        #pragma vertex Vert
        #pragma fragment Frag
        #pragma multi_compile_instancing
        #pragma editor_sync_compilation
        
            // Keywords
            #pragma multi_compile _ LIGHTMAP_ON
        #pragma multi_compile _ DYNAMICLIGHTMAP_ON
        #pragma multi_compile _ DIRLIGHTMAP_COMBINED
        #pragma multi_compile _ USE_LEGACY_LIGHTMAPS
        #pragma multi_compile _ LIGHTMAP_BICUBIC_SAMPLING
        #pragma multi_compile _ REFLECTION_PROBE_ROTATION
        #pragma multi_compile _ _MAIN_LIGHT_SHADOWS _MAIN_LIGHT_SHADOWS_CASCADE _MAIN_LIGHT_SHADOWS_SCREEN
        #pragma multi_compile_fragment _ _SHADOWS_SOFT _SHADOWS_SOFT_LOW _SHADOWS_SOFT_MEDIUM _SHADOWS_SOFT_HIGH
        #pragma multi_compile _ LIGHTMAP_SHADOW_MIXING
        #pragma multi_compile _ _MIXED_LIGHTING_SUBTRACTIVE
        #pragma multi_compile _DECAL_NORMAL_BLEND_LOW _DECAL_NORMAL_BLEND_MEDIUM _DECAL_NORMAL_BLEND_HIGH
        #pragma multi_compile _ _DECAL_LAYERS
        #pragma multi_compile_fragment _ _GBUFFER_NORMALS_OCT
        #pragma multi_compile_fragment _ _RENDER_PASS_ENABLED
            // GraphKeywords: <None>
        
            #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Common.hlsl"
            #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Texture.hlsl"
            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
        
            // Defines
            #define ATTRIBUTES_NEED_NORMAL
            #define ATTRIBUTES_NEED_TANGENT
            #define ATTRIBUTES_NEED_TEXCOORD0
            #define ATTRIBUTES_NEED_TEXCOORD1
            #define ATTRIBUTES_NEED_TEXCOORD2
            #define VARYINGS_NEED_POSITION_WS
            #define VARYINGS_NEED_NORMAL_WS
            #define VARYINGS_NEED_TANGENT_WS
            #define VARYINGS_NEED_TEXCOORD0
            #define VARYINGS_NEED_FOG_AND_VERTEX_LIGHT
            #define VARYINGS_NEED_SH
            #define VARYINGS_NEED_STATIC_LIGHTMAP_UV
            #define VARYINGS_NEED_DYNAMIC_LIGHTMAP_UV
            #define VARYINGS_NEED_SHADOW_COORD
        
            #define HAVE_MESH_MODIFICATION
        
        
            #define SHADERPASS SHADERPASS_DECAL_GBUFFER_MESH
        #define _MATERIAL_AFFECTS_ALBEDO 1
        #define _MATERIAL_AFFECTS_NORMAL 1
        #define _MATERIAL_AFFECTS_NORMAL_BLEND 1
        #define _MATERIAL_AFFECTS_MAOS 1
        #define _MATERIAL_AFFECTS_EMISSION 1
        
            // Includes
            #include_with_pragmas "Packages/com.unity.render-pipelines.universal/ShaderLibrary/DOTS.hlsl"
        #include_with_pragmas "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Fog.hlsl"
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
        #include_with_pragmas "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ProbeVolumeVariants.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/GBufferOutput.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShaderPass.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/DecalInput.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShaderVariablesDecal.hlsl"
        
            // -- Properties used by ScenePickingPass
            #ifdef SCENEPICKINGPASS
            float4 _SelectionID;
            #endif
            #if _RENDER_PASS_ENABLED
            #define GBUFFER3 0
            FRAMEBUFFER_INPUT_X_FLOAT(GBUFFER3);
            #define GBUFFER4 1
            FRAMEBUFFER_INPUT_X_UINT(GBUFFER4);
            #endif
        
            // --------------------------------------------------
            // Structs and Packing
        
            struct Attributes
        {
             float3 positionOS : POSITION;
             float3 normalOS : NORMAL;
             float4 tangentOS : TANGENT;
             float4 uv0 : TEXCOORD0;
             float4 uv1 : TEXCOORD1;
             float4 uv2 : TEXCOORD2;
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
             float3 TangentSpaceNormal;
             float4 uv0;
        };
        struct VertexDescriptionInputs
        {
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
             float4 fogFactorAndVertexLight : INTERP7;
             float3 positionWS : INTERP8;
             float3 normalWS : INTERP9;
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
        float _Alpha_Multiply;
        float _Alpha_Power;
        float4 _BaseColorMap_TexelSize;
        float4 _NormalMap_TexelSize;
        float Normal_Blend;
        float4 _BaseColor;
        float4 _MaskMap_TexelSize;
        float _MetallicRemapMax;
        float _MetallicRemapMin;
        float _AORemapMin;
        float _AORemapMax;
        float _SmoothnessRemapMin;
        float _SmoothnessRemapMax;
        float _MaskBlendSrc;
        float4 _EmissiveColor;
        float4 _EmissiveColorMap_TexelSize;
        float _Alpha_Use_T_Base_Color_A_F_Maskmap_B;
        float _MaskMap_Alpha_Use_T_Base_Color_A_F_Maskmap_B;
        float _DrawOrder;
        float _DecalMeshBiasType;
        float _DecalMeshDepthBias;
        float _DecalMeshViewBias;
        float _DecalAngleFadeSupported;
        UNITY_TEXTURE_STREAMING_DEBUG_VARS;
        CBUFFER_END
        
        
        // Object and Global properties
        SAMPLER(SamplerState_Linear_Repeat);
        TEXTURE2D(_BaseColorMap);
        SAMPLER(sampler_BaseColorMap);
        TEXTURE2D(_NormalMap);
        SAMPLER(sampler_NormalMap);
        TEXTURE2D(_MaskMap);
        SAMPLER(sampler_MaskMap);
        TEXTURE2D(_EmissiveColorMap);
        SAMPLER(sampler_EmissiveColorMap);
        
            // Graph Includes
            // GraphIncludes: <None>
        
            // Graph Functions
            
        void Unity_Multiply_float4_float4(float4 A, float4 B, out float4 Out)
        {
            Out = A * B;
        }
        
        void Unity_Branch_float(float Predicate, float True, float False, out float Out)
        {
            Out = Predicate ? True : False;
        }
        
        void Unity_Multiply_float_float(float A, float B, out float Out)
        {
            Out = A * B;
        }
        
        void Unity_Absolute_float(float In, out float Out)
        {
            Out = abs(In);
        }
        
        void Unity_Power_float(float A, float B, out float Out)
        {
            Out = pow(A, B);
        }
        
        void Unity_Clamp_float(float In, float Min, float Max, out float Out)
        {
            Out = clamp(In, Min, Max);
        }
        
        void Unity_Remap_float(float In, float2 InMinMax, float2 OutMinMax, out float Out)
        {
            Out = OutMinMax.x + (In - InMinMax.x) * (OutMinMax.y - OutMinMax.x) / (InMinMax.y - InMinMax.x);
        }
        
            // Graph Vertex
            struct VertexDescription
        {
        };
        
        VertexDescription VertexDescriptionFunction(VertexDescriptionInputs IN)
        {
            VertexDescription description = (VertexDescription)0;
            return description;
        }
        
            // Graph Pixel
            struct SurfaceDescription
        {
            float3 BaseColor;
            float Alpha;
            float3 NormalTS;
            float NormalAlpha;
            float Metallic;
            float Occlusion;
            float Smoothness;
            float MAOSAlpha;
            float3 Emission;
        };
        
        SurfaceDescription SurfaceDescriptionFunction(SurfaceDescriptionInputs IN)
        {
            SurfaceDescription surface = (SurfaceDescription)0;
            float4 _Property_320fefd883db46679cd769f61b130dd7_Out_0_Vector4 = _BaseColor;
            UnityTexture2D _Property_9f1059a7a93a46ccab349515214f3ed2_Out_0_Texture2D = UnityBuildTexture2DStructNoScale(_BaseColorMap);
            float4 _SampleTexture2D_7388a7ddbf6648ec92c3bb54ed055048_RGBA_0_Vector4 = SAMPLE_TEXTURE2D(_Property_9f1059a7a93a46ccab349515214f3ed2_Out_0_Texture2D.tex, _Property_9f1059a7a93a46ccab349515214f3ed2_Out_0_Texture2D.samplerstate, _Property_9f1059a7a93a46ccab349515214f3ed2_Out_0_Texture2D.GetTransformedUV(IN.uv0.xy) );
            float _SampleTexture2D_7388a7ddbf6648ec92c3bb54ed055048_R_4_Float = _SampleTexture2D_7388a7ddbf6648ec92c3bb54ed055048_RGBA_0_Vector4.r;
            float _SampleTexture2D_7388a7ddbf6648ec92c3bb54ed055048_G_5_Float = _SampleTexture2D_7388a7ddbf6648ec92c3bb54ed055048_RGBA_0_Vector4.g;
            float _SampleTexture2D_7388a7ddbf6648ec92c3bb54ed055048_B_6_Float = _SampleTexture2D_7388a7ddbf6648ec92c3bb54ed055048_RGBA_0_Vector4.b;
            float _SampleTexture2D_7388a7ddbf6648ec92c3bb54ed055048_A_7_Float = _SampleTexture2D_7388a7ddbf6648ec92c3bb54ed055048_RGBA_0_Vector4.a;
            float4 _Multiply_885586d42d884019a5375f12f3c61e52_Out_2_Vector4;
            Unity_Multiply_float4_float4(_Property_320fefd883db46679cd769f61b130dd7_Out_0_Vector4, _SampleTexture2D_7388a7ddbf6648ec92c3bb54ed055048_RGBA_0_Vector4, _Multiply_885586d42d884019a5375f12f3c61e52_Out_2_Vector4);
            float _Property_10cb48b77e114c99a77554a14a36ed9a_Out_0_Float = _Alpha_Multiply;
            float _Property_97f64a9c7748494dbf6dc5b32920f5a5_Out_0_Boolean = _Alpha_Use_T_Base_Color_A_F_Maskmap_B;
            float _Split_da1fca62bd1b452a906195ffb7fa6a18_R_1_Float = _Multiply_885586d42d884019a5375f12f3c61e52_Out_2_Vector4[0];
            float _Split_da1fca62bd1b452a906195ffb7fa6a18_G_2_Float = _Multiply_885586d42d884019a5375f12f3c61e52_Out_2_Vector4[1];
            float _Split_da1fca62bd1b452a906195ffb7fa6a18_B_3_Float = _Multiply_885586d42d884019a5375f12f3c61e52_Out_2_Vector4[2];
            float _Split_da1fca62bd1b452a906195ffb7fa6a18_A_4_Float = _Multiply_885586d42d884019a5375f12f3c61e52_Out_2_Vector4[3];
            UnityTexture2D _Property_b46891aff98b4364a190337410150f10_Out_0_Texture2D = UnityBuildTexture2DStructNoScale(_MaskMap);
            float4 _SampleTexture2D_2dcb30935afc407482bb065c4150e563_RGBA_0_Vector4 = SAMPLE_TEXTURE2D(_Property_b46891aff98b4364a190337410150f10_Out_0_Texture2D.tex, _Property_b46891aff98b4364a190337410150f10_Out_0_Texture2D.samplerstate, _Property_b46891aff98b4364a190337410150f10_Out_0_Texture2D.GetTransformedUV(IN.uv0.xy) );
            float _SampleTexture2D_2dcb30935afc407482bb065c4150e563_R_4_Float = _SampleTexture2D_2dcb30935afc407482bb065c4150e563_RGBA_0_Vector4.r;
            float _SampleTexture2D_2dcb30935afc407482bb065c4150e563_G_5_Float = _SampleTexture2D_2dcb30935afc407482bb065c4150e563_RGBA_0_Vector4.g;
            float _SampleTexture2D_2dcb30935afc407482bb065c4150e563_B_6_Float = _SampleTexture2D_2dcb30935afc407482bb065c4150e563_RGBA_0_Vector4.b;
            float _SampleTexture2D_2dcb30935afc407482bb065c4150e563_A_7_Float = _SampleTexture2D_2dcb30935afc407482bb065c4150e563_RGBA_0_Vector4.a;
            float _Branch_eb932f0ef97d49398f01d62d896b2b60_Out_3_Float;
            Unity_Branch_float(_Property_97f64a9c7748494dbf6dc5b32920f5a5_Out_0_Boolean, _Split_da1fca62bd1b452a906195ffb7fa6a18_A_4_Float, _SampleTexture2D_2dcb30935afc407482bb065c4150e563_B_6_Float, _Branch_eb932f0ef97d49398f01d62d896b2b60_Out_3_Float);
            float _Multiply_3c4f7578756f4e789ded2b826c933b6d_Out_2_Float;
            Unity_Multiply_float_float(_Property_10cb48b77e114c99a77554a14a36ed9a_Out_0_Float, _Branch_eb932f0ef97d49398f01d62d896b2b60_Out_3_Float, _Multiply_3c4f7578756f4e789ded2b826c933b6d_Out_2_Float);
            float _Absolute_cc8840692870447e8bc057dbbf5f18c1_Out_1_Float;
            Unity_Absolute_float(_Multiply_3c4f7578756f4e789ded2b826c933b6d_Out_2_Float, _Absolute_cc8840692870447e8bc057dbbf5f18c1_Out_1_Float);
            float _Property_472619a20fe14990a52e2bbe0c00ea22_Out_0_Float = _Alpha_Power;
            float _Power_55566f012c2d4585bb257e256506056c_Out_2_Float;
            Unity_Power_float(_Absolute_cc8840692870447e8bc057dbbf5f18c1_Out_1_Float, _Property_472619a20fe14990a52e2bbe0c00ea22_Out_0_Float, _Power_55566f012c2d4585bb257e256506056c_Out_2_Float);
            float _Clamp_4788840726ef4518b7a1fc8db3fcdd97_Out_3_Float;
            Unity_Clamp_float(_Power_55566f012c2d4585bb257e256506056c_Out_2_Float, float(0), float(1), _Clamp_4788840726ef4518b7a1fc8db3fcdd97_Out_3_Float);
            UnityTexture2D _Property_360e6833e8d64d75827ab98987b2b545_Out_0_Texture2D = UnityBuildTexture2DStructNoScale(_NormalMap);
            float4 _SampleTexture2D_1300b7cb738f4b18927411750039acd2_RGBA_0_Vector4 = SAMPLE_TEXTURE2D(_Property_360e6833e8d64d75827ab98987b2b545_Out_0_Texture2D.tex, _Property_360e6833e8d64d75827ab98987b2b545_Out_0_Texture2D.samplerstate, _Property_360e6833e8d64d75827ab98987b2b545_Out_0_Texture2D.GetTransformedUV(IN.uv0.xy) );
            _SampleTexture2D_1300b7cb738f4b18927411750039acd2_RGBA_0_Vector4.rgb = UnpackNormal(_SampleTexture2D_1300b7cb738f4b18927411750039acd2_RGBA_0_Vector4);
            float _SampleTexture2D_1300b7cb738f4b18927411750039acd2_R_4_Float = _SampleTexture2D_1300b7cb738f4b18927411750039acd2_RGBA_0_Vector4.r;
            float _SampleTexture2D_1300b7cb738f4b18927411750039acd2_G_5_Float = _SampleTexture2D_1300b7cb738f4b18927411750039acd2_RGBA_0_Vector4.g;
            float _SampleTexture2D_1300b7cb738f4b18927411750039acd2_B_6_Float = _SampleTexture2D_1300b7cb738f4b18927411750039acd2_RGBA_0_Vector4.b;
            float _SampleTexture2D_1300b7cb738f4b18927411750039acd2_A_7_Float = _SampleTexture2D_1300b7cb738f4b18927411750039acd2_RGBA_0_Vector4.a;
            float _Property_e94639b7a37847e1a4616aeed6a21034_Out_0_Boolean = _MaskMap_Alpha_Use_T_Base_Color_A_F_Maskmap_B;
            float _Branch_39df5838709544d2951602a5ba721694_Out_3_Float;
            Unity_Branch_float(_Property_e94639b7a37847e1a4616aeed6a21034_Out_0_Boolean, _Split_da1fca62bd1b452a906195ffb7fa6a18_A_4_Float, _SampleTexture2D_2dcb30935afc407482bb065c4150e563_B_6_Float, _Branch_39df5838709544d2951602a5ba721694_Out_3_Float);
            float _Property_1ed131c6c6bd4d3b9225106c761ab06c_Out_0_Float = Normal_Blend;
            float _Multiply_52cb6c63b083455c8e01c3d5ccd89afc_Out_2_Float;
            Unity_Multiply_float_float(_Branch_39df5838709544d2951602a5ba721694_Out_3_Float, _Property_1ed131c6c6bd4d3b9225106c761ab06c_Out_0_Float, _Multiply_52cb6c63b083455c8e01c3d5ccd89afc_Out_2_Float);
            float _Property_5830ed7c65ef489e93de994fcb2769e2_Out_0_Float = _MetallicRemapMin;
            float _Property_3b33ae94b35943b5bbaa24c03b7069a8_Out_0_Float = _MetallicRemapMax;
            float2 _Vector2_0ad2d19d32894d5e83e19e69d72753fd_Out_0_Vector2 = float2(_Property_5830ed7c65ef489e93de994fcb2769e2_Out_0_Float, _Property_3b33ae94b35943b5bbaa24c03b7069a8_Out_0_Float);
            float _Remap_b3145e45987e489f9b15e9672b41a608_Out_3_Float;
            Unity_Remap_float(_SampleTexture2D_2dcb30935afc407482bb065c4150e563_R_4_Float, float2 (0, 1), _Vector2_0ad2d19d32894d5e83e19e69d72753fd_Out_0_Vector2, _Remap_b3145e45987e489f9b15e9672b41a608_Out_3_Float);
            float _Property_6427dba68c8342eebff5ce521921ddc5_Out_0_Float = _AORemapMin;
            float _Property_f74a95489f364e41b53a083f89ad2365_Out_0_Float = _AORemapMax;
            float2 _Vector2_a00f84e5347b414ca0e9496b9948ba0b_Out_0_Vector2 = float2(_Property_6427dba68c8342eebff5ce521921ddc5_Out_0_Float, _Property_f74a95489f364e41b53a083f89ad2365_Out_0_Float);
            float _Remap_75ea5a896ac148bb8058b60d79c90284_Out_3_Float;
            Unity_Remap_float(_SampleTexture2D_2dcb30935afc407482bb065c4150e563_G_5_Float, float2 (0, 1), _Vector2_a00f84e5347b414ca0e9496b9948ba0b_Out_0_Vector2, _Remap_75ea5a896ac148bb8058b60d79c90284_Out_3_Float);
            float _Property_9d6993415be843799b7ec2e689c5db02_Out_0_Float = _SmoothnessRemapMin;
            float _Property_df4aa91a4fe94e5f8768553f10cd1f82_Out_0_Float = _SmoothnessRemapMax;
            float2 _Vector2_d67e05a1240344f3978c1c9e3cb9525f_Out_0_Vector2 = float2(_Property_9d6993415be843799b7ec2e689c5db02_Out_0_Float, _Property_df4aa91a4fe94e5f8768553f10cd1f82_Out_0_Float);
            float _Remap_ad26abe467c44f5284db4b4203d8242b_Out_3_Float;
            Unity_Remap_float(_SampleTexture2D_2dcb30935afc407482bb065c4150e563_A_7_Float, float2 (0, 1), _Vector2_d67e05a1240344f3978c1c9e3cb9525f_Out_0_Vector2, _Remap_ad26abe467c44f5284db4b4203d8242b_Out_3_Float);
            float _Property_5c661f4099b14a5bac0c24977977340d_Out_0_Float = _MaskBlendSrc;
            float _Multiply_fc69b6805f38404cb402d2a6b2d2b73a_Out_2_Float;
            Unity_Multiply_float_float(_Split_da1fca62bd1b452a906195ffb7fa6a18_A_4_Float, _Property_5c661f4099b14a5bac0c24977977340d_Out_0_Float, _Multiply_fc69b6805f38404cb402d2a6b2d2b73a_Out_2_Float);
            float _Multiply_2f94ef00580f43caa2427a59ed8ca124_Out_2_Float;
            Unity_Multiply_float_float(_Property_5c661f4099b14a5bac0c24977977340d_Out_0_Float, _SampleTexture2D_2dcb30935afc407482bb065c4150e563_B_6_Float, _Multiply_2f94ef00580f43caa2427a59ed8ca124_Out_2_Float);
            float _Branch_753c02949c6b4f128d654534f2d64ced_Out_3_Float;
            Unity_Branch_float(_Property_e94639b7a37847e1a4616aeed6a21034_Out_0_Boolean, _Multiply_fc69b6805f38404cb402d2a6b2d2b73a_Out_2_Float, _Multiply_2f94ef00580f43caa2427a59ed8ca124_Out_2_Float, _Branch_753c02949c6b4f128d654534f2d64ced_Out_3_Float);
            float4 _Property_293317916e0e41cc98bbd5377294091b_Out_0_Vector4 = IsGammaSpace() ? LinearToSRGB(_EmissiveColor) : _EmissiveColor;
            UnityTexture2D _Property_fb3929b3be5f4269845ceb27fb377d12_Out_0_Texture2D = UnityBuildTexture2DStructNoScale(_EmissiveColorMap);
            float4 _SampleTexture2D_d4d6d2f60c614e4c8b681d89316209dc_RGBA_0_Vector4 = SAMPLE_TEXTURE2D(_Property_fb3929b3be5f4269845ceb27fb377d12_Out_0_Texture2D.tex, _Property_fb3929b3be5f4269845ceb27fb377d12_Out_0_Texture2D.samplerstate, _Property_fb3929b3be5f4269845ceb27fb377d12_Out_0_Texture2D.GetTransformedUV(IN.uv0.xy) );
            float _SampleTexture2D_d4d6d2f60c614e4c8b681d89316209dc_R_4_Float = _SampleTexture2D_d4d6d2f60c614e4c8b681d89316209dc_RGBA_0_Vector4.r;
            float _SampleTexture2D_d4d6d2f60c614e4c8b681d89316209dc_G_5_Float = _SampleTexture2D_d4d6d2f60c614e4c8b681d89316209dc_RGBA_0_Vector4.g;
            float _SampleTexture2D_d4d6d2f60c614e4c8b681d89316209dc_B_6_Float = _SampleTexture2D_d4d6d2f60c614e4c8b681d89316209dc_RGBA_0_Vector4.b;
            float _SampleTexture2D_d4d6d2f60c614e4c8b681d89316209dc_A_7_Float = _SampleTexture2D_d4d6d2f60c614e4c8b681d89316209dc_RGBA_0_Vector4.a;
            float4 _Multiply_2fa508cc2b6044e09e63453927d92375_Out_2_Vector4;
            Unity_Multiply_float4_float4(_Property_293317916e0e41cc98bbd5377294091b_Out_0_Vector4, _SampleTexture2D_d4d6d2f60c614e4c8b681d89316209dc_RGBA_0_Vector4, _Multiply_2fa508cc2b6044e09e63453927d92375_Out_2_Vector4);
            surface.BaseColor = (_Multiply_885586d42d884019a5375f12f3c61e52_Out_2_Vector4.xyz);
            surface.Alpha = _Clamp_4788840726ef4518b7a1fc8db3fcdd97_Out_3_Float;
            surface.NormalTS = (_SampleTexture2D_1300b7cb738f4b18927411750039acd2_RGBA_0_Vector4.xyz);
            surface.NormalAlpha = _Multiply_52cb6c63b083455c8e01c3d5ccd89afc_Out_2_Float;
            surface.Metallic = _Remap_b3145e45987e489f9b15e9672b41a608_Out_3_Float;
            surface.Occlusion = _Remap_75ea5a896ac148bb8058b60d79c90284_Out_3_Float;
            surface.Smoothness = _Remap_ad26abe467c44f5284db4b4203d8242b_Out_3_Float;
            surface.MAOSAlpha = _Branch_753c02949c6b4f128d654534f2d64ced_Out_3_Float;
            surface.Emission = (_Multiply_2fa508cc2b6044e09e63453927d92375_Out_2_Vector4.xyz);
            return surface;
        }
        
            // --------------------------------------------------
            // Build Graph Inputs
        
            
        //     $features.graphVertex:  $include("VertexAnimation.template.hlsl")
        //                                       ^ ERROR: $include cannot find file : VertexAnimation.template.hlsl. Looked into:
        // Packages/com.unity.shadergraph/Editor/Generation/Templates
        
            
        //     $features.graphPixel:   $include("SharedCode.template.hlsl")
        //                                       ^ ERROR: $include cannot find file : SharedCode.template.hlsl. Looked into:
        // Packages/com.unity.shadergraph/Editor/Generation/Templates
        
            SurfaceDescriptionInputs BuildSurfaceDescriptionInputs(Varyings input)
        {
            SurfaceDescriptionInputs output;
            ZERO_INITIALIZE(SurfaceDescriptionInputs, output);
        
            /* WARNING: $splice Could not find named fragment 'CustomInterpolatorCopyToSDI' */
        
        
        
            output.TangentSpaceNormal =                         float3(0.0f, 0.0f, 1.0f);
        
        
        
            #if UNITY_UV_STARTS_AT_TOP
            #else
            #endif
        
        
        
        #if defined(UNITY_UIE_INCLUDED)
            output.uv0 =                                        float4(input.texCoord0.x, input.texCoord0.y, 0, 0);
        #else
            output.uv0 =                                        input.texCoord0;
        #endif
            
        
            
            
        #if UNITY_ANY_INSTANCING_ENABLED
        #else // TODO: XR support for procedural instancing because in this case UNITY_ANY_INSTANCING_ENABLED is not defined and instanceID is incorrect.
        #endif
        #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
        #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN                output.FaceSign =                                   IS_FRONT_VFACE(input.cullFace, true, false);
        #else
        #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
        #endif
        #undef BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
        
            return output;
        }
        
            // --------------------------------------------------
            // Build Surface Data
        
            void GetSurfaceData(Varyings input, float4 positionCS, float angleFadeFactor, out DecalSurfaceData surfaceData)
            {
                #if (SHADERPASS == SHADERPASS_DBUFFER_PROJECTOR) || (SHADERPASS == SHADERPASS_FORWARD_EMISSIVE_PROJECTOR) || (SHADERPASS == SHADERPASS_DECAL_SCREEN_SPACE_PROJECTOR) || (SHADERPASS == SHADERPASS_DECAL_GBUFFER_PROJECTOR)
                    half4x4 normalToWorld = UNITY_ACCESS_INSTANCED_PROP(Decal, _NormalToWorld);
                    half fadeFactor = clamp(normalToWorld[0][3], 0.0f, 1.0f) * angleFadeFactor;
                    float2 scale = float2(normalToWorld[3][0], normalToWorld[3][1]);
                    float2 offset = float2(normalToWorld[3][2], normalToWorld[3][3]);
                    input.texCoord0.xy = input.texCoord0.xy * scale + offset;
                    half3 normalWS = TransformObjectToWorldDir(half3(0, 1, 0));
                    half3 tangentWS = TransformObjectToWorldDir(half3(1, 0, 0));
                    half3 bitangentWS = TransformObjectToWorldDir(half3(0, 0, 1));
                    half sign = dot(cross(normalWS, tangentWS), bitangentWS) > 0 ? 1 : -1;
                    input.normalWS.xyz = normalWS;
                    input.tangentWS.xyzw = half4(tangentWS, sign);
                #else
                    #if defined(LOD_FADE_CROSSFADE) && USE_UNITY_CROSSFADE
                        LODFadeCrossFade(positionCS);
                    #endif
        
                    half fadeFactor = half(1.0);
                #endif
        
                SurfaceDescriptionInputs surfaceDescriptionInputs = BuildSurfaceDescriptionInputs(input);
                SurfaceDescription surfaceDescription = SurfaceDescriptionFunction(surfaceDescriptionInputs);
        
                // setup defaults -- these are used if the graph doesn't output a value
                ZERO_INITIALIZE(DecalSurfaceData, surfaceData);
                surfaceData.occlusion = half(1.0);
                surfaceData.smoothness = half(0);
        
                #ifdef _MATERIAL_AFFECTS_NORMAL
                    surfaceData.normalWS.w = half(1.0);
                #else
                    surfaceData.normalWS.w = half(0.0);
                #endif
        
                surfaceData.emissive.rgb = half3(surfaceDescription.Emission.rgb * fadeFactor);
        
                // copy across graph values, if defined
                surfaceData.baseColor.xyz = half3(surfaceDescription.BaseColor);
                surfaceData.baseColor.w = half(surfaceDescription.Alpha * fadeFactor);
        
                #if (SHADERPASS == SHADERPASS_DBUFFER_PROJECTOR) || (SHADERPASS == SHADERPASS_DECAL_SCREEN_SPACE_PROJECTOR) || (SHADERPASS == SHADERPASS_DECAL_GBUFFER_PROJECTOR)
                    #if defined(_MATERIAL_AFFECTS_NORMAL)
                        surfaceData.normalWS.xyz = normalize(mul((half3x3)normalToWorld, surfaceDescription.NormalTS.xyz));
                    #else
                        surfaceData.normalWS.xyz = normalize(normalToWorld[2].xyz);
                    #endif
                #elif (SHADERPASS == SHADERPASS_DBUFFER_MESH) || (SHADERPASS == SHADERPASS_DECAL_SCREEN_SPACE_MESH) || (SHADERPASS == SHADERPASS_DECAL_GBUFFER_MESH)
                    #if defined(_MATERIAL_AFFECTS_NORMAL)
                        float sgn = input.tangentWS.w;      // should be either +1 or -1
                        float3 bitangent = sgn * cross(input.normalWS.xyz, input.tangentWS.xyz);
                        half3x3 tangentToWorld = half3x3(input.tangentWS.xyz, bitangent.xyz, input.normalWS.xyz);
        
                        // We need to normalize as we use mikkt tangent space and this is expected (tangent space is not normalize)
                        surfaceData.normalWS.xyz = normalize(TransformTangentToWorld(surfaceDescription.NormalTS, tangentToWorld));
                    #else
                        surfaceData.normalWS.xyz = normalize(half3(input.normalWS)); // Default to vertex normal
                    #endif
                #endif
        
                surfaceData.normalWS.w = surfaceDescription.NormalAlpha * fadeFactor;
        
                // In case of Smoothness / AO / Metal, all the three are always computed but color mask can change
                surfaceData.metallic = half(surfaceDescription.Metallic);
                surfaceData.occlusion = half(surfaceDescription.Occlusion);
                surfaceData.smoothness = half(surfaceDescription.Smoothness);
                surfaceData.MAOSAlpha = half(surfaceDescription.MAOSAlpha * fadeFactor);
            }
        
            // --------------------------------------------------
            // Main
        
            #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/Varyings.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShaderPassDecal.hlsl"
        
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
            Cull Back
        
            // Debug
            // <None>
        
            // --------------------------------------------------
            // Pass
        
            HLSLPROGRAM
        
            // Pragmas
            #pragma target 2.0
        #pragma multi_compile_instancing
        #pragma editor_sync_compilation
        #pragma vertex Vert
        #pragma fragment Frag
        
            // Keywords
            // PassKeywords: <None>
            // GraphKeywords: <None>
        
            #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Common.hlsl"
            #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Texture.hlsl"
            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
        
            // Defines
        
            #define HAVE_MESH_MODIFICATION
        
        
            #define SHADERPASS SHADERPASS_DEPTHONLY
        #define SCENEPICKINGPASS 1
        
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
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/DecalInput.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShaderVariablesDecal.hlsl"
        
            // -- Properties used by ScenePickingPass
            #ifdef SCENEPICKINGPASS
            float4 _SelectionID;
            #endif
            #if _RENDER_PASS_ENABLED
            #define GBUFFER3 0
            FRAMEBUFFER_INPUT_X_FLOAT(GBUFFER3);
            #define GBUFFER4 1
            FRAMEBUFFER_INPUT_X_UINT(GBUFFER4);
            #endif
        
            // --------------------------------------------------
            // Structs and Packing
        
            struct Attributes
        {
             float3 positionOS : POSITION;
            #if UNITY_ANY_INSTANCING_ENABLED || defined(ATTRIBUTES_NEED_INSTANCEID)
             uint instanceID : INSTANCEID_SEMANTIC;
            #endif
        };
        struct Varyings
        {
             float4 positionCS : SV_POSITION;
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
        };
        struct VertexDescriptionInputs
        {
        };
        struct PackedVaryings
        {
             float4 positionCS : SV_POSITION;
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
        float _Alpha_Multiply;
        float _Alpha_Power;
        float4 _BaseColorMap_TexelSize;
        float4 _NormalMap_TexelSize;
        float Normal_Blend;
        float4 _BaseColor;
        float4 _MaskMap_TexelSize;
        float _MetallicRemapMax;
        float _MetallicRemapMin;
        float _AORemapMin;
        float _AORemapMax;
        float _SmoothnessRemapMin;
        float _SmoothnessRemapMax;
        float _MaskBlendSrc;
        float4 _EmissiveColor;
        float4 _EmissiveColorMap_TexelSize;
        float _Alpha_Use_T_Base_Color_A_F_Maskmap_B;
        float _MaskMap_Alpha_Use_T_Base_Color_A_F_Maskmap_B;
        float _DrawOrder;
        float _DecalMeshBiasType;
        float _DecalMeshDepthBias;
        float _DecalMeshViewBias;
        float _DecalAngleFadeSupported;
        UNITY_TEXTURE_STREAMING_DEBUG_VARS;
        CBUFFER_END
        
        
        // Object and Global properties
        SAMPLER(SamplerState_Linear_Repeat);
        TEXTURE2D(_BaseColorMap);
        SAMPLER(sampler_BaseColorMap);
        TEXTURE2D(_NormalMap);
        SAMPLER(sampler_NormalMap);
        TEXTURE2D(_MaskMap);
        SAMPLER(sampler_MaskMap);
        TEXTURE2D(_EmissiveColorMap);
        SAMPLER(sampler_EmissiveColorMap);
        
            // Graph Includes
            // GraphIncludes: <None>
        
            // Graph Functions
            // GraphFunctions: <None>
        
            // Graph Vertex
            struct VertexDescription
        {
        };
        
        VertexDescription VertexDescriptionFunction(VertexDescriptionInputs IN)
        {
            VertexDescription description = (VertexDescription)0;
            return description;
        }
        
            // Graph Pixel
            struct SurfaceDescription
        {
        };
        
        SurfaceDescription SurfaceDescriptionFunction(SurfaceDescriptionInputs IN)
        {
            SurfaceDescription surface = (SurfaceDescription)0;
            return surface;
        }
        
            // --------------------------------------------------
            // Build Graph Inputs
        
            
        //     $features.graphVertex:  $include("VertexAnimation.template.hlsl")
        //                                       ^ ERROR: $include cannot find file : VertexAnimation.template.hlsl. Looked into:
        // Packages/com.unity.shadergraph/Editor/Generation/Templates
        
            
        //     $features.graphPixel:   $include("SharedCode.template.hlsl")
        //                                       ^ ERROR: $include cannot find file : SharedCode.template.hlsl. Looked into:
        // Packages/com.unity.shadergraph/Editor/Generation/Templates
        
            SurfaceDescriptionInputs BuildSurfaceDescriptionInputs(Varyings input)
        {
            SurfaceDescriptionInputs output;
            ZERO_INITIALIZE(SurfaceDescriptionInputs, output);
        
            /* WARNING: $splice Could not find named fragment 'CustomInterpolatorCopyToSDI' */
        
        
        
        
        
        
            #if UNITY_UV_STARTS_AT_TOP
            #else
            #endif
        
        
        
        #if defined(UNITY_UIE_INCLUDED)
        #else
        #endif
            
        
            
            
        #if UNITY_ANY_INSTANCING_ENABLED
        #else // TODO: XR support for procedural instancing because in this case UNITY_ANY_INSTANCING_ENABLED is not defined and instanceID is incorrect.
        #endif
        #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
        #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN                output.FaceSign =                                   IS_FRONT_VFACE(input.cullFace, true, false);
        #else
        #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
        #endif
        #undef BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
        
            return output;
        }
        
            // --------------------------------------------------
            // Build Surface Data
        
            void GetSurfaceData(Varyings input, float4 positionCS, float angleFadeFactor, out DecalSurfaceData surfaceData)
            {
                #if (SHADERPASS == SHADERPASS_DBUFFER_PROJECTOR) || (SHADERPASS == SHADERPASS_FORWARD_EMISSIVE_PROJECTOR) || (SHADERPASS == SHADERPASS_DECAL_SCREEN_SPACE_PROJECTOR) || (SHADERPASS == SHADERPASS_DECAL_GBUFFER_PROJECTOR)
                    half4x4 normalToWorld = UNITY_ACCESS_INSTANCED_PROP(Decal, _NormalToWorld);
                    half fadeFactor = clamp(normalToWorld[0][3], 0.0f, 1.0f) * angleFadeFactor;
                    float2 scale = float2(normalToWorld[3][0], normalToWorld[3][1]);
                    float2 offset = float2(normalToWorld[3][2], normalToWorld[3][3]);
                    half3 normalWS = TransformObjectToWorldDir(half3(0, 1, 0));
                    half3 tangentWS = TransformObjectToWorldDir(half3(1, 0, 0));
                    half3 bitangentWS = TransformObjectToWorldDir(half3(0, 0, 1));
                    half sign = dot(cross(normalWS, tangentWS), bitangentWS) > 0 ? 1 : -1;
                #else
                    #if defined(LOD_FADE_CROSSFADE) && USE_UNITY_CROSSFADE
                        LODFadeCrossFade(positionCS);
                    #endif
        
                    half fadeFactor = half(1.0);
                #endif
        
                SurfaceDescriptionInputs surfaceDescriptionInputs = BuildSurfaceDescriptionInputs(input);
                SurfaceDescription surfaceDescription = SurfaceDescriptionFunction(surfaceDescriptionInputs);
        
                // setup defaults -- these are used if the graph doesn't output a value
                ZERO_INITIALIZE(DecalSurfaceData, surfaceData);
                surfaceData.occlusion = half(1.0);
                surfaceData.smoothness = half(0);
        
                #ifdef _MATERIAL_AFFECTS_NORMAL
                    surfaceData.normalWS.w = half(1.0);
                #else
                    surfaceData.normalWS.w = half(0.0);
                #endif
        
        
                // copy across graph values, if defined
        
                #if (SHADERPASS == SHADERPASS_DBUFFER_PROJECTOR) || (SHADERPASS == SHADERPASS_DECAL_SCREEN_SPACE_PROJECTOR) || (SHADERPASS == SHADERPASS_DECAL_GBUFFER_PROJECTOR)
                    #if defined(_MATERIAL_AFFECTS_NORMAL)
                    #else
                        surfaceData.normalWS.xyz = normalize(normalToWorld[2].xyz);
                    #endif
                #elif (SHADERPASS == SHADERPASS_DBUFFER_MESH) || (SHADERPASS == SHADERPASS_DECAL_SCREEN_SPACE_MESH) || (SHADERPASS == SHADERPASS_DECAL_GBUFFER_MESH)
                    #if defined(_MATERIAL_AFFECTS_NORMAL)
                        float sgn = input.tangentWS.w;      // should be either +1 or -1
                        float3 bitangent = sgn * cross(input.normalWS.xyz, input.tangentWS.xyz);
                        half3x3 tangentToWorld = half3x3(input.tangentWS.xyz, bitangent.xyz, input.normalWS.xyz);
        
                        // We need to normalize as we use mikkt tangent space and this is expected (tangent space is not normalize)
                    #else
                        surfaceData.normalWS.xyz = normalize(half3(input.normalWS)); // Default to vertex normal
                    #endif
                #endif
        
        
                // In case of Smoothness / AO / Metal, all the three are always computed but color mask can change
            }
        
            // --------------------------------------------------
            // Main
        
            #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/Varyings.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShaderPassDecal.hlsl"
        
            ENDHLSL
        }
    }
    CustomEditor "UnityEditor.ShaderGraph.GenericShaderGraphMaterialGUI"
    CustomEditorForRenderPipeline "UnityEditor.Rendering.Universal.DecalShaderGraphGUI" "UnityEngine.Rendering.Universal.UniversalRenderPipelineAsset"
    FallBack "Hidden/Shader Graph/FallbackError"
}