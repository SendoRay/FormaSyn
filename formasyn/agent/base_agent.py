"""Shared base class for FormaSyn LLM agents."""

from __future__ import annotations

import json
import os
from dataclasses import dataclass
from pathlib import Path
from typing import Any

import httpx
import yaml
from openai import OpenAI

# 环境变量名称常量
ENV_API_KEY = "FORMASYN_API_KEY"
ENV_BASE_URL = "FORMASYN_BASE_URL"
ENV_MODEL = "FORMASYN_MODEL"


def _load_dotenv() -> None:
    """手动解析项目根目录的 .env 文件（无需 python-dotenv 依赖）。"""
    dotenv_path = Path(__file__).resolve().parents[2] / ".env"
    if not dotenv_path.exists():
        return
    try:
        with open(dotenv_path) as f:
            for line in f:
                line = line.strip()
                if not line or line.startswith("#") or "=" not in line:
                    continue
                key, _, value = line.partition("=")
                key = key.strip()
                value = value.strip().strip("\"'")
                if key not in os.environ:  # 环境变量优先级高于 .env
                    os.environ[key] = value
    except Exception:
        pass


def _load_api_config() -> tuple[str, str, str]:
    """加载 API 配置：环境变量 > .env 文件 > config.yaml。

    环境变量名：
      - FORMASYN_API_KEY
      - FORMASYN_BASE_URL  （例如 https://api.tryallai.com，无需 /v1 后缀）
      - FORMASYN_MODEL      （例如 gpt-5-codex-high）

    返回 (api_key, base_url, model)，未配置时为空字符串。
    实际使用时的验证延迟到 BaseAgent 初始化时。
    """
    # 首次调用时尝试加载 .env
    _load_dotenv()

    api_key = os.environ.get(ENV_API_KEY, "")
    base_url = os.environ.get(ENV_BASE_URL, "")
    model = os.environ.get(ENV_MODEL, "")

    # 可选：从项目 config.yaml 读取覆盖（优先级最低）
    project_config_path = Path(__file__).resolve().parents[2] / "config.yaml"
    if project_config_path.exists():
        try:
            with open(project_config_path) as f:
                config = yaml.safe_load(f) or {}
            api_config = config.get("api", {})
            if not api_key and api_config.get("api_key"):
                api_key = api_config["api_key"]
            if not base_url and api_config.get("base_url"):
                base_url = api_config["base_url"]
            if not model and api_config.get("model"):
                model = api_config["model"]
        except Exception:
            pass

    # 确保 base_url 包含 /v1 后缀
    if base_url and not base_url.endswith("/v1"):
        base_url = base_url + "/v1"

    return api_key, base_url, model


def _validate_config() -> None:
    """验证 API 配置是否完整，不完整时抛出 RuntimeError。"""
    missing = []
    if not _LOADED_API_KEY:
        missing.append(ENV_API_KEY)
    if not _LOADED_BASE_URL:
        missing.append(ENV_BASE_URL)
    if not _LOADED_MODEL:
        missing.append(ENV_MODEL)
    if missing:
        raise RuntimeError(
            f"缺少 API 配置，请设置环境变量或创建 .env 文件: {', '.join(missing)}\n"
            f"参考 {Path(__file__).resolve().parents[2] / '.env.example'}"
        )


_LOADED_API_KEY, _LOADED_BASE_URL, _LOADED_MODEL = _load_api_config()


@dataclass(frozen=True)
class AgentConfig:
    """Common OpenAI-compatible API configuration."""

    model: str
    api_key: str = _LOADED_API_KEY
    base_url: str = _LOADED_BASE_URL


class BaseAgent:
    """Base class for OpenAI-compatible chat-completion agents."""

    def __init__(
        self,
        *,
        model: str | None = None,
        api_key: str | None = None,
        base_url: str | None = None,
    ) -> None:
        # 延迟验证：仅在实际实例化 Agent 时检查配置
        _validate_config()

        # 使用配置中的默认模型（如果未指定）
        if model is None:
            model = _LOADED_MODEL
        self._config = AgentConfig(
            model=model,
            api_key=api_key or _LOADED_API_KEY,
            base_url=base_url or _LOADED_BASE_URL,
        )
        # Avoid loading local proxy settings that may require extra deps.
        http_client = httpx.Client(trust_env=False)
        self._client = OpenAI(
            api_key=self._config.api_key,
            base_url=self._config.base_url,
            http_client=http_client,
        )

    @property
    def model(self) -> str:
        return self._config.model

    @property
    def base_url(self) -> str:
        return self._config.base_url

    def _chat_completion(
        self,
        *,
        system_prompt: str,
        user_prompt: str,
        temperature: float = 0.2,
        timeout: float = 30.0,
        response_format: dict | None = None,
    ) -> str:
        """Send a chat completion request and return assistant text."""
        kwargs = {
            "model": self.model,
            "temperature": temperature,
            "timeout": timeout,
            "messages": [
                {"role": "system", "content": system_prompt},
                {"role": "user", "content": user_prompt},
            ],
        }
        if response_format:
            kwargs["response_format"] = response_format
        response = self._client.chat.completions.create(**kwargs)
        message = response.choices[0].message.content
        return message or ""

