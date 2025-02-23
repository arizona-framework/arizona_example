-module(arizona_example_layout).
-compile({parse_transform, arizona_transform}).
-behaviour(arizona_layout).

-export([mount/2]).
-export([render/1]).

-ignore_xref([render/1]).

-spec mount(Assigns, Socket) -> View when
    Assigns :: arizona:assigns(),
    Socket :: arizona:socket(),
    View :: arizona:view().
mount(Assigns, _Socket) ->
    arizona:new_view(?MODULE, Assigns).

-spec render(View) -> Rendered when
    View :: arizona:view(),
    Rendered :: arizona:rendered_layout_template().
render(View) ->
    arizona:render_layout_template(View, ~""""
    <!DOCTYPE html>
    <html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta http-equiv="X-UA-Compatible" content="IE=edge">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>{arizona:get_assign(title, View)}</title>
        {arizona:render_html_scripts()}
        <script src="assets/js/main.js"></script>
    </head>
    <body>
        {arizona:get_assign(inner_content, View)}
    </body>
    </html>
    """").
