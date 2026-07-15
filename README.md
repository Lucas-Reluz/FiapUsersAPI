# UsersAPI

API para gerenciar usuarios da plataforma de jogos.

## O que faz

- Cadastrar novos usuarios
- Fazer login e gerar token JWT
- Buscar informacoes de usuarios
- Publica eventos quando um usuario e criado

## Como funciona

Quando um usuario se cadastra, a API salva os dados no banco PostgreSQL e envia uma mensagem pelo RabbitMQ avisando os outros servicos.

## Como rodar

1. Ter Docker rodando com PostgreSQL e RabbitMQ
2. Entrar na pasta do projeto:
   ```
   cd UsersAPI/src/UsersAPI.Api
   ```
3. Rodar o comando:
   ```
   dotnet run
   ```
4. A API vai abrir em: http://localhost:5227

## O que precisa configurar

No arquivo appsettings.json tem:
- Conexao com banco PostgreSQL
- Configuracao do RabbitMQ
- Chave secreta do JWT

## Endpoints principais

- POST /api/auth/register - Cadastrar usuario
- POST /api/auth/login - Fazer login
- GET /api/users - Listar usuarios (precisa estar logado)
- GET /api/health - Ver se a API esta funcionando
