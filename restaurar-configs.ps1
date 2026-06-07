# restaurar-configs.ps1
# Script para restaurar configuracoes do Zed e Qwen apos formatacao do Windows

Write-Host "Iniciando restauracao das configuracoes..." -ForegroundColor Green

# 1. Definir caminhos
$ZedAppData = "$env:APPDATA\Zed"
$QwenDir = "$env:USERPROFILE\.qwen"
$RepoDir = $PSScriptRoot # Assume que o script esta dentro da pasta zed-config

# 2. Restaurar Zed
Write-Host "Restaurando configuracoes do Zed em $ZedAppData..." -ForegroundColor Cyan
New-Item -ItemType Directory -Force -Path $ZedAppData | Out-Null

# Copia arquivos individuais se existirem
$filesToCopy = @("settings.json", "keymap.json", "tasks.json", "AGENTS.md", ".clangd")
foreach ($file in $filesToCopy) {
    if (Test-Path "$RepoDir\$file") {
        Copy-Item -Path "$RepoDir\$file" -Destination $ZedAppData -Force
        Write-Host "  -> Copiado: $file" -ForegroundColor Gray
    }
}

# Copia pasta de temas se existir
if (Test-Path "$RepoDir\themes") {
    Copy-Item -Path "$RepoDir\themes" -Destination $ZedAppData -Recurse -Force
    Write-Host "  -> Copiado: themes\" -ForegroundColor Gray
}

# 3. Restaurar Qwen
Write-Host "Restaurando configuracoes do Qwen em $QwenDir..." -ForegroundColor Cyan
New-Item -ItemType Directory -Force -Path $QwenDir | Out-Null

if (Test-Path "$RepoDir\qwen-config") {
    Copy-Item -Path "$RepoDir\qwen-config\*" -Destination $QwenDir -Recurse -Force
    Write-Host "  -> Copiado: conteudo de qwen-config\" -ForegroundColor Gray
}

Write-Host "`nRestauracao concluida com sucesso!" -ForegroundColor Green
Write-Host "Lembre-se de verificar se a variavel de ambiente DASHSCOPE_API_KEY esta configurada no Windows." -ForegroundColor Yellow
Write-Host "Para configurar via PowerShell (como Administrador):" -ForegroundColor Yellow
Write-Host '[Environment]::SetEnvironmentVariable("DASHSCOPE_API_KEY", "SUA_CHAVE_AQUI", "User")' -ForegroundColor White