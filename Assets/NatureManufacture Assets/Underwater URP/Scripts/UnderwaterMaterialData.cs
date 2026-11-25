using UnityEngine;

namespace NatureManufacture.Underwater
{
    public class UnderwaterMaterialData : MonoBehaviour
    {
        [SerializeField] private Material underwaterMaterial;
        [SerializeField] private float materialChangeSpeed = 2f;
        [SerializeField] private int priority = 1;
        

        public Material UnderwaterMaterial
        {
            get => underwaterMaterial;
            set => underwaterMaterial = value;
        }

        public float MaterialChangeSpeed
        {
            get => materialChangeSpeed;
            set => materialChangeSpeed = value;
        }

        public int Priority
        {
            get => priority;
            set => priority = value;
        }
    }
}