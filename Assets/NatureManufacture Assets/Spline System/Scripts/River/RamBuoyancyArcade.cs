using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Serialization;

namespace NatureManufacture.RAM
{
    [SelectionBase]
    [RequireComponent(typeof(Rigidbody))]
    public class RamBuoyancyArcade : MonoBehaviour
    {
        [SerializeField] private LayerMask layer = 16;
        [SerializeField] private float lerpRotationSpeed = 3f;
        [SerializeField] private float lerpFloatSpeed = 3f;
        [SerializeField] private float lerpWaterVelocity = 3f;
        [SerializeField] private float velocityMultiplier = 0.1f;
        [SerializeField] private bool rotateToSpeed;
        [SerializeField] private float rotationSpeed = 5;
        [SerializeField] private Vector3 physicsPivot;
        [SerializeField] private float checkWaterDistance = 10;

        [SerializeField] private bool debugForces;
        private Rigidbody _rigidbody;
        private Collider _collider;

        private RamSpline _lastRamSpline;
        private LakePolygon _lastLakePolygon;
        private Waterfall _lastWaterfall;
        private List<Vector2> _uvs3 = new(100);
        private List<int> _triangles = new(100);


        private RamBuoyancyCalculations RamBuoyancyCalculations { get; } = new();

        private void Start()
        {
            _rigidbody = GetComponent<Rigidbody>();
            _collider = GetComponent<Collider>();

            if (_collider == null)
            {
                Debug.LogError("Buoyancy doesn't have collider");
                enabled = false;
                return;
            }
        }

        private void FixedUpdate()
        {
            WaterPhysics();
        }

        private void WaterPhysics()
        {
            bool isSea = CheckHighestWaterPoint(out RaycastHit? outHit);


            /*  var ray = new Ray
              {
                  origin = transform.position + Vector3.up * 100,
                  direction = Vector3.down
              };


              if (!Physics.Raycast(ray, out RaycastHit hit, 1000, layer)) return;*/
            if (!outHit.HasValue) return;

            RaycastHit hit = outHit.Value;

            /*   bool isSea = false;
               if (hit.collider.TryGetComponent(out SeaPhysics seaHeight))
               {
                   isSea = true;
                   SeaPhysics.PositionNormal positionNormal = seaHeight.GetHeight(hit.point, true);

                   //Debug.DrawLine(hit.point, positionNormal.Position, Color.magenta);
                   hit.point = positionNormal.Position;
                   hit.normal = positionNormal.Normal;
               }*/

            Vector3 targetPosition = hit.point;
            Vector3 targetNormal = hit.normal;

            // Lerp position
            //   _rigidbody.position = Vector3.Lerp(_rigidbody.position + physicsPivot, targetPosition, lerpFloatSpeed * Time.fixedDeltaTime);

            targetPosition = Vector3.Lerp(_rigidbody.position, targetPosition - physicsPivot, lerpFloatSpeed * Time.fixedDeltaTime);
            _rigidbody.MovePosition(targetPosition);


            // Lerp rotation
            // Calculate the target rotation based on the normal
            Quaternion targetRotation = Quaternion.FromToRotation(Vector3.up, targetNormal);

            // Extract the pitch and roll from the target rotation
            Vector3 targetEulerAngles = targetRotation.eulerAngles;
            Vector3 currentEulerAngles = _rigidbody.rotation.eulerAngles;

            // Keep the yaw (direction) unchanged
            targetEulerAngles.y = 0;

            // Apply the new rotation
            Quaternion adjustedRotation = Quaternion.Euler(targetEulerAngles) * Quaternion.Euler(0, currentEulerAngles.y, 0);
            _rigidbody.rotation = Quaternion.Lerp(_rigidbody.rotation, adjustedRotation, lerpRotationSpeed * Time.fixedDeltaTime);

            RamBuoyancyCalculations.GetMeshData(hit.collider.gameObject, isSea);

            (Vector3 baseProfileFloatSpeed, float physicalDensity) = RamBuoyancyCalculations.GetFloatSpeedAndDensity(hit.triangleIndex, isSea,debugForces);
         
#if UNITY_6000_0_OR_NEWER
            Vector3 velocity = _rigidbody.linearVelocity;
#else
            Vector3 velocity = _rigidbody.velocity;
#endif


            velocity = Vector3.Lerp(velocity, baseProfileFloatSpeed * velocityMultiplier, lerpWaterVelocity * Time.fixedDeltaTime);


#if UNITY_6000_0_OR_NEWER
            _rigidbody.linearVelocity = velocity;
#else
            _rigidbody.velocity = velocity;
#endif


            RotateToSpeed(velocity);
        }

        private bool CheckHighestWaterPoint(out RaycastHit? hit)
        {
            var ray = new Ray
            {
                origin = transform.position + Vector3.up * checkWaterDistance,
                direction = Vector3.down
            };
            RaycastHit[] results = new RaycastHit[5];
            var size = Physics.RaycastNonAlloc(ray, results, checkWaterDistance * 1.1f, layer);

            if (size == 0)
            {
                hit = null;
                return false;
            }

            bool[] seaList = new bool[size];

            for (int i = 0; i < size; i++)
            {
                seaList[i] = false;

                if (!results[i].collider.TryGetComponent(out SeaPhysics seaHeight)) continue;

                SeaPhysics.PositionNormal positionNormal = seaHeight.GetHeight(results[i].point, true);

                //Debug.DrawLine(hit.point, positionNormal.Position, Color.magenta);
                results[i].point = positionNormal.Position;
                results[i].normal = positionNormal.Normal;
                seaList[i] = true;
            }

            float maxY = float.MinValue;
            hit = null;
            bool isSea = false;
            for (int i = 0; i < size; i++)
            {
                if (results[i].point.y <= maxY) continue;

                maxY = results[i].point.y;
                hit = results[i];
                isSea = seaList[i];
            }

            return isSea;
        }


        private void RotateToSpeed(Vector3 velocity)
        {
            if (!rotateToSpeed) return;

            Vector3 speed = velocity.normalized;

            speed.y = 0;


// Extract the current x, y, and z rotations
            Vector3 currentEulerAngles = _rigidbody.rotation.eulerAngles;

// Extract the target y-axis rotation
            float targetYRotation = Quaternion.LookRotation(speed).eulerAngles.y;

// Interpolate between the current and target y-axis rotations
            float newYRotation = Mathf.LerpAngle(currentEulerAngles.y, targetYRotation, Time.fixedDeltaTime * rotationSpeed);

// Apply the interpolated y-axis rotation while keeping the x and z rotations unchanged
            Quaternion newRotation = Quaternion.Euler(currentEulerAngles.x, newYRotation, currentEulerAngles.z);
            _rigidbody.MoveRotation(newRotation);
        }

        private void OnDrawGizmos()
        {
            if (_rigidbody == null)
                _rigidbody = GetComponent<Rigidbody>();

            Gizmos.color = new Color(1, 0, 1, 0.5f);

            Gizmos.DrawSphere(_rigidbody.position + physicsPivot, 0.05f);
        }
    }
}