using UsersAPI.Domain.Events;

namespace UsersAPI.Domain.Interfaces;

public interface IEventPublisher
{
    Task PublishAsync<T>(T eventMessage) where T : class;
}
