using UnityEngine;
using System.Collections;

public class MoveSphereINFINIGRASS : MonoBehaviour {

	public float Speed = 1;
	Transform this_transf;

	// Use this for initialization
	void Start () {
		this_transf = this.transform;
	}
	
	// Update is called once per frame
	void Update () {
		this_transf.position = new Vector3 (this_transf.position.x+Input.GetAxis ("Horizontal") * Speed * Time.deltaTime * 6,this_transf.position.y, this_transf.position.z+Input.GetAxis ("Vertical") * Speed * Time.deltaTime * 6);
	}
}
