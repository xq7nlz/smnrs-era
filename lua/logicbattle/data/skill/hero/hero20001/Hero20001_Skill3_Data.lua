--- @class Hero20001_Skill3_Data Icarus
Hero20001_Skill3_Data = Class(Hero20001_Skill3_Data, BaseSkillData)

--- @return void
function Hero20001_Skill3_Data:Ctor()
    BaseSkillData.Ctor(self)

    --- @type StatChangerDataHelper
    self.statChangerDataHelper = StatChangerDataHelper(self)
end

---------------------------------------- Initialization ----------------------------------------
--- @return BaseSkillData
function Hero20001_Skill3_Data:CreateInstance()
    return Hero20001_Skill3_Data()
end

--- @return void
--- @param parsedData table
function Hero20001_Skill3_Data:ValidateBeforeParseCsv(parsedData)
    self.statChangerDataHelper:ValidateBeforeParseCsv(parsedData)

    assert(parsedData.effect_type ~= nil, "effect_type = nil")
    assert(parsedData.effect_percent ~= nil, "effect_percent = nil")
end

--- @return void
--- @param parsedData table
function Hero20001_Skill3_Data:ParseCsv(parsedData)
    self.statChangerDataHelper:ParseCsv(parsedData)

    self.effectType = tonumber(parsedData.effect_type)
    self.effectPercent = tonumber(parsedData.effect_percent)
end

return Hero20001_Skill3_Data