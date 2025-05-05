using System;
using System.Collections.Generic;

namespace Reflectly.Services.Database
{
    public partial class JournalEntry
    {
        public JournalEntry()
        {
            MoodLabels = new HashSet<MoodLabel>();
        }

        public Guid JournalEntryId { get; set; }
        public Guid UserId { get; set; }
        public string PromptText { get; set; } = null!;
        public string ResponseText { get; set; } = null!;
        public DateTime? Timestamp { get; set; }
        public Guid? LinkedMoodEntryId { get; set; }

        public virtual MoodEntry? LinkedMoodEntry { get; set; }
        public virtual User User { get; set; } = null!;
        public string? StateMachine {  get; set; }

        public virtual ICollection<MoodLabel> MoodLabels { get; set; }
    }
}
