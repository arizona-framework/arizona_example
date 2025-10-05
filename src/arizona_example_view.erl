-module(arizona_example_view).
-behaviour(arizona_view).
-compile({parse_transform, arizona_parse_transform}).

-export([mount/2]).
-export([render/1]).

-spec mount(MountArg, Req) -> View when
    MountArg :: arizona_view:mount_arg(),
    Req :: arizona_request:request(),
    View :: arizona_view:view().
mount(_MountArg, _Req) ->
    Bindings = #{
        id => ~"app",
        count => 0
    },
    Layout =
        {arizona_example_layout, render, inner_content, #{
            title => ~"Arizona Example"
        }},
    % Initialize view with bindings and layout
    arizona_view:new(?MODULE, Bindings, Layout).

-spec render(Bindings) -> Template when
    Bindings :: map(),
    Template :: arizona_template:template().
render(Bindings) ->
    arizona_template:from_erl(
        {main, [{id, arizona_template:get_binding(id, Bindings)}],
            arizona_template:render_stateful(arizona_example_counter, #{
                id => ~"counter",
                count => arizona_template:get_binding(count, Bindings)
            })}
    ).
