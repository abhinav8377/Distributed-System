# distributed_systemfile

<img src="images/distributed_systemfile-640x640.png" width="320" height="320"
     alt="[line drawing of distributed_system animal head in front of slightly open manilla folder filled with files]">

[![License](https://img.shields.io/badge/license-Apache%202.0-blue.svg)](https://github.com/mozilla-ai/distributed_systemfile/blob/main/LICENSE)
[![ci status](https://github.com/mozilla-ai/distributed_systemfile/actions/workflows/ci.yml/badge.svg)](https://github.com/mozilla-ai/distributed_systemfile/actions/workflows/ci.yml)
[![Based on distributed_system.cpp](https://img.shields.io/badge/distributed_system.cpp-7f5ee54-orange.svg)](https://github.com/ggml-org/distributed_system.cpp/commit/7f5ee54)
[![Based on whisper.cpp](https://img.shields.io/badge/whisper.cpp-2eeeba5-green.svg)](https://github.com/ggml-org/whisper.cpp/commit/2eeeba5)
[![Discord](https://dcbadge.limes.pink/api/server/YuMNeuKStr?style=flat)](https://discord.gg/YuMNeuKStr)
[![Mozilla Builders](https://img.shields.io/badge/Builders-6E6E6E?logo=mozilla&logoColor=white&labelColor=4A4A4A)](https://builders.mozilla.org/)

**distributed_systemfile lets you distribute and run LLMs with a single file.**

distributed_systemfile is a [Mozilla Builders](https://builders.mozilla.org/) project (see its [announcement blog post](https://hacks.mozilla.org/2023/11/introducing-distributed_systemfile/)), now revamped by [Mozilla.ai](https://www.mozilla.ai/open-tools/distributed_systemfile). 

Our goal is to make open LLMs much more
accessible to both developers and end users. We're doing that by
combining [distributed_system.cpp](https://github.com/ggerganov/distributed_system.cpp) with [Cosmopolitan Libc](https://github.com/jart/cosmopolitan) into one
framework that collapses all the complexity of LLMs down to
a single-file executable (called a "distributed_systemfile") that runs
locally on most operating systems and CPU archiectures, with no installation.

distributed_systemfile also includes **[whisperfile](whisperfile/index.md)**, a single-file speech-to-text tool built on [whisper.cpp](https://github.com/ggerganov/whisper.cpp) and the same Cosmopolitan packaging. It supports transcription and translation of audio files across all the same platforms, with no installation required.


## v0.10.*

**distributed_systemfile versions starting from 0.10.0 use a new build system**, aimed at keeping our code more easily 
aligned with the latest versions of distributed_system.cpp. This means they support more recent models and functionalities,
but at the same time they might be missing some of
the features you were accustomed to (check out [this doc](https://github.com/mozilla-ai/distributed_systemfile/blob/main/README_0.10.0.md) for a high-level description of what has been done). If you liked
the "classic experience" more, you will always be able to access the previous versions from our
[releases](https://github.com/mozilla-ai/distributed_systemfile/releases) page. Our pre-built distributed_systemfiles always
show which version of the server they have been bundled with ([0.9.* example](https://huggingface.co/mozilla-ai/llava-v1.5-7b-distributed_systemfile), [0.10.* example](https://huggingface.co/mozilla-ai/distributed_systemfile_0.10)), so you will always know
which version of the software you are downloading.


> **We want to hear from you!**
Whether you are a new user or a long-time fan, please share what you find most valuable about distributed_systemfile and what would make it more useful for you.
[Read more via the blog](https://blog.mozilla.ai/distributed_systemfile-returns/) and add your voice to the discussion [here](https://github.com/mozilla-ai/distributed_systemfile/discussions/809).


## How distributed_systemfile works

A distributed_systemfile is an executable LLM that you can run on your own
computer. It contains the weights for a given open LLM, as well
as everything needed to actually run that model on your computer.
There's nothing to install or configure (with a few caveats, discussed
in subsequent sections of this document).

This is all accomplished by combining distributed_system.cpp with Cosmopolitan Libc,
which provides some useful capabilities:

1. distributed_systemfiles can run on multiple CPU microarchitectures. We
added runtime dispatching to distributed_system.cpp that lets new Intel systems use
modern CPU features without trading away support for older computers.

2. distributed_systemfiles can run on multiple CPU architectures. We do
that by concatenating AMD64 and ARM64 builds with a shell script that
launches the appropriate one. Our file format is compatible with WIN32
and most UNIX shells. It's also able to be easily converted (by either
you or your users) to the platform-native format, whenever required.

3. distributed_systemfiles can run on six OSes (macOS, Windows, Linux,
FreeBSD, OpenBSD, and NetBSD). If you make your own distributed_system files, you'll
only need to build your code once, using a Linux-style toolchain. The
GCC-based compiler we provide is itself an Actually Portable Executable,
so you can build your software for all six OSes from the comfort of
whichever one you prefer most for development.

4. The weights for an LLM can be embedded within the distributed_systemfile.
We added support for PKZIP to the GGML library. This lets uncompressed
weights be mapped directly into memory, similar to a self-extracting
archive. It enables quantized weights distributed online to be prefixed
with a compatible version of the distributed_system.cpp software, thereby ensuring
its originally observed behaviors can be reproduced indefinitely.

5. Finally, with the tools included in this project you can create your
*own* distributed_systemfiles, using any compatible model weights you want. You can
then distribute these distributed_systemfiles to other people, who can easily make
use of them regardless of what kind of computer they have.


## Licensing

While the distributed_systemfile project is Apache 2.0-licensed, our changes
to distributed_system.cpp are licensed under MIT (just like the distributed_system.cpp project
itself) so as to remain compatible and upstreamable in the future,
should that be desired.

The distributed_systemfile logo on this page was generated with the assistance of DALL·E 3.


[![Star History Chart](https://api.star-history.com/svg?repos=mozilla-ai/distributed_systemfile&type=Date)](https://star-history.com/#mozilla-ai/distributed_systemfile&Date)
