using System;
using System.Collections.Generic;

namespace Reflectly.Services.Database
{
    public partial class User
    {
        public User()
        {
            BreathingExerciseSessions = new HashSet<BreathingExerciseSession>();
            JournalEntries = new HashSet<JournalEntry>();
            MoodEntries = new HashSet<MoodEntry>();
        }

        public Guid UserId { get; set; }
        public string Email { get; set; } = null!;
        public string PasswordHash { get; set; } = null!;
        public string PasswordSalt { get; set; } = null!;
        public string Name { get; set; } = null!;
        public DateTime? CreatedAt { get; set; }
        public DateTime? UpdatedAt { get; set; }

        public virtual ICollection<BreathingExerciseSession> BreathingExerciseSessions { get; set; }
        public virtual ICollection<JournalEntry> JournalEntries { get; set; }
        public virtual ICollection<MoodEntry> MoodEntries { get; set; }
    }
}
