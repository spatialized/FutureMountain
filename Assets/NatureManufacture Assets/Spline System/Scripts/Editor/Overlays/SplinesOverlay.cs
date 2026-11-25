namespace NatureManufacture.RAM
{
    using NatureManufacture.RAM.Editor;
    using UnityEditor;
    using UnityEditor.Overlays;
    using UnityEditor.Toolbars;
    using UnityEngine;

    [Overlay(typeof(SceneView), "NM Spline Tools")]
    [NmIcon("logoRAMNoText")]
    public class SplinesOverlay : ToolbarOverlay
    {
        //private SplinesOverlay() : base(AddRiverButton.ID, AddLakeButton.ID, AddFenceButton.ID)
        private SplinesOverlay() : base(AddRiverButton.ID, AddLakeButton.ID, AddFenceButton.ID, AddWaterfallButton.ID)
        {
        }


        [EditorToolbarElement(ID, typeof(SceneView))]
        private class AddRiverButton : EditorToolbarButton
        {
            public const string ID = "NM Spline Tools/River";

            public AddRiverButton()
            {
                this.text = "";
                this.icon = AssetDatabase.LoadAssetAtPath<Texture2D>(NmIconAttribute.GetRelativeIconPath("riverRAM"));
                this.tooltip = "Add river to scene";
                this.clicked += OnClick;
            }


            void OnClick()
            {
                RamSplineEditor.CreateSpline();
            }
        }

        [EditorToolbarElement(ID, typeof(SceneView))]
        private class AddLakeButton : EditorToolbarButton
        {
            public const string ID = "NM Spline Tools/Lake";

            public AddLakeButton()
            {
                this.text = "";
                this.icon = AssetDatabase.LoadAssetAtPath<Texture2D>(NmIconAttribute.GetRelativeIconPath("lakeRAM"));
                this.tooltip = "Add lake to scene";
                this.clicked += OnClick;
            }

            void OnClick()
            {
                LakePolygonEditor.CreateLakePolygon();
            }
        }


        [EditorToolbarElement(ID, typeof(SceneView))]
        private class AddFenceButton : EditorToolbarButton
        {
            public const string ID = "NM Spline Tools/Fence";

            public AddFenceButton()
            {
                this.text = "";
                this.icon = AssetDatabase.LoadAssetAtPath<Texture2D>(NmIconAttribute.GetRelativeIconPath("fenceRAM"));
                this.tooltip = "Add fence to scene";
                this.clicked += OnClick;
            }

            void OnClick()
            {
                FenceGeneratorEditor.CreateFenceGenerator();
            }
        }

        //Toolbar element for waterfall
        [EditorToolbarElement(ID, typeof(SceneView))]
        private class AddWaterfallButton : EditorToolbarButton
        {
            public const string ID = "NM Spline Tools/Waterfall";

            public AddWaterfallButton()
            {
                this.text = "";
                this.icon = AssetDatabase.LoadAssetAtPath<Texture2D>(NmIconAttribute.GetRelativeIconPath("waterfallRAM"));
                this.tooltip = "Add waterfall to scene";
                this.clicked += OnClick;
            }

            void OnClick()
            {
                WaterfallEditor.CreateWaterfall();
            }
        }
        
    }
}