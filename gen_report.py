#!/usr/bin/env python3
"""Generate a markdown report from FormaFlow pipeline results.

Usage:
    python gen_report.py [--results-dir results/loop_run] [--output report.md]
"""

import argparse
import csv
import json
import re
import subprocess
from datetime import datetime
from pathlib import Path

SYNTH_TIMEOUT = 120


def extract_module_name(verilog: str) -> str:
    m = re.search(r"module\s+(\w+)", verilog)
    return m.group(1) if m else "design"


def run_yosys_ice40(verilog_path: Path) -> dict:
    """Run Yosys ice40 synthesis and extract metrics."""
    mod_name = extract_module_name(verilog_path.read_text())
    script = f"read_verilog {verilog_path.name}; synth_ice40 -top {mod_name}; stat"
    try:
        result = subprocess.run(
            ["yosys", "-p", script],
            capture_output=True, text=True, timeout=SYNTH_TIMEOUT,
            cwd=str(verilog_path.parent),
        )
    except (subprocess.TimeoutExpired, FileNotFoundError):
        return {}

    if result.returncode != 0:
        return {}

    out = result.stdout
    # Only parse the final stat section to avoid double-counting from
    # intermediate synthesis passes
    idx = out.rfind("Printing statistics")
    stat_section = out[idx:] if idx >= 0 else out

    def parse(pattern, sum_all=False):
        matches = re.findall(pattern, stat_section)
        if not matches:
            return 0
        if sum_all:
            return sum(int(m) for m in matches)
        return int(matches[-1])

    return {
        "lut4": parse(r"(\d+)\s+SB_LUT4"),
        "ff": parse(r"(\d+)\s+SB_DFF\w*", sum_all=True),
        "carry": parse(r"(\d+)\s+SB_CARRY"),
        "dsp": parse(r"(\d+)\s+SB_MAC16"),
        "bram": parse(r"(\d+)\s+SB_RAM\w*"),
        "total_cells": parse(r"(\d+)\s+cells"),
    }


def count_lines(verilog_path: Path) -> int:
    return len(verilog_path.read_text().splitlines())


def check_sim_pass(variant_dir: Path, golden_path=None) -> bool:
    """Check if simulation passed by verifying output.csv against golden."""
    output_csv = variant_dir / "output.csv"
    if not output_csv.exists():
        return False
    if golden_path is None or not golden_path.exists():
        return False

    try:
        with open(golden_path) as f:
            golden = list(csv.DictReader(f))
        with open(output_csv) as f:
            sim = list(csv.DictReader(f))

        if len(sim) != len(golden):
            return False

        expected_fields = [c for c in golden[0] if c.startswith("expected_")]
        for i, (sr, gr) in enumerate(zip(sim, golden)):
            for field in expected_fields:
                out_name = field.removeprefix("expected_")
                if out_name not in sr:
                    return False
                try:
                    if int(gr[field]) != int(sr[out_name]):
                        return False
                except (ValueError, TypeError):
                    if str(gr[field]).strip() != str(sr[out_name]).strip():
                        return False
        return True
    except Exception:
        return False


def count_sim_vectors(variant_dir: Path) -> int:
    output_csv = variant_dir / "output.csv"
    if not output_csv.exists():
        return 0
    with open(output_csv) as f:
        return sum(1 for _ in f) - 1  # minus header


def get_transform_name(variant_dir: Path) -> str:
    """Try to infer transform name from directory or Verilog comments."""
    for v in variant_dir.glob("*.v"):
        text = v.read_text()
        for line in text.splitlines()[:5]:
            if "transform" in line.lower() or "//" in line:
                return line.strip("/ \n")
    vid = variant_dir.name
    # e.g., k_bd97090a3658_v0 -> v0
    parts = vid.rsplit("_", 1)
    return parts[-1] if len(parts) > 1 else vid


def analyze_kernel(kernel_dir: Path, golden_dir: Path) -> dict:
    """Analyze all variants for a single kernel."""
    kernel_id = kernel_dir.name
    golden_path = golden_dir / f"{kernel_id}_golden.csv"
    variants = sorted(kernel_dir.glob("k_*"))
    results = []

    for vdir in variants:
        vfiles = list(vdir.glob("*.v"))
        if not vfiles:
            continue
        # pick the main verilog file (largest)
        vfile = max(vfiles, key=lambda f: f.stat().st_size)

        vid = vdir.name
        sim_pass = check_sim_pass(vdir, golden_path)
        n_vectors = count_sim_vectors(vdir)
        n_lines = count_lines(vfile)

        metrics = {}
        if sim_pass:
            metrics = run_yosys_ice40(vfile)

        results.append({
            "variant_id": vid,
            "verilog_file": vfile.name,
            "lines": n_lines,
            "sim_pass": sim_pass,
            "sim_vectors": n_vectors,
            "synth": metrics,
        })

    return {"kernel_id": kernel_id, "variants": results}


def generate_md(results_dir: Path, output_path: Path):
    # Load progress.json if available
    progress = []
    progress_path = results_dir / "progress.json"
    if progress_path.exists():
        progress = json.loads(progress_path.read_text())

    # Find kernel directories
    kernel_dirs = sorted(
        d for d in results_dir.iterdir()
        if d.is_dir() and d.name != "golden" and not d.name.startswith(".")
    )

    all_kernels = []
    for kdir in kernel_dirs:
        print(f"Analyzing {kdir.name}...")
        golden_dir = results_dir / "golden"
        analysis = analyze_kernel(kdir, golden_dir)
        # merge with progress info
        prog = next((p for p in progress if p["kernel_id"] == kdir.name), {})
        analysis["verdict"] = prog.get("verdict", "unknown")
        analysis["wall_time_s"] = prog.get("wall_time_s", 0)
        analysis["best_variant"] = prog.get("best_variant", "")
        all_kernels.append(analysis)

    # Generate markdown
    lines = []
    lines.append("# FormaFlow Pipeline Results Report")
    lines.append("")
    lines.append(f"**Generated**: {datetime.now().strftime('%Y-%m-%d %H:%M:%S')}")
    lines.append(f"**Results directory**: `{results_dir}`")
    lines.append(f"**Target FPGA**: Lattice iCE40 (Yosys synth_ice40)")
    lines.append(f"**LLM Backend**: Claude Sonnet 4 (via `claude -p` CLI)")
    lines.append("")

    # Summary table
    lines.append("## Summary")
    lines.append("")
    passed = sum(1 for k in all_kernels if k["verdict"] == "pass")
    total = len(all_kernels)
    lines.append(f"| Metric | Value |")
    lines.append(f"|--------|-------|")
    lines.append(f"| Kernels evaluated | {total} |")
    lines.append(f"| Kernels passed | {passed}/{total} ({100*passed//total if total else 0}%) |")
    total_variants = sum(len(k["variants"]) for k in all_kernels)
    passing_variants = sum(1 for k in all_kernels for v in k["variants"] if v["sim_pass"])
    lines.append(f"| Total variants generated | {total_variants} |")
    lines.append(f"| Variants passing simulation | {passing_variants}/{total_variants} |")
    total_time = sum(k["wall_time_s"] for k in all_kernels)
    lines.append(f"| Total wall time | {total_time:.0f}s ({total_time/60:.1f}min) |")
    lines.append("")

    # Per-kernel details
    lines.append("## Per-Kernel Results")
    lines.append("")

    for kernel in all_kernels:
        kid = kernel["kernel_id"]
        verdict = kernel["verdict"]
        verdict_icon = "PASS" if verdict == "pass" else "FAIL"
        lines.append(f"### {kid} — {verdict_icon}")
        lines.append("")
        lines.append(f"- **Verdict**: `{verdict}`")
        lines.append(f"- **Wall time**: {kernel['wall_time_s']:.1f}s")
        lines.append(f"- **Best variant**: `{kernel['best_variant']}`")
        lines.append(f"- **Variants**: {len(kernel['variants'])} generated, "
                      f"{sum(1 for v in kernel['variants'] if v['sim_pass'])} passed simulation")
        lines.append("")

        # Variant table
        has_synth = any(v["synth"] for v in kernel["variants"])
        if has_synth:
            lines.append("| Variant | Sim | Vectors | Lines | LUT4 | FF | Carry | Total Cells |")
            lines.append("|---------|-----|---------|-------|------|----|----|-------------|")
        else:
            lines.append("| Variant | Sim | Vectors | Lines |")
            lines.append("|---------|-----|---------|-------|")

        for v in kernel["variants"]:
            sim = "PASS" if v["sim_pass"] else "FAIL"
            vid_short = v["variant_id"].split("_")[-1]
            if has_synth and v["synth"]:
                s = v["synth"]
                lines.append(
                    f"| {vid_short} | {sim} | {v['sim_vectors']} | {v['lines']} | "
                    f"{s.get('lut4', '-')} | {s.get('ff', '-')} | {s.get('carry', '-')} | "
                    f"{s.get('total_cells', '-')} |"
                )
            elif has_synth:
                lines.append(
                    f"| {vid_short} | {sim} | {v['sim_vectors']} | {v['lines']} | - | - | - | - |"
                )
            else:
                lines.append(
                    f"| {vid_short} | {sim} | {v['sim_vectors']} | {v['lines']} |"
                )
        lines.append("")

    # PPA comparison for passing variants
    passing = [
        (k["kernel_id"], v)
        for k in all_kernels
        for v in k["variants"]
        if v["sim_pass"] and v["synth"]
    ]
    if passing:
        lines.append("## PPA Comparison (Passing Variants)")
        lines.append("")
        lines.append("| Kernel | Variant | LUT4 | FF | Carry | Total Cells | Verilog Lines |")
        lines.append("|--------|---------|------|----|----|-------------|---------------|")
        for kid, v in passing:
            s = v["synth"]
            vid_short = v["variant_id"].split("_")[-1]
            lines.append(
                f"| {kid} | {vid_short} | {s.get('lut4', 0)} | {s.get('ff', 0)} | "
                f"{s.get('carry', 0)} | {s.get('total_cells', 0)} | {v['lines']} |"
            )
        lines.append("")

    # Notes
    lines.append("## Notes")
    lines.append("")
    lines.append("- **Target**: Lattice iCE40 FPGA (Yosys `synth_ice40`)")
    lines.append("- **Fmax**: Not available from Yosys alone (requires nextpnr for place-and-route)")
    lines.append("- **Power**: Not estimated (requires gate-level simulation or vendor tools)")
    lines.append("- **Simulation**: Verilator cycle-accurate simulation against golden model (integer exact match)")
    lines.append("- **Pipeline**: FormaFlow 5-stage (Parse → Transform → Codegen → Verify → Rank)")
    lines.append("")

    md = "\n".join(lines)
    output_path.write_text(md)
    print(f"\nReport written to {output_path}")
    return md


if __name__ == "__main__":
    parser = argparse.ArgumentParser()
    parser.add_argument("--results-dir", type=Path, default=Path("results/loop_run"))
    parser.add_argument("--output", type=Path, default=Path("results/loop_run/report.md"))
    args = parser.parse_args()
    generate_md(args.results_dir, args.output)
