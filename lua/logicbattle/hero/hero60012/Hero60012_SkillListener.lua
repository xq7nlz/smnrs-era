--- @class Hero60012_SkillListener
Hero60012_SkillListener = Class(Hero60012_SkillListener, SkillListener)

--- @return void
--- @param hero BaseHero
function Hero60012_SkillListener:Ctor(hero)
    SkillListener.Ctor(self, hero)

    ---@type BaseSkill
    self.skill_2 = nil
    ---@type BaseSkill
    self.skill_3 = nil
end

--- @return void
--- @param skill BaseSkill
function Hero60012_SkillListener:BindingWithSkill_2(skill)
    self.skill_2 = skill
end

--- @return void
--- @param skill BaseSkill
function Hero60012_SkillListener:BindingWithSkill_3(skill)
    self.skill_3 = skill
end


--- @return void
--- @param enemy BaseHero
--- @param totalDamage number
function Hero60012_SkillListener:OnTakeSkillDamageFromEnemy(enemy, totalDamage)
    if self.skill_2 ~= nil then
        self.skill_2:OnTakeSkillDamageFromEnemy(enemy, totalDamage)
    end
end

--- @return void
--- @param enemyTarget BaseHero
--- @param totalDamage number
function Hero60012_SkillListener:OnDealCritDamage(enemyTarget, totalDamage)
    if self.skill_3 ~= nil then
        self.skill_3:OnDealCritDamage(enemyTarget, totalDamage)
    end
end