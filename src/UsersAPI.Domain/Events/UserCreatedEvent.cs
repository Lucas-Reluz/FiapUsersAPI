namespace UsersAPI.Domain.Events;

public class UserCreatedEvent
{
    public Guid UserId { get; set; }
    public string Name { get; set; } = string.Empty;
    public string Email { get; set; } = string.Empty;
    public DateTime CreatedAt { get; set; }

    public UserCreatedEvent()
    {
    }

    public UserCreatedEvent(Guid userId, string name, string email)
    {
        UserId = userId;
        Name = name;
        Email = email;
        CreatedAt = DateTime.UtcNow;
    }
}
