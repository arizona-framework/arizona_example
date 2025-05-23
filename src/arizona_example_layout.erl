-module(arizona_example_layout).
-compile({parse_transform, arizona_transform}).
-behaviour(arizona_layout).

-export([mount/2]).
-export([render/1]).

-ignore_xref([render/1]).

-spec mount(Bindings, Socket) -> View when
    Bindings :: arizona:bindings(),
    Socket :: arizona:socket(),
    View :: arizona:view().
mount(Bindings, _Socket) ->
    arizona:new_view(?MODULE, Bindings).

-spec render(View) -> Rendered when
    View :: arizona:view(),
    Rendered :: arizona:rendered_layout_template().
render(View) ->
    arizona:render_layout_template(View, ~""""
    <!DOCTYPE html>
    <html lang="en" style="height: 100%;">
    <head>
        <meta charset="UTF-8">
        <meta http-equiv="X-UA-Compatible" content="IE=edge">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>{arizona:get_binding(title, View)}</title>
        <script src="assets/js/arizona/main.js"></script>
        <script src="assets/js/main.js"></script>
    </head>
    <body style="height: 100%; margin: 0;">
        {arizona:get_binding(inner_content, View)}
    </body>
    </html>
    """").
