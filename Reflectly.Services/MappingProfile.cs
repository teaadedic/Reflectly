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
            CreateMap<Database.MoodEntry, Model.MoodEntry>();
            CreateMap<Model.Requests.MoodEntryInsertRequest, Database.MoodEntry>();
            CreateMap<Model.Requests.MoodEntryUpdateRequest, Database.MoodEntry>();
            CreateMap<Model.Requests.UserInsertRequest, Database.User>();
            CreateMap<Model.Requests.UserUpdateRequest, Database.User>();
            CreateMap<Model.Requests.JournalEntryInsertRequest, Database.JournalEntry>();
            CreateMap<Model.Requests.JournalEntryUpdateRequest, Database.JournalEntry>();
        }
    }

    
    }
