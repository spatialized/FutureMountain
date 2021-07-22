/* 
*   NatCorder
*   Copyright (c) 2019 Yusuf Olokoba
*/

namespace NatCorder.Examples {

    using UnityEngine;
    using UnityEngine.UI;
    using System.Collections;

	[RequireComponent(typeof(RawImage), typeof(AspectRatioFitter))]
    public class CameraPreview : MonoBehaviour {

        public WebCamTexture cameraTexture { get; private set; }
		private RawImage rawImage;
		private AspectRatioFitter aspectFitter;
		
		IEnumerator Start () {
			rawImage = GetComponent<RawImage>();
			aspectFitter = GetComponent<AspectRatioFitter>();
            // Request microphone and camera
            yield return Application.RequestUserAuthorization(UserAuthorization.WebCam | UserAuthorization.Microphone);
            if (!Application.HasUserAuthorization(UserAuthorization.WebCam | UserAuthorization.Microphone)) yield break;
            // Start the WebCamTexture
            cameraTexture = new WebCamTexture(null, 1280, 720, 30);
            cameraTexture.Play();
            yield return new WaitUntil(() => cameraTexture.width != 16 && cameraTexture.height != 16); // Workaround for weird bug on macOS
            // Setup preview shader with correct orientation
            rawImage.texture = cameraTexture;
            rawImage.material = new Material(Shader.Find("Hidden/NatCorder/CameraPreview"));
            // Orient the preview panel
            rawImage.material.SetFloat("_Rotation", cameraTexture.videoRotationAngle * Mathf.PI / 180f);
            rawImage.material.SetFloat("_Scale", cameraTexture.videoVerticallyMirrored ? -1 : 1);
            // Scale the preview panel
            aspectFitter.aspectMode = AspectRatioFitter.AspectMode.HeightControlsWidth;
            if (cameraTexture.videoRotationAngle == 90 || cameraTexture.videoRotationAngle == 270)
                aspectFitter.aspectRatio = (float)cameraTexture.height / cameraTexture.width;
            else
                aspectFitter.aspectRatio = (float)cameraTexture.width / cameraTexture.height;
        }
	}
}