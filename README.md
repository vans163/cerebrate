# cerebrate
A distributed erlang node connector

<img src="http://i.imgur.com/YNlDX6N.gif"/>

"The Overmind controls its minions through agents called Cerebrates. Strike down the Cerebrates, and the Swarms will surely fall." - Tassadar briefs Executor Artanis

## Design
Instead of multicasting, cerebrate relies on net_kernel:hostname/1 to detect erlang nodes.  
cerebrate will first check locally, then remotely by hostname for erlang nodes it can join.  This means a production, dev, or even testing environment should be flexible to connect and attach to as we discard ip addresses.  

cerebrate assumes 1 erlang node per machine, and for distributed erlang, for the machine hostname to be equal to the cname (core_1@core_1).  

cerebrate maintains a process to retry in case of connection failure.  It will stop retrying once the specified nodes are all connected. It will resume retrying if they go down.

## Usage

```erlang

cerebrate:join([core_1, core_2, core_3], [block]).
```

## API
cerebrate:join(ListOfNodes, Options)

ListOfNodes is a list of atoms, where the atom is either the sname of an erlang node, or the hostname of a machine on the network.

Options is a list of options.
    block  This blocks execution until all nodes in ListOfNodes are available in erlang:nodes/0.