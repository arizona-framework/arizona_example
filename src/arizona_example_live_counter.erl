-module(arizona_example_live_counter).
-behaviour(arizona_live_view).

%% arizona_live_view callbacks.
-export([mount/1]).
-export([render/1]).
-export([handle_event/3]).

%% component functions.
-export([counter/1]). -ignore_xref([counter/1]).
-export([button/1]). -ignore_xref([button/1]).

%% arizona_live_view callbacks.

-spec mount(Socket) -> Mounted
    when Socket :: arizona_socket:t(),
         Mounted :: arizona_socket:t().
mount(Socket) ->
    Count = arizona_socket:get_assign(count, Socket, 0),
    arizona_socket:put_assign(count, Count, Socket).

-spec render(Macros) -> Tree
    when Macros :: arizona_template_compiler:macros(),
         Tree :: arizona_tpl_parse:tree().
render(Macros0) ->
    Title = arizona_live_view:get_macro(title, Macros0, ~"Arizona"),
    Macros = arizona_live_view:put_macro(title, Title, Macros0),
    arizona_live_view:parse_str(~"""
    <!DOCTYPE html>
    <html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta http-equiv="X-UA-Compatible" content="IE=edge">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>{_@title}</title>
        <script src="assets/js/main.js"></script>
    </head>
    <body>
        <.counter
            count={_@count}
            btn_text="Increment"
            event="incr"
        />
        <.counter
            count={99}
            btn_text="Decrement"
            event="decr"
        />
    </body>
    </html>
    """, Macros).

-spec handle_event(EventName, Payload, Socket) -> Handled
    when EventName :: binary(),
         Payload :: arizona:payload(),
         Socket :: arizona_socket:t(),
         Handled :: arizona_socket:t().
handle_event(<<"incr">>, _Payload, Socket) ->
    Count = arizona_socket:get_assign(count, Socket) + 1,
    arizona_socket:put_assign(count, Count, Socket);
handle_event(<<"decr">>, _Payload, Socket) ->
    Count = arizona_socket:get_assign(count, Socket) - 1,
    arizona_socket:put_assign(count, Count, Socket).

%% component functions.

-spec counter(Macros) -> Tree
    when Macros :: arizona_template_compiler:macros(),
         Tree :: arizona_tpl_parse:tree().
counter(Macros) ->
    arizona_live_view:parse_str(~"""
    <div :stateful>
        <div>Count: {_@count}</div>
        <.button event={_@event} text={_@btn_text} />
    </div>
    """, Macros).

-spec button(Macros) -> Tree
    when Macros :: arizona_template_compiler:macros(),
         Tree :: arizona_tpl_parse:tree().
button(Macros) ->
    arizona_live_view:parse_str(~"""
    {% Note: in this example, :onclick is an expression, in order to be }
    {%       dynamic. It could be just, e.g., :onclick="incr". }
    <button type="button" :onclick={arizona_js:send(_@event)}>
        {_@text}
    </button>
    """, Macros).
