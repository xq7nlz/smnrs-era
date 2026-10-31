--- @class Hero10008_SkillListener
Hero10008_SkillListener = Class(Hero10008_SkillListener, SkillListener)

--- @return void
--- @param hero BaseHero
function Hero10008_SkillListener:Ctor(hero)
    SkillListener.Ctor(self, hero)

    ---@type BaseSkill
    self.skill_4 = nil
end

--- @return void
--- @param skill BaseSkill
function Hero10008_SkillListener:BindingWithSkill_4(skill)
    self.skill_4 = skill
end

--- @return void
--- @param enemyTarget BaseHero
--- @param totalDamage number
function Hero10008_SkillListener:OnDealSkillDamageToEnemy(enemyTarget, totalDamage)
    if self.skill_4 ~= nil then
        self.skill_4:OnDealSkillDamageToEnemy(enemyTarget, totalDamage)
    end
end
