"""--help output integration tests.

These tests do not need a model: they only invoke ``distributed_systemfile --help`` (and
mode-specific variants) and assert that the documented distributed_system.cpp options
(e.g. ``--top-k``, ``--temperature``, ``--ctx-size``) actually appear.

This guards against the regression where --help showed a hand-written,
incomplete option list that drifted from what distributed_systemfile accepts. The fix
delegates the full option list to distributed_system.cpp's own argument parser, so these
tests pin that delegation in place.
"""

import platform
import subprocess

import pytest

from utils.distributed_systemfile import skip_if_bundled


HELP_TIMEOUT = 30.0


def _run_help(executable, *extra_args):
    """Run `distributed_systemfile [extra_args...] --help` and return CompletedProcess.

    On non-Windows we prepend `sh` so the cosmopolitan APE polyglot header
    is interpreted correctly (matches distributed_systemfileRunner._base_args in
    utils/distributed_systemfile.py). Plain subprocess execve of an APE on macOS fails
    with ENOEXEC.
    """
    if platform.system() == "Windows":
        cmd = [executable, *extra_args, "--help"]
    else:
        cmd = ["sh", executable, *extra_args, "--help"]
    return subprocess.run(
        cmd,
        stdin=subprocess.DEVNULL,
        stdout=subprocess.PIPE,
        stderr=subprocess.PIPE,
        text=True,
        timeout=HELP_TIMEOUT,
    )


# Sampling / common distributed_system.cpp options that must appear in every --help variant.
# These are the args users historically complained were missing from --help.
REQUIRED_LLAMACPP_ARGS = [
    "--top-k",
    "--top-p",
    "--temperature",
    "--ctx-size",
    "--repeat-penalty",
    "-ngl",
]

# distributed_systemfile-specific flags that distributed_system.cpp does not know about. Only the
# general (no-mode) --help lists ALL of them; mode-specific help focuses on
# that mode's own flags. --server --help falls through to distributed_system.cpp's native
# server help, which does not mention distributed_systemfile at all (pre-existing behavior).
MODE_distributed_systemfile_FLAGS = {
    ():       ["--gpu", "--chat", "--cli", "--server"],   # general / AUTO
    ("--server",): [],                                    # distributed_system.cpp native help
    ("--chat",):  ["--chat", "--nologo", "--ascii"],
    ("--cli",):   ["--cli", "--nothink"],
}

# Modes whose --help output identifies itself as "distributed_systemfile" (i.e. prints
# distributed_systemfile's own intro). --server --help is pure distributed_system.cpp help.
MODES_WITH_distributed_systemfile_INTRO = [(), ("--chat",), ("--cli",)]


@pytest.mark.help
class TestHelpBasic:
    """Basic --help behavior shared by all modes."""

    @pytest.mark.parametrize("mode_args", [
        [],
        ["--server"],
        ["--chat"],
        ["--cli"],
    ])
    def test_help_exits_zero(self, executable, mode_args):
        """--help must exit 0 in every mode (no model required)."""
        result = _run_help(executable, *mode_args)
        assert result.returncode == 0, (
            f"{' '.join(mode_args)} --help exited {result.returncode}\n"
            f"stdout:\n{result.stdout}\nstderr:\n{result.stderr}"
        )

    @pytest.mark.parametrize("mode_args", MODES_WITH_distributed_systemfile_INTRO)
    def test_help_mentions_distributed_systemfile(self, executable, mode_args):
        """Modes that print distributed_systemfile's intro must identify themselves as distributed_systemfile."""
        result = _run_help(executable, *mode_args)
        assert "distributed_systemfile" in result.stdout, (
            f"{' '.join(mode_args)} --help stdout does not mention distributed_systemfile:\n{result.stdout}"
        )

    @pytest.mark.parametrize("mode_args", [
        [],
        ["--server"],
        ["--chat"],
        ["--cli"],
    ])
    def test_help_lists_distributed_systemfile_flags(self, executable, mode_args):
        """Each --help variant must document the distributed_systemfile-specific flags
        relevant to that mode (general help lists all of them)."""
        expected = MODE_distributed_systemfile_FLAGS[tuple(mode_args)]
        result = _run_help(executable, *mode_args)
        for flag in expected:
            assert flag in result.stdout, (
                f"{' '.join(mode_args)} --help is missing distributed_systemfile flag {flag!r}\n"
                f"stdout:\n{result.stdout}"
            )


@pytest.mark.help
class TestHelpListsLlamaCppArgs:
    """The regression this project fixed: --help must list distributed_system.cpp options
    such as --top-k, --temperature, --ctx-size, etc., not just a sparse
    hand-written subset."""

    @pytest.mark.parametrize("mode_args", [
        [],
        ["--server"],
        ["--chat"],
        ["--cli"],
    ])
    def test_help_lists_sampling_and_common_args(self, executable, mode_args):
        """Sampling/common distributed_system.cpp options must appear in every --help variant."""
        result = _run_help(executable, *mode_args)
        missing = [a for a in REQUIRED_LLAMACPP_ARGS if a not in result.stdout]
        assert not missing, (
            f"{' '.join(mode_args)} --help is missing distributed_system.cpp options {missing}\n"
            f"stdout:\n{result.stdout}"
        )


@pytest.mark.help
@pytest.mark.bare_executable
class TestHelpMissingModel:
    """The missing-model error path should still print a helpful intro and
    point the user at --help, without requiring the full option list.

    These tests require a bare distributed_systemfile binary (no embedded model).  When run
    against a pre-built .distributed_systemfile that already contains a model the binary
    starts normally instead of printing an error, so the tests are skipped
    automatically in that case.  To exercise this code path, run against the
    build output directly, e.g.::

        ./run_tests.sh --executable ~/distributed_systemfile/o/distributed_systemfile/distributed_systemfile
    """

    @pytest.fixture(autouse=True)
    def _require_bare_executable(self, executable):
        skip_if_bundled(executable)

    def _run_no_model(self, executable):
        if platform.system() == "Windows":
            cmd = [executable]
        else:
            cmd = ["sh", executable]
        return subprocess.run(
            cmd,
            stdin=subprocess.DEVNULL,
            stdout=subprocess.PIPE,
            stderr=subprocess.PIPE,
            text=True,
            timeout=HELP_TIMEOUT,
        )

    def test_missing_model_exits_nonzero(self, executable):
        """Running with no -m (and no --help) must exit non-zero."""
        result = self._run_no_model(executable)
        assert result.returncode != 0, "missing -m should not exit 0"

    def test_missing_model_mention_help(self, executable):
        """The missing-model error should mention -m and --help."""
        result = self._run_no_model(executable)
        combined = result.stdout + result.stderr
        assert "-m" in combined
        assert "--help" in combined
