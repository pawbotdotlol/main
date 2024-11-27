getgenv().base64encode = function(data)
    local b = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/'
    local result = {}
    local padding = ({ '', '==', '=' })[#data % 3 + 1]

    local function to_binary(num, bits)
        local bin = {}
        for i = bits, 1, -1 do
            table.insert(bin, math.floor(num / 2^(i - 1)) % 2)
        end
        return table.concat(bin)
    end

    local binary = data:gsub('.', function(char)
        local byte = string.byte(char)
        return to_binary(byte, 8)
    end)

    binary = binary .. '0000'
    binary:gsub('%d%d%d%d%d%d', function(chunk)
        local index = tonumber(chunk, 2) + 1
        table.insert(result, b:sub(index, index))
    end)

    return table.concat(result) .. padding
end

getgenv().base64decode = function(data)
    local b = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/'
    local result = {}

    data = data:gsub('[^' .. b .. '=]', '')

    local function to_binary(num, bits)
        local bin = {}
        for i = bits, 1, -1 do
            table.insert(bin, math.floor(num / 2^(i - 1)) % 2)
        end
        return table.concat(bin)
    end

    local binary = data:gsub('.', function(char)
        if char == '=' then return '' end
        local index = b:find(char) - 1
        return to_binary(index, 6)
    end)

    binary:gsub('%d%d%d%d%d%d%d%d', function(chunk)
        local byte = tonumber(chunk, 2)
        table.insert(result, string.char(byte))
    end)

    return table.concat(result)
end
