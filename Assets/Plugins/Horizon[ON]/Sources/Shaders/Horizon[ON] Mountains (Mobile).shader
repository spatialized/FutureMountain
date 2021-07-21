// Shader created with Shader Forge v1.38 
// Shader Forge (c) Neat Corporation / Joachim Holmer - http://www.acegikmo.com/shaderforge/
// Note: Manually altering this data may prevent you from opening it in Shader Forge
/*SF_DATA;ver:1.38;sub:START;pass:START;ps:flbk:,iptp:0,cusa:False,bamd:0,cgin:,lico:0,lgpr:1,limd:2,spmd:0,trmd:0,grmd:0,uamb:False,mssp:True,bkdf:False,hqlp:False,rprd:True,enco:False,rmgx:False,imps:False,rpth:0,vtps:0,hqsc:True,nrmq:1,nrsp:0,vomd:0,spxs:False,tesm:0,olmd:1,culm:0,bsrc:0,bdst:1,dpts:2,wrdp:True,dith:0,atcv:False,rfrpo:True,rfrpn:Refraction,coma:15,ufog:True,aust:True,igpj:False,qofs:0,qpre:1,rntp:1,fgom:False,fgoc:False,fgod:False,fgor:False,fgmd:0,fgcr:0.692398,fgcg:0.7166868,fgcb:0.722,fgca:1,fgde:0.00015,fgrn:0,fgrf:300,stcl:False,atwp:False,stva:128,stmr:255,stmw:255,stcp:6,stps:0,stfa:0,stfz:0,ofsf:0,ofsu:0,f2p0:False,fnsp:False,fnfb:False,fsmp:False;n:type:ShaderForge.SFN_Final,id:4013,x:36927,y:33256,varname:node_4013,prsc:2|diff-5870-OUT,spec-7994-OUT,gloss-7994-OUT,normal-5053-OUT,emission-2545-OUT,amdfl-8924-OUT,difocc-7235-OUT;n:type:ShaderForge.SFN_Color,id:1304,x:35743,y:31955,ptovrint:False,ptlb:Global Tint,ptin:_GlobalTint,varname:_BuildingTint,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,c1:1,c2:1,c3:1,c4:1;n:type:ShaderForge.SFN_Multiply,id:3998,x:35743,y:32108,varname:node_3998,prsc:2|A-1304-RGB,B-9515-OUT,C-7063-OUT;n:type:ShaderForge.SFN_Color,id:7083,x:34708,y:33954,ptovrint:False,ptlb:OverlayFogColorAfromAmbient,ptin:_OverlayFogColorAfromAmbient,varname:_OverlayFogColorAfromAmbient,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,c1:1,c2:1,c3:1,c4:1;n:type:ShaderForge.SFN_Distance,id:5478,x:34739,y:33650,varname:node_5478,prsc:2|A-5169-XYZ,B-4120-XYZ;n:type:ShaderForge.SFN_ViewPosition,id:5169,x:34435,y:33614,varname:node_5169,prsc:2;n:type:ShaderForge.SFN_FragmentPosition,id:4120,x:34435,y:33733,varname:node_4120,prsc:2;n:type:ShaderForge.SFN_ValueProperty,id:5063,x:35028,y:33579,ptovrint:False,ptlb:OverlayFogStartDistance,ptin:_OverlayFogStartDistance,varname:_OverlayFogStartDistance,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,v1:0;n:type:ShaderForge.SFN_ValueProperty,id:6501,x:35167,y:33579,ptovrint:False,ptlb:OverlayFogDistanceTransition,ptin:_OverlayFogDistanceTransition,varname:_OverlayFogDistanceTransition,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,v1:2500;n:type:ShaderForge.SFN_Slider,id:6270,x:34582,y:33790,ptovrint:False,ptlb:OverlayFogAmount,ptin:_OverlayFogAmount,varname:_OverlayFogAmount,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,min:0,cur:0,max:1;n:type:ShaderForge.SFN_Tex2d,id:8554,x:35697,y:32917,ptovrint:False,ptlb:Global Normal,ptin:_GlobalNormal,varname:_NormalMap,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:True,tagnrm:True,ntxv:3,isnm:True;n:type:ShaderForge.SFN_ValueProperty,id:5510,x:35308,y:33579,ptovrint:False,ptlb:OverlayFogStartHeight,ptin:_OverlayFogStartHeight,varname:_OverlayFogStartHeight,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,v1:0;n:type:ShaderForge.SFN_ValueProperty,id:4995,x:35446,y:33579,ptovrint:False,ptlb:OverlayFogHeightTransition,ptin:_OverlayFogHeightTransition,varname:_OverlayFogHeightTransition,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,v1:300;n:type:ShaderForge.SFN_ValueProperty,id:3386,x:35589,y:33579,ptovrint:False,ptlb:OverlayFogDistance2Height,ptin:_OverlayFogDistance2Height,varname:_OverlayFogDistance2Height,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,v1:10;n:type:ShaderForge.SFN_FragmentPosition,id:3971,x:35726,y:33511,varname:node_3971,prsc:2;n:type:ShaderForge.SFN_Color,id:2859,x:34237,y:34234,ptovrint:False,ptlb:SnowColor,ptin:_SnowColor,varname:_SnowColor,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,c1:0.8931949,c2:0.9191236,c3:0.9411765,c4:1;n:type:ShaderForge.SFN_Slider,id:3521,x:34237,y:34453,ptovrint:False,ptlb:SnowAmount,ptin:_SnowAmount,varname:_SnowAmount,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,min:0,cur:0,max:1;n:type:ShaderForge.SFN_Vector1,id:4447,x:35801,y:34425,varname:node_4447,prsc:2,v1:0;n:type:ShaderForge.SFN_Lerp,id:5905,x:35801,y:34475,varname:node_5905,prsc:2|A-4080-OUT,B-4447-OUT,T-7240-OUT;n:type:ShaderForge.SFN_Code,id:9684,x:35031,y:33649,varname:MyFog,prsc:2,code:ZgBsAG8AYQB0ACAAZgBvAGcAVgBhAGwAPQAxAC0AcwBhAHQAdQByAGEAdABlACgAKABkAGkAcwB0AC0AcwB0AGEAcgB0AEQAaQBzAHQAYQBuAGMAZQApAC8AKABlAG4AZABEAGkAcwB0AGEAbgBjAGUAKwBzAHQAYQByAHQARABpAHMAdABhAG4AYwBlACkAKQA7AAoAZgBvAGcAVgBhAGwAPQAxAC0AZgBvAGcAVgBhAGwAKgBmAG8AZwBWAGEAbAA7AAoAZgBsAG8AYQB0ACAAZgBvAGcASABlAGkAZwBoAHQAVgBhAGwAPQBzAGEAdAB1AHIAYQB0AGUAKAAoAHcAbwByAGwAZABQAG8AcwAtAHMAdABhAHIAdABIAGUAaQBnAGgAdAAtAGgAZQBpAGcAaAB0AE8AZgBmAHMAZQB0ACoAZgBvAGcAVgBhAGwAKgBmAG8AZwBWAGEAbAApACAALwAgACgAZQBuAGQASABlAGkAZwBoAHQAKwBzAHQAYQByAHQASABlAGkAZwBoAHQAKQApADsACgBmAG8AZwBIAGUAaQBnAGgAdABWAGEAbAA9ACgAMQAtAGYAbwBnAEgAZQBpAGcAaAB0AFYAYQBsACkAOwAKAGYAbwBnAEgAZQBpAGcAaAB0AFYAYQBsACoAPQBmAG8AZwBIAGUAaQBnAGgAdABWAGEAbAA7AAoAZgBvAGcAVgBhAGwAIAAqAD0AIABmAG8AZwBIAGUAaQBnAGgAdABWAGEAbAAqAGYAbwBnAEEAbQBvAHUAbgB0ADsACgByAGUAdAB1AHIAbgAgAGYAbwBnAFYAYQBsADsA,output:0,fname:FogValue,width:794,height:208,input:0,input:0,input:0,input:0,input:0,input:0,input:0,input:0,input_1_label:dist,input_2_label:startDistance,input_3_label:endDistance,input_4_label:startHeight,input_5_label:endHeight,input_6_label:heightOffset,input_7_label:worldPos,input_8_label:fogAmount|A-5478-OUT,B-5063-OUT,C-6501-OUT,D-5510-OUT,E-4995-OUT,F-3386-OUT,G-3971-Y,H-6270-OUT;n:type:ShaderForge.SFN_Vector1,id:7994,x:36716,y:33285,varname:node_7994,prsc:2,v1:0;n:type:ShaderForge.SFN_ValueProperty,id:2176,x:35283,y:35011,ptovrint:False,ptlb:Ambient Multi,ptin:_AmbientMulti,varname:_AmbientMulti,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,v1:1;n:type:ShaderForge.SFN_Multiply,id:4080,x:35604,y:34475,varname:node_4080,prsc:2|A-7545-OUT,B-4436-OUT;n:type:ShaderForge.SFN_ValueProperty,id:7545,x:35604,y:34421,ptovrint:False,ptlb:Diffuse Multi,ptin:_DiffuseMulti,varname:_DiffuseMulti,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,v1:1;n:type:ShaderForge.SFN_Code,id:5825,x:35496,y:34851,varname:node_5825,prsc:2,code:cgBlAHQAdQByAG4AIABTAGgAYQBkAGUAUwBIADkAKABmAGwAbwBhAHQANAAoAE4AbwByAG0AYQBsAEQAaQByACwAMQApACkAKgAoAEEAbQBiAGkAZQBuAHQATQB1AGwAdABpACoAMgApADsA,output:2,fname:Ambient,width:389,height:112,input:2,input:0,input_1_label:NormalDir,input_2_label:AmbientMulti|A-8-OUT,B-2176-OUT;n:type:ShaderForge.SFN_NormalVector,id:8,x:35283,y:34852,prsc:2,pt:True;n:type:ShaderForge.SFN_ViewVector,id:4844,x:34708,y:34093,varname:node_4844,prsc:2;n:type:ShaderForge.SFN_Slider,id:814,x:35036,y:34078,ptovrint:False,ptlb:OverlayFogAmountFromReflCubemap,ptin:_OverlayFogAmountFromReflCubemap,varname:_OverlayFogAmountFromReflCubemap,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,min:0,cur:0.5,max:1;n:type:ShaderForge.SFN_Code,id:4590,x:35031,y:33886,varname:node_4590,prsc:2,code:ZgBsAG8AYQB0ADMAIABmAG8AZwBWAGkAZQB3AEQAaQByAGUAYwB0AGkAbwBuAD0ALQBWAGkAZQB3AEQAaQByAGUAYwB0AGkAbwBuADsACgBmAG8AZwBWAGkAZQB3AEQAaQByAGUAYwB0AGkAbwBuAC4AeQA9AGEAYgBzACgAZgBvAGcAVgBpAGUAdwBEAGkAcgBlAGMAdABpAG8AbgAuAHkAKQA7AAoAaABhAGwAZgAzACAAYQBtAGIAaQBlAG4AdABGAG8AZwBDAG8AbAAgAD0AIABTAGgAYQBkAGUAUwBIADkAKABmAGwAbwBhAHQANAAoAGYAbwBnAFYAaQBlAHcARABpAHIAZQBjAHQAaQBvAG4ALAAxACkAKQAuAHIAZwBiACoAMgA7AAoAaABhAGwAZgAzACAAZgBvAGcAQwBvAGwAbwByAD0AbABlAHIAcAAoAE8AdgBlAHIAbABhAHkARgBvAGcAQwBvAGwAbwByAC4AcgBnAGIALAAgAGEAbQBiAGkAZQBuAHQARgBvAGcAQwBvAGwALAAgAEEARgByAG8AbQBBAG0AYgBpAGUAbgB0ACkAOwAKACMAZABlAGYAaQBuAGUAIABSAEUARgBMAEUAQwBUAEkATwBOAF8AUABSAE8AQgBFAF8ARgBPAEcAXwBNAEkAUABMAEUAVgBFAEwAIAAoAEYAbwBnAFYAYQBsACoAMgArADMAKQAKAGgAYQBsAGYANAAgAHIAZwBiAG0AZgAgAD0AIABTAGEAbQBwAGwAZQBDAHUAYgBlAFIAZQBmAGwAZQBjAHQAaQBvAG4AKAAgAHUAbgBpAHQAeQBfAFMAcABlAGMAQwB1AGIAZQAwACwAIABmAG8AZwBWAGkAZQB3AEQAaQByAGUAYwB0AGkAbwBuACwAIABSAEUARgBMAEUAQwBUAEkATwBOAF8AUABSAE8AQgBFAF8ARgBPAEcAXwBNAEkAUABMAEUAVgBFAEwAIAApADsACgBoAGEAbABmADMAIABmAG8AZwBTAGMAYQB0AHQAZQByAFYAYQBsAHUAZQAgAD0AIABEAGUAYwBvAGQAZQBIAEQAUgBfAE4AbwBMAGkAbgBlAGEAcgBTAHUAcABwAG8AcgB0AEkAbgBTAE0AMgAgACgAcgBnAGIAbQBmACwAIAB1AG4AaQB0AHkAXwBTAHAAZQBjAEMAdQBiAGUAMABfAEgARABSACkAOwAKAGYAbwBnAEMAbwBsAG8AcgAgACsAPQAgAGYAbwBnAFMAYwBhAHQAdABlAHIAVgBhAGwAdQBlACoAQwB1AGIAZQBBAGQAZAA7AAoAaABhAGwAZgAzACAAZgBpAG4AYQBsAEYAbwBnAEMAbwBsAG8AcgAgAD0AIABsAGUAcgBwACgAMAAsACAAZgBvAGcAQwBvAGwAbwByACwAIABGAG8AZwBWAGEAbAApADsACgByAGUAdAB1AHIAbgAgAGYAaQBuAGEAbABGAG8AZwBDAG8AbABvAHIAOwA=,output:6,fname:FogColor,width:795,height:166,input:0,input:6,input:4,input:2,input:0,input_1_label:FogVal,input_2_label:OverlayFogColor,input_3_label:AFromAmbient,input_4_label:ViewDirection,input_5_label:CubeAdd|A-790-OUT,B-7083-RGB,C-7083-A,D-4844-OUT,E-814-OUT;n:type:ShaderForge.SFN_Code,id:3420,x:34802,y:34495,varname:node_3420,prsc:2,code:ZgBsAG8AYQB0ACAAUwBuAG8AdwBWAGEAbAAgAD0AIABTAG4AbwB3AEEAbQAqADIAOwAKAGYAbABvAGEAdAAgAEgAZQBpAGcAaAB0AEYAYQBjAHQAbwByACAAPQAgAHMAYQB0AHUAcgBhAHQAZQAoACgAQgBhAHMAZQBIAGUAaQBnAGgAdAAgAC0AIABXAG8AcgBsAGQAUABvAHMAWQApAC8ASABlAGkAZwBoAHQAVAByAGEAbgBzAGkAdABpAG8AbgApACoANAA7AAoAUwBuAG8AdwBWAGEAbAAgACsAPQAgAEgAZQBpAGcAaAB0AEYAYQBjAHQAbwByACAAPAAgADAAIAA/ACAAMAAgADoAIAAtAEgAZQBpAGcAaAB0AEYAYQBjAHQAbwByADsACgBoAGEAbABmADMAIABEAGUAUwBhAHQAQwBvAGwAbwByACAAPQAgADEALQBkAG8AdAAoAEQAaQBmAGYAdQBzAGUAQwBvAGwALAAgAGYAbABvAGEAdAAzACgAMAAuADQALAAwAC4ANAAsADAALgA0ACkAKQA7AAoARABlAFMAYQB0AEMAbwBsAG8AcgAgACoAPQAgAEQAZQBTAGEAdABDAG8AbABvAHIAOwAKAFMAbgBvAHcAVgBhAGwAIAAtAD0AIABEAGUAUwBhAHQAQwBvAGwAbwByACoAQwBvAGwAbwByAEQAYQBtAHAAOwAKAFMAbgBvAHcAVgBhAGwAIAAtAD0AIAAoAFMAbABvAHAAZQBEAGEAbQBwACoAMAAuADYANQApACoAKAAxAC0ATgBvAHIAbQBhAGwARABpAHIALgB5ACkAOwAKAFMAbgBvAHcAVgBhAGwAIAA9ACAAcwBhAHQAdQByAGEAdABlACgAUwBuAG8AdwBWAGEAbAApADsACgBTAG4AbwB3AFYAYQBsACAAKgA9ACAAUwBuAG8AdwBWAGEAbAA7AAoAUwBuAG8AdwBWAGEAbAAgACoAPQAgAFMAbgBvAHcAVgBhAGwAOwAKAGgAYQBsAGYAMwAgAEMAbwBsACAAPQAgAGwAZQByAHAAKABEAGkAZgBmAHUAcwBlAEMAbwBsACwAIABTAG4AbwB3AEMAbwBsACwAIABTAG4AbwB3AFYAYQBsACkAOwAKAGgAYQBsAGYANAAgAFIARwBCAEEAIAA9ACAAaABhAGwAZgA0ACgAQwBvAGwALAAgAFMAbgBvAHcAVgBhAGwAKQA7AAoAcgBlAHQAdQByAG4AIABSAEcAQgBBADsA,output:7,fname:Snow,width:570,height:228,input:2,input:0,input:6,input:0,input:0,input:0,input:0,input:0,input:6,input_1_label:NormalDir,input_2_label:WorldPosY,input_3_label:SnowCol,input_4_label:SnowAm,input_5_label:SlopeDamp,input_6_label:ColorDamp,input_7_label:BaseHeight,input_8_label:HeightTransition,input_9_label:DiffuseCol|A-6046-OUT,B-5629-Y,C-8480-OUT,D-3521-OUT,E-8893-OUT,F-5671-OUT,G-7335-OUT,H-9781-OUT,I-3559-OUT;n:type:ShaderForge.SFN_FragmentPosition,id:5629,x:34802,y:34298,varname:node_5629,prsc:2;n:type:ShaderForge.SFN_Slider,id:8893,x:34237,y:34540,ptovrint:False,ptlb:SnowSlopeDamp,ptin:_SnowSlopeDamp,varname:_SnowSlopeDamp,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,min:0,cur:0,max:4;n:type:ShaderForge.SFN_ValueProperty,id:7335,x:34394,y:34711,ptovrint:False,ptlb:SnowHeight,ptin:_SnowHeight,varname:_SnowHeight,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,v1:0;n:type:ShaderForge.SFN_ValueProperty,id:9781,x:34394,y:34783,ptovrint:False,ptlb:SnowHeightTransition,ptin:_SnowHeightTransition,varname:_SnowHeightTransition,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,v1:0;n:type:ShaderForge.SFN_NormalVector,id:6046,x:34985,y:34298,prsc:2,pt:True;n:type:ShaderForge.SFN_Slider,id:5671,x:34237,y:34625,ptovrint:False,ptlb:SnowOutputColorBrightness2Coverage,ptin:_SnowOutputColorBrightness2Coverage,varname:_SnowOutputColorBrightness2Coverage,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,min:0,cur:0,max:1;n:type:ShaderForge.SFN_ComponentMask,id:4436,x:35432,y:34495,varname:node_4436,prsc:2,cc1:0,cc2:1,cc3:2,cc4:-1|IN-3420-OUT;n:type:ShaderForge.SFN_Set,id:4201,x:35938,y:34851,varname:DiffuseAmbient,prsc:2|IN-5825-OUT;n:type:ShaderForge.SFN_Get,id:8924,x:36716,y:33438,varname:node_8924,prsc:2|IN-4201-OUT;n:type:ShaderForge.SFN_Set,id:7796,x:35918,y:33892,varname:Fog,prsc:2|IN-4590-OUT;n:type:ShaderForge.SFN_Get,id:2545,x:36716,y:33391,varname:node_2545,prsc:2|IN-7796-OUT;n:type:ShaderForge.SFN_Set,id:6774,x:35918,y:33649,varname:FogVal,prsc:2|IN-9684-OUT;n:type:ShaderForge.SFN_Get,id:790,x:34687,y:33887,varname:node_790,prsc:2|IN-6774-OUT;n:type:ShaderForge.SFN_Get,id:7240,x:35604,y:34600,varname:node_7240,prsc:2|IN-6774-OUT;n:type:ShaderForge.SFN_Set,id:3014,x:35949,y:34475,varname:FinalDiffuse,prsc:2|IN-5905-OUT;n:type:ShaderForge.SFN_Get,id:5870,x:36716,y:33238,varname:node_5870,prsc:2|IN-3014-OUT;n:type:ShaderForge.SFN_Set,id:1565,x:35893,y:32108,varname:DiffuseChain,prsc:2|IN-3998-OUT;n:type:ShaderForge.SFN_Get,id:3559,x:34373,y:34838,varname:node_3559,prsc:2|IN-1565-OUT;n:type:ShaderForge.SFN_Set,id:2470,x:35906,y:32917,varname:NormalChain,prsc:2|IN-8554-RGB;n:type:ShaderForge.SFN_Get,id:5053,x:36716,y:33345,varname:node_5053,prsc:2|IN-2470-OUT;n:type:ShaderForge.SFN_Tex2d,id:4756,x:34849,y:32260,ptovrint:False,ptlb:Grass Diffuse,ptin:_GrassDiffuse,varname:node_4756,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,ntxv:0,isnm:False;n:type:ShaderForge.SFN_Tex2d,id:5590,x:34849,y:31924,ptovrint:False,ptlb:Rock Diffuse,ptin:_RockDiffuse,varname:node_5590,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,ntxv:0,isnm:False;n:type:ShaderForge.SFN_Tex2d,id:7646,x:35077,y:32432,ptovrint:False,ptlb:Dirt Diffuse,ptin:_DirtDiffuse,varname:node_7646,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,ntxv:0,isnm:False;n:type:ShaderForge.SFN_Tex2d,id:3068,x:35778,y:35227,ptovrint:False,ptlb:Splat,ptin:_Splat,varname:node_3068,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:True,tagnrm:False,ntxv:0,isnm:False;n:type:ShaderForge.SFN_Set,id:7320,x:35949,y:35212,varname:SplatGrass,prsc:2|IN-3068-R;n:type:ShaderForge.SFN_Set,id:6984,x:35949,y:35258,varname:SplatDirt,prsc:2|IN-3068-G;n:type:ShaderForge.SFN_Set,id:8888,x:35949,y:35305,varname:AO,prsc:2|IN-3068-B;n:type:ShaderForge.SFN_Lerp,id:5176,x:35283,y:32130,varname:node_5176,prsc:2|A-8754-OUT,B-9130-OUT,T-6005-OUT;n:type:ShaderForge.SFN_Lerp,id:9515,x:35510,y:32130,varname:node_9515,prsc:2|A-5176-OUT,B-939-OUT,T-6241-OUT;n:type:ShaderForge.SFN_Get,id:6005,x:35056,y:32366,varname:node_6005,prsc:2|IN-7320-OUT;n:type:ShaderForge.SFN_Get,id:6241,x:35262,y:32366,varname:node_6241,prsc:2|IN-6984-OUT;n:type:ShaderForge.SFN_Get,id:7063,x:35510,y:32286,varname:node_7063,prsc:2|IN-8888-OUT;n:type:ShaderForge.SFN_Multiply,id:8754,x:35077,y:32129,varname:node_8754,prsc:2|A-5590-RGB,B-5999-RGB;n:type:ShaderForge.SFN_Color,id:5999,x:34849,y:32098,ptovrint:False,ptlb:Rock Tint,ptin:_RockTint,varname:node_5999,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,c1:1,c2:1,c3:1,c4:1;n:type:ShaderForge.SFN_Multiply,id:9130,x:35077,y:32248,varname:node_9130,prsc:2|A-4756-RGB,B-2846-RGB;n:type:ShaderForge.SFN_Color,id:2846,x:34849,y:32432,ptovrint:False,ptlb:Grass Tint,ptin:_GrassTint,varname:node_2846,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,c1:1,c2:1,c3:1,c4:1;n:type:ShaderForge.SFN_Multiply,id:939,x:35283,y:32248,varname:node_939,prsc:2|A-7646-RGB,B-6520-RGB;n:type:ShaderForge.SFN_Color,id:6520,x:35077,y:32603,ptovrint:False,ptlb:Dirt Tint,ptin:_DirtTint,varname:node_6520,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,c1:1,c2:1,c3:1,c4:1;n:type:ShaderForge.SFN_Get,id:7235,x:36716,y:33485,varname:node_7235,prsc:2|IN-8888-OUT;n:type:ShaderForge.SFN_Multiply,id:8480,x:34394,y:34298,varname:node_8480,prsc:2|A-2859-RGB,B-4379-OUT;n:type:ShaderForge.SFN_ValueProperty,id:4379,x:34237,y:34387,ptovrint:False,ptlb:Diffuse Snow,ptin:_DiffuseSnow,varname:node_4379,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,v1:1;proporder:7545-2176-4379-1304-3068-8554-5999-5590-2846-4756-6520-7646-6270-7083-814-5063-6501-5510-4995-3386-3521-2859-8893-7335-5671-9781;pass:END;sub:END;*/

Shader "Horizon[ON]/Horizon[ON] Mountains(Mobile)" {
    Properties {
        _DiffuseMulti ("Diffuse Multi", Float ) = 1
        _AmbientMulti ("Ambient Multi", Float ) = 1
        _DiffuseSnow ("Diffuse Snow", Float ) = 1
        _GlobalTint ("Global Tint", Color) = (1,1,1,1)
        [NoScaleOffset]_Splat ("Splat", 2D) = "white" {}
        [NoScaleOffset][Normal]_GlobalNormal ("Global Normal", 2D) = "bump" {}
        _RockTint ("Rock Tint", Color) = (1,1,1,1)
        _RockDiffuse ("Rock Diffuse", 2D) = "white" {}
        _GrassTint ("Grass Tint", Color) = (1,1,1,1)
        _GrassDiffuse ("Grass Diffuse", 2D) = "white" {}
        _DirtTint ("Dirt Tint", Color) = (1,1,1,1)
        _DirtDiffuse ("Dirt Diffuse", 2D) = "white" {}
        _OverlayFogAmount ("OverlayFogAmount", Range(0, 1)) = 0
        _OverlayFogColorAfromAmbient ("OverlayFogColorAfromAmbient", Color) = (1,1,1,1)
        _OverlayFogAmountFromReflCubemap ("OverlayFogAmountFromReflCubemap", Range(0, 1)) = 0.5
        _OverlayFogStartDistance ("OverlayFogStartDistance", Float ) = 0
        _OverlayFogDistanceTransition ("OverlayFogDistanceTransition", Float ) = 2500
        _OverlayFogStartHeight ("OverlayFogStartHeight", Float ) = 0
        _OverlayFogHeightTransition ("OverlayFogHeightTransition", Float ) = 300
        _OverlayFogDistance2Height ("OverlayFogDistance2Height", Float ) = 10
        _SnowAmount ("SnowAmount", Range(0, 1)) = 0
        _SnowColor ("SnowColor", Color) = (0.8931949,0.9191236,0.9411765,1)
        _SnowSlopeDamp ("SnowSlopeDamp", Range(0, 4)) = 0
        _SnowHeight ("SnowHeight", Float ) = 0
        _SnowOutputColorBrightness2Coverage ("SnowOutputColorBrightness2Coverage", Range(0, 1)) = 0
        _SnowHeightTransition ("SnowHeightTransition", Float ) = 0
    }
    SubShader {
        Tags {
            "RenderType"="Opaque"
        }
        Pass {
            Name "FORWARD"
            Tags {
                "LightMode"="ForwardBase"
            }
            
            
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #define UNITY_PASS_FORWARDBASE
            #define _GLOSSYENV 1
            #include "UnityCG.cginc"
            #include "AutoLight.cginc"
            #include "UnityPBSLighting.cginc"
            #include "UnityStandardBRDF.cginc"
            #pragma multi_compile_fwdbase_fullshadows
            #pragma multi_compile_fog
            #pragma only_renderers d3d9 d3d11 glcore gles gles3 d3d11_9x n3ds wiiu 
            #pragma target 3.0
            uniform float4 _GlobalTint;
            uniform float4 _OverlayFogColorAfromAmbient;
            uniform float _OverlayFogStartDistance;
            uniform float _OverlayFogDistanceTransition;
            uniform float _OverlayFogAmount;
            uniform sampler2D _GlobalNormal;
            uniform float _OverlayFogStartHeight;
            uniform float _OverlayFogHeightTransition;
            uniform float _OverlayFogDistance2Height;
            uniform float4 _SnowColor;
            uniform float _SnowAmount;
            float FogValue( float dist , float startDistance , float endDistance , float startHeight , float endHeight , float heightOffset , float worldPos , float fogAmount ){
            float fogVal=1-saturate((dist-startDistance)/(endDistance+startDistance));
            fogVal=1-fogVal*fogVal;
            float fogHeightVal=saturate((worldPos-startHeight-heightOffset*fogVal*fogVal) / (endHeight+startHeight));
            fogHeightVal=(1-fogHeightVal);
            fogHeightVal*=fogHeightVal;
            fogVal *= fogHeightVal*fogAmount;
            return fogVal;
            }
            
            uniform float _AmbientMulti;
            uniform float _DiffuseMulti;
            float3 Ambient( float3 NormalDir , float AmbientMulti ){
            return ShadeSH9(float4(NormalDir,1))*(AmbientMulti*2);
            }
            
            uniform float _OverlayFogAmountFromReflCubemap;
            half3 FogColor( float FogVal , half3 OverlayFogColor , half AFromAmbient , float3 ViewDirection , float CubeAdd ){
            float3 fogViewDirection=-ViewDirection;
            fogViewDirection.y=abs(fogViewDirection.y);
            half3 ambientFogCol = ShadeSH9(float4(fogViewDirection,1)).rgb*2;
            half3 fogColor=lerp(OverlayFogColor.rgb, ambientFogCol, AFromAmbient);
            #define REFLECTION_PROBE_FOG_MIPLEVEL (FogVal*2+3)
            half4 rgbmf = SampleCubeReflection( unity_SpecCube0, fogViewDirection, REFLECTION_PROBE_FOG_MIPLEVEL );
            half3 fogScatterValue = DecodeHDR_NoLinearSupportInSM2 (rgbmf, unity_SpecCube0_HDR);
            fogColor += fogScatterValue*CubeAdd;
            half3 finalFogColor = lerp(0, fogColor, FogVal);
            return finalFogColor;
            }
            
            half4 Snow( float3 NormalDir , float WorldPosY , half3 SnowCol , float SnowAm , float SlopeDamp , float ColorDamp , float BaseHeight , float HeightTransition , half3 DiffuseCol ){
            float SnowVal = SnowAm*2;
            float HeightFactor = saturate((BaseHeight - WorldPosY)/HeightTransition)*4;
            SnowVal += HeightFactor < 0 ? 0 : -HeightFactor;
            half3 DeSatColor = 1-dot(DiffuseCol, float3(0.4,0.4,0.4));
            DeSatColor *= DeSatColor;
            SnowVal -= DeSatColor*ColorDamp;
            SnowVal -= (SlopeDamp*0.65)*(1-NormalDir.y);
            SnowVal = saturate(SnowVal);
            SnowVal *= SnowVal;
            SnowVal *= SnowVal;
            half3 Col = lerp(DiffuseCol, SnowCol, SnowVal);
            half4 RGBA = half4(Col, SnowVal);
            return RGBA;
            }
            
            uniform float _SnowSlopeDamp;
            uniform float _SnowHeight;
            uniform float _SnowHeightTransition;
            uniform float _SnowOutputColorBrightness2Coverage;
            uniform sampler2D _GrassDiffuse; uniform float4 _GrassDiffuse_ST;
            uniform sampler2D _RockDiffuse; uniform float4 _RockDiffuse_ST;
            uniform sampler2D _DirtDiffuse; uniform float4 _DirtDiffuse_ST;
            uniform sampler2D _Splat;
            uniform float4 _RockTint;
            uniform float4 _GrassTint;
            uniform float4 _DirtTint;
            uniform float _DiffuseSnow;
            struct VertexInput {
                float4 vertex : POSITION;
                float3 normal : NORMAL;
                float4 tangent : TANGENT;
                float2 texcoord0 : TEXCOORD0;
            };
            struct VertexOutput {
                float4 pos : SV_POSITION;
                float2 uv0 : TEXCOORD0;
                float4 posWorld : TEXCOORD1;
                float3 normalDir : TEXCOORD2;
                float3 tangentDir : TEXCOORD3;
                float3 bitangentDir : TEXCOORD4;
                LIGHTING_COORDS(5,6)
                UNITY_FOG_COORDS(7)
            };
            VertexOutput vert (VertexInput v) {
                VertexOutput o = (VertexOutput)0;
                o.uv0 = v.texcoord0;
                o.normalDir = UnityObjectToWorldNormal(v.normal);
                o.tangentDir = normalize( mul( unity_ObjectToWorld, float4( v.tangent.xyz, 0.0 ) ).xyz );
                o.bitangentDir = normalize(cross(o.normalDir, o.tangentDir) * v.tangent.w);
                o.posWorld = mul(unity_ObjectToWorld, v.vertex);
                float3 lightColor = _LightColor0.rgb;
                o.pos = UnityObjectToClipPos( v.vertex );
                UNITY_TRANSFER_FOG(o,o.pos);
                TRANSFER_VERTEX_TO_FRAGMENT(o)
                return o;
            }
            float4 frag(VertexOutput i) : COLOR {
                i.normalDir = normalize(i.normalDir);
                float3x3 tangentTransform = float3x3( i.tangentDir, i.bitangentDir, i.normalDir);
                float3 viewDirection = normalize(_WorldSpaceCameraPos.xyz - i.posWorld.xyz);
                float3 _GlobalNormal_var = UnpackNormal(tex2D(_GlobalNormal,i.uv0));
                float3 NormalChain = _GlobalNormal_var.rgb;
                float3 normalLocal = NormalChain;
                float3 normalDirection = normalize(mul( normalLocal, tangentTransform )); // Perturbed normals
                float3 viewReflectDirection = reflect( -viewDirection, normalDirection );
                float3 lightDirection = normalize(_WorldSpaceLightPos0.xyz);
                float3 lightColor = _LightColor0.rgb;
////// Lighting:
                float attenuation = LIGHT_ATTENUATION(i);
                float3 attenColor = attenuation * _LightColor0.xyz;
///////// Gloss:
                float node_7994 = 0.0;
                float gloss = node_7994;
                float specPow = gloss;
/////// GI Data:
                UnityLight light;
                #ifdef LIGHTMAP_OFF
                    light.color = lightColor;
                    light.dir = lightDirection;
                    light.ndotl = LambertTerm (normalDirection, light.dir);
                #else
                    light.color = half3(0.f, 0.f, 0.f);
                    light.ndotl = 0.0f;
                    light.dir = half3(0.f, 0.f, 0.f);
                #endif
                UnityGIInput d;
                d.light = light;
                d.worldPos = i.posWorld.xyz;
                d.worldViewDir = viewDirection;
                d.atten = attenuation;
                #if UNITY_SPECCUBE_BLENDING || UNITY_SPECCUBE_BOX_PROJECTION
                    d.boxMin[0] = unity_SpecCube0_BoxMin;
                    d.boxMin[1] = unity_SpecCube1_BoxMin;
                #endif
                #if UNITY_SPECCUBE_BOX_PROJECTION
                    d.boxMax[0] = unity_SpecCube0_BoxMax;
                    d.boxMax[1] = unity_SpecCube1_BoxMax;
                    d.probePosition[0] = unity_SpecCube0_ProbePosition;
                    d.probePosition[1] = unity_SpecCube1_ProbePosition;
                #endif
                d.probeHDR[0] = unity_SpecCube0_HDR;
                d.probeHDR[1] = unity_SpecCube1_HDR;
                Unity_GlossyEnvironmentData ugls_en_data;
                ugls_en_data.roughness = 1.0 - gloss;
                ugls_en_data.reflUVW = viewReflectDirection;
                UnityGI gi = UnityGlobalIllumination(d, 1, normalDirection, ugls_en_data );
                lightDirection = gi.light.dir;
                lightColor = gi.light.color;
////// Specular:
                float NdotL = saturate(dot( normalDirection, lightDirection ));
                float3 specularColor = float3(node_7994,node_7994,node_7994);
                float3 directSpecular = attenColor * pow(max(0,dot(reflect(-lightDirection, normalDirection),viewDirection)),specPow)*specularColor;
                float3 indirectSpecular = (gi.indirect.specular)*specularColor;
                float3 specular = (directSpecular + indirectSpecular);
/////// Diffuse:
                NdotL = max(0.0,dot( normalDirection, lightDirection ));
                float3 directDiffuse = max( 0.0, NdotL) * attenColor;
                float3 indirectDiffuse = float3(0,0,0);
                float3 DiffuseAmbient = Ambient( normalDirection , _AmbientMulti );
                indirectDiffuse += DiffuseAmbient; // Diffuse Ambient Light
                float4 _Splat_var = tex2D(_Splat,i.uv0);
                float AO = _Splat_var.b;
                indirectDiffuse *= AO; // Diffuse AO
                float4 _RockDiffuse_var = tex2D(_RockDiffuse,TRANSFORM_TEX(i.uv0, _RockDiffuse));
                float4 _GrassDiffuse_var = tex2D(_GrassDiffuse,TRANSFORM_TEX(i.uv0, _GrassDiffuse));
                float SplatGrass = _Splat_var.r;
                float4 _DirtDiffuse_var = tex2D(_DirtDiffuse,TRANSFORM_TEX(i.uv0, _DirtDiffuse));
                float SplatDirt = _Splat_var.g;
                float3 node_9515 = lerp(lerp((_RockDiffuse_var.rgb*_RockTint.rgb),(_GrassDiffuse_var.rgb*_GrassTint.rgb),SplatGrass),(_DirtDiffuse_var.rgb*_DirtTint.rgb),SplatDirt);
                float3 DiffuseChain = (_GlobalTint.rgb*node_9515*AO);
                float node_4447 = 0.0;
                float FogVal = FogValue( distance(_WorldSpaceCameraPos,i.posWorld.rgb) , _OverlayFogStartDistance , _OverlayFogDistanceTransition , _OverlayFogStartHeight , _OverlayFogHeightTransition , _OverlayFogDistance2Height , i.posWorld.g , _OverlayFogAmount );
                float3 FinalDiffuse = lerp((_DiffuseMulti*Snow( normalDirection , i.posWorld.g , (_SnowColor.rgb*_DiffuseSnow) , _SnowAmount , _SnowSlopeDamp , _SnowOutputColorBrightness2Coverage , _SnowHeight , _SnowHeightTransition , DiffuseChain ).rgb),float3(node_4447,node_4447,node_4447),FogVal);
                float3 diffuseColor = FinalDiffuse;
                float3 diffuse = (directDiffuse + indirectDiffuse) * diffuseColor;
////// Emissive:
                float3 Fog = FogColor( FogVal , _OverlayFogColorAfromAmbient.rgb , _OverlayFogColorAfromAmbient.a , viewDirection , _OverlayFogAmountFromReflCubemap );
                float3 emissive = Fog;
/// Final Color:
                float3 finalColor = diffuse + specular + emissive;
                fixed4 finalRGBA = fixed4(finalColor,1);
                UNITY_APPLY_FOG(i.fogCoord, finalRGBA);
                return finalRGBA;
            }
            ENDCG
        }
    }
    FallBack "Diffuse"
    //CustomEditor "ShaderForgeMaterialInspector"
}
