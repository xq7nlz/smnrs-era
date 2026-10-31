--- @class Hero60004_SkillListener Karos
Hero60004_SkillListener = Class(Hero60004_SkillListener, SkillListener)

function Hero60004_SkillListener:Ctor(hero)
    SkillListener.Ctor(self, hero)

    ---@type BaseSkill
    self.skill_2 = nil
end

--- @return void
--- @param skill BaseSkill
function Hero60004_SkillListener:BindingWithSkill_2(skill)
    self.skill_2 = skill
end

----------------------------------------------Battle-----------------------------------------
--- @return void
--- @param enemyTarget BaseHero
--- @param totalDamage number
function Hero60004_SkillListener:OnDealSkillDamageToEnemy(enemyTarget, totalDamage)
    if self.skill_2 ~= nil then
        self.skill_2:OnDealSkillDamageToEnemy(enemyTarget, totalDamage)
    end
end