local function reverse(t, n)
    local nt = {} -- new table
    local size = n + 1
    for k = 1, n do
        if k <= #t then
            nt[size - k] = t[k]
        else
            nt[size - k] = 0
        end
    end
    return nt
end

--- @class BitUtils
BitUtils = {}

--- @return number
--- @param data number
--- @param bit number
function BitUtils.TurnOn(data, bit)
    return data | (1 << bit)
end

--- @return number
--- @param data number
--- @param bit number
function BitUtils.TurnOff(data, bit)
    return data & (1 << bit)
end

--- @return number
--- @param data number
--- @param bit number
function BitUtils.IsOn(data, bit)
    return (data & (1 << bit)) ~= 0
end

--- @return number
--- @param num number
--- @param n number -- number bit
function BitUtils.GetBitTableByNumber(num, n)
    local t={}
    local rest
    while num > 0 do
        rest=num%2
        t[#t+1]=rest
        num=(num-rest)/2
    end
    return reverse(t, n)
end

--- @return number
--- @param data table
function BitUtils.GetNumberByBitIndexTable(data)
    local bitmask1 = 0
    local bitmask2 = 0
    for _, v in pairs(data) do
        if v < 64 then
            bitmask1 = BitUtils.TurnOn(bitmask1, v)
        else
            bitmask2 = BitUtils.TurnOn(bitmask2, v - 64)
        end
    end
    return bitmask1, bitmask2
end

--- @return number
--- @param data table
function BitUtils.GetNumberByBitTable(data)
    local bitmask = 0
    for i, v in ipairs(data) do
        if v ~= 0 then
            bitmask = bitmask + 2^(#data - i)
        end
    end
    return bitmask
end

--- @return table
--- @param a table
--- @param b table
function BitUtils.MergerBit(a, b)
    local aSize = #a
    local bSize = #b
    local newTable = {}
    for i = 1, aSize do
        newTable[i] = a[i]
    end
    for i = 1, bSize do
        newTable[aSize + i] = b[i]
    end
    return newTable
end


