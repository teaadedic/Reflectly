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

namespace Reflectly.Services
{
    public class UserService : IUserService
    {

        ReflectlyContext _context;

        public IMapper _mapper { get; set; }

        public UserService(ReflectlyContext context, IMapper mapper)
        {
            _context = context;
            _mapper = mapper;
        }

        public async Task<List<Model.User>> Get()
        {
            var entitnyList = await _context.Users.ToListAsync();

            

            return _mapper.Map<List<Model.User>>(entitnyList);
        }


        public Model.User Insert(UserInsertRequest request)
        {
            var entity = new Services.Database.User();
            _mapper.Map(request, entity);

            entity.PasswordSalt = GenerateSalt();
            entity.PasswordHash = GenerateHash(entity.PasswordSalt, request.Password);

            _context.Users.Add(entity);
            _context.SaveChanges();

            return _mapper.Map<Model.User>(entity);
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
    }
}
