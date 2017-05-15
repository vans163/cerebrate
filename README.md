# cerebrate
A distributed erlang node connector

<img src="http://i.imgur.com/YNlDX6N.gif"/>

"The Overmind controls its minions through agents called Cerebrates. Strike down the Cerebrates, and the Swarms will surely fall."

## Design
Instead of multicasting, cerebrate relies on net_adm:names/1 to detect erlang nodes.  

cerebrate will first check locally, then remotely by hostname for erlang nodes it can join.  This means a production, dev, staging, or even testing environment should not need seperate configurations.  

cerebrate connects to erlang nodes by cname yet connects to remote machines by hostname.    

cerebrate maintains a process to retry in case of connection failure.  It will stop retrying once the specified nodes are all connected. It will resume retrying if they go down.  

The idea behind cerebrate is to define a few core erlang nodes that can be used to connect the entire distribution.  

## Usage

```erlang

cerebrate:join([core_1, core_2, core_3], #{block=> true}).
```

## API
cerebrate:join(ListOfNodes, OptionMap)

ListOfNodes is a list of atoms, where the atom is either the sname of an erlang node, or the hostname of a machine on the network.

OptionMap is a list of options.  
    {block, true} - This blocks execution until all nodes in ListOfNodes are available in erlang:nodes/0.