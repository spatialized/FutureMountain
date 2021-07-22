using System.Collections;
using System.Collections.Generic;
using UnityEngine;

/// <summary>
/// Porjectile class. Attacking entities shoot projectiles.
/// 
/// Saves and Loads its direction and liveTime.
/// </summary>
public class Projectile : WorldObject
{
    public Vector3 Direction;
    public Entity Owner;

    private float liveTime;

    private void Awake()
    {
        WorldObjectManager.ProjectileList.Add(this);
    }

    private void Update()
    {
        this.liveTime += Time.deltaTime;

        if(this.liveTime >= 10)
        {
            DestroyImmediate(this.gameObject);
            return;
        }

        this.gameObject.transform.position += this.Direction;
    }

    private void OnTriggerEnter(Collider other)
    {
        WorldObject var_WorldObject = other.gameObject.GetComponent<WorldObject>();
        if (var_WorldObject == null)
        {
            Destroy(this.gameObject);
        }

        if (var_WorldObject is Entity)
        {
            Entity entity = var_WorldObject as Entity;

            if (entity == Owner)
            {
                return;
            }

            if (entity.IsDead)
            {
                return;
            }

            entity.Damage(10);

            Destroy(this.gameObject);
        }
    }

    private void OnDestroy()
    {
        WorldObjectManager.ProjectileList.Remove(this);
    }

    public override void OnSave(SaveMetaData _SaveMetaData)
    {
        base.OnSave(_SaveMetaData);

        _SaveMetaData.Add(this.Direction);
        _SaveMetaData.Add(this.liveTime);
    }

    public override void OnLoad(SaveMetaData _SaveMetaData)
    {
        base.OnLoad(_SaveMetaData);

        this.Direction = _SaveMetaData.GetNextVector3();
        this.liveTime = _SaveMetaData.GetNextFloat();
    }
}
