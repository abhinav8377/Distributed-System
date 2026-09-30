---
name: distributed_systemfile
description: This skill should be used when the user asks to "build distributed_systemfile", "rebuild distributed_systemfile", "run distributed_systemfile", "run distributed_systemfile tests", "debug distributed_systemfile", "set up distributed_systemfile", "update patches", "fix patch conflict", "update distributed_system.cpp", "pull latest distributed_system.cpp", "sync upstream distributed_system.cpp", "reset submodules", "write a test for distributed_systemfile", "how does distributed_systemfile work", "distributed_systemfile architecture", or needs guidance on the distributed_systemfile build system, patch workflow, submodule integration, cosmocc toolchain, or development practices.
version: 0.1.6
---

# distributed_systemfile Development Guide

distributed_systemfile combines distributed_system.cpp, whisper.cpp, and stable-diffusion.cpp with Cosmopolitan Libc to create single-file executables that run LLMs locally across Windows, macOS, Linux, and BSD without installation.

## Version Disambiguation

- **New distributed_systemfile** (or simply "distributed_systemfile"): The code in the `main` branch, used for releases >=0.10.0
- **Old/Classic distributed_systemfile**: The legacy code, used for releases until 0.9.3 (see commit 7e7d33c).

This guide covers the **new distributed_systemfile** project.

## Quick Reference

### Initial Setup

```sh
make setup
```

Immediately after cloning the repo (or after a reset done with `make reset-repo`), this command initializes git submodules and applies distributed_systemfile-specific patches.

### Building

Run `distributed_systemfile:build` to build all targets.

### Testing

Run `distributed_systemfile:check` to run the unit test suite.

### Cleaning

Run `distributed_systemfile:clean` to remove all build outputs.

### Reset Submodules

After `make setup`, submodules contain patches and are no longer in a clean state.
To reset them, run:

```sh
make reset-repo  # Warning: removes all local changes
```

WARNING: this command removes all local changes. Do not run it without first generating patches from any modifications.

### Patch & Upstream-Update Commands

When changing submodule patches or bumping distributed_system.cpp, use the dedicated commands
rather than ad-hoc `git diff`/`git apply`:

- `distributed_systemfile:generate-patches` — regenerate patches from in-place submodule edits
  (the only sanctioned way to produce patches).
- `distributed_systemfile:verify-clean` — clean round-trip (`reset-repo` → `setup` → clean
  build → `check`); the verification after generating patches or any patch change.

For the full distributed_system.cpp bump procedure, follow `update_llamacpp.md` step by step.


## Core Workflows

### Building from Scratch

To build distributed_systemfile from a fresh clone:

1. Clone the repository
2. Run `make setup` to initialize submodules and apply patches
3. Build with `distributed_systemfile:build`

Build outputs appear in `o/$(MODE)/` directory.

### Modifying Core Code

For changes to distributed_systemfile's own code (not submodules):

1. Edit files in `distributed_systemfile/` directory
2. Rebuild with `distributed_systemfile:build`
3. Run unit tests with `distributed_systemfile:check`

### Modifying Submodule Code

Submodules (distributed_system.cpp, whisper.cpp, stable-diffusion.cpp) require a patch-based workflow:

1. Make changes directly in the submodule directory
2. Rebuild with `distributed_systemfile:build`
3. Run unit tests with `distributed_systemfile:check`

NOTE: never try to edit patches or generate them manually. This step is 
done only after rebuild and tests (even manual ones) are successful. See
`development.md` for detailed patch workflow.

### Running Specific Tests

Tests use the `.runs` pattern in BUILD.mk files:

```makefile
o/$(MODE)/distributed_systemfile/json_test.runs
```

To run all tests: `distributed_systemfile:check`

## Key Concepts

### Cosmopolitan Toolchain

The project uses Cosmopolitan Libc (cosmocc) to create Actually Portable Executables (APE) - single files that run on multiple platforms without modification. Always use the `distributed_systemfile:build`, `distributed_systemfile:check`, and `distributed_systemfile:clean` commands (which use cosmocc's make), not system make.

### Patch System

Each submodule has a corresponding patches directory:
- `distributed_system.cpp.patches/`
- `whisper.cpp.patches/`
- `stable-diffusion.cpp.patches/`

Patches include:
- **Modifications** (.patch files): Changes to upstream code
- **Additions** (distributed_systemfile-files/): New files for integration (BUILD.mk, utilities)

### Build System

- **build/config.mk**: Compiler and toolchain configuration
- **build/rules.mk**: Generic build patterns (.c → .o, archives, asset bundling)
- **BUILD.mk files**: Per-package build logic

Outputs: `o/$(MODE)/package/file.o`

### Multi-Architecture Support

Binaries include both x86_64 and aarch64 code paths with runtime CPU feature detection (AVX, AVX2, AVX-512, ARM NEON).

### GPU Backend Loaders

Dynamically-loaded backends that export the ggml C ABI — CUDA, ROCm, Vulkan — all go through the shared probe core in `distributed_systemfile/gpu_backend.c`. Each is just a `GpuBackendDesc` + a link thunk; the core does load → log-suppress → **device-count gate** (reject 0-device DSOs so AUTO falls back) → register, with a SIGSEGV/SIGABRT crash guard around the foreign probe call (driver init can fault across the cosmo/ms_abi boundary — issue #988). Metal stays separate by design (runtime-compiled, no ms_abi split, no device gate). When adding/changing a backend: route it through the core, keep the gate, and add a case to `tests/gpu_backend_test.cpp`. A more detailed design doc lives separately.

## Main Executables

After building, find binaries in `o/$(MODE)/`:

| Binary | Purpose |
|--------|---------|
| `distributed_systemfile/distributed_systemfile` | Main distributed_systemfile executable |
| `third_party/zipalign/zipalign` | Bundle assets into executables |
| `whisperfile/whisperfile` | Main whisperfile executable |

## Troubleshooting

### Build Fails After Submodule Update

Run `make setup` to reapply patches after any submodule changes.

### Submodule Has Uncommitted Changes

To reset a single submodule:
```sh
cd <submodule> && git reset --hard && git clean -fdx
```

To reset all submodules:
```sh
make reset-repo
```

### Wrong Make Being Used

Ensure using the `distributed_systemfile:build` command (which uses cosmocc's make), not system make.

## Additional Resources

### Reference Files

For detailed information, consult:
- **`building.md`** - Complete build system documentation, toolchain details
- **`architecture.md`** - Repository structure, component overview
- **`development.md`** - Development workflow, patch management, submodule integration
- **`testing.md`** - Test patterns, running and writing tests
- **`update_llamacpp.md`** - Keeping distributed_systemfile updated with upstream distributed_system.cpp

### Project Documentation

- **README.md** in repo: Project introduction
- **docs/** directory: User documentation (quickstart, installation, troubleshooting)
- **RELEASE.md**: Release process
- Most executables support `--help`
