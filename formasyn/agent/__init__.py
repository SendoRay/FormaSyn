"""FormaSyn Agent 模块.

包含：
- DSEAgent: 设计空间探索，生成变体意图
- AgentDiagnostic: 智能诊断与回退决策
"""

from .base_agent import BaseAgent
from .diagnostic import (
    AgentDiagnostic,
    DiagnosticResult,
    RecoveryAction,
    RecoveryLayer,
)
from .dse_agent import DSEAgent, IntentJSON, QuantSpec

__all__ = [
    "BaseAgent",
    "AgentDiagnostic",
    "DiagnosticResult",
    "RecoveryAction",
    "RecoveryLayer",
    "DSEAgent",
    "IntentJSON",
    "QuantSpec",
]
