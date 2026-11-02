GOOSE ?= .toolchain/goose/build/goose

.PHONY: setup check test format
setup:
	./scripts/setup-goose.sh

check:
	$(GOOSE) format --check argparse.goose examples tests
	$(GOOSE) check tests/parser.goose
	$(GOOSE) check examples/hello.goose

test:
	$(GOOSE) run tests/parser.goose
	mkdir -p .build
	$(GOOSE) build tests/parser.goose -o .build/parser
	./.build/parser
	$(GOOSE) build examples/hello.goose -o .build/hello
	python3 tests/cli.py .build/hello

format:
	$(GOOSE) format argparse.goose examples tests
