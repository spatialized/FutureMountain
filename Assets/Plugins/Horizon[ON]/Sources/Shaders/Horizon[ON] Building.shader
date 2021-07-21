// Shader created with Shader Forge v1.38 
// Shader Forge (c) Neat Corporation / Joachim Holmer - http://www.acegikmo.com/shaderforge/
// Note: Manually altering this data may prevent you from opening it in Shader Forge
/*SF_DATA;ver:1.38;sub:START;pass:START;ps:flbk:,iptp:0,cusa:False,bamd:0,cgin:,lico:0,lgpr:1,limd:3,spmd:0,trmd:0,grmd:0,uamb:False,mssp:True,bkdf:False,hqlp:False,rprd:True,enco:True,rmgx:True,imps:True,rpth:0,vtps:0,hqsc:True,nrmq:1,nrsp:0,vomd:0,spxs:False,tesm:0,olmd:1,culm:0,bsrc:0,bdst:1,dpts:2,wrdp:True,dith:0,atcv:False,rfrpo:True,rfrpn:Refraction,coma:15,ufog:True,aust:True,igpj:False,qofs:0,qpre:1,rntp:1,fgom:False,fgoc:False,fgod:False,fgor:False,fgmd:0,fgcr:0.5,fgcg:0.5,fgcb:0.5,fgca:1,fgde:0.01,fgrn:0,fgrf:300,stcl:False,atwp:False,stva:128,stmr:255,stmw:255,stcp:6,stps:0,stfa:0,stfz:0,ofsf:0,ofsu:0,f2p0:False,fnsp:False,fnfb:False,fsmp:False;n:type:ShaderForge.SFN_Final,id:4013,x:36857,y:32652,varname:node_4013,prsc:2|diff-5905-OUT,spec-7994-OUT,gloss-6782-OUT,normal-8554-RGB,emission-6181-OUT,amdfl-3428-OUT;n:type:ShaderForge.SFN_Color,id:1304,x:34354,y:32687,ptovrint:False,ptlb:Building Tint,ptin:_BuildingTint,varname:_BuildingTint,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,c1:1,c2:1,c3:1,c4:1;n:type:ShaderForge.SFN_Tex2d,id:4380,x:34354,y:32844,ptovrint:False,ptlb:MainTex,ptin:_MainTex,varname:_MainTex,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:True,tagnrm:False,ntxv:0,isnm:False;n:type:ShaderForge.SFN_Multiply,id:3998,x:34551,y:32811,varname:node_3998,prsc:2|A-1304-RGB,B-4380-RGB;n:type:ShaderForge.SFN_Color,id:7083,x:34739,y:33873,ptovrint:False,ptlb:OverlayFogColorAfromAmbient,ptin:_OverlayFogColorAfromAmbient,varname:_OverlayFogColorAfromAmbient,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,c1:1,c2:1,c3:1,c4:1;n:type:ShaderForge.SFN_Distance,id:5478,x:34739,y:33650,varname:node_5478,prsc:2|A-5169-XYZ,B-4120-XYZ;n:type:ShaderForge.SFN_ViewPosition,id:5169,x:34435,y:33614,varname:node_5169,prsc:2;n:type:ShaderForge.SFN_FragmentPosition,id:4120,x:34435,y:33733,varname:node_4120,prsc:2;n:type:ShaderForge.SFN_ValueProperty,id:5063,x:35028,y:33579,ptovrint:False,ptlb:OverlayFogStartDistance,ptin:_OverlayFogStartDistance,varname:_OverlayFogStartDistance,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,v1:0;n:type:ShaderForge.SFN_ValueProperty,id:6501,x:35167,y:33579,ptovrint:False,ptlb:OverlayFogDistanceTransition,ptin:_OverlayFogDistanceTransition,varname:_OverlayFogDistanceTransition,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,v1:2500;n:type:ShaderForge.SFN_Slider,id:6270,x:34582,y:33790,ptovrint:False,ptlb:OverlayFogAmount,ptin:_OverlayFogAmount,varname:_OverlayFogAmount,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,min:0,cur:0,max:1;n:type:ShaderForge.SFN_Tex2d,id:8554,x:36500,y:32894,ptovrint:False,ptlb:Normal Map,ptin:_NormalMap,varname:_NormalMap,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:True,tagnrm:True,ntxv:3,isnm:True;n:type:ShaderForge.SFN_ValueProperty,id:5510,x:35308,y:33579,ptovrint:False,ptlb:OverlayFogStartHeight,ptin:_OverlayFogStartHeight,varname:_OverlayFogStartHeight,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,v1:0;n:type:ShaderForge.SFN_ValueProperty,id:4995,x:35446,y:33579,ptovrint:False,ptlb:OverlayFogHeightTransition,ptin:_OverlayFogHeightTransition,varname:_OverlayFogHeightTransition,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,v1:300;n:type:ShaderForge.SFN_ValueProperty,id:3386,x:35589,y:33579,ptovrint:False,ptlb:OverlayFogDistance2Height,ptin:_OverlayFogDistance2Height,varname:_OverlayFogDistance2Height,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,v1:10;n:type:ShaderForge.SFN_FragmentPosition,id:3971,x:35726,y:33511,varname:node_3971,prsc:2;n:type:ShaderForge.SFN_Color,id:2859,x:34803,y:32189,ptovrint:False,ptlb:SnowColor,ptin:_SnowColor,varname:_SnowColor,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,c1:0.8931949,c2:0.9191236,c3:0.9411765,c4:1;n:type:ShaderForge.SFN_Slider,id:3521,x:34646,y:32349,ptovrint:False,ptlb:SnowAmount,ptin:_SnowAmount,varname:_SnowAmount,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,min:0,cur:0,max:1;n:type:ShaderForge.SFN_Vector1,id:4447,x:36497,y:32603,varname:node_4447,prsc:2,v1:0;n:type:ShaderForge.SFN_Lerp,id:5905,x:36497,y:32653,varname:node_5905,prsc:2|A-4080-OUT,B-4447-OUT,T-9684-OUT;n:type:ShaderForge.SFN_Code,id:9684,x:35031,y:33649,varname:MyFog,prsc:2,code:ZgBsAG8AYQB0ACAAZgBvAGcAVgBhAGwAPQAxAC0AcwBhAHQAdQByAGEAdABlACgAKABkAGkAcwB0AC0AcwB0AGEAcgB0AEQAaQBzAHQAYQBuAGMAZQApAC8AKABlAG4AZABEAGkAcwB0AGEAbgBjAGUAKwBzAHQAYQByAHQARABpAHMAdABhAG4AYwBlACkAKQA7AAoAZgBvAGcAVgBhAGwAPQAxAC0AZgBvAGcAVgBhAGwAKgBmAG8AZwBWAGEAbAA7AAoAZgBsAG8AYQB0ACAAZgBvAGcASABlAGkAZwBoAHQAVgBhAGwAPQBzAGEAdAB1AHIAYQB0AGUAKAAoAHcAbwByAGwAZABQAG8AcwAtAHMAdABhAHIAdABIAGUAaQBnAGgAdAAtAGgAZQBpAGcAaAB0AE8AZgBmAHMAZQB0ACoAZgBvAGcAVgBhAGwAKgBmAG8AZwBWAGEAbAApACAALwAgACgAZQBuAGQASABlAGkAZwBoAHQAKwBzAHQAYQByAHQASABlAGkAZwBoAHQAKQApADsACgBmAG8AZwBIAGUAaQBnAGgAdABWAGEAbAA9ACgAMQAtAGYAbwBnAEgAZQBpAGcAaAB0AFYAYQBsACkAOwAKAGYAbwBnAEgAZQBpAGcAaAB0AFYAYQBsACoAPQBmAG8AZwBIAGUAaQBnAGgAdABWAGEAbAA7AAoAZgBvAGcAVgBhAGwAIAAqAD0AIABmAG8AZwBIAGUAaQBnAGgAdABWAGEAbAAqAGYAbwBnAEEAbQBvAHUAbgB0ADsACgByAGUAdAB1AHIAbgAgAGYAbwBnAFYAYQBsADsA,output:0,fname:FogValue,width:794,height:208,input:0,input:0,input:0,input:0,input:0,input:0,input:0,input:0,input_1_label:dist,input_2_label:startDistance,input_3_label:endDistance,input_4_label:startHeight,input_5_label:endHeight,input_6_label:heightOffset,input_7_label:worldPos,input_8_label:fogAmount|A-5478-OUT,B-5063-OUT,C-6501-OUT,D-5510-OUT,E-4995-OUT,F-3386-OUT,G-3971-Y,H-6270-OUT;n:type:ShaderForge.SFN_Vector1,id:7994,x:36500,y:32771,varname:node_7994,prsc:2,v1:0.01;n:type:ShaderForge.SFN_Relay,id:6181,x:36559,y:33050,varname:node_6181,prsc:2|IN-716-OUT;n:type:ShaderForge.SFN_ValueProperty,id:2176,x:35221,y:34177,ptovrint:False,ptlb:Ambient Multi,ptin:_AmbientMulti,varname:_AmbientMulti,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,v1:1;n:type:ShaderForge.SFN_Multiply,id:4080,x:36180,y:32654,varname:node_4080,prsc:2|A-7545-OUT,B-4436-OUT;n:type:ShaderForge.SFN_ValueProperty,id:7545,x:36180,y:32597,ptovrint:False,ptlb:Diffuse Multi,ptin:_DiffuseMulti,varname:_DiffuseMulti,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,v1:1;n:type:ShaderForge.SFN_Code,id:5825,x:35434,y:34225,varname:node_5825,prsc:2,code:cgBlAHQAdQByAG4AIABTAGgAYQBkAGUAUwBIADkAKABmAGwAbwBhAHQANAAoAE4AbwByAG0AYQBsAEQAaQByACwAMQApACkAKgAoAEEAbQBiAGkAZQBuAHQATQB1AGwAdABpACoAMgApADsA,output:2,fname:Ambient,width:389,height:112,input:2,input:0,input_1_label:NormalDir,input_2_label:AmbientMulti|A-8-OUT,B-2176-OUT;n:type:ShaderForge.SFN_NormalVector,id:8,x:35221,y:34226,prsc:2,pt:True;n:type:ShaderForge.SFN_ViewVector,id:4844,x:34739,y:34012,varname:node_4844,prsc:2;n:type:ShaderForge.SFN_Slider,id:814,x:35036,y:34078,ptovrint:False,ptlb:OverlayFogAmountFromReflCubemap,ptin:_OverlayFogAmountFromReflCubemap,varname:_OverlayFogAmountFromReflCubemap,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,min:0,cur:0.5,max:1;n:type:ShaderForge.SFN_Code,id:4590,x:35031,y:33886,varname:node_4590,prsc:2,code:ZgBsAG8AYQB0ADMAIABmAG8AZwBWAGkAZQB3AEQAaQByAGUAYwB0AGkAbwBuAD0ALQBWAGkAZQB3AEQAaQByAGUAYwB0AGkAbwBuADsACgBmAG8AZwBWAGkAZQB3AEQAaQByAGUAYwB0AGkAbwBuAC4AeQA9AGEAYgBzACgAZgBvAGcAVgBpAGUAdwBEAGkAcgBlAGMAdABpAG8AbgAuAHkAKQA7AAoAaABhAGwAZgAzACAAYQBtAGIAaQBlAG4AdABGAG8AZwBDAG8AbAAgAD0AIABTAGgAYQBkAGUAUwBIADkAKABmAGwAbwBhAHQANAAoAGYAbwBnAFYAaQBlAHcARABpAHIAZQBjAHQAaQBvAG4ALAAxACkAKQAuAHIAZwBiACoAMgA7AAoAaABhAGwAZgAzACAAZgBvAGcAQwBvAGwAbwByAD0AbABlAHIAcAAoAE8AdgBlAHIAbABhAHkARgBvAGcAQwBvAGwAbwByAC4AcgBnAGIALAAgAGEAbQBiAGkAZQBuAHQARgBvAGcAQwBvAGwALAAgAEEARgByAG8AbQBBAG0AYgBpAGUAbgB0ACkAOwAKACMAZABlAGYAaQBuAGUAIABSAEUARgBMAEUAQwBUAEkATwBOAF8AUABSAE8AQgBFAF8ARgBPAEcAXwBNAEkAUABMAEUAVgBFAEwAIAAoAEYAbwBnAFYAYQBsACoAMgArADMAKQAKAGgAYQBsAGYANAAgAHIAZwBiAG0AZgAgAD0AIABTAGEAbQBwAGwAZQBDAHUAYgBlAFIAZQBmAGwAZQBjAHQAaQBvAG4AKAAgAHUAbgBpAHQAeQBfAFMAcABlAGMAQwB1AGIAZQAwACwAIABmAG8AZwBWAGkAZQB3AEQAaQByAGUAYwB0AGkAbwBuACwAIABSAEUARgBMAEUAQwBUAEkATwBOAF8AUABSAE8AQgBFAF8ARgBPAEcAXwBNAEkAUABMAEUAVgBFAEwAIAApADsACgBoAGEAbABmADMAIABmAG8AZwBTAGMAYQB0AHQAZQByAFYAYQBsAHUAZQAgAD0AIABEAGUAYwBvAGQAZQBIAEQAUgBfAE4AbwBMAGkAbgBlAGEAcgBTAHUAcABwAG8AcgB0AEkAbgBTAE0AMgAgACgAcgBnAGIAbQBmACwAIAB1AG4AaQB0AHkAXwBTAHAAZQBjAEMAdQBiAGUAMABfAEgARABSACkAOwAKAGYAbwBnAEMAbwBsAG8AcgAgACsAPQAgAGYAbwBnAFMAYwBhAHQAdABlAHIAVgBhAGwAdQBlACoAQwB1AGIAZQBBAGQAZAA7AAoAaABhAGwAZgAzACAAZgBpAG4AYQBsAEYAbwBnAEMAbwBsAG8AcgAgAD0AIABsAGUAcgBwACgAMAAsACAAZgBvAGcAQwBvAGwAbwByACwAIABGAG8AZwBWAGEAbAApADsACgByAGUAdAB1AHIAbgAgAGYAaQBuAGEAbABGAG8AZwBDAG8AbABvAHIAOwA=,output:6,fname:FogColor,width:795,height:166,input:0,input:6,input:4,input:2,input:0,input_1_label:FogVal,input_2_label:OverlayFogColor,input_3_label:AFromAmbient,input_4_label:ViewDirection,input_5_label:CubeAdd|A-9684-OUT,B-7083-RGB,C-7083-A,D-4844-OUT,E-814-OUT;n:type:ShaderForge.SFN_Code,id:3420,x:35266,y:32654,varname:node_3420,prsc:2,code:ZgBsAG8AYQB0ACAAUwBuAG8AdwBWAGEAbAAgAD0AIABTAG4AbwB3AEEAbQAqADIAOwAKAGYAbABvAGEAdAAgAEgAZQBpAGcAaAB0AEYAYQBjAHQAbwByACAAPQAgAHMAYQB0AHUAcgBhAHQAZQAoACgAQgBhAHMAZQBIAGUAaQBnAGgAdAAgAC0AIABXAG8AcgBsAGQAUABvAHMAWQApAC8ASABlAGkAZwBoAHQAVAByAGEAbgBzAGkAdABpAG8AbgApACoANAA7AAoAUwBuAG8AdwBWAGEAbAAgACsAPQAgAEgAZQBpAGcAaAB0AEYAYQBjAHQAbwByACAAPAAgADAAIAA/ACAAMAAgADoAIAAtAEgAZQBpAGcAaAB0AEYAYQBjAHQAbwByADsACgBoAGEAbABmADMAIABEAGUAUwBhAHQAQwBvAGwAbwByACAAPQAgADEALQBkAG8AdAAoAEQAaQBmAGYAdQBzAGUAQwBvAGwALAAgAGYAbABvAGEAdAAzACgAMAAuADQALAAwAC4ANAAsADAALgA0ACkAKQA7AAoARABlAFMAYQB0AEMAbwBsAG8AcgAgACoAPQAgAEQAZQBTAGEAdABDAG8AbABvAHIAOwAKAFMAbgBvAHcAVgBhAGwAIAAtAD0AIABEAGUAUwBhAHQAQwBvAGwAbwByACoAQwBvAGwAbwByAEQAYQBtAHAAOwAKAFMAbgBvAHcAVgBhAGwAIAAtAD0AIAAoAFMAbABvAHAAZQBEAGEAbQBwACoAMAAuADMAKQAqACgAMQAtAE4AbwByAG0AYQBsAEQAaQByAC4AeQApADsACgBTAG4AbwB3AFYAYQBsACAAPQAgAHMAYQB0AHUAcgBhAHQAZQAoAFMAbgBvAHcAVgBhAGwAKQA7AAoAUwBuAG8AdwBWAGEAbAAgACoAPQAgAFMAbgBvAHcAVgBhAGwAOwAKAFMAbgBvAHcAVgBhAGwAIAAqAD0AIABTAG4AbwB3AFYAYQBsADsACgBoAGEAbABmADMAIABDAG8AbAAgAD0AIABsAGUAcgBwACgARABpAGYAZgB1AHMAZQBDAG8AbAAsACAAUwBuAG8AdwBDAG8AbAAsACAAUwBuAG8AdwBWAGEAbAApADsACgBoAGEAbABmADQAIABSAEcAQgBBACAAPQAgAGgAYQBsAGYANAAoAEMAbwBsACwAIABTAG4AbwB3AFYAYQBsACkAOwAKAHIAZQB0AHUAcgBuACAAUgBHAEIAQQA7AA==,output:7,fname:Snow,width:570,height:228,input:2,input:0,input:6,input:0,input:0,input:0,input:0,input:0,input:6,input_1_label:NormalDir,input_2_label:WorldPosY,input_3_label:SnowCol,input_4_label:SnowAm,input_5_label:SlopeDamp,input_6_label:ColorDamp,input_7_label:BaseHeight,input_8_label:HeightTransition,input_9_label:DiffuseCol|A-6046-OUT,B-5629-Y,C-2859-RGB,D-3521-OUT,E-8893-OUT,F-5671-OUT,G-7335-OUT,H-9781-OUT,I-3998-OUT;n:type:ShaderForge.SFN_FragmentPosition,id:5629,x:35266,y:32457,varname:node_5629,prsc:2;n:type:ShaderForge.SFN_Slider,id:8893,x:34646,y:32436,ptovrint:False,ptlb:SnowSlopeDamp,ptin:_SnowSlopeDamp,varname:_SnowSlopeDamp,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,min:0,cur:0,max:4;n:type:ShaderForge.SFN_ValueProperty,id:7335,x:34803,y:32607,ptovrint:False,ptlb:SnowHeight,ptin:_SnowHeight,varname:_SnowHeight,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,v1:0;n:type:ShaderForge.SFN_ValueProperty,id:9781,x:34803,y:32679,ptovrint:False,ptlb:SnowHeightTransition,ptin:_SnowHeightTransition,varname:_SnowHeightTransition,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,v1:0;n:type:ShaderForge.SFN_NormalVector,id:6046,x:35449,y:32457,prsc:2,pt:True;n:type:ShaderForge.SFN_Slider,id:5671,x:34646,y:32521,ptovrint:False,ptlb:SnowOutputColorBrightness2Coverage,ptin:_SnowOutputColorBrightness2Coverage,varname:_SnowOutputColorBrightness2Coverage,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,min:0,cur:0,max:1;n:type:ShaderForge.SFN_ComponentMask,id:4436,x:35989,y:32654,varname:node_4436,prsc:2,cc1:0,cc2:1,cc3:2,cc4:-1|IN-3420-OUT;n:type:ShaderForge.SFN_Relay,id:3428,x:36559,y:33096,varname:node_3428,prsc:2|IN-5825-OUT;n:type:ShaderForge.SFN_Relay,id:6782,x:36559,y:32824,varname:node_6782,prsc:2|IN-1884-OUT;n:type:ShaderForge.SFN_Relay,id:1884,x:36239,y:32928,varname:node_1884,prsc:2|IN-4380-A;n:type:ShaderForge.SFN_Tex2d,id:3373,x:35379,y:33037,ptovrint:False,ptlb:Emission Map,ptin:_EmissionMap,varname:_EmissionMap,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,ntxv:2,isnm:False;n:type:ShaderForge.SFN_Color,id:1039,x:35379,y:33206,ptovrint:False,ptlb:Emission Color,ptin:_EmissionColor,varname:_EmissionColor,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,c1:1,c2:0.9707911,c3:0.7352941,c4:0.184;n:type:ShaderForge.SFN_Multiply,id:1877,x:35746,y:33127,varname:node_1877,prsc:2|A-3373-RGB,B-1039-RGB,C-4484-OUT;n:type:ShaderForge.SFN_Multiply,id:4484,x:35553,y:33252,varname:node_4484,prsc:2|A-1039-A,B-9535-OUT;n:type:ShaderForge.SFN_Vector1,id:9535,x:35379,y:33344,varname:node_9535,prsc:2,v1:5;n:type:ShaderForge.SFN_Add,id:716,x:36133,y:33211,varname:node_716,prsc:2|A-1877-OUT,B-4590-OUT;proporder:7545-2176-4380-1304-3373-1039-8554-6270-7083-814-5063-6501-5510-4995-3386-3521-2859-8893-7335-5671-9781;pass:END;sub:END;*/

Shader "Horizon[ON]/Horizon[ON] Building" {
    Properties {
        _DiffuseMulti ("Diffuse Multi", Float ) = 1
        _AmbientMulti ("Ambient Multi", Float ) = 1
        [NoScaleOffset]_MainTex ("MainTex", 2D) = "white" {}
        _BuildingTint ("Building Tint", Color) = (1,1,1,1)
        _EmissionMap ("Emission Map", 2D) = "black" {}
        _EmissionColor ("Emission Color", Color) = (1,0.9707911,0.7352941,0.184)
        [NoScaleOffset][Normal]_NormalMap ("Normal Map", 2D) = "bump" {}
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
            #pragma only_renderers d3d9 d3d11 glcore gles gles3 n3ds wiiu 
            #pragma target 3.0
            uniform float4 _BuildingTint;
            uniform sampler2D _MainTex;
            uniform float4 _OverlayFogColorAfromAmbient;
            uniform float _OverlayFogStartDistance;
            uniform float _OverlayFogDistanceTransition;
            uniform float _OverlayFogAmount;
            uniform sampler2D _NormalMap;
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
            SnowVal -= (SlopeDamp*0.3)*(1-NormalDir.y);
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
            uniform sampler2D _EmissionMap; uniform float4 _EmissionMap_ST;
            uniform float4 _EmissionColor;
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
                float3 _NormalMap_var = UnpackNormal(tex2D(_NormalMap,i.uv0));
                float3 normalLocal = _NormalMap_var.rgb;
                float3 normalDirection = normalize(mul( normalLocal, tangentTransform )); // Perturbed normals
                float3 viewReflectDirection = reflect( -viewDirection, normalDirection );
                float3 lightDirection = normalize(_WorldSpaceLightPos0.xyz);
                float3 lightColor = _LightColor0.rgb;
                float3 halfDirection = normalize(viewDirection+lightDirection);
////// Lighting:
                float attenuation = LIGHT_ATTENUATION(i);
                float3 attenColor = attenuation * _LightColor0.xyz;
                float Pi = 3.141592654;
                float InvPi = 0.31830988618;
///////// Gloss:
                float4 _MainTex_var = tex2D(_MainTex,i.uv0);
                float gloss = _MainTex_var.a;
                float perceptualRoughness = 1.0 - _MainTex_var.a;
                float roughness = perceptualRoughness * perceptualRoughness;
                float specPow = exp2( gloss * 10.0 + 1.0 );
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
                float LdotH = saturate(dot(lightDirection, halfDirection));
                float node_7994 = 0.01;
                float3 specularColor = float3(node_7994,node_7994,node_7994);
                float specularMonochrome;
                float node_4447 = 0.0;
                float MyFog = FogValue( distance(_WorldSpaceCameraPos,i.posWorld.rgb) , _OverlayFogStartDistance , _OverlayFogDistanceTransition , _OverlayFogStartHeight , _OverlayFogHeightTransition , _OverlayFogDistance2Height , i.posWorld.g , _OverlayFogAmount );
                float3 diffuseColor = lerp((_DiffuseMulti*Snow( normalDirection , i.posWorld.g , _SnowColor.rgb , _SnowAmount , _SnowSlopeDamp , _SnowOutputColorBrightness2Coverage , _SnowHeight , _SnowHeightTransition , (_BuildingTint.rgb*_MainTex_var.rgb) ).rgb),float3(node_4447,node_4447,node_4447),MyFog); // Need this for specular when using metallic
                diffuseColor = EnergyConservationBetweenDiffuseAndSpecular(diffuseColor, specularColor, specularMonochrome);
                specularMonochrome = 1.0-specularMonochrome;
                float NdotV = abs(dot( normalDirection, viewDirection ));
                float NdotH = saturate(dot( normalDirection, halfDirection ));
                float VdotH = saturate(dot( viewDirection, halfDirection ));
                float visTerm = SmithJointGGXVisibilityTerm( NdotL, NdotV, roughness );
                float normTerm = GGXTerm(NdotH, roughness);
                float specularPBL = (visTerm*normTerm) * UNITY_PI;
                #ifdef UNITY_COLORSPACE_GAMMA
                    specularPBL = sqrt(max(1e-4h, specularPBL));
                #endif
                specularPBL = max(0, specularPBL * NdotL);
                #if defined(_SPECULARHIGHLIGHTS_OFF)
                    specularPBL = 0.0;
                #endif
                half surfaceReduction;
                #ifdef UNITY_COLORSPACE_GAMMA
                    surfaceReduction = 1.0-0.28*roughness*perceptualRoughness;
                #else
                    surfaceReduction = 1.0/(roughness*roughness + 1.0);
                #endif
                specularPBL *= any(specularColor) ? 1.0 : 0.0;
                float3 directSpecular = attenColor*specularPBL*FresnelTerm(specularColor, LdotH);
                half grazingTerm = saturate( gloss + specularMonochrome );
                float3 indirectSpecular = (gi.indirect.specular);
                indirectSpecular *= FresnelLerp (specularColor, grazingTerm, NdotV);
                indirectSpecular *= surfaceReduction;
                float3 specular = (directSpecular + indirectSpecular);
/////// Diffuse:
                NdotL = max(0.0,dot( normalDirection, lightDirection ));
                half fd90 = 0.5 + 2 * LdotH * LdotH * (1-gloss);
                float nlPow5 = Pow5(1-NdotL);
                float nvPow5 = Pow5(1-NdotV);
                float3 directDiffuse = ((1 +(fd90 - 1)*nlPow5) * (1 + (fd90 - 1)*nvPow5) * NdotL) * attenColor;
                float3 indirectDiffuse = float3(0,0,0);
                indirectDiffuse += Ambient( normalDirection , _AmbientMulti ); // Diffuse Ambient Light
                diffuseColor *= 1-specularMonochrome;
                float3 diffuse = (directDiffuse + indirectDiffuse) * diffuseColor;
////// Emissive:
                float4 _EmissionMap_var = tex2D(_EmissionMap,TRANSFORM_TEX(i.uv0, _EmissionMap));
                float3 emissive = ((_EmissionMap_var.rgb*_EmissionColor.rgb*(_EmissionColor.a*5.0))+FogColor( MyFog , _OverlayFogColorAfromAmbient.rgb , _OverlayFogColorAfromAmbient.a , viewDirection , _OverlayFogAmountFromReflCubemap ));
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
