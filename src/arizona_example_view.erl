-module(arizona_example_view).
-behaviour(arizona_view).
-compile({parse_transform, arizona_parse_transform}).

-export([mount/1]).
-export([render/1]).

-spec mount(Req) -> View when
    Req :: arizona_request:request(),
    View :: arizona_view:view().
mount(Req) ->
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
