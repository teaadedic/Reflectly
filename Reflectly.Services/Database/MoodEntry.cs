using System;
using System.Collections.Generic;

namespace Reflectly.Services.Database
{
    public partial class MoodEntry
    {
        public MoodEntry()
        {
            JournalEntries = new HashSet<JournalEntry>();
        }

        public Guid MoodEntryId { get; set; }
        public Guid UserId { get; set; }
        public string MoodEmoji { get; set; } = null!;
        public string? MoodText { get; set; }
        public DateTime? Timestamp { get; set; }

        public virtual User User { get; set; } = null!;
        public virtual ICollection<JournalEntry> JournalEntries { get; set; }
    }
}
