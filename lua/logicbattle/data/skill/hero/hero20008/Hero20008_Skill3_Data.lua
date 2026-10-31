--- @class Hero20008_Skill3_Data Moblin
Hero20008_Skill3_Data = Class(Hero20008_Skill3_Data, BaseSkillData)

--- @return void
function Hero20008_Skill3_Data:Ctor()
    BaseSkillData.Ctor(self)

    --- @type StatChangerDataHelper
    self.statChangerDataHelper = StatChangerDataHelper(self)
end

--- @return BaseSkillData
function Hero20008_Skill3_Data:CreateInstance()
    return Hero20008_Skill3_Data()
end

--- @return void
function Hero20008_Skill3_Data:ValidateBeforeParseCsv(parsedData)
    self.statChangerDataHelper:ValidateBeforeParseCsv(parsedData)

    assert(parsedData.damage_attack ~= nil, "damage_attack = nil")
    assert(parsedData.damage_target_position ~= nil, "damage_target_position = nil")
    assert(parsedData.damage_target_number ~= nil, "damage_target_number = nil")
end

--- @return void
function Hero20008_Skill3_Data:ParseCsv(parsedData)
    self.statChangerDataHelper:ParseCsv(parsedData)

    self.damageAttack = tonumber(parsedData.damage_attack)
    self.targetPosition = tonumber(parsedData.damage_target_position)
    self.targetNumber = tonumber(parsedData.damage_target_number)
end

return Hero20008_Skill3_Data