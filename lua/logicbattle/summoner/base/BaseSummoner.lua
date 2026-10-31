--- @class BaseSummoner : BaseHero
BaseSummoner = Class(BaseSummoner, BaseHero)

--- @return void
function BaseSummoner:Ctor()
    BaseHero.Ctor(self)

    --- @type List<number>
    self.skillLevels = List()

    --- @type SummonerDataEntry
    self.summonerDataEntry = nil

    --- @type boolean
    self.canPlay = false
end

--- @return HeroInitializer
function BaseSummoner:CreateInitializer()
    return SummonerInitializer(self)
end

---------------------------------------- Battle actions ----------------------------------------
--- @return List<BaseActionResult>, boolean
--- @param actionType ActionType
function BaseSummoner:DoAction(actionType)
    return self.skillController:UseActiveSkill()
end

---------------------------------------- Getters ----------------------------------------
--- @return boolean
function BaseSummoner:GetActionType()
    return ActionType.USE_SKILL
end

--- @return number
function BaseSummoner:CalculateBattlePower()
    local result = 0

    local critRateCoef = 1 + self.critRate:GetValue() * (self.critDamage:GetValue() - 1) + 0.7 * self.skillDamage:GetValue()
    local levelCoef = 20 * self.level * (1 - self.armorBreak:GetValue()) + 1
    result = result + 3 * self.attack:GetValue() * (critRateCoef / levelCoef + self.pureDamage:GetValue())

    result = result + 50 * self.speed:GetValue() + 3 * self.accuracy:GetValue()

    -- ignore defense, damageReduction, hp, dodge
    return result
end

---------------------------------------- ToString ----------------------------------------
--- @return string
function BaseSummoner:ToString()
    return string.format("[%s (TEAM %s)]", self.name, self.teamId)
end

--- @return string
function BaseSummoner:ToDetailString()
    local result = self:ToString() .. "\n"

    result = result .. string.format("star = %s\n", self.star)
    result = result .. string.format("level = %s\n", self.level)

    result = result .. string.format("isBoss = %s\n", tostring(self.isBoss))
    result = result .. string.format("isSummoner = %s\n", tostring(self.isSummoner))
    result = result .. string.format("isDummy = %s\n", tostring(self.isDummy))

    result = result .. self.originInfo:ToString()

    result = result .. self.attack:ToString()

    result = result .. self.critRate:ToString()
    result = result .. self.critDamage:ToString()

    result = result .. self.accuracy:ToString()

    result = result .. self.pureDamage:ToString()
    result = result .. self.skillDamage:ToString()
    result = result .. self.armorBreak:ToString()

    return result
end