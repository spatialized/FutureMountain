//using System.Collections;
using UnityEngine;
using UnityEngine.EventSystems;
using UnityEngine.UI;

/// <summary>
/// 360 slider component
/// </summary>
public class TimeKnobSlider : MonoBehaviour, IBeginDragHandler, IDragHandler, IEndDragHandler, IPointerClickHandler
{
    public GameController gameController;

    private static float zeroPos = 0.075f;
    private static float maxPos = 0.925f;

    public static float zeroAngle = 30f;
    public static float maxAngle = 330f;

    public GameObject thumbSign;
    public Image foreground;
    public Text label;
    public string format = "{0:00.00}";
    public float timeScale { get; set; } = 0f;                        // Time scale value
    public float angle_Z = 0f;
    //private float angleAdjustAmt = 0f;

    public float minValue = 1f; 
    public float maxValue = 60f;

    /// <summary>
    /// Start
    /// </summary>
    private void Start()
    {
        SetAngle(zeroAngle);
        //this.SetValue(zeroAngle + 1f);
    }

    /// <summary>
    /// Mouse drag on slider.
    /// Calculate angle and set value
    /// </summary>
    /// <param name="eventData"></param>
    public void OnDrag(PointerEventData eventData)
    {
        RespondToInput(eventData.position);

        // if (this.label != null) this.label.text = string.Format(this.format, this.value);
        // this.thumbSign.transform.rotation = Quaternion.Euler(0, 0, angle_Z);
    }

    /// <summary>
    /// Gets the circle value.
    /// </summary>
    /// <returns>The circle value.</returns>
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
    /// Sets slider angle.
    /// </summary>
    /// <param name="newAngle">New angle in degrees.</param>
    public void SetAngle(float newAngle)
    {
        //Debug.Log("SetAngle:" + newAngle);
        angle_Z = newAngle;

        angle_Z = Mathf.Clamp(angle_Z, zeroAngle, maxAngle);
        timeScale = ConstrainValueRange(angle_Z) / 360f;

        this.foreground.fillAmount = this.timeScale;
        timeScale = Mathf.Clamp(MapValue(timeScale, zeroPos, maxPos, minValue, maxValue), minValue, maxValue);

        angle_Z *= -1f;

        //Debug.Log("SetAngle()... timeScale:" + timeScale);

        this.thumbSign.transform.rotation = Quaternion.Euler(0, 0, angle_Z);
        if (this.label != null) this.label.text = string.Format(this.format, this.timeScale);
    }

    /// <summary>
    /// Sets knob value and angle from given time step.
    /// </summary>
    /// <param name="newTimeStep">New time step.</param>
    public void SetValue(int newTimeStep)
    {
        timeScale = (float)newTimeStep;
        //Debug.Log("SetValue()... timeScale:" + timeScale);
        float newAngle = MapValue(timeScale, minValue, maxValue, zeroPos, maxPos);
        //Debug.Log("SetValue()... newAngle:" + newAngle);
        SetAngle(newAngle * 360f);

    }

    /// <summary>
    /// Update this instance.
    /// </summary>
    private void Update()
    {

    }


    public void OnPointerClick(PointerEventData eventData)
    {
        //Output to console the clicked GameObject's name and the following message. You can replace this with your own actions for when clicking the GameObject.
       // Debug.Log(name + " Game Object Clicked!");

        RespondToInput(eventData.position);

        //if (this.label != null) this.label.text = string.Format(this.format, this.value);
        //this.thumbSign.transform.rotation = Quaternion.Euler(0, 0, angle_Z);
    }

    private void RespondToInput(Vector2 eventPosition)
    {
        Vector2 thumbPos = this.transform.position;
        Vector2 direction = thumbPos - eventPosition;
        direction.Normalize();

        angle_Z = Vector3.Angle(direction, new Vector3(0, -1, 0));

        float check = (360 - ((direction.x > 0) ? angle_Z : 360 - angle_Z)) / 360f;
        if (check >= 0f && check <= 1f)
            timeScale = check;
        else
            return;

        angle_Z = (direction.x > 0) ? angle_Z : -angle_Z;
        angle_Z = GetCircleValue(angle_Z);

        angle_Z = Mathf.Clamp(angle_Z, zeroAngle, maxAngle);
        timeScale = ConstrainValueRange(timeScale);

        this.foreground.fillAmount = timeScale;
        timeScale = MapValue(timeScale, zeroPos, maxPos, 1f, maxValue);

        angle_Z *= -1f;

        gameController.HandleTimeSliderInput((int)timeScale);

        this.thumbSign.transform.rotation = Quaternion.Euler(0, 0, angle_Z);
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
    /// Finds the discretized angle value of thumb sign.
    /// </summary>
    /// <param name="val">Value.</param>
    private float DiscretizeAngleValue(float val)
    {
        float result = val;
        if (val < maxAngle - 0.001f) result = zeroAngle;
        else if (val < zeroAngle - 0.001f) result = maxAngle;
        else if (val < 0f) result = zeroAngle;
        else if (val >= 0f) result = zeroAngle;
        return result;
    }

    /// <summary>
    /// Find discretized slider value
    /// </summary>
    /// <returns>The value.</returns>
    /// <param name="val">Value.</param>
    private float ConstrainValueRange(float val)
    {
        float result = val;
        if (val < zeroPos) result = zeroPos;
        else if (val > maxPos) result = maxPos;
        //Debug.Log("ConstrainValueRange()... val:" + val+ " result:"+ result);
        return result;
    }

    /// <summary>
    /// Gets warming index from slider value.
    /// </summary>
    /// <returns>The warming index.</returns>
    public int GetTimeScaleIdx()
    {
        int timeScaleIdx = 0;

        if (Mathf.Abs(timeScale - zeroPos) < 0.01f)
            timeScaleIdx = 0;
        else if (Mathf.Abs(timeScale - maxPos) < 0.01f)
            timeScaleIdx = 1;
        else if (Mathf.Abs(timeScale - 0.5f) < 0.01f)
            timeScaleIdx = 1;
        else
        {
            timeScaleIdx = (int)Mathf.Clamp(MapValue(timeScale, 0f, 1f, 0f, maxValue), 0f, 1f);
        }

        Debug.Log(" >>> GetTimeScaleIdx()... timeScaleIdx:" + timeScaleIdx);

        return timeScaleIdx;
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