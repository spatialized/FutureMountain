using System;
using System.Collections;
using System.Collections.Generic;

using OPS.Serialization.Attributes;
using UnityEngine;

/// <summary>
/// Stores the save game informations.
/// </summary>
[SerializeAbleClass]
public class SaveMetaData
{
    private int childIndex;
    [SerializeAbleField(1)]
    private List<SaveMetaData> childList;

    private int byteIndex;
    [SerializeAbleField(2)]
    private List<byte> byteList;
    public List<byte> ByteList
    {
        get
        {
            return byteList;
        }
    }

    private int intIndex;
    [SerializeAbleField(3)]
    private List<int> intList;

    private int uintIndex;
    [SerializeAbleField(4)]
    private List<uint> uintList;

    private int floatIndex;
    [SerializeAbleField(5)]
    private List<float> floatList;

    private int boolIndex;
    [SerializeAbleField(6)]
    private List<bool> boolList;

    private int stringIndex;
    [SerializeAbleField(7)]
    private List<String> stringList;

    public SaveMetaData()
    {
        this.childList = new List<SaveMetaData>();
        this.byteList = new List<byte>();
        this.intList = new List<int>();
        this.uintList = new List<uint>();
        this.floatList = new List<float>();
        this.boolList = new List<bool>();
        this.stringList = new List<string>();
    }

    public void AddChild(SaveMetaData _SaveMetaData)
    {
        if (_SaveMetaData == null)
        {
            return;
        }
        this.childList.Add(_SaveMetaData);
    }

    public SaveMetaData GetNextChild()
    {
        SaveMetaData var_Result = this.childList[this.childIndex];
        this.childIndex += 1;
        return var_Result;
    }

    public void Add(byte _Byte)
    {
        this.byteList.Add(_Byte);
    }

    public void AddByte(byte _Byte)
    {
        this.byteList.Add(_Byte);
    }

    public void AddByte(byte[] _ByteArray)
    {
        this.byteList.AddRange(_ByteArray);
    }

    public byte GetNextByte()
    {
        byte var_Result = this.byteList[this.byteIndex];
        this.byteIndex += 1;
        return var_Result;
    }

    public void Add(int _Int)
    {
        this.intList.Add(_Int);
    }

    public void AddInt(int _Int)
    {
        this.intList.Add(_Int);
    }

    public void AddInt(int[] _IntArray)
    {
        this.intList.AddRange(_IntArray);
    }

    public int GetNextInt()
    {
        int var_Result = this.intList[this.intIndex];
        this.intIndex += 1;
        return var_Result;
    }

    public void Add(uint _UInt)
    {
        this.uintList.Add(_UInt);
    }

    public void AddUInt(uint _UInt)
    {
        this.uintList.Add(_UInt);
    }

    public void AddUInt(uint[] _UIntArray)
    {
        this.uintList.AddRange(_UIntArray);
    }

    public uint GetNextUInt()
    {
        uint var_Result = this.uintList[this.uintIndex];
        this.uintIndex += 1;
        return var_Result;
    }

    public void Add(float _Float)
    {
        this.floatList.Add(_Float);
    }

    public void AddFloat(float _Float)
    {
        this.floatList.Add(_Float);
    }

    public void AddFloat(float[] _FloatArray)
    {
        this.floatList.AddRange(_FloatArray);
    }

    public float GetNextFloat()
    {
        float var_Result = this.floatList[this.floatIndex];
        this.floatIndex += 1;
        return var_Result;
    }

    public void Add(bool _Bool)
    {
        this.boolList.Add(_Bool);
    }

    public void AddBool(bool _Bool)
    {
        this.boolList.Add(_Bool);
    }

    public void AddBool(bool[] _BoolArray)
    {
        this.boolList.AddRange(_BoolArray);
    }

    public bool GetNextBool()
    {
        bool var_Result = this.boolList[this.boolIndex];
        this.boolIndex += 1;
        return var_Result;
    }

    public void Add(String _String)
    {
        if (_String == null)
        {
            return;
        }
        this.stringList.Add(_String);
    }

    public void AddString(String _String)
    {
        if (_String == null)
        {
            return;
        }
        this.stringList.Add(_String);
    }

    public String GetNextString()
    {
        String var_Result = this.stringList[this.stringIndex];
        this.stringIndex += 1;
        return var_Result;
    }

    public void Add(Vector2 _Vector2)
    {
        this.floatList.Add(_Vector2.x);
        this.floatList.Add(_Vector2.y);
    }

    public void AddVector2(Vector2 _Vector2)
    {
        this.floatList.Add(_Vector2.x);
        this.floatList.Add(_Vector2.y);
    }

    public Vector2 GetNextVector2()
    {
        float var_x = this.GetNextFloat();
        float var_y = this.GetNextFloat();

        return new Vector2(var_x, var_y);
    }

    public void Add(Vector3 _Vector3)
    {
        this.floatList.Add(_Vector3.x);
        this.floatList.Add(_Vector3.y);
        this.floatList.Add(_Vector3.z);
    }

    public void AddVector3(Vector3 _Vector3)
    {
        this.floatList.Add(_Vector3.x);
        this.floatList.Add(_Vector3.y);
        this.floatList.Add(_Vector3.z);
    }

    public Vector3 GetNextVector3()
    {
        float var_x = this.GetNextFloat();
        float var_y = this.GetNextFloat();
        float var_z = this.GetNextFloat();

        return new Vector3(var_x, var_y, var_z);
    }

    public void Add(Vector4 _Vector4)
    {
        this.floatList.Add(_Vector4.x);
        this.floatList.Add(_Vector4.y);
        this.floatList.Add(_Vector4.z);
        this.floatList.Add(_Vector4.w);
    }

    public void AddVector4(Vector4 _Vector4)
    {
        this.floatList.Add(_Vector4.x);
        this.floatList.Add(_Vector4.y);
        this.floatList.Add(_Vector4.z);
        this.floatList.Add(_Vector4.w);
    }

    public Vector4 GetNextVector4()
    {
        float var_x = this.GetNextFloat();
        float var_y = this.GetNextFloat();
        float var_z = this.GetNextFloat();
        float var_w = this.GetNextFloat();

        return new Vector4(var_x, var_y, var_z, var_w);
    }

    public void Add(Matrix4x4 _Matrix4x4)
    {
        for (int i = 0; i < 4; i++)
        {
            this.Add(_Matrix4x4.GetColumn(i));
        }
    }

    public void AddMatrix4x4(Matrix4x4 _Matrix4x4)
    {
        for (int i = 0; i < 4; i++)
        {
            this.Add(_Matrix4x4.GetColumn(i));
        }
    }

    public Matrix4x4 GetNextMatrix4x4()
    {
        Matrix4x4 var_Matrix4x4 = new Matrix4x4();

        for (int i = 0; i < 4; i++)
        {
            Vector4 var_Vector4 = this.GetNextVector4();
            var_Matrix4x4.SetColumn(i, var_Vector4);
        }

        return var_Matrix4x4;
    }

    public void Add(Quaternion _Quaternion)
    {
        this.AddQuaternion(_Quaternion);
    }

    public void AddQuaternion(Quaternion _Quaternion)
    {
        this.AddVector4(new Vector4(_Quaternion.x, _Quaternion.y, _Quaternion.z, _Quaternion.w));
    }

    public Quaternion GetNextQuaternion()
    {
        Vector4 var_Vector4 = this.GetNextVector4();

        return new Quaternion(var_Vector4.x, var_Vector4.y, var_Vector4.z, var_Vector4.w);
    }
}

