using System;
using UnityEngine;

/// <summary>
/// A leaf-density model switcher, attached to a tree prefab in place of distance-based LODs.
///
/// Works like a Unity LODGroup, but the level is chosen from the tree's leaf carbon instead of camera
/// distance. Each level (<see cref="Level"/>) holds one or more GameObjects — e.g. a canopy mesh plus
/// a trunk mesh — so a density level can be made of several parts. Levels are ordered densest first
/// (index 0) to sparsest last. A tree controller calls <see cref="ShowState"/> to display exactly one
/// level, so as overstory carbon falls the foliage thins out.
///
/// Only prefabs that carry this component participate: trees without it (e.g. BigCreek) are never
/// touched. This does not drive a Unity LODGroup; if one is present and interferes, disable it on the
/// prefab (all Central Coast variants are authored at LOD0 anyway).
/// </summary>
public class DensityLODGroup : MonoBehaviour
{
    [Serializable]
    public class Level
    {
        [Tooltip("The models that make up this density level, e.g. canopy + trunk.")]
        public GameObject[] objects;
    }

    [Tooltip("Density levels from densest (index 0) to sparsest (last). Each level can hold several models.")]
    public Level[] levels;

    private int currentState = -1;   // -1 = nothing shown yet, so the first ShowState always applies

    /// <summary>Number of density levels available (0 if none assigned).</summary>
    public int StateCount => levels != null ? levels.Length : 0;

    /// <summary>
    /// Shows every object in the level at <paramref name="state"/> (0 = densest) and hides the objects
    /// in all other levels. Clamped to the available range; a no-op when the state is unchanged, so it
    /// is cheap to call every frame.
    /// </summary>
    public void ShowState(int state)
    {
        if (levels == null || levels.Length == 0)
            return;

        state = Mathf.Clamp(state, 0, levels.Length - 1);
        if (state == currentState)
            return;

        currentState = state;
        for (int i = 0; i < levels.Length; i++)
        {
            bool show = (i == state);
            GameObject[] objects = levels[i] != null ? levels[i].objects : null;
            if (objects == null)
                continue;

            for (int j = 0; j < objects.Length; j++)
            {
                if (objects[j] != null)
                    objects[j].SetActive(show);
            }
        }
    }
}
