--- @class HeroData
HeroData = Class(HeroData)

--- @return void
function HeroData:Ctor()
    --- @type number
    self.id = -1
    --- @type string
    self.name = nil

    --- @type number
    self.star = -1
    --- @type number
    self.class = -1
    --- @type number
    self.faction = -1

    --- @type number
    self.attack = -1
    --- @type number
    self.defense = -1
    --- @type number
    self.hp = -1
    --- @type number
    self.speed = -1

    --- @type number
    self.critRate = -1
    --- @type number
    self.critDamage = -1

    --- @type number
    self.accuracy = -1
    --- @type number
    self.dodge = -1

    --- @type number
    self.pureDamage = -1
    --- @type number
    self.skillDamage = -1
    --- @type number
    self.armorBreak = -1
    --- @type number
    self.reduceDamageReduction = -1

    --- @type number
    self.ccResistance = -1
    --- @type number
    self.damageReduction = -1

    --- @type Dictionary<StatType, number>
    self.heroStats = Dictionary()
end

--- @return void
--- @param id number
--- @param name string
function HeroData:SetId(id, name)
    self.id = id
    self.name = name
end

--- @return void
--- @param star number
--- @param class string
--- @param faction number
function HeroData:SetOriginInfo(star, class, faction)
    self.star = star
    self.class = class
    self.faction = faction
end

--- @return void
--- @param data string
function HeroData:ParseCsv(data)
    self.attack = tonumber(data.attack)
    self.defense = tonumber(data.defense)
    self.hp = tonumber(data.hp)
    self.speed = tonumber(data.speed)

    self.critRate = tonumber(data.crit_rate)
    self.critDamage = tonumber(data.crit_damage)

    self.accuracy = tonumber(data.accuracy)
    self.dodge = tonumber(data.dodge)

    self.pureDamage = tonumber(data.pure_damage)
    self.skillDamage = tonumber(data.skill_damage)
    self.armorBreak = tonumber(data.armor_break)

    if data.reduce_damage_reduction ~= nil then
        self.reduceDamageReduction = tonumber(data.reduce_damage_reduction)
    else
        self.reduceDamageReduction = 0
    end

    self.ccResistance = tonumber(data.cc_resistance)
    self.damageReduction = tonumber(data.damage_reduction)

    self:CreateStats()
end

--- @return void
function HeroData:CreateStats()
    self.heroStats:Add(StatType.ATTACK, self.attack)
    self.heroStats:Add(StatType.DEFENSE, self.defense)
    self.heroStats:Add(StatType.HP, self.hp)
    self.heroStats:Add(StatType.SPEED, self.speed)

    self.heroStats:Add(StatType.CRIT_RATE, self.critRate)
    self.heroStats:Add(StatType.CRIT_DAMAGE, self.critDamage)

    self.heroStats:Add(StatType.ACCURACY, self.accuracy)
    self.heroStats:Add(StatType.DODGE, self.dodge)

    self.heroStats:Add(StatType.PURE_DAMAGE, self.pureDamage)
    self.heroStats:Add(StatType.SKILL_DAMAGE, self.skillDamage)
    self.heroStats:Add(StatType.ARMOR_BREAK, self.armorBreak)
    self.heroStats:Add(StatType.REDUCE_DAMAGE_REDUCTION, self.reduceDamageReduction)

    self.heroStats:Add(StatType.CC_RESISTANCE, self.ccResistance)
    self.heroStats:Add(StatType.DAMAGE_REDUCTION, self.damageReduction)
end

--- @return void
function HeroData:Validate()
    if MathUtils.IsInteger(self.id) == false or self.id < 0 then
        assert(false)
    end

    if self.name == nil then
        assert(false)
    end

    ---
    if MathUtils.IsInteger(self.star) == false or self.star < 0 then
        assert(false)
    end

    if MathUtils.IsInteger(self.class) == false or self.class < 0 then
        assert(false)
    end

    if MathUtils.IsInteger(self.faction) == false or self.faction < 0 then
        assert(false)
    end

    ---
    if MathUtils.IsInteger(self.attack) == false or self.attack < 0 then
        assert(false)
    end

    if MathUtils.IsInteger(self.defense) == false or self.defense < 0 then
        assert(false)
    end

    if MathUtils.IsInteger(self.hp) == false or self.hp < 0 then
        assert(false)
    end

    if MathUtils.IsInteger(self.speed) == false or self.speed < 0 then
        assert(false)
    end

    ---
    if MathUtils.IsNumber(self.critRate) == false or self.critRate < 0 then
        assert(false)
    end

    if MathUtils.IsNumber(self.critDamage) == false or self.critDamage < 0 then
        assert(false)
    end

    if MathUtils.IsInteger(self.accuracy) == false or self.accuracy < 0 then
        assert(false)
    end

    if MathUtils.IsInteger(self.dodge) == false or self.dodge < 0 then
        assert(false)
    end

    ---
    if MathUtils.IsNumber(self.pureDamage) == false or self.pureDamage < 0 then
        assert(false)
    end

    if MathUtils.IsNumber(self.skillDamage) == false or self.skillDamage < 0 then
        assert(false)
    end

    if MathUtils.IsNumber(self.armorBreak) == false or self.armorBreak < 0 then
        assert(false)
    end

    if MathUtils.IsNumber(self.reduceDamageReduction) == false or self.reduceDamageReduction < 0 then
        assert(false)
    end

    ---
    if MathUtils.IsNumber(self.ccResistance) == false or self.ccResistance < 0 then
        assert(false)
    end

    if MathUtils.IsNumber(self.damageReduction) == false or self.damageReduction < 0 then
        assert(false)
    end
end