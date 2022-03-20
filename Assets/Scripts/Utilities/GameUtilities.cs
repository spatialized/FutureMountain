using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using UnityEngine;

namespace FutureMountain
{
    public static class GameUtilities
    {
        public static GameObject GetRandomPrefabFromList(GameObject[] options)
        {
            int idx = (int)Math.Round((double)UnityEngine.Random.Range(0, options.Length));
            return options[idx];
        }
    }
}
