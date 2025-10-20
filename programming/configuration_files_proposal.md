# Configuration files proposal

No one will ever agree on the ideal configuration file format.
Therefore, we should allow people to use their preferred configuration file format in all programs.

## Rough idea

Write libraries for as many languages as possible that read files like:

```
#? yaml
my configuration:
  option: value
```

```
#? json
{"my configuration": {"option": "value"}}
```

and produces a JSON string with the "parsed" input from the second line onwards.
(Or optionally, a data structure appropriate for the language that you are using.)

If your program uses this library to read configuration, then your users can write their configuration in their preferred language.

## Challenges

* How to prevent arbitrary code execution and other attacks?
* How to support as many configuration languages as possible?

## Possible solutions

Use capability-based runtimes and embed capabilities in the first line of the configuration file:

```
                                                  # Allow the specific format parser to...
+file(./**)                                       # ... read files in the same directory as the configuration file and descendants.
+hostname                                         # ... access the hostname.
+load(https://example.com/file,sha256:...,/file)  # ... download a file from the Internet and expose it to the parser.
...
```

Be able to refer to different parsers:

```
# Built-in parsers
json
yaml
...

# Parsers installed on the local system
/path/to/my/parser

# Download parsers on demand
https://example.com/foo-parser
```

## Possible implementation

Use WASM runtimes:

* They already support capabilities.
* Parsers can be distributed as WASM blobs.

Maybe use [Extism](https://github.com/extism/extism) to implement.

## Motivating examples

### Declarative CI

`.github/workflows/workflow.yaml`:

```
#? https://jsonnet.org/jsonnet.wasm +load(https://jsonnetci.com/rust.libsonnet,sha256:...,/rust.libsonnet)
local rust = import '/rust.libsonnet';

rust.github({
  'supported-archs': ['x86_64-unknown-linux-gnu', ...],
  'attach-binaries-to-releases': true,
  'upload-to-docsrs': true,
  ...
})
```

but also `.gitlab-ci.yml`:

```
#? https://jsonnet.org/jsonnet.wasm +load(https://jsonnetci.com/rust.libsonnet,sha256:...,/rust.libsonnet)
local rust = import '/rust.libsonnet';

rust.gitlab(...)
```
