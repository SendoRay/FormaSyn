#!/usr/bin/env python3
"""简单的三层 Checker 测试脚本 - 直接使用 checker 模块"""

import sys
import os
import logging
import subprocess
import tempfile
import xml.etree.ElementTree as ET

logging.basicConfig(level=logging.INFO, format='%(levelname)s %(message)s')
logger = logging.getLogger(__name__)

TEST_DIR = "/home/chengzhy/FormaSyn/vitis_hls_test/vec_add"

def read_file(path):
    with open(path, 'r') as f:
        return f.read()

def run_vitis_hls_csim():
    """直接运行 Vitis HLS C 仿真"""
    config_file = f"{TEST_DIR}/hls_config.cfg"

    cmd = [
        "vitis-run",
        "--mode", "hls",
        "--csim",
        "--config", config_file,
        "--work_dir", f"{TEST_DIR}/work",
    ]

    logger.info(f"运行命令: {' '.join(cmd)}")

    proc = subprocess.run(
        cmd,
        capture_output=True,
        text=True,
        cwd=TEST_DIR,
        timeout=60,
    )

    logger.info(f"返回码: {proc.returncode}")

    if proc.stdout:
        logger.info(f"STDOUT:\n{proc.stdout[:500]}")
    if proc.stderr:
        logger.info(f"STDERR:\n{proc.stderr[:500]}")

    return proc

def parse_csynth_report():
    """解析综合报告"""
    report_path = f"{TEST_DIR}/work/hls/syn/report/csynth.xml"

    if not os.path.exists(report_path):
        logger.warning(f"综合报告不存在: {report_path}")
        return None

    tree = ET.parse(report_path)
    root = tree.getroot()

    bram = int(root.findtext(".//AreaEstimates/Resources/BRAM_18K", "0"))
    dsp = int(root.findtext(".//AreaEstimates/Resources/DSP", "0"))
    ff = int(root.findtext(".//AreaEstimates/Resources/FF", "0"))
    lut = int(root.findtext(".//AreaEstimates/Resources/LUT", "0"))

    interval = int(root.findtext(".//PerformanceEstimates/SummaryOfOverallLatency/Interval-max", "1"))
    clock_period = float(root.findtext(".//PerformanceEstimates/SummaryOfTimingAnalysis/EstimatedClockPeriod", "0.0"))

    print(f"\n综合结果:")
    print(f"  DSP: {dsp}")
    print(f"  BRAM: {bram}")
    print(f"  FF: {ff}")
    print(f"  LUT: {lut}")
    print(f"  达成 II: {interval}")
    print(f"  时钟周期: {clock_period} ns")

def main():
    print("=" * 60)
    print("三层 Checker 测试")
    print("=" * 60)

    # 读取源文件
    hls_cpp = read_file(f"{TEST_DIR}/vec_add.cpp")
    print(f"\nHLS 代码:\n{hls_cpp}")

    # L1: 运行 C 仿真
    print("\n" + "-" * 40)
    print("L1 Checker: C 仿真")
    print("-" * 40)

    result = run_vitis_hls_csim()

    # L2: 解析综合报告
    print("\n" + "-" * 40)
    print("L2 Checker: 综合报告解析")
    print("-" * 40)

    parse_csynth_report()

    print("\n" + "=" * 60)
    print("测试完成")
    print("=" * 60)

if __name__ == "__main__":
    main()
