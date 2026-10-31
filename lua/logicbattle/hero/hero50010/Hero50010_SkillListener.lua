--- @class Hero50010_SkillListener Sephion
Hero50010_SkillListener = Class(Hero50010_SkillListener, SkillListener)

function Hero50010_SkillListener:Ctor(hero)
    SkillListener.Ctor(self, hero)

    ---@type BaseSkill
    self.skill_2 = nil
end

--- @return void
--- @param skill BaseSkill
function Hero50010_SkillListener:BindingWithSkill_2(skill)
    self.skill_2 = skill
end

--- @return void
--- @param enemy BaseHero
--- @param totalDamage number
function Hero50010_SkillListener:OnTakeSkillDamageFromEnemy(enemy, totalDamage)
    if self.skill_2 ~= nil then
         self.skill_2:OnTakeSkillDamageFromEnemy(enemy, totalDamage)
    end
end
