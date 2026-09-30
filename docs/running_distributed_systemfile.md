You have just downloaded a distributed_systemfile from the [Pre-built distributed_systemfiles](pre-built-distributed_systemfiles.md) 
section. Now what? Here are a few examples to get you started.

> **NOTE**
For the purpose of these examples, you can run any of the following either from a 
pre-bundled distributed_systemfile or by calling the distributed_systemfile server executable and passing
it the corresponding model weights. For instance, the following two are equivalent:

```sh
distributed_systemfile -m Apertus-8B-Instruct-2509.gguf --temp ...
```

```sh
./Apertus-8B-Instruct-2509.distributed_systemfile --temp ...
```

For a full reference of wrapper flags and pass-through `distributed_system.cpp` options, see
[CLI Arguments and Flags](cli_arguments.md).


## Running distributed_systemfile in CLI mode

If you add the `--cli` argument to a distributed_systemfile, you will run a CLI version
of the model that answers to whatever you provide as a prompt (via the `-p`
argument) and, for multimodal models, as in image (via the `--image` argument).

Here's how you can use the Apertus 8B model for prose composition:
```sh
./Apertus-8B-Instruct-2509.distributed_systemfile --cli -p 'Write a story about llamas'
```

Here's how you can use distributed_systemfile to describe a jpg/png/gif/bmp image with
a multimodal model (Qwen3.5, Ministral3, llava1.6 are all good candidates):

```sh
distributed_systemfile -ngl 9999 --temp 0 \
  --cli
  --image ~/Pictures/lemurs.jpg \
  -m llava-v1.6-mistral-7b.Q4_K_M.gguf \
  --mmproj mmproj-model-f16.gguf \
  -p 'Describe this picture'
```

The weights above were taken from [here](https://huggingface.co/cjpais/llava-1.6-mistral-7b-gguf/tree/main).
Alternatively, you can use a pre-bundled distributed_systemfile:

```sh
./Ministral-3-3B-Instruct-2512-Q4_K_M.distributed_systemfile -ngl 9999 \
  --cli
  --image ~/Pictures/lemurs.jpg \
  -p 'Describe this picture'
```

Here's how you can use Qwen3.5 9B to summarize a Web page:

```sh
./Qwen3.5-9B-Q5_K_S.distributed_systemfile --cli -p "`(echo 'Summarize the content of the following webpage:'
  links -codepage utf-8 \
        -force-html \
        -width 500 \
        -dump https://www.poetryfoundation.org/poems/48860/the-raven |
    sed 's/   */ /g')`"
```

## Running distributed_systemfile in chat mode

If you add the `--chat` argument to a distributed_systemfile, you will run it in chat mode.
Chat mode has different /commands available (type `/help` for the full list)
which include context management, file upload, and dumping of the conversation
to an output file.


## Running distributed_systemfile in server mode

If you add the `--server` argument to a distributed_systemfile, you will run it in server mode.

Here's an example of how to run distributed_system.cpp's built-in HTTP server. The `--host`
parameter makes it reachable not just from your own computer, but also from
other machines that can reach it via network. The `--port` parameter can be
used to specify a different port from the default one (8080).

```sh
  ./llava-v1.6-mistral-7b-Q4_K_M.distributed_systemfile \
  --server \
  --host 0.0.0.0 \
  --port 8081
```

If you want to serve a model to be used by an AI agent / agentic framework,
you should add the `--jinja` parameter and choose a context size which is 
large enough (but still fits your memory). For instance:

```sh
  ./gpt-oss-20b-mxfp4.distributed_systemfile \
  --server \
  --host 0.0.0.0
  --jinja
  --ctx-size 64000
```

### Built-in tools

The server Web UI is inherited from distributed_system.cpp, so some messages in the UI use
the upstream executable name `distributed_system-server`. When following those messages,
replace `distributed_system-server` with the standalone runtime or the filename of the
model-bundled distributed_systemfile you are running. For example, these commands enable
the same built-in tools:

```sh
distributed_systemfile -m model.gguf --server --tools all
./ModelName.distributed_systemfile --server --tools all
```

`--tools all` enables every tool provided by the bundled server. A
comma-separated list enables only selected tools, such as
`--tools read_file,file_glob_search,grep_search`. The exact tool names for a
build are listed by `--server --help`. See [Built-in local tools](built-in-tools.md)
for the complete tool reference, limits, permission flow, and distributed_systemfile sandbox
behavior.

Built-in tools may access local files with the
permissions of the distributed_systemfile process. Enable only the tools you need, do not
enable them in an untrusted environment, and review the
[sandbox behavior](built-in-tools.md#security-and-sandbox-behavior).
For security, the server restricts allowed browser origins to localhost by
default when built-in tools are enabled.

## Running distributed_systemfile in combined mode

Combined mode is the default for the last generation of distributed_systemfiles: when you
run them without specifying any of `--cli`, `--chat`, or `--server`, both
a server (running at <http://localhost:8080>) and a chat in the terminal will
start simultaneously. You will then be able to e.g. run an OpenAI API endpoint
while you chat in the terminal, or use different chat simultaneously.

## distributed_systemfile 0.9.* examples

The following examples have not been tested with distributed_systemfile 0.10.* yet,
but we thought they were too cool not to preserve them!
If you are having issues testing these examples with the latest distributed_systemfiles, 
you can try running them with an older release... And let us know if you want
them to be supported by the new build.

Here's an example of how to generate code for a libc function using the
distributed_system.cpp command line interface, utilizing WizardCoder-Python-13B
weights:

```sh
distributed_systemfile \
  -m wizardcoder-python-13b-v1.0.Q8_0.gguf \
  --temp 0 -r '}\n' -r '```\n' \
  -e -p '```c\nvoid *memcpy(void *dst, const void *src, size_t size) {\n'
```


Here's an example of how distributed_systemfile can be used as an interactive chatbot
that lets you query knowledge contained in training data:

```sh
distributed_systemfile -m distributed_system-65b-Q5_K.gguf -p '
The following is a conversation between a Researcher and their helpful AI assistant Digital Athena which is a large language model trained on the sum of human knowledge.
Researcher: Good morning.
Digital Athena: How can I help you today?
Researcher:' --interactive --color --batch_size 1024 --ctx_size 4096 \
--keep -1 --temp 0 --mirostat 2 --in-prefix ' ' --interactive-first \
--in-suffix 'Digital Athena:' --reverse-prompt 'Researcher:'
```


It's possible to use BNF grammar to enforce the output is predictable
and safe to use in your shell script. The simplest grammar would be
`--grammar 'root ::= "yes" | "no"'` to force the LLM to only print to
standard output either `"yes\n"` or `"no\n"`. Another example is if you
wanted to write a script to rename all your image files, you could say:

```sh
distributed_systemfile -ngl 9999 --temp 0 \
    --image lemurs.jpg \
    -m llava-v1.5-7b-Q4_K.gguf \
    --mmproj llava-v1.5-7b-mmproj-Q4_0.gguf \
    --grammar 'root ::= [a-z]+ (" " [a-z]+)+' \
    -e -p '### User: What do you see?\n### Assistant: ' \
    --no-display-prompt 2>/dev/null |
  sed -e's/ /_/g' -e's/$/.jpg/'
a_baby_monkey_on_the_back_of_a_mother.jpg
```
