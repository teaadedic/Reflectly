using System;
using System.ComponentModel.DataAnnotations;
using Reflectly.Model.Requests;


namespace Reflectly.Model.Requests
{
    public class UserLoginRequest
    {
        [Required(ErrorMessage = "Username is required")]
        public string UserName { get; set; } = null!;

        [Required(ErrorMessage = "Password is required")]
        public string Password { get; set; } = null!;
    }
}
