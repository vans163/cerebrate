-module(cerebrate).
-compile(export_all).

join(NodeList) ->
    join(NodeList, #{}).
join(NodeList, OptionMap) ->
    gen_server:call(cerebrate_gen, {join, NodeList, OptionMap}).




