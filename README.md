# Distributed System

<img src="docs/images/distributed_systemfile-640x640.png" width="320" height="320"
     alt="distributed_system logo">

[![License](https://img.shields.io/badge/license-Apache%202.0-blue.svg)](LICENSE)
[![Based on distributed_system.cpp](https://img.shields.io/badge/distributed_system.cpp-7f5ee54-orange.svg)](https://github.com/ggml-org/distributed_system.cpp/commit/7f5ee54)
[![Based on whisper.cpp](https://img.shields.io/badge/whisper.cpp-2eeeba5-green.svg)](https://github.com/ggml-org/whisper.cpp/commit/2eeeba5)

**Distributed System lets you distribute and run LLMs with a single file.**

This project combines [distributed_system.cpp](https://github.com/ggerganov/distributed_system.cpp) with [Cosmopolitan Libc](https://github.com/jart/cosmopolitan) into one framework that collapses all the complexity of LLMs down to a single-file executable that runs locally on most operating systems and CPU architectures, with no installation required.

The project also includes **whisperfile**, a single-file speech-to-text tool built on [whisper.cpp](https://github.com/ggerganov/whisper.cpp) with the same Cosmopolitan packaging, supporting transcription and translation of audio files across all platforms.

## Features

- **Single-file executables** - No installation or dependencies required
- **Cross-platform** - Runs on Windows, macOS, Linux, and BSD
- **Multiple architectures** - Supports x86_64, ARM64, and more
- **GPU acceleration** - Optional CUDA, ROCm, Metal, and Vulkan support
- **Built-in server** - REST API and web UI included
- **Speech-to-text** - Whisperfile for audio transcription and translation

## Quick Start

Download and run your first model:

```sh
# Download an example model (Qwen3.5 0.8B)
curl -LO https://huggingface.co/mozilla-ai/distributed_systemfile_0.10/resolve/main/Qwen3.5-0.8B-Q8_0.distributed_systemfile

# Make it executable (macOS/Linux/BSD)
chmod +x Qwen3.5-0.8B-Q8_0.distributed_systemfile

# Run it
./Qwen3.5-0.8B-Q8_0.distributed_systemfile
```

**Windows users:** Rename the file to add `.exe` extension before running.

**Note:** Only executables under 4GB can run directly on Windows. For larger models, download the distributed_systemfile binary and run it with external weights (GGUF format).

## Building from Source

### Prerequisites

- Git
- Bash shell
- Make

### Setup

```sh
# Clone the repository
git clone <repository-url>
cd distributed_system

# Initialize submodules and apply patches
make setup

# Build the project
make
```

### GPU Support (Optional)

Build GPU-accelerated backends:

```sh
# NVIDIA GPUs (CUDA)
make cuda

# AMD GPUs (ROCm)
make rocm

# Cross-platform (Vulkan)
make vulkan
```

## Usage

### Running a Model

```sh
# Interactive chat mode
./distributed_systemfile -m model.gguf

# Start server with web UI
./distributed_systemfile -m model.gguf --server --host 0.0.0.0 --port 8080

# Use external weights
./distributed_systemfile --model model.gguf
```

### Creating a Distributed Systemfile

```sh
# Combine model weights with the executable
./distributed_systemfile-convert model.gguf -o mymodel.distributed_systemfile
```

## Documentation

- [CLI Arguments](docs/cli_arguments.md)
- [API Reference](docs/api.md)
- [Building from Source](docs/source_installation.md)
- [Technical Details](docs/technical_details.md)
- [Troubleshooting](docs/troubleshooting.md)

## Project Structure

```
distributed_system/
├── distributed_systemfile/     # Core library and main executable
├── distributed_system.cpp/     # LLM inference engine (submodule)
├── whisper.cpp/               # Speech recognition (submodule)
├── stable-diffusion.cpp/      # Image generation (submodule)
├── whisperfile/               # Speech-to-text tool
├── diffusionfile/             # Image generation tool
├── transcribefile/            # Transcription tool
├── docs/                      # Documentation
├── tests/                     # Test suites
└── third_party/               # Third-party dependencies
```

## License

This project is licensed under the Apache 2.0 License - see the [LICENSE](LICENSE) file for details.

Changes to distributed_system.cpp and whisper.cpp submodules are licensed under MIT to remain compatible with upstream projects.

## Contributing

Contributions are welcome! Please read [CONTRIBUTING.md](CONTRIBUTING.md) for guidelines.

## Support

For issues, questions, or feature requests, please open an issue on the GitHub repository.
