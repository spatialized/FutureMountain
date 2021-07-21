using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class GameObjectPool : MonoBehaviour
{
    public List<GameObject> pooledObjects;
    private GameObject objectToPool;
    public GameObject objectPool;
    public int amountToPool;

    public void Initialize(GameObject newObjectToPool)
    {
        objectToPool = newObjectToPool;
        pooledObjects = new List<GameObject>();
        for (int i = 0; i < amountToPool; i++)
        {
            GameObject obj = (GameObject)Instantiate(objectToPool);
            obj.transform.parent = objectPool.transform;

            SERI_FireVisualManager fvm = obj.GetComponent<SERI_FireVisualManager>() as SERI_FireVisualManager;

            obj.SetActive(false);
            pooledObjects.Add(obj);
        }
    }

    /// <summary>
    /// Get pooled object
    /// </summary>
    /// <returns>Object from pool</returns>
    public GameObject GetPooledObject()
    {
        for (int i = 0; i < pooledObjects.Count; i++)
        {
            if (pooledObjects[i])
            {
                if (!pooledObjects[i].activeInHierarchy)
                {
                    pooledObjects[i].SetActive(true);
                    return pooledObjects[i];
                }
            }
            else
            {
                Debug.Log(name+".GetPooledObject()... ERROR: Null pooled object i:" + i);
            }
        }
                    
        return null;
    }

    /// <summary>
    /// Return object to pool
    /// </summary>
    /// <param name="obj"></param>
    public void ReturnToPool(GameObject obj)
    {
        //Debug.Log(name + ".ReturnToPool()... obj: " + obj.name);

        obj.SetActive(false);
        obj.transform.parent = objectPool.transform;
    }
}
