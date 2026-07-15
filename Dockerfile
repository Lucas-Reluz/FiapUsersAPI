# Build stage
FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build
WORKDIR /src

# Copy csproj files and restore dependencies
COPY ["src/UsersAPI.Api/UsersAPI.Api.csproj", "UsersAPI.Api/"]
COPY ["src/UsersAPI.Application/UsersAPI.Application.csproj", "UsersAPI.Application/"]
COPY ["src/UsersAPI.Domain/UsersAPI.Domain.csproj", "UsersAPI.Domain/"]
COPY ["src/UsersAPI.Infrastructure/UsersAPI.Infrastructure.csproj", "UsersAPI.Infrastructure/"]

RUN dotnet restore "UsersAPI.Api/UsersAPI.Api.csproj"

# Copy all source code
COPY src/ .

# Build and publish
WORKDIR "/src/UsersAPI.Api"
RUN dotnet build "UsersAPI.Api.csproj" -c Release -o /app/build
RUN dotnet publish "UsersAPI.Api.csproj" -c Release -o /app/publish /p:UseAppHost=false

# Runtime stage
FROM mcr.microsoft.com/dotnet/aspnet:8.0 AS runtime
WORKDIR /app

# Copy published files
COPY --from=build /app/publish .

# Expose port
EXPOSE 8080

# Entry point
ENTRYPOINT ["dotnet", "UsersAPI.Api.dll"]
