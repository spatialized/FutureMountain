using System;
using UnityEngine;
using UnityEngine.Serialization;

namespace NatureManufacture.RAM
{
    [Serializable]
    public class WaterfallConnection
    {
        public enum ConnectionTypeEnum
        {
            Along,
            Across
        }

        [SerializeField] private NmSpline spline;
        [SerializeField] private float firstPoint = 0;
        [SerializeField] private float lastPoint = 1;
        [SerializeField] private float connectionPoint = 0;


        [SerializeField] private int numberOfPoints = 2;
        [SerializeField] private bool invert;
        [SerializeField] private ConnectionTypeEnum connectionType;
        [SerializeField] private bool autoGetPoints = false;


        public NmSpline Spline
        {
            get => spline;
            set => spline = value;
        }

        public float FirstPoint
        {
            get => firstPoint;
            set => firstPoint = value;
        }

        public float LastPoint
        {
            get => lastPoint;
            set => lastPoint = value;
        }


        public int NumberOfPoints
        {
            get => numberOfPoints;
            set => numberOfPoints = value;
        }

        public bool Invert
        {
            get => invert;
            set => invert = value;
        }

        public ConnectionTypeEnum ConnectionType
        {
            get => connectionType;
            set => connectionType = value;
        }

        public float ConnectionPoint
        {
            get => connectionPoint;
            set => connectionPoint = value;
        }

        public bool AutoGetPoints
        {
            get => autoGetPoints;
            set => autoGetPoints = value;
        }

        public void GetPointsFromSpline(Waterfall waterfall)
        {
            if (spline == null) return;
            if (firstPoint < 0 || lastPoint < 0) return;
            if (Mathf.Approximately(firstPoint, lastPoint))
                return;

            if (numberOfPoints < 2)
                numberOfPoints = 2;


            if (connectionType == ConnectionTypeEnum.Along)
            {
                if (!Along(waterfall)) return;
            }
            else
            {
                Across(waterfall);
            }

            foreach (RamControlPoint controlPoint in waterfall.NmSpline.MainControlPoints)
            {
              
                controlPoint.rotation = Quaternion.Euler(0, 0, waterfall.BaseProfile.AngleOffset);
            }


            if (Invert)
                waterfall.NmSpline.ReversePoints();
        }

        private void Across(Waterfall waterfall)
        {
            waterfall.NmSpline.Clear();

            int count = spline.MainControlPoints.Count;

            float i = connectionPoint;

            int index = (int)i;
            float lerp = i % 1;

            Vector4 firstPosition = spline.MainControlPoints[index].position;
            Vector4 secondPosition = spline.MainControlPoints[(index + 1) % count].position;

            Vector3 firstBinormal = spline.ControlPointsParameters[index].Binormal;
            Vector3 secondBinormal = spline.ControlPointsParameters[(index + 1) % count].Binormal;

            Vector4 positionLerp = Vector4.Lerp(firstPosition, secondPosition, lerp);
            Vector3 binormalLerp = Vector3.Lerp(firstBinormal, secondBinormal, lerp);

            Vector3 position = positionLerp;

            position += spline.transform.position - waterfall.transform.position;
            position.y += waterfall.BaseProfile.YOffset;

            float step = positionLerp.w / (numberOfPoints - 1);


            for (int j = 0; j < numberOfPoints; j++)
            {
                Vector3 transformPosition = position - binormalLerp * (step * j) + binormalLerp * (positionLerp.w * 0.5f);
                transformPosition.y += waterfall.BaseProfile.YOffset;

                waterfall.NmSpline.AddPoint(transformPosition);
            }
        }

        private bool Along(Waterfall waterfall)
        {
            if (firstPoint > spline.MainControlPoints.Count || lastPoint > spline.MainControlPoints.Count)
                return false;

            waterfall.NmSpline.Clear();

            int count = spline.MainControlPoints.Count;

            float step;
            if (firstPoint < lastPoint)
            {
                step = lastPoint - firstPoint;

                step /= (NumberOfPoints - 1);
            }
            else
            {
                step = spline.MainControlPoints.Count - firstPoint + lastPoint;
                step /= (NumberOfPoints - 1);
            }


            float i = firstPoint;


            for (int j = 0; j < numberOfPoints; j++)
            {
                i %= count;

                NmSplinePoint point = NmSpline.GetMainControlPointDataLerp(spline, i);


                Vector3 positionLerp = point.Position;
                Vector3 binormalLerp = point.Binormal;

                Vector3 transformPosition = positionLerp + spline.transform.position - waterfall.transform.position;

                transformPosition += binormalLerp * (waterfall.BaseProfile.Offset * (Invert ? -1 : 1));


                transformPosition.y += waterfall.BaseProfile.YOffset;


                waterfall.NmSpline.AddPoint(transformPosition);

                i += step;
            }

            return true;
        }

        public void CalculateOffset(Waterfall waterfall)
        {
            waterfall.BaseProfile.Offset = -0.11f * waterfall.BaseProfile.BaseStrength;
        }
    }
}