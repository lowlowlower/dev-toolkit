# ====================================
# 数据库查询工具
# ====================================

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  🔍 数据库查询工具" -ForegroundColor Yellow
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# 检查容器是否运行
$running = docker ps --filter "name=supabase-db" --format "{{.Names}}"
if (-not $running) {
    Write-Host "❌ 数据库容器未运行" -ForegroundColor Red
    pause
    exit 1
}

Write-Host "选择查询:" -ForegroundColor Yellow
Write-Host "  1. 查看所有卡片" -ForegroundColor White
Write-Host "  2. 查看所有组合" -ForegroundColor White
Write-Host "  3. 查看所有工作流模板" -ForegroundColor White
Write-Host "  4. 查看卡片统计" -ForegroundColor White
Write-Host "  5. 自定义 SQL 查询" -ForegroundColor White
Write-Host "  6. 进入交互式 SQL 模式" -ForegroundColor White
Write-Host ""

$choice = Read-Host "请选择 (1-6)"
Write-Host ""

switch ($choice) {
    "1" {
        Write-Host "=== 所有卡片 ===" -ForegroundColor Green
        $sql = "SELECT id, title, category, rarity, level, skill_power FROM business_cards ORDER BY category, title;"
        $sql | docker exec -i supabase-db psql -U postgres -d postgres
    }
    
    "2" {
        Write-Host "=== 所有组合 ===" -ForegroundColor Green
        $sql = @"
SELECT 
    cc.combination_name,
    b1.title as card1,
    b2.title as card2,
    cc.synergy_bonus,
    cc.combo_effect
FROM card_combinations cc
JOIN business_cards b1 ON cc.card_id_1 = b1.id
JOIN business_cards b2 ON cc.card_id_2 = b2.id
ORDER BY cc.synergy_bonus DESC;
"@
        $sql | docker exec -i supabase-db psql -U postgres -d postgres
    }
    
    "3" {
        Write-Host "=== 所有工作流模板 ===" -ForegroundColor Green
        $sql = "SELECT name, category, difficulty, estimated_time, description FROM workflow_templates ORDER BY category;"
        $sql | docker exec -i supabase-db psql -U postgres -d postgres
    }
    
    "4" {
        Write-Host "=== 卡片统计 ===" -ForegroundColor Green
        $sql = @"
SELECT 
    category,
    COUNT(*) as count,
    AVG(skill_power) as avg_power,
    MAX(level) as max_level
FROM business_cards 
GROUP BY category
ORDER BY category;
"@
        $sql | docker exec -i supabase-db psql -U postgres -d postgres
    }
    
    "5" {
        Write-Host "请输入 SQL 查询 (按回车结束):" -ForegroundColor Yellow
        $sql = Read-Host
        if ($sql) {
            $sql | docker exec -i supabase-db psql -U postgres -d postgres
        }
    }
    
    "6" {
        Write-Host "进入交互式 SQL 模式..." -ForegroundColor Green
        Write-Host "提示: 输入 \q 退出" -ForegroundColor Yellow
        Write-Host ""
        docker exec -it supabase-db psql -U postgres -d postgres
    }
    
    default {
        Write-Host "无效选择" -ForegroundColor Red
    }
}

Write-Host ""
pause


