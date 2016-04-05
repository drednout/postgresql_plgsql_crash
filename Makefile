REBAR_BIN = ./rebar3
REBAR = $(REBAR_BIN)

all: compile release

console:
	ln -vsf `pwd`/vm.args _build/default/rel/test_app/releases/0.0.1
	ln -vsf `pwd`/sys.config _build/default/rel/test_app/releases/0.0.1
	./_build/default/rel/test_app/bin/test_app console

compile:
	$(REBAR) compile


release:
	$(REBAR) release


