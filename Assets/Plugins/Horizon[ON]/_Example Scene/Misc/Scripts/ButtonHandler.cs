using UnityEngine;
using UnityEngine.UI;
using UnityEngine.EventSystems;
using System.Collections;

public class ButtonHandler : MonoBehaviour, IPointerDownHandler, IPointerUpHandler, IPointerExitHandler {

	public MonoBehaviour script;
	public string invoke;
	bool pointerDown = false;
	
	void Update () {
		if (pointerDown) {
			script.Invoke(invoke,0); 	
		}
	}
	public void OnPointerDown(PointerEventData eventData){
		pointerDown = true;
	}
	public void OnPointerUp(PointerEventData eventData){
		pointerDown = false;
	}
	public void OnPointerExit(PointerEventData eventData){
		pointerDown = false;
	}
}
