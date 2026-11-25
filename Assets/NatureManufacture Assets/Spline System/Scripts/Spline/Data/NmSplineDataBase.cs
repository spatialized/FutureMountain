using System.Collections;
using System.Collections.Generic;
using UnityEngine;

namespace NatureManufacture.RAM
{
    public abstract class NmSplineDataBase : MonoBehaviour
    {

        
        public abstract void CalculatePoint(int pointIndex, int nextPointIndex, float lerp);


        public abstract void ClearPointsData();


        public abstract void GenerateMainControlPointsData(int index);

        public abstract void AddPointAtEnd();
        
        public abstract void AddPointAfter(int index);
        
        public abstract void RemoveAllData();
        
        public abstract void RemoveData(int index);
        
        public abstract void RemoveDataFrom(int fromIndex);
        
        public abstract void RemoveLastData();
        
        public abstract void ReverseData();
        
        public abstract void ShowUI(int index);


        public abstract void ClearSearchData();
        public abstract void AddSearchData(float lengthToFind, float lerpValue, int firstIndex, int secondIndex);
    }

}