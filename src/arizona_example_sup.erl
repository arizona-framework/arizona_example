-module(arizona_example_sup).
-behaviour(supervisor).

-export([start_link/0]).
-export([init/1]).

-spec start_link() -> Ret when
    Ret :: supervisor:startlink_ret().
start_link() ->
    supervisor:start_link({local, ?MODULE}, ?MODULE, []).

-spec init(Args) -> Init when
    Args :: term(),
    Init :: {ok, {SupFlags, [ChildSpec]}},
    SupFlags :: supervisor:sup_flags(),
    ChildSpec :: supervisor:child_spec().
init(_Args) ->
    SupFlags = #{
        strategy => one_for_all,
        intensity => 0,
        period => 1
    },
    ChildSpecs = [],
    {ok, {SupFlags, ChildSpecs}}.
