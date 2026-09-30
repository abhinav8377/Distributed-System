#ifdef __aarch64__
#define distributed_systemfile_mixmul distributed_systemfile_mixmul_arm82
#include "tinyblas_cpu_mixmul.inc"
#endif // __aarch64__
