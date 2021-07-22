using System.Collections;
using System.Collections.Generic;
using System.Diagnostics;
using System.IO;
using UnityEngine;

public class Demo_CnEGui : MonoBehaviour
{
    public void Save()
    {
        //Create Data
        Teacher teacher = new Teacher();
        teacher.Gender = Person.EGender.Male;
        teacher.Age = 40;
        teacher.FirstName = "Peter";
        teacher.Address = "My Street 123";
        teacher.School = "Cool School!";

        teacher.ChildsInClass = new List<Child>()
        {
            new Child() { Age = 7, Gender = Person.EGender.Female, FavouriteTeacherName = "Anna", Address = "My Home" },
            new Child() { Age = 8, Gender = Person.EGender.Other, Address = "My Home 2", FavouriteTeacherName = "Peter" },
            new Child() { Age = 6, Gender = Person.EGender.Male, FavouriteTeacherName = "Sam", Address = "My Home 3" }
        };

        //Save Data
        FileStream stream = new FileStream("OPS_Teacher.ser", FileMode.Create);
        Stopwatch stopwatch = new Stopwatch();
        stopwatch.Start();
        OPS.Serialization.IO.Serializer.SerializeToStream(stream, teacher, true, true, "UltimatePassword!");
        stopwatch.Stop();
        stream.Close();
        
        UnityEngine.Debug.Log("Save Teacher: " + teacher.FirstName + " ElapsedMilliseconds: " + stopwatch.ElapsedMilliseconds);
    }

    public void Load()
    {
        //Check if exits
        if(!File.Exists("OPS_Teacher.ser"))
        {
            UnityEngine.Debug.LogError("OPS_Teacher.ser does not exits. Please use first save!");
        }

        //Load Data
        FileStream stream = new FileStream("OPS_Teacher.ser", FileMode.Open);
        Stopwatch stopwatch = new Stopwatch();
        stopwatch.Start();
        Teacher teacher = OPS.Serialization.IO.Serializer.DeSerializeFromStream<Teacher>(stream, true, true, "UltimatePassword!");
        stopwatch.Stop();
        stream.Close();

        UnityEngine.Debug.Log("Load Teacher: " + teacher.FirstName + " ElapsedMilliseconds: " + stopwatch.ElapsedMilliseconds);
    }
}
