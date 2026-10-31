--- @class Hero50024_SkillListener Dancer
Hero50024_SkillListener = Class(Hero50024_SkillListener, SkillListener)

function Hero50024_SkillListener:Ctor(hero)
    SkillListener.Ctor(self, hero)

    ---@type BaseSkill
    self.skill_4 = nil
end

--- @return void
--- @param skill BaseSkill
function Hero50024_SkillListener:BindingWithSkill_4(skill)
    self.skill_4 = skill
end

--- @return void
--- @param enemy BaseHero
--- @param totalDamage number
function Hero50024_SkillListener:OnTakeSkillDamageFromEnemy(enemy, totalDamage)
    if self.skill_4 ~= nil then
        self.skill_4:OnTakeSkillDamageFromEnemy(enemy, totalDamage)
    end
end