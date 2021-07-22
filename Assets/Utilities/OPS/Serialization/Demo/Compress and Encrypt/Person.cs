using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using OPS.Serialization.Attributes;

[SerializeAbleClass]
//Employee inherites from Person. So you need to add an ClassInheritanceAttribute!
[ClassInheritance(typeof(Employee), 0)]
//Child inherites from Person. So you need to add an ClassInheritanceAttribute!
[ClassInheritance(typeof(Child), 1)]
public class Person
{
    public enum EGender
    {
        Male,
        Female,
        Other
    }

    [SerializeAbleField(0)]
    public EGender Gender;

    [SerializeAbleField(1)]
    public int Age;

    [SerializeAbleField(2)]
    public String FirstName;

    [SerializeAbleField(3)]
    public String LastName;

    [SerializeAbleField(4)]
    public String Address;

    [SerializeAbleField(5)]
    public Sandbox.Shared.Sex Sex;

    //public string FirstName;
    //public string LastName;
    //public Sex2 Sex;
}

