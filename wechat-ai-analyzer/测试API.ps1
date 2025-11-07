# 测试 Gemini API 连接

Write-Host "================================" -ForegroundColor Cyan
Write-Host "  测试 Gemini API" -ForegroundColor Cyan
Write-Host "================================" -ForegroundColor Cyan
Write-Host ""

# 检查配置文件
if (-not (Test-Path "config.json")) {
    Write-Host "❌ 未找到 config.json" -ForegroundColor Red
    Write-Host ""
    Write-Host "请先:" -ForegroundColor Yellow
    Write-Host "1. 复制 config.example.json 为 config.json" -ForegroundColor Gray
    Write-Host "2. 填入你的 Gemini API Key" -ForegroundColor Gray
    pause
    exit 1
}

# 读取配置
$config = Get-Content "config.json" -Raw | ConvertFrom-Json
$apiKey = $config.gemini_api_key

if (-not $apiKey -or $apiKey -eq "your_api_key_here") {
    Write-Host "❌ 请在 config.json 中设置正确的 API Key" -ForegroundColor Red
    pause
    exit 1
}

Write-Host "🔑 API Key: $($apiKey.Substring(0, 10))..." -ForegroundColor Gray
Write-Host ""

# 测试连接
Write-Host "🧪 测试 1: 简单问答" -ForegroundColor Cyan
Write-Host "   发送请求..." -ForegroundColor Gray

$url = "https://generativelanguage.googleapis.com/v1beta/models/gemini-2.0-flash:generateContent?key=$apiKey"

$body = @{
    contents = @(
        @{
            parts = @(
                @{
                    text = "用一句话介绍人工智能"
                }
            )
        }
    )
} | ConvertTo-Json -Depth 10

try {
    $response = Invoke-RestMethod -Uri $url -Method Post -Body $body -ContentType "application/json" -TimeoutSec 30
    
    if ($response.candidates -and $response.candidates[0].content.parts[0].text) {
        $answer = $response.candidates[0].content.parts[0].text
        Write-Host ""
        Write-Host "✅ API 连接成功！" -ForegroundColor Green
        Write-Host ""
        Write-Host "AI 回复:" -ForegroundColor Cyan
        Write-Host "  $answer" -ForegroundColor White
        Write-Host ""
        
        # 测试中文
        Write-Host "🧪 测试 2: 中文理解" -ForegroundColor Cyan
        Write-Host "   发送请求..." -ForegroundColor Gray
        
        $body2 = @{
            contents = @(
                @{
                    parts = @(
                        @{
                            text = "今天天气不错，适合出门玩。这句话的情感是积极还是消极？"
                        }
                    )
                }
            )
        } | ConvertTo-Json -Depth 10
        
        $response2 = Invoke-RestMethod -Uri $url -Method Post -Body $body2 -ContentType "application/json" -TimeoutSec 30
        
        if ($response2.candidates -and $response2.candidates[0].content.parts[0].text) {
            $answer2 = $response2.candidates[0].content.parts[0].text
            Write-Host ""
            Write-Host "✅ 中文理解测试成功！" -ForegroundColor Green
            Write-Host ""
            Write-Host "AI 回复:" -ForegroundColor Cyan
            Write-Host "  $answer2" -ForegroundColor White
        }
        
        Write-Host ""
        Write-Host "================================" -ForegroundColor Green
        Write-Host "✅ 所有测试通过！" -ForegroundColor Green
        Write-Host "================================" -ForegroundColor Green
        Write-Host ""
        Write-Host "可以开始使用了！运行 快速启动.ps1 开始分析" -ForegroundColor Cyan
        
    } else {
        Write-Host "⚠️  响应格式异常" -ForegroundColor Yellow
        Write-Host $response | ConvertTo-Json -Depth 10
    }
    
} catch {
    Write-Host ""
    Write-Host "❌ API 测试失败" -ForegroundColor Red
    Write-Host ""
    Write-Host "错误信息:" -ForegroundColor Yellow
    Write-Host $_.Exception.Message -ForegroundColor Gray
    Write-Host ""
    
    Write-Host "可能的原因:" -ForegroundColor Yellow
    Write-Host "1. API Key 不正确" -ForegroundColor Gray
    Write-Host "2. 网络连接问题（需要访问 Google 服务）" -ForegroundColor Gray
    Write-Host "3. API 配额已用完" -ForegroundColor Gray
    Write-Host "4. 防火墙拦截" -ForegroundColor Gray
    Write-Host ""
    
    Write-Host "解决方案:" -ForegroundColor Yellow
    Write-Host "1. 检查 config.json 中的 API Key 是否正确" -ForegroundColor Gray
    Write-Host "2. 确保网络可以访问 Google 服务" -ForegroundColor Gray
    Write-Host "3. 访问 https://aistudio.google.com 查看 API 使用情况" -ForegroundColor Gray
}

Write-Host ""
Write-Host "按任意键退出..." -ForegroundColor Gray
pause

