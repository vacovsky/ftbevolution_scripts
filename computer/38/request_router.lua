-- request_router.lua
-- storage_controller
local args = {...}
local internal_modem_name = args[1]
-- listen
while true do
    print("listening on protocol: storage_controller")
    local id, message = rednet.receive("storage_controller")
    print(id, message)
    parts = string.gmatch(message, "%S+")
    local api = parts(1)
    local api_arg_1 = parts(2)
    local api_arg_2 = parts(3)
    local api_arg_3 = parts(4)
    if api == "get" then
        print("client", id, "api", "get")
        shell.openTab("get_api", id, api_arg_1, api_arg_2, api_arg_3, internal_modem_name)
    end
    if api == "return" then
        print("client", id, "api", "return")
        shell.openTab("return_api", id)
    end
    
    -- reset variables
    id = nil
    message = nil
    api = nil
    api_arg_1 = nil
    api_arg_2 = nil
    api_arg_3 = nil
end
