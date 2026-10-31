--- @class FragmentIconData
FragmentIconData = Class(FragmentIconData)

--- @return void
function FragmentIconData:Ctor()
    self.id = nil
    self.type = nil
    self.itemId = nil
    self.quantity = nil
    self.countFull = nil
end

--- @return void
--- @param type ResourceType
--- @param itemId number
--- @param quantity number
function FragmentIconData:SetData(type, itemId, quantity, countFull)
    self.type = type
    self.itemId = itemId
    self.quantity = quantity
    self.countFull = countFull
end

--- @return ItemIconData
--- @param data ItemIconData
function FragmentIconData.Clone(data)
    return FragmentIconData.CreateInstance(data.type, data.itemId, data.quantity, data.countFull)
end

--- @return ItemIconData
--- @param type ResourceType
--- @param itemId number
--- @param quantity number
function FragmentIconData.CreateInstance(type, itemId, quantity, countFull)
    local inst = FragmentIconData()
    inst:SetData(type, itemId, quantity, countFull)
    return inst
end