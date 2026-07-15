using MediatR;
using UsersAPI.Application.DTOs;

namespace UsersAPI.Application.Commands;

public class RegisterUserCommand : IRequest<UserResponse>
{
    public string Name { get; set; } = string.Empty;
    public string Email { get; set; } = string.Empty;
    public string Password { get; set; } = string.Empty;

    public RegisterUserCommand()
    {
    }

    public RegisterUserCommand(string name, string email, string password)
    {
        Name = name;
        Email = email;
        Password = password;
    }
}
