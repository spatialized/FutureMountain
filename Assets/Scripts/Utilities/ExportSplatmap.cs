using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Assets.Scripts.Utilities
{
    using System.IO;
    using UnityEditor;
    using UnityEngine;

    public class ExportSplatmap
    {
        //[MenuItem("Terrain/Export Splatmap...")]
        static public string Export(Terrain terrain, string fileName, string path)
        {
            //Terrain terrain = Selection.activeObject as Terrain;
            if (!terrain)
            {
                terrain = Terrain.activeTerrain;
                if (!terrain)
                {
                    Debug.Log("Could not find any terrain. Please select or create a terrain first.");
                    return "";
                }
            }

            if(path.Equals(""))
               path = EditorUtility.SaveFolderPanel("Choose a directory to save the alpha maps:", "", "");

            if (path != null && path.Length != 0)
            {
                path = path.Replace(Application.dataPath, "Assets");
                TerrainData terrainData = terrain.terrainData;
                int alphaMapsCount = terrainData.alphamapTextureCount;

                for (int i = 0; i < alphaMapsCount; i++)
                {
                    Texture2D tex = terrainData.GetAlphamapTexture(i);
                    byte[] pngData = tex.EncodeToPNG();
                    if (pngData != null)
                    {
                        Debug.Log("Exporting " + fileName + " to png... texture count: "+ terrainData.alphamapTextureCount);
                        File.WriteAllBytes(path + "/" + fileName + "_"+i+".png", pngData);
                    }
                    else
                    {
                        Debug.Log("Could not convert " + fileName + " to png. Skipping saving texture.");
                    }
                }
            }

            return path;
        }

        //static public string ExportSplat(float[,,] splatMap, string fileName, string path)
        //{
        //    //Terrain terrain = Selection.activeObject as Terrain;
        //    //if (!splatMap)
        //    //{
        //    //    terrain = Terrain.activeTerrain;
        //    //    if (!terrain)
        //    //    {
        //    //        Debug.Log("Could not find any terrain. Please select or create a terrain first.");
        //    //        return "";
        //    //    }
        //    //}

        //    if (path.Equals(""))
        //        path = EditorUtility.SaveFolderPanel("Choose a directory to save the alpha maps:", "", "");

        //    if (path != null && path.Length != 0)
        //    {
        //        path = path.Replace(Application.dataPath, "Assets");
        //        //TerrainData terrainData = terrain.terrainData;
        //        //int alphaMapsCount = terrainData.alphamapTextureCount;

        //        for (int i = 0; i < 3; i++)
        //        {
        //            Texture2D tex = terrainData.GetAlphamapTexture(i);
        //            byte[] pngData = tex.EncodeToPNG();
        //            if (pngData != null)
        //            {
        //                Debug.Log("Exporting " + fileName + " to png...");
        //                File.WriteAllBytes(path + "/" + fileName + ".png", pngData);
        //            }
        //            else
        //            {
        //                Debug.Log("Could not convert " + fileName + " to png. Skipping saving texture.");
        //            }
        //        }
        //    }

        //    return path;
        //}
    }
}
