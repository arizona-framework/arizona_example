-module(arizona_example_counter_view).
-compile({parse_transform, arizona_transform}).
-behaviour(arizona_view).

-export([mount/2]).
-export([render/1]).
-export([handle_event/3]).

-spec mount(Assigns, Socket) -> {ok, View} | ignore when
    Assigns :: arizona_view:assigns(),
    Socket :: arizona_socket:socket(),
    View :: arizona_view:view().
mount(Assigns, _Socket) ->
    View = arizona_view:new(?MODULE, Assigns#{
        count => maps:get(count, Assigns, 0)
    }),
    {ok, View}.

-spec render(View) -> Token when
    View :: arizona_view:view(),
    Token :: arizona_render:token().
render(View) ->
    arizona_render:view_template(View, ~"""
    <div id="{arizona_view:get_assign(id, View)}">
        <span>{integer_to_binary(arizona_view:get_assign(count, View))}</span>
        {arizona_render:component(arizona_example_components, button, #{
            handler => arizona_view:get_assign(id, View),
            event => ~"incr",
            payload => 1,
            text => ~"Increment"
         })}
    </div>
    """).

-spec handle_event(Event, Payload, View0) -> View1 when
    Event :: arizona_view:event(),
    Payload :: arizona_view:payload(),
    View0 :: arizona_view:view(),
    View1 :: arizona_view:view().
handle_event(~"incr", Incr, View) ->
    Count = arizona_view:get_assign(count, View),
    arizona_view:put_assign(count, Count + Incr, View).
