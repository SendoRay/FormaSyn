"""Claude LLM backend using the Anthropic SDK."""

from __future__ import annotations

import json
import logging
import os
import time

import anthropic

logger = logging.getLogger(__name__)


class ClaudeBackend:
    """LLMBackend implementation for Anthropic Claude models."""

    def __init__(self, model: str = "claude-sonnet-4-20250514", api_key: str | None = None):
        self._model = model
        key = api_key or os.environ.get("ANTHROPIC_API_KEY")
        self._client = anthropic.Anthropic(api_key=key)

    @property
    def model_id(self) -> str:
        return self._model

    def complete(
        self,
        messages: list[dict],
        temperature: float = 0.7,
        max_tokens: int = 4096,
    ) -> str:
        """Send messages to Claude and return assistant text."""
        for attempt in range(3):
            try:
                logger.debug("Claude complete call (attempt %d), model=%s", attempt + 1, self._model)
                response = self._client.messages.create(
                    model=self._model,
                    messages=messages,
                    temperature=temperature,
                    max_tokens=max_tokens,
                )
                return response.content[0].text
            except Exception as e:
                logger.warning("Claude API error (attempt %d): %s", attempt + 1, e)
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
        """Use tool_use to get structured JSON output matching the schema."""
        tool = {
            "name": "structured_output",
            "description": "Return structured data matching the required schema.",
            "input_schema": schema,
        }

        for attempt in range(3):
            try:
                logger.debug("Claude complete_structured call (attempt %d), model=%s", attempt + 1, self._model)
                response = self._client.messages.create(
                    model=self._model,
                    messages=messages,
                    temperature=temperature,
                    max_tokens=4096,
                    tools=[tool],
                    tool_choice={"type": "tool", "name": "structured_output"},
                )
                # Extract the tool use block
                for block in response.content:
                    if block.type == "tool_use":
                        return block.input
                raise ValueError("No tool_use block in response")
            except Exception as e:
                logger.warning("Claude API error (attempt %d): %s", attempt + 1, e)
                if attempt == 2:
                    raise
                time.sleep(2 ** attempt)
        return {}  # unreachable
