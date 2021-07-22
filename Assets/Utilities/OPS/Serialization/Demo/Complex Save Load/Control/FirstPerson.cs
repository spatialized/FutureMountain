using UnityEngine;
using System.Collections;

public class FirstPerson : MonoBehaviour
{

    public enum RotationAxes { MouseXAndY = 0, MouseX = 1, MouseY = 2 }
    public RotationAxes axes = RotationAxes.MouseXAndY;
    private float sensitivityX = 5f;
    private float sensitivityY = 5f;

    //private float minimumX = 0f;
    //private float maximumX = 360f;

    private float minimumY = -30f;
    private float maximumY = 45f;

    private float rotationY = 0f;

    void Update()
    {
        if (axes == RotationAxes.MouseXAndY)
        {
            float rotationX = transform.localEulerAngles.y + Input.GetAxis("Mouse X") * sensitivityX;

            rotationY += Input.GetAxis("Mouse Y") * sensitivityY;
            rotationY = Mathf.Clamp(rotationY, minimumY, maximumY);

            transform.localEulerAngles = new Vector3(-rotationY, rotationX, 0);
        }
        else if (axes == RotationAxes.MouseX)
        {
            transform.Rotate(0, Input.GetAxis("Mouse X") * sensitivityX, 0);
        }
        else
        {
            rotationY += Input.GetAxis("Mouse Y") * sensitivityY;
            rotationY = Mathf.Clamp(rotationY, minimumY, maximumY);

            transform.localEulerAngles = new Vector3(-rotationY, transform.localEulerAngles.y, 0);
        }

        float speed = 0.1f;
        Vector3 moving = new Vector3();
        if(Input.GetKey(KeyCode.W))
        {
            moving += new Vector3(this.transform.forward.normalized.x, 0, this.transform.forward.normalized.z);
        }
        if (Input.GetKey(KeyCode.A))
        {
            moving -= new Vector3(this.transform.right.normalized.x, 0, this.transform.right.normalized.z);
        }
        if (Input.GetKey(KeyCode.S))
        {
            moving -= new Vector3(this.transform.forward.normalized.x, 0, this.transform.forward.normalized.z);
        }
        if (Input.GetKey(KeyCode.D))
        {
            moving += new Vector3(this.transform.right.normalized.x, 0, this.transform.right.normalized.z);
        }
        this.transform.position += moving * speed;
    }
}