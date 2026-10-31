--- @class Hero40020_SkillListener Lith
Hero40020_SkillListener = Class(Hero40020_SkillListener, SkillListener)

function Hero40020_SkillListener:Ctor(hero)
    SkillListener.Ctor(self, hero)

    ---@type BaseSkill
    self.skill_3 = nil
end

--- @return void
--- @param skill BaseSkill
function Hero40020_SkillListener:BindingWithSkill_3(skill)
    self.skill_3 = skill
end

--- @return void
--- @param enemyTarget BaseHero
--- @param totalDamage number
function Hero40020_SkillListener:OnDealSkillDamageToEnemy(enemyTarget, totalDamage)
    if self.skill_3 ~= nil then
        self.skill_3:OnDealSkillDamageToEnemy(enemyTarget, totalDamage)
    end
end
