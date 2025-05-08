using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Reflectly.Model.Requests
{
    public class MoodEntryInsertRequest
    {
        
        public string MoodEmoji { get; set; } = null!;
        public string? MoodText { get; set; }
        public DateTime? Timestamp { get; set; }
    }
}
