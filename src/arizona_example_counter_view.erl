-module(arizona_example_counter_view).
-compile({parse_transform, arizona_transform}).
-behaviour(arizona_view).

-export([mount/2]).
-export([render/1]).
-export([handle_event/3]).

-spec mount(Bindings, Socket) -> Return when
    Bindings :: arizona:bindings(),
    Socket :: arizona:socket(),
    Return :: arizona:mount_ret().
mount(Bindings, _Socket) ->
    View = arizona:new_view(?MODULE, Bindings#{
        count => maps:get(count, Bindings, 0)
    }),
    {ok, View}.

-spec render(View) -> Rendered when
    View :: arizona:view(),
    Rendered :: arizona:rendered_view_template().
render(View) ->
    arizona:render_view_template(View, ~"""
    <div id="{arizona:get_binding(id, View)}">
        <span>{integer_to_binary(arizona:get_binding(count, View))}</span>
        {arizona:render_component(arizona_example_components, button, #{
            handler => arizona:get_binding(id, View),
            event => ~"incr",
            payload => 1,
            text => ~"Increment"
         })}
    </div>
    """).

-spec handle_event(EventName, Payload, View0) -> View1 when
    EventName :: arizona:event_name(),
    Payload :: arizona:event_payload(),
    View0 :: arizona:view(),
    View1 :: arizona:view().
handle_event(~"incr", Incr, View) ->
    Count = arizona:get_binding(count, View),
    arizona:put_binding(count, Count + Incr, View).
