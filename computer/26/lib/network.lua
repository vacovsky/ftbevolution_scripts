
local network = { _version = '1.1.0' }

function network.ListMatchingDevices(devStr)
    local peripherals = peripheral.getNames()
    local devices = {}
    for _, attached_peripheral in pairs(peripherals) do
        if string.find(attached_peripheral, devStr) then
            devices[#devices + 1] = attached_peripheral
        end
    end
    return devices
end

function network.ListMultipleMatchingDevices(devTable)
    local peripherals = peripheral.getNames()
    local devices = {}

    for _, devStr in pairs(devTable) do
        for _, attached_peripheral in pairs(peripherals) do
            if string.find(attached_peripheral, devStr) then
                devices[#devices + 1] = attached_peripheral
            end
        end
    end

    return devices
end


return network