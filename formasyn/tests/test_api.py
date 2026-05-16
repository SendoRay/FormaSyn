#!/usr/bin/env python3
"""测试 API 连接和可用性。"""

import os

import httpx
import json

# 从环境变量读取配置
API_KEY = os.environ.get("FORMASYN_API_KEY", "")
BASE_URL = os.environ.get("FORMASYN_BASE_URL", "https://api.tryallai.com")
MODEL = os.environ.get("FORMASYN_MODEL", "gpt-5-codex-high")


def test_api_raw_http():
    """使用原始 HTTP 测试 API"""
    print("=" * 60)
    print("FormaSyn API 连接测试 (Raw HTTP)")
    print("=" * 60)
    print(f"\n配置信息:")
    print(f"  Base URL: {BASE_URL}")
    print(f"  Model: {MODEL}")
    print(f"  API Key: {API_KEY[:20]}...")
    
    # 准备请求
    url = f"{BASE_URL}/v1/chat/completions"
    headers = {
        "Authorization": f"Bearer {API_KEY}",
        "Content-Type": "application/json",
    }
    data = {
        "model": MODEL,
        "messages": [
            {"role": "system", "content": "You are a helpful assistant."},
            {"role": "user", "content": "Hello, respond with 'API test successful' only."}
        ],
        "temperature": 0.0,
        "max_tokens": 50,
    }
    
    print(f"\n1. 发送 POST 请求到 {url}...")
    
    try:
        response = httpx.post(
            url,
            headers=headers,
            json=data,
            timeout=30.0,
        )
        
        print(f"   状态码: {response.status_code}")
        print(f"   响应头: {dict(response.headers)}")
        
        # 尝试解析 JSON
        try:
            result = response.json()
            print(f"\n2. 响应体 (JSON):")
            print(json.dumps(result, indent=2, ensure_ascii=False))
            
            # 检查错误
            if "error" in result:
                error = result["error"]
                print("\n" + "=" * 60)
                print("⚠️  API 返回错误")
                print("=" * 60)
                print(f"错误消息: {error.get('message', 'Unknown')}")
                print(f"错误类型: {error.get('type', 'Unknown')}")
                
                if "credit" in str(error).lower() or "balance" in str(error).lower():
                    print("\n💳 账户余额不足！")
                    print("\n解决方案:")
                    print("  1. 访问 https://api.tryallai.com 充值")
                    print("  2. 联系管理员购买 credits")
                    print("  3. 使用 --baseline 模式运行 (无需 API)")
                return False
            
            # 检查正常响应
            if "choices" in result:
                content = result["choices"][0]["message"]["content"]
                print("\n" + "=" * 60)
                print("✅ API 连接成功！")
                print("=" * 60)
                print(f"模型响应: {content}")
                if "usage" in result:
                    usage = result["usage"]
                    print(f"\nToken 使用:")
                    print(f"  Prompt: {usage.get('prompt_tokens', 'N/A')}")
                    print(f"  Completion: {usage.get('completion_tokens', 'N/A')}")
                    print(f"  Total: {usage.get('total_tokens', 'N/A')}")
                return True
                
        except json.JSONDecodeError:
            print(f"\n2. 响应体 (原始文本):")
            print(response.text[:2000])
            return False
            
    except httpx.TimeoutException:
        print("   ✗ 请求超时")
        return False
    except httpx.ConnectError as e:
        print(f"   ✗ 连接错误: {e}")
        return False
    except Exception as e:
        print(f"   ✗ 请求失败: {e}")
        return False


def test_models_endpoint():
    """测试 models 端点"""
    print("\n" + "=" * 60)
    print("测试 Models 端点")
    print("=" * 60)
    
    url = f"{BASE_URL}/v1/models"
    headers = {"Authorization": f"Bearer {API_KEY}"}
    
    try:
        response = httpx.get(url, headers=headers, timeout=10.0)
        print(f"状态码: {response.status_code}")
        
        try:
            result = response.json()
            if "data" in result:
                models = result["data"]
                print(f"\n可用模型 ({len(models)} 个):")
                for m in models[:10]:
                    print(f"  - {m.get('id', 'unknown')}")
                if len(models) > 10:
                    print(f"  ... 还有 {len(models)-10} 个")
                    
                # 检查目标模型
                model_ids = [m.get('id') for m in models]
                if MODEL in model_ids:
                    print(f"\n✓ 目标模型 '{MODEL}' 可用")
                else:
                    print(f"\n⚠️ 目标模型 '{MODEL}' 不在列表中")
                    print("   建议检查模型名称是否正确")
            else:
                print(f"响应: {json.dumps(result, indent=2)[:500]}")
        except:
            print(f"响应: {response.text[:500]}")
            
    except Exception as e:
        print(f"请求失败: {e}")


def main():
    """主函数"""
    print("\n🔧 FormaSyn API 诊断工具\n")
    
    # 基本连接测试
    success = test_api_raw_http()
    
    # 测试 models 端点
    test_models_endpoint()
    
    # 总结
    print("\n" + "=" * 60)
    print("总结")
    print("=" * 60)
    if success:
        print("\n✅ API 连接正常，可以使用 LLM DSE 功能")
        print("\n运行命令:")
        print("  python run.py fir_16tap")
    else:
        print("\n❌ API 连接失败")
        print("\n💡 使用 baseline 模式 (无需 API):")
        print("     python run.py fir_16tap --baseline")
        print("\n这将使用最小可行配置运行，跳过 LLM 设计空间探索")
    print()


if __name__ == "__main__":
    main()
