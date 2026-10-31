require "lua.libs.Class"
require "lua.libs.collection.CollectionItem"

--- @class Dictionary
Dictionary = Class(Dictionary)

--- @return Dictionary
function Dictionary:Ctor()
    --- @type table<object, CollectionItem>
    self._items = {}

    --- @type number
    self._currentSize = 0
end

---------------------------------------- Getters ----------------------------------------
--- @return number
function Dictionary:Count()
    return self._currentSize
end

--- @return object
--- @param key object
function Dictionary:Get(key)
    if key == nil then
        return nil
    end

    local item = self._items[key]
    if item ~= nil then
        return item.data
    else
        return nil
    end
end

--- @return object
--- @param key object
--- @param default object
function Dictionary:GetOrDefault(key, default)
    if key == nil then
        return default
    end

    local item = self._items[key]
    if item ~= nil then
        return item.data
    else
        return default
    end
end

--- @return boolean
--- @param key object
function Dictionary:IsContainKey(key)
    if key == nil then
        return false
    end

    local item = self._items[key]
    if item ~= nil then
        return true
    else
        return false
    end
end

--- @return boolean
--- @param value object
function Dictionary:IsContainValue(value)
    if value == nil then
        return false
    end

    for _, v in pairs(self._items) do
        if v.data == value then
            return true
        end
    end
    return false
end

--- @return table
function Dictionary:GetItems()
    local result = {}
    for k, v in pairs(self._items) do
        result[k] = v.data
    end

    return result
end

function Dictionary:GetData()
    local result = {}
    for k, v in pairs(self._items) do
        result[k] = v.data:GetData()
    end

    return result
end

--- @return string
function Dictionary:ToString()
    local result = string.format("Dictionary = %s, count = %s\n", tostring(self), self:Count())
    for k, v in pairs(self._items) do
        result = result .. string.format("\t[%s] = %s\n", LogUtils.ToDetail(k), LogUtils.ToDetail(v.data))
    end

    return result
end

---------------------------------------- Setters ----------------------------------------
--- @return void
--- @param key object
--- @param value object
function Dictionary:Add(key, value)
    if self._items[key] == nil then
        self._currentSize = self._currentSize + 1
    end

--[[   local result, message = pcall(function()
        self._items[key] = CollectionItem(value)
    end)
    if result == false then
        print(debug.traceback())
    end]]

    self._items[key] = CollectionItem(value)
end


--- @param dict Dictionary
function Dictionary:AddRange(dict)
    for key,value in pairs(dict:GetItems()) do
        self:Add(key,value)
    end
end

--- @return void
--- @param key object
function Dictionary:RemoveByKey(key)
    if self._items[key] ~= nil then
        self._currentSize = self._currentSize - 1
        self._items[key] = nil
    end
end

--- @return void
function Dictionary:Clear()
    self._items = {}
    self._currentSize = 0
end

--- @return void
function Dictionary:Reverse()
    local temp
    local count = #self._items
    for i = 1, count/2 do
        temp = self._items[i]
        self._items[i] = self._items[count - i + 1]
        self._items[count - i + 1] = temp
    end
end