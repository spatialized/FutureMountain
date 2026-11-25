Shader "Hidden/Nature Manufacture/WaterDepthMaskBlit"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
    }
    SubShader
    {
        Tags
        {
            "RenderType"="Opaque"
        }

        //pass 0 Waterline Mask
        Pass
        {
            Name "WaterDepthMaskBlit"
            ZTest Always
            Cull Off
            ZWrite Off

            CGPROGRAM
            #pragma vertex Vert
            #pragma fragment Frag

            sampler2D _MainTex;
            sampler2D _OldTex;


            float4x4 _ViewPosition;
            float3 _Near;
            float3 _Far;
            float _WaterLineBlurSize;
            float _DropletsMaskDecay;

            float _ScreenHeight;

            float _InvertMask;

            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
            };

            struct v2f
            {
                float4 pos : SV_POSITION;
                float2 uv : TEXCOORD0;
            };

            float3 InverseLerp3(float3 from, float3 to, float3 value)
            {
                float3 result;
                result.x = (value.x - from.x) / (to.x - from.x);
                result.y = (value.y - from.y) / (to.y - from.y);
                result.z = (value.z - from.z) / (to.z - from.z);
                return result;
            }


            float InverseLerp(float from, float to, float value)
            {
                return (value - from) / (to - from);
            }

            float3 GetWorldPosition(float4x4 viewPos, float2 uv)
            {
                float3 c0 = float3(viewPos._m00, viewPos._m10, viewPos._m20); // bottom-left
                float3 c1 = float3(viewPos._m01, viewPos._m11, viewPos._m21); // bottom-right
                float3 c2 = float3(viewPos._m02, viewPos._m12, viewPos._m22); // top-left
                float3 c3 = float3(viewPos._m03, viewPos._m13, viewPos._m23); // top-right

                float3 bottom = lerp(c0, c1, uv.x);
                float3 top = lerp(c2, c3, uv.x);
                return lerp(bottom, top, uv.y);
            }

            v2f Vert(appdata v)
            {
                v2f o;
                o.pos = UnityObjectToClipPos(v.vertex);


                o.uv = v.uv;
                return o;
            }

            float4 Frag(v2f i) : COLOR
            {
                float3 worldPosition = GetWorldPosition(_ViewPosition, i.uv);

                float3 positionDepth = InverseLerp3(_Far, _Near, worldPosition);

                float d = tex2D(_MainTex, float2(positionDepth.x, positionDepth.z)).r;

                float mask = step(d, positionDepth.y);
                //float mask = step(12, worldPosition.y);
                float frustumLength = _Near.y - _Far.y;
                float maskLine = abs(d - positionDepth.y) * frustumLength;
                maskLine = smoothstep(_WaterLineBlurSize, 0, maskLine);

                float4 oldMask = tex2D(_OldTex, i.uv);

                // float dropletsMask = oldMask.r + lerp(oldMask.b,0, _DropletsMaskDecay);
                float decayed = max(0.0, oldMask.b - _DropletsMaskDecay * unity_DeltaTime.x);
                float dropletsMask = max(1.0 - mask, decayed);

                return float4(1-mask, maskLine, dropletsMask, 1);
            }
            ENDCG
        }
    }
    Fallback Off
}