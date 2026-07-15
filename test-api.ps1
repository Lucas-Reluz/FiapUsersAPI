# Script de teste para UsersAPI
$baseUrl = "http://localhost:5227"

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  TESTE COMPLETO - UsersAPI" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# Test 1: Registrar novo usuário
Write-Host "1. Registrando novo usuário..." -ForegroundColor Yellow
$registerBody = @{
	name = "Lucas Silva"
	email = "lucas@example.com"
	password = "Senha@123"
} | ConvertTo-Json

try {
	$registerResponse = Invoke-RestMethod -Uri "$baseUrl/api/auth/register" `
		-Method Post `
		-ContentType "application/json" `
		-Body $registerBody

	Write-Host " Usuário registrado com sucesso!" -ForegroundColor Green
	Write-Host "   ID: $($registerResponse.id)" -ForegroundColor Gray
	Write-Host "   Nome: $($registerResponse.name)" -ForegroundColor Gray
	Write-Host "   Email: $($registerResponse.email)" -ForegroundColor Gray
	$userId = $registerResponse.id
} catch {
	Write-Host "❌ Erro ao registrar usuário: $($_.Exception.Message)" -ForegroundColor Red
	exit
}

Write-Host ""

Write-Host "2. Fazendo login..." -ForegroundColor Yellow
$loginBody = @{
	email = "lucas@example.com"
	password = "Senha@123"
} | ConvertTo-Json

try {
	$loginResponse = Invoke-RestMethod -Uri "$baseUrl/api/auth/login" `
		-Method Post `
		-ContentType "application/json" `
		-Body $loginBody

	Write-Host " Login realizado com sucesso!" -ForegroundColor Green
	Write-Host "   Token: $($loginResponse.token.Substring(0, 50))..." -ForegroundColor Gray
	$token = $loginResponse.token
} catch {
	Write-Host " Erro ao fazer login: $($_.Exception.Message)" -ForegroundColor Red
	exit
}

Write-Host ""

Write-Host "3. Buscando usuário com JWT (rota protegida)..." -ForegroundColor Yellow
$headers = @{
	"Authorization" = "Bearer $token"
}

try {
	$userResponse = Invoke-RestMethod -Uri "$baseUrl/api/users/$userId" `
		-Method Get `
		-Headers $headers

	Write-Host " Usuário encontrado!" -ForegroundColor Green
	Write-Host "   ID: $($userResponse.id)" -ForegroundColor Gray
	Write-Host "   Nome: $($userResponse.name)" -ForegroundColor Gray
	Write-Host "   Email: $($userResponse.email)" -ForegroundColor Gray
} catch {
	Write-Host "❌ Erro ao buscar usuário: $($_.Exception.Message)" -ForegroundColor Red
	exit
}

Write-Host ""

Write-Host "4. Tentando acessar rota protegida SEM token (deve falhar)..." -ForegroundColor Yellow
try {
	$unauthorizedResponse = Invoke-RestMethod -Uri "$baseUrl/api/users/$userId" `
		-Method Get
	Write-Host "❌ Não deveria ter funcionado!" -ForegroundColor Red
} catch {
	if ($_.Exception.Response.StatusCode -eq 401) {
		Write-Host "✅ Corretamente bloqueado (401 Unauthorized)" -ForegroundColor Green
	} else {
		Write-Host "⚠️ Erro inesperado: $($_.Exception.Message)" -ForegroundColor Yellow
	}
}

Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  TESTES CONCLUÍDOS!" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "Verificar RabbitMQ Management UI:" -ForegroundColor Magenta
Write-Host "   URL: http://localhost:15672" -ForegroundColor Gray
Write-Host "   User: guest" -ForegroundColor Gray
Write-Host "   Pass: guest" -ForegroundColor Gray
Write-Host ""
