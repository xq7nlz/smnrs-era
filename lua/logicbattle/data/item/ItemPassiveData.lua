--- @class ItemPassiveData
ItemPassiveData = Class(ItemPassiveData, BaseSkillData)

--- @return void
function ItemPassiveData:Ctor()
    --- @type table
    self.fields = nil
end

---------------------------------------- Initialization ----------------------------------------
--- @return BaseSkillData
function ItemPassiveData:CreateInstance()
    return ItemPassiveData()
end

--- @return void
--- @param parsedData table
function ItemPassiveData:ParseCsv(parsedData)
    self.skillName = parsedData.name
    self.fields = parsedData
end

return ItemPassiveData
