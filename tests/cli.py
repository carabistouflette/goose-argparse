"""Exercise the example's real argv, output, and exit status."""
import subprocess
import sys


def run(*args):
    return subprocess.run([sys.argv[1], *args], capture_output=True, text=True, check=False)


r = run()
assert (r.returncode, r.stdout, r.stderr) == (0, "Hello, world!\n", ""), r
r = run("-vnGoose", "file", "--", "--literal")
assert (r.returncode, r.stdout, r.stderr) == (
    0, "Hello, Goose!\nPositional arguments: 2\n", ""
), r
r = run("--name=é")
assert (r.returncode, r.stdout, r.stderr) == (0, "Hello, é!\n", ""), r
r = run("--help")
assert r.returncode == 0 and r.stderr == "" and "-n, --name <NAME>" in r.stdout, r
for args, message in [
    (["--unknown"], "unknown option: --unknown\n"),
    (["--name"], "missing value for --name\n"),
    (["--verbose=false"], "flag does not take a value: --verbose\n"),
]:
    r = run(*args)
    assert (r.returncode, r.stdout, r.stderr) == (2, "", message), r
print("CLI tests passed")
