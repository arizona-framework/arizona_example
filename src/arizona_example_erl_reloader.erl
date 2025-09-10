-module(arizona_example_erl_reloader).
-behaviour(arizona_reloader).

-export([reload/1]).

-elvis([{elvis_style, no_debug_call, disable}]).

-spec reload(Files) -> Result when
    Files :: arizona_reloader:reload_files(),
    Result :: arizona_reloader:reload_result().
reload(Files) ->
    try
        CompileResult = os:cmd("rebar3 compile", #{exception_on_failure => true}),
        ok = io:format("~ts", [CompileResult]),
        {ok, Cwd0} = file:get_cwd(),
        Cwd = Cwd0 ++ "/",
        ErlFiles = [F || F <- Files, filename:extension(F) =:= ".erl"],
        lists:foreach(
            fun(AbsFilename) ->
                Filename =
                    case string:prefix(AbsFilename, Cwd) of
                        nomatch -> AbsFilename;
                        Suffix -> Suffix
                    end,
                ok = io:format("===> Reloading module: ~s~n", [Filename]),
                BaseName = filename:basename(Filename, ".erl"),
                Module = list_to_existing_atom(BaseName),
                code:purge(Module),
                code:load_file(Module)
            end,
            ErlFiles
        ),
        ok = io:format("===> Reloading page~n"),
        arizona_pubsub:broadcast(~"reload", erl)
    catch
        error:{command_failed, ResultBeforeFailure, _ExitCode} ->
            io:format("~ts~n", [ResultBeforeFailure])
    end.
