using Reflectly.Services.Database;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using AutoMapper;

namespace Reflectly.Services
{
    public class MappingProfile : Profile
    {
        public MappingProfile() {
            CreateMap<Database.JournalEntry, Model.JournalEntry>();
            CreateMap<Database.User, Model.User>();
            CreateMap<Model.Requests.UserInsertRequest, Database.User>();
            CreateMap<Model.Requests.UserUpdateRequest, Database.User>();
        }
    }

    //public UserProfile()
        //{
            //CreateMap<User, UserViewModel>();
        //}
    }
