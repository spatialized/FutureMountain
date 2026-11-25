using UnityEngine;

namespace NatureManufacture.Underwater
{
    public class CameraFarPlaneDebug : MonoBehaviour
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

            Gizmos.DrawLine(camera.ViewportToWorldPoint(new Vector3(0, 0, camera.farClipPlane)),
                camera.ViewportToWorldPoint(new Vector3(1, 0, camera.farClipPlane)));

            Gizmos.DrawLine(camera.ViewportToWorldPoint(new Vector3(1, 0, camera.farClipPlane)),
                camera.ViewportToWorldPoint(new Vector3(1, 1, camera.farClipPlane)));

            Gizmos.DrawLine(camera.ViewportToWorldPoint(new Vector3(1, 1, camera.farClipPlane)),
                camera.ViewportToWorldPoint(new Vector3(0, 1, camera.farClipPlane)));

            Gizmos.DrawLine(camera.ViewportToWorldPoint(new Vector3(0, 1, camera.farClipPlane)),
                camera.ViewportToWorldPoint(new Vector3(0, 0, camera.farClipPlane)));
        }
    }
}