using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Reflectly.Model
{
    public partial class User
    {
        public Guid UserId { get; set; }
        public string Email { get; set; } = null!;
        public string Name { get; set; } = null!;
        public DateTime? CreatedAt { get; set; }
        public DateTime? UpdatedAt { get; set; }

    }
}
