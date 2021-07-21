using UnityEngine;
using UnityEngine.UI;
using System.Collections;

public class ButtonSetColorOnClick : MonoBehaviour {

	public Color color1;
	public Color color2;

	public void SetColor1 () {
		GetComponent<Text> ().color = color1;
	}
	public void SetColor2 () {
		GetComponent<Text> ().color = color2;
	}
}
