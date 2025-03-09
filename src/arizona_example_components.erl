-module(arizona_example_components).

-export([button/1]).
-ignore_xref([button/1]).

-spec button(View) -> Rendered when
    View :: arizona:view(),
    Rendered :: arizona:rendered_component_template().
button(View) ->
    arizona:render_component_template(View, ~"""
    <button
        type="{arizona:get_binding(type, View, ~"button")}"
        onclick="{arizona:get_binding(on_click, View)}"
    >
        {arizona:get_binding(text, View)}
    </button>
    """).
