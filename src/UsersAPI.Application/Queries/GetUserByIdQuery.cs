using MediatR;
using UsersAPI.Application.DTOs;

namespace UsersAPI.Application.Queries;

public class GetUserByIdQuery : IRequest<UserResponse?>
{
    public Guid UserId { get; set; }

    public GetUserByIdQuery()
    {
    }

    public GetUserByIdQuery(Guid userId)
    {
        UserId = userId;
    }
}
