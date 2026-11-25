using System;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Rendering;

namespace NatureManufacture.Underwater
{
    public class UnderwaterMaterialManager : MonoBehaviour
    {

        [Serializable]
        public class ShaderEnum
        {
            public string name;
            public List<string> referenceSuffixes;
        }
        
        [SerializeField] private float materialChangeSpeed = 2f;
        [SerializeField] private Material lerpUnderwaterMaterial;
        private Material _underwaterMaterial;

        [Tooltip("These properties will be copied from the new underwater material to the lerp material when the material changes. " +
                 "This is needed to prevent visual glitches when changing underwater materials with different values of these properties.")]
        [SerializeField]
        private List<string> floatPropertiesToSet = new()
        {
            "_Caustic_Speed",
            "_Caustic_Tiling"
        };


        [SerializeField] private List<string> texturePropertiesToSet = new();

        [SerializeField] private List<string> keywordsToSync = new()
        {
            "_USE_DISTORTION",
            "_USE_CAUSTIC",
            "_USE_DROPLETS",
            "_USE_WATERLINE_BLUR",
            "_USE_SIMPLE_FOG"
        };

        [SerializeField] private List<ShaderEnum> shaderEnums = new();

        public void CheckMaterial(LayerMask waterLayer, Vector3 rayPosition, Vector3 cameraPosition)
        {
            if (!enabled)
                return;

            if (!lerpUnderwaterMaterial)
                return;

            var ray = new Ray(rayPosition, Vector3.down);
            RaycastHit[] results = new RaycastHit[100];
            int size = Physics.RaycastNonAlloc(ray, results, Mathf.Infinity, waterLayer);
            if (size == 0) return;

            //find colliderMaterialData that has highest priority and is lowest
            UnderwaterMaterialData colliderMaterialData = FindColliderMaterialData(cameraPosition, size, results);

            if (!colliderMaterialData || !colliderMaterialData.enabled) return;

            if (_underwaterMaterial != colliderMaterialData.UnderwaterMaterial)
            {
                //Debug.Log($"{colliderMaterialData.gameObject.name} {colliderMaterialData.Priority} {colliderMaterialData.transform.position.y} {cameraPosition.y}");

                if (lerpUnderwaterMaterial.shader != colliderMaterialData.UnderwaterMaterial.shader)
                    lerpUnderwaterMaterial.shader = colliderMaterialData.UnderwaterMaterial.shader;


                materialChangeSpeed = colliderMaterialData.MaterialChangeSpeed;


                _underwaterMaterial = colliderMaterialData.UnderwaterMaterial;

                foreach (string setFloatProperty in floatPropertiesToSet)
                {
                    if (lerpUnderwaterMaterial.HasFloat(setFloatProperty) && _underwaterMaterial.HasFloat(setFloatProperty))
                        lerpUnderwaterMaterial.SetFloat(setFloatProperty, _underwaterMaterial.GetFloat(setFloatProperty));
                }

                foreach (string setTextureProperty in texturePropertiesToSet)
                {
                    if (lerpUnderwaterMaterial.HasTexture(setTextureProperty) && _underwaterMaterial.HasTexture(setTextureProperty))
                        lerpUnderwaterMaterial.SetTexture(setTextureProperty, _underwaterMaterial.GetTexture(setTextureProperty));
                }
            }

            foreach (string keyword in keywordsToSync)
            {
                SetKeyword(keyword);
            }

            foreach (ShaderEnum shaderEnum in shaderEnums)
            {
                if (shaderEnum == null || string.IsNullOrEmpty(shaderEnum.name))
                    continue;
                
                if (shaderEnum.referenceSuffixes == null)
                    continue;

                foreach (string suffix in shaderEnum.referenceSuffixes)
                {
                    if (string.IsNullOrEmpty(suffix))
                        continue;

                    string keyword = $"{shaderEnum.name}_{suffix}";
                    SetKeyword(keyword);
                }
            }
            

            lerpUnderwaterMaterial.Lerp(lerpUnderwaterMaterial, _underwaterMaterial, materialChangeSpeed * Time.deltaTime);
        }

        private static UnderwaterMaterialData FindColliderMaterialData(Vector3 cameraPosition, int size, RaycastHit[] results)
        {
            UnderwaterMaterialData colliderMaterialData = null;
            UnderwaterMaterialData colliderMaterialDataOther = null;
            for (int i = 0; i < size; i++)
            {
                if (colliderMaterialData == null || !colliderMaterialData.enabled)
                    colliderMaterialData = results[i].collider.GetComponent<UnderwaterMaterialData>();
                else
                {
                    colliderMaterialDataOther = results[i].collider.GetComponent<UnderwaterMaterialData>();

                    if (colliderMaterialData == colliderMaterialDataOther) continue;

                    //Debug.Log($"{colliderMaterialDataOther.gameObject.name} {colliderMaterialDataOther.Priority} {colliderMaterialDataOther.transform.position.y < cameraPosition.y}");
                    if (colliderMaterialDataOther == null || !colliderMaterialData.enabled || colliderMaterialDataOther.transform.position.y < cameraPosition.y) continue;

                    //Debug.Log($"{colliderMaterialData.Priority < colliderMaterialDataOther.Priority} {colliderMaterialData.transform.position.y > colliderMaterialDataOther.transform.position.y} ");
                    if (colliderMaterialData.Priority < colliderMaterialDataOther.Priority || 
                        colliderMaterialData.Priority == colliderMaterialDataOther.Priority && colliderMaterialData.transform.position.y > colliderMaterialDataOther.transform.position.y)
                    {
                        colliderMaterialData = colliderMaterialDataOther;
                    }
                }
            }

            return colliderMaterialData;
        }

        private void SetKeyword(string keyword)
        {
            if (_underwaterMaterial.IsKeywordEnabled(keyword))
                lerpUnderwaterMaterial.EnableKeyword(keyword);
            else
                lerpUnderwaterMaterial.DisableKeyword(keyword);
        }
    }
}