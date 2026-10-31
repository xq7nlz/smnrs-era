--- @class Hero50006_SkillListener Enule
Hero50006_SkillListener = Class(Hero50006_SkillListener, SkillListener)

function Hero50006_SkillListener:Ctor(hero)
    SkillListener.Ctor(self, hero)

    --- @type BaseSkill
    self.skill_4 = nil
end

--- @return void
--- @param skill BaseSkill
function Hero50006_SkillListener:BindingWithSkill_4(skill)
    self.skill_4 = skill
end
---------------------------------------------------Battle-----------------------------------------
--- @return void
--- @param enemyTarget BaseHero
--- @param totalDamage number
function Hero50006_SkillListener:OnDealSkillDamageToEnemy(enemyTarget, totalDamage)
    if self.skill_4 ~= nil then
        self.skill_4:OnDealSkillDamageToEnemy(enemyTarget, totalDamage)
    end
end