function x(delay)
    print("start")
    print("delay", delay)
    redstone.setOutput("right", true)
    redstone.setOutput("left", true)
    sleep(0)
    redstone.setOutput("right", false)
    redstone.setOutput("left", false)
    print("end")
end

c = .05
x(c)
sleep(5)
c = c + .05
x(c)
sleep(5)
c = c + .05
x(c)
sleep(5)
c = c + .05
x(c)
sleep(5)
c = 5
x(c)
