"""Claude Code backend — calls the claude CLI to use the authenticated session.

This backend is designed for environments where the Anthropic API key is only
available within the Claude Code session (e.g., proxy-based auth). It shells
out to `claude` CLI to perform completions.
"""

from __future__ import annotations

import json
import logging
import subprocess
import tempfile
from pathlib import Path

logger = logging.getLogger(__name__)

_CLI_TIMEOUT = 120  # seconds per call


class ClaudeCodeBackend:
    """LLMBackend that delegates to the `claude` CLI."""

    def __init__(self, model: str = "claude-sonnet-4-20250514"):
        self._model = model

    @property
    def model_id(self) -> str:
        return self._model

    def complete(
        self,
        messages: list[dict],
        temperature: float = 0.7,
        max_tokens: int = 4096,
    ) -> str:
        """Send a prompt via claude CLI and return the response."""
        # Build a single prompt from messages
        prompt = self._messages_to_prompt(messages)
        return self._call_cli(prompt)

    def complete_structured(
        self,
        messages: list[dict],
        schema: dict,
        temperature: float = 0.7,
    ) -> dict:
        """Get structured JSON output via claude CLI."""
        prompt = self._messages_to_prompt(messages)
        prompt += (
            "\n\nIMPORTANT: You MUST respond with ONLY valid JSON matching this schema, "
            "no other text:\n```json\n" + json.dumps(schema, indent=2) + "\n```"
        )

        response = self._call_cli(prompt)

        # Extract JSON from response
        return self._extract_json(response)

    def _messages_to_prompt(self, messages: list[dict]) -> str:
        """Convert message list to a single prompt string."""
        parts = []
        for msg in messages:
            role = msg.get("role", "user")
            content = msg.get("content", "")
            if role == "system":
                parts.append(f"[System instruction]: {content}")
            elif role == "user":
                parts.append(content)
            elif role == "assistant":
                parts.append(f"[Previous response]: {content}")
        return "\n\n".join(parts)

    def _call_cli(self, prompt: str) -> str:
        """Call claude CLI with a prompt."""
        # Write prompt to temp file to avoid shell escaping issues
        with tempfile.NamedTemporaryFile(
            mode="w", suffix=".txt", delete=False, prefix="formaflow_"
        ) as f:
            f.write(prompt)
            prompt_file = f.name

        try:
            result = subprocess.run(
                ["claude", "-p", f"$(cat {prompt_file})", "--no-input"],
                capture_output=True,
                text=True,
                timeout=_CLI_TIMEOUT,
                shell=True,
            )

            if result.returncode != 0:
                logger.error("claude CLI error: %s", result.stderr[:500])
                # Try alternative invocation
                result = subprocess.run(
                    f"cat '{prompt_file}' | claude -p --no-input",
                    capture_output=True,
                    text=True,
                    timeout=_CLI_TIMEOUT,
                    shell=True,
                )

            return result.stdout.strip()

        except subprocess.TimeoutExpired:
            logger.error("claude CLI timed out after %ds", _CLI_TIMEOUT)
            return ""
        except FileNotFoundError:
            logger.error("claude CLI not found on PATH")
            return ""
        finally:
            Path(prompt_file).unlink(missing_ok=True)

    def _extract_json(self, text: str) -> dict:
        """Extract JSON from a text response."""
        # Try direct parse
        try:
            return json.loads(text)
        except json.JSONDecodeError:
            pass

        # Try extracting from code fence
        import re
        match = re.search(r"```(?:json)?\s*\n(.*?)```", text, re.DOTALL)
        if match:
            try:
                return json.loads(match.group(1))
            except json.JSONDecodeError:
                pass

        # Try finding first { to last }
        start = text.find("{")
        end = text.rfind("}")
        if start >= 0 and end > start:
            try:
                return json.loads(text[start : end + 1])
            except json.JSONDecodeError:
                pass

        logger.error("Failed to extract JSON from response: %s...", text[:200])
        return {}
