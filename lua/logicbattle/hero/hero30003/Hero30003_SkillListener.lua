--- @class Hero30003_SkillListener
Hero30003_SkillListener = Class(Hero30003_SkillListener, SkillListener)

--- @return void
--- @param hero BaseHero
function Hero30003_SkillListener:Ctor(hero)
    SkillListener.Ctor(self, hero)

    --- @type BaseSkill
    self.skill_2 = nil
end

--- @return number
--- @param skill BaseSkill
function Hero30003_SkillListener:BindingWithSkill_2(skill)
    self.skill_2 = skill
end

--- @return void
--- @param enemyTarget BaseHero
--- @param totalDamage number
function Hero30003_SkillListener:OnDealSkillDamageToEnemy(enemyTarget, totalDamage)
    if self.skill_2 ~= nil then
        self.skill_2:OnDealSkillDamageToEnemy(enemyTarget, totalDamage)
    end
end
