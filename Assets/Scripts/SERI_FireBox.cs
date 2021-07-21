/* -- UNUSED
 *
 * Copyright (c) 2016-2017 Lewis Ward
// Fire Propagation System
// author: Lewis Ward
// date  : 03/02/2017
*/
using UnityEngine;
using System.Collections;

public class SERI_FireBox {
    public Vector3 m_radius = new Vector3(1, 1, 1);
    private Vector3 m_position;
    private string m_terrainName = "Terrain";
    private Collider[] m_overlapOjects = new Collider[10];
    public Vector3 radius
    {
        get { return m_radius; }
        set { m_radius = value; }
    }

    // brief Set the inital values
    // param Vector3 Box position
    // param String Terrain name
    public void Init(Vector3 position, string terrainName)
    {
        m_position = position;
        m_terrainName = terrainName;
    }

    // brief Test for any collision
    //public void RunDetectionTest()
    //{
    //    Physics.OverlapBoxNonAlloc(m_position, m_radius, m_overlapOjects);
    //    //Debug.Log("DetectionTest()... m_overlapOjects.Length:"+ m_overlapOjects.Length);

    //    // active FireChain if the collided GameObject has one
    //    for (int i = 0; i < 10; i++)
    //        if (m_overlapOjects[i] != null)
    //            if (m_overlapOjects[i].name != m_terrainName)
    //                ActivatePresentFireNodeChains(m_overlapOjects[i]);
    //}

    //// brief Activate any present FireNodeChain's in a GameObject using it's collider
    //// param Collider GameObject's Collider
    bool ActivatePresentFireNodeChains(Collider gameObject)
    {
        SERI_FireNodeChain chain = gameObject.GetComponent<SERI_FireNodeChain>();

        //Debug.Log("ActivePresentFireNodeChains()... chain == null?:" + (chain == null));

        if (chain != null)
        {
            chain.SpreadFire(m_position);
            return true;
        }

        return false;
    }
}
