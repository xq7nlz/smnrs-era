--- @class Hero30001_SkillListener
Hero30001_SkillListener = Class(Hero30001_SkillListener, SkillListener)

--- @return void
--- @param hero BaseHero
function Hero30001_SkillListener:Ctor(hero)
    SkillListener.Ctor(self, hero)

    --- @type BaseSkill
    self.skill_2 = nil
end

--- @return number
--- @param skill BaseSkill
function Hero30001_SkillListener:BindingWithSkill_2(skill)
    self.skill_2 = skill
end

--- @return void
--- @param enemyTarget BaseHero
--- @param totalDamage number
function Hero30001_SkillListener:OnDealSkillDamageToEnemy(enemyTarget, totalDamage)
    if self.skill_2 ~= nil then
        self.skill_2:OnDealSkillDamageToEnemy(enemyTarget, totalDamage)
    end
end