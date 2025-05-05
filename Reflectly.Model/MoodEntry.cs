using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Reflectly.Model
{
    public partial class MoodEntry
    {

        public Guid MoodEntryId { get; set; }
        public Guid UserId { get; set; }
        public string MoodEmoji { get; set; } = null!;
        public string? MoodText { get; set; }
        public DateTime? Timestamp { get; set; }

    }
}
