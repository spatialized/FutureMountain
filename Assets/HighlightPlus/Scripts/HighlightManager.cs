using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

namespace HighlightPlus {

	[RequireComponent (typeof(HighlightEffect))]
	[HelpURL("https://kronnect.freshdesk.com/support/solutions/42000065090")]
	public class HighlightManager : MonoBehaviour {
		public LayerMask layerMask = -1;
		public Camera raycastCamera;
		public RayCastSource raycastSource = RayCastSource.MousePosition;

		HighlightEffect baseEffect, currentEffect;
		Transform currentObject;

		void OnEnable () {
			currentObject = null;
			currentEffect = null;
			if (baseEffect == null) {
				baseEffect = GetComponent<HighlightEffect> ();
				if (baseEffect == null) {
					baseEffect = gameObject.AddComponent<HighlightEffect> ();
				}
			}
			raycastCamera = GetComponent<Camera> ();
			if (raycastCamera == null) {
				raycastCamera = GetCamera ();
				if (raycastCamera == null) {
					Debug.LogError ("Highlight Manager: no camera found!");
				}
			}
		}


		void OnDisable () {
			SwitchesCollider (null);
		}

		void Update () {
			if (raycastCamera == null)
				return;
			Ray ray;
			if (raycastSource == RayCastSource.MousePosition) {
				ray = raycastCamera.ScreenPointToRay (Input.mousePosition);
			} else {
				ray = new Ray (raycastCamera.transform.position, raycastCamera.transform.forward);
			}
			RaycastHit hitInfo;
			if (Physics.Raycast (ray, out hitInfo, raycastCamera.farClipPlane, layerMask)) {
				// Check if the object has a Highlight Effect
				if (hitInfo.collider != currentObject) {
					SwitchesCollider (hitInfo.collider.transform);
				}
                return;
            }

            // no hit
            SwitchesCollider (null);
		}

		void SwitchesCollider (Transform newObject) {
			if (currentEffect != null) {
				currentEffect.SetHighlighted (false);
                currentEffect = null;
			}
			currentObject = newObject;
            if (newObject == null) return;
            HighlightTrigger ht = newObject.GetComponent<HighlightTrigger>();
            if (ht != null && ht.enabled)
				return;
			
			HighlightEffect otherEffect = newObject.GetComponent<HighlightEffect> ();
			currentEffect = otherEffect != null ? otherEffect : baseEffect;
			currentEffect.SetTarget (currentObject.transform);
			currentEffect.SetHighlighted (true);
		}

		public static Camera GetCamera() {
			Camera raycastCamera = Camera.main;
			if (raycastCamera == null) {
				raycastCamera = FindObjectOfType<Camera> ();
			}
			return raycastCamera;
		}


	}

}