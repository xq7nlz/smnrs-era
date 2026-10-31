--- @class Hero40006_Skill3_Data Oropher
Hero40006_Skill3_Data = Class(Hero40006_Skill3_Data, BaseSkillData)

--- @return void
function Hero40006_Skill3_Data:Ctor()
    BaseSkillData.Ctor(self)

    --- @type StatChangerDataHelper
    self.statChangerDataHelper = StatChangerDataHelper(self)
end

---------------------------------------- Initialization ----------------------------------------
--- @return BaseSkillData
function Hero40006_Skill3_Data:CreateInstance()
    return Hero40006_Skill3_Data()
end

--- @return void
function Hero40006_Skill3_Data:ValidateBeforeParseCsv(parsedData)
    self.statChangerDataHelper:ValidateBeforeParseCsv(parsedData)

    assert(parsedData.stack_limit ~= nil, "stack_limit = nil")
end

--- @return void
function Hero40006_Skill3_Data:ParseCsv(parsedData)
    self.statChangerDataHelper:ParseCsv(parsedData)

    self.stackLimit = tonumber(parsedData.stack_limit)
end

return Hero40006_Skill3_Data