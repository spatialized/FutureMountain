using System;
using Unity.Mathematics;
using UnityEngine;

namespace NatureManufacture.RAM
{
    public class SeaPhysicsCalculations
    {
        private const float UnityPI = 3.14159265359f;
        private float4 _gerstnerDirection1;
        private float4 _gerstnerDirection4;
        private float4 _gerstnerDirection5;
        private float4 _gerstner1;
        private float4 _gerstner2;
        private float _globalTiling;
        private float4 _macroWaveTiling;
        private float _macroWaveTessScale;
        private float4 _polarWaveDepthStartXFlattenPointY;
        private float _polarWaveSilentAreaAngleHardness;
        private float _polarWaveSilentAreaAngle;
        private float _polarWaveSwashSize;
        private float4 _seaFoamSlopeInfluence;
        private float4 _seaWaveDepthFlattenStartXEndY;
        private float _seaWaveNoiseMultiply;
        private float _seaWaveNoisePower;
        private float4 _seaWaveNoiseTiling;
        private float _seaWaveSwashSize;
        private float _seaWavesChaos;
        private float4 _slowWaterMixSpeed;
        private float _slowWaterTessScale;
        private float4 _slowWaterTiling;
        private float4 _slowWaterSpeed;
        private float _slowNormalScale;
        private float4 _smallWaveNoiseTiling;
        private float _smallWaveNoiseMultiply;
        private float _smallWaveNoisePower;
        private float _smallWaveShoreHeightMultiply;
        private float4 _smallWaveShoreDepthStartXFlattenPointY;
        private float _smallWaveSilentAreaAngleHardness;
        private float _smallWaveSilentAreaAngle;
        private float _smallWaveSwashSize;
        
        private float _polarAndSmallWavesFrictionDepthMask;
        private float _polarAndSmallWavesFrictionDepthMaskPower;
        private float _polarAndSmallWavesFrictionSpeedReduction;

        private float _smallWavesChaos;
        private float _timeOffset;
        private float _waterFlowUVRefresSpeed;
        private bool _uvvdirection1Udirection0On = false;
        private Texture2D _slowWaterNormal;
        private Texture2D _slowWaterTesselation;
        private Texture2D _wavesNoise;

        private float time = 0;
        private float oldTime;


        public void GetShaderTime()
        {
            time = oldTime;
            //Debug.Log($"time: {time} Time.timeSinceLevelLoad: {Time.timeSinceLevelLoad} shader time: {Shader.GetGlobalVector("_Time").y}");
            oldTime = Time.timeSinceLevelLoad;
            // time = 0;
        }

        public void GetMaterialData(Material seaMaterial)
        {
            _gerstnerDirection1 = seaMaterial.GetVector("_GerstnerDirection_1");
            _gerstnerDirection4 = seaMaterial.GetVector("_GerstnerDirection_4");
            _gerstnerDirection5 = seaMaterial.GetVector("_GerstnerDirection_5");
            _gerstner1 = seaMaterial.GetVector("_Gerstner_1");
            _gerstner2 = seaMaterial.GetVector("_Gerstner_2");
            _globalTiling = seaMaterial.GetFloat("_GlobalTiling");
            _macroWaveTiling = seaMaterial.GetVector("_MacroWaveTiling");
            _macroWaveTessScale = seaMaterial.GetFloat("MacroWaveTessScale");
            _polarWaveDepthStartXFlattenPointY = seaMaterial.GetVector("_Polar_Wave_Depth_Start_X_Flatten_Point_Y");
            _polarWaveSilentAreaAngleHardness = seaMaterial.GetFloat("_Polar_Wave_Silent_Area_Angle_Hardness");
            _polarWaveSilentAreaAngle = seaMaterial.GetFloat("_Polar_Wave_Silent_Area_Angle");
            _polarWaveSwashSize = seaMaterial.GetFloat("_Polar_Wave_Swash_Size");
            _seaFoamSlopeInfluence = seaMaterial.GetVector("_Sea_Foam_Slope_Influence");
            _seaWaveDepthFlattenStartXEndY = seaMaterial.GetVector("_Sea_Wave_Depth_Flatten_Start_X_End_Y");
            _seaWaveNoiseMultiply = seaMaterial.GetFloat("_Sea_Wave_Noise_Multiply");
            _seaWaveNoisePower = seaMaterial.GetFloat("_Sea_Wave_Noise_Power");
            _seaWaveNoiseTiling = seaMaterial.GetVector("_Sea_Wave_Noise_Tiling");
            _seaWaveSwashSize = seaMaterial.GetFloat("_Sea_Wave_Swash_Size");
            _seaWavesChaos = seaMaterial.GetFloat("_Sea_Waves_Chaos");
            _slowWaterMixSpeed = seaMaterial.GetVector("_SlowWaterMixSpeed");
            _slowWaterTessScale = seaMaterial.GetFloat("_SlowWaterTessScale");
            _slowWaterTiling = seaMaterial.GetVector("_SlowWaterTiling");
            _slowWaterSpeed = seaMaterial.GetVector("_SlowWaterSpeed");
            _slowNormalScale = seaMaterial.GetFloat("_SlowNormalScale");
            _smallWaveNoiseTiling = seaMaterial.GetVector("_Small_Wave_Noise_Tiling");
            _smallWaveNoiseMultiply = seaMaterial.GetFloat("_Small_Wave_Noise_Multiply");
            _smallWaveNoisePower = seaMaterial.GetFloat("_Small_Wave_Noise_Power");
            _smallWaveShoreHeightMultiply = seaMaterial.GetFloat("_Small_Wave_Shore_Height_Multiply");
            _smallWaveShoreDepthStartXFlattenPointY = seaMaterial.GetVector("_Small_Wave_Shore_Depth_Start_X_Flatten_Point_Y");
            _smallWaveSilentAreaAngleHardness = seaMaterial.GetFloat("_Small_Wave_Silent_Area_Angle_Hardness");
            _smallWaveSilentAreaAngle = seaMaterial.GetFloat("_Small_Wave_Silent_Area_Angle");
            _smallWaveSwashSize = seaMaterial.GetFloat("_Small_Wave_Swash_Size");
            
            _polarAndSmallWavesFrictionDepthMask = seaMaterial.GetFloat("_Polar_and_Small_Waves_Friction_Depth_Mask");
            _polarAndSmallWavesFrictionDepthMaskPower = seaMaterial.GetFloat("_Polar_and_Small_Waves_Friction_Depth_Mask_Power");
            _polarAndSmallWavesFrictionSpeedReduction = seaMaterial.GetFloat("_Polar_and_Small_Waves_Friction_Speed_Reduction");
            _smallWavesChaos = seaMaterial.GetFloat("_Small_Waves_Chaos");
            _timeOffset = seaMaterial.GetFloat("_Time_Offset");
            _waterFlowUVRefresSpeed = seaMaterial.GetFloat("_WaterFlowUVRefresSpeed");
            _uvvdirection1Udirection0On = seaMaterial.GetFloat("_UVVDirection1UDirection0") == 1;

            _slowWaterNormal = (Texture2D)seaMaterial.GetTexture("_SlowWaterNormal");
            _slowWaterTesselation = (Texture2D)seaMaterial.GetTexture("_SlowWaterTesselation");
            _wavesNoise = (Texture2D)seaMaterial.GetTexture("_Waves_Noise");
        }

        private static float3 UnpackScaleNormal(float4 packedNormal, float bumpScale)
        {
            packedNormal.x *= packedNormal.w;

            var unpackedNormal = new float3(0, 0, 0)
            {
                xy = (packedNormal.xy * 2 - 1)
            };

            unpackedNormal.xy *= bumpScale;

            unpackedNormal.z = math.sqrt(1.0f - math.saturate(math.dot(unpackedNormal.xy, unpackedNormal.xy)));
            return unpackedNormal;
        }

        private static float4 SAMPLE_TEXTURE2D_LOD(Texture2D texture, float2 uv)
        {
            Color color = texture.GetPixelBilinear(uv.x, uv.y);

            return new float4(color.r, color.g, color.b, color.a);
        }

        public SeaPhysics.PositionNormal VertexDataFuncV2Normal(float3 vertex, float4 tangent, float3 normal, float4 texcoord, float4 texcoord3, float3 aseWorldPos, float3 aseWorldNormal)
        {
            var appendResult861 = new float2(texcoord3.x, texcoord3.y);

            float cos864 = math.cos((_gerstnerDirection5.z * _seaWavesChaos + 180.0f) * 0.01745f);
            float sin864 = math.sin((_gerstnerDirection5.z * _seaWavesChaos + 180.0f) * 0.01745f);
            float2 rotator864 = math.mul(appendResult861, new float2x2(cos864, -sin864, sin864, cos864));

            float2 ifLocalVar77G51 = math.length(rotator864) == 0.0f ? new float2(0.001f, 0) : rotator864;


            float2 normalizeResult79G51 = math.normalize(ifLocalVar77G51);

            float tempOutput8160 = (texcoord3.w - _seaWaveDepthFlattenStartXEndY.y) /
                                   (_seaWaveDepthFlattenStartXEndY.x - _seaWaveDepthFlattenStartXEndY.y);
            float clampResult823 = math.clamp(tempOutput8160, 0.0f, 1.0f);
            float clampResult833 =
                math.clamp(
                    _gerstnerDirection5.y + (clampResult823 - 0.0f) * (math.max(clampResult823 * _gerstnerDirection5.x, _gerstnerDirection5.y) - _gerstnerDirection5.y) /
                    (1.0f - 0.0f), 0.0f, 1.0f);


            float clampResult44G155 = math.clamp(math.abs(aseWorldNormal.y), 0.0f, 1.0f);
            float2 tempOutput8010 = _seaWaveNoiseTiling.xy / new float2(1, 1);
            float2 clampResult800 = math.clamp(tempOutput8010, new float2(0.001f, 0.001f), new float2(500, 500));
            float2 tempOutput530G155 = ((1.0f - clampResult44G155) * new float2(1, 1) + new float2(1, 1) / clampResult800 * new float2(1.8f, 1.8f)) * tempOutput8010 * texcoord3.xy;
            var appendResult57G155 = new float2(tempOutput530G155.y, tempOutput530G155.x);

            float2 staticSwitch59G155 = _uvvdirection1Udirection0On ? tempOutput530G155 : appendResult57G155;

            float tempOutput680G155 = time * 0.07f;
            float tempOutput710G155 = math.frac(tempOutput680G155);
            float2 tempOutput600G155 = staticSwitch59G155 * tempOutput710G155;
            float globalTiling70 = _globalTiling;
            float2 tempOutput830G155 = 1.0f / globalTiling70 * (tempOutput8010 * texcoord.xy);
            float2 tempOutput800G155 = staticSwitch59G155 * math.frac(tempOutput680G155 + -0.5f);
            float clampResult90G155 = math.clamp(math.abs(math.sin(UnityPI * 1.5f + tempOutput710G155 * UnityPI)), 0.0f, 1.0f);
            float lerpResult791 = math.lerp(SAMPLE_TEXTURE2D_LOD(_wavesNoise, tempOutput600G155 + tempOutput830G155).x, SAMPLE_TEXTURE2D_LOD(_wavesNoise, tempOutput830G155 + tempOutput800G155).x,
                clampResult90G155);

            float clampResult807 = math.clamp(math.pow(math.abs(lerpResult791), _seaWaveNoisePower) * _seaWaveNoiseMultiply, 0.0f, 1.0f);
            float clampResult827 = math.clamp(1.0f - (0.05f + (clampResult807 - 0.0f) * (0.97f - 0.05f) / (1.0f - 0.0f)), 0.0f, 1.0f);
            float tempOutput8320 = clampResult833 * clampResult827;
            float2 polarWaveDepthStartXFlattenPointY732 = _polarWaveDepthStartXFlattenPointY.xy;
            float clampResult884 = math.clamp(texcoord3.w - polarWaveDepthStartXFlattenPointY732.y, 0.0f, 1.0f);
            float clampResult886 = math.clamp(1.0f + (texcoord3.w - polarWaveDepthStartXFlattenPointY732.y) * (0.0f - 1.0f) / (polarWaveDepthStartXFlattenPointY732.x - polarWaveDepthStartXFlattenPointY732.y), 0.0f,
                1.0f);
            float clampResult890 = math.clamp(_gerstnerDirection1.y + (clampResult884 - 0.0f) * (_gerstnerDirection1.x * clampResult886 - _gerstnerDirection1.y) / (1.0f - 0.0f), 0.0f, 1.0f);
            var appendResult1009 = new float2(texcoord3.x, texcoord3.y);
            float2 normalizeResult1014 = math.normalize(appendResult1009 * new float2(1, -1));
            var appendResult1011 = new float2(texcoord.z, texcoord.w);
            float2 normalizeResult1015 = math.normalize(appendResult1011);
            float dotResult1016 = math.dot(normalizeResult1014, normalizeResult1015);
            float clampResult1022 = math.clamp((dotResult1016 - -1.0f) / (1.0f - -1.0f) + (_polarWaveSilentAreaAngle + -180.0f) / 180.0f, 0.0f, 1.0f);
            float clampResult1024 = math.clamp(1.0f - clampResult1022, 0.0f, 1.0f);
            float clampResult1028 = math.clamp(math.pow(math.abs(clampResult1024), _polarWaveSilentAreaAngleHardness), 0.0f, 1.0f);
            float clampResult44G156 = math.clamp(math.abs(aseWorldNormal.y), 0.0f, 1.0f);
            float2 tempOutput7790 = _smallWaveNoiseTiling.xy / new float2(1, 1);
            float2 clampResult780 = math.clamp(tempOutput7790, new float2(0.001f, 0.001f), new float2(500, 500));
            float2 tempOutput530G156 = ((1.0f - clampResult44G156) * new float2(1, 1) + new float2(1, 1) / clampResult780 * new float2(2, 2)) * tempOutput7790 * texcoord3.xy;
            var appendResult57G156 = new float2(tempOutput530G156.y, tempOutput530G156.x);


            float2 staticSwitch59G156 = _uvvdirection1Udirection0On ? tempOutput530G156 : appendResult57G156;

            float tempOutput680G156 = time * 0.05f;
            float tempOutput710G156 = math.frac(tempOutput680G156);
            float2 tempOutput600G156 = staticSwitch59G156 * tempOutput710G156;
            float2 tempOutput830G156 = 1.0f / globalTiling70 * (tempOutput7790 * texcoord.xy);
            float2 tempOutput800G156 = staticSwitch59G156 * math.frac(tempOutput680G156 + -0.5f);
            float clampResult90G156 = math.clamp(math.abs(math.sin(UnityPI * 1.5f + tempOutput710G156 * UnityPI)), 0.0f, 1.0f);
            float lerpResult772 = math.lerp(SAMPLE_TEXTURE2D_LOD(_wavesNoise, tempOutput600G156 + tempOutput830G156).x, SAMPLE_TEXTURE2D_LOD(_wavesNoise, tempOutput830G156 + tempOutput800G156).x,
                clampResult90G156);

            float clampResult787 = math.clamp(math.pow(math.abs(lerpResult772), _smallWaveNoisePower) * _smallWaveNoiseMultiply, 0.0f, 1.0f);
            float tempOutput7880 = (clampResult787 - 0.0f) * (0.97f - 0.0f) / (1.0f - 0.0f);
            float clampResult897 = math.clamp(1.0f - tempOutput7880, 0.0f, 1.0f);
            float tempOutput8950 = clampResult890 * (clampResult1028 * 1.0f) * clampResult897;
            float clampResult824 =
                math.clamp(
                    _gerstnerDirection4.y + (clampResult823 - 0.0f) * (math.max(clampResult823 * _gerstnerDirection4.x, _gerstnerDirection4.y) - _gerstnerDirection4.y) /
                    (1.0f - 0.0f), 0.0f, 1.0f);
            float tempOutput8250 = clampResult824 * clampResult827;
            float2 smallWaveShoreDepthStartXFlattenPointY733 = _smallWaveShoreDepthStartXFlattenPointY.xy;
            float clampResult968 = math.clamp(texcoord3.w - smallWaveShoreDepthStartXFlattenPointY733.y, 0.0f, 1.0f);
            float clampResult950 = math.clamp(
                1.0f + (texcoord3.w - smallWaveShoreDepthStartXFlattenPointY733.y) * (0.0f - 1.0f) / (smallWaveShoreDepthStartXFlattenPointY733.x - smallWaveShoreDepthStartXFlattenPointY733.y),
                0.0f, 1.0f);
            float clampResult983 =
                math.clamp(
                    _gerstner1.y + (clampResult968 - 0.0f) * (_gerstner1.x + _smallWaveShoreHeightMultiply * _gerstner1.x * clampResult950 - _gerstner1.y) /
                    (1.0f - 0.0f), 0.0f, 1.0f);
            float clampResult985 = math.clamp(1.0f - tempOutput7880, 0.0f, 1.0f);
            float clampResult1007 = math.clamp(tempOutput8160, 0.0f, 1.0f);
            float tempOutput10080 = 1.0f - clampResult1007;
            float tempOutput9330 = _gerstner1.z * _smallWavesChaos;
            float cos1034 = math.cos(tempOutput9330 * 0.01745f);
            float sin1034 = math.sin(tempOutput9330 * 0.01745f);
            float2 rotator1034 = math.mul(normalizeResult1014, new float2x2(cos1034, -sin1034, sin1034, cos1034));
            float2 normalizeResult1038 = math.normalize(rotator1034);
            float dotResult1040 = math.dot(normalizeResult1038, normalizeResult1015);
            float tempOutput10450 = (_smallWaveSilentAreaAngle + -180.0f) / 180.0f;
            float clampResult1051 = math.clamp(tempOutput10080 * ((dotResult1040 - -1.0f) / (1.0f - -1.0f) + tempOutput10450), 0.0f, 1.0f);
            float clampResult1055 = math.clamp(1.0f - clampResult1051, 0.0f, 1.0f);
            float clampResult1062 = math.clamp(math.pow(math.abs(clampResult1055), _smallWaveSilentAreaAngleHardness), 0.0f, 1.0f);
            float tempOutput9930 = clampResult983 * clampResult985 * clampResult1062;
            float clampResult984 =
                math.clamp(
                    _gerstner2.y + (clampResult968 - 0.0f) * (_smallWaveShoreHeightMultiply * _gerstner2.x * clampResult950 + _gerstner2.x - _gerstner2.y) /
                    (1.0f - 0.0f), 0.0f, 1.0f);
            float tempOutput9290 = _gerstner2.z * _smallWavesChaos;
            float cos1036 = math.cos(tempOutput9290 * 0.01745f);
            float sin1036 = math.sin(tempOutput9290 * 0.01745f);
            float2 rotator1036 = math.mul(normalizeResult1014, new float2x2(cos1036, -sin1036, sin1036, cos1036));
            float2 normalizeResult1039 = math.normalize(rotator1036);
            float dotResult1041 = math.dot(normalizeResult1039, normalizeResult1015);
            float clampResult1052 = math.clamp(tempOutput10080 * ((dotResult1041 - -1.0f) / (1.0f - -1.0f) + tempOutput10450), 0.0f, 1.0f);
            float clampResult1056 = math.clamp(1.0f - clampResult1052, 0.0f, 1.0f);
            float clampResult1063 = math.clamp(math.pow(math.abs(clampResult1056), _smallWaveSilentAreaAngleHardness), 0.0f, 1.0f);
            float tempOutput9940 = clampResult984 * clampResult985 * clampResult1063;
            float clampResult894 = math.clamp(tempOutput8950 + (tempOutput8250 + tempOutput8320 + (tempOutput9930 + tempOutput9940)), 0.01f, 999.0f);
            float clampResult858 = math.clamp(tempOutput8320, 0.0f, tempOutput8320 / clampResult894);
            float clampResult859 = math.clamp(clampResult858, 0.01f, 1.0f);
            float tempOutput610G51 = UnityPI * 2.0f / _gerstnerDirection5.w;
            float tempOutput820G51 = clampResult859 / tempOutput610G51;

            var appendResult71G51 = new float3(aseWorldPos.x, aseWorldPos.z, 0.0f);
            float dotResult72G51 = math.dot(new float3(normalizeResult79G51, 0.0f), appendResult71G51);
            float timeOffset843 = _timeOffset;
            float tempOutput8410 = time + timeOffset843;
            float tempOutput810G51 = tempOutput610G51 * (dotResult72G51 - math.sqrt(9.8f / tempOutput610G51) * tempOutput8410);
            float tempOutput850G51 = math.cos(tempOutput810G51);
            float tempOutput860G51 = math.sin(tempOutput810G51);
            float clampResult856 = math.clamp(tempOutput8320, 0.0f, 1.0f);
            float tempOutput8490 = texcoord3.z * _seaWaveSwashSize;
            float tempOutput890G51 = clampResult856 * tempOutput8490;
            float tempOutput900G51 = tempOutput820G51 * tempOutput850G51 + tempOutput860G51 * tempOutput890G51;
            var appendResult94G51 = new float3(normalizeResult79G51.x * tempOutput900G51, tempOutput820G51 * tempOutput860G51, normalizeResult79G51.y * tempOutput900G51);
            float cos862 = math.cos((_gerstnerDirection4.z * _seaWavesChaos + 180.0f) * 0.01745f);
            float sin862 = math.sin((_gerstnerDirection4.z * _seaWavesChaos + 180.0f) * 0.01745f);
            float2 rotator862 = math.mul(appendResult861, new float2x2(cos862, -sin862, sin862, cos862));
            float2 ifLocalVar77G69 = math.length(rotator862) == 0.0f ? new float2(0.001f, 0) : rotator862;

            float2 normalizeResult79G69 = math.normalize(ifLocalVar77G69);
            float clampResult845 = math.clamp(tempOutput8250, 0.0f, tempOutput8250 / clampResult894);
            float clampResult847 = math.clamp(clampResult845, 0.01f, 1.0f);
            float tempOutput610G69 = UnityPI * 2.0f / _gerstnerDirection4.w;
            float tempOutput820G69 = clampResult847 / tempOutput610G69;
            var appendResult71G69 = new float3(aseWorldPos.x, aseWorldPos.z, 0.0f);
            float dotResult72G69 = math.dot(new float3(normalizeResult79G69, 0.0f), appendResult71G69);
            float tempOutput810G69 = tempOutput610G69 * (dotResult72G69 - math.sqrt(9.8f / tempOutput610G69) * tempOutput8410);
            float tempOutput850G69 = math.cos(tempOutput810G69);
            float tempOutput860G69 = math.sin(tempOutput810G69);
            float clampResult852 = math.clamp(tempOutput8250, 0.0f, 1.0f);
            float tempOutput890G69 = clampResult852 * tempOutput8490;
            float tempOutput900G69 = tempOutput820G69 * tempOutput850G69 + tempOutput860G69 * tempOutput890G69;
            var appendResult94G69 = new float3(normalizeResult79G69.x * tempOutput900G69, tempOutput820G69 * tempOutput860G69, normalizeResult79G69.y * tempOutput900G69);
            var appendResult908 = new float2(texcoord.z, texcoord.w);
            float2 ifLocalVar77G70 = math.length(appendResult908) == 0.0f ? new float2(0.001f, 0) : appendResult908;
            float2 normalizeResult79G70 = math.normalize(ifLocalVar77G70);
            float clampResult899 = math.clamp(tempOutput8950, 0.0f, tempOutput8950 / clampResult894);
            float clampResult901 = math.clamp(clampResult899, 0.01f, 1.0f);
            float tempOutput610G70 = UnityPI * 2.0f / _gerstnerDirection1.w;
            float tempOutput820G70 = clampResult901 / tempOutput610G70;
            float tempOutput1260G70 = math.length(ifLocalVar77G70);
            float tempOutput810G70 = tempOutput610G70 * (-1.0f * tempOutput1260G70 - math.sqrt(9.8f / tempOutput610G70) * (time + timeOffset843));
            float tempOutput850G70 = math.cos(tempOutput810G70);
            float tempOutput860G70 = math.sin(tempOutput810G70);
            float tempOutput9090 = clampResult897 * (_polarWaveSwashSize * texcoord3.z * clampResult1028);
            float clampResult910 = math.clamp(tempOutput9090, 0.0f, tempOutput9090 / clampResult894);
            float clampResult913 = math.clamp(1.0f + (texcoord3.w - polarWaveDepthStartXFlattenPointY732.y) * (0.0f - 1.0f) / (polarWaveDepthStartXFlattenPointY732.x - polarWaveDepthStartXFlattenPointY732.y), 0.001f,
                1.0f);
            float tempOutput890G70 = clampResult910 * clampResult913;
            float tempOutput900G70 = tempOutput820G70 * tempOutput850G70 + tempOutput860G70 * tempOutput890G70;
            var appendResult94G70 = new float3(normalizeResult79G70.x * -1.0f * tempOutput900G70, tempOutput820G70 * tempOutput860G70, normalizeResult79G70.y * -1.0f * tempOutput900G70);
            var appendResult967 = new float2(texcoord3.x, texcoord3.y);
            float cos932 = math.cos((tempOutput9330 + 180.0f) * 0.01745f);
            float sin932 = math.sin((tempOutput9330 + 180.0f) * 0.01745f);
            float2 rotator932 = math.mul(appendResult967, new float2x2(cos932, -sin932, sin932, cos932));
            float2 ifLocalVar77G71 = math.length(rotator932) == 0.0f ? new float2(0.001f, 0) : rotator932;
            float2 normalizeResult79G71 = math.normalize(ifLocalVar77G71);
            float clampResult998 = math.clamp(tempOutput9930, 0.0f, tempOutput9930 / clampResult894);
            float clampResult1000 = math.clamp(clampResult998, 0.01f, 1.0f);
            float tempOutput610G71 = UnityPI * 2.0f / _gerstner1.w;
            float tempOutput820G71 = clampResult1000 / tempOutput610G71;
            var appendResult71G71 = new float3(aseWorldPos.x, aseWorldPos.z, 0.0f);
            float dotResult72G71 = math.dot(new float3(normalizeResult79G71, 0.0f), appendResult71G71);
            float tempOutput9640 = time + timeOffset843;
            float tempOutput810G71 = tempOutput610G71 * (dotResult72G71 - math.sqrt(9.8f / tempOutput610G71) * tempOutput9640);
            float tempOutput850G71 = math.cos(tempOutput810G71);
            float tempOutput860G71 = math.sin(tempOutput810G71);
            float tempOutput9910 = clampResult985 * (clampResult1062 * (_smallWaveSwashSize * texcoord3.z));
            float clampResult996 = math.clamp(tempOutput9910, 0.0f, tempOutput9910 / clampResult894);
            float tempOutput900G71 = tempOutput820G71 * tempOutput850G71 + tempOutput860G71 * clampResult996;
            var appendResult94G71 = new float3(normalizeResult79G71.x * tempOutput900G71, tempOutput820G71 * tempOutput860G71, normalizeResult79G71.y * tempOutput900G71);
            float cos931 = math.cos((tempOutput9290 + 180.0f) * 0.01745f);
            float sin931 = math.sin((tempOutput9290 + 180.0f) * 0.01745f);
            float2 rotator931 = math.mul(appendResult967, new float2x2(cos931, -sin931, sin931, cos931));
            float2 ifLocalVar77G53 = math.length(rotator931) == 0.0f ? new float2(0.001f, 0) : rotator931;
            float2 normalizeResult79G53 = math.normalize(ifLocalVar77G53);
            float clampResult1004 = math.clamp(tempOutput9940, 0.0f, tempOutput9940 / clampResult894);
            float clampResult1005 = math.clamp(clampResult1004, 0.01f, 1.0f);
            float tempOutput610G53 = UnityPI * 2.0f / _gerstner2.w;
            float tempOutput820G53 = clampResult1005 / tempOutput610G53;
            var appendResult71G53 = new float3(aseWorldPos.x, aseWorldPos.z, 0.0f);
            float dotResult72G53 = math.dot(new float3(normalizeResult79G53, 0.0f), appendResult71G53);
            float tempOutput810G53 = tempOutput610G53 * (dotResult72G53 - math.sqrt(9.8f / tempOutput610G53) * tempOutput9640);
            float tempOutput850G53 = math.cos(tempOutput810G53);
            float tempOutput860G53 = math.sin(tempOutput810G53);
            float tempOutput9920 = clampResult985 * (_smallWaveSwashSize * texcoord3.z * clampResult1063);
            float clampResult1001 = math.clamp(tempOutput9920, 0.0f, tempOutput9920 / clampResult894);
            float tempOutput900G53 = tempOutput820G53 * tempOutput850G53 + tempOutput860G53 * clampResult1001;
            var appendResult94G53 = new float3(normalizeResult79G53.x * tempOutput900G53, tempOutput820G53 * tempOutput860G53, normalizeResult79G53.y * tempOutput900G53);
            float clampResult44G154 = math.clamp(math.abs(aseWorldNormal.y), 0.0f, 1.0f);
            float2 seaFoamSlopeInfluence701 = _seaFoamSlopeInfluence.xy;
            float2 mainWaterSpeed692 = _slowWaterSpeed.xy;
            float2 waterTiling693 = _slowWaterTiling.xy;
            float2 tempOutput530G154 = ((1.0f - clampResult44G154) * seaFoamSlopeInfluence701 + mainWaterSpeed692) * waterTiling693 * texcoord3.xy;
            var appendResult57G154 = new float2(tempOutput530G154.y, tempOutput530G154.x);

            float2 staticSwitch59G154 = _uvvdirection1Udirection0On ? tempOutput530G154 : appendResult57G154;

            float waterFlowUVRefreshSpeed695 = _waterFlowUVRefresSpeed;
            float tempOutput680G154 = time * waterFlowUVRefreshSpeed695;
            float tempOutput710G154 = math.frac(tempOutput680G154);
            float2 tempOutput600G154 = staticSwitch59G154 * tempOutput710G154;
            float2 tempOutput830G154 = 1.0f / globalTiling70 * (waterTiling693 * texcoord.xy);
            float2 tempOutput161591 = tempOutput600G154 + tempOutput830G154;
            float2 tempOutput800G154 = staticSwitch59G154 * math.frac(tempOutput680G154 + -0.5f);
            float2 tempOutput161593 = tempOutput830G154 + tempOutput800G154;
            float clampResult90G154 = math.clamp(math.abs(math.sin(UnityPI * 1.5f + tempOutput710G154 * UnityPI)), 0.0f, 1.0f);
            float3 lerpResult80 = math.lerp(UnpackScaleNormal(SAMPLE_TEXTURE2D_LOD(_slowWaterNormal, tempOutput161591), _slowNormalScale),
                UnpackScaleNormal(SAMPLE_TEXTURE2D_LOD(_slowWaterNormal, tempOutput161593), _slowNormalScale), clampResult90G154);
            var appendResult136 = new float2(aseWorldPos.x, aseWorldPos.z);
            float lerpResult81 = math.lerp(SAMPLE_TEXTURE2D_LOD(_slowWaterTesselation, tempOutput161591).x, SAMPLE_TEXTURE2D_LOD(_slowWaterTesselation, tempOutput161593).x, clampResult90G154);

            float tempOutput11240 = math.min(polarWaveDepthStartXFlattenPointY732.y, smallWaveShoreDepthStartXFlattenPointY733.y);
            float clampResult1126 = math.clamp(tempOutput11240 / 3.0f, 0.0f, 9999.0f);
            float clampResult1132 = math.clamp(tempOutput11240 * 2.0f, 0.0f, 9999.0f);
            float clampResult1129 = math.clamp(1.0f + (texcoord3.w - clampResult1126) * (0.0f - 1.0f) / (clampResult1132 - clampResult1126), 0.0f, 1.0f);
            float lerpResult1133 = math.lerp((SAMPLE_TEXTURE2D_LOD(_slowWaterTesselation, lerpResult80.xy * new float2(0.05f, 0.05f) +
                                                                                          (time * (_slowWaterMixSpeed.xy * new float2(1.2f, 1.2f) * _macroWaveTiling.xy)
                                                                                           + 1.0f / globalTiling70 * (_macroWaveTiling.xy * appendResult136))).x + -0.25f) * _macroWaveTessScale +
                                             lerpResult81 * _slowWaterTessScale, 0.0f, clampResult1129);
            float3 aseVertexNormal = normal.xyz;
            float3 clampResult559 = math.clamp(aseVertexNormal, new float3(0, 0, 0), new float3(1, 1, 1));
            vertex.xyz += appendResult94G51 + (appendResult94G69 + appendResult94G70) + appendResult94G71 + appendResult94G53 + lerpResult1133 * clampResult559;

            float3 aseVertexTangent = tangent.xyz;
            float3 aseVertexBitangent = math.cross(aseVertexNormal, aseVertexTangent) * tangent.w; // * ( unity_WorldTransformParams.w >= 0.0f ? 1.0f : -1.0f );
            float tempOutput950G51 = tempOutput860G51 * clampResult859;
            float tempOutput1040G51 = tempOutput850G51 * tempOutput610G51 * tempOutput890G51;
            float tempOutput1140G51 = normalizeResult79G51.y * -1.0f * tempOutput950G51 + normalizeResult79G51.y * tempOutput1040G51;
            float tempOutput960G51 = tempOutput850G51 * clampResult859;
            var appendResult120G51 = new float3(normalizeResult79G51.x * tempOutput1140G51, normalizeResult79G51.y * tempOutput960G51, normalizeResult79G51.y * tempOutput1140G51);
            float tempOutput950G69 = tempOutput860G69 * clampResult847;
            float tempOutput1040G69 = tempOutput850G69 * tempOutput610G69 * tempOutput890G69;
            float tempOutput1140G69 = normalizeResult79G69.y * -1.0f * tempOutput950G69 + normalizeResult79G69.y * tempOutput1040G69;
            float tempOutput960G69 = tempOutput850G69 * clampResult847;
            var appendResult120G69 = new float3(normalizeResult79G69.x * tempOutput1140G69, normalizeResult79G69.y * tempOutput960G69, normalizeResult79G69.y * tempOutput1140G69);
            float tempOutput1270G70 = -1.0f / tempOutput1260G70;
            float tempOutput1360G70 = (clampResult901 * -1.0f * tempOutput860G70 + tempOutput610G70 * tempOutput850G70 * tempOutput890G70) * tempOutput1270G70;
            float tempOutput1380G70 = normalizeResult79G70.y * tempOutput1360G70;
            float tempOutput1310G70 = tempOutput850G70 * clampResult901 * tempOutput1270G70;
            var appendResult120G70 = new float3(normalizeResult79G70.x * tempOutput1380G70, normalizeResult79G70.y * tempOutput1310G70, normalizeResult79G70.y * tempOutput1380G70);
            float tempOutput950G71 = tempOutput860G71 * clampResult1000;
            float tempOutput1040G71 = tempOutput850G71 * tempOutput610G71 * clampResult996;
            float tempOutput1140G71 = normalizeResult79G71.y * -1.0f * tempOutput950G71 + normalizeResult79G71.y * tempOutput1040G71;
            float tempOutput960G71 = tempOutput850G71 * clampResult1000;
            var appendResult120G71 = new float3(normalizeResult79G71.x * tempOutput1140G71, normalizeResult79G71.y * tempOutput960G71, normalizeResult79G71.y * tempOutput1140G71);
            float tempOutput950G53 = tempOutput860G53 * clampResult1005;
            float tempOutput1040G53 = tempOutput850G53 * tempOutput610G53 * clampResult1001;
            float tempOutput1140G53 = normalizeResult79G53.y * -1.0f * tempOutput950G53 + normalizeResult79G53.y * tempOutput1040G53;
            float tempOutput960G53 = tempOutput850G53 * clampResult1005;
            var appendResult120G53 = new float3(normalizeResult79G53.x * tempOutput1140G53, normalizeResult79G53.y * tempOutput960G53, normalizeResult79G53.y * tempOutput1140G53);
            float tempOutput1010G51 = normalizeResult79G51.x * -1.0f * tempOutput950G51 + normalizeResult79G51.x * tempOutput1040G51;
            var appendResult110G51 = new float3(normalizeResult79G51.x * tempOutput1010G51, normalizeResult79G51.x * tempOutput960G51, normalizeResult79G51.y * tempOutput1010G51);
            float tempOutput1010G69 = normalizeResult79G69.x * -1.0f * tempOutput950G69 + normalizeResult79G69.x * tempOutput1040G69;
            var appendResult110G69 = new float3(normalizeResult79G69.x * tempOutput1010G69, normalizeResult79G69.x * tempOutput960G69, normalizeResult79G69.y * tempOutput1010G69);
            float tempOutput1370G70 = normalizeResult79G70.x * tempOutput1360G70;
            var appendResult110G70 = new float3(normalizeResult79G70.x * tempOutput1370G70, normalizeResult79G70.x * tempOutput1310G70, normalizeResult79G70.y * tempOutput1370G70);
            float tempOutput1010G71 = normalizeResult79G71.x * -1.0f * tempOutput950G71 + normalizeResult79G71.x * tempOutput1040G71;
            var appendResult110G71 = new float3(normalizeResult79G71.x * tempOutput1010G71, normalizeResult79G71.x * tempOutput960G71, normalizeResult79G71.y * tempOutput1010G71);
            float tempOutput1010G53 = normalizeResult79G53.x * -1.0f * tempOutput950G53 + normalizeResult79G53.x * tempOutput1040G53;
            var appendResult110G53 = new float3(normalizeResult79G53.x * tempOutput1010G53, normalizeResult79G53.x * tempOutput960G53, normalizeResult79G53.y * tempOutput1010G53);
            float3 normalizeResult1099 = math.normalize(math.cross(
                new float3(0, 0, 1) + (aseVertexBitangent + (appendResult120G51 + (appendResult120G69 + appendResult120G70) + appendResult120G71 + appendResult120G53)),
                new float3(1, 0, 0) + (aseVertexTangent.xyz + (appendResult110G51 + (appendResult110G69 + appendResult110G70) + appendResult110G71 + appendResult110G53))));
            normal = normalizeResult1099;


            return new SeaPhysics.PositionNormal()
            {
                Position = vertex,
                Normal = normal
            };
        }

        public SeaPhysics.PositionNormal VertexDataFuncV3Normal(float3 vertex, float4 tangent, float3 normal, float4 texcoord, float4 texcoord3, float3 aseWorldPos, float3 aseWorldNormal)
        {
            float2 appendResult861 = (new float2(texcoord3.x, texcoord3.y));

            float cos864 = math.cos((((_gerstnerDirection5.z * _seaWavesChaos) + 180.0f) * 0.01745f));
            float sin864 = math.sin((((_gerstnerDirection5.z * _seaWavesChaos) + 180.0f) * 0.01745f));
            float2 rotator864 = math.mul(appendResult861, new float2x2(cos864, -sin864, sin864, cos864));
            float2 ifLocalVar77G51 = math.length(rotator864) == 0.0f ? new float2(0.001f, 0) : rotator864;

            float2 normalizeResult79G223 = math.normalize(ifLocalVar77G51);
            float2 break80G223 = normalizeResult79G223;
            float tempOutput8160 = (0.0f + (texcoord3.w - _seaWaveDepthFlattenStartXEndY.y) * (1.0f - 0.0f) / (_seaWaveDepthFlattenStartXEndY.x - _seaWaveDepthFlattenStartXEndY.y));
            float clampResult823 = math.clamp(tempOutput8160, 0.0f, 1.0f);
            float clampResult833 = math.clamp((_gerstnerDirection5.y + (clampResult823 - 0.0f) * (math.max((clampResult823 * _gerstnerDirection5.x), _gerstnerDirection5.y) - _gerstnerDirection5.y) / (1.0f - 0.0f)), 0.0f,
                1.0f);


            float clampResult44G155 = math.clamp(math.abs(aseWorldNormal.y), 0.0f, 1.0f);
            float2 tempOutput8010 = (_seaWaveNoiseTiling.xy / new float2(1, 1));
            float2 clampResult800 = math.clamp(tempOutput8010, new float2(0.001f, 0.001f), new float2(500, 500));
            float2 tempOutput660G155 = tempOutput8010;
            float2 tempOutput530G155 = (((((1.0f - clampResult44G155) * new float2(1, 1)) + ((new float2(1, 1) / clampResult800) * new float2(1.8f, 1.8f)))
                                         * tempOutput660G155) * texcoord3.xy);
            float2 break56G155 = tempOutput530G155;
            float2 appendResult57G155 = (new float2(break56G155.y, break56G155.x));
            float2 staticSwitch59G155 = _uvvdirection1Udirection0On ? tempOutput530G155 : appendResult57G155;

            float timeOffset843 = _timeOffset;
            float tempOutput680G155 = ((time + timeOffset843) * 0.07f);
            float tempOutput710G155 = math.frac((tempOutput680G155 + 0.0f));
            float2 tempOutput600G155 = (staticSwitch59G155 * tempOutput710G155);
            float globalTiling70 = _globalTiling;
            float2 tempOutput830G155 = ((1.0f / globalTiling70) * (tempOutput660G155 * texcoord.xy));
            float2 tempOutput800G155 = (staticSwitch59G155 * math.frac((tempOutput680G155 + -0.5f)));
            float clampResult90G155 = math.clamp(math.abs(math.sin(((UnityPI * 1.5f) + (tempOutput710G155 * UnityPI)))), 0.0f, 1.0f);
            float lerpResult791 = math.lerp(SAMPLE_TEXTURE2D_LOD(_wavesNoise, tempOutput600G155 + tempOutput830G155).x,
                SAMPLE_TEXTURE2D_LOD(_wavesNoise, tempOutput830G155 + tempOutput800G155).x, clampResult90G155);

            float clampResult807 = math.clamp((math.pow(math.abs(lerpResult791), _seaWaveNoisePower) * _seaWaveNoiseMultiply), 0.0f, 1.0f);
            float clampResult827 = math.clamp((1.0f - (0.05f + (clampResult807 - 0.0f) * (0.97f - 0.05f) / (1.0f - 0.0f))), 0.0f, 1.0f);
            float tempOutput8320 = (clampResult833 * clampResult827);

            float2 polarWaveDepthStartXFlattenPointY732 = _polarWaveDepthStartXFlattenPointY.xy;
            float2 break1308 = polarWaveDepthStartXFlattenPointY732;
            float clampResult884 = math.clamp((texcoord3.w - break1308.y), 0.0f, 1.0f);

            float clampResult886 = math.clamp((1.0f + (texcoord3.w - break1308.y) * (0.0f - 1.0f) / (break1308.x - break1308.y)), 0.0f, 1.0f);
            float clampResult890 = math.clamp((_gerstnerDirection1.y + (clampResult884 - 0.0f) * ((_gerstnerDirection1.x * clampResult886) - _gerstnerDirection1.y) / (1.0f - 0.0f)),
                0.0f, 1.0f);
            float2 appendResult1009 = (new float2(texcoord3.x, texcoord3.y));
            float2 normalizeResult1014 = math.normalize((appendResult1009 * new float2(1, -1)));

            float2 appendResult1011 = (new float2(texcoord.z, texcoord.w));
            float2 normalizeResult1015 = math.normalize(appendResult1011);
            float dotResult1016 = math.dot(normalizeResult1014, normalizeResult1015);

            float clampResult1022 = math.clamp(((0.0f + (dotResult1016 - -1.0f) * (1.0f - 0.0f) / (1.0f - -1.0f)) +
                                                ((_polarWaveSilentAreaAngle + -180.0f) / 180.0f)), 0.0f, 1.0f);
            float clampResult1024 = math.clamp((1.0f - clampResult1022), 0.0f, 1.0f);

            float clampResult1028 = math.clamp(math.pow(math.abs(clampResult1024), _polarWaveSilentAreaAngleHardness), 0.0f, 1.0f);
            float clampResult44G156 = math.clamp(math.abs(aseWorldNormal.y), 0.0f, 1.0f);

            float2 tempOutput7790 = (_smallWaveNoiseTiling.xy / new float2(1, 1));
            float2 clampResult780 = math.clamp(tempOutput7790, new float2(0.001f, 0.001f), new float2(500, 500));
            float2 tempOutput660G156 = tempOutput7790;
            float2 tempOutput530G156 = (((((1.0f - clampResult44G156) * new float2(1, 1)) + ((new float2(1, 1) / clampResult780) * new float2(2, 2))) * tempOutput660G156) * texcoord3.xy);
            float2 break56G156 = tempOutput530G156;
            float2 appendResult57G156 = (new float2(break56G156.y, break56G156.x));
            float2 staticSwitch59G156 = _uvvdirection1Udirection0On ? tempOutput530G156 : appendResult57G156;

            float tempOutput680G156 = ((time + timeOffset843) * 0.05f);
            float tempOutput710G156 = math.frac((tempOutput680G156 + 0.0f));
            float2 tempOutput600G156 = (staticSwitch59G156 * tempOutput710G156);
            float2 tempOutput830G156 = ((1.0f / globalTiling70) * (tempOutput660G156 * texcoord.xy));
            float2 tempOutput800G156 = (staticSwitch59G156 * math.frac((tempOutput680G156 + -0.5f)));
            float clampResult90G156 = math.clamp(math.abs(math.sin(((UnityPI * 1.5f) + (tempOutput710G156 * UnityPI)))),
                0.0f, 1.0f);
            float lerpResult772 = math.lerp(SAMPLE_TEXTURE2D_LOD(_wavesNoise, tempOutput600G156 + tempOutput830G156).x,
                SAMPLE_TEXTURE2D_LOD(_wavesNoise, tempOutput830G156 + tempOutput800G156).x, clampResult90G156);

            float clampResult787 = math.clamp((math.pow(math.abs(lerpResult772), _smallWaveNoisePower) * _smallWaveNoiseMultiply), 0.0f, 1.0f);
            float tempOutput7880 = (0.0f + (clampResult787 - 0.0f) * (0.97f - 0.0f) / (1.0f - 0.0f));
            float clampResult897 = math.clamp((1.0f - tempOutput7880), 0.0f, 1.0f);
            float tempOutput8950 = ((clampResult890 * (clampResult1028 * 1.0f)) * clampResult897);
            float clampResult824 = math.clamp((_gerstnerDirection4.y + (clampResult823 - 0.0f) * (math.max((clampResult823 * _gerstnerDirection4.x), _gerstnerDirection4.y) - _gerstnerDirection4.y) / (1.0f - 0.0f)), 0.0f,
                1.0f);
            float tempOutput8250 = (clampResult824 * clampResult827);
            float2 smallWaveShoreDepthStartXFlattenPointY733 = _smallWaveShoreDepthStartXFlattenPointY.xy;
            float2 break953 = smallWaveShoreDepthStartXFlattenPointY733;
            float clampResult968 = math.clamp((texcoord3.w - break953.y), 0.0f, 1.0f);
            float clampResult950 = math.clamp((1.0f + (texcoord3.w - break953.y) * (0.0f - 1.0f) / (break953.x - break953.y)),
                0.0f, 1.0f);
            float clampResult983 = math.clamp((_gerstner1.y + (clampResult968 - 0.0f) * ((_gerstner1.x + ((_smallWaveShoreHeightMultiply * _gerstner1.x) * clampResult950)) - _gerstner1.y) / (1.0f - 0.0f)), 0.0f,
                1.0f);
            float clampResult985 = math.clamp((1.0f - tempOutput7880), 0.0f, 1.0f);
            float clampResult1007 = math.clamp(tempOutput8160, 0.0f, 1.0f);
            float tempOutput10080 = (1.0f - clampResult1007);
            float tempOutput9330 = (_gerstner1.z * _smallWavesChaos);
            float cos1034 = math.cos((tempOutput9330 * 0.01745f));
            float sin1034 = math.sin((tempOutput9330 * 0.01745f));
            float2 rotator1034 = math.mul(normalizeResult1014 - new float2(0, 0), new float2x2(cos1034, -sin1034, sin1034, cos1034));
            float2 normalizeResult1038 = math.normalize(rotator1034);
            float dotResult1040 = math.dot(normalizeResult1038, normalizeResult1015);
            float tempOutput10450 = ((_smallWaveSilentAreaAngle + -180.0f) / 180.0f);
            float clampResult1051 = math.clamp((tempOutput10080 * ((0.0f + (dotResult1040 - -1.0f) * (1.0f - 0.0f) / (1.0f - -1.0f)) + tempOutput10450)), 0.0f, 1.0f);
            float clampResult1055 = math.clamp((1.0f - clampResult1051), 0.0f, 1.0f);
            float clampResult1062 = math.clamp(math.pow(math.abs(clampResult1055), _smallWaveSilentAreaAngleHardness), 0.0f, 1.0f);
            float tempOutput9930 = ((clampResult983 * clampResult985) * clampResult1062);
            float clampResult984 = math.clamp((_gerstner2.y + (clampResult968 - 0.0f) * ((((_smallWaveShoreHeightMultiply * _gerstner2.x) * clampResult950) + _gerstner2.x) - _gerstner2.y) / (1.0f - 0.0f)), 0.0f,
                1.0f);
            float tempOutput9290 = (_gerstner2.z * _smallWavesChaos);
            float cos1036 = math.cos((tempOutput9290 * 0.01745f));
            float sin1036 = math.sin((tempOutput9290 * 0.01745f));
            float2 rotator1036 = math.mul(normalizeResult1014 - new float2(0, 0), new float2x2(cos1036, -sin1036, sin1036, cos1036));
            float2 normalizeResult1039 = math.normalize(rotator1036);
            float dotResult1041 = math.dot(normalizeResult1039, normalizeResult1015);
            float clampResult1052 = math.clamp((tempOutput10080 * ((0.0f + (dotResult1041 - -1.0f) * (1.0f - 0.0f) / (1.0f - -1.0f)) + tempOutput10450)), 0.0f, 1.0f);
            float clampResult1056 = math.clamp((1.0f - clampResult1052), 0.0f, 1.0f);
            float clampResult1063 = math.clamp(math.pow(math.abs(clampResult1056), _smallWaveSilentAreaAngleHardness),
                0.0f, 1.0f);
            float tempOutput9940 = ((clampResult984 * clampResult985) * clampResult1063);
            float clampResult894 = math.clamp((tempOutput8950 + ((tempOutput8250 + tempOutput8320) + (tempOutput9930 + tempOutput9940))),
                0.01f, 999.0f);
            float clampResult858 = math.clamp(tempOutput8320, 0.0f, (tempOutput8320 / clampResult894));
            float clampResult859 = math.clamp(clampResult858, 0.01f, 1.0f);
            float tempOutput830G223 = clampResult859;
            float tempOutput610G223 = ((UnityPI * 2.0f) / _gerstnerDirection5.w);
            float tempOutput820G223 = (tempOutput830G223 / tempOutput610G223);

            float3 break70G223 = aseWorldPos;
            float3 appendResult71G223 = (new float3(break70G223.x, break70G223.z, 0.0f));
            float dotResult72G223 = math.dot(new float3(normalizeResult79G223, 0.0f), appendResult71G223);
            float tempOutput8410 = (time + timeOffset843);
            float tempOutput810G223 = (tempOutput610G223 * (dotResult72G223 - (math.sqrt((9.8f / tempOutput610G223)) * tempOutput8410)));
            float tempOutput850G223 = math.cos(tempOutput810G223);
            float tempOutput860G223 = math.sin(tempOutput810G223);
            float clampResult856 = math.clamp(tempOutput8320, 0.0f, 1.0f);
            float tempOutput8490 = (texcoord3.z * _seaWaveSwashSize);
            float tempOutput890G223 = (clampResult856 * tempOutput8490);
            float tempOutput900G223 = ((tempOutput820G223 * tempOutput850G223) + (tempOutput860G223 * tempOutput890G223));
            float3 appendResult94G223 = (new float3((break80G223.x * tempOutput900G223), (tempOutput820G223 * tempOutput860G223), (break80G223.y * tempOutput900G223)));
            float cos862 = math.cos((((_gerstnerDirection4.z * _seaWavesChaos) + 180.0f) * 0.01745f));
            float sin862 = math.sin((((_gerstnerDirection4.z * _seaWavesChaos) + 180.0f) * 0.01745f));
            float2 rotator862 = math.mul(appendResult861 - new float2(0, 0), new float2x2(cos862, -sin862, sin862, cos862));
            float2 tempOutput730G224 = rotator862;
            float2 ifLocalVar77G224 = 0;
            if (math.length(tempOutput730G224) == 0.0f)
                ifLocalVar77G224 = new float2(0.001f, 0);
            else
                ifLocalVar77G224 = tempOutput730G224;
            float2 normalizeResult79G224 = math.normalize(ifLocalVar77G224);
            float2 break80G224 = normalizeResult79G224;
            float clampResult845 = math.clamp(tempOutput8250, 0.0f, (tempOutput8250 / clampResult894));
            float clampResult847 = math.clamp(clampResult845, 0.01f, 1.0f);
            float tempOutput830G224 = clampResult847;
            float tempOutput610G224 = ((UnityPI * 2.0f) / _gerstnerDirection4.w);
            float tempOutput820G224 = (tempOutput830G224 / tempOutput610G224);
            float3 break70G224 = aseWorldPos;
            float3 appendResult71G224 = (new float3(break70G224.x, break70G224.z, 0.0f));
            float dotResult72G224 = math.dot(new float3(normalizeResult79G224, 0.0f), appendResult71G224);
            float tempOutput810G224 = (tempOutput610G224 * (dotResult72G224 - (math.sqrt((9.8f / tempOutput610G224)) * tempOutput8410)));
            float tempOutput850G224 = math.cos(tempOutput810G224);
            float tempOutput860G224 = math.sin(tempOutput810G224);
            float clampResult852 = math.clamp(tempOutput8250, 0.0f, 1.0f);
            float tempOutput890G224 = (clampResult852 * tempOutput8490);
            float tempOutput900G224 = ((tempOutput820G224 * tempOutput850G224) + (tempOutput860G224 * tempOutput890G224));
            float3 appendResult94G224 = (new float3((break80G224.x * tempOutput900G224), (tempOutput820G224 * tempOutput860G224), (break80G224.y * tempOutput900G224)));
            float2 appendResult908 = (new float2(texcoord.z, texcoord.w));
            float2 tempOutput730G225 = appendResult908;
            float2 ifLocalVar77G225 = 0;
            if (math.length(tempOutput730G225) == 0.0f)
                ifLocalVar77G225 = new float2(0.001f, 0);
            else
                ifLocalVar77G225 = tempOutput730G225;
            float2 normalizeResult79G225 = math.normalize(ifLocalVar77G225);
            float2 break80G225 = normalizeResult79G225;
            float clampResult899 = math.clamp(tempOutput8950, 0.0f, (tempOutput8950 / clampResult894));
            float clampResult901 = math.clamp(clampResult899, 0.01f, 1.0f);
            float tempOutput830G225 = clampResult901;
            float tempOutput610G225 = ((UnityPI * 2.0f) / _gerstnerDirection1.w);
            float tempOutput820G225 = (tempOutput830G225 / tempOutput610G225);
            float tempOutput9090 = (clampResult897 * ((_polarWaveSwashSize * texcoord3.z) * clampResult1028));
            float clampResult910 = math.clamp(tempOutput9090, 0.0f, (tempOutput9090 / clampResult894));
            float clampResult913 = math.clamp((1.0f + (texcoord3.w - break1308.y) * (0.0f - 1.0f) / (break1308.x - break1308.y)),
                0.001f, 1.0f);
            float tempOutput9120 = (clampResult910 * clampResult913);
            float tempOutput670G214 = _polarAndSmallWavesFrictionDepthMask;
            float clampResult135G214 = math.clamp(texcoord3.w, 0.0f, tempOutput670G214);
            float tempOutput810G225 = (tempOutput610G225 * ((-1.0f * math.length(ifLocalVar77G225)) - (math.sqrt((9.8f / tempOutput610G225)) *
                                                                                                       (((time + timeOffset843) - (0.3f * tempOutput9120)) - (math.pow(math.abs((1.0f + (clampResult135G214 - 0.0f) *
                                                                                                                   (0.0f - 1.0f) /
                                                                                                                   (tempOutput670G214 - 0.0f))),
                                                                                                               _polarAndSmallWavesFrictionDepthMaskPower) *
                                                                                                           _polarAndSmallWavesFrictionSpeedReduction)))));
            float tempOutput850G225 = math.cos(tempOutput810G225);
            float tempOutput860G225 = math.sin(tempOutput810G225);
            float tempOutput890G225 = tempOutput9120;
            float tempOutput900G225 = ((tempOutput820G225 * tempOutput850G225) + (tempOutput860G225 * tempOutput890G225));
            float3 appendResult94G225 = (new float3(((break80G225.x * -1.0f) * tempOutput900G225), (tempOutput820G225 * tempOutput860G225), ((break80G225.y * -1.0f) * tempOutput900G225)));
            float2 appendResult967 = (new float2(texcoord3.x, texcoord3.y));
            float cos932 = math.cos(((tempOutput9330 + 180.0f) * 0.01745f));
            float sin932 = math.sin(((tempOutput9330 + 180.0f) * 0.01745f));
            float2 rotator932 = math.mul(appendResult967 - new float2(0, 0), new float2x2(cos932, -sin932, sin932, cos932));
            float2 tempOutput730G221 = rotator932;
            float2 ifLocalVar77G221 = 0;
            if (math.length(tempOutput730G221) == 0.0f)
                ifLocalVar77G221 = new float2(0.001f, 0);
            else
                ifLocalVar77G221 = tempOutput730G221;
            float2 normalizeResult79G221 = math.normalize(ifLocalVar77G221);
            float2 break80G221 = normalizeResult79G221;
            float clampResult998 = math.clamp(tempOutput9930, 0.0f, (tempOutput9930 / clampResult894));
            float clampResult1000 = math.clamp(clampResult998, 0.01f, 1.0f);
            float tempOutput830G221 = clampResult1000;
            float tempOutput610G221 = ((UnityPI * 2.0f) / _gerstner1.w);
            float tempOutput820G221 = (tempOutput830G221 / tempOutput610G221);
            float3 break70G221 = aseWorldPos;
            float3 appendResult71G221 = (new float3(break70G221.x, break70G221.z, 0.0f));
            float dotResult72G221 = math.dot(new float3(normalizeResult79G221, 0.0f), appendResult71G221);
            float tempOutput9640 = (time + timeOffset843);
            float tempOutput9910 = (clampResult985 * (clampResult1062 * (_smallWaveSwashSize * texcoord3.z)));
            float clampResult996 = math.clamp(tempOutput9910, 0.0f, (tempOutput9910 / clampResult894));
            float tempOutput670G212 = _polarAndSmallWavesFrictionDepthMask;
            float clampResult135G212 = math.clamp(texcoord3.w, 0.0f, tempOutput670G212);
            float tempOutput810G221 = (tempOutput610G221 * (dotResult72G221 - (math.sqrt((9.8f / tempOutput610G221)) * ((tempOutput9640 - (0.3f * clampResult996)) -
                                                                                                                        (math.pow(
                                                                                                                             math.abs((1.0f + (clampResult135G212 - 0.0f) * (0.0f - 1.0f) / (tempOutput670G212 - 0.0f))),
                                                                                                                             _polarAndSmallWavesFrictionDepthMaskPower) *
                                                                                                                         _polarAndSmallWavesFrictionSpeedReduction)))));
            float tempOutput850G221 = math.cos(tempOutput810G221);
            float tempOutput860G221 = math.sin(tempOutput810G221);
            float tempOutput890G221 = clampResult996;
            float tempOutput900G221 = ((tempOutput820G221 * tempOutput850G221) + (tempOutput860G221 * tempOutput890G221));
            float3 appendResult94G221 = (new float3((break80G221.x * tempOutput900G221), (tempOutput820G221 * tempOutput860G221), (break80G221.y * tempOutput900G221)));
            float cos931 = math.cos(((tempOutput9290 + 180.0f) * 0.01745f));
            float sin931 = math.sin(((tempOutput9290 + 180.0f) * 0.01745f));
            float2 rotator931 = math.mul(appendResult967 - new float2(0, 0), new float2x2(cos931, -sin931, sin931, cos931));
            float2 tempOutput730G222 = rotator931;
            float2 ifLocalVar77G222 = 0;
            if (math.length(tempOutput730G222) == 0.0f)
                ifLocalVar77G222 = new float2(0.001f, 0);
            else
                ifLocalVar77G222 = tempOutput730G222;
            float2 normalizeResult79G222 = math.normalize(ifLocalVar77G222);
            float2 break80G222 = normalizeResult79G222;
            float clampResult1004 = math.clamp(tempOutput9940, 0.0f, (tempOutput9940 / clampResult894));
            float clampResult1005 = math.clamp(clampResult1004, 0.01f, 1.0f);
            float tempOutput830G222 = clampResult1005;
            float tempOutput610G222 = ((UnityPI * 2.0f) / _gerstner2.w);
            float tempOutput820G222 = (tempOutput830G222 / tempOutput610G222);
            float3 break70G222 = aseWorldPos;
            float3 appendResult71G222 = (new float3(break70G222.x, break70G222.z, 0.0f));
            float dotResult72G222 = math.dot(new float3(normalizeResult79G222, 0.0f), appendResult71G222);
            float tempOutput9920 = (clampResult985 * ((_smallWaveSwashSize * texcoord3.z) * clampResult1063));
            float clampResult1001 = math.clamp(tempOutput9920, 0.0f, (tempOutput9920 / clampResult894));
            float tempOutput670G213 = _polarAndSmallWavesFrictionDepthMask;
            float clampResult135G213 = math.clamp(texcoord3.w, 0.0f, tempOutput670G213);
            float tempOutput810G222 = (tempOutput610G222 * (dotResult72G222 - (math.sqrt((9.8f / tempOutput610G222)) * ((tempOutput9640 - (0.3f * clampResult1001)) -
                                                                                                                        (math.pow(
                                                                                                                             math.abs((1.0f + (clampResult135G213 - 0.0f) * (0.0f - 1.0f) / (tempOutput670G213 - 0.0f))),
                                                                                                                             _polarAndSmallWavesFrictionDepthMaskPower) *
                                                                                                                         _polarAndSmallWavesFrictionSpeedReduction)))));
            float tempOutput850G222 = math.cos(tempOutput810G222);
            float tempOutput860G222 = math.sin(tempOutput810G222);
            float tempOutput890G222 = clampResult1001;
            float tempOutput900G222 = ((tempOutput820G222 * tempOutput850G222) + (tempOutput860G222 * tempOutput890G222));
            float3 appendResult94G222 = (new float3((break80G222.x * tempOutput900G222), (tempOutput820G222 * tempOutput860G222), (break80G222.y * tempOutput900G222)));
            float clampResult44G154 = math.clamp(math.abs(aseWorldNormal.y), 0.0f, 1.0f);
            float2 seaFoamSlopeInfluence701 = _seaFoamSlopeInfluence.xy;
            float2 mainWaterSpeed692 = _slowWaterSpeed.xy;
            float2 waterTiling693 = _slowWaterTiling.xy;
            float2 tempOutput660G154 = waterTiling693;
            float2 tempOutput530G154 = (((((1.0f - clampResult44G154) * seaFoamSlopeInfluence701) + mainWaterSpeed692) * tempOutput660G154) * texcoord3.xy);
            float2 break56G154 = tempOutput530G154;
            float2 appendResult57G154 = (new float2(break56G154.y, break56G154.x));

            float2 staticSwitch59G154 = _uvvdirection1Udirection0On ? tempOutput530G154 : appendResult57G154;

            float waterFlowUVRefreshSpeed695 = _waterFlowUVRefresSpeed;
            float tempOutput680G154 = ((time + 0.0f) * waterFlowUVRefreshSpeed695);
            float tempOutput710G154 = math.frac((tempOutput680G154 + 0.0f));
            float2 tempOutput600G154 = (staticSwitch59G154 * tempOutput710G154);
            float2 tempOutput830G154 = ((1.0f / globalTiling70) * (tempOutput660G154 * texcoord.xy));
            float2 tempOutput161591 = (tempOutput600G154 + tempOutput830G154);
            float2 tempOutput800G154 = (staticSwitch59G154 * math.frac((tempOutput680G154 + -0.5f)));
            float2 tempOutput161593 = (tempOutput830G154 + tempOutput800G154);
            float clampResult90G154 = math.clamp(math.abs(math.sin(((UnityPI * 1.5f) + (tempOutput710G154 * UnityPI)))), 0.0f, 1.0f);
            float tempOutput161596 = clampResult90G154;
            float3 lerpResult80 = math.lerp(UnpackScaleNormal(SAMPLE_TEXTURE2D_LOD(_slowWaterNormal, tempOutput161591), _slowNormalScale),
                UnpackScaleNormal(SAMPLE_TEXTURE2D_LOD(_slowWaterNormal, tempOutput161593), _slowNormalScale), tempOutput161596);
            float2 appendResult136 = (new float2(aseWorldPos.x, aseWorldPos.z));
            float lerpResult81 = math.lerp(SAMPLE_TEXTURE2D_LOD(_slowWaterTesselation, tempOutput161591).x,
                SAMPLE_TEXTURE2D_LOD(_slowWaterTesselation, tempOutput161593).x, tempOutput161596);
            float tempOutput11240 = math.min(polarWaveDepthStartXFlattenPointY732.y, smallWaveShoreDepthStartXFlattenPointY733.y);
            float clampResult1126 = math.clamp((tempOutput11240 / 3.0f), 0.0f, 9999.0f);
            float clampResult1132 = math.clamp((tempOutput11240 * 2.0f), 0.0f, 9999.0f);
            float clampResult1129 = math.clamp((1.0f + (texcoord3.w - clampResult1126) * (0.0f - 1.0f) / (clampResult1132 - clampResult1126)), 0.0f, 1.0f);
            float lerpResult1133 = math.lerp((((SAMPLE_TEXTURE2D_LOD(_slowWaterTesselation
                    , (((lerpResult80).xy * new float2(0.05f, 0.05f)) + ((time * ((_slowWaterMixSpeed.xy * new float2(1.2f, 1.2f)) * _macroWaveTiling.xy)) + ((1.0f / globalTiling70) * (_macroWaveTiling.xy * appendResult136)))))
                .x + -0.25f) * _macroWaveTessScale) + (lerpResult81 * _slowWaterTessScale)), 0.0f, clampResult1129);
            vertex.xyz += ((((((appendResult94G223 + (appendResult94G224 + appendResult94G225)) + appendResult94G221) + appendResult94G222) + new float3(0, 0, 0)) + (lerpResult1133 * aseWorldNormal)) +
                           new float3(0, 0, 0));

            float3 aseVertexNormal = normal.xyz;
            float3 aseVertexTangent = tangent.xyz;
            float3 aseVertexBitangent = math.cross(aseVertexNormal, aseVertexTangent) * tangent.w; // * (unity_WorldTransformParams.w >= 0.0f ? 1.0f : -1.0f);
            float tempOutput950G223 = (tempOutput860G223 * tempOutput830G223);
            float tempOutput16400 = 0; //math.distance(aseWorldPos, _WorldSpaceCameraPos);
            float clampResult126G223 = math.clamp(tempOutput16400, 0.0f, 100.0f);
            float clampResult130G223 = math.clamp((((clampResult126G223 * 0.01f) * tempOutput890G223) + -1.0f), -0.6f, 0.0f);
            float clampResult132G223 = math.clamp(tempOutput850G223, clampResult130G223, 1.0f);
            float tempOutput1040G223 = ((clampResult132G223 * tempOutput610G223) * tempOutput890G223);
            float tempOutput1140G223 = (((break80G223.y * -1.0f) * tempOutput950G223) + (break80G223.y * tempOutput1040G223));
            float tempOutput960G223 = (clampResult132G223 * tempOutput830G223);
            float3 appendResult120G223 = (new float3((break80G223.x * tempOutput1140G223), (break80G223.y * tempOutput960G223), (break80G223.y * tempOutput1140G223)));
            float tempOutput950G224 = (tempOutput860G224 * tempOutput830G224);
            float clampResult126G224 = math.clamp(tempOutput16400, 0.0f, 100.0f);
            float clampResult130G224 = math.clamp((((clampResult126G224 * 0.01f) * tempOutput890G224) + -1.0f), -0.6f, 0.0f);
            float clampResult132G224 = math.clamp(tempOutput850G224, clampResult130G224, 1.0f);
            float tempOutput1040G224 = ((clampResult132G224 * tempOutput610G224) * tempOutput890G224);
            float tempOutput1140G224 = (((break80G224.y * -1.0f) * tempOutput950G224) + (break80G224.y * tempOutput1040G224));
            float tempOutput960G224 = (clampResult132G224 * tempOutput830G224);
            float3 appendResult120G224 = (new float3((break80G224.x * tempOutput1140G224), (break80G224.y * tempOutput960G224), (break80G224.y * tempOutput1140G224)));
            float clampResult144G225 = math.clamp(tempOutput16400, 0.0f, 100.0f);
            float clampResult146G225 = math.clamp((((clampResult144G225 * 0.01f) * tempOutput890G225) + -1.0f), -0.6f, 0.0f);
            float clampResult147G225 = math.clamp(tempOutput850G225, clampResult146G225, 1.0f);
            float tempOutput1270G225 = (-1.0f / 1.0f);
            float tempOutput1360G225 = ((((tempOutput830G225 * -1.0f) * tempOutput860G225) + ((tempOutput610G225 * clampResult147G225) * tempOutput890G225)) * tempOutput1270G225);
            float tempOutput1380G225 = (break80G225.y * tempOutput1360G225);
            float tempOutput1310G225 = ((clampResult147G225 * tempOutput830G225) * tempOutput1270G225);
            float3 appendResult120G225 = (new float3((break80G225.x * tempOutput1380G225), (break80G225.y * tempOutput1310G225), (break80G225.y * tempOutput1380G225)));
            float tempOutput950G221 = (tempOutput860G221 * tempOutput830G221);
            float clampResult126G221 = math.clamp(tempOutput16400, 0.0f, 100.0f);
            float clampResult130G221 = math.clamp((((clampResult126G221 * 0.01f) * tempOutput890G221) + -1.0f), -0.6f, 0.0f);
            float clampResult132G221 = math.clamp(tempOutput850G221, clampResult130G221, 1.0f);
            float tempOutput1040G221 = ((clampResult132G221 * tempOutput610G221) * tempOutput890G221);
            float tempOutput1140G221 = (((break80G221.y * -1.0f) * tempOutput950G221) + (break80G221.y * tempOutput1040G221));
            float tempOutput960G221 = (clampResult132G221 * tempOutput830G221);
            float3 appendResult120G221 = (new float3((break80G221.x * tempOutput1140G221), (break80G221.y * tempOutput960G221), (break80G221.y * tempOutput1140G221)));
            float tempOutput950G222 = (tempOutput860G222 * tempOutput830G222);
            float clampResult126G222 = math.clamp(tempOutput16400, 0.0f, 100.0f);
            float clampResult130G222 = math.clamp((((clampResult126G222 * 0.01f) * tempOutput890G222) + -1.0f), -0.6f, 0.0f);
            float clampResult132G222 = math.clamp(tempOutput850G222, clampResult130G222, 1.0f);
            float tempOutput1040G222 = ((clampResult132G222 * tempOutput610G222) * tempOutput890G222);
            float tempOutput1140G222 = (((break80G222.y * -1.0f) * tempOutput950G222) + (break80G222.y * tempOutput1040G222));
            float tempOutput960G222 = (clampResult132G222 * tempOutput830G222);
            float3 appendResult120G222 = (new float3((break80G222.x * tempOutput1140G222), (break80G222.y * tempOutput960G222), (break80G222.y * tempOutput1140G222)));
            float tempOutput1010G223 = (((break80G223.x * -1.0f) * tempOutput950G223) + (break80G223.x * tempOutput1040G223));
            float3 appendResult110G223 = (new float3((break80G223.x * tempOutput1010G223), (break80G223.x * tempOutput960G223), (break80G223.y * tempOutput1010G223)));
            float tempOutput1010G224 = (((break80G224.x * -1.0f) * tempOutput950G224) + (break80G224.x * tempOutput1040G224));
            float3 appendResult110G224 = (new float3((break80G224.x * tempOutput1010G224), (break80G224.x * tempOutput960G224), (break80G224.y * tempOutput1010G224)));
            float tempOutput1370G225 = (break80G225.x * tempOutput1360G225);
            float3 appendResult110G225 = (new float3((break80G225.x * tempOutput1370G225), (break80G225.x * tempOutput1310G225), (break80G225.y * tempOutput1370G225)));
            float tempOutput1010G221 = (((break80G221.x * -1.0f) * tempOutput950G221) + (break80G221.x * tempOutput1040G221));
            float3 appendResult110G221 = (new float3((break80G221.x * tempOutput1010G221), (break80G221.x * tempOutput960G221), (break80G221.y * tempOutput1010G221)));
            float tempOutput1010G222 = (((break80G222.x * -1.0f) * tempOutput950G222) + (break80G222.x * tempOutput1040G222));
            float3 appendResult110G222 = (new float3((break80G222.x * tempOutput1010G222), (break80G222.x * tempOutput960G222), (break80G222.y * tempOutput1010G222)));
            float3 normalizeResult1099 = math.normalize(math.cross(
                (new float3(0, 0, 1) + (aseVertexBitangent +
                                        ((((appendResult120G223) + ((appendResult120G224) + ((appendResult120G225 * new float3(-1, 1, -1))))) +
                                          (appendResult120G221)) + (appendResult120G222)))),
                (new float3(1, 0, 0) + (aseVertexTangent.xyz +
                                        ((((appendResult110G223) + ((appendResult110G224) + ((appendResult110G225 * new float3(-1, 1, -1))))) +
                                          (appendResult110G221)) + (appendResult110G222))))));

            normal = normalizeResult1099;


            return new SeaPhysics.PositionNormal()
            {
                Position = vertex,
                Normal = normal
            };
        }
    }
}