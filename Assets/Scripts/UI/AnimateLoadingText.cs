using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Assertions;
using UnityEngine.UI;

public class AnimateLoadingText : MonoBehaviour
{
    public Text text;
    public List<string> textStates;
    [SerializeField]
    private int curState = 0;
    private float lastTime = -10000f;
    private float timePerState = 1f;

    void Start()
    {
        Assert.IsNotNull(text);
        Assert.IsNotNull(textStates);
        Assert.IsTrue(textStates.Count > 0);

        lastTime = -10000f;
    }

    void Update()
    {
        if(ShouldSwitchState())
        {
            curState = (curState + 1) % textStates.Count;
            text.text = textStates[curState];
            lastTime = Time.time;
        }
    }

    bool ShouldSwitchState()
    {
        if(gameObject.activeInHierarchy == false)
            return false;

        return Time.time - lastTime > timePerState;
    }
}
