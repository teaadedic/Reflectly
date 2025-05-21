using System;
using Reflectly.Model.Requests;


namespace Reflectly.Model.Requests
{
    public class UserLoginRequest
    {
        public string UserName { get; set; }
        public string Password { get; set; }
    }
}
