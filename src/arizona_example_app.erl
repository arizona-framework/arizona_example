-module(arizona_example_app).
-behaviour(application).

-export([start/2]).
-export([stop/1]).

-spec start(StartType, StartArgs) -> Started
    when StartType :: application:start_type(),
         StartArgs :: term(),
         Started :: supervisor:startlink_ret().
start(_StartType, _StartArgs) ->
    arizona_example_sup:start_link().

-spec stop(State) -> Stopped
    when State :: term(),
         Stopped :: ok.
stop(_State) ->
    ok.
