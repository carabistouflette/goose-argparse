# goose-argparse

A command-line argument parser for the
[Goose programming language](https://github.com/aardappel/goose).
It handles long options, short aliases, grouped flags, values, and positional
arguments. Applications decide how to display errors and when to exit.

## Try it

```sh
git clone https://github.com/carabistouflette/goose-argparse.git
cd goose-argparse
git checkout 7f99d1ed74c705be470d479ec0c95b9aa038b603
make setup
export PATH="$PWD/.toolchain/goose/build:$PATH"
goose run examples/hello.goose -- -v --name Goose file.txt
```

Output:

```text
Hello, Goose!
Positional arguments: 1
```

Setup needs Bash, Git, Make, CMake 3.27+, a C++20 compiler, and a C compiler. Linux
also needs libc development headers. `make setup` builds the compiler at
[GOOSE_REVISION](GOOSE_REVISION); it does not install it system-wide.

## Use it

Save this as `hello.goose` and run `goose run hello.goose -- --name Goose`
with the pinned compiler on your PATH:

```goose
import argparse from "carabistouflette/goose-argparse@7f99d1ed74c705be470d479ec0c95b9aa038b603";
import os;

fn main() {
    let spec = [
        argparse::flag("verbose", 'v', "Extra details"),
        argparse::option("name", 'n', "Who to greet", "NAME")
    ];
    let argv = args();
    let result = argparse::parse(spec, argv[1..]);
    if result.error != argparse::Error.None {
        write_stderr(str(result.message, "\n"));
        exit(2);
    }
    print("Hello, ", result.get("name", "world"), "!");
}
```

For a local checkout, use `import argparse from "../goose-argparse";`
instead; the path is relative to your program's root file. The complete
[example](examples/hello.goose) also shows an explicit help flag.

See the [API and parsing rules](API.md) for defaults, repeated options,
empty values, `--`, errors, and borrowed result lifetimes.

## Status and limits

The examples pin a published commit. `main` may move; there are no version
tags or releases yet, and the API may change. CI tests Ubuntu 24.04 with
Goose `eadca409f68210893f366e60d0c2f0dc29a339be`. Other operating systems
and compiler revisions are unverified.

Values stay strings. Required options, subcommands, environment-variable
fallbacks, and shell tokenizing are not supported. Input sizes have no
library-specific cap. Diagnostics include input bytes; escape untrusted
text before displaying it in terminals or logs.

[Validation and performance limits](RESULTS.md) describe what has been
checked. There is no measured speed or throughput claim.

## Development

Run `make check test` after setup; this also needs Make and Python 3.
With an existing pinned compiler, use `make GOOSE=/path/to/goose check test`.
See [CONTRIBUTING.md](CONTRIBUTING.md) for the Git workflow and
[SECURITY.md](SECURITY.md) for vulnerability reporting.

[Apache-2.0](LICENSE).
