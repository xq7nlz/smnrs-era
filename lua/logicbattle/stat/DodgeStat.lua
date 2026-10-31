--- @class DodgeStat : BaseHeroStat
DodgeStat = Class(DodgeStat, BaseHeroStat)

--- @return void
--- @param hero BaseHero
function DodgeStat:Ctor(hero)
    BaseHeroStat.Ctor(self, hero, StatType.DODGE, StatValueType.RAW)
end

---------------------------------------- Getters ----------------------------------------
--- @return boolean, number isDodge, dodgeDamageRate
--- @param isCrit boolean
--- @param accuracy number
function DodgeStat:CalculateDodgeDamage(isCrit, accuracy)
    if self.myHero.effectController:IsContainCCEffect() then
        return DodgeType.NO_DODGE, 1
    end

    if self:GetValue() > 0 then
        local dodgeRate = 1 - accuracy / self:GetValue()
        local isDodge = self.myHero.randomHelper:RandomRate(dodgeRate)

        if isDodge then
            -- GD: only allows miss chance up to BattleConstants.MAX_MISS_CHANCE (24/10/2018)
            dodgeRate = MathUtils.Clamp(dodgeRate, 0, BattleConstants.MAX_MISS_CHANCE)
            local isMiss = self.myHero.randomHelper:RandomRate(dodgeRate)

            if isMiss then
                return DodgeType.MISS, 0
            else
                return DodgeType.GLANCING, 0.5
            end
        end
    end

    return DodgeType.NO_DODGE, 1
end

--- @return string
function DodgeStat:ToString()
    return string.format("dodge = %s\n", self:GetValue())
end