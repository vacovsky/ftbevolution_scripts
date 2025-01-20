while true do
    local success, data = turtle.inspect()
    if data.state.age == 7 then
        turtle.dig()
    end
    sleep(1)
end
