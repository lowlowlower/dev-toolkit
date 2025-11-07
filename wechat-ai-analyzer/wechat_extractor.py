"""
微信消息提取模块
从微信本地数据库中提取聊天记录
"""

import os
import sys
import sqlite3
import json
from datetime import datetime, timedelta
from pathlib import Path
from typing import List, Dict, Optional, Tuple
import subprocess


class WeChatExtractor:
    """微信消息提取器"""
    
    def __init__(self, data_path: Optional[str] = None):
        """
        初始化提取器
        
        Args:
            data_path: 微信数据路径，如果为 None 则自动检测
        """
        self.data_path = data_path or self._find_wechat_data_path()
        self.db_key = None
        
    def _find_wechat_data_path(self) -> Optional[str]:
        """
        自动查找微信数据路径
        
        Returns:
            微信数据路径，找不到返回 None
        """
        # Windows 常见路径
        possible_paths = [
            os.path.join(os.environ.get('USERPROFILE', ''), 'Documents', 'WeChat Files'),
            os.path.join(os.environ.get('APPDATA', ''), 'Tencent', 'WeChat'),
            'C:\\Users\\Public\\Documents\\WeChat Files',
        ]
        
        for path in possible_paths:
            if os.path.exists(path):
                print(f"✅ 找到微信数据路径: {path}")
                return path
        
        print("❌ 未找到微信数据路径，请手动指定")
        return None
    
    def find_db_files(self) -> List[str]:
        """
        查找所有微信数据库文件
        
        Returns:
            数据库文件路径列表
        """
        if not self.data_path:
            return []
        
        db_files = []
        
        # 遍历查找 .db 文件
        for root, dirs, files in os.walk(self.data_path):
            for file in files:
                if file.endswith('.db') and 'MSG' in file.upper():
                    db_path = os.path.join(root, file)
                    db_files.append(db_path)
        
        print(f"📁 找到 {len(db_files)} 个数据库文件")
        return db_files
    
    def extract_messages_simple(self, hours: int = 24) -> List[Dict]:
        """
        简单方法：直接读取数据库（适用于未加密或已知密钥的情况）
        
        Args:
            hours: 提取最近多少小时的消息
            
        Returns:
            消息列表
        """
        messages = []
        db_files = self.find_db_files()
        
        if not db_files:
            print("❌ 未找到数据库文件")
            return messages
        
        # 计算时间戳
        start_time = datetime.now() - timedelta(hours=hours)
        timestamp = int(start_time.timestamp())
        
        for db_file in db_files:
            try:
                # 尝试直接连接（某些情况下数据库未加密）
                conn = sqlite3.connect(db_file)
                cursor = conn.cursor()
                
                # 查询消息表
                query = """
                    SELECT 
                        localId,
                        TalkerId,
                        Type,
                        SubType,
                        IsSender,
                        CreateTime,
                        Message,
                        StrContent,
                        StrTime
                    FROM MSG
                    WHERE CreateTime > ?
                    ORDER BY CreateTime DESC
                """
                
                cursor.execute(query, (timestamp,))
                rows = cursor.fetchall()
                
                for row in rows:
                    msg = {
                        'id': row[0],
                        'talker': row[1],
                        'type': row[2],
                        'is_sender': row[4],
                        'time': datetime.fromtimestamp(row[5]).strftime('%Y-%m-%d %H:%M:%S'),
                        'content': row[7] or row[6] or ''
                    }
                    messages.append(msg)
                
                conn.close()
                print(f"✅ 从 {os.path.basename(db_file)} 提取了 {len(rows)} 条消息")
                
            except sqlite3.DatabaseError as e:
                # 数据库加密，需要使用 pywxdump
                print(f"⚠️ {os.path.basename(db_file)} 已加密，需要使用高级方法解密")
                continue
            except Exception as e:
                print(f"⚠️ 处理 {os.path.basename(db_file)} 时出错: {str(e)}")
                continue
        
        return messages
    
    def extract_messages_with_pywxdump(self, hours: int = 24) -> List[Dict]:
        """
        使用 pywxdump 提取消息（推荐方法）
        
        Args:
            hours: 提取最近多少小时的消息
            
        Returns:
            消息列表
        """
        try:
            from pywxdump import get_wechat_db, read_info
            
            print("📱 正在使用 pywxdump 提取微信消息...")
            
            # 获取微信信息
            wx_info = read_info.get_wechat_info()
            if not wx_info:
                print("❌ 无法获取微信信息，请确保微信已登录")
                return []
            
            print(f"✅ 检测到微信账号: {wx_info.get('wxid', 'unknown')}")
            
            # 获取数据库路径和密钥
            db_path = wx_info.get('db_path')
            db_key = wx_info.get('key')
            
            if not db_path or not db_key:
                print("❌ 无法获取数据库路径或密钥")
                return []
            
            # 读取消息
            messages = self._read_messages_from_db(db_path, db_key, hours)
            return messages
            
        except ImportError:
            print("❌ 未安装 pywxdump，请运行: pip install pywxdump")
            return []
        except Exception as e:
            print(f"❌ 提取消息失败: {str(e)}")
            return []
    
    def _read_messages_from_db(self, db_path: str, key: str, hours: int) -> List[Dict]:
        """从解密的数据库读取消息"""
        messages = []
        
        # TODO: 实现数据库读取逻辑
        # 这里需要根据实际的数据库结构来读取
        
        return messages
    
    def format_messages_for_ai(self, messages: List[Dict]) -> str:
        """
        格式化消息以供 AI 分析
        
        Args:
            messages: 消息列表
            
        Returns:
            格式化的文本
        """
        if not messages:
            return "没有消息记录"
        
        formatted = []
        formatted.append(f"# 微信聊天记录 ({len(messages)} 条消息)\n")
        formatted.append(f"时间范围: {messages[-1]['time']} 至 {messages[0]['time']}\n")
        formatted.append("=" * 50 + "\n")
        
        # 按时间分组
        current_date = None
        for msg in reversed(messages):
            msg_date = msg['time'].split()[0]
            
            if msg_date != current_date:
                current_date = msg_date
                formatted.append(f"\n## {msg_date}\n")
            
            sender = "我" if msg['is_sender'] else msg['talker']
            time_str = msg['time'].split()[1]
            content = msg['content']
            
            # 过滤掉系统消息和空消息
            if content and msg['type'] == 1:  # 文本消息
                formatted.append(f"[{time_str}] {sender}: {content}\n")
        
        return "".join(formatted)
    
    def save_messages(self, messages: List[Dict], output_file: str):
        """
        保存消息到文件
        
        Args:
            messages: 消息列表
            output_file: 输出文件路径
        """
        output_path = Path(output_file)
        output_path.parent.mkdir(parents=True, exist_ok=True)
        
        # 保存为 JSON
        if output_file.endswith('.json'):
            with open(output_file, 'w', encoding='utf-8') as f:
                json.dump(messages, f, ensure_ascii=False, indent=2)
        
        # 保存为文本
        else:
            formatted_text = self.format_messages_for_ai(messages)
            with open(output_file, 'w', encoding='utf-8') as f:
                f.write(formatted_text)
        
        print(f"💾 消息已保存到: {output_file}")


def test_extractor():
    """测试提取器"""
    print("🧪 测试微信消息提取器...\n")
    
    extractor = WeChatExtractor()
    
    if not extractor.data_path:
        print("❌ 未找到微信数据路径")
        print("\n💡 请手动指定路径:")
        print("   extractor = WeChatExtractor(data_path='你的微信数据路径')")
        return
    
    # 方法1: 简单提取（尝试直接读取）
    print("\n📝 方法1: 尝试简单提取...")
    messages = extractor.extract_messages_simple(hours=24)
    
    if messages:
        print(f"✅ 提取了 {len(messages)} 条消息")
        
        # 保存示例
        extractor.save_messages(messages, 'test_output.txt')
        
        # 格式化预览
        formatted = extractor.format_messages_for_ai(messages[:10])
        print("\n📄 消息预览 (前10条):")
        print(formatted[:500])
    else:
        print("⚠️ 简单方法未能提取消息，尝试高级方法...")
        
        # 方法2: 使用 pywxdump
        messages = extractor.extract_messages_with_pywxdump(hours=24)
        
        if messages:
            print(f"✅ 提取了 {len(messages)} 条消息")
        else:
            print("\n❌ 提取失败")
            print("\n💡 解决方案:")
            print("1. 确保微信已登录")
            print("2. 安装 pywxdump: pip install pywxdump")
            print("3. 或使用第三方工具如 WeChatMsg (github.com/LC044/WeChatMsg)")


if __name__ == "__main__":
    test_extractor()

