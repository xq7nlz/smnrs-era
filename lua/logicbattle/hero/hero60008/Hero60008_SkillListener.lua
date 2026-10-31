--- @class Hero60008_SkillListener
Hero60008_SkillListener = Class(Hero60008_SkillListener, SkillListener)

--- @return void
--- @param hero BaseHero
function Hero60008_SkillListener:Ctor(hero)
    SkillListener.Ctor(self, hero)

    ---@type BaseSkill
    self.skill_2 = nil
end

--- @return void
--- @param skill BaseSkill
function Hero60008_SkillListener:BindingWithSkill_2(skill)
    self.skill_2 = skill
end


--- @return void
--- @param enemy BaseHero
--- @param totalDamage number
function Hero60008_SkillListener:OnDealSkillDamageToEnemy(enemy, totalDamage)
    if self.skill_2 ~= nil then
        self.skill_2:OnDealDamageToEnemy(enemy, totalDamage, DodgeType.NO_DODGE)
    end
end