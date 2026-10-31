--- @class Hero50002_SkillListener
Hero50002_SkillListener = Class(Hero50002_SkillListener, SkillListener)

--- @return void
--- @param hero BaseHero
function Hero50002_SkillListener:Ctor(hero)
    SkillListener.Ctor(self, hero)

    --- @type BaseSkill
    self.skill_4 = nil
end

--- @return number
--- @param skill BaseSkill
function Hero50002_SkillListener:BindingWithSkill_4(skill)
    self.skill_4 = skill
end

--- @return void
--- @param enemy BaseHero
--- @param totalDamage number
function Hero50002_SkillListener:OnTakeSkillDamageFromEnemy(enemy, totalDamage)
    if self.skill_4 ~= nil then
        self.skill_4:OnTakeSkillDamageFromEnemy(enemy, totalDamage)
    end
end
