--- @class Hero10004_Skill4_Data Frosthardy
Hero10004_Skill4_Data = Class(Hero10004_Skill4_Data, BaseSkillData)

--- @return void
function Hero10004_Skill4_Data:Ctor()
    BaseSkillData.Ctor(self)

    --- @type StatChangerDataHelper
    self.statChangerDataHelper = StatChangerDataHelper(self)
end

---------------------------------------- Initialization ----------------------------------------
--- @return BaseSkillData
function Hero10004_Skill4_Data:CreateInstance()
    return Hero10004_Skill4_Data()
end

--- @return void
--- @param parsedData table
function Hero10004_Skill4_Data:ValidateBeforeParseCsv(parsedData)
    self.statChangerDataHelper:ValidateBeforeParseCsv(parsedData)

    assert(parsedData.immune_effect_type ~= nil, "immune_effect_type = nil")
end

--- @return void
--- @param parsedData table
function Hero10004_Skill4_Data:ParseCsv(parsedData)
    self.statChangerDataHelper:ParseCsv(parsedData)

    self.immuneEffectType = tonumber(parsedData.immune_effect_type)
end

return Hero10004_Skill4_Data