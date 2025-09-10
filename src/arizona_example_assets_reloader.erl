-module(arizona_example_assets_reloader).
-behaviour(arizona_reloader).

-export([reload/1]).

-spec reload(Files) -> Result when
    Files :: arizona_reloader:reload_files(),
    Result :: arizona_reloader:reload_result().
reload(_Files) ->
    arizona_pubsub:broadcast(~"reload", assets).
