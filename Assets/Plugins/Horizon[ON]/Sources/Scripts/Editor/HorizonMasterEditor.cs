using UnityEngine;
using UnityEditor;

namespace Horizon {
	[CustomEditor(typeof(HorizonMaster))]
	public class HorizonMasterEditor : Editor {

        // Misc
        SerializedProperty isPreset;
        SerializedProperty childUsesDisplacement;
        SerializedProperty childUsesTesselation;
        SerializedProperty childUsesCliffs;
        SerializedProperty childUsesTransition;
        SerializedProperty horizonChildAvailable;
        SerializedProperty drawGizmos;
        SerializedProperty gizmoColor;
        SerializedProperty showWireF;
        SerializedProperty getFromMaterialMat;
        SerializedProperty setFeatures;
        SerializedProperty getFeatures;
        SerializedProperty getMatSettings;
        // Remember EditorWindow Layout
        SerializedProperty showFeatures;
        SerializedProperty showScaling;
        SerializedProperty showMainSettings;
        SerializedProperty showDetailSettings;
        SerializedProperty showWaterSettings;
        SerializedProperty showFogSettings;
        SerializedProperty showSnowSettings;
        SerializedProperty showDispSettings;
        SerializedProperty showCliffSettings;
        SerializedProperty showTools;
        // Features
        SerializedProperty hFeatLayerCount;
        SerializedProperty layerCount;
        SerializedProperty hFeatNormalmaps;
        SerializedProperty hFeatEmissivness;
        SerializedProperty hFeatDetailTex;
        SerializedProperty hFeatWater;
        SerializedProperty hFeatFog;
        SerializedProperty hFeatSnow;
        SerializedProperty hFeatDirSpec;
        SerializedProperty hFeatCubeRefl;
        // Settings Disc Scaling
        SerializedProperty hSetScaleInner;
        SerializedProperty hSetScaleOuter;
        SerializedProperty hSetScaleHeight;
        // Settings Main
        SerializedProperty hSetLockMask;
        SerializedProperty hTexMask;
        SerializedProperty hColTint;
        SerializedProperty hColEmissColor;
        SerializedProperty hColAmbOverride;
        SerializedProperty hSetIBLExposure;
        SerializedProperty hSetIBLReflExposure;
        SerializedProperty hSetAmbvsIBL;
        SerializedProperty hSetNMIntensLayers;
        // Settings LayerProperties
        SerializedProperty hSetLayerProps;
        // Settings Detail
        SerializedProperty hTexDetailTexDiff;
        SerializedProperty hTexDetailTexNM;
        SerializedProperty hSetDetailDiffIntens;
        SerializedProperty hSetDetailNMIntens;
        // Settings Water
        SerializedProperty hTexWaterNM;
        SerializedProperty hColWaterColorOpac;
        SerializedProperty hColWaterSpecGloss;
        SerializedProperty hSetWaterBlend;
        SerializedProperty hSetWaterWavesIntens;
        SerializedProperty HSetWaterWavesSpeed;
        // Settings Fog
        SerializedProperty hSetFogIntens;
        SerializedProperty hColFogColorAmbBlend;
        SerializedProperty hSetFogSpecCubeAdd;
        SerializedProperty hSetFogStartDist;
        SerializedProperty hSetFogTransDist;
        SerializedProperty hSetFogStartHeight;
        SerializedProperty hSetFogTransHeight;
        SerializedProperty hSetFogDistHeightOffset;
        SerializedProperty hSetFogEmissPunchThru;
        // Settings Snow
        SerializedProperty hsetSnowAmount;
        SerializedProperty hColSnowDiffColor;
        //SerializedProperty hColSnowSpecGloss;
        SerializedProperty hSetSnowStartHeight;
        SerializedProperty hSetSnowHeightTrans;
        SerializedProperty hSetSnowSlopeDamp;
        SerializedProperty hSetSnowReduceByColor;
        // Settings Displacement & Tesselation
        SerializedProperty hSetDispHeight;
        SerializedProperty hSetDispRedByVertCol;
        SerializedProperty hSetDispRedByUV;
        SerializedProperty hSetDispRedFadeAmount;
        SerializedProperty hTexDispHeightmap;
        SerializedProperty hSetTessSubD;
        // Settings Cliffs
        SerializedProperty hTexCliffDiff;
        SerializedProperty hSetCliffAIsEmissMask;
        SerializedProperty hTexCliffNM;
        //==================================================================================================================================================================================


        string installPath;
        string inspectorGUIPath;

        bool drag = false;
        float mouseStartPos;
        float mouseDragPos;
        float specialSens = 1;
        float sensitivity = 1;
        int dragVector = 1;
        string valueToChange = "";
        Event e;

        HorizON_LayerProps hmlp;
        string activeCtrlID;

        bool drawInspector;
        float inspectorWidth;
        float scrollBarWidth = 32;
        public HorizonMaster hm;
        //==================================================================================================================================================================================


        void SetupSerializedProperties()
        {
            // Misc
            isPreset = serializedObject.FindProperty("isPreset");
            childUsesDisplacement = serializedObject.FindProperty("childUsesDisplacement");
            childUsesTesselation = serializedObject.FindProperty("childUsesTesselation");
            childUsesCliffs = serializedObject.FindProperty("childUsesCliffs");
            childUsesTransition = serializedObject.FindProperty("childUsesTransition");
            horizonChildAvailable = serializedObject.FindProperty("horizonChildAvailable");
            drawGizmos = serializedObject.FindProperty("drawGizmos");
            gizmoColor = serializedObject.FindProperty("gizmoColor");
            showWireF = serializedObject.FindProperty("showWireF");
            getFromMaterialMat = serializedObject.FindProperty("getFromMaterialMat");
            setFeatures = serializedObject.FindProperty("setFeatures");
            getFeatures = serializedObject.FindProperty("getFeatures");
            getMatSettings = serializedObject.FindProperty("getMatSettings");

            // Remember EditorWindow Layout
            showFeatures = serializedObject.FindProperty("showFeatures");
            showScaling = serializedObject.FindProperty("showScaling");
            showMainSettings = serializedObject.FindProperty("showMainSettings");
            showDetailSettings = serializedObject.FindProperty("showDetailSettings");
            showWaterSettings = serializedObject.FindProperty("showWaterSettings");
            showFogSettings = serializedObject.FindProperty("showFogSettings");
            showSnowSettings = serializedObject.FindProperty("showSnowSettings");
            showDispSettings = serializedObject.FindProperty("showDispSettings");
            showCliffSettings = serializedObject.FindProperty("showCliffSettings");
            showTools = serializedObject.FindProperty("showTools");

            // Features
            hFeatLayerCount = serializedObject.FindProperty("hFeatLayerCount");
            layerCount = serializedObject.FindProperty("layerCount");
            hFeatNormalmaps = serializedObject.FindProperty("hFeatNormalmaps");
            hFeatEmissivness = serializedObject.FindProperty("hFeatEmissivness");
            hFeatDetailTex = serializedObject.FindProperty("hFeatDetailTex");
            hFeatWater = serializedObject.FindProperty("hFeatWater");
            hFeatFog = serializedObject.FindProperty("hFeatFog");
            hFeatSnow = serializedObject.FindProperty("hFeatSnow");
            hFeatDirSpec = serializedObject.FindProperty("hFeatDirSpec");
            hFeatCubeRefl = serializedObject.FindProperty("hFeatCubeRefl");
            // Settings Disc Scaling
            hSetScaleInner = serializedObject.FindProperty("hSetScaleInner");
            hSetScaleOuter = serializedObject.FindProperty("hSetScaleOuter");
            hSetScaleHeight = serializedObject.FindProperty("hSetScaleHeight");
            // Settings Main
            hSetLockMask = serializedObject.FindProperty("hSetLockMask");
            hTexMask = serializedObject.FindProperty("hTexMask");
            hColTint = serializedObject.FindProperty("hColTint");
            hColEmissColor = serializedObject.FindProperty("hColEmissColor");
            hColAmbOverride = serializedObject.FindProperty("hColAmbOverride");
            hSetIBLExposure = serializedObject.FindProperty("hSetIBLExposure");
            hSetIBLReflExposure = serializedObject.FindProperty("hSetIBLReflExposure");
            hSetAmbvsIBL = serializedObject.FindProperty("hSetAmbvsIBL");
            hSetNMIntensLayers = serializedObject.FindProperty("hSetNMIntensLayers");
            // Settings LayerProperties
            hSetLayerProps = serializedObject.FindProperty("hSetLayerProps");
            // Settings Detail
            hTexDetailTexDiff = serializedObject.FindProperty("hTexDetailTexDiff");
            hTexDetailTexNM = serializedObject.FindProperty("hTexDetailTexNM");
            hSetDetailDiffIntens = serializedObject.FindProperty("hSetDetailDiffIntens");
            hSetDetailNMIntens = serializedObject.FindProperty("hSetDetailNMIntens");
            // Settings Water
            hTexWaterNM = serializedObject.FindProperty("hTexWaterNM");
            hColWaterColorOpac = serializedObject.FindProperty("hColWaterColorOpac");
            hColWaterSpecGloss = serializedObject.FindProperty("hColWaterSpecGloss");
            hSetWaterBlend = serializedObject.FindProperty("hSetWaterBlend");
            hSetWaterWavesIntens = serializedObject.FindProperty("hSetWaterWavesIntens");
            HSetWaterWavesSpeed = serializedObject.FindProperty("HSetWaterWavesSpeed");
            // Settings Fog
            hSetFogIntens = serializedObject.FindProperty("hSetFogIntens");
            hColFogColorAmbBlend = serializedObject.FindProperty("hColFogColorAmbBlend");
            hSetFogSpecCubeAdd = serializedObject.FindProperty("hSetFogSpecCubeAdd");
            hSetFogStartDist = serializedObject.FindProperty("hSetFogStartDist");
            hSetFogTransDist = serializedObject.FindProperty("hSetFogTransDist");
            hSetFogStartHeight = serializedObject.FindProperty("hSetFogStartHeight");
            hSetFogTransHeight = serializedObject.FindProperty("hSetFogTransHeight");
            hSetFogDistHeightOffset = serializedObject.FindProperty("hSetFogDistHeightOffset");
            hSetFogEmissPunchThru = serializedObject.FindProperty("hSetFogEmissPunchThru");
            // Settings Snow
            hsetSnowAmount = serializedObject.FindProperty("hsetSnowAmount");
            hColSnowDiffColor = serializedObject.FindProperty("hColSnowDiffColor");
            //hColSnowSpecGloss = serializedObject.FindProperty("hColSnowSpecGloss");
            hSetSnowStartHeight = serializedObject.FindProperty("hSetSnowStartHeight");
            hSetSnowHeightTrans = serializedObject.FindProperty("hSetSnowHeightTrans");
            hSetSnowSlopeDamp = serializedObject.FindProperty("hSetSnowSlopeDamp");
            hSetSnowReduceByColor = serializedObject.FindProperty("hSetSnowReduceByColor");
            // Settings Displacement & Tesselation
            hSetDispHeight = serializedObject.FindProperty("hSetDispHeight");
            hSetDispRedByVertCol = serializedObject.FindProperty("hSetDispRedByVertCol");
            hSetDispRedByUV = serializedObject.FindProperty("hSetDispRedByUV");
            hSetDispRedFadeAmount = serializedObject.FindProperty("hSetDispRedFadeAmount");
            hTexDispHeightmap = serializedObject.FindProperty("hTexDispHeightmap");
            hSetTessSubD = serializedObject.FindProperty("hSetTessSubD");
            // Settings Cliffs
            hTexCliffDiff = serializedObject.FindProperty("hTexCliffDiff");
            hSetCliffAIsEmissMask = serializedObject.FindProperty("hSetCliffAIsEmissMask");
            hTexCliffNM = serializedObject.FindProperty("hTexCliffNM");
        } //==================================================================================================================================================================================


        void OnEnable(){
            SetupSerializedProperties();

			hm = (HorizonMaster)target;
			if (hm != null) {
				hm.InitLayerProps();
				hm.CheckMaterials ();
				hm.UpdateHorizonMaster();
				hm.UpdateMaterials ();
				hm.ShowWireFrame(hm.showWireF);
				SceneView.RepaintAll ();
			}
			string scriptLocation = AssetDatabase.GetAssetPath(MonoScript.FromScriptableObject(this));
			installPath = scriptLocation.Replace ("/Sources/Scripts/Editor/HorizonMasterEditor.cs", "");
			inspectorGUIPath = installPath + "/Sources/Scripts/Editor/InspectorGUI";

            Undo.undoRedoPerformed += UndoRedoCallback;
        } //==================================================================================================================================================================================


        void UndoRedoCallback()
        {
            hm.UpdateMaterials();
            SceneView.RepaintAll();
        } //==================================================================================================================================================================================


        public override void OnInspectorGUI(){
            serializedObject.Update();
            hm = (HorizonMaster)target;
            e = Event.current;
            inspectorWidth = EditorGUIUtility.currentViewWidth;

            if (drag) {
                if (valueToChange != "") {
					specialSens = 1;
					if (e.shift){specialSens = 3;}
					if (e.control) { specialSens = 0.1f; }
					if (dragVector == 1) typeof(HorizonMaster).GetField (valueToChange).SetValue (target,(float)typeof(HorizonMaster).GetField (valueToChange).GetValue (target)-e.delta.y*specialSens*sensitivity);
					if (dragVector == 2) typeof(HorizonMaster).GetField (valueToChange).SetValue (target,(Vector4)typeof(HorizonMaster).GetField (valueToChange).GetValue (target)- new Vector4(e.delta.y*specialSens*sensitivity, e.delta.y*specialSens*sensitivity, 0,0));
					if (dragVector == 3) typeof(HorizonMaster).GetField (valueToChange).SetValue (target,(Vector4)typeof(HorizonMaster).GetField (valueToChange).GetValue (target)- new Vector4(0, 0, e.delta.y*specialSens*sensitivity,0));
					if (dragVector == 4) typeof(HorizonMaster).GetField (valueToChange).SetValue (target,(Vector4)typeof(HorizonMaster).GetField (valueToChange).GetValue (target)- new Vector4(0, 0, 0, e.delta.y*specialSens*sensitivity));
					if (dragVector == 5) typeof(HorizON_LayerProps).GetField (valueToChange).SetValue (hmlp,(Vector4)typeof(HorizON_LayerProps).GetField (valueToChange).GetValue (hmlp)- new Vector4(e.delta.y*specialSens*sensitivity, e.delta.y*specialSens*sensitivity, 0,0));
					if (dragVector == 6) typeof(HorizON_LayerProps).GetField (valueToChange).SetValue (hmlp,(Vector4)typeof(HorizON_LayerProps).GetField (valueToChange).GetValue (hmlp)- new Vector4(0, 0, e.delta.y*specialSens*sensitivity,0));
					if (dragVector == 7) typeof(HorizON_LayerProps).GetField (valueToChange).SetValue (hmlp,(Vector4)typeof(HorizON_LayerProps).GetField (valueToChange).GetValue (hmlp)- new Vector4(0, 0, 0, e.delta.y*specialSens*sensitivity));
					GUI.changed = true;
				}
			} 
			if (e.type == EventType.MouseUp || e.type == EventType.Ignore) {
				drag= false;
				valueToChange = "";
				Repaint();
            } //==================================================================================================================================================================================


    //===== GUI Layout ======================================================================================================================================================================
            Texture2D bgTex;
			Texture2D logoTex = AssetDatabase.LoadAssetAtPath (inspectorGUIPath + "/Horizon[ON]Inspector_Logo.png", typeof (Texture2D))as Texture2D;
			Texture2D color01 = AssetDatabase.LoadAssetAtPath (inspectorGUIPath + "/images/Horizon[ON]Inspector_Color_01.png", typeof (Texture2D))as Texture2D;
			Texture2D color02 = AssetDatabase.LoadAssetAtPath (inspectorGUIPath + "/images/Horizon[ON]Inspector_Color_02.png", typeof (Texture2D))as Texture2D;
			Texture2D color03 = AssetDatabase.LoadAssetAtPath (inspectorGUIPath + "/images/Horizon[ON]Inspector_Color_03.png", typeof (Texture2D))as Texture2D;
			Texture2D color04 = AssetDatabase.LoadAssetAtPath (inspectorGUIPath + "/images/Horizon[ON]Inspector_Color_04.png", typeof (Texture2D))as Texture2D;
			Texture2D color05 = AssetDatabase.LoadAssetAtPath (inspectorGUIPath + "/images/Horizon[ON]Inspector_Color_05.png", typeof (Texture2D))as Texture2D;
			Texture2D color06 = AssetDatabase.LoadAssetAtPath (inspectorGUIPath + "/images/Horizon[ON]Inspector_Color_06.png", typeof (Texture2D))as Texture2D;
			Texture2D color07 = AssetDatabase.LoadAssetAtPath (inspectorGUIPath + "/images/Horizon[ON]Inspector_Color_07.png", typeof (Texture2D))as Texture2D;
			Texture2D color08 = AssetDatabase.LoadAssetAtPath (inspectorGUIPath + "/images/Horizon[ON]Inspector_Color_08.png", typeof (Texture2D))as Texture2D;
			Texture2D color09 = AssetDatabase.LoadAssetAtPath (inspectorGUIPath + "/images/Horizon[ON]Inspector_Color_09.png", typeof (Texture2D))as Texture2D;
			Texture2D color10 = AssetDatabase.LoadAssetAtPath (inspectorGUIPath + "/images/Horizon[ON]Inspector_Color_10.png", typeof (Texture2D))as Texture2D;

            Rect bgRect = EditorGUILayout.GetControlRect(GUILayout.MaxWidth(0));
            bgRect = new Rect(bgRect.x + 3, bgRect.y - 18, inspectorWidth - 38, bgRect.height + 1);

            if (EditorGUIUtility.isProSkin) {
				bgTex = AssetDatabase.LoadAssetAtPath (inspectorGUIPath + "/Horizon[ON]Inspector_bgTex_DarkSkin.jpg", typeof(Texture2D))as Texture2D;
			} else {
				bgTex = AssetDatabase.LoadAssetAtPath (inspectorGUIPath + "/Horizon[ON]Inspector_bgTex_LightSkin.jpg", typeof(Texture2D))as Texture2D;
			}

            EditorGUI.DrawPreviewTexture (bgRect, bgTex);
            GUI.DrawTexture (new Rect ((inspectorWidth/2)-109,bgRect.y+7, 210,36), logoTex);

            EditorGUILayout.GetControlRect(GUILayout.Height(4), GUILayout.MaxWidth(0));
            EditorGUILayout.GetControlRect(GUILayout.Height(4), GUILayout.MaxWidth(0));

            // Set Label Width
            EditorGUIUtility.labelWidth = inspectorWidth - 103 - scrollBarWidth;
            GUILayoutOption fieldWidth = GUILayout.Width(inspectorWidth - 4 - scrollBarWidth);


    //===== Features ======================================================================================================================================================================
            if (setFeatures.boolValue) {
				if (!isPreset.boolValue) {
                    showFeatures.boolValue = StartSection("Horizon[ON] Features", showFeatures.boolValue, color01);
					if (showFeatures.boolValue)
                    {
                        EditorGUILayout.PropertyField(hFeatLayerCount, new GUIContent("Layercount"), fieldWidth);
						EditorGUILayout.PropertyField (hFeatDirSpec, new GUIContent("Enable Specularity"));
                        EditorGUILayout.PropertyField(hFeatCubeRefl, new GUIContent("Enable Reflections"));
						EditorGUILayout.PropertyField(hFeatNormalmaps, new GUIContent("Enable Normalmapping"));
						EditorGUILayout.PropertyField(hFeatEmissivness, new GUIContent("Enable Emissiveness"));
						EditorGUILayout.PropertyField(hFeatDetailTex, new GUIContent("Enable Detail Textures"));
						EditorGUILayout.PropertyField(hFeatWater, new GUIContent("Enable Water"));
						EditorGUILayout.PropertyField(hFeatFog, new GUIContent("Enable Fog"));
						EditorGUILayout.PropertyField(hFeatSnow, new GUIContent("Enable Snow"));
					}
                    EndSection(color01);
				}
			}
            // Set Label Width
            EditorGUIUtility.labelWidth = inspectorWidth - 133 - scrollBarWidth;


    //===== Scaling ======================================================================================================================================================================
            if (childUsesTransition.boolValue) {

				string tTipScaleInner = 
					"This controls how big the blending area is between the terrain and Horizon[ON].";
                string tTipScaleOuter =
                    "This controls how much the 'Transition Sky' extends towards the horizonline.";
                string tTipScaleHeight =
                    "This controls how high the 'Transition Sky' extends into the sky.";

                showScaling.boolValue = StartSection("Transition Settings", showScaling.boolValue, color02);
                if (showScaling.boolValue)
                {
                    EditorGUILayout.PropertyField(hSetScaleInner, new GUIContent("Scale Inner", tTipScaleInner), fieldWidth);
                    EditorGUILayout.PropertyField(hSetScaleOuter, new GUIContent("Scale Outer", tTipScaleOuter), fieldWidth);
                    EditorGUILayout.PropertyField(hSetScaleHeight, new GUIContent("Scale Height", tTipScaleHeight), fieldWidth);
                }
                EndSection(color02);
			}


    //===== Main Settings ======================================================================================================================================================================
            if (horizonChildAvailable.boolValue) {

				string tTipLockMask = 
					"If this is enabled, the textures of horizon will move with the object when you move it, otherwise they will stay in place. Locking is usefull if you want to move horizon with your camera, this will give the apearance of an infinite terrain. Locking may be usefull if you want to do worldshifting.";
				string tTipTexMask = 
					"This mask defines where the layers and or the water will be drawn. Layer 1 is drawn everywhere and the following layers will overdraw the previous ones. This mask can easily be painted in an image editor, you may take a screenshot from above as a guideline if you want to match certain layers with your terrain.";
				string tTipColTint = 
					"This is a global color tint, middle grey is neutral, you can use this if your horizon is too bright or too dark in general.";
				string tTipEmissColor = 
					"The emission color will be taken from the layer colormaps where the alpha of the layer is white. This color is usefull if you want to tint this colors. The alpha value is a multiplier for the intensity.";
                string tTipAmbDiffIntensity =
                    "This controls how strong Horizon[ON] is affected by diffuse ambient light.";
                string tTipAmbReflIntensity =
                    "This controls how strong Horizon[ON] is affected by specular ambient light(Reflections).";
                string tTipAmbOverride = 
					"You can use this color to override the ambient light for Horizon[ON]. How much of it is overridden is controlled by the alpha value.";
				string tTipAmbvsIBL = 
					"Here you can gradually fade between IBL and ambient light.";
				string tTipNMIntens = 
					"This controls globally how strong the normalmaps of the layers are applied.";

                showMainSettings.boolValue = StartSection("Main Settings", showMainSettings.boolValue, color03);
                if (showMainSettings.boolValue)
                {
                    // Mask Scale
                    EditorGUILayout.BeginHorizontal();
                    ButtonDragSingle("Scale", "(m)", "hSetMaskScaleOffset", 1, 2, -1, "MaskScale");
                    EditorGUI.BeginChangeCheck();
                    float a = EditorGUILayout.FloatField(hm.hSetMaskScaleOffset.x, GUILayout.Width(63));
                    if (EditorGUI.EndChangeCheck()) { Undo.RecordObject(hm, "Inspector"); hm.hSetMaskScaleOffset.x = a; }
                    EditorGUI.BeginChangeCheck();
                    float b = EditorGUILayout.FloatField(hm.hSetMaskScaleOffset.y, GUILayout.Width(62));
                    if (EditorGUI.EndChangeCheck()) { Undo.RecordObject(hm, "Inspector"); hm.hSetMaskScaleOffset.y = b; }
                    EditorGUILayout.EndHorizontal();

                    // Mask Offset
                    EditorGUILayout.BeginHorizontal();
                    ButtonDragDouble("OffsetX", "OffsetY", "", "hSetMaskScaleOffset", "hSetMaskScaleOffset", 1, 3, 4, -1, "MaskOffset");
                    EditorGUI.BeginChangeCheck();
                    float c = EditorGUILayout.FloatField(hm.hSetMaskScaleOffset.z, GUILayout.Width(63));
                    if (EditorGUI.EndChangeCheck()) { Undo.RecordObject(hm, "Inspector"); hm.hSetMaskScaleOffset.z = c; }
                    EditorGUI.BeginChangeCheck();
                    float d = EditorGUILayout.FloatField(hm.hSetMaskScaleOffset.w, GUILayout.Width(62));
                    if (EditorGUI.EndChangeCheck()) { Undo.RecordObject(hm, "Inspector"); hm.hSetMaskScaleOffset.w = d; }
                    EditorGUILayout.EndHorizontal();

                    // Lock Mask
                    EditorGUILayout.BeginHorizontal ();
					EditorGUILayout.LabelField ("", EditorStyles.label, GUILayout.Width (inspectorWidth - 138 - scrollBarWidth));
					EditorGUILayout.LabelField (new GUIContent("Use local Space", tTipLockMask), EditorStyles.label, GUILayout.Width (111));
					hSetLockMask.boolValue = EditorGUILayout.Toggle (hSetLockMask.boolValue, GUILayout.Width (16));
					EditorGUILayout.EndHorizontal ();

					// Mask
					if (hm.hFeatLayerCount != HorizonMaster.LayerCount.One || hFeatWater.boolValue) {
						EditorGUILayout.LabelField (new GUIContent("Mask (RGBA)", tTipTexMask), EditorStyles.boldLabel, GUILayout.Width (inspectorWidth - 137 - scrollBarWidth));
                        Rect rectA = EditorGUILayout.GetControlRect(GUILayout.Height(0), GUILayout.MaxWidth(0));
                        rectA = new Rect (rectA.x + (inspectorWidth - 133 - scrollBarWidth), rectA.y - 16, 129, 129);
						hTexMask.objectReferenceValue = EditorGUI.ObjectField (rectA, hTexMask.objectReferenceValue, typeof(Texture), false) as Texture;
						GUILayout.Box ("Layers are drawn on\ntop of each other:\n\nLayer 1 is base...\nR = Layer 2\nG = Layer 3\nB = Layer 4\nA = Water", EditorStyles.miniLabel, GUILayout.Width (132), GUILayout.Height (112));
					}

                    EditorGUILayout.PropertyField(hColTint, new GUIContent("Global Tint", tTipColTint), fieldWidth);
                    if (hFeatEmissivness.boolValue) EditorGUILayout.PropertyField(hColEmissColor, new GUIContent("Emission Color", tTipEmissColor), fieldWidth);
                    EditorGUILayout.PropertyField(hColAmbOverride, new GUIContent("Ambient Override (A)Amount", tTipAmbOverride), fieldWidth);
                    EditorGUILayout.PropertyField(hSetIBLExposure, new GUIContent("Ambient Diffuse Intensity", tTipAmbDiffIntensity), fieldWidth);
                    if (hFeatCubeRefl.boolValue) EditorGUILayout.PropertyField(hSetIBLReflExposure, new GUIContent("Ambient Reflection Intensity", tTipAmbReflIntensity), fieldWidth);
                    EditorGUILayout.PropertyField(hSetAmbvsIBL, new GUIContent("Ambient vs. IBL", tTipAmbvsIBL), fieldWidth);
                    if (hFeatNormalmaps.boolValue) EditorGUILayout.PropertyField(hSetNMIntensLayers, new GUIContent("Normal Intensity", tTipNMIntens), fieldWidth);
                }
                EndSection(color03);
			}


    //===== Layer Settings ======================================================================================================================================================================
            if (horizonChildAvailable.boolValue) {

				string tTipLayerDiff = 
					"The colormap of this layer.";
				//string tTipAIsGlossMask = 
				//	"If this is enabled the alpha channel of the layer colormap will be used as a gloss mask.";
				string tTipAIsEmissMask = 
					"If this is enabled the alpha channel of the layer colormap will be used as an emission mask.";
				string tTipLayerNM = 
					"The normalmap of this layer.";
				string tTipLayerTint = 
					"Set the color to tint this layer, middle grey is neutral. The alpha channel controls the saturation of this layer.";
				//string tTipLayerSpecGloss = 
				//	"The specular color of this layer. The alpha channel controls the glossines.";
				string tTipLayerDetIntens = 
					"Controls how strong the detail textures are applied to this layer.";

                // Layer Header
                for (int i = 0; i < layerCount.intValue; i++) {
                    hSetLayerProps.GetArrayElementAtIndex(i).FindPropertyRelative("showLayerSettings").boolValue = 
                        StartSection("Layer " + (i + 1).ToString() + " Settings", hSetLayerProps.GetArrayElementAtIndex(i).FindPropertyRelative("showLayerSettings").boolValue, color04);
                    if (hSetLayerProps.GetArrayElementAtIndex(i).FindPropertyRelative("showLayerSettings").boolValue) {
				
						// Layer Settings Content

						// Diffuse Texture
						EditorGUILayout.BeginHorizontal ();
						EditorGUILayout.LabelField (new GUIContent("Colormap", tTipLayerDiff), EditorStyles.boldLabel, GUILayout.Width (inspectorWidth - 137 - scrollBarWidth));
						//Rect rectA = GUILayoutUtility.GetRect (0, 0);
                        Rect rectA = EditorGUILayout.GetControlRect(GUILayout.Height(0), GUILayout.MaxWidth(0));
                        rectA = new Rect (rectA.x, rectA.y, 129, 129);
                        hSetLayerProps.GetArrayElementAtIndex(i).FindPropertyRelative("hTexLayerDiff").objectReferenceValue =
                            EditorGUI.ObjectField(rectA, hSetLayerProps.GetArrayElementAtIndex(i).FindPropertyRelative("hTexLayerDiff").objectReferenceValue, typeof(Texture), false);
                        EditorGUILayout.EndHorizontal ();

                        // A is Emission
                        if (hFeatEmissivness.boolValue) {
							EditorGUILayout.BeginHorizontal ();
                            hSetLayerProps.GetArrayElementAtIndex(i).FindPropertyRelative("hSetAIsEmissMask").boolValue = 
                                EditorGUILayout.Toggle(hSetLayerProps.GetArrayElementAtIndex(i).FindPropertyRelative("hSetAIsEmissMask").boolValue, GUILayout.Width(12));
                            EditorGUILayout.LabelField (new GUIContent("A = Emission", tTipAIsEmissMask), EditorStyles.label, GUILayout.Width (85));
							EditorGUILayout.EndHorizontal ();
						} else {
                            EditorGUILayout.GetControlRect(GUILayout.Height(16));
                        }
                        EditorGUILayout.GetControlRect(GUILayout.Height(94));

						// Normal Texture
						if (hm.hFeatNormalmaps) {
							EditorGUILayout.BeginHorizontal ();
							EditorGUILayout.LabelField (new GUIContent("Normalmap", tTipLayerNM), EditorStyles.boldLabel, GUILayout.Width (inspectorWidth - 137 - scrollBarWidth));
                            Rect rectB = EditorGUILayout.GetControlRect(GUILayout.Height(0), GUILayout.MaxWidth(0));
                            rectB = new Rect (rectB.x, rectB.y, 128, 16);
                            hSetLayerProps.GetArrayElementAtIndex(i).FindPropertyRelative("hTexLayerNM").objectReferenceValue =
                                EditorGUI.ObjectField(rectB, hSetLayerProps.GetArrayElementAtIndex(i).FindPropertyRelative("hTexLayerNM").objectReferenceValue, typeof(Texture), false);
                            EditorGUILayout.EndHorizontal ();
						}

						// Map Scale
						EditorGUILayout.BeginHorizontal ();
						ButtonDragSingle ("Tiling","" , "hSetLayerScaleOffset", 0.001f, 5, i, "layerTiling"+i.ToString());
                        EditorGUI.BeginChangeCheck();
                        float e = EditorGUILayout.FloatField (hm.hSetLayerProps [i].hSetLayerScaleOffset.x, GUILayout.Width (63));
                        if (EditorGUI.EndChangeCheck()) { Undo.RecordObject(hm, "Inspector"); hm.hSetLayerProps[i].hSetLayerScaleOffset.x = e; }
                        EditorGUI.BeginChangeCheck();
                        float f = EditorGUILayout.FloatField (hm.hSetLayerProps [i].hSetLayerScaleOffset.y, GUILayout.Width (62));
                        if (EditorGUI.EndChangeCheck()) { Undo.RecordObject(hm, "Inspector"); hm.hSetLayerProps[i].hSetLayerScaleOffset.y = f; }
                        EditorGUILayout.EndHorizontal ();
					
						// Map Offset
						EditorGUILayout.BeginHorizontal ();
						ButtonDragDouble ("OffsetX","OffsetY", "", "hSetLayerScaleOffset", "hSetLayerScaleOffset", 0.001f, 6, 7, i, "layerOffset"+i.ToString());
                        EditorGUI.BeginChangeCheck();
                        float g = EditorGUILayout.FloatField (hm.hSetLayerProps [i].hSetLayerScaleOffset.z, GUILayout.Width (63));
                        if (EditorGUI.EndChangeCheck()) { Undo.RecordObject(hm, "Inspector"); hm.hSetLayerProps[i].hSetLayerScaleOffset.z = g; }
                        EditorGUI.BeginChangeCheck();
                        float h = EditorGUILayout.FloatField (hm.hSetLayerProps [i].hSetLayerScaleOffset.w, GUILayout.Width (62));
                        if (EditorGUI.EndChangeCheck()) { Undo.RecordObject(hm, "Inspector"); hm.hSetLayerProps[i].hSetLayerScaleOffset.w = h; }
                        EditorGUILayout.EndHorizontal ();

						// Tint
                        EditorGUILayout.PropertyField(hSetLayerProps.GetArrayElementAtIndex(i).FindPropertyRelative("hColLayerTint"), new GUIContent("Tint / Saturation", tTipLayerTint), fieldWidth);
                        // Layer Detail Intensity
                        if (hm.hFeatDetailTex) EditorGUILayout.PropertyField(hSetLayerProps.GetArrayElementAtIndex(i).FindPropertyRelative("hSetLayerDetIntens"), new GUIContent("Detail Intensity", tTipLayerDetIntens), fieldWidth);
					}
					EndSection(color04);
				}
			}


    //===== Detail Settings ======================================================================================================================================================================
            if (hFeatDetailTex.boolValue && horizonChildAvailable.boolValue) {

				string tTipetailTexDiff = 
					"The detail colormap. It is blended in overlay mode, that means that pixels darker than 128(sRGB unchecked in Texture Importer) will darken and pixels brighter than 128 will brighten the underlying layers.";
				string tTipDetailTexNM = 
					"The detail normalmap.";
				string tTipDetailDiffIntens = 
					"Controls how strong the detail colormap will be blended.";
				string tTipDetailNMIntens = 
					"Controls how strong the detail normalmap will be blended.";

                showDetailSettings.boolValue = StartSection("Detail Settings", showDetailSettings.boolValue, color05);
                if (showDetailSettings.boolValue) {
				
					// Scale
					EditorGUILayout.BeginHorizontal ();
					ButtonDragSingle ("Tiling","" , "hSetDetailScaleOffset", 0.05f, 2, -1, "DetailScale");
                    EditorGUI.BeginChangeCheck();
                    float i = EditorGUILayout.FloatField (hm.hSetDetailScaleOffset.x, GUILayout.Width (63));
                    if (EditorGUI.EndChangeCheck()) { Undo.RecordObject(hm, "Inspector"); hm.hSetDetailScaleOffset.x = i; }
                    EditorGUI.BeginChangeCheck();
                    float j = EditorGUILayout.FloatField (hm.hSetDetailScaleOffset.y, GUILayout.Width (62));
                    if (EditorGUI.EndChangeCheck()) { Undo.RecordObject(hm, "Inspector"); hm.hSetDetailScaleOffset.y = j; }
                    EditorGUILayout.EndHorizontal ();

					// ColorMap
					EditorGUILayout.LabelField (new GUIContent("Colormap", tTipetailTexDiff), EditorStyles.boldLabel, GUILayout.Width (inspectorWidth - 137 - scrollBarWidth));
                    Rect rectA = EditorGUILayout.GetControlRect(GUILayout.Height(0), GUILayout.MaxWidth(0));
                    rectA = new Rect (rectA.x + (inspectorWidth - 133 - scrollBarWidth), rectA.y - 16, 129, 129);
					hTexDetailTexDiff.objectReferenceValue = EditorGUI.ObjectField (rectA, hTexDetailTexDiff.objectReferenceValue, typeof(Texture), false) as Texture;
					GUILayout.Box ("Colormap is blended\nin overlay mode...\n\nEverything below\nmiddle grey is\ndarkening and\neverything above\nmiddle grey is\nbrightening.", EditorStyles.miniLabel, GUILayout.Width (132), GUILayout.Height (112));

					// Normal Texture
					if (hFeatNormalmaps.boolValue) {
						EditorGUILayout.BeginHorizontal ();
						EditorGUILayout.LabelField (new GUIContent("Normalmap", tTipDetailTexNM), EditorStyles.boldLabel, GUILayout.Width (inspectorWidth - 137 - scrollBarWidth));
                        Rect rectB = EditorGUILayout.GetControlRect(GUILayout.Height(0), GUILayout.MaxWidth(0));
                        rectB = new Rect (rectB.x, rectB.y, 128, 16);
						hTexDetailTexNM.objectReferenceValue = EditorGUI.ObjectField (rectB, hTexDetailTexNM.objectReferenceValue, typeof(Texture), false) as Texture;
						EditorGUILayout.EndHorizontal ();
					}			
					// Colormap Intensity
					EditorGUILayout.PropertyField (hSetDetailDiffIntens, new GUIContent("Color Intensity", tTipDetailDiffIntens), fieldWidth);

					// Normal Intensity
					if (hFeatNormalmaps.boolValue) EditorGUILayout.PropertyField(hSetDetailNMIntens, new GUIContent("Normal Intensity", tTipDetailNMIntens), fieldWidth);
				}
                EndSection(color05);
			}


    //===== Water Settings ======================================================================================================================================================================
            if (hFeatWater.boolValue && horizonChildAvailable.boolValue) {

				string tTipWaterColorOpac = 
					"The diffuse color of the water. The alpha channel controls the opacity of the water.";
				string tTiphWaterSpecGloss = 
					"The specular color of the water. The alpha channel controls the glossines of the water";
				string tTipWaterBlend = 
					"Controls the visibility of the water, can be used to simulate partially wet areas.";
				string tTipWaterNM = 
					"The normalmap for the water.";
				string tTipWaterWavesIntens = 
					"Controls the intensity of the waves.";
                string tTipWaterWavesSpeed =
                    "Controls the speed of the waves.";

                showWaterSettings.boolValue = StartSection("Water Settings", showWaterSettings.boolValue, color06);
                if (showWaterSettings.boolValue) {

					// Color
                    EditorGUILayout.PropertyField(hColWaterColorOpac, new GUIContent("Color / Opacity", tTipWaterColorOpac), fieldWidth);
                    // Spec Gloss
                    if (hFeatDirSpec.boolValue || hFeatCubeRefl.boolValue) EditorGUILayout.PropertyField(hColWaterSpecGloss, new GUIContent("Spec / Gloss", tTiphWaterSpecGloss), fieldWidth);
					// Blend
                    EditorGUILayout.PropertyField(hSetWaterBlend, new GUIContent("Water Blend", tTipWaterBlend), fieldWidth);

                    // NormalMap
                    if (hFeatNormalmaps.boolValue) {
						EditorGUILayout.LabelField (new GUIContent("Normalmap", tTipWaterNM), EditorStyles.boldLabel, GUILayout.Width (inspectorWidth - 137 - scrollBarWidth));
						//Rect rectA = GUILayoutUtility.GetRect (0, 0);
                        Rect rectA = EditorGUILayout.GetControlRect(GUILayout.Height(0), GUILayout.MaxWidth(0));
                        rectA = new Rect (rectA.x + (inspectorWidth - 133 - scrollBarWidth), rectA.y - 16, 129, 129);
						hTexWaterNM.objectReferenceValue = EditorGUI.ObjectField (rectA, hTexWaterNM.objectReferenceValue, typeof(Texture), false) as Texture;
						EditorGUILayout.GetControlRect(GUILayout.Height(112));

						// Scale
						EditorGUILayout.BeginHorizontal ();
						ButtonDragSingle ("Tiling","" , "hSetWaterScaleOffset", 0.05f, 2);
                        EditorGUI.BeginChangeCheck();
                        float k = EditorGUILayout.FloatField (hm.hSetWaterScaleOffset.x, GUILayout.Width (63));
                        if (EditorGUI.EndChangeCheck()) { Undo.RecordObject(hm, "Inspector"); hm.hSetWaterScaleOffset.x = k; }
                        EditorGUI.BeginChangeCheck();
                        float l = EditorGUILayout.FloatField (hm.hSetWaterScaleOffset.y, GUILayout.Width (62));
                        if (EditorGUI.EndChangeCheck()) { Undo.RecordObject(hm, "Inspector"); hm.hSetWaterScaleOffset.y = l; }
                        EditorGUILayout.EndHorizontal ();
																	
						// Normal Intensity
                        EditorGUILayout.PropertyField(hSetWaterWavesIntens, new GUIContent("Waviness", tTipWaterWavesIntens), fieldWidth);
                        // Wave Speed
                        EditorGUILayout.PropertyField(HSetWaterWavesSpeed, new GUIContent("Wave Speed", tTipWaterWavesSpeed), fieldWidth);
                    }
				}
                EndSection(color06);
			}


    //===== Fog Settings ======================================================================================================================================================================
            if (hFeatFog.boolValue && horizonChildAvailable.boolValue) {

				string tTipFogIntens = 
					"This is the global setting for the amount of fog.";
				string tTiphColFogColorAmbBlend = 
					"The color of the fog, should be similiar to the ambient light color. The alpha channel controls how much of the color should be taken from the ambient light color.";
				string tTipFogSpecCubeAdd = 
					"Controls how much of the reflection cubemap color should be added to the fog color. This can give some directional dependence to the fog and might also help to match the fog color with the sky.";
                string tTipFogHeightOffsetByDist =
                    "This will raise or lower the fog base height depending on distance. This can help if you want to have heightbased fog and still hide/reveal further away things in the fog.";
                string tTipFogEmissPunchThru = 
					"Controls how strong the emissive color will shine through the fog.";

                showFogSettings.boolValue = StartSection("Fog Settings", showFogSettings.boolValue, color07);
                if (showFogSettings.boolValue)
                {
					// Fog Amount
                    EditorGUILayout.PropertyField(hSetFogIntens, new GUIContent("Fog Amount", tTipFogIntens), fieldWidth);
                    // Color
                    EditorGUILayout.PropertyField(hColFogColorAmbBlend, new GUIContent("Color/Amb. Blend", tTiphColFogColorAmbBlend), fieldWidth);
                    // Cube Add
                    if (hFeatCubeRefl.boolValue) EditorGUILayout.PropertyField(hSetFogSpecCubeAdd, new GUIContent("Cubemap Add", tTipFogSpecCubeAdd), fieldWidth);

					// Start Distance
					EditorGUILayout.BeginHorizontal ();
					ButtonDragDouble ("Start","End","(m)", "hSetFogStartDist", "hSetFogTransDist");
                    hSetFogStartDist.floatValue = EditorGUILayout.FloatField (hSetFogStartDist.floatValue, GUILayout.Width (63));
                    hSetFogTransDist.floatValue = EditorGUILayout.FloatField (hSetFogTransDist.floatValue, GUILayout.Width (62));
					EditorGUILayout.EndHorizontal ();

					// Start Height
					EditorGUILayout.BeginHorizontal ();
					ButtonDragDouble ("Base","Height","(m)", "hSetFogStartHeight", "hSetFogTransHeight");
                    hSetFogStartHeight.floatValue = EditorGUILayout.FloatField (hSetFogStartHeight.floatValue, GUILayout.Width (63));
                    hSetFogTransHeight.floatValue = EditorGUILayout.FloatField (hSetFogTransHeight.floatValue, GUILayout.Width (62));
					EditorGUILayout.EndHorizontal ();

					// Height offset by distance
                    EditorGUILayout.PropertyField(hSetFogDistHeightOffset, new GUIContent("Height Offset by Distance", tTipFogHeightOffsetByDist), fieldWidth);
                    // Emission punch through
                    EditorGUILayout.PropertyField(hSetFogEmissPunchThru, new GUIContent("Emission seethru", tTipFogEmissPunchThru), fieldWidth);
                }
                EndSection(color07);
			}


    //===== Snow Settings ======================================================================================================================================================================
            if (hFeatSnow.boolValue && horizonChildAvailable.boolValue) {

				string tTipSnowAmount = 
					"This is the global setting for the amount of snow.";
				string tTipSnowDiffColor = 
					"The color of the snow. A slight blueish tint is recommended";
				//string tTipSnowSpecGloss = 
				//	"The specular color of the snow. The alpha value controls the glossiness of the snow, for ice a relatively high value is recommended.";
				string tTipSnowSlopeDamp = 
					"How steep/flat should a surface be so snow can lay on it";
				string tTipSnowReduceByColor =
					"This reduces the snow amount if the underlying color is dark. (Dark surfaces absorb more heat and therefor snow will need longer to gather)";

                showSnowSettings.boolValue = StartSection("Snow Settings", showSnowSettings.boolValue, color09);
                if (showSnowSettings.boolValue)
                {
					// Snow Amount
                    EditorGUILayout.PropertyField(hsetSnowAmount, new GUIContent("Snow Amount", tTipSnowAmount), fieldWidth);
                    // Color
                    EditorGUILayout.PropertyField(hColSnowDiffColor, new GUIContent("Snow Color", tTipSnowDiffColor), fieldWidth);
                    // Spec Gloss
                    //if (hFeatCubeRefl.boolValue || hFeatDirSpec.boolValue) EditorGUILayout.PropertyField(hColSnowSpecGloss, new GUIContent("Spec / Gloss", tTipSnowSpecGloss), fieldWidth);
					// Height

					EditorGUILayout.BeginHorizontal ();
					ButtonDragDouble("Base", "Height", "(m)", "hSetSnowStartHeight", "hSetSnowHeightTrans");
                    hSetSnowStartHeight.floatValue = EditorGUILayout.FloatField (hSetSnowStartHeight.floatValue, GUILayout.Width (63));
                    hSetSnowHeightTrans.floatValue = EditorGUILayout.FloatField (hSetSnowHeightTrans.floatValue, GUILayout.Width (62));
					EditorGUILayout.EndHorizontal ();
					
					// Slope Damp
                    EditorGUILayout.PropertyField(hSetSnowSlopeDamp, new GUIContent("Slope Damping", tTipSnowSlopeDamp), fieldWidth);
                    // Color Damp
                    EditorGUILayout.PropertyField(hSetSnowReduceByColor, new GUIContent("Color Damping", tTipSnowReduceByColor), fieldWidth);
                }
                EndSection(color09);
			}


    //===== Displacement & Tesselation Settings ======================================================================================================================================================================
            if (childUsesDisplacement.boolValue) {

				// Tooltips
				string tTipDispHeightmap = 
					"The The heightmap for displacent. It uses 4 channels, ARGB, that means that the alpha channel is used for layer 1, the red channel is used for layer 2, the green channel is used for layer 3 and the blue channel is used for layer 4. Water (if enabled) will be flattened automatically.";
                string tTipDispHeight =
                    "Controls the amount of vertical displacement, basically the maximum height of the Horizon[ON] objects which use displacement.";
                string tTipDispRedByUV = 
					"When this is enabled, displacement will be reduced near the borders of the meshes. The mesh UVs are used for this. If you want to use your own meshes you can set the UVs in a way to reduce displacement where you want. A value of 0.5 will not reduce displacement but a value of 0 will and a vale of 1 will too. (UVs are not used for texturing)";
				string tTipDispRedByVertCol = 
					"When this is enabled you can use vertex painitng to reduce displacement.";
				string tTipDispRedFadeAmount = 
					"This slider controlls how strong the displacement will be reduced by the UV borders.";
				string tTipTessSubD =
					"This controls how often the mesh is subdivided";

                showDispSettings.boolValue = StartSection("Displacement Settings", showDispSettings.boolValue, color08);
                if (showDispSettings.boolValue)
                {
					// HeightMap
					EditorGUILayout.LabelField (new GUIContent("Heightmap", tTipDispHeightmap),EditorStyles.boldLabel, GUILayout.Width (inspectorWidth - 137 - scrollBarWidth));
                    Rect rectA = EditorGUILayout.GetControlRect(GUILayout.Height(0), GUILayout.MaxWidth(0));
                    rectA = new Rect (rectA.x + (inspectorWidth - 133 - scrollBarWidth), rectA.y - 16, 129, 129);
					hTexDispHeightmap.objectReferenceValue = EditorGUI.ObjectField (rectA, hTexDispHeightmap.objectReferenceValue, typeof(Texture), false);
					GUILayout.Box ("Heightmap uses 4\nChannels (ARGB)...\nA = Layer 1\nR = Layer 2\nG = Layer 3\nB = Layer 4\n\nWater flattens\nautomatically", EditorStyles.miniLabel, GUILayout.Width (132), GUILayout.Height (112));

					// Disp Height
                    EditorGUILayout.PropertyField(hSetDispHeight, new GUIContent("Height(m)", tTipDispHeight), fieldWidth);

                    // Reduce by Border
                    EditorGUILayout.BeginHorizontal ();
					EditorGUILayout.LabelField (new GUIContent("Flatten by UVs (near 0 and 1)", tTipDispRedByUV), EditorStyles.label, GUILayout.Width (inspectorWidth - 22 - scrollBarWidth));
					hSetDispRedByUV.boolValue = EditorGUILayout.Toggle (hSetDispRedByUV.boolValue, GUILayout.Width (16));
					EditorGUILayout.EndHorizontal ();

					// Reduce by Vert Color
					EditorGUILayout.BeginHorizontal ();
					EditorGUILayout.LabelField (new GUIContent("Flatten by Vertex Color (A)", tTipDispRedByVertCol), EditorStyles.label, GUILayout.Width (inspectorWidth - 22 - scrollBarWidth));
					hSetDispRedByVertCol.boolValue = EditorGUILayout.Toggle (hSetDispRedByVertCol.boolValue, GUILayout.Width (16));
					EditorGUILayout.EndHorizontal ();
				
					// Flatten Strength
                    EditorGUILayout.PropertyField(hSetDispRedFadeAmount, new GUIContent("Flatten Strength", tTipDispRedFadeAmount), fieldWidth);

                    // DX11 SubDs
                    if (childUsesTesselation.boolValue){
						//if (PlayerSettings.useDirect3D11) {
                        if (SystemInfo.graphicsDeviceVersion.Contains("Direct3D 11") || SystemInfo.graphicsDeviceVersion.Contains("Direct3D 12"))
                        {
                            EditorGUILayout.BeginHorizontal ();
							EditorGUILayout.LabelField (new GUIContent("SubDivisions", tTipTessSubD), EditorStyles.label, GUILayout.Width (inspectorWidth - 137 - scrollBarWidth));
							hSetTessSubD.floatValue = EditorGUILayout.Slider (hSetTessSubD.floatValue, 1, 40, GUILayout.Width (129));
							EditorGUILayout.EndHorizontal ();
                            EditorGUILayout.PropertyField(hSetTessSubD, new GUIContent("SubDivisions", tTipTessSubD), fieldWidth);
                        }
					}
				}
                EndSection(color08);
			}

    //===== Cliff Settings ======================================================================================================================================================================
            if (childUsesCliffs.boolValue) {

				// Tooltips
				string tTipCliffMainColormap = 
					"The main colormap for the cliff layer, this map is projected 2-planar in worldspace. \n(custom cliff meshes dont need UVs)";
				string tTipCliffAIsEmissMask = 
					"If this is enabled the alpha channel of the cliff colormap will be used as emission mask. \n(Emission is controlled globally in the main settings foldout)";
				string tTipCliffMainNormalmap = 
					"The main normalmap for the cliff layer, this map is projected 2-planar in worldspace. \n(Custom cliff meshes dont need UVs)";

                showCliffSettings.boolValue = StartSection("Cliff Settings", showCliffSettings.boolValue, color08);
                if (showCliffSettings.boolValue)
                {
					// Diffuse Texture
					EditorGUILayout.BeginHorizontal ();
					EditorGUILayout.LabelField (new GUIContent("Colormap", tTipCliffMainColormap), EditorStyles.boldLabel, GUILayout.Width (inspectorWidth - 137 - scrollBarWidth));
                    Rect rectA = EditorGUILayout.GetControlRect(GUILayout.Height(0), GUILayout.MaxWidth(0));
                    rectA = new Rect (rectA.x, rectA.y, 129, 129);
					hTexCliffDiff.objectReferenceValue = EditorGUI.ObjectField (rectA, hTexCliffDiff.objectReferenceValue, typeof(Texture), false);
					EditorGUILayout.EndHorizontal ();

					// A is Emission
					if (hFeatEmissivness.boolValue) {
						EditorGUILayout.BeginHorizontal ();
						hSetCliffAIsEmissMask.boolValue = EditorGUILayout.Toggle (hSetCliffAIsEmissMask.boolValue, GUILayout.Width (12));
						EditorGUILayout.LabelField (new GUIContent("A = Emission", tTipCliffAIsEmissMask), EditorStyles.label, GUILayout.Width (85));
						EditorGUILayout.EndHorizontal ();
					} else {
                        EditorGUILayout.GetControlRect(GUILayout.Height(16));
                    }
                    EditorGUILayout.GetControlRect(GUILayout.Height(94));

					// Normal Texture
					if (hFeatNormalmaps.boolValue) {
						EditorGUILayout.BeginHorizontal ();
						EditorGUILayout.LabelField (new GUIContent("Normalmap", tTipCliffMainNormalmap), EditorStyles.boldLabel, GUILayout.Width (inspectorWidth - 137 - scrollBarWidth));
                        Rect rectB = EditorGUILayout.GetControlRect(GUILayout.Height(0), GUILayout.MaxWidth(0));
                        rectB = new Rect (rectB.x, rectB.y, 128, 16);
						hTexCliffNM.objectReferenceValue = EditorGUI.ObjectField (rectB, hTexCliffNM.objectReferenceValue, typeof(Texture), false);
						EditorGUILayout.EndHorizontal ();
					}
				
					// Map Scale
					EditorGUILayout.BeginHorizontal ();
					ButtonDragSingle ("Tiling", "", "hSetCliffScaleOffset", 0.05f, 2);
                    EditorGUI.BeginChangeCheck();
                    float m = EditorGUILayout.FloatField (hm.hSetCliffScaleOffset.x, GUILayout.Width (63));
                    if (EditorGUI.EndChangeCheck()) { Undo.RecordObject(hm, "Inspector"); hm.hSetCliffScaleOffset.x = m; }
                    EditorGUI.BeginChangeCheck();
                    float n = EditorGUILayout.FloatField (hm.hSetCliffScaleOffset.y, GUILayout.Width (62));
                    if (EditorGUI.EndChangeCheck()) { Undo.RecordObject(hm, "Inspector"); hm.hSetCliffScaleOffset.y = n; }
                    EditorGUILayout.EndHorizontal ();
				}
                EndSection(color08);
			}


	//===== Tools Settings ======================================================================================================================================================================
			if (horizonChildAvailable.boolValue) {

				// Tooltips
				string tTipToolsSetFeatures = 
					"When this is enabled horizon master will set the features for all of its children.\n(Default: On)";
				string tTipToolsGetFeatures = 
					"If this is enabled this script will adopt the material features of its children instead of being \"set only\". "+
						"This is needed if you want to control this horizon master with a horizon master higher up in the hierarchy. " +
						"For example if you want to control material groups with differentfeature sets.\n(Default: Off)";
				string tTipToolsGetMatSettingsfromCh = 
					"If this is enabled this script will adopt the material parameters of its children instead of being \"set only\". " +
						"This is needed if you want to control this script with a horizon master higher up in the hierarchy. " +
						"For example if you want to control material groups with different feature sets.\n(Default: Off)";
				string tTipToolsHideWireFrame = 
					"Hides the annoying wireframes for the children, so you can see what you are tweaking.\n(Default: Off)";
				string tTipToolsGetSettingsFromMat =
					"Drag a Horizon[ON] Material into the slot to adopt its settings.";
				string tTipToolsLoad = 
					"Load a previously saved settings file.";
				string tTipToolsSave = 
					"Save the current settings to a specified location. This is very helpful to transfer settings between scenes.";
				string tTipToolsShowBounds = 
					"Show the bounds of the children which use displacement, this helps to check if culling is done right.\n(Default: Off)";
				string tTipToolsCalcBounds = 
					"Automatically calculate the bounds of children which use displacement, this should always be done if you are satisfied with the results, Culling will be more efficient and correct.";
				string tTipToolsBakeDisp = 
					"This bakes the displacement of the children into new meshes. This is helpful if you want to use them on mobile where displacement does not work, " +
						"or if you need to add meshcolliders to them.";

                showTools.boolValue = StartSection("Horizon[ON] Tools", showTools.boolValue, color10);
                if (showTools.boolValue)
                {
					// Options
					EditorGUILayout.BeginHorizontal();
					EditorGUILayout.LabelField (new GUIContent("Set Features (for all children)", tTipToolsSetFeatures), GUILayout.Width (inspectorWidth - 23 - scrollBarWidth));
					setFeatures.boolValue = EditorGUILayout.Toggle(setFeatures.boolValue, GUILayout.Width (16));
					EditorGUILayout.EndHorizontal ();

					EditorGUILayout.BeginHorizontal();
					EditorGUILayout.LabelField (new GUIContent("Get Features (from children)", tTipToolsGetFeatures), GUILayout.Width (inspectorWidth - 23 - scrollBarWidth));
					getFeatures.boolValue = EditorGUILayout.Toggle(getFeatures.boolValue, GUILayout.Width (16));
					EditorGUILayout.EndHorizontal ();

					EditorGUILayout.BeginHorizontal();
					EditorGUILayout.LabelField (new GUIContent("Get Material Settings (from children)", tTipToolsGetMatSettingsfromCh), GUILayout.Width (inspectorWidth - 23 - scrollBarWidth));
					getMatSettings.boolValue = EditorGUILayout.Toggle(getMatSettings.boolValue, GUILayout.Width (16));
					EditorGUILayout.EndHorizontal ();

					EditorGUILayout.BeginHorizontal();
					EditorGUILayout.LabelField (new GUIContent("Hide Selection Wireframe", tTipToolsHideWireFrame), GUILayout.Width(inspectorWidth - 23 - scrollBarWidth));
					bool changedOld = GUI.changed;
					GUI.changed = false;
					showWireF.boolValue = EditorGUILayout.Toggle (showWireF.boolValue);
					if (GUI.changed) hm.ShowWireFrame(showWireF.boolValue);
					GUI.changed = changedOld;
					EditorGUILayout.EndHorizontal ();

					EditorGUILayout.BeginHorizontal ();
					EditorGUILayout.LabelField (new GUIContent("Get Settings from Material:", tTipToolsGetSettingsFromMat), EditorStyles.boldLabel, GUILayout.Width (inspectorWidth - 137 - scrollBarWidth));

                    Rect rectB = EditorGUILayout.GetControlRect(GUILayout.Height(0), GUILayout.MaxWidth(0));
                    rectB = new Rect (rectB.x, rectB.y, 128, 16);
					getFromMaterialMat.objectReferenceValue = EditorGUI.ObjectField (rectB, getFromMaterialMat.objectReferenceValue, typeof(Material), false) as Material;
					EditorGUILayout.EndHorizontal ();

					// Load / Save
					EditorGUILayout.BeginHorizontal ();
                    if (GUILayout.Button(new GUIContent("Load Settings", tTipToolsLoad), GUILayout.Width(inspectorWidth - 137 - scrollBarWidth)))
                    {
                        hm.LoadPreset(EditorUtility.OpenFilePanel("Load Preset", installPath + "/Presets", "prefab"));
                        //OnEnable();
                        return;
                    }
					if (GUILayout.Button (new GUIContent("Save Settings", tTipToolsSave), GUILayout.Width (128)))
						hm.SavePreset (EditorUtility.SaveFilePanel ("Save Preset", installPath + "/Presets", "MyPreset1", "prefab"));  
					EditorGUILayout.EndHorizontal ();

					if (childUsesDisplacement.boolValue) {
						EditorGUILayout.BeginHorizontal ();
						EditorGUILayout.LabelField (new GUIContent("Show Bounds", tTipToolsShowBounds), EditorStyles.label, GUILayout.Width (inspectorWidth - 137 - scrollBarWidth));
						drawGizmos.boolValue = EditorGUILayout.Toggle (drawGizmos.boolValue, GUILayout.Width (12));
						gizmoColor.colorValue = EditorGUILayout.ColorField (gizmoColor.colorValue, GUILayout.Width (129 - 17));
						EditorGUILayout.EndHorizontal ();

						//GUI.backgroundColor = new Color (0.4f, 0.5f, 0.4f, 0.4f);
						if (GUILayout.Button (new GUIContent("Set Bounds of displaced Meshes", tTipToolsCalcBounds), GUILayout.Width (inspectorWidth - 4 - scrollBarWidth))) { hm.GetBounds (); }
						if (GUILayout.Button (new GUIContent("Bake displacement into Meshes", tTipToolsBakeDisp), GUILayout.Width (inspectorWidth - 4 - scrollBarWidth))) {
							if (EditorUtility.DisplayDialog ("Note", "This will bake the displacement into the displaced meshes. Are you sure you want to do this?\n(The source meshes in the project wont be affected)", "OK", "Cancel")) {
								hm.Displace ();
							}
						}
					}
				}
                EndSection(color10);
			}
			if (isPreset.boolValue) {
				Rect rectWarning = GUILayoutUtility.GetRect (0, 0);
				EditorGUI.HelpBox (new Rect (rectWarning.x, rectWarning.y + 1, inspectorWidth - 4 - scrollBarWidth, 45), "This is a preset, you can load it by using the \"Load preset\" button on your Horizon[ON] object!", MessageType.Info);
				EditorGUILayout.GetControlRect (GUILayout.Height (45));
			}


    //==================================================================================================================================================================================
			if (drag) { GUI.changed = true; }
			if (GUI.changed) {
                serializedObject.ApplyModifiedProperties();
                if (hm.getFromMaterialMat != null) {
					hm.UpdateHorizonMaster();
					hm.getFromMaterialMat = null;
					hm.UpdateMaterials();
					hm.CheckMaterials();
				}
				hm.UpdateMaterials();
                SceneView.RepaintAll();
			}
            serializedObject.ApplyModifiedProperties();
        } //==================================================================================================================================================================================


        void ButtonDragDouble(string label1, string label2, string label3, string change1, string change2, float sens = 1, int dragV1 = 1, int dragV2 = 1, int i = -1, string ctrlID = ""){
			EditorGUILayout.LabelField("", GUILayout.Width (inspectorWidth - 137 - scrollBarWidth));
			Rect rect = GUILayoutUtility.GetLastRect ();
			Vector2 v2 = GUI.skin.GetStyle ("boldLabel").CalcSize (new GUIContent (label1));
			Rect labelRect = new Rect (rect.x, rect.y, v2.x, v2.y);
			EditorGUI.LabelField (labelRect, label1, (valueToChange == change1 && activeCtrlID == ctrlID+"1") || (valueToChange == change1 && ctrlID == "") ? EditorStyles.boldLabel : EditorStyles.label);

            EditorGUIUtility.AddCursorRect(labelRect, MouseCursor.SlideArrow);
            if (e.type == EventType.MouseDown) {
				if (labelRect.Contains (e.mousePosition)) {
                    Undo.RegisterCompleteObjectUndo(hm, "HorizonValue");
					drag = true; 
					dragVector = dragV1; 
					sensitivity = sens; 
					valueToChange = change1; 
					Repaint(); 
					if (i != -1) hmlp = hm.hSetLayerProps[i];
					activeCtrlID = ctrlID+"1";
				}
			}
			EditorGUI.LabelField(new Rect (labelRect.xMax-3, labelRect.y, 9,16),"/", EditorStyles.label);
			v2 = GUI.skin.GetStyle ("boldLabel").CalcSize (new GUIContent (label2));
			labelRect = new Rect (labelRect.xMax + 5, labelRect.y, v2.x, v2.y);
			EditorGUI.LabelField (labelRect, label2, (valueToChange == change2 && activeCtrlID == ctrlID+"2") || (valueToChange == change2 && ctrlID == "") ? EditorStyles.boldLabel : EditorStyles.label);

            EditorGUIUtility.AddCursorRect(labelRect, MouseCursor.SlideArrow);
            if (e.type == EventType.MouseDown) {
				if (labelRect.Contains (e.mousePosition)) {
                    Undo.RegisterCompleteObjectUndo(hm, "HorizonValue");
                    drag = true; 
					dragVector = dragV2; 
					sensitivity = sens; 
					valueToChange = change2; 
					Repaint();
					if (i != -1) hmlp = hm.hSetLayerProps[i];
					activeCtrlID = ctrlID+"2";
				}
			}
			v2 = GUI.skin.GetStyle ("Label").CalcSize (new GUIContent (label3));
			EditorGUI.LabelField(new Rect(labelRect.xMax-3,labelRect.y,v2.x,v2.y),label3, EditorStyles.label);
        } //==================================================================================================================================================================================


        void ButtonDragSingle(string label1, string label2, string change1, float sens = 1, int dragV = 1, int i = -1, string ctrlID = ""){
			EditorGUILayout.LabelField("", GUILayout.Width (inspectorWidth - 137 - scrollBarWidth));
			Rect rect = GUILayoutUtility.GetLastRect ();
			Vector2 v2 = GUI.skin.GetStyle ("boldLabel").CalcSize (new GUIContent (label1));
			Rect labelRect = new Rect (rect.x, rect.y, v2.x, v2.y);
			EditorGUI.LabelField (labelRect, label1, (valueToChange == change1 && activeCtrlID == ctrlID) || (valueToChange == change1 && ctrlID == "") ? EditorStyles.boldLabel : EditorStyles.label);

            EditorGUIUtility.AddCursorRect(labelRect, MouseCursor.SlideArrow);
            if (e.type == EventType.MouseDown) {
				if (labelRect.Contains (e.mousePosition)) {
                    Undo.RegisterCompleteObjectUndo(hm, "HorizonValue");
                    drag = true; 
					dragVector = dragV; 
					sensitivity = sens; 
					valueToChange = change1; 
					Repaint();
					if (i != -1) hmlp = hm.hSetLayerProps[i];
					activeCtrlID = ctrlID;			
				}

			}
			v2 = GUI.skin.GetStyle ("Label").CalcSize (new GUIContent (label2));
			EditorGUI.LabelField(new Rect(labelRect.xMax-3,labelRect.y,v2.x,v2.y),label2, EditorStyles.label);
        } //==================================================================================================================================================================================


        bool StartSection(string title, bool show, Texture2D color)
        {
            string showLabel = "| Show";
            if (show) showLabel = "| Hide"; else showLabel = "| Show";

            EditorGUILayout.BeginHorizontal();
            EditorGUILayout.LabelField(title, EditorStyles.boldLabel, GUILayout.Width(inspectorWidth - 70 - scrollBarWidth));
            EditorGUILayout.LabelField(showLabel, GUILayout.Width(53));            
            Rect r = EditorGUILayout.GetControlRect(GUILayout.Height(15), GUILayout.MaxWidth(6));
            r.x = inspectorWidth - scrollBarWidth + 5;
            show = EditorGUI.Foldout(r, show, "");
            EditorGUILayout.EndHorizontal();
            r = EditorGUILayout.GetControlRect(GUILayout.Height(0), GUILayout.MaxWidth(0));
            GUI.DrawTexture(new Rect(14, r.y, inspectorWidth - 5 - scrollBarWidth, 2), color);
            if (show) EditorGUILayout.GetControlRect(GUILayout.Height(0), GUILayout.MaxWidth(0));
            return show;
        } //==================================================================================================================================================================================


        void EndSection(Texture2D color)
        {
            Rect r = EditorGUILayout.GetControlRect(GUILayout.Height(0), GUILayout.MaxWidth(0));
            r = new Rect(inspectorWidth +10- scrollBarWidth, r.y+2, 1-(inspectorWidth - 5 - scrollBarWidth), 2);
            GUI.DrawTexture(r, color);
            EditorGUILayout.GetControlRect(GUILayout.Height(4), GUILayout.MaxWidth(0));
        } //==================================================================================================================================================================================
    }
}