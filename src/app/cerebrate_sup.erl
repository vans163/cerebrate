-module(cerebrate_sup).
-behaviour(supervisor).
-compile(export_all).

start_link() -> 
    supervisor:start_link({local, ?MODULE}, ?MODULE, []).

init([]) ->
    {ok,
        {
            {one_for_one, 2, 10}, 
            [
                {cerebrate_gen, {cerebrate_gen, start_link, []}, permanent, 5000, worker, dynamic}
            ]
        }
    }.