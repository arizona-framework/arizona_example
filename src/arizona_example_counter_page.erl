-module(arizona_example_counter_page).
-compile({parse_transform, arizona_transform}).
-behaviour(arizona_view).

-export([handle_params/2]).
-export([mount/2]).
-export([render/1]).
-export([handle_join/3]).
-export([handle_event/4]).

-spec handle_params(PathParams, QueryString) -> {true, Bindings} when
    PathParams :: arizona:path_params(),
    QueryString :: arizona:query_string(),
    Bindings :: arizona:bindings().
handle_params(_PathParams, QueryString) ->
    QueryParams = arizona:parse_query_string(QueryString),
    case arizona:get_query_param(count, QueryParams, 10) of
        Count when is_binary(Count) ->
            {true, #{count => binary_to_integer(Count)}};
        Count when is_integer(Count) ->
            {true, #{count => Count}}
    end.

-spec mount(Bindings, Socket) -> Return when
    Bindings :: arizona:bindings(),
    Socket :: arizona:socket(),
    Return :: arizona:mount_ret().
mount(Bindings, _Socket) ->
    View = arizona:new_view(?MODULE, Bindings#{
        bcast_count => arizona_example_counter:get_count()
    }),
    {ok, View}.

-spec render(View) -> Rendered when
    View :: arizona:view(),
    Rendered :: arizona:rendered_view_template().
render(View) ->
    arizona:render_view_template(View, ~"""
    <div
        id="{arizona:get_binding(id, View)}"
        style="display: flex; flex-direction: column; row-gap: 1rem; padding: 1rem;"
    >
        <div>
            {arizona:render_view(arizona_example_counter_view, #{
                id => ~"bcastCounter",
                count => arizona:get_binding(bcast_count, View),
                text => ~"Broadcast Increment",
                on_btn_click => arizona:render_js_event(
                    arizona:get_binding(id, View),
                    ~"broadcast:incr",
                    ~"bcastCounter"
                )
            })}
            <small><em>Open another tab or browser and see the real-time changes!</em></small>
        </div>

        {arizona:render_view(arizona_example_counter_view, #{
            id => ~"counter",
            count => arizona:get_binding(count, View),
            text => ~"Private Increment",
            on_btn_click => arizona:render_js_event(~"counter", ~"incr", 1)
        })}
    </div>
    """).

-spec handle_join(EventName, Payload, View) -> Return when
    EventName :: arizona:event_name(),
    Payload :: arizona:event_payload(),
    View :: arizona:view(),
    Return :: arizona:handle_join_ret().
handle_join(~"broadcast:incr", _Payload, View) ->
    {ok, undefined, View}.

-spec handle_event(Event, Payload, From, View) -> Return when
    Event :: arizona:event_name(),
    Payload :: arizona:event_payload(),
    From :: pid(),
    View :: arizona:view(),
    Return :: arizona:handle_event_ret().
handle_event(~"broadcast:incr", CounterViewId, _From, View) ->
    ok = arizona_example_counter:incr_count(),
    Count = arizona_example_counter:get_count(),
    ok = arizona:broadcast(CounterViewId, ~"set_count", Count),
    {noreply, View}.
