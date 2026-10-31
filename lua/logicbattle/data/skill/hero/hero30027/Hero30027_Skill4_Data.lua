--- @class Hero30027_Skill4_Data : BaseSkillData Kazetsu
Hero30027_Skill4_Data = Class(Hero30027_Skill4_Data, BaseSkillData)

---------------------------------------- Initialization ----------------------------------------
--- @return BaseSkillData
function Hero30027_Skill4_Data:CreateInstance()
    return Hero30027_Skill4_Data()
end

--- @return void
function Hero30027_Skill4_Data:ValidateBeforeParseCsv(parsedData)
    assert(parsedData.trigger_hp ~= nil, "trigger_hp = nil")
    assert(parsedData.trigger_round ~= nil, "trigger_round = nil")
    assert(parsedData.new_attack_percent ~= nil, "last_hp_percent = nil")
    assert(parsedData.new_defense_percent ~= nil, "last_hp_percent = nil")
    assert(parsedData.new_hp_percent ~= nil, "last_hp_percent = nil")
end

--- @return void
function Hero30027_Skill4_Data:ParseCsv(parsedData)
    self.triggerHp = tonumber(parsedData.trigger_hp)
    self.triggerRound = tonumber(parsedData.trigger_round)
    self.newAttackPercent = tonumber(parsedData.new_attack_percent)
    self.newDefensePercent = tonumber(parsedData.new_defense_percent)
    self.newHpPercent = tonumber(parsedData.new_hp_percent)
end

return Hero30027_Skill4_Data