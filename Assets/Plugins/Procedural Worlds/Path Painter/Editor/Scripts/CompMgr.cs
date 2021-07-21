// Copyright © 2018 Procedural Worlds Pty Limited.  All Rights Reserved.
#if UNITY_EDITOR
using System.Collections.Generic;
using System.IO;
using UnityEditor;

namespace PathPainter
{
    internal class CompMgr
    {
        // TODO: get these from config
        public const string DLL_KEY = "h8i493ZcWPaY0FUgQmhYfrVilSvFkq5X"; //check this in config
        private const string DNAME = "Pptr";
        private const string DEXT = ".pp";

        private static string ms_f;

        [InitializeOnLoadMethod]
        static void Onload()
        {
            if (NC())
            {
                return;
            }

            // Need to wait for things to import before creating the common menu - Using delegates and only check menu when something gets imported
            AssetDatabase.importPackageCompleted -= OnImportPackageCompleted;
            AssetDatabase.importPackageCompleted += OnImportPackageCompleted;

            AssetDatabase.importPackageCancelled -= OnImportPackageCancelled;
            AssetDatabase.importPackageCancelled += OnImportPackageCancelled;

            AssetDatabase.importPackageFailed -= OnImportPackageFailed;
            AssetDatabase.importPackageFailed += OnImportPackageFailed;
        }

        /// <summary>
        /// Called when a package import is Completed.
        /// </summary>
        private static void OnImportPackageCompleted(string packageName)
        {
            OnPackageImport();
        }

        /// <summary>
        /// Called when a package import is Cancelled.
        /// </summary>
        private static void OnImportPackageCancelled(string packageName)
        {
            OnPackageImport();
        }

        /// <summary>
        /// Called when a package import fails.
        /// </summary>
        private static void OnImportPackageFailed(string packageName, string error)
        {
            OnPackageImport();
        }

        /// <summary>
        /// Used to run things after a package was imported.
        /// </summary>
        private static void OnPackageImport()
        {
            // No need for these anymore
            AssetDatabase.importPackageCompleted -= OnImportPackageCompleted;
            AssetDatabase.importPackageCancelled -= OnImportPackageCancelled;
            AssetDatabase.importPackageFailed -= OnImportPackageFailed;

            M();
        }

        private static void F()
        {

#if !PW_DEV
            UnityEngine.Debug.LogError("Files are corrupt or missing. Please Reimport Path Painter.");
#endif
        }

        private static bool M()
        {
            if (C())
            {
                return true;
            }

            G();
            if (string.IsNullOrEmpty(ms_f))
            {
                return false;
            }

            R(ms_f);
#if !PW_REL
            string f = ms_f.Replace("Editor/", "");
            AssetDatabase.DeleteAsset(f + "Path Painter.dll");
            if (!AssetDatabase.CopyAsset(f + DNAME + ms_t + DEXT, f + "Path Painter.dll"))
            {
                EditorUtility.DisplayDialog("Path Painter",
                    "\nPath Painter was not completely imported.\n\n" +
                    "You can try right-click -> \"Reimport\" once Unity completes importing and compiling.\n\n" +
                    "Please contact support with your invoice number if this message keeps popping up.\n\n", "Ok");
                return false;
            }
            string p = ms_f + DNAME + ms_t + "e";
            MV(p + DEXT, p + ".dll");
#endif
            return true;
        }

        private static bool NC()
        {
            if (OE())
            {
                return true;
            }
#if !NET_4_6
            ms_t += "3";
#endif
            string f = DNAME + ms_t + "e";
            string x = ".dll";

            string p = P(f, f + x);
            if (string.IsNullOrEmpty(p))
            {
                M();
                return true;
            }

            ms_f = p.Replace(f + x, "");
            return false;
        }

        private static void R(string f)
        {
            DirectoryInfo dirInfo = new DirectoryInfo(f);
            if (!dirInfo.Exists)
            {
                return;
            }

            FileInfo[] files = dirInfo.GetFiles(DNAME + "*.dll");
            foreach (var file in files)
            {
                string d = file.Name.Replace(".dll", DEXT);
                FileInfo[] dfiles = dirInfo.GetFiles(d);
                if (dfiles.Length > 0)
                {
                    dfiles[0].CopyTo(file.FullName, true);
                    AssetDatabase.DeleteAsset(f + d);
                }
                MV(f + file.Name, f + d);
            }
        }

        private static void MV(string ofn, string nfn)
        {
            AssetDatabase.MoveAsset(ofn, nfn);
        }

        private static void G()
        {
            if (string.IsNullOrEmpty(ms_f))
            {
                string f = DNAME + "jhce";
                string x = DEXT;

                string p = P(f, f + x);
                if (!string.IsNullOrEmpty(p))
                {
                    ms_f = p.Replace(f + x, "");
                    return;
                }
            }
        }

        private static bool OE()
        {
            string[] ends = new string[] { "/Editor/Pptrjhc.pp", "/Editor/Pptrjhc.dll",
                "Path Painter 1.0.0 U5.dll", "Path Painter 1.0.0 U5.dll.pp" };
            foreach (var path in AssetDatabase.GetAllAssetPaths())
            {
                foreach (string end in ends)
                {
                    if (path.EndsWith(end))
                    {
                        return true;
                    }
                }
            }
            return false;
        }

        public static string P(string fn, string f)
        {
            string[] a = AssetDatabase.FindAssets(fn, null);
            for (int i = 0; i < a.Length; i++)
            {
                string p = AssetDatabase.GUIDToAssetPath(a[i]);
                if (Path.GetFileName(p) == f)
                {
                    return p;
                }
            }
            return "";
        }

#if UNITY_5
        private static string ms_t = "e";
#elif UNITY_2017
        private static string ms_t = "jg";
#elif UNITY_2018_2 || UNITY_2018_1
        private static string ms_t = "jh";
#else
        private static string ms_t = "jhc";
#endif

        private static bool C()
        {
#if !PW_REL
            string[] i = new string[]
            {
                "ee",
                "jge",
                "jhe",
                "jhce",
                "e3e",
                "jg3e",
                "jh3e",
                "jhc3e",
            };

            HashSet<string> w = new HashSet<string>();
            HashSet<string> b = new HashSet<string>();

            string t = ms_t + "e";
            foreach (string a in i)
            {
                if (a != t)
                {
                    w.Add(DNAME + a + DEXT);
                    b.Add(DNAME + a + ".dll");
                }
            }
            w.Add(DNAME + t + ".dll");
            b.Add(DNAME + t + DEXT);

            foreach (string p in AssetDatabase.GetAllAssetPaths())
            {
                string f = Path.GetFileName(p);
                if (w.Contains(f))
                {
                    w.Remove(f);
                    ms_f = p.Replace(f, "");
                }

                if (b.Contains(f))
                {
                    return false;
                }
            }

            return w.Count < 1;
#else
            return false;
#endif
        }
    }
}
#endif
