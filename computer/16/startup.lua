
while true do
    local source = peripheral.wrap('left')
    if source.tanks()[1] ~= nil then
        if source.tanks()[1].amount > 100 then
            print("moved", source.pushFluid('right', source.tanks()[1].amount - 100), "/", source.tanks()[1].amount)
        end
    end
    sleep(3)
end
