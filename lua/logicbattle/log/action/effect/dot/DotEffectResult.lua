--- @class DotEffectResult : BaseActionResult
DotEffectResult = Class(DotEffectResult, BaseActionResult)

--- @return void
--- @param initiator BaseHero
--- @param target BaseHero
--- @param type ActionResultType
--- @param remainingRound number
function DotEffectResult:Ctor(initiator, target, type, remainingRound)
    BaseActionResult.Ctor(self, initiator, target, type)

    --- @type number
    self.damage = nil

    --- @type number
    self.remainingRound = remainingRound
end

--- @return void
--- @param damage number
function DotEffectResult:SetDamage(damage)
    self.damage = damage
end

--- @return DotEffectResult
function DotEffectResult:GetData()
    local data = BaseActionResult.GetData(self)

    data.damage = self.damage

    data.remainingRound = self.remainingRound

    return data
end

--- @return string
function DotEffectResult:ToString(actionName)
    local result = string.format("%s, TAKE %s damage, remainingRound = %s\n",
            BaseActionResult.GetPrefix(self, actionName), self.damage, self.remainingRound)
    return result
end