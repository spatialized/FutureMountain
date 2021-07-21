// Shader created with Shader Forge v1.38 
// Shader Forge (c) Neat Corporation / Joachim Holmer - http://www.acegikmo.com/shaderforge/
// Note: Manually altering this data may prevent you from opening it in Shader Forge
/*SF_DATA;ver:1.38;sub:START;pass:START;ps:flbk:Legacy Shaders/Transparent/Cutout/Bumped Diffuse,iptp:0,cusa:False,bamd:0,cgin:,lico:0,lgpr:1,limd:2,spmd:0,trmd:0,grmd:0,uamb:False,mssp:True,bkdf:False,hqlp:False,rprd:False,enco:True,rmgx:False,imps:True,rpth:0,vtps:0,hqsc:True,nrmq:1,nrsp:0,vomd:0,spxs:False,tesm:0,olmd:1,culm:0,bsrc:0,bdst:1,dpts:2,wrdp:True,dith:0,atcv:False,rfrpo:True,rfrpn:Refraction,coma:15,ufog:True,aust:True,igpj:False,qofs:0,qpre:2,rntp:3,fgom:False,fgoc:False,fgod:False,fgor:False,fgmd:0,fgcr:0.692398,fgcg:0.7166868,fgcb:0.722,fgca:1,fgde:0.0002,fgrn:0,fgrf:300,stcl:False,atwp:False,stva:128,stmr:255,stmw:255,stcp:6,stps:0,stfa:0,stfz:0,ofsf:0,ofsu:0,f2p0:False,fnsp:False,fnfb:False,fsmp:False;n:type:ShaderForge.SFN_Final,id:4013,x:36857,y:32652,varname:node_4013,prsc:2|diff-5905-OUT,normal-8554-RGB,emission-6181-OUT,amdfl-3428-OUT,clip-2818-OUT;n:type:ShaderForge.SFN_Color,id:1304,x:33690,y:32573,ptovrint:False,ptlb:Tint 1,ptin:_Tint1,varname:_Tint1,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,c1:0.628,c2:0.6255639,c3:0.429552,c4:1;n:type:ShaderForge.SFN_Tex2d,id:4380,x:33690,y:32937,ptovrint:False,ptlb:MainTex,ptin:_MainTex,varname:_MainTex,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:True,tagnrm:False,ntxv:0,isnm:False;n:type:ShaderForge.SFN_Multiply,id:3998,x:33926,y:32805,varname:node_3998,prsc:2|A-8860-OUT,B-4380-RGB;n:type:ShaderForge.SFN_Color,id:7083,x:34288,y:33937,ptovrint:False,ptlb:OverlayFogColorAfromAmbient,ptin:_OverlayFogColorAfromAmbient,varname:_OverlayFogColorAfromAmbient,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,c1:1,c2:1,c3:1,c4:1;n:type:ShaderForge.SFN_Distance,id:5478,x:34288,y:33714,varname:node_5478,prsc:2|A-5169-XYZ,B-4120-XYZ;n:type:ShaderForge.SFN_ViewPosition,id:5169,x:33984,y:33678,varname:node_5169,prsc:2;n:type:ShaderForge.SFN_FragmentPosition,id:4120,x:33984,y:33797,varname:node_4120,prsc:2;n:type:ShaderForge.SFN_ValueProperty,id:5063,x:34577,y:33643,ptovrint:False,ptlb:OverlayFogStartDistance,ptin:_OverlayFogStartDistance,varname:_OverlayFogStartDistance,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,v1:0;n:type:ShaderForge.SFN_ValueProperty,id:6501,x:34716,y:33643,ptovrint:False,ptlb:OverlayFogDistanceTransition,ptin:_OverlayFogDistanceTransition,varname:_OverlayFogDistanceTransition,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,v1:2500;n:type:ShaderForge.SFN_Slider,id:6270,x:34131,y:33854,ptovrint:False,ptlb:OverlayFogAmount,ptin:_OverlayFogAmount,varname:_OverlayFogAmount,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,min:0,cur:0,max:1;n:type:ShaderForge.SFN_Tex2d,id:8554,x:36857,y:32439,ptovrint:False,ptlb:Normal Map,ptin:_NormalMap,varname:_NormalMap,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:True,tagnrm:True,ntxv:3,isnm:True;n:type:ShaderForge.SFN_ValueProperty,id:5510,x:34857,y:33643,ptovrint:False,ptlb:OverlayFogStartHeight,ptin:_OverlayFogStartHeight,varname:_OverlayFogStartHeight,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,v1:0;n:type:ShaderForge.SFN_ValueProperty,id:4995,x:34995,y:33643,ptovrint:False,ptlb:OverlayFogHeightTransition,ptin:_OverlayFogHeightTransition,varname:_OverlayFogHeightTransition,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,v1:300;n:type:ShaderForge.SFN_ValueProperty,id:3386,x:35138,y:33643,ptovrint:False,ptlb:OverlayFogDistance2Height,ptin:_OverlayFogDistance2Height,varname:_OverlayFogDistance2Height,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,v1:10;n:type:ShaderForge.SFN_FragmentPosition,id:3971,x:35275,y:33575,varname:node_3971,prsc:2;n:type:ShaderForge.SFN_Color,id:2859,x:34343,y:32186,ptovrint:False,ptlb:SnowColor,ptin:_SnowColor,varname:_SnowColor,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,c1:0.8931949,c2:0.9191236,c3:0.9411765,c4:1;n:type:ShaderForge.SFN_Slider,id:3521,x:34186,y:32346,ptovrint:False,ptlb:SnowAmount,ptin:_SnowAmount,varname:_SnowAmount,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,min:0,cur:0,max:1;n:type:ShaderForge.SFN_Vector1,id:4447,x:36497,y:32603,varname:node_4447,prsc:2,v1:0;n:type:ShaderForge.SFN_Lerp,id:5905,x:36497,y:32653,varname:node_5905,prsc:2|A-4080-OUT,B-4447-OUT,T-9684-OUT;n:type:ShaderForge.SFN_Tex2d,id:9775,x:35268,y:33057,ptovrint:False,ptlb:Backlight Map (A),ptin:_BacklightMapA,varname:_BacklightMapA,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:True,tagnrm:False,ntxv:2,isnm:False;n:type:ShaderForge.SFN_Slider,id:6830,x:34719,y:33448,ptovrint:False,ptlb:Backlight Strength,ptin:_BacklightStrength,varname:_BacklightStrength,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,min:0,cur:1.5,max:2;n:type:ShaderForge.SFN_Relay,id:8345,x:35332,y:34578,varname:node_8345,prsc:2|IN-1408-OUT;n:type:ShaderForge.SFN_Code,id:9684,x:34580,y:33713,varname:MyFog,prsc:2,code:ZgBsAG8AYQB0ACAAZgBvAGcAVgBhAGwAPQAxAC0AcwBhAHQAdQByAGEAdABlACgAKABkAGkAcwB0AC0AcwB0AGEAcgB0AEQAaQBzAHQAYQBuAGMAZQApAC8AKABlAG4AZABEAGkAcwB0AGEAbgBjAGUAKwBzAHQAYQByAHQARABpAHMAdABhAG4AYwBlACkAKQA7AAoAZgBvAGcAVgBhAGwAPQAxAC0AZgBvAGcAVgBhAGwAKgBmAG8AZwBWAGEAbAA7AAoAZgBsAG8AYQB0ACAAZgBvAGcASABlAGkAZwBoAHQAVgBhAGwAPQBzAGEAdAB1AHIAYQB0AGUAKAAoAHcAbwByAGwAZABQAG8AcwAtAHMAdABhAHIAdABIAGUAaQBnAGgAdAAtAGgAZQBpAGcAaAB0AE8AZgBmAHMAZQB0ACoAZgBvAGcAVgBhAGwAKgBmAG8AZwBWAGEAbAApACAALwAgACgAZQBuAGQASABlAGkAZwBoAHQAKwBzAHQAYQByAHQASABlAGkAZwBoAHQAKQApADsACgBmAG8AZwBIAGUAaQBnAGgAdABWAGEAbAA9ACgAMQAtAGYAbwBnAEgAZQBpAGcAaAB0AFYAYQBsACkAOwAKAGYAbwBnAEgAZQBpAGcAaAB0AFYAYQBsACoAPQBmAG8AZwBIAGUAaQBnAGgAdABWAGEAbAA7AAoAZgBvAGcAVgBhAGwAIAAqAD0AIABmAG8AZwBIAGUAaQBnAGgAdABWAGEAbAAqAGYAbwBnAEEAbQBvAHUAbgB0ADsACgByAGUAdAB1AHIAbgAgAGYAbwBnAFYAYQBsADsA,output:0,fname:FogValue,width:794,height:208,input:0,input:0,input:0,input:0,input:0,input:0,input:0,input:0,input_1_label:dist,input_2_label:startDistance,input_3_label:endDistance,input_4_label:startHeight,input_5_label:endHeight,input_6_label:heightOffset,input_7_label:worldPos,input_8_label:fogAmount|A-5478-OUT,B-5063-OUT,C-6501-OUT,D-5510-OUT,E-4995-OUT,F-3386-OUT,G-3971-Y,H-6270-OUT;n:type:ShaderForge.SFN_Vector1,id:7994,x:36857,y:32594,varname:node_7994,prsc:2,v1:0;n:type:ShaderForge.SFN_Relay,id:6181,x:36556,y:32771,varname:node_6181,prsc:2|IN-4590-OUT;n:type:ShaderForge.SFN_FragmentPosition,id:272,x:33426,y:32573,varname:node_272,prsc:2;n:type:ShaderForge.SFN_ValueProperty,id:8134,x:33173,y:32963,ptovrint:False,ptlb:VariationMap Scale,ptin:_VariationMapScale,varname:_VariationMapScale,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,v1:800;n:type:ShaderForge.SFN_Color,id:5739,x:33558,y:32573,ptovrint:False,ptlb:Tint 2,ptin:_Tint2,varname:_Tint2,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,c1:0.3259408,c2:0.428,c3:0.260652,c4:1;n:type:ShaderForge.SFN_ValueProperty,id:2176,x:34581,y:34370,ptovrint:False,ptlb:Ambient Regular,ptin:_AmbientRegular,varname:_AmbientRegular,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,v1:1.2;n:type:ShaderForge.SFN_Multiply,id:4080,x:36177,y:32650,varname:node_4080,prsc:2|A-7545-OUT,B-7162-OUT;n:type:ShaderForge.SFN_ValueProperty,id:7545,x:36177,y:32593,ptovrint:False,ptlb:Diffuse Multi,ptin:_DiffuseMulti,varname:_DiffuseMulti,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,v1:1.2;n:type:ShaderForge.SFN_Code,id:5825,x:34983,y:34289,varname:node_5825,prsc:2,code:cgBlAHQAdQByAG4AIABTAGgAYQBkAGUAUwBIADkAKABmAGwAbwBhAHQANAAoAE4AbwByAG0AYQBsAEQAaQByACwAMQApACkAKgAoAEEAbQBiAGkAZQBuAHQATQB1AGwAdABpACoAMgApADsA,output:2,fname:Ambient,width:389,height:112,input:2,input:0,input_1_label:NormalDir,input_2_label:AmbientMulti|A-8-OUT,B-9009-OUT;n:type:ShaderForge.SFN_NormalVector,id:8,x:34770,y:34290,prsc:2,pt:True;n:type:ShaderForge.SFN_Tex2d,id:6468,x:33373,y:32937,ptovrint:False,ptlb:Leaves Mask,ptin:_LeavesMask,varname:_LeavesMask,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:True,tagnrm:False,ntxv:0,isnm:False;n:type:ShaderForge.SFN_Add,id:1408,x:34057,y:34581,varname:node_1408,prsc:2|A-4380-A,B-1417-OUT;n:type:ShaderForge.SFN_Slider,id:1417,x:33737,y:34602,ptovrint:False,ptlb:Alpha Cutoff,ptin:_AlphaCutoff,varname:_AlphaCutoff,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,min:-0.5,cur:0,max:0.5;n:type:ShaderForge.SFN_Add,id:7162,x:35787,y:32650,varname:node_7162,prsc:2|A-4436-OUT,B-5486-OUT;n:type:ShaderForge.SFN_Color,id:9705,x:35113,y:33057,ptovrint:False,ptlb:Backlight Tint,ptin:_BacklightTint,varname:_BacklightTint,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,c1:1,c2:0.9310346,c3:0,c4:1;n:type:ShaderForge.SFN_LightAttenuation,id:9935,x:34720,y:33079,varname:node_9935,prsc:2;n:type:ShaderForge.SFN_ViewVector,id:4844,x:34288,y:34076,varname:node_4844,prsc:2;n:type:ShaderForge.SFN_Slider,id:814,x:34585,y:34142,ptovrint:False,ptlb:OverlayFogAmountFromReflCubemap,ptin:_OverlayFogAmountFromReflCubemap,varname:_OverlayFogAmountFromReflCubemap,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,min:0,cur:0.5,max:1;n:type:ShaderForge.SFN_Code,id:4590,x:34580,y:33950,varname:node_4590,prsc:2,code:ZgBsAG8AYQB0ADMAIABmAG8AZwBWAGkAZQB3AEQAaQByAGUAYwB0AGkAbwBuAD0ALQBWAGkAZQB3AEQAaQByAGUAYwB0AGkAbwBuADsACgBmAG8AZwBWAGkAZQB3AEQAaQByAGUAYwB0AGkAbwBuAC4AeQA9AGEAYgBzACgAZgBvAGcAVgBpAGUAdwBEAGkAcgBlAGMAdABpAG8AbgAuAHkAKQA7AAoAaABhAGwAZgAzACAAYQBtAGIAaQBlAG4AdABGAG8AZwBDAG8AbAAgAD0AIABTAGgAYQBkAGUAUwBIADkAKABmAGwAbwBhAHQANAAoAGYAbwBnAFYAaQBlAHcARABpAHIAZQBjAHQAaQBvAG4ALAAxACkAKQAuAHIAZwBiACoAMgA7AAoAaABhAGwAZgAzACAAZgBvAGcAQwBvAGwAbwByAD0AbABlAHIAcAAoAE8AdgBlAHIAbABhAHkARgBvAGcAQwBvAGwAbwByAC4AcgBnAGIALAAgAGEAbQBiAGkAZQBuAHQARgBvAGcAQwBvAGwALAAgAEEARgByAG8AbQBBAG0AYgBpAGUAbgB0ACkAOwAKACMAZABlAGYAaQBuAGUAIABSAEUARgBMAEUAQwBUAEkATwBOAF8AUABSAE8AQgBFAF8ARgBPAEcAXwBNAEkAUABMAEUAVgBFAEwAIAAoAEYAbwBnAFYAYQBsACoAMgArADMAKQAKAGgAYQBsAGYANAAgAHIAZwBiAG0AZgAgAD0AIABTAGEAbQBwAGwAZQBDAHUAYgBlAFIAZQBmAGwAZQBjAHQAaQBvAG4AKAAgAHUAbgBpAHQAeQBfAFMAcABlAGMAQwB1AGIAZQAwACwAIABmAG8AZwBWAGkAZQB3AEQAaQByAGUAYwB0AGkAbwBuACwAIABSAEUARgBMAEUAQwBUAEkATwBOAF8AUABSAE8AQgBFAF8ARgBPAEcAXwBNAEkAUABMAEUAVgBFAEwAIAApADsACgBoAGEAbABmADMAIABmAG8AZwBTAGMAYQB0AHQAZQByAFYAYQBsAHUAZQAgAD0AIABEAGUAYwBvAGQAZQBIAEQAUgBfAE4AbwBMAGkAbgBlAGEAcgBTAHUAcABwAG8AcgB0AEkAbgBTAE0AMgAgACgAcgBnAGIAbQBmACwAIAB1AG4AaQB0AHkAXwBTAHAAZQBjAEMAdQBiAGUAMABfAEgARABSACkAOwAKAGYAbwBnAEMAbwBsAG8AcgAgACsAPQAgAGYAbwBnAFMAYwBhAHQAdABlAHIAVgBhAGwAdQBlACoAQwB1AGIAZQBBAGQAZAA7AAoAaABhAGwAZgAzACAAZgBpAG4AYQBsAEYAbwBnAEMAbwBsAG8AcgAgAD0AIABsAGUAcgBwACgAMAAsACAAZgBvAGcAQwBvAGwAbwByACwAIABGAG8AZwBWAGEAbAApADsACgByAGUAdAB1AHIAbgAgAGYAaQBuAGEAbABGAG8AZwBDAG8AbABvAHIAOwA=,output:6,fname:FogColor,width:795,height:166,input:0,input:6,input:4,input:2,input:0,input_1_label:FogVal,input_2_label:OverlayFogColor,input_3_label:AFromAmbient,input_4_label:ViewDirection,input_5_label:CubeAdd|A-9684-OUT,B-7083-RGB,C-7083-A,D-4844-OUT,E-814-OUT;n:type:ShaderForge.SFN_Code,id:8860,x:33257,y:32739,varname:node_8860,prsc:2,code:aABhAGwAZgAzACAAdABpAG4AdABzACAAPQAgAGwAZQByAHAAKABBACwAIABCACwAIAB0AGUAeAAyAEQAKABWAE0AYQBwACwAIABmAGwAbwBhAHQAMgAoAFcAUABvAHMALgB4ACwAIABXAFAAbwBzAC4AegApAC8AUwBjAGEAbABlACkALgBhACkAOwAKAGgAYQBsAGYAMwAgAG0AaQB4AGUAZABDAG8AbABvAHIAIAA9ACAAbABlAHIAcAAoADEALAAgAHQAaQBuAHQAcwAsACAAVABNAGEAcwBrACkAOwAKAHIAZQB0AHUAcgBuACAAbQBpAHgAZQBkAEMAbwBsAG8AcgA7AA==,output:2,fname:Dif,width:532,height:168,input:6,input:6,input:2,input:0,input:4,input:12,input_1_label:A,input_2_label:B,input_3_label:WPos,input_4_label:Scale,input_5_label:TMask,input_6_label:VMap|A-1304-RGB,B-5739-RGB,C-272-XYZ,D-8134-OUT,E-6468-A,F-9114-TEX;n:type:ShaderForge.SFN_Tex2dAsset,id:9114,x:33507,y:32937,ptovrint:False,ptlb:VariationMap (A),ptin:_VariationMapA,varname:_VariationMapA,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:True,tagnrm:False,ntxv:0,isnm:False;n:type:ShaderForge.SFN_Code,id:5486,x:34719,y:33229,varname:node_5486,prsc:2,code:ZgBsAG8AYQB0ACAAQQAgAD0AIABzAGEAdAB1AHIAYQB0AGUAKABkAG8AdAAoAE4AbwByAG0AYQBsAEQAaQByACwATABpAGcAaAB0AEQAaQByACkAKgAtADIALgA1ACsALQAxAC4ANQApADsACgBBACAAKgA9ACAAKABCAGEAYwBrAEwAaQBnAGgAdABUAGUAeABBACoAVAByAGEAbgBzAE0AaQBzACkAOwAKAGYAbABvAGEAdAAgAEIAIAA9ACAAcwBhAHQAdQByAGEAdABlACgAZABvAHQAKABMAGkAZwBoAHQARABpAHIALABmAGwAbwBhAHQAMwAoADAALAAxACwAMAApACkAKgAtADIALgAwACsAMQAuADIAKQA7AAoAaABhAGwAZgAzACAAVAByAGEAbgBzAEMAbwBsACAAPQAgAGwAZQByAHAAKABUAHIAYQBuAHMATQBpAHMAVABpAG4AdAAsACAAMQAsACAAUwBuAG8AdwBWAGEAbAApADsACgAvAC8AaABhAGwAZgAzACAATwB1AHQAcAB1AHQAIAA9ACAAKABUAHIAYQBuAHMAQwBvAGwAKgBMAGkAZwBoAHQAQQB0AHQAZQBuACoAQQAqAEIAKQA7AAoAaABhAGwAZgAzACAATwB1AHQAcAB1AHQAIAA9ACAAKABUAHIAYQBuAHMAQwBvAGwAKgBBACoAQgApACAAKgAgAEwAaQBnAGgAdABBAHQAdABlAG4AOwAKAHIAZQB0AHUAcgBuACAATwB1AHQAcAB1AHQAOwA=,output:6,fname:Backlighting,width:651,height:188,input:4,input:6,input:2,input:2,input:0,input:0,input:0,input_1_label:BackLightTexA,input_2_label:TransMisTint,input_3_label:NormalDir,input_4_label:LightDir,input_5_label:LightAtten,input_6_label:SnowVal,input_7_label:TransMis|A-9775-A,B-9705-RGB,C-7015-OUT,D-1886-OUT,E-9935-OUT,F-5619-OUT,G-6830-OUT;n:type:ShaderForge.SFN_NormalVector,id:7015,x:34985,y:33057,prsc:2,pt:False;n:type:ShaderForge.SFN_LightVector,id:1886,x:34853,y:33079,varname:node_1886,prsc:2;n:type:ShaderForge.SFN_Code,id:3420,x:34804,y:32651,varname:node_3420,prsc:2,code:ZgBsAG8AYQB0ACAAUwBuAG8AdwBWAGEAbAAgAD0AIABTAG4AbwB3AEEAbQAqADIAOwAKAGYAbABvAGEAdAAgAEgAZQBpAGcAaAB0AEYAYQBjAHQAbwByACAAPQAgAHMAYQB0AHUAcgBhAHQAZQAoACgAQgBhAHMAZQBIAGUAaQBnAGgAdAAgAC0AIABXAG8AcgBsAGQAUABvAHMAWQApAC8ASABlAGkAZwBoAHQAVAByAGEAbgBzAGkAdABpAG8AbgApACoANAA7AAoAUwBuAG8AdwBWAGEAbAAgACsAPQAgAEgAZQBpAGcAaAB0AEYAYQBjAHQAbwByACAAPAAgADAAIAA/ACAAMAAgADoAIAAtAEgAZQBpAGcAaAB0AEYAYQBjAHQAbwByADsACgBoAGEAbABmADMAIABEAGUAUwBhAHQAQwBvAGwAbwByACAAPQAgADEALQBkAG8AdAAoAEQAaQBmAGYAdQBzAGUAQwBvAGwALAAgAGYAbABvAGEAdAAzACgAMAAuADQALAAwAC4ANAAsADAALgA0ACkAKQA7AAoARABlAFMAYQB0AEMAbwBsAG8AcgAgACoAPQAgAEQAZQBTAGEAdABDAG8AbABvAHIAOwAKAFMAbgBvAHcAVgBhAGwAIAAtAD0AIABEAGUAUwBhAHQAQwBvAGwAbwByACoAQwBvAGwAbwByAEQAYQBtAHAAOwAKAFMAbgBvAHcAVgBhAGwAIAAtAD0AIAAoAFMAbABvAHAAZQBEAGEAbQBwACoAMAAuADIAKQAqACgAMQAtAE4AbwByAG0AYQBsAEQAaQByAC4AeQApADsACgBTAG4AbwB3AFYAYQBsACAAPQAgAHMAYQB0AHUAcgBhAHQAZQAoAFMAbgBvAHcAVgBhAGwAKQA7AAoAUwBuAG8AdwBWAGEAbAAgACoAPQAgAFMAbgBvAHcAVgBhAGwAOwAKAFMAbgBvAHcAVgBhAGwAIAAqAD0AIABTAG4AbwB3AFYAYQBsADsACgBoAGEAbABmADMAIABDAG8AbAAgAD0AIABsAGUAcgBwACgARABpAGYAZgB1AHMAZQBDAG8AbAAsACAAUwBuAG8AdwBDAG8AbAAqAEQAaQBmAGYAdQBzAGUAUwBuAG8AdwAsACAAUwBuAG8AdwBWAGEAbAApADsACgBoAGEAbABmADQAIABSAEcAQgBBACAAPQAgAGgAYQBsAGYANAAoAEMAbwBsACwAIABTAG4AbwB3AFYAYQBsACkAOwAKAHIAZQB0AHUAcgBuACAAUgBHAEIAQQA7AA==,output:7,fname:Snow,width:570,height:248,input:2,input:0,input:6,input:0,input:0,input:0,input:0,input:0,input:6,input:0,input_1_label:NormalDir,input_2_label:WorldPosY,input_3_label:SnowCol,input_4_label:SnowAm,input_5_label:SlopeDamp,input_6_label:ColorDamp,input_7_label:BaseHeight,input_8_label:HeightTransition,input_9_label:DiffuseCol,input_10_label:DiffuseSnow|A-6046-OUT,B-5629-Y,C-2859-RGB,D-3521-OUT,E-8893-OUT,F-5671-OUT,G-7335-OUT,H-9781-OUT,I-3998-OUT,J-2609-OUT;n:type:ShaderForge.SFN_FragmentPosition,id:5629,x:34806,y:32454,varname:node_5629,prsc:2;n:type:ShaderForge.SFN_Slider,id:8893,x:34186,y:32433,ptovrint:False,ptlb:SnowSlopeDamp,ptin:_SnowSlopeDamp,varname:_SnowSlopeDamp,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,min:0,cur:0,max:4;n:type:ShaderForge.SFN_ValueProperty,id:7335,x:34343,y:32604,ptovrint:False,ptlb:SnowHeight,ptin:_SnowHeight,varname:_SnowHeight,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,v1:0;n:type:ShaderForge.SFN_ValueProperty,id:9781,x:34343,y:32676,ptovrint:False,ptlb:SnowHeightTransition,ptin:_SnowHeightTransition,varname:_SnowHeightTransition,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,v1:0;n:type:ShaderForge.SFN_NormalVector,id:6046,x:34989,y:32454,prsc:2,pt:True;n:type:ShaderForge.SFN_Slider,id:5671,x:34186,y:32518,ptovrint:False,ptlb:SnowOutputColorBrightness2Coverage,ptin:_SnowOutputColorBrightness2Coverage,varname:_SnowOutputColorBrightness2Coverage,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,min:0,cur:0,max:1;n:type:ShaderForge.SFN_ComponentMask,id:4436,x:35529,y:32651,varname:node_4436,prsc:2,cc1:0,cc2:1,cc3:2,cc4:-1|IN-3420-OUT;n:type:ShaderForge.SFN_ComponentMask,id:5619,x:34234,y:32901,varname:node_5619,prsc:2,cc1:3,cc2:-1,cc3:-1,cc4:-1|IN-3420-OUT;n:type:ShaderForge.SFN_Relay,id:3428,x:36556,y:32817,varname:node_3428,prsc:2|IN-5825-OUT;n:type:ShaderForge.SFN_Relay,id:2818,x:36556,y:32933,varname:node_2818,prsc:2|IN-8345-OUT;n:type:ShaderForge.SFN_Relay,id:6558,x:34581,y:34482,varname:node_6558,prsc:2|IN-5619-OUT;n:type:ShaderForge.SFN_Lerp,id:9009,x:34770,y:34432,varname:node_9009,prsc:2|A-2176-OUT,B-762-OUT,T-6558-OUT;n:type:ShaderForge.SFN_ValueProperty,id:762,x:34581,y:34432,ptovrint:False,ptlb:Ambient Snow,ptin:_AmbientSnow,varname:_AmbientSnow,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,v1:0.9;n:type:ShaderForge.SFN_ValueProperty,id:2609,x:34343,y:32745,ptovrint:False,ptlb:Diffuse Snow,ptin:_DiffuseSnow,varname:node_2609,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,v1:1;proporder:7545-2176-2609-762-4380-1417-8554-1304-5739-6468-9114-8134-6830-9705-9775-6270-7083-814-5063-6501-5510-4995-3386-3521-2859-8893-7335-5671-9781;pass:END;sub:END;*/

Shader "Horizon[ON]/Horizon[ON] Tree Cutout" {
    Properties {
        _DiffuseMulti ("Diffuse Multi", Float ) = 1.2
        _AmbientRegular ("Ambient Regular", Float ) = 1.2
        _DiffuseSnow ("Diffuse Snow", Float ) = 1
        _AmbientSnow ("Ambient Snow", Float ) = 0.9
        [NoScaleOffset]_MainTex ("MainTex", 2D) = "white" {}
        _AlphaCutoff ("Alpha Cutoff", Range(-0.5, 0.5)) = 0
        [NoScaleOffset][Normal]_NormalMap ("Normal Map", 2D) = "bump" {}
        _Tint1 ("Tint 1", Color) = (0.628,0.6255639,0.429552,1)
        _Tint2 ("Tint 2", Color) = (0.3259408,0.428,0.260652,1)
        [NoScaleOffset]_LeavesMask ("Leaves Mask", 2D) = "white" {}
        [NoScaleOffset]_VariationMapA ("VariationMap (A)", 2D) = "white" {}
        _VariationMapScale ("VariationMap Scale", Float ) = 800
        _BacklightStrength ("Backlight Strength", Range(0, 2)) = 1.5
        _BacklightTint ("Backlight Tint", Color) = (1,0.9310346,0,1)
        [NoScaleOffset]_BacklightMapA ("Backlight Map (A)", 2D) = "black" {}
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
        [HideInInspector]_Cutoff ("Alpha cutoff", Range(0,1)) = 0.5
    }
    SubShader {
        Tags {
            "Queue"="AlphaTest"
            "RenderType"="TransparentCutout"
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
            #include "UnityCG.cginc"
            #include "AutoLight.cginc"
            #include "Lighting.cginc"
            #pragma multi_compile_fwdbase_fullshadows
            #pragma multi_compile_fog
            #pragma only_renderers d3d9 d3d11 glcore gles gles3 n3ds wiiu 
            #pragma target 3.0
            uniform float4 _Tint1;
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
            uniform sampler2D _BacklightMapA;
            uniform float _BacklightStrength;
            float FogValue( float dist , float startDistance , float endDistance , float startHeight , float endHeight , float heightOffset , float worldPos , float fogAmount ){
            float fogVal=1-saturate((dist-startDistance)/(endDistance+startDistance));
            fogVal=1-fogVal*fogVal;
            float fogHeightVal=saturate((worldPos-startHeight-heightOffset*fogVal*fogVal) / (endHeight+startHeight));
            fogHeightVal=(1-fogHeightVal);
            fogHeightVal*=fogHeightVal;
            fogVal *= fogHeightVal*fogAmount;
            return fogVal;
            }
            
            uniform float _VariationMapScale;
            uniform float4 _Tint2;
            uniform float _AmbientRegular;
            uniform float _DiffuseMulti;
            float3 Ambient( float3 NormalDir , float AmbientMulti ){
            return ShadeSH9(float4(NormalDir,1))*(AmbientMulti*2);
            }
            
            uniform sampler2D _LeavesMask;
            uniform float _AlphaCutoff;
            uniform float4 _BacklightTint;
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
            
            float3 Dif( half3 A , half3 B , float3 WPos , float Scale , half TMask , sampler2D VMap ){
            half3 tints = lerp(A, B, tex2D(VMap, float2(WPos.x, WPos.z)/Scale).a);
            half3 mixedColor = lerp(1, tints, TMask);
            return mixedColor;
            }
            
            uniform sampler2D _VariationMapA;
            half3 Backlighting( half BackLightTexA , half3 TransMisTint , float3 NormalDir , float3 LightDir , float LightAtten , float SnowVal , float TransMis ){
            float A = saturate(dot(NormalDir,LightDir)*-2.5+-1.5);
            A *= (BackLightTexA*TransMis);
            float B = saturate(dot(LightDir,float3(0,1,0))*-2.0+1.2);
            half3 TransCol = lerp(TransMisTint, 1, SnowVal);
            //half3 Output = (TransCol*LightAtten*A*B);
            half3 Output = (TransCol*A*B) * LightAtten;
            return Output;
            }
            
            half4 Snow( float3 NormalDir , float WorldPosY , half3 SnowCol , float SnowAm , float SlopeDamp , float ColorDamp , float BaseHeight , float HeightTransition , half3 DiffuseCol , float DiffuseSnow ){
            float SnowVal = SnowAm*2;
            float HeightFactor = saturate((BaseHeight - WorldPosY)/HeightTransition)*4;
            SnowVal += HeightFactor < 0 ? 0 : -HeightFactor;
            half3 DeSatColor = 1-dot(DiffuseCol, float3(0.4,0.4,0.4));
            DeSatColor *= DeSatColor;
            SnowVal -= DeSatColor*ColorDamp;
            SnowVal -= (SlopeDamp*0.2)*(1-NormalDir.y);
            SnowVal = saturate(SnowVal);
            SnowVal *= SnowVal;
            SnowVal *= SnowVal;
            half3 Col = lerp(DiffuseCol, SnowCol*DiffuseSnow, SnowVal);
            half4 RGBA = half4(Col, SnowVal);
            return RGBA;
            }
            
            uniform float _SnowSlopeDamp;
            uniform float _SnowHeight;
            uniform float _SnowHeightTransition;
            uniform float _SnowOutputColorBrightness2Coverage;
            uniform float _AmbientSnow;
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
                float3 _NormalMap_var = UnpackNormal(tex2D(_NormalMap,i.uv0));
                float3 normalLocal = _NormalMap_var.rgb;
                float3 normalDirection = normalize(mul( normalLocal, tangentTransform )); // Perturbed normals
                float4 _MainTex_var = tex2D(_MainTex,i.uv0);
                clip((_MainTex_var.a+_AlphaCutoff) - 0.5);
                float3 lightDirection = normalize(_WorldSpaceLightPos0.xyz);
                float3 lightColor = _LightColor0.rgb;
////// Lighting:
                float attenuation = LIGHT_ATTENUATION(i);
                float3 attenColor = attenuation * _LightColor0.xyz;
                float Pi = 3.141592654;
                float InvPi = 0.31830988618;
/////// Diffuse:
                float NdotL = max(0.0,dot( normalDirection, lightDirection ));
                float3 directDiffuse = max( 0.0, NdotL) * attenColor;
                float3 indirectDiffuse = float3(0,0,0);
                float4 _LeavesMask_var = tex2D(_LeavesMask,i.uv0);
                float4 node_3420 = Snow( normalDirection , i.posWorld.g , _SnowColor.rgb , _SnowAmount , _SnowSlopeDamp , _SnowOutputColorBrightness2Coverage , _SnowHeight , _SnowHeightTransition , (Dif( _Tint1.rgb , _Tint2.rgb , i.posWorld.rgb , _VariationMapScale , _LeavesMask_var.a , _VariationMapA )*_MainTex_var.rgb) , _DiffuseSnow );
                float node_5619 = node_3420.a;
                indirectDiffuse += Ambient( normalDirection , lerp(_AmbientRegular,_AmbientSnow,node_5619) ); // Diffuse Ambient Light
                float4 _BacklightMapA_var = tex2D(_BacklightMapA,i.uv0);
                float3 node_7162 = (node_3420.rgb+Backlighting( _BacklightMapA_var.a , _BacklightTint.rgb , i.normalDir , lightDirection , attenuation , node_5619 , _BacklightStrength ));
                float node_4447 = 0.0;
                float MyFog = FogValue( distance(_WorldSpaceCameraPos,i.posWorld.rgb) , _OverlayFogStartDistance , _OverlayFogDistanceTransition , _OverlayFogStartHeight , _OverlayFogHeightTransition , _OverlayFogDistance2Height , i.posWorld.g , _OverlayFogAmount );
                float3 diffuseColor = lerp((_DiffuseMulti*node_7162),float3(node_4447,node_4447,node_4447),MyFog);
                float3 diffuse = (directDiffuse + indirectDiffuse) * diffuseColor;
////// Emissive:
                float3 emissive = FogColor( MyFog , _OverlayFogColorAfromAmbient.rgb , _OverlayFogColorAfromAmbient.a , viewDirection , _OverlayFogAmountFromReflCubemap );
/// Final Color:
                float3 finalColor = diffuse + emissive;
                fixed4 finalRGBA = fixed4(finalColor,1);
                UNITY_APPLY_FOG(i.fogCoord, finalRGBA);
                return finalRGBA;
            }
            ENDCG
        }
        Pass {
            Name "ShadowCaster"
            Tags {
                "LightMode"="ShadowCaster"
            }
            Offset 1, 1
            Cull Back
            
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #define UNITY_PASS_SHADOWCASTER
            #include "UnityCG.cginc"
            #include "Lighting.cginc"
            #pragma fragmentoption ARB_precision_hint_fastest
            #pragma multi_compile_shadowcaster
            #pragma multi_compile_fog
            #pragma only_renderers d3d9 d3d11 glcore gles gles3 n3ds wiiu 
            #pragma target 3.0
            uniform sampler2D _MainTex;
            uniform float _AlphaCutoff;
            struct VertexInput {
                float4 vertex : POSITION;
                float2 texcoord0 : TEXCOORD0;
            };
            struct VertexOutput {
                V2F_SHADOW_CASTER;
                float2 uv0 : TEXCOORD1;
            };
            VertexOutput vert (VertexInput v) {
                VertexOutput o = (VertexOutput)0;
                o.uv0 = v.texcoord0;
                o.pos = UnityObjectToClipPos( v.vertex );
                TRANSFER_SHADOW_CASTER(o)
                return o;
            }
            float4 frag(VertexOutput i) : COLOR {
                float4 _MainTex_var = tex2D(_MainTex,i.uv0);
                clip((_MainTex_var.a+_AlphaCutoff) - 0.5);
                SHADOW_CASTER_FRAGMENT(i)
            }
            ENDCG
        }
    }
    FallBack "Legacy Shaders/Transparent/Cutout/Bumped Diffuse"
    //CustomEditor "ShaderForgeMaterialInspector"
}
