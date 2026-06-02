# Claude Code 模型切换工具 v3 (Windows PowerShell)
# 只修改 settings.json 中的模型相关字段，保留插件、权限、MCP 等所有其他配置
#
# 安装：将此文件放到 PATH 中（如 C:\Users\你的用户名\bin\）
# 配置：修改下方 $PROFILES 中的 API Key 为你的真实 Key

param(
    [Parameter(Position=0)]
    [ValidateSet("kimi", "zhipu", "minimax")]
    [string]$Profile = ""
)

$SettingsPath = "$env:USERPROFILE\.claude\settings.json"
$BackupPath = "$env:USERPROFILE\.claude\settings.json.bak"

$Labels = @{
    "kimi"   = "Kimi (月之暗面)"
    "zhipu"  = "智谱/GLM"
    "minimax" = "MiniMax"
}

# ===== 在这里填入你的真实 API Key =====
$Profiles = @{
    "kimi" = @{
        "ANTHROPIC_BASE_URL"            = "https://api.kimi.com/coding/"
        "ANTHROPIC_AUTH_TOKEN"           = "sk-kimi-你的Kimi-Key"
        "ANTHROPIC_MODEL"                = "kimi-for-coding"
        "ANTHROPIC_DEFAULT_SONNET_MODEL" = "kimi-for-coding"
        "ANTHROPIC_DEFAULT_OPUS_MODEL"   = "kimi-for-coding"
        "ANTHROPIC_DEFAULT_HAIKU_MODEL"  = "kimi-for-coding"
    }
    "zhipu" = @{
        "ANTHROPIC_BASE_URL"            = "https://open.bigmodel.cn/api/anthropic"
        "ANTHROPIC_AUTH_TOKEN"           = "你的智谱API_Key"
        "ANTHROPIC_MODEL"                = "GLM-5.1"
        "ANTHROPIC_DEFAULT_SONNET_MODEL" = "GLM-5.1"
        "ANTHROPIC_DEFAULT_OPUS_MODEL"   = "GLM-5.1"
        "ANTHROPIC_DEFAULT_HAIKU_MODEL"  = "GLM-5-Turbo"
    }
    "minimax" = @{
        "ANTHROPIC_BASE_URL"            = "https://api.minimaxi.com/anthropic"
        "ANTHROPIC_AUTH_TOKEN"           = "sk-cp-你的MiniMax-Key"
        "ANTHROPIC_MODEL"                = "MiniMax-M3"
        "ANTHROPIC_DEFAULT_SONNET_MODEL" = "MiniMax-M3"
        "ANTHROPIC_DEFAULT_OPUS_MODEL"   = "MiniMax-M3"
        "ANTHROPIC_DEFAULT_HAIKU_MODEL"  = "MiniMax-M2.7-highspeed"
    }
}

if (-not $Profile) {
    Write-Host "Usage: use-model <kimi|zhipu|minimax>" -ForegroundColor Yellow
    exit 1
}

# 检测运行中的 Claude Code
$claudeProcesses = Get-Process -Name "claude" -ErrorAction SilentlyContinue | Where-Object {
    $_.Path -notlike "*use-model*"
}
if ($claudeProcesses) {
    Write-Host "⚠️  检测到 Claude Code 正在运行！" -ForegroundColor Yellow
    Write-Host "   运行中切换模型可能导致配置不一致"
    $answer = Read-Host "   仍要继续？(y/N)"
    if ($answer -ne 'y') {
        Write-Host "   已取消"
        exit 0
    }
}

# 读取 settings.json
if (-not (Test-Path $SettingsPath)) {
    Write-Host "❌ settings.json 不存在" -ForegroundColor Red
    exit 1
}

try {
    $json = Get-Content $SettingsPath -Raw -Encoding UTF8 | ConvertFrom-Json
} catch {
    Write-Host "❌ settings.json 已损坏" -ForegroundColor Red
    if (Test-Path $BackupPath) {
        Copy-Item $BackupPath $SettingsPath -Force
        $json = Get-Content $SettingsPath -Raw -Encoding UTF8 | ConvertFrom-Json
        Write-Host "✅ 已从备份恢复" -ForegroundColor Green
    } else {
        Write-Host "❌ 无备份可用" -ForegroundColor Red
        exit 1
    }
}

# 检测重复切换
$currentModel = $json.env.ANTHROPIC_MODEL
$targetModel = $Profiles[$Profile]["ANTHROPIC_MODEL"]
if ($currentModel -eq $targetModel) {
    Write-Host "ℹ️  已经是 $($Labels[$Profile])，无需切换" -ForegroundColor Cyan
    exit 0
}

# 备份
Copy-Item $SettingsPath $BackupPath -Force

# 只更新模型字段
if (-not $json.PSObject.Properties["env"]) {
    $json | Add-Member -NotePropertyName "env" -NotePropertyValue @{} -Force
}

foreach ($key in $Profiles[$Profile].Keys) {
    if ($json.env.PSObject.Properties[$key]) {
        $json.env.$key = $Profiles[$Profile][$key]
    } else {
        $json.env | Add-Member -NotePropertyName $key -NotePropertyValue $Profiles[$Profile][$key] -Force
    }
}

# 原子写入
$tmpPath = $SettingsPath + ".tmp"
$json | ConvertTo-Json -Depth 10 | Set-Content $tmpPath -Encoding UTF8
Move-Item $tmpPath $SettingsPath -Force

# 找到旧模型名称
$oldLabel = "未知"
foreach ($name in $Labels.Keys) {
    if ($Profiles[$name]["ANTHROPIC_MODEL"] -eq $currentModel) {
        $oldLabel = $Labels[$name]
        break
    }
}

$pluginCount = 0
if ($json.PSObject.Properties["enabledPlugins"] -and $json.enabledPlugins) {
    $pluginCount = ($json.enabledPlugins.PSObject.Properties | Measure-Object).Count
}

Write-Host "✅ $oldLabel → $($Labels[$Profile])" -ForegroundColor Green
Write-Host "   插件: $pluginCount 个" -ForegroundColor Gray
