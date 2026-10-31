--- @class MagicShieldResult : BaseActionResult
MagicShieldResult = Class(MagicShieldResult, BaseActionResult)

--- @return void
--- @param initiator BaseHero
--- @param target BaseHero
--- @param reason TakeDamageReason
--- @param damage number
function MagicShieldResult:Ctor(initiator, target, reason, damage)
    BaseActionResult.Ctor(self, initiator, target, ActionResultType.MAGIC_SHIELD)

    --- @type number
    self.reason = reason

    --- @type number
    self.damage = damage
end

--- @return MagicShieldResult
function MagicShieldResult:GetData()
    local data = BaseActionResult.GetData(self)

    data.reason = self.reason

    data.damage = self.damage

    return data
end

--- @return string
function MagicShieldResult:ToString()
    local result = string.format("%s, reason = %s, damage = %s\n",
            BaseActionResult.GetPrefix(self, "MAGIC_SHIELD"), self.reason, self.damage)
    return result
end