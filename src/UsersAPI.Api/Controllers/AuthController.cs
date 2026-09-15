using MediatR;
using Microsoft.AspNetCore.Mvc;
using UsersAPI.Application.Commands;
using UsersAPI.Application.DTOs;

namespace UsersAPI.Api.Controllers;

[ApiController]
[Route("api/[controller]")]
public class AuthController : ControllerBase
{
    private readonly IMediator _mediator;
    private readonly ILogger<AuthController> _logger;

    public AuthController(IMediator mediator, ILogger<AuthController> logger)
    {
        _mediator = mediator;
        _logger = logger;
    }
    [HttpPost("register")]
    public async Task<ActionResult<UserResponse>> Register([FromBody] RegisterRequest request)
    {
        try
        {
            _logger.LogInformation("Tentativa de registro para email: {Email}", request.Email);

            var command = new RegisterUserCommand(request.Name, request.Email, request.Password);
            var result = await _mediator.Send(command);

            _logger.LogInformation("Usuário {UserId} registrado com sucesso", result.Id);

            return CreatedAtAction(nameof(UsersController.GetById), "Users", new { id = result.Id }, result);
        }
        catch (InvalidOperationException ex)
        {
            _logger.LogWarning(ex, "Falha no registro: {Message}", ex.Message);
            return BadRequest(new { error = ex.Message });
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "Erro ao registrar usuário");
            return StatusCode(500, new { error = "Erro interno ao processar requisição" });
        }
    }
    [HttpPost("login")]
    public async Task<ActionResult<LoginResponse>> Login([FromBody] LoginRequest request)
    {
        try
        {
            _logger.LogInformation("Tentativa de login para email: {Email}", request.Email);

            var command = new LoginCommand(request.Email, request.Password);
            var result = await _mediator.Send(command);

            _logger.LogInformation("Login bem-sucedido para usuário: {Email}", request.Email);

            return Ok(result);
        }
        catch (UnauthorizedAccessException ex)
        {
            _logger.LogWarning(ex, "Falha no login: {Message}", ex.Message);
            return Unauthorized(new { error = ex.Message });
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "Erro ao realizar login");
            return StatusCode(500, new { error = "Erro interno ao processar requisição" });
        }
    }
}
