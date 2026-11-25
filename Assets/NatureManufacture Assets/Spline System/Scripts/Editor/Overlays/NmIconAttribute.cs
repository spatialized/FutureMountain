namespace NatureManufacture.RAM
{
    using System;
    using System.Diagnostics;
    using UnityEditor;
    using UnityEngine;
    using Debug = UnityEngine.Debug;

    [AttributeUsage(AttributeTargets.Class, Inherited = true, AllowMultiple = false)]
    [Conditional("UNITY_EDITOR")]
    public class NmIconAttribute : IconAttribute
    {
        public NmIconAttribute(string name) : base(GetRelativeIconPath(name))
        {
        }

        public static string GetRelativeIconPath(string name)
        {
            string[] guids = AssetDatabase.FindAssets(name);

            return guids.Length <= 0 ? "" : AssetDatabase.GUIDToAssetPath(guids[0]);
        }
    }
}