# API

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

## Parsing rules

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
are not supported.

## Results and lifetimes

Results borrow option names from the specification and values from `argv`.
Keep both alive while using the result; Goose checks these lifetimes.
The result owns its entry and positional lists and error message. `help`
returns an owned text builder. Argument text is not copied.

Input sizes and output allocations have no library-specific cap. Applications
parsing data beyond OS-provided argv should bound token counts and byte lengths.
Error messages include input bytes and help includes caller-provided text;
escape these before displaying untrusted content in a terminal or log.
