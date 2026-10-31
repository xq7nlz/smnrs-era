--- @class Hero30011_Skill2 : BaseSkill Skaven
Hero30011_Skill2 = Class(Hero30011_Skill2, BaseSkill)

--- @return void
--- @param id number id of skill (1: activeSkill, 2-4: passiveSkills)
--- @param hero BaseHero
function Hero30011_Skill2:Ctor(id, hero)
    BaseSkill.Ctor(self, id, hero)

    --- @type number
    self.healHpPercent = nil
end

---------------------------------------- Initialization ----------------------------------------
--- @return BaseSkill
--- @param id number id of skill (1: activeSkill, 2-4: passiveSkills)
--- @param hero BaseHero
function Hero30011_Skill2:CreateInstance(id, hero)
    return Hero30011_Skill2(id, hero)
end

--- @return void
function Hero30011_Skill2:Init()
    self.healHpPercent = self.data.healHpPercent

    self.myHero.attackListener:BindingWithSkill_2(self)
    self.myHero.skillListener:BindingWithSkill_2(self)
end

---------------------------------------- Battle ----------------------------------------
--- @return void
--- @param enemyAttacker BaseHero
--- @param totalDamage number
function Hero30011_Skill2:OnTakeDamageFromEnemy(enemyAttacker, totalDamage)
    local healAmount = totalDamage * self.healHpPercent
    HealUtils.Heal(self.myHero, self.myHero, healAmount, HealReason.HEAL_SKILL)
end

--- @return void
--- @param enemy BaseHero
--- @param totalDamage number
function Hero30011_Skill2:OnTakeSkillDamageFromEnemy(enemy, totalDamage)
    local healAmount = totalDamage * self.healHpPercent
    HealUtils.Heal(self.myHero, self.myHero, healAmount, HealReason.HEAL_SKILL)
end

return Hero30011_Skill2