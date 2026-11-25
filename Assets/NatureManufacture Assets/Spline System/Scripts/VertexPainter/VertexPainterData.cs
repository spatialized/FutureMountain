// /**
//  * Created by Pawel Homenko on  08/2022
//  */

using System;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Serialization;
using Debug = System.Diagnostics.Debug;

namespace NatureManufacture.RAM
{
    [Serializable]
    public class VertexPainterData
    {
        [SerializeField] private bool alwaysDrawing;
        [SerializeField] private bool drawing;
        [SerializeField] private bool showVertexColors;
        [SerializeField] private bool showFlowMap;
        [SerializeField] private int toolbarInt = 0;
        [SerializeField] private int flowToolSelected = 0;
        [SerializeField] private Color drawColor = Color.black;
        [SerializeField] private float drawSize = 10f;
        [SerializeField] [Range(0, 1)] private float drawBlendSize = 0.5f;
        [SerializeField] private float opacity = 0.1f;
        [SerializeField] private float speedMultiplier = 1f;
        [SerializeField] private bool drawColorR = true;
        [SerializeField] private bool drawColorG = true;
        [SerializeField] private bool drawColorB = true;
        [SerializeField] private bool drawColorA = true;
        [SerializeField] private float flowSpeed = 1f;
        [SerializeField] private float flowDirection;
        [SerializeField] private bool drawOnMultiple;
        [SerializeField] private float height = 0.1f;

        [SerializeField] private bool overridenColors;
        [SerializeField] private bool overridenFlow;
        [SerializeField] private bool overridenVertexHeight;

        [SerializeField] private GameObject currentDrawObject;
        [SerializeField] private List<MeshFilter> meshFilters = new();
        [SerializeField] private List<MeshRenderer> meshRenderers = new();
        [SerializeField] private List<Material> oldMaterials = new();

        public VertexPainterData(bool alwaysDrawing)
        {
            this.alwaysDrawing = alwaysDrawing;
        }

        private string[] _toolbarStrings =
        {
            "Vertex Color",
            "Flow Map",
            "Vertex Height"
        };

        private string[] _flowToolbarStrings =
        {
            "Direction",
            "Attraction",
            "Repulsion",
            "Smudge"
        };

        public bool AlwaysDrawing
        {
            get => alwaysDrawing;
            set => alwaysDrawing = value;
        }

        public string[] ToolbarStrings
        {
            get
            {
                return _toolbarStrings ??= new string[]
                {
                    "Vertex Color",
                    "Flow Map"
                };
            }
        }

        public string[] FlowToolbarStrings
        {
            get
            {
                return _flowToolbarStrings ??= new string[]
                {
                    "Direction",
                    "Attraction",
                    "Repulsion",
                    "Smudge"
                };
            }
        }

        public bool Drawing
        {
            get => drawing;
            set => drawing = value;
        }

        public bool ShowVertexColors
        {
            get => showVertexColors;
            set => showVertexColors = value;
        }

        public bool ShowFlowMap
        {
            get => showFlowMap;
            set => showFlowMap = value;
        }

        public int ToolbarInt
        {
            get => toolbarInt;
            set => toolbarInt = value;
        }

        public int FlowToolSelected
        {
            get => flowToolSelected;
            set => flowToolSelected = value;
        }

        public Color DrawColor
        {
            get => drawColor;
            set => drawColor = value;
        }

        public float DrawSize
        {
            get => drawSize;
            set => drawSize = value;
        }

        public float Opacity
        {
            get => opacity;
            set => opacity = value;
        }

        public bool DrawColorR
        {
            get => drawColorR;
            set => drawColorR = value;
        }

        public bool DrawColorG
        {
            get => drawColorG;
            set => drawColorG = value;
        }

        public bool DrawColorB
        {
            get => drawColorB;
            set => drawColorB = value;
        }

        public bool DrawColorA
        {
            get => drawColorA;
            set => drawColorA = value;
        }

        public float FlowSpeed
        {
            get => flowSpeed;
            set => flowSpeed = value;
        }

        public float FlowDirection
        {
            get => flowDirection;
            set => flowDirection = value;
        }

        public GameObject CurrentDrawObject
        {
            get => currentDrawObject;
            set => currentDrawObject = value;
        }

        public List<MeshFilter> MeshFilters
        {
            get => meshFilters;
            set => meshFilters = value;
        }

        public List<Material> OldMaterials
        {
            get => oldMaterials;
            set => oldMaterials = value;
        }

        public bool OverridenFlow
        {
            get => overridenFlow;
            set => overridenFlow = value;
        }

        public bool OverridenColors
        {
            get => overridenColors;
            set => overridenColors = value;
        }

        public List<MeshRenderer> MeshRenderers
        {
            get => meshRenderers;
            set => meshRenderers = value;
        }

        public bool DrawOnMultiple
        {
            get => drawOnMultiple;
            set => drawOnMultiple = value;
        }

        public float DrawBlendSize
        {
            get => drawBlendSize;
            set => drawBlendSize = value;
        }

        public float SpeedMultiplier
        {
            get => speedMultiplier;
            set => speedMultiplier = value;
        }

        public bool OverridenVertexHeight
        {
            get => overridenVertexHeight;
            set => overridenVertexHeight = value;
        }

        public float Height
        {
            get => height;
            set => height = value;
        }

        
    }
}