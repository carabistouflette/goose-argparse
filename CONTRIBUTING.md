# Contributing

Keep changes small, understandable, and tested. The library is pure Goose;
no runtime dependencies or native build sidecar are required.

## Workflow

1. Start from an up-to-date `main` and create a focused branch, such as
   `feat/required-options` or `fix/empty-value`.
2. Describe the intended behavior before expanding the API. Keep process
   I/O and exit decisions in applications.
3. Add regression coverage for parser behavior changes in
   `tests/parser.goose`. Use `tests/cli.py` for actual process integration.
4. Run `make format`, then `make check test` (or override `GOOSE`).
5. Review `git diff --check` and `git diff`. Commit related changes together
   with a short imperative subject, such as `Fix empty attached values`.
6. Open a pull request describing behavior and validation. Merge after
   review and passing CI. Keep `main` releasable.

`make test` runs the parser through both Goose's in-process runner and a
native executable, then checks the example's output and exit codes. CI
runs the same commands on Ubuntu. The compiler cache is local and ignored.

## Toolchain updates

Change `GOOSE_REVISION` to a reviewed full commit from `aardappel/goose`,
run `make setup`, and run the full checks. Include compatibility changes
in the same pull request. The setup script builds only the core compiler;
this library needs none of Goose's optional graphics or audio packages.

## Releases

Once an API is ready, document changes, run the full checks, merge, and tag
an agreed semantic version, such as `v0.1.0`. Publish the Goose import line
with that tag; recommend a full commit hash for reproducible builds.
No registry, generated manifest, or release automation is needed yet.
