using System.Collections;
using System.Collections.Generic;
using System.Linq;
using NatureManufacture.RAM;
using NatureManufacture.RAM.Editor;
using UnityEditor;
using UnityEditor.Overlays;
using UnityEditor.Toolbars;
using UnityEditor.UIElements;
using UnityEngine;
using UnityEngine.UIElements;

[Overlay(typeof(SceneView), "NM Spline")]
[NmIcon("logoRAMOnly")]
public class NmSplineOverlay : Overlay, ITransientOverlay
{
    private bool turnedOff = true;
/*
    [SerializeField] private VisualTreeAsset _uxml;
    private VisualElement _root;

    private Label _mLabel;
    private NmSpline _nmSpline = null;
    private NmSpline _nmSplineLast = null;

    private int _lastSelection = -1;

    private NmSplineOverlay() : base()
    {
        //SceneView.duringSceneGui += UpdateData;
    }

    public override void OnWillBeDestroyed()
    {
        
       // SceneView.duringSceneGui -= UpdateData;
    }

    private void UpdateData(SceneView sceneView)
    {
        if (_root == null)
            return;

        Debug.Log("UpdateData");
        if (visible == false || _nmSpline == null)
        {
            _root.Unbind();
            return;
        }

        
        Debug.Log("UpdateData Selection");
        if (Selection.activeGameObject != null && Selection.activeGameObject.GetComponent<NmSpline>() != _nmSpline)
        {
            _nmSpline = Selection.activeGameObject.GetComponent<NmSpline>();
            _lastSelection = -1;
        }

        if (_lastSelection == _nmSpline.SelectedPosition && _nmSplineLast == _nmSpline)
            return;

        _lastSelection = _nmSpline.SelectedPosition;
        _mLabel.text = $"Point {_lastSelection}";


        displayName = $"Point {_lastSelection}";


        if (_nmSpline.MainControlPoints.Count <= 0 || _lastSelection < 0)
        {
            _root.Unbind();
            return;
        }

        _root.Q<Vector4Field>("PositionV4").bindingPath = $"mainControlPoints.Array.data[{_lastSelection}].position";
        _root.Q<PropertyField>("propRotation").bindingPath = $"mainControlPoints.Array.data[{_lastSelection}].rotation";
        _root.Q<PropertyField>("propRotation").label = "";
        _root.Q<CurveField>("curMeshCurve").bindingPath = $"mainControlPoints.Array.data[{_lastSelection}].meshCurve";
        _root.Q<Slider>("slDensityU").bindingPath = $"mainControlPoints.Array.data[{_lastSelection}].additionalDensityU";
        _root.Q<Slider>("slDensityV").bindingPath = $"mainControlPoints.Array.data[{_lastSelection}].additionalDensityV";


        _root.Bind(new SerializedObject(_nmSpline));

        _root.Q<Vector4Field>("PositionV4").Q<FloatField>("unity-x-input").isDelayed = true;
        _root.Q<Vector4Field>("PositionV4").Q<FloatField>("unity-y-input").isDelayed = true;
        _root.Q<Vector4Field>("PositionV4").Q<FloatField>("unity-z-input").isDelayed = true;
        _root.Q<Vector4Field>("PositionV4").Q<FloatField>("unity-w-input").isDelayed = true;


        _root.Q<Vector4Field>("PositionV4").Q<FloatField>("unity-w-input").style.display = _nmSpline.UseWidth ? DisplayStyle.Flex : DisplayStyle.None;
        _root.Q<VisualElement>("vsRotation").style.display = _nmSpline.UseRotation ? DisplayStyle.Flex : DisplayStyle.None;


        _root.Q<Toggle>("tgSnapToTerrain").style.display = _nmSpline.UsePointSnap ? DisplayStyle.Flex : DisplayStyle.None;

        _root.Q<CurveField>("curMeshCurve").style.display = _nmSpline.UseMeshCurve ? DisplayStyle.Flex : DisplayStyle.None;
        _root.Q<Slider>("slDensityU").style.display = _nmSpline.UseSplinePointDensity ? DisplayStyle.Flex : DisplayStyle.None;
        _root.Q<Slider>("slDensityV").style.display = _nmSpline.UseSplineWidthDensity ? DisplayStyle.Flex : DisplayStyle.None;


        _root.Q<VisualElement>("vsSplitSpline").style.display = _nmSpline.TryGetComponent<RamSpline>(out RamSpline _) ? DisplayStyle.Flex : DisplayStyle.None;

        _nmSplineLast = _nmSpline;
        Debug.Log("UpdateDataEnd");
    }


    public override VisualElement CreatePanelContent()
    {
        if (turnedOff)
            return null;

        Debug.Log("CreatePanelContent");
        if (Selection.activeGameObject != null)
            _nmSpline = Selection.activeGameObject.GetComponent<NmSpline>();


        string[] guids = AssetDatabase.FindAssets("NMSplineOverlayUI");
        _root = new VisualElement();
        VisualTreeAsset visualTree = AssetDatabase.LoadAssetAtPath<VisualTreeAsset>(guids.Length <= 0 ? "" : AssetDatabase.GUIDToAssetPath(guids[0]));

        visualTree.CloneTree(_root);


        _mLabel = new Label($"Selection Count {Selection.count}");

        Selection.selectionChanged += () =>
        {
            if (_mLabel != null)
                _mLabel.text = $"Selection Count {Selection.count}";
        };

        _root.RegisterCallback<ChangeEvent<Vector4>>(evt =>
        {
            if (Vector4.Distance(evt.previousValue, evt.newValue) > 0.0001f)
                SplineChanged();
        });
        _root.RegisterCallback<ChangeEvent<Vector3>>(evt => { SplineChanged(); });
        _root.RegisterCallback<ChangeEvent<bool>>(evt => { SplineChanged(); });
        _root.RegisterCallback<ChangeEvent<AnimationCurve>>(evt => { SplineChanged(); });
        _root.Q<PropertyField>("propRotation").RegisterValueChangeCallback(evt => { SplineChanged(); });

        _root.Q<Toggle>("tgSnapToTerrain").RegisterCallback<ChangeEvent<bool>>(SnapPoint);

        _root.Q<Slider>("slDensityU").RegisterCallback<ChangeEvent<float>>(SetDensityU);
        _root.Q<Slider>("slDensityV").RegisterCallback<ChangeEvent<float>>(SetDensityV);

        _root.Q<Button>("btnAdd").clicked += () =>
        {
            _nmSpline.AddPointAfter(_nmSpline.SelectedPosition);
            SplineChanged();

            _nmSpline.SelectedPosition++;
        };

        _root.Q<Button>("btnRemove").clicked += () =>
        {
            _nmSpline.RemovePoint(_nmSpline.SelectedPosition);
            SplineChanged();


            if (_nmSpline.SelectedPosition > 0)
                _nmSpline.SelectedPosition--;
        };

        _root.Q<Button>("btnClearRotation").clicked += () =>
        {
            _nmSpline.MainControlPoints[_nmSpline.SelectedPosition].rotation = Quaternion.identity;
            SplineChanged();
        };


        if (_nmSpline.TryGetComponent<RamSpline>(out RamSpline spline))
        {
            _root.Q<Button>("btnSplitSpline").clicked += () =>
            {
                (new RamSplitter()).SplitRiver(spline, _nmSpline.SelectedPosition);
                _nmSpline.SelectedPosition = -1;
            };

            _root.Q<Button>("btnSplitSplineTwo").clicked += () =>
            {
                (new RamSplitter()).SplitRiverIntoTwo(spline, _nmSpline.SelectedPosition);
                _nmSpline.SelectedPosition = -1;
            };
        }


        UpdateData(null);


        return _root;
    }

    private void SetDensityV(ChangeEvent<float> evt)
    {
        _nmSpline.MainControlPoints[_nmSpline.SelectedPosition].additionalDensityV = Mathf.NextPowerOfTwo((int) evt.newValue);
        SplineChanged();
    }

    private void SetDensityU(ChangeEvent<float> evt)
    {
        _nmSpline.MainControlPoints[_nmSpline.SelectedPosition].additionalDensityU = Mathf.NextPowerOfTwo((int) evt.newValue);

        SplineChanged();
    }

    private void SnapPoint(ChangeEvent<bool> evtNewValue)
    {
        _nmSpline.MainControlPoints[_nmSpline.SelectedPosition].snap = evtNewValue.newValue ? 1 : 0;
        SplineChanged();
    }


    private void SplineChanged()
    {
        _nmSpline.NmSplineChanged?.Invoke();
    }
*/

    public override VisualElement CreatePanelContent()
    {
        return new  Label($"In works");
    }

    public bool visible
    {
        get
        {
            if (turnedOff)
                return false;

            if (Selection.activeGameObject != null)
                return Selection.activeGameObject.GetComponent<NmSpline>() != null;

            return false;
        }
    }
}