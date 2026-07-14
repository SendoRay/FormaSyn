"""Benchmark kernel definitions and deterministic golden-model generation.

These live in the package (not in a runner script) so both the fixed pipeline
runner and the evolutionary engine can share them.
"""

from __future__ import annotations

import csv
import logging
import random
from pathlib import Path

logger = logging.getLogger(__name__)

# ── Kernel definitions (extracted from benchmark) ──────────────────────────
KERNELS: list[dict] = [
    {
        "id": "complex_mult",
        "name": "16-bit Complex Multiplier (Karatsuba)",
        "latex": r"(a+jb)(c+jd) = (ac-bd) + j(ad+bc)",
        "constraints": {"input_width": 16, "output_width": 32},
        "category": "cat01_basic_math",
    },
    {
        "id": "cordic_rotate",
        "name": "CORDIC Rotation Mode (12 iterations, 16-bit)",
        "latex": r"x[i+1]=x[i]-\sigma_i y[i] 2^{-i},\ y[i+1]=y[i]+\sigma_i x[i] 2^{-i},\ z[i+1]=z[i]-\sigma_i \arctan(2^{-i})",
        "constraints": {"iterations": 12, "data_width": 16},
        "category": "cat01_basic_math",
    },
    {
        "id": "fir_symmetric",
        "name": "Symmetric FIR Filter (16 taps, 16-bit)",
        "latex": r"y[n] = \sum_{k=0}^{N-1} h[k] \cdot x[n-k],\ h[k]=h[N-1-k]",
        "constraints": {"taps": 16, "data_width": 16, "coeff_width": 16},
        "category": "cat02_filters",
    },
    {
        "id": "crc24",
        "name": "CRC-24 (polynomial 0x864CFB)",
        "latex": r"G(x) = x^{24}+x^{23}+x^{18}+x^{17}+x^{14}+x^{11}+x^{10}+x^{7}+x^{6}+x^{5}+x^{4}+x^{3}+x+1,\; \text{poly}=\texttt{0x864CFB}",
        "constraints": {"data_width": 8, "crc_width": 24, "polynomial": "0x864CFB", "init": "0xB704CE"},
        "category": "cat01_basic_math",
    },
    {
        "id": "nco",
        "name": "Numerically Controlled Oscillator",
        "latex": r"\theta[n+1] = (\theta[n] + \Delta\theta) \mod 2\pi,\ \text{output} = \sin(\theta[n])",
        "constraints": {"phase_width": 32, "output_width": 16},
        "category": "cat06_sync_estimation",
    },
]


def get_kernel(kernel_id: str) -> dict | None:
    """Return the kernel definition with the given id, or None."""
    return next((k for k in KERNELS if k["id"] == kernel_id), None)


def generate_golden(kernel: dict, golden_dir: Path, num_vectors: int = 200) -> Path:
    """Generate deterministic golden test vectors (CSV) for a kernel.

    Columns follow the `expected_<name>` convention the verify agent's testbench
    expects. Only complex_mult and crc24 have real references today; other kernels
    emit a placeholder identity mapping until proper references are added.
    """
    golden_path = golden_dir / f"{kernel['id']}_golden.csv"
    if golden_path.exists():
        return golden_path

    golden_dir.mkdir(parents=True, exist_ok=True)
    random.seed(42)

    kid = kernel["id"]
    width = kernel["constraints"].get("data_width", kernel["constraints"].get("input_width", 16))
    max_val = 2 ** (width - 1) - 1
    min_val = -(2 ** (width - 1))

    with open(golden_path, "w", newline="") as f:
        if kid == "complex_mult":
            writer = csv.writer(f)
            writer.writerow(["a", "b", "c", "d", "expected_real", "expected_imag"])
            for _ in range(num_vectors):
                a, b = random.randint(min_val, max_val), random.randint(min_val, max_val)
                c, d = random.randint(min_val, max_val), random.randint(min_val, max_val)
                writer.writerow([a, b, c, d, a * c - b * d, a * d + b * c])
        elif kid == "crc24":
            # CRC-24 (RFC 4880/OpenPGP): poly=0x864CFB, init=0xB704CE
            # Byte-at-a-time, MSB-first, cumulative CRC state.
            POLY = 0x1864CFB  # full 25-bit poly with x^24 term
            crc = 0xB704CE
            writer = csv.writer(f)
            writer.writerow(["data", "expected_crc"])
            for _ in range(num_vectors):
                byte = random.randint(0, 255)
                crc ^= byte << 16
                for _bit in range(8):
                    crc <<= 1
                    if crc & 0x1000000:
                        crc ^= POLY
                crc &= 0xFFFFFF
                writer.writerow([byte, crc])
        else:
            writer = csv.writer(f)
            writer.writerow(["input", "expected_output"])
            for _ in range(num_vectors):
                x = random.randint(min_val, max_val)
                writer.writerow([x, x])  # placeholder

    logger.info("Golden model generated: %s", golden_path)
    return golden_path
