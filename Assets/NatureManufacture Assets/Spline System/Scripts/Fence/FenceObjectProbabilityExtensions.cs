using System.Collections;
using System.Collections.Generic;
using UnityEngine;

namespace NatureManufacture.RAM
{
    public static class FenceObjectProbabilityExtensions
    {
        public static FenceObjectProbability GetRandomFromList(this List<FenceObjectProbability> objectProbabilities)
        {
            float probabilitySum = 0;
            for (int i = 0; i < objectProbabilities.Count; i++)
            {
                probabilitySum += objectProbabilities[i].probability;
            }

            float random = Random.Range(0, probabilitySum);

            for (int i = 0; i < objectProbabilities.Count; i++)
            {
                random -= objectProbabilities[i].probability;
                if (random < 0)
                    return objectProbabilities[i];
            }

            return objectProbabilities[0];
        }
    }
}