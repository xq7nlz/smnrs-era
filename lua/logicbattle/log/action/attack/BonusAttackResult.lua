--- @class BonusAttackResult : AttackResult
BonusAttackResult = Class(BonusAttackResult, AttackResult)

--- @return void
--- @param initiator BaseHero
--- @param target BaseHero
function BonusAttackResult:Ctor(initiator, target)
    AttackResult.Ctor(self, initiator, target)
    self.type = ActionResultType.BONUS_ATTACK
end

--- @return string
function BonusAttackResult:ToString()
    local result = BaseActionResult.GetPrefix(self, ">>> BONUS_ATTACK <<<")
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
        result = result .. string.format("%s BLOCK BONUS_ATTACK\n", self.target:ToString())
    end

    return result
end