using UnityEngine;
static public class GameObjectExtensions
{
    static public void ClearChildren(this GameObject go)
    {
        for (int i = go.transform.childCount - 1; i >= 0; i--)
        {
            GameObject.Destroy(go.transform.GetChild(i).gameObject);
        }
    }
}