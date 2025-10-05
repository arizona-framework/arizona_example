-module(arizona_example_layout).
-compile({parse_transform, arizona_parse_transform}).

-export([render/1]).
-ignore_xref([render/1]).

-spec render(Bindings) -> Template when
    Bindings :: map(),
    Template :: arizona_template:template().
render(Bindings) ->
    arizona_template:from_erl([
        ~"<!DOCTYPE html>",
        {html, [{lang, ~"en"}], [
            {head, [], [
                {meta, [{charset, ~"UTF-8"}]},
                {meta, [{'http-equiv', ~"X-UA-Compatible"}, {content, ~"IE=edge"}]},
                {meta, [{name, ~"viewport"}, {content, ~"width=device-width, initial-scale=1.0"}]},
                {title, [], arizona_template:get_binding(title, Bindings)},
                {style, [], ~"""
                html {
                    height: 100%;
                }
                body {
                    height: 100%;
                    margin: 0;
                }
                main {
                   display: flex;
                   flex-direction: column;
                   row-gap: 1rem;
                   padding: 1rem;
                }
                """},
                {script, [{type, ~"module"}, {src, ~"/assets/js/main.js"}], []}
            ]},
            {body, [], [
                arizona_template:render_slot(arizona_template:get_binding(inner_content, Bindings))
            ]}
        ]}
    ]).
