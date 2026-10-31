--- @class Hero10005_SkillListener
Hero10005_SkillListener = Class(Hero10005_SkillListener, SkillListener)

--- @return void
--- @param hero BaseHero
function Hero10005_SkillListener:Ctor(hero)
    SkillListener.Ctor(self, hero)

    --- @type BaseSkill
    self.skill_4 = nil
end

--- @return number
--- @param skill BaseSkill
function Hero10005_SkillListener:BindingWithSkill_4(skill)
    self.skill_4 = skill
end

--- @return void
--- @param enemy BaseHero
--- @param totalDamage number
function Hero10005_SkillListener:OnTakeSkillDamageFromEnemy(enemy, totalDamage)
    if self.skill_4 ~= nil then
        self.skill_4:OnTakeSkillDamageFromEnemy(enemy, totalDamage)
    end
end
