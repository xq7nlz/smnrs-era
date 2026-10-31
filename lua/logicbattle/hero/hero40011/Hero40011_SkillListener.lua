--- @class Hero40011_SkillListener Yome
Hero40011_SkillListener = Class(Hero40011_SkillListener, SkillListener)

function Hero40011_SkillListener:Ctor(hero)
    SkillListener.Ctor(self, hero)

    ---@type BaseSkill
    self.skill_2 = nil
end

--- @return void
--- @param skill BaseSkill
function Hero40011_SkillListener:BindingWithSkill_2(skill)
    self.skill_2 = skill
end

--- @return void
--- @param enemy BaseHero
--- @param totalDamage number
function Hero40011_SkillListener:OnTakeSkillDamageFromEnemy(enemy, totalDamage)
    if self.skill_2 ~= nil then
        self.skill_2:OnTakeSkillDamageFromEnemy(enemy, totalDamage)
    end
end
