"""DeepSeek LLM backend using the OpenAI-compatible SDK."""

from __future__ import annotations

import json
import logging
import os
import time

import openai

logger = logging.getLogger(__name__)

_DEEPSEEK_BASE_URL = "https://api.deepseek.com"


class DeepSeekBackend:
    """LLMBackend implementation for DeepSeek models (OpenAI-compatible API)."""

    def __init__(self, model: str = "deepseek-coder", api_key: str | None = None):
        self._model = model
        key = api_key or os.environ.get("DEEPSEEK_API_KEY")
        self._client = openai.OpenAI(api_key=key, base_url=_DEEPSEEK_BASE_URL)

    @property
    def model_id(self) -> str:
        return self._model

    def complete(
        self,
        messages: list[dict],
        temperature: float = 0.7,
        max_tokens: int = 4096,
    ) -> str:
        """Send messages via chat completions and return assistant text."""
        for attempt in range(3):
            try:
                logger.debug("DeepSeek complete call (attempt %d), model=%s", attempt + 1, self._model)
                response = self._client.chat.completions.create(
                    model=self._model,
                    messages=messages,
                    temperature=temperature,
                    max_tokens=max_tokens,
                )
                return response.choices[0].message.content
            except Exception as e:
                logger.warning("DeepSeek API error (attempt %d): %s", attempt + 1, e)
                if attempt == 2:
                    raise
                time.sleep(2 ** attempt)
        return ""  # unreachable

    def complete_structured(
        self,
        messages: list[dict],
        schema: dict,
        temperature: float = 0.7,
    ) -> dict:
        """Structured output via DeepSeek JSON mode.

        DeepSeek supports response_format={"type": "json_object"} but not the
        OpenAI-style json_schema, so we describe the schema in the prompt and
        request a raw JSON object.
        """
        schema_msg = {
            "role": "user",
            "content": (
                "Respond with ONLY a single JSON object (no markdown, no prose) "
                "that conforms to this JSON Schema:\n" + json.dumps(schema)
            ),
        }
        msgs = list(messages) + [schema_msg]
        for attempt in range(3):
            try:
                logger.debug("DeepSeek complete_structured call (attempt %d), model=%s", attempt + 1, self._model)
                response = self._client.chat.completions.create(
                    model=self._model,
                    messages=msgs,
                    temperature=temperature,
                    max_tokens=4096,
                    response_format={"type": "json_object"},
                )
                return json.loads(response.choices[0].message.content)
            except Exception as e:
                logger.warning("DeepSeek API error (attempt %d): %s", attempt + 1, e)
                if attempt == 2:
                    raise
                time.sleep(2 ** attempt)
        return {}  # unreachable
