using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Reflectly.Model.Requests
{
    public class FcmTokenUpdateRequest
    {
        public Guid UserId { get; set; }
        public string FcmToken { get; set; }
    }

    public class ToggleNotificationRequest
    {
        public Guid UserId { get; set; }
        public bool Enabled { get; set; }
    }
}
