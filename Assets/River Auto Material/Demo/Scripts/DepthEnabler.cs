using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Serialization;

[ExecuteInEditMode]
public class DepthEnabler : MonoBehaviour
{
    [SerializeField] private Camera mainCamera;

    private void OnEnable()
    {
        CheckDepthTextureMode();
    }


    private void Awake()
    {
        CheckDepthTextureMode();
    }

    private void CheckDepthTextureMode()
    {
        if (mainCamera == null)
        {
            mainCamera = GetComponent<Camera>();
        }

        if (mainCamera.actualRenderingPath == RenderingPath.DeferredShading)
            return;


        if (mainCamera.depthTextureMode == DepthTextureMode.None)
        {
            mainCamera.depthTextureMode = DepthTextureMode.Depth;
        }
    }
}