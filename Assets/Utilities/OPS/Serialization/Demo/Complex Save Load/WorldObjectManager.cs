using System;
using System.Collections;
using System.Collections.Generic;
using System.Diagnostics;
using System.IO;
using UnityEngine;

/// <summary>
/// World controller. Controls saving, loading, and enemy spawning.
/// </summary>
public class WorldObjectManager : MonoBehaviour, ISaveAble
{
    public static Player Player;

    public static List<Enemy> EnemyList;

    public static List<Projectile> ProjectileList;

    public GameObject PlayerGameObjectReference;
    public GameObject EnemyGameObjectReference;
    public GameObject ProjectileReference;

    private void Awake()
    {
        this.StartNewGame();

        StartCoroutine(this.SpawnEnemy());
    }

    private void Clear()
    {
        if (Player != null)
        {
            try
            {
                DestroyImmediate(Player.gameObject);
            }
            catch
            {
            }
        }

        if (EnemyList != null)
        {
            for (int i = 0; i < EnemyList.Count; i++)
            {
                try
                {
                    DestroyImmediate(EnemyList[i].gameObject);
                }
                catch
                {
                }
            }
        }

        if (ProjectileList != null)
        {
            for (int i = 0; i < ProjectileList.Count; i++)
            {
                try
                {
                    DestroyImmediate(ProjectileList[i].gameObject);
                }
                catch 
                {
                }
            }
        }

        EnemyList = new List<Enemy>();
        ProjectileList = new List<Projectile>();
    }

    public void StartNewGame()
    {
        this.Clear();

        Instantiate(PlayerGameObjectReference, Vector3.zero, new Quaternion(0, 0, 0, 0));
    }

    public void LoadGame()
    {
        this.Clear();

        Instantiate(PlayerGameObjectReference, Vector3.zero, new Quaternion(0, 0, 0, 0));

        //Check if there is a save game.
        if (!File.Exists("OPS_Complex_Save_Load.ser"))
        {
            UnityEngine.Debug.LogError("OPS_Complex_Save_Load.ser does not exits. Please use first save!");
        }

        //Load save game.
        FileStream stream = new FileStream("OPS_Complex_Save_Load.ser", FileMode.Open);
        Stopwatch stopwatch = new Stopwatch();
        stopwatch.Start();

        //Deserialize
        SaveMetaData saveMetaData = OPS.Serialization.IO.Serializer.DeSerializeFromStream<SaveMetaData>(stream);
        //Load
        this.OnLoad(saveMetaData);

        stopwatch.Stop();
        stream.Close();

        UnityEngine.Debug.Log("Loaded Game: ElapsedMilliseconds: " + stopwatch.ElapsedMilliseconds);
    }

    public void SaveGame()
    {
        //Create save game file.
        FileStream stream = new FileStream("OPS_Complex_Save_Load.ser", FileMode.Create);
        Stopwatch stopwatch = new Stopwatch();
        stopwatch.Start();

        //Create new SaveMetaData.
        SaveMetaData saveMetaData = new SaveMetaData();
        //Save game.
        this.OnSave(saveMetaData);

        //Serialize
        OPS.Serialization.IO.Serializer.SerializeToStream(stream, saveMetaData);

        stopwatch.Stop();
        stream.Close();

        UnityEngine.Debug.Log("Saved Game: ElapsedMilliseconds: " + stopwatch.ElapsedMilliseconds);
    }

    private IEnumerator SpawnEnemy()
    {
        while (true)
        {
            if (Player != null)
            {
                Instantiate(EnemyGameObjectReference, Player.transform.position + new Vector3(UnityEngine.Random.Range(-20, 20), 0, UnityEngine.Random.Range(-20, 20)), new Quaternion(0, 0, 0, 0));
            }
            yield return new WaitForSeconds(5);
        }
    }

    /// <summary>
    /// Saves the Player.
    /// Iterates through all Enemies and saves them.
    /// Iterates through all Projectiles and saves them.
    /// </summary>
    /// <param name="_SaveMetaData"></param>
    public void OnSave(SaveMetaData _SaveMetaData)
    {
        //Save Player
        if(Player == null)
        {
            _SaveMetaData.Add(false);
        }
        else
        {
            _SaveMetaData.Add(true);

            //Save player data in extra SaveMetaData.
            SaveMetaData playerSaveMetaData = new SaveMetaData();
            Player.OnSave(playerSaveMetaData);

            //Store the playerSaveMetaData as child in the whole SaveMetaData.
            _SaveMetaData.AddChild(playerSaveMetaData);
        }

        //Save Enemy
        if (EnemyList == null)
        {
            _SaveMetaData.Add(false);
        }
        else
        {
            _SaveMetaData.Add(true);

            //Save enemy count.
            _SaveMetaData.Add(EnemyList.Count);

            for (int i = 0; i < EnemyList.Count; i++)
            {
                _SaveMetaData.Add(EnemyList[i] == null);

                if (EnemyList[i] == null)
                {
                    continue;
                }

                //Save enemy data in extra SaveMetaData.
                SaveMetaData enemySaveMetaData = new SaveMetaData();
                EnemyList[i].OnSave(enemySaveMetaData);

                //Store the enemySaveMetaData as child in the whole SaveMetaData.
                _SaveMetaData.AddChild(enemySaveMetaData);
            }
        }

        //Save Projectiles
        if (ProjectileList == null)
        {
            _SaveMetaData.Add(false);
        }
        else
        {
            _SaveMetaData.Add(true);

            //Save projectile count.
            _SaveMetaData.Add(ProjectileList.Count);

            for (int i = 0; i < ProjectileList.Count; i++)
            {
                _SaveMetaData.Add(ProjectileList[i] == null);

                if (ProjectileList[i] == null)
                {
                    continue;
                }

                //Save projectile data in extra SaveMetaData.
                SaveMetaData projectileSaveMetaData = new SaveMetaData();
                ProjectileList[i].OnSave(projectileSaveMetaData);

                //Store the enemySaveMetaData as child in the whole SaveMetaData.
                _SaveMetaData.AddChild(projectileSaveMetaData);
            }
        }
    }

    /// <summary>
    /// Loads the Player.
    /// Instantiates and loads the enemies.
    /// Instantiates and loads the projectiles.
    /// </summary>
    /// <param name="_SaveMetaData"></param>
    public void OnLoad(SaveMetaData _SaveMetaData)
    {
        //Load Player
        bool playerDataSaved = _SaveMetaData.GetNextBool();
        if(playerDataSaved)
        {
            //Load extra SaveMetaData for player data;
            SaveMetaData playerSaveMetaData = _SaveMetaData.GetNextChild();

            //Load player data
            Player.OnLoad(playerSaveMetaData);
        }

        //Load Enemy
        bool enemyDataSaved = _SaveMetaData.GetNextBool();
        if (enemyDataSaved)
        {
            int enemyCount = _SaveMetaData.GetNextInt();

            for (int i = 0; i < enemyCount; i++)
            {
                bool isNull = _SaveMetaData.GetNextBool();
                if(isNull)
                {
                    continue;
                }

                //Instantiate new enemy
                Enemy enemy = Instantiate(EnemyGameObjectReference, Vector3.zero, new Quaternion(0, 0, 0, 0)).GetComponent<Enemy>();

                //Load extra SaveMetaData for enemy data;
                SaveMetaData enemySaveMetaData = _SaveMetaData.GetNextChild();
                enemy.OnLoad(enemySaveMetaData);

                //Add to enemy list.
                EnemyList.Add(enemy);
            }
        }

        //Load Projectile
        bool projectileDataSaved = _SaveMetaData.GetNextBool();
        if (projectileDataSaved)
        {
            int projectileCount = _SaveMetaData.GetNextInt();

            for (int i = 0; i < projectileCount; i++)
            {
                bool isNull = _SaveMetaData.GetNextBool();
                if (isNull)
                {
                    continue;
                }

                //Instantiate new projectile
                Projectile projectile = Instantiate(ProjectileReference, Vector3.zero, new Quaternion(0, 0, 0, 0)).GetComponent<Projectile>();

                //Load extra SaveMetaData for projectile data;
                SaveMetaData projectileSaveMetaData = _SaveMetaData.GetNextChild();
                projectile.OnLoad(projectileSaveMetaData);

                //Add to projectile list.
                ProjectileList.Add(projectile);
            }
        }
    }
}
