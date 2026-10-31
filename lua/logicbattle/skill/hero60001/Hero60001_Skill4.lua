--- @class Hero60001_Skill4 BlackArrow
Hero60001_Skill4 = Class(Hero60001_Skill4, BaseSkill)

--- @return void
--- @param id number id of skill (1: activeSkill, 2-4: passiveSkills)
--- @param hero BaseHero
function Hero60001_Skill4:Ctor(id, hero)
    BaseSkill.Ctor(self, id, hero)

    --- @type number
    self.extraTurnChance = nil

    --- @type number
    self.extraTurnLimit = nil

    --- @type number
    self.numberExtraTurnThisRound = 0

    --- @type boolean
    self.canHaveExtraTurn = false

    --- @type number
    self.damagePerExtraTurn = false
end

---------------------------------------- Initialization ----------------------------------------
--- @return BaseSkill
--- @param id number id of skill (1: activeSkill, 2-4: passiveSkills)
--- @param hero BaseHero
function Hero60001_Skill4:CreateInstance(id, hero)
    return Hero60001_Skill4(id, hero)
end

--- @return void
function Hero60001_Skill4:Init()
    self.extraTurnChance = self.data.extraTurnChance
    self.extraTurnLimit = self.data.extraTurnLimit
    self.damagePerExtraTurn = self.data.damagePerExtraTurn

    self.myHero.attackController:BindingWithSkill_4(self)
    self.myHero.attackListener:BindingWithSkill_4(self)
    self.myHero.battleListener:BindingWithSkill_4(self)
    self.myHero.battleHelper:BindingWithSkill_4(self)
end

---------------------------------------- Calculate ----------------------------------------
--- @return void
--- @param round BattleRound
function Hero60001_Skill4:OnStartBattleRound(round)
    self.numberExtraTurnThisRound = 0
    self.canHaveExtraTurn = false
end

--- @return void
--- @param turn BattleTurn
function Hero60001_Skill4:OnStartBattleTurn(turn)
    self.canHaveExtraTurn = false
end

--- @return void
--- @param enemyDefender BaseHero
--- @param totalDamage number
function Hero60001_Skill4:OnDealCritDamage(enemyDefender, totalDamage)
    self.canHaveExtraTurn = true
end

--- @return void
function Hero60001_Skill4:ShouldEndTurn()
    if self.canHaveExtraTurn and self.numberExtraTurnThisRound < self.extraTurnLimit then
        self.numberExtraTurnThisRound = self.numberExtraTurnThisRound + 1
        return false
    end
    self.numberExtraTurnThisRound = 0
    return true
end

--- @return number, number
--- @param multiplier number
function Hero60001_Skill4:CalculateAttackResult(multiplier)
    if self.numberExtraTurnThisRound > 0 then
        for _ = 1, self.numberExtraTurnThisRound do
            multiplier = multiplier * self.damagePerExtraTurn
        end
    end
    return multiplier, self.numberExtraTurnThisRound
end

return Hero60001_Skill4