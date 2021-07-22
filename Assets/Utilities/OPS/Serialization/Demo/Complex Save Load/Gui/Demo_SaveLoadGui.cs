using System.Collections;
using System.Collections.Generic;
using System.Diagnostics;
using System.IO;
using UnityEngine;

public class Demo_SaveLoadGui : MonoBehaviour
{
    private WorldObjectManager worldObjectManager;

    public GameObject DeadGameObject;

    private void Awake()
    {
        this.worldObjectManager = GameObject.Find("WorldObjectManager").GetComponent<WorldObjectManager>();
    }

    private void Update()
    {
        if(Input.GetKeyDown(KeyCode.U))
        {
            this.New();
        }
        if (Input.GetKeyDown(KeyCode.I))
        {
            this.Save();
        }
        if (Input.GetKeyDown(KeyCode.O))
        {
            this.Load();
        }

        if(WorldObjectManager.Player == null)
        {
            DeadGameObject.SetActive(true);
        }
        else
        {
            if (WorldObjectManager.Player.IsDead)
            {
                DeadGameObject.SetActive(true);
            }
            else
            {
                DeadGameObject.SetActive(false);
            }
        }
    }

    public void New()
    {
        this.worldObjectManager.StartNewGame();
    }

    public void Save()
    {
        this.worldObjectManager.SaveGame();
    }

    public void Load()
    {
        this.worldObjectManager.LoadGame();
    }
}
