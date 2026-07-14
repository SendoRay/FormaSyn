"""LLM backend adapters."""

from .claude import ClaudeBackend
from .claude_code import ClaudeCodeBackend
from .openai import OpenAIBackend
from .deepseek import DeepSeekBackend

_DEFAULT_MODELS = {
    "deepseek": "deepseek-chat",
    "openai": "gpt-4o",
    "claude": "claude-sonnet-4-20250514",
}


def make_backend(name: str, model: str | None = None):
    """Instantiate the requested LLM backend by name."""
    if name == "claude_code":
        return ClaudeCodeBackend()
    if name == "deepseek":
        return DeepSeekBackend(model=model or _DEFAULT_MODELS["deepseek"])
    if name == "openai":
        return OpenAIBackend(model=model or _DEFAULT_MODELS["openai"])
    if name == "claude":
        return ClaudeBackend(model=model or _DEFAULT_MODELS["claude"])
    raise ValueError(f"unknown backend: {name}")


__all__ = [
    "ClaudeBackend",
    "ClaudeCodeBackend",
    "OpenAIBackend",
    "DeepSeekBackend",
    "make_backend",
]

