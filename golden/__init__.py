"""Golden Model generation and quantisation analysis for FormaSyn.

Provides:
- ``GoldenModelGenerator``: Math Dialect -> float64 serial C++ reference model.
- ``QuantizationAnalyzer``: Runs golden model multiple times to recommend
  fixed-point bit-widths per node.
"""

from FormaSyn.golden.generator import GoldenCompileError, GoldenModelGenerator
from FormaSyn.golden.quant_analyzer import QuantizationAnalyzer, QuantSpec

__all__ = [
    "GoldenModelGenerator",
    "GoldenCompileError",
    "QuantizationAnalyzer",
    "QuantSpec",
]
