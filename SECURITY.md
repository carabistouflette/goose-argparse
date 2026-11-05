# Security

Security fixes target current `main`. There are no released versions or
maintained older branches.

Report suspected vulnerabilities privately through
[GitHub security advisories](https://github.com/carabistouflette/goose-argparse/security/advisories/new).
Include the library and Goose compiler commits, platform, a minimal
reproducer, and expected and observed behavior. Keep exploit details
private until a fix is available. There is no response-time guarantee.

Check `result.error` before using a result that may be partial. Keep the
specification and argument text alive while using borrowed results.
Bound untrusted token counts and byte lengths in the calling application;
the parser has no resource cap. Escape untrusted diagnostic and help text
before displaying it in a terminal or log. See [API.md](API.md).
