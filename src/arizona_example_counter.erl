-module(arizona_example_counter).
-behaviour(arizona_stateful).
-compile({parse_transform, arizona_parse_transform}).

-export([mount/1]).
-export([render/1]).
-export([handle_event/3]).

-spec mount(Bindings) -> State when
    Bindings :: arizona_binder:map(),
    State :: arizona_stateful:state().
mount(Bindings) ->
    arizona_stateful:new(?MODULE, Bindings).

-spec render(Bindings) -> Template when
    Bindings :: arizona_binder:bindings(),
    Template :: arizona_template:template().
render(Bindings) ->
    arizona_template:from_string(~"""
    <div id="{arizona_template:get_binding(id, Bindings)}">
        <span>{arizona_template:get_binding(count, Bindings)}</span>
        {arizona_template:render_stateless(arizona_example_components, button, #{
            text => ~"Increment",
            onclick => <<"arizona.sendEvent("
                "'incr', "
                "\{incr: 1}, "
                "'", (arizona_template:get_binding(id, Bindings))/binary, "'"
            ")">>
         })}
    </div>
    """).

-spec handle_event(Event, Params, State) -> {noreply, State1} when
    Event :: arizona_stateful:event_name(),
    Params :: arizona_stateful:event_params(),
    State :: arizona_stateful:state(),
    State1 :: arizona_stateful:state().
handle_event(~"incr", #{~"incr" := Incr}, State) ->
    Count = arizona_stateful:get_binding(count, State),
    State1 = arizona_stateful:put_binding(count, Count + Incr, State),
    {noreply, State1}.
