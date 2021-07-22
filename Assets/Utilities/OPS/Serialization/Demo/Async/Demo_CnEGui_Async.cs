using System.Collections;
using System.Collections.Generic;
using System.Diagnostics;
using System.IO;
using UnityEngine;

public class Demo_CnEGui_Async : MonoBehaviour
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
        //this.StopAllCoroutines();
        //this.StartCoroutine(this.SaveAsync(teacher));

        //Save Data alternative
        this.SaveAsync_Alternative(teacher);
    }

    //Coroutines getting called in the unity main thread!
    //So when the async serialization is finished, you can process the bytes sync.
    private IEnumerator SaveAsync(Teacher teacher)
    {
        var serializerAsyncRequest = OPS.Serialization.IO.Helper.SerializerAsyncRequestFactory.CreateSerializerAsyncRequest(teacher);
        yield return serializerAsyncRequest;

        FileStream stream = new FileStream("OPS_Teacher.ser", FileMode.Create);
        stream.Write(serializerAsyncRequest.Bytes, 0, serializerAsyncRequest.Bytes.Length);
        stream.Close();

        UnityEngine.Debug.Log("Saved Teacher: " + teacher.FirstName);
    }

    //The alternative is complete in another thread!
    private void SaveAsync_Alternative(Teacher teacher)
    {
        OPS.Serialization.IO.SerializerAsync.Serialize(this.OnSavedAsync_Alternative, teacher);
    }

    //So this method wont get called in the unity main thread.
    //When the serialization is finished!
    private void OnSavedAsync_Alternative(object myObject, byte[] bytes)
    {
        FileStream stream = new FileStream("OPS_Teacher.ser", FileMode.Create);
        stream.Write(bytes, 0, bytes.Length);
        stream.Close();

        UnityEngine.Debug.Log("Saved Teacher: " + ((Teacher)myObject).FirstName);
    }

    public void Load()
    {
        //Check if exits
        if(!File.Exists("OPS_Teacher.ser"))
        {
            UnityEngine.Debug.LogError("OPS_Teacher.ser does not exits. Please use first save!");
        }

        //Load Data
        //this.StopAllCoroutines();
        //this.StartCoroutine(this.LoadAsync());

        //Load Data alternative
        this.LoadAsync_Alternative();
    }

    private IEnumerator LoadAsync()
    {
        byte[] bytes = File.ReadAllBytes("OPS_Teacher.ser");

        var serializerAsyncRequest = OPS.Serialization.IO.Helper.SerializerAsyncRequestFactory.CreateDeserializerAsyncRequest(typeof(Teacher), bytes);
        yield return serializerAsyncRequest;

        Teacher teacher = (Teacher)serializerAsyncRequest.Object;

        UnityEngine.Debug.Log("Loaded Teacher: " + teacher.FirstName);
    }

    private void LoadAsync_Alternative()
    {
        byte[] bytes = File.ReadAllBytes("OPS_Teacher.ser");

        OPS.Serialization.IO.SerializerAsync.Deserialize<Teacher>(this.OnLoadedAsync_Alternative, bytes);
    }

    private void OnLoadedAsync_Alternative(Teacher teacher)
    {
        UnityEngine.Debug.Log("Loaded Teacher: " + teacher.FirstName);
    }
}
