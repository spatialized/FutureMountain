using UnityEngine;

namespace NatureManufacture.RAM
{
    public class RamBuoyancyDebug
    {
        public void DrawGizmos(Vector3[] volumePointsMatrix, Vector3 lowestPoint, Vector3 center, Collider meshCollider)
        {
            if (meshCollider != null && volumePointsMatrix != null)
            {
                foreach (Vector3 item in volumePointsMatrix)
                {
                    Gizmos.color = Color.red;
                    Gizmos.DrawSphere(item, .08f);
                }
            }


            Gizmos.color = Color.blue;
            Gizmos.DrawSphere(lowestPoint, .08f);


            Gizmos.color = Color.green;
            Gizmos.DrawSphere(center, .08f);
        }

        public void DebugForces(bool isSea, Vector3 baseProfileFloatSpeed, Vector3 upVector, float minY, Vector3 velocity, float buoyancy, Vector3 center, float viscosity, Vector3 position, Rigidbody objectRigidbody)
        {
            const float vectorSize = 5;

            Debug.DrawRay(position + Vector3.up, baseProfileFloatSpeed * vectorSize, isSea ? Color.cyan : Color.red);
            Debug.DrawRay(center, upVector * (buoyancy * (minY - center.y) * vectorSize), Color.green);
            Debug.DrawRay(position, velocity * (-1 * viscosity * vectorSize), Color.magenta);
            Debug.DrawRay(position, velocity * vectorSize, Color.blue);
            Debug.DrawRay(position, objectRigidbody.angularVelocity * vectorSize, Color.black);
        }
    }
}