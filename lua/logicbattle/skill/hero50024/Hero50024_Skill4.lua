--- @class Hero50024_Skill4 Dwarf
Hero50024_Skill4 = Class(Hero50024_Skill4, BaseSkill)

---------------------------------------- Initialization ----------------------------------------
--- @param hero BaseHero
--- @param id number id of skill (1: activeSkill, 2-4: passiveSkills)
--- @param hero BaseHero
function Hero50024_Skill4:CreateInstance(id, hero)
    return Hero50024_Skill4(id, hero)
end

--- @return void
function Hero50024_Skill4:Init()
    self.myHero.attackListener:BindingWithSkill_4(self)
    self.myHero.skillListener:BindingWithSkill_4(self)
end

--- @return void
--- @param enemyAttacker BaseHero
--- @param totalDamage number
function Hero50024_Skill4:OnTakeDamageFromEnemy(enemyAttacker, totalDamage)
    if self.myHero.randomHelper:RandomRate(self.data.healChance) then
        local healAmount = self.data.healPercent * totalDamage
        HealUtils.Heal(self.myHero, self.myHero, healAmount, HealReason.HEAL_SKILL)
    end
end

--- @return void
--- @param enemy BaseHero
--- @param totalDamage number
function Hero50024_Skill4:OnTakeSkillDamageFromEnemy(enemy, totalDamage)
    if self.myHero.randomHelper:RandomRate(self.data.healChance) then
        local healAmount = self.data.healPercent * totalDamage
        HealUtils.Heal(self.myHero, self.myHero, healAmount, HealReason.HEAL_SKILL)
    end
end

return Hero50024_Skill4