-module(arizona_example_live_counter).
-behaviour(arizona_live_view).

%% arizona_live_view callbacks.
-export([mount/1]).
-export([render/1]).
-export([handle_event/3]).

%% Component functions.
-export([counter/1]). -ignore_xref([counter/1]).
-export([button/1]). -ignore_xref([button/1]).

%% Libs
-include_lib("arizona/include/arizona.hrl").

%% --------------------------------------------------------------------
%% arizona_live_view callbacks.
%% --------------------------------------------------------------------

-spec mount(Socket) -> Mounted
    when Socket :: arizona_socket:t(),
         Mounted :: {error, arizona_socket:t()}.
mount(Socket) ->
    Count = arizona_socket:get_assign(count, Socket, 0),
    {ok, arizona_socket:put_assign(count, Count, Socket)}.

-spec render(Macros) -> Tree
    when Macros :: arizona_live_view:macros(),
         Tree :: arizona_live_view:tree().
render(Macros0) ->
    Title = arizona_live_view:get_macro(title, Macros0, ~"Arizona"),
    Macros = arizona_live_view:put_macro(title, Title, Macros0),
    ?ARIZONA_LIVEVIEW(Macros, ~"""
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
            btn_text="Increment #1"
            event="incr"
        />
        <.counter
            count={99}
            btn_text="Increment #2"
            event="decr"
        />
    </body>
    </html>
    """).

-spec handle_event(EventName, Payload, Socket) -> Handled
    when EventName :: binary(),
         Payload :: arizona:payload(),
         Socket :: arizona_socket:t(),
         Handled :: {noreply, arizona_socket:t()}.
handle_event(<<"incr">>, _Payload, Socket) ->
    Count = arizona_socket:get_assign(count, Socket) + 1,
    {noreply, arizona_socket:put_assign(count, Count, Socket)};
handle_event(<<"decr">>, _Payload, Socket) ->
    Count = arizona_socket:get_assign(count, Socket) - 1,
    {noreply, arizona_socket:put_assign(count, Count, Socket)}.

%% --------------------------------------------------------------------
%% Component functions.
%% --------------------------------------------------------------------

-spec counter(Macros) -> Tree
    when Macros :: arizona_live_view:macros(),
         Tree :: arizona_live_view:tree().
counter(Macros) ->
    ?ARIZONA_LIVEVIEW(Macros, ~s"""
    <div :stateful>
        <div>Count: {_@count}</div>
        <.button event={_@event} text={_@btn_text} />
    </div>
    """).

-spec button(Macros) -> Tree
    when Macros :: arizona_live_view:macros(),
         Tree :: arizona_live_view:tree().
button(Macros) ->
    ?ARIZONA_LIVEVIEW(Macros, ~s"""
    {% NOTE: On this example, :onclick is and expression to be }
    {%       dynamic. It could be just, e.g., :onclick="incr". }
    <button type="button" :onclick={arizona_js:send(_@event)}>
        {_@text}
    </button>
    """).
