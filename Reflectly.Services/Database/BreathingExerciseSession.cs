using System;
using System.Collections.Generic;

namespace Reflectly.Services.Database
{
    public partial class BreathingExerciseSession
    {
        public Guid SessionId { get; set; }
        public Guid UserId { get; set; }
        public int DurationSeconds { get; set; }
        public DateTime? Timestamp { get; set; }

        public virtual User User { get; set; } = null!;
    }
}
