{application, edk,
 [{description, "Distributed Key Value Store"},
  {vsn, "0.1"},
  {modules, [edk_app, edk_supervisor, edk_master, edk_dict_store]},
  {registered, [edk_supervisor]},
  {applications, [kernel, stdlib]},
  {mod, {edk_app, []}}
]}.
