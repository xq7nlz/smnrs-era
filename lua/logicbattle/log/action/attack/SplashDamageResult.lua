--- @class SplashDamageResult : BaseActionResult
SplashDamageResult = Class(SplashDamageResult, BaseActionResult)

--- @return void
--- @param initiator BaseHero
--- @param target BaseHero
function SplashDamageResult:Ctor(initiator, target)
    BaseActionResult.Ctor(self, initiator, target, ActionResultType.SPLASH_DAMAGE)

    --- @type number
    self.damage = nil
end

--- @return void
--- @param damage number
function SplashDamageResult:SetDamage(damage)
    --- @type number
    self.damage = damage
    self:RefreshHeroStatus()
end

--- @return SplashDamageResult
function SplashDamageResult:GetData()
    local data = BaseActionResult.GetData(self)

    data.damage = self.damage

    return data
end

--- @return string
function SplashDamageResult:ToString()
    local result = string.format("%s, TAKE %s damage\n",
            BaseActionResult.GetPrefix(self, "SPLASH"), self.damage)
    return result
end