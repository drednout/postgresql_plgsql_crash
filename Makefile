REBAR_BIN = ./rebar3
REBAR = $(REBAR_BIN)

all: compile release

console:
	./_build/default/rel/test_app/bin/test_app console

compile:
	$(REBAR) compile


release:
	$(REBAR) release


