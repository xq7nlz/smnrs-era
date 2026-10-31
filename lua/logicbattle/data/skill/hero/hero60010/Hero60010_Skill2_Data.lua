--- @class Hero60010_Skill2_Data Hehta
Hero60010_Skill2_Data = Class(Hero60010_Skill2_Data, BaseSkillData)

--- @return void
--- @param id number id of skill (1: activeSkill, 2-4: passiveSkills)
--- @param hero BaseHero
function Hero60010_Skill2_Data:Ctor(id, hero)
    BaseSkill.Ctor(self, id, hero)

    --- @param List<number>
    self.effectCanRebuff = List()
end

---------------------------------------- Initialization ----------------------------------------
--- @return BaseSkillData
function Hero60010_Skill2_Data:CreateInstance()
    return Hero60010_Skill2_Data()
end

--- @return void
function Hero60010_Skill2_Data:ValidateBeforeParseCsv(parsedData)
    assert(parsedData.target_position ~= nil, "target_position = nil")
    assert(parsedData.target_number ~= nil, "target_number = nil")

    assert(parsedData.effect_chance ~= nil, "effect_chance = nil")
    assert(parsedData.effect_type ~= nil, "effect_type = nil")
    assert(parsedData.debuff_duration ~= nil, "debuff_duration = nil")
end

--- @return void
function Hero60010_Skill2_Data:ParseCsv(parsedData)
    --local content = StringUtils.Trim(parsedData.effect_can_rebuff)
    --content = content:Split(';')
    --
    --for _, value in pairs(content) do
    --    self.effectCanRebuff:Add(tonumber(value))
    --end
    self.targetPosition = tonumber(parsedData.target_position)
    self.targetNumber = tonumber(parsedData.target_number)

    self.effectChance = tonumber(parsedData.effect_chance)

    self.effectType = tonumber(parsedData.effect_type)
    self.effectDuration = tonumber(parsedData.debuff_duration)

end

return Hero60010_Skill2_Data