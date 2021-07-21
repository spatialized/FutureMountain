// Shader created with Shader Forge v1.38 
// Shader Forge (c) Neat Corporation / Joachim Holmer - http://www.acegikmo.com/shaderforge/
// Note: Manually altering this data may prevent you from opening it in Shader Forge
/*SF_DATA;ver:1.38;sub:START;pass:START;ps:flbk:,iptp:0,cusa:False,bamd:0,cgin:,lico:0,lgpr:1,limd:3,spmd:0,trmd:0,grmd:0,uamb:False,mssp:True,bkdf:False,hqlp:False,rprd:True,enco:True,rmgx:True,imps:False,rpth:0,vtps:0,hqsc:True,nrmq:1,nrsp:0,vomd:0,spxs:False,tesm:0,olmd:1,culm:0,bsrc:0,bdst:1,dpts:2,wrdp:True,dith:0,atcv:False,rfrpo:True,rfrpn:Refraction,coma:15,ufog:True,aust:True,igpj:False,qofs:0,qpre:1,rntp:1,fgom:False,fgoc:False,fgod:False,fgor:False,fgmd:0,fgcr:0.692398,fgcg:0.7166868,fgcb:0.722,fgca:1,fgde:0.00015,fgrn:0,fgrf:300,stcl:False,atwp:False,stva:128,stmr:255,stmw:255,stcp:6,stps:0,stfa:0,stfz:0,ofsf:0,ofsu:0,f2p0:False,fnsp:False,fnfb:False,fsmp:False;n:type:ShaderForge.SFN_Final,id:4013,x:36779,y:32826,varname:node_4013,prsc:2|diff-5870-OUT,spec-7994-OUT,gloss-7994-OUT,normal-5053-OUT,emission-2545-OUT,amdfl-8924-OUT;n:type:ShaderForge.SFN_Color,id:1304,x:35898,y:32968,ptovrint:False,ptlb:Diffuse Tint,ptin:_DiffuseTint,varname:_BuildingTint,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,c1:1,c2:1,c3:1,c4:1;n:type:ShaderForge.SFN_Tex2d,id:4380,x:35898,y:32798,ptovrint:False,ptlb:Diffuse Map,ptin:_DiffuseMap,varname:_MainTex,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,ntxv:1,isnm:False;n:type:ShaderForge.SFN_Multiply,id:3998,x:36085,y:32883,varname:node_3998,prsc:2|A-4380-RGB,B-1304-RGB;n:type:ShaderForge.SFN_Color,id:7083,x:37661,y:33239,ptovrint:False,ptlb:OverlayFogColorAfromAmbient,ptin:_OverlayFogColorAfromAmbient,varname:_OverlayFogColorAfromAmbient,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,c1:0.6452206,c2:0.6849645,c3:0.75,c4:1;n:type:ShaderForge.SFN_Distance,id:5478,x:37661,y:32914,varname:node_5478,prsc:2|A-5169-XYZ,B-4120-XYZ;n:type:ShaderForge.SFN_ViewPosition,id:5169,x:37369,y:32883,varname:node_5169,prsc:2;n:type:ShaderForge.SFN_FragmentPosition,id:4120,x:37369,y:33002,varname:node_4120,prsc:2;n:type:ShaderForge.SFN_ValueProperty,id:5063,x:37974,y:32845,ptovrint:False,ptlb:OverlayFogStartDistance,ptin:_OverlayFogStartDistance,varname:_OverlayFogStartDistance,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,v1:0;n:type:ShaderForge.SFN_ValueProperty,id:6501,x:38113,y:32845,ptovrint:False,ptlb:OverlayFogDistanceTransition,ptin:_OverlayFogDistanceTransition,varname:_OverlayFogDistanceTransition,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,v1:2500;n:type:ShaderForge.SFN_Slider,id:6270,x:37504,y:33054,ptovrint:False,ptlb:OverlayFogAmount,ptin:_OverlayFogAmount,varname:_OverlayFogAmount,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,min:0,cur:0,max:1;n:type:ShaderForge.SFN_Tex2d,id:8554,x:36086,y:33121,ptovrint:False,ptlb:Normal Map,ptin:_NormalMap,varname:_NormalMap,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:True,ntxv:3,isnm:True;n:type:ShaderForge.SFN_ValueProperty,id:5510,x:38254,y:32845,ptovrint:False,ptlb:OverlayFogStartHeight,ptin:_OverlayFogStartHeight,varname:_OverlayFogStartHeight,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,v1:0;n:type:ShaderForge.SFN_ValueProperty,id:4995,x:38392,y:32845,ptovrint:False,ptlb:OverlayFogHeightTransition,ptin:_OverlayFogHeightTransition,varname:_OverlayFogHeightTransition,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,v1:300;n:type:ShaderForge.SFN_ValueProperty,id:3386,x:38535,y:32845,ptovrint:False,ptlb:OverlayFogDistance2Height,ptin:_OverlayFogDistance2Height,varname:_OverlayFogDistance2Height,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,v1:10;n:type:ShaderForge.SFN_FragmentPosition,id:3971,x:38672,y:32777,varname:node_3971,prsc:2;n:type:ShaderForge.SFN_Color,id:2859,x:37259,y:33492,ptovrint:False,ptlb:SnowColor,ptin:_SnowColor,varname:_SnowColor,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,c1:0.8931949,c2:0.9191236,c3:0.9411765,c4:1;n:type:ShaderForge.SFN_Slider,id:3521,x:37259,y:33719,ptovrint:False,ptlb:SnowAmount,ptin:_SnowAmount,varname:_SnowAmount,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,min:0,cur:0,max:1;n:type:ShaderForge.SFN_Vector1,id:4447,x:38458,y:33858,varname:node_4447,prsc:2,v1:0;n:type:ShaderForge.SFN_Lerp,id:5905,x:38655,y:33741,varname:node_5905,prsc:2|A-4080-OUT,B-4447-OUT,T-7240-OUT;n:type:ShaderForge.SFN_Code,id:9684,x:37977,y:32915,varname:MyFog,prsc:2,code:ZgBsAG8AYQB0ACAAZgBvAGcAVgBhAGwAPQAxAC0AcwBhAHQAdQByAGEAdABlACgAKABkAGkAcwB0AC0AcwB0AGEAcgB0AEQAaQBzAHQAYQBuAGMAZQApAC8AKABlAG4AZABEAGkAcwB0AGEAbgBjAGUAKwBzAHQAYQByAHQARABpAHMAdABhAG4AYwBlACkAKQA7AAoAZgBvAGcAVgBhAGwAPQAxAC0AZgBvAGcAVgBhAGwAKgBmAG8AZwBWAGEAbAA7AAoAZgBsAG8AYQB0ACAAZgBvAGcASABlAGkAZwBoAHQAVgBhAGwAPQBzAGEAdAB1AHIAYQB0AGUAKAAoAHcAbwByAGwAZABQAG8AcwAtAHMAdABhAHIAdABIAGUAaQBnAGgAdAAtAGgAZQBpAGcAaAB0AE8AZgBmAHMAZQB0ACoAZgBvAGcAVgBhAGwAKgBmAG8AZwBWAGEAbAApACAALwAgACgAZQBuAGQASABlAGkAZwBoAHQAKwBzAHQAYQByAHQASABlAGkAZwBoAHQAKQApADsACgBmAG8AZwBIAGUAaQBnAGgAdABWAGEAbAA9ACgAMQAtAGYAbwBnAEgAZQBpAGcAaAB0AFYAYQBsACkAOwAKAGYAbwBnAEgAZQBpAGcAaAB0AFYAYQBsACoAPQBmAG8AZwBIAGUAaQBnAGgAdABWAGEAbAA7AAoAZgBvAGcAVgBhAGwAIAAqAD0AIABmAG8AZwBIAGUAaQBnAGgAdABWAGEAbAAqAGYAbwBnAEEAbQBvAHUAbgB0ADsACgByAGUAdAB1AHIAbgAgAGYAbwBnAFYAYQBsADsA,output:0,fname:FogValue,width:794,height:208,input:0,input:0,input:0,input:0,input:0,input:0,input:0,input:0,input_1_label:dist,input_2_label:startDistance,input_3_label:endDistance,input_4_label:startHeight,input_5_label:endHeight,input_6_label:heightOffset,input_7_label:worldPos,input_8_label:fogAmount|A-5478-OUT,B-5063-OUT,C-6501-OUT,D-5510-OUT,E-4995-OUT,F-3386-OUT,G-3971-Y,H-6270-OUT;n:type:ShaderForge.SFN_Vector1,id:7994,x:36568,y:32860,varname:node_7994,prsc:2,v1:0;n:type:ShaderForge.SFN_ValueProperty,id:2176,x:38168,y:34346,ptovrint:False,ptlb:Ambient Multi,ptin:_AmbientMulti,varname:_AmbientMulti,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,v1:1;n:type:ShaderForge.SFN_Multiply,id:4080,x:38458,y:33741,varname:node_4080,prsc:2|A-7545-OUT,B-3420-OUT;n:type:ShaderForge.SFN_ValueProperty,id:7545,x:38458,y:33687,ptovrint:False,ptlb:Diffuse Multi,ptin:_DiffuseMulti,varname:_DiffuseMulti,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,v1:1;n:type:ShaderForge.SFN_Code,id:5825,x:38383,y:34188,varname:node_5825,prsc:2,code:cgBlAHQAdQByAG4AIABTAGgAYQBkAGUAUwBIADkAKABmAGwAbwBhAHQANAAoAE4AbwByAG0AYQBsAEQAaQByACwAMQApACkAKgAoAEEAbQBiAGkAZQBuAHQATQB1AGwAdABpACoAMgApADsA,output:2,fname:Ambient,width:389,height:112,input:2,input:0,input_1_label:NormalDir,input_2_label:AmbientMulti|A-8-OUT,B-2176-OUT;n:type:ShaderForge.SFN_NormalVector,id:8,x:38168,y:34188,prsc:2,pt:True;n:type:ShaderForge.SFN_ViewVector,id:4844,x:37661,y:33377,varname:node_4844,prsc:2;n:type:ShaderForge.SFN_Slider,id:814,x:37978,y:33352,ptovrint:False,ptlb:OverlayFogAmountFromReflCubemap,ptin:_OverlayFogAmountFromReflCubemap,varname:_OverlayFogAmountFromReflCubemap,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,min:0,cur:0.5,max:1;n:type:ShaderForge.SFN_Code,id:4590,x:37977,y:33152,varname:node_4590,prsc:2,code:ZgBsAG8AYQB0ADMAIABmAG8AZwBWAGkAZQB3AEQAaQByAGUAYwB0AGkAbwBuAD0ALQBWAGkAZQB3AEQAaQByAGUAYwB0AGkAbwBuADsACgBmAG8AZwBWAGkAZQB3AEQAaQByAGUAYwB0AGkAbwBuAC4AeQA9AGEAYgBzACgAZgBvAGcAVgBpAGUAdwBEAGkAcgBlAGMAdABpAG8AbgAuAHkAKQA7AAoAaABhAGwAZgAzACAAYQBtAGIAaQBlAG4AdABGAG8AZwBDAG8AbAAgAD0AIABTAGgAYQBkAGUAUwBIADkAKABmAGwAbwBhAHQANAAoAGYAbwBnAFYAaQBlAHcARABpAHIAZQBjAHQAaQBvAG4ALAAxACkAKQAuAHIAZwBiACoAMgA7AAoAaABhAGwAZgAzACAAZgBvAGcAQwBvAGwAbwByAD0AbABlAHIAcAAoAE8AdgBlAHIAbABhAHkARgBvAGcAQwBvAGwAbwByAC4AcgBnAGIALAAgAGEAbQBiAGkAZQBuAHQARgBvAGcAQwBvAGwALAAgAEEARgByAG8AbQBBAG0AYgBpAGUAbgB0ACkAOwAKACMAZABlAGYAaQBuAGUAIABSAEUARgBMAEUAQwBUAEkATwBOAF8AUABSAE8AQgBFAF8ARgBPAEcAXwBNAEkAUABMAEUAVgBFAEwAIAAoAEYAbwBnAFYAYQBsACoAMgArADMAKQAKAGgAYQBsAGYANAAgAHIAZwBiAG0AZgAgAD0AIABTAGEAbQBwAGwAZQBDAHUAYgBlAFIAZQBmAGwAZQBjAHQAaQBvAG4AKAAgAHUAbgBpAHQAeQBfAFMAcABlAGMAQwB1AGIAZQAwACwAIABmAG8AZwBWAGkAZQB3AEQAaQByAGUAYwB0AGkAbwBuACwAIABSAEUARgBMAEUAQwBUAEkATwBOAF8AUABSAE8AQgBFAF8ARgBPAEcAXwBNAEkAUABMAEUAVgBFAEwAIAApADsACgBoAGEAbABmADMAIABmAG8AZwBTAGMAYQB0AHQAZQByAFYAYQBsAHUAZQAgAD0AIABEAGUAYwBvAGQAZQBIAEQAUgBfAE4AbwBMAGkAbgBlAGEAcgBTAHUAcABwAG8AcgB0AEkAbgBTAE0AMgAgACgAcgBnAGIAbQBmACwAIAB1AG4AaQB0AHkAXwBTAHAAZQBjAEMAdQBiAGUAMABfAEgARABSACkAOwAKAGYAbwBnAEMAbwBsAG8AcgAgACsAPQAgAGYAbwBnAFMAYwBhAHQAdABlAHIAVgBhAGwAdQBlACoAQwB1AGIAZQBBAGQAZAA7AAoAaABhAGwAZgAzACAAZgBpAG4AYQBsAEYAbwBnAEMAbwBsAG8AcgAgAD0AIABsAGUAcgBwACgARQBtAGkAcwBzAGkAbwBuAEMAaABhAGkAbgAsACAAZgBvAGcAQwBvAGwAbwByACwAIABGAG8AZwBWAGEAbAApADsACgByAGUAdAB1AHIAbgAgAGYAaQBuAGEAbABGAG8AZwBDAG8AbABvAHIAOwA=,output:6,fname:FogColor,width:795,height:168,input:6,input:0,input:6,input:4,input:2,input:0,input_1_label:EmissionChain,input_2_label:FogVal,input_3_label:OverlayFogColor,input_4_label:AFromAmbient,input_5_label:ViewDirection,input_6_label:CubeAdd|A-40-OUT,B-790-OUT,C-7083-RGB,D-7083-A,E-4844-OUT,F-814-OUT;n:type:ShaderForge.SFN_Code,id:3420,x:37824,y:33761,varname:node_3420,prsc:2,code:ZgBsAG8AYQB0ACAAUwBuAG8AdwBWAGEAbAAgAD0AIABTAG4AbwB3AEEAbQAqADIAOwAKAGYAbABvAGEAdAAgAEgAZQBpAGcAaAB0AEYAYQBjAHQAbwByACAAPQAgAHMAYQB0AHUAcgBhAHQAZQAoACgAQgBhAHMAZQBIAGUAaQBnAGgAdAAgAC0AIABXAG8AcgBsAGQAUABvAHMAWQApAC8ASABlAGkAZwBoAHQAVAByAGEAbgBzAGkAdABpAG8AbgApACoANAA7AAoAUwBuAG8AdwBWAGEAbAAgACsAPQAgAEgAZQBpAGcAaAB0AEYAYQBjAHQAbwByACAAPAAgADAAIAA/ACAAMAAgADoAIAAtAEgAZQBpAGcAaAB0AEYAYQBjAHQAbwByADsACgBoAGEAbABmADMAIABEAGUAUwBhAHQAQwBvAGwAbwByACAAPQAgADEALQBkAG8AdAAoAEQAaQBmAGYAdQBzAGUAQwBvAGwALAAgAGYAbABvAGEAdAAzACgAMAAuADQALAAwAC4ANAAsADAALgA0ACkAKQA7AAoARABlAFMAYQB0AEMAbwBsAG8AcgAgACoAPQAgAEQAZQBTAGEAdABDAG8AbABvAHIAOwAKAFMAbgBvAHcAVgBhAGwAIAAtAD0AIABEAGUAUwBhAHQAQwBvAGwAbwByACoAQwBvAGwAbwByAEQAYQBtAHAAOwAKAFMAbgBvAHcAVgBhAGwAIAAtAD0AIAAoAFMAbABvAHAAZQBEAGEAbQBwACoAMAAuADYANQApACoAKAAxAC0ATgBvAHIAbQBhAGwARABpAHIALgB5ACkAOwAKAFMAbgBvAHcAVgBhAGwAIAA9ACAAcwBhAHQAdQByAGEAdABlACgAUwBuAG8AdwBWAGEAbAApADsACgBTAG4AbwB3AFYAYQBsACAAKgA9ACAAUwBuAG8AdwBWAGEAbAA7AAoAUwBuAG8AdwBWAGEAbAAgACoAPQAgAFMAbgBvAHcAVgBhAGwAOwAKAHIAZQB0AHUAcgBuACAAbABlAHIAcAAoAEQAaQBmAGYAdQBzAGUAQwBvAGwALAAgAFMAbgBvAHcAQwBvAGwALAAgAFMAbgBvAHcAVgBhAGwAKQA7AA==,output:6,fname:Snow,width:570,height:228,input:2,input:0,input:6,input:0,input:0,input:0,input:0,input:0,input:6,input_1_label:NormalDir,input_2_label:WorldPosY,input_3_label:SnowCol,input_4_label:SnowAm,input_5_label:SlopeDamp,input_6_label:ColorDamp,input_7_label:BaseHeight,input_8_label:HeightTransition,input_9_label:DiffuseCol|A-6046-OUT,B-5629-Y,C-8480-OUT,D-3521-OUT,E-8893-OUT,F-5671-OUT,G-7335-OUT,H-9781-OUT,I-3559-OUT;n:type:ShaderForge.SFN_FragmentPosition,id:5629,x:37824,y:33564,varname:node_5629,prsc:2;n:type:ShaderForge.SFN_Slider,id:8893,x:37259,y:33806,ptovrint:False,ptlb:SnowSlopeDamp,ptin:_SnowSlopeDamp,varname:_SnowSlopeDamp,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,min:0,cur:0,max:4;n:type:ShaderForge.SFN_ValueProperty,id:7335,x:37416,y:33977,ptovrint:False,ptlb:SnowHeight,ptin:_SnowHeight,varname:_SnowHeight,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,v1:0;n:type:ShaderForge.SFN_ValueProperty,id:9781,x:37416,y:34049,ptovrint:False,ptlb:SnowHeightTransition,ptin:_SnowHeightTransition,varname:_SnowHeightTransition,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,v1:0;n:type:ShaderForge.SFN_NormalVector,id:6046,x:38007,y:33564,prsc:2,pt:True;n:type:ShaderForge.SFN_Slider,id:5671,x:37259,y:33891,ptovrint:False,ptlb:SnowOutputColorBrightness2Coverage,ptin:_SnowOutputColorBrightness2Coverage,varname:_SnowOutputColorBrightness2Coverage,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,min:0,cur:0,max:1;n:type:ShaderForge.SFN_Set,id:4201,x:38819,y:34188,varname:DiffuseAmbient,prsc:2|IN-5825-OUT;n:type:ShaderForge.SFN_Get,id:8924,x:36568,y:33008,varname:node_8924,prsc:2|IN-4201-OUT;n:type:ShaderForge.SFN_Set,id:7796,x:38820,y:33151,varname:FinalEmission,prsc:2|IN-4590-OUT;n:type:ShaderForge.SFN_Get,id:2545,x:36568,y:32961,varname:node_2545,prsc:2|IN-7796-OUT;n:type:ShaderForge.SFN_Set,id:6774,x:38820,y:32915,varname:FogVal,prsc:2|IN-9684-OUT;n:type:ShaderForge.SFN_Get,id:790,x:37640,y:33172,varname:node_790,prsc:2|IN-6774-OUT;n:type:ShaderForge.SFN_Get,id:7240,x:38458,y:33908,varname:node_7240,prsc:2|IN-6774-OUT;n:type:ShaderForge.SFN_Set,id:3014,x:38803,y:33741,varname:FinalDiffuse,prsc:2|IN-5905-OUT;n:type:ShaderForge.SFN_Get,id:5870,x:36568,y:32808,varname:node_5870,prsc:2|IN-3014-OUT;n:type:ShaderForge.SFN_Set,id:1565,x:36231,y:32883,varname:DiffuseChain,prsc:2|IN-3998-OUT;n:type:ShaderForge.SFN_Get,id:3559,x:37395,y:34104,varname:node_3559,prsc:2|IN-1565-OUT;n:type:ShaderForge.SFN_Set,id:2470,x:36231,y:33121,varname:NormalChain,prsc:2|IN-8554-RGB;n:type:ShaderForge.SFN_Get,id:5053,x:36568,y:32915,varname:node_5053,prsc:2|IN-2470-OUT;n:type:ShaderForge.SFN_Multiply,id:8480,x:37416,y:33556,varname:node_8480,prsc:2|A-2859-RGB,B-4379-OUT;n:type:ShaderForge.SFN_ValueProperty,id:4379,x:37259,y:33645,ptovrint:False,ptlb:Diffuse Snow,ptin:_DiffuseSnow,varname:node_4379,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,v1:1;n:type:ShaderForge.SFN_Set,id:2517,x:36231,y:33007,varname:EmissionChain,prsc:2|IN-4237-OUT;n:type:ShaderForge.SFN_Get,id:40,x:37640,y:33126,varname:node_40,prsc:2|IN-2517-OUT;n:type:ShaderForge.SFN_Vector3,id:4237,x:36086,y:33007,varname:node_4237,prsc:2,v1:0,v2:0,v3:0;proporder:7545-2176-4379-1304-4380-8554-6270-7083-814-5063-6501-5510-4995-3386-3521-2859-8893-7335-5671-9781;pass:END;sub:END;*/

Shader "Horizon[ON]/Horizon[ON] ShaderForge Example" {
    Properties {
        _DiffuseMulti ("Diffuse Multi", Float ) = 1
        _AmbientMulti ("Ambient Multi", Float ) = 1
        _DiffuseSnow ("Diffuse Snow", Float ) = 1
        _DiffuseTint ("Diffuse Tint", Color) = (1,1,1,1)
        _DiffuseMap ("Diffuse Map", 2D) = "gray" {}
        [Normal]_NormalMap ("Normal Map", 2D) = "bump" {}
        _OverlayFogAmount ("OverlayFogAmount", Range(0, 1)) = 0
        _OverlayFogColorAfromAmbient ("OverlayFogColorAfromAmbient", Color) = (0.6452206,0.6849645,0.75,1)
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
            uniform float4 _DiffuseTint;
            uniform sampler2D _DiffuseMap; uniform float4 _DiffuseMap_ST;
            uniform float4 _OverlayFogColorAfromAmbient;
            uniform float _OverlayFogStartDistance;
            uniform float _OverlayFogDistanceTransition;
            uniform float _OverlayFogAmount;
            uniform sampler2D _NormalMap; uniform float4 _NormalMap_ST;
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
            half3 FogColor( half3 EmissionChain , float FogVal , half3 OverlayFogColor , half AFromAmbient , float3 ViewDirection , float CubeAdd ){
            float3 fogViewDirection=-ViewDirection;
            fogViewDirection.y=abs(fogViewDirection.y);
            half3 ambientFogCol = ShadeSH9(float4(fogViewDirection,1)).rgb*2;
            half3 fogColor=lerp(OverlayFogColor.rgb, ambientFogCol, AFromAmbient);
            #define REFLECTION_PROBE_FOG_MIPLEVEL (FogVal*2+3)
            half4 rgbmf = SampleCubeReflection( unity_SpecCube0, fogViewDirection, REFLECTION_PROBE_FOG_MIPLEVEL );
            half3 fogScatterValue = DecodeHDR_NoLinearSupportInSM2 (rgbmf, unity_SpecCube0_HDR);
            fogColor += fogScatterValue*CubeAdd;
            half3 finalFogColor = lerp(EmissionChain, fogColor, FogVal);
            return finalFogColor;
            }
            
            half3 Snow( float3 NormalDir , float WorldPosY , half3 SnowCol , float SnowAm , float SlopeDamp , float ColorDamp , float BaseHeight , float HeightTransition , half3 DiffuseCol ){
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
            return lerp(DiffuseCol, SnowCol, SnowVal);
            }
            
            uniform float _SnowSlopeDamp;
            uniform float _SnowHeight;
            uniform float _SnowHeightTransition;
            uniform float _SnowOutputColorBrightness2Coverage;
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
                float3 _NormalMap_var = UnpackNormal(tex2D(_NormalMap,TRANSFORM_TEX(i.uv0, _NormalMap)));
                float3 NormalChain = _NormalMap_var.rgb;
                float3 normalLocal = NormalChain;
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
                float node_7994 = 0.0;
                float gloss = node_7994;
                float perceptualRoughness = 1.0 - node_7994;
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
                float3 specularColor = float3(node_7994,node_7994,node_7994);
                float specularMonochrome;
                float4 _DiffuseMap_var = tex2D(_DiffuseMap,TRANSFORM_TEX(i.uv0, _DiffuseMap));
                float3 DiffuseChain = (_DiffuseMap_var.rgb*_DiffuseTint.rgb);
                float node_4447 = 0.0;
                float FogVal = FogValue( distance(_WorldSpaceCameraPos,i.posWorld.rgb) , _OverlayFogStartDistance , _OverlayFogDistanceTransition , _OverlayFogStartHeight , _OverlayFogHeightTransition , _OverlayFogDistance2Height , i.posWorld.g , _OverlayFogAmount );
                float3 FinalDiffuse = lerp((_DiffuseMulti*Snow( normalDirection , i.posWorld.g , (_SnowColor.rgb*_DiffuseSnow) , _SnowAmount , _SnowSlopeDamp , _SnowOutputColorBrightness2Coverage , _SnowHeight , _SnowHeightTransition , DiffuseChain )),float3(node_4447,node_4447,node_4447),FogVal);
                float3 diffuseColor = FinalDiffuse; // Need this for specular when using metallic
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
                float3 DiffuseAmbient = Ambient( normalDirection , _AmbientMulti );
                indirectDiffuse += DiffuseAmbient; // Diffuse Ambient Light
                diffuseColor *= 1-specularMonochrome;
                float3 diffuse = (directDiffuse + indirectDiffuse) * diffuseColor;
////// Emissive:
                float3 EmissionChain = float3(0,0,0);
                float3 FinalEmission = FogColor( EmissionChain , FogVal , _OverlayFogColorAfromAmbient.rgb , _OverlayFogColorAfromAmbient.a , viewDirection , _OverlayFogAmountFromReflCubemap );
                float3 emissive = FinalEmission;
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
    CustomEditor "ShaderForgeMaterialInspector"
}
