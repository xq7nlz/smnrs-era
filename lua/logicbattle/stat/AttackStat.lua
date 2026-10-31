--- @class AttackStat : BaseHeroStatIntegral
AttackStat = Class(AttackStat, BaseHeroStatIntegral)

--- @return void
--- @param hero BaseHero
function AttackStat:Ctor(hero)
    BaseHeroStat.Ctor(self, hero, StatType.ATTACK, StatValueType.RAW)
end

---------------------------------------- Getters ----------------------------------------
--- @return number
--- @param target BaseHero
--- @param baseMulti number
function AttackStat:GetMultiAddByTarget(target, baseMulti)
    --- override this method if needed
    return baseMulti
end

--- @return void
function AttackStat:Calculate()
    self._maxValue = BattleConstants.MAX_NUMBER_VALUE

    local rawBase, rawInGame, percentAdd, percentMultiply = self:GetTotalBonus(self._statChangerList)

    local calculatedValue = rawBase * percentAdd * percentMultiply + rawInGame
    self._totalValue = math.floor(MathUtils.Clamp(calculatedValue,
            rawBase * BattleConstants.MAX_ATTACK_DEBUFF_STAT, self._maxValue))

    self:_LimitStat()
    self._maxValue = self._totalValue
end

--- @return number
--- @param damage number of attacker
--- @param armorBreak number of attacker
--- @param defense number of target
function AttackStat:CalculateDamage(damage, armorBreak, defense)
    return math.floor(damage / (defense * (1 - armorBreak) * BattleConstants.DEFENSE_MULTIPLIER + 1))
end

--- @return string
function AttackStat:ToString()
    return string.format("attack = %s\n", self:GetValue())
end