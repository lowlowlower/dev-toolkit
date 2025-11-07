"""
Gemini API 客户端模块
用于调用 Google Gemini AI 进行文本分析
"""

import requests
import json
import time
from typing import Optional, Dict, Any


class GeminiClient:
    """Gemini API 客户端"""
    
    def __init__(self, api_key: str, model: str = "gemini-2.0-flash"):
        """
        初始化 Gemini 客户端
        
        Args:
            api_key: Gemini API 密钥
            model: 使用的模型名称
        """
        self.api_key = api_key
        self.model = model
        self.base_url = "https://generativelanguage.googleapis.com/v1beta/models"
        
    def generate_content(self, prompt: str, max_retries: int = 3) -> Optional[str]:
        """
        生成内容
        
        Args:
            prompt: 输入提示词
            max_retries: 最大重试次数
            
        Returns:
            生成的文本内容，失败返回 None
        """
        url = f"{self.base_url}/{self.model}:generateContent?key={self.api_key}"
        
        headers = {
            'Content-Type': 'application/json'
        }
        
        data = {
            "contents": [{
                "parts": [{"text": prompt}]
            }]
        }
        
        for attempt in range(max_retries):
            try:
                response = requests.post(url, headers=headers, json=data, timeout=60)
                
                if response.status_code == 200:
                    result = response.json()
                    
                    # 解析响应
                    if 'candidates' in result and len(result['candidates']) > 0:
                        candidate = result['candidates'][0]
                        if 'content' in candidate and 'parts' in candidate['content']:
                            parts = candidate['content']['parts']
                            if len(parts) > 0 and 'text' in parts[0]:
                                return parts[0]['text']
                    
                    print(f"⚠️ 响应格式异常: {result}")
                    return None
                    
                elif response.status_code == 429:
                    # 速率限制，等待后重试
                    wait_time = (attempt + 1) * 2
                    print(f"⚠️ 请求过于频繁，等待 {wait_time} 秒后重试...")
                    time.sleep(wait_time)
                    continue
                    
                else:
                    print(f"❌ API 请求失败: {response.status_code}")
                    print(f"响应内容: {response.text}")
                    return None
                    
            except requests.exceptions.Timeout:
                print(f"⚠️ 请求超时，第 {attempt + 1} 次重试...")
                time.sleep(2)
                
            except Exception as e:
                print(f"❌ 请求出错: {str(e)}")
                return None
        
        print("❌ 达到最大重试次数，请求失败")
        return None
    
    def analyze_messages(self, messages: str, analysis_type: str = "daily_summary") -> Optional[str]:
        """
        分析微信消息
        
        Args:
            messages: 要分析的消息文本
            analysis_type: 分析类型
            
        Returns:
            分析结果文本
        """
        prompts = {
            "daily_summary": f"""请分析以下微信聊天记录，生成一份详细的日报。

要求：
1. **重要信息摘要**：提取关键信息和重要对话
2. **待办事项**：识别所有待办事项和任务
3. **情感分析**：分析整体情感趋势
4. **关键联系人**：统计主要沟通对象
5. **建议**：给出后续行动建议

聊天记录：
{messages}

请用中文回复，格式清晰，使用 Markdown 格式。""",
            
            "sentiment": f"""请对以下微信聊天记录进行情感分析：

{messages}

分析维度：
1. 整体情感倾向（积极/中性/消极）
2. 情感强度
3. 主要情绪类型
4. 情感变化趋势

请用中文回复。""",

            "todo_extract": f"""请从以下微信聊天记录中提取所有待办事项：

{messages}

要求：
1. 识别明确的任务和待办
2. 提取截止时间（如有）
3. 标注优先级
4. 列出负责人

请用中文回复，清单格式。"""
        }
        
        prompt = prompts.get(analysis_type, prompts["daily_summary"])
        return self.generate_content(prompt)
    
    def test_connection(self) -> bool:
        """
        测试 API 连接
        
        Returns:
            连接成功返回 True
        """
        result = self.generate_content("Hello, how are you?")
        return result is not None


def test_gemini_api():
    """测试 Gemini API"""
    print("🧪 测试 Gemini API 连接...")
    
    # 读取配置
    try:
        with open('config.json', 'r', encoding='utf-8') as f:
            config = json.load(f)
    except FileNotFoundError:
        print("❌ 配置文件不存在，请先复制 config.example.json 为 config.json")
        return
    
    api_key = config.get('gemini_api_key')
    if not api_key or api_key == "your_api_key_here":
        print("❌ 请在 config.json 中配置正确的 API Key")
        return
    
    client = GeminiClient(api_key)
    
    # 测试简单请求
    print("\n📝 测试 1: 简单问答...")
    result = client.generate_content("用一句话介绍一下人工智能")
    if result:
        print(f"✅ 成功！回复: {result[:100]}...")
    else:
        print("❌ 测试失败")
        return
    
    # 测试消息分析
    print("\n📝 测试 2: 消息分析...")
    test_messages = """
    张三 [10:30]: 今天下午3点开会，记得准备PPT
    李四 [10:35]: 好的，我准备一下
    王五 [11:20]: 午饭一起吗？
    张三 [11:22]: 好啊，楼下见
    """
    
    analysis = client.analyze_messages(test_messages, "daily_summary")
    if analysis:
        print(f"✅ 分析成功！\n{analysis}")
    else:
        print("❌ 分析失败")


if __name__ == "__main__":
    test_gemini_api()

