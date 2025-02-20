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
    <!DOCTYPE html>
    <html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta http-equiv="X-UA-Compatible" content="IE=edge">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>{arizona_view:get_assign(title, View)}</title>
        <script src="assets/js/arizona/worker.js"></script>
        <script src="assets/js/arizona/main.js"></script>
        <script src="assets/js/main.js"></script>
    </head>
    <body id="{arizona_view:get_assign(id, View)}">
        {arizona_render:component(arizona_example_components, counter, #{
            count => 0
        })}
    </body>
    </html>
    """").
