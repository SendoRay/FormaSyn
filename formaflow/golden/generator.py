"""Golden model generator — produces Python/SymPy reference implementations for verification."""

from __future__ import annotations

import logging
import subprocess
import tempfile
from pathlib import Path

import numpy as np

logger = logging.getLogger(__name__)


GOLDEN_TEMPLATE = '''\
"""Golden model for {kernel_id}. Auto-generated from LaTeX specification."""

import numpy as np
import sys
from pathlib import Path


def golden_compute({input_args}):
    """Reference implementation of {kernel_id}.

    Formula: {latex}
    """
{compute_body}


def generate_test_vectors(num_vectors: int = 1000, seed: int = 42, bit_width: int = 16):
    """Generate random test vectors for verification."""
    rng = np.random.default_rng(seed)
    max_val = 2 ** (bit_width - 1) - 1
    min_val = -(2 ** (bit_width - 1))

    vectors = []
    for _ in range(num_vectors):
        inputs = {{
{vector_gen}
        }}
        outputs = golden_compute(**inputs)
        if not isinstance(outputs, dict):
            outputs = {{"result": outputs}}
        vectors.append({{**inputs, **outputs}})

    return vectors


def main():
    """Generate golden output CSV."""
    import csv

    output_path = Path(sys.argv[1]) if len(sys.argv) > 1 else Path("{kernel_id}_golden.csv")
    num_vectors = int(sys.argv[2]) if len(sys.argv) > 2 else 1000

    vectors = generate_test_vectors(num_vectors=num_vectors)

    if not vectors:
        print("ERROR: No vectors generated", file=sys.stderr)
        sys.exit(1)

    fieldnames = list(vectors[0].keys())
    with open(output_path, "w", newline="") as f:
        writer = csv.DictWriter(f, fieldnames=fieldnames)
        writer.writeheader()
        writer.writerows(vectors)

    print(f"Generated {{len(vectors)}} test vectors -> {{output_path}}")


if __name__ == "__main__":
    main()
'''


class GoldenModelGenerator:
    """Generates Python golden model scripts from kernel specifications."""

    def __init__(self, llm_backend, output_dir: Path = Path("golden_models")):
        self.llm = llm_backend
        self.output_dir = output_dir
        self.output_dir.mkdir(parents=True, exist_ok=True)

    def generate(self, kernel_id: str, latex: str, constraints: dict) -> Path:
        """Generate a golden model Python script for a kernel.

        Returns the path to the generated golden model script.
        """
        logger.info(f"Generating golden model for {kernel_id}")

        # Ask LLM to produce the compute body
        prompt = self._build_prompt(kernel_id, latex, constraints)
        response = self.llm.complete(
            messages=[{"role": "user", "content": prompt}],
            temperature=0.0,  # deterministic for golden model
            max_tokens=4096,
        )

        # Parse the response to extract function components
        compute_body, input_args, vector_gen = self._parse_response(response, kernel_id)

        # Fill template
        script = GOLDEN_TEMPLATE.format(
            kernel_id=kernel_id,
            latex=latex.replace('"', '\\"'),
            input_args=input_args,
            compute_body=compute_body,
            vector_gen=vector_gen,
        )

        # Write and validate
        script_path = self.output_dir / f"{kernel_id}_golden.py"
        script_path.write_text(script)

        # Syntax check
        if not self._validate_syntax(script_path):
            logger.warning(f"Golden model {kernel_id} has syntax errors")

        return script_path

    def generate_output(self, kernel_id: str, num_vectors: int = 1000) -> Path:
        """Run the golden model script to produce test vector CSV."""
        script_path = self.output_dir / f"{kernel_id}_golden.py"
        output_path = self.output_dir / f"{kernel_id}_golden.csv"

        if not script_path.exists():
            raise FileNotFoundError(f"Golden model script not found: {script_path}")

        result = subprocess.run(
            ["python", str(script_path), str(output_path), str(num_vectors)],
            capture_output=True,
            text=True,
            timeout=60,
            cwd=str(self.output_dir),
        )

        if result.returncode != 0:
            logger.error(f"Golden model execution failed: {result.stderr}")
            raise RuntimeError(f"Golden model failed for {kernel_id}: {result.stderr}")

        logger.info(f"Golden output generated: {output_path}")
        return output_path

    def _build_prompt(self, kernel_id: str, latex: str, constraints: dict) -> str:
        """Build the LLM prompt for golden model generation."""
        constraint_text = "\n".join(f"  - {k}: {v}" for k, v in constraints.items())
        return f"""Generate a Python numpy implementation of this digital signal processing kernel.

Kernel ID: {kernel_id}
Mathematical formula (LaTeX): {latex}
Constraints:
{constraint_text if constraint_text else "  (none specified)"}

Requirements:
1. Implement the EXACT mathematical operation in floating-point (this is the golden reference)
2. Use numpy for vectorized computation
3. Return a dict of output values

Provide three things in your response, clearly labeled:

## INPUT_ARGS
A Python function signature parameter list (e.g., "x, h, n_taps" for a FIR filter)

## COMPUTE_BODY
The function body (indented with 4 spaces) that computes the output.
It should return a dict like {{"y": result}} or {{"real": re, "imag": im}}.

## VECTOR_GEN
Dict comprehension lines (indented with 12 spaces) that generate random inputs.
Each line like: '"x": rng.integers(min_val, max_val, size=n_taps).tolist(),'

Use only numpy. No external dependencies beyond numpy."""

    def _parse_response(self, response: str, kernel_id: str) -> tuple[str, str, str]:
        """Parse LLM response into template components."""
        sections = {"INPUT_ARGS": "", "COMPUTE_BODY": "", "VECTOR_GEN": ""}
        current_section = None

        for line in response.split("\n"):
            if "## INPUT_ARGS" in line:
                current_section = "INPUT_ARGS"
                continue
            elif "## COMPUTE_BODY" in line:
                current_section = "COMPUTE_BODY"
                continue
            elif "## VECTOR_GEN" in line:
                current_section = "VECTOR_GEN"
                continue
            elif line.startswith("## "):
                current_section = None
                continue

            if current_section:
                sections[current_section] += line + "\n"

        input_args = sections["INPUT_ARGS"].strip().strip("`")
        compute_body = sections["COMPUTE_BODY"].rstrip()
        vector_gen = sections["VECTOR_GEN"].rstrip()

        # Ensure compute_body is indented
        if compute_body and not compute_body.startswith("    "):
            compute_body = "\n".join("    " + l for l in compute_body.split("\n"))

        # Ensure vector_gen is indented
        if vector_gen and not vector_gen.startswith("            "):
            vector_gen = "\n".join("            " + l.lstrip() for l in vector_gen.split("\n") if l.strip())

        # Fallback if parsing failed
        if not compute_body:
            compute_body = f'    # TODO: implement {kernel_id}\n    return {{"result": 0}}'
        if not input_args:
            input_args = "x"
        if not vector_gen:
            vector_gen = '            "x": rng.integers(min_val, max_val, size=16).tolist(),'

        return compute_body, input_args, vector_gen

    def _validate_syntax(self, script_path: Path) -> bool:
        """Check Python syntax validity."""
        result = subprocess.run(
            ["python", "-c", f"import ast; ast.parse(open('{script_path}').read())"],
            capture_output=True,
            text=True,
        )
        return result.returncode == 0
