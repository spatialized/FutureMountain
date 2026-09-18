using UnityEngine;
using DG.Tweening;

// Central Coast V3 camera controller.
// Replaces the base's animator-driven camera moves with DOTween motion to anchor transforms.
// Overridden methods use tweens; anything not overridden still runs the base (animator) path.
// BigCreek keeps using CameraController directly and is never affected.
public class CameraController_CCV3 : CameraController
{
    [Header("View anchors (camera moves to each one's position + rotation)")]
    public Transform aggregateAnchor;    // zoom into the aggregate cube
    public Transform[] cubeAnchors;      // zoom into zone cube 0..4
    public Transform zoneOverviewAnchor; // L3 zone overview
    public Transform idleAnchor;         // default / zoomed-out home view

    [Header("Side-by-side anchors")]
    public Transform sbsAggregateAnchor; // side-by-side view when the target is the aggregate cube
    public Transform[] sbsCubeAnchors;   // side-by-side view for zone cube 0..4

    [Header("Tween")]
    public float moveDuration = 1.5f;    // seconds per camera move

    private Tween camMove;               // current camera tween (killed before starting a new one)

    // CC V3 drives the camera with DOTween, not the animator — skip the base's animator setup so the
    // Animator component can be removed from the CC V3 camera entirely.
    protected override void InitCameraDriver() { }

    // Reset to the idle view without the animator (base uses animator.Play("Idle")).
    public override void ResetPosition()
    {
        camMove?.Kill();
        if (idleAnchor != null)
        {
            transform.position = idleAnchor.position;
            transform.rotation = idleAnchor.rotation;
        }
        zoomed = false;
        inZoneOverview = false;
        moving = false;
        pauseState = GamePauseState.unpause;
    }

    // Debug hotkeys (A/F/E/D/C/B in the base) use the animator directly. Route them through the DOTween
    // zoom path instead so the CC V3 camera never touches the animator. Space still zooms out (base logic).
    protected override void GetKeyboardInput()
    {
        if (zoomed)
        {
            if (Input.GetKeyDown(KeyCode.Space) && !zoomOutLocked)
            {
                GameController.Instance.SetZoomOutButtonActive(false);
                GameController.Instance.SetSideByToggleActive(true);
                StartResetZoom();
            }
            return;
        }

        if (moving) return;
        if      (Input.GetKeyDown(KeyCode.A)) StartZoomIntoCube(-1);
        else if (Input.GetKeyDown(KeyCode.F)) StartZoomIntoCube(0);
        else if (Input.GetKeyDown(KeyCode.E)) StartZoomIntoCube(1);
        else if (Input.GetKeyDown(KeyCode.D)) StartZoomIntoCube(2);
        else if (Input.GetKeyDown(KeyCode.C)) StartZoomIntoCube(3);
        else if (Input.GetKeyDown(KeyCode.B)) StartZoomIntoCube(4);
    }

    // Move the camera to an anchor. Kills any in-flight move first, so we never chase two targets
    // at once (this is what kills the animator "jump back" bug). onDone runs when the move finishes.
    protected void TweenTo(Transform anchor, System.Action onDone)
    {
        if (anchor == null) { onDone?.Invoke(); return; }

        camMove?.Kill();
        moving = true;
        pauseState = GamePauseState.pause;

        Sequence seq = DOTween.Sequence();
        seq.Join(transform.DOMove(anchor.position, moveDuration).SetEase(Ease.InOutQuad));
        seq.Join(transform.DORotateQuaternion(anchor.rotation, moveDuration).SetEase(Ease.InOutQuad));
        seq.OnComplete(() => { moving = false; pauseState = GamePauseState.unpause; onDone?.Invoke(); });
        camMove = seq;
    }

    // --- zoom into a cube (Stage 1: normal zoom only; side-by-side still uses the base for now) ---
    public override void StartZoomIntoCube(int cubeIdx)
    {
        if (GameController.Instance.DifferentCubesModeOn())
        {
            GameController.Instance.HandleDifferentCubesClick(cubeIdx);   // mode 1: pick two cubes

            // Move the camera only once BOTH cubes are picked and placed side by side. Picking the first
            // cube does nothing visual here (its label just highlights, added later); we wait for the second.
            bool active = GameController.Instance.DifferentCubesActive();
            int first = GameController.Instance.DifferentCubesFirst();
            if (active)
            {
                if (first >= 0 && sbsCubeAnchors != null && first < sbsCubeAnchors.Length)
                {
                    GameController.Instance.SetSideByToggleActive(false);
                    GameController.Instance.ForceHideModel(true);
                    TweenTo(sbsCubeAnchors[first], () => { zoomed = true; });
                }
            }
            return;
        }

        if (ShouldEnterSideBySideMode())
        {
            GameController.Instance.SetSideByToggleActive(false);
            GameController.Instance.ForceHideModel(true);
            GameController.Instance.EnterSideBySideMode(cubeIdx);

            Transform sbsTarget = (cubeIdx == -1) ? sbsAggregateAnchor
                                : (sbsCubeAnchors != null && cubeIdx >= 0 && cubeIdx < sbsCubeAnchors.Length ? sbsCubeAnchors[cubeIdx] : null);
            TweenTo(sbsTarget, () => { zoomed = true; });
            return;
        }

        GameController.Instance.SetSideByToggleActive(false);
        GameController.Instance.ForceHideModel(true);
        GameController.Instance.HideAllCubeLabels();   // zoomed into a single cube -> hide the name labels

        Transform target = (cubeIdx == -1) ? aggregateAnchor
                          : (cubeAnchors != null && cubeIdx >= 0 && cubeIdx < cubeAnchors.Length ? cubeAnchors[cubeIdx] : null);

        TweenTo(target, () =>
        {
            zoomed = true;
            if (!GameController.Instance.sideBySideMode)
                GameController.Instance.SetZoomOutButtonActive(true);
        });

        GameController.Instance.OnZoomedIntoCube(cubeIdx);   // point the zone graph at this cube
    }

    // --- zoom out: L3 goes back to the zone overview, everything else to idle ---
    public override void StartResetZoom()
    {
        if (GameController.Instance.DifferentCubesActive())
            GameController.Instance.ExitDifferentCubesCompare();   // mode 1: move the second cube back, hide graphs

        GameController.Instance.SetSideByToggleActive(true);
        GameController.Instance.SetZoomOutButtonActive(false);
        GameController.Instance.ForceHideModel(false);

        Transform target = inZoneOverview ? zoneOverviewAnchor : idleAnchor;
        TweenTo(target, () => { zoomed = false; });

        if (inZoneOverview) GameController.Instance.ShowAllCubeLabels();   // back at the zone overview -> show cube names again

        GameController.Instance.OnZoomedOut();
    }

    // --- L3 zone overview (5 cubes visible). This becomes the "home" view to return to. ---
    private bool inZoneOverview = false;

    public override void GoToZoneCubeView()
    {
        inZoneOverview = true;                 // remember: zoom-out should come back here, not idle
        GameController.Instance.SetSideByToggleActive(true);
        TweenTo(zoneOverviewAnchor, () => { zoomed = false; });
    }

    // --- snap straight to a cube with no fly-in (Quest opening). DOTween with ~0 duration. ---
    public override void SnapZoomIntoCube(int cubeIdx)
    {
        GameController.Instance.SetSideByToggleActive(false);
        GameController.Instance.ForceHideModel(true);

        Transform target = (cubeIdx == -1) ? aggregateAnchor
                          : (cubeAnchors != null && cubeIdx >= 0 && cubeIdx < cubeAnchors.Length ? cubeAnchors[cubeIdx] : null);
        if (target == null) return;

        camMove?.Kill();
        transform.position = target.position;   // snap, no animation
        transform.rotation = target.rotation;
        moving = false;
        zoomed = true;
        pauseState = GamePauseState.unpause;

        if (!GameController.Instance.sideBySideMode)
            GameController.Instance.SetZoomOutButtonActive(true);

        GameController.Instance.OnZoomedIntoCube(cubeIdx);
    }
}
