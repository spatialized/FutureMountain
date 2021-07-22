using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using OPS.Serialization.Attributes;

[SerializeAbleClass]
public class Child : Person
{
    [SerializeAbleField(0)]
    public String FavouriteTeacherName;
}

