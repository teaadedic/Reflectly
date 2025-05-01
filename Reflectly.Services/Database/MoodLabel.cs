using System;
using System.Collections.Generic;

namespace Reflectly.Services.Database
{
    public partial class MoodLabel
    {
        public MoodLabel()
        {
            JournalEntries = new HashSet<JournalEntry>();
        }

        public Guid MoodLabelId { get; set; }
        public string LabelName { get; set; } = null!;

        public virtual ICollection<JournalEntry> JournalEntries { get; set; }
    }
}
