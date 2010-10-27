-module(edk_dict_store).

-behaviour(gen_server).

-export([start_link/0]).

%% gen_server callbacks
-export([init/1, handle_call/3, handle_cast/2, handle_info/2, terminate/2, code_change/3]).

start_link() ->
  gen_server:start_link(?MODULE, [], []).

init(State) ->
  edk_master:register(self()),
  {ok, State}.
  
handle_call({put, Key, Value}, _From, State) ->
  erlang:put(Key, Value),
  {reply, {ok}, State};
handle_call({get, Key}, _From, State) ->
  {reply, {ok, erlang:get(Key)}, State}.
  
handle_cast(stop, State) ->
    {stop, normal, State}.
    
handle_info(_Msg, State) ->
  {noreply, State}.

terminate(_Reason, _State) ->
    ok.

code_change(_OldVsn, State, _Extra) ->
    {ok, State}.