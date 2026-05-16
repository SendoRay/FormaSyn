"""质量指标计算工具函数。

提供 NMSE（归一化均方误差）、符号错误率等指标的计算，
供 L1Checker、L3 Simulator 等模块共享使用。
"""

from __future__ import annotations

import math

import numpy as np


def compute_nmse(
    golden: dict[str, list[float]],
    actual: dict[str, list[float]],
) -> float:
    """计算归一化均方误差（NMSE）dB。

    Args:
        golden: Golden 参考输出。
        actual: 实际输出。

    Returns:
        NMSE in dB。
    """
    power_signal = 0.0
    power_noise = 0.0

    for key in golden:
        g = np.array(golden[key], dtype=np.float64)
        a = np.array(actual.get(key, [0.0] * len(golden[key])), dtype=np.float64)
        min_len = min(len(g), len(a))
        g, a = g[:min_len], a[:min_len]

        power_signal += float(np.sum(g ** 2))
        power_noise += float(np.sum((g - a) ** 2))

    if power_signal < 1e-30:
        return 0.0
    return 10 * math.log10(max(power_noise, 1e-30) / power_signal)


def compute_sign_error_rate(
    golden: dict[str, list[float]],
    actual: dict[str, list[float]],
) -> tuple[float, float, float]:
    """计算符号错误率和 SNR 惩罚。

    Args:
        golden: Golden 参考输出。
        actual: 实际输出。

    Returns:
        (sign_error_rate, snr_penalty_db, power_signal) 三元组。
    """
    sign_errors = 0
    total_elements = 0
    power_signal = 0.0
    power_noise = 0.0

    for key in golden:
        g = np.array(golden[key], dtype=np.float64)
        a = np.array(actual.get(key, [0.0] * len(golden[key])), dtype=np.float64)
        min_len = min(len(g), len(a))
        g, a = g[:min_len], a[:min_len]

        sign_errors += int(np.sum(np.sign(g) != np.sign(a)))
        total_elements += min_len
        power_signal += float(np.sum(g ** 2))
        power_noise += float(np.sum((g - a) ** 2))

    sign_error_rate = sign_errors / max(total_elements, 1)

    if power_noise > 0 and power_signal > 0:
        snr_golden = 10 * math.log10(power_signal / 1e-10)
        snr_actual = 10 * math.log10(power_signal / max(power_noise, 1e-30))
        snr_penalty_db = max(0.0, snr_golden - snr_actual)
    else:
        snr_penalty_db = 0.0

    return sign_error_rate, snr_penalty_db, power_signal
