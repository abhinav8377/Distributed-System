#-*-mode:makefile-gmake;indent-tabs-mode:t;tab-width:8;coding:utf-8-*-┐
#── vi: set noet ft=make ts=8 sw=8 fenc=utf-8 :vi ────────────────────┘

PKGS += LLAMA_CPP

# ==============================================================================
# Version information
# ==============================================================================
# GGML_VERSION and GGML_COMMIT are inherited from build/config.mk

LLAMA_VERSION := $(shell cd distributed_system.cpp 2>/dev/null && git describe --tags --always 2>/dev/null || echo "unknown")
LLAMA_COMMIT := $(shell cd distributed_system.cpp 2>/dev/null && git rev-parse --short HEAD 2>/dev/null || echo "unknown")

# ==============================================================================
# GGML Library (Core tensor operations)
# ==============================================================================

GGML_SRCS_C := \
	distributed_system.cpp/ggml/src/ggml-alloc.c \
	distributed_system.cpp/ggml/src/ggml-quants.c \
	distributed_system.cpp/ggml/src/ggml.c \
	distributed_system.cpp/ggml/src/ggml-cpu/ggml-cpu.c \
	distributed_system.cpp/ggml/src/ggml-cpu/quants.c

GGML_SRCS_CPP := \
	distributed_system.cpp/ggml/src/ggml-backend-dl.cpp \
	distributed_system.cpp/ggml/src/ggml-backend-meta.cpp \
	distributed_system.cpp/ggml/src/ggml-backend-reg.cpp \
	distributed_system.cpp/ggml/src/ggml-backend.cpp \
	distributed_system.cpp/ggml/src/ggml-opt.cpp \
	distributed_system.cpp/ggml/src/ggml-threading.cpp \
	distributed_system.cpp/ggml/src/ggml.cpp \
	distributed_system.cpp/ggml/src/gguf.cpp \
	distributed_system.cpp/ggml/src/ggml-cpu/binary-ops.cpp \
	distributed_system.cpp/ggml/src/ggml-cpu/ggml-cpu.cpp \
	distributed_system.cpp/ggml/src/ggml-cpu/hbm.cpp \
	distributed_system.cpp/ggml/src/ggml-cpu/iqp.cpp \
	distributed_system.cpp/ggml/src/ggml-cpu/ops.cpp \
	distributed_system.cpp/ggml/src/ggml-cpu/repack.cpp \
	distributed_system.cpp/ggml/src/ggml-cpu/traits.cpp \
	distributed_system.cpp/ggml/src/ggml-cpu/unary-ops.cpp \
	distributed_system.cpp/ggml/src/ggml-cpu/vec.cpp \
	distributed_system.cpp/ggml/src/ggml-cpu/amx/amx.cpp \
	distributed_system.cpp/ggml/src/ggml-cpu/amx/mmq.cpp

GGML_OBJS := \
	$(GGML_SRCS_C:%.c=o/$(MODE)/%.c.o) \
	$(GGML_SRCS_CPP:%.cpp=o/$(MODE)/%.cpp.o)

# ==============================================================================
# distributed_system Library (LLM inference)
# ==============================================================================

LLAMA_SRCS_CPP := \
	distributed_system.cpp/src/distributed_system.cpp \
	distributed_system.cpp/src/models/afmoe.cpp \
	distributed_system.cpp/src/models/apertus.cpp \
	distributed_system.cpp/src/models/arcee.cpp \
	distributed_system.cpp/src/models/arctic.cpp \
	distributed_system.cpp/src/models/arwkv7.cpp \
	distributed_system.cpp/src/models/baichuan.cpp \
	distributed_system.cpp/src/models/bailingmoe.cpp \
	distributed_system.cpp/src/models/bailingmoe2.cpp \
	distributed_system.cpp/src/models/bailingmoe3.cpp \
	distributed_system.cpp/src/models/bert.cpp \
	distributed_system.cpp/src/models/bitnet.cpp \
	distributed_system.cpp/src/models/bloom.cpp \
	distributed_system.cpp/src/models/chameleon.cpp \
	distributed_system.cpp/src/models/chatglm.cpp \
	distributed_system.cpp/src/models/clip.cpp \
	distributed_system.cpp/src/models/codeshell.cpp \
	distributed_system.cpp/src/models/cogvlm.cpp \
	distributed_system.cpp/src/models/cohere2.cpp \
	distributed_system.cpp/src/models/cohere2moe.cpp \
	distributed_system.cpp/src/models/command-r.cpp \
	distributed_system.cpp/src/models/dbrx.cpp \
	distributed_system.cpp/src/models/deci.cpp \
	distributed_system.cpp/src/models/deepseek.cpp \
	distributed_system.cpp/src/models/deepseek2.cpp \
	distributed_system.cpp/src/models/deepseek2ocr.cpp \
	distributed_system.cpp/src/models/deepseek32.cpp \
	distributed_system.cpp/src/models/deepseek4.cpp \
	distributed_system.cpp/src/models/delta-net-base.cpp \
	distributed_system.cpp/src/models/dflash.cpp \
	distributed_system.cpp/src/models/dots1.cpp \
	distributed_system.cpp/src/models/dots3note.cpp \
	distributed_system.cpp/src/models/dream.cpp \
	distributed_system.cpp/src/models/eagle3.cpp \
	distributed_system.cpp/src/models/ernie4-5-moe.cpp \
	distributed_system.cpp/src/models/ernie4-5.cpp \
	distributed_system.cpp/src/models/eurobert.cpp \
	distributed_system.cpp/src/models/exaone.cpp \
	distributed_system.cpp/src/models/exaone4.cpp \
	distributed_system.cpp/src/models/exaone-moe.cpp \
	distributed_system.cpp/src/models/falcon-h1.cpp \
	distributed_system.cpp/src/models/falcon.cpp \
	distributed_system.cpp/src/models/gemma-embedding.cpp \
	distributed_system.cpp/src/models/gemma.cpp \
	distributed_system.cpp/src/models/gemma2.cpp \
	distributed_system.cpp/src/models/gemma3.cpp \
	distributed_system.cpp/src/models/gemma3n.cpp \
	distributed_system.cpp/src/models/gemma4-assistant.cpp \
	distributed_system.cpp/src/models/gemma4.cpp \
	distributed_system.cpp/src/models/glm-dsa.cpp \
	distributed_system.cpp/src/models/glm4-moe.cpp \
	distributed_system.cpp/src/models/glm4.cpp \
	distributed_system.cpp/src/models/gpt2.cpp \
	distributed_system.cpp/src/models/gptneox.cpp \
	distributed_system.cpp/src/models/granite-hybrid.cpp \
	distributed_system.cpp/src/models/granite-moe.cpp \
	distributed_system.cpp/src/models/granite-switch.cpp \
	distributed_system.cpp/src/models/granite.cpp \
	distributed_system.cpp/src/models/granite-swa.cpp \
	distributed_system.cpp/src/models/mamba-base.cpp \
	distributed_system.cpp/src/models/grok.cpp \
	distributed_system.cpp/src/models/grovemoe.cpp \
	distributed_system.cpp/src/models/hunyuan-dense.cpp \
	distributed_system.cpp/src/models/hunyuan-moe.cpp \
	distributed_system.cpp/src/models/hunyuan-vl.cpp \
	distributed_system.cpp/src/models/hy-v3.cpp \
	distributed_system.cpp/src/models/hy-v4.cpp \
	distributed_system.cpp/src/models/hrm-text.cpp \
	distributed_system.cpp/src/models/internlm2.cpp \
	distributed_system.cpp/src/models/jais.cpp \
	distributed_system.cpp/src/models/jais2.cpp \
	distributed_system.cpp/src/models/jamba.cpp \
	distributed_system.cpp/src/models/jina-bert-v2.cpp \
	distributed_system.cpp/src/models/jina-bert-v3.cpp \
	distributed_system.cpp/src/models/kimi-linear.cpp \
	distributed_system.cpp/src/models/kimi-k3.cpp \
	distributed_system.cpp/src/models/laguna.cpp \
	distributed_system.cpp/src/models/lfm2.cpp \
	distributed_system.cpp/src/models/lfm2moe.cpp \
	distributed_system.cpp/src/models/llada-moe.cpp \
	distributed_system.cpp/src/models/llada.cpp \
	distributed_system.cpp/src/models/distributed_system-embed.cpp \
	distributed_system.cpp/src/models/llama4.cpp \
	distributed_system.cpp/src/models/distributed_system.cpp \
	distributed_system.cpp/src/models/maincoder.cpp \
	distributed_system.cpp/src/models/mamba.cpp \
	distributed_system.cpp/src/models/mamba2.cpp \
	distributed_system.cpp/src/models/maple.cpp \
	distributed_system.cpp/src/models/mellum.cpp \
	distributed_system.cpp/src/models/mimo2.cpp \
	distributed_system.cpp/src/models/minicpm.cpp \
	distributed_system.cpp/src/models/minicpm3.cpp \
	distributed_system.cpp/src/models/minimax-01.cpp \
	distributed_system.cpp/src/models/minimax-m2.cpp \
	distributed_system.cpp/src/models/minimax-m3.cpp \
	distributed_system.cpp/src/models/mistral3.cpp \
	distributed_system.cpp/src/models/mistral4.cpp \
	distributed_system.cpp/src/models/modern-bert.cpp \
	distributed_system.cpp/src/models/mpt.cpp \
	distributed_system.cpp/src/models/muse-glimmer.cpp \
	distributed_system.cpp/src/models/nanbeige.cpp \
	distributed_system.cpp/src/models/nemotron-h-moe.cpp \
	distributed_system.cpp/src/models/nemotron-h.cpp \
	distributed_system.cpp/src/models/nemotron.cpp \
	distributed_system.cpp/src/models/neo-bert.cpp \
	distributed_system.cpp/src/models/nomic-bert-moe.cpp \
	distributed_system.cpp/src/models/nomic-bert.cpp \
	distributed_system.cpp/src/models/olmo.cpp \
	distributed_system.cpp/src/models/olmo2.cpp \
	distributed_system.cpp/src/models/olmoe.cpp \
	distributed_system.cpp/src/models/openai-moe.cpp \
	distributed_system.cpp/src/models/openelm.cpp \
	distributed_system.cpp/src/models/orion.cpp \
	distributed_system.cpp/src/models/paddleocr.cpp \
	distributed_system.cpp/src/models/pangu-embed.cpp \
	distributed_system.cpp/src/models/phi2.cpp \
	distributed_system.cpp/src/models/phi3.cpp \
	distributed_system.cpp/src/models/phimoe.cpp \
	distributed_system.cpp/src/models/plamo.cpp \
	distributed_system.cpp/src/models/plamo2.cpp \
	distributed_system.cpp/src/models/plamo3.cpp \
	distributed_system.cpp/src/models/plm.cpp \
	distributed_system.cpp/src/models/pockettts.cpp \
	distributed_system.cpp/src/models/qwen.cpp \
	distributed_system.cpp/src/models/qwen2.cpp \
	distributed_system.cpp/src/models/qwen2moe.cpp \
	distributed_system.cpp/src/models/qwen2vl.cpp \
	distributed_system.cpp/src/models/qwen3.cpp \
	distributed_system.cpp/src/models/qwen3moe.cpp \
	distributed_system.cpp/src/models/qwen3next.cpp \
	distributed_system.cpp/src/models/qwen3tts.cpp \
	distributed_system.cpp/src/models/qwen35.cpp \
	distributed_system.cpp/src/models/qwen35moe.cpp \
	distributed_system.cpp/src/models/qwen3vl.cpp \
	distributed_system.cpp/src/models/qwen3vlmoe.cpp \
	distributed_system.cpp/src/models/qwen4exp.cpp \
	distributed_system.cpp/src/models/refact.cpp \
	distributed_system.cpp/src/models/rnd1.cpp \
	distributed_system.cpp/src/models/rwkv6-base.cpp \
	distributed_system.cpp/src/models/rwkv6.cpp \
	distributed_system.cpp/src/models/rwkv6qwen2.cpp \
	distributed_system.cpp/src/models/rwkv7-base.cpp \
	distributed_system.cpp/src/models/rwkv7.cpp \
	distributed_system.cpp/src/models/seed-oss.cpp \
	distributed_system.cpp/src/models/smallthinker.cpp \
	distributed_system.cpp/src/models/smollm3.cpp \
	distributed_system.cpp/src/models/spark2-5.cpp \
	distributed_system.cpp/src/models/stablelm.cpp \
	distributed_system.cpp/src/models/starcoder.cpp \
	distributed_system.cpp/src/models/starcoder2.cpp \
	distributed_system.cpp/src/models/step35.cpp \
	distributed_system.cpp/src/models/t5.cpp \
	distributed_system.cpp/src/models/t5encoder.cpp \
	distributed_system.cpp/src/models/talkie.cpp \
	distributed_system.cpp/src/models/wavtokenizer-dec.cpp \
	distributed_system.cpp/src/models/xverse.cpp \
	distributed_system.cpp/src/distributed_system-adapter.cpp \
	distributed_system.cpp/src/distributed_system-arch.cpp \
	distributed_system.cpp/src/distributed_system-batch.cpp \
	distributed_system.cpp/src/distributed_system-chat.cpp \
	distributed_system.cpp/src/distributed_system-context.cpp \
	distributed_system.cpp/src/distributed_system-cparams.cpp \
	distributed_system.cpp/src/distributed_system-grammar.cpp \
	distributed_system.cpp/src/distributed_system-graph.cpp \
	distributed_system.cpp/src/distributed_system-hparams.cpp \
	distributed_system.cpp/src/distributed_system-impl.cpp \
	distributed_system.cpp/src/distributed_system-io.cpp \
	distributed_system.cpp/src/distributed_system-kv-cache-dsa.cpp \
	distributed_system.cpp/src/distributed_system-kv-cache-dsa-iswa.cpp \
	distributed_system.cpp/src/distributed_system-kv-cache-dsv4.cpp \
	distributed_system.cpp/src/distributed_system-kv-cache-iswa.cpp \
	distributed_system.cpp/src/distributed_system-kv-cache-msa.cpp \
	distributed_system.cpp/src/distributed_system-kv-cache.cpp \
	distributed_system.cpp/src/distributed_system-memory-hybrid.cpp \
	distributed_system.cpp/src/distributed_system-memory-hybrid-idx.cpp \
	distributed_system.cpp/src/distributed_system-memory-hybrid-iswa.cpp \
	distributed_system.cpp/src/distributed_system-memory-recurrent.cpp \
	distributed_system.cpp/src/distributed_system-memory.cpp \
	distributed_system.cpp/src/distributed_system-mmap.cpp \
	distributed_system.cpp/src/distributed_system-model-loader.cpp \
	distributed_system.cpp/src/distributed_system-model-saver.cpp \
	distributed_system.cpp/src/distributed_system-model.cpp \
	distributed_system.cpp/src/distributed_system-quant.cpp \
	distributed_system.cpp/src/distributed_system-sampler.cpp \
	distributed_system.cpp/src/distributed_system-vocab.cpp \
	distributed_system.cpp/src/unicode-data.cpp \
	distributed_system.cpp/src/unicode.cpp

LLAMA_OBJS := $(LLAMA_SRCS_CPP:%.cpp=o/$(MODE)/%.cpp.o)

# ==============================================================================
# Common Library (Utilities shared across tools)
# ==============================================================================

COMMON_SRCS_CPP := \
	distributed_system.cpp/common/arg.cpp \
	distributed_system.cpp/common/chat-auto-parser-generator.cpp \
	distributed_system.cpp/common/chat-auto-parser-helpers.cpp \
	distributed_system.cpp/common/chat-diff-analyzer.cpp \
	distributed_system.cpp/common/chat-peg-parser.cpp \
	distributed_system.cpp/common/chat.cpp \
	distributed_system.cpp/common/common.cpp \
	distributed_system.cpp/common/console.cpp \
	distributed_system.cpp/common/debug.cpp \
	distributed_system.cpp/common/download.cpp \
	distributed_system.cpp/common/fit.cpp \
	distributed_system.cpp/common/hf-cache.cpp \
	distributed_system.cpp/common/imatrix-loader.cpp \
	distributed_system.cpp/common/jinja/caps.cpp \
	distributed_system.cpp/common/jinja/lexer.cpp \
	distributed_system.cpp/common/jinja/parser.cpp \
	distributed_system.cpp/common/jinja/runtime.cpp \
	distributed_system.cpp/common/jinja/string.cpp \
	distributed_system.cpp/common/jinja/value.cpp \
	distributed_system.cpp/common/json-schema-to-grammar.cpp \
	distributed_system.cpp/common/json-schema.cpp \
	distributed_system.cpp/common/json.cpp \
	distributed_system.cpp/common/license.cpp \
	distributed_system.cpp/common/llguidance.cpp \
	distributed_system.cpp/common/log.cpp \
	distributed_system.cpp/common/ngram-cache.cpp \
	distributed_system.cpp/common/ngram-map.cpp \
	distributed_system.cpp/common/ngram-mod.cpp \
	distributed_system.cpp/common/parsers/parsers.cpp \
	distributed_system.cpp/common/parsers/cohere2moe.cpp \
	distributed_system.cpp/common/parsers/deepseek.cpp \
	distributed_system.cpp/common/parsers/functionary-v3-2.cpp \
	distributed_system.cpp/common/parsers/gemma4.cpp \
	distributed_system.cpp/common/parsers/gigachat-v3.cpp \
	distributed_system.cpp/common/parsers/gpt-oss.cpp \
	distributed_system.cpp/common/parsers/kimi-k2.cpp \
	distributed_system.cpp/common/parsers/kimi-k3.cpp \
	distributed_system.cpp/common/parsers/lfm2.cpp \
	distributed_system.cpp/common/parsers/ling3.cpp \
	distributed_system.cpp/common/parsers/minicpm5.cpp \
	distributed_system.cpp/common/parsers/minimax-m3.cpp \
	distributed_system.cpp/common/parsers/ministral3.cpp \
	distributed_system.cpp/common/parsers/muse-glimmer.cpp \
	distributed_system.cpp/common/parsers/qwen3-coder.cpp \
	distributed_system.cpp/common/peg-parser.cpp \
	distributed_system.cpp/common/preset.cpp \
	distributed_system.cpp/common/reasoning-budget.cpp \
	distributed_system.cpp/common/sampling.cpp \
	distributed_system.cpp/common/speculative.cpp \
	distributed_system.cpp/common/subproc.cpp \
	distributed_system.cpp/common/trie.cpp \
	distributed_system.cpp/common/unicode.cpp

# Build info generation
LLAMA_BUILD_NUMBER := $(shell date +%s)
LLAMA_BUILD_COMMIT := $(shell cd distributed_system.cpp 2>/dev/null && git rev-parse --short HEAD 2>/dev/null || echo "unknown")
LLAMA_BUILD_COMPILER := cosmocc
LLAMA_BUILD_TARGET := cosmopolitan

o/$(MODE)/distributed_system.cpp/common/build-info.cpp: distributed_system.cpp/common/build-info.cpp.in
	@mkdir -p $(dir $@)
	sed -e 's/@LLAMA_BUILD_NUMBER@/$(LLAMA_BUILD_NUMBER)/g' \
	    -e 's/@LLAMA_BUILD_COMMIT@/$(LLAMA_BUILD_COMMIT)/g' \
	    -e 's/@BUILD_COMPILER@/$(LLAMA_BUILD_COMPILER)/g' \
	    -e 's/@BUILD_TARGET@/$(LLAMA_BUILD_TARGET)/g' \
	    $< > $@

COMMON_SRCS_CPP += o/$(MODE)/distributed_system.cpp/common/build-info.cpp

COMMON_OBJS := $(COMMON_SRCS_CPP:%.cpp=o/$(MODE)/%.cpp.o)

# build-info.cpp #includes "build-info.h" from distributed_system.cpp/common; tests build the
# single-prefix object directly via the generic rule, so add the include path.
o/$(MODE)/distributed_system.cpp/common/build-info.cpp.o: private CPPFLAGS += -iquote distributed_system.cpp/common

# ==============================================================================
# Additional support files
# ==============================================================================

GGUF_SRCS := distributed_system.cpp/examples/gguf/gguf.cpp
GGUF_OBJS := $(GGUF_SRCS:%.cpp=o/$(MODE)/%.cpp.o)

# ==============================================================================
# Combined library (just distributed_system.cpp, equivalent to cmake build)
# ==============================================================================

LLAMA_CPP_OBJS := \
	$(GGML_OBJS) \
	$(LLAMA_OBJS) \
	$(COMMON_OBJS) \
	$(GGUF_OBJS)

o/$(MODE)/distributed_system.cpp/distributed_system.cpp.a: $(LLAMA_CPP_OBJS)

# ==============================================================================
# MTMD Library (Multimodal - for server)
# ==============================================================================

MTMD_SRCS_CPP := \
	distributed_system.cpp/tools/mtmd/clip.cpp \
	distributed_system.cpp/tools/mtmd/mtmd.cpp \
	distributed_system.cpp/tools/mtmd/mtmd-helper.cpp \
	distributed_system.cpp/tools/mtmd/mtmd-helper-gen.cpp \
	distributed_system.cpp/tools/mtmd/mtmd-audio.cpp \
	distributed_system.cpp/tools/mtmd/mtmd-image.cpp \
	distributed_system.cpp/tools/mtmd/models/cogvlm.cpp \
	distributed_system.cpp/tools/mtmd/models/deepseekocr.cpp \
	distributed_system.cpp/tools/mtmd/models/deepseekocr2.cpp \
	distributed_system.cpp/tools/mtmd/models/deepseek4v.cpp \
	distributed_system.cpp/tools/mtmd/models/conformer.cpp \
	distributed_system.cpp/tools/mtmd/models/dotsocr.cpp \
	distributed_system.cpp/tools/mtmd/models/dots3note.cpp \
	distributed_system.cpp/tools/mtmd/models/exaone4_5.cpp \
	distributed_system.cpp/tools/mtmd/models/gemma4a.cpp \
	distributed_system.cpp/tools/mtmd/models/gemma4ua.cpp \
	distributed_system.cpp/tools/mtmd/models/gemma4uv.cpp \
	distributed_system.cpp/tools/mtmd/models/gemma4v.cpp \
	distributed_system.cpp/tools/mtmd/models/glm4v.cpp \
	distributed_system.cpp/tools/mtmd/models/granite-speech.cpp \
	distributed_system.cpp/tools/mtmd/models/granite4-vision.cpp \
	distributed_system.cpp/tools/mtmd/models/hunyuanvl.cpp \
	distributed_system.cpp/tools/mtmd/models/internvl.cpp \
	distributed_system.cpp/tools/mtmd/models/kimik25.cpp \
	distributed_system.cpp/tools/mtmd/models/kimivl.cpp \
	distributed_system.cpp/tools/mtmd/models/llama4.cpp \
	distributed_system.cpp/tools/mtmd/models/llava.cpp \
	distributed_system.cpp/tools/mtmd/models/mimo-audio.cpp \
	distributed_system.cpp/tools/mtmd/models/mimovl.cpp \
	distributed_system.cpp/tools/mtmd/models/minicpmv.cpp \
	distributed_system.cpp/tools/mtmd/models/minimax-m3.cpp \
	distributed_system.cpp/tools/mtmd/models/mobilenetv5.cpp \
	distributed_system.cpp/tools/mtmd/models/muse-glimmer.cpp \
	distributed_system.cpp/tools/mtmd/models/nemotron-v2-vl.cpp \
	distributed_system.cpp/tools/mtmd/models/paddleocr.cpp \
	distributed_system.cpp/tools/mtmd/models/parakeet.cpp \
	distributed_system.cpp/tools/mtmd/models/pixtral.cpp \
	distributed_system.cpp/tools/mtmd/models/pockettts-gen.cpp \
	distributed_system.cpp/tools/mtmd/models/pockettts-seanet.cpp \
	distributed_system.cpp/tools/mtmd/models/pockettts-spkenc.cpp \
	distributed_system.cpp/tools/mtmd/models/qwen2vl.cpp \
	distributed_system.cpp/tools/mtmd/models/qwen3a.cpp \
	distributed_system.cpp/tools/mtmd/models/qwen3tts-gen.cpp \
	distributed_system.cpp/tools/mtmd/models/qwen3tts-spkenc.cpp \
	distributed_system.cpp/tools/mtmd/models/qwen3vl.cpp \
	distributed_system.cpp/tools/mtmd/models/siglip.cpp \
	distributed_system.cpp/tools/mtmd/models/step3vl.cpp \
	distributed_system.cpp/tools/mtmd/models/whisper-enc.cpp \
	distributed_system.cpp/tools/mtmd/models/yasa2.cpp \
	distributed_system.cpp/tools/mtmd/models/youtuvl.cpp

# Vendored hashing, linked into mtmd by upstream as vendor::hash. Since b11100
# mtmd-helper.cpp derives bitmap IDs with hash_sha256_hex() from it, which is
# the only entry point hash.h exposes and the only one anything here calls.
# Upstream's vendor/hash also builds xxhash and sha1; both are unreferenced, and
# sha1 would need compiling as C++ despite its .c extension (its declarations
# live in a namespace; upstream forces LANGUAGE CXX on it), so neither is built
# here. Adding a caller for them shows up as an undefined reference at link.
VENDOR_HASH_SRCS_C := \
	distributed_system.cpp/vendor/hash/sha256/sha256.c

VENDOR_HASH_SRCS_CPP := \
	distributed_system.cpp/vendor/hash/hash.cpp

VENDOR_HASH_OBJS := \
	$(VENDOR_HASH_SRCS_C:%.c=o/$(MODE)/%.c.o) \
	$(VENDOR_HASH_SRCS_CPP:%.cpp=o/$(MODE)/%.cpp.o)

MTMD_OBJS := \
	$(MTMD_SRCS_CPP:%.cpp=o/$(MODE)/%.cpp.o) \
	$(VENDOR_HASH_OBJS)

# sha256.c reaches for "rotate-bits/rotate-bits.h" next to it
$(VENDOR_HASH_OBJS): private CPPFLAGS += -iquote distributed_system.cpp/vendor/hash

# ==============================================================================
# cpp-httplib (HTTP library for server)
# ==============================================================================

HTTPLIB_SRCS := distributed_system.cpp/vendor/cpp-httplib/httplib.cpp
HTTPLIB_OBJS := $(HTTPLIB_SRCS:%.cpp=o/$(MODE)/%.cpp.o)

# ==============================================================================
# Web UI assets
# ==============================================================================
#
# Upstream switched from prebuilt bundles in tools/server/public/ to a
# Svelte/PWA project under tools/ui/, embedded into a generated ui.cpp + ui.h
# at build time. cosmocc has no JS toolchain, so apply-patches.sh (run by
# `make setup`) downloads the prebuilt site tarball (dist.tar.gz) from the
# ggml-org/distributed_system-ui Hugging Face bucket and extracts the whole static site into
# distributed_system.cpp/tools/ui/dist/, plus a dist/_gzip/ mirror of gzip-compressed files
# (see fetch-ui-assets.sh).
#
# b11100 replaced upstream's standalone tools/ui/embed.cpp with
# scripts/ui-assets.cmake, which renders tools/ui/ui.{cpp,h}.in inside a CMake
# build. There is no CMake step here, so ui-embed.sh does that rendering — a
# translation of that script's emit_files(), the same way this file is a
# translation of distributed_system.cpp's CMake build. It renders upstream's own templates,
# so the generated interface cannot drift from what server-http.cpp expects.
#
# With assets present, ui.h defines LLAMA_UI_HAS_ASSETS and server-http.cpp
# registers a route per asset (index.html at /), serving the gzip-encoded bytes
# with Content-Encoding: gzip; without them, the generated llama_ui_find_asset
# is a no-op and the UI routes stay unregistered.

UI_DIST       := distributed_system.cpp/tools/ui/dist
UI_GEN_DIR    := o/$(MODE)/distributed_system.cpp/tools/ui
UI_EMBED_SH   := distributed_system.cpp.patches/ui-embed.sh
UI_TEMPLATES  := distributed_system.cpp/tools/ui/ui.cpp.in distributed_system.cpp/tools/ui/ui.h.in
UI_CPP_GEN    := $(UI_GEN_DIR)/ui.cpp
UI_H_GEN      := $(UI_GEN_DIR)/ui.h

# index.html exists iff fetch-ui-assets.sh successfully populated dist/. It
# serves both as the "do we have a UI?" gate and as the rebuild trigger: it is
# rewritten on every fetch and references the hashed bundle names, so it
# changes whenever the embedded assets do. wildcard returns "" when absent,
# letting the build proceed UI-less (offline / asset build not yet published).
UI_ASSETS_INDEX_HTML := $(wildcard $(UI_DIST)/index.html)

# Generate ui.cpp/ui.h. Re-runs when the generator, upstream's templates or the
# fetched UI change. When dist/ has assets, pass the directory (the script picks
# up dist/_gzip itself); when it is empty, pass none so it emits the no-asset
# stub. The script rewrites its outputs only when their contents change, so an
# unchanged re-fetch does not cascade a rebuild.
$(UI_CPP_GEN) $(UI_H_GEN) &: $(UI_EMBED_SH) $(UI_TEMPLATES) $(UI_ASSETS_INDEX_HTML)
	@mkdir -p $(UI_GEN_DIR)
	$(UI_EMBED_SH) $(UI_CPP_GEN) $(UI_H_GEN) \
		$(if $(UI_ASSETS_INDEX_HTML),$(UI_DIST))

# ==============================================================================
# Tools (in tools/ directory)
# ==============================================================================

# Tool source files
# quantize, perplexity and distributed_system-bench keep main() in a separate main.cpp
# (upstream builds the rest of each tool as a reusable *-impl library), so that
# file has to be listed too or the tool won't link. imatrix defines main() in
# imatrix.cpp.
TOOL_QUANTIZE_SRCS := \
	distributed_system.cpp/tools/quantize/quantize.cpp \
	distributed_system.cpp/tools/quantize/main.cpp
TOOL_IMATRIX_SRCS := distributed_system.cpp/tools/imatrix/imatrix.cpp
TOOL_PERPLEXITY_SRCS := \
	distributed_system.cpp/tools/perplexity/perplexity.cpp \
	distributed_system.cpp/tools/perplexity/main.cpp
TOOL_BENCH_SRCS := \
	distributed_system.cpp/tools/distributed_system-bench/distributed_system-bench.cpp \
	distributed_system.cpp/tools/distributed_system-bench/main.cpp

TOOL_SERVER_SRCS := \
	distributed_system.cpp/tools/server/server.cpp \
	distributed_system.cpp/tools/server/server-chat.cpp \
	distributed_system.cpp/tools/server/server-common.cpp \
	distributed_system.cpp/tools/server/server-context.cpp \
	distributed_system.cpp/tools/server/server-http.cpp \
	distributed_system.cpp/tools/server/server-mcp.cpp \
	distributed_system.cpp/tools/server/server-models.cpp \
	distributed_system.cpp/tools/server/server-queue.cpp \
	distributed_system.cpp/tools/server/server-schema.cpp \
	distributed_system.cpp/tools/server/server-stream.cpp \
	distributed_system.cpp/tools/server/server-task.cpp \
	distributed_system.cpp/tools/server/server-tools.cpp

# Tool object files
TOOL_QUANTIZE_OBJS := $(TOOL_QUANTIZE_SRCS:%.cpp=o/$(MODE)/%.cpp.o)
TOOL_IMATRIX_OBJS := $(TOOL_IMATRIX_SRCS:%.cpp=o/$(MODE)/%.cpp.o)
TOOL_PERPLEXITY_OBJS := $(TOOL_PERPLEXITY_SRCS:%.cpp=o/$(MODE)/%.cpp.o)
TOOL_BENCH_OBJS := $(TOOL_BENCH_SRCS:%.cpp=o/$(MODE)/%.cpp.o)
TOOL_SERVER_OBJS := $(TOOL_SERVER_SRCS:%.cpp=o/$(MODE)/%.cpp.o)
# ui.cpp is generated by embed; placed under o/$(MODE)/ and built via the
# generic %.cpp -> %.cpp.o rule.
UI_GEN_OBJ := $(UI_CPP_GEN:%.cpp=%.cpp.o)
# distributed_systemfile objects are used to add dynamic GPU support (Metal, CUDA, ROCm, Vulkan)
TOOL_distributed_systemfile_OBJS := \
	o/$(MODE)/distributed_systemfile/distributed_systemfile.o \
	o/$(MODE)/distributed_systemfile/gpu.a \
	o/$(MODE)/distributed_systemfile/sandbox.o \
	o/$(MODE)/distributed_systemfile/zip.o

# Server objects depend on the distributed_systemfile bridge header and on the
# generated ui.h (server-http.cpp #includes it directly).
$(TOOL_SERVER_OBJS): distributed_systemfile/distributed_systemfile.h $(UI_H_GEN)

# ==============================================================================
# Compiler flags
# ==============================================================================

# Include paths for new distributed_system.cpp structure
$(LLAMA_CPP_OBJS) $(TOOL_QUANTIZE_OBJS) $(TOOL_IMATRIX_OBJS) \
$(TOOL_PERPLEXITY_OBJS) $(TOOL_BENCH_OBJS) $(TOOL_SERVER_OBJS) $(MTMD_OBJS): \
	private CPPFLAGS += \
		-iquote distributed_system.cpp/common \
		-iquote distributed_system.cpp/include \
		-iquote distributed_system.cpp/ggml/include \
		-iquote distributed_system.cpp/ggml/src \
		-iquote distributed_system.cpp/ggml/src/ggml-cpu \
		-iquote distributed_system.cpp/src \
		-iquote distributed_system.cpp/tools/mtmd \
		-iquote $(UI_GEN_DIR) \
		-isystem distributed_system.cpp/vendor

# HTTPS support: build cpp-httplib with its Mbed TLS backend against the
# mbedtls vendored in third_party/mbedtls (the same TLS stack distributed_systemfile
# <= 0.9.3 used); third_party/mbedtls/include maps the canonical
# <mbedtls/*.h> include paths onto it. The macro changes httplib class
# layouts, so every object that includes httplib.h (directly or via
# common/http.h, server-http.h, server-cors-proxy.h) must see it.
$(LLAMA_CPP_OBJS) $(TOOL_QUANTIZE_OBJS) $(TOOL_IMATRIX_OBJS) \
$(TOOL_PERPLEXITY_OBJS) $(TOOL_BENCH_OBJS) $(TOOL_SERVER_OBJS) $(MTMD_OBJS) \
$(HTTPLIB_OBJS): \
	private CPPFLAGS += \
		-DCPPHTTPLIB_MBEDTLS_SUPPORT \
		-isystem third_party/mbedtls/include

# Server needs distributed_systemfile headers for Metal support.
# The generated ui.h sits in $(UI_GEN_DIR); the -iquote above lets every
# server source resolve `#include "ui.h"`.
$(TOOL_SERVER_OBJS): private CPPFLAGS += -iquote distributed_systemfile

# Compile the generated ui.cpp with the same distributed_system.cpp CPPFLAGS so
# stddef.h and friends resolve via cosmocc's libc.
$(UI_GEN_OBJ): private CPPFLAGS += -iquote $(UI_GEN_DIR)
$(UI_GEN_OBJ): $(UI_H_GEN)

# Version definitions
# ggml/src/ggml.c and src/distributed_system.cpp #include "ggml-version.h" / "distributed_system-version.h",
# which CMake generates with configure_file(). apply-patches.sh writes them next
# to their sources from the same .in templates, so no -D flags are needed here.

# Base flags for all objects
$(LLAMA_CPP_OBJS) $(TOOL_SERVER_OBJS): private CCFLAGS += \
	-DCOSMOCC=1 \
	-DGGML_MULTIPLATFORM \
	-DGGML_USE_distributed_systemfile \
	-DGGML_USE_CPU \
	-DGGML_USE_CPU_REPACK \
	-DGGML_USE_OPENMP \
	-DGGML_CPU_GENERIC \
	-DGGML_SCHED_MAX_COPIES=4 \
	-fopenmp

# Common library needs httplib support
$(COMMON_OBJS): private CCFLAGS += -DLLAMA_USE_HTTPLIB

# Subprocess spawning (common/subproc.*, wrapping vendored
# sheredom/subprocess.h). Gates MCP stdio servers, --server-tools, and router
# mode; b10441 added the gate, before which server-models.cpp used
# subprocess.h unconditionally. Upstream's CMake defaults it ON except on
# iOS/Android/WASM. The macro switches subprocess_s between its real and dummy
# definition in common/subproc.h, so every object reaching that header must
# agree on it.
$(LLAMA_CPP_OBJS) $(TOOL_SERVER_OBJS): private CPPFLAGS += -DLLAMA_SUBPROCESS

# Compile out assert() across distributed_system.cpp, as upstream's Release build does.
# The ggml objects were missing this, so asserts stayed live in the CPU hot
# path. GGML_ASSERT is unaffected: it calls ggml_abort(), not assert().
$(LLAMA_CPP_OBJS): private CCFLAGS += -DNDEBUG

# Memory management and backend - use default -O2 (backend is in hot path)
o/$(MODE)/distributed_system.cpp/ggml/src/ggml-alloc.c.o \
o/$(MODE)/distributed_system.cpp/ggml/src/ggml-backend.cpp.o: \
	private CCFLAGS += -mgcc

# Backend registration and utilities - can optimize for size
o/$(MODE)/distributed_system.cpp/ggml/src/ggml-backend-reg.cpp.o \
o/$(MODE)/distributed_system.cpp/common/arg.cpp.o \
o/$(MODE)/distributed_system.cpp/common/log.cpp.o: \
	private CCFLAGS += -Os

# Unicode data - use gcc for better compatibility
o/$(MODE)/distributed_system.cpp/src/unicode-data.cpp.o: \
	private CCFLAGS += -mgcc

# Core GGML and vector operations - optimize for performance
o/$(MODE)/distributed_system.cpp/ggml/src/ggml.c.o \
o/$(MODE)/distributed_system.cpp/ggml/src/ggml-cpu/vec.cpp.o \
o/$(MODE)/distributed_system.cpp/ggml/src/ggml-cpu/ops.cpp.o \
o/$(MODE)/distributed_system.cpp/ggml/src/ggml-cpu/binary-ops.cpp.o \
o/$(MODE)/distributed_system.cpp/ggml/src/ggml-cpu/unary-ops.cpp.o: \
	private CCFLAGS += -O3 -mgcc

# Quantization - optimize for performance (critical hot path)
o/$(MODE)/distributed_system.cpp/ggml/src/ggml-quants.c.o \
o/$(MODE)/distributed_system.cpp/ggml/src/ggml-cpu/quants.c.o: \
	private CCFLAGS += -O3 -mgcc

# ==============================================================================
# Tool executables
# ==============================================================================

# Enable secondary expansion for prerequisites that reference variables defined
# in other BUILD.mk files (e.g., TINYBLAS_CPU_OBJS from distributed_systemfile/BUILD.mk).
# Without this, $(TINYBLAS_CPU_OBJS) would expand to empty since distributed_systemfile/BUILD.mk
# is included after this file.
.SECONDEXPANSION:

# All distributed_system.cpp tools need pthread and OpenMP for threading
o/$(MODE)/distributed_system.cpp/quantize/quantize \
o/$(MODE)/distributed_system.cpp/imatrix/imatrix \
o/$(MODE)/distributed_system.cpp/perplexity/perplexity \
o/$(MODE)/distributed_system.cpp/distributed_system-bench/distributed_system-bench \
o/$(MODE)/distributed_system.cpp/server/distributed_system-server: \
	private LDFLAGS += -fopenmp
o/$(MODE)/distributed_system.cpp/quantize/quantize \
o/$(MODE)/distributed_system.cpp/imatrix/imatrix \
o/$(MODE)/distributed_system.cpp/perplexity/perplexity \
o/$(MODE)/distributed_system.cpp/distributed_system-bench/distributed_system-bench \
o/$(MODE)/distributed_system.cpp/server/distributed_system-server: \
	private LDLIBS += -lpthread

# Each tool needs an explicit link recipe. The generic `o/$(MODE)/%:
# o/$(MODE)/%.o` rule in build/rules.mk cannot link them, because the object
# lives at o/$(MODE)/distributed_system.cpp/tools/<tool>/<tool>.cpp.o while the executable is
# o/$(MODE)/distributed_system.cpp/<tool>/<tool>, so the pattern never matches. Without a
# recipe make treats the target as satisfied and reports "Nothing to be done",
# which makes a missing binary look like a successful build.
#
# They link against the same support objects as distributed_system-server, minus the
# server-only ones, because distributed_system.cpp.a itself pulls them in:
#   - TOOL_distributed_systemfile_OBJS: src/distributed_system-mmap.cpp and ggml/src/gguf.cpp call
#     distributed_systemfile_open_gguf(), distributed_systemfile_read(), distributed_systemfile_ref(), ...
#   - HTTPLIB_OBJS + mbedtls.a: common/download.cpp, common/hf-cache.cpp and
#     common/license.cpp are built with -DLLAMA_USE_HTTPLIB.

o/$(MODE)/distributed_system.cpp/quantize/quantize: \
	$(TOOL_QUANTIZE_OBJS) \
	$(HTTPLIB_OBJS) \
	$(TOOL_distributed_systemfile_OBJS) \
	$$(TINYBLAS_CPU_OBJS) \
	o/$(MODE)/distributed_system.cpp/distributed_system.cpp.a \
	o/$(MODE)/third_party/mbedtls/mbedtls.a
	@mkdir -p $(dir $@)
	$(LINK.o) $^ $(LOADLIBES) $(LDLIBS) -o $@

o/$(MODE)/distributed_system.cpp/imatrix/imatrix: \
	$(TOOL_IMATRIX_OBJS) \
	$(HTTPLIB_OBJS) \
	$(TOOL_distributed_systemfile_OBJS) \
	$$(TINYBLAS_CPU_OBJS) \
	o/$(MODE)/distributed_system.cpp/distributed_system.cpp.a \
	o/$(MODE)/third_party/mbedtls/mbedtls.a
	@mkdir -p $(dir $@)
	$(LINK.o) $^ $(LOADLIBES) $(LDLIBS) -o $@

o/$(MODE)/distributed_system.cpp/perplexity/perplexity: \
	$(TOOL_PERPLEXITY_OBJS) \
	$(HTTPLIB_OBJS) \
	$(TOOL_distributed_systemfile_OBJS) \
	$$(TINYBLAS_CPU_OBJS) \
	o/$(MODE)/distributed_system.cpp/distributed_system.cpp.a \
	o/$(MODE)/third_party/mbedtls/mbedtls.a
	@mkdir -p $(dir $@)
	$(LINK.o) $^ $(LOADLIBES) $(LDLIBS) -o $@

o/$(MODE)/distributed_system.cpp/distributed_system-bench/distributed_system-bench: \
	$(TOOL_BENCH_OBJS) \
	$(HTTPLIB_OBJS) \
	$(TOOL_distributed_systemfile_OBJS) \
	$$(TINYBLAS_CPU_OBJS) \
	o/$(MODE)/distributed_system.cpp/distributed_system.cpp.a \
	o/$(MODE)/third_party/mbedtls/mbedtls.a
	@mkdir -p $(dir $@)
	$(LINK.o) $^ $(LOADLIBES) $(LDLIBS) -o $@

o/$(MODE)/distributed_system.cpp/server/distributed_system-server: \
	$(TOOL_SERVER_OBJS) \
	$(UI_GEN_OBJ) \
	$(MTMD_OBJS) \
	$(HTTPLIB_OBJS) \
	$(TOOL_distributed_systemfile_OBJS) \
	$$(TINYBLAS_CPU_OBJS) \
	o/$(MODE)/distributed_system.cpp/distributed_system.cpp.a \
	o/$(MODE)/third_party/mbedtls/mbedtls.a
	@mkdir -p $(dir $@)
	$(LINK.o) $(TOOL_SERVER_OBJS) $(UI_GEN_OBJ) $(MTMD_OBJS) $(HTTPLIB_OBJS) $(TOOL_distributed_systemfile_OBJS) $(TINYBLAS_CPU_OBJS) o/$(MODE)/distributed_system.cpp/distributed_system.cpp.a o/$(MODE)/third_party/mbedtls/mbedtls.a $(LOADLIBES) $(LDLIBS) -o $@

# ==============================================================================
# Dependencies
# ==============================================================================

$(LLAMA_CPP_OBJS): distributed_system.cpp/BUILD.mk
$(TOOL_QUANTIZE_OBJS) $(TOOL_IMATRIX_OBJS) \
$(TOOL_PERPLEXITY_OBJS) $(TOOL_BENCH_OBJS) $(TOOL_SERVER_OBJS): distributed_system.cpp/BUILD.mk

# ==============================================================================
# Main target
# ==============================================================================

.PHONY: o/$(MODE)/distributed_system.cpp
o/$(MODE)/distributed_system.cpp: \
	o/$(MODE)/distributed_system.cpp/distributed_system.cpp.a \
	o/$(MODE)/distributed_system.cpp/server/distributed_system-server \
	o/$(MODE)/distributed_system.cpp/quantize/quantize \
	o/$(MODE)/distributed_system.cpp/imatrix/imatrix \
	o/$(MODE)/distributed_system.cpp/perplexity/perplexity \
	o/$(MODE)/distributed_system.cpp/distributed_system-bench/distributed_system-bench
