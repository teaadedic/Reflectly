using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Reflectly.Model.Requests
{
    public class UserUpdateRequest
    {
       
        
        public Guid UserId { get; set; }

        [Required(AllowEmptyStrings = false, ErrorMessage = "Empty filed no allowed")]
        public string Email { get; set; } = null!;

        [Required(AllowEmptyStrings = false, ErrorMessage = "Empty filed no allowed")]
        public string Name { get; set; } = null!;

        public DateTime? CreatedAt { get; set; }

        public DateTime? UpdatedAt { get; set; }

    }
}
