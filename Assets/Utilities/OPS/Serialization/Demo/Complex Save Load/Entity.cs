using System.Collections;
using System.Collections.Generic;
using UnityEngine;

/// <summary>
/// Base class for moving and attacking entites.
/// 
/// Saves and Loads its live.
/// </summary>
public class Entity : WorldObject
{
    public GameObject ProjectileReference;

    private Animator animator;

    protected float live;
    private bool isDead;
    public bool IsDead
    {
        get { return this.isDead; }
    }

    protected Vector3 walkTarget;

    protected bool isWalking;

    private bool isAttacking;

    protected virtual void Awake()
    {
        this.animator = this.GetComponent<Animator>();

        this.live = 100;

        this.walkTarget = this.transform.position;
    }

    protected virtual void Update()
    {
        if (this.live <= 0)
        {
            this.Die();
            return;
        }

        if (this.isWalking)
        {
            if (Vector3.Distance(this.transform.position, this.walkTarget) < 0.5f)
            {
                this.transform.position = this.walkTarget;
                this.Stop();
            }
            else
            {
                Vector3 var_Speed = this.walkTarget - this.transform.position;
                var_Speed.Normalize();

                this.transform.position += var_Speed * 0.05f;
                this.transform.position = new Vector3(this.transform.position.x, 0, this.transform.position.z);
            }
        }
    }

    protected void Walk(Vector3 _WalkTarget)
    {
        if(this.isDead)
        {
            return;
        }

        this.walkTarget = _WalkTarget;

        this.transform.LookAt(this.walkTarget);

        if (this.isAttacking)
        {
            return;
        }

        if (this.isWalking)
        {
            return;
        }

        this.isWalking = true;

        this.animator.Play("Walk");
        this.animator.SetBool("Walk", true);
    }

    protected void Stop()
    {
        this.isWalking = false;
        this.animator.SetBool("Walk", false);
    }

    protected void Attack()
    {
        if (this.isDead)
        {
            return;
        }

        this.Stop();

        this.animator.Play("Attack");

        this.isAttacking = true;
    }

    public void FireProjectile()
    {
        GameObject projectileGameObject = Instantiate(ProjectileReference, this.transform.position + Vector3.up, new Quaternion(0, 0, 0, 0));
        Projectile projectile = projectileGameObject.GetComponent<Projectile>();
        projectile.Owner = this;
        projectile.Direction = this.transform.forward.normalized;

        this.isAttacking = false;
    }

    public void Damage(float _Value)
    {
        this.live -= _Value;
    }

    public void Die()
    {
        if (this.isDead)
        {
            return;
        }

        this.isDead = true;

        this.animator.SetBool("Walk", false);
        this.animator.SetBool("Die", true);

        Destroy(this.gameObject, 4f);
    }

    public override void OnSave(SaveMetaData _SaveMetaData)
    {
        base.OnSave(_SaveMetaData);

        _SaveMetaData.Add(this.live);
    }

    public override void OnLoad(SaveMetaData _SaveMetaData)
    {
        base.OnLoad(_SaveMetaData);

        this.live = _SaveMetaData.GetNextFloat();
        if(this.live <= 0)
        {
            this.Die();
        }
    }
}
