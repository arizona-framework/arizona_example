-module(arizona_example_view_counter).
-compile({parse_transform, arizona_transform}).
-behaviour(arizona_view).

-export([mount/2]).
-export([render/1]).

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
    arizona_render:view_template(View, ~""""
    <div id="{arizona_view:get_assign(id, View)}">
        {arizona_render:component(arizona_example_components, counter, #{
            parent_id => arizona_view:get_assign(id, View),
            count => arizona_view:get_assign(count, View)
        })}
    </div>
    """").
