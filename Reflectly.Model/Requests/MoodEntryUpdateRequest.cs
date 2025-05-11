using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Reflectly.Model.Requests
{
    public class MoodEntryUpdateRequest
    {
        [Required(ErrorMessage = "UserID is requred")]
        public string UserId { get; set; }

        [Required(AllowEmptyStrings = false, ErrorMessage = "Empty filed no allowed")]
        public string MoodEmoji { get; set; } = null!;

        [Required(AllowEmptyStrings = false, ErrorMessage = "Empty filed no allowed")]
        public string? MoodText { get; set; }

        public DateTime? Timestamp { get; set; }
    }
}
