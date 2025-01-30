-- lib/constants.lua
-- storage_controller
local constants = { _version = '0.0.1' }
constants.return_storages = {
    "minecraft:chest_109",
    "minecraft:chest_110",
    "minecraft:chest_111"
}
constants.storage_buffers = {
    ["minecraft:chest_118"]="minecraft:chest_119",
    ["minecraft:chest_117"]="minecraft:chest_120",
    ["minecraft:chest_116"]="minecraft:chest_121",
    ["minecraft:chest_115"]="minecraft:chest_122"
}
constants.inbound_storages = {
    "minecraft:chest_112",
    "minecraft:chest_113",
    "minecraft:chest_114"
}
constants.p1_storage_strings = {
    "functionalstorage:storage_controller_",
}
constants.p2_storage_strings = {
    "minecraft:chest_"
}

return constants
