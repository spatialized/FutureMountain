using System;

namespace Assets.Scripts.Models
{
    //myObject = JsonUtility.FromJson<DateList>("{\"dates\":" + www.text + "}");

    [Serializable]
    public class DateModel
    {
        public int id;

        public DateTime date;
        public int year;
        public int month;
        public int day;
        public DateModel() { }

        public override string ToString()
        {
            return "" + year + "-" + month + "-" + day;
        }
    }

    [Serializable]
    public class DateList
    {
        public DateModel[] dates;
    }
}
