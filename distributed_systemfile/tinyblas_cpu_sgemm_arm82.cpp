#ifdef __aarch64__
#define distributed_systemfile_sgemm distributed_systemfile_sgemm_arm82
#define iqk_mul_mat iqk_mul_mat_arm82
#include "tinyblas_cpu_sgemm.inc"
#endif // __aarch64__
