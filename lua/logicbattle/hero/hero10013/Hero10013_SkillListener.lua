--- @class Hero10013_SkillListener Oceanee
Hero10013_SkillListener = Class(Hero10013_SkillListener, SkillListener)

function Hero10013_SkillListener:Ctor(hero)
    SkillListener.Ctor(self, hero)

    ---@type BaseSkill
    self.skill_4 = nil
end

--- @return void
--- @param skill BaseSkill
function Hero10013_SkillListener:BindingWithSkill_4(skill)
    self.skill_4 = skill
end

--- @return void
--- @param enemyAttacker BaseHero
--- @param totalDamage number
function Hero10013_SkillListener:OnTakeCritDamage(enemyAttacker, totalDamage)
    if self.skill_4 ~= nil then
        self.skill_4:OnTakeCritDamage(enemyAttacker, totalDamage)
    end
end