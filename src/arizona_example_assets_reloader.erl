-module(arizona_example_assets_reloader).
-behaviour(arizona_reloader).

-export([reload/2]).

-spec reload(Files, Opts) -> Result when
    Files :: arizona_reloader:reload_files(),
    Opts :: map(),
    Result :: arizona_reloader:reload_result().
reload(_Files, _Opts) ->
    arizona_pubsub:broadcast(~"reload", assets).
