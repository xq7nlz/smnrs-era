--- @class VenomStackResult : BaseActionResult
VenomStackResult = Class(VenomStackResult, BaseActionResult)

--- @return void
--- @param initiator BaseHero
--- @param target BaseHero
--- @param roundRemaining number
function VenomStackResult:Ctor(initiator, target, roundRemaining)
    BaseActionResult.Ctor(self, initiator, target, ActionResultType.VENOM_STACK)

    --- @type number
    self.damage = nil

    --- @type number
    self.roundRemaining = roundRemaining
end

--- @return void
--- @param damage number
function VenomStackResult:SetDamage(damage)
    self.damage = damage
end

--- @return VenomStackResult
function VenomStackResult:GetData()
    local data = BaseActionResult.GetData(self)

    data.damage = self.damage

    data.roundRemaining = self.roundRemaining

    return data
end

--- @return string
function VenomStackResult:ToString()
    local result = string.format("%s, TAKE %s damage, roundRemaining = %s\n",
            BaseActionResult.GetPrefix(self, "VENOM_STACK"), self.damage, self.roundRemaining)
    return result
end