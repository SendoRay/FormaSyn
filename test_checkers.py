#!/usr/bin/env python3
"""简单的三层 Checker 测试脚本

使用 vitis_hls_test/vec_add 下的现有 demo 测试三层验证流水线。
"""

import sys
import os
import logging
sys.path.insert(0, '.')

from formasyn.checker.l1_checker import L1Checker
from formasyn.checker.l2_checker import L2Checker
from formasyn.checker.l3_checker import L3Checker

logging.basicConfig(level=logging.INFO, format='%(levelname)s %(message)s')
logger = logging.getLogger(__name__)

# 测试配置
TEST_DIR = "/home/chengzhy/FormaSyn/vitis_hls_test/vec_add"
CPP_FILE = os.path.join(TEST_DIR, "vec_add.cpp")
TB_FILE = os.path.join(TEST_DIR, "vec_add_tb.cpp")

def read_file(path):
    with open(path, 'r') as f:
        return f.read()

def main():
    print("=" * 60)
    print("三层 Checker 测试")
    print("=" * 60)

    # 读取源文件
    hls_cpp = read_file(CPP_FILE)
    hls_header = ""  # 简化，不需要头文件

    # 准备测试数据
    test_inputs = {
        'a': [i for i in range(16)],
        'b': [i*2 for i in range(16)]
    }

    # 计算预期输出
    golden_outputs = {
        'c': [test_inputs['a'][i] + test_inputs['b'][i] for i in range(16)]
    }

    print(f"\n测试数据:")
    print(f"  a: {test_inputs['a']}")
    print(f"  b: {test_inputs['b']}")
    print(f"  预期 c: {golden_outputs['c']}")

    # L1 Checker 测试
    print("\n" + "-" * 40)
    print("L1 Checker 测试 (C 仿真)")
    print("-" * 40)

    l1 = L1Checker(kernel_type="filtering", tolerance={'nmse_db': -40.0})

    # 注意：L1 Checker 需要生成 testbench，这里手动创建一个简单的
    # 先尝试使用 PreChecker
    try:
        from formasyn.checker.pre_checker import PreChecker

        pre_checker = PreChecker(
            part="xc7z020clg400-1",
            clock="10ns",
            output_root=f"/tmp/checker_test/vec_add"
        )

        pre_result = pre_checker.prepare_environment(
            example_name="vec_add",
            variant_id="test",
            hls_cpp_code=hls_cpp,
            golden_outputs=golden_outputs,
            test_inputs=test_inputs,
        )

        logger.info(f"PreChecker 准备完成: {pre_result.ready}")
        logger.info(f"输出目录: {pre_result.output_dir}")

        if pre_result.ready:
            l1_result = l1.check(
                hls_cpp,
                golden_outputs,
                test_inputs,
                "test",
                prepared_dir=pre_result.output_dir,
            )

            print(f"L1 结果:")
            print(f"  编译成功: {l1_result.compile_ok}")
            print(f"  验证通过: {l1_result.passed}")
            if l1_result.metrics:
                print(f"  指标: {l1_result.metrics}")
        else:
            print(f"PreChecker 失败: {pre_result.error}")

    except Exception as e:
        logger.error(f"L1 测试失败: {e}")
        import traceback
        traceback.print_exc()

    # L2 Checker 测试
    print("\n" + "-" * 40)
    print("L2 Checker 测试 (综合)")
    print("-" * 40)

    try:
        l2 = L2Checker(
            hw_budget={"dsp": 9999, "bram": 9999},
            target_ii=2,
            clock_mhz=100,  # 10ns = 100MHz
        )

        # 使用 PreChecker 准备的目录
        if 'pre_result' in locals() and pre_result.ready:
            l2_result = l2.check(
                hls_cpp,
                hls_header,
                "test",
                prepared_dir=pre_result.output_dir,
            )

            print(f"L2 结果:")
            print(f"  跳过: {l2_result.skipped}")
            print(f"  验证通过: {l2_result.passed}")
            if l2_result.synth_report:
                r = l2_result.synth_report
                print(f"  DSP: {r.dsp}")
                print(f"  BRAM: {r.bram}")
                print(f"  LUT: {r.lut}")
                print(f"  FF: {r.ff}")
                print(f"  时钟周期: {r.clock_period_ns} ns")
                print(f"  达成 II: {r.achieved_ii}")
        else:
            # 直接测试
            l2_result = l2.check(hls_cpp, hls_header, "test")

            print(f"L2 结果:")
            print(f"  跳过: {l2_result.skipped}")
            print(f"  验证通过: {l2_result.passed}")

    except Exception as e:
        logger.error(f"L2 测试失败: {e}")
        import traceback
        traceback.print_exc()

    print("\n" + "=" * 60)
    print("测试完成")
    print("=" * 60)

if __name__ == "__main__":
    main()
