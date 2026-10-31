--- @class Hero10011_Skill4 Jeronim
Hero10011_Skill4 = Class(Hero10011_Skill4, BaseSkill)

--- @return void
--- @param id number id of skill (1: activeSkill, 2-4: passiveSkills)
--- @param hero BaseHero
function Hero10011_Skill4:Ctor(id, hero)
    BaseSkill.Ctor(self, id, hero)

    --- @type number
    self.extraTurnChance = 0

    --- @type number
    self.damageOfExtraTurn = 0

    --- @type number
    self.extraTurnLimit = 0

    --- @type number
    self.numberExtraTurnThisRound = 0

    --- @type boolean
    self.canHaveExtraTurn = false
end

--- @return BaseSkill
--- @param id number id of skill (1: activeSkill, 2-4: passiveSkills)
--- @param hero BaseHero
function Hero10011_Skill4:CreateInstance(id, hero)
    return Hero10011_Skill4(id, hero)
end

--- @return void
function Hero10011_Skill4:Init()
    self.extraTurnChance = self.data.extraTurnChance
    self.damageOfExtraTurn = self.data.damageOfExtraTurn
    self.extraTurnLimit = self.data.extraTurnLimit

    self.myHero.attackController:BindingWithSkill_4(self)
    self.myHero.skillController:BindingWithSkill_4(self)

    self.myHero.battleHelper:BindingWithSkill_4(self)

    self.myHero.battleListener:BindingWithSkill_4(self)
    self.myHero.skillListener:BindingWithSkill_4(self)
    self.myHero.attackListener:BindingWithSkill_4(self)
end

---------------------------------------- BATTLE -----------------------------------
--- @return void
--- @param round BattleRound
function Hero10011_Skill4:OnStartBattleRound(round)
    self.numberExtraTurnThisRound = 0
    self.canHaveExtraTurn = false
end

--- @return void
--- @param turn BattleTurn
function Hero10011_Skill4:OnStartBattleTurn(turn)
    self.canHaveExtraTurn = false
end

--- @return void
--- @param enemyDefender BaseHero
--- @param totalDamage number
function Hero10011_Skill4:OnDealCritDamage(enemyDefender, totalDamage)
    self.canHaveExtraTurn = true
end

--- @return void
function Hero10011_Skill4:ShouldEndTurn()
    if self.canHaveExtraTurn and self.numberExtraTurnThisRound < self.extraTurnLimit then
        self.numberExtraTurnThisRound = self.numberExtraTurnThisRound + 1
        return false
    end
    self.numberExtraTurnThisRound = 0
    return true
end

--- @return number, number
--- @param multiplier number
function Hero10011_Skill4:GetMultiDamageExtraTurn(multiplier)
    if self.numberExtraTurnThisRound > 0 then
        for _ = 1, self.numberExtraTurnThisRound do
            multiplier = multiplier * self.damageOfExtraTurn
        end
    end
    return multiplier, self.numberExtraTurnThisRound
end

return Hero10011_Skill4