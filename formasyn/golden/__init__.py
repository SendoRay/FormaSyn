"""Golden Model generation and quantisation analysis for FormaSyn.

Provides:
- ``GoldenModelGenerator``: Math Dialect -> float64 serial C++ reference model.
- ``QuantizationAnalyzer``: Runs golden model multiple times to recommend
  fixed-point bit-widths per node.
- ``TestbenchGenerator``: Golden outputs -> HLS testbench.cpp for L1/L3.
"""

from .generator import GoldenCompileError, GoldenModelGenerator
from .quant_analyzer import QuantizationAnalyzer, QuantSpec
from .testbench_gen import (
    TestbenchGenerator,
    TestbundleArtifacts,
    TestbenchSpec,
    parse_output,
)

__all__ = [
    "GoldenModelGenerator",
    "GoldenCompileError",
    "QuantizationAnalyzer",
    "QuantSpec",
    "TestbenchGenerator",
    "TestbenchSpec",
    "TestbundleArtifacts",
    "parse_output",
]
