using UnityEditor;
using UnityEngine;

namespace NatureManufacture.RAM.Editor
{
    public static class NmSplineSceneGUI
    {
        private static readonly Color selectedTextColor = new(0.38f, 1f, 0.55f, 1);
        private static readonly Color selectedHandleColor = new(0.38f, 1f, 0.55f, 0.5f);
        private static readonly Color notSelectedTextColor = Color.red;
        private static readonly Color notSelectedHandleColor = new(1.0f, 0.36f, 0.36f, 0.5f);


        public static void SplineSceneGUI(NmSpline nmSpline, Object objectToUndo, bool blockFirstPoint, bool blockLastPoint, ref bool splineChanged)
        {
            
            int controlId = GUIUtility.GetControlID(FocusType.Passive);
            Color baseColor = Handles.color;
            int controlPointToDelete = -1;

            for (int j = 0; j < nmSpline.MainControlPoints.Count; j++)
            {
                EditorGUI.BeginChangeCheck();


                Vector3 handlePos = (Vector3)nmSpline.MainControlPoints[j].position + nmSpline.Transform.position;
                Quaternion handleRot = nmSpline.MainControlPoints[j].orientation * Quaternion.LookRotation(Vector3.up);
                float handleSize = HandleUtility.GetHandleSize(handlePos);


                var style = new GUIStyle();


                if (nmSpline.SelectedPosition == j)
                {
                    style.normal.textColor = selectedTextColor;
                    Handles.color = selectedHandleColor;
                }
                else
                {
                    style.normal.textColor = notSelectedTextColor;
                    Handles.color = notSelectedHandleColor;
                }


                Handles.CircleHandleCap(
                    controlId,
                    handlePos,
                    handleRot,
                    0.3f * handleSize,
                    EventType.Repaint
                );

                Handles.DrawSolidDisc(handlePos, handleRot * Vector3.forward, 0.15f * handleSize);


                //if (NmSpline.SelectedPosition != j) - can't use because of hot control
                if (Handles.Button(handlePos, handleRot,
                        0.2f * handleSize, 0.25f * handleSize,
                        Handles.CircleHandleCap))
                    nmSpline.SelectedPosition = j;


                Vector3 screenPoint = Camera.current.WorldToScreenPoint(handlePos);

                if (screenPoint.z > 0)
                    Handles.Label(handlePos + Vector3.up * handleSize,
                        "Point: " + j, style);

                float width = nmSpline.MainControlPoints[j].position.w;


                // if (_splineChanged && j != NmSpline.SelectedPosition)
                //    continue;


                if (Event.current.control && Event.current.shift && nmSpline.MainControlPoints.Count > 1)
                {
                    int id = GUIUtility.GetControlID(FocusType.Passive);


                    if (HandleUtility.nearestControl == id)
                    {
                        Handles.color = Color.white;
                        if (Event.current.type == EventType.MouseDown && Event.current.button == 0)
                            controlPointToDelete = j;
                    }
                    else
                    {
                        Handles.color = Handles.xAxisColor;
                    }

                    float size = 0.6f;
                    size = handleSize * size;
                    switch (Event.current.type)
                    {
                        case EventType.Repaint:
                            Handles.SphereHandleCap(id, (Vector3)nmSpline.MainControlPoints[j].position + nmSpline.Transform.position,
                                Quaternion.identity, size, EventType.Repaint);
                            break;
                        case EventType.Layout:
                            Handles.SphereHandleCap(id, (Vector3)nmSpline.MainControlPoints[j].position + nmSpline.Transform.position,
                                Quaternion.identity, size, EventType.Layout);
                            break;
                    }
                }
                else
                    switch (Tools.current)
                    {
                        case Tool.Move:
                            PointMove(nmSpline, handleSize, j, width, handleRot);
                            break;
                        case Tool.Rotate when nmSpline.UseRotation:
                            PointRotate(nmSpline, blockFirstPoint, blockLastPoint, j, handleSize, handlePos, baseColor);
                            break;
                        case Tool.Scale when nmSpline.UseWidth:
                            PointScale(nmSpline, j, handleSize);
                            break;
                    }


                if (EditorGUI.EndChangeCheck())
                {
                    //NmSpline.SelectedPosition = j;

                    Undo.RecordObject(objectToUndo, "Change Position");
                    Undo.RegisterFullObjectHierarchyUndo(nmSpline, "Change Position");
                    nmSpline.NmSplineChanged?.Invoke();
                    splineChanged = true;
                }
            }

            if (controlPointToDelete >= 0)
            {
                if (nmSpline.SelectedPosition == controlPointToDelete) nmSpline.SelectedPosition--;
                Undo.RecordObject(objectToUndo, "Remove point");
                Undo.RecordObject(nmSpline, "Change Position");


                nmSpline.RemovePoint(controlPointToDelete);

                nmSpline.NmSplineChanged?.Invoke();

                GUIUtility.hotControl = controlId;
                Event.current.Use();
                HandleUtility.Repaint();
            }

            //Add Point at end
            if (Event.current.control && !Event.current.alt && !Event.current.shift)
            {
                AddPointAtEnd(nmSpline, objectToUndo, controlId);
            }

            //Add Point between 
            if (!Event.current.control && Event.current.shift && nmSpline.MainControlPoints.Count > 1)
            {
                AddPointBetween(nmSpline, objectToUndo, controlId);
            }

            if (Event.current.type == EventType.MouseUp && Event.current.button == 0 && Event.current.control && !Event.current.alt) GUIUtility.hotControl = 0;

            if (Event.current.type == EventType.MouseUp && Event.current.button == 0 && Event.current.shift) GUIUtility.hotControl = 0;

        
            if (Event.current.type == EventType.MouseUp && Event.current.button == 0 && splineChanged)
            {
                splineChanged = false;
                GUIUtility.hotControl = 0;
            }

         
        }

        private static void PointScale(NmSpline nmSpline, int j, float handleSize)
        {
            float width = nmSpline.MainControlPoints[j].position.w;
            Handles.color = Handles.xAxisColor;
            //Vector3 handlePos = (Vector3)spline.controlPoints [j] + spline.NmSpline.Transform.position;

            width = Handles.ScaleSlider(width,
                (Vector3)nmSpline.MainControlPoints[j].position + nmSpline.Transform.position, new Vector3(0, 0.5f, 0),
                Quaternion.Euler(-90, 0, 0), handleSize, 0.01f);

            if (width <= 0)
                width = 0.00001f;

            Vector4 pos = nmSpline.MainControlPoints[j].position;
            pos.w = width;


            nmSpline.MainControlPoints[j].position = pos;

            if (Vector3.Distance(nmSpline.MainControlPoints[j].position, pos) > 0.0001f) nmSpline.SelectedPosition = j;
        }

        private static void PointRotate(NmSpline nmSpline, bool blockFirstPoint, bool blockLastPoint, int j, float handleSize, Vector3 handlePos, Color baseColor)
        {
            if (nmSpline.MainControlPoints.Count <= j) return;

            if (blockFirstPoint && j == 0 || blockLastPoint && j == nmSpline.MainControlPoints.Count - 1) return;

            float size = 0.6f;
            size = handleSize * size;

            Handles.color = Handles.zAxisColor;
            Quaternion rotation = Handles.Disc(nmSpline.MainControlPoints[j].orientation, handlePos,
                nmSpline.MainControlPoints[j].orientation * new Vector3(0, 0, 1), size, true, 0.1f);

            Handles.color = Handles.yAxisColor;
            rotation = Handles.Disc(rotation, handlePos, rotation * new Vector3(0, 1, 0), size, true,
                0.1f);

            Handles.color = Handles.xAxisColor;
            rotation = Handles.Disc(rotation, handlePos, rotation * new Vector3(1, 0, 0), size, true,
                0.1f);

            if ((Quaternion.Inverse(nmSpline.MainControlPoints[j].orientation) * rotation).eulerAngles.magnitude > 0)
            {
                //Debug.Log($"Rotation changed {j}");
                nmSpline.SelectedPosition = j;
            }

            nmSpline.MainControlPoints[j].rotation *=
                Quaternion.Inverse(nmSpline.MainControlPoints[j].orientation) * rotation;

            if (float.IsNaN(nmSpline.MainControlPoints[j].rotation.x) ||
                float.IsNaN(nmSpline.MainControlPoints[j].rotation.y) ||
                float.IsNaN(nmSpline.MainControlPoints[j].rotation.z) ||
                float.IsNaN(nmSpline.MainControlPoints[j].rotation.w))
            {
                nmSpline.MainControlPoints[j].rotation = Quaternion.identity;
                nmSpline.NmSplineChanged?.Invoke();
            }

            Handles.color = baseColor;
            Handles.FreeRotateHandle(Quaternion.identity, handlePos, size);

            Handles.CubeHandleCap(0, handlePos, nmSpline.MainControlPoints[j].orientation, size * 0.3f,
                EventType.Repaint);

            Vector3 position = nmSpline.Transform.position;

            if (nmSpline.ControlPointsPositionUp.Count > j)
                Handles.DrawLine(nmSpline.ControlPointsPositionUp[j] + position, nmSpline.ControlPointsPositionDown[j] + position);
        }

        private static void PointMove(NmSpline nmSpline, float handleSize, int j, float width, Quaternion handleRot)
        {
            float size = 0.6f;
            size = handleSize * size;
            Vector3 position = nmSpline.Transform.position;

            if (Tools.pivotRotation == PivotRotation.Global)
            {
                Handles.color = Handles.xAxisColor;
                //Vector3 position = NmSpline.Transform.position;
                Vector4 pos = Handles.Slider((Vector3)nmSpline.MainControlPoints[j].position + position,
                    Vector3.right, size, Handles.ArrowHandleCap, 0.01f) - position;
                Handles.color = Handles.yAxisColor;
                pos = Handles.Slider((Vector3)pos + position, Vector3.up, size,
                    Handles.ArrowHandleCap, 0.01f) - position;
                Handles.color = Handles.zAxisColor;
                pos = Handles.Slider((Vector3)pos + position, Vector3.forward, size,
                    Handles.ArrowHandleCap, 0.01f) - position;

                Vector3 halfPos = (Vector3.right + Vector3.forward) * size * 0.3f;
                Handles.color = Handles.yAxisColor;
                pos = Handles.Slider2D((Vector3)pos + position + halfPos, Vector3.up,
                          Vector3.right, Vector3.forward, size * 0.3f, Handles.RectangleHandleCap, 0.01f) -
                      position - halfPos;
                halfPos = (Vector3.right + Vector3.up) * size * 0.3f;
                Handles.color = Handles.zAxisColor;
                pos = Handles.Slider2D((Vector3)pos + position + halfPos, Vector3.forward,
                          Vector3.right, Vector3.up, size * 0.3f, Handles.RectangleHandleCap, 0.01f) -
                      position - halfPos;
                halfPos = (Vector3.up + Vector3.forward) * size * 0.3f;
                Handles.color = Handles.xAxisColor;
                pos = Handles.Slider2D((Vector3)pos + position + halfPos, Vector3.right,
                          Vector3.up, Vector3.forward, size * 0.3f, Handles.RectangleHandleCap, 0.01f) -
                      position - halfPos;

                pos.w = width;

                if (Vector3.Distance(nmSpline.MainControlPoints[j].position, pos) > 0.0001f)
                {
                    //Debug.Log($"name {_name}");
                    nmSpline.SelectedPosition = j;
                }


                nmSpline.MainControlPoints[j].position = pos;
            }
            else
            {
                Handles.color = Handles.xAxisColor;
                //Vector3 position = NmSpline.Transform.position;
                Vector4 pos = Handles.Slider((Vector3)nmSpline.MainControlPoints[j].position + position,
                    handleRot * Vector3.right, size, Handles.ArrowHandleCap, 0.01f) - position;
                Handles.color = Handles.yAxisColor;
                pos = Handles.Slider((Vector3)pos + position, handleRot * Vector3.forward, size,
                    Handles.ArrowHandleCap, 0.01f) - position;
                Handles.color = Handles.zAxisColor;
                pos = Handles.Slider((Vector3)pos + position, handleRot * Vector3.down, size,
                    Handles.ArrowHandleCap, 0.01f) - position;

                Vector3 halfPos = (handleRot * Vector3.right + handleRot * Vector3.forward) * size * 0.3f;
                Handles.color = Handles.zAxisColor;
                pos = Handles.Slider2D((Vector3)pos + position + halfPos, handleRot * Vector3.up,
                          handleRot * Vector3.right, handleRot * Vector3.forward, size * 0.3f, Handles.RectangleHandleCap, 0.01f) -
                      position - halfPos;

                halfPos = (handleRot * Vector3.right + handleRot * Vector3.down) * size * 0.3f;
                Handles.color = Handles.yAxisColor;
                pos = Handles.Slider2D((Vector3)pos + position + halfPos, handleRot * Vector3.forward,
                          handleRot * Vector3.right, handleRot * Vector3.down, size * 0.3f, Handles.RectangleHandleCap, 0.01f) -
                      position - halfPos;

                halfPos = (handleRot * Vector3.down + handleRot * Vector3.forward) * size * 0.3f;
                Handles.color = Handles.xAxisColor;
                pos = Handles.Slider2D((Vector3)pos + position + halfPos, handleRot * Vector3.right,
                          handleRot * Vector3.down, handleRot * Vector3.forward, size * 0.3f, Handles.RectangleHandleCap, 0.01f) -
                      position - halfPos;

                pos.w = width;

                if (Vector3.Distance(nmSpline.MainControlPoints[j].position, pos) > 0.0001f)
                {
                    //Debug.Log($"name {_name}");
                    nmSpline.SelectedPosition = j;
                }


                nmSpline.MainControlPoints[j].position = pos;
            }
        }

        private static void AddPointAtEnd(NmSpline nmSpline, Object objectToUndo, int controlId)
        {
            Ray ray = HandleUtility.GUIPointToWorldRay(Event.current.mousePosition);

            if (!Physics.Raycast(ray, out RaycastHit hit)) return;

            Vector3 handlePos = hit.point;

            if (nmSpline.MainControlPoints.Count > 0)
                Handles.DrawLine(hit.point, (Vector3)nmSpline.MainControlPoints[^1].position + nmSpline.Transform.position);

            float handleSize = HandleUtility.GetHandleSize(handlePos);

            Handles.DrawSolidDisc(handlePos, hit.normal, 0.25f * handleSize);


            Handles.CircleHandleCap(
                0,
                handlePos,
                Quaternion.LookRotation(hit.normal),
                0.5f * handleSize,
                EventType.Repaint
            );


            if (Event.current.type != EventType.MouseDown || Event.current.button != 0) return;


            Undo.RecordObject(objectToUndo, "Add point");
            Undo.RecordObject(nmSpline, "Change Position");

            Vector4 position = hit.point - nmSpline.Transform.position;

            if (!Event.current.alt)
            {
                nmSpline.AddPoint(position, nmSpline.IsSnapping, nmSpline.Width);
                nmSpline.SelectedPosition = nmSpline.MainControlPoints.Count - 1;
            }
            else
            {
                nmSpline.AddPointAfter(-1, nmSpline.IsSnapping);
                nmSpline.ChangePointPosition(0, position);
                nmSpline.SelectedPosition = 0;

                nmSpline.NmSplineChanged?.Invoke();
            }


            nmSpline.NmSplineChanged?.Invoke();


            GUIUtility.hotControl = controlId;
            Event.current.Use();
            HandleUtility.Repaint();
        }

        private static void AddPointBetween(NmSpline nmSpline, Object objectToUndo, int controlId)
        {
            Ray ray = HandleUtility.GUIPointToWorldRay(Event.current.mousePosition);

            if (!Physics.Raycast(ray, out RaycastHit hit)) return;


            int idMin = -1;
            float distanceMin = float.MaxValue;
            Vector3 handlePos;
            for (int j = 0; j < nmSpline.MainControlPoints.Count; j++)
            {
                handlePos = (Vector3)nmSpline.MainControlPoints[j].position + nmSpline.Transform.position;

                float pointDist = Vector3.Distance(hit.point, handlePos);
                if (pointDist < distanceMin)
                {
                    distanceMin = pointDist;
                    idMin = j;
                }
            }

            Vector3 posOne = (Vector3)nmSpline.MainControlPoints[idMin].position + nmSpline.Transform.position;
            Vector3 posTwo;


            if (idMin == 0)
            {
                posTwo = (Vector3)nmSpline.MainControlPoints[1].position + nmSpline.Transform.position;
            }
            else if (idMin == nmSpline.MainControlPoints.Count - 1 && !nmSpline.IsLooping)
            {
                posTwo = (Vector3)nmSpline.MainControlPoints[^2].position +
                         nmSpline.Transform.position;

                idMin = idMin - 1;
            }
            else
            {
                Vector3 position = nmSpline.Transform.position;
                Vector3 posPrev = (Vector3)nmSpline.MainControlPoints[nmSpline.ClampListPos(idMin - 1)].position + position;
                Vector3 posNext = (Vector3)nmSpline.MainControlPoints[nmSpline.ClampListPos(idMin + 1)].position + position;

                if (Vector3.Distance(hit.point, posPrev) > Vector3.Distance(hit.point, posNext))
                {
                    posTwo = posNext;
                }
                else
                {
                    posTwo = posPrev;
                    idMin = idMin - 1;
                }
            }


            Handles.DrawLine(hit.point, posOne);
            Handles.DrawLine(hit.point, posTwo);


            handlePos = hit.point;

            float handleSize = HandleUtility.GetHandleSize(handlePos);

            Handles.DrawSolidDisc(handlePos, hit.normal, 0.25f * handleSize);


            Handles.CircleHandleCap(
                0,
                handlePos,
                Quaternion.LookRotation(hit.normal),
                0.5f * handleSize,
                EventType.Repaint
            );

            if (Event.current.type == EventType.MouseDown && Event.current.button == 0)
            {
                Undo.RecordObject(objectToUndo, "Add point");
                Undo.RecordObject(nmSpline, "Change Position");

                Vector4 position = handlePos - nmSpline.Transform.position;
                nmSpline.AddPointAfter(idMin, nmSpline.IsSnapping);
                nmSpline.ChangePointPosition(idMin + 1, position);

                nmSpline.NmSplineChanged?.Invoke();

                GUIUtility.hotControl = controlId;
                Event.current.Use();
                HandleUtility.Repaint();
            }
        }
    }
}