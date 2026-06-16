#ifndef _DF_SKYBOX_BLENDING
#define _DF_SKYBOX_BLENDING

    UNITY_DECLARE_SCREENSPACE_TEXTURE(_DynamicFogSkybox);

    void PostFog(inout fixed4 color, v2f i) {
        #if SKYBOX_BLENDING
            float2 uv = i.uv;
            uv.y = 1.0 - uv.y;
            fixed4 skybox = UNITY_SAMPLE_SCREENSPACE_TEXTURE(_DynamicFogSkybox, uv);
            color = lerp(color, skybox, color.a);
        #endif
    }

	
#endif // _DF_SKYBOX_BLENDING