---
description: Regenerate distributed_systemfile patches from in-place submodule edits
---

# Generate Patches

Capture the current in-place edits of a submodule as patch files, using the
project's `generate_patches.sh` tool. This is the **only** sanctioned way to
produce patches — never hand-craft them with `git diff` (the tool rewrites the
`a/`,`b/` paths to be repo-rooted, strips the volatile `index` line, names files
by convention, and routes new/untracked files into `distributed_systemfile-files/`; a raw
`git diff` gets all of that wrong).

Run it for the `distributed_system.cpp` submodule (the common case). The tool is general and
works for any submodule — swap the directory and output path for `whisper.cpp`
or `stable-diffusion.cpp`.

The subshell keeps the working directory restored even if the tool fails, and
`echo y` answers the script's confirmation prompt non-interactively:

```bash
( cd distributed_system.cpp && echo y | ../tools/generate_patches.sh --output-dir ../distributed_system.cpp.patches )
```

Output lands in `distributed_system.cpp.patches/patches/` (modified files) and
`distributed_system.cpp.patches/distributed_systemfile-files/` (new files, including `BUILD.mk`).

The tool **only writes/overwrites — it never deletes**. If you dropped a patch
during a bump (the file is no longer modified, e.g. upstream absorbed the
change), its old `.patch` will still be sitting in `patches/` and will keep
being applied by `setup`. `git rm` each dropped patch by hand, and confirm the
final count (`ls distributed_system.cpp.patches/patches | wc -l`) matches your intent.

IMPORTANT: only run this **after** the in-place edits are proven to work
(a clean build succeeds and distributed_systemfile runs as expected). Generating patches
from unproven edits bakes in breakage. After generating, verify the patch set
round-trips with `distributed_systemfile:verify-clean`.
