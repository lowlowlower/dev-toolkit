"""
定时任务脚本
每天自动运行微信消息分析
"""

import schedule
import time
import json
from datetime import datetime
from main import WeChatAIAnalyzer


def run_daily_task():
    """每日任务"""
    print(f"\n{'=' * 60}")
    print(f"🕐 定时任务触发: {datetime.now().strftime('%Y-%m-%d %H:%M:%S')}")
    print(f"{'=' * 60}\n")
    
    try:
        analyzer = WeChatAIAnalyzer()
        analyzer.run_daily_analysis()
    except Exception as e:
        print(f"❌ 任务执行失败: {str(e)}")


def main():
    """主函数"""
    # 读取配置
    try:
        with open('config.json', 'r', encoding='utf-8') as f:
            config = json.load(f)
    except FileNotFoundError:
        print("❌ 配置文件不存在")
        return
    
    # 设置定时任务
    schedule_time = config.get('schedule_time', '09:00')  # 默认每天9点
    schedule.every().day.at(schedule_time).do(run_daily_task)
    
    print("⏰ 微信消息 AI 分析 - 定时任务已启动")
    print(f"📅 执行时间: 每天 {schedule_time}")
    print(f"🔄 当前时间: {datetime.now().strftime('%Y-%m-%d %H:%M:%S')}")
    print("\n按 Ctrl+C 停止\n")
    
    # 运行一次测试
    print("🧪 执行一次测试任务...")
    run_daily_task()
    
    # 持续运行
    try:
        while True:
            schedule.run_pending()
            time.sleep(60)  # 每分钟检查一次
    except KeyboardInterrupt:
        print("\n⚠️ 定时任务已停止")


if __name__ == "__main__":
    main()

