-- startup.lua
-- storage_controller
-- shell.openTab("lua")
local constants = require "lib/constants"
local kv = require "lib/kv"

local local_modem = "left"
local storage_modem = "right"
local buffer_state_fn = "buffer_state"

-- initialize buffer states
local storage_buffers_states = {}
for _, storage_buffer in pairs(constants.storage_buffers) do
    storage_buffers_states[storage_buffer] = "unlocked"
end

kv.write(storage_buffers_states, buffer_state_fn)

-- start rednet
rednet.host("storage_controller", ("%s"):format(os.getComputerID()))
rednet.open(local_modem)

-- listen
while true do
    print("listening on protocol: storage_controller")
    local id, message = rednet.receive("storage_controller")
    id = tonumber(id)
    print(id, message)
    parts = string.gmatch(message, "%S+")
    local api = parts(1)
    local api_arg_1 = parts(2)
    local api_arg_2 = parts(3)
    local api_arg_3 = parts(4)
    if api == "get" then
        print(id, "get")
        shell.openTab("get_api", id, api_arg_1, api_arg_2, api_arg_3)
    end
    -- reset variables
    id = nil
    message = nil
    api = nil
    api_arg_1 = nil
    api_arg_2 = nil
    api_arg_3 = nil
end
            
