--- @class Hero50023_Skill4 Dancer
Hero50023_Skill4 = Class(Hero50023_Skill4, BaseSkill)

---------------------------------------- Initialization ----------------------------------------
--- @param hero BaseHero
--- @param id number id of skill (1: activeSkill, 2-4: passiveSkills)
--- @param hero BaseHero
function Hero50023_Skill4:CreateInstance(id, hero)
    return Hero50023_Skill4(id, hero)
end

--- @return void
function Hero50023_Skill4:Init()
    self.myHero.attackListener:BindingWithSkill_4(self)
    self.myHero.skillListener:BindingWithSkill_4(self)
end

--- @return void
--- @param enemyDefender BaseHero
--- @param totalDamage number
--- @param dodgeType DodgeType
function Hero50023_Skill4:OnDealDamageToEnemy(enemyDefender, totalDamage, dodgeType)
    local healAmount = self.data.healPercent * totalDamage
    HealUtils.Heal(self.myHero, self.myHero, healAmount, HealReason.HEAL_SKILL)
end

--- @return void
--- @param enemyTarget BaseHero
--- @param totalDamage number
function Hero50023_Skill4:OnDealSkillDamageToEnemy(enemyTarget, totalDamage)
    local healAmount = self.data.healPercent * totalDamage
    HealUtils.Heal(self.myHero, self.myHero, healAmount, HealReason.HEAL_SKILL)
end

return Hero50023_Skill4