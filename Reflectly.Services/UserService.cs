using Reflectly.Services.Database;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Reflectly.Model;
using AutoMapper;
using Reflectly.Model.Requests;
using System.Security.Cryptography;
using System.ComponentModel.DataAnnotations;
using Microsoft.EntityFrameworkCore;
using Reflectly.Model.SearchObjects;

namespace Reflectly.Services
{
    
    public class UserService : BaseCRUDService<Model.User, Database.User, BaseSearchObject, UserInsertRequest, UserUpdateRequest>, IUserService
    {

        ReflectlyContext _context;

        public IMapper _mapper { get; set; }

        public UserService(ReflectlyContext context, IMapper mapper)
            :base (context, mapper)
        {
           
        }
       
        public override async Task BeforeInsesrt(Database.User entity, UserInsertRequest insert)
        {
            entity.PasswordSalt = GenerateSalt();
            entity.PasswordHash = GenerateHash(entity.PasswordSalt, insert.Password);
        }

        public static string GenerateSalt()
        {
            RNGCryptoServiceProvider provider = new RNGCryptoServiceProvider();
            var byteArray = new byte[16];
            provider.GetBytes(byteArray);

            return Convert.ToBase64String(byteArray);
        }

        public static string GenerateHash(string salt, string password)
        {
            byte[] src = Convert.FromBase64String(salt);
            byte[] bytes = Encoding.Unicode.GetBytes(password);
            byte[] dst = new byte[src.Length + bytes.Length];

            System.Buffer.BlockCopy(src, 0, dst, 0, src.Length);
            System.Buffer.BlockCopy(bytes, 0, dst, src.Length,bytes.Length);

            HashAlgorithm algorithm = HashAlgorithm.Create("SHA1");
            byte[] inArray = algorithm.ComputeHash(dst);
            return Convert.ToBase64String(inArray);
        }

        public Model.User Update(int id, UserUpdateRequest request)
        {
            var entity = _context.Users.Find(id);

            _mapper.Map(request, entity);

            _context.SaveChanges();
            return _mapper.Map<Model.User>(entity);
        }

        public Task<List<Model.User>> Get()
        {
            throw new NotImplementedException();
        }

        Model.User IUserService.Insert(UserInsertRequest request)
        {
            throw new NotImplementedException();
        }
    }
}
