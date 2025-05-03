using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Reflectly.Model
{
    public partial class JournalEntry
    {

        public Guid JournalEntryId { get; set; }
        public Guid UserId { get; set; }
        public string PromptText { get; set; } = null!;
        public string ResponseText { get; set; } = null!;
        public DateTime? Timestamp { get; set; }
        public Guid? LinkedMoodEntryId { get; set; }

       
    }
}
