-module(arizona_example_counter).
-behaviour(arizona_stateful).
-compile({parse_transform, arizona_parse_transform}).

-export([mount/1]).
-export([render/1]).
-export([handle_event/3]).

-spec mount(Bindings) -> State when
    Bindings :: map(),
    State :: arizona_stateful:state().
mount(Bindings) ->
    arizona_stateful:new(?MODULE, Bindings).

-spec render(Bindings) -> Template when
    Bindings :: map(),
    Template :: arizona_template:template().
render(Bindings) ->
    arizona_template:from_erl(
        {'div', [{id, arizona_template:get_binding(id, Bindings)}], [
            {span, [], arizona_template:get_binding(count, Bindings)},
            arizona_template:render_stateless(arizona_example_components, button, #{
                text => ~"Increment",
                onclick => [
                    ~"arizona.pushEventTo('",
                    arizona_template:get_binding(id, Bindings),
                    ~"', 'incr', {incr: 1})"
                ]
            })
        ]}
    ).

-spec handle_event(Event, Payload, State) -> Result when
    Event :: arizona_stateful:event_name(),
    Payload :: arizona_stateful:event_payload(),
    State :: arizona_stateful:state(),
    Result :: arizona_stateful:handle_event_result().
handle_event(~"incr", #{~"incr" := Incr}, State) ->
    Count = arizona_stateful:get_binding(count, State),
    State1 = arizona_stateful:put_binding(count, Count + Incr, State),
    {[], State1}.
