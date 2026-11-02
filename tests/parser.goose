import argparse from "..";
import std;

fn expect_error(spec: argparse::Option[:], argv: const u8[:][:], error: argparse::Error, message: const u8[:]) {
    let r = argparse::parse(spec, argv);
    assert(r.error == error);
    assert(r.message == message);
}

fn main() {
    let spec = [
        argparse::flag("verbose", 'v', "Extra details"),
        argparse::flag("quiet", 'q'),
        argparse::option("output", 'o', "Destination", "FILE"),
        argparse::option("count", 'c'),
    ];
    {
        let argv: const u8[:][] = [];
        let r = argparse::parse(spec, argv);
        assert(r.error == argparse::Error.None);
        assert(r.entries.len == 0 && r.positionals.len == 0);
        assert(!r.has("verbose"));
        assert(r.get("output", "stdout") == "stdout");
    }
    {
        let argv: const u8[:][] = ["first", "--verbose", "--output=result.txt", "middle", "-qc", "-12", "last"];
        let r = argparse::parse(spec, argv);
        assert(r.error == argparse::Error.None);
        assert(r.has("verbose") && r.has("quiet"));
        assert(r.get("output") == "result.txt");
        assert(r.get("count") == "-12");
        let count, ok = parse_int(r.get("count"));
        assert(ok && count == -12);
        assert(r.positionals.len == 3);
        assert(r.positionals[0] == "first" && r.positionals[1] == "middle" && r.positionals[2] == "last");
    }
    {
        let argv: const u8[:][] = ["-vqoone", "--output", "two", "-othree", "--verbose", "--verbose"];
        let r = argparse::parse(spec, argv);
        assert(r.error == argparse::Error.None);
        assert(r.entries.len == 7);
        assert(r.entries[2].value == "one");
        assert(r.get("output") == "three");
    }
    {
        let argv: const u8[:][] = ["-", "", "--", "--verbose", "-q", "--", "é"];
        let r = argparse::parse(spec, argv);
        assert(r.error == argparse::Error.None && r.entries.len == 0);
        assert(r.positionals.len == 6);
        assert(r.positionals[0] == "-" && r.positionals[1] == "");
        assert(r.positionals[2] == "--verbose" && r.positionals[5] == "é");
    }
    {
        let argv: const u8[:][] = ["--output=", "--count=a=b", "-o", "--", "-c", "--verbose"];
        let r = argparse::parse(spec, argv);
        assert(r.error == argparse::Error.None);
        assert(r.entries[0].value == "");
        assert(r.entries[1].value == "a=b");
        assert(r.get("output") == "--");
        assert(r.get("count") == "--verbose" && !r.has("verbose"));
    }
    {
        let argv: const u8[:][] = ["--output", ""];
        let r = argparse::parse(spec, argv);
        assert(r.error == argparse::Error.None && r.has("output"));
        assert(r.get("output", "fallback") == "");
    }
    {
        let argv:  const u8[:][]      = ["file", "--", "-v"];
        let empty: argparse::Option[] = [];
        let r = argparse::parse(empty, argv);
        assert(r.error == argparse::Error.None && r.positionals.len == 2);
        assert(argparse::validate(spec).len == 0);
    }
    expect_error(spec, ["--unknown"], argparse::Error.UnknownOption, "unknown option: --unknown");
    expect_error(spec, ["--verb"], argparse::Error.UnknownOption, "unknown option: --verb");
    expect_error(spec, ["--unknown=x"], argparse::Error.UnknownOption, "unknown option: --unknown");
    expect_error(spec, ["-vx"], argparse::Error.UnknownOption, "unknown option: -x");
    expect_error(spec, ["--output"], argparse::Error.MissingValue, "missing value for --output");
    expect_error(spec, ["-vqo"], argparse::Error.MissingValue, "missing value for --output");
    expect_error(spec, ["--verbose=false"], argparse::Error.UnexpectedValue, "flag does not take a value: --verbose");
    expect_error(spec, ["--quiet="], argparse::Error.UnexpectedValue, "flag does not take a value: --quiet");
    expect_error([], ["--help"], argparse::Error.UnknownOption, "unknown option: --help");
    expect_error([argparse::flag("")], [], argparse::Error.InvalidSpec, "option name must not be empty");
    expect_error([argparse::flag("bad_name")], [], argparse::Error.InvalidSpec, "invalid option name: bad_name");
    expect_error([argparse::flag("-bad")], [], argparse::Error.InvalidSpec, "invalid option name: -bad");
    expect_error([argparse::flag("bad", '1')], [], argparse::Error.InvalidSpec, "short alias must be an ASCII letter: --bad");
    expect_error([argparse::flag("same"), argparse::option("same")], [], argparse::Error.InvalidSpec, "duplicate option: --same");
    expect_error([argparse::flag("one", 'a'), argparse::flag("two", 'a')], [], argparse::Error.InvalidSpec, "duplicate short alias for --two");
    {
        let text = argparse::help([argparse::flag("help", 'h', "Show help"), argparse::option("output", 0, "Destination", "FILE")], "app", "Example.");
        assert(text == "Usage: app [options] [--] [args...]\n\nExample.\n\nOptions:\n  -h, --help  Show help\n  --output <FILE>  Destination\n");
        assert(argparse::help([], "app") == "Usage: app [options] [--] [args...]\n");
    }
    print("parser tests passed");
}
