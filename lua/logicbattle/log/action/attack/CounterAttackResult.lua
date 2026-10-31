--- @class CounterAttackResult : BaseActionResult
CounterAttackResult = Class(CounterAttackResult, BaseActionResult)

--- @return void
--- @param initiator BaseHero
--- @param target BaseHero
function CounterAttackResult:Ctor(initiator, target)
    BaseActionResult.Ctor(self, initiator, target, ActionResultType.COUNTER_ATTACK)

    --- @type boolean
    self.isBlock = false

    --- @type DodgeType
    self.dodgeType = DodgeType.NO_DODGE

    --- @type number
    self.damage = 0
end

--- @return void
--- @param damage number
--- @param isBlock boolean
--- @param dodgeType number
function CounterAttackResult:SetInfo(damage, isBlock, dodgeType)
    self.damage = damage
    self.isBlock = isBlock
    self.dodgeType = dodgeType
    self:RefreshHeroStatus()
end

--- @return CounterAttackResult
function CounterAttackResult:GetData()
    local data = BaseActionResult.GetData(self)

    data.isBlock = self.isBlock

    data.dodgeType = self.dodgeType

    data.damage = self.damage

    return data
end

--- @return string
function CounterAttackResult:ToString()
    local result = string.format("%s, TAKE %s damage",
            BaseActionResult.GetPrefix(self, "COUNTER_ATTACK"), self.damage)

    if self.dodgeType == DodgeType.MISS then
        result = result .. " (MISS)"
    elseif self.dodgeType == DodgeType.GLANCING then
        result = result .. " (GLANCING)"
    end

    result = result .. "\n"

    if self.isBlock then
        result = result .. string.format("%s BLOCK COUNTER_ATTACK\n", self.target:ToString())
    end

    return result
end