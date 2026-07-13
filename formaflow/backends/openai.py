"""OpenAI LLM backend using the OpenAI SDK."""

from __future__ import annotations

import json
import logging
import os
import time

import openai

logger = logging.getLogger(__name__)


class OpenAIBackend:
    """LLMBackend implementation for OpenAI models."""

    def __init__(self, model: str = "gpt-4o", api_key: str | None = None):
        self._model = model
        key = api_key or os.environ.get("OPENAI_API_KEY")
        self._client = openai.OpenAI(api_key=key)

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
                logger.debug("OpenAI complete call (attempt %d), model=%s", attempt + 1, self._model)
                response = self._client.chat.completions.create(
                    model=self._model,
                    messages=messages,
                    temperature=temperature,
                    max_tokens=max_tokens,
                )
                return response.choices[0].message.content
            except Exception as e:
                logger.warning("OpenAI API error (attempt %d): %s", attempt + 1, e)
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
        """Use json_schema response format for structured output."""
        for attempt in range(3):
            try:
                logger.debug("OpenAI complete_structured call (attempt %d), model=%s", attempt + 1, self._model)
                response = self._client.chat.completions.create(
                    model=self._model,
                    messages=messages,
                    temperature=temperature,
                    max_tokens=4096,
                    response_format={
                        "type": "json_schema",
                        "json_schema": {
                            "name": "structured_output",
                            "strict": True,
                            "schema": schema,
                        },
                    },
                )
                return json.loads(response.choices[0].message.content)
            except Exception as e:
                logger.warning("OpenAI API error (attempt %d): %s", attempt + 1, e)
                if attempt == 2:
                    raise
                time.sleep(2 ** attempt)
        return {}  # unreachable
