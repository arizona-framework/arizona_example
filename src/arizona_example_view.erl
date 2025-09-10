-module(arizona_example_view).
-behaviour(arizona_view).
-compile({parse_transform, arizona_parse_transform}).

-export([mount/2]).
-export([render/1]).
-export([handle_event/3]).

-spec mount(MountArg, Req) -> View when
    MountArg :: arizona_view:mount_arg(),
    Req :: arizona_request:request(),
    View :: arizona_view:view().
mount(_MountArg, Req) ->
    _ = arizona_live:is_connected(self()) andalso initialize_connected_session(),
    % Parse query parameters from request
    {QueryParams, _Req1} = arizona_request:get_params(Req),
    CountParam = proplists:get_value(~"count", QueryParams, ~"0"),
    Count = binary_to_integer(CountParam),
    Layout =
        {arizona_example_layout, render, inner_content, #{
            title => ~"Arizona Example"
        }},
    % Initialize view with bindings and layout
    arizona_view:new(
        ?MODULE,
        #{
            id => ~"app",
            count => Count
        },
        Layout
    ).

-spec render(Bindings) -> Template when
    Bindings :: arizona_binder:bindings(),
    Template :: arizona_template:template().
render(Bindings) ->
    arizona_template:from_string(~"""
    <main id="{arizona_template:get_binding(id, Bindings)}">
        {arizona_template:render_stateful(arizona_example_counter, #{
            id => ~"counter",
            count => arizona_template:get_binding(count, Bindings)
        })}
    </main>
    """).

-spec handle_event(Event, Params, View) -> Result when
    Event :: arizona_stateful:event_name(),
    Params :: arizona_stateful:event_params(),
    View :: arizona_view:view(),
    Result :: {reply, Reply, View1} | {noreply, View1},
    Reply :: arizona_stateful:event_reply(),
    View1 :: arizona_view:view().
handle_event(~"reload", FileType, View) ->
    {reply, #{~"reload" => FileType}, View}.

initialize_connected_session() ->
    arizona_pubsub:join(~"reload", self()).
