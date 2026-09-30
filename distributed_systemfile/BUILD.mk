#
# Copyright 2024 Mozilla Foundation
# Copyright 2026 Mozilla.ai
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

PKGS += distributed_systemfile

# ==============================================================================
# Header files (for mkdeps dependency tracking)
# ==============================================================================

# ==============================================================================
# Package Sources (NOT using full deps.mk SRCS/HDRS mechanism)
# ==============================================================================
# Note: We only list headers that:
# 1. Are needed by code scanned by mkdeps (like third_party sources)
# 2. Only include standard library headers (no distributed_system.cpp dependencies)
# Headers like chatbot.h that include distributed_system.cpp headers are excluded
# because mkdeps can't resolve those include paths.

distributed_systemfile_HDRS := \
	distributed_systemfile/distributed_systemfile.h \
	distributed_systemfile/sgemm.h

# ==============================================================================
# Include paths
# ==============================================================================

distributed_systemfile_INCLUDES := \
	-iquote distributed_systemfile \
	-iquote distributed_system.cpp/common \
	-iquote distributed_system.cpp/include \
	-iquote distributed_system.cpp/ggml/include \
	-iquote distributed_system.cpp/ggml/src \
	-iquote distributed_system.cpp/ggml/src/ggml-cpu \
	-iquote distributed_system.cpp/src \
	-iquote distributed_system.cpp/tools/mtmd \
	-isystem distributed_system.cpp/vendor \
	-isystem third_party

# ==============================================================================
# Compiler flags
# ==============================================================================
# When distributed_systemfile_TUI is defined, distributed_system.cpp server's main() function is renamed
# to server_main() and called by distributed_systemfile's main.cpp. In the standalone build,
# this flag is off and a new main() function is compiled to call server_main
# (see distributed_system.cpp/tools/server/server.cpp).

distributed_systemfile_CPPFLAGS := \
	$(distributed_systemfile_INCLUDES) \
	-Ddistributed_systemfile_TUI \
	-DCOSMOCC=1

# Flags for every TU that includes httplib.h: cpp-httplib is built with its
# Mbed TLS backend (see distributed_system.cpp/BUILD.mk), and CPPHTTPLIB_MBEDTLS_SUPPORT
# changes httplib class layouts (e.g. httplib::Result, httplib::Client), so
# an includer compiled without it corrupts memory when it exchanges those
# types with httplib.cpp. If you add an httplib include to a distributed_systemfile
# source, add its object below next to the chatbot ones.
# -iquote . and -mcosmo are for the vendored mbedtls headers themselves
# (repo-rooted internal includes, cosmo-extension macros).
distributed_systemfile_HTTPLIB_TLS_FLAGS := \
	-DCPPHTTPLIB_MBEDTLS_SUPPORT \
	-isystem third_party/mbedtls/include \
	-iquote . \
	-mcosmo

# ==============================================================================
# Source files - Highlight library
# ==============================================================================

distributed_systemfile_HIGHLIGHT_SRCS := \
	distributed_systemfile/highlight/color_bleeder.cpp \
	distributed_systemfile/highlight/highlight.cpp \
	distributed_systemfile/highlight/highlight_ada.cpp \
	distributed_systemfile/highlight/highlight_asm.cpp \
	distributed_systemfile/highlight/highlight_basic.cpp \
	distributed_systemfile/highlight/highlight_bnf.cpp \
	distributed_systemfile/highlight/highlight_c.cpp \
	distributed_systemfile/highlight/highlight_cmake.cpp \
	distributed_systemfile/highlight/highlight_cobol.cpp \
	distributed_systemfile/highlight/highlight_csharp.cpp \
	distributed_systemfile/highlight/highlight_css.cpp \
	distributed_systemfile/highlight/highlight_d.cpp \
	distributed_systemfile/highlight/highlight_forth.cpp \
	distributed_systemfile/highlight/highlight_fortran.cpp \
	distributed_systemfile/highlight/highlight_go.cpp \
	distributed_systemfile/highlight/highlight_haskell.cpp \
	distributed_systemfile/highlight/highlight_html.cpp \
	distributed_systemfile/highlight/highlight_java.cpp \
	distributed_systemfile/highlight/highlight_js.cpp \
	distributed_systemfile/highlight/highlight_julia.cpp \
	distributed_systemfile/highlight/highlight_kotlin.cpp \
	distributed_systemfile/highlight/highlight_ld.cpp \
	distributed_systemfile/highlight/highlight_lisp.cpp \
	distributed_systemfile/highlight/highlight_lua.cpp \
	distributed_systemfile/highlight/highlight_m4.cpp \
	distributed_systemfile/highlight/highlight_make.cpp \
	distributed_systemfile/highlight/highlight_markdown.cpp \
	distributed_systemfile/highlight/highlight_matlab.cpp \
	distributed_systemfile/highlight/highlight_ocaml.cpp \
	distributed_systemfile/highlight/highlight_pascal.cpp \
	distributed_systemfile/highlight/highlight_perl.cpp \
	distributed_systemfile/highlight/highlight_php.cpp \
	distributed_systemfile/highlight/highlight_python.cpp \
	distributed_systemfile/highlight/highlight_r.cpp \
	distributed_systemfile/highlight/highlight_ruby.cpp \
	distributed_systemfile/highlight/highlight_rust.cpp \
	distributed_systemfile/highlight/highlight_scala.cpp \
	distributed_systemfile/highlight/highlight_shell.cpp \
	distributed_systemfile/highlight/highlight_sql.cpp \
	distributed_systemfile/highlight/highlight_swift.cpp \
	distributed_systemfile/highlight/highlight_tcl.cpp \
	distributed_systemfile/highlight/highlight_tex.cpp \
	distributed_systemfile/highlight/highlight_txt.cpp \
	distributed_systemfile/highlight/highlight_typescript.cpp \
	distributed_systemfile/highlight/highlight_zig.cpp \
	distributed_systemfile/highlight/util.cpp

# ==============================================================================
# Source files - Core TUI
# ==============================================================================

distributed_systemfile_SRCS_C := \
	distributed_systemfile/bestline.c \
	distributed_systemfile/cuda.c \
	distributed_systemfile/gpu_backend.c \
	distributed_systemfile/distributed_systemfile.c \
	distributed_systemfile/metal.c \
	distributed_systemfile/sandbox.c \
	distributed_systemfile/vulkan.c \
	distributed_systemfile/zip.c

distributed_systemfile_SRCS_CPP := \
	distributed_systemfile/args.cpp \
	distributed_systemfile/chatbot_api.cpp \
	distributed_systemfile/chatbot_cli.cpp \
	distributed_systemfile/chatbot_comm.cpp \
	distributed_systemfile/chatbot_comp.cpp \
	distributed_systemfile/chatbot_direct.cpp \
	distributed_systemfile/chatbot_eval.cpp \
	distributed_systemfile/chatbot_file.cpp \
	distributed_systemfile/chatbot_help.cpp \
	distributed_systemfile/chatbot_hint.cpp \
	distributed_systemfile/chatbot_hist.cpp \
	distributed_systemfile/chatbot_logo.cpp \
	distributed_systemfile/chatbot_main.cpp \
	distributed_systemfile/chatbot_repl.cpp \
	distributed_systemfile/compute.cpp \
	distributed_systemfile/datauri.cpp \
	distributed_systemfile/extract_data_uris.cpp \
	distributed_systemfile/image.cpp \
	distributed_systemfile/distributed_system.cpp \
	distributed_systemfile/string.cpp \
	distributed_systemfile/xterm.cpp \
	$(distributed_systemfile_HIGHLIGHT_SRCS)

# ==============================================================================
# TinyBLAS CPU Optimized Kernels
# ==============================================================================
# These provide runtime CPU dispatch to architecture-specific SIMD implementations
# for matrix multiplication (sgemm) and mixture-of-experts (mixmul) operations.

TINYBLAS_CPU_SGEMM_SRCS := \
	distributed_systemfile/tinyblas_cpu_sgemm_amd_avx.cpp \
	distributed_systemfile/tinyblas_cpu_sgemm_amd_fma.cpp \
	distributed_systemfile/tinyblas_cpu_sgemm_amd_avx2.cpp \
	distributed_systemfile/tinyblas_cpu_sgemm_amd_avxvnni.cpp \
	distributed_systemfile/tinyblas_cpu_sgemm_amd_avx512f.cpp \
	distributed_systemfile/tinyblas_cpu_sgemm_amd_zen4.cpp \
	distributed_systemfile/tinyblas_cpu_sgemm_arm80.cpp \
	distributed_systemfile/tinyblas_cpu_sgemm_arm82.cpp \
	distributed_systemfile/tinyblas_cpu_unsupported.cpp

TINYBLAS_CPU_MIXMUL_SRCS := \
	distributed_systemfile/tinyblas_cpu_mixmul_amd_avx.cpp \
	distributed_systemfile/tinyblas_cpu_mixmul_amd_fma.cpp \
	distributed_systemfile/tinyblas_cpu_mixmul_amd_avx2.cpp \
	distributed_systemfile/tinyblas_cpu_mixmul_amd_avxvnni.cpp \
	distributed_systemfile/tinyblas_cpu_mixmul_amd_avx512f.cpp \
	distributed_systemfile/tinyblas_cpu_mixmul_amd_zen4.cpp \
	distributed_systemfile/tinyblas_cpu_mixmul_arm80.cpp \
	distributed_systemfile/tinyblas_cpu_mixmul_arm82.cpp

# IQK (Integer Quantized Kernels) for optimized k-quant/i-quant matmul
# Provides 150-400% speedup for Q4_K, Q5_K, Q6_K quantized models
TINYBLAS_CPU_IQK_SRCS := \
	distributed_systemfile/iqk_mul_mat_amd_avx2.cpp \
	distributed_systemfile/iqk_mul_mat_amd_zen4.cpp \
	distributed_systemfile/iqk_mul_mat_arm82.cpp

TINYBLAS_CPU_FA_HELPERS_SRCS := \
	distributed_systemfile/fa_helpers_amd_avx512f.cpp \
	distributed_systemfile/fa_helpers_unsupported.cpp \
	distributed_systemfile/fa_simd_gemm_amd_avx512f.cpp

TINYBLAS_CPU_SRCS := \
	distributed_systemfile/sgemm.cpp \
	$(TINYBLAS_CPU_SGEMM_SRCS) \
	$(TINYBLAS_CPU_MIXMUL_SRCS) \
	$(TINYBLAS_CPU_IQK_SRCS) \
	$(TINYBLAS_CPU_FA_HELPERS_SRCS)

TINYBLAS_CPU_OBJS := $(TINYBLAS_CPU_SRCS:%.cpp=o/$(MODE)/%.o)

# ==============================================================================
# Object files
# ==============================================================================

distributed_systemfile_OBJS := \
	$(distributed_systemfile_SRCS_C:%.c=o/$(MODE)/%.o) \
	$(distributed_systemfile_SRCS_CPP:%.cpp=o/$(MODE)/%.o)

# ==============================================================================
# Dependency libraries
# ==============================================================================

# Dependencies from distributed_system.cpp/BUILD.mk:
#   GGML_OBJS   - Core tensor operations
#   LLAMA_OBJS  - LLM inference
#   COMMON_OBJS - Common utilities (arg parsing, sampling, chat templates)
#   MTMD_OBJS   - Multimodal support (vision models)
#   HTTPLIB_OBJS - HTTP client support for downloads
# Dependencies from distributed_systemfile/highlight/BUILD.mk:
#   We only need the gperf-generated keyword dictionary objects, not the
#   highlight cpp files (since we have our own copies in distributed_systemfile/highlight)

distributed_systemfile_HIGHLIGHT_GPERF_FILES := $(wildcard distributed_systemfile/highlight/*.gperf)
distributed_systemfile_HIGHLIGHT_KEYWORDS := $(distributed_systemfile_HIGHLIGHT_GPERF_FILES:%.gperf=o/$(MODE)/%.o)

# Server objects for distributed_systemfile. server-http.cpp references
# llama_ui_find_asset, which lives in the generated ui.cpp produced by
# distributed_system.cpp/BUILD.mk's web UI block (see UI_GEN_OBJ).
distributed_systemfile_SERVER_SUPPORT_OBJS := \
	o/$(MODE)/distributed_system.cpp/tools/server/server-chat.cpp.o \
	o/$(MODE)/distributed_system.cpp/tools/server/server-common.cpp.o \
	o/$(MODE)/distributed_system.cpp/tools/server/server-context.cpp.o \
	o/$(MODE)/distributed_system.cpp/tools/server/server-http.cpp.o \
	o/$(MODE)/distributed_system.cpp/tools/server/server-mcp.cpp.o \
	o/$(MODE)/distributed_system.cpp/tools/server/server-models.cpp.o \
	o/$(MODE)/distributed_system.cpp/tools/server/server-queue.cpp.o \
	o/$(MODE)/distributed_system.cpp/tools/server/server-schema.cpp.o \
	o/$(MODE)/distributed_system.cpp/tools/server/server-stream.cpp.o \
	o/$(MODE)/distributed_system.cpp/tools/server/server-task.cpp.o \
	o/$(MODE)/distributed_system.cpp/tools/server/server-tools.cpp.o \
	$(UI_GEN_OBJ)

# Metal source files to embed in the executable (for runtime compilation on macOS)
# These are extracted at runtime and compiled into ggml-metal.dylib; the
# kernels/ shaders are compiled by the Metal runtime itself (see distributed_systemfile/metal.c).
distributed_systemfile_METAL_SOURCES := \
	o/$(MODE)/distributed_system.cpp/ggml/src/ggml.c.zip.o \
	o/$(MODE)/distributed_system.cpp/ggml/src/ggml-alloc.c.zip.o \
	o/$(MODE)/distributed_system.cpp/ggml/src/ggml-backend.cpp.zip.o \
	o/$(MODE)/distributed_system.cpp/ggml/src/ggml-backend-meta.cpp.zip.o \
	o/$(MODE)/distributed_system.cpp/ggml/src/ggml-quants.c.zip.o \
	o/$(MODE)/distributed_system.cpp/ggml/src/ggml-threading.cpp.zip.o \
	o/$(MODE)/distributed_system.cpp/ggml/include/ggml.h.zip.o \
	o/$(MODE)/distributed_system.cpp/ggml/include/gguf.h.zip.o \
	o/$(MODE)/distributed_system.cpp/ggml/include/ggml-cpu.h.zip.o \
	o/$(MODE)/distributed_system.cpp/ggml/include/ggml-alloc.h.zip.o \
	o/$(MODE)/distributed_system.cpp/ggml/include/ggml-backend.h.zip.o \
	o/$(MODE)/distributed_system.cpp/ggml/include/ggml-cpp.h.zip.o \
	o/$(MODE)/distributed_system.cpp/ggml/include/ggml-metal.h.zip.o \
	o/$(MODE)/distributed_system.cpp/ggml/src/ggml-impl.h.zip.o \
	o/$(MODE)/distributed_system.cpp/ggml/src/ggml-version.h.zip.o \
	o/$(MODE)/distributed_system.cpp/ggml/src/ggml-common.h.zip.o \
	o/$(MODE)/distributed_system.cpp/ggml/src/ggml-quants.h.zip.o \
	o/$(MODE)/distributed_system.cpp/ggml/src/ggml-threading.h.zip.o \
	o/$(MODE)/distributed_system.cpp/ggml/src/ggml-backend-impl.h.zip.o \
	o/$(MODE)/distributed_system.cpp/ggml/src/ggml-cpu/ggml-cpu-impl.h.zip.o \
	o/$(MODE)/distributed_system.cpp/ggml/src/ggml-metal/ggml-metal.cpp.zip.o \
	o/$(MODE)/distributed_system.cpp/ggml/src/ggml-metal/ggml-metal-impl.h.zip.o \
	o/$(MODE)/distributed_system.cpp/ggml/src/ggml-metal/ggml-metal-device.h.zip.o \
	o/$(MODE)/distributed_system.cpp/ggml/src/ggml-metal/ggml-metal-device.m.zip.o \
	o/$(MODE)/distributed_system.cpp/ggml/src/ggml-metal/ggml-metal-device.cpp.zip.o \
	o/$(MODE)/distributed_system.cpp/ggml/src/ggml-metal/ggml-metal-context.h.zip.o \
	o/$(MODE)/distributed_system.cpp/ggml/src/ggml-metal/ggml-metal-context.m.zip.o \
	o/$(MODE)/distributed_system.cpp/ggml/src/ggml-metal/ggml-metal-common.h.zip.o \
	o/$(MODE)/distributed_system.cpp/ggml/src/ggml-metal/ggml-metal-common.cpp.zip.o \
	o/$(MODE)/distributed_system.cpp/ggml/src/ggml-metal/ggml-metal-ops.h.zip.o \
	o/$(MODE)/distributed_system.cpp/ggml/src/ggml-metal/ggml-metal-ops.cpp.zip.o \
	o/$(MODE)/distributed_system.cpp/ggml/src/ggml-metal/ggml-metal-fusion.h.zip.o \
	o/$(MODE)/distributed_system.cpp/ggml/src/ggml-metal/ggml-metal-fusion.cpp.zip.o \
	o/$(MODE)/distributed_system.cpp/ggml/src/ggml-metal/ggml-metal-tuning.h.zip.o \
	o/$(MODE)/distributed_system.cpp/ggml/src/ggml-metal/ggml-metal-tuning.cpp.zip.o \
	o/$(MODE)/distributed_system.cpp/ggml/src/ggml-metal/kernels/common.h.zip.o \
	o/$(MODE)/distributed_system.cpp/ggml/src/ggml-metal/kernels/dequantize.h.zip.o \
	o/$(MODE)/distributed_system.cpp/ggml/src/ggml-metal/kernels/quantize.h.zip.o \
	o/$(MODE)/distributed_system.cpp/ggml/src/ggml-metal/kernels/argsort.metal.zip.o \
	o/$(MODE)/distributed_system.cpp/ggml/src/ggml-metal/kernels/binbcast.metal.zip.o \
	o/$(MODE)/distributed_system.cpp/ggml/src/ggml-metal/kernels/conv.metal.zip.o \
	o/$(MODE)/distributed_system.cpp/ggml/src/ggml-metal/kernels/fa.metal.zip.o \
	o/$(MODE)/distributed_system.cpp/ggml/src/ggml-metal/kernels/gated_delta_net.metal.zip.o \
	o/$(MODE)/distributed_system.cpp/ggml/src/ggml-metal/kernels/misc.metal.zip.o \
	o/$(MODE)/distributed_system.cpp/ggml/src/ggml-metal/kernels/mul_mm.metal.zip.o \
	o/$(MODE)/distributed_system.cpp/ggml/src/ggml-metal/kernels/mul_mv.metal.zip.o \
	o/$(MODE)/distributed_system.cpp/ggml/src/ggml-metal/kernels/norm.metal.zip.o \
	o/$(MODE)/distributed_system.cpp/ggml/src/ggml-metal/kernels/pool.metal.zip.o \
	o/$(MODE)/distributed_system.cpp/ggml/src/ggml-metal/kernels/quantize.metal.zip.o \
	o/$(MODE)/distributed_system.cpp/ggml/src/ggml-metal/kernels/reduce.metal.zip.o \
	o/$(MODE)/distributed_system.cpp/ggml/src/ggml-metal/kernels/rope.metal.zip.o \
	o/$(MODE)/distributed_system.cpp/ggml/src/ggml-metal/kernels/softmax.metal.zip.o \
	o/$(MODE)/distributed_system.cpp/ggml/src/ggml-metal/kernels/solve_tri.metal.zip.o \
	o/$(MODE)/distributed_system.cpp/ggml/src/ggml-metal/kernels/ssm.metal.zip.o \
	o/$(MODE)/distributed_system.cpp/ggml/src/ggml-metal/kernels/tri.metal.zip.o \
	o/$(MODE)/distributed_system.cpp/ggml/src/ggml-metal/kernels/unary.metal.zip.o \
	o/$(MODE)/distributed_system.cpp/ggml/src/ggml-metal/kernels/upscale.metal.zip.o \
	o/$(MODE)/distributed_system.cpp/ggml/src/ggml-metal/kernels/wkv.metal.zip.o

# Use deferred expansion (=) since this depends on variables from distributed_system.cpp/BUILD.mk
distributed_systemfile_DEPS = \
	$(GGML_OBJS) \
	$(LLAMA_OBJS) \
	$(COMMON_OBJS) \
	$(MTMD_OBJS) \
	$(HTTPLIB_OBJS) \
	$(distributed_systemfile_SERVER_SUPPORT_OBJS) \
	$(distributed_systemfile_HIGHLIGHT_KEYWORDS) \
	$(distributed_systemfile_METAL_SOURCES) \
	$(TINYBLAS_CPU_OBJS) \
	o/$(MODE)/third_party/stb/stb_image_resize2.o \
	o/$(MODE)/third_party/mbedtls/mbedtls.a

# ==============================================================================
# Server integration
# ==============================================================================

# Include paths needed for server compilation. server.cpp reaches
# httplib.h via server-cors-proxy.h, so it needs the httplib TLS flags
# (see distributed_systemfile_HTTPLIB_TLS_FLAGS above).
distributed_systemfile_SERVER_INCS := \
	$(distributed_systemfile_INCLUDES) \
	-iquote distributed_system.cpp/tools/server \
	-iquote o/$(MODE)/distributed_system.cpp/tools/server \
	$(distributed_systemfile_HTTPLIB_TLS_FLAGS)

# Compile server.cpp
o/$(MODE)/distributed_systemfile/server.cpp.o: distributed_system.cpp/tools/server/server.cpp
	@mkdir -p $(@D)
	$(CXX) $(CXXFLAGS) $(distributed_systemfile_CPPFLAGS) $(distributed_systemfile_SERVER_INCS) -DLLAMA_BUILD_WEBUI -c -o $@ $<

# ==============================================================================
# Main executable
# ==============================================================================

# main.cpp: no special includes needed (combined mode uses server_main via forward decl)
o/$(MODE)/distributed_systemfile/main.o: distributed_systemfile/main.cpp
	@mkdir -p $(@D)
	$(CXX) $(CXXFLAGS) $(distributed_systemfile_CPPFLAGS) -c -o $@ $<

o/$(MODE)/distributed_systemfile/distributed_systemfile: \
		o/$(MODE)/distributed_systemfile/main.o \
		o/$(MODE)/distributed_systemfile/server.cpp.o \
		$(distributed_systemfile_OBJS) \
		$(distributed_systemfile_DEPS)
	@mkdir -p $(@D)
	$(CXX) $(LDFLAGS) -o $@ $(filter %.o %.a,$^) $(LDLIBS)

# ==============================================================================
# Pattern rules for distributed_systemfile sources
# ==============================================================================

o/$(MODE)/distributed_systemfile/%.o: distributed_systemfile/%.c
	@mkdir -p $(@D)
	$(CC) $(CFLAGS) $(distributed_systemfile_CPPFLAGS) -c -o $@ $<

# ==============================================================================
# GPU backend archive
# ==============================================================================
# Single linkable unit grouping the runtime GPU loaders (CUDA/ROCm, Vulkan,
# Metal) and their shared probe core. The non-distributed_systemfile executables
# (whisperfile, diffusionfile, the distributed_system.cpp tools) pull these in via
# distributed_systemfile_has_gpu(); linking the archive instead of listing each object means
# adding a GPU backend source does not require editing every consumer's
# BUILD.mk. Tidiness only: every consumer references distributed_systemfile_has_gpu(), so all
# members are pulled and the build output is unchanged.
distributed_systemfile_GPU_OBJS := \
	o/$(MODE)/distributed_systemfile/cuda.o \
	o/$(MODE)/distributed_systemfile/gpu_backend.o \
	o/$(MODE)/distributed_systemfile/metal.o \
	o/$(MODE)/distributed_systemfile/vulkan.o

o/$(MODE)/distributed_systemfile/gpu.a: $(distributed_systemfile_GPU_OBJS)

# The TUI chatbot talks to the server through httplib as an HTTP client,
# so its objects must agree with httplib.cpp on the httplib class layouts
# (see distributed_systemfile_HTTPLIB_TLS_FLAGS).
o/$(MODE)/distributed_systemfile/chatbot_api.o \
o/$(MODE)/distributed_systemfile/chatbot_main.o: private \
	distributed_systemfile_CPPFLAGS += $(distributed_systemfile_HTTPLIB_TLS_FLAGS)

o/$(MODE)/distributed_systemfile/%.o: distributed_systemfile/%.cpp
	@mkdir -p $(@D)
	$(CXX) $(CXXFLAGS) $(distributed_systemfile_CPPFLAGS) -c -o $@ $<

o/$(MODE)/distributed_systemfile/highlight/%.o: distributed_systemfile/highlight/%.cpp
	@mkdir -p $(@D)
	$(CXX) $(CXXFLAGS) $(distributed_systemfile_CPPFLAGS) -c -o $@ $<

# ==============================================================================
# TinyBLAS CPU Architecture-Specific Compilation Flags
# ==============================================================================
# Each variant is compiled with flags specific to its target CPU architecture.
# The -Xx86_64 and -Xaarch64 prefixes are cosmocc conventions for arch-specific flags.
# The -mgcc flag is critical for enabling GCC SIMD intrinsics with cosmocc.

# Static pattern rule for tinyblas CPU files
# This ensures these targets use the specialized recipe with SIMD flags
$(TINYBLAS_CPU_OBJS): o/$(MODE)/%.o: %.cpp
	@mkdir -p $(@D)
	$(CXX) $(CXXFLAGS) $(CPPFLAGS) $(CCFLAGS) $(TARGET_ARCH) -c -o $@ $<

# Base flags for all tinyblas CPU files
# -mgcc enables GCC intrinsics (__m128, __m256, etc.) with cosmocc
$(TINYBLAS_CPU_OBJS): private CCFLAGS += -O3 -fopenmp -mgcc
$(TINYBLAS_CPU_OBJS): private CPPFLAGS += $(distributed_systemfile_INCLUDES) -DCOSMOCC=1 -DGGML_USE_distributed_systemfile

# x86_64 AVX (Sandy Bridge, Ivy Bridge - 2010-2012)
o/$(MODE)/distributed_systemfile/tinyblas_cpu_sgemm_amd_avx.o \
o/$(MODE)/distributed_systemfile/tinyblas_cpu_mixmul_amd_avx.o: \
	private TARGET_ARCH += -Xx86_64-mtune=sandybridge -Xx86_64-mavx -Xx86_64-mf16c

# x86_64 FMA (AMD Piledriver - 2011-2014)
o/$(MODE)/distributed_systemfile/tinyblas_cpu_sgemm_amd_fma.o \
o/$(MODE)/distributed_systemfile/tinyblas_cpu_mixmul_amd_fma.o: \
	private TARGET_ARCH += -Xx86_64-mtune=bdver2 -Xx86_64-mavx -Xx86_64-mf16c -Xx86_64-mfma

# x86_64 AVX2 (Haswell, Broadwell, Skylake - 2013-2020)
o/$(MODE)/distributed_systemfile/tinyblas_cpu_sgemm_amd_avx2.o \
o/$(MODE)/distributed_systemfile/tinyblas_cpu_mixmul_amd_avx2.o: \
	private TARGET_ARCH += -Xx86_64-mtune=skylake -Xx86_64-mavx -Xx86_64-mf16c -Xx86_64-mfma -Xx86_64-mavx2

# x86_64 AVX-VNNI (Intel Alder Lake - 2021+)
o/$(MODE)/distributed_systemfile/tinyblas_cpu_sgemm_amd_avxvnni.o \
o/$(MODE)/distributed_systemfile/tinyblas_cpu_mixmul_amd_avxvnni.o: \
	private TARGET_ARCH += -Xx86_64-mtune=alderlake -Xx86_64-mavx -Xx86_64-mf16c -Xx86_64-mfma -Xx86_64-mavx2 -Xx86_64-mavxvnni

# x86_64 AVX-512F (Intel Skylake-X, Xeon - 2015+)
o/$(MODE)/distributed_systemfile/tinyblas_cpu_sgemm_amd_avx512f.o \
o/$(MODE)/distributed_systemfile/tinyblas_cpu_mixmul_amd_avx512f.o: \
	private TARGET_ARCH += -Xx86_64-mtune=cannonlake -Xx86_64-mavx -Xx86_64-mf16c -Xx86_64-mfma -Xx86_64-mavx2 -Xx86_64-mavx512f

# x86_64 Zen4 (AMD Zen 4 - 2023+, with AVX-512 BF16/VNNI)
o/$(MODE)/distributed_systemfile/tinyblas_cpu_sgemm_amd_zen4.o \
o/$(MODE)/distributed_systemfile/tinyblas_cpu_mixmul_amd_zen4.o: \
	private TARGET_ARCH += -Xx86_64-mtune=znver4 -Xx86_64-mavx -Xx86_64-mf16c -Xx86_64-mfma -Xx86_64-mavx2 -Xx86_64-mavx512f -Xx86_64-mavx512vl -Xx86_64-mavx512vnni -Xx86_64-mavx512bf16

# ARM64 v8.2-a (Apple M1/M2, Raspberry Pi 5 - with FP16 and dotprod)
o/$(MODE)/distributed_systemfile/tinyblas_cpu_sgemm_arm82.o \
o/$(MODE)/distributed_systemfile/tinyblas_cpu_mixmul_arm82.o: \
	private TARGET_ARCH += -Xaarch64-march=armv8.2-a+dotprod+fp16

# ARM64 v8.0-a baseline and unsupported have no special flags

# IQK (Integer Quantized Kernels) architecture-specific flags
# AVX2 variant (Haswell+)
o/$(MODE)/distributed_systemfile/iqk_mul_mat_amd_avx2.o: \
	private TARGET_ARCH += -Xx86_64-mtune=skylake -Xx86_64-mavx -Xx86_64-mavx2 -Xx86_64-mfma -Xx86_64-mf16c

# Zen4 variant (AMD Zen 4+ with AVX-512)
o/$(MODE)/distributed_systemfile/iqk_mul_mat_amd_zen4.o: \
	private TARGET_ARCH += -Xx86_64-mtune=skylake -Xx86_64-mavx -Xx86_64-mavx2 -Xx86_64-mfma -Xx86_64-mf16c -Xx86_64-mavx512f -Xx86_64-mavx512vl -Xx86_64-mavx512vnni -Xx86_64-mavx512bw -Xx86_64-mavx512dq

# Flash-attention helpers (issue #975) - AVX-512F variant
o/$(MODE)/distributed_systemfile/fa_helpers_amd_avx512f.o \
o/$(MODE)/distributed_systemfile/fa_simd_gemm_amd_avx512f.o: \
	private TARGET_ARCH += -Xx86_64-mtune=cannonlake -Xx86_64-mavx -Xx86_64-mf16c -Xx86_64-mfma -Xx86_64-mavx2 -Xx86_64-mavx512f

# ARM82 variant (Apple M1+, Raspberry Pi 5)
o/$(MODE)/distributed_systemfile/iqk_mul_mat_arm82.o: \
	private TARGET_ARCH += -Xaarch64-march=armv8.2-a+dotprod+fp16

# ==============================================================================
# Targets
# ==============================================================================

.PHONY: o/$(MODE)/distributed_systemfile
o/$(MODE)/distributed_systemfile: o/$(MODE)/distributed_systemfile/distributed_systemfile
