"""Algebraic rewrite rules with provable quality bounds.

This module implements Direction A: formal approximation guarantees for
communication algorithm FPGA implementations.
"""

from .rules import RewriteRule, QualityBound, ResourceDelta, RewriteCatalog
from .engine import RewriteEngine

__all__ = [
    "RewriteRule",
    "QualityBound",
    "ResourceDelta",
    "RewriteCatalog",
    "RewriteEngine",
]
