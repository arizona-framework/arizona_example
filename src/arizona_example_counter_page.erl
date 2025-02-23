-module(arizona_example_counter_page).
-compile({parse_transform, arizona_transform}).
-behaviour(arizona_view).

-export([mount/2]).
-export([render/1]).
-export([handle_event/3]).

-spec mount(Assigns, Socket) -> Return when
    Assigns :: arizona:assigns(),
    Socket :: arizona:socket(),
    Return :: arizona:mount_ret().
mount(Assigns, _Socket) ->
    View = arizona:new_view(?MODULE, Assigns),
    {ok, View}.

-spec render(View) -> Rendered when
    View :: arizona:view(),
    Rendered :: arizona:rendered_view_template().
render(View) ->
    arizona:render_view_template(View, ~"""
    <div id="{arizona:get_assign(id, View)}">
        {arizona:render_view(arizona_example_counter_view, #{
            id => ~"counter0"
        })}

        {arizona:render_view(arizona_example_counter_view, #{
            id => ~"counter10",
            count => 10
        })}
    </div>
    """).

-spec handle_event(Event, Payload, View0) -> View1 when
    Event :: arizona:event_name(),
    Payload :: arizona:event_payload(),
    View0 :: arizona:view(),
    View1 :: arizona:view().
handle_event(_Event, _Payload, View) ->
    View.
