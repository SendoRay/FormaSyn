"""Cross-layer Pareto optimizer (Direction C).

Jointly optimizes across Math, AlgoHW, and HLS-Schedule layers
to find Pareto-optimal design points unreachable by layer-isolated optimization.
"""

from .pareto import ParetoOptimizer, DesignPoint, ParetoFront

__all__ = ["ParetoOptimizer", "DesignPoint", "ParetoFront"]
