using System.Collections;
using System.Collections.Generic;
using UnityEngine;

/// <summary>
/// Player class. Controls the Player behaviour.
/// </summary>
public class Player : Entity
{
    private UnityEngine.UI.Text PlayerHealthText;

    protected override void Awake()
    {
        base.Awake();

        this.live = 100;

        WorldObjectManager.Player = this;

        Animator animator = this.GetComponent<Animator>();
        animator.speed = 3f;

        PlayerHealthText = GameObject.Find("Canvas").transform.Find("PlayerHealth").GetComponent<UnityEngine.UI.Text>();
    }

    protected override void Update()
    {
        base.Update();

        if(Input.GetMouseButtonDown(0))
        {
            this.Attack();
        }

        this.PlayerHealthText.text = this.live.ToString();
    }
}
