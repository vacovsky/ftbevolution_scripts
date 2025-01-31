-- ender_empty.lua
local sc = require "lib/sc"
local ender_chest_name = "enderstorage:ender_chest_9"

print("starting to empty ender chest")
while true do
    local moved_count = 0
    moved_count = moved_count + sc.push_all(ender_chest_name)
    print(string.format("items moved: %s", moved_count))
    sleep(1)
end

