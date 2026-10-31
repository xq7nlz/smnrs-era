--- @class Hero60022_SkillListener
Hero60022_SkillListener = Class(Hero60022_SkillListener, SkillListener)

--- @return void
--- @param hero BaseHero
function Hero60022_SkillListener:Ctor(hero)
    SkillListener.Ctor(self, hero)

    ---@type BaseSkill
    self.skill_4 = nil
end

--- @return void
--- @param skill BaseSkill
function Hero60022_SkillListener:BindingWithSkill_4(skill)
    self.skill_4 = skill
end

--- @return void
--- @param enemyTarget BaseHero
--- @param totalDamage number
function Hero60022_SkillListener:OnDealSkillDamageToEnemy(enemyTarget, totalDamage)
    if self.skill_4 ~= nil then
        self.skill_4:OnDealSkillDamageToEnemy(enemyTarget, totalDamage)
    end
end
