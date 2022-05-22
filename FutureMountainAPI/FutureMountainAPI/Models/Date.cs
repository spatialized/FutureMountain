using System.ComponentModel.DataAnnotations;

namespace FutureMountainAPI
{
    public class Date
    {
        [Key]
        public int id { get; set; }

        public DateTime date { get; set; }

        public int year { get; set; }
        public int month { get; set; }
        public int day { get; set; }
        public Date() {}
    }
}
