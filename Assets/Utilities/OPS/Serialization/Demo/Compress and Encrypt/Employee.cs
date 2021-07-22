using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using OPS.Serialization.Attributes;


[SerializeAbleClass]
//Teacher inherites from Employee. So you need to add an ClassInheritanceAttribute!
[ClassInheritance(typeof(Teacher), 0)]
public class Employee : Person
{
    [SerializeAbleField(0)]
    public String Department;
}

