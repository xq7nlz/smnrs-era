--- @class Hero50012_SkillListener Alvar
Hero50012_SkillListener = Class(Hero50012_SkillListener, SkillListener)

function Hero50012_SkillListener:Ctor(hero)
    SkillListener.Ctor(self, hero)

    ---@type BaseSkill
    self.skill_1 = nil
end

--- @return void
--- @param skill BaseSkill
function Hero50012_SkillListener:BindingWithSkill_1(skill)
    self.skill_1 = skill
end
---------------------------------------------------Battle-----------------------------------------

--- @return void
--- @param enemyTarget BaseHero
--- @param totalDamage number
function Hero50012_SkillListener:OnDealSkillDamageToEnemy(enemyTarget, totalDamage)
    if self.skill_1 ~= nil then
        self.skill_1:OnDealSkillDamageToEnemy(enemyTarget, totalDamage)
    end
end
