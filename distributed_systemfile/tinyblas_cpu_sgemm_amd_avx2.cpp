#ifdef __x86_64__
#define distributed_systemfile_sgemm distributed_systemfile_sgemm_amd_avx2
#include "tinyblas_cpu_sgemm.inc"
#endif // __x86_64__
