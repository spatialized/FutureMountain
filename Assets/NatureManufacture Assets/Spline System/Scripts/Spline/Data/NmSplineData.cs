using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

#if UNITY_EDITOR
using UnityEditor;
#endif


namespace NatureManufacture.RAM
{
    [Serializable]
    public abstract class NmSplineData<T> : NmSplineDataBase
    {
        [SerializeField, HideInInspector] private List<T> mainControlPointsData;
        [SerializeField, HideInInspector] private List<T> pointsData;
        [field: SerializeField] [HideInInspector] private Dictionary<float, T> SearchData { get; } = new();

        public List<T> MainControlPointsData
        {
            get => mainControlPointsData;
            set => mainControlPointsData = value;
        }

        public List<T> PointsData
        {
            get => pointsData;
            set => pointsData = value;
        }

        public abstract T GetBaseValue { get; }

        public abstract string GetName { get; }

        public abstract T LerpData(T a, T b, float lerp);


        public T GetPointData(int index)
        {
            return index < PointsData.Count ? PointsData[index] : GetBaseValue;
        }

        public override void AddPointAtEnd()
        {
            MainControlPointsData.Add(MainControlPointsData.Count > 0 ? MainControlPointsData[^1] : GetBaseValue);
        }

        public override void AddPointAfter(int i)
        {
            if (i < MainControlPointsData.Count - 1 && MainControlPointsData.Count > i + 1)
            {
                MainControlPointsData.Insert(i + 1, LerpData(MainControlPointsData[i], MainControlPointsData[i + 1], 0.5f));
            }
            else if (MainControlPointsData.Count > 1 && i == MainControlPointsData.Count - 1)
            {
                MainControlPointsData.Insert(i + 1, LerpData(MainControlPointsData[i - 1], MainControlPointsData[i], 0.5f));
            }
            else
            {
                MainControlPointsData.Insert(i, GetBaseValue);
            }
        }

        public override void RemoveAllData()
        {
            MainControlPointsData.Clear();
        }

        public override void RemoveData(int index)
        {
            MainControlPointsData.RemoveAt(index);
        }

        public override void RemoveDataFrom(int fromIndex)
        {
            MainControlPointsData.RemoveRange(fromIndex, MainControlPointsData.Count - fromIndex);
        }

        public override void RemoveLastData()
        {
            MainControlPointsData.RemoveAt(MainControlPointsData.Count - 1);
        }

        public override void ReverseData()
        {
            MainControlPointsData.Reverse();
        }


        // Define an abstract method that derived classes must implement
        public override void CalculatePoint(int pointIndex, int nextPointIndex, float lerp)
        {
            T newData = LerpData(MainControlPointsData[pointIndex], MainControlPointsData[nextPointIndex], lerp);

            PointsData.Add(newData);
        }

        public override void ClearPointsData()
        {
            PointsData.Clear();
        }

        public override void GenerateMainControlPointsData(int index)
        {
            if (MainControlPointsData == null)
            {
                MainControlPointsData = new List<T>();
                MainControlPointsData.Clear();

                for (int i = 0; i < index; i++)
                {
                    MainControlPointsData.Add(GetBaseValue);
                }
            }
            else if (MainControlPointsData.Count < index)
            {
                for (int i = MainControlPointsData.Count; i < index; i++)
                {
                    MainControlPointsData.Add(GetBaseValue);
                }
            }
            else if (MainControlPointsData.Count > index)
            {
                MainControlPointsData.RemoveRange(index, MainControlPointsData.Count - index);
            }

            PointsData ??= new List<T>();
            PointsData.Clear();
        }

        public override void ClearSearchData()
        {
            SearchData.Clear();
        }

        public override void AddSearchData(float lengthToFind, float lerpValue, int firstIndex, int secondIndex)
        {
            T newData = LerpData(PointsData[firstIndex], PointsData[secondIndex], lerpValue);
            SearchData.Add(lengthToFind, newData);
        }

        public T GetSearchData(float lengthToFind)
        {
            return SearchData.TryGetValue(lengthToFind, out T position) ? position : GetBaseValue;
        }


        public void ShowSceneGUI(NmSpline nmSpline)
        {
#if UNITY_EDITOR
            for (int j = 0; j < nmSpline.MainControlPoints.Count; j++)
            {
                EditorGUI.BeginChangeCheck();


                Vector3 handlePos = (Vector3)nmSpline.MainControlPoints[j].position + nmSpline.Transform.position;
                Quaternion handleRot = nmSpline.MainControlPoints[j].orientation * Quaternion.LookRotation(Vector3.up);
                float handleSize = HandleUtility.GetHandleSize(handlePos);

                ShowHandle(nmSpline, j, handlePos, handleRot, handleSize);


                if (EditorGUI.EndChangeCheck())
                {
                    Undo.RegisterFullObjectHierarchyUndo(this, "Change Position");
                    nmSpline.SelectedPosition = j;
                    nmSpline.NmSplineChanged?.Invoke();
                }
            }

#endif
        }

        public abstract void ShowHandle(NmSpline nmSpline, int i, Vector3 handlePos, Quaternion handleRot, float handleSize);


        public override void ShowUI(int index)
        {
#if UNITY_EDITOR

            SerializedObject serializedObject = new SerializedObject(this);
            //get the object from main control points data
            SerializedProperty controlPointsSerialized = serializedObject.FindProperty("mainControlPointsData");

            SerializedProperty data = controlPointsSerialized.GetArrayElementAtIndex(index);

            EditorGUILayout.PropertyField(data, new GUIContent(GetName));
            serializedObject.ApplyModifiedProperties();

#endif
        }
    }
}