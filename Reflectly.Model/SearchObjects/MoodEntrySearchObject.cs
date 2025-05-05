using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Reflectly.Model.SearchObjects
{
    public class MoodEntrySearchObject : BaseSearchObject
    {
        public string? MoodEmoji { get; set; }

        public string? FTS { get; set; }
    }
}
