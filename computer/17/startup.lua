
print("Starting timer")

local counter = 0
while true do
    if redstone.getInput("back") then
        counter = counter + 1
        print(counter)
    end
    sleep(0.01)
end

