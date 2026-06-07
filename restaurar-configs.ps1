# restaurar-configs.ps1
# Script para restaurar configurações do Zed e Qwen após formatação do Windows

Write-Host "Iniciando restauracao das configuracoes..." -ForegroundColor Green

$ZedAppData = "$env:APPDATA\Zed"
$QwenDir = "$env:USERPROFILE\.qwen"
$RepoDir = $PSScriptRoot # Pasta onde este script esta localizado (zed-config)

# ==========================================
# 1. RESTAURAR ZED (Via Link Simbolico / Junction)
# ==========================================
Write-Host "Configurando link do Zed..." -ForegroundColor Cyan

# Remove a pasta ou link antigo se existir para evitar conflitos
if (Test-Path $ZedAppData) {
    Write-Host "  -> Removendo configuracao/link antigo em $ZedAppData" -ForegroundColor Yellow
    Remove-Item -Path $ZedAppData -Recurse -Force -ErrorAction SilentlyContinue
}

# Cria o Directory Junction apontando da pasta do Windows para o seu repositorio
# /J e mais robusto para pastas locais no Windows e geralmente nao exige Admin
Write-Host "  -> Criando junction de '$RepoDir' para '$ZedAppData'" -ForegroundColor Cyan
cmd.exe /c "mklink /J `"$ZedAppData`" `"$RepoDir`" >nul 2>&1"

if (Test-Path $ZedAppData) {
    Write-Host "  -> Link do Zed criado com sucesso!" -ForegroundColor Green
} else {
    Write-Host "  -> ERRO: Falha ao criar o link. Execute este script como Administrador." -ForegroundColor Red
}

# ==========================================
# 2. RESTAURAR QWEN
# ==========================================
Write-Host "Restaurando configuracoes do Qwen em $QwenDir..." -ForegroundColor Cyan
New-Item -ItemType Directory -Force -Path $QwenDir | Out-Null

if (Test-Path "$RepoDir\qwen-config") {
    Copy-Item -Path "$RepoDir\qwen-config\*" -Destination $QwenDir -Recurse -Force
    Write-Host "  -> Configs do Qwen copiadas com sucesso!" -ForegroundColor Green
} else {
    Write-Host "  -> Aviso: Pasta qwen-config nao encontrada no repositorio." -ForegroundColor Yellow
}

Write-Host "`n==========================================" -ForegroundColor Cyan
Write-Host "Restauracao concluida com sucesso!" -ForegroundColor Green
Write-Host "Lembre-se de recriar a variavel de ambiente DASHSCOPE_API_KEY no Windows." -ForegroundColor Yellow
Write-Host "==========================================" -ForegroundColor Cyan