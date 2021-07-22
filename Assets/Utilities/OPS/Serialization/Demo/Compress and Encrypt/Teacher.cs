using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using OPS.Serialization.Attributes;

[SerializeAbleClass]
public class Teacher : Employee
{
    [SerializeAbleField(0)]
    public String School;

    [SerializeAbleField(1)]
    public List<Child> ChildsInClass;
}

