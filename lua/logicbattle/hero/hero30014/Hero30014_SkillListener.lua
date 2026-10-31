--- @class Hero30014_SkillListener
Hero30014_SkillListener = Class(Hero30014_SkillListener, SkillListener)

--- @return void
--- @param hero BaseHero
function Hero30014_SkillListener:Ctor(hero)
    SkillListener.Ctor(self, hero)

    --- @type BaseSkill
    self.skill_2 = nil
    --- @type BaseSkill
    self.skill_4 = nil
end

--- @return number
--- @param skill BaseSkill
function Hero30014_SkillListener:BindingWithSkill_2(skill)
    self.skill_2 = skill
end

--- @return number
--- @param skill BaseSkill
function Hero30014_SkillListener:BindingWithSkill_4(skill)
    self.skill_4 = skill
end

--- @return void
--- @param enemy BaseHero
--- @param totalDamage number
function Hero30014_SkillListener:OnTakeSkillDamageFromEnemy(enemy, totalDamage)
    if self.skill_2 ~= nil then
        self.skill_2:OnTakeSkillDamageFromEnemy(enemy, totalDamage)
    end

    if self.skill_4 ~= nil then
        self.skill_4:OnTakeSkillDamageFromEnemy(enemy, totalDamage)
    end
end
