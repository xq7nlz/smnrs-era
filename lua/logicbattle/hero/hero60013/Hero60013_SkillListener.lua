--- @class Hero60013_SkillListener
Hero60013_SkillListener = Class(Hero60013_SkillListener, SkillListener)

--- @return void
--- @param hero BaseHero
function Hero60013_SkillListener:Ctor(hero)
    SkillListener.Ctor(self, hero)

    ---@type BaseSkill
    self.skill_3 = nil
end

--- @return void
--- @param skill BaseSkill
function Hero60013_SkillListener:BindingWithSkill_3(skill)
    self.skill_3 = skill
end


--- @return void
--- @param enemy BaseHero
--- @param totalDamage number
function Hero60013_SkillListener:OnTakeSkillDamageFromEnemy(enemy, totalDamage)
    if self.skill_3 ~= nil then
        self.skill_3:OnTakeSkillDamageFromEnemy(enemy, totalDamage)
    end
end
