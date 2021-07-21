using UnityEngine;
using System.Collections;

namespace Horizon {
	[AddComponentMenu("Horizon[ON]/Horizon[ON] Compensate Z-Fighting")]
	public class HorizonCompensateZFighting : MonoBehaviour {

		public float minCamHeight = 2.0f;
		public float minOffsetY = 0.5f;
		public float maxCamHeight = 500.0f;
		public float maxOffsetY = 5.0f;

		float currentOffset = 0.0f;

		void Update () {
            if (Camera.main != null)
            {
                if (Camera.main.transform.position.y <= minCamHeight) { currentOffset = minOffsetY; }
                currentOffset = Mathf.Lerp(minOffsetY, maxOffsetY, (Camera.main.transform.position.y / maxCamHeight));
                if (Camera.main.transform.position.y >= maxCamHeight) { currentOffset = maxOffsetY; }
                transform.position = new Vector3(transform.position.x, currentOffset, transform.position.z);
            }
		}
	}
}