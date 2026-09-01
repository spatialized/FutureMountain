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
    public RectTransform questPanel;   // outermost panel (has Content Size Fitter); force-rebuilt when text/answers change

    [Header("Answer layout")]
    public Vector2 buttonPadding = new Vector2(40f, 24f);   // space around text (x=width, y=height)
    public float minButtonWidth = 120f;
    public float maxButtonWidth = 320f;                     // text wraps once wider than this

    [Header("Feedback colors")]
    public Color normalColor  = Color.white;
    public Color correctColor = new Color(0.60f, 0.90f, 0.60f);   // green
    public Color wrongColor   = new Color(0.95f, 0.60f, 0.60f);   // red

    private int idx = 0;
    private bool correctlyAnswered = false;
    private bool inOpening = true;

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
        if (openingText != null)
        {
            openingText.gameObject.SetActive(true);
            if (level != null) openingText.text = level.opening;
        }
        if (graph != null) graph.SetSuppressed(true);
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

        // Columns per row: 1-3 -> single row; 4 -> 2x2; 5+ -> 3 across (5 becomes 3+2).
        int cols;
        if (n <= 3)      cols = n;
        else if (n == 4) cols = 2;
        else             cols = 3;
        answerGrid.constraint = GridLayoutGroup.Constraint.FixedColumnCount;
        answerGrid.constraintCount = cols;

        // Cell width = widest option's single-line text (clamped), so buttons fit content.
        var sample = answerButtons[0].GetComponentInChildren<TMP_Text>();
        float widest = 0f;
        for (int i = 0; i < n; i++)
            widest = Mathf.Max(widest, sample.GetPreferredValues(opts[i]).x);
        float cellW = Mathf.Clamp(widest + buttonPadding.x, minButtonWidth, maxButtonWidth);

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

            if (!correctlyAnswered)
            {
                var q = level.questions[idx];
                if (q.graphSelect) CheckGraphAnswer(); 
                return;    
            }

            if (idx + 1 < level.questions.Count) ShowQuestion(idx + 1);
            else AdvanceLevel();
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