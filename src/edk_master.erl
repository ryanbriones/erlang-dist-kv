-module(edk_master).

-behaviour(gen_server).

-export([start_link/0, register/1, servers/0, put/2, get/1]).

%% gen_server callbacks
-export([init/1, handle_call/3, handle_cast/2, handle_info/2, terminate/2, code_change/3]).

start_link() ->
  gen_server:start_link({local, edk_master}, ?MODULE, [], []).

register(Pid) ->
  gen_server:call(edk_master, {register, Pid}).

servers() ->
  {ok, Servers} = gen_server:call(edk_master, servers),
  Servers.
  
put(Key, Value) ->
  ok = gen_server:call(edk_master, {put, Key, Value}).
  
get(Key) ->
  {ok, Value} = gen_server:call(edk_master, {get, Key}),
  Value.

init(State) ->
  erlang:put(servers, sets:new()),
  {ok, State}.
  
handle_call({register, Pid}, _From, State) ->
  erlang:put(servers, sets:add_element(Pid, erlang:get(servers))),
  {reply, ok, State};
handle_call(servers, _From, State) ->
  {reply, {ok, sets:to_list(erlang:get(servers))}, State};
handle_call({put, Key, Value}, _From, State) ->
  [Server|_T] = sets:to_list(erlang:get(servers)),
  gen_server:call(Server, {put, Key, Value}),
  {reply, ok, State};
handle_call({get, Key}, _From, State) ->
  [Server|_T] = sets:to_list(erlang:get(servers)),
  {reply, gen_server:call(Server, {get, Key}), State}.
  
handle_cast(stop, State) ->
    {stop, normal, State}.
    
handle_info(_Msg, State) ->
  {noreply, State}.

terminate(_Reason, _State) ->
    ok.

code_change(_OldVsn, State, _Extra) ->
    {ok, State}.