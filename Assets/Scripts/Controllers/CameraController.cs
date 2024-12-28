using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Assertions;
using UnityEngine.UI;

public class CameraController : MonoBehaviour {

    Animator animator;
    public GameObject zoomOutButtonObject;

    private bool moving = false;
    private float moveLength = 1.75f; // adjust this to fit your attack animations length

    public bool zoomed { get; set; } = false;
    public bool fly { get; set; } = false;
    public GamePauseState pauseState { get; set; } = GamePauseState.idle;        // Flag to unpause game state

    public GameObject sideBySideModeToggleObject;

    //public bool useWii = false;

    private float minXRotation = 0f;
    private float maxXRotation = 180f;
    private float minYRotation = 100f;
    private float maxYRotation = 240f;

    /* Timing */
    float lastMouseClickedTime = -1;            // Time user last clicked mouse
    float mouseClickWaitTime = 1f;              // Seconds to wait in between registering mouse clicks

    public enum GamePauseState
    {
        pause,
        unpause,
        idle
    }

    void Start() {
        Assert.IsNotNull(zoomOutButtonObject);

        animator = gameObject.GetComponent<Animator>();
        animator.enabled = true;

        RuntimeAnimatorController ac = animator.runtimeAnimatorController;    //Get Animator controller
                                                                              //for (int i = 0; i < ac.animationClips.Length; i++)                 //For all animations
                                                                              //{
        moveLength = ac.animationClips[0].length;                        // All animation clips are same length (1.5 sec)  
                                                                         //Debug.Log("Anim clip #" + i + " length:" + moveLength+" name:"+ ac.animationClips[i].name);
                                                                         //}
        fly = false;

        //sideBySideModeToggleObject = GameObject.Find("SideBySideToggle");
        Assert.IsNotNull(sideBySideModeToggleObject);
    }

    /// <summary>
    /// Update simulation each frame
    /// </summary>
    //public void UpdateSimulation()
    void Update()
    {
        if (fly)
        {
            UpdateFlyCamKeyboardInput();
        }
        else
        {
            GetMouseInput();
            GetKeyboardInput();
        }
    }

    /// <summary>
    /// Gets mouse input.
    /// </summary>
    void GetMouseInput()
    {
        /* Handle Mouse Input */
        float waited = Time.time - lastMouseClickedTime;
        if (Input.GetMouseButtonDown(0) && waited > mouseClickWaitTime)
        {
            Ray ray = Camera.main.ScreenPointToRay(Input.mousePosition);
            RaycastHit hit;

            if (Physics.Raycast(ray, out hit))
            {
                if (zoomed)
                {
                   // StartResetZoom();                     // Click to zoom out (disabled)
                }
                else
                {
                    if (hit.transform.tag == "AggregateCube")
                    {
                        Debug.Log("User clicked on AggregateCube");
                        if (!moving)
                        {
                            StartZoomIntoCube(-1);
                        }
                    }
                    else if(hit.transform.tag != "Untagged")
                    {
                        string cubeTag = hit.transform.tag;
                        //Debug.Log("GetMouseInput()... Will zoom in... cubeTag: " + cubeTag + " cubeTag.Substring(cubeTag.Length - 1): " + cubeTag.Substring(cubeTag.Length - 1));

                        string strIdx = cubeTag.Substring(cubeTag.Length - 1);
                        string animName = "ZoomCube" + strIdx;
                        int idx = int.Parse(strIdx) - 1;

                        //Debug.Log("GetMouseInput()... Zooming in... animName: " + animName + " strIdx: " + strIdx);

                        if (!moving)
                        {
                            StartZoomIntoCube(idx);
                        }
                    }

                    //if (hit.transform.tag == "Cube1")
                    //{
                    //    Debug.Log("User clicked on Cube1");
                    //    if (!moving)
                    //    {
                    //        StartZoomIntoCube(0, "ZoomCube1");
                    //    }
                    //}
                    //else if (hit.transform.tag == "Cube2")
                    //{
                    //    Debug.Log("User clicked on Cube2");
                    //    if (!moving)
                    //    {
                    //        StartZoomIntoCube(1, "ZoomCube2");
                    //    }
                    //}
                    //else if (hit.transform.tag == "Cube3")
                    //{
                    //    Debug.Log("User clicked on Cube3");
                    //    if (!moving)
                    //    {
                    //        StartZoomIntoCube(2, "ZoomCube3");
                    //    }
                    //}
                    //else if (hit.transform.tag == "Cube4")
                    //{
                    //    Debug.Log("User clicked on Cube4");
                    //    if (!moving)
                    //    {
                    //        StartZoomIntoCube(3, "ZoomCube4");
                    //    }
                    //}
                    //else if (hit.transform.tag == "Cube5")
                    //{
                    //    Debug.Log("User clicked on Cube5");
                    //    if (!moving)
                    //    {
                    //        StartZoomIntoCube(4, "ZoomCube5");
                    //    }
                    //}
                    //else if (hit.transform.tag == "AggregateCube")
                    //{
                    //    Debug.Log("User clicked on AggregateCube");
                    //    if (!moving)
                    //    {
                    //        StartZoomIntoCube(-1, "ZoomAggregateCube");
                    //    }
                    //}
                }
            }

            lastMouseClickedTime = Time.time;
        }
    }

    private bool ShouldEnterSideBySideMode()
    {
        if (sideBySideModeToggleObject.GetComponent<Toggle>().isOn)
        {
            return !GameController.Instance.sideBySideMode;
        }
        else
        {
            return false;
        }
    }

    /// <summary>
    /// Start zoom into specified cube
    /// </summary>
    /// <param name="animTriggerName">Camera animation trigger name</param>
    public void StartZoomIntoCube(int cubeIdx)
    {
        string animTriggerName;
        GameController.Instance.SetSideByToggleActive(false);

        if (ShouldEnterSideBySideMode())
        {
            if (cubeIdx == -1)
            {
                animTriggerName = "SBS_Cube0";
                //return;
            }
            else
                animTriggerName = "SBS_Cube" + (cubeIdx + 1);

            //Debug.Log("Calling EnterSideBySideMode()... cubeIdx: "+cubeIdx);
            GameController.Instance.EnterSideBySideMode(cubeIdx);

            pauseState = GamePauseState.pause;
            moving = true;

            //Debug.Log("StartZoomIntoCube()... In Side-by-Side Mode... animTriggerName: " + animTriggerName);

            animator.SetTrigger(animTriggerName);
            StartCoroutine(ZoomingIn());
        }
        else
        {
            if(cubeIdx == -1)
                animTriggerName = "ZoomAggregateCube";
            else
                animTriggerName = "ZoomCube" + (cubeIdx + 1);

            //Debug.Log("EnterSideBySideMode()... animTriggerName: " + animTriggerName);

            pauseState = GamePauseState.pause;
            moving = true;
            animator.SetTrigger(animTriggerName);
            StartCoroutine(ZoomingIn());
        }
    }

    /// <summary>
    /// Start zoom reset animation
    /// </summary>
    public void StartResetZoom()
    {
        GameController.Instance.SetSideByToggleActive(true);
        GameController.Instance.SetZoomOutButtonActive(false);

        pauseState = GamePauseState.pause;
        moving = true;
        animator.SetTrigger("ResetZoom");
        StartCoroutine(ZoomingOut());
    }

    /// <summary>
    /// Gets keyboard input.
    /// </summary>
    void GetKeyboardInput() 
    { 
        if (zoomed)
        {
            if (Input.GetKeyDown(KeyCode.Space))
            {
                GameController.Instance.SetZoomOutButtonActive(false);
                GameController.Instance.SetSideByToggleActive(true);
                StartResetZoom();
            }
        }
        else
        {
            if (Input.GetKeyDown(KeyCode.A))
            {
                if (!moving)
                {
                    pauseState = GamePauseState.pause;
                    moving = true;
                    animator.SetTrigger("ZoomAggregateCube");
                    StartCoroutine(ZoomingIn());
                }
            }
            if (Input.GetKeyDown(KeyCode.F))
            {
                if (!moving)
                {
                    pauseState = GamePauseState.pause;
                    moving = true;
                    animator.SetTrigger("ZoomCube1");
                    StartCoroutine(ZoomingIn());
                }
            }
            if (Input.GetKeyDown(KeyCode.E))
            {
                if (!moving)
                {
                    pauseState = GamePauseState.pause;
                    moving = true;
                    animator.SetTrigger("ZoomCube2");
                    StartCoroutine(ZoomingIn());
                }
            }
            if (Input.GetKeyDown(KeyCode.D))
            {
                if (!moving)
                {
                    pauseState = GamePauseState.pause;
                    moving = true;
                    animator.SetTrigger("ZoomCube3");
                    StartCoroutine(ZoomingIn());
                }
            }
            if (Input.GetKeyDown(KeyCode.C))
            {
                if (!moving)
                {
                    pauseState = GamePauseState.pause;
                    moving = true;
                    animator.SetTrigger("ZoomCube4");
                    StartCoroutine(ZoomingIn());
                }
            }
            if (Input.GetKeyDown(KeyCode.B))
            {
                if (!moving)
                {
                    pauseState = GamePauseState.pause;
                    moving = true;
                    animator.SetTrigger("ZoomCube5");
                    StartCoroutine(ZoomingIn());
                }
            }
        }
    }

    /// <summary>
    /// Moving this instance.
    /// </summary>
    /// <returns>Move animation IEnumerator.</returns>
    IEnumerator ZoomingIn()
    {
        yield return new WaitForSeconds(moveLength);

        //Debug.Log("ZoomingIn() finished... setting moving to false");
        moving = false;
        zoomed = true;
        pauseState = GamePauseState.unpause;

        if(!GameController.Instance.sideBySideMode)
            zoomOutButtonObject.SetActive(true);
    }

    /// <summary>
    /// Moving this instance.
    /// </summary>
    /// <returns>Move animation IEnumerator.</returns>
    IEnumerator ZoomingOut()
    {
        zoomOutButtonObject.SetActive(false);
        yield return new WaitForSeconds(moveLength);

        Debug.Log("ZoomingOut() finished... setting moving to false");

        moving = false;
        zoomed = false;
        pauseState = GamePauseState.unpause;
    }

    /// <summary>
    /// Resets the position.
    /// </summary>
    public void ResetPosition()
    {
        animator.Play("Idle");
        //animator.SetTrigger("Idle");
        zoomed = false;
    }

    /// <summary>
    /// Toggles the fly camera mode.
    /// </summary>
    public void ToggleFlyCameraMode(GameObject toggleButton)
    {
        bool newFlyState = toggleButton.GetComponent<Toggle>().isOn;
        SetCameraFlyMode(newFlyState);
    }

    /// <summary>
    /// Sets the camera fly mode.
    /// </summary>
    /// <param name="newFlyState">If set to <c>true</c> new fly state.</param>
    public void SetCameraFlyMode(bool newFlyState)
    {
        if (fly && !newFlyState)
        {
            fly = false;
            GetComponent<Animator>().enabled = true;
            GameController.Instance.SetZoomOutButtonActive(false);
            GameController.Instance.SetSideByToggleActive(true);
            StartResetZoom();
        }
        else if (!fly && newFlyState)
        {
            fly = true;
            Vector3 savePos = transform.position;
            Quaternion saveRot = transform.localRotation;
            rotationX = transform.localRotation.eulerAngles.x;
            rotationY = transform.localRotation.eulerAngles.y;
            rotationZ = transform.localRotation.eulerAngles.z;
            GetComponent<Animator>().enabled = false;
            transform.position = savePos;
            transform.localRotation = saveRot;
            //Debug.Log("SetCameraFlyMode()... rotationY:" + rotationY + " rotationX:" + rotationX);
        }
    }

    public float mouseCameraSensitivity = 90f;
    public float wiiCameraSensitivity = 30f;
    private float climbSpeed = 8f;
    private float normalMoveSpeed = 12f;
    public float slowMoveFactor = 0.25f;
    public float fastMoveFactor = 3f;

    private float rotationX = 0.0f;
    private float rotationY = 0.0f;
    private float rotationZ = 0.0f;

    /// <summary>
    /// Updates the fly cam keyboard input.
    /// </summary>
    private void UpdateFlyCamKeyboardInput()
    {
        rotationX += Input.GetAxis("Mouse X") * mouseCameraSensitivity * Time.deltaTime;
        rotationY += Input.GetAxis("Mouse Y") * mouseCameraSensitivity * Time.deltaTime;

        rotationX = Mathf.Clamp(rotationX, minXRotation, maxXRotation);
        rotationY = Mathf.Clamp(rotationY, minYRotation, maxYRotation);

        transform.localRotation = Quaternion.Euler( new Vector3(rotationX, rotationY, rotationZ) );

        //Debug.Log("UpdateFlyCamKeyboardInput()... 2 rotationY:" + rotationY + " rotationX:" + rotationX);

        if (Input.GetKey(KeyCode.LeftShift) || Input.GetKey(KeyCode.RightShift))
        {
            transform.position += transform.forward * (normalMoveSpeed * fastMoveFactor) * Input.GetAxis("Vertical") * Time.deltaTime;
            transform.position += transform.right * (normalMoveSpeed * fastMoveFactor) * Input.GetAxis("Horizontal") * Time.deltaTime;
        }
        else if (Input.GetKey(KeyCode.LeftControl) || Input.GetKey(KeyCode.RightControl))
        {
            transform.position += transform.forward * (normalMoveSpeed * slowMoveFactor) * Input.GetAxis("Vertical") * Time.deltaTime;
            transform.position += transform.right * (normalMoveSpeed * slowMoveFactor) * Input.GetAxis("Horizontal") * Time.deltaTime;
        }
        else
        {
            transform.position += transform.forward * normalMoveSpeed * Input.GetAxis("Vertical") * Time.deltaTime;
            transform.position += transform.right * normalMoveSpeed * Input.GetAxis("Horizontal") * Time.deltaTime;
        }

        if (Input.GetKey(KeyCode.Q))
            transform.position += transform.up * climbSpeed * Time.deltaTime; 
        if (Input.GetKey(KeyCode.E)) 
            transform.position -= transform.up * climbSpeed * Time.deltaTime; 
        if (Input.GetKey(KeyCode.W)) 
            transform.position += transform.forward * normalMoveSpeed  * Time.deltaTime; 
        if (Input.GetKey(KeyCode.A)) 
            transform.position -= transform.right * normalMoveSpeed * Time.deltaTime; 
        if (Input.GetKey(KeyCode.S)) 
            transform.position -= transform.forward * normalMoveSpeed * Time.deltaTime; 
        if (Input.GetKey(KeyCode.D)) 
            transform.position += transform.right * normalMoveSpeed * Time.deltaTime; 

        if (Input.GetKeyDown(KeyCode.End))
        {
            Cursor.visible = (Cursor.visible == false) ? true : false;
        }
    }

    /// <summary>
    /// Gets the base input.
    /// </summary>
    /// <returns>The base input.</returns>
    private Vector3 GetBaseInput()
    { 
        Vector3 p_Velocity = new Vector3(0, 0, 0);
        if (Input.GetKey (KeyCode.W))
        {
            p_Velocity = new Vector3(0, 0 , 1);
        }
        if (Input.GetKey (KeyCode.S))
        {
            p_Velocity = new Vector3(0, 0 , -1);
        }
        if (Input.GetKey (KeyCode.A))
        {
            p_Velocity = new Vector3(-1, 0 , 0);
        }
        if (Input.GetKey (KeyCode.D))
        {
            p_Velocity = new Vector3(1, 0 , 0);
        }
        Debug.Log("p_Velocity:" + p_Velocity);
        return p_Velocity;
    }
}
