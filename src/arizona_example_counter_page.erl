-module(arizona_example_counter_page).
-compile({parse_transform, arizona_transform}).
-behaviour(arizona_view).

-export([handle_params/2]).
-export([mount/2]).
-export([render/1]).
-export([handle_event/3]).

-spec handle_params(PathParams, QueryString) -> {true, Bindings} when
    PathParams :: arizona:path_params(),
    QueryString :: arizona:query_string(),
    Bindings :: arizona:bindings().
handle_params(_PathParams, QueryString) ->
    QueryParams = arizona:parse_query_string(QueryString),
    case arizona:get_query_param(count, QueryParams, 0) of
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
    View = arizona:new_view(?MODULE, Bindings),
    {ok, View}.

-spec render(View) -> Rendered when
    View :: arizona:view(),
    Rendered :: arizona:rendered_view_template().
render(View) ->
    arizona:render_view_template(View, ~"""
    <div id="{arizona:get_binding(id, View)}">
        {arizona:render_view(arizona_example_counter_view, #{
            id => ~"counter0",
            count => arizona:get_binding(count, View)
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
