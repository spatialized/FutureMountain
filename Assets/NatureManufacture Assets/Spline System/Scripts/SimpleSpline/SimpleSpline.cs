using System.Collections.Generic;
#if UNITY_EDITOR
using UnityEditor;
#endif
using UnityEngine;
using UnityEngine.Events;
using Random = UnityEngine.Random;

namespace NatureManufacture.RAM
{
    [SelectionBase]
    [RequireComponent(typeof(NmSpline))]
    public class SimpleSpline : MonoBehaviour, IGenerationEvents
    {
        [SerializeField] private NmSpline nmSpline;

        [SerializeField] private float triangleDensity = 0;

        [SerializeField] private bool centerPivot;

        [SerializeField] private bool lockHeight;


        [field: SerializeField] public UnityEvent OnGenerationStarted { get; set; }
        [field: SerializeField] public UnityEvent OnGenerationEnded { get; set; }

        public NmSpline NmSpline
        {
            get
            {
                if (nmSpline != null && nmSpline.gameObject == gameObject)
                    return nmSpline;

                nmSpline = GetComponentInParent<NmSpline>();


                nmSpline.SetData(0, 1, false, false, false, false, false, false);

                return nmSpline;
            }
        }

        public float TriangleDensity
        {
            get => triangleDensity;
            set => triangleDensity = value;
        }

        public bool CenterPivot
        {
            get => centerPivot;
            set => centerPivot = value;
        }

        public bool LockHeight
        {
            get => lockHeight;
            set => lockHeight = value;
        }


        #region spline

        private void GeneratePointList()
        {
            nmSpline.PrepareSpline();


            nmSpline.GenerateFullSpline(triangleDensity);
        }

        #endregion


        public void GenerateSplineObjects()
        {
            SetLockHeight();

            if (CenterPivot)
                nmSpline.CenterSplinePivot();

            OnGenerationStarted?.Invoke();
            if (!NmSpline.CanGenerateSpline())
                return;
            nmSpline.CenterSplinePivot();
            GeneratePointList();


            OnGenerationEnded?.Invoke();
        }


        private void SetLockHeight()
        {
            if (!LockHeight) return;

            for (int i = 1; i < NmSpline.MainControlPoints.Count; i++)
            {
                Vector4 vec = NmSpline.MainControlPoints[i].position;
                vec.y = NmSpline.MainControlPoints[0].position.y;
                NmSpline.MainControlPoints[i].position = vec;
            }
        }


        public static SimpleSpline CreateSimpleSpline()
        {
            var gameObject = new GameObject("Simple Spline");


            var simpleSpline = gameObject.AddComponent<SimpleSpline>();
#if UNITY_EDITOR
            EditorGUIUtility.SetIconForObject(gameObject, EditorGUIUtility.GetIconForObject(simpleSpline));
#endif

            simpleSpline.nmSpline = simpleSpline.GetComponentInParent<NmSpline>();
            simpleSpline.nmSpline.SetData(0, 1, true, true, false, true, false, false, false);


            return simpleSpline;
        }
    }
}