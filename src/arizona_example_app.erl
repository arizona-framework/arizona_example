-module(arizona_example_app).
-behaviour(application).

-export([start/2]).
-export([stop/1]).

-spec start(StartType, StartArgs) -> StartRet when
    StartType :: application:start_type(),
    StartArgs :: term(),
    StartRet :: {ok, pid()} | {error, term()}.
start(_StartType, _StartArgs) ->
    arizona_example_sup:start_link().

-spec stop(State) -> Stopped when
    State :: term(),
    Stopped :: ok.
stop(_State) ->
    ok.
