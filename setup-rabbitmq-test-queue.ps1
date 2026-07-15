# Script para criar fila de teste e fazer bind no exchange
$rabbitUrl = "http://localhost:15672/api"
$credentials = "guest:guest"
$encodedCredentials = [Convert]::ToBase64String([Text.Encoding]::ASCII.GetBytes($credentials))
$headers = @{
	"Authorization" = "Basic $encodedCredentials"
	"Content-Type" = "application/json"
}

Write-Host "Configurando fila de teste no RabbitMQ..." -ForegroundColor Cyan
Write-Host ""

# 1. Criar fila
Write-Host "1. Criando fila 'user.events.test'..." -ForegroundColor Yellow
$queueBody = @{
	durable = $true
	auto_delete = $false
} | ConvertTo-Json

try {
	Invoke-RestMethod -Uri "$rabbitUrl/queues/%2F/user.events.test" `
		-Method Put `
		-Headers $headers `
		-Body $queueBody
	Write-Host "   ✅ Fila criada!" -ForegroundColor Green
} catch {
	Write-Host "   ⚠️ Fila já existe ou erro: $($_.Exception.Message)" -ForegroundColor Yellow
}

Write-Host ""

# 2. Fazer bind da fila no exchange
Write-Host "2. Fazendo bind da fila ao exchange 'user.exchange'..." -ForegroundColor Yellow
$bindingBody = @{
	routing_key = ""
} | ConvertTo-Json

try {
	Invoke-RestMethod -Uri "$rabbitUrl/bindings/%2F/e/user.exchange/q/user.events.test" `
		-Method Post `
		-Headers $headers `
		-Body $bindingBody
	Write-Host "   ✅ Binding criado!" -ForegroundColor Green
} catch {
	Write-Host "   ⚠️ Binding já existe ou erro: $($_.Exception.Message)" -ForegroundColor Yellow
}

Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "Configuração concluída!" -ForegroundColor Green
Write-Host ""
Write-Host "Agora registre um novo usuário para ver a mensagem:" -ForegroundColor Magenta
Write-Host ""
Write-Host "  POST http://localhost:5227/api/auth/register" -ForegroundColor Gray
Write-Host '  Body: {"name": "Teste", "email": "teste@example.com", "password": "Senha@123"}' -ForegroundColor Gray
Write-Host ""
Write-Host "Depois, veja a mensagem em:" -ForegroundColor Magenta
Write-Host "  http://localhost:15672/#/queues/%2F/user.events.test" -ForegroundColor Cyan
Write-Host ""
