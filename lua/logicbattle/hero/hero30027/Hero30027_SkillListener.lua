--- @class Hero30027_SkillListener Vlad
Hero30027_SkillListener = Class(Hero30027_SkillListener, SkillListener)

function Hero30027_SkillListener:Ctor(hero)
    SkillListener.Ctor(self, hero)

    ---@type BaseSkill
    self.skill_1 = nil

    ---@type BaseSkill
    self.skill_2 = nil
end

--- @return void
--- @param skill BaseSkill
function Hero30027_SkillListener:BindingWithSkill_1(skill)
    self.skill_1 = skill
end

--- @return void
--- @param skill BaseSkill
function Hero30027_SkillListener:BindingWithSkill_2(skill)
    self.skill_2 = skill
end

--- @return void
--- @param enemyTarget BaseHero
--- @param totalDamage number
function Hero30027_SkillListener:OnDealSkillDamageToEnemy(enemyTarget, totalDamage)
    if self.skill_1 ~= nil then
        self.skill_1:OnDealSkillDamageToEnemy(enemyTarget, totalDamage)
    end

    if self.skill_2 ~= nil then
        self.skill_2:OnDealSkillDamageToEnemy(enemyTarget, totalDamage)
    end
end