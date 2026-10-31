--- @class HeroCompanionBuffCondition
HeroCompanionBuffCondition = Class(HeroCompanionBuffCondition)

--- @return void
function HeroCompanionBuffCondition:Ctor()
    --- @type HeroCompanionBuffConditionType
    self.conditionType = nil

    --- @type number
    self.conditionNumber = nil
end

--- @return void
--- @param data table
function HeroCompanionBuffCondition:ParseCsv(data)
    self.conditionType = tonumber(data.condition_type)
    self.conditionNumber = tonumber(data.condition_number)
end

--- @return HeroCompanionBuffCondition
function HeroCompanionBuffCondition:GetData()
    local data = {}
    data.conditionType = self.conditionType
    data.conditionNumber = self.conditionNumber

    return data
end