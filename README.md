# cerebrate
A distributed erlang node connector

<img src="http://i.imgur.com/YNlDX6N.gif"/>

"The Overmind controls its minions through agents called Cerebrates. Strike down the Cerebrates, and the Swarms will surely fall."

## Design
Instead of multicasting, cerebrate relies on net_kernel:hostname/1 to detect erlang nodes.  

cerebrate will first check locally, then remotely by hostname for erlang nodes it can join.  This means a production, dev, staging, or even testing environment should not need seperate configurations.  

cerebrate assumes 1 erlang node per machine. For distributed erlang the machine hostname must be equal to the cname (core_1@core_1).  

cerebrate maintains a process to retry in case of connection failure.  It will stop retrying once the specified nodes are all connected. It will resume retrying if they go down.  

The idea behind cerebrate is to define a few core erlang nodes that can be used to connect the entire distribution.  

## Usage

```erlang

cerebrate:join([core_1, core_2, core_3], [block]).
```

## API
cerebrate:join(ListOfNodes, Options)

ListOfNodes is a list of atoms, where the atom is either the sname of an erlang node, or the hostname of a machine on the network.

Options is a list of options.  
    block - This blocks execution until all nodes in ListOfNodes are available in erlang:nodes/0.