--- @class Hero30007_SkillListener
Hero30007_SkillListener = Class(Hero30007_SkillListener, SkillListener)

--- @return void
--- @param hero BaseHero
function Hero30007_SkillListener:Ctor(hero)
    SkillListener.Ctor(self, hero)

    --- @type BaseSkill
    self.skill_3 = nil
end

--- @return number
--- @param skill BaseSkill
function Hero30007_SkillListener:BindingWithSkill_3(skill)
    self.skill_3 = skill
end

--- @return void
--- @param enemy BaseHero
--- @param totalDamage number
function Hero30007_SkillListener:OnTakeSkillDamageFromEnemy(enemy, totalDamage)
    if self.skill_3 ~= nil then
        self.skill_3:OnTakeSkillDamageFromEnemy(enemy, totalDamage)
    end
end
