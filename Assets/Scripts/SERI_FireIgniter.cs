/***
 * Adapted from FireIgniter.cs of Fire Propagation System asset by Lewis Ward 
 **/

using UnityEngine;
using System.Collections;
using UnityEngine.Assertions;

public class SERI_FireIgniter : MonoBehaviour
{
    [SerializeField]
    [Tooltip("Width of the fire grid, fire starts in the center of the grid")]
    private int m_gridWidth = 20;
    [SerializeField]
    [Tooltip("Height of the fire grid, fire starts in the center of the grid")]
    private int m_gridHeight = 20;
    //[SerializeField]
    [Tooltip("Prefab of the fire to use")]
    public GameObject m_firePrefab;
    [Tooltip("Width of the fire complex to create")]
    private float m_fireComplexWidth = 30f;
    [SerializeField]
    [Tooltip("Delete this GameObject when there is a collision with it and the terrain or another GameObject?")]
    private bool m_destroyOnCollision = false;
    private bool m_fireIgnited = false;
    //[SerializeField]
    [Tooltip("Fire manager to use")]
    //public GameObject m_fireManagerObject;

    private SERI_FireManager m_fireManager;

    private Vector3 currentPos;
    private Vector3 offsetPos = new Vector3(0,0,0);

    //[SerializeField]
    //[Tooltip("Use to start fire (for testing)")]
    //private bool startFireFlag = false;

    public void Initialize(SERI_FireManager newFireManager)
    {
        if (m_firePrefab == null)
        {
            Debug.LogError("No Fire Prefab set on Fire Igniter.");
        }

        // negate negative values
        if (m_gridWidth < 0)
            m_gridWidth = -m_gridWidth;
        if (m_gridHeight < 0)
            m_gridHeight = -m_gridHeight;

        // valid size grid
        if (m_gridWidth == 0)
            m_gridWidth = 1;
        if (m_gridHeight == 0)
            m_gridHeight = 1;

        m_fireManager = newFireManager;
        //m_fireManager = m_fireManagerObject.GetComponent<SERI_FireManager>() as SERI_FireManager;
        Assert.IsNotNull(m_fireManager);

        Debug.Log(name + ".Initialize()... transform.position:" + transform.position);

        /// -- TESTING --
        //OnCollision();          
        //m_fireIgnited = true;

        //if (m_destroyOnCollision)
        //Destroy();
        /// -----
    }

    //void Start()
    //{
    //    if (m_firePrefab == null)
    //    {
    //        Debug.LogError("No Fire Prefab set on Fire Igniter.");
    //    }

    //    // negate negative values
    //    if (m_gridWidth < 0)
    //        m_gridWidth = -m_gridWidth;
    //    if (m_gridHeight < 0)
    //        m_gridHeight = -m_gridHeight;

    //    // valid size grid
    //    if (m_gridWidth == 0)
    //        m_gridWidth = 1;
    //    if (m_gridHeight == 0)
    //        m_gridHeight = 1;

    //    m_fireManager = m_fireManagerObject.GetComponent<SERI_FireManager>() as SERI_FireManager;
    //    Assert.IsNotNull(m_fireManager);
    //}

    private void Update()
    {
        //if(startFireFlag)
        //{
        //    StartFire();
        //    startFireFlag = false;
        //}
    }

    //public void IgniteTerrain(Terrain t)              // -- BROKEN
    //{
    //    //Debug.Log(name+".OnCollision()... pos:" + transform.position);

    //    GameObject fireGrid = new GameObject();
    //    fireGrid.name = "FireGrid";

    //    fireGrid.transform.parent = transform.parent;                   // Set parent

    //    SERI_FireGrid grid = fireGrid.AddComponent<SERI_FireGrid>();
    //    SERI_FireGrassRemover remover = fireGrid.AddComponent<SERI_FireGrassRemover>();
    //    remover.Initialize(m_fireManager);

    //    Vector3 pos = transform.position;
    //    //pos.y = 

    //    grid.IgniterUpdate(m_firePrefab, transform.position, m_gridWidth, m_gridHeight);
    //    grid.Ignite(m_fireManager, offsetPos, true, false, null);

    //    m_fireIgnited = true;
    //}

    /// <summary>
    /// Starts the fire.
    /// </summary>
    //public void StartFire()
    //{
    //    Rigidbody rb = GetComponent<Rigidbody>() as Rigidbody;
    //    rb.useGravity = true;
    //}

    //public void OnCollision()             // -- BROKEN
    //{
    //    //Debug.Log(name+".OnCollision()... pos:" + transform.position);

    //    GameObject fireGrid = new GameObject();
    //    fireGrid.name = "FireGrid";

    //    fireGrid.transform.parent = transform.parent;                   // Set parent

    //    SERI_FireGrid grid = fireGrid.AddComponent<SERI_FireGrid>();
    //    SERI_FireGrassRemover remover = fireGrid.AddComponent<SERI_FireGrassRemover>();
    //    remover.Initialize(m_fireManager);

    //    Vector3 pos = transform.position;
    //    //pos.y = 

    //    grid.IgniterUpdate(m_firePrefab, transform.position, m_gridWidth, m_gridHeight);
    //    grid.Ignite(m_fireManager, offsetPos, true, false, null);
    //}

    //void OnCollisionEnter(Collision collision)        // -- BROKEN
    //{
    //    if (m_fireIgnited == false)
    //    {
    //        OnCollision();
    //        m_fireIgnited = true;

    //        if (m_destroyOnCollision)
    //            Destroy();
    //    }
    //}

    public bool Ignited()
    {
        return true;
    }

    // brief Destroy this object
    void Destroy()
    {
        Destroy(gameObject);
    }
}
