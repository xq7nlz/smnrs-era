--- @class Hero50002_Skill1_Data HolyKnight
Hero50002_Skill1_Data = Class(Hero50002_Skill1_Data, BaseSkillData)

---------------------------------------- Initialization ----------------------------------------
--- @return BaseSkillData
function Hero50002_Skill1_Data:CreateInstance()
    return Hero50002_Skill1_Data()
end

--- @return void
function Hero50002_Skill1_Data:ValidateBeforeParseCsv(parsedData)
    assert(parsedData.damage ~= nil, "damage = nil")

    assert(parsedData.target_position ~= nil, "target_position = nil")
    assert(parsedData.target_number ~= nil, "target_number = nil")

    assert(parsedData.stat_debuff_chance ~= nil, "stat_debuff_chance = nil")
    assert(parsedData.stat_debuff_duration ~= nil, "stat_debuff_duration = nil")

    local i = 1
    while true do
        if TableUtils.IsContainKey(parsedData, EffectConstants.STAT_DEBUFF_TYPE_TAG .. i) then
            assert(parsedData[EffectConstants.STAT_DEBUFF_TYPE_TAG .. i] ~= nil)
            assert(parsedData[EffectConstants.STAT_DEBUFF_AMOUNT_TAG .. i] ~= nil)

            i = i + 1
        else
            assert(i >= 1)
            break
        end
    end

    assert(parsedData.effect_type ~= nil, "effect_type = nil")
    assert(parsedData.effect_chance ~= nil, "effect_chance = nil")
    assert(parsedData.effect_duration ~= nil, "effect_duration = nil")
end

--- @return void
function Hero50002_Skill1_Data:ParseCsv(parsedData)
    self.damage = tonumber(parsedData.damage)

    self.targetPosition = tonumber(parsedData.target_position)
    self.targetNumber = tonumber(parsedData.target_number)

    self.statDebuffChance = tonumber(parsedData.stat_debuff_chance)
    self.statDebuffDuration = tonumber(parsedData.stat_debuff_duration)

    self.debuffs = List()

    local i = 1
    while true do
        local keyStat = EffectConstants.STAT_DEBUFF_TYPE_TAG .. i
        if TableUtils.IsContainKey(parsedData, keyStat) then
            local statBonus = StatDebuff(StatChangerCalculationType.PERCENT_ADD)
            statBonus:ParseCsv(parsedData, i)

            self.debuffs:Add(statBonus)
        else
            break
        end
        i = i + 1
    end

    self.effect_type = tonumber(parsedData.effect_type)
    self.effect_chance = tonumber(parsedData.effect_chance)
    self.effect_duration = tonumber(parsedData.effect_duration)
end

return Hero50002_Skill1_Data