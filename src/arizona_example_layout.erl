-module(arizona_example_layout).
-compile({parse_transform, arizona_transform}).

-export([render/1]).
-ignore_xref([render/1]).

-spec render(View) -> Rendered when
    View :: arizona:view(),
    Rendered :: arizona:rendered_view_template().
render(View) ->
    arizona:render_view_template(View, ~""""
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
