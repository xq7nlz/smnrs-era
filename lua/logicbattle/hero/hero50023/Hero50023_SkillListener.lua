--- @class Hero50023_SkillListener Dancer
Hero50023_SkillListener = Class(Hero50023_SkillListener, SkillListener)

function Hero50023_SkillListener:Ctor(hero)
    SkillListener.Ctor(self, hero)

    ---@type BaseSkill
    self.skill_4 = nil
end

--- @return void
--- @param skill BaseSkill
function Hero50023_SkillListener:BindingWithSkill_4(skill)
    self.skill_4 = skill
end

--- @return void
--- @param enemyTarget BaseHero
--- @param totalDamage number
function Hero50023_SkillListener:OnDealSkillDamageToEnemy(enemyTarget, totalDamage)
    if self.skill_4 ~= nil then
        self.skill_4:OnDealSkillDamageToEnemy(enemyTarget, totalDamage)
    end
end