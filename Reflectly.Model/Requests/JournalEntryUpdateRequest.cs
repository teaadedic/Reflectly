using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Reflectly.Model.Requests
{
    public class JournalEntryUpdateRequest
    {

        [Required(ErrorMessage = "UserID is requred")]
        public Guid UserId { get; set; }

        [Required(AllowEmptyStrings = false, ErrorMessage = "Empty filed no allowed")]
        public string PromptText { get; set; } = null!;

        [Required(AllowEmptyStrings = false, ErrorMessage = "Empty filed no allowed")]
        public string ResponseText { get; set; } = null!;

        public DateTime? Timestamp { get; set; }

        public Guid? LinkedMoodEntryId { get; set; }
    }
}
