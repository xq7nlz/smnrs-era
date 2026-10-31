require "lua.libs.Class"
require "lua.libs.collection.List"

--- @class DirtyList :List
DirtyList = Class(DirtyList, List)

--- @return void
function DirtyList:Ctor()
    List.Ctor(self)

    --- @type boolean
    self._isDirty = false
end

---------------------------------------- Getters ----------------------------------------
--- @return boolean
function DirtyList:IsDirty()
    return self._isDirty
end

---------------------------------------- Setters ----------------------------------------
--- @return void
--- @param value boolean
function DirtyList:SetDirty(value)
    self._isDirty = value
end

--- @return void
--- @param item object
function DirtyList:Add(item)
    List.Add(self, item)
    self._isDirty = true
end

--- @return void
--- @param item object
--- @param index number which item is updated
function DirtyList:SetItemAtIndex(item, index)
    List.SetItemAtIndex(self, item, index)
    self._isDirty = true
end

--- @return void
--- @param index number
--- remove item at index, or do nothing if index out of bound
function DirtyList:RemoveByIndex(index)
    List.RemoveByIndex(self, index)
    self._isDirty = true
end

--- @return void
--- @param comparatorOwner table object
--- @param comparatorMethod function
--- Signature of function must have the following format
--- --- Positive: item1 > item2, 0: item1 == item2, Negative: item1 < item2
--- --- @param item1 object
--- --- @param item2 object
--- function DummyFunctionCallback(target1, target2)
--- This method use Insertion Sort algorithm, sort in ascending order
function DirtyList:Sort(comparatorOwner, comparatorMethod)
    List.Sort(self, comparatorOwner, comparatorMethod)
    self._isDirty = true
end

--- @return void
function DirtyList:Clear()
    List.Clear(self)
    self._isDirty = true
end