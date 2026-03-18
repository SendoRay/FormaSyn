from __future__ import annotations

from FormaSyn.formasyn.checker.l2_checker import L2Checker


def test_vitis_available_handles_not_a_directory(monkeypatch) -> None:
    def fake_run(cmd, capture_output, text, timeout=None, cwd=None):
        raise NotADirectoryError("[Errno 20] Not a directory: 'vitis_hls'")

    monkeypatch.setattr("FormaSyn.formasyn.checker.l2_checker.subprocess.run", fake_run)
    assert L2Checker._vitis_available() is False


def test_check_skips_when_probe_raises_oserror(monkeypatch) -> None:
    checker = L2Checker()
    monkeypatch.setattr(checker, "_vitis_available", lambda: False)

    result = checker.check(
        hls_cpp_code="void kernel() {}",
        hls_header_code="void kernel();\n",
        variant_id="probe_error_variant",
    )

    assert result.skipped is True
    assert result.passed is True
    assert result.failure is None


def test_hls_config_for_csynth_only() -> None:
    checker = L2Checker(clock_mhz=250)
    cfg = checker._generate_hls_config("kernel", "/tmp/kernel.cpp")
    assert "syn.top=kernel" in cfg
    assert "syn.file=/tmp/kernel.cpp" in cfg
    assert "tb.file=" not in cfg
