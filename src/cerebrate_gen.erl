-module(cerebrate_gen).
-behavior(gen_server).
-compile(export_all).

handle_cast(_, S) -> {noreply, S}.
code_change(_OldVersion, S, _Extra) -> {ok, S}. 
terminate(_R, _S) -> ok.

start_link() -> gen_server:start_link({local, ?MODULE}, ?MODULE, [], []).

init([]) ->
    io:format("~p: Started!~n", [?MODULE]),
    catch ets:new(cerebrate_nodes, [ordered_set, public, named_table]),
    erlang:send_after(1, self(), tick),
    {ok, #{}}.


handle_call({join, NodeList}, _, S) ->
    lists:foreach(fun(Node)->
            ets:insert(cerebrate_nodes, {Node, false})
        end, NodeList),
    {reply, ok, S};
handle_call({leave, NodeList}, _, S) ->
    lists:foreach(fun(Node)->
            ets:delete(cerebrate_nodes, Node)
        end, NodeList),
    {reply, ok, S}.


handle_info(tick, S) ->
    NodesTuple = ets:tab2list(cerebrate_nodes),
    Nodes = [Node||{Node,_}<-NodesTuple],
    ToConnect = Nodes -- nodes(),
    lists:foreach(fun(Node) ->
            p_connect_node(Node)
        end, ToConnect),
    erlang:send_after(1000, self(), tick),
    {noreply, S}.


p_connect_node(Node) ->
    {ok, LocalNamesPropsList} = net_adm:names(),
    LocalNames = [list_to_atom(NodeF)||{NodeF,_}<-LocalNamesPropsList],
    case lists:member(Node, LocalNames) of
        false -> ignore;
        true -> net_adm:connect_node(Node)
    end,

    case net_adm:names(Node) of
        {error, _} -> ignore;
        {ok, RemoteNamesPropsList} ->
            RemoteNames = [list_to_atom(NodeF)||{NodeF,_}<-RemoteNamesPropsList],
            case lists:member(Node, RemoteNames) of
                false -> ignore;
                true ->
                    BinNode = atom_to_binary(Node, latin1),
                    FullNode = binary_to_atom(<<BinNode, "@", BinNode>>, latin1),
                    net_adm:connect_node(FullNode)
            end
    end.