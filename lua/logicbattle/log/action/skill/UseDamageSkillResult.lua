--- @class UseDamageSkillResult : BaseActionResult
UseDamageSkillResult = Class(UseDamageSkillResult, BaseActionResult)

--- @return void
--- @param initiator BaseHero
--- @param target BaseHero
function UseDamageSkillResult:Ctor(initiator, target)
    BaseActionResult.Ctor(self, initiator, target, ActionResultType.USE_ACTIVE_DAMAGE_SKILL)

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
--- @param isBlock boolean
function UseDamageSkillResult:SetInfo(isCrit, isBlock)
    self.isCrit = isCrit
    self.isBlock = isBlock
end

--- @return void
--- @param damage number
function UseDamageSkillResult:SetDamage(damage)
    self.damage = damage
    self:RefreshHeroStatus()
    self:RefreshHeroPower()
end

--- @return void
function UseDamageSkillResult:RefreshHeroPower()
    self.initiatorPowerPercent = self.initiator.power:GetStatPercent()
    self.targetPowerPercent = self.target.power:GetStatPercent()
end

--- @return UseDamageSkillResult
function UseDamageSkillResult:GetData()
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
function UseDamageSkillResult:ToString()
    local result = string.format("%s, TAKE %s damage",
            BaseActionResult.GetPrefix(self, ">>> ACTIVE_SKILL <<<"), self.damage)
    result = result .. string.format(", initiatorPower = %s, targetPower = %s", self.initiatorPowerPercent, self.targetPowerPercent)

    if self.isCrit then
        result = result .. " (CRIT)"
    end

    result = result .. "\n"

    if self.isBlock then
        result = result .. string.format("%s BLOCK ACTIVE_SKILL\n", self.target:ToString())
    end

    return result
end