--- @class Hero60006_Skill1_Data Hehta
Hero60006_Skill1_Data = Class(Hero60006_Skill1_Data, BaseSkillData)

---------------------------------------- Initialization ----------------------------------------
--- @return BaseSkillData
function Hero60006_Skill1_Data:CreateInstance()
    return Hero60006_Skill1_Data()
end

--- @return void
function Hero60006_Skill1_Data:ValidateBeforeParseCsv(parsedData)
    assert(parsedData.damage ~= nil, "damage = nil")

    assert(parsedData.damage_target_position ~= nil, "target_position = nil")
    assert(parsedData.damage_target_number ~= nil, "target_number = nil")

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
end

--- @return void
function Hero60006_Skill1_Data:ParseCsv(parsedData)
    self.damage = tonumber(parsedData.damage)

    self.targetPosition = tonumber(parsedData.damage_target_position)
    self.targetNumber = tonumber(parsedData.damage_target_number)

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
end

return Hero60006_Skill1_Data