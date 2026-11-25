using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;


namespace NatureManufacture.RAM
{
    public class TextureManager : MonoBehaviour
    {
        public static Texture2D ToTexture2D(RenderTexture rTex, TextureFormat format, Texture2D oldTexture = null)
        {
            if (!oldTexture || oldTexture.width != rTex.width || oldTexture.height != rTex.height || oldTexture.format != format)
                oldTexture = new Texture2D(rTex.width, rTex.height, format, false);

            RenderTexture temp = RenderTexture.GetTemporary(rTex.width, rTex.height, rTex.depth, rTex.format);

            Graphics.Blit(rTex, temp);


            var currentActiveRT = RenderTexture.active;
            RenderTexture.active = temp;

            oldTexture.ReadPixels(new Rect(0, 0, rTex.width, rTex.height), 0, 0);
            oldTexture.Apply();

            RenderTexture.active = currentActiveRT;

            RenderTexture.ReleaseTemporary(temp);
            return oldTexture;
        }

        public static Texture2D TempToTexture2D(RenderTexture rTex, TextureFormat format, Texture2D oldTexture = null)
        {
            RenderTexture temp = RenderTexture.GetTemporary(rTex.width, rTex.height, 0, rTex.format);
            Graphics.Blit(rTex, temp);
            oldTexture = ToTexture2D(temp, format, oldTexture);

            RenderTexture.ReleaseTemporary(temp);

            return oldTexture;
        }

        public static void SaveTexture(RenderTexture texture, TextureFormat format, string suffix = "")
        {
            SaveTexture(ToTexture2D(texture, format), suffix);
        }

        public static void SaveTexture(Texture2D texture, string suffix = "")
        {
            byte[] bytes = texture.EncodeToPNG();
            var dirPath = Application.dataPath + "/RenderOutput";
            if (!System.IO.Directory.Exists(dirPath))
            {
                System.IO.Directory.CreateDirectory(dirPath);
            }

            System.IO.File.WriteAllBytes(dirPath + "/R_" + DateTime.Now.ToString("yyMMddhhmmss") + "_" + suffix + ".png", bytes);
            Debug.Log(bytes.Length / 1024 + "Kb was saved as: " + dirPath);
#if UNITY_EDITOR
            UnityEditor.AssetDatabase.Refresh();
#endif
        }
    }
}