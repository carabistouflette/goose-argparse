# Security

This library is in early development. Security fixes target the latest
reviewed default-branch commit; no older release line is maintained.

Report suspected vulnerabilities privately through
[GitHub security advisories](https://github.com/carabistouflette/goose-argparse/security/advisories/new).
Include the source and Goose compiler commits, a minimal reproducer, platform,
and expected versus observed behavior. Avoid public exploit details until a
fix is available. No response-time guarantee is offered.

Parsing does not execute commands or access the environment. Results borrow
argument and specification text; preserve the lifetimes checked by Goose and
check `result.error` before consuming partial results. The parser has no
application-specific resource limits. Callers must bound untrusted input and
escape diagnostic text before displaying it in terminals or logs.
