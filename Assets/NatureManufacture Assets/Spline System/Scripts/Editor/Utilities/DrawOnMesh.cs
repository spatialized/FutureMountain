// /**
//  * Created by Pawel Homenko on  08/2022
//  */

using System.Collections.Generic;
using UnityEditor;
using UnityEngine;
using UnityEngine.Events;

namespace NatureManufacture.RAM.Editor
{
    public class DrawOnMesh
    {
        private DrawOnMeshData _drawOnMeshData;
        private GameObject _gameObject;
        private MeshFilter _meshFilter;
        private GameObject _lastGameObjectUnderCursor;
        private Vector3 _hitPositionOldFlow;

        public UnityEvent DrawOnMeshChanged { get; set; }

        private readonly string[] _flowToolbarStrings =
        {
            "Direction",
            "Attraction",
            "Repulsion",
            "Smudge"
        };

        private static readonly int Direction = Shader.PropertyToID("_Direction");
        private static readonly int NoDirection = Shader.PropertyToID("_NoDirection");

        public DrawOnMesh(DrawOnMeshData drawOnMeshData, GameObject gameObject)
        {
            _drawOnMeshData = drawOnMeshData;
            _gameObject = gameObject;
            _meshFilter = gameObject.GetComponent<MeshFilter>();

            DrawOnMeshChanged = new UnityEvent();
        }

        public bool SceneGuiDrawOnMesh()
        {
            if (!_drawOnMeshData.DrawOnMesh && !_drawOnMeshData.DrawOnMeshFlowMap) return false;

            Tools.current = Tool.None;
            if (_meshFilter != null)
            {
                Handles.color = Color.magenta;
                var sharedMesh = _meshFilter.sharedMesh;
                Vector3[] vertices = sharedMesh.vertices;
                //Vector2[] uv4 = sharedMesh.uv4;
                //Vector3[] normals = sharedMesh.normals;
                Quaternion up = Quaternion.Euler(90, 0, 0);
                for (int i = 0; i < vertices.Length; i += 5)
                {
                    Vector3 item = vertices[i];
                    Vector3 handlePos = _gameObject.transform.TransformPoint(item);

                    if (_drawOnMeshData.DrawOnMesh)
                        Handles.RectangleHandleCap(0, handlePos, up, 0.05f, EventType.Repaint);
                }
            }

            if (_drawOnMeshData.DrawOnMesh)
                DrawOnVertexColors();
            else
                DrawOnFlowMap();

            return true;
        }

        private void ResetMaterial()
        {
            _drawOnMeshData.ShowFlowMap = false;
            _drawOnMeshData.ShowVertexColors = false;
        }

        public void UIVertexColors()
        {
            EditorGUI.BeginChangeCheck();
            _drawOnMeshData.DrawOnMesh = true;
            if (_drawOnMeshData.DrawOnMesh)
            {
                EditorGUILayout.HelpBox("R - Slow Water G - Small Cascade B - Big Cascade A - Opacity", MessageType.Info);
                EditorGUILayout.Space();
                _drawOnMeshData.DrawColor = EditorGUILayout.ColorField("Draw color", _drawOnMeshData.DrawColor);

                _drawOnMeshData.Opacity = EditorGUILayout.FloatField("Opacity", _drawOnMeshData.Opacity);
                _drawOnMeshData.DrawSize = EditorGUILayout.FloatField("Size", _drawOnMeshData.DrawSize);
                if (_drawOnMeshData.DrawSize < 0)
                {
                    _drawOnMeshData.DrawSize = 0;
                }

                _drawOnMeshData.DrawColorR = EditorGUILayout.Toggle("Draw R", _drawOnMeshData.DrawColorR);
                _drawOnMeshData.DrawColorG = EditorGUILayout.Toggle("Draw G", _drawOnMeshData.DrawColorG);
                _drawOnMeshData.DrawColorB = EditorGUILayout.Toggle("Draw B", _drawOnMeshData.DrawColorB);
                _drawOnMeshData.DrawColorA = EditorGUILayout.Toggle("Draw A", _drawOnMeshData.DrawColorA);


                EditorGUILayout.Space();
                _drawOnMeshData.DrawOnMultiple = EditorGUILayout.Toggle("Draw on multiple rivers", _drawOnMeshData.DrawOnMultiple);
            }

            EditorGUILayout.Space();
            if (!_drawOnMeshData.ShowVertexColors)
            {
                if (GUILayout.Button("Show vertex colors"))
                {
                    if (!_drawOnMeshData.ShowFlowMap && !_drawOnMeshData.ShowVertexColors) _drawOnMeshData.OldMaterial = _gameObject.GetComponent<MeshRenderer>().sharedMaterial;
                    ResetMaterial();
                    _gameObject.GetComponent<MeshRenderer>().sharedMaterial =
                        new Material(Shader.Find("NatureManufacture Shaders/Debug/Vertex color"));
                    _drawOnMeshData.ShowVertexColors = true;
                }
            }
            else
            {
                if (GUILayout.Button("Hide vertex colors"))
                {
                    ResetMaterial();
                    _gameObject.GetComponent<MeshRenderer>().sharedMaterial = _drawOnMeshData.OldMaterial;
                    _drawOnMeshData.ShowVertexColors = false;
                }
            }

            if (GUILayout.Button("Reset vertex colors") && EditorUtility.DisplayDialog("Reset vertex colors?",
                    "Are you sure you want to reset f vertex colors?", "Yes", "No"))
            {
                _drawOnMeshData.OverrideColors = false;
                if (_meshFilter.sharedMesh != null)
                    _meshFilter.sharedMesh.colors = null;
                DrawOnMeshChanged?.Invoke();
            }

            if (EditorGUI.EndChangeCheck())
            {
                Undo.RecordObject(_gameObject, "Lake changed");
            }
        }

        public void UIFlowColors()
        {
            EditorGUILayout.Space();
            EditorGUILayout.HelpBox("Sharp gradient could generate bugged effect. Keep flow changes smooth.",
                MessageType.Info);

            GUILayout.Label("Flow Map Manual: ", EditorStyles.boldLabel);
            _drawOnMeshData.DrawOnMeshFlowMap = true;
            if (_drawOnMeshData.DrawOnMeshFlowMap)
            {
                _drawOnMeshData.FlowToolSelected = GUILayout.SelectionGrid(_drawOnMeshData.FlowToolSelected, _flowToolbarStrings, 4, GUILayout.Height(25));

                EditorGUILayout.Space();
                if (_drawOnMeshData.FlowToolSelected == 0)
                {
                    _drawOnMeshData.FlowSpeed = EditorGUILayout.Slider("Flow U Speed", _drawOnMeshData.FlowSpeed, -1, 1);
                    _drawOnMeshData.FlowDirection = EditorGUILayout.Slider("Flow V Speed", _drawOnMeshData.FlowDirection, -1, 1);
                }

                _drawOnMeshData.Opacity = EditorGUILayout.FloatField("Opacity", _drawOnMeshData.Opacity);
                _drawOnMeshData.DrawSize = EditorGUILayout.FloatField("Size", _drawOnMeshData.DrawSize);
                if (_drawOnMeshData.DrawSize < 0)
                {
                    _drawOnMeshData.DrawSize = 0;
                }

                EditorGUILayout.Space();
                _drawOnMeshData.DrawOnMultiple = EditorGUILayout.Toggle("Draw on multiple rivers", _drawOnMeshData.DrawOnMultiple);
            }

            EditorGUILayout.Space();
            if (!_drawOnMeshData.ShowFlowMap)
            {
                if (GUILayout.Button("Show flow directions"))
                {
                    if (!_drawOnMeshData.ShowFlowMap && !_drawOnMeshData.ShowVertexColors) _drawOnMeshData.OldMaterial = _gameObject.GetComponent<MeshRenderer>().sharedMaterial;
                    ResetMaterial();
                    _gameObject.GetComponent<MeshRenderer>().sharedMaterial =
                        new Material(Shader.Find("NatureManufacture Shaders/Debug/Flowmap Direction"));
                    _gameObject.GetComponent<MeshRenderer>().sharedMaterial
                        .SetTexture(Direction, Resources.Load<Texture2D>("Debug_Arrow"));
                    _gameObject.GetComponent<MeshRenderer>().sharedMaterial
                        .SetTexture(NoDirection, Resources.Load<Texture2D>("Debug_Dot"));


                    _drawOnMeshData.ShowFlowMap = true;
                }

                if (GUILayout.Button("Show flow smoothness"))
                {
                    if (!_drawOnMeshData.ShowFlowMap && !_drawOnMeshData.ShowVertexColors) _drawOnMeshData.OldMaterial = _gameObject.GetComponent<MeshRenderer>().sharedMaterial;
                    ResetMaterial();
                    _gameObject.GetComponent<MeshRenderer>().sharedMaterial =
                        new Material(Shader.Find("NatureManufacture Shaders/Debug/FlowMapUV4"));
                    _drawOnMeshData.ShowFlowMap = true;
                }
            }

            if (_drawOnMeshData.ShowFlowMap)
            {
                if (GUILayout.Button("Hide flow"))
                {
                    ResetMaterial();
                    _gameObject.GetComponent<MeshRenderer>().sharedMaterial = _drawOnMeshData.OldMaterial;
                }
            }

            if (GUILayout.Button("Reset flow") && EditorUtility.DisplayDialog("Reset flow to automatic?",
                    "Are you sure you want to reset flow to automatic?", "Yes", "No"))
            {
                _drawOnMeshData.OverrideFlowMap = false;
                DrawOnMeshChanged?.Invoke();
            }
        }

        private void DrawOnVertexColors()
        {
            if (Event.current.type == EventType.MouseUp && Event.current.button == 0)
            {
                _hitPositionOldFlow = Vector3.zero;
                Undo.RegisterCompleteObjectUndo(_gameObject, "Painted");
            }

            GameObject go;

            HandleUtility.AddDefaultControl(GUIUtility.GetControlID(FocusType.Passive));

            switch (Event.current.type)
            {
                // HandleUtility.PickGameObject doesn't work with some EventTypes in OnSceneGUI
                case EventType.Layout:
                case EventType.Repaint:
                case EventType.ExecuteCommand:
                    go = _lastGameObjectUnderCursor;
                    break;
                default:
                    go = HandleUtility.PickGameObject(Event.current.mousePosition, false);
                    break;
            }

            if (!go)
                return;


            if (go == _gameObject && _drawOnMeshData.DrawOnMultiple)
                return;

            _drawOnMeshData.OverrideColors = true;

            Ray ray = HandleUtility.GUIPointToWorldRay(Event.current.mousePosition);

            MeshCollider meshCollider = go.AddComponent<MeshCollider>();

            Vector3 hitPosition = Vector3.zero;
            Vector3 hitNormal = Vector3.zero;


            if (meshCollider.Raycast(ray, out RaycastHit hit, Mathf.Infinity))
            {
                if (hit.collider.gameObject == go)
                {
                    go = hit.collider.gameObject;

                    hitPosition = hit.point;
                    hitNormal = hit.normal;
                }
                else
                    go = null;
            }
            else
                go = null;


            if (meshCollider != null)
                Object.DestroyImmediate(meshCollider);


            if (go != null)
            {
                _lastGameObjectUnderCursor = go;
                Handles.color = new Color(_drawOnMeshData.DrawColor.r, _drawOnMeshData.DrawColor.g, _drawOnMeshData.DrawColor.b, 1);
                Handles.DrawLine(hitPosition, hitPosition + hitNormal * 2);
                Handles.CircleHandleCap(
                    0,
                    hitPosition,
                    Quaternion.LookRotation(hitNormal), _drawOnMeshData.DrawSize,
                    EventType.Repaint
                );
                Handles.color = Color.black;
                Handles.CircleHandleCap(
                    0,
                    hitPosition,
                    Quaternion.LookRotation(hitNormal), _drawOnMeshData.DrawSize - 0.1f,
                    EventType.Repaint
                );


                if (!(Event.current.type == EventType.MouseDown || Event.current.type == EventType.MouseDrag) ||
                    Event.current.button != 0)
                    return;


                MeshFilter meshFilter = go.GetComponent<MeshFilter>();
                if (meshFilter.sharedMesh != null)
                {
                    Mesh mesh = meshFilter.sharedMesh;


                    int length = mesh.vertices.Length;
                    float dist;
                    hitPosition -= go.transform.position;
                    Vector3[] vertices = mesh.vertices;
                    Color[] colors = mesh.colors ?? new Color[length];

                    for (int i = 0; i < length; i++)
                    {
                        dist = Vector3.Distance(hitPosition, vertices[i]);

                        if (dist < _drawOnMeshData.DrawSize)
                        {
                            if (Event.current.shift)
                            {
                                if (_drawOnMeshData.DrawColorR)
                                    colors[i].r = Mathf.Lerp(colors[i].r, 0, _drawOnMeshData.Opacity);
                                if (_drawOnMeshData.DrawColorG)
                                    colors[i].g = Mathf.Lerp(colors[i].g, 0, _drawOnMeshData.Opacity);
                                if (_drawOnMeshData.DrawColorB)
                                    colors[i].b = Mathf.Lerp(colors[i].b, 0, _drawOnMeshData.Opacity);
                                if (_drawOnMeshData.DrawColorA)
                                    colors[i].a = Mathf.Lerp(colors[i].a, 1, _drawOnMeshData.Opacity);
                            }
                            else
                            {
                                if (_drawOnMeshData.DrawColorR)
                                    colors[i].r = Mathf.Lerp(colors[i].r, _drawOnMeshData.DrawColor.r, _drawOnMeshData.Opacity);
                                if (_drawOnMeshData.DrawColorG)
                                    colors[i].g = Mathf.Lerp(colors[i].g, _drawOnMeshData.DrawColor.g, _drawOnMeshData.Opacity);
                                if (_drawOnMeshData.DrawColorB)
                                    colors[i].b = Mathf.Lerp(colors[i].b, _drawOnMeshData.DrawColor.b, _drawOnMeshData.Opacity);
                                if (_drawOnMeshData.DrawColorA)
                                    colors[i].a = Mathf.Lerp(colors[i].a, _drawOnMeshData.DrawColor.a, _drawOnMeshData.Opacity);
                            }
                        }
                    }

                    mesh.colors = colors;
                    meshFilter.sharedMesh = mesh;
                }
            }
        }

        private void DrawOnFlowMap()
        {
            if (Event.current.type == EventType.MouseUp && Event.current.button == 0)
            {
                _hitPositionOldFlow = Vector3.zero;
                Undo.RegisterCompleteObjectUndo(_gameObject, "Painted");
            }

            GameObject go;

            HandleUtility.AddDefaultControl(GUIUtility.GetControlID(FocusType.Passive));

            switch (Event.current.type)
            {
                // HandleUtility.PickGameObject doesn't work with some EventTypes in OnSceneGUI
                case EventType.Layout:
                case EventType.Repaint:
                case EventType.ExecuteCommand:
                    go = _lastGameObjectUnderCursor;
                    break;
                default:
                    go = HandleUtility.PickGameObject(Event.current.mousePosition, false);
                    break;
            }

            if (!go)
                return;


            LakePolygon hitedSpline = go.GetComponent<LakePolygon>();


            if (!hitedSpline || (hitedSpline.gameObject != _gameObject && _drawOnMeshData.DrawOnMultiple))
                return;


            Ray ray = HandleUtility.GUIPointToWorldRay(Event.current.mousePosition);

            MeshCollider meshCollider = hitedSpline.gameObject.AddComponent<MeshCollider>();

            Vector3 hitPosition = Vector3.zero;
            Vector3 hitNormal = Vector3.zero;


            if (meshCollider.Raycast(ray, out RaycastHit hit, Mathf.Infinity))
            {
                if (hit.collider.gameObject == go)
                {
                    go = hit.collider.gameObject;

                    hitPosition = hit.point;
                    hitNormal = hit.normal;
                }
                else
                    go = null;
            }
            else
                go = null;


            if (meshCollider != null)
                Object.DestroyImmediate(meshCollider);


            if (go != null)
            {
                _lastGameObjectUnderCursor = go;
                Handles.color = new Color(_drawOnMeshData.FlowDirection, _drawOnMeshData.FlowSpeed, 0, 1);
                Handles.DrawLine(hitPosition, hitPosition + hitNormal * 2);
                Handles.CircleHandleCap(
                    0,
                    hitPosition,
                    Quaternion.LookRotation(hitNormal), _drawOnMeshData.DrawSize,
                    EventType.Repaint
                );
                Handles.color = Color.black;
                Handles.CircleHandleCap(
                    0,
                    hitPosition,
                    Quaternion.LookRotation(hitNormal), _drawOnMeshData.DrawSize - 0.1f,
                    EventType.Repaint
                );

                if (!(Event.current.type == EventType.MouseDown || Event.current.type == EventType.MouseDrag) ||
                    Event.current.button != 0)
                    return;


                //hitedSpline.DrawOnMeshData.OverrideFlowMap = true;
                MeshFilter meshFilter = hitedSpline.GetComponent<MeshFilter>();


                if (meshFilter.sharedMesh != null)
                {
                    Mesh mesh = meshFilter.sharedMesh;


                    List<Vector2> colorsFlowMap = new();
                    colorsFlowMap.AddRange(mesh.uv4);

                    int length = mesh.vertices.Length;
                    float dist;
                    float distValue;
                    hitPosition -= hitedSpline.transform.position;
                    Vector3[] vertices = mesh.vertices;

                    for (int i = 0; i < length; i++)
                    {
                        dist = Vector3.Distance(hitPosition, vertices[i]);
                        if (!(dist < _drawOnMeshData.DrawSize)) continue;

                        distValue = (_drawOnMeshData.DrawSize - dist) / _drawOnMeshData.DrawSize;
                        if (Event.current.shift)
                        {
                            colorsFlowMap[i] = Vector2.Lerp(colorsFlowMap[i], new Vector2(0, 0), _drawOnMeshData.Opacity);
                        }
                        else
                        {
                            Vector2 direction = new Vector2((hitPosition - vertices[i]).x, (hitPosition - vertices[i]).z).normalized * distValue;
                            Vector2 smudgeDirection = new Vector2((hitPosition - _hitPositionOldFlow).x, (hitPosition - _hitPositionOldFlow).z).normalized; //  * distValue;

                            if (_drawOnMeshData.FlowToolSelected == 0)
                            {
                                colorsFlowMap[i] = Vector2.Lerp(colorsFlowMap[i], new Vector2(_drawOnMeshData.FlowDirection, _drawOnMeshData.FlowSpeed), _drawOnMeshData.Opacity * distValue);
                            }
                            else if (_drawOnMeshData.FlowToolSelected == 1)
                            {
                                colorsFlowMap[i] = Vector2.Lerp(colorsFlowMap[i],
                                    -direction, _drawOnMeshData.Opacity * distValue);
                            }
                            else if (_drawOnMeshData.FlowToolSelected == 2)
                            {
                                colorsFlowMap[i] = Vector2.Lerp(colorsFlowMap[i],
                                    direction, _drawOnMeshData.Opacity * distValue);
                            }
                            else if (_drawOnMeshData.FlowToolSelected == 3)
                            {
                                if (_hitPositionOldFlow.magnitude != 0 && Vector3.Distance(_hitPositionOldFlow, hitPosition) > 0.001f)
                                {
                                    colorsFlowMap[i] = Vector2.Lerp(colorsFlowMap[i],
                                        -smudgeDirection, _drawOnMeshData.Opacity * distValue);
                                }
                            }
                        }
                    }

                    mesh.uv4 = colorsFlowMap.ToArray();
                    meshFilter.sharedMesh = mesh;

                    _hitPositionOldFlow = hitPosition;
                }
            }
        }
    }
}