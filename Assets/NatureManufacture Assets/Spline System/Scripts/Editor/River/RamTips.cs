// /**
//  * Created by Pawel Homenko on  07/2022
//  */

using UnityEditor;

namespace NatureManufacture.RAM.Editor
{
    public sealed class RamTips
    {
        public void Tips()
        {
            EditorGUILayout.Space();
            EditorGUILayout.HelpBox(
                "\nReflections - Use box projection in reflection probes to get proper render even at multiple river connection.\n",
                MessageType.Info);
            EditorGUILayout.HelpBox(
                "\nKeep reasonable quasi- square vertex shapes at river mesh, " +
                "this will give better tesselation result. Don't worry about low amount of poly, tesselation will smooth shapes.\n",
                MessageType.Info);
            EditorGUILayout.HelpBox(
                "\nBy rotating point you could get similar effect as vertex color painting.\n" +
                "You could adjust waterfalls or add noise in the river. " +
                "Note that if rotation will be bigger then +/- 90 degree you could invert normals.\n", MessageType.Info);
            EditorGUILayout.HelpBox(
                "\nUse low resolution reflection probes, and only around the water. " +
                "\nFar clip planes also should be short, you probably only need colors from the surrounding world.\n",
                MessageType.Info);
            EditorGUILayout.HelpBox(
                "\nPut reflection probes behind, in and after dark area (tunnel, cave) so you will get excellent result in lighting and reflections.\n",
                MessageType.Info);
            EditorGUILayout.HelpBox(
                "\nTry to keep quite similar distance between spline points. Huge distance between them could create strange result.\n",
                MessageType.Info);
            EditorGUILayout.HelpBox(
                "\nWhen you use multiple connected rivers, you should put reflection probe at fork of the rivers to keep proper reflections\n",
                MessageType.Info);


            EditorGUILayout.Space();
        }
    }
}