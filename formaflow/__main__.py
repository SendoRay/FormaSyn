"""CLI entry point for FormaFlow."""

import argparse
import logging
import sys
from pathlib import Path

import yaml


def main():
    parser = argparse.ArgumentParser(description="FormaFlow experiment runner")
    subparsers = parser.add_subparsers(dest="command")

    # run command
    run_parser = subparsers.add_parser("run", help="Run an experiment campaign")
    run_parser.add_argument("--config", type=Path, required=True, help="Experiment config YAML")
    run_parser.add_argument("--resume", action="store_true", help="Resume from last checkpoint")
    run_parser.add_argument(
        "--log-level", default="INFO", choices=["DEBUG", "INFO", "WARNING", "ERROR"]
    )

    # single command
    single_parser = subparsers.add_parser("single", help="Run a single kernel")
    single_parser.add_argument("--kernel-id", required=True)
    single_parser.add_argument("--latex", required=True)
    single_parser.add_argument("--backend", default="claude", choices=["claude", "openai", "deepseek"])
    single_parser.add_argument("--golden", type=Path, help="Path to golden model output")
    single_parser.add_argument(
        "--log-level", default="INFO", choices=["DEBUG", "INFO", "WARNING", "ERROR"]
    )

    args = parser.parse_args()

    if not args.command:
        parser.print_help()
        sys.exit(1)

    logging.basicConfig(
        level=getattr(logging, args.log_level),
        format="%(asctime)s [%(levelname)s] %(name)s: %(message)s",
    )

    if args.command == "run":
        from .orchestrator import Orchestrator

        with open(args.config) as f:
            config = yaml.safe_load(f)
        orch = Orchestrator(config)
        result_path = orch.run_experiment(config)
        print(f"Results written to: {result_path}")

    elif args.command == "single":
        from .backends import ClaudeBackend, DeepSeekBackend, OpenAIBackend
        from .pipeline import FormaFlowPipeline

        backend_map = {
            "claude": ClaudeBackend,
            "openai": OpenAIBackend,
            "deepseek": DeepSeekBackend,
        }
        llm = backend_map[args.backend]()

        from .agents import (
            LLMCodegenAgent,
            LLMParseAgent,
            LLMTransformAgent,
            MultiObjectiveRankAgent,
            ToolVerifyAgent,
        )

        pipeline = FormaFlowPipeline(
            parse_agent=LLMParseAgent(llm),
            transform_agent=LLMTransformAgent(llm),
            codegen_agent=LLMCodegenAgent(llm),
            verify_agent=ToolVerifyAgent(llm),
            rank_agent=MultiObjectiveRankAgent(),
        )
        result = pipeline.run(
            latex=args.latex,
            constraints={},
            golden_model_path=args.golden or Path("/dev/null"),
        )
        print(f"Result: {result.verify_result.verdict.value if result.verify_result else 'NO_RESULT'}")
        if result.best_variant:
            print(f"Best variant: {result.best_variant.variant_id} ({result.best_variant.transform_applied})")


if __name__ == "__main__":
    main()
