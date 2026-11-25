// /**
//  * Created by Pawel Homenko on  08/2022
//  */

using System.Collections.Generic;
using System.Linq;
using UnityEditor;
using UnityEditor.SceneManagement;
using UnityEngine;
using UnityEngine.Events;
using UnityEngine.SceneManagement;
using Object = UnityEngine.Object;

namespace NatureManufacture.RAM.Editor
{
    public class VertexPainterEditor<T> where T : Component
    {
        private List<Color> colors = new();
        List<Vector4> colorsFlowMap = new();
        private Vector3 _hitPositionOldFlow;
        private readonly int _direction = Shader.PropertyToID("_Direction");
        private readonly int _noDirection = Shader.PropertyToID("_NoDirection");

        public VertexPainterData VertexPainterData { get; }


        public UnityEvent OnResetDrawing { get; set; }
        public UnityEvent OnFinishedDrawing { get; set; }


        public delegate Vector2 TransformFlowMapDelegate(Vector2 flowDirection, int id, MeshFilter meshFilter);

        public TransformFlowMapDelegate TransformFlowMap { get; set; }

        public delegate Color TransformVertexColorDelegate(Color flowDirection, int id);

        public TransformVertexColorDelegate TransformVertexColor { get; set; }

        public string ColorDescriptions { get; set; } = "\nR - Emission \nG- Bottom Cover \nB - Top Cover\n" +
                                                        "Paint  - Left Mouse Button Click \n" +
                                                        "Clean  - SHIFT + Left Mouse Button Click \n";

        private bool _multiDraw;

        private T[] _objectsToDrawOn;
        private int group;


        public bool VertexColorChanged { get; set; } = false;
        public bool FlowMapChanged { get; set; } = false;
        public bool VertexHeightChanged { get; set; } = false;

        public bool FinishedPainting { get; set; } = false;


        public VertexPainterEditor(VertexPainterData vertexPainterData = default, bool multiDraw = false)
        {
            VertexPainterData = vertexPainterData;

            OnResetDrawing = new UnityEvent();
            OnFinishedDrawing = new UnityEvent();

            _multiDraw = multiDraw;

            if (multiDraw)
                _objectsToDrawOn = Object.FindObjectsByType<T>(FindObjectsSortMode.None);
        }

        public void UIPainter()
        {
            VertexPainterData.MeshFilters.RemoveAll(item => item == null);

            UIAlwaysDrawing();

            VertexPainterData.ToolbarInt = GUILayout.Toolbar(VertexPainterData.ToolbarInt, VertexPainterData.ToolbarStrings);

            UINotDrawing();

            UIDrawing();

            VertexPainterData.DrawOnMultiple = EditorGUILayout.Toggle("DrawOnMultiple", VertexPainterData.DrawOnMultiple);

            if (VertexPainterData.ToolbarInt == 0)
            {
                UIVertexColor();
            }
            else if (VertexPainterData.ToolbarInt == 1)
            {
                UIFlowMap();
            }
            else if (VertexPainterData.ToolbarInt == 2)
            {
                UIHeightMap();
            }

            UIShowReset();
        }


        private void UIAlwaysDrawing()
        {
            //VertexPainterData.AlwaysDrawing = EditorGUILayout.Toggle("test", VertexPainterData.AlwaysDrawing);

            if (VertexPainterData.AlwaysDrawing) VertexPainterData.Drawing = VertexPainterData.AlwaysDrawing;


            if (!VertexPainterData.AlwaysDrawing || Selection.activeGameObject == VertexPainterData.CurrentDrawObject) return;


            if (Selection.activeGameObject == null) return;

            if (!Application.isPlaying)
                EditorSceneManager.MarkSceneDirty(SceneManager.GetActiveScene());


            GetMeshFilters();
        }

        public void GetMeshFilters(GameObject toSelect = null)
        {
            VertexPainterData.MeshFilters.Clear();
            VertexPainterData.MeshRenderers.Clear();
            VertexPainterData.CurrentDrawObject = toSelect == null ? Selection.activeGameObject : toSelect;


            MeshFilter[] filters = VertexPainterData.CurrentDrawObject.GetComponentsInChildren<MeshFilter>();


            foreach (var item in filters)
            {
                if (item.sharedMesh == null)
                    continue;

                VertexPainterData.MeshFilters.Add(item);
                VertexPainterData.MeshRenderers.Add(item.GetComponent<MeshRenderer>());
                Undo.RecordObject(item.sharedMesh, "Start draw vertex");
            }

            VertexPainterData.Drawing = true;
            Tools.current = Tool.None;
        }

        private void UIFlowMap()
        {
            VertexPainterData.FlowToolSelected = GUILayout.SelectionGrid(VertexPainterData.FlowToolSelected, VertexPainterData.FlowToolbarStrings, 4, GUILayout.Height(25));

            EditorGUILayout.Space();
            if (VertexPainterData.FlowToolSelected == 0)
            {
                VertexPainterData.FlowSpeed = EditorGUILayout.Slider("Flow U Speed", VertexPainterData.FlowSpeed, -1, 1);
                VertexPainterData.FlowDirection = EditorGUILayout.Slider("Flow V Speed", VertexPainterData.FlowDirection, -1, 1);
            }

            VertexPainterData.Opacity = EditorGUILayout.FloatField("Opacity", VertexPainterData.Opacity);
            VertexPainterData.SpeedMultiplier = EditorGUILayout.FloatField("Speed Multiplier", VertexPainterData.SpeedMultiplier);
            VertexPainterData.DrawSize = EditorGUILayout.FloatField("Size", VertexPainterData.DrawSize);

            if (VertexPainterData.DrawSize < 0)
            {
                VertexPainterData.DrawSize = 0;
            }

            VertexPainterData.DrawBlendSize = EditorGUILayout.Slider("Blend Size", VertexPainterData.DrawBlendSize, 0, 1);
        }

        private void UIVertexColor()
        {
            VertexPainterData.DrawColor = EditorGUILayout.ColorField("Draw color", VertexPainterData.DrawColor);
            VertexPainterData.Opacity = EditorGUILayout.FloatField("Opacity", VertexPainterData.Opacity);
            VertexPainterData.DrawSize = EditorGUILayout.FloatField("Size", VertexPainterData.DrawSize);
            if (VertexPainterData.DrawSize < 0)
            {
                VertexPainterData.DrawSize = 0;
            }

            VertexPainterData.DrawBlendSize = EditorGUILayout.Slider("Blend Size", VertexPainterData.DrawBlendSize, 0, 1);


            VertexPainterData.DrawColorR = EditorGUILayout.Toggle("Draw R", VertexPainterData.DrawColorR);
            VertexPainterData.DrawColorG = EditorGUILayout.Toggle("Draw G", VertexPainterData.DrawColorG);
            VertexPainterData.DrawColorB = EditorGUILayout.Toggle("Draw B", VertexPainterData.DrawColorB);
            VertexPainterData.DrawColorA = EditorGUILayout.Toggle("Draw A", VertexPainterData.DrawColorA);


            EditorGUILayout.HelpBox(ColorDescriptions, MessageType.Info);
            EditorGUILayout.Space();
        }

        private void UIHeightMap()
        {
            VertexPainterData.Height = EditorGUILayout.FloatField("Height", VertexPainterData.Height);
            VertexPainterData.Opacity = EditorGUILayout.FloatField("Opacity", VertexPainterData.Opacity);
            VertexPainterData.DrawSize = EditorGUILayout.FloatField("Size", VertexPainterData.DrawSize);
            if (VertexPainterData.DrawSize < 0)
            {
                VertexPainterData.DrawSize = 0;
            }

            VertexPainterData.DrawBlendSize = EditorGUILayout.Slider("Blend Size", VertexPainterData.DrawBlendSize, 0, 1);
        }


        private void UIDrawing()
        {
            if (!VertexPainterData.Drawing) return;


            if (!VertexPainterData.AlwaysDrawing && Selection.activeGameObject != VertexPainterData.CurrentDrawObject)
            {
                Debug.Log(Selection.activeGameObject + " " + VertexPainterData.CurrentDrawObject);
                _hitPositionOldFlow = Vector3.zero;
                StopDrawing();
            }

            if (!VertexPainterData.AlwaysDrawing && GUILayout.Button("End Drawing"))
            {
                _hitPositionOldFlow = Vector3.zero;
                StopDrawing();
            }

            EditorGUILayout.Space();
        }

        private void UIShowReset()
        {
            if (VertexPainterData.ToolbarInt == 0)
            {
                if (!VertexPainterData.ShowVertexColors)
                {
                    if (GUILayout.Button("Show vertex colors"))
                    {
                        if (!VertexPainterData.ShowFlowMap && !VertexPainterData.ShowVertexColors)
                        {
                            VertexPainterData.OldMaterials.Clear();
                        }

                        Material vertexColor = new Material(Shader.Find("NatureManufacture Shaders/Debug/Vertex color"));
                        //Debug.Log(VertexPainterData.MeshRenderers.Count);
                        // Debug.Log(VertexPainterData.MeshFilters.Count);

                        for (int i = 0; i < VertexPainterData.MeshFilters.Count; i++)
                        {
                            // Debug.Log("show Vertex");
                            if (!VertexPainterData.ShowFlowMap && !VertexPainterData.ShowVertexColors)
                                VertexPainterData.OldMaterials.Add(VertexPainterData.MeshRenderers[i].sharedMaterial);

                            //Debug.Log("show Vertex change material");
                            VertexPainterData.MeshRenderers[i].sharedMaterial = vertexColor;
                        }

                        ResetMaterialShow();
                        VertexPainterData.ShowVertexColors = true;
                    }
                }
                else
                {
                    if (GUILayout.Button("Hide vertex colors"))
                    {
                        ResetOldMaterials();
                    }
                }

                if (GUILayout.Button("Reset colors"))
                {
                    RestartColor();
                }

                // EditorGUILayout.HelpBox("River Auto Material -> R Wetness", MessageType.Info);
            }
            else if (VertexPainterData.ToolbarInt == 1)
            {
                if (!VertexPainterData.ShowFlowMap)
                {
                    if (GUILayout.Button("Show flow directions"))
                    {
                        if (!VertexPainterData.ShowFlowMap && !VertexPainterData.ShowVertexColors)
                        {
                            VertexPainterData.OldMaterials.Clear();
                        }

                        Material flowMap = new Material(Shader.Find("NatureManufacture Shaders/Debug/Flowmap Direction"));
                        flowMap.SetTexture(_direction, Resources.Load<Texture2D>("Debug_Arrow"));

                        flowMap.SetTexture(_noDirection, Resources.Load<Texture2D>("Debug_Point"));

                        for (int i = 0; i < VertexPainterData.MeshFilters.Count; i++)
                        {
                            if (!VertexPainterData.ShowFlowMap && !VertexPainterData.ShowVertexColors)
                                VertexPainterData.OldMaterials.Add(VertexPainterData.MeshRenderers[i].sharedMaterial);

                            VertexPainterData.MeshRenderers[i].sharedMaterial = flowMap;
                        }


                        ResetMaterialShow();
                        VertexPainterData.ShowFlowMap = true;
                    }
                }
                else
                {
                    if (GUILayout.Button("Hide flow directions"))
                    {
                        ResetOldMaterials();
                    }
                }

                if (GUILayout.Button("Reset flow"))
                {
                    RestartFlow();
                }
            }

            else if (VertexPainterData.ToolbarInt == 2)
            {
                if (GUILayout.Button("Reset height"))
                {
                    VertexPaintHeight.RestartHeight(VertexPainterData, OnResetDrawing);
                }
            }
        }


        public void ResetOldMaterials()
        {
            if (VertexPainterData.OldMaterials.Count > 0)
                for (int i = 0; i < VertexPainterData.MeshFilters.Count; i++)
                {
                    if (VertexPainterData.MeshRenderers.Count > i)
                        VertexPainterData.MeshRenderers[i].sharedMaterial = VertexPainterData.OldMaterials[i];
                }

            VertexPainterData.OldMaterials.Clear();


            ResetMaterialShow();
        }

        private void UINotDrawing()
        {
            if (!VertexPainterData.Drawing)
            {
                if (GUILayout.Button("Start Drawing"))
                {
                    _hitPositionOldFlow = Vector3.zero;
                    if (Selection.activeGameObject != null)
                    {
                        EditorSceneManager.MarkSceneDirty(SceneManager.GetActiveScene());

                        GetMeshFilters();
                    }
                }
            }
        }

        private void ResetMaterialShow()
        {
            VertexPainterData.ShowFlowMap = false;
            VertexPainterData.ShowVertexColors = false;
        }

        public void StopDrawing()
        {
            // Debug.Log("----------------stopDrawing-------------------");
            ResetOldMaterials();
            VertexPainterData.CurrentDrawObject = null;
            VertexPainterData.Drawing = false;
            VertexPainterData.MeshFilters.Clear();
        }

        public bool OnSceneGUI(SceneView sceneView)
        {
            if (Selection.activeGameObject != VertexPainterData.CurrentDrawObject && VertexPainterData.Drawing)
            {
                StopDrawing();
            }


            if (VertexPainterData.CurrentDrawObject == null) return false;
            if (!VertexPainterData.Drawing) return false;

            DrawOnMesh(VertexPainterData.ToolbarInt);


            return true;
        }

        private void RestartColor()
        {
            foreach (var item in VertexPainterData.MeshFilters)
            {
                Mesh mesh = item.sharedMesh;
                if (mesh != null)
                {
                    if (!string.IsNullOrEmpty(AssetDatabase.GetAssetPath(mesh)))
                    {
                        mesh = Object.Instantiate(item.sharedMesh);
                        item.sharedMesh = mesh;
                    }

                    mesh.colors = null;
                }
            }

            VertexPainterData.OverridenColors = false;
            OnResetDrawing?.Invoke();
        }

        public void RestartFlow()
        {
            foreach (var item in VertexPainterData.MeshFilters)
            {
                if (item == null)
                    continue;
                Mesh mesh = item.sharedMesh;
                if (mesh != null)
                {
                    if (!string.IsNullOrEmpty(AssetDatabase.GetAssetPath(mesh)))
                    {
                        mesh = Object.Instantiate(item.sharedMesh);
                        item.sharedMesh = mesh;
                    }

                    mesh.SetUVs(3, (Vector2[])null);
                }
            }


            VertexPainterData.OverridenFlow = false;
            OnResetDrawing?.Invoke();
        }

        private void DrawOnMesh(int painterType)
        {
            HandleUtility.AddDefaultControl(GUIUtility.GetControlID(FocusType.Passive));


            Vector2 mousePos = Event.current.mousePosition;
            Ray ray = HandleUtility.GUIPointToWorldRay(mousePos);

            List<MeshCollider> meshColliders = new();
            foreach (var item in VertexPainterData.MeshFilters)
            {
                if (item == null)
                    continue;
                meshColliders.Add(item.gameObject.AddComponent<MeshCollider>());
            }

            if (_multiDraw && VertexPainterData.DrawOnMultiple)
            {
                foreach (var item in _objectsToDrawOn)
                {
                    if (item == null)
                        continue;
                    meshColliders.Add(item.gameObject.AddComponent<MeshCollider>());
                }
            }

            RaycastHit[] hits = Physics.RaycastAll(ray, Mathf.Infinity);

            Vector3 hitPosition;
            Vector3 hitNormal;
            if (hits.Length > 0)
            {
                List<MeshCollider> hittedMeshColliders = new();
                List<RaycastHit> meshColliderHit = new();
                //List<MeshFilter> meshCollidedFilters = new();

                foreach (RaycastHit hit in hits)
                {
                    if (meshColliders.Contains(hit.collider))
                    {
                        Collider[] colliders = Physics.OverlapSphere(hit.point, VertexPainterData.DrawSize);
                        foreach (var castedCollider in colliders)
                        {
                            if (castedCollider is not MeshCollider collider) continue;
                            if (hittedMeshColliders.Contains(collider)) continue;
                            hittedMeshColliders.Add(collider);
                            meshColliderHit.Add(hit);
                        }

                        break;
                    }
                }


                for (int i = 0; i < hittedMeshColliders.Count; i++)
                {
                    MeshCollider collider = hittedMeshColliders[i];
                    if (!meshColliders.Contains(collider)) continue;
                    RaycastHit hit = meshColliderHit[i];

                    MeshFilter meshFilter = collider.GetComponent<MeshFilter>();

                    hitPosition = hit.point;
                    hitNormal = hit.normal;

                    Handles.color = new Color(VertexPainterData.DrawColor.r, VertexPainterData.DrawColor.g, VertexPainterData.DrawColor.b, 0.5f);
                    /*   Handles.CircleHandleCap(
                           GUIUtility.GetControlID(FocusType.Passive),
                           hitPosition,
                           Quaternion.LookRotation(hitNormal), VertexPainterData.DrawSize * 0.95f,
                           EventType.Repaint
                       );*/

                    Handles.DrawWireDisc(hitPosition, hitNormal, VertexPainterData.DrawSize, 5);
                    Handles.DrawWireDisc(hitPosition, hitNormal, VertexPainterData.DrawSize - VertexPainterData.DrawSize * VertexPainterData.DrawBlendSize, 5);

                    Handles.DrawLine(hitPosition, hitPosition + hitNormal * 2);

                    Color negativeColor = new Color(1f - Handles.color.r, 1f - Handles.color.g, 1f - Handles.color.b, 0.5f);
                    Handles.color = negativeColor;

                    Handles.DrawWireDisc(hitPosition, hitNormal, VertexPainterData.DrawSize, 1);
                    Handles.DrawWireDisc(hitPosition, hitNormal, VertexPainterData.DrawSize - VertexPainterData.DrawSize * VertexPainterData.DrawBlendSize, 1);


                    Handles.color = Color.blue;


                    if (Event.current.type is not (EventType.MouseDown or EventType.MouseDrag) || Event.current.button != 0)
                    {
                        _hitPositionOldFlow = hitPosition;
                        continue;
                    }


                    if (meshFilter.sharedMesh == null) continue;


                    FinishedPainting = false;
                    //meshCollidedFilters.Add(meshFilter);
                    //Debug.Log(meshFilter.name);

                    Mesh mesh = meshFilter.sharedMesh;
                    if (!string.IsNullOrEmpty(AssetDatabase.GetAssetPath(mesh)))
                    {
                        mesh = Object.Instantiate(meshFilter.sharedMesh);
                        meshFilter.sharedMesh = mesh;
                    }

                    int vertLength = mesh.vertices.Length;
                    Vector3[] vertices = mesh.vertices;

                    var vertexPaintable = meshFilter.GetComponent<IVertexPaintable>();


                    switch (painterType)
                    {
                        case 0:
                        {
                            if (vertexPaintable != null)
                                vertexPaintable.GetVertexPainterData().OverridenColors = true;
                            DrawVertexColors(mesh, meshFilter, vertLength, vertices, hitPosition);
                            VertexColorChanged = true;
                            break;
                        }
                        case 1:
                        {
                            if (vertexPaintable != null)
                                vertexPaintable.GetVertexPainterData().OverridenFlow = true;
                            DrawFlowMap(mesh, meshFilter, vertLength, vertices, hitPosition);
                            FlowMapChanged = true;
                            break;
                        }
                        case 2:
                        {
                            if (vertexPaintable != null)
                                vertexPaintable.GetVertexPainterData().OverridenVertexHeight = true;
                            VertexPaintHeight.DrawVertexHeight(mesh, meshFilter, vertLength, vertices, hitPosition, VertexPainterData);
                            VertexHeightChanged = true;
                            break;
                        }
                    }
                }
            }

            foreach (var item in meshColliders)
            {
                Object.DestroyImmediate(item);
            }

            if (FlowMapChanged || VertexColorChanged || VertexHeightChanged)
            {
                if (Event.current.type == EventType.MouseUp)
                {
                    OnFinishedDrawing?.Invoke();
                    FinishedPainting = true;
                }
            }
        }

        private void DrawVertexColors(Mesh mesh, MeshFilter meshFilter, int vertLength, Vector3[] vertices, Vector3 hitPosition)
        {
            mesh.GetColors(colors);


            Transform transform = meshFilter.transform;
            if (colors.Count == 0)
            {
                for (int i = 0; i < vertLength; i++)
                {
                    colors.Add(Color.white);
                }
            }

            Vector3 posVert;
            VertexPainterData.OverridenColors = true;
            Color color;
            for (int i = 0; i < vertLength; i++)
            {
                posVert = transform.TransformPoint(vertices[i]);
                float dist = Vector3.Distance(hitPosition, posVert);


                if (!(dist < VertexPainterData.DrawSize)) continue;

                color = colors[i];

                float distBlend = Mathf.Clamp01((VertexPainterData.DrawSize - dist) / (VertexPainterData.DrawSize * VertexPainterData.DrawBlendSize));


                if (Event.current.shift)
                {
                    if (VertexPainterData.DrawColorR)
                        color.r = Mathf.Lerp(colors[i].r, 1 - VertexPainterData.DrawColor.r, VertexPainterData.Opacity * distBlend);
                    if (VertexPainterData.DrawColorG)
                        color.g = Mathf.Lerp(colors[i].g, 1 - VertexPainterData.DrawColor.g, VertexPainterData.Opacity * distBlend);
                    if (VertexPainterData.DrawColorB)
                        color.b = Mathf.Lerp(colors[i].b, 1 - VertexPainterData.DrawColor.b, VertexPainterData.Opacity * distBlend);
                    if (VertexPainterData.DrawColorA)
                        color.a = Mathf.Lerp(colors[i].a, 1 - VertexPainterData.DrawColor.a, VertexPainterData.Opacity * distBlend);
                }
                else
                {
                    if (VertexPainterData.DrawColorR)
                        color.r = Mathf.Lerp(colors[i].r, VertexPainterData.DrawColor.r, VertexPainterData.Opacity * distBlend);
                    if (VertexPainterData.DrawColorG)
                        color.g = Mathf.Lerp(colors[i].g, VertexPainterData.DrawColor.g, VertexPainterData.Opacity * distBlend);
                    if (VertexPainterData.DrawColorB)
                        color.b = Mathf.Lerp(colors[i].b, VertexPainterData.DrawColor.b, VertexPainterData.Opacity * distBlend);
                    if (VertexPainterData.DrawColorA)
                        color.a = Mathf.Lerp(colors[i].a, VertexPainterData.DrawColor.a, VertexPainterData.Opacity * distBlend);
                }

                colors[i] = color;
                if (TransformVertexColor != null)
                    colors[i] = TransformVertexColor(colors[i], i);
            }


            mesh.SetColors(colors);
        }


        private void DrawFlowMap(Mesh mesh, MeshFilter meshFilter, int vertLength, Vector3[] vertices, Vector3 hitPosition)
        {
            mesh.GetUVs(3, colorsFlowMap);
            Transform transform = meshFilter.transform;
            if (colorsFlowMap.Count == 0)
            {
                for (int i = 0; i < vertLength; i++)
                {
                    colorsFlowMap.Add(new Vector4(0, 0, 0, 0));
                }
            }


            float dist;
            VertexPainterData.OverridenFlow = true;

            for (int i = 0; i < vertLength; i++)
            {
                Vector3 vertice = transform.TransformPoint(vertices[i]);
                dist = Vector3.Distance(hitPosition, vertice);


                if (!(dist < VertexPainterData.DrawSize)) continue;

                // distValue = (VertexPainterData.DrawSize - dist) / VertexPainterData.DrawSize;

                float distBlend = Mathf.Clamp01((VertexPainterData.DrawSize - dist) / (VertexPainterData.DrawSize * VertexPainterData.DrawBlendSize));

                if (Event.current.shift)
                {
                    colorsFlowMap[i] = Vector4.Lerp(colorsFlowMap[i], new Vector4(0, 0, colorsFlowMap[i].z, colorsFlowMap[i].w), VertexPainterData.Opacity);
                }
                else
                {
                    Vector2 direction = new Vector2((hitPosition - vertice).x, (hitPosition - vertice).z).normalized * distBlend;
                    Vector3 directionHit = hitPosition - _hitPositionOldFlow;


                    if (VertexPainterData.FlowToolSelected == 0)
                    {
                        colorsFlowMap[i] = Vector4.Lerp(colorsFlowMap[i], new Vector4(VertexPainterData.FlowDirection, VertexPainterData.FlowSpeed, colorsFlowMap[i].z, colorsFlowMap[i].w),
                            VertexPainterData.Opacity * distBlend);
                    }
                    else if (VertexPainterData.FlowToolSelected == 1)
                    {
                        if (TransformFlowMap != null)
                            direction = TransformFlowMap(direction, i, meshFilter);

                        colorsFlowMap[i] = Vector4.Lerp(colorsFlowMap[i], new Vector4(-direction.x, -direction.y, colorsFlowMap[i].z, colorsFlowMap[i].w), VertexPainterData.Opacity * distBlend);
                    }
                    else if (VertexPainterData.FlowToolSelected == 2)
                    {
                        if (TransformFlowMap != null)
                            direction = TransformFlowMap(direction, i, meshFilter);

                        colorsFlowMap[i] = Vector4.Lerp(colorsFlowMap[i], new Vector4(direction.x, direction.y, colorsFlowMap[i].z, colorsFlowMap[i].w), VertexPainterData.Opacity * distBlend);
                    }
                    else if (VertexPainterData.FlowToolSelected >= 3)
                    {
                        if (_hitPositionOldFlow.magnitude == 0 || !(Vector3.Distance(_hitPositionOldFlow, hitPosition) > 0.001f)) continue;

                        Vector2 smudgeDirection = new Vector2(directionHit.x, directionHit.z); //  * distValue;
                        if (smudgeDirection.magnitude > 1)
                            smudgeDirection = smudgeDirection.normalized;

                        if (TransformFlowMap != null)
                            smudgeDirection = TransformFlowMap(smudgeDirection, i, meshFilter);

                        switch (VertexPainterData.FlowToolSelected)
                        {
                            case 3:

                                colorsFlowMap[i] = Vector4.Lerp(colorsFlowMap[i], new Vector4(
                                        -smudgeDirection.x * VertexPainterData.SpeedMultiplier, -smudgeDirection.y * VertexPainterData.SpeedMultiplier, colorsFlowMap[i].z, colorsFlowMap[i].w),
                                    VertexPainterData.Opacity * distBlend);
                                break;
                            case 4:
                                smudgeDirection = smudgeDirection * VertexPainterData.SpeedMultiplier * VertexPainterData.Opacity * distBlend;
                                colorsFlowMap[i] = colorsFlowMap[i] - new Vector4(smudgeDirection.x, smudgeDirection.y, 0, 0);
                                colorsFlowMap[i] = new Vector4(Mathf.Clamp01(colorsFlowMap[i].x), Mathf.Clamp01(colorsFlowMap[i].y), colorsFlowMap[i].z, colorsFlowMap[i].w);
                                break;
                        }
                    }
                }
            }


            _hitPositionOldFlow = hitPosition;
            mesh.SetUVs(3, colorsFlowMap);
        }

        public void ResetFinished()
        {
            FinishedPainting = false;
            VertexColorChanged = false;
            FlowMapChanged = false;
            VertexHeightChanged = false;
        }
    }
}