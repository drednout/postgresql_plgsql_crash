%%%-------------------------------------------------------------------
%% @doc test_app public API
%% @end
%%%-------------------------------------------------------------------

-module('test_app_app').

-behaviour(application).

%% Application callbacks
-export([start/2
        ,stop/1]).

%%====================================================================
%% API
%%====================================================================

start(_StartType, _StartArgs) ->
    test_app:init_pg_test(),
    Concurrency = 1,
    lists:foldr(
        fun(_, _) -> 
            spawn(test_app, run_pg_test, [10000])
        end, 0, lists:seq(1, Concurrency)
     ),
    spawn(test_app, try_to_crash_pg, []),
    'test_app_sup':start_link().

%%--------------------------------------------------------------------
stop(_State) ->
    ok.

%%====================================================================
%% Internal functions
%%====================================================================
