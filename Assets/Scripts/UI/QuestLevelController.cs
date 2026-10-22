using UnityEngine;
using UnityEngine.UI;
using TMPro;
using System.Collections.Generic;

public class QuestLevelController : MonoBehaviour
{
    [Header("Content")]
    public QuestLevelData[] levels;   // drag Quest1_Level1 / _Level2 / _Level3 in order
    public TMP_Text titleText;        // header showing the current level's title
    private int levelIdx = 0;
    private QuestLevelData level;      // current level (set from levels[levelIdx])

    [Header("UI")]
    public TMP_Text openingText;        // optional
    public TMP_Text questionText;
    public Button[] answerButtons;      // pre-placed; extras auto-hidden
    public GridLayoutGroup answerGrid;  // Grid Layout Group on the Answer panel (drives rows/cols)
    public Button nextButton;
    public ZoneGraph graph;            // optional; null in FreePlay/BigCreek mode
    public GameObject graphVariableDropdown;   // the data-variable picker; hidden on precip-only levels (L1)
    public RectTransform questPanel;   // outermost panel (has Content Size Fitter); force-rebuilt when text/answers change

    [Header("Answer layout")]
    public Vector2 buttonPadding = new Vector2(40f, 24f);   // space around text (x=width, y=height)
    public float minButtonWidth = 120f;
    public float maxButtonWidth = 320f;                     // text wraps once wider than this
    public float maxAnswerRowWidth = 600f;                  // a row never exceeds this; columns wrap instead (prevents canvas overflow)

    [Header("Feedback colors")]
    public Color normalColor  = Color.white;
    public Color correctColor = new Color(0.60f, 0.90f, 0.60f);   // green
    public Color wrongColor   = new Color(0.95f, 0.60f, 0.60f);   // red

    private int idx = 0;
    private bool correctlyAnswered = false;
    private bool inOpening = true;
    private bool inEnding = false;   // showing the level's closing message before advancing

    // Level 3 vegetation dropdown: option order maps 1:1 to these variables.
    static readonly CubeController.ZoneGraphVariable[] VegVars = {
        CubeController.ZoneGraphVariable.Biomass,
        CubeController.ZoneGraphVariable.NPP,
        CubeController.ZoneGraphVariable.GPP,
        CubeController.ZoneGraphVariable.Respiration,
        CubeController.ZoneGraphVariable.Transpiration,
        CubeController.ZoneGraphVariable.Height,
    };
    static readonly string[] VegLabels = { "Biomass", "Productivity (NPP)", "GPP", "Respiration", "Transpiration", "Height" };

    void Start()
    {
        levelIdx = 0;
        if (levels != null && levels.Length > 0) level = levels[0];
        ShowOpening();
    }

    void ShowOpening()
    {
        if (titleText != null && level != null) titleText.text = level.title;
        inOpening = true;
        inEnding = false;
        if (openingText != null)
        {
            openingText.gameObject.SetActive(true);
            if (level != null) openingText.text = level.opening;
        }
        if (graph != null) graph.SetSuppressed(true);

        // Per-level graph variable control:
        //  precipOnly (Q1 L1)        -> lock to Precip, hide the dropdown
        //  lockedGraphVariable >= 0  -> lock to that variable, hide the dropdown (Q2 L1=Biomass, L2=Height)
        //  graphVegVariables (Q1 L3) -> fill the dropdown with the vegetation set, show it
        //  otherwise                 -> default climate dropdown, show it
        bool precipOnly = (level != null && level.graphPrecipOnly);
        bool lockedVar  = (level != null && level.lockedGraphVariable >= 0);
        bool vegVars    = (level != null && level.graphVegVariables && !lockedVar && !precipOnly);
        if (graphVariableDropdown != null) graphVariableDropdown.SetActive(!precipOnly && !lockedVar);
        if (graph != null) graph.variableOptions = vegVars ? VegVars : null;

        if (precipOnly && graph != null)
            graph.SetVariable(CubeController.ZoneGraphVariable.Precip);
        else if (lockedVar && graph != null)
            graph.SetVariable((CubeController.ZoneGraphVariable)level.lockedGraphVariable);
        else if (vegVars)
        {
            if (graphVariableDropdown != null)
            {
                var dd = graphVariableDropdown.GetComponent<TMP_Dropdown>();
                if (dd != null)
                {
                    dd.ClearOptions();
                    dd.AddOptions(new System.Collections.Generic.List<string>(VegLabels));
                    dd.SetValueWithoutNotify(0);
                }
            }
            if (graph != null) graph.SetVariable(VegVars[0]);
        }

        foreach (var b in answerButtons) if (b != null) b.gameObject.SetActive(false);
        if (answerGrid != null) answerGrid.gameObject.SetActive(false);   // hide panel during opening
        if (graph != null) graph.gameObject.SetActive(false);
        RebuildPanelLayout();
        if (nextButton != null) nextButton.interactable = true;   // Next usable to leave the opening

        if (GameController.Instance != null && GameController.Instance.cameraController != null)
        {
            GameController.Instance.cameraController.zoomOutLocked = (level != null && level.lockZoomOut);
            if (level != null && level.lockZoomOut)
                GameController.Instance.SetZoomOutButtonActive(false);

            // Per-level side-by-side mode availability (CC V3; greys the toggle when not allowed)
            GameController.Instance.SetSideBySideAllowed(level != null && level.allowSideBySide);
            GameController.Instance.SetDifferentCubesAllowed(level != null && level.allowDifferentCubes);
        }

        // Quest2: force a scenario (and disable the picker) or leave it free.
        if (GameController.Instance != null && GameController.Instance.scenarioDropdown != null)
        {
            int ls = (level != null) ? level.lockedScenario : -1;
            if (ls >= 0)
            {
                GameController.Instance.scenarioDropdown.SetValueWithoutNotify(ls);
                GameController.Instance.OnScenarioChanged(ls);   // actually load that scenario's data
                GameController.Instance.scenarioDropdown.interactable = false;
            }
            else
            {
                GameController.Instance.scenarioDropdown.interactable = true;
            }
        }
    }
    public void ShowQuestion(int i)
    {
        idx = i;
        correctlyAnswered = false;
        var q = level.questions[i];
        questionText.text = q.prompt;

        if (q.graphSelect)
        {
            if (graph != null) graph.ClearSelections();
                foreach (var b in answerButtons) if (b != null) b.gameObject.SetActive(false);
                if (answerGrid != null) answerGrid.gameObject.SetActive(false);   // graph-select: no answer panel
                if (nextButton != null) nextButton.interactable = true;
                RebuildPanelLayout();
                return;
        }
        if (answerGrid != null) answerGrid.gameObject.SetActive(true);   // multiple-choice: show answer panel
        if (nextButton != null) nextButton.gameObject.SetActive(true);

        string[] opts = (q.options != null && q.options.Length > 0) ? q.options : level.defaultOptions;
        for (int b = 0; b < answerButtons.Length; b++)
        {
            bool used = b < opts.Length;
            answerButtons[b].gameObject.SetActive(used);
            if (!used) continue;
            answerButtons[b].GetComponentInChildren<TMP_Text>().text = opts[b];
            SetButtonColor(b, normalColor);
            int captured = b;
            answerButtons[b].onClick.RemoveAllListeners();
            answerButtons[b].onClick.AddListener(() => OnAnswer(captured));
        }
        LayoutAnswerButtons(opts);
        RebuildPanelLayout();
        if (nextButton != null) nextButton.interactable = true;   // must answer correctly first
    }

    // Arrange the active answer buttons in a grid whose column count and cell size
    // adapt to how many options there are and how wide the widest option is.
    void LayoutAnswerButtons(string[] opts)
    {
        if (answerGrid == null || opts == null) return;
        int n = Mathf.Min(opts.Length, answerButtons.Length);
        if (n == 0) return;

        // Cell width = widest option's single-line text (clamped), so buttons fit content.
        var sample = answerButtons[0].GetComponentInChildren<TMP_Text>();
        float widest = 0f;
        for (int i = 0; i < n; i++)
            widest = Mathf.Max(widest, sample.GetPreferredValues(opts[i]).x);
        float cellW = Mathf.Clamp(widest + buttonPadding.x, minButtonWidth, maxButtonWidth);

        // Columns per row: 1-3 -> single row; 4 -> 2x2; 5+ -> 3 across (5 becomes 3+2).
        int cols;
        if (n <= 3)      cols = n;
        else if (n == 4) cols = 2;
        else             cols = 3;
        // Clamp columns so a row never exceeds maxAnswerRowWidth; wider buttons wrap to extra rows
        // instead of running off the canvas (e.g. 3 wide options become 2+1 or stack vertically).
        float spacingX = answerGrid.spacing.x;
        int fitCols = Mathf.Max(1, Mathf.FloorToInt((maxAnswerRowWidth + spacingX) / (cellW + spacingX)));
        cols = Mathf.Max(1, Mathf.Min(cols, fitCols));
        answerGrid.constraint = GridLayoutGroup.Constraint.FixedColumnCount;
        answerGrid.constraintCount = cols;

        // Cell height = tallest option once wrapped to that width.
        float textW = cellW - buttonPadding.x;
        float tallest = 0f;
        for (int i = 0; i < n; i++)
            tallest = Mathf.Max(tallest, sample.GetPreferredValues(opts[i], textW, 0f).y);
        float cellH = tallest + buttonPadding.y;

        answerGrid.cellSize = new Vector2(cellW, cellH);
    }

    // Nested Content Size Fitters don't recompute reliably in the same frame a
    // script changes the text, so a longer question can keep the previous (shorter)
    // height and let the answer panel overlap the text. Force an immediate rebuild.
    void RebuildPanelLayout()
    {
        if (questPanel == null) return;
        if (questionText != null) questionText.ForceMeshUpdate();   // refresh TMP preferred size first
        if (openingText  != null) openingText.ForceMeshUpdate();
        Canvas.ForceUpdateCanvases();
        LayoutRebuilder.ForceRebuildLayoutImmediate(questPanel);
    }

    void OnAnswer(int b)
    {
        if (correctlyAnswered) return;                             // lock once correct
        bool correct = (b == level.questions[idx].correctIndex);
        SetButtonColor(b, correct ? correctColor : wrongColor);
        if (correct)
        {
            correctlyAnswered = true;
            if (nextButton != null) nextButton.interactable = true;
        }
    }

    public void OnNext()   // wire to Next button's OnClick
    {
    if (inOpening)
            {
                inOpening = false;
                if (openingText != null) openingText.gameObject.SetActive(false);
                if (questionText != null) questionText.gameObject.SetActive(true);
                if (graph != null) graph.SetSuppressed(false);   // show graph once questions start
                ShowQuestion(0);
                return;
            }

            if (inEnding)   // Next pressed on the closing message -> advance to the next level
            {
                inEnding = false;
                AdvanceLevel();
                return;
            }

            if (!correctlyAnswered)
            {
                var q = level.questions[idx];
                if (q.graphSelect) CheckGraphAnswer();
                return;
            }

            if (idx + 1 < level.questions.Count) ShowQuestion(idx + 1);
            else if (!string.IsNullOrEmpty(level.ending)) ShowEnding();
            else AdvanceLevel();
    }

    // Closing message for the level (reuses the opening text block). Next then advances.
    void ShowEnding()
    {
        inEnding = true;
        if (questionText != null) questionText.gameObject.SetActive(false);
        if (openingText != null)
        {
            openingText.gameObject.SetActive(true);
            openingText.text = level.ending;
        }
        foreach (var b in answerButtons) if (b != null) b.gameObject.SetActive(false);
        if (answerGrid != null) answerGrid.gameObject.SetActive(false);
        if (graph != null) { graph.SetSuppressed(true); graph.gameObject.SetActive(false); }
        if (nextButton != null) nextButton.interactable = true;
        RebuildPanelLayout();
    }

    private void SetButtonColor(int b, Color c)
    {
        var img = answerButtons[b].GetComponent<Image>();
        if (img != null) img.color = c;
    }

    void CheckGraphAnswer()
        {
            var q = level.questions[idx];
            bool allCorrect = q.correctYearsByScenario != null && q.correctYearsByScenario.Count >= 3;
            for (int s = 0; s < 3 && allCorrect; s++)
            {
                var selectedIdx = (graph != null) ? graph.GetSelectedYears(s) : null;
                var selectedYears = new HashSet<int>();
                if (selectedIdx != null)
                    foreach (int di in selectedIdx) selectedYears.Add(di + 1);   // dataIndex -> "Year N"
                var correct = new HashSet<int>(q.correctYearsByScenario[s].years ?? new int[0]);
                if (!selectedYears.SetEquals(correct)) allCorrect = false;
            }

            if (allCorrect)
            {
                correctlyAnswered = true;
                if (nextButton != null) nextButton.interactable = true;
                questionText.text = q.prompt + "\n<color=green>Correct!</color>";
            }
            else
            {
                questionText.text = q.prompt + "\n<color=red>Not quite — try again.</color>";
                if (graph != null) graph.ClearSelections();   // reset selections on incorrect
            }
        }
     void AdvanceLevel()
    {
        if (levels != null && levelIdx + 1 < levels.Length)
            LoadLevel(levelIdx + 1);
        else
            questionText.text = "Quest complete!";
    }

    // Jump straight to a level (roadmap buttons + AdvanceLevel both use this).
    public void LoadLevel(int i)
    {
        if (levels == null || levels.Length == 0) return;
        levelIdx = Mathf.Clamp(i, 0, levels.Length - 1);
        level = levels[levelIdx];
        idx = 0;
        correctlyAnswered = false;
        ShowOpening();

        if (GameController.Instance != null && GameController.Instance.cameraController != null)
        {
            if (level.lockZoomOut)
                GameController.Instance.cameraController.SnapZoomIntoCube(-1);   // aggregate view (L1/L2)
            else
                GameController.Instance.ShowZoneCubeView();                      // zone overview (L3)
        }
      }
}