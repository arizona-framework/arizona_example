-module(arizona_example_components).

-export([counter/1]).

-spec counter(View) -> Token when
    View :: arizona_view:view(),
    Token :: arizona_render:token().
counter(View) ->
    arizona_render:component_template(View, ~""""
    <div id="counter">
        <span>{integer_to_binary(arizona_view:get_assign(count, View))}</span>
        <button type="button">
            Increment
        </button>
    </div>
    """").
