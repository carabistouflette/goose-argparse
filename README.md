# goose-argparse

A small, dependency-free command-line argument parser for the
[Goose programming language](https://github.com/aardappel/goose).
Early development: the API may change before the first release.

- Long options, short aliases, grouped flags, and attached values.
- Positional arguments and the `--` end-of-options marker.
- Predictable errors and generated help.
- No hidden process access, printing, or exits.

## Quick start

From this checkout:

```sh
make setup              # builds the pinned Goose compiler locally
make check test
.toolchain/goose/build/goose run examples/hello.goose -- -v --name Goose file.txt
```

Setup requires Git, CMake 3.27+, a C++20 compiler, and a C compiler. Tests
also require Make and Python 3. On Linux, Goose's in-process runner needs
libc development headers. If Goose is already installed, use
`make GOOSE=/path/to/goose check test` instead of setup.

To use the library from a nearby project, declare the package in your
program's root file:

```goose
import argparse from "../goose-argparse";
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

For a remote dependency, Goose accepts
`import argparse from "carabistouflette/goose-argparse@<commit>";`.
Replace `<commit>` with a published commit containing the library. There
are no releases yet. See the complete [example](examples/hello.goose) for
an explicit help flag.

## API

| Function | Behavior |
| --- | --- |
| `flag(name, short = 0, help = "")` | Declare a presence-only flag |
| `option(name, short = 0, help = "", value_name = "VALUE")` | Declare an option taking one string value |
| `parse(spec, argv)` | Parse a slice of argument byte slices **without** the executable name |
| `result.has(name)` | Test whether an option occurred |
| `result.get(name, fallback = "")` | Last value, or fallback if absent |
| `help(spec, program, description = "")` | Return help text, including a trailing newline |
| `validate(spec)` | Return a specification error message, or an empty string |

`Option` is also directly constructible. Its `value_name` is the help
placeholder: empty means flag, nonempty means value option. Names must
start with an ASCII letter, followed by ASCII letters, digits, or hyphens.
Short aliases are optional ASCII letters. Duplicate names or aliases are
specification errors. Names and aliases are case-sensitive.

A `Result` contains `error`, `message`, `entries`, and `positionals`.
`error` is `argparse::Error.None` on success; failures are `InvalidSpec`,
`UnknownOption`, `MissingValue`, or `UnexpectedValue`. Always check it
before using the result: failures may contain entries parsed before the
error. `entries` preserves every occurrence as `{ name, value }`, using
the long name even for short aliases. Flags have an empty value; use `has`
to distinguish absent options from present options with an empty value.

### Parsing rules

- `--output file`, `--output=file`, `-o file`, and `-ofile` supply a value.
- `-vq` groups flags. In `-vqoFILE`, `o` consumes the remaining `FILE`.
- A value option consumes the next token verbatim, even `--` or a token
  beginning with `-`. This allows negative numbers and dash-prefixed paths.
- `--output=` and `--output ""` are valid empty values.
- Flags reject `--verbose=true` and `--verbose=`.
- Repeated options are allowed; `get` returns the last value.
- Options may appear between positionals. A lone `-` and an empty token
  are positional. After a standalone `--`, all tokens are positional.
- Unknown options fail; long names are never abbreviated. Put negative
  positional numbers after `--`.
- `-o=value` supplies the literal `=value`; only long options split `=`.
- Help is explicit: declare `flag("help", 'h', ...)` and call `help` when
  the application chooses. No options are reserved.

Values remain strings. Use Goose's standard `parse_int` / `parse_flt`
functions for conversion and validate domain rules in the application.
Required options, subcommands, environment variables, and shell tokenizing
are outside this initial scope.

### Goose memory model

The library uses `namespace argparse`, fixed-size option declarations,
and grow-only arrays for parsed entries, positional slices, and text
builders. The returned entries **borrow slices from both the specification
and argv**; keep those alive while using the result. Goose checks their
lifetimes. Parsing does not copy argument text. Temporary grow-only builders are
finished into owned, fixed-length result arrays; help returns an owned
text builder and error messages are owned strings. The specification is validated on each parse; lookups are
linear, appropriate for small CLI option sets.

## Development

See [CONTRIBUTING.md](CONTRIBUTING.md) for the branch, test, and release
workflow. [GOOSE_REVISION](GOOSE_REVISION) pins the exact upstream compiler
used by CI; compatibility with other revisions is not yet guaranteed.

Language references used for this implementation:
[language reference](https://aardappel.github.io/goose/docs/reference.html),
[packages](https://aardappel.github.io/goose/docs/packages.html), and
[command line](https://aardappel.github.io/goose/docs/command_line.html).

## License

[Apache-2.0](LICENSE).
