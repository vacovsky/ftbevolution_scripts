-- lib/kv.lua

local kv = { _version = '0.0.1' }

function kv.write(data, fileName)
    local file = io.open(fileName, "w")
    io.output(file)
    for k, v in pairs(data) do
        io.write(string.format("%s %s\n", k, v))
    end
    io.close(file)
end

function kv.read(fileName)
    local data = {}
    for line in io.lines(fileName) do
        parts = string.gmatch(line, "%S+")
        data[parts(1)] = parts(2)
    end
    return data
end

return kv