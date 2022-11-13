"use strict";(self.webpackChunkdocs=self.webpackChunkdocs||[]).push([[862],{33011:e=>{e.exports=JSON.parse('{"functions":[{"name":"Is","desc":"Return whether or not the specified object is a SignalMethods.","params":[{"name":"Object","desc":"The specified object.","lua_type":"table"}],"returns":[{"desc":"Return whether or not the specified object is a SignalMethods.","lua_type":"boolean"}],"function_type":"static","source":{"line":98,"path":"src/Signal/init.lua"}},{"name":"Connect","desc":"Connect to the signal while waiting for a fire to load the specified callback function.","params":[{"name":"Callback","desc":"The specified callback function.","lua_type":"Function"}],"returns":[{"desc":"Return a table consisting of disconnect-related functions.","lua_type":"Connection"}],"function_type":"static","source":{"line":113,"path":"src/Signal/init.lua"}},{"name":"ConnectOnce","desc":"Unlike the normal connect method, this will run once.","params":[{"name":"Callback","desc":"The specified callback function.","lua_type":"Function"}],"returns":[{"desc":"Return a table consisting of disconnect-related functions.","lua_type":"Connection"}],"function_type":"static","source":{"line":146,"path":"src/Signal/init.lua"}},{"name":"ConnectToOnClose","desc":"Unlike the normal connect method, this will run when specified callback when the server\'s closing.","params":[{"name":"Callback","desc":"The specified callback function.","lua_type":"Function"}],"returns":[{"desc":"Return a table consisting of disconnect-related functions.","lua_type":"Connection"}],"function_type":"static","source":{"line":172,"path":"src/Signal/init.lua"}},{"name":"ConnectParallel","desc":"Unlike the normal connect method, this will run in parallel, resulting in zero code interference.","params":[{"name":"Callback","desc":"The specified callback function.","lua_type":"Function"}],"returns":[{"desc":"Return a table consisting of disconnect-related functions.","lua_type":"Connection"}],"function_type":"static","source":{"line":198,"path":"src/Signal/init.lua"}},{"name":"Wait","desc":"Wait for the connection to be fired and then return any retrieved values.","params":[],"returns":[{"desc":"Return a table consisting of any retrieved values.","lua_type":"Wait"}],"function_type":"static","source":{"line":215,"path":"src/Signal/init.lua"}},{"name":"Fire","desc":"Fire the current signal\'s connections.","params":[{"name":"...","desc":"The specified arguments to fire with.","lua_type":"any?"}],"returns":[],"function_type":"static","source":{"line":240,"path":"src/Signal/init.lua"}},{"name":"FireUntil","desc":"Fire the current signal\'s connections until the specified callback is reached.","params":[{"name":"Callback","desc":"The specified callback.","lua_type":"Function"},{"name":"...","desc":"The specified arguments to fire with.","lua_type":"any?"}],"returns":[],"function_type":"static","source":{"line":263,"path":"src/Signal/init.lua"}},{"name":"OnInvoke","desc":"Create a callback function that\'d be activated on invoke, retrieving the function\'s callback.","params":[{"name":"Callback","desc":"The specified callback function.","lua_type":"Function"}],"returns":[],"function_type":"static","source":{"line":288,"path":"src/Signal/init.lua"}},{"name":"Invoke","desc":"Wait until the \\\\\\"OnInvoke\\\\\\" method exists and then invoke with the necessary arguments.","params":[{"name":"...","desc":"The specified arguments to invoke with.","lua_type":"any?"}],"returns":[{"desc":"Return the function associated with \\\\\\"OnInvoke\\\\\\".","lua_type":"Function"}],"function_type":"static","source":{"line":303,"path":"src/Signal/init.lua"}},{"name":"Destroy","desc":"Destroy and cleanup a SignalMethods.","params":[],"returns":[],"function_type":"static","source":{"line":320,"path":"src/Signal/init.lua"}}],"properties":[],"types":[],"name":"SignalMethods","desc":"All of the subsidiary code within Signal.","source":{"line":38,"path":"src/Signal/init.lua"}}')}}]);