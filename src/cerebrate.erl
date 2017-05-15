-module(cerebrate).
-compile(export_all).

join(NodeList) ->
    gen_server:call(cerebrate_gen, {join, NodeList}).

block(NodeList) ->
    (fun Loop() ->
        Nodes = nodes(),
        Done = lists:all(fun(Node)-> 
                lists:member(Node, Nodes) 
            end, NodeList),
        case Done of
            true -> unblock;
            false ->
                timer:sleep(1000),
                Loop()
        end
    end)().




