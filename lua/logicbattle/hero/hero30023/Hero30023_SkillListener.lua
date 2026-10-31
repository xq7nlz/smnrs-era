--- @class Hero30023_SkillListener
Hero30023_SkillListener = Class(Hero30023_SkillListener, SkillListener)

--- @return void
--- @param hero BaseHero
function Hero30023_SkillListener:Ctor(hero)
    SkillListener.Ctor(self, hero)

    ---@type BaseSkill
    self.skill_2 = nil
end

--- @return void
--- @param skill BaseSkill
function Hero30023_SkillListener:BindingWithSkill_2(skill)
    self.skill_2 = skill
end

--- @return void
--- @param enemy BaseHero
--- @param totalDamage number
function Hero30023_SkillListener:OnTakeSkillDamageFromEnemy(enemy, totalDamage)
    if self.skill_2 ~= nil then
        self.skill_2:OnTakeSkillDamageFromEnemy(enemy, totalDamage)
    end
end