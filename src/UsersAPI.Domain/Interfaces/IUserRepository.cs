using UsersAPI.Domain.Entities;

namespace UsersAPI.Domain.Interfaces;

public interface IUserRepository
{
    Task<User?> GetByIdAsync(Guid id);
    Task<User?> GetByEmailAsync(string email);
    Task<User> AddAsync(User user);
    Task<bool> EmailExistsAsync(string email);
}
