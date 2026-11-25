// /**
//  * Created by Pawel Homenko on  08/2022
//  */

using UnityEditor;

namespace NatureManufacture.RAM.Editor
{
    public sealed class LakePolygonTips
    {
        public void Tips()
        {
            EditorGUILayout.Space();
            EditorGUILayout.HelpBox(
                "\nReflections - Use box projection in reflection probes to get proper render even at river and lake connection.\n",
                MessageType.Info);
            EditorGUILayout.HelpBox(
                "\nUse low resolution reflection probes, and only around the water. " +
                "\nFar clip planes also should be short, you probably only need colors from the surrounding world.\n",
                MessageType.Info);
            EditorGUILayout.HelpBox(
                "\nPut reflection probes behind, in and after dark area (tunnel, cave) so you will get excellent result in lighting and reflections.\n",
                MessageType.Info);


            EditorGUILayout.Space();
        }
    }
}