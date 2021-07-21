using UnityEngine;
using System.Collections;

public class AmbientControllerExample : MonoBehaviour {

    Transform cameraRig;
    Transform camPanPoint;
    Light sunLight;
    Transform sunTransform;

    public float timeMulti;
    public AnimationCurve timeCurve;
    public Gradient sunColor;
    public AnimationCurve sunIntensity;
    public AnimationCurve sunAnim;
    [Space(8)]
    public ReflectionProbe reflectionProbe;
    public Material skybox;
    public AnimationCurve atmosphereThickness;
    public AnimationCurve exposure;
    public AnimationCurve ambientIntensity;
    public Gradient fogColor;
    public AnimationCurve shadowDistance;
    [Space]
    public float zoomDuration = 0.5f;
    public float minFOV = 20;
    public Color CityLights;
    public float CityLightsSwitchTime = 0.2f;
    public Material[] horizonMaterials;
    public Material terrainMaterial;
    float origFOV;
    float origOffset;
    bool isZoomed = false;

    int frame = 0;
    [HideInInspector] public float time;
    float panTargetLerp, tiltTargetLerp, pedestaltargetLerp;
    [HideInInspector] public bool input = false;
    [HideInInspector] public Transform sunRotation;
    
    public GameObject gui;

    void Start()
    {
        //Camera.main.layerCullSpherical = true;
        //Camera.main.depthTextureMode = DepthTextureMode.Depth;
        //Camera.main.depthTextureMode = DepthTextureMode.MotionVectors;
        origOffset = Camera.main.transform.localPosition.z;
        origFOV = Camera.main.fieldOfView;
        gui.SetActive(true);
        reflectionProbe.gameObject.SetActive(true);
        sunTransform = GameObject.Find("Sun").transform;
        sunLight = sunTransform.GetComponent<Light>();
        sunRotation = sunTransform.parent;
        sunRotation.eulerAngles = new Vector3(0,180,0);

        cameraRig = transform.Find("Camera Rig");
        camPanPoint = cameraRig.GetChild(0);
        time = 0.25f;
        input = true;
        EvaluateCurves();
        DynamicGI.UpdateEnvironment();
        Invoke("DelayedRefresh", 0.1f);
    } //============================================================================================
    void OnDisable()
    {
        gui.SetActive(false);
        time = 0.25f;
        input = true;
        EvaluateCurves();
    } //============================================================================================

    void DelayedRefresh()
    {
        input = true;
        EvaluateCurves();
        DynamicGI.UpdateEnvironment();
    }

    void Update()
    {
        if (Input.GetMouseButtonDown(1) && !isZoomed)
        {
            isZoomed = true;
            StopAllCoroutines();
            StartCoroutine(ZoomIn());
        }
        else if (Input.GetMouseButtonDown(1) && isZoomed)
        {
            isZoomed = false;
            StopAllCoroutines();
            StartCoroutine(ZoomOut());
        }
        if (Input.GetKey(KeyCode.RightArrow))
        {
            sunRotation.eulerAngles += new Vector3(0,Time.deltaTime*20,0);
            input = true;
        }
        if (Input.GetKey(KeyCode.LeftArrow))
        {
            sunRotation.eulerAngles -= new Vector3(0, Time.deltaTime*20, 0);
            input = true;
        }
        if (Input.GetKey(KeyCode.UpArrow)) { TimePlus(); }
        if (Input.GetKey(KeyCode.DownArrow)) { TimeMinus(); }

        if (input)
        {
            if (frame == 0)
            {
                DynamicGI.UpdateEnvironment();
            }
            if (frame == 1)
            {
                reflectionProbe.RenderProbe();
            }
            frame++;
            if (frame > 10) frame = 0;
            input = false;
            EvaluateCurves();
        }

        if (time <= CityLightsSwitchTime)
        {
            SwitchCityLights(true);
        }
        else
        {
            SwitchCityLights(false);
        }

        pedestaltargetLerp = Mathf.Lerp(pedestaltargetLerp, Input.GetAxis("Mouse ScrollWheel")*300, 2 * Time.deltaTime);
        cameraRig.position += new Vector3(0, pedestaltargetLerp, 0);
        if (cameraRig.position.y < 70) cameraRig.position = new Vector3(0, 70, 0);
        else if (cameraRig.position.y > 350) cameraRig.position = new Vector3(0, 350, 0);
        cameraRig.Rotate(0, 1 * Time.deltaTime, 0);
    } //============================================================================================

    float x = 0, y = 0;
    void LateUpdate()
    {
        if (Input.GetMouseButton(0)) { x = Input.GetAxis("Mouse X"); y = -Input.GetAxis("Mouse Y"); }
        else { x = 0; y = 0; }
        panTargetLerp = Mathf.Lerp(panTargetLerp, x * 2, 2 * Time.deltaTime);
        camPanPoint.localEulerAngles += new Vector3(0, panTargetLerp * (Time.deltaTime * 100), 0);
        tiltTargetLerp = Mathf.Lerp(tiltTargetLerp, y * 2, 2 * Time.deltaTime);
        camPanPoint.localEulerAngles += new Vector3(tiltTargetLerp, 0, 0);
        if (camPanPoint.localEulerAngles.x < 0 || camPanPoint.localEulerAngles.x > 180) camPanPoint.localEulerAngles = new Vector3(0, camPanPoint.localEulerAngles.y, camPanPoint.localEulerAngles.z);
        if (camPanPoint.localEulerAngles.x > 45) camPanPoint.localEulerAngles = new Vector3(45, camPanPoint.localEulerAngles.y, camPanPoint.localEulerAngles.z);
    } //============================================================================================


    void EvaluateCurves()
    {
        sunTransform.localEulerAngles = new Vector3(sunAnim.Evaluate(time) * 90, 0, 0);
        sunLight.color = sunColor.Evaluate(time);
        sunLight.intensity = sunIntensity.Evaluate(time);
        skybox.SetFloat("_AtmosphereThickness", atmosphereThickness.Evaluate(time));
        skybox.SetFloat("_Exposure", exposure.Evaluate(time));
        RenderSettings.ambientIntensity = ambientIntensity.Evaluate(time);
        Color fCol = RenderSettings.fogColor = fogColor.Evaluate(time);
        fCol.a = 0;

        foreach (Material m in horizonMaterials)
        {
            if (m.HasProperty("_OverlayFogColorAfromAmbient")) m.SetColor("_OverlayFogColorAfromAmbient", fCol);
        }
        if (terrainMaterial != null) { if (terrainMaterial.HasProperty("_OverlayFogColorAfromAmbient")) terrainMaterial.SetColor("_OverlayFogColorAfromAmbient", fCol); }

        QualitySettings.shadowDistance = shadowDistance.Evaluate(time)*6000;
    } //============================================================================================

    IEnumerator ZoomIn()
    {
        float tStamp = Time.time;
        float startFOV = Camera.main.fieldOfView;
        float startOffset = Camera.main.transform.localPosition.z;
        while (Time.time - tStamp < zoomDuration)
        {
            Camera.main.transform.localPosition = new Vector3(0,0,Mathf.Lerp(startOffset,0, (Time.time - tStamp) / zoomDuration));
            Camera.main.fieldOfView = Mathf.Lerp(startFOV, minFOV, (Time.time - tStamp) / zoomDuration);
            yield return null;
        }
        Camera.main.transform.localPosition = new Vector3(0, 0, 0);
        Camera.main.fieldOfView = minFOV;
    }
    IEnumerator ZoomOut()
    {
        float tStamp = Time.time;
        float startFOV = Camera.main.fieldOfView;
        float startOffset = Camera.main.transform.localPosition.z;
        while (Time.time - tStamp < zoomDuration)
        {
            Camera.main.transform.localPosition = new Vector3(0, 0, Mathf.Lerp(startOffset, origOffset, (Time.time - tStamp) / zoomDuration));
            Camera.main.fieldOfView = Mathf.Lerp(startFOV, origFOV, (Time.time - tStamp) / zoomDuration);
            yield return null;
        }
        Camera.main.transform.localPosition = new Vector3(0, 0, origOffset);
        Camera.main.fieldOfView = origFOV;
    }

    void TimePlus()
    {
        time += Time.deltaTime*timeMulti;
        if (time >= 0.8f) time = 0.8f;
        input = true;
    }
    void TimeMinus()
    {
        time -= Time.deltaTime*timeMulti;
        if (time <= 0) time = 0;
        input = true;
    }
    void SwitchCityLights(bool on)
    {
        if (on)
        {
            foreach (Material m in horizonMaterials)
            {
                if (m.HasProperty("_EmissionColor")) m.SetColor("_EmissionColor", CityLights);
            }
        }
        else
        {
            foreach (Material m in horizonMaterials)
            {
                if (m.HasProperty("_EmissionColor")) m.SetColor("_EmissionColor", Color.black);
            }
        }
    }

    public void Quit() { Application.Quit(); }
}
