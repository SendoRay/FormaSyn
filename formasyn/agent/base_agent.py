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

# 项目 API 配置（硬编码）
API_KEY = "sk-kxzxgaFXQRfi14ZNDJ2YhzSqmcBQiQBYSPjXkiFKEZocfpU3"
BASE_URL = "https://api.tryallai.com"
MODEL = "gpt-5-codex-high"


def _load_api_config() -> tuple[str, str, str]:
    """加载 API 配置：优先项目 config.yaml > 硬编码默认值."""
    api_key = API_KEY
    base_url = BASE_URL
    model = MODEL

    # 可选：从项目 config.yaml 读取覆盖
    project_config_path = Path(__file__).resolve().parents[2] / "config.yaml"
    if project_config_path.exists():
        try:
            with open(project_config_path) as f:
                config = yaml.safe_load(f) or {}
            api_config = config.get("api", {})
            if api_config.get("api_key"):
                api_key = api_config["api_key"]
            if api_config.get("base_url"):
                base_url = api_config["base_url"]
            if api_config.get("model"):
                model = api_config["model"]
        except Exception:
            pass

    # 确保 base_url 包含 /v1 后缀
    if base_url and not base_url.endswith("/v1"):
        base_url = base_url + "/v1"

    return api_key, base_url, model


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

