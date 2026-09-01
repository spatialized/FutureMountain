 using UnityEngine;
using UnityEngine.UI;
using TMPro;

// CC V3 only: replaces the shared TimeKnob with a 4-step speed slider.
// Dragging the slider sets the simulation's days-per-tick through the
// existing GameController API.
public class SpeedSliderCCV3 : MonoBehaviour
{
    [Header("Refs")]
    public GameController gameController;   // the scene's GameController
    public Slider slider;                   // Whole Numbers, Min 0, Max 3
 

    // index 0..3 -> days advanced per simulation tick (matches old knob feel)
    private readonly int[] daysPerStep = { 1, 10, 25, 45 };
    private readonly string[] stepNames = { "Daily", "Weekly", "Monthly", "Yearly" };

    void Start()
    {
        if (slider != null) ApplyStep((int)slider.value);   // push the initial speed
    }

    // Wire to the Slider's On Value Changed (Single).
    public void OnSpeedSlider(float v)
    {
        ApplyStep((int)v);
    }

    private void ApplyStep(int i)
    {
        i = Mathf.Clamp(i, 0, daysPerStep.Length - 1);
        if (gameController != null)
            gameController.HandleTimeSliderInput(daysPerStep[i]);   // set timeStep
    }
}