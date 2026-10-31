--- @class ChangePowerActionResult : BaseActionResult
ChangePowerActionResult = Class(ChangePowerActionResult, BaseActionResult)

--- @return void
--- @param initiator BaseHero
--- @param target BaseHero
function ChangePowerActionResult:Ctor(initiator, target)
    BaseActionResult.Ctor(self, initiator, target, ActionResultType.CHANGE_POWER)

    --- @type number
    self.initiatorPowerPercent = initiator.power:GetStatPercent()

    --- @type number
    self.targetPowerPercent = target.power:GetStatPercent()
end

--- @return ChangePowerActionResult
function ChangePowerActionResult:GetData()
    local data = BaseActionResult.GetData(self)

    data._ipp = self.initiatorPowerPercent

    data._tpp = self.targetPowerPercent

    return data
end

--- @return string
function ChangePowerActionResult:ToString()
    local result = string.format("%s, power = %s\n",
            BaseActionResult.GetPrefix(self, "CHANGE_POWER"), self.targetPowerPercent)
    return result
end