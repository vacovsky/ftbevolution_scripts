local firstTick = .3
local secondTick = .2
local pulseTimeTick = .1

local counter = 0

function flappy() 
    counter = counter + 1
    print(counter)
    redstone.setOutput("top", true)
    os.sleep(0)
    redstone.setOutput("top", false)
end

function pearlgen()
    os.sleep(firstTick)
    redstone.setOutput("front", true)
    os.sleep(pulseTimeTick)
    redstone.setOutput("front", false)

    os.sleep(secondTick)
    redstone.setOutput("front", true)
    os.sleep(pulseTimeTick)
    redstone.setOutput("front", false)
end

print("starting sequencer")
while true do
    if redstone.getInput("back") then
        pcall(pearlgen)
        pcall(flappy)
    end
    sleep(0)
end


