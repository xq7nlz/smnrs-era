--- @class BouncingDamageResult : BaseActionResult
BouncingDamageResult = Class(BouncingDamageResult, BaseActionResult)

--- @return void
--- @param initiator BaseHero
--- @param target BaseHero
--- @param bouncingId number
--- @param numberBouncing number
function BouncingDamageResult:Ctor(initiator, target, bouncingId, numberBouncing)
    BaseActionResult.Ctor(self, initiator, target, ActionResultType.BOUNCING_DAMAGE)

    --- @type number
    self.bouncingId = bouncingId

    --- @type number
    self.numberBouncing = numberBouncing

    --- @type boolean
    self.isCrit = false

    --- @type DodgeType
    self.dodgeType = DodgeType.NO_DODGE

    --- @type boolean
    self.isBlock = false

    --- @type number
    self.damage = nil
end

--- @return void
--- @param damage number
function BouncingDamageResult:SetDamage(damage)
    --- @type number
    self.damage = damage
    self:RefreshHeroStatus()
end

--- @return BouncingDamageResult
function BouncingDamageResult:GetData()
    local data = BaseActionResult.GetData(self)

    data.bouncingId = self.bouncingId

    data.numberBouncing = self.numberBouncing

    data.isCrit = self.isCrit

    data.dodgeType = self.dodgeType

    data.isBlock = self.isBlock

    data.damage = self.damage

    return data
end

--- @return string
function BouncingDamageResult:ToString()
    local result = string.format("%s, TAKE %s damage, bouncingId = %s, numberBouncing = %s\n",
            BaseActionResult.GetPrefix(self, "BOUNCING"), self.damage, self.bouncingId, self.numberBouncing)
    return result
end