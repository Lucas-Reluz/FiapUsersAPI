namespace UsersAPI.Domain.Interfaces;

public interface IJwtService
{
    string GenerateToken(Entities.User user);
}
