"""
微信消息 AI 分析主程序
每日自动提取微信消息并使用 Gemini AI 进行分析
"""

import os
import sys
import json
import argparse
from datetime import datetime
from pathlib import Path

from gemini_client import GeminiClient
from wechat_extractor import WeChatExtractor


class WeChatAIAnalyzer:
    """微信消息AI分析器"""
    
    def __init__(self, config_path: str = 'config.json'):
        """
        初始化分析器
        
        Args:
            config_path: 配置文件路径
        """
        self.config = self._load_config(config_path)
        self.gemini = GeminiClient(self.config['gemini_api_key'])
        self.extractor = WeChatExtractor(self.config.get('wechat_data_path'))
        self.output_dir = Path(self.config.get('output_dir', './reports'))
        self.output_dir.mkdir(parents=True, exist_ok=True)
    
    def _load_config(self, config_path: str) -> dict:
        """加载配置文件"""
        if not os.path.exists(config_path):
            print(f"❌ 配置文件不存在: {config_path}")
            print("💡 请复制 config.example.json 为 config.json 并配置")
            sys.exit(1)
        
        with open(config_path, 'r', encoding='utf-8') as f:
            config = json.load(f)
        
        # 验证必需配置
        if not config.get('gemini_api_key') or config['gemini_api_key'] == 'your_api_key_here':
            print("❌ 请在配置文件中设置正确的 Gemini API Key")
            sys.exit(1)
        
        return config
    
    def run_daily_analysis(self, hours: int = None):
        """
        运行每日分析
        
        Args:
            hours: 分析最近多少小时的消息，默认从配置读取
        """
        print("=" * 60)
        print("🚀 微信消息 AI 分析器")
        print("=" * 60)
        print(f"⏰ 开始时间: {datetime.now().strftime('%Y-%m-%d %H:%M:%S')}\n")
        
        # 1. 提取微信消息
        print("📱 步骤 1/4: 提取微信消息...")
        hours = hours or self.config.get('analyze_last_hours', 24)
        
        # 先尝试简单方法
        messages = self.extractor.extract_messages_simple(hours=hours)
        
        # 如果失败，尝试高级方法
        if not messages:
            print("   尝试使用 pywxdump...")
            messages = self.extractor.extract_messages_with_pywxdump(hours=hours)
        
        if not messages:
            print("❌ 未能提取到消息")
            print("\n💡 可能的原因:")
            print("   1. 微信未登录")
            print("   2. 数据库已加密，需要安装 pywxdump")
            print("   3. 微信数据路径不正确")
            print("\n建议:")
            print("   - 使用第三方工具: WeChatMsg (github.com/LC044/WeChatMsg)")
            print("   - 或手动导出消息为 txt 文件，使用 --file 参数")
            return
        
        print(f"✅ 成功提取 {len(messages)} 条消息\n")
        
        # 2. 格式化消息
        print("📝 步骤 2/4: 格式化消息...")
        formatted_messages = self.extractor.format_messages_for_ai(messages)
        
        # 保存原始消息
        timestamp = datetime.now().strftime('%Y%m%d_%H%M%S')
        raw_file = self.output_dir / f"messages_{timestamp}.txt"
        self.extractor.save_messages(messages, str(raw_file))
        print(f"✅ 原始消息已保存: {raw_file}\n")
        
        # 3. AI 分析
        print("🤖 步骤 3/4: AI 分析中...")
        print("   (这可能需要几秒钟...)")
        
        analysis_result = self.gemini.analyze_messages(
            formatted_messages,
            analysis_type='daily_summary'
        )
        
        if not analysis_result:
            print("❌ AI 分析失败")
            return
        
        print("✅ AI 分析完成\n")
        
        # 4. 保存分析报告
        print("💾 步骤 4/4: 保存分析报告...")
        report_file = self.output_dir / f"report_{timestamp}.md"
        
        report_content = f"""# 微信消息分析报告

**生成时间**: {datetime.now().strftime('%Y-%m-%d %H:%M:%S')}  
**分析时段**: 最近 {hours} 小时  
**消息数量**: {len(messages)} 条

---

{analysis_result}

---

**原始数据**: {raw_file.name}
"""
        
        with open(report_file, 'w', encoding='utf-8') as f:
            f.write(report_content)
        
        print(f"✅ 分析报告已保存: {report_file}\n")
        
        # 5. 显示报告摘要
        print("=" * 60)
        print("📊 分析报告摘要")
        print("=" * 60)
        print(analysis_result[:500])
        if len(analysis_result) > 500:
            print(f"\n... (更多内容请查看完整报告)")
        
        print("\n" + "=" * 60)
        print("✅ 分析完成！")
        print("=" * 60)
    
    def analyze_from_file(self, file_path: str):
        """
        从文件分析消息
        
        Args:
            file_path: 消息文件路径
        """
        print(f"📂 从文件读取消息: {file_path}")
        
        with open(file_path, 'r', encoding='utf-8') as f:
            messages = f.read()
        
        print(f"✅ 读取成功，共 {len(messages)} 字符\n")
        
        print("🤖 AI 分析中...")
        analysis_result = self.gemini.analyze_messages(messages, 'daily_summary')
        
        if analysis_result:
            print("\n" + "=" * 60)
            print(analysis_result)
            print("=" * 60)
            
            # 保存报告
            timestamp = datetime.now().strftime('%Y%m%d_%H%M%S')
            report_file = self.output_dir / f"report_from_file_{timestamp}.md"
            
            with open(report_file, 'w', encoding='utf-8') as f:
                f.write(f"# 消息分析报告\n\n{analysis_result}")
            
            print(f"\n💾 报告已保存: {report_file}")
        else:
            print("❌ 分析失败")


def main():
    """主函数"""
    parser = argparse.ArgumentParser(
        description='微信消息 AI 分析工具',
        formatter_class=argparse.RawDescriptionHelpFormatter,
        epilog="""
示例:
  # 分析最近24小时的微信消息
  python main.py
  
  # 分析最近48小时的消息
  python main.py --hours 48
  
  # 从文件分析
  python main.py --file messages.txt
  
  # 使用自定义配置文件
  python main.py --config my_config.json
        """
    )
    
    parser.add_argument(
        '--hours',
        type=int,
        help='分析最近多少小时的消息 (默认: 24)'
    )
    
    parser.add_argument(
        '--file',
        type=str,
        help='从文件读取消息进行分析'
    )
    
    parser.add_argument(
        '--config',
        type=str,
        default='config.json',
        help='配置文件路径 (默认: config.json)'
    )
    
    parser.add_argument(
        '--test',
        action='store_true',
        help='测试 Gemini API 连接'
    )
    
    args = parser.parse_args()
    
    try:
        analyzer = WeChatAIAnalyzer(config_path=args.config)
        
        if args.test:
            print("🧪 测试 Gemini API 连接...")
            if analyzer.gemini.test_connection():
                print("✅ API 连接正常！")
            else:
                print("❌ API 连接失败")
            return
        
        if args.file:
            analyzer.analyze_from_file(args.file)
        else:
            analyzer.run_daily_analysis(hours=args.hours)
    
    except KeyboardInterrupt:
        print("\n\n⚠️ 用户中断")
    except Exception as e:
        print(f"\n❌ 发生错误: {str(e)}")
        import traceback
        traceback.print_exc()


if __name__ == "__main__":
    main()

