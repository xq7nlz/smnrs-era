--- @class Hero50006_Skill3 Enule
Hero50006_Skill3 = Class(Hero50006_Skill3, BaseSkill)

--- @return void
--- @param id number id of skill (1: activeSkill, 2-4: passiveSkills)
--- @param hero BaseHero
function Hero50006_Skill3:Ctor(id, hero)
    BaseSkill.Ctor(self, id, hero)

    --- @type number
    self.extraTurnChance = 0

    --- @type number
    self.damageOfExtraTurn = 0

    --- @type number
    self.extraTurnLimit = 0

    --- @type number
    self.numberExtraTurnThisRound = 0

    --- @type number
    self.damageOfExtraTurn = 0

    --- @type number
    self.currentDamageExtraTurn = 1
end

--- @return BaseSkill
--- @param id number id of skill (1: activeSkill, 2-4: passiveSkills)
--- @param hero BaseHero
function Hero50006_Skill3:CreateInstance(id, hero)
    return Hero50006_Skill3(id, hero)
end

--- @return void
function Hero50006_Skill3:Init()
    self.extraTurnChance = self.data.extraTurnChance
    self.damageOfExtraTurn = self.data.damageOfExtraTurn
    self.extraTurnLimit = self.data.extraTurnLimit

    --- binding to calculation have extra turn
    self.myHero.attackController:BindingWithSkill_3(self)
    self.myHero.skillController.activeSkill:BindingWithSkill_3(self)

    --- Binding to get damage and reset
    self.myHero.battleListener:BindingWithSkill_3(self)
    self.myHero.battleHelper:BindingWithSkill_3(self)
end

---------------------------------------- BATTLE -----------------------------------
--- @return void
function Hero50006_Skill3:OnEndBattleRound()
    self.numberExtraTurnThisRound = 0
    self.currentDamageExtraTurn = 1
end

--- @return boolean
function Hero50006_Skill3:ExtraTurn()
    if self.myHero.randomHelper:RandomRate(self.extraTurnChance) and self.numberExtraTurnThisRound < self.extraTurnLimit then
        self.numberExtraTurnThisRound = self.numberExtraTurnThisRound + 1
        self.currentDamageExtraTurn = self.currentDamageExtraTurn * self.damageOfExtraTurn
        return true
    else
        self:OnEndBattleRound()
        return false
    end
end

--- @return number, number
--- @param multiplier number
function Hero50006_Skill3:GetMultiDamageExtraTurn(multiplier)
    local result = self.currentDamageExtraTurn * multiplier
    return result, self.numberExtraTurnThisRound
end

return Hero50006_Skill3