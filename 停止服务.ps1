# 停止所有服务

Write-Host "🛑 停止 Docker Supabase 服务..." -ForegroundColor Yellow

docker-compose down

Write-Host ""
Write-Host "✅ 所有服务已停止" -ForegroundColor Green
Write-Host ""
Write-Host "提示：" -ForegroundColor Cyan
Write-Host "- 数据已保存在 Docker volumes 中" -ForegroundColor White
Write-Host "- 下次启动时数据会保留" -ForegroundColor White
Write-Host "- 如需清除所有数据，请运行: docker-compose down -v" -ForegroundColor White
Write-Host ""

pause


