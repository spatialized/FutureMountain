using UnityEngine;

namespace NatureManufacture.Underwater
{
    public class CameraNearPlaneDebug : MonoBehaviour
    {
        private new Camera camera;

        private void Awake()
        {
            camera = GetComponent<Camera>();
        }

        private void OnDrawGizmos()
        {
            if (camera == null)
            {
                camera = GetComponent<Camera>();
                if (camera == null)
                    return;
            }


            Gizmos.color = Color.green;

            // Calculate the corners of the near plane
            Gizmos.DrawLine(camera.ViewportToWorldPoint(new Vector3(0, 0, camera.nearClipPlane)),
                camera.ViewportToWorldPoint(new Vector3(1, 0, camera.nearClipPlane)));

            Gizmos.DrawLine(camera.ViewportToWorldPoint(new Vector3(1, 0, camera.nearClipPlane)),
                camera.ViewportToWorldPoint(new Vector3(1, 1, camera.nearClipPlane)));

            Gizmos.DrawLine(camera.ViewportToWorldPoint(new Vector3(1, 1, camera.nearClipPlane)),
                camera.ViewportToWorldPoint(new Vector3(0, 1, camera.nearClipPlane)));

            Gizmos.DrawLine(camera.ViewportToWorldPoint(new Vector3(0, 1, camera.nearClipPlane)),
                camera.ViewportToWorldPoint(new Vector3(0, 0, camera.nearClipPlane)));
        }
    }
}