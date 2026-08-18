using UnityEngine;
  using UnityEngine.UI;
  using TMPro;

  public class QuestLevelController : MonoBehaviour
  {
      [Header("Content")]
      public QuestLevelData level;        // drag the .asset here

      [Header("UI")]
      public TMP_Text openingText;        // optional
      public TMP_Text questionText;
      public Button[] answerButtons;      // pre-placed; extras auto-hidden
      public Button nextButton;

      [Header("Feedback colors")]
      public Color normalColor  = Color.white;
      public Color correctColor = new Color(0.60f, 0.90f, 0.60f);   // green
      public Color wrongColor   = new Color(0.95f, 0.60f, 0.60f);   // red

      private int idx = 0;
      private bool correctlyAnswered = false;

      void Start()
      {
          if (openingText != null && level != null) openingText.text = level.opening;
          if (level != null && level.questions.Count > 0) ShowQuestion(0);
      }

      public void ShowQuestion(int i)
      {
          idx = i;
          correctlyAnswered = false;
          var q = level.questions[i];
          questionText.text = q.prompt;

          string[] opts = (q.options != null && q.options.Length > 0) ? q.options :
  level.defaultOptions;
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
          if (nextButton != null) nextButton.interactable = false;   // must answer correctly first
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
          if (!correctlyAnswered) return;
          if (idx + 1 < level.questions.Count) ShowQuestion(idx + 1);
          else questionText.text = "Level complete!";                // TODO: unlock next level
      }

      private void SetButtonColor(int b, Color c)
      {
          var img = answerButtons[b].GetComponent<Image>();
          if (img != null) img.color = c;
      }
  }