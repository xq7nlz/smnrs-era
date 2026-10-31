require "lua.libs.Class"
require "lua.libs.collection.CollectionItem"
require "lua.libs.MathUtils"

--- @class List
List = Class(List)

--- @return void
function List:Ctor()
    --- @type table<number, CollectionItem>
    self._items = {}

    --- @type number
    self._currentIndex = 1
end

---------------------------------------- Getters ----------------------------------------
--- @return number
function List:GetCurrentIndex()
    return self._currentIndex
end

--- @return number
function List:Count()
    return self._currentIndex - 1
end

--- @return number
function List:GetLastItem()
    return self:Get(self:Count())
end

--- @return number
function List:_CalculateSize()
    local count = 0
    for _, _ in pairs(self._items) do
        count = count + 1
    end
    return count
end

--- @return object
--- @param index number
--- Get item at index, or do nothing if index out of bound
function List:Get(index)
    local item = self._items[index]
    if item ~= nil then
        return item.data
    else
        return nil
    end
end

--- @return boolean
--- @param value object
function List:IsContainValue(value)
    for _, v in pairs(self._items) do
        if v.data == value then
            return true
        end
    end
    return false
end

--- @return table
function List:GetItems()
    local result = {}
    for k, v in ipairs(self._items) do
        result[k] = v.data
    end

    return result
end

--- @return table
function List:GetData()
    if self:Count() == 0 then
        return nil
    end

    local result = {}
    for k, v in ipairs(self._items) do
        result[k] = v.data:GetData()
    end

    return result
end

--- @return string
function List:ToString()
    local result = string.format("List = %s, count = %s\n", tostring(self), self:Count())
    for k, v in pairs(self._items) do
        result = result .. string.format("\t[%s] = %s\n", tostring(k), LogUtils.ToDetail(v.data))
    end

    return result
end

---------------------------------------- Setters ----------------------------------------
--- @return void
--- @param item object
--- add an item to the end of list
function List:Add(item)
    self._items[self._currentIndex] = CollectionItem(item)
    self._currentIndex = self._currentIndex + 1
end

--- @return void
--- @param item object
--- @param index number which item is inserted
--- insert an item at the specified index, auto fallback to add action if index is invalid
function List:Insert(item, index)
    if self:Count() > 0 then
        if index >= 1 and index < self._currentIndex then
            for i = self._currentIndex, index + 1, -1 do
                self._items[i] = self._items[i - 1]
            end

            self._items[index] = CollectionItem(item)
            self._currentIndex = self._currentIndex + 1
        else
            self:Add(item)
        end
    else
        self:Add(item)
    end
end

--- @return void
--- @param item object
--- @param index number which item is updated
function List:SetItemAtIndex(item, index)
    if index >= 1 and index < self._currentIndex then
        self._items[index].data = item
    end
end

--- @return void
--- @param itemList List
function List:AddAll(itemList)
    for i = 1, itemList:Count() do
        self:Add(itemList:Get(i))
    end
end

--- @return void
--- @param index number
--- remove item at index, or do nothing if index out of bound
function List:RemoveByIndex(index)
    if index >= 1 and index < self._currentIndex then
        self._items[index] = nil
        self:_Collapse(index)
    end
end

--- @return void
--- @param itemToRemoved object
function List:RemoveByReference(itemToRemoved)
    if itemToRemoved ~= nil and self:Count() > 0 then
        while true do
            local keyToRemoved = -1
            for k, v in ipairs(self._items) do
                if v.data == itemToRemoved then
                    keyToRemoved = k
                    break
                end
            end

            if keyToRemoved == -1 then
                break
            else
                self:RemoveByIndex(keyToRemoved)
            end
        end
    end
end

--- @return void
--- @param itemToRemoved object
function List:RemoveOneByReference(itemToRemoved)
    if itemToRemoved ~= nil and self:Count() > 0 then
        local keyToRemoved = -1
        for k, v in ipairs(self._items) do
            if v.data == itemToRemoved then
                keyToRemoved = k
                break
            end
        end

        if keyToRemoved ~= -1 then
            self:RemoveByIndex(keyToRemoved)
        end
    end
end

--- @return void
--- @param numberToRemove number
--- @param randomHelper RandomHelper
function List:RemoveRandomItems(numberToRemove, randomHelper)
    for _ = 1, numberToRemove do
        local indexToRemove = randomHelper:RandomMax(self:Count() + 1)
        self:RemoveByIndex(indexToRemove)
    end
end

--- @return void
--- @param comparatorOwner table object
--- @param comparatorMethod function
--- Signature of function must have the following format
--- --- Positive: item1 > item2, 0: item1 == item2, Negative: item1 < item2
--- --- @param item1 object
--- --- @param item2 object
--- function DummyFunctionCallback(item1, item2)
--- This method use Insertion Sort algorithm, sort in ascending order
function List:Sort(comparatorOwner, comparatorMethod)
    local length = self:Count()
    if length > 1 then
        for i = 2, length do
            local item = self._items[i]
            local j = i - 1

            while j >= 1 and comparatorMethod(comparatorOwner, self._items[j].data, item.data) > 0 do
                self._items[j + 1] = self._items[j]
                j = j - 1
            end
            self._items[j + 1] = item
        end
    end
end

--- @return void
--- @param comparatorMethod function
--- Signature of function must have the following format
--- --- Positive: item1 > item2, 0: item1 == item2, Negative: item1 < item2
--- --- @param item1 object
--- --- @param item2 object
--- function DummyFunctionCallback(item1, item2)
--- This method use Insertion Sort algorithm, sort in ascending order
function List:SortWithMethod(comparatorMethod)
    local length = self:Count()
    if length > 1 then
        for i = 2, length do
            local item = self._items[i]
            local j = i - 1

            while j >= 1 and comparatorMethod(self._items[j].data, item.data) > 0 do
                self._items[j + 1] = self._items[j]
                j = j - 1
            end
            self._items[j + 1] = item
        end
    end
end

--- @return void
function List:Clear()
    self._items = {}
    self._currentIndex = 1
end

--- @return void
--- @param index number
function List:_Collapse(index)
    for i = index, self._currentIndex - 1 do
        self._items[i] = self._items[i + 1]
    end
    self._currentIndex = self:_CalculateSize() + 1
end

--- @return void
function List:Reverse()
    local temp
    local count = #self._items
    for i = 1, count / 2 do
        temp = self._items[i]
        self._items[i] = self._items[count - i + 1]
        self._items[count - i + 1] = temp
    end
end