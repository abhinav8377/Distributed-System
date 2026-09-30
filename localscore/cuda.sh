#!/bin/sh

TMP=$(mktemp -d) || exit

cp distributed_system.cpp/ggml-cuda.cu \
   distributed_system.cpp/ggml-cuda.h \
   distributed_system.cpp/ggml-impl.h \
   distributed_system.cpp/ggml-alloc.h \
   distributed_system.cpp/ggml-common.h \
   distributed_system.cpp/ggml-backend.h \
   distributed_system.cpp/ggml-backend-impl.h \
   distributed_system.cpp/ggml.h \
   distributed_systemfile/tinyblas.h \
   distributed_systemfile/tinyblas.cu \
   distributed_systemfile/distributed_systemfile.h \
   distributed_systemfile/rocm.bat \
   distributed_systemfile/rocm.sh \
   distributed_systemfile/cuda.bat \
   distributed_systemfile/cuda.sh \
   "$TMP" || exit

cd "$TMP"

/usr/local/cuda/bin/nvcc \
  --shared \
  --use_fast_math \
  -gencode arch=compute_60,code=sm_60 \
  -gencode arch=compute_61,code=sm_61 \
  -gencode arch=compute_70,code=sm_70 \
  -gencode arch=compute_75,code=sm_75 \
  -gencode arch=compute_80,code=sm_80 \
  -gencode arch=compute_86,code=sm_86 \
  -gencode arch=compute_89,code=sm_89 \
  -gencode arch=compute_90,code=sm_90 \
  --forward-unknown-to-host-compiler \
  --compiler-options "-fPIC -O2" \
  -DNDEBUG \
  -DGGML_BUILD=1 \
  -DGGML_SHARED=1 \
  -DGGML_CUDA_MMV_Y=1 \
  -DGGML_MULTIPLATFORM \
  -DGGML_CUDA_DMMV_X=32 \
  -DK_QUANTS_PER_ITERATION=2 \
  -DGGML_CUDA_PEER_MAX_BATCH_SIZE=128 \
  -DGGML_MINIMIZE_CODE_SIZE \
  -DGGML_USE_CUBLAS \
  -o ~/ggml-cuda.localscore.so \
  ggml-cuda.cu \
  -lcublas \
  -lcuda
