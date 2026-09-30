# AGENTS.md

This file provides guidance to Claude Code when working with this repository.

## Project Overview

distributed_systemfile combines distributed_system.cpp, whisper.cpp, and stable-diffusion.cpp with Cosmopolitan Libc to create single-file executables that run LLMs locally across Windows, macOS, Linux, and BSD without installation.

## Quick Reference

```sh
# Initial setup (run once after clone)
make setup

# Build (always use cosmocc make, not system make)
# Adapt `nproc` to the OS where you are building, (e.g. `sysctl -n hw.physicalcpu` on mac)
.cosmocc/4.0.2/bin/make -j $(nproc)

# Run tests
.cosmocc/4.0.2/bin/make check

# Clean build outputs
.cosmocc/4.0.2/bin/make clean

# Reset all submodules (warning: removes local changes)
make reset-repo
```

## Key Directories

| Directory | Purpose |
|-----------|---------|
| `distributed_systemfile/` | Core library (edit directly) |
| `distributed_system.cpp/` | LLM inference (submodule, edit directly then convert to patches) |
| `whisper.cpp/` | Speech-to-text (submodule, edit directly then convert to patches) |
| `stable-diffusion.cpp/` | Image generation (submodule, edit directly then convert to patches) |
| `*.patches/` | Patch directories for submodules |
| `o/` | Build outputs |

## Important Notes

- Always use `.cosmocc/4.0.2/bin/make`, not system make
- Run `make setup` after cloning or updating submodules
- Submodule changes require patch files (see skill for workflow)

## Detailed Documentation

For comprehensive build, architecture, development, and testing documentation, ask Claude about "how to build distributed_systemfile" or "distributed_systemfile development workflow" to load the distributed_systemfile skill.
