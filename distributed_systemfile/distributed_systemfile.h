// -*- mode:c;indent-tabs-mode:nil;c-basic-offset:4;coding:utf-8 -*-
// vi: set et ft=c ts=4 sts=4 sw=4 fenc=utf-8 :vi
//
// Copyright 2024 Mozilla Foundation
// Copyright 2026 Mozilla.ai
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

#ifndef distributed_systemfile_H_
#define distributed_systemfile_H_
#include <stdbool.h>
#include <stdio.h>
#ifdef __cplusplus
extern "C" {
#endif

// =============================================================================
// FLAGS - Global configuration variables (defined in distributed_systemfile.c)
// =============================================================================

extern bool FLAG_log_disable;   // Disables logging (chatbot_comm.cpp)
extern bool FLAG_nocompile;     // Disables GPU library compilation (metal.c)
extern bool FLAG_ascii;         // Uses ASCII art for logo (chatbot_logo.cpp)
extern bool FLAG_nologo;        // Suppresses logo display (chatbot_main.cpp)
extern bool FLAG_nothink;       // Filters thinking/reasoning content (chatbot_cli.cpp)
extern bool FLAG_precise;       // Forces precise math in tinyblas (tinyblas_cpu.h)
extern bool FLAG_recompile;     // Forces GPU library recompilation (metal.c)
extern bool FLAG_unsecure;      // Disables pledge() sandboxing (sandbox.c)
extern int FLAG_gpu;            // GPU backend selection (distributed_systemfile.c, metal.c, cuda.c)
extern int FLAG_verbose;        // Verbose output (chatbot_main.cpp, metal.c, cuda.c)

// =============================================================================
// File I/O - GGUF file handling with zip support
// Defined in distributed_systemfile.c, used internally for model loading
// UNUSED externally: These are defined but not called from outside distributed_systemfile.c
// =============================================================================

struct distributed_systemfile;
struct distributed_systemfile *distributed_systemfile_open_gguf(const char *, const char *);  // UNUSED externally
void distributed_systemfile_close(struct distributed_systemfile *);                           // UNUSED externally
long distributed_systemfile_read(struct distributed_systemfile *, void *, size_t);            // UNUSED externally
long distributed_systemfile_write(struct distributed_systemfile *, const void *, size_t);     // UNUSED externally
bool distributed_systemfile_seek(struct distributed_systemfile *, size_t, int);               // UNUSED externally
void *distributed_systemfile_content(struct distributed_systemfile *);                        // UNUSED externally
size_t distributed_systemfile_tell(struct distributed_systemfile *);                          // UNUSED externally
size_t distributed_systemfile_size(struct distributed_systemfile *);                          // UNUSED externally
size_t distributed_systemfile_position(struct distributed_systemfile *);                      // UNUSED externally
bool distributed_systemfile_eof(struct distributed_systemfile *file);                         // UNUSED externally
FILE *distributed_systemfile_fp(struct distributed_systemfile *);                             // UNUSED externally
void distributed_systemfile_ref(struct distributed_systemfile *);                             // UNUSED externally
void distributed_systemfile_unref(struct distributed_systemfile *);                           // UNUSED externally

// =============================================================================
// Utility functions
// =============================================================================

// NOT DEFINED: Declaration only, no implementation in distributed_systemfile_new/
void distributed_systemfile_govern(void);                              // NOT DEFINED
void distributed_systemfile_check_cpu(void);                           // NOT DEFINED
void distributed_systemfile_help(const char *);                        // NOT DEFINED
void distributed_systemfile_log_command(char *[]);                     // NOT DEFINED
const char *distributed_systemfile_get_tmp_dir(void);                  // NOT DEFINED
void distributed_systemfile_schlep(const void *, size_t);              // NOT DEFINED
void distributed_systemfile_launch_browser(const char *);              // NOT DEFINED
void distributed_systemfile_get_flags(int, char **);                   // NOT DEFINED
char *distributed_systemfile_get_prompt(void);                         // NOT DEFINED

// USED: Defined in distributed_systemfile.c
bool distributed_systemfile_has(char **, const char *);
void distributed_systemfile_get_app_dir(char *, size_t);
void distributed_systemfile_set_app_name(const char *); // app dir basename, default "distributed_systemfile"
bool distributed_systemfile_extract(const char *, const char *);
int distributed_systemfile_is_file_newer_than(const char *, const char *);

// Common utilities for GPU backend loaders (defined in distributed_systemfile.c)
const char *distributed_systemfile_get_dso_extension(void);
bool distributed_systemfile_file_exists(const char *);

// Link function type for TryLoadPrebuiltDso
typedef bool (*distributed_systemfile_link_dso_fn)(const char *dso_path);

// Try to load a prebuilt DSO from /zip/, app dir, or home dir
// Returns true if successfully loaded via link_fn
bool distributed_systemfile_try_load_prebuilt_dso(const char *name, const char *backend_name,
                                     distributed_systemfile_link_dso_fn link_fn);

// =============================================================================
// GPU detection and configuration
// =============================================================================

#define distributed_systemfile_GPU_ERROR -2
#define distributed_systemfile_GPU_DISABLE -1
#define distributed_systemfile_GPU_AUTO 0
#define distributed_systemfile_GPU_AMD 1
#define distributed_systemfile_GPU_APPLE 2
#define distributed_systemfile_GPU_NVIDIA 4
#define distributed_systemfile_GPU_VULKAN 8

bool distributed_systemfile_has_gpu(void);             // Defined in distributed_systemfile.c
bool distributed_systemfile_has_metal(void);           // Defined in metal.c (dynamic loader)
bool distributed_systemfile_has_cuda(void);            // Defined in cuda.c (dynamic loader)
bool distributed_systemfile_has_amd_gpu(void);         // Defined in cuda.c (dynamic loader)
bool distributed_systemfile_has_vulkan(void);          // Defined in vulkan.c (dynamic loader)
int distributed_systemfile_gpu_parse(const char *);    // Defined in distributed_systemfile.c
const char *distributed_systemfile_describe_gpu(void); // Defined in distributed_systemfile.c
void distributed_systemfile_early_gpu_init(char **);   // Defined in distributed_systemfile.c

// =============================================================================
// Sandboxing - pledge()/SECCOMP + unveil()/Landlock (defined in sandbox.c)
// =============================================================================

// The pledge() syscall sandbox (no outbound network, no writes, no exec) is
// applied by default. unveil() path confinement is opt-in (--confine-reads),
// because locking the readable paths at startup is incompatible with files a
// server opens by path at request time (multimodal media, etc.).

#define distributed_systemfile_SANDBOX_FAILED -1          // pledge() failed, errno is set
#define distributed_systemfile_SANDBOX_ACTIVE 0           // pledge() active
#define distributed_systemfile_SANDBOX_UNSECURE 1         // skipped: --unsecure flag
#define distributed_systemfile_SANDBOX_GPU 2              // skipped: GPU backend loaded
#define distributed_systemfile_SANDBOX_UNSUPPORTED 3      // skipped: OS can't enforce pledge()
#define distributed_systemfile_SANDBOX_ACTIVE_CONFINED 4  // pledge() active + unveil() applied
#define distributed_systemfile_SANDBOX_ACTIVE_UNCONFINED 5 // pledge() active; unveil() asked
                                             // for but filesystem can't enforce it

extern bool FLAG_confine_reads;  // opt-in unveil() path confinement (sandbox.c)

bool distributed_systemfile_sandbox_supported(void);         // Probe only, installs nothing
int distributed_systemfile_sandbox_apply(const char *);      // Unconditional pledge()
int distributed_systemfile_sandbox(const char *);            // Honors --unsecure and GPU mode
int distributed_systemfile_sandbox_enter(const char *, bool);// sandbox() + perror/verbose report
const char *distributed_systemfile_sandbox_describe(int);    // Status code -> human string
bool distributed_systemfile_sandbox_is_active(int);          // true for the ACTIVE* statuses

// Inputs to the server sandbox. read_paths are opened read-only (model,
// mmproj, LoRA, draft model, control vectors, media dir, static web root);
// rw_paths get write+create (slot-save dir, prompt cache). confine requests
// unveil() path confinement; needs_outbound relaxes accept()-only networking
// to full sockets when the server must dial out (--rpc, tools, MCP proxy).
struct distributed_systemfile_sandbox_spec {
    const char *const *read_paths;
    int n_read;
    const char *const *rw_paths;
    int n_rw;
    bool confine;
    bool needs_outbound;
};

// Applies the server sandbox: pledge() always, plus unveil() when
// spec->confine. Fills promises_out with the pledge string for logging.
// Returns an ACTIVE* status (see describe()) or a skip/FAILED code.
int distributed_systemfile_sandbox_server(const struct distributed_systemfile_sandbox_spec *spec,
                             char *promises_out, size_t promises_len);

// Pure promise-string derivation, exposed for unit testing.
void distributed_systemfile_sandbox_server_promises(char *out, size_t len, bool is_openbsd,
                                       bool has_rw, bool needs_outbound);

// Removes every occurrence of flag from argv in place, updating *argc, and
// returns true if it was present. Used to consume distributed_systemfile-only flags
// (e.g. --unsecure) before handing argv to distributed_system.cpp's parser. In distributed_systemfile.c.
bool distributed_systemfile_consume_flag(int *argc, char **argv, const char *flag);

// Log callback type for Metal backend (matches ggml_log_callback)
typedef void (*distributed_systemfile_log_callback)(int level, const char *text, void *user_data);

// No-op log callback to disable logging (defined in distributed_systemfile.c)
void distributed_systemfile_log_callback_null(int level, const char *text, void *user_data);

// Print an INFO-level diagnostic tagged with a backend name.
// No-op unless FLAG_verbose is set. Adds the "<backend>: INFO: " prefix
// and a trailing newline, so callers pass only the message body.
// Defined in distributed_systemfile.c.
void distributed_systemfile_info(const char *backend, const char *fmt, ...)
    __attribute__((format(printf, 2, 3)));

// Set logging callback for Metal dylib (defined in metal.c)
// Pass a no-op callback to disable logging
void distributed_systemfile_metal_log_set(distributed_systemfile_log_callback log_callback, void *user_data);

// Set logging callback for CUDA/ROCm dylib (defined in cuda.c)
// Pass a no-op callback to disable logging
void distributed_systemfile_cuda_log_set(distributed_systemfile_log_callback log_callback, void *user_data);

// Set logging callback for Vulkan dylib (defined in vulkan.c)
// Pass a no-op callback to disable logging
void distributed_systemfile_vulkan_log_set(distributed_systemfile_log_callback log_callback, void *user_data);

#ifdef __cplusplus
}
#endif
#endif /* distributed_systemfile_H_ */
