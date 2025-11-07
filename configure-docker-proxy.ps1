# 配置 Docker 代理的 PowerShell 脚本

Write-Host "===========================================" -ForegroundColor Cyan
Write-Host "Docker 代理配置助手" -ForegroundColor Green
Write-Host "===========================================" -ForegroundColor Cyan
Write-Host ""

# 检查 Docker 是否运行
$dockerRunning = docker info 2>&1 | Select-String -Pattern "Server Version"
if (-not $dockerRunning) {
    Write-Host "错误: Docker Desktop 未运行，请先启动 Docker Desktop" -ForegroundColor Red
    exit 1
}

Write-Host "✓ Docker Desktop 正在运行" -ForegroundColor Green
Write-Host ""

# 设置代理地址
$proxyUrl = "http://127.0.0.1:7897"
Write-Host "代理地址: $proxyUrl" -ForegroundColor Yellow
Write-Host ""

# 检查 Docker daemon.json 位置
$daemonJsonPath = Join-Path $env:USERPROFILE ".docker\daemon.json"
$dockerConfigPath = Join-Path $env:ProgramData "Docker\config\daemon.json"

Write-Host "正在查找 Docker 配置文件..." -ForegroundColor Yellow

# 辅助函数：将对象转换为 Hashtable
function ConvertTo-Hashtable {
    param($obj)
    if ($obj -is [hashtable]) {
        return $obj
    }
    $ht = @{}
    $obj.PSObject.Properties | ForEach-Object {
        $ht[$_.Name] = if ($_.Value -is [PSCustomObject]) {
            ConvertTo-Hashtable $_.Value
        } else {
            $_.Value
        }
    }
    return $ht
}

# 尝试创建或更新 daemon.json
$configUpdated = $false
$configPath = $null

if (Test-Path $dockerConfigPath) {
    $configPath = $dockerConfigPath
    Write-Host "找到配置文件: $configPath" -ForegroundColor Green
} elseif (Test-Path $daemonJsonPath) {
    $configPath = $daemonJsonPath
    Write-Host "找到配置文件: $configPath" -ForegroundColor Green
} else {
    # 创建新配置文件
    $configDir = Split-Path $daemonJsonPath -Parent
    if (-not (Test-Path $configDir)) {
        New-Item -ItemType Directory -Path $configDir -Force | Out-Null
    }
    $configPath = $daemonJsonPath
    Write-Host "将创建新配置文件: $configPath" -ForegroundColor Yellow
}

# 读取或创建配置
$config = @{}
if (Test-Path $configPath) {
    try {
        $jsonContent = Get-Content $configPath -Raw
        if ($jsonContent) {
            $config = $jsonContent | ConvertFrom-Json | ConvertTo-Hashtable
        }
        Write-Host "✓ 已读取现有配置" -ForegroundColor Green
    } catch {
        Write-Host "警告: 无法读取现有配置，将创建新配置" -ForegroundColor Yellow
        $config = @{}
    }
}

# 更新代理配置
$config["proxies"] = @{
    "http-proxy" = $proxyUrl
    "https-proxy" = $proxyUrl
    "no-proxy" = "localhost,127.0.0.1"
}

# 保存配置
try {
    $config | ConvertTo-Json -Depth 10 | Set-Content $configPath -Encoding UTF8
    Write-Host "✓ 代理配置已更新: $configPath" -ForegroundColor Green
    $configUpdated = $true
} catch {
    Write-Host "警告: 无法自动更新配置文件: $_" -ForegroundColor Yellow
    Write-Host ""
    Write-Host "请手动编辑配置文件: $configPath" -ForegroundColor Yellow
    Write-Host "添加以下内容:" -ForegroundColor Yellow
    Write-Host (@"
{
  "proxies": {
    "http-proxy": "$proxyUrl",
    "https-proxy": "$proxyUrl",
    "no-proxy": "localhost,127.0.0.1"
  }
}
"@) -ForegroundColor Cyan
}

Write-Host ""
Write-Host "===========================================" -ForegroundColor Cyan
Write-Host "重要提示" -ForegroundColor Yellow
Write-Host "===========================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "由于 Docker Desktop 的代理配置主要通过 GUI 设置，" -ForegroundColor White
Write-Host "建议您也在 Docker Desktop 中手动配置:" -ForegroundColor White
Write-Host ""
Write-Host "1. 打开 Docker Desktop" -ForegroundColor Cyan
Write-Host "2. Settings (设置) → Resources → Proxies" -ForegroundColor Cyan
Write-Host "3. 设置以下代理:" -ForegroundColor Cyan
Write-Host "   Web server (HTTP): $proxyUrl" -ForegroundColor Yellow
Write-Host "   Secure Web server (HTTPS): $proxyUrl" -ForegroundColor Yellow
Write-Host "   Bypass: localhost,127.0.0.1" -ForegroundColor Yellow
Write-Host "4. 点击 'Apply and Restart'" -ForegroundColor Cyan
Write-Host ""
Write-Host "配置完成后，运行以下命令启动服务:" -ForegroundColor Green
Write-Host "  docker compose up -d" -ForegroundColor Cyan
Write-Host ""

if ($configUpdated) {
    Write-Host "注意: 修改配置文件后需要重启 Docker Desktop 才能生效！" -ForegroundColor Red
}

