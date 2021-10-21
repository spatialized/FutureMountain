/***
 * Adapted from FireGrassRemover.cs of Fire Propagation System asset by Lewis Ward 
 **/

using UnityEngine;
using System.Collections;

public class SERI_FireGrassRemover : MonoBehaviour 
{
    private SERI_FireManager m_fireManager;
    private float[] m_pixelPoints = new float[4];
    private float m_radius = 1;
    private int m_scorchmarkTexture = 0;
    private int m_DToAWidth = 0;
    private int m_DToAHeight = 0;
    private bool m_replaceGrass = false;
    public float radius {  set { m_radius = value; } }
    //float radius;
    public void Initialize(SERI_FireManager newFireManager)
    {
        // Get the terrain from the fire manager
        //m_fireManager = FindObjectOfType<FireManager>();

        m_fireManager = newFireManager;

        if (m_fireManager != null)
        {
            // Get ratio
            m_DToAWidth = m_fireManager.terrainWidth / m_fireManager.alphaWidth;
            m_DToAHeight = m_fireManager.terrainHeight / m_fireManager.alphaHeight;

            // find which texture is the scorch mark texture
            foreach (SERI_FireTerrainTexture texture in m_fireManager.terrainTextures)
            {
                if (texture.m_isGroundBurnTexture == true)
                {
                    //Debug.Log("texture.m_isGroundBurnTexture == true... id:" + texture.m_textureID);
                    m_scorchmarkTexture = texture.m_textureID;
                    break;
                }
            }

            m_replaceGrass = !m_fireManager.removeGrassOnceBurnt;
        }
    }

    /// <summary>
    /// Deletes the grass on position.
    /// </summary>
    /// <param name="position">Position.</param>
    public void DeleteGrassOnPosition(Vector3 position)
    {
        if (m_fireManager != null)
            RemoveGrass(m_fireManager.terrain, position);
        else
            Debug.Log("DeleteGrassOnPosition()... m_fireManager == null!");
    }

    /// <summary>
    /// Removes the grass.
    /// </summary>
    /// <param name="terrain">Terrian.</param>
    /// <param name="position">Position.</param>
    void RemoveGrass(Terrain terrain, Vector3 position)
    {
        // Convert the position to a position on the terrain map
        Vector3 texturePoint3D = position;
        texturePoint3D = texturePoint3D * m_fireManager.terrainDetailSize;
        m_pixelPoints[0] = texturePoint3D.z + m_radius;
        m_pixelPoints[1] = texturePoint3D.z - m_radius;
        m_pixelPoints[2] = texturePoint3D.x + m_radius;
        m_pixelPoints[3] = texturePoint3D.x - m_radius;

        //Debug.Log("RemoveGrass()... position: " + position+ " m_fireManager.terrainDetailSize:"+ m_fireManager.terrainDetailSize);

        // Keep within array bounds
        for (int i = 0; i < 4; i++)
        {
            if (m_pixelPoints[i] < 0)
                m_pixelPoints[i] = 0;

            if (m_pixelPoints[i] > m_fireManager.terrainHeight)
            {
                Debug.Log("Reached height edge:" + m_pixelPoints[i] + " m_fireManager.terrainHeight:" + m_fireManager.terrainHeight+ " m_pixelPoints[i] :"+ m_pixelPoints[i]);
                m_pixelPoints[i] = m_fireManager.terrainHeight - 1;     // Height and Width should always be the same, checked on creation of the grid.
            }
            if (m_pixelPoints[i] > m_fireManager.terrainWidth)
            {
                Debug.Log("Reached width edge:" + m_pixelPoints[i] + " m_fireManager.terrainWidth:" + m_fireManager.terrainHeight + " m_pixelPoints[i] :" + m_pixelPoints[i]);
                m_pixelPoints[i] = m_fireManager.terrainHeight - 1;     // Height and Width should always be the same, checked on creation of the grid.
            }

            //if (m_pixelPoints[i] > m_fireManager.terrainHeight || m_pixelPoints[i] > m_fireManager.terrainWidth)
                //m_pixelPoints[i] = m_fireManager.terrainHeight - 1; // Height and Width should always be the same, checked on creation of the grid.

        }

        // Remove the grass from the terrain
        for (int y = (int)m_pixelPoints[3]; y < (int)m_pixelPoints[2] + 1; y++)
        {
            for (int x = (int)m_pixelPoints[1]; x < (int)m_pixelPoints[0] + 1; x++)
            {
                // Using the standard number of grass detail or the maximum number
                if (!m_fireManager.maxGrassDetails)
                {
                    if (m_replaceGrass && m_fireManager.terrainMap[x, y] != 0)
                    {
                        m_fireManager.terrainMap[x, y] = 0;
                        m_fireManager.terrainReplacementMap[x, y] = 1;
                    }
                    else
                    {
                        m_fireManager.terrainMap[x, y] = 0;
                    }
                }
                else
                {
                    for (int i = 0; i < m_fireManager.terrain.terrainData.detailPrototypes.Length; i++)
                    {
                        if (m_replaceGrass && m_fireManager.terrainMaps[i][x, y] != 0)
                        {
                            m_fireManager.terrainMaps[i][x, y] = 0;
                            m_fireManager.terrainMaps[m_fireManager.burntGrassDetailIndex][x, y] = 1;
                        }
                        else if(!m_replaceGrass)
                        {
                            m_fireManager.terrainMaps[i][x, y] = 0;
                        }
                    }
                }
                
                // Set the dirty flag, will trigger a terrain update
                m_fireManager.dirty = true;
            }
        }

        //Debug.Log("Setting scorchmark texture for points: " + m_pixelPoints[0]+" 1:" + m_pixelPoints[1]+" to 2:" + m_pixelPoints[2]+" 3:" + m_pixelPoints[3]);

        // Update the alphamap to the scorch mark texture
        int terrainLayerLen = m_fireManager.terrainAlpha.GetLength(2);
        for (int y = (int)m_pixelPoints[3]; y < (int)m_pixelPoints[2] + 1; y++)
        {
            for (int x = (int)m_pixelPoints[1]; x < (int)m_pixelPoints[0] + 1; x++)
            {
                if (m_pixelPoints[0] > x && m_pixelPoints[1] < x && m_pixelPoints[2] > y && m_pixelPoints[3] < y)
                {
                    int X = x / m_DToAWidth;
                    int Y = y / m_DToAHeight;
                
                    for (int i = 0; i < terrainLayerLen; i++)
                        m_fireManager.terrainAlpha[X, Y, i] = 0;

                    m_fireManager.terrainAlpha[X, Y, m_scorchmarkTexture] = 1;
                }
            }
        }
    }

    /// <summary>
    /// Gets the terrain position.
    /// </summary>
    /// <returns>The terrain position.</returns>
    public Vector3 GetTerrainPosition()
    {
        return m_fireManager.terrain.GetPosition();
    }
}
