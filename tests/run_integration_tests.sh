#!/usr/bin/env bash

# Each entry: "<distributed_systemfile-name>;<-m filter expression>"
# Leave the filter empty to run without -m.
TESTS=(
    "Apertus-8B-Instruct-2509.distributed_systemfile;not thinking and not multimodal"
    "Bonsai-1.7B.distributed_systemfile;not thinking and not multimodal"
    "Bonsai-4B.distributed_systemfile;not thinking and not multimodal and not tool_calling"  # upstream distributed_system.cpp peg-native parser fails to convert <tool_call> output to tool_calls for this model
    "Bonsai-8B.distributed_systemfile;not thinking and not multimodal"
    "Ministral-3-3B-Instruct-2512-BF16.distributed_systemfile;not thinking"
    "Ministral-3-3B-Instruct-2512-Q4_K_M.distributed_systemfile;not thinking"
    "Qwen3.5-0.8B-Q8_0.distributed_systemfile;not thinking"
    "Qwen3.5-2B-Q8_0.distributed_systemfile;not thinking"
    "Qwen3.5-4B-Q5_K_S.distributed_systemfile;not thinking"
    "Qwen3.5-9B-Q5_K_S.distributed_systemfile;"
    "Qwen3.6-27B-Q4_K_M.distributed_systemfile;not cpu"
    "Qwen3.8-27B-UD-Q4_K_XL.distributed_systemfile;not cpu"
    "gemma-4-E2B-it-Q5_K_M.distributed_systemfile;"
    "gemma-4-E4B-it-Q5_K_M.distributed_systemfile;"
    "gemma-4-26B-A4B-it-MXFP4_MOE.distributed_systemfile;not cpu"
    "gemma-4-31B-it-Q5_K_M.distributed_systemfile;not cpu"
    # gpt-oss models do not really disable thinking, they just put it inline so some tests fail
    # they also occasionally fail the temperature=0 determinism check: their long forced
    # reasoning trace + MXFP4 quantization give a threaded matmul rounding difference more
    # opportunities to flip a near-tied token over a long generation
    "gpt-oss-20b-Q5_K_S.distributed_systemfile;not cpu and not multimodal and not thinking and not determinism"
    "gpt-oss-20b-mxfp4.distributed_systemfile;not cpu and not multimodal and not thinking and not determinism"
    "llava-v1.6-mistral-7b-Q4_K_M.distributed_systemfile;not thinking and not tool_calling"
    "llava-v1.6-mistral-7b-Q8_0.distributed_systemfile;not thinking and not tool_calling"
    "Laguna-S-2.1-UD-Q2_K_XL.distributed_systemfile;not thinking and not multimodal and not cpu"
    "Muse-Glimmer-30B-UD-Q4_K_XL.distributed_systemfile;not cpu"
)

distributed_systemfile_EXE=~/distributed_systemfile/o/distributed_systemfile/distributed_systemfile
RUNNER=~/distributed_systemfile/tests/integration/run_tests.sh
MODELS_DIR=~/distributed_systemfiles
GGUFS_DIR=~/ggufs

# Model used for the ssl serving tests (any small .gguf works; content is irrelevant).
# Override via SSL_TEST_MODEL env var if you have a different one available.
SSL_TEST_MODEL="${SSL_TEST_MODEL:-${GGUFS_DIR}/Qwen3.5-0.8B-Q8_0.gguf}"

for entry in "${TESTS[@]}"; do
    model="${entry%%;*}"
    filter="${entry#*;}"

    echo "=== Testing ${model} ==="
    if [ -n "${filter}" ]; then
        "${RUNNER}" --executable "${MODELS_DIR}/${model}" -m "${filter}"
    else
        "${RUNNER}" --executable "${MODELS_DIR}/${model}"
    fi
done

echo "=== Running help tests (on bare executable: ${distributed_systemfile_EXE} ) ==="
"${RUNNER}" --executable "${distributed_systemfile_EXE}" -m help

echo "=== Running ssl tests (bare executable, network download) ==="
${RUNNER} --executable "${distributed_systemfile_EXE}" -m "ssl and online"

echo "=== Running ssl tests (on bare executable: ${distributed_systemfile_EXE}, model: ${SSL_TEST_MODEL}) ==="
"${RUNNER}" --executable "${distributed_systemfile_EXE}" --model "${SSL_TEST_MODEL}" -m "ssl and not online"
