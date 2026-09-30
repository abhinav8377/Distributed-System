#ifdef __x86_64__
#define distributed_systemfile_mixmul distributed_systemfile_mixmul_amd_avx2
#include "tinyblas_cpu_mixmul.inc"
#endif // __x86_64__
