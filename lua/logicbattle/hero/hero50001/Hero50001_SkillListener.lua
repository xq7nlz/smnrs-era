--- @class Hero50001_SkillListener
Hero50001_SkillListener = Class(Hero50001_SkillListener, SkillListener)

--- @return void
--- @param hero BaseHero
function Hero50001_SkillListener:Ctor(hero)
    SkillListener.Ctor(self, hero)

    --- @type BaseSkill
    self.skill_2 = nil

    --- @type BaseSkill
    self.skill_3 = nil
end

--- @return number
--- @param skill BaseSkill
function Hero50001_SkillListener:BindingWithSkill_2(skill)
    self.skill_2 = skill
end

--- @return number
--- @param skill BaseSkill
function Hero50001_SkillListener:BindingWithSkill_3(skill)
    self.skill_3 = skill
end

--- @return void
--- @param enemyTarget BaseHero
--- @param totalDamage number
function Hero50001_SkillListener:OnDealSkillDamageToEnemy(enemyTarget, totalDamage)
    if self.skill_2 ~= nil then
        self.skill_2:OnDealSkillDamageToEnemy(enemyTarget, totalDamage)
    end
end

--- @return void
--- @param enemy BaseHero
--- @param totalDamage number
function Hero50001_SkillListener:OnTakeSkillDamageFromEnemy(enemy, totalDamage)
    if self.skill_3 ~= nil then
        self.skill_3:OnTakeSkillDamageFromEnemy(enemy, totalDamage)
    end
end
