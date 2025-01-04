using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Assertions;
using UnityEngine.UI;

public class BlinkContinueButton : MonoBehaviour
{
    public GameObject textObject;
    private Text text;

    void Start()
    {
        Assert.IsNotNull(textObject, "ERROR: Continue Button textObject is null");
        text = textObject.GetComponent<Text>();
        Assert.IsNotNull(text, "ERROR: Continue Button text is null");
    }

    void Update()
    {
        if(gameObject.activeSelf)
        {
            float alpha = Mathf.PingPong(Time.time, 1);
            Color color = text.color;
            color.a = alpha;
            text.color = color;
        }
    }
}

