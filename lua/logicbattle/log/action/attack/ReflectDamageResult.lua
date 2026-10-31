--- @class ReflectDamageResult : BaseActionResult
ReflectDamageResult = Class(ReflectDamageResult, BaseActionResult)

--- @return void
--- @param initiator BaseHero
--- @param target BaseHero
function ReflectDamageResult:Ctor(initiator, target)
    BaseActionResult.Ctor(self, initiator, target, ActionResultType.REFLECT_DAMAGE)

    --- @type number
    self.damage = nil
end

--- @return void
--- @param damage number
function ReflectDamageResult:SetDamage(damage)
    --- @type number
    self.damage = damage
    self:RefreshHeroStatus()
end

--- @return ReflectDamageResult
function ReflectDamageResult:GetData()
    local data = BaseActionResult.GetData(self)

    data.damage = self.damage

    return data
end

--- @return string
function ReflectDamageResult:ToString()
    local result = string.format("%s, TAKE %s damage\n",
            BaseActionResult.GetPrefix(self, "REFLECT"), self.damage)
    return result
end