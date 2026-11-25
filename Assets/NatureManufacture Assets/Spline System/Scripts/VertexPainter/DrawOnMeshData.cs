// /**
//  * Created by Pawel Homenko on  08/2022
//  */

using System;
using System.Collections.Generic;
using UnityEngine;

namespace NatureManufacture.RAM
{
    [Serializable]
    public class DrawOnMeshData
    {
        [SerializeField] private int flowToolSelected;


        [SerializeField] private bool showVertexColors;
        [SerializeField] private bool showFlowMap;
        [SerializeField] private bool overrideFlowMap;
        [SerializeField] private bool overrideColors;
        [SerializeField] private bool drawOnMesh;
        [SerializeField] private bool drawOnMeshFlowMap;
        [SerializeField] private Color drawColor = Color.black;
        [SerializeField] private bool drawColorR = true;
        [SerializeField] private bool drawColorG = true;
        [SerializeField] private bool drawColorB = true;
        [SerializeField] private bool drawColorA = true;
        [SerializeField] private bool drawOnMultiple;
        [SerializeField] private float opacity = 0.1f;
        [SerializeField] private float drawSize = 1f;
        [SerializeField] private Material oldMaterial;
        [SerializeField] private float flowSpeed = 1f;
        [SerializeField] private float flowDirection;

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

        public bool OverrideFlowMap
        {
            get => overrideFlowMap;
            set => overrideFlowMap = value;
        }

        public bool DrawOnMesh
        {
            get => drawOnMesh;
            set => drawOnMesh = value;
        }

        public bool DrawOnMeshFlowMap
        {
            get => drawOnMeshFlowMap;
            set => drawOnMeshFlowMap = value;
        }

        public Color DrawColor
        {
            get => drawColor;
            set => drawColor = value;
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

        public bool DrawOnMultiple
        {
            get => drawOnMultiple;
            set => drawOnMultiple = value;
        }

        public float Opacity
        {
            get => opacity;
            set => opacity = value;
        }

        public float DrawSize
        {
            get => drawSize;
            set => drawSize = value;
        }

        public Material OldMaterial
        {
            get => oldMaterial;
            set => oldMaterial = value;
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

        public int FlowToolSelected
        {
            get => flowToolSelected;
            set => flowToolSelected = value;
        }

        public bool OverrideColors
        {
            get => overrideColors;
            set => overrideColors = value;
        }
    }
}