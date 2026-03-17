"""Shared base class for FormaSyn LLM agents."""

from __future__ import annotations

from dataclasses import dataclass
from typing import Any

import httpx
from openai import OpenAI

DEFAULT_API_KEY = "sk-fgiM17i17hA5lYtIhuPf9MGMkEN27dJA4SVE2CsXWxtNovU4"
DEFAULT_BASE_URL = "https://api.tryallai.com/v1"


@dataclass(frozen=True)
class AgentConfig:
    """Common OpenAI-compatible API configuration."""

    model: str
    api_key: str = DEFAULT_API_KEY
    base_url: str = DEFAULT_BASE_URL


class BaseAgent:
    """Base class for OpenAI-compatible chat-completion agents."""

    def __init__(
        self,
        *,
        model: str,
        api_key: str = DEFAULT_API_KEY,
        base_url: str = DEFAULT_BASE_URL,
    ) -> None:
        self._config = AgentConfig(
            model=model,
            api_key=api_key,
            base_url=base_url,
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
    ) -> str:
        """Send a chat completion request and return assistant text."""
        response = self._client.chat.completions.create(
            model=self.model,
            temperature=temperature,
            messages=[
                {"role": "system", "content": system_prompt},
                {"role": "user", "content": user_prompt},
            ],
        )
        message = response.choices[0].message.content
        return message or ""

