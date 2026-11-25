// /**
//  * Created by Pawel Homenko on  12/2023
//  */

using UnityEngine;

namespace NatureManufacture.RAM
{
    public class LakeVertexColorGenerator
    {
        private LakePolygon _lakePolygon;

        public LakeVertexColorGenerator(LakePolygon lakePolygon)
        {
            _lakePolygon = lakePolygon;
        }

        public void GenerateVertexColor(Color[] colors, int vertCount, LakePolygon lakePolygon)
        {
            for (int i = 0; i < vertCount; i++)
            {
                RamMath.MinimumDistanceVector minimumDistanceVector = lakePolygon.MinimumDistanceVectors[i];
                float red = _lakePolygon.BaseProfile.redColorCurve.Evaluate(minimumDistanceVector.Distance);
                float green = _lakePolygon.BaseProfile.greenColorCurve.Evaluate(minimumDistanceVector.Distance);
                float blue = _lakePolygon.BaseProfile.blueColorCurve.Evaluate(minimumDistanceVector.Distance);
                float alpha = _lakePolygon.BaseProfile.alphaColorCurve.Evaluate(minimumDistanceVector.Distance);

                colors[i] = new Color(red, green, blue, alpha);
            }
        }
    }
}