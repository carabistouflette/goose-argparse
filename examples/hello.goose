import argparse from "..";
import os;

fn main() {
    let spec = [
        argparse::flag("help", 'h', "Show this help"),
        argparse::flag("verbose", 'v', "Print extra details"),
        argparse::option("name", 'n', "Who to greet", "NAME"),
    ];
    let argv = args();
    let result = argparse::parse(spec, argv[1..]);
    if result.error != argparse::Error.None {
        write_stderr(str(result.message, "\n"));
        exit(2);
    }
    if result.has("help") {
        write_stdout(argparse::help(spec, "hello", "A small greeting example."));
        return;
    }
    print("Hello, ", result.get("name", "world"), "!");
    if result.has("verbose") { print("Positional arguments: ", result.positionals.len); }
}
