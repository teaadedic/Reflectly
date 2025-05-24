using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Reflectly.Model
{
    public partial class BreathingExerciseSession
    {
        public Guid SessionId { get; set; }
        public Guid UserId { get; set; }
        public int DurationSeconds { get; set; }
        public DateTime? Timestamp { get; set; }

    }
}
