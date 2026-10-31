--- @class BondShareDamageResult : BaseActionResult
BondShareDamageResult = Class(BondShareDamageResult, BaseActionResult)

--- @return void
--- @param initiator BaseHero
--- @param bondType BondType
function BondShareDamageResult:Ctor(initiator, target, bondType)
    BaseActionResult.Ctor(self, initiator, target, ActionResultType.BOND_SHARE_DAMAGE)

    --- @type BaseHero
    self.damage = nil

    --- @type BondType
    self.bondType = bondType
end

--- @return void
--- @param damage number
function BondShareDamageResult:SetDamage(damage)
    self.damage = damage
end

--- @return BondShareDamageResult
function BondShareDamageResult:GetData()
    local data = BaseActionResult.GetData(self)

    data.damage = self.damage

    data.bondType = self.bondType

    return data
end

--- @return string
function BondShareDamageResult:ToString()
    local result = string.format("%s, TAKE %s damage (bondType = %s)\n",
            BaseActionResult.GetPrefix(self, "BOND_SHARE_DAMAGE"), self.damage, self.bondType)
    return result
end