--- @class AttackResult : BaseActionResult
AttackResult = Class(AttackResult, BaseActionResult)

--- @return void
--- @param initiator BaseHero
--- @param target BaseHero
function AttackResult:Ctor(initiator, target)
    BaseActionResult.Ctor(self, initiator, target, ActionResultType.ATTACK)

    --- @type boolean
    self.isCrit = false

    --- @type DodgeType
    self.dodgeType = DodgeType.NO_DODGE

    --- @type boolean
    self.isBlock = false

    --- @type number
    self.damage = 0

    --- @type number
    self.initiatorPowerPercent = nil

    --- @type number
    self.targetPowerPercent = nil
end

--- @return void
--- @param isCrit boolean
--- @param dodgeType DodgeType
--- @param isBlock boolean
function AttackResult:SetInfo(isCrit, dodgeType, isBlock)
    self.isCrit = isCrit
    self.dodgeType = dodgeType
    self.isBlock = isBlock
end

--- @return void
--- @param damage number
function AttackResult:SetDamage(damage)
    self.damage = damage
    self:RefreshHeroStatus()
    self:RefreshHeroPower()
end

--- @return void
function AttackResult:RefreshHeroPower()
    self.initiatorPowerPercent = self.initiator.power:GetStatPercent()
    self.targetPowerPercent = self.target.power:GetStatPercent()
end

--- @return AttackResult
function AttackResult:GetData()
    local data = BaseActionResult.GetData(self)

    data.isCrit = self.isCrit

    data.dodgeType = self.dodgeType

    data.isBlock = self.isBlock

    data.damage = self.damage

    data._ipp = self.initiatorPowerPercent

    data._tpp = self.targetPowerPercent

    return data
end

--- @return string
function AttackResult:ToString()
    local result = BaseActionResult.GetPrefix(self, ">>> BASIC_ATTACK <<<")
    if self.dodgeType == DodgeType.MISS then
        result = result .. " (MISS)"
    elseif self.dodgeType == DodgeType.GLANCING then
        result = result .. " (GLANCING)"
    end

    result = result .. string.format(", TAKE %s damage", self.damage)
    result = result .. string.format(", initiatorPower = %s, targetPower = %s", self.initiatorPowerPercent, self.targetPowerPercent)

    if self.isCrit then
        result = result .. " (CRIT)"
    end

    result = result .. "\n"

    if self.isBlock then
        result = result .. string.format("%s BLOCK BASIC_ATTACK\n", self.target:ToString())
    end

    return result
end