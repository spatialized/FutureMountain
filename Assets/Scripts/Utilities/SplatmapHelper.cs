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

    public class SplatmapHelper : MonoBehaviour
    {
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

                Debug.Log("Export()... terrainData.alphamapTextureCount:" + terrainData.alphamapTextureCount);

                for (int i = 0; i < alphaMapsCount; i++)
                {
                    Texture2D tex = terrainData.GetAlphamapTexture(i);
                    ExportPNG(tex, fileName + (alphaMapsCount > 1 ? "_" + i : ""), path);
                }
            }

            return path;
        }
        
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

            // Normal texture format is ARGB32
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

        // -- TO DO: IMPOSSIBLE?
        //static public bool SetTerrainAlphamapFromTexture(Terrain terrain, Texture2D texture)
        //{
        //    if (!terrain)
        //    {
        //        terrain = Terrain.activeTerrain;
        //        if (!terrain)
        //        {
        //            Debug.Log("Could not find any terrain. Please select or create a terrain first.");
        //            return false;
        //        }
        //    }

        //    if (texture == null)
        //        return false;
           
        //    TerrainData terrainData = terrain.terrainData;
        //    int alphaMapsCount = terrainData.alphamapTextureCount;

        //    for (int i = 0; i < alphaMapsCount; i++)
        //    {
        //        Texture2D tex = terrainData.GetAlphamapTexture(i);
        //        ExportPNG(tex, fileName, path);
        //    }

        //    return false;
        //}

        static public Texture2D ImportPNG(string filePath)
        {
            Debug.Log(filePath);

            if (filePath == "") return null;

            var rawData = System.IO.File.ReadAllBytes(filePath);
            Texture2D tex = new Texture2D(512, 512); 
            tex.LoadImage(rawData);

            return tex;
        }
    }
}
