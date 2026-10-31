--- @class DivineShieldResult : BaseActionResult
DivineShieldResult = Class(DivineShieldResult, BaseActionResult)

--- @return void
--- @param initiator BaseHero
--- @param target BaseHero
function DivineShieldResult:Ctor(initiator, target, remainingRound, damage, remainingHp)
    BaseActionResult.Ctor(self, initiator, target, ActionResultType.DIVINE_SHIELD)

    --- @type number
    self.remainingRound = remainingRound

    --- @type number
    self.damage = damage

    --- @type number
    self.remainingHp = remainingHp
end

--- @return DivineShieldResult
function DivineShieldResult:GetData()
    local data = BaseActionResult.GetData(self)

    data.remainingRound = self.remainingRound

    data.damage = self.damage

    data.remainingHp = self.remainingHp

    return data
end

--- @return string
function DivineShieldResult:ToString()
    local result = ""
    if self.remainingRound >= 0 then
        if self.damage == nil or self.damage == 0 then
            result = string.format("%s, ADD SHIELD, hp = %s\n",
                    BaseActionResult.GetPrefix(self, "DIVINE_SHIELD"), self.remainingHp)
        else
            result = string.format("%s, RECEIVE %s damage to SHIELD, hp = %s\n",
                    BaseActionResult.GetPrefix(self, "DIVINE_SHIELD"), self.damage, self.remainingHp)
        end
    else
        result = string.format("%s, REMOVE SHIELD\n",
                BaseActionResult.GetPrefix(self, "DIVINE_SHIELD"))
    end
    return result
end
