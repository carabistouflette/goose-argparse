> Historical validation record from 2026-11-04. See [current results](../RESULTS.md).

# Validation and performance

On 2026-11-04, the parser at `d23af7aff17c6720d17a2e8f6b80bd3bf8f14275`
passed `make check test` with the pinned Goose compiler
`eadca409f68210893f366e60d0c2f0dc29a339be` on x86-64 Arch Linux,
Linux 7.2.11, GCC 16.2.1. The local run reused a compiler binary built from
that revision; a fresh standalone setup is separately exercised in CI.

The checks cover formatting, type checking, parser execution through Goose's
in-process runner and an optimized native executable, and seven subprocess
cases for the example CLI. Parser coverage includes empty inputs, grouped
short flags, attached and empty values, repeated options, positionals, `--`,
invalid specifications, exact error messages, help output, and NUL bytes
that must not match an absent short alias. The successful output is:

```text
parser tests passed
parser tests passed
CLI tests passed
```

Reproduce from a standalone clone:

```sh
make setup
make check test
```

Use a fresh clone for source provenance: the current setup script checks out
the pinned revision but does not reject every local modification in a reused
`.toolchain/goose` source cache. Treat an existing cache as trusted local input.

The repository contains no timing benchmark or measured throughput ranking.
It does not claim exhaustive fuzz coverage, sanitizer coverage, or validation
on other platforms. Passing these tests does not prove absence of defects.

Performance follows the deliberately small implementation: validating `S`
options compares pairs, and each option lookup scans the specification.
Parsing therefore includes quadratic specification validation and linear
lookups per option occurrence, with byte-comparison costs depending on name
length. Results allocate entry/positional arrays but borrow input text.
`has` and `get` scan the returned entries. This suits small CLI specifications;
measure representative workloads before using large specifications or
optimizing the implementation.
