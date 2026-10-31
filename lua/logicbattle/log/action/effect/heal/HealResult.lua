--- @class HealResult : BaseActionResult
HealResult = Class(HealResult, BaseActionResult)

--- @return void
--- @param initiator BaseHero
--- @param target BaseHero
--- @param healAmount number
--- @param healReason HealReason
function HealResult:Ctor(initiator, target, healAmount, healReason)
    BaseActionResult.Ctor(self, initiator, target, ActionResultType.HEAL_EFFECT)

    --- @type number
    self.healAmount = healAmount

    --- @type HealReason
    self.healReason = healReason
end

--- @return HealResult
function HealResult:GetData()
    local data = BaseActionResult.GetData(self)

    data.healAmount = self.healAmount

    data.healReason = self.healReason

    return data
end

--- @return string
function HealResult:ToString()
    local result = string.format("%s, HEAL %s hp, reason = %s\n",
            BaseActionResult.GetPrefix(self, "HEAL"), self.healAmount, self.healReason)
    return result
end