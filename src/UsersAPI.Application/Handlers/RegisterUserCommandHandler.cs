using MediatR;
using UsersAPI.Application.Commands;
using UsersAPI.Application.DTOs;
using UsersAPI.Domain.Entities;
using UsersAPI.Domain.Events;
using UsersAPI.Domain.Interfaces;
using BCrypt.Net;

namespace UsersAPI.Application.Handlers;

public class RegisterUserCommandHandler : IRequestHandler<RegisterUserCommand, UserResponse>
{
    private readonly IUserRepository _userRepository;
    private readonly IEventPublisher _eventPublisher;

    public RegisterUserCommandHandler(IUserRepository userRepository, IEventPublisher eventPublisher)
    {
        _userRepository = userRepository;
        _eventPublisher = eventPublisher;
    }

    public async Task<UserResponse> Handle(RegisterUserCommand request, CancellationToken cancellationToken)
    {
        // Verificar se email já existe
        if (await _userRepository.EmailExistsAsync(request.Email))
        {
            throw new InvalidOperationException("Email já está em uso");
        }

        // Hash da senha
        var passwordHash = BCrypt.Net.BCrypt.HashPassword(request.Password);

        // Criar usuário
        var user = new User(request.Name, request.Email, passwordHash);

        // Persistir no banco
        await _userRepository.AddAsync(user);

        // Publicar evento UserCreatedEvent
        var userCreatedEvent = new UserCreatedEvent(user.Id, user.Name, user.Email);
        await _eventPublisher.PublishAsync(userCreatedEvent);

        // Retornar resposta
        return new UserResponse
        {
            Id = user.Id,
            Name = user.Name,
            Email = user.Email,
            CreatedAt = user.CreatedAt
        };
    }
}
