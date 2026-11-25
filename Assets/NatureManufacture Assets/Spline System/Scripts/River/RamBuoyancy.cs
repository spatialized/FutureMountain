using System.Collections.Generic;
using UnityEngine;

namespace NatureManufacture.RAM
{
    [SelectionBase]
    [RequireComponent(typeof(Rigidbody))]
    public class RamBuoyancy : MonoBehaviour
    {
        [SerializeField] private float buoyancy = 30;
        [SerializeField] public float viscosity = 2;
        [Range(0, 1)] [SerializeField] private float viscosityAngular = 0.4f;
        [SerializeField] private bool rotateToSpeed;
        [SerializeField] private float rotationSpeed = 5;

        [SerializeField] private LayerMask layer = 16;

        [SerializeField] private new Collider collider;

        [SerializeField] private int pointsInAxis = 2;

        [SerializeField] private List<Vector3> volumePoints = new();
        [SerializeField] private bool autoGenerateVolumePoints = true;

        [SerializeField] private bool debugForces;
        [SerializeField] private bool debugVolumePoints;
        [SerializeField] private float checkWaterDistance = 10;


        private Rigidbody _rigidbody;
        private Vector3 _center = Vector3.zero;
        private Vector3 _lowestPoint;
        private Vector3[] _volumePointsMatrix;

        private RamBuoyancyDebug RamBuoyancyDebug { get; } = new();

        private RamBuoyancyCalculations RamBuoyancyCalculations { get; } = new();

        private void Start()
        {
            _rigidbody = GetComponent<Rigidbody>();


            if (collider == null)
                collider = GetComponent<Collider>();

            if (collider == null)
            {
                Debug.LogError("Buoyancy doesn't have collider");
                enabled = false;
                return;
            }

            if (autoGenerateVolumePoints)
            {
                AutoGenerateVolumePoints();
            }

            _volumePointsMatrix = new Vector3[volumePoints.Count];
        }

        public void AutoGenerateVolumePoints()
        {
            volumePoints.Clear();
            if (collider == null)
                collider = GetComponent<Collider>();

            if (collider == null)
            {
                Debug.LogError("Buoyancy doesn't have collider");
                enabled = false;
                return;
            }

            Bounds bounds = collider.bounds;
            Vector3 size = bounds.size * 0.8f;
            Vector3 center = bounds.center;
            var step = new Vector3(size.x / pointsInAxis, size.y / pointsInAxis, size.z / pointsInAxis);

            for (int x = 0; x <= pointsInAxis; x++)
            {
                for (int y = 0; y <= pointsInAxis; y++)
                {
                    for (int z = 0; z <= pointsInAxis; z++)
                    {
                        Vector3 vertice = new Vector3(center.x + (x - pointsInAxis * 0.5f) * step.x, center.y + (y - pointsInAxis * 0.5f) * step.y, center.z + (z - pointsInAxis * 0.5f) * step.z);
                        Vector3 closestPoint = collider.ClosestPoint(vertice);

                        if (Vector3.Distance(closestPoint, vertice) < float.Epsilon)
                        {
                            volumePoints.Add(transform.InverseTransformPoint(vertice));
                        }
                    }
                }
            }
        }

        private void FixedUpdate()
        {
            WaterPhysics();
        }


        private void WaterPhysics()
        {
            if (volumePoints.Count == 0)
            {
                Debug.Log("Not initiated Buoyancy");
                return;
            }

            var ray = new Ray
            {
                direction = Vector3.down
            };

            bool backFace = Physics.queriesHitBackfaces;
            Physics.queriesHitBackfaces = true;

            float minY;

            CalculateLowestPoint();

            ray.origin = _lowestPoint + Vector3.up * checkWaterDistance;

            _center = Vector3.zero;

#if UNITY_6000_0_OR_NEWER
                Vector3 velocity = _rigidbody.linearVelocity;
#else
            Vector3 velocity = _rigidbody.velocity;
#endif


            if (Physics.Raycast(ray, out RaycastHit hit, checkWaterDistance * 1.1f, layer))
            {
                //var width = Mathf.Max(collider.bounds.size.x, collider.bounds.size.z);

                bool isSea = false;
                if (hit.collider.TryGetComponent(out SeaPhysics seaHeight))
                {
                    isSea = true;
                    SeaPhysics.PositionNormal positionNormal = seaHeight.GetHeight(hit.point);

                    hit.point = positionNormal.Position;
                    hit.normal = positionNormal.Normal;
                }

                Vector3 upVector = hit.normal;
                minY = CalculateCenter(hit.point.y);


                RamBuoyancyCalculations.GetMeshData(hit.collider.gameObject, isSea);

                (Vector3 baseProfileFloatSpeed, float physicalDensity) = RamBuoyancyCalculations.GetFloatSpeedAndDensity(hit.triangleIndex, isSea, debugForces);


                SeaBuoyancyCalculation(seaHeight, physicalDensity);

                _rigidbody.AddForce(velocity * (-1 * viscosity * physicalDensity));

                _rigidbody.AddForce(baseProfileFloatSpeed * physicalDensity);

                RotateToSpeed(velocity);


                if (debugForces)
                {
                    if (RamBuoyancyCalculations.IsOverWater)
                        RamBuoyancyDebug.DebugForces(isSea, baseProfileFloatSpeed, upVector, minY, velocity, buoyancy, _center, viscosity, transform.position, _rigidbody);
                }
            }


            Physics.queriesHitBackfaces = backFace;
        }

        private void SeaBuoyancyCalculation(SeaPhysics seaPhysics, float physicalDensity)
        {
            int volumePointsCount = _volumePointsMatrix.Length;
            float step = 1f / volumePointsCount;

            var ray = new Ray
            {
                direction = Vector3.down
            };

            //Debug.Log(_volumePointsMatrix.Length, gameObject);
            if (seaPhysics)
                seaPhysics.ResetData();
            foreach (Vector3 worldPoint in _volumePointsMatrix)
            {
                float depth = 0;
                if (seaPhysics)
                {
                    SeaPhysics.PositionNormal positionNormal = seaPhysics.GetHeight(worldPoint);
                    depth = positionNormal.Position.y - worldPoint.y;
                }
                else
                {
                    ray.origin = worldPoint + Vector3.up * checkWaterDistance;

                    if (Physics.Raycast(ray, out RaycastHit hit, checkWaterDistance * 1.1f, layer))
                    {
                        depth = hit.point.y - worldPoint.y;
                    }
                }

                if (depth > 0)
                {
                    Vector3 buoyantForce = Vector3.up * (buoyancy * Mathf.Abs(depth) * step * physicalDensity);
                    _rigidbody.AddForceAtPosition(buoyantForce, worldPoint);
                }
                //Debug.DrawRay(worldPoint, buoyantForce, Color.green);

                Vector3 velocityVis = _rigidbody.GetPointVelocity(worldPoint);
                Vector3 dampingForce = -velocityVis * (viscosityAngular * Mathf.Sign(depth) * step * physicalDensity);
                if (dampingForce.magnitude > 0)
                    _rigidbody.AddForceAtPosition(dampingForce, worldPoint);
            }
        }

        private void CalculateLowestPoint()
        {
            Matrix4x4 thisMatrix = transform.localToWorldMatrix;

            _lowestPoint = volumePoints[0];
            float minY = float.MaxValue;
            for (int i = 0; i < volumePoints.Count; i++)
            {
                _volumePointsMatrix[i] = thisMatrix.MultiplyPoint3x4(volumePoints[i]);

                if (minY > _volumePointsMatrix[i].y)
                {
                    _lowestPoint = _volumePointsMatrix[i];
                    minY = _lowestPoint.y;
                }
            }
        }

        private float CalculateCenter(float min)
        {
            int verticesCount = 0;
            float minY = min;
            for (int i = 0; i < _volumePointsMatrix.Length; i++)
                if (_volumePointsMatrix[i].y <= minY)
                {
                    _center += _volumePointsMatrix[i];
                    verticesCount++;
                }

            if (verticesCount == 0)
            {
                // Debug.LogWarning($"CalculateCenter verticesCount == 0",gameObject);
                _center = _lowestPoint;


                return minY;
            }


            _center /= verticesCount;
            return minY;
        }

        private void RotateToSpeed(Vector3 velocity)
        {
            if (!rotateToSpeed) return;

            Vector3 speed = velocity;

            speed.y = 0;

            Quaternion deltaRotation = Quaternion.LookRotation(speed);
            _rigidbody.MoveRotation(Quaternion.Slerp(transform.rotation, deltaRotation, Time.fixedDeltaTime * rotationSpeed));
        }


        private void OnDrawGizmosSelected()
        {
            if (!debugVolumePoints)
                return;

            if (!autoGenerateVolumePoints)
            {
                foreach (Vector3 item in volumePoints)
                {
                    Vector3 worldPoint = transform.TransformPoint(item);
                    Gizmos.color = Color.cyan;
                    Gizmos.DrawSphere(worldPoint, .08f);
                }
            }


            RamBuoyancyDebug.DrawGizmos(_volumePointsMatrix, _lowestPoint, _center, collider);
        }
    }
}