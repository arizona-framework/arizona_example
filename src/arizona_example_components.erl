-module(arizona_example_components).
-compile({parse_transform, arizona_parse_transform}).

-export([button/1]).
-ignore_xref([button/1]).

-spec button(Bindings) -> Template when
    Bindings :: arizona_binder:bindings(),
    Template :: arizona_template:template().
button(Bindings) ->
    arizona_template:from_html(~"""
    <button
        type="{arizona_template:get_binding(type, Bindings, fun() -> ~"button" end)}"
        onclick="{arizona_template:get_binding(onclick, Bindings)}"
    >
        {arizona_template:get_binding(text, Bindings)}
    </button>
    """).
