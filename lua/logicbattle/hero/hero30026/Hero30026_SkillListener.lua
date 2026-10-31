--- @class Hero30026_SkillListener Vlad
Hero30026_SkillListener = Class(Hero30026_SkillListener, SkillListener)

function Hero30026_SkillListener:Ctor(hero)
    SkillListener.Ctor(self, hero)

    ---@type BaseSkill
    self.skill_2 = nil
end

--- @return void
--- @param skill BaseSkill
function Hero30026_SkillListener:BindingWithSkill_1(skill)
    self.skill_2 = skill
end

--- @return void
--- @param enemyTarget BaseHero
--- @param totalDamage number
function Hero30026_SkillListener:OnDealSkillDamageToEnemy(enemyTarget, totalDamage)
    if self.skill_2 ~= nil then
        self.skill_2:OnDealSkillDamageToEnemy(enemyTarget, totalDamage)
    end
end