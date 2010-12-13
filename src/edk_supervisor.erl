%%%-------------------------------------------------------------------
%%% @author Adam Walters <ajwalters@ajw-imac>
%%% @copyright (C) 2010, Adam Walters
%%% @doc
%%%
%%% @end
%%% Created : 12 Dec 2010 by Adam Walters <ajwalters@ajw-imac>
%%%-------------------------------------------------------------------
-module(edk_supervisor).

-behaviour(supervisor).

%% API
-export([start_link/0]).

%% Supervisor callbacks
-export([init/1]).

-define(SERVER, ?MODULE).

%%%===================================================================
%%% API functions
%%%===================================================================

%%--------------------------------------------------------------------
%% @doc
%% Starts the supervisor
%%
%% @spec start_link() -> {ok, Pid} | ignore | {error, Error}
%% @end
%%--------------------------------------------------------------------
start_link() ->
    supervisor:start_link({local, ?SERVER}, ?MODULE, []).

%%%===================================================================
%%% Supervisor callbacks
%%%===================================================================

%%--------------------------------------------------------------------
%% @private
%% @doc
%% Whenever a supervisor is started using supervisor:start_link/[2,3],
%% this function is called by the new process to find out about
%% restart strategy, maximum restart frequency and child
%% specifications.
%%
%% @spec init(Args) -> {ok, {SupFlags, [ChildSpec]}} |
%%                     ignore |
%%                     {error, Reason}
%% @end
%%--------------------------------------------------------------------
init([]) ->
    RestartStrategy = one_for_one,
    MaxRestarts = 1000,
    MaxSecondsBetweenRestarts = 3600,

    SupFlags = {RestartStrategy, MaxRestarts, MaxSecondsBetweenRestarts},

    Restart = permanent,
    Shutdown = 2000,
    Type = worker,

    Master = {master_tag, {edk_master, start_link, []},
              Restart, Shutdown, Type, [edk_master]},
    Store = {store_tag, {edk_dict_store, start_link, []},
              Restart, Shutdown, Type, [edk_dict_store]},

    {ok, {SupFlags, [Master, Store]}}.

%%%===================================================================
%%% Internal functions
%%%===================================================================
