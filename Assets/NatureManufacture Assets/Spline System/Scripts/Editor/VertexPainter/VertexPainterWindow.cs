using UnityEditor;
using UnityEngine;

namespace NatureManufacture.RAM.Editor
{
    public sealed class VertexPainterWindow : EditorWindow
    {
        private VertexPainterEditor<MeshFilter> VertexPainterEditor { get; set; }


        [MenuItem("Tools/Nature Manufacture/Vertex Painter")]
        private static void Init()
        {
            // Get existing open window or if none, make a new one:
            VertexPainterWindow window = GetWindow<VertexPainterWindow>("VertexPainter");
            window.VertexPainterEditor = new VertexPainterEditor<MeshFilter>(new VertexPainterData(false), false);
            window.Show();
        }

        private void OnGUI()
        {
            VertexPainterEditor.UIPainter();
        }


        private void OnEnable()
        {
            VertexPainterEditor ??= new VertexPainterEditor<MeshFilter>(new VertexPainterData(false), false);
            SceneView.duringSceneGui -= OnSceneGUI;
            SceneView.duringSceneGui += OnSceneGUI;
        }

        private void OnSceneGUI(SceneView obj)
        {
            VertexPainterEditor.OnSceneGUI(obj);
        }

        private void OnDestroy()
        {
            SceneView.duringSceneGui -= OnSceneGUI;

            if (VertexPainterEditor.VertexPainterData.Drawing) VertexPainterEditor.StopDrawing();
        }
    }
}