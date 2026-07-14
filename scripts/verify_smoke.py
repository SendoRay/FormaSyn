#!/usr/bin/env python3
"""LLM-free verify smoke test.

Feeds a known-correct complex-multiplier Verilog through ToolVerifyAgent to
validate the Verilator + Yosys toolchain and the auto-generated testbench,
independent of any LLM backend. Exits 0 on PASS.
"""

import csv
import logging
import random
import sys
from pathlib import Path

logging.basicConfig(level=logging.INFO, format="%(asctime)s [%(levelname)s] %(name)s: %(message)s")
logger = logging.getLogger("verify_smoke")

sys.path.insert(0, str(Path(__file__).resolve().parent.parent))

from formaflow.agents.verify_agent import ToolVerifyAgent
from formaflow.types import GeneratedCode


class _NoLLM:
    """Backend stub: verify must not need any fix calls for correct Verilog."""

    model_id = "no-llm"

    def complete(self, *a, **k):
        raise RuntimeError("unexpected LLM call — hand-written Verilog should be correct")

    def complete_structured(self, *a, **k):
        raise RuntimeError("unexpected LLM call — hand-written Verilog should be correct")


VERILOG = """\
module complex_mult (
    input  wire               clk,
    input  wire               rst,
    input  wire               valid_in,
    input  wire signed [15:0] a,
    input  wire signed [15:0] b,
    input  wire signed [15:0] c,
    input  wire signed [15:0] d,
    output reg                valid_out,
    output reg  signed [31:0] real_out,
    output reg  signed [31:0] imag_out
);
    always @(posedge clk) begin
        if (rst) begin
            valid_out <= 1'b0;
            real_out  <= 32'sd0;
            imag_out  <= 32'sd0;
        end else begin
            real_out  <= a * c - b * d;
            imag_out  <= a * d + b * c;
            valid_out <= valid_in;
        end
    end
endmodule
"""


def make_golden(path: Path, n: int = 200) -> None:
    path.parent.mkdir(parents=True, exist_ok=True)
    random.seed(42)
    with open(path, "w", newline="") as f:
        w = csv.writer(f)
        w.writerow(["a", "b", "c", "d", "expected_real", "expected_imag"])
        for _ in range(n):
            a = random.randint(-32768, 32767)
            b = random.randint(-32768, 32767)
            c = random.randint(-32768, 32767)
            d = random.randint(-32768, 32767)
            w.writerow([a, b, c, d, a * c - b * d, a * d + b * c])


def main() -> int:
    work = Path("results/verify_smoke")
    golden = work / "complex_mult_golden.csv"
    make_golden(golden)

    agent = ToolVerifyAgent(_NoLLM(), work_dir=work)
    code = GeneratedCode(variant_id="hand_complex_mult", verilog=VERILOG, testbench="")
    result = agent.verify(code, golden, max_fix_iterations=1)

    logger.info("Verdict: %s (iterations=%d)", result.verdict.value, result.iterations)
    if result.synth_metrics:
        m = result.synth_metrics
        logger.info("Synth: LUT=%d FF=%d DSP=%d BRAM=%d Fmax=%.1fMHz", m.lut, m.ff, m.dsp, m.bram, m.fmax_mhz)
    if result.error_log:
        logger.warning("Error log: %s", result.error_log[:500])
    return 0 if result.verdict.value == "pass" else 1


if __name__ == "__main__":
    sys.exit(main())
