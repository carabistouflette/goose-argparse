# Contributing

1. Start a focused branch from current `main`.
2. Add regression cases in `tests/parser.goose` for parser changes or
   `tests/cli.py` for process arguments, output, and exit codes.
3. Run `make format`, then `make check test`. Use `GOOSE=/path/to/goose`
   with either command to select an existing pinned compiler.
4. Review `git diff --check` and the diff. Commit related changes together
   with a Conventional Commit subject, such as `fix: reject NUL short aliases`.
5. Open a pull request explaining the behavior and checks. Merge after
   review and passing CI.

Keep process I/O and exit decisions in applications. The library uses only
Goose's standard library; it needs no native build sidecar.

## Checks and toolchain updates

`make check` checks formatting and types. `make test` runs parser tests
through Goose's in-process runner and an optimized native executable, then
checks the example CLI with Python subprocess tests. CI uses the same
commands on Ubuntu 24.04.

To update Goose, change `GOOSE_REVISION` to a reviewed full upstream commit,
run `make setup`, and rerun the checks. Keep the README's compiler support
statement and [validation record](RESULTS.md) consistent with the change.

## Releases

There are no version tags yet. Before the first release, agree on the API,
update the docs, pass the checks, and merge the changes. Publish an agreed
semantic-version tag and its import line. Recommend full commit hashes
for reproducible builds; do not move an existing release tag.
