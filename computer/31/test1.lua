local sc = require "lib/sc"
local local_storage_name = "minecraft:chest_91"

sc.pull("rand_item", 69, false, local_storage_name, nil)

print("debug sleep")
sleep(20)
