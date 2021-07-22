using System.Collections;
using System.Collections.Generic;
using UnityEngine;
/// <summary>
/// Enemy class. Controls the Enemy behaviour.
/// 
/// Searchs, Moves and Attacks Player.
/// </summary>
public class Enemy : Entity
{
    protected override void Awake()
    {
        base.Awake();

        this.live = 20;

        WorldObjectManager.EnemyList.Add(this);
    }

    protected override void Update()
    {
        base.Update();

        //If a Player exists
        if (WorldObjectManager.Player != null)
        {
            //Check if in attack range
            if (Vector3.Distance(this.transform.position, WorldObjectManager.Player.transform.position) < 4f)
            {
                this.Attack();
            }
            else
            {
                this.Walk(WorldObjectManager.Player.transform.position);
            }
        }
    }

    private void OnDestroy()
    {
        WorldObjectManager.EnemyList.Remove(this);
    }
}
