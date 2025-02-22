-module(arizona_example_page_view).
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
    View = arizona_view:new(?MODULE, Assigns),
    {ok, View}.

-spec render(View) -> Token when
    View :: arizona_view:view(),
    Token :: arizona_render:token().
render(View) ->
    arizona_render:view_template(View, ~"""
    <div id="{arizona_view:get_assign(id, View)}">
        {arizona_render:view(arizona_example_counter_view, #{
            id => ~"counter0"
        })}

        {arizona_render:view(arizona_example_counter_view, #{
            id => ~"counter10",
            count => 10
        })}
    </div>
    """).

-spec handle_event(Event, Payload, View0) -> View1 when
    Event :: arizona_view:event(),
    Payload :: arizona_view:payload(),
    View0 :: arizona_view:view(),
    View1 :: arizona_view:view().
handle_event(_Event, _Payload, View) ->
    View.
