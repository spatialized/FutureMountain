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

    public class ExportSplatmap : MonoBehaviour
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

                    //Debug.Log("alphamap px(10,10):" + tex.GetPixel(10, 10).ToString() + " px(100,100):" + tex.GetPixel(100, 100).ToString());
                    //try
                    //{
                    //    tex = terrainData.terrainLayers[i].maskMapTexture;
                    //    Debug.Log("maskMap px(10,10):" + tex.GetPixel(10, 10).ToString() + " px(100,100):" +
                    //              tex.GetPixel(100, 100).ToString());
                    //}
                    //catch
                    //{
                    //}

                    //// METHOD 1
                    //byte[] pngData = tex.EncodeToPNG();
                    //if (pngData != null)
                    //{
                    //    Debug.Log("Exporting terrain maskMap texture:" + terrain.name+" as fileName:" + fileName + " to png...  tex.name:" + tex.name + " texture count: " + terrainData.alphamapTextureCount);
                    //    File.WriteAllBytes(path + "/" + fileName + "_"+i+".png", pngData);
                    //}
                    //else
                    //{
                    //    Debug.Log("Could not convert " + fileName + " to png. Skipping saving texture.");
                    //}

                    // METHOD 2
                    ExportPNG(tex, fileName, path);
                }
            }

            return path;
        }

        //static public string Export2(Terrain terrain, string fileName, string path)
        //{
        //    //Terrain terrain = Selection.activeObject as Terrain;
        //    if (!terrain)
        //    {
        //        terrain = Terrain.activeTerrain;
        //        if (!terrain)
        //        {
        //            Debug.Log("Could not find any terrain. Please select or create a terrain first.");
        //            return "";
        //        }
        //    }

        //    if (path.Equals(""))
        //        path = EditorUtility.SaveFolderPanel("Choose a directory to save the alpha maps:", "", "");

        //    if (path != null && path.Length != 0)
        //    {
        //        path = path.Replace(Application.dataPath, "Assets");
        //        TerrainData terrainData = terrain.terrainData;
        //        int alphaMapsCount = terrainData.alphamapTextureCount;

        //        for (int i = 0; i < alphaMapsCount; i++)
        //        {
        //            Texture2D tex = terrainData.GetAlphamapTexture(i);
        //            //Debug.Log("px(10,10):" + tex.GetPixel(10, 10).ToString()+" px(100,100):" + tex.GetPixel(100, 100).ToString());

        //            byte[] pngData = tex.EncodeToPNG();
        //            if (pngData != null)
        //            {
        //                Debug.Log("Exporting terrain:" + terrain.name + " as fileName:" + fileName + " to png...  tex.name:" + tex.name + " texture count: " + terrainData.alphamapTextureCount);
        //                File.WriteAllBytes(path + "/" + fileName + "_" + i + ".png", pngData);
        //            }
        //            else
        //            {
        //                Debug.Log("Could not convert " + fileName + " to png. Skipping saving texture.");
        //            }
        //        }
        //    }

        //    return path;
        //}

        // https://stuff.mattgadient.com/download/SplatmapHelper.js
        static public void ExportPNG(Texture2D texture1, string fileName, string path)
        {
            var texture = Instantiate(texture1) as Texture2D;
            var textureColors = texture.GetPixels();
            for (int i = 0; i < textureColors.Length; i++) {
                textureColors[i].a = 1;
            }

            texture.SetPixels(textureColors);
            texture.Apply();

            if (texture.format != TextureFormat.ARGB32 && texture.format != TextureFormat.RGB24)
            {
                var newTexture = new Texture2D(texture.width, texture.height);
                newTexture.SetPixels(texture.GetPixels(0), 0);
                texture = newTexture;
            }

            var bytes = texture.EncodeToPNG();
            File.WriteAllBytes(path + "/" + fileName + ".png", bytes);
            //AssetDatabase.Refresh();
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
