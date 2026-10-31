--- @class Hero30004_Skill4 Stheno
Hero30004_Skill4 = Class(Hero30004_Skill4, BaseSkill)

--- @return void
--- @param id number id of skill (1: activeSkill, 2-4: passiveSkills)
--- @param hero BaseHero
function Hero30004_Skill4:Ctor(id, hero)
    BaseSkill.Ctor(self, id, hero)

    --- @type number
    self.healPercent = nil
end

---------------------------------------- Initialization ----------------------------------------
--- @return BaseSkill
--- @param id number id of skill (1: activeSkill, 2-4: passiveSkills)
--- @param hero BaseHero
function Hero30004_Skill4:CreateInstance(id, hero)
    return Hero30004_Skill4(id, hero)
end

--- @return void
function Hero30004_Skill4:Init()
    self.healPercent = self.data.healPercent
    self.myHero.battleListener:BindingWithSkill_4(self)
end

---------------------------------------- Calculate ----------------------------------------
--- @return void
--- @param round BattleRound
function Hero30004_Skill4:OnStartBattleRound(round)
    local totalDamage = self.myHero.hp:GetTotalDamageInRound()
    if totalDamage > 0 then
        local healAmount = totalDamage * self.healPercent
        HealUtils.Heal(self.myHero, self.myHero, healAmount, HealReason.HEAL_SKILL)
    end

    self.myHero.hp:OnStartBattleRound(round)
end

return Hero30004_Skill4