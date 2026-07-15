using MediatR;
using UsersAPI.Application.DTOs;

namespace UsersAPI.Application.Commands;

public class LoginCommand : IRequest<LoginResponse>
{
    public string Email { get; set; } = string.Empty;
    public string Password { get; set; } = string.Empty;

    public LoginCommand()
    {
    }

    public LoginCommand(string email, string password)
    {
        Email = email;
        Password = password;
    }
}
