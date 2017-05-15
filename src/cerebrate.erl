-module(cerebrate).
-compile(export_all).

join(NodeList) ->
    gen_server:call(cerebrate_gen, {join, NodeList}).

block(NodeList) ->
    block(NodeList, 999999999999).
block(NodeList, Timeout) ->
    EndTime = os:system_time(1000) + Timeout,
    (fun Loop() ->
        Nodes = lists:foldl(fun(Node, Acc) ->
                Bin = atom_to_binary(Node, latin1),
                [BinNode,_] = binary:split(Bin,<<"@">>),
                Acc ++ [binary_to_atom(BinNode, latin1)]
            end, [], nodes()),
        Done = lists:all(fun(Node)->
                lists:member(Node, Nodes) 
            end, NodeList),
        TS = os:system_time(1000),
        if
            TS > EndTime -> throw(cerebrate_block_timeout);
            Done == false ->
                timer:sleep(1000),
                Loop();
            true ->
                unblock
        end
    end)().




