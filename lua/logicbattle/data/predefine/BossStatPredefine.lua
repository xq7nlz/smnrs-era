--- @class BossStatPredefine
BossStatPredefine = Class(BossStatPredefine)

--- @return void
function BossStatPredefine:Ctor()
    --- @type Dictionary<StatType, number>
    self.statBaseMultiplier = Dictionary()

    --- @type Dictionary<StatType, number>
    self.statGrowMultiplier = Dictionary()

    --- @type Dictionary<StatType, number>
    self.statBaseAdder = Dictionary()
end

--- @return void
--- @param data string
function BossStatPredefine:ParseBaseStatMultiplier(data)
    self:ValidateBeforeParseCsv(data)

    self.statBaseMultiplier:Add(StatType.ATTACK, tonumber(data.attack))
    self.statBaseMultiplier:Add(StatType.DEFENSE, tonumber(data.defense))
    self.statBaseMultiplier:Add(StatType.HP, tonumber(data.hp))
    self.statBaseMultiplier:Add(StatType.SPEED, tonumber(data.speed))

    self.statBaseMultiplier:Add(StatType.CRIT_RATE, tonumber(data.crit_rate))
    self.statBaseMultiplier:Add(StatType.CRIT_DAMAGE, tonumber(data.crit_damage))

    self.statBaseMultiplier:Add(StatType.ACCURACY, tonumber(data.accuracy))
    self.statBaseMultiplier:Add(StatType.DODGE, tonumber(data.dodge))

    self.statBaseMultiplier:Add(StatType.PURE_DAMAGE, tonumber(data.pure_damage))
    self.statBaseMultiplier:Add(StatType.SKILL_DAMAGE, tonumber(data.skill_damage))
    self.statBaseMultiplier:Add(StatType.ARMOR_BREAK, tonumber(data.armor_break))
    self.statBaseMultiplier:Add(StatType.REDUCE_DAMAGE_REDUCTION, tonumber(data.reduce_damage_reduction))

    self.statBaseMultiplier:Add(StatType.CC_RESISTANCE, tonumber(data.cc_resistance))
    self.statBaseMultiplier:Add(StatType.DAMAGE_REDUCTION, tonumber(data.damage_reduction))
end

--- @return void
--- @param data string
function BossStatPredefine:ParseGrowStatMultiplier(data)
    self:ValidateBeforeParseCsv(data)

    self.statGrowMultiplier:Add(StatType.ATTACK, tonumber(data.attack))
    self.statGrowMultiplier:Add(StatType.DEFENSE, tonumber(data.defense))
    self.statGrowMultiplier:Add(StatType.HP, tonumber(data.hp))
    self.statGrowMultiplier:Add(StatType.SPEED, tonumber(data.speed))

    self.statGrowMultiplier:Add(StatType.CRIT_RATE, tonumber(data.crit_rate))
    self.statGrowMultiplier:Add(StatType.CRIT_DAMAGE, tonumber(data.crit_damage))

    self.statGrowMultiplier:Add(StatType.ACCURACY, tonumber(data.accuracy))
    self.statGrowMultiplier:Add(StatType.DODGE, tonumber(data.dodge))

    self.statGrowMultiplier:Add(StatType.PURE_DAMAGE, tonumber(data.pure_damage))
    self.statGrowMultiplier:Add(StatType.SKILL_DAMAGE, tonumber(data.skill_damage))
    self.statGrowMultiplier:Add(StatType.ARMOR_BREAK, tonumber(data.armor_break))
    self.statGrowMultiplier:Add(StatType.REDUCE_DAMAGE_REDUCTION, tonumber(data.reduce_damage_reduction))

    self.statGrowMultiplier:Add(StatType.CC_RESISTANCE, tonumber(data.cc_resistance))
    self.statGrowMultiplier:Add(StatType.DAMAGE_REDUCTION, tonumber(data.damage_reduction))
end

--- @return void
--- @param data string
function BossStatPredefine:ParseBaseStatAdder(data)
    self:ValidateBeforeParseCsv(data)

    self.statBaseAdder:Add(StatType.ATTACK, tonumber(data.attack))
    self.statBaseAdder:Add(StatType.DEFENSE, tonumber(data.defense))
    self.statBaseAdder:Add(StatType.HP, tonumber(data.hp))
    self.statBaseAdder:Add(StatType.SPEED, tonumber(data.speed))

    self.statBaseAdder:Add(StatType.CRIT_RATE, tonumber(data.crit_rate))
    self.statBaseAdder:Add(StatType.CRIT_DAMAGE, tonumber(data.crit_damage))

    self.statBaseAdder:Add(StatType.ACCURACY, tonumber(data.accuracy))
    self.statBaseAdder:Add(StatType.DODGE, tonumber(data.dodge))

    self.statBaseAdder:Add(StatType.PURE_DAMAGE, tonumber(data.pure_damage))
    self.statBaseAdder:Add(StatType.SKILL_DAMAGE, tonumber(data.skill_damage))
    self.statBaseAdder:Add(StatType.ARMOR_BREAK, tonumber(data.armor_break))
    self.statBaseAdder:Add(StatType.REDUCE_DAMAGE_REDUCTION, tonumber(data.reduce_damage_reduction))

    self.statBaseAdder:Add(StatType.CC_RESISTANCE, tonumber(data.cc_resistance))
    self.statBaseAdder:Add(StatType.DAMAGE_REDUCTION, tonumber(data.damage_reduction))
end

--- @return void
--- @param data table
function BossStatPredefine:ValidateBeforeParseCsv(data)
    ---
    local attack = tonumber(data.attack)
    if MathUtils.IsInteger(attack) == false or attack < 0 then
        assert(false)
    end

    local defense = tonumber(data.defense)
    if MathUtils.IsInteger(defense) == false or defense < 0 then
        assert(false)
    end

    local hp = tonumber(data.hp)
    if MathUtils.IsInteger(hp) == false or hp < 0 then
        assert(false)
    end

    local speed = tonumber(data.speed)
    if MathUtils.IsInteger(speed) == false or speed < 0 then
        assert(false)
    end

    ---
    local crit_rate = tonumber(data.crit_rate)
    if MathUtils.IsInteger(crit_rate) == false or crit_rate < 0 then
        assert(false)
    end

    local crit_damage = tonumber(data.crit_damage)
    if MathUtils.IsInteger(crit_damage) == false or crit_damage < 0 then
        assert(false)
    end

    ---
    local accuracy = tonumber(data.accuracy)
    if MathUtils.IsInteger(accuracy) == false or accuracy < 0 then
        assert(false)
    end

    local dodge = tonumber(data.dodge)
    if MathUtils.IsInteger(dodge) == false or dodge < 0 then
        assert(false)
    end

    ---
    local pure_damage = tonumber(data.pure_damage)
    if MathUtils.IsInteger(pure_damage) == false or pure_damage < 0 then
        assert(false)
    end

    local skill_damage = tonumber(data.skill_damage)
    if MathUtils.IsInteger(skill_damage) == false or skill_damage < 0 then
        assert(false)
    end

    local armor_break = tonumber(data.armor_break)
    if MathUtils.IsInteger(armor_break) == false or armor_break < 0 then
        assert(false)
    end

    local reduce_damage_reduction = tonumber(data.reduce_damage_reduction)
    if MathUtils.IsInteger(reduce_damage_reduction) == false or reduce_damage_reduction < 0 then
        assert(false)
    end

    ---
    local cc_resistance = tonumber(data.cc_resistance)
    if MathUtils.IsInteger(cc_resistance) == false or cc_resistance < 0 then
        assert(false)
    end

    local damage_reduction = tonumber(data.damage_reduction)
    if MathUtils.IsInteger(damage_reduction) == false or damage_reduction < 0 then
        assert(false)
    end
end