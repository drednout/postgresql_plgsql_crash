-module(test_app).
-export([init_pg_test/0, run_pg_test/1, try_to_crash_pg/0]).
-include_lib("epgsql_pool/include/epgsql_pool.hrl").

init_pg_test() ->
    Host = "localhost",
    Port = 5434,
    User = "test",
    Password = "1",
    Database = "test",
    Params = #epgsql_connection_params{host=Host, port=Port, username=User,
                                        password=Password, database=Database},
    ValidateConnectionRes = epgsql_pool:validate_connection_params(Params),
    if
        ValidateConnectionRes =/= ok ->
            lager:error("Unable to connect to PostgreSQL server with params ~p, reason: ~p~n",
                        [Params, ValidateConnectionRes]),
            init:stop(1);
        true ->
            ok
    end,
    {ok, _} = epgsql_pool:start("test_app", 10, 10, Params).


run_pg_test(QueryCount) -> 
    RunProcedureQuery = "SELECT test_plpy_postgres_crash(trunc(random() * 5 + 1)::integer)",
    lists:foldr(
        fun(_, _) -> 
            {ok, _, QueryInfo} = epgsql_pool:query("test_app", RunProcedureQuery, []),
            lager:debug("QueryInfo is ~p~n~", [QueryInfo])
        end, 
        0, lists:seq(1, QueryCount)).

try_to_crash_pg() -> 
    epgsql_pool:transaction("test_app",
    fun(Worker) ->
        epgsql_pool:query(Worker, "select pg_sleep(1)"),
        epgsql_pool:query(Worker, "lock test"),
        epgsql_pool:query(Worker, "select sum(counter) from test"),
        epgsql_pool:query(Worker, "select pg_sleep(60)")
    end).
