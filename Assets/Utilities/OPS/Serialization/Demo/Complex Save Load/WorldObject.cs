using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

/// <summary>
/// A base class for all GameObjects.
/// 
/// Saved the Position and Rotation.
/// </summary>
public class WorldObject : MonoBehaviour, ISaveAble
{
    public virtual void OnSave(SaveMetaData _SaveMetaData)
    {
        _SaveMetaData.Add(this.transform.position);
        _SaveMetaData.Add(this.transform.rotation);
    }

    public virtual void OnLoad(SaveMetaData _SaveMetaData)
    {
        this.transform.position = _SaveMetaData.GetNextVector3();
        this.transform.rotation = _SaveMetaData.GetNextQuaternion();
    }
}
