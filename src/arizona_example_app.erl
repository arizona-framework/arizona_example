-module(arizona_example_app).
-behaviour(application).

-export([start/2]).
-export([stop/1]).

-spec start(StartType, StartArgs) -> StartRet when
    StartType :: application:start_type(),
    StartArgs :: term(),
    StartRet :: {ok, pid()} | {error, term()}.
start(_StartType, _StartArgs) ->
    maybe
        % Start Arizona server with routes
        ServerConfig = #{
            port => 8080,
            routes => [
                % Static assets
                {static, ~"/favicon.ico", {priv_file, arizona_example, ~"static/favicon.ico"}},
                {static, ~"/robots.txt", {priv_file, arizona_example, ~"static/robots.txt"}},
                {static, ~"/assets/example", {priv_dir, arizona_example, ~"static/assets"}},
                {static, ~"/assets", {priv_dir, arizona, ~"static/assets"}},
                % Live routes
                {live, ~"/", arizona_example_view},
                % WebSocket endpoint for Live connection
                {live_websocket, ~"/live"}
            ],
            reloader => #{
                enabled => true,
                rules => [
                    #{
                        directories => ["src"],
                        patterns => [".*\\.erl$"],
                        callback => fun(Files) ->
                            os:cmd("rebar3 compile"),
                            lists:foreach(fun(File) ->
                                BaseName = filename:basename(File, ".erl"),
                                Module = list_to_existing_atom(BaseName),
                                % code:purge/1 removes old version from memory
                                % Required before loading new version to avoid conflicts
                                code:purge(Module),
                                % code:load_file/1 loads the newly compiled .beam file
                                % This makes the updated code active in the running system
                                code:load_file(Module)
                            end, Files)
                        end
                    },
                    #{
                        directories => ["priv/static/assets"],
                        patterns => ["favicon\\.ico", ".*\\.js$"]
                    }
                ]
            }
        },
        {ok, _ServerPid} ?= arizona_server:start(ServerConfig),
        {ok, _SupPid} ?= arizona_example_sup:start_link()
    else
        {error, Reason} ->
            {error, Reason}
    end.

-spec stop(State) -> Stopped when
    State :: term(),
    Stopped :: ok.
stop(_State) ->
    ok.
