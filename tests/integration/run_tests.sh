#!/bin/bash
# Run distributed_systemfile integration tests
#
# Usage:
#   # With direct build
#   ./run_tests.sh --executable ./o/distributed_systemfile/distributed_systemfile --model /path/to/model.gguf
#
#   # With pre-built distributed_systemfile
#   ./run_tests.sh --executable ./Qwen-QwQ.distributed_systemfile
#
#   # Run specific test categories
#   ./run_tests.sh --executable ./model.distributed_systemfile -m "cli"
#   ./run_tests.sh --executable ./model.distributed_systemfile -m "server"
#   ./run_tests.sh --executable ./model.distributed_systemfile -m "multimodal"
#
#   # Skip slow tests
#   ./run_tests.sh --executable ./model.distributed_systemfile -m "not slow"
#
#   # Show model outputs (debug level logging)
#   ./run_tests.sh --executable ./model.distributed_systemfile --log-cli-level=DEBUG

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR"

# Run pytest using uv
exec uv run pytest tests/ "$@"
