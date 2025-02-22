-module(arizona_example_components).

-export([button/1]).
-ignore_xref([button/1]).

-spec button(View) -> Token when
    View :: arizona_view:view(),
    Token :: arizona_render:token().
button(View) ->
    arizona_render:component_template(View, ~"""
    <button
        type="{arizona_view:get_assign(type, View, ~"button")}"
        onclick={arizona_js:send(
            arizona_view:get_assign(handler, View),
            arizona_view:get_assign(event, View), 
            arizona_view:get_assign(payload, View)
        )}
    >
        {arizona_view:get_assign(text, View)}
    </button>
    """).
