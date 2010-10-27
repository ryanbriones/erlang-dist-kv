## Make it work

    erlc -o ebin src/*.erl
    erl -pa ebin
    > edk_master:start_link().
    > edk_dict_store:start_link().
    > edk_master:put(foo, "bar").
    > edk_master:get(foo).
    
## Todo

* OTP Application/Supervisor setup. Automatically restarts downed node
* Distribute keys over multiple nodes via consistent hashing
* Handle downed store; consistent hashing algorithm redistributes key range to new node
* Replication
* Rebalance on downed node