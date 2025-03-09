-module(arizona_example_counter).
-export([create/0]).
-export([get_count/0]).
-export([incr_count/0]).

-spec create() -> ok.
create() ->
    Ref = counters:new(1, [atomics]),
    persistent_term:put(counters, Ref).

-spec get_count() -> integer().
get_count() ->
    Ref = persistent_term:get(counters),
    counters:get(Ref, 1).

-spec incr_count() -> ok.
incr_count() ->
    Ref = persistent_term:get(counters),
    counters:add(Ref, 1, 1).
