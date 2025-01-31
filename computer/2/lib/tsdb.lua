
local json = require "lib/json"

local tsdb = { _version = '0.1.0' }

function tsdb.WriteOutput(pathPrefix, keyPrefix, data, fileName)
    local processed = {
        timeStamp = os.epoch("utc"),
        [pathPrefix..':'..keyPrefix] = {
            name = pathPrefix..':'..keyPrefix,
        },
    }
    for k, v in pairs(data) do
        processed[pathPrefix..':'..keyPrefix][k] = v
    end
    WriteToFile(json.encode(processed), fileName, "w")
end

function WriteToFile(input, fileName, mode)
    local file = io.open(fileName, mode)
    io.output(file)
    io.write(input)
    io.close(file)
end

return tsdb