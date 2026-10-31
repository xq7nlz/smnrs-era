--- @class Hero20026_SkillListener
Hero20026_SkillListener = Class(Hero20026_SkillListener, SkillListener)

--- @return void
--- @param hero BaseHero
function Hero20026_SkillListener:Ctor(hero)
    SkillListener.Ctor(self, hero)

    --- @type BaseSkill
    self.skill_2 = nil
end

--- @return number
--- @param skill BaseSkill
function Hero20026_SkillListener:BindingWithSkill_2(skill)
    self.skill_2 = skill
end

--- @return void
--- @param enemy BaseHero
--- @param totalDamage number
function Hero20026_SkillListener:OnTakeSkillDamageFromEnemy(enemy, totalDamage)
    if self.skill_2 ~= nil then
        self.skill_2:OnTakeSkillDamageFromEnemy(enemy, totalDamage)
    end
end
