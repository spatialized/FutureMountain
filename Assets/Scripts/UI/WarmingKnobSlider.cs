//using System.Collections;
using UnityEngine;
using UnityEngine.EventSystems;
using UnityEngine.UI;

/// <summary>
/// 360 slider component
/// </summary>
public class WarmingKnobSlider : MonoBehaviour, IBeginDragHandler, IDragHandler, IEndDragHandler, IPointerClickHandler
{
    public bool respondToUser = true;

    private static float zeroPos = 0f;
    private static float onePos = 0.25f;
    private static float twoPos = 0.33f;
    private static float fourPos = 0.66f;
    private static float sixPos = 0.88f;

    private static float zeroAngle = 0f;
    private static float oneAngle = 40f;
    private static float twoAngle = 94f;
    private static float fourAngle = 205f;
    private static float sixAngle = 300f;

    public GameObject thumbSign;
    public Image foreground;
    public Text label;
    public string format = "{0:00.00}";
    public int warmingValue = 0;                           // Warming index value (0-4)
    public float angle_Z = 0f;
    private float angleAdjustAmt = 0f;

    public bool isSideBySideKnob = false;                   // Is it a knob for Side-by-Side Mode?
    public bool isComparedCubeKnob = false;                 // Is it the cube on the right

    /// <summary>
    /// Start
    /// </summary>
    private void Start()
    {
        this.SetAngle(zeroAngle);
    }

    /// <summary>
    /// Mouse drag on slider.
    /// Calculate angle and set value
    /// </summary>
    /// <param name="eventData"></param>
    public void OnDrag(PointerEventData eventData)
    {
        if (respondToUser)
        {
            RespondToInput(eventData.position);


            //if (this.label != null) this.label.text = string.Format(this.format, this.value);
            //this.thumbSign.transform.rotation = Quaternion.Euler(0, 0, angle_Z);
        }
    }

    /// <summary>
    /// Sets the angle.
    /// </summary>
    /// <param name="newAngle">New angle.</param>
    public void SetAngle(float newAngle)
    {
        angle_Z = newAngle;
        this.thumbSign.transform.rotation = Quaternion.Euler(0, 0, angle_Z);
        warmingValue = GetValueFromAngle();

        //Debug.Log(name + ".SetAngle()... Chose warmingValue:" + warmingValue+ " newAngle:"+ newAngle);

        if (this.label != null) this.label.text = string.Format(this.format, warmingValue);
    }

    /// <summary>
    /// Gets the value from angle.
    /// </summary>
    /// <returns>The value from angle.</returns>
    public int GetValueFromAngle()
    {
        float val = angle_Z * -1f;
        int result;

        if (val > sixAngle + 0.001f) result = 0;
        else if (val > fourAngle + 0.001f) result = 6;
        else if (val > twoAngle + 0.001f) result = 4;
        else if (val > oneAngle + 0.001f) result = 2;
        else if (val > zeroAngle + 0.001f) result = 1;
        else if (val <= 0f) result = 0;
        else result = 0;

        return result;
    }

    /// <summary>
    /// Set slider value.
    /// </summary>
    /// <param name="val"></param>
    //public void SetValue(float val)
    //{
    //    //val -= 0.1f;

    //    Debug.Log("SetValue()... val:" + val);
    //    this.value = DiscretizeValue(val);
    //    //Debug.Log(" SetValue()... this.value:" + this.value);

    //    angle_Z = this.value * 360f;
    //    //angle_Z = this.value * -360f;
    //    Debug.Log(" SetValue()... angle_Z 1: " + angle_Z);
    //    //angle_Z = this.value * 360f;
    //    //angle_Z = DiscretizeAngleValue(angle_Z) + angleAdjustAmt;
    //    angle_Z = -DiscretizeAngle(angle_Z) + angleAdjustAmt;
    //    Debug.Log(" SetValue()... angle_Z 2: " + angle_Z);

    //    //angle_Z *= -1f;

    //    //this.thumbSign.transform.rotation = Quaternion.Euler(0, 0, angle_Z);
    //    //if (this.label != null) this.label.text = string.Format(this.format, this.value);
    //}

    /// <summary>
    /// Adjusts dragged slider value to match 0f to 360f range.
    /// </summary>
    /// <param name="val">Value.</param>
    private float GetCircleValue(float val)
    {
        float result = val;

        if (result < -180f)
            result = -180f;
        else if (result > 180f)
            result = 180f;

        if (result < 0f)
            result = result * -1f;
        else if (result > 0f)
            result = MapValue(180f - result, 0f, 180f, 180f, 360f);

        return result;
    }

    /// <summary>
    /// Finds the discretized angle value of thumb sign.
    /// </summary>
    /// <param name="val">Value.</param>
    private float DiscretizeAngle(float val)
    {
        float result = val;
        if (val > sixAngle - 0.001f) result = zeroAngle;
        else if (val > fourAngle - 0.001f) result = sixAngle;
        else if (val > twoAngle - 0.001f) result = fourAngle;
        else if (val > oneAngle - 0.001f) result = twoAngle;
        else if (val > zeroAngle) result = oneAngle;
        else if (val <= 0f) result = zeroAngle;
        return result;
    }

    [Range(0f, 1f)]
    public float valueTest = 0f;
    [ContextMenu("DiscreteValueTest")]
    private float DiscreteValue()
    {
        float result = valueTest;
        if (valueTest <= zeroPos) result = zeroPos;
        else if (valueTest < onePos) result = onePos;
        else if (valueTest < twoPos) result = twoPos;
        else if (valueTest < fourPos) result = fourPos;
        else if (valueTest <= sixPos) result = sixPos;
        else if (valueTest > sixPos) result = zeroPos;

        //Debug.Log("result:" + result);
        return result;
    }

    /// <summary>
    /// Find discretized slider value
    /// </summary>
    /// <returns>The value.</returns>
    /// <param name="val">Value.</param>
    private float DiscretizeValue(float val)
    {
        float result = val;
        if (val <= zeroPos) result = zeroPos;
        else if (val < onePos) result = onePos;
        else if (val < twoPos) result = twoPos;
        else if (val < fourPos) result = fourPos;
        else if (val <= sixPos) result = sixPos;
        else if (val > sixPos) result = zeroPos;
        return result;
    }

    /// <summary>
    /// Gets warming index in degrees from slider value.
    /// </summary>
    /// <returns>The warming index.</returns>
    public int GetWarmingIdxAbsoluteValue()
    {
        return warmingValue;
    }

    public int GetWarmingDegrees()
    {
        switch (warmingValue)
        {
            case 0:                 // Baseline
                return 0;
            case 1:                 // 1 Degree
                return 1;
            case 2:                 // 2 Degrees
                return 2;
            case 4:                 // 4 Degrees
                return 4;
            case 6:                 // 6 Degrees
                return 6;
        }
        return warmingValue;
    }

    /// <summary>
    /// Gets warming index (Range: 0-4) from slider value.    
    /// </summary>
    /// <returns>The warming index.</returns>
    public int GetWarmingIndex()
    {
        switch(warmingValue)
        {
            case 0:                 // Baseline
                return 0;
            case 1:                 // 1 Degree
                return 1;
            case 2:                 // 2 Degrees
                return 2;
            case 4:                 // 4 Degrees
                return 3;
            case 6:                 // 6 Degrees
                return 4;
        }
        return warmingValue;
    }

    // Update is called once per frame
    private void Update()
    {

    }

    public void OnPointerClick(PointerEventData eventData)
    {
        //Output to console the clicked GameObject's name and the following message. You can replace this with your own actions for when clicking the GameObject.
        //Debug.Log(name + " Game Object Clicked!");

        if (respondToUser)
        {
           // RespondToInput(eventData.position);

            //if (this.label != null) this.label.text = string.Format(this.format, this.value);
            //this.thumbSign.transform.rotation = Quaternion.Euler(0, 0, angle_Z);
        }
    }

    /// <summary>
    /// Respond to user input (click or drag)
    /// </summary>
    /// <param name="eventPosition"></param>
    private void RespondToInput(Vector2 eventPosition)
    {
        Vector2 thumbPos = this.transform.position;
        Vector2 direction = thumbPos - eventPosition;
        direction.Normalize();
        angle_Z = Vector3.Angle(direction, new Vector3(0, -1, 0));

        float check = (360 - ((direction.x > 0) ? angle_Z : 360 - angle_Z)) / 360f;

        if (check < 0f || check > 1f)
            return;

        //Debug.Log("direction.x:" + direction.x + " angle_Z :" + angle_Z);
        angle_Z = (direction.x > 0) ? angle_Z : -angle_Z;

        angle_Z = GetCircleValue(angle_Z);
        angle_Z = DiscretizeAngle(angle_Z) + angleAdjustAmt;

        angle_Z *= -1f;

        SetAngle(angle_Z);

        //Debug.Log("RespondToInput()... warmingValue: " + warmingValue + " isSideBySideKnob:"+isSideBySideKnob);

        if (isSideBySideKnob)               // TO DO: Generalize for cubes besides Cube B
        {
            if (isComparedCubeKnob)
            {
                GameController.Instance.SetSBSWarmingLevel(GetWarmingIndex(), GetWarmingDegrees(), true);
            }
            else
            {
                GameController.Instance.SetSBSWarmingLevel(GetWarmingIndex(), GetWarmingDegrees(), false);
            }
        }
    }

    /// <summary>
    /// Callback when drag event began
    /// </summary>
    /// <param name="eventData"></param>
    public void OnBeginDrag(PointerEventData eventData)
    {

    }

    /// <summary>
    /// Callback when drag event end
    /// </summary>
    /// <param name="eventData"></param>
    public void OnEndDrag(PointerEventData eventData)
    {

    }

    /// <summary>
    /// Maps value from one range to another.
    /// </summary>
    /// <returns>The value.</returns>
    /// <param name="value">Value.</param>
    /// <param name="from1">From1.</param>
    /// <param name="to1">To1.</param>
    /// <param name="from2">From2.</param>
    /// <param name="to2">To2.</param>
    public static float MapValue(float value, float from1, float to1, float from2, float to2)
    {
        return (value - from1) / (to1 - from1) * (to2 - from2) + from2;
    }
}