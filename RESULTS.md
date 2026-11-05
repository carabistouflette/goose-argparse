# Validation and performance

## Current checks

On 2026-11-05, a fresh public clone at
`7f99d1ed74c705be470d479ec0c95b9aa038b603` passed:

- `make check test`: formatting, type checks, parser tests through Goose's
  in-process runner and native executable, and seven CLI subprocess cases.
- The README quickstart example command, with the displayed output.
  Compiler setup was checked through the existing CI run linked below.
- The README program using the full-commit remote import: type check,
  named greeting, default greeting, and unknown-option exit code 2.
- The same program using the documented relative local import.

The local checks reused a Release build of Goose
`eadca409f68210893f366e60d0c2f0dc29a339be`, with no optional built-in
packages, on an Intel Core Ultra 7 258V, x86-64 Arch Linux,
Linux 7.2.11-arch1-1, GCC 16.2.1, and Python 3.14.9.
The compiler source was clean. This audit did not rebuild the compiler.
The unchanged setup script and full checks also passed in
[CI for the public source](https://github.com/carabistouflette/goose-argparse/actions/runs/41800816916).

[Commands, outputs, and source/compiler hashes](docs/validation-2026-11-05.json)
are recorded separately. The parser, example, tests, compiler pin, Makefile,
setup script, and CI workflow are byte-identical between the previously
checked `d23af7a`, public `7f99d1e`, and this documentation update.
The [2026-11-04 validation record](docs/validation-2026-11-04.md) is historical.

To reproduce, use the README's pinned checkout and setup, then:

```sh
make check test
goose run examples/hello.goose -- -v --name Goose file.txt
```

Or use an existing compiler built from `GOOSE_REVISION`:

```sh
make GOOSE=/path/to/goose check test
/path/to/goose run examples/hello.goose -- -v --name Goose file.txt
```

Use a fresh clone when checking the setup process. `make setup` checks out
the pinned compiler revision but does not reject all local changes in a
reused `.toolchain/goose` cache; an existing cache is trusted local input.

## Performance

**Benchmark: not applicable.** There are no timing results, speed rankings,
or quantitative performance claims in the maintained docs. This parser
has no stated performance target that needs a benchmark for this update.
No measurements were run; there are no samples or comparisons to report.

The following costs come from reading the implementation, not timing it:
validating `S` options compares pairs of definitions; each option lookup
scans the specification. Name comparisons also depend on byte length.
`has` and `get` scan the parsed entries. Results allocate entry and
positional lists while borrowing the argument text. Measure your own
workload before relying on large specifications or argument lists.

## Limits of these checks

Tests cover grouped flags, attached/empty/repeated values, positionals,
`--`, invalid specifications, exact diagnostics, generated help, and NUL
bytes that must not match an absent short alias. They do not establish
exhaustive fuzz coverage or sanitizer coverage. CI validates Ubuntu 24.04;
other operating systems and compiler revisions remain unverified. There
are no release tags, and this documentation audit does not create one.
